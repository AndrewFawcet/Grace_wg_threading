// testing runtime errors

def myArray = array()
myArray.add("apple")
myArray.add("banana")
myArray.add("cherry")

print(myArray.asString)  // Should print: [apple, banana, cherry]

print(myArray.get(1))    // Should print: banana

print("fruit is {myArray.get(1)}  ..")    // Should print: banana
print("fruits are {myArray.get(0)}  .. {myArray.get(1)}  ..")    // Should print: apple banana

// print(myArray.get(one))    // Should give runtime error
// print(myArray.get(4))    // Should give runtime error
