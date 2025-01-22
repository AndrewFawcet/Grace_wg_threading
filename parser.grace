import "ast" as ast

method EOFToken(line, column) {
    SymbolToken(line, column, "EOF")
}

method NumberToken(ln, col, val) {
    object {
        def nature is public = "NUMBER"
        def value is public = val
        def line is public = ln
        def column is public = col

        method asString {
            nature ++ "(" ++ value ++ ")[" ++ line ++ ":" ++ column ++ "]"
        }
    }
}

method LParenToken(line, column) {
    SymbolToken(line, column, "LPAREN")
}

method RParenToken(line, column) {
    SymbolToken(line, column, "RPAREN")
}

method LBraceToken(line, column) {
    SymbolToken(line, column, "LBRACE")
}

method RBraceToken(ln, col, idx) {
    object {
        def nature is public = "RBRACE"
        def line is public = ln
        def column is public = col
        def index is public = idx

        method asString {
            "RBRACE[" ++ line ++ ":" ++ column ++ "@" ++ index ++ "]"
        }
    }}

method CommaToken(line, column) {
    SymbolToken(line, column, "COMMA")
}

method DotToken(line, column) {
    SymbolToken(line, column, "DOT")
}

method IdentifierToken(ln, col, val) {
    object {
        def nature is public = "IDENTIFIER"
        def value is public = val
        def line is public = ln
        def column is public = col

        method asString {
            nature ++ "(" ++ value ++ ")[" ++ line ++ ":" ++ column ++ "]"
        }
    }
}

method KeywordToken(ln, col, val) {
    object {
        def nature is public = "KEYWORD"
        def value is public = val
        def line is public = ln
        def column is public = col

        method asString {
            nature ++ "(" ++ value ++ ")" ++ "[" ++ line ++ ":" ++ column ++ "]"
        }
    }
}

method OperatorToken(ln, col, val) {
    object {
        def nature is public = "OPERATOR"
        def value is public = val
        def line is public = ln
        def column is public = col

        method asString {
            nature ++ "(" ++ value ++ ")" ++ "[" ++ line ++ ":" ++ column ++ "]"
        }
    }
}

method StringToken(ln, col, val) {
    object {
        def nature is public = "STRING"
        def value is public = val
        def line is public = ln
        def column is public = col

        method asString {
            nature ++ "(" ++ value ++ ")" ++ "[" ++ line ++ ":" ++ column ++ "]"
        }
    }
}

method InterpStringToken(ln, col, val) {
    object {
        def nature is public = "INTERPSTRING"
        def value is public = val
        def line is public = ln
        def column is public = col

        method asString {
            nature ++ "(" ++ value ++ ")" ++ "[" ++ line ++ ":" ++ column ++ "]"
        }
    }
}

method EqualsToken(line, column) {
    SymbolToken(line, column, "EQUALS")
}

method AssignToken(line, column) {
    SymbolToken(line, column, "ASSIGN")
}

method ArrowToken(line, column) {
    SymbolToken(line, column, "ARROW")
}

method SymbolToken(ln, col, nat) {
    object {
        def nature is public = nat
        def line is public = ln
        def column is public = col

        method asString {
            nature ++ "[" ++ line ++ ":" ++ column ++ "]"
        }
    }
}

method NewlineToken(line, column) {
    SymbolToken(line, column, "NEWLINE")
}

method CommentToken(ln, col, text) {
    object {
        def nature is public = "COMMENT"
        def line is public = ln
        def column is public = col
        def value is public = text

        method asString {
            nature ++ "(" ++ value ++ ")[" ++ line ++ ":" ++ column ++ "]"
        }
    }
}

method isOperatorCharacter(c) {
    (c == "+") || (c == "-") || (c == "*") || (c == "/") || (c == "=") || (c == ":") || (c == "|") || (c == "&") || (c == "!") || (c == ">") || (c == "<") || (c == ".")
}

method isIdentifierStart(c) {
    def cp = c.firstCodepoint
    ((cp >= 97) && (cp <= 122)) || ((cp >= 65) && (cp <= 90)) || (cp == 95)
}

method isDigit(c) {
    def cp = c.firstCodepoint
    (cp >= 48) && (cp <= 57)
}

method ErrorToken(ln, col, val) {
    object {
        def nature is public = "ERROR"
        def message is public = val
        def line is public = ln
        def column is public = col

        method asString {
            nature ++ "(" ++ value ++ ")[" ++ line ++ ":" ++ column ++ "]"
        }
    }
}

