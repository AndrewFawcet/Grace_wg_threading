print ""
print "basic use of method to make a new alias. Fundamnetal and should pass"

var a := object {
    var value := 1
}

method b {
    return a
}
print("object reference count before method: {refCount(a)}, (should be 1)")
print ("hasNotionalRef(a) {hasNotionalRef(a)}  .")

var newNumber :=  b   // Call method

print("newNumber value :  {newNumber.value}, (should be 1)")
print("object reference count after method: {refCount(a)}, (should be 2)")
print ("hasNotionalRef(a) {hasNotionalRef(a)}  .")

var c := a
print ""
print("object reference count after alias: {refCount(a)}, (should be 3)")
print ("hasNotionalRef(a) {hasNotionalRef(a)}  .")

b
print ""
print("object reference count after alias: {refCount(a)}, (should be 3)")
print ("hasNotionalRef(a) {hasNotionalRef(a)}  .")

