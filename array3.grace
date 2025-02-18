def myArray = array()
myArray.add(123)
myArray.add(456)
myArray.add(789)

print(myArray.asString)  // Should print: [apple, banana, cherry]

print(myArray.get(1))    // Should print: 456
var x := myArray.get(0)  + myArray.get(1) + myArray.get(2)
print(" array 0 + 1 + 2 is {x}  ..")    
print(" array 0 + 1 + 2 is {myArray.get(0)  + myArray.get(1) + myArray.get(2)}  ..")  
