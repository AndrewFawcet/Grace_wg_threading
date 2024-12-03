
// var block := {x, y -> x + y}  // Define a block with two parameters
// print(block.apply(5, 10))    // Apply the block directly with arguments 5 and 10

// print ("-------seven ok")


var y : Number := 1
method foo(arg ) -> String {
    self.y := arg.apply
    return "y: {y}!"
}

print(foo { 2 })

print ("-------eight ok")
