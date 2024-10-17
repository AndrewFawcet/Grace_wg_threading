print "Reference increment test start--------------------------------------------------------"
print "Hello beautiful world-----------------------------------------------------------------"


var objectX := object {
    var fieldX := 123456
    method foo {
        print(self.fieldX)
        self.fieldX := self.fieldX + 789
    }
}

print "object created"
var reference2 := objectX
print "object references = 2"
var reference3 := objectX
print "object references = 3"

print "End of test grace code"

