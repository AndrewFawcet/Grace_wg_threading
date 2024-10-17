package nz.mwh.wg;

import nz.mwh.wg.ast.ASTNode;
import nz.mwh.wg.runtime.BaseObject;
import nz.mwh.wg.runtime.GraceObject;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.lang.reflect.Field;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.HashMap;

import static org.junit.jupiter.api.Assertions.*;

class EvaluatorTest {

    @BeforeEach
    void setUp() {
    }

    @Test
    void referenceIsIncrementedTest() throws Exception {
        String filename = "referenceIncrementTest.grace";
        String source = Files.readString(Path.of(filename));
        ASTNode ast = Parser.parse(source);
        GraceObject graceObject = Evaluator.evaluateProgram(ast);


        // Access the private field 'fields'
        Field field = graceObject.getClass().getDeclaredField("fields");
        // Make it accessible
        field.setAccessible(true);

        @SuppressWarnings("unchecked")
        HashMap<String, BaseObject> fields = (HashMap<String, BaseObject>) field.get(graceObject);

        BaseObject reference1 = fields.get("objectX");
        assertEquals(3, reference1.getReferenceCount());

        String lexicalReference = "varDec(\"reference3\", nil, nil, one(lexReq(one(part(\"reference1\", nil)))))";
    }
}