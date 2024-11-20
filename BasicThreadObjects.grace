// Grace thread object behavior test

var objectX := object is threaded {
    var objectXX := object is local {
        var fieldXX : Number := 1
    }
    print (objectXX.fieldXX)

}


