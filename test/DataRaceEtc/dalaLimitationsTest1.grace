// Define an object `x`
var x := object is isolated {
    // Declare methods f and g
    method f {
        print "Method f called"
    }
    
    method g -> Object {
        // Return an object that calls method f
        object {
            method h {
                f  // Call method f from the parent object
            }
        }
    }
}

// Call the method `g` on `x`
def y := x.g

// Spawn a thread using a communication channel
def c := spawn { v ->
    print "Received value: {←v}  .. "
}

// Transfer ownership of `x` using a destructive read
c.send(consume(x))

// Attempt to call `h` on `y`
y.h
