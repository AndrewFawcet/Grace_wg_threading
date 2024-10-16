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

class IsolatedAndImmutableTest {

    @BeforeEach
    void setUp() {
    }

    @Test
    void isolatedAndImmutableObjectShouldFail() throws Exception {
        String filename = "isolatedAndImmutableTest.grace"; 
        String source = Files.readString(Path.of(filename));
        ASTNode ast = Parser.parse(source);
        // Expect a RuntimeException when immutability is violated
        RuntimeException thrown = assertThrows(RuntimeException.class, () -> {
            GraceObject graceObject = Evaluator.evaluateProgram(ast);
        });

        assertEquals("Violation: Object 'zzzObject' cannot have both capabilities 'isolated' and 'immutable' assigned.",
        thrown.getMessage());
    }

    @Test
    void immutableAndIsolatedObjectShouldFail() throws Exception {
        String filename = "immutableAndIsolatedTest.grace"; 
        String source = Files.readString(Path.of(filename));
        ASTNode ast = Parser.parse(source);
        // Expect a RuntimeException when immutability is violated
        RuntimeException thrown = assertThrows(RuntimeException.class, () -> {
            GraceObject graceObject = Evaluator.evaluateProgram(ast);
        });

        assertEquals("Violation: Object 'zzzObject' cannot have both capabilities 'isolated' and 'immutable' assigned.",
        thrown.getMessage());
    }


}
