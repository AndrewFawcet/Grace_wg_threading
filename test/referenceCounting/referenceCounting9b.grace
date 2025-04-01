// Michael example

print ""
print "michael example"
print "using def"

method foo {
    def x := object {
        def y := object { 
            var a := 1
        }
    }
    def a := object { 
        var b := 2
    }
    return x
}

print ""
def z := foo
print(" z object reference count after method: {refCount(z)}, (should be 1)")
print(" z.y object reference count after method: {refCount(z.y)}, (should be 1)")

def z := foo

print(" z object reference count after method called twice on same def: {refCount(z)}, (should be 1)")
print(" z.y object reference count after method called twice on same def: {refCount(z.y)}, (should be 1)")
