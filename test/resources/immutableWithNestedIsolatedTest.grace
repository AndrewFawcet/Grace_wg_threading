print "Isolated and immutable test start-----------------------------------------------------"
print "Hello beautiful world-----------------------------------------------------------------"


var objectX := object is immutable {
    var nestedObject1 := object is immutable {
        var nestedObject2 := object is immutable { 
            var objectY := object is isolated {
            }
        }
    }
}

print ""
print "Goodbye cruel world"