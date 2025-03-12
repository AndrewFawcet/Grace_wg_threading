
print "Hello beautiful world-----------------------------------------------------------------"

var objectX:= object {
    var variableX := 1
    method foo {
        print(self.variableX)
    }
}

print ""
// setLocal (objectX)
print ""
def c1 = spawn { c2 ->
    var objectY := c2.receive
    print "Thread received object with field value: {objectY.variableX}"
    objectY.foo()
}

objectX.foo()
print ""
print ""

c1.send(objectX)
print ""
print ""
objectX.foo()


print "Goodbye cruel world"
