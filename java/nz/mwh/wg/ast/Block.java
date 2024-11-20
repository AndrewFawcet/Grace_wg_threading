package nz.mwh.wg.ast;

import java.util.List;

import nz.mwh.wg.Visitor;

public class Block extends ASTNode {
    List<ASTNode> parameters;
    List<ASTNode> body;
    private boolean isThreaded;

    public Block(Cons<ASTNode> parameters, Cons<ASTNode> body, boolean isThreaded) {
        this.parameters = parameters.toList();
        this.body = body.toList();
        this.isThreaded = isThreaded;
    }

    // Constructor without isThreaded, defaults to false
    public Block(Cons<ASTNode> parameters, Cons<ASTNode> body) {
        this(parameters, body, false); // Call the other constructor
    }

    public <T> T accept(T context, Visitor<T> visitor) {
        return visitor.visit(context, this);
    }

    public String toString() {
        return "block(" + Cons.stringFromList(parameters) + ", " + Cons.stringFromList(body) + ")";
    }

    public List<ASTNode> getParameters() {
        return parameters;
    }

    public List<ASTNode> getBody() {
        return body;
    }

    public boolean isThreaded() {
        return isThreaded;
    }
}
