print "Isolated test start-------------------------------------------------------------------"
print "Hello beautiful world-----------------------------------------------------------------"


var objectX := object is isolated{
    var nestedObject1 := object {
        var nestedObject2 := object {
            var nestedObject3 := object {
                var fieldX := 123
            }
        }
    }
}
print ""

var objectY := objectX.nestedObject1.nestedObject2.nestedObject3

print (objectY.fieldX)

print ""
print "Goodbye cruel world"