// Object factory for creating nested objects
var makeNestedObject := object {
    method newImm(value) -> Object {
        object is imm {
            var name := value
        }
    }
    method newIso(value) -> Object {
        object is iso {
            var amount := value
        }
    }
}

// Transaction factory (Immutable)
var makeTransaction := object {
    method new(amountValue, descriptionValue) -> Object {
        object is imm {
            var amount := amountValue
            var description := descriptionValue
        }
    }
}

// Account factory
var makeAccount := object {
    method new(accountNameValue, initialBalance) -> Object {
        object {
            var accountName := makeNestedObject.newImm(accountNameValue)  // Immutable account name
            var balance := makeNestedObject.newIso(initialBalance)        // Isolated balance

            method deposit(amount, description) {
                var transaction := makeTransaction.new(amount, description)
                print ("here")
                balance.amount := balance.amount + amount
                print ("here--")
            }

            method withdraw(amount, description) {
                if (balance.amount >= amount) then {
                    var transaction := makeTransaction.new(- amount, description)
                    balance.amount := balance.amount - amount
                } else {
                    print "Insufficient funds for withdrawal."
                }
            }
        }
    }
}

// Create an account instance
var myAccount := makeAccount.new("Alice's Savings Account", 1000)
print "Account Name: {myAccount.accountName.name} ..."
print "Initial Balance: {myAccount.balance.amount} ..."

// Perform transactions
myAccount.deposit(200, "Salary Payment")
// myAccount.withdraw(150, "Grocery Shopping")

// Print updated account information
// print "Balance after transactions: {myAccount.balance.amount} ..."

