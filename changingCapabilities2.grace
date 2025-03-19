//  so fundamentally bad that it shouldn't be considered
var a := object is imm {
    var b := 1
}

print ""
// a.b := 2 // this would be a runtime capability error 
print "object a field b : {a.b}..." // outputs 1 as an imm

setIso (a)
a.b := 2
setImm (a)

print "object a field b : {a.b}..." // outputs 2 as an imm
