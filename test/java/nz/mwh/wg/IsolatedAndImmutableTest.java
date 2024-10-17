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

        assertEquals("Capability Violation: Object 'objectX' cannot have both capabilities 'isolated' and 'immutable' assigned.",
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

        assertEquals("Capability Violation: Object 'objectX' cannot have both capabilities 'isolated' and 'immutable' assigned.",
        thrown.getMessage());
    }

    @Test
    void immutableWithIsolatedObjectShouldFail() throws Exception {
        String filename = "immutableWithIsolatedTest.grace"; 
        String source = Files.readString(Path.of(filename));
        ASTNode ast = Parser.parse(source);
        // Expect a RuntimeException when immutability is violated
        RuntimeException thrown = assertThrows(RuntimeException.class, () -> {
            GraceObject graceObject = Evaluator.evaluateProgram(ast);
        });

        assertEquals("Capability Violation: An 'immutable' object cannot reference an 'isolated' object.",
        thrown.getMessage());
    }


    @Test
    void immutableWithNestedIsolatedObjectShouldFail() throws Exception {
        String filename = "immutableWithNestedIsolatedTest.grace"; 
        String source = Files.readString(Path.of(filename));
        ASTNode ast = Parser.parse(source);
        // Expect a RuntimeException when immutability is violated
        RuntimeException thrown = assertThrows(RuntimeException.class, () -> {
            GraceObject graceObject = Evaluator.evaluateProgram(ast);
        });

        assertEquals("Capability Violation: An 'immutable' object cannot reference an 'isolated' object.",
        thrown.getMessage());
    }

    @Test
    void isolatedWithNestedImmutableObjectShouldPass() throws Exception {
        String filename = "isolatedWithNestedImmutableTest.grace"; 
        String source = Files.readString(Path.of(filename));
        ASTNode ast = Parser.parse(source);
        // Expect the evaluation to complete successfully
            GraceObject graceObject = Evaluator.evaluateProgram(ast);
    }

    @Test
    void isolatedWithNestedImmutableObjectMutatedShouldFail() throws Exception {
        String filename = "isolatedWithNestedImmutableMutatedTest.grace"; 
        String source = Files.readString(Path.of(filename));
        ASTNode ast = Parser.parse(source);
        // Expect a RuntimeException when immutability is violated
        RuntimeException thrown = assertThrows(RuntimeException.class, () -> {
            GraceObject graceObject = Evaluator.evaluateProgram(ast);
        });

        assertEquals("Capability Violation: Immutable object, cannot mutate 'immutable' object field 'fieldY'.",
        thrown.getMessage());
    }

}
