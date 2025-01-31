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

            // Expose limited access to account state
            method getBalance -> Number { balance.amount }

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

            // Method that improperly captures and leaks isolated balance
            method leakBalanceAccess -> Block {
                { balance.amount }
            }

            // Method that leaks an immutable transaction object
            method depositAndLeakTransaction(amount, description) -> Block {
                var transaction := makeTransaction.new(amount, description)
                balance.amount := balance.amount + amount
                { transaction }  // Returns a block that leaks the transaction
            }
        }
    }
}

// Create an Account Instance (Distant Object Concept)
var aliceAccount := makeAccount.new("Alice's Savings Account", 1000)

// Distant Object Simulation using Proxy
var makeBankProxy := object {
    method new(targetAccount) -> Object {
        object {
            method requestBalance -> Number {
                // Simulates forwarding request to distant object
                targetAccount.getBalance
            }

            method requestDeposit(amount, description) {
                // Forward the request to the actual bank account
                targetAccount.deposit(amount, description)
            }

            method requestWithdrawal(amount, description) {
                targetAccount.withdraw(amount, description)
            }
        }
    }
}

// Create Proxy for Alice's Account
var aliceProxy := makeBankProxy.new(aliceAccount)

// Use Proxy to Perform Operations
print "Initial Balance from Proxy: {aliceProxy.requestBalance} ..."
aliceProxy.requestDeposit(200, "Salary Payment via Proxy")
aliceProxy.requestWithdrawal(150, "Grocery Shopping via Proxy")

// Print final balance using the proxy
print "Final Balance from Proxy: {aliceProxy.requestBalance} ..."

// Test leaking methods
var balanceLeak := aliceAccount.leakBalanceAccess
print "Leaked Balance Value: {balanceLeak.apply} ..."

print "--"
print "Normal Balance Value: {aliceAccount.getBalance} ..."
print "--"
print "Normal Balance Value: {aliceProxy.requestBalance} ..."
print "--"

var transactionLeak := aliceAccount.depositAndLeakTransaction(500, "Bonus Payment")
print "Leaked Transaction Object: {transactionLeak} ..."
