package nz.mwh.wg.ast;

import java.util.List;

import nz.mwh.wg.Visitor;

public class ExplicitRequest extends ASTNode {
    ASTNode receiver;
    List<? extends Part> parts;
    public String location;

    public ExplicitRequest(String location, ASTNode receiver, Cons<? extends Part> parts) {
        this.receiver = receiver;
        this.parts = parts.toList();
        this.location = location;
    }
    
    public <T> T accept(T context, Visitor<T> visitor) {
        return visitor.visit(context, this);
    }

    public String toString() {
        return "dotReq(" + receiver + ", " + Cons.stringFromList(parts) + ")";
    }

    public ASTNode getReceiver() {
        return receiver;
    }

    public List<? extends Part> getParts() {
        return parts;
    }
}
