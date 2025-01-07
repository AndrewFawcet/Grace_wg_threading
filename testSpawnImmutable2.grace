// new reference to an immutable object then attempting to change via new reference

var objectX := object is immutable{
    var fieldX : Number := 10
    method getField -> Number {
        fieldX
    }
}

def c1 = spawn { c2 ->
    var objectY := c2.receive
    print "Thread received object with field value: {objectY.getField}"
    objectY.fieldX := 20
    print "Thread received object with new field value: {objectY.getField}"
    
}

c1.send(objectX)
print(" main end ")