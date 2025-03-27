// Michael example

print "michael example"


method foo {
    def x := object {
        def y := object { 
            var a := 1
        }
    }
    var a := object { 
        var b := 2
    }
    return x
}
def z := foo
print(" z object reference count after method: {refCount(z)}, (should be 1 or 2?, currently is 1)")
