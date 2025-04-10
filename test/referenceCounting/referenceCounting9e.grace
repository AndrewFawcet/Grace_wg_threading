
print ""
print ""
print ""
print "using def"

method foo {
    var o := object { 
        var v := 1 
    }
    var t := object { 
        var v := 1 
    }
    var r := object { 
        var v := 1 
    }
    var s := object { 
        var v := 1 
    }
    // return    print "--------------------------++--------------------------"
    var i := object { 
        var v := 1 
    }

    var e := i
    var f := i
    var g := i
    var h := i

    return e
}

print ""
print " calling foo"
def z := foo

print ""
print "dropping on floor"
foo
