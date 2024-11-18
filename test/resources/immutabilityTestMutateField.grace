print "Immutability test start---------------------------------------------------------------"
print "Hello beautiful world-----------------------------------------------------------------"


var objectX:= object is immutable{
    var fieldX := 123

}

print ""

objectX.fieldX := objectX.fieldX + 789

print ""
print "Goodbye cruel world"
