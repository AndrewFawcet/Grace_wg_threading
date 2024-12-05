// Testing local Capability

print ("----starting")

var localObject := object is local {
    var field := 42
}

print (localObject.field)
print ("----starting block")

var block := { 
    print("here in block")
    print (localObject.field)

    localObject.field := localObject.field + 1
    print("Updated value: {localObject.field}")
    
    // Attempt to return localObject (should fail or restrict access outside the block)
    localObject
}

print("Executing block...")
block.apply
block.apply_thread
print ("-------fourteen ok")