var indentColumn := 0

method lexer(code) {
    object {
        def source = code
        var index := 1
        var line := 1
        var column := 0
        var lineStart := 0
        var currentToken := nextToken
        var pendingToken := nextToken

        method nextToken {
            if (index > source.size) then {
                return EOFToken(line, column)
            }

            var c := source.at(index)
            column := index - lineStart
            index := index + 1
            

            if (c == " ") then {
                return nextToken
            }

            if (c == "(") then {
                return LParenToken(line, column)
            }

            if (c == ")") then {
                return RParenToken(line, column)
            }

            if ((c > "z") && (c < "|")) then {
                return LBraceToken(line, column)
            }

            if (c == "}") then {
                return RBraceToken(line, column, index)
            }

            if (c == ",") then {
                return CommaToken(line, column)
            }

            if (c.firstCodepoint == 13) then {
                c := source.at(index)
                index := index + 1
            }
            if ((c.firstCodepoint == 10) || (c.firstCodepoint == 8232)) then {
                line := line + 1
                lineStart := index - 1
                return NewlineToken(line, column)
            }

            if (c.firstCodepoint == 34) then {
                return lexString
            }

            if (isDigit(c)) then {
                def startIndex = index - 1
                if (index >= source.size) then {
                    return NumberToken(line, column, c)
                }
                var value := ""
                while {isDigit(c) && (index <= source.size)} do {
                    value := value ++ c
                    c := source.at(index)
                    index := index + 1
                }
                if (c == ".") then {
                    value := value ++ c
                    c := source.at(index)
                    index := index + 1
                    while {isDigit(c) && (index <= source.size)} do {
                        value := value ++ c
                        c := source.at(index)
                        index := index + 1
                    }
                }
                if (index > (startIndex + 1)) then {
                    index := index - 1
                }
                return NumberToken(line, column, value)
            }

            if (isIdentifierStart(c)) then {
                def startIndex = index - 1
                var value := c
                if (index > source.size) then {
                    return IdentifierToken(line, column, value)
                }
                c := source.at(index)
                while {(isIdentifierStart(c) || isDigit(c) || (c == "'")) && (index <= source.size)} do {
                    value := value ++ c
                    index := index + 1
                    if (index <= source.size) then {
                        c := source.at(index)
                    }
                }
                if ((value == "var") || (value == "def") || (value == "method") || (value == "object") || (value == "is") || (value == "return") || (value == "class") || (value == "type") || (value == "import") || (value == "self")) then {
                    return KeywordToken(line, column, value)
                }
                return IdentifierToken(line, column, value)
            }

            if (isOperatorCharacter(c)) then {
                def startIndex = index
                var op := c
                c := source.at(index)
                index := index + 1
                while {isOperatorCharacter(c) && (index <= source.size)} do {
                    op := op ++ c
                    c := source.at(index)
                    index := index + 1
                }
                index := index - 1
                if (op == ":=") then {
                    return AssignToken(line, column)
                }
                if (op == "=") then {
                    return EqualsToken(line, column)
                }
                if (op == "->") then {
                    return ArrowToken(line, column)
                }
                if (op == ".") then {
                    return DotToken(line, column)
                }
                if (op == ":") then {
                    return SymbolToken(line, column, "COLON")
                }
                if (op == "//") then {
                    var cp := c.firstCodepoint
                    var text := ""
                    index := index + 1
                    while { (cp != 10) && (cp != 13) && (index <= source.size) } do {
                        text := text ++ c
                        c := source.at(index)
                        cp := c.firstCodepoint
                        index := index + 1
                    }
                    return CommentToken(line, column, text)
                }
                return OperatorToken(line, column, op)
            }

            if (c == ";") then {
                return SymbolToken(line, column, "SEMICOLON")
            }

            ErrorToken(line, column, "Unknown character: " ++ c.asString ++ "(" ++ c.firstCodepoint.asString ++ ")")
        
        }

        method current {
            currentToken
        }

        method advance {
            currentToken := pendingToken
            pendingToken := nextToken
            if ((currentToken.nature == "NEWLINE") && (pendingToken.column > indentColumn)) then {
                advance
            }
        }

        method lexString {
            var value := ""
            var escaped := false
            while {(source.at(index).firstCodepoint != 34) || escaped} do {
                var escapeNext := false
                def cp = source.at(index).firstCodepoint
                if ((cp == 92) && (escaped == false)) then {
                    escapeNext := true
                } elseif { escaped && (cp == 110) } then {
                    value := value ++ "\n"
                } elseif { escaped && (cp == 114) } then {
                    value := value ++ "\r"
                } else {
                    if ((cp == 123) && (!escaped)) then {
                        // String interpolation
                        index := index + 1
                        return InterpStringToken(line, column, value)
                    } else {
                        value := value ++ source.at(index)
                    }
                }
                escaped := escapeNext
                index := index + 1
            }
            index := index + 1
            return StringToken(line, column, value)
        }

        method startStringAt(pos) {
            index := pos
            currentToken := lexString
            pendingToken := nextToken
        }

        method windback(pos) {
            index := pos
        }

        method expectToken(nature) {
            if (currentToken.nature != nature) then {
                print("Expected " ++ nature ++ " but got " ++ currentToken.nature ++ " at " ++ currentToken.line ++ ":" ++ currentToken.column)
                Exception.raise("Expected " ++ nature ++ " but got " ++ currentToken.nature ++ " at " ++ currentToken.line ++ ":" ++ currentToken.column)
            }
        }

        method expectSymbol(nature) {
            if (currentToken.nature != nature) then {
                print("Expected " ++ nature ++ " but got " ++ currentToken.nature ++ " at " ++ currentToken.line ++ ":" ++ currentToken.column)
                Exception.raise("Expected " ++ nature ++ " but got " ++ currentToken.nature ++ " at " ++ currentToken.line ++ ":" ++ currentToken.column)
            }
        }

        method expectKeyword(val) {
            if (currentToken.nature != "KEYWORD") then {
                print("Expected KEYWORD but got " ++ currentToken.nature ++ " at " ++ currentToken.line ++ ":" ++ currentToken.column)
                Exception.raise("Expected KEYWORD but got " ++ currentToken.nature ++ " at " ++ currentToken.line ++ ":" ++ currentToken.column)
            }
            if (currentToken.value != val) then {
                print("Expected " ++ val ++ " but got " ++ currentToken.value ++ " at " ++ currentToken.line ++ ":" ++ currentToken.column)
                Exception.raise("Expected " ++ val ++ " but got " ++ currentToken.value ++ " at " ++ currentToken.line ++ ":" ++ currentToken.column)
            }
        }
    }
}

