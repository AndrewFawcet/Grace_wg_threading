package nz.mwh.wg.runtime;

import java.util.List;
import java.util.concurrent.*; // For threading and Future

import javax.sound.sampled.Port;

import nz.mwh.wg.ast.*;

// This class represents a block of code with parameters and a body that can be invoked directly or in a separate thread.
// The GraceBlock class models a functional block within the Grace language runtime, capturing lexical scope, parameters, and a sequence of statements, and supports execution either synchronously or asynchronously through the use of a Channel to enable threading and communication between execution contexts.
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
                // threading
                System.out.println("beginning threading");

                
                
                GraceObject response = spawn(request);

                return response;
            }

        }
        throw new RuntimeException("No such method in Block(" + parameters.size() + "): " + request.getName());
    }

    private GraceObject spawn(Request request) {

        DuplexChannel<Request, GraceObject> channel = new DuplexChannel<>(10);
        GracePort<Request, GraceObject> portMain = channel.createPort1(); // Main thread's port
        GracePort<GraceObject, Request> portWorker = channel.createPort2(); // Main thread's port

        // Spawn the thread
        Thread workerThread = new Thread(() -> {
            try {
                System.out.println("Worker thread started.");
                Request incomingRequest = portWorker.receive(); // Wait for request
                // Execute the block and send the result back
                GraceObject result = apply( incomingRequest, incomingRequest.parts.get(0), true);
                portWorker.send(result); // Send response
            } catch (InterruptedException e) {
                throw new RuntimeException("Worker thread interrupted.", e);
            }
        });

        workerThread.start();

        // Send the request and receive the response
        try {
            portMain.send(request); // Send request to the worker
            GraceObject response = portMain.receive(); // Wait for response from worker
            System.out.println("Main thread received response: " + response);
            return response; // Return the response to the caller
        } catch (InterruptedException e) {
            throw new RuntimeException("Error in communication between threads.", e);
        }
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

            GraceObject last = null;
            for (ASTNode node : body) {
                last = node.accept(blockContext, request.getVisitor());
            }
            return last; // Return the result of the last executed statement

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
