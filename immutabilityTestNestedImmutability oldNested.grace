print "Immutability test start---------------------------------------------------------------"
print "Hello beautiful world-----------------------------------------------------------------"


var objectX := object is immutable{
    var nestedObject := object {
         var fieldX := 123
    }
}


print ""
print " - nested immutable object created"
print "attempting to mutate nested immutable..."

objectX.nestedObject.fieldX := objectX.nestedObject.fieldX + 789


print ""
print "Goodbye cruel world"
