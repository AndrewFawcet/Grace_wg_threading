// this shows the local account object holding the account name object and amount object failing in four different ways. 


// Account factory
def makeAccount := object {
    method new(accountNameValue, initialBalance) {
        object is local {
            def accountName := object is imm {
                def name := accountNameValue
            }
            def balance := object is iso {
                var amount := initialBalance
            }
            method deposit(amount) {
                balance.amount := balance.amount + amount
            }
            method withdraw(amount) {
                if (balance.amount >= amount) then {
                    balance.amount := balance.amount - amount
                }
            }
        }
    }
}
var account1 := makeAccount.new("Alice's Savings Account", 1000)
print "Account Name: {account1.accountName.name} ..."
print "Account Balance: {account1.balance.amount} ..."

// Perform transactions
account1.deposit(2000)
account1.withdraw(1000)
def channel1 = spawn { channel2 ->
    var account2 := channel2.receive   // local thread boundry failure
    print "Account Name: {account2.accountName.name} ..."
    account2.withdraw(1000)  // local dereferencing failure (vanilla and dereferencing and auto unlink)
}

channel1.send(account1)
