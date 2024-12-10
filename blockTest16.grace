// old and junky

print ("----starting")


def xObject = object is local{
    var value :=  1 
}

var block := {x, y -> x + y }

print(block.apply(xObject.value, 10))

print ("----now threading block")
print(block.apply_thread(xObject.value, 10))


// var block := {fetchX, y -> fetchX() + y }

// print(block.apply({xObject.value}, 10))

// print("----now threading block++")
// print(block.apply_thread({xObject.value}, 10))


print ("-------sixteen ok")
