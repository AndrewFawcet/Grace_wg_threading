var objectX := object is iso {
    var objectY := object is iso {
        var fieldY : Number := 10
    }
    var fieldX : Number := 20
}

var objectA := object {
    var fieldA := 123
} 

print (" objectX now holds : {objectX.fieldX} and {objectX.objectY.fieldY} ")
print (" objectX now holds : {objectX.fieldX} ")
print (" and {objectX.objectY.fieldY}")
print (" objectA contains : { objectA.fieldA} ")

def c1 = spawn { c2 ->
    var objectXX := c2.receive
    print " Thread received object with field value: {objectXX.fieldX}"
    print " Thread received object with field value: {objectXX.objectY.fieldY}"
    var objectZ := objectX.objectY
    print "Thread objectZ now holds value: {objectZ.fieldY}"
    c2.send(objectXX)
    var objectAA := c2.receive
    print ( " Thread received objectAA holds value: {objectAA.fieldA} ")
    print(" Thread end ")

}

c1.send(objectX)
var objectXXX := c1.receive
// print (" objectX now holds : {objectX.fieldX} ") // will create error 'because "receiver" is null'
print (" objectXXX now holds : {objectXXX.fieldX}")

// print (" objectXXX now holds : {objectXXX.objectY.fieldY}") // will create error 'because "receiver" is null'

c1.send(objectA)
print ( " objectA post thread send holds value: {objectA.fieldA} ")

print(" main end ")
