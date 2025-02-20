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
            var buckets := array()
            var i := 0
            while { i < size} do {
                buckets.add(makeLinkedList())  // Creates a linked list in each bucket
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
                print("here getting index {index}  .")
                if (buckets.get(index).head != -1) then {
                    print("in here")
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
myMap.put("hello", 123)
myMap.put("world", 456)

print("Value for 'hello': {myMap.get("hello")} ..")  // Should print 123
print("Value for 'world': {myMap.get("world")} ..")  // Should print 456
print("Value for 'missing': {myMap.get("missing")} ..")  // Should print 'Key not found'

myMap.printAll()

var otherMap := makeHashMap.new(4)
otherMap.put("hello", 123)
otherMap.put("world", 456)
otherMap.put("bacon", 123)
otherMap.put("garlic", 456)
otherMap.put("chips", 123)
otherMap.put("cheese", 456)
otherMap.put("tofu", 123)
otherMap.put("lamb", 456)
otherMap.put("sausage", "sausage")
otherMap.put("steak", 456)
otherMap.put("potato", 123)
otherMap.put("onion", 456)
otherMap.put("chicken", 123)
otherMap.put("oil", 456)
otherMap.put("water", 123)
otherMap.put("chocolate", 456)
otherMap.put("orange", 123)
otherMap.put("pear", 456)
otherMap.put(123456, 456789123456)
otherMap.put(123457, 456789123456)
otherMap.put(123458, 456789123456)
otherMap.put(2, 456789123456)

otherMap.printAll()
print ""
myMap.printAll()

// var aliasMap := myMap // wil create a reference error 

var aliasMap := myMap.put("rottenBanana", 789)
// aliasMap("rottenBanana", 789)  // doesn't do anything non usefull alias essentially null
myMap.printAll()

var key1 := object {
    var one := "I am key 1" 
    }
// var key2 := object { var 2 := "I am key 2" }
// var key3 := object { var 3 := "I am key 3" }
// 
var value1 := object {
    var one := "I am value 1" 
    }
// var value1 := object { var 1 := "I am object 1" }
// var value2 := object { var 2 := "I am object 2" }
// var value3 := object { var 3 := "I am object 3" }

var objectMap := makeHashMap.new(3)
var num := key1.hash()
print ("hash num is {num} >> ")
// objectMap.put(key1, value1);
objectMap.put(key1, value1);
var keyReturned := objectMap.get(key1)
print (keyReturned.one)
print "-end-"