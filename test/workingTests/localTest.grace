// Define a local (thread-bound) object using "loc".
var objectX := object is loc {
    var fieldX := 10

    // Method to return the field value
    method getField() -> Number {
        return fieldX
    }
}

def c1 = spawn { c2 ->
    // Attempt to receive and use the local object
    var objectY := c2.receive

    // This will fail because `objectY` is a `loc` object and cannot be safely dereferenced in this thread.
    print "Thread received object with field value: {objectY.getField()} ..."
}

// Send the local object to another thread.
// This should trigger a runtime error or failure due to the "local" constraint.
c1.send(objectX)

print("main end")