method digitToNumber(c) {
    if (c == "1") then {
        return 1
    }
    if (c == "2") then {
        return 2
    }
    if (c == "3") then {
        return 3
    }
    if (c == "4") then {
        return 4
    }
    if (c == "5") then {
        return 5
    }
    if (c == "6") then {
        return 6
    }
    if (c == "7") then {
        return 7
    }
    if (c == "8") then {
        return 8
    }
    if (c == "9") then {
        return 9
    }
    if (c == "0") then {
        return 0
    }
    print("Unexpected digit: " ++ c.asString)
    Exception.raise("Unexpected digit: " ++ c.asString)
}

method parseNumber(lxr) {
    def token = lxr.current
    lxr.advance
    def s = token.value
    var val := 0
    var index := 1
    while { (index <= s.size) } do {
        if (s.at(index) == ".") then {
            index := index + 1
            var frac := 0
            var scale := 1
            while {index <= s.size} do {
                frac := frac * 10 + digitToNumber(s.at(index))
                scale := scale * 10
                index := index + 1
            }
            val := val + (frac / scale)
        } else {
            val := val * 10 + digitToNumber(s.at(index))
        }
        index := index + 1
    }
    ast.numberNode(val)
}

method parseString(lxr) {
    def token = lxr.current
    lxr.advance
    if (token.nature == "INTERPSTRING") then {
        def interpExpr = parseExpression(lxr)
        lxr.expectSymbol("RBRACE")
        lxr.startStringAt(lxr.current.index)
        def nextStr = parseString(lxr)
        ast.interpString(token.value, interpExpr, nextStr)
    } else {
        ast.stringNode(token.value)
    }
}

method parselexicalRequestNoBlock(lxr, id) {
    def parts = parseparts(lxr, false)
    ast.lexicalRequest(parts)
}

method parselexicalRequest(lxr) {
    def parts = parseparts(lxr, true)
    ast.lexicalRequest(parts)
}

