#!/bin/bash

files=(../java/nz/mwh/wg/{Evaluator,Visitor,ASTConstructors}.java ../java/nz/mwh/wg/{ast,runtime}/*.java)

{
    grep -hE '^import' "${files[@]}" | grep -v 'nz.mwh.wg' | sort -u
    cat <<'EOT'

public class Runner {
    public static void main(String[] args) {
        Evaluator.evaluateProgram(TheProgram.program);
    }
}
EOT
    for f in "${files[@]}"
    do
        grep -vE '^package|^import' "$f" | sed -e 's/public class/class/' -e 's/public abstract class/abstract class/' -e 's/public interface/interface/' -e 's/Parser.parse.*/null; if (true) {throw new RuntimeException("no imports in standalone programs");}/'
    done
} > flat-template.java
