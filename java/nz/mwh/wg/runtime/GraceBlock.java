package nz.mwh.wg.runtime;

import java.util.List;
import java.util.Map;
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
                return apply(request, request.parts.get(0));
            }
        }
        throw new RuntimeException("No such method in Block(" + parameters.size() + "): " + request.getName());
    }

    private GraceObject apply(Request request, RequestPartR part) {
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
                if (last instanceof BaseObject) {
                    // handles statement level discards
                    ((BaseObject) last).decrementReferenceCount(); // all but the last last is decremented. (TODO should this be a removeNotionalReferences?)
                }
                last = node.accept(blockContext, request.getVisitor());
            }

            // if object being returned is held in the local scope (in fields HashMap) then set the "being returned" flag on it before decrementing method context count
            if (lexicalParent instanceof BaseObject) {
                Map<String, GraceObject> lexicalParentFields = ((BaseObject) lexicalParent).getFields();
                if (lexicalParentFields.containsValue(last)) {
                    ((BaseObject) last).setHasNotionalRef(true);
                }
            }
            ((BaseObject) last).decrementReferenceCount();
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
