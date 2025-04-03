

def a := object {
    def value := 1
}

method b {
    return a
}

print ""
print "assigning a new value from object 'a' using a method"
print ""

def newNumber :=  b.value

print ""
print "some more direct object value requests"
print ""

def n := a.value + a.value + 123
