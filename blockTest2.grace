// old and junky

print ("----starting")


def a = object is local{
    var value :=  1 
}

var block := {x, y -> x + y }

print(block.apply(a.value, 10))
print(block.apply(a.value, 10))

var b := { x -> x }

var c := b.apply(8)
print (c)

var d := {9}
var e := d
print(e.apply)

var f := {object { var g := 1}}
var h := f
print(h.apply.g)


print ("-------sixteen ok")
