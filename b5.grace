print "Isolated test start-------------------------------------------------------------------"
print "Hello beautiful world-----------------------------------------------------------------"

// not sure what this should prove?


var x := object is iso {
    method asString { "Hello, World!" }
}
var z := object is iso {
    var inner
}
var y := z
y.inner := x
print(y.inner)
print(x)


print "Goodbye cruel world"