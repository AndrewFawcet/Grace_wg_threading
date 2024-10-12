
print "Reference increment test start-----------------------------------------"

print "Hello ---------------------------aaa--------------------------------------"
var reference1 := object {
    var variableA := 123456
    method foo {
        print(self.variableA)
        self.variableA := self.variableA + 789
    }
}

print "object created"
var reference2 := reference1
print "object references = 2"
var reference3 := reference1
print "object references = 3"

print "End of test grace code"

