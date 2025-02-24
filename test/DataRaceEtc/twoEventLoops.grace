// Create two isolated objects (actors)

var actor1 := object is iso {
    var field1 := 42
    method communicate(c) {
        print "Actor 1 says: Hello World!"
        c.send("Hello from Actor 1")
    }
}

// Main event loop: Communication between isolated objects
def c1 = spawn { c2 ->
    // Receive actor1's message
    var actor1Instance := c2.receive
    actor1Instance.communicate(c2)  // Actor 1 communicates with the main loop

    // Receive actor1's message from main loop
    var message1 := c2.receive
    // print "Main Event Loop received: {message1}"

    // Create actor2 and communicate with it
    var actor2 := object is iso {
        var field2 := 84
        method communicate(c) {
            print "Actor 2 says: Hello World!"
            c.send("Hello from Actor 2")
        }
    }

    // Create and communicate with actor2
    var actor2Instance := actor2
    actor2Instance.communicate(c2)

    // Receive actor2's message
    var message2 := c2.receive
    print "Main Event Loop received: {message2}"

    print "Main Event Loop ends"
}

// Start the main event loop, sending actor1 to it
c1.send(actor1 := -1)
