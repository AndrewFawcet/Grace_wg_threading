
// chaining example

print ""
print "chaining example"
print ""

var c :=  object {
    var value := 0

    method increment {
        value := value + 1
        return self
    }

    method decrement {
        value := value - 1
        return self
    }

    method show {
        print(value)
        return self
    }
}

// c.increment
// (c.increment).increment
((((c.increment).increment).show).decrement).show
