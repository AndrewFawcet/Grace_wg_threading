print "Destructive test start-------------------------------------------------------------------"
print "Hello beautiful world-----------------------------------------------------------------"

var x :=  1 

print (" x is {x}")

// var y := { x := 2 }  // may already semantically work
var y := ( x := 2 )
// var y := x
// x := 2


print (" x is after destrutive read {x}")
print (" y is after destrutive read {y}")

print("Goodbye cruel world")