print "Immutability test start-----------------------------------------"
print "Hello beautiful world-----------------------------------------------------------------"


var zzzObject := object is immutable{
    var nestedObject1 := object {
         var nestedObject2 := object {
              var cannotChangeMe := 123
         }
    }
}


print ""
print "attempting to mutate nested immutable that has been assigned to different context"
var dodgyCopy := zzzObject.nestedObject1.nestedObject2
dodgyCopy.cannotChangeMe := dodgyCopy.cannotChangeMe + 1

print (zzzObject.nestedObject.cannotChangeMe)


print "Goodbye cruel world"
