// seems to be doig calculations prior to going into the thread, thus not accessing the local in the other thread.

print ("----starting")


def xObject = object is local{
    var value :=  1 
}

var block := {x, y -> x.value + y }

print(block.apply(xObject, 10))

print ("----now threading block")
print(block.apply_thread(xObject, 10))

print ("-------fifteen ok")
