package nz.mwh.wg;

import nz.mwh.wg.ast.ASTNode;
import nz.mwh.wg.runtime.BaseObject;
import nz.mwh.wg.runtime.GraceObject;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

import static org.junit.jupiter.api.Assertions.*;

class LocalTest {

    @BeforeEach
    void setUp() {
    }

    @Test
    void localObjectWithNonLocalReferenceShouldFail() throws Exception {
        String filename = "localObjectWithNonLocalReference.grace"; 
        String source = Files.readString(Path.of("test/resources/" + filename));
        ASTNode ast = Parser.parse(source);
        // Expect a RuntimeException when immutability is violated
        RuntimeException thrown = assertThrows(RuntimeException.class, () -> {
            GraceObject graceObject = Evaluator.evaluateProgram(ast);
        });

        assertEquals("Capability Violation: Local object 'blah' cannot be referenced outside the thread.",
        thrown.getMessage());
    }

    @Test
    void localObjectWithNonLocalReferenceShouldPass() throws Exception {
        String filename = "localObjectWithLocalReference.grace"; 
        String source = Files.readString(Path.of("test/resources/" + filename));
        ASTNode ast = Parser.parse(source);
        // Expect the evaluation to complete successfully
        GraceObject graceObject = Evaluator.evaluateProgram(ast);
    }
}
