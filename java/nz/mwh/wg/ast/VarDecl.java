package nz.mwh.wg.ast;

import java.util.List;

import nz.mwh.wg.Visitor;

//represents a variable declaration in the syntax tree of a program. It stores the following information about a variable:
// Name: The variable's identifier (e.g., x or objectY).
// Type: The data type of the variable (e.g., int, String).
// Annotations: Additional metadata about the variable (e.g., @local, @immutable).
// Value: The initial value assigned to the variable (if any).
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

    // this is needed to get the value(s) for an existing object, byt referring to the reference of the object.
    public ASTNode getValue() {
        return value;
    }
}
