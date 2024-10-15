print "Hello world"
var x := object {
    var val := 1
    method foo {
        print(self.val)
        self.val := self.val + 1
    }
}

x.val := 987654321

print (x.val)

x.foo()
x.foo()
x.foo()



print "Goodbye world"
