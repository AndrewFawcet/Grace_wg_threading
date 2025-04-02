// return method example

var x := object { var object1 }
var y := x
print(" x object reference count after method: {refCount(x)}, (should be 2)")
print(" y object reference count after method: {refCount(y)}, (should be 2)")
method setX(o) {
    x := o
}
setX(object { var object2 })

print(" x object reference count after method: {refCount(x)}, (should be 1)")
print(" y object reference count after method: {refCount(y)}, (should be 1)")


var yy := y
var xx := x

print(" x object reference count after method: {refCount(x)}, (should be 2)")
print(" y object reference count after method: {refCount(y)}, (should be 2)")
