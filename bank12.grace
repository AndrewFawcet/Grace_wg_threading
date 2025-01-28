print "Grace Example with ISO object and Destructive Read Start--------------------------------"

// Create a generic isolated (ISO) object
var makeIsolated := object {
    method new(value: Number) -> Object {
        object is iso {
            var isoVar := 0
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

// Create an instance of an isolated object
var x := makeIsolated.new(42)

// Spawn a thread to receive and manipulate the isolated object
def c1 = spawn { c2 ->
    var objectW := ( c2.receive )
    print "Thread received ISO object with value: {objectW.getIsoVar}"
    objectW.updateIsoVar(100)
    print "Thread updated ISO object, new value: {objectW.getIsoVar}"
}

// Use a destructive read to send the ISO object across the thread
// myIsolated := (x := makeIsolated.new(99)) // Move object to new reference

// Send the moved ISO object to the thread
c1.send( x := -1 )

print "Thread destructively sent ISO object with value now as an int : {x}"

print "Grace Example with ISO object and Destructive Read End--------------------------------"
