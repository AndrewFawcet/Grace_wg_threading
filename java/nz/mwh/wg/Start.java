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
        // String filename = "blockTestThreading.grace";
        // String filename = "blockTest.grace";
        // String filename = "blockTest1.grace"; // ok
        // String filename = "blockTest2.grace"; // ok
        // String filename = "blockTest3.grace"; // ok
        // String filename = "blockTest4.grace"; // ok
        // String filename = "blockTest5.grace"; // ok
        // String filename = "blockTest6.grace"; // ok
        // String filename = "blockTest7.grace"; // ok
        // String filename = "blockTest8.grace"; // ok
        // String filename = "blockTest9.grace"; // ok
        // String filename = "blockTest10.grace"; //
        // String filename = "blockTest11.grace"; //
        // String filename = "blockTest12.grace"; //
        // String filename = "blockTest13.grace"; //
        // String filename = "blockTest14.grace"; //
        // String filename = "blockTest15.grace"; //
        // String filename = "blockTest16.grace"; //
        String filename = "blockTest17ok.grace"; //
        // String filename = "blockTest18.grace"; //
        // String filename = "BasicThreadObjects2.grace";
        // String filename = "BasicThreadObjectsSafe.grace";

        boolean printAST = false;
        String updateFile = null;
        boolean inlineImports = false;
        for (String arg : args) {
            if (arg.equals("-p")) {
                printAST = true;
            } else if (arg.equals("-u")) {
                updateFile = "";
            } else if (updateFile != null && updateFile.isEmpty()) {
                updateFile = arg;
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
            throw new RuntimeException("Error reading file: " + filename);
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
            throw new RuntimeException("Error writing file: " + filename);
        }
    }
}
