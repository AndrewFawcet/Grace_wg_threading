
print "Hello beautiful world-----------------------------------------------------------------"

var objectX:= object is local {
    var variableX := 1
}

var objectZ := object {
}


print ""
print " after 1 - object new ref!!"

var objectY := objectX

print ""
print " after 2 "

var A := 1

print ""
print " after 3 "

var B := A

print ""
print " after 4 "

print (B)
print (objectX.variableX)

print ""
print " after 5 "

objectZ := objectX

print ""
print " after 6 "

print (objectZ.variableX)

print "Goodbye cruel world"
