// Testing iso objects
print ""
print "Testing iso objects"

method foo {
    var x := object is iso {
        var y := object is iso { 
            var a := 1
        }
    }
    var bb := object { 
        var b := 2
    }
    return x
}
print ""
var z := foo
print ""
foo
print ""
print "-----"
print(" z object reference count after method: {refCount(z)}, (should be 1)")
print(" z.y object reference count after method: {refCount(z.y)}, (should be 1)")
var zz := foo
var zzz := foo
var zzzz := foo
foo
foo
foo
print(" z object reference count after method: {refCount(z)}, (should be 1)")
print(" z.y object reference count after method: {refCount(z.y)}, (should be 1)")
// var zz := z // generates iso capabiility error