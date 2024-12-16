print ("----starting")

def xObject := object{
    var value := 1 
}

// Define a block that sends updates via a channel
var block := {x, y, channel ->  
    while {x.value < 10} do {
        x.value := x.value + y 
        channel.send(x.value)  # Send updated value to the main thread
    } 
}

// Set up a channel for communication
var mainChannel := GraceChannel.new()

// Create a thread and pass the channel
block.apply_thread(xObject, 1, mainChannel.port2)  // Port2 is for the worker thread
block.apply_thread(xObject, 1, mainChannel.port2)
block.apply_thread(xObject, 1, mainChannel.port2)
block.apply_thread(xObject, 1, mainChannel.port2)

// Main thread receives updates and prints them
while {mainChannel.hasMoreMessages} do {
    print ("Main received: {mainChannel.receive()}")
}

print ("final value is")
print (xObject.value)
print ("-------test ok")
