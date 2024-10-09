var x := object {
    var variableX := 123456

    print ""
    print "before  variableY"
    var variableY := variableX
    print "after  variableY"
    print ""

    method foo {
        print(self.variableX)
        self.variableX := self.variableX + 789
    }
}
print "----------1-----------"
x.foo()
print "----------2-----------"
x.foo()
print "----------3-----------"
