
export class ObjectConstructor {
    constructor(body, annotations) {
        this.body = body;
        this.annotations = annotations;
    }
}

export class MethodDecl {
    #name
    constructor(parts, returnType, annotations, body) {
        this.parts = parts;
        this.returnType = returnType[0];
        this.annotations = annotations;
        this.body = body;
    }

    get name() {
        if (this.#name !== undefined) {
            return this.#name;
        }
        this.#name = this.parts.map(part => part.name + "(" + part.params.length + ")").join("");
        return this.#name;
    }
}

export class Part {
    constructor(name, params) {
        this.name = name;
        this.params = params;
    }

    get args() {
        return this.params;
    }
}

export class IdentifierDeclaration {
    constructor(name, type) {
        this.name = name;
        this.type = type[0];
    }

}

export class LexicalRequest {
    #name
    constructor(parts) {
        if (parts === undefined) {
            throw new Error("undefined parts")
        }
        this.parts = parts;
    }

    get name() {
        if (this.#name !== undefined) {
            return this.#name;
        }
        this.#name = this.parts.map(part => part.name + "(" + part.args.length + ")").join("");
        return this.#name;
    }
}

export class ExplicitRequest {
    #name
    constructor(receiver, parts) {
        if (parts === undefined) {
            throw new Error("undefined parts")
        }
        this.receiver = receiver;
        this.parts = parts;
    }

    get name() {
        if (this.#name !== undefined) {
            return this.#name;
        }
        this.#name = this.parts.map(part => part.name + "(" + part.args.length + ")").join("");
        return this.#name;
    }
}

export class DefDecl {
    constructor(name, type, annotations, value) {
        this.name = name;
        this.type = type[0];
        this.annotations = annotations;
        this.value = value;
    }
}

export class VarDecl {
    constructor(name, type, annotations, value) {
        this.name = name;
        this.type = type[0];
        this.annotations = annotations;
        this.value = value[0];
    }
}

export class NumberNode {
    constructor(value) {
        this.value = value;
    }
}

export class StringNode {
    constructor(value) {
        this.value = value;
    }
}

export class InterpString {
    constructor(value, expr, next) {
        this.value = value;
        this.expression = expr;
        this.next = next;
    }
}

export class Block {
    constructor(params, body) {
        this.params = params;
        this.body = body;
    }
}

export class Comment {
    constructor(value) {
        this.text = value;
    }
}

export class ReturnStmt {
    constructor(value) {
        this.value = value;
    }
}

export class Assign {
    constructor(lhs, rhs) {
        this.lhs = lhs;
        this.rhs = rhs;
    }
}

export class ImportStmt {
    constructor(source, binding) {
        this.source = source;
        this.binding = binding;
    }
}