method parseparts(lxr, allowBlock) {
    var parts := ast.nil
    while {lxr.current.nature == "IDENTIFIER"} do {
        var id := lxr.current.value
        lxr.advance
        if (lxr.current.nature == "LPAREN") then {
            lxr.advance
            var args := ast.nil
            while {(lxr.current.nature != "RPAREN") && (lxr.current.nature != "EOF")} do {
                args := ast.cons(parseExpression(lxr), args)
                if (lxr.current.nature == "COMMA") then {
                    lxr.advance
                }
            }
            lxr.advance
            def part = ast.part(id, args.reversed(ast.nil))
            parts := ast.cons(part, parts)
        } elseif { allowBlock && (lxr.current.nature == "LBRACE") } then {
            def blk = parseblock(lxr)
            def part = ast.part(id, ast.cons(blk, ast.nil))
            parts := ast.cons(part, parts)
        } elseif { lxr.current.nature == "NUMBER" } then {
            def num = parseNumber(lxr)
            def part = ast.part(id, ast.cons(num, ast.nil))
            parts := ast.cons(part, parts)
        } elseif { (lxr.current.nature == "STRING") || (lxr.current.nature == "INTERPSTRING") } then {
            def str = parseString(lxr)
            def part = ast.part(id, ast.cons(str, ast.nil))
            parts := ast.cons(part, parts)
        } else {
            def part = ast.part(id, ast.nil)
            parts := ast.cons(part, parts)
            return parts.reversed(ast.nil)
        }
    }
    parts.reversed(ast.nil)
}

method parseexplicitRequestNoBlock(receiver, lxr) {
    lxr.advance
    def pos = lxr.current.asString
    def parts = parseparts(lxr, false)
    ast.explicitRequest(pos, receiver, parts)
}

method parseexplicitRequest(receiver, lxr) {
    lxr.advance
    def pos = lxr.current.asString
    def parts = parseparts(lxr, true)
    ast.explicitRequest(pos, receiver, parts)
}

method parseTypeExpression(lxr) {
    def token = lxr.current
    if (token.nature == "IDENTIFIER") then {
        return parselexicalRequestNoBlock(lxr, token.value)
    }
    print("Unexpected token: " ++ token.asString)
    Exception.raise("Unexpected token: " ++ token.asString)
}

method parseExpressionNoOpNoDot(lxr) {
    def token = lxr.current
    if (token.nature == "NUMBER") then {
        return parseNumber(lxr)
    }
    if ((token.nature == "STRING") || (lxr.current.nature == "INTERPSTRING")) then {
        return parseString(lxr)
    }
    if (token.nature == "LPAREN") then {
        lxr.advance
        def expr = parseExpression(lxr)
        lxr.advance
        return expr
    }
    if (token.nature == "LBRACE") then {
        return parseblock(lxr)
    }
    if (token.nature == "IDENTIFIER") then {
        return parselexicalRequest(lxr)
    }
    if (token.nature == "KEYWORD") then {
        if (token.value == "object") then {
            return parseObject(lxr)
        } elseif { token.value == "self" } then {
            lxr.advance
            return ast.lexicalRequest(ast.cons(ast.part("self", ast.nil), ast.nil))
        }
    }
    if (token.nature == "OPERATOR") then {
        lxr.advance
        def pos = lxr.current.asString
        def expr = parseExpressionNoOp(lxr)
        return ast.explicitRequest(pos, expr, ast.cons(ast.part("prefix" ++ token.value, ast.nil), ast.nil))
    }
    print("Unexpected token: " ++ token.asString)
    Exception.raise("Unexpected token: " ++ token.asString)
}

method parseExpressionNoOp(lxr) {
    var left := parseExpressionNoOpNoDot(lxr)
    var token := lxr.current
    while { token.nature == "DOT" } do {
        left := parseexplicitRequest(left, lxr)
        
        token := lxr.current
    }
    return left
}

method parseExpression(lxr) {
    var left := parseExpressionNoOp(lxr)
    var token := lxr.current
    while { token.nature == "OPERATOR" } do {
        def pos = token.asString
        lxr.advance
        def right = parseExpressionNoOp(lxr)
        def args = ast.cons(right, ast.nil)
        def part = ast.part(token.value, args)
        def parts = ast.cons(part, ast.nil)
        def req = ast.explicitRequest(pos, left, parts.reversed(ast.nil))
        left := req
        token := lxr.current
    }
    if (token.nature == "ASSIGN") then {
        lxr.advance
        def right = parseExpression(lxr)
        left := ast.assign(left, right)
    }
    return left
}

