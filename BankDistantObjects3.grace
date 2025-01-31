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

            // Method that improperly leaks the balance object
            method leakBalanceObject -> Block {
                { balance }  // Leaks the entire balance object instead of just its value
            }
        }
    }
}

// Create an Account Instance
var aliceAccount := makeAccount.new("Alice's Savings Account", 1000)

// Test leaking the balance object
var balanceObjectLeak := aliceAccount.leakBalanceObject

// Attempt to access and print sensitive details of the balance object
var leakedBalanceObject := balanceObjectLeak.apply
print "Leaked Balance Object Amount: {leakedBalanceObject.amount} ..."

// Attempt to modify the balance externally (this would ideally be prevented in a secure system)
leakedBalanceObject.amount := 99999
print "Balance After External Modification: {aliceAccount.getBalance} ..."

// Verify isolation breach
print "Final Leaked Balance Value: {leakedBalanceObject.amount} ..."
