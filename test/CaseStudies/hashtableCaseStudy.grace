// Grace HashTable Implementation
// has an isolated linked list in the buckets.
// Simple deployment of destructive reads to place iso values into a hashtable and take them out

// Node factory for creating a linked list node
var makeNode := object is iso { // factories do not need to be iso, but are for consistency in all objects in and associated with making the hashmap
    method new(newValue) -> Object {
        object is iso {
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
                    return (value.v := -1)
                } else {
                    if (nextNode != -1) then {
                        return nextNode.getKeyValue(keyValue)  // Ensure we return the result from recursion
                    } else {
                        return "Value not found for Key {keyValue} .."
                    }
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

            method at(key)put(value) {
                var index := hashKey(key)
                // Add the key-value object to the appropriate bucket
                buckets.get(index).add(object {
                    var k := key
                    var v := value
                })
            }

            method at(key) {
                var index := hashKey(key)
                // Return the appropriate linked list for the bucket
                return buckets.get(index)
            }

            method get(key) -> Object {
                var index := hashKey(key)
                if (buckets.get(index).head != -1) then {
                    return buckets.get(index).get(key)  // Returning the result from the linked list
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

// var key1 := object is loc { var o := "I am loc key 1"  }
// var key2 := object is loc { var o := "I am loc key 2"  }
// var key3 := object is loc { var o := "I am loc key 3"  }
// var key4 := object { var o := "I am key 4"  }
// var key5 := object { var o := "I am key 5"  }
// var key6 := object { var o := "I am key 6"  }
// 
var object1 := object is iso { var o := "I am object 1" }
var object2 := object is iso { var o := "I am object 2" }
var object3 := object is iso { var o := "I am object 3" }
var object4 := object is iso { var o := "I am object 4" }
var object5 := object is iso { var o := "I am object 5" }
var object6 := object is iso { var o := "I am object 6" }

var key1 := 1
var key2 := 2
var key3 := 3
var key4 := 4
var key5 := 5
var key6 := 6

myMap.at(key1)put(object1 := -1)
myMap.at(key2)put(object2 := -1)
myMap.at(key3)put(object3 := -1)
myMap.at(key4)put(object4 := -1)
myMap.at(key5)put(object5 := -1)
myMap.at(key6)put(object6 := -1)


var objectReturned1 := myMap.get(1)
var objectReturned2 := myMap.get(2)
var objectReturned3 := myMap.get(3)
var objectReturned4 := myMap.get(4)
var objectReturned5 := myMap.get(5)
var objectReturned6 := myMap.get(6)

print(objectReturned1.o)
print(objectReturned2.o)
print(objectReturned3.o)
print(objectReturned4.o)
print(objectReturned5.o)
print(objectReturned6.o)

var otherObjectReturned1 := myMap.get(1)
var otherObjectReturned2 := myMap.get(2)
var otherObjectReturned3 := myMap.get(3)
var otherObjectReturned4 := myMap.get(4)
var otherObjectReturned5 := myMap.get(5)
var otherObjectReturned6 := myMap.get(6)

print(" what is left in the hashmap after reading object1 is {otherObjectReturned1} ...")
print(" what is left in the hashmap after reading object2 is {otherObjectReturned2} ...")
print(" what is left in the hashmap after reading object3 is {otherObjectReturned3} ...")
print(" what is left in the hashmap after reading object4 is {otherObjectReturned4} ...")
print(" what is left in the hashmap after reading object5 is {otherObjectReturned5} ...")
print(" what is left in the hashmap after reading object6 is {otherObjectReturned6} ...")
