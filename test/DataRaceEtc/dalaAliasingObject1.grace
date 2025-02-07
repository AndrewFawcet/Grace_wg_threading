// adapted from 'Object Ownership in Program Verification' paper
// from aggregation of papers 'Aliasing in Object-Oriented Programming'

class Account {
    imm value -> Number

    Account (initialValue) -> Account {
        value := initialValue
    }

    method getValue -> Number {
        value
    }
}

class Person {
    iso rep account: Account
    iso peer spouse: Person

    Person (initialBalance) -> Person {
        account := Account(initialBalance)
        spouse := null
    }

    method setSpouse(peer newSpouse) {
        spouse := newSpouse
    }

    method getAccountValue -> Number {
        account.getValue
    }
}

class Main {
    iso rep p1: Person
    iso rep p2: Person

    Main -> Main {
        p1 := Person(100)
        p2 := Person(200)

        p1.setSpouse(p2)
        p2.setSpouse(p1)

        // Attempt to access accounts and modify them - restricted by immutability.
        print("Total balance: {p1.getAccountValue + p2.getAccountValue}")
    }
}
