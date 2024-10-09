package nz.mwh.wg.ast.grace;

import nz.mwh.wg.ast.ASTNode;
import nz.mwh.wg.runtime.GraceObject;
import nz.mwh.wg.runtime.Request;

public class MethodDecl extends nz.mwh.wg.ast.MethodDecl implements GraceObject {

    public MethodDecl(Cons<Part> parts, ASTNode type, Cons<String> annotations, Cons<ASTNode> body) {
        super(parts, type, annotations, body);
    }

    public GraceObject request(Request request) {
        throw new RuntimeException("Cannot request method on ASTNode: " + request.getName());
    }

    public GraceObject findReceiver(String name) {
        throw new RuntimeException("No such method in scope: " + name);
    }

}
