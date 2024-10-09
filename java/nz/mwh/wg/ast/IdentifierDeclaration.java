package nz.mwh.wg.ast;

import nz.mwh.wg.Visitor;

public class IdentifierDeclaration extends ASTNode {
    private String name;
    private ASTNode type;

    public IdentifierDeclaration(String name, ASTNode type) {
        this.name = name;
        this.type = type;
    }

    public <T> T accept(T context, Visitor<T> visitor) {
        throw new RuntimeException("Cannot visit IdentifierDeclaration");
    }

    public String toString() {
        return "identifierDeclaration(\"" + name + "\", " + Cons.fromValue(type) + ")";
    }

    public String getName() {
        return name;
    }
}
