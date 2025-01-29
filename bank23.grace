// Object factory for creating nested objects
var makeNestedObject := object {
    method new(nameValue) -> Object {
        object {
            var name := nameValue

            method getName -> String {
                name
            }
        }
    }
    method newLoc(nameValue) -> Object {
        object is loc {
            var name := nameValue

            method getName -> String {
                name
            }
        }
    }
    method newIso(nameValue) -> Object {
        object is iso {
            var name := nameValue

            method getName -> String {
                name
            }
        }
    }
    method newImm(nameValue) -> Object {
        object is imm {
            var name := nameValue

            method getName -> String {
                name
            }
        }
    }

}

// Transaction factory (Immutable)
var makeTransaction := object {
    method new(amountValue, descriptionValue) -> Object {
        object is imm {
            var amount := amountValue
            var description := descriptionValue

            method getAmount -> Number { amount }
            method getDescription -> String { description }
        }
    }
}

// Transaction history object
var makeHistory := object {
    method new -> Object {
        object {
            var transactionCounter := 0
            var transactionHistory := object is iso {}

            // Add a transaction to the history
            method addTransaction(transaction) {
                transactionCounter := transactionCounter + 1
                def transactionSlot := "transaction{transactionCounter}"
                transactionHistory.(transactionSlot) := transaction
            }

            // Print all transactions
            method printHistory {
                for (i in 1..transactionCounter) do {
                    def transaction := transactionHistory.("transaction{i}")
                    print "Amount: {transaction.getAmount}, Description: {transaction.getDescription}"
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
            var balance := makeNestedObject.newIso(initialBalance)       // Isolated balance
            var history := makeHistory.new()                             // Transaction history

            // Deposit method
            method deposit(amount, description) {
                var transaction := makeTransaction.new(amount, description)
                history.addTransaction(transaction)
                balance := balance + amount
            }

            // Withdraw method
            method withdraw(amount, description) {
                if (balance >= amount) then {
                    var transaction := makeTransaction.new(-amount, description)
                    history.addTransaction(transaction)
                    balance := balance - amount
                } else {
                    print "Insufficient funds for withdrawal."
                }
            }

            // Getter methods
            method getAccountName -> String {
                accountName.getName
            }

            method getBalance -> Number {
                balance
            }

            method printTransactionHistory {
                history.printHistory
            }
        }
    }
}

// Creating an account instance
var myAccount := makeAccount.new("Alice's Savings Account", 1000)
print "Account Name: {myAccount.getAccountName}"
print "Initial Balance: {myAccount.getBalance}"

// Perform transactions
myAccount.deposit(200, "Salary Payment")
myAccount.withdraw(150, "Grocery Shopping")

// Print updated account information
print "Balance after transactions: {myAccount.getBalance}"

// Print transaction history
print "Transaction History:"
myAccount.printTransactionHistory
