
print "Hello beautiful world-----------------------------------------------------------------"

print "For loop example:"
var i := 5
if (i == 5) then {
    print "i = {i} .. in brackets"
}

print "While loop example:"
var counter := 1
while {counter <= 5} do {
    print "counter = {counter}  .."
    counter := counter + 1
}

print "Multiplication table:"
var j := 1
var k := 1

while {j < 4} do {
    while {k < 4} do {
        print "{j}"
        print "{k}"
        print " = {k * j}  ,,"
        j := j + 1
        k := k + 1
    }
}

var x := object {
    method checkValue(newValue : Number) {
        if (newValue < 5) then {
            print " newValue = {newValue} and is less than 5" 
        } else {
            print " newValue = {newValue} and is greater than 5" 
        }
    }
}
x.checkValue(6)
x.checkValue(4)

method checkMeth(newValue : Number) {
    if (newValue < 5) then {
        print " checkMeth newValue = {newValue} and is less than 5" 
    } else {
        print " checkMeth newValue = {newValue} and is greater than 5" 
    }
}


checkMeth(9)
checkMeth(1)

print "Goodbye cruel world"
