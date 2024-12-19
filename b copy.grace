
print "Hello beautiful world-----------------------------------------------------------------"

var objectX:= object {
    var variableX := 1
    method foo {
        print(self.variableX)
    }
}


method bar is thread {
        print ("meth")
        print ("meth")
        print ("meth")
        print ("meth")
        print ("meth")        
    }


print ""
print ""


print "after"
print ""

// objectX.foo()

print ""
print ""

bar()

print ""
print ""


print "Goodbye cruel world"
