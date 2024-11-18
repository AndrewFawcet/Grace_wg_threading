print "Immutability test start---------------------------------------------------------------"
print "Hello beautiful world-----------------------------------------------------------------"


var objectX := object is immutable {
    var nestedObject1 := object is immutable {
         var nestedObject2 := object is immutable {
             var nestedObject3 := object is immutable {
                  var fieldX := 123
             }
         }
    }
}

print ""
print " - nested immutable object created"
print "attempting to mutate nested immutable..."

objectX.nestedObject1.nestedObject2.nestedObject3.fieldX := 987

print ""
print "Goodbye cruel world"