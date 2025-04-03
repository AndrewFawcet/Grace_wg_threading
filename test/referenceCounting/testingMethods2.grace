
var a := object {
    var value := 1
}

method b {
    return a
}

print ""
print "assigning a new alias to object 'a' using a method"
print ""

var newNumber :=  b

print ""
print "makeing a method call without assigning it"
print ""

b
