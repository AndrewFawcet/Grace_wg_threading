
print "Testing auto iso moves"

var objectX := object is iso {
    var objectY := object is iso {
        var objectZ := object is iso {
            var v := " variable in iso "
        }
    }
}


print ""
print " after assignment with {objectX.objectY.objectZ.v} ..."

var objectNew1 := object is iso {
    var objectNew2 := -1
}

objectNew1.objectNew2 := objectX.objectY.objectZ
print " alias made to iso "

// print (" this should be an error {objectX.objectY.objectZ.v} ...")
print (" this should be ok {objectNew1.objectNew2.v} ...")

print " -doneskies- "
