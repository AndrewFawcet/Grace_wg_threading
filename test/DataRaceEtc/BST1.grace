var BSTNode := object {
    method new(k, v) -> Object {
        object {
            var key := k
            var value := v
            var left := -1
            var right := -1
        }
    }
}


var BST := object {
    var root := -1

    method insert(k, v) {
        if (root == -1) then {
            root := BSTNode.new(k, v)
        } else {
            insertHelper(root, k, v)
        }
    }

    method insertHelper(node, k, v) {
        if (k < node.key) then {
            if (node.left == -1) then {
                node.left := BSTNode.new(k, v)
            } else {
                insertHelper(node.left, k, v)
            }
        } elseif (k > node.key) then {
            if (node.right == -1) then {
                node.right := BSTNode.new(k, v)
            } else {
                insertHelper(node.right, k, v)
            }
        } else {
            node.value := v  // Update value if key already exists
        }
    }

    method search(k) {
        return searchHelper(root, k)
    }

    method searchHelper(node, k) {
        if (node == -1) then {
            return -1
        } elseif (k == node.key) then {
            return node.value
        } elseif (k < node.key) then {
            return searchHelper(node.left, k)
        } else {
            return searchHelper(node.right, k)
        }
    }
}

// Creating a new BST and inserting random key-value pairs
var myBST := BST
myBST.insert(50, "A")
myBST.insert(30, "B")
myBST.insert(70, "C")
// myBST.insert(20, "D")
// myBST.insert(40, "E")
// myBST.insert(60, "F")
// myBST.insert(80, "G")