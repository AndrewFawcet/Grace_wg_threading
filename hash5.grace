// Grace HashMap Implementation
// Node factory for creating a linked list node
var makeNode := object {
    method new(newValue) -> Object {
        object {
            var value := newValue
            var nextNode := -1  // Initially -1 for null

            method setNext(node) {
                nextNode := node
            }

            method getNext() -> Object {
                nextNode
            }
        }
    }
}

// Linked List factory
var makeLinkedList := object {
    var head := -1

    method add(value) {
        var newNode := makeNode.new(value)
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

    method printList() {
        var currentNode := head
        while {currentNode != -1} do {
            print("{currentNode.value.k}: {currentNode.value.v}")
            currentNode := currentNode.getNext()
        }
    }
}

// HashMap factory
var makeHashMap := object {
    method new(size) -> Object {
        object {
            var buckets := array()
            var i := 1
            while { i < size} do {
                buckets.add(makeLinkedList)
                i := i + 1
            }

            method hashKey(key) -> Number {
                print (" key {key} .." )
                var hashValue := hash(key)
                hashValue := hashValue % size
                print (" hash {hashValue} .." )
                return hashValue
            }

            method put(key, value) {
                var index := hashKey(key)
                buckets.get(index).add(object {
                    var k := key
                    var v := value
                })
            }

            method get(key) -> Object {
                var index := hashKey(key)
                var currentNode := buckets.get(index).head
                while {currentNode != -1} do {
                    if (currentNode.value.k == key) then { return currentNode.value.v }
                    currentNode := currentNode.getNext()
                }
                print("Key not found")
                -1
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
