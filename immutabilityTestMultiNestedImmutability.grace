print "Immutability test start-----------------------------------------"
print "Hello beautiful world-----------------------------------------------------------------"


var zzzObject := object is immutable {
    var nestedObject1 := object {
         var nestedObject2 := object {
             var nestedObject3 := object {
                  var variableZ := 123
             }
         }
    }
}


print ""
print " - nested immutable object created"
print "attempting to mutate nested immutable..."
zzzObject.nestedObject1.nestedObject2.nestedObject3.variableZ := 99


print "Goodbye cruel world"