method parseReturnStatement(lxr) {
    lxr.advance
    def val = parseExpression(lxr)
    ast.returnStmt(val)
}

method parseStatement(lxr) {
    def token = lxr.current
    if (token.nature == "KEYWORD") then {
        if (token.value == "return") then {
            return parseReturnStatement(lxr)
        }
        if (token.value == "var") then {
            return parsevarDeclaration(lxr)
        }
        if (token.value == "def") then {
            return parsedefDeclaration(lxr)
        }
    } elseif {token.nature == "COMMENT"} then {
        lxr.advance
        return ast.comment(token.value)
    }
    var exp := parseExpression(lxr)
    if (lxr.current.nature == "ASSIGN") then {
        lxr.advance
        def val = parseExpression(lxr)
        exp := ast.assign(exp, val)
    }
    if (lxr.current.nature == "NEWLINE") then {
        lxr.advance
    }
    exp
}

method parseblock(lxr) {
    var params := ast.nil
    var body := ast.nil
    def indentBefore = indentColumn
    if (lxr.current.nature == "LBRACE") then {
        lxr.advance
        while { lxr.current.nature == "NEWLINE" } do {
            lxr.advance
        }
        if (lxr.current.nature != "RBRACE") then {
            def firstTok = lxr.current
            indentColumn := firstTok.column
            def first = parseStatement(lxr)
            def after = lxr.current
            if ((after.nature == "COLON") || (after.nature == "ARROW") || (after.nature == "COMMA")) then {
                // Parameter list
                var prm := first
                var tp := ast.nil
                if (after.nature == "COLON") then {
                    lxr.advance
                    tp := parseTypeExpression(lxr)
                }
                //prm := ast.identifierDeclaration(prm, tp)
                params := ast.cons(prm, params)
                while { (lxr.current.nature != "ARROW") && (lxr.current.nature != "RBRACE") } do {
                    lxr.advance
                    if (lxr.current.nature == "NEWLINE") then {
                        lxr.advance
                    } else {
                        prm := parseExpressionNoOpNoDot(lxr)
                        tp := ast.nil
                        if (lxr.current.nature == "COLON") then {
                            lxr.advance
                            tp := parseTypeExpression(lxr)
                        }
                        //prm := ast.identifierDeclaration(prm, tp)
                        params := ast.cons(prm, params)
                    }
                }
                lxr.expectToken("ARROW")
                lxr.advance
                while { lxr.current.nature == "NEWLINE" } do {
                    lxr.advance
                }
            } else {
                indentColumn := indentBefore
                body := ast.cons(first, body)
            }
        }
        if (lxr.current.nature == "SEMICOLON") then {
            lxr.advance
            lxr.expectToken("NEWLINE")
        }
        while { lxr.current.nature == "NEWLINE" } do {
            lxr.advance
        }
        while {lxr.current.nature != "RBRACE"} do {
            indentColumn := lxr.current.column
            if (indentColumn <= indentBefore) then {
                print("Indentation must increase inside block body. Expected at least column " ++ (indentBefore + 1) ++ " on line " ++ lxr.current.line ++ " but got " ++ indentColumn)
                Exception.raise("Indentation must increase inside block body. Expected at least column " ++ (indentBefore + 1) ++ " on line " ++ lxr.current.line ++ " but got " ++ indentColumn)
            }
            body := ast.cons(parseStatement(lxr), body)
            if (lxr.current.nature == "SEMICOLON") then {
                lxr.advance
                lxr.expectToken("NEWLINE")
            }
            while { lxr.current.nature == "NEWLINE" } do {
                lxr.advance
            }
        }
        lxr.advance
    }
    indentColumn := indentBefore
    ast.block(params.reversed(ast.nil), body.reversed(ast.nil))

}

method parseAnnotations(lxr) {
    var anns := ast.nil
    lxr.advance
    while {lxr.current.nature == "IDENTIFIER"} do {
        anns := ast.cons(lxr.current.value, anns)
        lxr.advance
        if (lxr.current.nature == "COMMA") then {
            lxr.advance
        }
    }
    anns.reversed(ast.nil)
}

