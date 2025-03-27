print "Hello beautiful world-----------------------------------------------------------------"

def counter := object is loc {
    var counterValue := 1
}


print("object reference count before method  {refCount(counter)} ...")
var x := object{
    method referenceCounter {

        def alias1 := counter
        print("B")
        def alias2 := counter
        print("C")
        def alias3 := counter
        print("D")
        print ("Inside method, value: {alias3.counterValue}, (should be 1)")
        print ("Inside method, object reference count {refCount(counter)} ...")
        return 123
    }
}

print("E")
var number :=   x.referenceCounter   // Call method
print("F")
print("object reference count after method: {refCount(counter)}, (should be 1)")

print "Goodbye cruel world"