print "Banking test start-------------------------------------------------------------------"
print "Hello beautiful bank-----------------------------------------------------------------"
print "Grace Example with .self Start--------------------------------"

// Object factory for creating nested objects
var makeNestedObject := object {
    method new(nameValue) -> Object {
        object {
            var name := nameValue

            method getName -> String {
                name
            }
        }
    }
    method newIso(nameValue) -> Object {
        object is iso {
            var name := nameValue

            method getName -> String {
                name
            }
        }
    }
}

// Main object factory with nested object initialization
var makeObject := object {
    method new(value, number, nestedName, nestedIsoName) -> Object {
        object {
            var textField := value   // Initialize with passed value
            var numberField := number // Initialize with passed number
            var nestedObject := makeNestedObject.new(nestedName) // Nested object
            var nestedIsoObject := makeNestedObject.newIso(nestedIsoName) // Nested object
            

            // Getter methods
            method getText -> String {
                textField
            }

            method getNumber -> Number {
                numberField
            }

            method getNestedName -> String {
                nestedObject.getName
            }

            method getNestedIsoName -> String {
                nestedIsoObject.getName
            }
        }
    }
}

// Create an instance with a nested object
var myObject := makeObject.new("Hello Grace!", 42, "Nested Bank Account", "iso Bank Account Object")

// Access fields via methods
print "Text field: {myObject.getText}"
print "Number field: {myObject.getNumber}"
print "Nested object name: {myObject.getNestedName}"
print "Nested object name: {myObject.getNestedIsoName}"

// Create another instance with a different nested object
var myObject2 := makeObject.new("Hello Graceeeeeeeeeeee!", 4242, "Another Nested Account", "another iso Bank Account Object" )

// Access fields via methods
print "Text field: {myObject2.getText}"
print "Number field: {myObject2.getNumber}"
print "Nested object name: {myObject2.getNestedName}"
print "Nested object name: {myObject2.getNestedIsoName}"

print "Grace Example with .self End----------------------------------"
