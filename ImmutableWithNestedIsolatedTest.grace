print "Isolated and immutable test start-----------------------------------------------------"
print "Hello beautiful world-----------------------------------------------------------------"


var objectX := object is immutable {
    var nestedObject1 := object {
        var nestedObject2 := object { 
            var objectY := object is isolated {
            }
        }
    }
}

print ""
print "Goodbye cruel world"