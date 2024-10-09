module Program where

import Ast

program = objCons(cons(methDec(one(part("succ", one(identifierDeclaration("x", one(lexReq(one(part("Number", nil)))))))), cons(lexReq(one(part("Number", nil))), nil), one("public"), one(dotReq(lexReq(one(part("x", nil))), one(part("+", one(numLit(1))))))), cons(defDec("a", nil, nil, numLit(1)), cons(varDec("b", nil, nil, one(lexReq(one(part("succ", one(lexReq(one(part("a", nil))))))))), one(dotReq(block(nil, one(lexReq(one(part("print", one(lexReq(one(part("b", nil))))))))), one(part("apply", nil))))))))
