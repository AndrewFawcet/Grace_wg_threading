// not operating asynchronously
// isolated counter asynchronously influencing a counter
// emulating example from: Domains: Sharing state in the communicating event-loopactor model
// fig 5
// file:///C:/PhD/Research%20Papers/Other/1-s2.0-S147784241600004X-main.pdf

var counter := object is iso {
    var val := 0  // This is the observable state

    // Method to get the current value of the counter
    method getCounterValue -> Number {
        val
    }

    // Method to set a new value for the counter
    method setCounterValue(newVal) {
        val := newVal
    }
}

// The Main program
var main := spawn { observerIsolate ->

    // The Observer object, which will modify the counter asynchronously
    var observer := object is iso {

        // Method that increases the counter value by 1
        method increaseCounter(counter) {
            // Asynchronously modify the counter's value
            var currentVal := counter.getCounterValue
            var newVal := currentVal + 1
            counter.setCounterValue(newVal)
            print("Counter incremented to: {newVal}")
        }
    }

    // Send the observer to the main program to handle
    observerIsolate.send(observer := -1)
}

// Main logic
// Send the counter to the observer for processing asynchronously
var observer := main.receive

// Send the counter object to the observer to modify its value asynchronously
observer.increaseCounter(counter)

// Print the updated counter value asynchronously
print("Counter value after Observer increment: {counter.getCounterValue} ..")
