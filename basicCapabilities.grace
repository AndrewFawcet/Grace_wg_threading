
print "Hello beautiful world-----------------------------------------------------------------"
var xxxObject := ISOLATED object {
    var xxxField := 123456
    
    method foo {
        print(self.xxxField)
        self.xxxField := self.xxxField + 789
    }
}

print " error after here? "
print "after yyyObject assigned to XXXObject"
print ""

var yyyObject := xxxObject
var zzzObject := xxxObject
var aaaObject := yyyObject

print ""
print "after yyyObject assigned to XXXObject"
print ""

print "Now doing some foo() in the main"
xxxObject.foo()

print "Goodbye cruel world"