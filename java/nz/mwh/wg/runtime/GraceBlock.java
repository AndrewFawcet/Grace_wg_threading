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
            Channel<GraceObject> channel = new Channel<>(10);

            GracePort<GraceObject> portMain = channel.createPort1(); // Main thread's port
            GracePort<GraceObject> portWorker = channel.createPort2(); // Worker thread's port

            // Use the spawn method to pass the worker port and return the main port
            GracePort<GraceObject> resultPort = spawn(portWorker, () -> {
                try {
                    GraceObject last = null;
                    for (ASTNode node : body) {
                        System.out.println("Worker processing node: " + node);
                        last = node.accept(blockContext, request.getVisitor());
                    }
                    System.out.println("Worker sending result: " + last);
                    portWorker.put(last); // Send the result back to the main thread
                } catch (InterruptedException e) {
                    throw new RuntimeException("Worker thread interrupted.", e);
                }
            });

            // Main thread waits for the result
            try {
                GraceObject result = resultPort.take(); // Receive the result
                return result; // Return the result to the caller
            } catch (InterruptedException e) {
                throw new RuntimeException("Main thread communication error.", e);
            }

            // GracePort<GraceObject> mainGracePort = spawn(portForWorker, () -> {
            // try {
            // GraceObject last = null;
            // for (ASTNode node : body) {
            // last = node.accept(blockContext, request.getVisitor());
            // }
            // fromWorker.put(last); // Send the result to the main thread
            // } catch (InterruptedException e) {
            // throw new RuntimeException("Worker thread interrupted.", e);
            // }
            // });
            // // return new GraceChannelWrapper(fromWorker.take());
            // return mainGracePort;

            // Spawn a worker thread
            // Thread workerThread = new Thread(() -> {
            // try {

            // // Worker thread listens for tasks and sends results back
            // while (true) {
            // GraceObject task = toWorker.take(); // Receive a task from the main thread
            // if (task == null) {
            // break; // Exit on null (signifies end of communication)
            // }

            // System.out.println("Worker received task: " + task);
            // GraceObject last = null;
            // // Process the task (e.g., execute AST nodes)
            // for (ASTNode node : body) {
            // last = node.accept(blockContext, request.getVisitor());
            // }

            // fromWorker.put(last); // Send the result back to the main thread
            // }
            // } catch (InterruptedException e) {
            // throw new RuntimeException("Worker thread interrupted.", e);
            // }
            // });
            // workerThread.start();

            // // Send a task to the worker thread
            // try {
            // // toWorker.put(new GraceObject() {}); // Placeholder object; replace with
            // actual task logic if needed
            // GraceObject result = fromWorker.take(); // Wait for result
            // toWorker.put(null); // Send termination signal
            // workerThread.join(); // Ensure clean thread termination
            // return result;
            // } catch (InterruptedException e) {
            // throw new RuntimeException("Thread communication error.", e);
            // }

        } else

        {
            // Non-threaded execution
            GraceObject last = null;
            for (ASTNode node : body) {
                System.out.println("-------------------------------" + node.toString());
                last = node.accept(blockContext, request.getVisitor());
            }
            return last; // Return the result of the last executed statement

        }
    }

    private <T> GracePort<T> spawn(GracePort<T> workerPort, Runnable task) {
        Thread workerThread = new Thread(task);
        workerThread.start(); // Start the worker thread
        return workerPort;    // Return the other end of the channel to the caller
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
