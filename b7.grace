
print "Hello beautiful world-----------------------------------------------------------------"

var objectX:= object {
    var variableX := 1
    method foo {
        print(self.variableX)
    }
}

print "setting object to local"
setLoc (objectX)
objectX.foo()

print "setting object to iso"
setIso(objectX)
objectX.foo()


print ""
def c1 = spawn { c2 ->
    var objectY := c2.receive
    print "Thread received object with field value: {objectY.variableX}"
    objectY.foo()
    print "setting object to local on new thread"
    setLoc (objectY)
    objectY.foo()
    
}

print ""

c1.send(objectX := -1)
print ""
print ""
// objectX.foo()


print "Goodbye cruel world"
