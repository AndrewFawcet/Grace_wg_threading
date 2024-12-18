print ("----starting")


def xObject := object{
    var value :=  1 
}

var block := {x, y ->  while {x.value < 1000} do {
        x.value := x.value + y print (xObject.value)
        } 
    }
block.apply_thread(xObject, 1)
block.apply_thread(xObject, 1)
block.apply_thread(xObject, 1)
block.apply_thread(xObject, 1)
print ("final value is ")
print (xObject.value)
print ("-------test ok")