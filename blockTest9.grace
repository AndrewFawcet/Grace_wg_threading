print ("----starting")
method foo(arg) -> String {
    return "Received: {arg.apply}"
}

print(foo { 42 })
