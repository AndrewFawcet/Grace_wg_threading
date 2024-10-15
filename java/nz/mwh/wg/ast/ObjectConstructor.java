package nz.mwh.wg.ast;

import java.util.List;

import nz.mwh.wg.Visitor;

public class ObjectConstructor extends ASTNode {
    List<ASTNode> body;
    List<String> annotations;
    private boolean isIsolated;


    public ObjectConstructor(Cons<ASTNode> body, Cons<String> annotations) {
        this.body = body.toList();
        this.annotations = annotations.toList();
        this.isIsolated = annotations.toString().contains("isolated");  //not sure about this bit, is it necessary?
    }

    public <T> T accept(T context, Visitor<T> visitor) {
        return visitor.visit(context, this);
    }

    public String toString() {
        return "objCons(" + Cons.stringFromList(body) + ", " + Cons.stringFromList(annotations) + ")";
    }

    public List<ASTNode> getBody() {
        return body;
    }

    public List<String> getAnnotations() {
        return annotations;
    }

    public boolean isIsolated() {
        return this.isIsolated;
    }
}