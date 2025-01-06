var objectX := object {
    var fieldX : Number := 10
    method getField -> Number {
        fieldX
    }
}

def c1 = spawn { c2 ->
    var objectY := c2.receive
    print "Thread received object with field value: {objectY.getField}"

}

c1.send(objectX)
