
print "Hello beautiful world-----------------------------------------------------------------"

print "Hello ---------------------------aaa--------------------------------------"
var aaaObject := object {
    var variableA := 123456
    method foo {
        print(self.variableA)
        self.variableA := self.variableA + 789
    }
    print (self.variableA)
}

print "Hello ---------------------------bbb--------------------------------------"

var bbbObject := object {
    var variableB := 654321
    method foo {
        print(self.variableB)
        self.variableB := self.variableB + 987
    }
    print (self.variableB)
}

print "Hello ---------------------------ccc--------------------------------------"

var cccObject := object {
    var variableC := 123456
    method foo {
        print(self.variableC)
        self.variableC := self.variableC + 789
    }
    print (self.variableC)
}

print "Hello ---------------------------ddd--------------------------------------"

var dddObject := object {
    var variableD := 654321
    method foo {
        print(self.variableD)
        self.variableD := self.variableD + 987
    }
    print (self.variableD)
}

print "Hello ---------------------------xxx--------------------------------------"

var xxxObject := object {
    var variableX := 123456
    method foo {
        print(self.variableX)
        self.variableX := self.variableX + 789
    }
    print (self.variableX)
}

print "Hello ---------------------------yyy--------------------------------------"

var yyyObject := object {
    var variableY := 654321
    method foo {
        print(self.variableX)
        self.variableY := self.variableX + 987
    }
    print (self.variableY)
}


print "before x y"
print ""

var x := xxxObject
var y := yyyObject

print "after x y"
print ""

xxxObject.foo()
xxxObject.foo()
xxxObject.foo()
y.foo()

print "Goodbye cruel world"
