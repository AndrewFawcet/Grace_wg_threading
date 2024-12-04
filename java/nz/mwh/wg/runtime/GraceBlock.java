package nz.mwh.wg.runtime;

import java.util.List;
import java.util.concurrent.*; // For threading and Future

import nz.mwh.wg.ast.*;

public class GraceBlock implements GraceObject {
    private GraceObject lexicalParent;
    private List<ASTNode> parameters;
    private List<ASTNode> body;
    private boolean isThreaded = false;
    // private MyBlockingQueue<Object> queue = new MyBlockingQueue<>(1); // Blocking
    // queue for thread communication

    // public GraceBlock(GraceObject lexicalParent, List<ASTNode> parameters,
    // List<ASTNode> body) {
    // this.lexicalParent = lexicalParent;
    // this.parameters = parameters;
    // this.body = body;
    // }

    // overload for threaded
    public GraceBlock(GraceObject lexicalParent, List<ASTNode> parameters, List<ASTNode> body, Boolean isThreaded) {
        this.lexicalParent = lexicalParent;
        this.parameters = parameters;
        this.body = body;
        this.isThreaded = isThreaded;
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
        MyBlockingQueue<GraceObject> queue = new MyBlockingQueue<>(1); // Blocking queue with capacity 1

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
        System.out.println("before thread started");

        // if (isThreaded) {
        if (apply_thread) {
            System.out.println("just before thread started !!!");

            // Create a thread to execute the block body
            Thread workerThread = new Thread(() -> {
                System.out.println("thread started");
                try {
                    GraceObject last = null;
                    for (ASTNode node : body) {
                        last = node.accept(blockContext, request.getVisitor());
                    }
                    queue.put(last); // Put the result into the queue
                } catch (InterruptedException e) {
                    throw new RuntimeException("Thread interrupted while executing block.", e);
                }
            });

            workerThread.start(); // Start the worker thread

            try {
                // Take the result from the queue (blocking until available)
                return queue.take();
            } catch (InterruptedException e) {
                throw new RuntimeException("Interrupted while waiting for block result.", e);
            }
        } else {

            // creates a new execution context (blockContext)
            // sets up block parameters and fields from the parameters and body.
            // executtes the statements in the block's body and returns the result of the
            // last statement.

            // Execute the block body
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
