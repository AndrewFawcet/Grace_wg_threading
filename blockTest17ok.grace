print ("----starting")


def xObject := object{
    var value :=  1 
}

var block := {x, y ->  while {x.value < 100} do {
        x.value := x.value + y} 
    }
block.apply_thread(xObject, 1)
block.apply_thread(xObject, 1)
block.apply_thread(xObject, 1)
block.apply_thread(xObject, 1)
print (xObject.value)

print ("-------seventeen ok")