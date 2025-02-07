// Define an Account “class” as an immutable (imm) object.
var Account := object is imm {
  // The 'new' method returns a new immutable Account object.
  method new(initialValue) -> Object {
    // Each account is created as an immutable object:
    object is imm {
      // Field 'value' holds the account balance.
      var value := initialValue
      
      // A getter to retrieve the account value.
      method getValue -> Number {
        value
      }
      
      // NOTE: No method to change 'value' is provided.
      // Attempting to do something like: value += 10000
      // would violate immutability and be forbidden.
    }
  }
}

// Define a Person “class” as an isolated (iso) object.
var Person := object is iso {
  // The 'new' method returns a new isolated Person.
  method new(initialBalance) -> Object {
    object is iso {
      // Each person owns an account (the account is a rep object).
      var account := Account.new(initialBalance)
      
      // The spouse field is meant to be in the same local ownership domain.
      // (We indicate this by our commentary; in a full system, you might
      // annotate this as a "loc" reference.)
      var spouse := -1  // Initially, no spouse.
      
      // Getter for the account balance.
      method getAccountValue -> Number {
        account.getValue
      }
      
      // Set the spouse. The parameter is expected to be a local (loc) Person.
      method setSpouse(newSpouse) {
        spouse := newSpouse
      }
      
      // Getter for spouse.
      method getSpouse -> Object {
        spouse
      }
      
      // (No method is provided to change the person's 'account' field;
      // reassigning a Person's account would be forbidden by the topology.)
    }
  }
}

// Define a Main object to tie things together.
var Main := object {
  method demo {
    // Create two persons with initial balances.
    var p1 := Person.new(100)
    var p2 := Person.new(200)
    
    // Set them as each other’s spouse.
    p1.setSpouse(p2)
    p2.setSpouse(p1)
    
    // Retrieve the account balances.
    var a1 := p1.getAccountValue
    var a2 := p2.getAccountValue
    var total := a1 + a2
    print("Total balance: " + total)
    
    // The following commented-out lines illustrate forbidden operations:
    // ---------------------------------------------------------------
    // p1.account = p2.account;  // Forbidden by topology: you cannot reassign
    //                          // a rep (owned) object to a different owner.
    //
    // a1.value += 10000;        // Forbidden by encapsulation/immutability:
    //                          // an immutable object’s state cannot be changed.
    // ---------------------------------------------------------------
  }
}

// Run the demo.
Main.demo
