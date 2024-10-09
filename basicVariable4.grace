var z := "789"
print (z)
var x := object {
    var variableX := "123456"

    print ""
    print "before  variableZ"
    z := variableX
    print "after  variableZ"
    print ""

    method foo {
        print(self.variableX)
        self.variableX := (self.variableX) ++ "789"
    }
}
print "----------1-----------"
x.foo()
print "----------2-----------"
x.foo()
print "----------3-----------"
print (z)