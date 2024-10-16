
print "Hello beautiful world-----------------------------------------------------------------"
var xxxObject := object is isolated{
       var nestedObject1 := object {
         var nestedObject2 := object {
             var nestedObject3 := object {
                  var variableZ := 123
             }
         }
    }
}
print ""

var yyyObject := xxxObject.nestedObject1.nestedObject2.nestedObject3

print (yyyObject.variableZ)

print ""

print "Goodbye cruel world"