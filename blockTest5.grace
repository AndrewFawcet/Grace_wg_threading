
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

print ("-------six ok")
