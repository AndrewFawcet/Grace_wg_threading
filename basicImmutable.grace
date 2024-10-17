
print "Hello beautiful world-----------------------------------------------------------------"

var objectX:= object is immutable{
    var variableX := 123

    method foo {
        print(self.variableX)
        self.variableX := self.variableX + 789
    }
}



print "before objectX method call"
print ""

objectX.variableX := objectX.variableX +  1

// objectX.foo()

print ""
print "after objectX method call"
print ""

print "and making a second reference to object to check it still can"
var a := objectX

print "Goodbye cruel world"
