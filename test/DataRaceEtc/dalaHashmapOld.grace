// Grace HashTable Implementation
// Has an isolated linked list in the buckets.
// old implementation

// Node factory for creating a linked list node
var makeNode := object is iso {
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

            method getValue(key) {
                if (value.k == key) then {
                    return value.v
                } else {
                    if (nextNode != -1) then {
                        return nextNode.getValue(key)  // Ensure we return the result from recursion
                    } else {
                        return "nothing here"  // return -1 to indicate no such value
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

            method put(key, value) {
                add(object {
                    var k := key
                    var v := value
                })
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

                // var result := buckets.get(index).get(key)  // Call the linked list's get method
                // if (result == nill) then {
                //     return "Key not found"  // Return a consistent message for missing keys
                // }
                // return result
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
myMap.at("hello").put("hello", 123)
myMap.at("hello").put("hello", 123)
myMap.at("world").put("world", 456)

print("Value for 'hello': {myMap.get("hello")} ..")  // Should print 123
print("Value for 'world': {myMap.get("world")} ..")  // Should print 456
print ("Value for 'hello': {myMap.at("hello").get("hello")} .. " )
print("Value for 'missing': {myMap.get("missing")} ..")  // Should print 'Key not found'
print ""

var key1 := object { var one := "I am key 1"  }
var key2 := object { var one := "I am key 2"  }
var key3 := object { var one := "I am key 3"  }

var object1 := object { var one := "I am object 1" }
var object2 := object { var one := "I am object 2" }
var object3 := object { var one := "I am object 3" }
var objectLoc := object is loc { var one := "I am object loc" }
var objectIso := object is iso { var one := "I am object iso" }
var objectImm := object is imm { var one := "I am object imm" }

var objectMap := makeHashMap.new(3)
objectMap.at(1).put(1, object1)
objectMap.at(2).put(2, object2)
var objectRecieved1 := objectMap.get(1)
var objectRecieved2 := objectMap.get(2)
print(objectRecieved1.one)
print(objectRecieved2.one)

print ""

objectMap.at(3).put(3, objectLoc)
objectMap.at(4).put(4, (objectIso := -1))   // destructive read for iso going into hashmap
objectMap.at(5).put(5, objectImm)

var objectRecievedLoc := objectMap.get(3)
var objectRecievedIso := objectMap.get(4)   //unable to read iso, is there a way to destructively get an object from a hashmap?
var objectRecievedImm := objectMap.get(5)

print(objectRecieved1.one)
print(objectRecieved2.one)

print "-end-"