// Grace HashTable Implementation
// Developing to have isolation.

// Node factory for creating a linked list node
var makeNode := object {
    method new(newValue) -> Object {
        object {
            var value := newValue
            var nextNode := -1  // Initially -1 for null

            method printValues() {
                print " {value} "
                if (nextNode != -1) then {
                    nextNode.printValues() 
                }
            }

            method addNewValue(newValue) {
                if (nextNode != -1) then {
                    nextNode.addNewValue(newValue) 
                } else {
                    nextNode := makeNode.new(newValue)
                }
            }

            method getKeyValue(keyValue) {
                if ( value.k == keyValue) then {
                    return value.v
                } else {
                    if (nextNode != -1) then {
                        nextNode.getKeyValue(keyValue)
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
    object {
        var head := -1

        method add(value) {
            if (head == -1) then {
                head := makeNode.new(value)
            } else {
                head.addNewValue(value)
            }
        }

        method get(keyValue) {
            if (head == -1) then {
                return "empty bucket"
            } else {
                head.getKeyValue(keyValue)
            }
        }

        method printList() {
            if (head != -1) then {
                head.printValues()
            }
        }
    }
}

// HashMap factory
var makeHashMap := object {
    method new(size) -> Object {
        object {
            var buckets := array()
            var i := 0
            while { i < size} do {
                buckets.add(makeLinkedList())  // creates a linked list in each bucket
                i := i + 1
            }

            method hashKey(key) -> Number {
                var hashValue := hash(key)
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
                    buckets.get(index).head.getKeyValue(key)
                }
                return ("Key not found")
            }

            method printAll() {
                var i := 0
                while { i < size } do {
                    print("Bucket {i}:")
                    if (buckets.get(index).head != -1) then {
                    buckets.get(index).head.getKeyValue(index)
                }
                    buckets.get(i).printList()
                    i := i + 1
                }
            }
        }
    }
}

// Example usage
var myMap := makeHashMap.new(10)
myMap.put("hello", 123)
myMap.put("world", 456)

print("Value for 'hello': {myMap.get("hello")}  ..")  // Should print 123
print("Value for 'world': {myMap.get("world")}  ..")  // Should print 456
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

otherMap.printAll()
print ""
myMap.printAll()