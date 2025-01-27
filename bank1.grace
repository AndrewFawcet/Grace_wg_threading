print "Banking test start-------------------------------------------------------------------"
print "Hello beautiful bank-----------------------------------------------------------------"

// this should show the practical use of capabilities loc, iso and imm to build a secure banking system with threading 



// Immutable Transaction object
var Transaction := object {
    var amount := obects is imm {
        var dollars := 1234
    }
    var type: IMM String // "deposit" or "withdraw"
    var timestamp: IMM String

    method initialize(amount: Number, type: String, timestamp: String) {
        self.amount := amount
        self.type := type
        self.timestamp := timestamp
    }

    method details -> String {
        "{type} of {amount} at {timestamp}"
    }
}
var accountOne := object is local {
    var accountName := object is imm {
        var name := "Bob"
    }
    var accountID := object is imm {
        var ID := 1234
    }
    var balance := object is iso {
        var dollars := 1234
    }

}


class Account {
    var accountName: IMM String
    var accountId: IMM Number
    var balance: Number := 0
    var history: LOC List<Transaction> := List.empty

    method initialize(accountName: String, accountId: Number) {
        self.accountName := accountName
        self.accountId := accountId
    }

    method getBalance -> LOC Number {
        return balance
    }

    method deposit(amount: Number) -> ISO {
        balance := balance + amount
        history.add(Transaction.new(amount, "deposit", Clock.now.toText))
        return self
    }

    method withdraw(amount: Number) -> ISO {
        if (balance >= amount) then {
            balance := balance - amount
            history.add(Transaction.new(amount, "withdraw", Clock.now.toText))
        } else {
            print "Insufficient funds for account {accountName}!"
        }
        return self
    }

    method getHistory -> LOC List<Transaction> {
        return history
    }
}

// Bank object
class Bank {
    var accounts: LOC List<Account> := List.empty

    method createAccount(accountName: String) -> ISO {
        def newAccount := Account.new(accountName, accounts.size + 1)
        accounts.add(newAccount)
        return newAccount
    }

    method listAccounts -> LOC List<Account> {
        return accounts
    }
}

// Threading example
def main {
    def bank := Bank.new

    // Spawn thread to create accounts
    def c1 = spawn { c2 ->
        def account1 := bank.createAccount("Alice")
        account1.deposit(1000)
        c2.send(account1)

        def account2 := bank.createAccount("Bob")
        account2.deposit(500)
        c2.send(account2)
    }

    // Spawn thread to perform operations on an account
    def c2 = spawn { c3 ->
        def receivedAccount := c3.receive
        print "Thread received account: {receivedAccount.accountName}"
        receivedAccount.withdraw(200)
        print "Account balance after withdrawal: {receivedAccount.getBalance}"
        receivedAccount.deposit(300)
        print "Account balance after deposit: {receivedAccount.getBalance}"
    }

    c1.send(bank)
    print "Main thread finished."
}
