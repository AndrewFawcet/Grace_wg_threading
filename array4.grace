// Simple Grace Bank Code with Transactions

// Transaction factory
var makeTransaction := object {
    method new(amountValue, descriptionValue) -> Object {
        object is imm {
            var amount := amountValue
            var description := descriptionValue
            method asString { "Transaction: {description} " }
        }
    }
}

// Bank class
var makeBank := object {
    method new(bankName) -> Object {
        object {
            var name := bankName
            var transactions := array

            method addTransaction(amount, description) {
                var transaction := makeTransaction.new(amount, description)
                transactions.add(transaction)
                print("Added transaction: {transaction.description} ..")
                print("Transaction amount: {transaction.amount} ..")
            }

            method printTransactions {
                print("Transactions for {name}:")
                print(transactions.asString)
            }
        }
    }
}

// Create a bank and add transactions
var myBank := makeBank.new("A Simple Bank")
myBank.addTransaction(100, "Deposit")
myBank.addTransaction(-50, "Withdrawal")

// Print all transactions
myBank.printTransactions()

// Access individual transactions
print("Transaction 1: description {myBank.transactions.get(0).description}  ..")
print("Transaction 1: amount {myBank.transactions.get(0).amount}  ..")
print("Transaction 2: description {myBank.transactions.get(1).description}  ..")
print("Transaction 2: amount {myBank.transactions.get(1).amount}  ..")

// myBank.transactions.get(0).amount := 123 // will result in a capability violation
