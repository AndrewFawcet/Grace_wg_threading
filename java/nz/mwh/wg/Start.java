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

        // String filename = "test/DataRaceEtc/bankAmbientTalk2.grace"; // dala AmbientTalk bank test working (psuedo encapsulation?)
        // String filename = "test/DataRaceEtc/dalaHashmap1.grace"; // dala hashmap test working
        // String filename = "test/DataRaceEtc/dalaHashmap2.grace"; // dala hashmap test working
        // String filename = "test/DataRaceEtc/dalaHashmap3.grace"; // dala hashmap test working
        // String filename = "test/DataRaceEtc/dalaActiveObjects1.grace"; // dala NOT working
        // String filename = "test/DataRaceEtc/dalaActiveObjects2.grace"; // dala NOT working
        // String filename = "basicBasic3.grace"; // dala basics working
        // String filename = "test/DataRaceEtc/dalaHashmap4.grace"; // dala hashmap test working
        // String filename = "test/DataRaceEtc/bankAmbientTalk.grace"; // dala hashmap test working
        // String filename = "test/DataRaceEtc/dalaLinkedList2WithIso.grace"; // dala hashmap test working
        // String filename = "test/DataRaceEtc/dalaLinkedList3WithIso.grace"; // dala hashmap test working
        // String filename = "test/DataRaceEtc/dalaLinkedList4WithIso.grace"; // dala hashmap test working
        // String filename = "test/DataRaceEtc/dalaLinkedList5WithIso.grace"; // dala hashmap test working
        // String filename = "hash1.grace"; // basic printhash working
        // String filename = "hash2.grace"; // basic hash working
        // String filename = "hash3.grace"; // basic hash and % modulus working
        // String filename = "array.grace"; // basic hash and % modulus working
        // String filename = "array2.grace"; // basic hash and % modulus working
        // String filename = "array3.grace"; // basic hash and % modulus working
        // String filename = "array4.grace"; // basic hash and % modulus working
        // String filename = "hash4.grace"; // basic hash not working
        // String filename = "hash5.grace"; // basic hash working
        // String filename = "hash6.grace"; // basic hash working
        // String filename = "hash7.grace"; // basic hash working
        // String filename = "hash8.grace"; // encapsulated basic hash not working
        String filename = "hash9.grace"; // encapsulated basic hash working using iso linked lists.



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
