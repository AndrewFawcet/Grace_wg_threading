print "Hello beautiful world-----------------------------------------------------------------"
print "using defs not var"

def counter := object is loc {
    var value := 1
    method increment { value := value + 1 }
    method getValue { value }
}


print("value before {counter.getValue} ...")
print("object reference count before method  {refCount(counter)} ...")
var x := object{
    method referenceCounter {

        print("A")
        def alias1 := counter
        print("B")
        def alias2 := counter
        print("C")
        def alias3 := counter
        print("D")
        alias3.increment
        print ("Inside method, value: {alias3.getValue}, (should be incremented to 2)")
        print ("Inside method, object reference count {refCount(counter)} ...")
        return 123
    }
}

print("E")
print("EE")
def aliasCounter :=   x.referenceCounter()   // Call method
print("F")
print("object reference count after method: {refCount(counter)}, (should be 2)")
// At this point, localObj, alias1 and alias2 should be garbage collected, refernce count for object should be 2
print "Method finished execution"
print "Goodbye cruel world"