
// Account factory
var makeAccount := object {
    method new(accountNameValue, initialBalance) {
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
var account1 := makeAccount.new("Alice's Savings Account", 1000)
print "Account Name: {account1.accountName.name} ..."
print "Account Balance: {account1.balance.amount} ..."

// Perform transactions
account1.deposit(2000, "Salary payment")
account1.withdraw(1000, "Grocery shopping")

// Print updated account information
print "Balance after transactions: {AliceAccount.balance.amount} ..."

var account2 := account1 // make an alias to the account.  Dala vanilla will fail here. !!

def channel1 = spawn { channel2 ->
    // Attempt to receive and use the local object
    var account3 := channel2.receive   // local thread boundry failure
    print (" new thread ")
    print "Account Name: {account3.accountName.name} ..."
    account3.withdraw(1000, "New thread shopping")
    print "Reference Count account3.balance: {getRefCount(account3.balance)} ..."
    print(" thread end ")
    print ""
}

// Send the local object to another thread.
// This should trigger a runtime error or failure due to the "local" constraint.
channel1.send(account2)

print(" main end ")
print ""