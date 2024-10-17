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

class ImmutabilityTest {

    @BeforeEach
    void setUp() {
    }

    @Test
    void immutabilityTestMutateField() throws Exception {
        String filename = "immutabilityTestMutateField.grace";
        String source = Files.readString(Path.of(filename));
        ASTNode ast = Parser.parse(source);
        // Expect a RuntimeException when immutability is violated
        RuntimeException thrown = assertThrows(RuntimeException.class, () -> {
            GraceObject graceObject = Evaluator.evaluateProgram(ast);
        });

        // Optionally, you can verify that the exception message matches what you expect
        assertEquals("Capability Violation: Immutable object, cannot mutate 'immutable' object field 'fieldX'.",
                thrown.getMessage());
    }

    @Test
    void nestedImmutabilityTest() throws Exception {
        String filename = "immutabilityTestNestedImmutability.grace";
        String source = Files.readString(Path.of(filename));
        ASTNode ast = Parser.parse(source);

        // Expecting RuntimeException for a different immutability test case
        RuntimeException thrown = assertThrows(RuntimeException.class, () -> {
            GraceObject graceObject = Evaluator.evaluateProgram(ast);
        });

        // Optionally, verify the exception message or behavior
        assertEquals("Capability Violation: Immutable object, cannot mutate 'immutable' object field 'fieldX'.", thrown.getMessage());
    }

    @Test
    void multiNestedImmutabilityTest() throws Exception {
        String filename = "immutabilityTestMultiNestedImmutability.grace";
        String source = Files.readString(Path.of(filename));
        ASTNode ast = Parser.parse(source);

        // Expecting RuntimeException for a different immutability test case
        RuntimeException thrown = assertThrows(RuntimeException.class, () -> {
            GraceObject graceObject = Evaluator.evaluateProgram(ast);
        });

        // Optionally, verify the exception message or behavior
        assertEquals("Capability Violation: Immutable object, cannot mutate 'immutable' object field 'fieldX'.", thrown.getMessage());
    }

    @Test
    void nestedImmutabilityAssignedToDifferentContextTest() throws Exception {
        String filename = "immutabilityTestNestedImmutabilityAssignedToDifferentContext.grace";
        String source = Files.readString(Path.of(filename));
        ASTNode ast = Parser.parse(source);

        // Expecting RuntimeException for a different immutability test case
        RuntimeException thrown = assertThrows(RuntimeException.class, () -> {
            GraceObject graceObject = Evaluator.evaluateProgram(ast);
        });

        // Optionally, verify the exception message or behavior
        assertEquals("Capability Violation: Immutable object, cannot mutate 'immutable' object field 'cannotChangeMeField'.", thrown.getMessage());
    }

}
