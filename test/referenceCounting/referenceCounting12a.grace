
// return method example
print ""
print ""
print ""

var x := object { var object1 }
var y := x

print(" x object reference count before method: {refCount(x)}, (should be 2)")
print(" x object  hasNotionalRef {hasNotionalRef(x)} ")
print(" y object reference count before method: {refCount(y)}, (should be 2)")
print(" y object  hasNotionalRef {hasNotionalRef(y)} ")

method setX(o) {
    x := o
}
setX(object { var object2 })

print(" x object reference count after method: {refCount(x)}, (should be 1)")
print(" x object  hasNotionalRef {hasNotionalRef(x)} .")
print(" y object reference count after method: {refCount(y)}, (should be 1)")
print(" y object  hasNotionalRef {hasNotionalRef(y)} .")


var xx := x
var yy := y

print(" x object reference count after method and with alias: {refCount(x)}, (should be 2)")
print(" x object  hasNotionalRef {hasNotionalRef(x)} .")
print(" y object reference count after method and with alias: {refCount(y)}, (should be 2)")
print(" y object  hasNotionalRef {hasNotionalRef(y)} .")

