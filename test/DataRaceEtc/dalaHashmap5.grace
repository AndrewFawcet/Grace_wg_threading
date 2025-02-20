// Grace HashTable Implementation
// has an isolated linked list in the buckets.

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
                    return value.v
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
var makeHashMap := object is iso{   // factories do not need to be iso, but are for consistency in all objects in and associated with making the hashmap
    method new(size) -> Object {
        object is iso {
            var buckets := array(size)
            var i := 0
            while { i < size} do {
                buckets.get(i).put(makeLinkedList())  // Creates a linked list in each bucket
                i := i + 1
            }

            method hashKey(key) -> Number {
                var hashValue := key.hash()
                hashValue := hashValue % size
                return hashValue
            }

            method at(key) -> Object {
                var index := hashKey(key)
                return buckets.get(index)
            }
        }
    }
}

// Example usage
var myMap := makeHashMap.new(3)
myMap.at("hello").put(123)
myMap.at("world").put(456)

print("Value for 'hello': {myMap.at("hello").get} ..")  // Should print 123
print("Value for 'world': {myMap.at("world").get} ..")  // Should print 456
print("Value for 'missing': {myMap.at("missing").get} ..")  // Should print 'Key not found'

myMap.printAll()

var otherMap := makeHashMap.new(4)
otherMap.at("hello").put(123)
otherMap.at("world").put(456)
otherMap.at("bacon").put(123)
otherMap.at("garlic").put(456)
otherMap.at("chips").put(123)
otherMap.at("cheese").put(456)
otherMap.at("tofu").put(123)
otherMap.at("lamb").put(456)
otherMap.at("sausage").put("sausage")
otherMap.at("steak").put(456)
otherMap.at("potato").put(123)
otherMap.at("onion").put(456)
otherMap.at("chicken").put(123)
otherMap.at("oil").put(456)
otherMap.at("water").put(123)
otherMap.at("chocolate").put(456)
otherMap.at("orange").put(123)
otherMap.at("pear").put(456)
otherMap.at(123456).put(456789123456)
otherMap.at(123457).put(456789123456)
otherMap.at(123458).put(456789123456)
otherMap.at(2).put(456789123456)

otherMap.printAll()
print ""
myMap.printAll()

var aliasMap := myMap.at("rottenBanana").put(789)
myMap.printAll()

var key1 := object { var one := "I am key 1"  }
var key2 := object { var one := "I am key 2"  }
var key3 := object { var one := "I am key 3"  }

var object1 := object { var one := "I am object 1" }
var object2 := object { var one := "I am object 2" }
var object3 := object { var one := "I am object 3" }

var objectMap := makeHashMap.new(3)
var num := key1.hash()
print ("hash num is {num} .. ")
objectMap.at(key1).put(object1)
objectMap.at(key2).put(object2)
objectMap.at(key3).put(object3)
var objectReturned1 := objectMap.at(key1).get
var objectReturned2 := objectMap.at(key2).get
var objectReturned3 := objectMap.at(key3).get
print (objectReturned1.one)
print (objectReturned2.one)
print (objectReturned3.one)
print "-end-"
