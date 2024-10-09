import * as ast from './ast.js';

class Continuation {
    of(val) {
        return this.go(val);
    }
}

class FunctionContinuation extends Continuation {
    constructor(endCont, func) {
        super();
        this.endCont = endCont;
        this.func = func;
    }

    go(val) {
        return this.func(this.endCont, val);
    }

    toString() {
        return "FunctionContinuation";
    }
}

class StatementsContinuation extends Continuation {
    constructor(endCont, scope, list, index) {
        super();
        this.endCont = endCont;
        if (endCont === null) {
            throw new Error("endCont is null", endCont);
        }
        this.scope = scope;
        this.list = list;
        this.index = index;
    }

    go(val) {
        if (this.index === this.list.length) {
            return this.endCont.of(val);
        }
        let stmt = this.list[this.index];
        let nextCont = new StatementsContinuation(this.endCont, this.scope, this.list, this.index + 1);
        return evaluateStatement(nextCont, this.scope, stmt);
    }

    toString() {
        return "StatementsContinuation at " + this.index + " of " + this.list.length;
    }
}

class ArgumentsContinuation extends Continuation {
    constructor(endCont, scope, req, partIndex, argIndex, argValues=[]) {
        super();
        this.endCont = endCont;
        this.scope = scope;
        this.req = req;
        if (typeof req !== 'object') {
            throw new Error("req is not an object", req);
        }
        this.partIndex = partIndex;
        this.argIndex = argIndex;
        this.argValues = argValues;
    }

    go(val) {
        let argValues = this.argValues.slice();
        if (val !== undefined) {
            argValues.push(val);
        }
        if (this.partIndex == this.req.parts.length) {
            return this.endCont.of(argValues);
        }
        let part = this.req.parts[this.partIndex];
        if (this.argIndex === part.args.length) {
            return new ArgumentsContinuation(this.endCont, this.scope, this.req, this.partIndex + 1, 0, argValues);
        }
        let arg = part.args[this.argIndex];
        let nextCont = new ArgumentsContinuation(this.endCont, this.scope, this.req, this.partIndex, this.argIndex + 1, argValues);
        return evaluateExpression(nextCont, this.scope, arg);
    }

    toString() {
        return "ArgumentsContinuation for " + this.req.name + " at " + this.partIndex + " of " + this.req.parts.length + (this.partIndex < this.req.parts.length ? " and " + this.argIndex + " of " + this.req.parts[this.partIndex].args.length : " last part") + ": " + this.argValues;
    }
}

class RequestContinuation extends Continuation {
    constructor(endCont, receiver, req) {
        super();
        this.endCont = endCont;
        this.receiver = receiver;
        if (receiver === undefined) {
            throw new Error("receiver is undefined", receiver);
        }
        this.req = req;
        if (typeof req !== 'object') {
            throw new Error("req is not an object", req);
        }
    }

    go(args) {
        //console.log("calling", this.req.name, "on", this.receiver, "with", args);
        if (this.receiver instanceof GraceObject)
            return this.receiver.request(this.endCont, this.req, args);
        if (typeof this.receiver == 'number') {
            return GraceNumber.request(this.endCont, this.req, args, this.receiver);
        }
        if (typeof this.receiver == 'string') {
            return GraceString.request(this.endCont, this.req, args, this.receiver);
        }
        if (typeof this.receiver == 'boolean') {
            return GraceBoolean.request(this.endCont, this.req, args, this.receiver);
        }
        throw new Error("Unknown receiver " + this.receiver);
    }

    toString() {
        return "RequestContinuation for " + this.req.name;
    }
}

class MethodContinuation extends Continuation {
    constructor(retCont, method, self, args) {
        super();
        this.retCont = retCont;
        this.method = method;
        this.self = self
        this.args = args;
    }

    go() {
        let scope = new GraceObject({}, this.self);
        for (let part of this.method.parts) {
            for (let dec of part.params) {
                scope.addDef(dec.name);
                scope.fields[dec.name] = this.args.shift();
            }
        }
        scope.returnContinuation = this.retCont;
        return evaluateStatementList(this.retCont, scope, this.method.body);
    }

    toString() {
        return "MethodContinuation for " + this.method.name;
    }
}

export function evaluateModule(cont, module) {
    return evaluateObjectConstructor(cont, prelude, module);
}

export function evaluateStatementList(cont, scope, list) {
    if (cont === null) {
        throw new Error("cont is null", cont);
    }
    if (list.length === 0) {
        return cont;
    }
    for (let stmt of list) {
        if (stmt instanceof ast.VarDecl) {
            scope.addVar(stmt.name);
        } else if (stmt instanceof ast.DefDecl) {
            scope.addDef(stmt.name);
        } else if (stmt instanceof ast.MethodDecl) {
            scope.methods[stmt.name] = stmt;
        }
    }
    return new StatementsContinuation(cont, scope, list, 0);
}

