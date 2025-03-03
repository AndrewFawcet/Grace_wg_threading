// this demonstrated is dereferencing and the racy kind of conditions that can incur with enforcing it.
// the iso has multiple aliases, and is sent to another thread, the aliases are subsequently deleted
// it is only the time it takes to send and intialise a new thread that causes this not to be an iso capability violation 

var objectX:= object is iso {
    var variableX := " variable in iso "
}


print ""
print " object initialised {objectX.variableX} ..."

def c1 = spawn { c2 ->
    var objectA := c2.receive
    print " Thread received object with field value: {objectA.variableX}"

}


var objectY := objectX
print " second alias made "

var objectZ := objectY
print " third alias made "

c1.send(objectZ)
print " third alias sent to other thread "

// print (objectZ.variableX) // will cause capability RuntimeException

(objectY := -1)
print " one alias removed"

// print (objectZ.variableX)    // will cause capability RuntimeException

(objectX := -1)
print " another alias removed"

print (" now acessing the object from a single alias :{objectZ.variableX} ... ")
print ""

print " now removing alias from main thread"
(objectZ := -1)

