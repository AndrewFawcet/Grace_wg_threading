// adapted from Dala paper

// Define the 'bucket' object for holding key-value pairs and a link to the next bucket
bucket: object {
    var key;
    var value;
    var next;

    method new(key, value) {
        key := key;
        value := value;
        next := null;
    }
}

// Define the 'map' object, simulating a hashmap-like structure
map: object {
    var buckets := (0..25).collect { 
        object { var next := null; } 
    };

    // Hash function to determine the index in the 'buckets' array
    method hash(key) {
        return key.hash % 26;
    }

    // 'get' method to retrieve the value for a given key
    method get(key) {
        var index := self.hash(key);
        var current := buckets[index];
        
        while current != null {
            if current.key == key {
                return current.value;
            }
            current := current.next;
        }
        return "Failure: No such key";
    }

    // 'put' method to add a key-value pair
    method put(key, value) {
        var index := self.hash(key);
        var current := buckets[index];
        
        while current != null {
            if current.key == key {
                current.value := value;
                return "Updated";
            }
            current := current.next;
        }
        
        // Add new key-value pair at the front of the linked list
        var newBucket := bucket.new(key, value);
        newBucket.next := buckets[index];
        buckets[index] := newBucket;
        return "Success";
    }

    // Method to handle the 'put' operation received in the message
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

// Method to create a new hashmap with channel communication
method new_hashmap() {
    return spawn (msgs) {
        var map := map.new();
        map.run(msgs);
    };
}

// Define the map proxy object to interact with the hashmap
map_proxy: object {
    use imm

    method put(key, val) {
        var map_ch := channel.new();
        var map := object {
            use iso
            var key := key;
            var val := consume val;
            var reply := map_ch;
        };
        map_ch.send(map); // Send the map to the channel

        // Wait for the response
        var result := map_ch.receive;
        return result;
    }
}

// Construct the hashmap and interact with it using the proxy
var hashmap := new_hashmap(); // Create the hashmap

// Create a map proxy to interact with the hashmap
var proxy := map_proxy.new();

// Use the proxy to put key-value pairs into the hashmap
proxy.put('a', 100);
proxy.put('b', 200);

// Retrieve values using the proxy (you would need a get method similar to put)
print(proxy.put('a', 100)) // Should print "Success"
print(proxy.put('b', 200)) // Should print "Success"
