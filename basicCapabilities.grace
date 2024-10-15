
print "Hello beautiful world-----------------------------------------------------------------"
var xxxObject := object is isolated{
    var xxxField := 123456
    
    method foo {
        print(self.xxxField)
        self.xxxField := self.xxxField + 789
    }
}

print "after yyyObject assigned to XXXObject --- should be an error"
print ""

var yyyObject := xxxObject

print ""
print "after yyyObject assigned to XXXObject"
print ""

print "Now doing some foo() in the main"
xxxObject.foo()

print "Goodbye cruel world"