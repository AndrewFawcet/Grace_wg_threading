package nz.mwh.wg.runtime;

import java.util.List;
import java.util.concurrent.*; // For threading and Future

import nz.mwh.wg.ast.*;

// This class represents a block of code with parameters and a body that can be invoked directly or in a separate thread.
// The GraceBlock class models a functional block within the Grace language runtime, capturing lexical scope, parameters, and a sequence of statements, and supports execution either synchronously or asynchronously through the use of a Channel to enable threading and communication between execution contexts.
public class GraceBlock implements GraceObject {
    private GraceObject lexicalParent;
    private List<ASTNode> parameters;
    private List<ASTNode> body;

    // Fields for thread communication
    private Port<GraceObject> inPort;
    private Port<GraceObject> outPort;

    public GraceBlock(GraceObject lexicalParent, List<ASTNode> parameters, List<ASTNode> body) {
        this.lexicalParent = lexicalParent;
        this.parameters = parameters;
        this.body = body;

        // Initialize ports (shared across all threads using this block)
        Channel<GraceObject> channel = new Channel<>(1); // Example channel with capacity 1
        this.inPort = channel.createPort1(); // Port for receiving messages (main thread)
        this.outPort = channel.createPort2(); // Port for sending messages (worker thread)
    }

    // handles incoming requests to the block
    @Override
    public GraceObject request(Request request) {
        if (request.parts.size() == 1) {
            if (request.parts.get(0).getName().equals("apply")) {
                return apply(request, request.parts.get(0), false);
            }
            if (request.parts.get(0).getName().equals("apply_thread")) {
                return apply(request, request.parts.get(0), true);
            }

        }
        throw new RuntimeException("No such method in Block(" + parameters.size() + "): " + request.getName());
    }

    private GraceObject apply(Request request, RequestPartR part, boolean apply_thread) {
        BaseObject blockContext = new BaseObject(lexicalParent);

        // Setting up the block parameters
        for (int i = 0; i < parameters.size(); i++) {
            ASTNode parameter = parameters.get(i);
            String name;
            if (parameter instanceof IdentifierDeclaration) {
                name = ((IdentifierDeclaration) parameter).getName();
            } else if (parameter instanceof LexicalRequest) {
                name = ((LexicalRequest) parameter).getParts().get(0).getName();
            } else {
                throw new RuntimeException("Invalid parameter in block: " + parameter);
            }
            blockContext.addField(name);

            blockContext.setField(name, part.getArgs().get(i));
        }

        for (ASTNode stmt : body) {
            if (stmt instanceof DefDecl) {
                DefDecl def = (DefDecl) stmt;
                blockContext.addField(def.getName());
            } else if (stmt instanceof VarDecl) {
                VarDecl var = (VarDecl) stmt;
                blockContext.addField(var.getName());
                blockContext.addFieldWriter(var.getName());
            }
        }

        // Add the `__in__` and `__out__` fields to the block context
        blockContext.addField("__in__");
        blockContext.addField("__out__");

        if (apply_thread) {
            System.out.println("Setting up threading with channels...");

            // Create a channel with capacity 1 (proof of concept)
            Channel<GraceObject> channel = new Channel<>(1);

            // Create two ports
            Port<GraceObject> port1 = channel.createPort1(); // Main thread's end
            Port<GraceObject> port2 = channel.createPort2(); // Worker thread's end

            // Assign ports explicitly for threading
            blockContext.setField("__in__", port2); // Worker thread's incoming port
            blockContext.setField("__out__", port1); // Worker thread's outgoing port

            // Pass port2 to the worker thread
            Thread workerThread = new Thread(() -> {
                try {
                    GraceObject last = null;
                    for (ASTNode node : body) {

                        // i think this needs to have the port2 sent to the other thread
                        // last = node.accept(blockContext, request.getVisitor(), port2); // like this??
                        last = node.accept(blockContext, request.getVisitor(), port2);

                    }
                    // port2.send(last); // Send result to port1 (main thread)
                    outPort.send(last); // Send result to the main thread
                } catch (InterruptedException e) {
                    throw new RuntimeException("Worker thread interrupted.", e);
                }
            });

            workerThread.start();

            // returning this allows the main thread to continue.
            return new GraceChannelWrapper(port1);

            // this forces threads to propogate sequentially
            // try {
            // // Main thread receives result from port1
            // return port1.receive();
            // } catch (InterruptedException e) {
            // throw new RuntimeException("Main thread interrupted while waiting for
            // result.", e);
            // }
        } else {
            // Non-threaded execution
            blockContext.setField("__in__", inPort); // Assign incoming port (not needeed?)
            blockContext.setField("__out__", outPort); // Assign outgoing port (not needeed?)

            GraceObject last = null;
            for (ASTNode node : body) {
                last = node.accept(blockContext, request.getVisitor());
            }
            return last; // Return the result of the last executed statement

        }
    }

    private String getParameterName(ASTNode parameter) {
        if (parameter instanceof IdentifierDeclaration) {
            return ((IdentifierDeclaration) parameter).getName();
        } else if (parameter instanceof LexicalRequest) {
            return ((LexicalRequest) parameter).getParts().get(0).getName();
        }
        throw new RuntimeException("Invalid parameter in block: " + parameter);
    }

    // Stub method to find the receiver object by name. Unimplemented
    @Override
    public GraceObject findReceiver(String name) {
        throw new RuntimeException("No such method in scope: " + name);
    }
}
