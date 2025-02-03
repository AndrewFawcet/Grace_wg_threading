print "Banking test start-------------------------------------------------------------------"
print "Hello beautiful bank-----------------------------------------------------------------"

// Immutable Transaction object
var Transaction := object {
    method new(amount: Number, type: String, timestamp: String) -> Object {
        object is imm {
            var transactionAmount: Number := amount
            var transactionType: String := type
            var transactionTimestamp: String := timestamp

            method details -> String {
                "{transactionType} of {transactionAmount} at {transactionTimestamp}"
            }
        }
    }
}

// Local Account object
var Account := object {
    method new(accountName: String, accountId: Number) -> Object {
        object is loc {
            var name: String := accountName
            var id: Number := accountId
            var balance: Number := 0
            var history: List<Object> := List.empty

            method getBalance -> Number {
                balance
            }

            method deposit(amount: Number) {
                balance := balance + amount
                history.add(Transaction.new(amount, "deposit", Clock.now.toText))
            }

            method withdraw(amount: Number) {
                if (balance >= amount) then {
                    balance := balance - amount
                    history.add(Transaction.new(amount, "withdraw", Clock.now.toText))
                } else {
                    print "Insufficient funds for account {name}!"
                }
            }

            method getHistory -> List<Object> {
                history
            }
        }
    }
}

// Bank object
var Bank := object {
    method new -> Object {
        object is iso {
            var accounts: List<Object> := List.empty

            method createAccount(accountName: String) -> Object {
                def account := Account.new(accountName, accounts.size + 1)
                accounts.add(account)
                account
            }

            method listAccounts -> List<Object> {
                accounts
            }
        }
    }
}

// Threading Example
def main {
    var bank := Bank.new

    // Spawn thread to create accounts
    def c1 = spawn { c2 ->
        var account1 := bank.createAccount("Alice")
        account1.deposit(1000)
        c2.send(account1)

        var account2 := bank.createAccount("Bob")
        account2.deposit(500)
        c2.send(account2)
    }

    // Spawn thread to perform operations on an account
    def c2 = spawn { c3 ->
        var receivedAccount := c3.receive
        print "Thread received account: {receivedAccount.name}"
        receivedAccount.withdraw(200)
        print "Account balance after withdrawal: {receivedAccount.getBalance}"
        receivedAccount.deposit(300)
        print "Account balance after deposit: {receivedAccount.getBalance}"
    }

    // Send bank object to thread
    c1.send(bank)

    print "Main thread finished."
}
