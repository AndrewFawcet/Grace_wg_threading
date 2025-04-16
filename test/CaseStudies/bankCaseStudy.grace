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
                balance.amount := balance.amount + amount
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
var AliceAccount := makeAccount.new("Alice's Savings Account", 1000)
print "Account Name: {AliceAccount.accountName.name} ..."
print "Initial Balance: {AliceAccount.balance.amount} ..."

// Perform transactions
AliceAccount.deposit(200, "Salary Payment")
AliceAccount.withdraw(150, "Grocery Shopping")

// Print updated account information
print "Balance after transactions: {AliceAccount.balance.amount} ..."

def channel1 = spawn { channel2 ->
    // Attempt to receive and use the local object
    var AliceAccount2 := channel2.receive
    print (" new thread ")
    print "Account Name: {AliceAccount2.accountName.name} ..."
    print "Initial Balance: {AliceAccount2.balance.amount} ..."
}

// Send the local object to another thread.
// This should trigger a runtime error or failure due to the "local" constraint.
channel1.send(AliceAccount)

print(" main end ")