
print ("----starting")


def xObject := object is local{
    var value :=  1 
}

var block := {x, y -> x.value := x.value + y }
while {xObject.value < 10} do {
    block.apply(xObject, 1)
    print (xObject.value)
}


print ("-------seventeen ok")
