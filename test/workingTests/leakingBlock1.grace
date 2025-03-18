// This demonstrates the potential for a method returning a block containing access to a vairable to leak from an iso object, it should fail
print "This demonstrates the potential for a method returning a block containing access to a vairable to leak from an iso object, it should fail"

var a := object is iso {
    var b := 1
    method getLeaker { return { b } }
}

var leakedA := a.getLeaker.apply
print(leakedA)

print "Goodbye cruel world"
