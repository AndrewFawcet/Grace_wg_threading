import "ast" as ast

// This file makes use of all AST nodes

def x = object {
    var y : Number := 1
    method foo(arg : Action) -> String {
        self.y := arg.apply
        return "y: {y}!"
    }
}

print(x.foo { 2 })