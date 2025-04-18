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

class IsolatedTest {

    @BeforeEach
    void setUp() {
    }

    @Test
    void isolatedObjectMultipleReferenceShouldFail() throws Exception {
        String filename = "isolatedTestMultipleReference.grace"; 
        String source = Files.readString(Path.of("test/resources/" + filename));
        ASTNode ast = Parser.parse(source);
        // Expect a RuntimeException when immutability is violated
        RuntimeException thrown = assertThrows(RuntimeException.class, () -> {
            GraceObject graceObject = Evaluator.evaluateProgram(ast);
        });
        
        assertEquals("Cannot invoke \"nz.mwh.wg.runtime.GraceObject.request(nz.mwh.wg.runtime.Request)\" because \"receiver\" is null",
        thrown.getMessage());
        // assertEquals("Capability Violation: Isolated object 'objectY' cannot have more than one reference.",
        // thrown.getMessage());
    }

    @Test
    void isolatedObjectNestedMultipleReferenceShouldFail() throws Exception {
        String filename = "isolatedTestNestedMultipleReference.grace"; 
        String source = Files.readString(Path.of("test/resources/" + filename));
        ASTNode ast = Parser.parse(source);
        // Expect a RuntimeException when immutability is violated
        RuntimeException thrown = assertThrows(RuntimeException.class, () -> {
            GraceObject graceObject = Evaluator.evaluateProgram(ast);
        });

        assertEquals("Cannot invoke \"nz.mwh.wg.runtime.GraceObject.request(nz.mwh.wg.runtime.Request)\" because \"receiver\" is null",
        thrown.getMessage());
        // assertEquals("Capability Violation: Isolated object 'objectY' cannot have more than one reference.",
        // thrown.getMessage());
    }

    //TODO does not fail as it should??
    @Test
    void isolatedObjectNestedMultipleReferenceShouldFail2() throws Exception {
        String filename = "isolatedTestNestedMultipleReference2.grace"; 
        String source = Files.readString(Path.of("test/resources/" + filename));
        ASTNode ast = Parser.parse(source);
        // Expect a RuntimeException when immutability is violated
        RuntimeException thrown = assertThrows(RuntimeException.class, () -> {
            GraceObject graceObject = Evaluator.evaluateProgram(ast);
        });

        assertEquals("Cannot invoke \"nz.mwh.wg.runtime.GraceObject.request(nz.mwh.wg.runtime.Request)\" because \"receiver\" is null",
        thrown.getMessage());
        // assertEquals("Capability Violation: Isolated object 'objectY' cannot have more than one reference.",
        // thrown.getMessage());
    }
    
    //TODO does not fail as it should??
    @Test
    void isolatedObjectNestedMultipleReferenceShouldFail3() throws Exception {
        String filename = "isolatedTestNestedMultipleReference3.grace"; 
        String source = Files.readString(Path.of("test/resources/" + filename));
        ASTNode ast = Parser.parse(source);
        // Expect a RuntimeException when immutability is violated
        RuntimeException thrown = assertThrows(RuntimeException.class, () -> {
            GraceObject graceObject = Evaluator.evaluateProgram(ast);
        });

        assertEquals("Cannot invoke \"nz.mwh.wg.runtime.GraceObject.request(nz.mwh.wg.runtime.Request)\" because \"receiver\" is null",
        thrown.getMessage());
        // assertEquals("Capability Violation: Isolated object 'objectY' cannot have more than one reference.",
        // thrown.getMessage());
    }

}
