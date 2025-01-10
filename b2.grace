
print "Hello beautiful world-----------------------------------------------------------------"

var objectX:= object is isolated{
    var variableX := 1
}


print ""
print " after 1 - object new ref!!"

var objectY := objectX

print ""
print " after 2 "

// objectX.variableX := 2

print ""
print " after 3 "

print (objectY.variableX)

print ""
print " after 4 "

// print (objectX.variableX)

print ""
print " after 5 "

var objectZ := objectX

print ""
print " after 6 "

print (objectZ.variableX)

print "Goodbye cruel world"
