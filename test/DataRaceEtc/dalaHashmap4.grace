
print("here" )
// Node for storing key-value pairs
var makeNode := object {
    method new(newKey, newValue) -> Object {
        object {
            var key := newKey
            var value := newValue
            var nextNode := -1

            print(" making a node " )
            method setNext(node) { nextNode := node }
            method getNext() { return nextNode }
        }
    }
}
print("here" )
// Linked list to store nodes
var makeLinkedList := object {
    method new() -> Object {
        object {
            var head := -1

            // Add a node to the list
            method add(key, value) {
                var newNode := makeNode.new(key, value)
                if (head == -1) then {
                    head := newNode
                } else {
                    var currentNode := head
                    while {currentNode.getNext() != -1} do {
                        currentNode := currentNode.getNext()
                    }
                    currentNode.setNext(newNode)
                }
            }

            // Get a value by key, returns an object
            method get(key) {
                var currentNode := head
                while {currentNode != -1} do {
                    if (currentNode.key == key) then {
                        return currentNode.value
                    }
                    currentNode := currentNode.getNext()
                }
                return -1
            }

            // Update the value for a given key, return number as a bool
            method update(key, newValue) {
                var currentNode := head
                while {currentNode != -1} do {
                    if (currentNode.key == key) then {
                        currentNode.value := newValue
                        return 1
                    }
                    currentNode := currentNode.getNext()
                }
                return 0
            }
            
            // Print the linked list contents
            method printList() {
                var currentNode := head
                if (currentNode == -1) then {
                    print "Empty bucket"
                    return -1
                }
                while {currentNode != -1} do {
                    print "currentNode "
                    print "Key: {currentNode.key}, Value: {currentNode.value}"
                    currentNode := currentNode.getNext()
                }
            }

        }
    }
}

// simple hash function for string keys which returns a number
method simpleHash(key, bucketCount) -> Number {
    var hashValue := 0
    hashValue := bucketCount
    // return hashValue - (hashValue / bucketCount) * bucketCount
    return hashValue
}

// HashMap implementation using a linked list of buckets
var makeHashMap := object {
    // makes a new bucket, returns an object
    method new(bucketCount) {
        object {
            var bucketList := makeLinkedList.new()

            // Initialize buckets
            var i := 0
            while {i  < bucketCount} do {
                bucketList.add(i, makeLinkedList.new())
                i := i + 1 
            }

            // Hash function returns a number
            method hash(key) {
                // return key.hashCode() % bucketCount
                // return key.hashCode()
                return simpleHash(key, bucketCount)
            }

            // Add or update a key-value pair
            method put(key, value) {
                var bucketIndex := hash(key)
                var bucket := bucketList.get(bucketIndex)
                print "--here"
                if (bucket != -1) then {
                    // print "----here {bucket.update(key, value)} ...."
                    if (bucket.update(key, value) == 1) then {
                        print "------here"
                        // Key already exists, value updated
                        return -1
                    }
                }
                print "----here {bucket} .."
                // Key doesn't exist; add a new node
                if (bucket == -1) then {
                    print "-== -1 bucket -here {bucket} .."

                    bucket := makeLinkedList.new()
                    bucketList.add(bucketIndex, bucket)
                }
                print ("end of method")
                // bucket.add(key, value)
            }

            // Get the value associated with a key
            method get(key) -> Object {
                var bucketIndex := hash(key)
                var bucket := bucketList.get(bucketIndex)
                return bucket.get(key)
            }

            // Print the entire hashmap
            method printMap() {
                var j := 0
                print "_____here"
                while {j < bucketCount} do {
                    var bucket := bucketList.get(j)
                    print "Bucket {j} : "
                    bucket.printList()
                    j := j + 1
                }
            }
        }
    }
}

// Create a new hashmap with 3 buckets
var myHashMap := makeHashMap.new(3)

// Add key-value pairs
// myHashMap.put("apple", 10)
myHashMap.put("banana", 20)
myHashMap.put("pear", 30)
// myHashMap.put("kiwi", 40)

// Print hashmap contents
myHashMap.printMap()

// Retrieve values by key
// print "Value for 'apple': {myHashMap.get('apple')} .."
// print "Value for 'kiwi': {myHashMap.get('kiwi')} .."
