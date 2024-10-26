so in this you are suggesting to have 'threads' reckognized by the parser
// Grace pseudo-code for local object behavior test

var objectX := object is thread {
    var objectXX = object is local {
        var fieldXX : Number := 1
    }

}


var objectY := object is thread {
    print objectX.objectXX.fieldXX    // Should runtime fail ?? 
}

//--------------------------------------------------------------------------------------------------------------

var objectX := object is thread {
    var objectXX = object {
        var fieldXX : Number := 1
    }

}


var objectY := object is thread {
    print objectX.objectXX.fieldXX    // Should pass?? 
}

thread {
    print objectX.fieldY    // Should raise an error or exhibit safe behavior, as it’s a different thread
}

  print objectX.fieldY    // Should work fine, as it's the same thread
