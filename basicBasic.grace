
print "Hello beautiful world-----------------------------------------------------------------"

print "Hello ---------------------------aaa--------------------------------------"
var objectA := object {
    var variableA := 123456
    method foo {
        print(self.variableA)
        self.variableA := self.variableA + 789
    }
    print (self.variableA)
}

// objectA.(var variableB := 456)

print "before x y"
print ""

var x := objectA
var y := objectA

print "after x y"
print ""


print "Goodbye cruel world"
