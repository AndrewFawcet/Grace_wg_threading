package nz.mwh.wg.ast;

import java.util.List;

import nz.mwh.wg.Visitor;

public class Block extends ASTNode {
    List<ASTNode> parameters;
    List<ASTNode> body;
    boolean isThreaded; // Capability to indicate if the block is threaded

    public Block(Cons<ASTNode> parameters, Cons<ASTNode> body) {
        this.parameters = parameters.toList();
        this.body = body.toList();
        this.isThreaded = false; // Default to not threaded
    }

    // Extra constructor for specifying threaded capability
    public Block(Cons<ASTNode> parameters, Cons<ASTNode> body, Cons<String> annotations) {
        this.parameters = parameters.toList();
        this.body = body.toList();
        this.isThreaded = annotations.toString().contains("threaded");
    }

    // Getter for isThreaded capability
    public boolean isThreaded() {
        if (this.isThreaded){
            System.out.println(" this block is threaded  !!!");
        } else {
            System.out.println(" this block not threaded");
        }
        
        return isThreaded;
    }

    // Setter for isThreaded capability (optional if mutability is needed)
    public void setThreaded(boolean isThreaded) {
        this.isThreaded = isThreaded;
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
