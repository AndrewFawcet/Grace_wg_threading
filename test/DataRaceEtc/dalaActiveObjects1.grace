
var parent := object {
    // Active Dala object, isolated to ensure exclusive access.
    var activeDala := object is iso {
        method process {
            print "Active Dala processing"
        }

        // Isolated method returning an object still bound to its original isolated state.
        method getResponder -> Object is iso {
            object is iso {
                method respond {
                    print "Responding from isolated responder"
                }
            }
        }
    }

    // Passive Dala object, local scope, does not require isolation.
    def passiveDala := object {
        method respond {
            print "Passive Dala responding {activeDala.getResponder.respond} ..."
        }
    }
}

// Spawn a communication channel for Dala object operations
def c := spawn { v ->
    var receivedDala := v.receive
    print "Received Dala object on thread"
    
    // Attempt to call methods on the received object
    receivedDala.process
    def responder := receivedDala.getResponder
    responder.respond
}

parent.passiveDala.respond
// Ownership transfer of `activeDala` using destructive read
c.send(parent.activeDala := -1)

// Attempting to use the transferred object will now fail
// parent.activeDala.process // Error: `activeDala` has been moved

// Passive Dala now not working
//parent.passiveDala.respond
