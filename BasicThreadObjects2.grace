// Grace thread object behavior test

var objectYY := object is local {
    var fieldYY : Number := 1
}

print(objectYY.fieldYY)

var objectY := object is threaded {
    print(objectYY.fieldYY + 1) 
}
