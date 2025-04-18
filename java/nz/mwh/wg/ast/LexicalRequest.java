package nz.mwh.wg.ast;

import java.util.List;

import nz.mwh.wg.Visitor;

// Represents a request for a variable or method call in the current lexical scope.
// encapsulated in a structured format to be used as a visitor.
public class LexicalRequest extends ASTNode {
    List<? extends Part> parts;

    public LexicalRequest(Cons<? extends Part> parts) {
        this.parts = parts.toList();
    }

    public <T> T accept(T context, Visitor<T> visitor) {
        return visitor.visit(context, this);
    }

    public String toString() {
        return "lexReq(" + Cons.stringFromList(parts) + ")";
    }

    public List<? extends Part> getParts() {
        return parts;
    }
}