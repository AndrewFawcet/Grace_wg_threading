def c1 = spawn { c2 ->
    var i := 0
    while {i < 5} do {
        print "about to send {i}"
        c2.send(i)
        print "sent {i}"
        i := i + 1
    }
    print "Waiting for sum..."
    def sum = c2.receive
    print "Received sum: {sum}"
}

print "about to receive"
var total := 0
var j := 0
while {j < 5} do {
    def val = c1.receive
    print "received {val}"
    total := total + val
    j := j + 1
}

print "Sending total of {total}"
c1.send(total)
print "Sent total"
