(* F# & OCaml hybrid *)

type part = | Part of string * astNode list

and astNode =
    | ObjectConstructor of astNode list
    | VarDecl of string * astNode list * string list * astNode list
    | DefDecl of string * astNode list * string list * astNode
    | ExplicitRequest of astNode * part list
    | LexicalRequest of part list
    | NumberNode of double
    | Block of astNode list * astNode list
    | MethodDecl of part list * astNode list * string list * astNode list
    | Assign of astNode * astNode
    | ReturnStmt of astNode
    | IdentifierDeclaration of string * astNode list
    | StringNode of string
    | Comment of string



let cons (hd, tl) = hd :: tl
let one hd = [hd]
let nil = []
let no = nil


let objCons (l) = ObjectConstructor l
let varDec (name, dtype, anns, value) = VarDecl (name, dtype, anns, value)
let defDec (name, dtype, anns, value) = DefDecl (name, dtype, anns, value)
let methDec (parts, rtype, anns, body) = MethodDecl (parts, rtype, anns, body)
let dotReq (receiver, req) = ExplicitRequest (receiver, req)
let lexReq parts = LexicalRequest parts
let numLit value = NumberNode value
let strLit value = StringNode value
let assn (lhs, rhs) = Assign (lhs, rhs)
let returnStmt value = ReturnStmt value
let identifierDeclaration (name, dtype) = IdentifierDeclaration (name, dtype)
let block (parameters, body) = Block (parameters, body)
let comment text = Comment text

let part (name, parameters) = Part (name, parameters)

let program = objCons(cons(methDec(one(part("succ", one(identifierDeclaration("x", one(lexReq(one(part("Number", nil)))))))), cons(lexReq(one(part("Number", nil))), nil), one("public"), one(dotReq(lexReq(one(part("x", nil))), one(part("+", one(numLit(1))))))), cons(defDec("a", nil, nil, numLit(1)), cons(varDec("b", nil, nil, one(lexReq(one(part("succ", one(lexReq(one(part("a", nil))))))))), one(dotReq(block(nil, one(lexReq(one(part("print", one(lexReq(one(part("b", nil))))))))), one(part("apply", nil))))))))
