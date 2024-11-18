package nz.mwh.wg.ast;

import java.util.List;

import nz.mwh.wg.Visitor;

public class ObjectConstructor extends ASTNode {
    List<ASTNode> body;
    List<String> annotations;
    private boolean isLocal;
    private boolean isIsolated;
    private boolean isImmutable;

    public ObjectConstructor(Cons<ASTNode> body, Cons<String> annotations) {
        this.body = body.toList();
        this.annotations = annotations.toList();
        this.isLocal = annotations.toString().contains("local123456");
        this.isIsolated = annotations.toString().contains("isolated");
        this.isImmutable = annotations.toString().contains("immutable");
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

    public boolean isLocal() {
        return this.isLocal;
    }

    public boolean isIsolated() {
        return this.isIsolated;
    }
    
    public boolean isImmutable() {
        return this.isImmutable;
    }
}