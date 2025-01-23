print "Destructive test start-------------------------------------------------------------------"
print "Hello beautiful world-----------------------------------------------------------------"


// variable example
var x :=  1 
var y := 3
print (" x is {x}")
print (" y is {y}")

print "-- destructive read --"
// y :=  { x := 2 }.apply // works for destructive read!
// y :=  { x := 2 }
y :=  ( x := 2 ) // works for destructive read!

print "--"
print (" x is {x}")
print (" y is {y}")

print("Goodbye cruel world")