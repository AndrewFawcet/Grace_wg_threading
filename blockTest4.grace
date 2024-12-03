
def aObject = object {

    method bar(a : Block) -> String {
        print("hi")
        var result := a.apply(5, 10)  // Apply the block with arguments 5 and 10
        print(result)                // Print the result
        return "Hello"                // Return the hello
    }
}

print (aObject.bar {x, y -> x + y})  // Pass a block with two parameters and a body

print ("-------four ok")
