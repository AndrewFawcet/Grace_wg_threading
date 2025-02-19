
// Taken from isolated intList example in 'Uniqueness and Reference Immutability for Safe Parallelism'
// An or sperating to iterators, for some reason being not good.
// Define an isolated IntList class that holds integers


class IntList {
  var value := 0
  var next := null

  method add(newValue) {
    if (next == null) then {
      next := make(IntList).new(newValue)
    } else {
      next.add(newValue)
    }
  }

  method map(fun) {
    value := fun.applyTo(value)  // Apply the function to the current value
    if (next != null) then {
      next.map(fun)  // Recursively apply the function to the rest of the list
    }
  }

  method printList() {
    print(value, " ")
    if (next != null) then {
      next.printList()
    }
  }
}

// Incrementor class that defines a function to increment a number
class Incrementor {
  method applyTo(num) {
    return num + 1
  }
}

// Create two isolated IntLists
isolated IntList l1 := make(IntList).new(1)
isolated IntList l2 := make(IntList).new(10)

// Populate the lists with values
l1.add(2)
l1.add(3)
l2.add(20)
l2.add(30)

// Define a parallel operation on the two isolated lists
{ l1.map(make(Incrementor).new) } || { l2.map(make(Incrementor).new) }

// Print the results
l1.printList()  // Output: 2 3 4
l2.printList()  // Output: 11 12 13
