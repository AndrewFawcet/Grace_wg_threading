// testing ref countig for objects propogated by blocks

print ("----starting")


var a := {object { var v := 1}}
var b := a.apply
var c := a.apply


print(c.v)
print ("ref count a {refCount(b)} ...")

print ("-------sixteen ok")
