package nz.mwh.wg.ast.grace;

import nz.mwh.wg.runtime.GraceObject;
import nz.mwh.wg.runtime.Request;

public class StringNode extends nz.mwh.wg.ast.StringNode implements GraceObject {
    
    public StringNode(String value) {
        super(value);
    }

    public GraceObject request(Request request) {
        throw new RuntimeException("Cannot request method on ASTNode: " + request.getName());
    }

    public GraceObject findReceiver(String name) {
        throw new RuntimeException("No such method in scope: " + name);
    }

}
