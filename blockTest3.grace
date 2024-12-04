
def z = object {

    method bar(a : Block) -> Number {
        print("hi")
        var result := a.apply(5, 10)  // Apply the block with arguments 5 and 10
        print(result)                // Print the result
        return result                // Return the result
    }
}

print (z.bar {x, y -> x + y})  // Pass a block with two parameters and a body

print ("-------three ok")
