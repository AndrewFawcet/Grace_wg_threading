// adapted from Dala paper

var x := object is iso {
    method f {
        print "Method f called"
    }
    method g -> Object {
        object {
            method h {
                f
            }
        }
    }
}

def y := x.g

y.h     // "Method f called"

def c := spawn { v ->
    var xThread := v.receive
    print ("on thread")
    xThread.g.h
    xThread.f
}

// Transfer ownership of `x` using a destructive read
c.send(x := -1) 

y.h
y.h