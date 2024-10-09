package nz.mwh.wg.ast;

import java.util.List;

import nz.mwh.wg.Visitor;

public class VarDecl extends ASTNode {
    String name;
    ASTNode type;
    List<String> annotations;
    ASTNode value;

    public VarDecl(String name, ASTNode type, Cons<String> annotations, Cons<ASTNode> value) {
        this.name = name;
        this.type = type;
        this.annotations = annotations.toList();
        this.value = value.getHead();
    }

    public <T> T accept(T context, Visitor<T> visitor) {
        return visitor.visit(context, this);
    }

    public String toString() {
        return "varDec(\"" + name + "\", " + Cons.fromValue(type) + ", " + Cons.stringFromList(annotations) + ", " + Cons.fromValue(value) + ")";
    }

    public String getName() {
        return name;
    }

    public List<String> getAnnotations() {
        return annotations;
    }

    public ASTNode getValue() {
        return value;
    }
}
