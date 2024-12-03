
def y = object {

    method bar(a : Block) -> Number {
        var value := a.apply
        value := value + 1
        print(value)
        return value
    }
}

print (y.bar {123})

print ("-------two ok")
