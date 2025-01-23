print "Destructive test start-------------------------------------------------------------------"
print "Hello beautiful world-----------------------------------------------------------------"


// object example
var a := object {  var aa := 1 }
var b := object { var bb := 2 }
var c := object { var cc := 3}

print (" b is {b.bb} ")
print "--"

// b.bb := {a.aa := 3}.apply
// b := {a := c}.apply
b := (a := c)

print ("herere")

// b := (a := 3)
// b := (a := 3)
print "++"
print(" a.cc is {a.cc}")
print (" and b.aa is {b.aa} ")

print("Goodbye cruel world")