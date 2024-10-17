
print "Hello beautiful world-----------------------------------------------------------------"
var objectX := object is isolated{
    var fieldX := 123456
    
    method foo {
        print(self.xxxField)
        self.xxxField := self.xxxField + 789
    }
}

print "after objectY assigned to objectX --- should be an error"
print ""

var objectY := objectX

print ""
print "after objectY assigned to objectX"
print ""

print "Now doing some foo() in the main"
objectX.foo()

print "Goodbye cruel world"