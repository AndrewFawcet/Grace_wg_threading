// Grace HashTable Implementation
// has an isolated linked list in the buckets.
// with 'at_' and 'at_put_' syntax
// inputting local objects as keys
// demonstrates capability violation using local keys can depend on ordering of inputs

// Node factory for creating a linked list node
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

            method getValue(keyValue) {
                if (value.k == keyValue) then {
                    return value.v
                } else {
                    if (nextNode != -1) then {
                        return nextNode.getValue(keyValue)  // Ensure we return the result from recursion
                    } else {
                        return "Value not found for Key {keyValue} .."
                    }
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

            method printList() {
                if (head != -1) then {
                    head.printValues()  // Print recursively
                }
            }
        }
    }
}

// HashMap factory
var makeHashMap := object is iso {
    method new(size) -> Object {
        object is iso {
            var buckets := array(size)
            var i := 0
            while { i < size} do {
                buckets.add(linkedList.new())  // Creates a new linked list in each bucket
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
// second hashmap myOtherMap will put in local keys last
var myOtherMap := makeHashMap.new(3)

var key1 := object is loc { var o := "I am loc key 1"  }
var key2 := object is loc { var o := "I am loc key 2"  }
var key3 := object is loc { var o := "I am loc key 3"  }
var key4 := object { var o := "I am key 4"  }
var key5 := object { var o := "I am key 5"  }
var key6 := object { var o := "I am key 6"  }

var object1 := object { var o := "I am object 1" }
var object2 := object { var o := "I am object 2" }
var object3 := object { var o := "I am object 3" }
var object4 := object { var o := "I am object 4" }
var object5 := object { var o := "I am object 5" }
var object6 := object { var o := "I am object 6" }

myMap.at(key1)put(object1)    // local key
myMap.at(key2)put(object2)    // local key
myMap.at(key3)put(object3)    // local key
myMap.at(key4)put(object4)
myMap.at(key5)put(object5)
myMap.at(key6)put(object6)

myOtherMap.at(key4)put(object4)
myOtherMap.at(key5)put(object5)
myOtherMap.at(key6)put(object6)
myOtherMap.at(key1)put(object1)  // local key
myOtherMap.at(key2)put(object2)  // local key
myOtherMap.at(key3)put(object3)  // local key


// demonstrating access on current thread (thread of local objects creation)
var objectReturned2 := myMap.get(key2)
var objectReturned5 := myMap.get(key5)
var otherObjectReturned2 := myOtherMap.get(key2)
var otherObjectReturned5 := myOtherMap.get(key5)
print (objectReturned2.o)
print (objectReturned5.o)
print (otherObjectReturned2.o)
print (otherObjectReturned5.o)

// demonstrating access on different thread (thread different to local objects creation)
def c1 = spawn { c2 ->
    print "on new thread"
    var myMapThread := c2.receive
    var myOtherMapThread := c2.receive
    // var objectReturnedThread2 := myMapThread.get(key2)  // local key unusable
    // var objectReturnedThread5 := myMapThread.get(key5)  // normal object key unaccessible as behined local keys
    // var otherObjectReturnedThread2 := myOtherMapThread.get(key2)
    var otherObjectReturnedThread5 := myOtherMapThread.get(key5)
    // print (objectReturnedThread2.o)
    // print (objectReturnedThread5.o)
    // print (otherObjectReturnedThread2.o)
    print (otherObjectReturnedThread5.o)    // this only is accessible, due to coincidentally being retrived before a local key is touched
}

c1.send(myMap := -1)
c1.send(myOtherMap := -1)

print "-end-"