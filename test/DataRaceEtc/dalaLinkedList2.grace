// Node factory for creating a linked list node
var makeNode := object {
    method new(newValue) -> Object {
        object {
            var value := newValue
            var nextNode := -1  // Use 'nothing' to represent a null reference

            // Method to set the next node
            method setNext(node) {
                nextNode := node
            }

            // Method to get the next node
            method getNext() -> Object {
                return nextNode
            }
        }
    }
}

// Linked List factory for creating a linked list
var makeLinkedList := object {
    var head := -1  // Use 'nothing' instead of -1 to represent an empty list

    // Method to add a node to the list
    method add(newValue) {
        var newNode := makeNode.new(newValue)  // Create a new node

        // If the list is empty, set the new node as the head
        if (head == -1) then {
            head := newNode
        } else {
            // Otherwise, traverse to the end of the list and add the new node there
            var currentNode := head
            while (currentNode.getNext() != -1) do {
                currentNode := currentNode.getNext()
            }
            currentNode.setNext(newNode)
        }
    }

    // Method to print the list's contents
    method printList() {
        var currentNode := head
        while (currentNode != -1) do {
            print "{currentNode.value} "
            currentNode := currentNode.getNext()  // Move to the next node
        }
        print ""  // Move to the next line after printing the list
    }
}

// Create a linked list instance
var myList := makeLinkedList

// Add some nodes to the linked list
myList.add(10)
myList.add(20)
myList.add(30)
myList.add(40)

// Print the linked list's contents
myList.printList()  // Output: 10 20 30 40
