class Node {

}

class ObjectConstructor : Node {
    var body : [Node]
    var annotations : [Node]

    init(_ body : [Node], _ annotations : [Node]) {
        self.body = body
        self.annotations = annotations
    }
}

class DefDeclaration : Node {
    var name : String
    var type : Node?
    var annotations : [Node]
    var value : Node

    init(_ name : String, _ type : Node?, _ annotations : [Node], _ value : Node) {
        self.name = name
        self.type = type
        self.annotations = annotations
        self.value = value
    }
}

class VarDeclaration : Node {
    var name : String
    var type : Node?
    var annotations : [Node]
    var value : Node?

    init(_ name : String, _ type : Node?, _ annotations : [Node], _ value : [Node]?) {
        self.name = name
        self.type = type
        self.annotations = annotations
        if value == nil {
            self.value = nil
        } else if value?.count == 0 {
            self.value = nil
        } else {
            self.value = value?[0]
        }
    }
}

class NumberLiteral : Node {
    var value : Int

    init(_ value : Int) {
        self.value = value
    }
}

class StringLiteral : Node {
    var value : String

    init(_ value : String) {
        self.value = value
    }
}

class InterpolatedString : Node {
    var before : String
    var expression : Node
    var after : Node

    init(_ before : String, _ expression : Node, _ after : Node) {
        self.before = before
        self.expression = expression
        self.after = after
    }
}

class LexicalRequest : Node {
    var node : [Node]

    init(_ node : [Node]) {
        self.node = node
    }
}

class IdentifierDeclaration : Node {
    var name : String
    var type : Node?

    init(_ name : String, _ type : [Node]?) {
        self.name = name
        self.type = type?[0]
    }
}

class DotRequest : Node {
    var node : Node
    var parts : [Node]

    init(_ node : Node, _ parts : [Node]?) {
        self.node = node
        self.parts = parts ?? []
    }
}

class MethodDeclaration : Node {
    var parts : [Node]
    var returnType : Node?
    var annotations : [Node]
    var body : [Node]

    init(_ parts : [Node], _ returnType : [Node]?, _ annotations : [Node]?, _ body : [Node]) {
        self.parts = parts
        self.returnType = returnType?[0]
        self.annotations = annotations ?? []
        self.body = body
    }
}

class Part : Node {
    var name : String
    var parameters : [Node]

    init(_ name : String, _ parameters : [Node]?) {
        self.name = name
        self.parameters = parameters ?? []
    }
}

class Assign : Node {
    var target : Node
    var value : Node

    init(_ node : Node, _ value : Node) {
        self.target = node
        self.value = value
    }
}

class ReturnStatement : Node {
    var value : Node

    init(_ value : Node) {
        self.value = value
    }
}

class Block : Node {
    var params : [Node]
    var body : [Node]

    init(_ params : [Node]?, _ body : [Node]) {
        self.params = params ?? []
        self.body = body
    }
}

class ImportStatement : Node {
    var name : String
    var binding : Node

    init(_ name : String, _ binding : Node) {
        self.name = name
        self.binding = binding
    }
}

class Comment : Node {
    var value : String

    init(_ value : String) {
        self.value = value
    }
}

func one(_ node : Node) -> [Node] {
    return [node]
}

let no : [Node] = []

func cons(_ head: Node, _ tail: [Node]) -> [Node] {
    return [head] + tail
}

func objCons(_ body : [Node], _ anns : [Node]?) -> Node {
    return ObjectConstructor(body, anns ?? [])
}


func defDec(_ name : String, _ type : [Node]?, _ anns : [Node]?, _ value : Node) -> Node {
    return DefDeclaration(name, type?[0], anns ?? [], value)
}

func varDec(_ name : String, _ type : [Node]?, _ anns : [Node]?, _ value : [Node]?) -> Node {
    return VarDeclaration(name, type?[0], anns ?? [], value)
}

func numLit(_ value : Int) -> Node {
    return NumberLiteral(value)
}

func strLit(_ value : String) -> Node {
    return StringLiteral(value)
}

func interpStr(_ before : String, _ expression : Node, _ after : Node) -> Node {
    return InterpolatedString(before, expression, after)
}

func lexReq(_ node : [Node]) -> Node {
    return LexicalRequest(node)
}

func identifierDeclaration(_ name : String, _ type : [Node]?) -> Node {
    return IdentifierDeclaration(name, type)
}

func dotReq(_ node : Node, _ parts : [Node]?) -> Node {
    return DotRequest(node, parts)
}

func methDec(_ parts : [Node], _ returnType : [Node]?, _ anns : [Node]?, _ body : [Node]) -> Node {
    return MethodDeclaration(parts, returnType, anns, body)
}

func part(_ name : String, _ parameters : [Node]?) -> Node {
    return Part(name, parameters)
}

func assn(_ node : Node, _ value : Node) -> Node {
    return Assign(node, value)
}

func returnStmt(_ value : Node) -> Node {
    return ReturnStatement(value)
}

func block(_ params : [Node]?, _ body : [Node]) -> Node {
    return Block(params, body)
}

func importStmt(_ name : String, _ binding : Node) -> Node {
    return ImportStatement(name, binding)
}

func comment(_ value : String) -> Node {
    return Comment(value)
}

let program = objCons(cons(importStmt("ast", identifierDeclaration("ast", nil)), cons(comment(" a comment"), cons(defDec("x", nil, nil, objCons(cons(varDec("y", nil, nil, one(numLit(1))), one(methDec(one(part("foo", one(identifierDeclaration("arg", nil)))), nil, nil, cons(assn(dotReq(lexReq(one(part("self", nil))), one(part("y", nil))), dotReq(lexReq(one(part("arg", nil))), one(part("apply", nil)))), cons(lexReq(one(part("print", one(lexReq(one(part("y", nil))))))), one(returnStmt(interpStr("y: ", lexReq(one(part("y", nil))), strLit("!"))))))))), nil)), one(dotReq(lexReq(one(part("x", nil))), one(part("foo", one(block(nil, one(numLit(2))))))))))), nil)

