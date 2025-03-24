print "Hello beautiful world-----------------------------------------------------------------"

var counter := object is loc {
    var value := 0
    method increment { value := value + 1 }
    method getValue { value }
}

print("value before {counter.getValue} ...")

method referenceCounter {
    // Additional references inside the method scope
    print("A")
    var alias1 := counter       // Reference the object, Reference count: 2
    print("B")
    var alias2 := counter       // Reference count: 3
    print("C")
    var alias3 := counter       // Reference count: 4
    print("D")
    alias3.increment            // Modify the object
    print ("Inside method, value: {alias3.getValue} ...")
}   // End of method → alias1, alias2 and alias3 go out of scope

print("E")
print("EE")
referenceCounter()   // Call method
print("F")

// At this point, localObj, alias1 and alias2 should be garbage collected, reference count for object should be 1
print "Method finished execution"
print "Goodbye cruel world"