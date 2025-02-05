var x := object {
    var message := "Hello from x!"
}

var y := object {
    var message := "Hello from y!"
}

var z := object {
    var message := "Hello from z!"
}

print " x is now {x.message} .. "
print " y is now {y.message} .. "
print " z is now {z.message} .. "

var x := (y := z)

print "-- after destructive read --" 

print " x is now {x.message} .. "
print " y is now {y.message} .. "
print " z is now {z.message} .. "
