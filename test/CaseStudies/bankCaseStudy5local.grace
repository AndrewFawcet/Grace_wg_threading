// this shows the local account object holding the account name object and amount object failing in four different ways. 

def account1 := object is local {
    def a := object is imm {
        def name := "Alice's Account"
    }
    def b := object is iso {
        var amount := 1000
    }
    method deposit(amount) {
        b.amount := b.amount + amount
    }
    method withdraw(amount) {
        if (b.amount >= amount) then {
            b.amount := b.amount - amount
        }
    }
}
print "Account Name: {account1.a.name} ..."
print "Account Balance: {account1.b.amount} ..."

// Perform transactions
account1.deposit(2000)
account1.withdraw(1000)

// Print updated account information
print "Balance after transactions: {account1.b.amount} ..."

def channel1 = spawn { channel2 ->
    var account2 := channel2.receive   // // local thread boundry failure
    print "Account Name: {account2.a.name} ..."   // local dereferencing failure (vanilla and dereferencing and auto unlink)
    account2.withdraw(1000)
}

channel1.send(account1)


sleep()
account1.withdraw(1000)       // delete this, will cause LATEST_REFERENCE_ONLY_DEREFERENCING failure, mention it will not fail

print(" main end ")
print ""