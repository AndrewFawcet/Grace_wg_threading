
print "Hello beautiful world-----------------------------------------------------------------"

var objectX:= object is iso {
    var variableX := " variable in iso "
}


print ""
print " after 1 - assignment"

var objectY := objectX

print " second alias made assignment"

var objectZ := objectY

// print (objectZ.variableX) // will cause capability RuntimeException

(objectY := -1)

print " one alias removed"

// print (objectZ.variableX)    // will cause capability RuntimeException

(objectX := -1)

print " another alias removed"

print (" now acessing the object from a single alias :{objectZ.variableX} ... ")

print ""
