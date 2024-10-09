package nz.mwh.wg.ast;

import java.util.List;

import nz.mwh.wg.Visitor;

public class Part extends ASTNode {
    String name;
    List<? extends ASTNode> parameters;

    public Part(String name, Cons<? extends ASTNode> parameters) {
        this.name = name;
        this.parameters = parameters.toList();
    }
    
    public <T> T accept(T context, Visitor<T> visitor) {
        throw new RuntimeException("Cannot visit DeclarationPart");
    }

    public String toString() {
        return "part(\"" + name + "\", " + Cons.stringFromList(parameters) + ")";
    }

    public String getName() {
        return name;
    }

    public List<? extends ASTNode> getParameters() {
        return parameters;
    }

    public List<? extends ASTNode> getArgs() {
        return parameters;
    }

}
