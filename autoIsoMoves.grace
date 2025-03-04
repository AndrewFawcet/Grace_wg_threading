
print "Hello beautiful world-----------------------------------------------------------------"

var objectX := object is iso {
    var variableX := " variable in iso "
}


print ""
print " after 1 - assignment"

var objectY := objectX

print " second alias made to iso "

var objectZ := objectY

print " third alias made to iso"

// print (" this should be an error {objectX.variableX} ...")
// print (" this should be an error {objectY.variableX} ...")
print (" this should be ok {objectZ.variableX} ...")

print " -doneskies- "
