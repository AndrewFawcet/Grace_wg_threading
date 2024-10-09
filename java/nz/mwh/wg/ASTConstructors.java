package nz.mwh.wg;

import nz.mwh.wg.ast.ASTNode;
import nz.mwh.wg.ast.Assign;
import nz.mwh.wg.ast.Block;
import nz.mwh.wg.ast.Cons;
import nz.mwh.wg.ast.Comment;
import nz.mwh.wg.ast.DefDecl;
import nz.mwh.wg.ast.ExplicitRequest;
import nz.mwh.wg.ast.IdentifierDeclaration;
import nz.mwh.wg.ast.ImportStmt;
import nz.mwh.wg.ast.InterpString;
import nz.mwh.wg.ast.LexicalRequest;
import nz.mwh.wg.ast.MethodDecl;
import nz.mwh.wg.ast.NumberNode;
import nz.mwh.wg.ast.ObjectConstructor;
import nz.mwh.wg.ast.Part;
import nz.mwh.wg.ast.ReturnStmt;
import nz.mwh.wg.ast.StringNode;
import nz.mwh.wg.ast.VarDecl;

public class ASTConstructors {
    static <T> Cons<T> cons(T head, Cons<T> tail) {
        return new Cons<>(head, tail);
    }

    static <T> Cons<T> at(int line, T head, Cons<T> tail) {
        return new Cons<>(head, tail);
    }

    static <T> Cons<T> one(T head) {
        return new Cons<>(head, Cons.nil());
    }

    @SuppressWarnings("rawtypes")
    static Cons nil = new Cons();

    @SuppressWarnings("rawtypes")
    static Cons no = nil;

    static ObjectConstructor objectConstructor(Cons<ASTNode> body, Cons<String> annotations) {
        return new ObjectConstructor(body, annotations);
    }

    static ObjectConstructor objCons(Cons<ASTNode> body, Cons<String> annotations) {
        return new ObjectConstructor(body, annotations);
    }

    static LexicalRequest lexicalRequest(Cons<Part> parts) {
        return new LexicalRequest(parts);
    }

    static LexicalRequest lexReq(Cons<Part> parts) {
        return new LexicalRequest(parts);
    }

    static Part requestPart(String name, Cons<ASTNode> args) {
        return new Part(name, args);
    }

    static Part part(String name, Cons<ASTNode> args) {
        return new Part(name, args);
    }

    static NumberNode numberNode(double value) {
        return new NumberNode(value);
    }

    static NumberNode numLit(double value) {
        return new NumberNode(value);
    }

    static StringNode stringNode(String value) {
        return new StringNode(value);
    }

    static StringNode strLit(String value) {
        return new StringNode(value);
    }

    static InterpString interpStr(String value, ASTNode expr, ASTNode next) {
        return new InterpString(value, expr, next);
    }

    static IdentifierDeclaration identifierDeclaration(String name, Cons<ASTNode> type) {
        return new IdentifierDeclaration(name, type.isNil() ? null : type.getHead());
    }

    static DefDecl defDecl(String name, Cons<ASTNode> type, Cons<String> annotations, ASTNode value) {
        return new DefDecl(name, type.isNil() ? null : type.getHead(), annotations, value);
    }
    
    static DefDecl defDec(String name, Cons<ASTNode> type, Cons<String> annotations, ASTNode value) {
        return new DefDecl(name, type.isNil() ? null : type.getHead(), annotations, value);
    }

    static VarDecl varDecl(String name, Cons<ASTNode> type, Cons<String> annotations, Cons<ASTNode> value) {
        return new VarDecl(name, type.isNil() ? null : type.getHead(), annotations, value);
    }

    static VarDecl varDec(String name, Cons<ASTNode> type, Cons<String> annotations, Cons<ASTNode> value) {
        return new VarDecl(name, type.isNil() ? null : type.getHead(), annotations, value);
    }

    static MethodDecl methodDecl(Cons<Part> parts, Cons<ASTNode> type, Cons<String> annotations, Cons<ASTNode> body) {
        return new MethodDecl(parts, type.isNil() ? null : type.getHead(), annotations, body);
    }

    static MethodDecl methDec(Cons<Part> parts, Cons<ASTNode> type, Cons<String> annotations, Cons<ASTNode> body) {
        return new MethodDecl(parts, type.isNil() ? null : type.getHead(), annotations, body);
    }

    static Part declarationPart(String name, Cons<IdentifierDeclaration> parameters) {
        return new Part(name, parameters);
    }

    static ExplicitRequest explicitRequest(ASTNode receiver, Cons<Part> parts) {
        return new ExplicitRequest("<unknown>", receiver, parts);
    }
    
    static ExplicitRequest dotReq(ASTNode receiver, Cons<Part> parts) {
        return new ExplicitRequest("<unknown>", receiver, parts);
    }

    static ExplicitRequest explicitRequest(String location, ASTNode receiver, Cons<Part> parts) {
        return new ExplicitRequest(location, receiver, parts);
    }

    static Assign assign(ASTNode target, ASTNode value) {
        return new Assign(target, value);
    }
    
    static Assign assn(ASTNode target, ASTNode value) {
        return new Assign(target, value);
    }

    static Block block(Cons<ASTNode> parameters, Cons<ASTNode> body) {
        return new Block(parameters, body);
    }

    static ReturnStmt returnStmt(ASTNode value) {
        return new ReturnStmt(value);
    }

    protected static Comment comment(String value) {
        return new Comment(value);
    }

    protected static ImportStmt importStmt(String source, IdentifierDeclaration binding) {
        return new ImportStmt(source, binding);
    }

    protected static final String charDollar = "$";
    protected static final String charBackslash = "\\";
    protected static final String charDQuote = "\"";
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
