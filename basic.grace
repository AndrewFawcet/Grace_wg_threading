
print "Hello beautiful world-----------------------------------------------------------------"
var xxxObject:= object is isolated{
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

var yyyObject:= object is mushroom{
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
var a := xxxObject
var b := xxxObject
var c := xxxObject
var d := xxxObject
var e := xxxObject

print "after y y"
print ""
var z := yyyObject

//xxxObject.foo()
//xxxObject.foo()
//xxxObject.foo()
//y.foo()

print "Goodbye cruel world"
