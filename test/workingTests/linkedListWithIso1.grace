// a linked iso list
// the head is an aliasable object, and holds no imput values
// all additional nodes with values are iso 

var makeHeadNode := object {
    method new -> Object {
        object {
            var value := "headNode"
            var nextNode := -1  // The reference to the next node (initially -1 for null)

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
        object is iso{
            var value := newValue
            var nextNode := -1  // The reference to the next node (initially -1 for null)

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
        }
    }
}

// Create separate linked list instances
var myList := makeLinkedList.new()
var myOtherList := makeLinkedList.new()

// Add nodes to the first list
print "myList contents:"
// myList.printList()  // Output: 10 20 30 40
myList.head.printValues()
myList.head.addNewValue(10)
myList.head.addNewValue(20)
myList.head.addNewValue(30)
myList.head.addNewValue(40)
myList.head.printValues()

print "--"

// Add nodes to the second list
myOtherList.head.addNewValue("jam")
myOtherList.head.addNewValue("bean")
myOtherList.head.addNewValue("toast")
myOtherList.head.addNewValue("blackPudding")
print "myOtherList contents:"
myOtherList.head.printValues()  // Output: jam bean toast blackPudding

print "--"

print "myList remains unchanged:"
myList.head.printValues()  // Output: 10 20 30 40

var blue := myList.head  //alaising of head is ok