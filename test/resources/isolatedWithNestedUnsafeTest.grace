print "Isolated test start-------------------------------------------------------------------"
print "Hello beautiful world-----------------------------------------------------------------"


var objectX := object is isolated {
    var nestedObject1 := object is isolated {
        var nestedObject2 := object is isolated { 
            var objectY := object {
                var fieldY := 123
            }
        }
    }
}

print""
print "Goodbye cruel world"
