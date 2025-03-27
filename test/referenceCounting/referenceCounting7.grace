var a := object {
    var value := 1
}

method b {
    return a
}

var newNumber :=  1 + b.value   // Call method

print("newNumber value :  {newNumber}, (should be 2)")
print("object reference count after method: {refCount(a)}, (should be 1)")
