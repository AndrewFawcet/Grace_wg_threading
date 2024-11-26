// Grace thread object behavior test

var objectX := object {
    var objectY := object is threaded {
        var objectYY := object is local {
            var fieldYY : Number := 1
        }
    }

    var objectZ := object is threaded {
        print (objectY.objectYY.fieldYY + 1)
    }
}

var objectX := object {
    var objectY := object is threaded {
        var objectYY := object is local {
            var fieldYY : Number := 1
        }
        print (objectYY.fieldYY)
    }

    var objectZ := object is threaded {
        print ("inside other thread")
        print (objectY.objectYY.fieldYY + 1)
    }
}