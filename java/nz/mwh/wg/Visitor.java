package nz.mwh.wg;

import nz.mwh.wg.ast.*;

public interface Visitor<T> {
    default T visit(T context, ASTNode node) {
        return node.accept(context, this);
    }
    T visit(T context, ObjectConstructor node);
    T visit(T context, LexicalRequest node);
    //T visit(RequestPart node);
    T visit(T context, NumberNode node);
    T visit(T context, StringNode node);
    T visit(T context, InterpString node);
    //T visit(IdentifierDeclaration node);
    T visit(T context, DefDecl node);
    T visit(T context, VarDecl node);
    T visit(T context, MethodDecl node);
    //T visit(DeclarationPart node);
    T visit(T context, ExplicitRequest node);
    T visit(T context, Assign node);
    T visit(T context, Block node);
    T visit(T context, ReturnStmt node);
    T visit(T context, Comment node);
    T visit(T context, ImportStmt node);
}
