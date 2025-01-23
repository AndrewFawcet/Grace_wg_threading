print "Destructive test start-------------------------------------------------------------------"
print "Hello beautiful world-----------------------------------------------------------------"


// object example
var a := object is iso {  var aa := 1 }
var b := object { var bb := 2 }
print ("b is {b.bb} ")
print "--"
b := object { var bb := 4 }
print "||"
print ("b is {b.bb} ")
print "=="
b.bb := {a.aa := 3}.apply
// b := (a := 3)
print "++"
print(" a is {a.aa}")
print (" and b is {b.bb} ")

print("Goodbye cruel world")