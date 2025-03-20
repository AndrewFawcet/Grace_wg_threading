
print "Hello beautiful world-----------------------------------------------------------------"

var counter := object is loc {
    var value := 0
    method increment { value := value + 1 }
    method getValue { value }
}
var SecondCounter := object is loc {
    var value := 123
    method increment { value := value + 1 }
    method getValue { value }
}

print("value before {counter.getValue} ...")
var x := object{
    method referenceCounter {

        print("A")
        var alias1 := counter
        print("B")
        var alias2 := counter
        print("C")
        var alias3 := counter
        print("D")
        alias3.increment
        print ("Inside method, value: {alias3.getValue} ...")
    }   
}

print("E")
print("EE")
x.referenceCounter()   // Call method
print("F")

// At this point, localObj, alias1 and alias2 should be garbage collected, refernce count for object should be 1
print "Method finished execution"
print "Goodbye cruel world"