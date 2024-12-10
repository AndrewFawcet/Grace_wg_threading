// good test

print ("----starting")


def xObject := object{
    var value :=  1 
}

var block := {x, y -> x.value + y }

print(block.apply(xObject, 10))

print ("----now threading block")
print(block.apply_thread(xObject, 10))

print ("-------fifteen ok")
