print "Banking test start-------------------------------------------------------------------"
print "Hello beautiful bank-----------------------------------------------------------------"

// Object factory with correct initialization for the bank
var bank := object {

    // Define the makeAccount object that will create new accounts
    var makeAccount := object is loc {
        method new(makeName.new(nameGiven), balanceGiven) -> Object {
            object {

                var makeName := object {
                    method new(nameGiven) -> Object {
                        object {
                            var name := nameGiven
                        }
                    }
                }
                var balance := balanceGiven   // Initialized with a default value

                // Getter methods
                method getName -> String {
                    name
                }

                method getBalance -> Number {
                    balance
                }

                // Deposit method to add money to the account
                method deposit( amount ) {
                    self.balance := self.balance + amount
                }

                // Withdraw method to remove money from the account
                method withdraw( amount ) {
                    if (self.balance >= amount) then {
                        self.balance := self.balance - amount
                    } else {
                        print "Insufficient funds to withdraw {amount} from {self.name}'s account."
                    }
                }
            }
        }
    }

    // Creating accounts using the bank's makeAccount object
    var account1 := makeAccount.new("John Doe", 1000)

    // var account2 := makeAccount.new(makeName.new("Jane Smith"), 2000)

    // Access and print account details
    print "--"
    print "=> {account1.getName}'s "
    print  " account balance: {account1.getBalance} dollars"
    print "--"
    // print "=> {account2.getName}'s "
    // print  " account balance: {account2.getBalance} dollars"

    // Perform transactions
    account1.deposit(500)
    // account2.withdraw(1000)

    // Print updated balances
    print "--"
    print "=> {account1.getName}'s "
    print  " account balance: {account1.getBalance} dollars"
    print "--"
    // print "=> {account2.getName}'s "
    // print  " account balance: {account2.getBalance} dollars"
}

print "Grace Bank End----------------------------------"
