print "Banking test start-------------------------------------------------------------------"
print "Hello beautiful bank-----------------------------------------------------------------"
print " This does nothing at this point, jsut non used objects "

// Immutable Transaction object
class Transaction {
    var amount: IMM Number
    var transactionType: IMM String
    var timestamp: IMM String

    method initialize(amount: Number, transactionType: String, timestamp: String) {
        self.amount := amount
        self.transactionType := transactionType
        self.timestamp := timestamp
    }

    method details -> String {
        "{transactionType} of {amount} at {timestamp}"
    }
}

// Account object
class Account {
    var accountName: IMM String
    var accountId: IMM Number
    var balance: Number := 0

    method initialize(accountName: String, accountId: Number) {
        self.accountName := accountName
        self.accountId := accountId
    }

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
        } else {
            print "Insufficient funds for account {accountName}!"
        }
    }
}

// Bank object
class Bank {
    method createAccount(accountName: String) -> ISO Account {
        def newAccount := Account.new(accountName, accounts.size + 1)
        accounts.add(newAccount)
        newAccount
    }
}

// Threading example
def main {
    def bank := Bank.new

    // Spawn thread to create accounts and perform transactions
    def accountThread = spawn { threadReceiver ->
        def account1 := bank.createAccount("Alice")
        account1.deposit(1000)
        threadReceiver.send(account1)

        def account2 := bank.createAccount("Bob")
        account2.deposit(500)
        threadReceiver.send(account2)
    }

    // Spawn thread to operate on received accounts
    def operationThread = spawn { threadSender ->
        def receivedAccount := threadSender.receive
        print "Thread received account: {receivedAccount.accountName}"
        receivedAccount.withdraw(200)
        print "Account balance after withdrawal: {receivedAccount.getBalance}"
        receivedAccount.deposit(300)
        print "Account balance after deposit: {receivedAccount.getBalance}"

        // Show transaction history
        for (transaction in receivedAccount.getHistory) do {
            print transaction.details
        }
    }

    accountThread.send(bank)
    print "Main thread finished."
}

main
// need to do something here???