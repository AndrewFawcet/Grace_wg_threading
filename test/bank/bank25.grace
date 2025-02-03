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

// Transaction history object
var makeHistory := object {
    method new -> Object {
        object {
            var transactionCounter := 0
            var transactions := object {}

            // Add a transaction to the history
            method addTransaction(transaction) {
                transactionCounter := transactionCounter + 1
                print("-")
                def key := "transaction{transactionCounter}"
                print("--")
                transactions.(" transaction{transactionCounter}pp" := transaction

                // transactions.(var key) := transaction
                print("---")
            }

            // Print all transactions
            method printHistory {
                for (i in 1..transactionCounter) do {
                    def key := "transaction{i}"
                    def transaction := transactions.(key)
                    if (transaction != null) then {
                        print "Amount: {transaction.amount}, Description: {transaction.description}"
                    }
                }
            }
        }
    }
}

// Account factory
var makeAccount := object {
    method new(accountNameValue, initialBalance) -> Object {
        object {
            var accountName := makeNestedObject.newImm(accountNameValue)  // Immutable account name
            var balance := makeNestedObject.newIso(initialBalance)        // Isolated balance
            var history := makeHistory.new()                              // Transaction history

            method deposit(amount, description) {
                var transaction := makeTransaction.new(amount, description)
                print ("here")
                history.addTransaction(transaction)
                print ("here-")
                balance.amount := balance.amount + amount
                print ("here--")
            }

            method withdraw(amount, description) {
                if (balance.amount >= amount) then {
                    var transaction := makeTransaction.new(-amount, description)
                    history.addTransaction(transaction)
                    balance.amount := balance.amount - amount
                } else {
                    print "Insufficient funds for withdrawal."
                }
            }

            method printTransactionHistory {
                history.printHistory
            }
        }
    }
}

// Create an account instance
var myAccount := makeAccount.new("Alice's Savings Account", 1000)
print "Account Name: {myAccount.accountName.name}"
print "Initial Balance: {myAccount.balance.amount}"

// Perform transactions
myAccount.deposit(200, "Salary Payment")
myAccount.withdraw(150, "Grocery Shopping")

// Print updated account information
print "Balance after transactions: {myAccount.balance.amount}"

// Print transaction history
print "Transaction History:"
myAccount.printTransactionHistory
