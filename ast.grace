method cons(hd, tl) {
    object {
        def head is public = hd
        def tail is public = tl
        def end is public = false

        method asString {
            if (tail.end) then {
                return "one(" ++ head.asString ++ ")"
            }
            return "cons(" ++ head.asString ++ ", " ++ tail.asString ++ ")"
        }

        method reversed(next) {
            def c = cons(head, next)
            if (tail.end) then {
                c
            } else {
                tail.reversed(c)
            }
        }

        method map(f) {
            cons(f.apply(head), tail.map(f))
        }
    }
}

method nil {
    object {
        def end is public = true

        method asString {
            "nil"
        }

        method reversed(next) {
            next
        }

        method map(f) {
            nil
        }
    }

}

method numberNode(val) {
    object {
        def value is public = val

        method asString {
            "numLit(" ++ value.asString ++ ")"
        }
    }
}

method stringNode(val) {
    object {
        def value is public = val

        method asString {
            "strLit(" ++ escapeString(value) ++ ")"
        }
    }
}

method interpString(val, exp, rest) {
    object {
        def value is public = val
        def expression is public = exp
        def next is public = rest

        method asString {
            "interpStr(" ++ escapeString(value) ++ ", " ++ expression ++ ", " ++ next ++ ")"
        }
    }
}

method block(params, stmts) {
    object {
        def parameters is public = params
        def statements is public = stmts

        method asString {
            "block(" ++ parameters ++ ", " ++ statements ++ ")"
        }
    }
}

method defDecl(id, dtype, anns, val) {
    object {
        def name is public = id
        def decType is public = dtype
        def annotations is public = anns
        def value is public = val

        method asString {
            "defDec(\"" ++ name ++ "\", "  ++ decType ++ ", " ++ anns.map { x -> "\"" ++ x ++ "\"" } ++ ", " ++ value ++ ")"
        }
    }
}

method varDecl(id, dtype, anns, val) {
    object {
        def name is public = id
        def decType is public = dtype
        def annotations is public = anns
        def value is public = val

        method asString {
            "varDec(\"" ++ name ++ "\", " ++ dtype ++ ", " ++ anns.map { x -> "\"" ++ x ++ "\"" } ++ ", " ++ value ++ ")"
        }
    }
}

method lexicalRequest(requestParts) {
    object {
        def parts is public = requestParts

        method asString {
            "lexReq(" ++ parts ++ ")"
        }
    }
}

method explicitRequest(pos, rec, requestParts) {
    object {
        def receiver is public = rec
        def parts is public = requestParts
        def position is public = pos

        method asString {
            "dotReq(" ++ receiver.asString ++ ", " ++ parts ++ ")"
        }
    }
}

method requestPart(partName, args) {
    object {
        def name is public = partName
        def arguments is public = args

        method asString {
            "part(\"" ++ name ++ "\", " ++ args ++ ")"
        }
    }
}


method part(partName, args) {
    object {
        def name is public = partName
        def parameters is public = args

        method asString {
            "part(\"" ++ name ++ "\", " ++ parameters ++ ")"
        }
    }
}

method methodDecl(declarationParts, retType, anns, bd) {
    object {
        def parts is public = declarationParts
        def returnType is public = retType
        def annotations is public = anns
        def body is public = bd

        method asString {
            "methDec(" ++ parts ++ ", " ++ returnType ++ ", " ++ annotations ++ ", " ++ body ++ ")"
        }
    }
}

method declarationPart(id, params) {
    object {
        def name is public = id
        def parameters is public = params

        method asString {
            "part(\"" ++ name ++ "\", " ++ parameters ++ ")"
        }
    }
}

method objectConstructor(bd, anns) {
    object {
        def body is public = bd
        def annotations is public = anns

        method asString {
            "objCons(" ++ body ++ ", " ++ annotations.map { x -> "\"" ++ x ++ "\"" } ++ ")"
        }
    }

}

method assign(lhs, rhs) {
    object {
        def left is public = lhs
        def right is public = rhs

        method asString {
            "assn(" ++ left ++ ", " ++ right ++ ")"
        }
    }
}

