print "Isolated and immutable test start-----------------------------------------"
print "Hello beautiful world-----------------------------------------------------------------"


var xxxObject := object is isolated {
    var nestedObject1 := object {
        var nestedObject2 := object { 
            var yyyObject := object is immutable {
                var variableY := 123
            }
        }
    }
}

xxxObject.nestedObject1.nestedObject2.yyyObject.variableY := xxxObject.nestedObject1.nestedObject2.yyyObject.variableY + 987

print "Goodbye cruel world"
