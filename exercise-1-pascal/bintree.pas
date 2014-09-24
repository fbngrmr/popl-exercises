(**************************************************************)
(******* BINARY SEARCH TREE ADT ********)
(**************************************************************)

TYPE
KeyType = Integer; (* the type of key in Info part *)

TreeElementType = RECORD (* the type of the user's data *)
Key : KeyType;
(* other fields as needed. *)
END; (* TreeElementType *)

TreePtrType = ^TreeNodeType;

TreeNodeType = RECORD
Info : TreeElementType; (* the user's data *)
Left : TreePtrType; (* pointer to left child *)
Right : TreePtrType (* pointer to right child *)
END; (* TreeNodeType *)

TreeType = TreePtrType;

TraversalType = (Preorder, Inorder, Postorder);

(******************************************************)

PROCEDURE CreateTree
(VAR Tree : TreeType);

(* Initializes Tree to empty state. *)

BEGIN (* CreateTree *)
Tree := NIL
END; (* CreateTree *)

(*************************************************)

PROCEDURE FindNode
( Tree : TreeType;
KeyValue : KeyType;
VAR NodePtr : TreePtrType;
VAR ParentPtr : TreePtrType);

(* Find the node that contains KeyValue; set NodePtr to *)
(* point to the node and ParentPtr to point to its parent; *)

VAR
Found : Boolean; (* KeyValue found in tree? *)

BEGIN (* FindNode *)

(* Set up to search. *)
NodePtr := Tree;
ParentPtr := NIL;
Found := False;

(* Search until no more nodes to search or until found. *)
WHILE (NodePtr <> NIL) AND NOT Found DO
IF NodePtr^.Info.Key = KeyValue
THEN Found := True

ELSE (* Advance pointers. *)
BEGIN

ParentPtr := NodePtr;

IF NodePtr^.Info.Key > KeyValue
THEN NodePtr := NodePtr^.Left
ELSE NodePtr := NodePtr^.Right

END (* advance pointers *)
END; (* FindNode *)

(********************************************************)

PROCEDURE RetrieveElement
(Tree : TreeType;
KeyValue : KeyType;
VAR Element : TreeElementType;
VAR ValueInTree : Boolean);

(* Searches the binary search tree for the element whose *)
(* key is KeyValue, and returns a copy of the element. *)

VAR
NodePtr : TreePtrType; (* pointer to node with KeyValue *)
ParentPtr : TreePtrType; (* used for FindNode interface *)

BEGIN (* RetrieveElement *)

(* Find node in tree that contains KeyValue. *)
FindNode (Tree, KeyValue, NodePtr, ParentPtr);

ValueInTree := (NodePtr <> NIL);

IF ValueInTree
THEN Element := NodePtr^.Info

END; (* RetrieveElement *)

(***********************************************************)

PROCEDURE ModifyElement
(VAR Tree : TreeType;
ModElement : TreeElementType);

(* ModElement replaces existing tree element with same key. *)
VAR
NodePtr : TreePtrType; (* pointer to node with KeyValue *)
ParentPtr : TreePtrType; (* used for FindNode interface *)

BEGIN (* ModifyElement *)

(* Find the node with the same key as ModElement.Key. *)
FindNode (Tree, ModElement.Key, NodePtr, ParentPtr);

(* NodePtr points to the tree node with same key. *)
NodePtr^.Info := ModElement

END; (* ModifyElement *)

(***************************************************************)

PROCEDURE InsertElement
(VAR Tree : TreeType;
Element : TreeElementType);

(* Add Element to the binary search tree. Assumes that no *)
(* element with the same key exists in the tree. *)

VAR
NewNode : TreePtrType; (* pointer to new node *)
NodePtr : TreePtrType; (* used for FindNode call *)
ParentPtr : TreePtrType; (* points to new node's parent *)

BEGIN (* InsertElement *)

(* Create a new node. *)
New (NewNode);
NewNode^.Left := NIL;
NewNode^.Right := NIL;
NewNode^.Info := Element;

(* Search for the insertion place. *)
FindNode (Tree, Element.Key, NodePtr, ParentPtr);

(* IF this is first node in tree, set Tree to NewNode; *)
(* otherwise, link new node to Node(ParentPtr). *)
IF ParentPtr = NIL
THEN Tree := NewNode (* first node in the tree *)
ELSE (* Add to the existing tree. *)
IF ParentPtr^.Info.Key > Element.Key
THEN ParentPtr^.Left := NewNode
ELSE ParentPtr^.Right := NewNode

END; (* InsertElement *)

(**********************************************************)
{ The following code has been commented out:
PROCEDURE InsertElement
(VAR Tree : TreeType;
Element : TreeElementType);

(* Recursive version of InsertElement operation. *)

BEGIN (* InsertElement *)

IF Tree = NIL
THEN (* Base Case: allocate new leaf Node(Tree) *)
BEGIN
New (Tree);
Tree^.Left := NIL;
Tree^.Right := NIL;
Tree^.Info := Element
END (* IF Tree = NIL *)

ELSE (* General Case: InsertElement into correct subtree *)
IF Element.Key < Tree^.Info.Key
THEN InsertElement (Tree^.Left, Element)
ELSE InsertElement (Tree^.Right, Element)

END; (* InsertElement *)
}

(**********************************************************)

PROCEDURE DeleteElement
(VAR Tree : TreeType;
KeyValue : KeyType);

(* Deletes the element containing KeyValue from the binary *)
(* search tree pointed to by Tree. Assumes that this key *)
(* value is known to exist in the tree. *)

VAR
NodePtr : TreePtrType; (* pointer to node to be deleted *)
ParentPtr : TreePtrType; (* pointer to parent of delete node *)

(********************* Nested Procedures ***********************)

PROCEDURE FindAndRemoveMax
(VAR Tree : TreePtrType;
VAR MaxPtr : TreePtrType);

BEGIN (* FindAndRemoveMax *)

IF Tree^.Right = NIL
THEN (* Base Case: maximum found *)
BEGIN
MaxPtr := Tree; (* return pointer to max node *)
Tree := Tree^.Left (* unlink max node from tree *)
END (* Base Case *)

ELSE (* General Case: find and remove from right subtree *)
FindAndRemoveMax (Tree^.Right, MaxPtr)

END; (* FindAndRemoveMax *)

(*************************************************************)

PROCEDURE DeleteNode
(VAR NodePtr : TreePtrType);

(* Deletes the node pointed to by NodePtr from the binary *)
(* search tree. NodePtr is a real pointer from the parent *)
(* node in the tree, not an external pointer. *)

VAR
TempPtr : TreePtrType; (* node to delete *)

BEGIN (* DeleteNode *)

(* Save the original pointer for freeing the node. *)
TempPtr := NodePtr;

(* Case of no children or one child: *)
IF NodePtr^.Right = NIL
THEN NodePtr := NodePtr^.Left

ELSE (* There is at least one child. *)
IF NodePtr^.Left = NIL
THEN (* There is one child. *)
NodePtr := NodePtr^.Right

ELSE (* There are two children. *)
BEGIN
(* Find and remove the replacement value from *)
(* Node(NodePtr)'s left subtree. *)
FindAndRemoveMax (NodePtr^.Left, TempPtr);

(* Replace the delete element. *)
NodePtr^.Info := TempPtr^.Info

END; (* There are two children. *)

(* Free the unneeded node. *)
Dispose (TempPtr)

END; (* DeleteNode *)
(*****************************************************************)

BEGIN (* DeleteElement *)

(* Find node containing KeyValue. *)
FindNode (Tree, KeyValue, NodePtr, ParentPtr);

(* Delete node pointed to by NodePtr. ParentPtr points *)
(* to the parent node, or is NIL if deleting root node. *)
IF NodePtr = Tree
THEN (* Delete the root node. *)
DeleteNode (Tree)
ELSE
IF ParentPtr^.Left = NodePtr
THEN (* Delete the left child node. *)
DeleteNode (ParentPtr^.Left)
ELSE (* Delete the right child node. *)
DeleteNode (ParentPtr^.Right)

END; (* DeleteElement *)

(***********************************************************)

{The following procedure has been commented out:
PROCEDURE DeleteElement
(VAR Tree : TreeType;
KeyValue : KeyType);

(* Recursive version of DeleteElement operation. *)

BEGIN (* DeleteElement *)

IF KeyValue = Tree^.Info.Key
THEN (* Base Case : delete this node *)
DeleteNode (Tree)

ELSE
IF KeyValue < Tree^.Info.Key
THEN (* General Case 1: delete node from left subtree *)
DeleteElement (Tree^.Left, KeyValue)
ELSE (* General Case 2: delete node from right subtree *)
DeleteElement (Tree^.Right, KeyValue)

END; (* DeleteElement *)
}

(****************************************************************)

PROCEDURE PrintTree
(Tree : TreeType;
TraversalOrder : TraversalType);

(* Print all the elements in the tree, in the order *)
(* specified by TraversalOrder. *)

(********************** Nested Procedures ************************)

PROCEDURE PrintNode
(Element : TreeElementType);

BEGIN (* PrintNode *)

Writeln (Element.Key);
(* other statements as needed *)

END; (* PrintNode *)

(*********************************************************)

PROCEDURE PrintInorder
(Tree : TreeType);

(* Prints out the elements in a binary search tree in *)
(* order from smallest to largest. This procedure is *)
(* a recursive solution. *)

BEGIN (* PrintInorder *)

(* Base Case: If Tree is NIL, do nothing. *)
IF Tree <>NIL
THEN

BEGIN (* General Case *)

(* Traverse left subtree to print smaller values. *)
PrintInorder(Tree^.Left);

(* Print the information in this node. *)
PrintNode(Tree^.Info);
(* Traverse right subtree to print larger values. *)
PrintInorder(Tree^.Right)

END (* General Case *)
END; (* PrintInorder *)

(***************************************************************)

PROCEDURE PrintPreorder
(Tree : TreeType);

(* Print out the elements in a binary search tree in *)
(* preorder. This procedure is a recursive solution. *)

BEGIN (* PrintPreorder *)

(* Base Case: IF Tree is NIL, do nothing. *)
IF Tree <> NIL
THEN (* General Case *)
BEGIN

(* Print the value of this node. *)
PrintNode(Tree^.Info);

(* Traverse the left subtree in preorder. *)
PrintPreorder(Tree^.Left);

(* Traverse the left subtree in preorder. *)
PrintPreorder(Tree^.Right)

END (* General Case *)
END; (* PrintPreorder *)

(***********************************************************)

PROCEDURE PrintPostorder
(Tree : TreeType);

(* Prints out the elements in a binary search tree in *)
(* postorder. This procedure is a recursive solution. *)

BEGIN (* PrintPostorder *)

(* Base Case: If Tree is NIL, do nothing. *)
IF Tree <> NIL
THEN (* General Case *)
BEGIN

(* Traverse the left subtree in postorder. *)
PrintPostorder(Tree^.Left);

(* Traverse the right subtree in postorder. *)
PrintPostorder(Tree^.Right);

(* Print the value of this node. *)
PrintNode(Tree^.Info)

END (* General Case *)
END; (* PrintPostorder *)
(********************************************************)

BEGIN (* PrintTree *)

(* Call internal print procedure according to TraversalOrder. *)
CASE TraversalOrder OF
Preorder : PrintPreorder (Tree);
Inorder : PrintInorder (Tree);
Postorder : PrintPostorder (Tree)
END (* CASE *)

END; (* PrintTree *)

(***********************************************************)

PROCEDURE DestroyTree
(VAR Tree : TreeType);

(* Removes all the elements from the binary search tree *)
(* rooted at Tree, leaving the tree empty. *)

BEGIN (* DestroyTree *)

(* Base Case: If Tree is NIL, do nothing. *)
IF Tree <> NIL
THEN (* General Case *)
BEGIN

(* Traverse the left subtree in postorder. *)
DestroyTree (Tree^.Left);

(* Traverse the right subtree in postorder. *)
DestroyTree (Tree^.Right);

(* Delete this leaf node from the tree. *)
Dispose (Tree);

END (* General Case *)
END; (* DestroyTree *)

(***********************************************************)