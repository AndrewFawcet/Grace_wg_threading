
print "Hello beautiful world-----------------------------------------------------------------"
var xxxObject := object is isolated{
    var xxxField := 123456
    
    method foo {
        print(self.xxxField)
        self.xxxField := self.xxxField + 789
    }
}
print ""

var yyyObject := xxxObject

print ""

print "Goodbye cruel world"