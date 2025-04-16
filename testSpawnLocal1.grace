print("")
print("  start")

var x := object is iso {
    var a := 10
    var z := object {
        var b := 20
    }
}

def c1 = spawn { c2 ->
    var y := c2.receive
    print "Thread received object with field value: {y.a} .."
    print "Reference Count y: {getRefCount(x)} ..."

}

c1.send(x)
print "Reference Count x: {getRefCount(x)} ..."
print("main end")