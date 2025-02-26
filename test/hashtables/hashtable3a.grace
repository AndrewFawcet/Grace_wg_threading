// Grace HashTable Implementation
// has an isolated linked list in the buckets.
// Developing the ability to remove values from the hashtable

// Node factory for creating a linked list node
var makeNode := object is iso { // factories do not need to be iso, but are for consistency in all objects in and associated with making the hashmap
    method new(newValue) -> Object {
        object {
            var value := newValue
            var nextNode := -1  // Initially -1 for null

            method printValues() {
                print " key {value.k} "
                print " value {value.v} "
                if (nextNode != -1) then {
                    nextNode.printValues() 
                }
            }

            method addNewValue(newValue) {
                if (nextNode != -1) then {
                    nextNode.addNewValue(newValue) 
                } else {
                    nextNode := makeNode.new(newValue)  // Correctly assigning nextNode
                }
            }

            method getKeyValue(keyValue) {
                if (value.k == keyValue) then {
                    return value.v
                } else {
                    if (nextNode != -1) then {
                        return nextNode.getKeyValue(keyValue)  // Ensure we return the result from recursion
                    } else {
                        return "Value not found for Key {keyValue} .."
                    }
                }
            }
            method removeNode(keyValue, prevNode) -> Object {
                if (value.k == keyValue) then {
                        // If removing a middle or last node, link prevNode to nextNode
                        prevNode.nextNode := nextNode
                        return nextNode
                    
                } else {
                    if (nextNode != -1) then {
                        return nextNode.removeNode(keyValue, prevNode.nextNode)
                    }
                    return -1
                }
            }
        }
    }
}

// Linked List factory
method makeLinkedList() -> Object {
    object is iso{
        var head := -1

        method add(value) {
            if (head == -1) then {
                head := makeNode.new(value)  // Correctly updating head
            } else {
                head.addNewValue(value)
            }
        }

        method get(keyValue) {
            if (head == -1) then {
                return "empty bucket"
            } else {
                return head.getKeyValue(keyValue)  // Ensure we return the result
            }
        }

        method remove(keyValue) {
            if (head == -1) then {
                return "empty bucket"
            } 
            if (head.value.k == keyValue) then {
                head := head.nextNode
            } else {
                if (head.nextNode != -1) then {
                    head.nextNode := head.nextNode.removeNode(keyValue, head)
                }
            }
        }

        method printList() {
            if (head != -1) then {
                head.printValues()  // Print recursively
            }
        }
    }
}

// HashMap factory
var makeHashMap := object is iso {   // factories do not need to be iso, but are for consistency in all objects in and associated with making the hashmap
    method new(size) -> Object {
        object is iso {
            var buckets := array(size)
            var i := 0
            while { i < size} do {
                buckets.add(makeLinkedList())  // Creates a linked list in each bucket
                // buckets.at(i).put(object is iso { var head := -1 })
                i := i + 1
            }

            method hashKey(key) -> Number {
                var hashValue := key.hash()
                hashValue := hashValue % size
                return hashValue
            }

            method put(key, value) {
                var index := hashKey(key)
                // Add the key-value object to the appropriate bucket
                buckets.get(index).add(object {
                    var k := key
                    var v := value
                })
            }

            method get(key) -> Object {
                var index := hashKey(key)
                if (buckets.get(index).head != -1) then {
                    return buckets.get(index).get(key)  // Returning the result from the linked list
                }
                return "Key not found"
            }

            method remove(key) {
                var index := hashKey(key)
                if (buckets.get(index).head != -1) then {
                    buckets.get(index).remove(key)
                }
            }

            method printAll() {
                var i := 0
                while { i < size } do {
                    print("Bucket {i}:")
                    if (buckets.get(i).head != -1) then {
                        buckets.get(i).printList()  // Print the list in each bucket
                    }
                    i := i + 1
                }
            }
        }
    }
}

// Example usage
var myMap := makeHashMap.new(3)
var myOtherMap := makeHashMap.new(3)

var key1 := object is loc { var o := "I am loc key 1"  }
var key2 := object is loc { var o := "I am loc key 2"  }
var key3 := object is loc { var o := "I am loc key 3"  }
var key4 := object { var o := "I am key 4"  }
var key5 := object { var o := "I am key 5"  }
var key6 := object { var o := "I am key 6"  }
// 
// var object1 := object { var o := "I am object 1" }
// var object2 := object { var o := "I am object 2" }
// var object3 := object { var o := "I am object 3" }
// var object4 := object { var o := "I am object 4" }
// var object5 := object { var o := "I am object 5" }
// var object6 := object { var o := "I am object 6" }
// 
// myMap.put(key1, object1)    // local key
// myMap.put(key2, object2)    // local key
// myMap.put(key3, object3)    // local key
// myMap.put(key4, object4)
// myMap.put(key5, object5)
// myMap.put(key6, object6)
// 
// var objectReturned2 := myMap.get(key2)
// print(objectReturned2.o)
// 
// myMap.printAll()
// 
// myMap.remove(key1)

// var key1 := 1
// var key2 := 2
// var key3 := 3
// var key4 := 4
// var key5 := 5
// var key6 := 6

var object1 := 123
var object2 := 234
var object3 := 345
var object4 := 456
var object5 := 567
var object6 := 678

myOtherMap.put(key1, object1)
myOtherMap.put(key2, object2)
myOtherMap.put(key3, object3)
myOtherMap.put(key4, object4)
myOtherMap.put(key5, object5)
myOtherMap.put(key6, object6)

myOtherMap.printAll()

myOtherMap.remove(key1)
myOtherMap.remove(key3)
myOtherMap.remove(key5)

print "---------------"
myOtherMap.printAll()
myOtherMap.remove(key5)
print "---------------"
myOtherMap.printAll()
