print "Isolated test start-------------------------------------------------------------------"
print "Hello beautiful world-----------------------------------------------------------------"


var objectX := object is isolated {
    var nestedObject1 := object {
        var nestedObject2 := object { 
            var objectY := object is immutable {
                var fieldY := 123
            }
        }
    }
}
print""

objectX.nestedObject1.nestedObject2.objectY.fieldY := objectX.nestedObject1.nestedObject2.objectY.fieldY + 987

print""
print "Goodbye cruel world"
