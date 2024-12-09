package nz.mwh.wg.runtime;

import java.util.List;
import java.util.concurrent.*; // For threading and Future

import nz.mwh.wg.ast.*;

public class GraceBlock implements GraceObject {
    private GraceObject lexicalParent;
    private List<ASTNode> parameters;
    private List<ASTNode> body;

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
            // System.out.println("Setting parameter: " + name + " with value: " + part.getArgs().get(i));

            blockContext.setField(name, part.getArgs().get(i)); 
        }

        for (

        ASTNode stmt : body) {
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

            // Create two ports
            Port<GraceObject> port1 = channel.createPort1();
            Port<GraceObject> port2 = channel.createPort2();

            // Pass port2 to the worker thread
            Thread workerThread = new Thread(() -> {
                try {
                    GraceObject last = null;
                    for (ASTNode node : body) {
                        last = node.accept(blockContext, request.getVisitor());

                        // last = node.accept(new BaseObject(lexicalParent), request.getVisitor());
                    }
                    port2.send(last); // Send result to port1
                } catch (InterruptedException e) {
                    throw new RuntimeException("Worker thread interrupted.", e);
                }
            });

            workerThread.start();

            try {
                // Main thread receives result from port1
                return port1.receive();
            } catch (InterruptedException e) {
                throw new RuntimeException("Main thread interrupted while waiting for result.", e);
            }
        } else {
            // Non-threaded execution
            GraceObject last = null;
            for (ASTNode node : body) {
                last = node.accept(blockContext, request.getVisitor());
            }
            return last; // Return the result of the last executed statement

        }
    }

    // Stub method to find the receiver object by name. Unimplemented
    @Override
    public GraceObject findReceiver(String name) {
        throw new RuntimeException("No such method in scope: " + name);
    }
}
