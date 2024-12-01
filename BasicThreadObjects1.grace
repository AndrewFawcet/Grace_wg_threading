// Grace thread object behavior test

var objectY := object is threaded {
    // Initialize objectYY
    var objectYY := object is local {
        var fieldYY : Number := 1
    }
    print(objectYY.fieldYY + 1)
}
print(objectY.objectYY.fieldYY + 2)
    
