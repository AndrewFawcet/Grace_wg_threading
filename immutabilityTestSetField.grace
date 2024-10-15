print "Immutability test start-----------------------------------------"
print "Hello beautiful world-----------------------------------------------------------------"

var zzzObject:= object is immutable{
    var variableZ := 123

    method foo {
        print(self.variableZ)
        self.variableZ := self.variableZ + 789
    }
}

print ""
set zzzObject.variableA := 123
//var zzzObject.variableA := 123
// zzzObject.variableZ := 456

print ""

print "Goodbye cruel world"
