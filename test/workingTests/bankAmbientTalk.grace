// inspired by file:///C:/PhD/Research%20Papers/Other/1-s2.0-S1477842414000335-main.pdf
// AmbientTalk: programming responsive mobile peer-to-peer applications with actors
// In the banking example in AmbientTalk it leverages on the actor system to provide encapulation.
// Encapsulation is used to protect the 'balance' of the account, so it is accessible only via method calls.
// This example uses iso for balance as a form of encapsulation, being only accessible from one reference. 
// This could be extended with complex internal variable names giving obfuscational protection for direct method calls.

// Object factory for creating immutable and isolated values
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

// Account factory
var makeAccount := object is iso {
    method new(accountNameValue, initialBalance) -> Object {
        object {
            var accountName := makeNestedObject.newImm(accountNameValue)  // Immutable account name
            var balance := makeNestedObject.newIso(initialBalance)        // Isolated balance
            
            // Private balance access
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

// Attempting direct modification (not prevented)
myAccount.balance.amount := 600  // This will not cause an error since `balance` is accessible through the iso myAccount. Is not encapsulated as in am actor system.
print "Initial Balance: {myAccount.getBalance} ..."

// Perform transactions
myAccount.deposit(200, "Salary Payment")
myAccount.withdraw(150, "Grocery Shopping")

// Print updated account information
print "Balance after transactions: {myAccount.getBalance} ..."