function evaluateStatement(cont, scope, stmt) {
    if (stmt instanceof ast.VarDecl) {
        if (stmt.value === undefined) {
            return cont.of(undefined);
        }
        let req = new ast.LexicalRequest([new ast.Part(stmt.name + ":=", [stmt.value])])
        let reqCont = new RequestContinuation(cont, scope, req);
        let argCont = new ArgumentsContinuation(reqCont, scope, req, 0, 0);
        return argCont;
    } else if (stmt instanceof ast.DefDecl) {
        return evaluateExpression(new FunctionContinuation(cont, (cont, val) => {
            scope.fields[stmt.name] = val;
            return cont.of(undefined);
        }), scope, stmt.value);
    } else if (stmt instanceof ast.MethodDecl) {
        return cont;
    } else if (stmt instanceof ast.ReturnStmt) {
        let rscope = scope
        while (rscope && !rscope.returnContinuation) {
            rscope = rscope.lexicalParent;
        }
        if (!rscope)
            throw new Error("No return continuation in scope");
        return evaluateExpression(rscope.returnContinuation, scope, stmt.value)
    } else if (stmt instanceof ast.Assign) {
        if (stmt.lhs instanceof ast.LexicalRequest) {
            let target = stmt.lhs;
            let name = target.parts[0].name;
            let parts = [new ast.Part(name + ":=", [stmt.rhs])];
            let request = new ast.LexicalRequest(parts);
            let receiver = scope.findReceiver(request);
            if (receiver === null) {
                console.log("name", req.name, "scope", scope)
                throw new Error("no receiver found for method " + req.name);
            }
            let reqCont = new RequestContinuation(cont, receiver, request);
            let argCont = new ArgumentsContinuation(reqCont, scope, request, 0, 0);
            return argCont;
        } else {
            throw new Error("unimplemented assignment LHS", stmt.lhs);
        }
    } else if (stmt instanceof ast.Comment) {
        return cont.of(undefined);
    } else {
        return evaluateExpression(cont, scope, stmt);
    }
}

function evaluateExpression(cont, scope, expr) {
    if (expr instanceof ast.LexicalRequest) {
        return evaluateLexicalRequest(cont, scope, expr);
    }
    if (expr instanceof (ast.ExplicitRequest)) {
        return evaluateExplicitRequest(cont, scope, expr);
    }
    if (expr instanceof ast.NumberNode) {
        return cont.of(expr.value);
    }
    if (expr instanceof ast.StringNode) {
        return cont.of(expr.value);
    }
    if (expr instanceof ast.InterpString) {
        return evaluateExpression(new FunctionContinuation(cont, (cont, val) => {
            return evaluateExpression(new FunctionContinuation(cont, (cont, val2) => {
                return cont.of(expr.value + val + val2);
            }), scope, expr.next);
        }), scope, expr.expression);
    }
    if (expr instanceof ast.Block) {
        return evaluateBlock(cont, scope, expr);
    }
    if (expr instanceof ast.ObjectConstructor) {
        return evaluateObjectConstructor(cont, scope, expr);
    }
    console.log("unknown expression", expr)
    throw new Error("Unknown expression" + expr);
}

function evaluateObjectConstructor(cont, scope, obj) {
    let o = new GraceObject({"self(0)": (cont, args) => cont.of(o)}, scope);
    return evaluateStatementList(
        new FunctionContinuation(cont, (cont, receiver) => {
            return cont.of(o);
        }),
        o, obj.body);
}

function evaluateBlock(cont, scope, block) {
    let blockObj = new GraceObject({
        ["apply(" + block.params.length + ")"]: (cont, args) => {
            let bscope = new GraceObject({}, scope);
            for (let i = 0; i < block.params.length; i++) {
                bscope.addDef(block.params[i].parts[0].name);
                bscope.fields[block.params[i].parts[0].name] = args[i];
            }
            return evaluateStatementList(cont, bscope, block.body);
        },
    }, scope);
    return cont.of(blockObj)
}

function evaluateLexicalRequest(cont, scope, stmt) {
    let receiver = scope.findReceiver(stmt);
    if (receiver === null) {
        console.log("name", stmt.name, "scope", scope)
        throw new Error("no receiver found for method " + stmt.name);
    }
    let reqCont = new RequestContinuation(cont, receiver, stmt);
    let argCont = new ArgumentsContinuation(reqCont, scope, stmt, 0, 0);
    return argCont;
}

