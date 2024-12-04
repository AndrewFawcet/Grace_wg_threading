// Testing isolated Capability
print ("----starting")
var block := {
    var isolatedObject := object is isolated {
        var field := 100
        method getField { self.field }
        method setField(newValue) { self.field := newValue }
    }
    print("Field value: {isolatedObject.getField}")
    
    // Attempt to assign to another variable
    try {
        var anotherReference := isolatedObject
        print("This should not print.")
    } catch (e) {
        print("Error: {e.description}")
    }
    
    // Modify the isolated object within the block
    isolatedObject.setField(200)
    print("Updated field value: {isolatedObject.getField}")
}

print("Executing block...")
block.apply


print ("-------ten ok")
