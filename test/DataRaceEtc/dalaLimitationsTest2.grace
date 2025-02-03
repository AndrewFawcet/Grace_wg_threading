// Define an object `x` 
// The object `x` is intended to be accessible only in its original scope.
var x := object is iso {
    // Declare methods f and g
    method f {
        print "Method f called"
    }
    
    // `h` implicitly captures the lexical scope of `x`, which includes access to method `f`.
    // This captures the outer scope even when it is supposed to be "isolated."
    method g -> Object {
        // Return an object that calls method f
        object {
            method h {
                f  // Call method f from the parent object
            }
        }
    }
}

// Store the result of `x.g()` in `y`. 
// Note: `y` now retains access to `x`'s scope through implicit lexical capture,
// violating the intended constraints of `isolated` objects
def y := x.g

print("--")
y.h     // "Method f called"
print("--")

// Spawn a thread using a communication channel
def c := spawn { v ->
    var xThread := v.receive
    // print "Received value: {xThread}  .. "
    print ("on thread")
    xThread.g.h
    xThread.f
    print "In thread and calling {xThread.g.h} from thread "
}

// Transfer ownership of `x` using a destructive read
c.send(x := -1) 

// Attempt to call `h` on `y`

y.h
y.h
y.h
// x.f // this will fail as iso object has moved.

