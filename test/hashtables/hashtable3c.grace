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
                // print " value {value.v} "
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

            method getValue(key) {
                if (value.k == key) then {
                    return value.v
                } else {
                    if (nextNode != -1) then {
                        return nextNode.getValue(key)  // Ensure we return the result from recursion
                    } else {
                        return "Value not found for Key {key} .."
                    }
                }
            }

            method removeNode(key, prevNode) -> Object {
                if (value.k == key) then {
                        // If removing a middle or last node, link prevNode to nextNode
                        prevNode.nextNode := nextNode
                        return nextNode
                } else {
                    if (nextNode != -1) then {
                        return nextNode.removeNode(key, prevNode.nextNode)
                    }
                    print "key does not exist in hashtable"
                    return -1
                }
            }

            method removeGetNode(keyValue, prevNode) -> Object {
                if (value.k == keyValue) then {
                        // If removing a middle or last node, link prevNode to nextNode
                        prevNode.nextNode := nextNode
                        return (value := -1)    // destructive read of removed node value for iso
                } else {
                    if (nextNode != -1) then {
                        return nextNode.removeNode(keyValue, prevNode.nextNode)
                        // return removeGetNode(keyValue, prevNode.nextNode)
                    }
                    print "key does not exist in hashtable"
                    return -1
                }
            }
        }
    }
}

// LinkedList object with a 'new' method
var linkedList := object is iso {
    method new() -> Object {
        object is iso {
            var head := -1  // Initially empty list

            method add(value) {
                if (head == -1) then {
                    head := makeNode.new(value)  // Correctly updating head
                } else {
                    head.addNewValue(value)
                }
            }

            method get(key) {
                if (head == -1) then {
                    return "empty bucket"
                } else {
                    return head.getValue(key)  // Ensure we return the result
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

            method removeGet(keyValue) {
                if (head == -1) then {
                    return "empty bucket"
                } 
                if (head.value.k == keyValue) then {
                    var oldHead := (head := head.nextNode)  // remove old head
                    return (oldHead.value.v := -1)  // return the value
                } else {
                    if (head.nextNode != -1) then {
                        var oldNode := (head.nextNode := head.nextNode.removeNode(keyValue, head))  // remove the old node
                        return (oldNode.value.v := -1)  // return the value
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
}

// HashMap factory
var makeHashMap := object is iso {   // factories do not need to be iso, but are for consistency in all objects in and associated with making the hashmap
    method new(size) -> Object {
        object is iso {
            var buckets := array(size)
            var i := 0
            while { i < size} do {
                buckets.add(linkedList.new())  // Creates a linked list in each bucket
                i := i + 1
            }

            method hashKey(key) -> Number {
                var hashValue := key.hash()
                hashValue := hashValue % size
                return hashValue
            }

            method at(key) {
                var index := hashKey(key)
                // Return the appropriate linked list for the bucket
                return buckets.get(index)
            }

            method at(key)put(value) {
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

            method removeGet(key) -> Object {
                var index := hashKey(key)
                if (buckets.get(index).head != -1) then {
                    return buckets.get(index).removeGet(key)
                }
                return "Key not found"
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

var key1 := object is loc { var o := "I am loc key 1"  }
var key2 := object is loc { var o := "I am loc key 2"  }
var key3 := object is loc { var o := "I am loc key 3"  }
var key4 := object { var o := "I am key 4"  }
var key5 := object { var o := "I am key 5"  }
var key6 := object { var o := "I am key 6"  }

var object1 := object is iso { var o := "I am object 1" }
var object2 := object is iso { var o := "I am object 2" }
var object3 := object is iso { var o := "I am object 3" }
var object4 := object is iso { var o := "I am object 4" }
var object5 := object is iso { var o := "I am object 5" }
var object6 := object is iso { var o := "I am object 6" }

myMap.at(key1)put(object1 := -1)
myMap.at(key2)put(object2 := -1)
myMap.at(key3)put(object3 := -1)
myMap.at(key4)put(object4 := -1)
myMap.at(key5)put(object5 := -1)
myMap.at(key6)put(object6 := -1)


var object11 := myMap.removeGet(key1)
print( "this is the thing {object11.o} ..." )
var object33 := myMap.removeGet(key3)
print( "this is the thing {object33.o} ..." )
myMap.remove(key3)
myMap.remove(key5)
myMap.remove(key5)
// 
// print "---------------"
print "---------------"
// myOtherMap.printAll()
