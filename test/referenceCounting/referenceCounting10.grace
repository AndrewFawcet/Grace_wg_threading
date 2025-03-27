// Michael example

print ""
print "michael example"
print "using var"

method foo {
    var x := object {
        var y := object { 
            var a := 1
        }
    }
    var a := object { 
        var b := 2
    }
    return x
}
var z := foo
print(" z object reference count after method: {refCount(z)}, (should be 1, currently is 1)")
print(" z.y object reference count after method: {refCount(z.y)}, (should be 1, currently is 0 fix!!)")