method parsedefDeclaration(lxr) {
    lxr.advance
    lxr.expectToken("IDENTIFIER")
    def name = lxr.current.value
    lxr.advance
    var dtype := ast.nil
    if (lxr.current.nature == "COLON") then {
        // Type annotation
        lxr.advance
        dtype := ast.cons(parseExpression(lxr), ast.nil)
    }
    var anns := ast.nil
    if ((lxr.current.nature == "KEYWORD")) then {
        if (lxr.current.value == "is") then {
            anns := parseAnnotations(lxr)
        }
    }
    lxr.advance
    def val = parseExpression(lxr)
    
    ast.defDecl(name, dtype, anns, val)
}

method parsevarDeclaration(lxr) {
    lxr.advance
    lxr.expectToken("IDENTIFIER")
    def name = lxr.current.value
    lxr.advance
    var dtype := ast.nil
    if (lxr.current.nature == "COLON") then {
        // Type annotation
        lxr.advance
        dtype := ast.cons(parseExpression(lxr), ast.nil)
    }
    var anns := ast.nil
    if ((lxr.current.nature == "KEYWORD")) then {
        if (lxr.current.value == "is") then {
            anns := parseAnnotations(lxr)
        }
    }
    if (lxr.current.nature == "ASSIGN") then {
        lxr.advance
        def val = parseExpression(lxr)
        ast.varDecl(name, dtype, anns, ast.cons(val, ast.nil))
    } else {
        ast.varDecl(name, dtype, anns, ast.nil)
    }
}

method parseMethodBody(lxr) {
    var body := ast.nil
    lxr.advance
    def indentBefore = indentColumn
    while {lxr.current.nature != "RBRACE"} do {
        if (lxr.current.nature == "SEMICOLON") then {
            lxr.advance
            lxr.expectToken("NEWLINE")
        }
        if (lxr.current.nature == "NEWLINE") then {
            lxr.advance
        } else {
            indentColumn := lxr.current.column
            if (indentColumn <= indentBefore) then {
                print("Indentation must increase inside method body. Expected at least column " ++ (indentBefore + 1) ++ " on line " ++ lxr.current.line ++ " but got " ++ indentColumn)
                Exception.raise("Indentation must increase inside method body. Expected at least column " ++ (indentBefore + 1) ++ " on line " ++ lxr.current.line ++ " but got " ++ indentColumn)
            }
            if (lxr.current.nature == "KEYWORD") then {
                if (lxr.current.value == "var") then {
                    def dec = parsevarDeclaration(lxr)
                    body := ast.cons(dec, body)
                } elseif { lxr.current.value == "def" } then {
                    def dec = parsedefDeclaration(lxr)
                    body := ast.cons(dec, body)
                } else {
                    body := ast.cons(parseStatement(lxr), body)
                }
            } else {
                body := ast.cons(parseStatement(lxr), body)
            }
        }
    }
    lxr.advance
    indentColumn := indentBefore
    body.reversed(ast.nil)

}

method parseMethodDeclaration(lxr) {
    lxr.advance
    var parts := ast.nil
    while { lxr.current.nature == "IDENTIFIER" } do {
        def id = lxr.current.value
        lxr.advance
        if (lxr.current.nature == "LPAREN") then {
            lxr.advance
            var args := ast.nil
            while {(lxr.current.nature != "RPAREN") && (lxr.current.nature != "EOF")} do {
                lxr.expectToken "IDENTIFIER"
                def idToken = lxr.current
                var dtype := ast.nil
                lxr.advance
                if (lxr.current.nature == "COLON") then {
                    // Type annotation
                    lxr.advance
                    dtype := ast.cons(parseTypeExpression(lxr), ast.nil)
                }
                args := ast.cons(ast.identifierDeclaration(idToken.value, dtype), args)
                if (lxr.current.nature == "COMMA") then {
                    lxr.advance
                }
            }
            lxr.advance
            def part = ast.part(id, args.reversed(ast.nil))
            parts := ast.cons(part, parts)
        } else {
            def part = ast.part(id, ast.nil)
            parts := ast.cons(part, parts)
        }
    }
    var dtype := ast.nil
    if (lxr.current.nature == "ARROW") then {
        // Type annotation
        lxr.advance
        dtype := ast.cons(parseTypeExpression(lxr), ast.nil)
    }
    var anns := ast.nil
    if ((lxr.current.nature == "KEYWORD")) then {
        if (lxr.current.value == "is") then {
            anns := parseAnnotations(lxr)
        }
    }
    //lxr.advance
    def body = parseMethodBody(lxr)
    ast.methodDecl(parts.reversed(ast.nil), dtype, anns, body)
}

