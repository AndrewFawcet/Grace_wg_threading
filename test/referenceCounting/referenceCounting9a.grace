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

def b := foo

print(" b object reference count after method: {refCount(b)}, (should be 2)")
print(" b.y object reference count after method: {refCount(b.y)}, (should be 2)")
