print "Immutability test start---------------------------------------------------------------"
print "Hello beautiful world-----------------------------------------------------------------"


var objectX := object is immutable{
    var nestedObject1 := object {
         var nestedObject2 := object {
              var cannotChangeMeField := 123
         }
    }
}


print ""
print "attempting to mutate nested immutable that has been assigned to different context"

var dodgyCopy := objectX.nestedObject1.nestedObject2
dodgyCopy.cannotChangeMeField := dodgyCopy.cannotChangeMeField + 456

print (objectX.nestedObject.cannotChangeMeField)

print ""
print "Goodbye cruel world"