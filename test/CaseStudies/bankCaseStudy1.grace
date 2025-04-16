
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
        object is loc {
            var accountName := object is imm {
                var name := accountNameValue
            }
            var balance := object is iso {
                var amount := initialBalance
            }

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
print ""
// Create an account instance
var AliceAccount := makeAccount.new("Alice's Savings Account", 1000)
print "Account Name: {AliceAccount.accountName.name} ..."
print "Account Balance: {AliceAccount.balance.amount} ..."

// Perform transactions
AliceAccount.deposit(2000, "Salary Payment")
AliceAccount.withdraw(1000, "Grocery Shopping")

// Print updated account information
print "Balance after transactions: {AliceAccount.balance.amount} ..."

def channel1 = spawn { channel2 ->
    // Attempt to receive and use the local object
    var AliceAccount2 := channel2.receive   // local thread boundry failure
    print (" new thread ")
    print "Account Name: {AliceAccount2.accountName.name} ..."
    print "Account Balance: {AliceAccount2.balance.amount} ..."
    print "Reference Count AliceAccount2.balance: {getRefCount(AliceAccount2.balance)} ..."
}

// Send the local object to another thread.
// This should trigger a runtime error or failure due to the "local" constraint.
channel1.send(AliceAccount)
AliceAccount.deposit(2000, "Salary Payment")
// AliceAccount.withdraw(1000, "Grocery Shopping")

print(" main end ")
print ""