package nz.mwh.wg;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

import nz.mwh.wg.ast.ASTNode;
import nz.mwh.wg.ast.Cons;
import nz.mwh.wg.ast.DefDecl;
import nz.mwh.wg.ast.ImportStmt;
import nz.mwh.wg.ast.ObjectConstructor;

public class Start {
    public static void main(String[] args) {
        //testing :)
        // args = new String[]{
        //     "-u",
        //     "java/nz/mwh/wg/parserData.java",
        //     "parser.grace"
        // };

        // String filename = "test/workingTests/dalaDestructive.grace"; // dala destructive read working
        // String filename = "test/workingTests/dalaLimitationsTest1.grace"; // dala limitation test working
        // String filename = "test/workingTests/dalaLimitationsTest2.grace"; // dala limitation test working
        // String filename = "test/workingTests/dalaLinkedList1.grace"; // dala L list  working
        // String filename = "test/workingTests/dalaLinkedList2.grace"; // dala L list  working
        // String filename = "test/workingTests/dalaAliasingObject1.grace"; // dala Aliasing example working will fail if spouse set in iso object
        // String filename = "test/workingTests/dalaAliasingObject2.grace"; // dala Aliasing example working will pass if spouse set in object
        // String filename = "test/workingTests/isoTest.grace"; // iso Test working
        // String filename = "test/workingTests/localTest.grace"; // loc Test working
        // String filename = "test/workingTests/bankDistantObjects.grace"; // dala dist bank working
        // String filename = "test/workingTests/bank.grace"; // dala bank working
        // String filename = "test/workingTests/bankAmbientTalk.grace"; // dala AmbientTalk bank test working (psuedo encapsulation?)
        // String filename = "test/workingTests/linkedListWithIso1.grace"; // dala AmbientTalk bank test working (psuedo encapsulation?)
        // String filename = "test/workingTests/linkedListWithIso2.grace"; // dala AmbientTalk bank test working (psuedo encapsulation?)
        // String filename = "test/workingTests/square.grace"; // encapsulated basic hash working using iso linked lists.not
        // String filename = "test/workingTests/aliasingDisallowed.grace"; // encapsulated basic hash working using iso linked lists.not

        // String filename = "test/DataRaceEtc/twoEventLoops.grace"; // two event loops.not
        // String filename = "test/DataRaceEtc/counter.grace"; // two event loops.not
        // String filename = "test/DataRaceEtc/counter2.grace"; // two event loops.not
        // String filename = "test/DataRaceEtc/BST1.grace"; // BST.not
        // String filename = "test/DataRaceEtc/BST2.grace"; // BST.not
        // String filename = "test/DataRaceEtc/BST3.grace"; // BST ok

        // String filename = "test/hashtables/hashtable1.grace"; // hashtable ok -vanilla
        // String filename = "test/hashtables/hashtable1a.grace"; // hashtable ok -vanilla with at_put_ syntax
        // String filename = "test/hashtables/hashtable2.grace"; // hashtable ok -local
        // String filename = "test/hashtables/hashtable2a.grace"; // hashtable ok -local with at_put_ syntax
        // String filename = "test/hashtables/hashtable3.grace"; // hashtable not -need to remove linked list nodes
        // String filename = "test/hashtables/hashtable3a.grace"; // hashtable ok - removes linked list nodes
        // String filename = "test/hashtables/hashtable3b.grace"; // hashtable ok - removes linked list nodes
        // String filename = "test/hashtables/hashtable3c.grace"; // hashtable ok - removes linked list nodes including iso objects as values
        // String filename = "test/hashtables/hashtable4.grace"; // hashtable ok -simple destructive reads of values in hashtable

        // String filename = "test/DataRaceEtc/dereferencingIsoChecks1.grace"; // basic dereferencing iso checks, all ok
        // String filename = "test/DataRaceEtc/dereferencingIsoChecks2.grace"; // basic dereferencing iso checks, all ok

        // String filename = "test/DataRaceEtc/bankAmbientTalk2.grace"; // dala AmbientTalk bank test working (psuedo encapsulation?)
        boolean printAST = false;
        String updateFile = null;
        boolean inlineImports = false;
        for (String arg : args) {
            if (arg.equals("-p")) {
                printAST = true;
            } else if (arg.equals("-u")) {
                updateFile = "";
            } else if (updateFile != null && updateFile.isEmpty()) {
                updateFile = arg; // first find the update file
            } else if (arg.equals("-i")) {
                inlineImports = true;
            } else {
                filename = arg;
                break;
            }
        }
        try {
            String source = Files.readString(Path.of(filename));
            ASTNode ast = Parser.parse(source);
            if (inlineImports) {
                inlineImports((ObjectConstructor) ast);
            }
            if (printAST) {
                System.out.println(ast);
            } else if (updateFile != null) {
                updateFile(ast, updateFile);
            } else {
                Evaluator.evaluateProgram(ast);
            }
        } catch (IOException e) {
            throw new RuntimeException("Error reading file: " + filename, e);
        }
    }

    private static void inlineImports(ObjectConstructor ast) throws IOException {
        List<ASTNode> body = ast.getBody();
        for (int i = 0; i < body.size(); i++) {
            ASTNode node = body.get(i);
            if (node instanceof ImportStmt) {
                ImportStmt importStmt = (ImportStmt) node;
                String filename = importStmt.getSource() + ".grace";
                String source = Files.readString(Path.of(filename));
                ObjectConstructor imported = (ObjectConstructor) Parser.parse(source);
                inlineImports(imported);
                DefDecl def = new DefDecl(importStmt.getName(), null, Cons.nil(), imported);
                body.set(i, def);
            }
        }
    }

    private static void updateFile(ASTNode ast, String filename) {
        try {
            List<String> source = Files.readAllLines(Path.of(filename));
            List<String> newSource = new ArrayList<>();
            Pattern pattern = Pattern.compile("^(|.*\\s)program\\s*=");
            System.out.println(pattern);
            boolean foundMatch = false;
            for (String line : source) {
                if (pattern.matcher(line).lookingAt()) {
                    int pos = line.indexOf("program");
                    String newLine = line.substring(0, pos + 7) + " = " + ast.toString()
                            + (line.endsWith(";") ? ";" : "");
                    newSource.add(newLine);
                    System.out.println("Found program line");
                    foundMatch = true;
                } else {
                    newSource.add(line);
                }
            }
            if (!foundMatch) {
                throw new RuntimeException("No program line found in file: " + filename);
            }
            Files.writeString(Path.of(filename), String.join("\n", newSource));
        } catch (IOException e) {
            // throw new RuntimeException("Error writing file: " + filename, e);
            throw new RuntimeException("Error writing file: " + filename, e);
        }
    }
}
