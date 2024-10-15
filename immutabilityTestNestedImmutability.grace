print "Immutability test start-----------------------------------------"
print "Hello beautiful world-----------------------------------------------------------------"


var zzzObject := object is immutable{
    var nestedObject := object {
         var variableZ := 123
    }
}


print ""
print " - nested immutable object created"
print "attempting to mutate nested immutable..."
zzzObject.nestedObject.variableZ := zzzObject.nestedObject.variableZ + 789

print "Goodbye cruel world"
