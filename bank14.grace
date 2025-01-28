// Creating a list
def myList := List.of(["Alice", "Bob", "Charlie"])
print("Original List: {myList}")  // Outputs: ["Alice", "Bob", "Charlie"]

// Accessing elements
print("First Element: {myList.at(1)}")  // Grace uses 1-based indexing: Outputs "Alice"
print("Second Element: {myList.at(2)}") // Outputs "Bob"

// Adding elements
myList.add("Diana")
print("After Adding: {myList}")  // Outputs: ["Alice", "Bob", "Charlie", "Diana"]

// Removing elements
myList.removeAt(2)
print("After Removing Second Element: {myList}")  // Outputs: ["Alice", "Charlie", "Diana"]

// Iterating over a list
print("Iterating over List:")
for (element in myList) do {
    print(element)  // Prints each element on a new line
}

// Checking the size of a list
print("List Size: {myList.size}")  // Outputs: 3

// Copying a list
def copiedList := myList.copy
print("Copied List: {copiedList}")  // Outputs: ["Alice", "Charlie", "Diana"]
