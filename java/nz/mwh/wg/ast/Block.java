package nz.mwh.wg.ast;

import java.util.List;

import nz.mwh.wg.Visitor;

public class Block extends ASTNode {
    List<ASTNode> parameters;
    List<ASTNode> body;

    public Block(Cons<ASTNode> parameters, Cons<ASTNode> body) {
        this.parameters = parameters.toList();
        this.body = body.toList();
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
}
