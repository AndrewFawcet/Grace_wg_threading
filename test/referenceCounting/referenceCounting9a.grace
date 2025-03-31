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

print "doing z := foo"
def z := foo
print(" z object reference count after method: {refCount(z)}, (should be 1)")
print(" z.y object reference count after method: {refCount(z.y)}, (should be 1)")


print "doing zz := foo"
def zz := foo
print(" zz object reference count after method: {refCount(zz)}, (should be 2)")
print(" zz.y object reference count after method: {refCount(zz.y)}, (should be 1)")

print "doing zzz := foo"
def zzz := foo
print(" zzz object reference count after method: {refCount(zzz)}, (should be 3)")
print(" zzz.y object reference count after method: {refCount(zzz.y)}, (should be 1)")
