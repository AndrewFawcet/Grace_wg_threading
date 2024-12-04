// Testing local Capability

print ("----starting")
var block := { 
    var localObject := object is local {
        var field := 42
        method increment { self.field := self.field + 1 }
        method getValue { self.field }
    }
    print("Initial value: {localObject.getValue}")
    localObject.increment
    print("Updated value: {localObject.getValue}")
    
    // Attempt to return localObject (should fail or restrict access outside the block)
    localObject
}

print("Executing block...")
block.apply

print ("-------ten ok")
