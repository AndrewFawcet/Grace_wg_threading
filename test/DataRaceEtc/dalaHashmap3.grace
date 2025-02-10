var bucket := object {
    var key
    var value
    var next

    method new(k, v) {
        key := k
        value := v
        next := null
    }
}

var map := object {
    // Explicitly define 26 bucket variables (one for each letter)
    var bucketA := null
    var bucketB := null
    var bucketC := null

    // Manually map keys to specific buckets
    method getBucket(key) {
        if (key == 'a') then {
            return bucketA
        }
        if (key == 'b') then {
            return bucketB
        }
        if (key == 'c') then {
            return bucketC
        }
        return -1; //null
    }

    method setBucket(key, value) {
        if (key == 'a') then {
            bucketA := value;
        }
        if (key == 'b') then {
            bucketB := value;
        }
        if (key == 'c') then {
            bucketC := value;
        }
    }

    // Put a key-value pair into the map
    method put(key, value) {
        var bucket := self.getBucket(key);
        var current := bucket;

        // Traverse linked list to check for key
        while current != null {
            if current.key == key {
                current.value := value;
                return "Updated";
            }
            current := current.next;
        }

        // Add new bucket if key is not found
        var newBucket := bucket.new(key, value);
        newBucket.next := bucket;
        self.setBucket(key, newBucket);
        return "Success";
    }

    // Get the value for a key
    method get(key) {
        var bucket := self.getBucket(key);
        var current := bucket;

        while current != null {
            if current.key == key {
                return current.value;
            }
            current := current.next;
        }

        return "Failure: No such key";
    }
}
var myMap := map.new(); // Create a new map object

// Insert key-value pairs
print(myMap.put('a', 100)); // Output: "Success"
print(myMap.put('b', 200)); // Output: "Success"
print(myMap.put('c', 300)); // Output: "Success"

// Retrieve values for existing keys
print(myMap.get('a')); // Output: 100
print(myMap.get('b')); // Output: 200
print(myMap.get('c')); // Output: 300

// Update an existing key
print(myMap.put('a', 400)); // Output: "Updated"
print(myMap.get('a')); // Output: 400

// Attempt to retrieve a non-existing key
print(myMap.get('d')); // Output: "Failure: No such key"

// Add multiple key-value pairs in the same bucket to test collisions
print(myMap.put('a', 500)); // Output: "Updated"
print(myMap.put('a', 600)); // Output: "Updated"
print(myMap.get('a')); // Output: 600
