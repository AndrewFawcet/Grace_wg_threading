print "Banking test start-------------------------------------------------------------------"
print "Hello beautiful bank-----------------------------------------------------------------"
print "Grace Example with .self Start--------------------------------"

print "Grace Example with .self Start--------------------------------"

// Generic immutable (IMM) object
var makeImmutable := object {
    method new(value: String) -> Object {
        object is imm {
            var immVar := "" // Initialize immVar with a default value
            method initialize {
                self.immVar := value
            }
            method getImmVar -> String {
                immVar
            }
        }
    }
}

// Generic local (LOC) object
var makeLocal := object {
    method new(value: Number) -> Object {
        object is loc {
            var locVar := 0 // Initialize locVar with a default value
            method initialize {
                self.locVar := value
            }
            method getLocVar -> Number {
                locVar
            }
            method updateLocVar(newValue: Number) {
                locVar := newValue
            }
        }
    }
}

// Generic isolated (ISO) object
var makeIsolated := object {
    method new(value: Number) -> Object {
        object is iso {
            var isoVar := 0 // Initialize isoVar with a default value
            method initialize {
                self.isoVar := value
            }
            method getIsoVar -> Number {
                isoVar
            }
            method updateIsoVar(newValue: Number) {
                isoVar := newValue
            }
        }
    }
}

// Creating instances
var myImmutable := makeImmutable.new("Hello from IMM!")
var myLocal := makeLocal.new(50)
var myIsolated := makeIsolated.new(100)

// Main program
print "Immutable variable: {myImmutable.getImmVar}"
print "Local variable before update: {myLocal.getLocVar}"
myLocal.updateLocVar(75)
print "Local variable after update: {myLocal.getLocVar}"
print "Isolated variable before update: {myIsolated.getIsoVar}"
myIsolated.updateIsoVar(150)
print "Isolated variable after update: {myIsolated.getIsoVar}"

print "Grace Example with .self End----------------------------------"
