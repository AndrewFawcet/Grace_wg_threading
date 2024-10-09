package nz.mwh.wg.ast;

import nz.mwh.wg.Visitor;

public class ReturnStmt extends ASTNode {
    ASTNode value;

    public ReturnStmt(ASTNode value) {
        this.value = value;
    }
    
    public <T> T accept(T context, Visitor<T> visitor) {
        return visitor.visit(context, this);
    }

    public String toString() {
        return "returnStmt(" + value + ")";
    }

    public ASTNode getValue() {
        return value;
    }
}
