

var a := object {
    var value := 1
}

method b {
    return a
}

print ""
print "assigning a new alias to object 'a' NOT using a method"
print ""

var newNumber :=  a