method parseClassDeclaration(lxr) {
    lxr.advance
    var parts := ast.nil
    while { lxr.current.nature == "IDENTIFIER" } do {
        def id = lxr.current.value
        lxr.advance
        if (lxr.current.nature == "LPAREN") then {
            lxr.advance
            var args := ast.nil
            while {(lxr.current.nature != "RPAREN") && (lxr.current.nature != "EOF")} do {
                args := ast.cons(ast.identifierDeclaration(lxr.current.value), args)
                lxr.advance
                if (lxr.current.nature == "COMMA") then {
                    lxr.advance
                }
            }
            lxr.advance
            def part = ast.part(id, args.reversed(ast.nil))
            parts := ast.cons(part, parts)
        } else {
            def part = ast.part(id, ast.nil)
            parts := ast.cons(part, parts)
        }
    }
    lxr.advance
    def body = parseObjectBody(lxr)
    def obj = ast.objectConstructor(body, ast.nil)
    ast.methodDecl(parts.reversed(ast.nil), ast.nil, ast.nil, ast.cons(obj, ast.nil))
}

method parseImport(lxr) {
    lxr.expectKeyword("import")
    lxr.advance
    lxr.expectToken("STRING")
    def src = lxr.current.value
    lxr.advance
    lxr.expectToken("IDENTIFIER")
    if (lxr.current.value != "as") then {
        Exception.raise "Expected 'as' in import"
    }
    lxr.advance
    lxr.expectToken("IDENTIFIER")
    def name = lxr.current.value
    lxr.advance
    var ident
    if (lxr.current.nature == "COLON") then {
        lxr.advance
        def aType = parseTypeExpression(lxr)
        ident := ast.identifierDeclaration(name, aType)
    } else {
        ident := ast.identifierDeclaration(name, ast.nil)
    }
    ast.importStmt(src, ident)
}

method parseObjectBody(lxr) {
    var body := ast.nil
    
    var token := lxr.current

    def indentBefore = indentColumn

    while { (token.nature != "EOF") && (token.nature != "RBRACE") } do {
        indentColumn := token.column
        if ((indentColumn <= indentBefore) && (token.nature != "NEWLINE")) then {
            print("Indentation must increase inside object body. Expected at least column " ++ (indentBefore + 1) ++ " on line " ++ lxr.current.line ++ " but got " ++ indentColumn)
            Exception.raise("Indentation must increase inside object body. Expected at least column " ++ (indentBefore + 1) ++ " on line " ++ lxr.current.line ++ " but got " ++ indentColumn)
        }

        if (token.nature == "SEMICOLON") then {
            lxr.advance
            token := lxr.current
            lxr.expectToken("NEWLINE")
        }
        if (token.nature == "NEWLINE") then {
            lxr.advance
        } elseif { token.nature == "KEYWORD" } then {
            if (token.value == "var") then {
                def dec = parsevarDeclaration(lxr)
                body := ast.cons(dec, body)
            } elseif { token.value == "def" } then {
                def dec = parsedefDeclaration(lxr)
                body := ast.cons(dec, body)
            } elseif { token.value == "method" } then {
                def dec = parseMethodDeclaration(lxr)
                body := ast.cons(dec, body)
            } elseif { token.value == "class" } then {
                def dec = parseClassDeclaration(lxr)
                body := ast.cons(dec, body)
            } else {
                if (token.value == "import") then {
                    def imp = parseImport(lxr)
                    body := ast.cons(imp, body)
                } else {
                    def stmt = parseStatement(lxr)
                    body := ast.cons(stmt, body)
                }
            } 
        } else {
            def stmt = parseStatement(lxr)
            body := ast.cons(stmt, body)
        }
        token := lxr.current
    }
    
    indentColumn := indentBefore
    body.reversed(ast.nil)

}

method parseObject(lxr) {
    lxr.advance
    var anns := ast.nil
    if (lxr.current.nature == "KEYWORD") then {
        lxr.expectKeyword("is")
        anns := parseAnnotations(lxr)
    }
    lxr.advance
    def body = parseObjectBody(lxr)
    lxr.advance
    ast.objectConstructor(body, anns)
}

method parse(code) {
    indentColumn := 0
    def lxr = lexer(code)
    def body = parseObjectBody(lxr)
    ast.objectConstructor(body, ast.nil)
}
