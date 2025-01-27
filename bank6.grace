print "Banking test start-------------------------------------------------------------------"
print "Hello beautiful bank-----------------------------------------------------------------"
print "Grace Example with .self Start--------------------------------"

// Object factory using .self for initialization
var makeObject := object {
    method new(value: String, number: Number) -> Object {
        object {
            var textField := ""     // Initialized with a default value
            var numberField := 0   // Initialized with a default value

            // Initialize fields explicitly
            method initialize {
                self.textField := value
                self.numberField := number
            }

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

print "Grace Example with .self End----------------------------------"
