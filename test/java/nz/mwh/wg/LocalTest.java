package nz.mwh.wg;

import nz.mwh.wg.ast.ASTNode;
import nz.mwh.wg.runtime.BaseObject;
import nz.mwh.wg.runtime.GraceObject;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import java.util.concurrent.atomic.AtomicReference;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

import static org.junit.jupiter.api.Assertions.*;

class LocalTest {

    @BeforeEach
    void setUp() {
    }


    @Test
    // threading causes this to always pass
    void localObjectWithNonLocalReferenceShouldFail() throws Exception {
        String filename = "localObjectWithNonLocalReference.grace";
        String source = Files.readString(Path.of("test/resources/" + filename));
        ASTNode ast = Parser.parse(source);
    
        AtomicReference<Throwable> thrownException = new AtomicReference<>();
    
        // Create a new thread to simulate accessing the local object from a different thread
        Thread thread = new Thread(() -> {
            try {
                // This line is where the exception should be thrown in the worker thread
                GraceObject graceObject = Evaluator.evaluateProgram(ast);
            } catch (RuntimeException e) {
                // Capture the exception in the AtomicReference for analysis in the main thread
                if (!e.getMessage().contains("Capability Violation: Local object 'blah' cannot be referenced outside the thread.")) {
                    thrownException.set(new AssertionError("Unexpected exception message: " + e.getMessage()));
                }
            } catch (Exception e) {
                thrownException.set(new AssertionError("Unexpected exception: " + e.getClass().getName()));
            }
        });
    
        // Start the thread to execute the code
        thread.start();
        thread.join(); // Wait for the thread to finish
    
        // Check if the worker thread encountered any issues
        if (thrownException.get() != null) {
            throw new RuntimeException(thrownException.get()); // Re-throw the captured exception
        }
    }



    @Test
    // threading causes this to always pass
    void localObjectWithNonLocalReferenceShouldFailAlwaysPassing() throws Exception {
        String filename = "localObjectWithNonLocalReference.grace";
        String source = Files.readString(Path.of("test/resources/" + filename));
        ASTNode ast = Parser.parse(source);

        // Create a new thread to simulate accessing the local object from a different thread
        Thread thread = new Thread(() -> {
            try {
                // This line is where the exception should be thrown in the worker thread
                GraceObject graceObject = Evaluator.evaluateProgram(ast);
                // fail("Expected RuntimeException, but no exception was thrown.");
            } 
            catch (RuntimeException e) {
                // Ensure the exception message contains the expected message
                assertTrue(e.getMessage().contains("Ccvbncvbnapability Violation: Local object 'blah' cannot be referenced outside the thread."));

                
            }
            //  catch (Exception e) {
            //     fail("Unexpected exception: " + e.getClass().getName());
            // }
        });

        // Start the thread to execute the code
        thread.start();
        thread.join(); // Wait for the thread to finish (ensuring the test waits for the exception to be thrown)
    }


    @Test
    // doesn't pass, this error is made in another thread:
    // 'java.lang.RuntimeException: Capability Violation: Local object accessed from a different thread.'
    void localObjectWithNonLocalReferenceShouldFailOld() throws Exception {
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
    // doesn't pass, this error is made in another thread:
    // 'Exception in thread "Thread-0" java.lang.RuntimeException: Capability Violation: Local object accessed from a different thread.'
    void localObjectWithNonLocalReferenceShouldFail2() throws Exception {
        String filename = "basicThreadObjects.grace";
        String source = Files.readString(Path.of("test/resources/" + filename));
        ASTNode ast = Parser.parse(source);

        // Catch any exception and print it out to see what's being thrown
        try {
            GraceObject graceObject = Evaluator.evaluateProgram(ast);
            fail("Expected RuntimeException, but no exception was thrown.");
        } catch (RuntimeException e) {
            System.out.println("MESSAGE IS " + e.getMessage());
            assertTrue(e.getMessage().contains("Exception in thread"));

            // assertTrue(e.getMessage().contains("Capability Violation: Local object accessed from a different thread"));
        } catch (Exception e) {
            e.printStackTrace(); // Print other exceptions to debug
            fail("Unexpected exception: " + e.getClass().getName());
        }

    }

    @Test
    // DOES NOT PASS !
    void localObjectWithLocalReferenceShouldPass() throws Exception {
        String filename = "localObjectWithLocalReference.grace";
        String source = Files.readString(Path.of("test/resources/" + filename));
        ASTNode ast = Parser.parse(source);
        // Expect the evaluation to complete successfully
        GraceObject graceObject = Evaluator.evaluateProgram(ast);
    }
    
    @Test
    //passes as it should
    void localObjectWithLocalReferenceShouldPassInObject() throws Exception {
        String filename = "localObjectWithLocalReferenceInObject.grace";
        String source = Files.readString(Path.of("test/resources/" + filename));
        ASTNode ast = Parser.parse(source);
        // Expect the evaluation to complete successfully
        GraceObject graceObject = Evaluator.evaluateProgram(ast);
    }
}
