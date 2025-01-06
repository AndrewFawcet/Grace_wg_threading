
print "Hello beautiful world-----------------------------------------------------------------"

var objectX:= object {
    var variableX := 1
    method foo {
        print(self.variableX)
    }
}


objectX.foo()


print "after"
print ""

objectX.variableX := 12

objectX.foo()

print ""

objectX.variableX := objectX.variableX + 12

objectX.foo()


print ""


print "Goodbye cruel world"
