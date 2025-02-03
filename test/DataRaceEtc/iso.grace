print "Isolated test start-------------------------------------------------------------------"
print "Hello beautiful world-----------------------------------------------------------------"

// not sure what this should prove?


var x := object {
    var xx := 3
    method setXX(newValue : Number) {
        xx := newValue
    }
}

print("{x.xx}")   // Prints the current value of x.xx (should be 3)

x.setXX(42)       // Explicit request: calling setXX on x with 42 as an argument

print("{x.xx}")   // Prints the updated value of x.xx (should now be 42)

print("Goodbye cruel world")