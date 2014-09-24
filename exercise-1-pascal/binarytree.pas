program binarytree;


TYPE
	TreeNodePtr = ^TreeNode;
	VisitProcPtr = Procedure(node: TreeNodePtr);
	TreeNode = RECORD
		parent : TreeNodePtr; // pointer to the parent node
		left: TreeNodePtr; // pointer to the left node
		right: TreeNodePtr; // pointer to the right node
		ID: integer; // integer ID of the node
		visit: VisitProcPtr; // function pointer to functions that have no return value and a pointer to a node
	END;

// A print-function that can be assigned to the node’s visit function pointer. The
// function prints the node’s ID on STDOUT seperated by a single whitespace
PROCEDURE print(node: TreeNodePtr);
BEGIN
	write(node^.ID, ' ');
END;

// Insert new node with ID 'element' at the right place in the tree
PROCEDURE insertID(VAR Tree : TreeNodePtr; insertID: integer);
VAR
	InsertNode : TreeNodePtr;
	ParentPtr : TreeNodePtr;
	CurrentNodePtr : TreeNodePtr;

BEGIN
	CurrentNodePtr := Tree;
	ParentPtr := NIL;

	WHILE (CurrentNodePtr <> NIL) DO
	IF CurrentNodePtr^.ID <> insertID THEN
	BEGIN
		ParentPtr := CurrentNodePtr;

		IF CurrentNodePtr^.ID > insertID THEN
			CurrentNodePtr := CurrentNodePtr^.left
		ELSE 
			CurrentNodePtr := CurrentNodePtr^.right
	END;

	// Allocate the memory for the nodes dynamically at run-time
	New (insertNode);
	insertNode^.parent := ParentPtr;
	insertNode^.left := NIL;
	insertNode^.right := NIL;
	insertNode^.ID := insertID;
	insertNode^.visit := @print;

	IF ParentPtr = NIL THEN 
		Tree := InsertNode
	ELSE
		IF ParentPtr^.ID > insertID THEN 
			ParentPtr^.left := insertNode
		ELSE 
			ParentPtr^.right := insertNode
END;

// Depth first traversal that traverses the tree from its root and invokes the visit method
// (http://en.wikipedia.org/wiki/Tree_traversal#Depth-first)
PROCEDURE depthFirstTraversal(root: TreeNodePtr);
BEGIN 
	IF root <> NIL THEN
	BEGIN
		// Visit the root.
		root^.visit(root);
		// Traverse the left subtree.
		depthFirstTraversal(root^.left);
		// Traverse the right subtree.
		depthFirstTraversal(root^.right);
	END
END;

VAR
   tree: TreeNodePtr;
BEGIN
	// Creating empty tree by setting the "root" node to NIL
	tree := NIL;

	insertID(tree, 5);
	insertID(tree, 2);
	insertID(tree, 6);
	insertID(tree, 7);
	insertID(tree, 1);

	depthFirstTraversal(tree);
END.