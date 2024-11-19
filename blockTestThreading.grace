// var myBlock := {x, y -> 
//     print("Running in a new thread!")
//     x + y
// }
// 
// // Wrap the block in a GraceBlock (simulated in runtime)
// var graceBlock := new GraceBlock(null, List.of(new IdentifierDeclaration("x"), new IdentifierDeclaration("y")), List.of(myBlockBody));
// 
// // Apply the block in a thread and print the result
// print(graceBlock.apply(List.of(5, 10))) // Outputs 15

// var block := {x, y -> x + y}  // Define a block with two parameters
// print(block.apply(5, 10))    // Apply the block directly with arguments 5 and 10


var block is thread := { 
    print ("hi")
}  
print(block.apply())   
