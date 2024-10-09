package nz.mwh.wg.ast.grace;

import nz.mwh.wg.ast.ASTNode;
import nz.mwh.wg.runtime.GraceObject;
import nz.mwh.wg.runtime.Request;

public class DefDecl extends nz.mwh.wg.ast.DefDecl implements GraceObject {
    
    public DefDecl(String name, ASTNode type, Cons<String> annotations, ASTNode value) {
        super(name, type, annotations, value);
    }

    public GraceObject request(Request request) {
        throw new RuntimeException("Cannot request method on ASTNode: " + request.getName());
    }

    public GraceObject findReceiver(String name) {
        throw new RuntimeException("No such method in scope: " + name);
    }

}
