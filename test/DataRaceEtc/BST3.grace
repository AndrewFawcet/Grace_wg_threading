// Binary Search Tree
// To emulate examples from "Domains: Safe Sharing Among Actors"
// file:///C:/PhD/Research%20Papers/Other/2414639.2414644.pdf

var BSTNode := object {
    method new(k, v) -> Object {
        print "Creating node with key {k} and value {v}"
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
        print "Inserting key {k} .. "
        print "with value {v} .. "
        if (root == -1) then {
            print "Setting root node"
            root := BSTNode.new(k, v)
        } else {
            print "Calling insertHelper"
            insertHelper(root, k, v)
        }
    }

    method insertHelper(node, k, v) {
        print "insertHelper called for key {k} .."
        if (k < node.key) then {
            print "Going left"
            if (node.left == -1) then {
                print "Inserting at left"
                node.left := BSTNode.new(k, v)
            } else {
                insertHelper(node.left, k, v)
            }
        } else {
            print "Going right"
            if (node.right == -1) then {
                print "Inserting at right"
                node.right := BSTNode.new(k, v)
            } else {
                insertHelper(node.right, k, v)
            }
        }
    }

    method search(k) {
        print "Searching for key {k} .."
        return searchHelper(root, k)
    }

    method searchHelper(node, k) {
        print "searchHelper called for key {k} .."
        if (node == -1) then {
            print "Key {k} not found"
            return -1
        } elseif (k == node.key) then {
            print "Key {k} found .."
                print "with value {node.value} .. "
                return node.value
        } elseif (k < node.key) then {
            print "Searching left"
                return searchHelper(node.left, k)
        } else {
            print "Searching right"
                return searchHelper(node.right, k)
        }
    }
}

// Creating a new BST and inserting random key-value pairs
var myBST := BST
myBST.insert(50, "A")
myBST.insert(30, "B")
myBST.insert(70, "C")
myBST.insert(20, "D")
myBST.insert(40, "E")
myBST.insert(60, "F")
myBST.insert(80, "G")
