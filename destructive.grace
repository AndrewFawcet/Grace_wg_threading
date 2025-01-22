print "Destructive test start-------------------------------------------------------------------"
print "Hello beautiful world-----------------------------------------------------------------"

var a := object {  1 }
var b := object { 2 }
b :=  (a := 3)
print(" a is {a}")
print (" and b is {b} ")



var x :=  1 
var y := 3
print (" x is {x}")
print (" y is {y}")

y :=  ( x := 2 )
// y := { x := 2 }  // may already semantically work
// var y := ( x := 2 ).apply

print (" x is after destructive read {x}")
print (" y is after destructive read {y}")


var z := (5)
print (" and z is {z}")

print("Goodbye cruel world")