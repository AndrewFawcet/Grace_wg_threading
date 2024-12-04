// Testing Threaded Block with Capability Enforcement
print ("----starting")
var block := { x, y ->
    var isolatedObject := object is isolated {
        var field := x + y
        method getField { self.field }
        method increment { self.field := self.field + 1 }
    }
    print("Initial value in thread: {isolatedObject.getField}")
    
    // Modify inside the thread
    isolatedObject.increment
    print("Updated value in thread: {isolatedObject.getField}")
    
    // Attempt to return (should fail or restrict due to isolation)
    isolatedObject
}

print("Executing threaded block...")
block.apply_thread(10, 20)

print ("-------ten ok")
