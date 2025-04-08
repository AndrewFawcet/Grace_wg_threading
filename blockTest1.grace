// good test

def original := object {
    var name := "Alice"
}

def makeAlias := { -> original }  // block with no parameters, returns original

def alias := makeAlias.apply     // apply the block to get a reference

print("Alias name is: {alias.name}")

print ("-------fifteen ok")
