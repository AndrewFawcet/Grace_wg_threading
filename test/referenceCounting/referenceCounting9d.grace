// Michael example

print ""
print "michael example"
print "using def"

method foo {
    // var o := object { var v := 1 }
    return object { var v := 1 }
}

print ""
def z := foo
print(" z object reference count after method: {refCount(z)}, (should be 1)")
print (" hasNotionalRef {hasNotionalRef(z)}  ...")
print(z.v)


print ""
print "dropping on floor"
foo