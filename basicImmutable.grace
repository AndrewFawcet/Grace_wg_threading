
print "Hello beautiful world-----------------------------------------------------------------"

var zzzObject:= object is immutable{
    var variableZ := 123

    method foo {
        print(self.variableZ)
        self.variableZ := self.variableZ + 789
    }
}



print "before zzzObject method call"
print ""

zzzObject.foo()

print ""
print "after zzzObject method call"
print ""

print "and making a second reference to object to check it still can"
var a := zzzObject

print "Goodbye cruel world"
