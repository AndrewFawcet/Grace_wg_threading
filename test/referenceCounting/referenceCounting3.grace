print "Hello beautiful world-----------------------------------------------------------------"
// example showing aliasing and method used. Too cluttered to be useful.


var counter := object {
    var value := 1
}


print("value before {counter.value} ...")
print("object reference count before method  {refCount(counter)} ...")
var x := object{
    method referenceCounter {

        print("A")
        print ("Inside method, object reference count {refCount(counter)} ...")
        var alias1 := counter
        print ("Inside method, object reference count {refCount(counter)} ...")
        print("B")
        print ("Inside method, object reference count {refCount(counter)} ...")
        var alias2 := counter
        print ("Inside method, object reference count {refCount(counter)} ...")
        print("C")
        print ("Inside method, object reference count {refCount(counter)} ...")
        var alias3 := counter
        print ("Inside method, object reference count {refCount(counter)} ...")
        print("D")
        print ("Inside method, object reference count {refCount(counter)} ...")
        alias3.value := (alias3.value + 1)
        print ("Inside method, object reference count {refCount(counter)} ...")
        print ("Inside method, value: {alias3.value}, (should be incremented to 2)")
        print ("Inside method, object reference count {refCount(counter)} (zero because inside method)")
        return alias3
    }   
}


print("object reference count after method: {refCount(counter)}, (should be 1)")
var y :=  x
print("object reference count after method: {refCount(counter)}, (should be 1)")
// x.referenceCounter()   // Call method

// var counterAlias :=   x.referenceCounter()   // Call method
print("object reference count after method: {refCount(counter)}, (should be 1)")
print("hasNotionalRef: {hasNotionalRef(counter)}, (should be false)")

print("object reference count after method: {refCount(y)}, (should be 2)")
print "Method finished execution"
print "Goodbye cruel world"