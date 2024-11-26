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

    @Override
    public GraceObject request(Request request) {
        if (request.parts.size() == 1) {
            if (request.parts.get(0).getName().equals("apply")) {
                return apply(request, request.parts.get(0));
            }
        }
        throw new RuntimeException("No such method in Block(" + parameters.size() + "): " + request.getName());
    }

    private GraceObject apply(Request request, RequestPartR part) {
        BaseObject blockContext = new BaseObject(lexicalParent);

        // setting up the block parameters
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

        // Thread thread = new Thread(() -> System.out.println("hi from java thread"));
        // thread.start();
        // try {
        //     thread.join(); // Wait for the thread to finish
        // } catch (InterruptedException e) {
        //     throw new RuntimeException("Thread was interrupted", e);
        // }

        for (ASTNode stmt : body) {
            if (stmt instanceof DefDecl) {
                DefDecl def = (DefDecl) stmt;
                blockContext.addField(def.getName());
            } else if (stmt instanceof VarDecl) {
                VarDecl var = (VarDecl) stmt;
                blockContext.addField(var.getName());
                Thread dummy = null;
                blockContext.addFieldWriter(var.getName(), dummy);
            }
        }

        // Execute the block body
        GraceObject last = null;
        for (ASTNode node : body) {
            last = node.accept(blockContext, request.getVisitor());
        }
        return last; // Return the final result of the block

    }

    @Override
    public GraceObject findReceiver(String name) {
        throw new RuntimeException("No such method in scope: " + name);
    }
}