function evaluateExplicitRequest(cont, scope, stmt) {
    return evaluateExpression(new FunctionContinuation(cont, (cont, receiver) => {
        let reqCont = new RequestContinuation(cont, receiver, stmt);
        let argCont = new ArgumentsContinuation(reqCont, scope, stmt, 0, 0);
        return argCont;
    }), scope, stmt.receiver);
}

class GraceObject {
    constructor(methods, lexicalParent=null) {
        this.methods = methods;
        this.fields = {};
        this.lexicalParent = lexicalParent;
    }

    request(cont, req, args, rec=undefined) {
        if (rec === undefined)
            rec = this;
        let method = this.methods[req.name];
        if (!method) {
            console.log("no such method", req.name, "on", this);
            throw new Error("no such method " + req.name + " on " + this)
        }
        if (method instanceof Function) {
            return method(cont, args, rec);
        } else {
            let methodCont = new MethodContinuation(cont, method, rec, args);
            return methodCont;
        }
    }

    addVar(name) {
        this.fields[name] = undefined;
        this.methods[name + "(0)"] = (cont, args) => {
            return cont.of(this.fields[name]);
        }
        this.methods[name + ":=(1)"] = (cont, args) => {
            this.fields[name] = args[0];
            return cont.of(undefined);
        }
    }

    addDef(name) {
        this.fields[name] = undefined;
        this.methods[name + "(0)"] = (cont, args) => {
            return cont.of(this.fields[name]);
        }
    }

    findReceiver(req) {
        if (req.name in this.methods) {
            return this;
        }
        if (this.lexicalParent)
            return this.lexicalParent.findReceiver(req);
        console.log("no lexical receiver found for", req.name)
        return null
    }
}

const GraceNumber = new GraceObject({
    "+(1)": (cont, args, rec) => {
        return cont.of(rec + args[0]);
    },
    "-(1)": (cont, args, rec) => {
        return cont.of(rec - args[0]);
    },
    "*(1)": (cont, args, rec) => {
        return cont.of(rec * args[0]);
    },
    "/(1)": (cont, args, rec) => {
        return cont.of(rec / args[0]);
    },
    "asString(0)": (cont, args, rec) => {
        return cont.of(rec.toString());
    },
    ">(1)": (cont, args, rec) => {
        return cont.of(rec > args[0]);
    },
    "<(1)": (cont, args, rec) => {
        return cont.of(rec < args[0]);
    },
    "==(1)": (cont, args, rec) => {
        return cont.of(rec == args[0]);
    },
    ">=(1)": (cont, args, rec) => {
        return cont.of(rec >= args[0]);
    },
    "<=(1)": (cont, args, rec) => {
        return cont.of(rec <= args[0]);
    },
    "!=(1)": (cont, args, rec) => {
        return cont.of(rec != args[0]);
    },
})

const GraceString = new GraceObject({
    "++(1)": (cont, args, rec) => {
        if (typeof args[0] == 'string') {
            return cont.of(rec + args[0]);
        }
        let rc = new RequestContinuation(
            new FunctionContinuation(cont, (cont, val) => {
                return cont.of(rec + val);
            }),
            args[0], new ast.LexicalRequest([new ast.Part("asString", [])]));
        return rc //cont.of(rec + args[0]);
    },
    "at(1)": (cont, args, rec) => {
        return cont.of(rec[args[0] - 1]);
    },
    "size(0)": (cont, args, rec) => {
        return cont.of(rec.length);
    },
    "asString(0)": (cont, args, rec) => {
        return cont.of(rec);
    },
    "firstCodepoint(0)": (cont, args, rec) => {
        return cont.of(rec.charCodeAt(0));
    },
    "replace(1)with(1)": (cont, args, rec) => {
        return cont.of(rec.replaceAll(args[0], args[1]));
    },
    ">(1)": (cont, args, rec) => {
        return cont.of(rec > args[0]);
    },
    "<(1)": (cont, args, rec) => {
        return cont.of(rec < args[0]);
    },
    "==(1)": (cont, args, rec) => {
        return cont.of(rec == args[0]);
    },
    ">=(1)": (cont, args, rec) => {
        return cont.of(rec >= args[0]);
    },
    "<=(1)": (cont, args, rec) => {
        return cont.of(rec <= args[0]);
    },
    "!=(1)": (cont, args, rec) => {
        return cont.of(rec != args[0]);
    },
    "substringFrom(1)to(1)": (cont, args, rec) => {
        return cont.of(rec.substring(args[0] - 1, args[1]));
    },
})


const GraceBoolean = new GraceObject({
    "&&(1)": (cont, args, rec) => {
        return cont.of(rec && args[0]);
    },
    "||(1)": (cont, args, rec) => {
        return cont.of(rec || args[0]);
    },
    "prefix!(0)": (cont, args, rec) => {
        return cont.of(!rec);
    },
    "==(1)": (cont, args, rec) => {
        return cont.of(rec == args[0]);
    },
    "!=(1)": (cont, args, rec) => {
        return cont.of(rec != args[0]);
    },
})

