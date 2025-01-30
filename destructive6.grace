print "Destructive test start-------------------------------------------------------------------"
print "Hello beautiful world-----------------------------------------------------------------"


// iso object example
var a := object is loc {  var aa := 1 }
var b := object { var bb := 2 }

print (" a.aa is {a.aa} ")
print (" b.bb is {b.bb} ")


print "---------------"

def c1 = spawn { c2 ->
    var aThread := c2.receive
    print ("on other thread")
    var bThread := (aThread := 1)
    print("successfully referencing by new variable" )
    print " Thread received object with aa field value: {aThread}"
    // print " bThread copied object with aa field value: {bThread.aa}"
    print "here"
    c2.send( bThread := -1 )
    print(" Thread end ")
}

c1.send( a := b )

var cMain := c1.receive

print (" a now holds bb: {a.bb} ") 
print (" variable cMain now holds files aa : {cMain.aa}")


print(" main end ")
