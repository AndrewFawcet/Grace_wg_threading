package nz.mwh.wg.ast.grace;

import nz.mwh.wg.ast.ASTNode;

public class ASTConstructors {
    protected static <T> Cons<T> cons(T head, Cons<T> tail) {
        return new Cons<>(head, tail);
    }

    protected static <T> Cons<T> one(T head) {
        return new Cons<>(head, Cons.nil());
    }

    @SuppressWarnings("rawtypes")
    protected static Cons nil = new Cons();

    protected static ObjectConstructor objectConstructor(Cons<ASTNode> body, Cons<String> annotations) {
        return new ObjectConstructor(body, annotations);
    }

    protected static LexicalRequest lexicalRequest(Cons<Part> parts) {
        return new LexicalRequest(parts);
    }

    protected static Part requestPart(String name, Cons<ASTNode> args) {
        return new Part(name, args);
    }

    protected static Part part(String name, Cons<ASTNode> args) {
        return new Part(name, args);
    }

    protected static NumberNode numberNode(double value) {
        return new NumberNode(value);
    }

    protected static StringNode stringNode(String value) {
        return new StringNode(value);
    }

    protected static InterpString interpStr(String value, ASTNode expr, ASTNode next) {
        return new InterpString(value, expr, next);
    }

    protected static IdentifierDeclaration identifierDeclaration(String name, Cons<ASTNode> type) {
        return new IdentifierDeclaration(name, type.isNil() ? null : type.getHead());
    }

    protected static DefDecl defDecl(String name, Cons<ASTNode> type, Cons<String> annotations, ASTNode value) {
        return new DefDecl(name, type.isNil() ? null : type.getHead(), annotations, value);
    }

    protected static VarDecl varDecl(String name, Cons<ASTNode> type, Cons<String> annotations, Cons<ASTNode> value) {
        return new VarDecl(name, type.isNil() ? null : type.getHead(), annotations, value);
    }

    protected static MethodDecl methodDecl(Cons<Part> parts, Cons<ASTNode> type, Cons<String> annotations, Cons<ASTNode> body) {
        return new MethodDecl(parts, type.isNil() ? null : type.getHead(), annotations, body);
    }

    protected static Part declarationPart(String name, Cons<IdentifierDeclaration> parameters) {
        return new Part(name, parameters);
    }

    protected static ExplicitRequest explicitRequest(ASTNode receiver, Cons<Part> parts) {
        return new ExplicitRequest("<unknown>", receiver, parts);
    }

    protected static ExplicitRequest explicitRequest(String location, ASTNode receiver, Cons<Part> parts) {
        return new ExplicitRequest(location, receiver, parts);
    }

    protected static Assign assign(ASTNode target, ASTNode value) {
        return new Assign(target, value);
    }

    protected static Block block(Cons<ASTNode> parameters, Cons<ASTNode> body) {
        return new Block(parameters, body);
    }

    protected static ReturnStmt returnStmt(ASTNode value) {
        return new ReturnStmt(value);
    }

    protected static Comment comment(String value) {
        return new Comment(value);
    }

    protected static ImportStmt importStmt(String source, IdentifierDeclaration bnd) {
        return new ImportStmt(source, bnd);
    }

    protected static final String charDollar = "$";
    protected static final String charBacklash = "\\";
    protected static final String charLF = "\n";
    protected static final String charCR = "\r";
    protected static final String charLBrace = "{";
    protected static final String charStar = "*";
    protected static final String charTilde = "~";
    protected static final String charBacktick = "`";
    protected static final String charCaret = "^";
    protected static final String charAt = "@";
    protected static final String charPercent = "%";
    protected static final String charAmp = "&";

    protected static String safeStr(String left, String middle, String right) {
        return left + middle + right;
    }
}
