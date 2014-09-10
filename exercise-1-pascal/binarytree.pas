program binarytree;

TYPE
	TreeNodePtr = ^TreeNode;
	VisitProcPtr = Procedure(node: TreeNodePtr);
	TreeNode = RECORD
		parent : TreeNodePtr;
		left: TreeNodePtr;
		right: TreeNodePtr;
		ID: integer;
		visit: VisitProcPtr;
	END;

PROCEDURE Visit(node: TreeNodePtr);
	BEGIN
		writeln(node^.ID);
	END;

(* Add Element to the binary search tree. Assumes that no *)
(* element with the same key exists in the tree. *)
PROCEDURE InsertElement(VAR Tree : TreeNodePtr; element: integer);
VAR
	NewNode : TreeNodePtr; (* pointer to new node *)
	ParentPtr : TreeNodePtr; (* points to new node's parent *)
	CurrentNodePtr : TreeNodePtr;

FUNCTION FindNode (Tree : TreeNodePtr; ID : integer) : TreeNodePtr;
VAR
	Found : Boolean;
	CurrentNodePtr : TreeNodePtr;
	ParentPtr : TreeNodePtr;
BEGIN
	(* Set up to search. *)
	CurrentNodePtr := Tree;
	ParentPtr := NIL;
	Found := False;

	(* Search until no more nodes to search or until found. *)
	WHILE (CurrentNodePtr <> NIL) AND NOT Found DO
	IF CurrentNodePtr^.ID = ID THEN
		Found := True
	ELSE
	BEGIN
		ParentPtr := CurrentNodePtr;

		IF CurrentNodePtr^.ID > ID THEN
			CurrentNodePtr := CurrentNodePtr^.left
		ELSE 
			CurrentNodePtr := CurrentNodePtr^.right
	END;

	exit(ParentPtr);
END;

BEGIN (* InsertElement *)
	(* Create a new node. *)
	New (NewNode);
	NewNode^.left := NIL;
	NewNode^.right := NIL;
	NewNode^.ID := Element;
	NewNode^.visit := @Visit;

	(* Search for the insertion place. *)
	//ParentPtr := FindNode (Tree, element);

	(* Set up to search. *)
	CurrentNodePtr := Tree;
	ParentPtr := NIL;

	(* Search until no more nodes to search or until found. *)
	WHILE (CurrentNodePtr <> NIL) DO
	IF CurrentNodePtr^.ID = element THEN
		//Found := True
	ELSE
	BEGIN
		ParentPtr := CurrentNodePtr;

		IF CurrentNodePtr^.ID > element THEN
			CurrentNodePtr := CurrentNodePtr^.left
		ELSE 
			CurrentNodePtr := CurrentNodePtr^.right
	END;

	(* IF this is first node in tree, set Tree to NewNode; *)
	(* otherwise, link new node to Node(ParentPtr). *)
	IF ParentPtr = NIL THEN 
		Tree := NewNode (* first node in the tree *)
	ELSE (* Add to the existing tree. *)
		IF ParentPtr^.ID > element THEN 
			ParentPtr^.left := NewNode
		ELSE 
			ParentPtr^.right := NewNode
END; (* InsertElement *)

PROCEDURE DepthFirstTraversal(root: TreeNodePtr);
BEGIN 
	IF root <> NIL THEN
	BEGIN
		// Visit the root.
		root^.visit(root);
		//Traverse the left subtree.
		DepthFirstTraversal(root^.left);
		//Traverse the right subtree.
		DepthFirstTraversal(root^.right);
	END
END;

VAR
   tree: TreeNodePtr;
BEGIN
	writeln('Creating Tree');
	tree := NIL;

	InsertElement(tree, 5);
	InsertElement(tree, 2);
	InsertElement(tree, 6);
	InsertElement(tree, 7);
	InsertElement(tree, 1);

	DepthFirstTraversal(tree);
END.