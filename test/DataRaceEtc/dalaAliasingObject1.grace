// --- Helper Factories ---

// Factory for creating nested objects in immutable or isolated mode.
var makeNestedObject := object {
  // Creates an immutable object that holds a value (for account names)
  method newImm(value) -> Object {
    object is imm {
      var name := value
    }
  }
  // Creates an isolated object that holds a numeric value (for balances)
  method newIso(value) -> Object {
    object is iso {
      var amount := value
    }
  }
}

// Factory for creating immutable transaction objects.
var makeTransaction := object {
  method new(amountValue, descriptionValue) -> Object {
    object is imm {
      var amount := amountValue
      var description := descriptionValue
    }
  }
}

// --- Account Factory ---
// Each account is created as an iso (isolated) object.
// It holds an immutable account name, an isolated balance,
// and a reference field for spouse.
var makeAccount := object {
  method new(accountNameValue, initialBalance) -> Object {
    object is iso {
      // The account's name is an immutable nested object.
      var accountName := makeNestedObject.newImm(accountNameValue)
      // The balance is stored in an isolated nested object.
      var balance := makeNestedObject.newIso(initialBalance)
      // The spouse field will hold a reference to another account.
      var spouse := -1

      // Deposit method: creates a transaction and updates balance.
      method deposit(amount, description) {
        var transaction := makeTransaction.new(amount, description)
        // Update the balance (allowed since this is done internally)
        balance.amount := balance.amount + amount
      }

      // Withdraw method: checks funds, creates a transaction, and updates balance.
      method withdraw(amount, description) {
        if (balance.amount >= amount) then {
          var transaction := makeTransaction.new(-amount, description)
          balance.amount := balance.amount - amount
        } else {
          print "Insufficient funds for withdrawal."
        }
      }

      // Sets the spouse account.
      method setSpouse(otherAccount) {
        spouse := otherAccount
      }
    }
  }
}

// --- Creating Accounts and Linking Them as Spouses ---

// Create two account instances (for example, belonging to two persons)
print ("creating Account A")
var accountAlice := makeAccount.new("Alice's Savings Account", 1000)
print ("creating Account B")
var accountBob := makeAccount.new("Bob's Savings Account", 800)


// Link them by setting each as the other's spouse.
print ("setting spouse")
// accountAlice.setSpouse(accountBob)
// accountBob.setSpouse(accountAlice)

// --- Displaying Account Information ---

print "Account A: {accountAlice.accountName.name}, Balance: {accountAlice.balance.amount}"
print "Account B: {accountBob.accountName.name}, Balance: {accountBob.balance.amount}"

// --- Performing Transactions on Account A ---

accountAlice.deposit(200, "Salary Payment")
accountAlice.withdraw(150, "Grocery Shopping")

// Display updated balance for account A.
print "Account A Updated Balance: {accountAlice.balance.amount} ."
