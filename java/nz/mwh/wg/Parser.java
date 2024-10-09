package nz.mwh.wg;
import java.util.Collections;

import nz.mwh.wg.ast.*;
import nz.mwh.wg.runtime.GraceObject;
import nz.mwh.wg.runtime.GraceString;
import nz.mwh.wg.runtime.Request;
import nz.mwh.wg.runtime.RequestPartR;

public class Parser {

    static GraceObject theParser;
    static Evaluator evaluator = new Evaluator();

    public static ASTNode parse(String input) {

        // check if the parser is null
        if (theParser == null) {
            // initializes a custom parser module (theParser) if it has not been initialized yet.
            // binds an ast module to provide necessary helper functions for AST manipulation.
            evaluator.bindModule("ast", GraceASTHelps.astModule(false));
            theParser = evaluator.evaluateModule(parserAST);
        }
        // evaluates the parser logic from parserAST and invokes the parse method on it, passing the input string.
        // method returns an ASTNode, which represents the parsed structure of the input string, using a combination of custom runtime classes and the Evaluator
        Request request = new Request(new Evaluator(), Collections.singletonList(new RequestPartR("parse", Collections.singletonList(new GraceString(input)))));
        ASTNode ast = (ASTNode)theParser.request(request);
        return ast;
    }

    private static final ObjectConstructor parserAST = (ObjectConstructor) ParserData.program;
}
