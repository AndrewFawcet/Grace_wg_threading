

var a := object {
    var value := 1
}

method b {
    return a
}

print ""
print "assigning a new value from object 'a' using a method"
print ""

var newNumber :=  b.value

print ""
print "some more direct object value requests"
print ""

var n := a.value + a.value + 123
