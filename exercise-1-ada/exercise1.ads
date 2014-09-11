with Ada.Text_IO;

package exercise1 is

	type IntegerArray is array (integer range <>) of integer;
	type Comparator_Function_Access is access function (left: integer; right: integer) return integer;
	type TreeNode;
	type TreeNode_Access is access TreeNode;
	type TreeNode is
	    record
	  		parent: TreeNode_Access;
	    	left: TreeNode_Access;
	    	right: TreeNode_Access;
	    	ID: integer;
	    	visit: Comparator_Function_Access;
	    end record;

	-- Compares integer left with the integer right for order. Returns a negative integer, 
	-- zero, or a positive integer as left is less than, equal to, or greater than right
	function compareTo(left, right : Integer) return integer;

	-- Sorts array of integers by Quicksort. The integers are compared using the function 'comparator'
	PROCEDURE QuickSort(a : in out IntegerArray; comparator : Comparator_Function_Access);

	-- A print-function that can be assigned to the node’s visit function pointer. The
	-- function prints the node’s ID on STDOUT seperated by a single whitespace
	PROCEDURE print(node: TreeNodePtr)
end exercise1;