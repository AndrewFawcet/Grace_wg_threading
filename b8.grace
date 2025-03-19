
print "Hello beautiful world-----------------------------------------------------------------"

var counter := object is loc {
    var value := 0
    method increment { value := value + 1 }
    method getValue { value }
}

method referenceCounter {
    var localObj := counter  // Create a new object (Reference count: 1)

    // Additional references inside the method scope
    var alias1 := localObj       // Reference count: 2
    var alias2 := localObj       // Reference count: 3
    print("here")
    alias1.increment            // Modify the object
    print ("Inside method, value: {alias2.getValue} ...")
}   // End of method → localObj, alias1 and alias2 go out of scope

referenceCounter()   // Call method

// At this point, localObj should be garbage collectible if there are no external references
print "Method finished execution"



print "Goodbye cruel world"
