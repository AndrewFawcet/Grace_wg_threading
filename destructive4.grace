print "Destructive test start-------------------------------------------------------------------"
print "Hello beautiful world-----------------------------------------------------------------"


// iso object example
var a := object is iso {  var aa := 1 }
var b := object { var bb := 2 }
var c := object { var cc := 3}

print (" a.aa is {a.aa} ")
print (" b.bb is {b.bb} ")
print (" c.cc is {c.cc} ")

print "-- destructive read --"
// b := {a := c}.apply
b := (a := c)

print ("--")
print(" a.cc is {a.cc}")
print (" and b.aa is {b.aa} ")

var d := a
print ("now accessing 'a' object fields through d.cc  {d.cc}")
var e := b  // this will not work as object b has inherited the iso capability
print ("now accessing 'b' object fields through e.aa  {e.aa}")

print("Goodbye cruel world")