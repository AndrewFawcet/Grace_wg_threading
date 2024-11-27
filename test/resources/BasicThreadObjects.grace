// Grace thread object behavior test

// var objectX := object {
//     var objectY := object is threaded {
//         var objectYY := object is local {
//             var fieldYY : Number := 1
//         }
//         print (objectYY.fieldYY)
//     }
// }

var objectX := object {
    var objectY := object is threaded {
        // Initialize objectYY
        var objectYY := object is local {
            var fieldYY : Number := 1
        }

        // Use objectYY only after initialization is complete
        method printObjectYY {
            print(objectYY.fieldYY)
        }
    }

    // Access objectYY only after objectY has fully initialized
    method printFromObjectX {
        objectY.printObjectYY
    }
}
