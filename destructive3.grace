print "Destructive test start-------------------------------------------------------------------"
print "Hello beautiful world-----------------------------------------------------------------"


// object example
var a := object {  var aa := 1 }
var b := object { var bb := 2 }
var c := object { var cc := 3}

print (" a.aa is {a.aa} ")
print (" b.bb is {b.bb} ")
print (" c.cc is {c.cc} ")

print "-- destructive read --"
b.bb := {a.aa := c.cc}.apply
// b.bb := (a.aa := c.cc)

print ("--")
print(" a.aa is {a.aa}")
print (" and b.bb is {b.bb} ")

print("Goodbye cruel world")