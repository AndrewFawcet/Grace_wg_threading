// Testing immutable Capability
print ("----starting")
var block := {
    var immutableObject := object is immutable {
        var field := 500
        method getField { self.field }
    }
    print("Field value: {immutableObject.getField}")
    
    // Attempt to modify the immutable field
    try {
        immutableObject.field := 1000
        print("This should not print.")
    } catch (e) {
        print("Error: {e.description}")
    }
}

print("Executing block...")
block.apply

print ("-------ten ok")
