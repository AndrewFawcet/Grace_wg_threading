print "Banking test start-------------------------------------------------------------------"
print "Hello beautiful bank-----------------------------------------------------------------"

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
    method newLoc(nameValue) -> Object {
        object is loc {
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
    method newImm(nameValue) -> Object {
        object is imm {
            var name := nameValue

            method getName -> String {
                name
            }
        }
    }

}

// Main object factory with nested object initialization
var makeObject := object {
    method new(value, number, nestedName, nestedLocName, nestedIsoName, nestedImmName) -> Object {
        object {
            var textField := value   // Initialize with passed value
            var numberField := number // Initialize with passed number
            var nestedObject := makeNestedObject.new(nestedName) // Nested object
            var nestedLocObject := makeNestedObject.newLoc(nestedLocName) // Nested loc object
            var nestedIsoObject := makeNestedObject.newIso(nestedIsoName) // Nested iso object
            var nestedImmObject := makeNestedObject.newImm(nestedImmName) // Nested imm object

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

            method getNestedLocName -> String {
                nestedLocObject.getName
            }

            method getNestedIsoName -> String {
                nestedIsoObject.getName
            }

            method getNestedImmName -> String {
                nestedImmObject.getName
            }

        }
    }
}

// Create an instance with a nested object
var myObject := makeObject.new("Hello Grace!", 42, "Nested Bank Account", "loc Bank Account Object", "iso Bank Account Object", "imm Bank Account Object")

// Access fields via methods
print "Text field: {myObject.getText}"
print "Number field: {myObject.getNumber}"
print "Nested object name: {myObject.getNestedName}"
print "Nested object name: {myObject.getNestedLocName}"
print "Nested object name: {myObject.getNestedIsoName}"
print "Nested object name: {myObject.getNestedImmName}"

// Create another instance with a different nested object
var myObject2 := makeObject.new("Hello Graceeeeeeeeeeee!", 4242, "Another Nested Account", "another loc Bank Account Object", "another iso Bank Account Object" , "another imm Bank Account Object" )

// Access fields via methods
print "Text field: {myObject2.getText}"
print "Number field: {myObject2.getNumber}"
print "Nested object name: {myObject2.getNestedName}"
print "Nested object name: {myObject2.getNestedLocName}"
print "Nested object name: {myObject2.getNestedIsoName}"
print "Nested object name: {myObject2.getNestedImmName}"
var normalOb := myObject2.nestedObject
print (" normalOb alias {normalOb.name} ...")
var locOb := myObject2.nestedLocObject
print (" locOb alias {locOb.name} ...")
locOb.name := "new locObName"
print (" locOb alias {locOb.name} ...")

// var isoOb := myObject2.nestedIsoObject  // Capability Violation: Isolated object
// print (" isoOb alias {isoOb.name} ...")

var immOb := myObject2.nestedImmObject
print (" immOb alias {immOb.name} ...")
// immOb.name := "new immObName" //  Capability Violation: Immutable object

def c1 = spawn { c2 ->
    var myObject2NewThread := c2.receive
    print "on new thread"
    print " Thread received object with field value: {myObject2NewThread.getNestedName} ..."
    print " Thread received object with field value: {myObject2NewThread.getNestedImmName} ..."
    print " Thread received object with field value: {myObject2NewThread.getNestedIsoName} ..."
    //    print " Thread received object with field value: {myObject2NewThread.getNestedLocName} ..." // Capability Violation: Local object

}

c1.send(myObject2)


print "Grace Example End----------------------------------"
