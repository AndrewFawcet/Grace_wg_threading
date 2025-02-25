// not operating asynchronously
// isolated counter asynchronously influencing a counter
// emulating example from: Domains: Sharing state in the communicating event-loopactor model
// fig 5
// file:///C:/PhD/Research%20Papers/Other/1-s2.0-S147784241600004X-main.pdf

var counter := object is iso {
    var val := 0  // This is the observable state
    method getCounterValue -> Number {
        val
    }
    method setCounterValue(newVal) {
        val := newVal
    }
}


// Main program, which spawns the Counter and Observer and interacts with them
var main := spawn { observerIsolate ->


    // The Observer object, which will modify the counter asynchronously
    var observer := object is iso {

        // Method that increases the counter value by 1
        method increaseCounter(counter) {
            var currentVal := counter.getCounterValue
            var newVal := currentVal + 1
            counter.setCounterValue(newVal)
        }
    }

    // Spawn the Observer and send the Counter object to it
    observerIsolate.send(observer := -1)

    // Spawn the Counter and send it to the Observer isolate
    // observerIsolate.send(counter)

}
print("Counter value after Observer increment: {counter.getCounterValue}  ..")

var observer := main.receive
observer.increaseCounter(counter)
// Print the current counter value (should be 1 after the Observer modifies it)
print("Counter value after Observer increment: {counter.getCounterValue}  ..")
print("Counter value after Observer increment: {counter.getCounterValue}  ..")
print("Counter value after Observer increment: {counter.getCounterValue}  ..")
