print "Immutability test start-----------------------------------------"
print "Hello beautiful world-----------------------------------------------------------------"

var zzzObject:= object is immutable{
    var variableZ := 123

}

print ""

zzzObject.variableZ := zzzObject.variableZ + 789

print ""

print "Goodbye cruel world"
