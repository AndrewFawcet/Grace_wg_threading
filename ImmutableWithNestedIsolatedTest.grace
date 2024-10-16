print "Isolated and immutable test start-----------------------------------------"
print "Hello beautiful world-----------------------------------------------------------------"


var xxxObject := object is immutable {
    var nestedObject1 := object {
        var nestedObject2 := object { 
            var yyyObject := object is isolated {
            }
        }
    }
}


print "Goodbye cruel world"
