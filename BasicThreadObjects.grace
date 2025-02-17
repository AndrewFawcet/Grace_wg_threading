// Grace thread object behavior test

//var objectX := object {
//    var objectY := object is threaded {
//        var objectYY := object is local {
//            var fieldYY : Number := 1
//        }
//        print (objectYY.fieldYY)
//    }
//
//    var objectZ := object is threaded {
//        print ("inside other thread, should be followed by a failure")
//        print (objectY.objectYY.fieldYY + 1)
//    }
//}

print ("------------------------------")
 
var isInitialized := false  // Shared flag to indicate initialization

// threaded var objectX := object()
// var threaded objectX := object()
// var objectX := thread()
// var objectX := threaded(object())
// var objectX := object -> threaded {...}
// var threaded<objectX> := object { ... }
// var objectX := object :: Threaded 
// var objectX : Threaded<Object> := object 


var objectX := object is threaded {
    var objectXX := object is local {
        print("hi")
        var fieldXX : Number := 3
        isInitialized := true  // Set the flag once initialization is complete
    }
    print ("inside other thread, should be followed by a pass ---------------------")
    // Wait until objectXX is initialized
    // while (!isInitialized) do { }
    print (objectXX.fieldXX)
}

// Wait for the other thread to initialize
// while (!isInitialized){ }
print ()
print (objectX.objectXX.fieldXX)
