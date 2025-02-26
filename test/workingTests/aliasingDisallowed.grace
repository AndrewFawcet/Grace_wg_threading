// aliasing is not allowed in isolated objects simlar to constraints in result
// Emulating example from 'Ownership is Theft: Experiences Building an Embedded OS in Rust'
// file:///C:/PhD/Research%20Papers/Other/2818302.2818306.pdf

var x := object is iso {var y := 1}
var z := (x := -1)  // destructive read
print ("value is : {x.y} ...")  // not allowed, alias no longer exists

