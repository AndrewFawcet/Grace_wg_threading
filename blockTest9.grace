print ("----starting")
method foo (arg: Block) -> String is threaded{
    return "Received: {arg.apply}"
}

print(foo { 42 })



def y = object {

    method bar (a : Block)  -> Number {
        var value := a.apply_thread 
        value := value + 1
        print(value)
        return value
    } 
}

print (y.bar {123})

print ("-------two ok")

var block := {x, y -> x + y }
print(block.apply_thread(5, 10))