method returnStmt(val) {
    object {
        def value is public = val

        method asString {
            "returnStmt(" ++ value ++ ")"
        }
    }
}

method identifierDeclaration(id, dtype) {
    object {
        def name is public = id
        def decType is public = dtype

        method asString {
            "identifierDeclaration(" ++ escapeString(name) ++ ", " ++ dtype ++ ")"
        }
    }
}

method comment(text) {
    object {
        def value is public = text

        method asString {
            "comment(" ++ escapeString(text) ++ ")"
        }
    }
}

method importStmt(src, nm) {
    object {
        def source is public = src
        def binding is public = nm

        method asString {
            "importStmt(\"" ++ source ++ "\", " ++ binding ++ ")"
        }
    }
}

method escapeString(value) {
    var i := 1
    def len = value.size
    while { i < len } do {
        def c = value.at(i)
        if (c == "\\") then {
            return "safeStr(\"" ++ value.substringFrom 1 to(i - 1) ++ "\", charBackslash, " ++ escapeString(value.substringFrom(i + 1)to(len)) ++ ")"
        }
        if (c == "$") then {
            return "safeStr(\"" ++ value.substringFrom 1 to(i - 1) ++ "\", charDollar, " ++ escapeString(value.substringFrom(i + 1)to(len)) ++ ")"
        }
        if (c == "*") then {
            return "safeStr(\"" ++ value.substringFrom 1 to(i - 1) ++ "\", charStar, " ++ escapeString(value.substringFrom(i + 1)to(len)) ++ ")"
        }
        if (c == "\{") then {
            return "safeStr(\"" ++ value.substringFrom 1 to(i - 1) ++ "\", charLBrace, " ++ escapeString(value.substringFrom(i + 1)to(len)) ++ ")"
        }
        if (c == "\n") then {
            return "safeStr(\"" ++ value.substringFrom 1 to(i - 1) ++ "\", charLF, " ++ escapeString(value.substringFrom(i + 1)to(len)) ++ ")"
        }
        if (c == "\r") then {
            return "safeStr(\"" ++ value.substringFrom 1 to(i - 1) ++ "\", charCR, " ++ escapeString(value.substringFrom(i + 1)to(len)) ++ ")"
        }
        if (c == "\"") then {
            return "safeStr(\"" ++ value.substringFrom 1 to(i - 1) ++ "\", charDQuote, " ++ escapeString(value.substringFrom(i + 1)to(len)) ++ ")"
        }
        if (c == "~") then {
            return "safeStr(\"" ++ value.substringFrom 1 to(i - 1) ++ "\", charTilde, " ++ escapeString(value.substringFrom(i + 1)to(len)) ++ ")"
        }
        if (c == "^") then {
            return "safeStr(\"" ++ value.substringFrom 1 to(i - 1) ++ "\", charCaret, " ++ escapeString(value.substringFrom(i + 1)to(len)) ++ ")"
        }
        if (c == "`") then {
            return "safeStr(\"" ++ value.substringFrom 1 to(i - 1) ++ "\", charBacktick, " ++ escapeString(value.substringFrom(i + 1)to(len)) ++ ")"
        }
        if (c == "@") then {
            return "safeStr(\"" ++ value.substringFrom 1 to(i - 1) ++ "\", charAt, " ++ escapeString(value.substringFrom(i + 1)to(len)) ++ ")"
        }
        if (c == "&") then {
            return "safeStr(\"" ++ value.substringFrom 1 to(i - 1) ++ "\", charAmp, " ++ escapeString(value.substringFrom(i + 1)to(len)) ++ ")"
        }
        if (c == "%") then {
            return "safeStr(\"" ++ value.substringFrom 1 to(i - 1) ++ "\", charPercent, " ++ escapeString(value.substringFrom(i + 1)to(len)) ++ ")"
        }
        i := i + 1
    }
    "\"" ++ value.replace "\\" with "\\\\".replace "\"" with "\\\"".replace "\n" with "\\n".replace "\r" with "\\r" ++ "\""
}
