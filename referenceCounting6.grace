var a := object {
    var value := 1
}
var x := object{
    method aMethod {
        return a.value
    }   
}

var newNumber :=  1 + x.aMethod()   // Call method

print("newNumber value :  {newNumber}, (should be 2)")
print("object reference count after method: {refCount(a)}, (should be 1 or 2?, currently is 1)")
