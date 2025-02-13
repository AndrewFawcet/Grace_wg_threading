// Node factory for creating a linked list node
// Different linked list instances can be made

var makeHeadNode := object {
    method new -> Object {
        object {
            var value := "headNode"
            var nextNode := -1  // The reference to the next node (initially -1 for null)

            // Method to set the next node
            method setNext(node) {
                nextNode := node
            }

            // Method to get the next node
            method getNext() -> Object {
                return nextNode
            }
            method printValues() {
                if (nextNode != -1) then {
                    nextNode.printValues() 
                }
            }
            method addNewValue(value) {
                if (nextNode != -1) then {
                    nextNode.addNewValue(value) 
                } else {
                    nextNode := makeNode.new(value)
                }
            }
        }
    }
}


var makeNode := object {
    method new(newValue) -> Object {
        object {
            var value := newValue
            var nextNode := -1  // The reference to the next node (initially -1 for null)

            // Method to set the next node
            method setNext(node) {
                nextNode := node
            }

            // Method to get the next node
            method getNext() -> Object {
                return nextNode
            }

            method printValues() {
                print "{value} "
                if (nextNode != -1) then {
                    nextNode.printValues() 
                }
            }

            method addNewValue(value) {
                if (nextNode != -1) then {
                    nextNode.addNewValue(value) 
                } else {
                    nextNode := makeNode.new(value)
                }
            }
        }
    }
}

// Linked List factory for creating separate linked list instances
var makeLinkedList := object {
    method new() -> Object {
        object {
            // var head := -1  // The head (first) node of the list
            var head := makeHeadNode.new()

            // Method to add a node to the list
            method add(value) {
                var newNode := makeNode.new(value)  // Create a new node

                // traverse to the end of the list and add the new node there
                var currentNode := head
                while {currentNode.getNext() != -1} do {
                    currentNode := currentNode.getNext()
                }
                currentNode.setNext(newNode)
            }

            // Method to print the list's contents
            method printList() {
                var currentNode := head
                while {currentNode != -1} do {
                    print "{currentNode.value} "
                    currentNode := currentNode.getNext()  // Move to the next node
                }
                print "" 
            }
        }
    }
}

// Create separate linked list instances
var myList := makeLinkedList.new()
var myOtherList := makeLinkedList.new()

// Add nodes to the first list
myList.add(10)
myList.add(20)
myList.add(30)
myList.add(40)
print "myList contents:"
// myList.printList()  // Output: 10 20 30 40
myList.head.printValues()
myList.head.addNewValue(50)
print "-+-"
myList.head.printValues()

print "--"

// Add nodes to the second list
myOtherList.add("jam")
myOtherList.add("bean")
myOtherList.add("toast")
myOtherList.add("blackPudding")
print "myOtherList contents:"
myOtherList.printList()  // Output: jam bean toast blackPudding

print "--"
print "myList remains unchanged:"
myList.printList()  // Output: 10 20 30 40
