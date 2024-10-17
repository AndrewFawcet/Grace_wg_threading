
print "Hello beautiful world-----------------------------------------------------------------"
var objectX:= object is immutable isolated{
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

var objectY:= object is isolated immutable{
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

var y := objectX


print "after y y"
print ""
var z := objectY

//objectY.foo()
//objectY.foo()
//objectY.foo()
//y.foo()

print "Goodbye cruel world"
//