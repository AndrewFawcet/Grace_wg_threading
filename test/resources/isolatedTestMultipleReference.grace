print "Isolated test start-------------------------------------------------------------------"
print "Hello beautiful world-----------------------------------------------------------------"


var objectX := object is isolated{
    var fieldX := 123456
    
    method foo {
        print(self.fieldX)
        self.fieldX := self.fieldX + 789
    }
}
print ""

var objectY := objectX

print (objectY.foo)

//this should fail, as now accessing a null reference with destructive reads
print (objectX.foo)  

print ""
print "Goodbye cruel world"