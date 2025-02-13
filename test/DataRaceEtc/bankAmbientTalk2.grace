// Object factory for creating immutable values
var makeNestedObject := object {
    method newImm(value) -> Object {
        object is imm {
            var name := value
        }
    }
}

// Account factory
var makeAccount := object is iso {
    method new(accountNameValue, initialBalance) -> Object {
        object {
            var accountName := makeNestedObject.newImm(accountNameValue)  // Immutable account name
            
            // Balance is completely hidden inside this method scope
            def balance := object is iso {
                var amount := initialBalance  // Not accessible from outside
            }
            
            method getBalance -> Number { balance.amount }

            method deposit(amount, description) {
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

// Create an account instance
var myAccount := makeAccount.new("Alice's Savings Account", 1000)

// Accessing account details
print "Account Name: {myAccount.accountName.name} ..."
print "Initial Balance: {myAccount.getBalance} ..."

// ❌ This will now cause an error, because balance is **not accessible**
myAccount.balance.amount := 600  // ❌ This line will NOT work
print "Initial Balance: {myAccount.getBalance} ..."

// Perform transactions
myAccount.deposit(200, "Salary Payment")
myAccount.withdraw(150, "Grocery Shopping")

// Print updated account information
print "Balance after transactions: {myAccount.getBalance} ..."
