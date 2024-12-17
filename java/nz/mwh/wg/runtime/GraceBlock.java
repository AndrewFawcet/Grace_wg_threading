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

        if (apply_thread) {
            System.out.println("Setting up threading with channels...");

            // Create a channel with capacity 1 (proof of concept)
            Channel<GraceObject> channel = new Channel<>(1);

            Port<GraceObject> resultPort = spawn(channel, () -> {
                try {
                    GraceObject last = null;
                    for (ASTNode node : body) {
                        last = node.accept(blockContext, request.getVisitor()); // more intermediate results could get sent to main thread
                    }
                    channel.createPort2().send(last); // Send the result to the main thread
                } catch (InterruptedException e) {
                    throw new RuntimeException("Worker thread interrupted.", e);
                }
            });
            return new GraceChannelWrapper(resultPort);

        } else {
            // Non-threaded execution
            GraceObject last = null;
            for (ASTNode node : body) {
                last = node.accept(blockContext, request.getVisitor());
            }
            return last; // Return the result of the last executed statement

        }
    }

    private Port<GraceObject> spawn(Channel<GraceObject> channel, Runnable task) {
        Port<GraceObject> port1 = channel.createPort1(); // Main thread's end
        Port<GraceObject> port2 = channel.createPort2(); // Worker thread's end

        Thread workerThread = new Thread(() -> {
            task.run();
            try {
                port2.close(); // completion
            } catch (Exception e) {
                throw new RuntimeException("Error closing port in thread.", e);
            }
        });
        workerThread.start();

        return port1; // Return the main thread's end
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
