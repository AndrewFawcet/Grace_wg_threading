// Define an isolated object with a field and a method.
var objectX := object is iso {
    var fieldX := 123456

    method foo {
        // Print the current value.
        print("fieldX =  {self.fieldX}  ")
        // Modify the field.
        self.fieldX := self.fieldX + 789
    }
}

print("")
print(objectX.foo)
print("")

// Transfer the capability by assigning objectX to objectY.
var objectY := (objectX := -1)

// Calling foo via objectY works.
print("Calling foo via objectY:")
print(objectY.fieldX)
objectY.foo


// Now objectX has been consumed by the transfer, so this next call should fail.
// It attempts to access a null reference because the isolated object has moved via destructive read.
print("Calling foo via objectX (should fail as a destructive read has removed the reference):")
// print(objectX.fieldX)
// objectX.foo
