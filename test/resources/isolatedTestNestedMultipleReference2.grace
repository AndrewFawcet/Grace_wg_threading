print "Isolated test start-------------------------------------------------------------------"
print "Hello beautiful world-----------------------------------------------------------------"


var objectX := object is isolated{
    var nestedObject1 := object is isolated{
        var nestedObject2 := object is isolated{
            var nestedObject3 := object is isolated{
                var fieldX := 123
            }
        }
    }
}
print ""

var objectY := objectX.nestedObject1.nestedObject2.nestedObject3

print (objectY.fieldX)

print "----"

//this should fail, as now accessing a null reference with destructive reads
print (objectX.nestedObject1.nestedObject2.nestedObject3.fieldX)  


print "+++"
print "Goodbye cruel world"