// This demonstrates the potential for a method returning a block containing self to leak an iso object, it should fail
print "This demonstrates the potential for a method returning a block containing self to leak an iso object, it should fail"

var a := object is iso {
    var b := 1
    method getLeaker { return { self } }
}

var leakedA := a.getLeaker.apply
print(leakedA.b)

print "-end-"
