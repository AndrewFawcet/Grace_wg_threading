
print "Hello beautiful world-----------------------------------------------------------------"
var xxxObject := object {
    var variableX := 123456

    print ""
    print "before  variableY"
    var variableY := variableX
    print "after  variableY"
    print ""

    method foo {
        print(self.variableX)
        self.variableX := self.variableX + 789
    }
}

print "before y y"
print ""

var y := xxxObject
print "after y y"
print ""

xxxObject.foo()
xxxObject.foo()
xxxObject.foo()
y.foo()

print "Goodbye cruel world"
