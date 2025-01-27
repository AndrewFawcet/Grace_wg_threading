print "Banking test start-------------------------------------------------------------------"
print "Hello beautiful bank-----------------------------------------------------------------"
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

// Creating instances of each object
var myImmutable1 := makeImmutable.new("Hello from IMM1!")
var myLocal1 := makeLocal.new(50)
var myIsolated1 := makeIsolated.new(100)

var myImmutable2 := makeImmutable.new("Hello from IMM2!")
var myLocal2 := makeLocal.new(200)
var myIsolated2 := makeIsolated.new(300)

// Main program
print "Immutable variable 1: {myImmutable1.getImmVar}"
print "Local variable 1 before update: {myLocal1.getLocVar}"
myLocal1.updateLocVar(75)
print "Local variable 1 after update: {myLocal1.getLocVar}"
print "Isolated variable 1 before update: {myIsolated1.getIsoVar}"
myIsolated1.updateIsoVar(150)
print "Isolated variable 1 after update: {myIsolated1.getIsoVar}"

print "Immutable variable 2: {myImmutable2.getImmVar}"
print "Local variable 2 before update: {myLocal2.getLocVar}"
myLocal2.updateLocVar(250)
print "Local variable 2 after update: {myLocal2.getLocVar}"
print "Isolated variable 2 before update: {myIsolated2.getIsoVar}"
myIsolated2.updateIsoVar(350)
print "Isolated variable 2 after update: {myIsolated2.getIsoVar}"

print "Grace Example with .self End----------------------------------"

// Thread 1 to work with first object
def c1 = spawn { c2 ->
    var objectY := c2.receive
    print "Thread 1 received immutable object with value: {objectY.getImmVar}"
}

// Thread 2 to work with second object
def c2 = spawn { c3 ->
    var objectZ := c3.receive
    print "Thread 2 received local object, value before: {objectZ.getLocVar}"
    objectZ.updateLocVar(1000)
    print "Thread 2 updated local object, value after: {objectZ.getLocVar}"
}

// Thread 3 to work with third object
def c3 = spawn { c4 ->
    var objectW := c4.receive
    print "Thread 3 received isolated object, value before: {objectW.getIsoVar}"
    objectW.updateIsoVar(500)
    print "Thread 3 updated isolated object, value after: {objectW.getIsoVar}"
}

// Send different objects to different threads
c1.send(myImmutable1)
c2.send(myLocal1)
c3.send(myIsolated1)

print "Main program finished."
