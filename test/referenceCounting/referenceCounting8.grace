var a := object {
    var value := 1
}

method b {
    return a
}

var newNumber :=  b   // Call method

print("newNumber value :  {newNumber.value}, (should be 1)")
print("object reference count after method: {refCount(a)}, (currently is 2)")
