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

class IsolatedOrImmutableAndUnsafeTest {

    @BeforeEach
    void setUp() {
    }

    @Test
    void isolatedWithUnsafeObjectShouldFail() throws Exception {
        String filename = "isolatedWithUnsafeTest.grace"; 
        String source = Files.readString(Path.of(filename));
        ASTNode ast = Parser.parse(source);
        // Expect a RuntimeException when immutability is violated
        RuntimeException thrown = assertThrows(RuntimeException.class, () -> {
            GraceObject graceObject = Evaluator.evaluateProgram(ast);
        });

        assertEquals("Capability Violation: An 'isolated' object cannot reference a (base) object without the 'isolated' or 'immutable' capability.",
        thrown.getMessage());
    }


    @Test
    void isolatedWithNestedUnsafeObjectShouldFail() throws Exception {
        String filename = "isolatedWithNestedUnsafeTest.grace"; 
        String source = Files.readString(Path.of(filename));
        ASTNode ast = Parser.parse(source);
        // Expect a RuntimeException when immutability is violated
        RuntimeException thrown = assertThrows(RuntimeException.class, () -> {
            GraceObject graceObject = Evaluator.evaluateProgram(ast);
        });

        assertEquals("Capability Violation: An 'isolated' object cannot reference a (base) object without the 'isolated' or 'immutable' capability.",
        thrown.getMessage());
    }

    @Test
    void immutableWithUnsafeObjectShouldFail() throws Exception {
        String filename = "immutableWithUnsafeTest.grace"; 
        String source = Files.readString(Path.of(filename));
        ASTNode ast = Parser.parse(source);
        // Expect a RuntimeException when immutability is violated
        RuntimeException thrown = assertThrows(RuntimeException.class, () -> {
            GraceObject graceObject = Evaluator.evaluateProgram(ast);
        });

        assertEquals("Capability Violation: An 'immutable' object cannot reference a (base) object without the 'immutable' capability.",
        thrown.getMessage());
    }


    @Test
    void immutableWithNestedUnsafeObjectShouldFail() throws Exception {
        String filename = "immutableWithNestedUnsafeTest.grace"; 
        String source = Files.readString(Path.of(filename));
        ASTNode ast = Parser.parse(source);
        // Expect a RuntimeException when immutability is violated
        RuntimeException thrown = assertThrows(RuntimeException.class, () -> {
            GraceObject graceObject = Evaluator.evaluateProgram(ast);
        });

        assertEquals("Capability Violation: An 'immutable' object cannot reference a (base) object without the 'immutable' capability.",
        thrown.getMessage());
    }

    @Test
    void isolatedWithImmutableWithUnsafeObjectShouldFail() throws Exception {
        String filename = "isolatedWithImmutableWithUnsafeTest.grace"; 
        String source = Files.readString(Path.of(filename));
        ASTNode ast = Parser.parse(source);
        // Expect a RuntimeException when immutability is violated
        RuntimeException thrown = assertThrows(RuntimeException.class, () -> {
            GraceObject graceObject = Evaluator.evaluateProgram(ast);
        });

        assertEquals("Capability Violation: An 'immutable' object cannot reference a (base) object without the 'immutable' capability.",
        thrown.getMessage());
    }

}
