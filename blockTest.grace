//import "ast" as ast

// This file makes use of all AST nodes

def x = object {
    var y : Number := 1
    method foo(arg : Action) -> String {
        self.y := arg.apply
        return "y: {y}!"
    }
}

print(x.foo { 2 })

print ("-------")

def y = object {

    method bar(a : Block) -> Number {
        var value := a.apply
        value := value + 1
        print(value)
        return value
    }
}

print (y.bar {123})

print ("-------")

def z = object {

    method bar(a : Block) -> Number {
        print("hi")
        var result := a.apply(5, 10)  // Apply the block with arguments 5 and 10
        print(result)                // Print the result
        return result                // Return the result
    }
}

print (z.bar {x, y -> x + y})  // Pass a block with two parameters and a body

print ("-------")

def aObject = object {

    method bar(a : Block) -> String {
        print("hi")
        var result := a.apply(5, 10)  // Apply the block with arguments 5 and 10
        print(result)                // Print the result
        return "Hello"                // Return the hello
    }
}

print (aObject.bar {x, y -> x + y})  // Pass a block with two parameters and a body

print ("-------")

var b := 456

def bObject = object {

    method bar(a : Block) -> Number {
        print("hi")
        var result := a.apply(b, 10)  // Apply the block with arguments 5 and 10
        print(result)                // Print the result
        return result                // Return the result
    }
}

b := bObject.bar{x, y -> x + y}
print (bObject.bar{x, y -> x + y})

print ("-------")

var block := {x, y -> x + y}  // Define a block with two parameters
print(block.apply(5, 10))    // Apply the block directly with arguments 5 and 10

print ("-------")

var c := {x, y -> x + y}  // Define a block with two parameters
print(c.apply(5, 10))    // Apply the block directly with arguments 5 and 10