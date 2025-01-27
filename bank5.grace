print "Banking test start-------------------------------------------------------------------"
print "Hello beautiful bank-----------------------------------------------------------------"
print "Grace Example with .self Start--------------------------------"

// Object factory with correct initialization
var makeObject := object {
    method new(value: String, number: Number) -> Object {
        object {
            var textField := value   // Initialize with passed value
            var numberField := number // Initialize with passed number

            // Getter methods
            method getText -> String {
                textField
            }

            method getNumber -> Number {
                numberField
            }
        }
    }
}

// Create an instance
var myObject := makeObject.new("Hello Grace!", 42)

// Access fields via methods
print "Text field: {myObject.getText}"
print "Number field: {myObject.getNumber}"

// Create an instance2
var myObject2 := makeObject.new("Hello Graceeeeeeeeeeee!", 4242)

// Access fields via methods
print "Text field: {myObject2.getText}"
print "Number field: {myObject2.getNumber}"

print "Grace Example with .self End----------------------------------"
