// Define the 'bucket' object, which stores the key-value pair and a link to the next bucket (in case of collisions)
bucket: object {
    var key;
    var value;
    var next;

    // Method to initialize a new bucket with key-value and next as null
    method new(key, value) {
        key := key;
        value := value;
        next := null;
    }
}

// Define the 'map' object, which will hold the hashmap-like structure
map: object {
    // 'buckets' is a collection of 26 objects (one for each letter of the alphabet)
    var buckets := (0..25).collect { 
        object {
            var next := null;
        }
    };

    // Method to calculate a hash for the key (using its character value and simple modulus operation)
    method hash(key) {
        return key.hash % 26;
    }

    // Method to get the value corresponding to a key
    method get(key) {
        var index := self.hash(key);  // Find the appropriate bucket
        var current := buckets[index]; // Get the first bucket in the index
        
        // Traverse the linked list to find the key
        while current != null {
            if current.key == key {
                return current.value; // Return the value if key is found
            }
            current := current.next; // Move to the next bucket in the list
        }
        return "Failure: No such key"; // Key not found
    }

    // Method to put a key-value pair into the map
    method put(key, value) {
        var index := self.hash(key);  // Find the appropriate bucket
        var current := buckets[index]; // Get the first bucket in the index
        
        // Traverse the linked list to check if the key already exists
        while current != null {
            if current.key == key {
                current.value := value; // Update the value if the key already exists
                return "Updated"; // Return "Updated" to indicate the key-value pair was updated
            }
            current := current.next; // Move to the next bucket in the list
        }

        // If the key does not exist, create a new bucket and insert it at the beginning of the linked list
        var newBucket := bucket.new(key, value);
        newBucket.next := buckets[index];
        buckets[index] := newBucket; // Insert the new bucket at the beginning of the list
        return "Success"; // Return "Success" to indicate the new key-value pair was added
    }

    // Method to update a key-value pair (same as 'put' in this case)
    method update(key, value) {
        return self.put(key, value);
    }

    // Method to run and process a message (simulating the original 'run' method from your example)
    method run(msgs) {
        var msg := msgs;
        var k := msg.key.freeze();
        var c := msg.reply;

        if (msg.op == "done") return "done";
        if (msg.op == "get") c := self.get(k);
        if (msg.op == "put") c := self.put(k, msg.val);
        if (msg.op == "update") {
            self.get(k); 
            c := self.put(k, msg.val);
        }
        self.run(msgs);
    }
}

// Create a new map object
var myMap := map.new();

// Insert some key-value pairs into the map
myMap.put('a', 100);
myMap.put('b', 200);

// Retrieve a value by key
print(myMap.get('a')) // Output: 100
print(myMap.get('b')) // Output: 200
print(myMap.get('c')) // Output: "Failure: No such key"

// Update a value for an existing key
myMap.update('a', 300);
print(myMap.get('a')) // Output: 300

// Simulating the run method (sending messages to the map)
var msg := object {
    var op := "put";
    var key := 'd';
    var val := 400;
    var reply := null;
};
myMap.run([msg]);
print(myMap.get('d')) // Output: 400