function call(cont, rec, name, args) {
    return rec.request(cont, new ast.LexicalRequest([new ast.Part(name, args)]), args);
}

function whileDo(cont, cond, block) {
    return call(new FunctionContinuation(cont, (cont, val) => {
        if (val) {
            let rc = new RequestContinuation(
                new FunctionContinuation(cont, (cont, val) => {return whileDo(cont, cond, block);}),
                block, new ast.LexicalRequest([new ast.Part("apply", [])]));
            return rc.of([]);
        }
        return cont.of(undefined);
    }), cond, "apply", []);
}

function elseifs(cont, elseifConds, elseifThens, elseCont) {
    if (elseifConds.length === 0) {
        return elseCont.of(undefined);
    }
    let cond = elseifConds[0];
    let then = elseifThens[0];
    elseifConds = elseifConds;
    elseifThens = elseifThens;
    return call(new FunctionContinuation(cont, (cont, val) => {
        if (val) {
            let rc = new RequestContinuation(
                cont,
                then, new ast.LexicalRequest([new ast.Part("apply", [])]));
            return rc
        }
        return elseifs(cont, elseifConds.slice(1), elseifThens.slice(1), elseCont);
    }), cond, "apply", []);
}

function ifThenElseIfs(cont, args) {
    if (args[0]) {
        let rc = new RequestContinuation(cont, args[1], new ast.LexicalRequest([new ast.Part("apply", [])]));
        return rc.of([])
    } else {
        let conds = []
        let thens = []
        let elseBlock
        if (args.length % 2 == 1) {
            elseBlock = args[args.length - 1]
        }
        for (let i = 2; i < args.length - 1; i += 2) {
            conds.push(args[i])
            thens.push(args[i + 1])
        }
        return elseifs(cont, conds, thens,
            elseBlock
                ? new RequestContinuation(cont, elseBlock, new ast.LexicalRequest([new ast.Part("apply", [])]))
                : cont
        );
    }
}

export const prelude = new GraceObject({
    'print(1)': (cont, args) => {
        console.log(args[0]);
        document.getElementById('output').append(args[0], document.createElement('br'));
        return cont.of(undefined);
    },
    'if(1)then(1)': (cont, args) => {
        if (args[0]) {
            let rc = new RequestContinuation(cont, args[1], new ast.LexicalRequest([new ast.Part("apply", [])]));
            return rc.of([])
        }
        return cont.of(undefined);
    },
    'if(1)then(1)else(1)': (cont, args) => {
        if (args[0]) {
            let rc = new RequestContinuation(cont, args[1], new ast.LexicalRequest([new ast.Part("apply", [])]));
            return rc.of([])
        } else {
            let rc = new RequestContinuation(cont, args[2], new ast.LexicalRequest([new ast.Part("apply", [])]));
            return rc.of([])
        }
        return cont.of(undefined);
    },
    'if(1)then(1)elseif(1)then(1)else(1)': (cont, args) => {
        return ifThenElseIfs(cont, args);
    },
    'if(1)then(1)elseif(1)then(1)': (cont, args) => {
        return ifThenElseIfs(cont, args);
    },
    'if(1)then(1)elseif(1)then(1)elseif(1)then(1)else(1)': (cont, args) => {
        return ifThenElseIfs(cont, args);
    },
    'if(1)then(1)elseif(1)then(1)elseif(1)then(1)': (cont, args) => {
        return ifThenElseIfs(cont, args);
    },
    'if(1)then(1)elseif(1)then(1)elseif(1)then(1)elseif(1)then(1)else(1)': (cont, args) => {
        return ifThenElseIfs(cont, args);
    },
    'if(1)then(1)elseif(1)then(1)elseif(1)then(1)elseif(1)then(1)': (cont, args) => {
        return ifThenElseIfs(cont, args);
    },
    'if(1)then(1)elseif(1)then(1)elseif(1)then(1)elseif(1)then(1)elseif(1)then(1)else(1)': (cont, args) => {
        return ifThenElseIfs(cont, args);
    },
    'if(1)then(1)elseif(1)then(1)elseif(1)then(1)elseif(1)then(1)elseif(1)then(1)': (cont, args) => {
        return ifThenElseIfs(cont, args);
    },
    'while(1)do(1)': (cont, args) => {
        return whileDo(cont, args[0], args[1]);
    },
    'true(0)': (cont, args) => {
        return cont.of(true);
    },
    'false(0)': (cont, args) => {
        return cont.of(false);
    },
})

