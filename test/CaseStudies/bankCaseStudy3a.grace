// this shows the iso account object holding the account name object and amount object failing in four different ways. 


// Account factory
var makeAccount := object {
    method new(accountNameValue, initialBalance) {
        object {
            var accountName := object is imm {
                var name := accountNameValue
            }
            var balance := object is iso {
                var amount := initialBalance
            }
            method deposit(amount, description) {
                balance.amount := balance.amount + amount
            }
            method withdraw(amount, description) {
                if (balance.amount >= amount) then {
                    balance.amount := balance.amount - amount
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
print "Balance after transactions: {account1.balance.amount} ..."

def channel1 = spawn { channel2 ->
    var account2 := channel2.receive   // local thread boundry failure
    print "Account Name: {account2.accountName.name} ..."
    account2.withdraw(1000, "New thread shopping")  // local dereferencing failure (vanilla and dereferencing and auto unlink, if balance is local obj)
    print "Reference Count account3.balance: {getRefCount(account2.balance)} ..."
    print(" thread end ")
    print ""
}

// Send the local object to another thread.
// This should trigger a runtime error or failure due to the "local" constraint.
channel1.send(account1)
sleep()
account1.withdraw(1000, "Old thread late withdrawal")

print(" main end ")
print ""