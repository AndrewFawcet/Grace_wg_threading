print "Isolated test start-------------------------------------------------------------------"
print "Hello beautiful world-----------------------------------------------------------------"


var objectX := object is iso {
    var nestedObject1 := object is iso {
        var nestedObject2 := object is iso {
            var nestedObject3 := object is iso {
                var fieldX := 123
            }
        }
    }
}
print ""

print ">>>>"

var objectY := objectX.nestedObject1.nestedObject2

print "<<<<<"

print (objectY.nestedObject3.fieldX)

print "----"

//this should fail, as now accessing a null reference with destructive reads
print (objectX.nestedObject1.nestedObject2.nestedObject3.fieldX)  


print "+++"
print "Goodbye cruel world"