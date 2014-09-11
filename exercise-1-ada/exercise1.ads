package exercise1 is

	type IntegerArray is array (integer range <>) of integer;
	type Comparator_Function_Access is access function (left: integer; right: integer) return integer;

	type TreeNode; -- Forward declaration
	type TreeNode_Access is access all TreeNode;
	type Visit_Procedure_Access is access procedure(node: TreeNode_Access);

	type TreeNode is
	    record
	  		parent: TreeNode_Access;
	    	left: TreeNode_Access;
	    	right: TreeNode_Access;
	    	ID: integer;
	    	visit: Visit_Procedure_Access;
	    end record;

	-- Compares integer left with the integer right for order. Returns a negative integer, 
	-- zero, or a positive integer as left is less than, equal to, or greater than right
	function compareTo(left, right : Integer) return integer;

	-- Sorts array of integers by Quicksort. The integers are compared using the function 'comparator'
	PROCEDURE QuickSort(a : in out IntegerArray; comparator : Comparator_Function_Access);

	-- A print-function that can be assigned to the node’s visit function pointer. The
	-- function prints the node’s ID on STDOUT seperated by a single whitespace
	PROCEDURE print(node: TreeNode_Access);

	-- Integer to String
	-- Taken from: http://stackoverflow.com/a/24671425
	function To_String(I : Integer) return String;

	-- Insert new node with ID 'element' at the right place in the tree
	PROCEDURE insertID(Tree : in out TreeNode_Access; insertID: Integer);

	-- Depth first traversal that traverses the tree from its root and invokes the visit method
	-- (http://en.wikipedia.org/wiki/Tree_traversal#Depth-first)
	PROCEDURE depthFirstTraversal(root: TreeNode_Access);

	-- Counts the occurences of separator in str
	-- Ported to Ada from: http://lists.freepascal.org/fpc-pascal/2007-July/014721.html}
	function Occurs(str: string; separator: character) return integer;

	-- Tokenize String into array of integer
	-- Taken and modified from: http://rosettacode.org/wiki/Tokenize_a_string#Ada
	function Split(Source_String: string; separator: string) return IntegerArray;

end exercise1;