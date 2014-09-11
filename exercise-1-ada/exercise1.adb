with Ada.Text_IO;
with Ada.Text_IO.Unbounded_IO;
with Ada.Strings;
with Ada.Strings.Unbounded;
with Ada.Strings.Fixed;
with System.Address_Image;

use Ada.Strings.Fixed;
use Ada.Strings.Unbounded;
use System;

package body exercise1 is

-- Integer to String
-- Taken from: http://stackoverflow.com/a/24671425
function To_String(I : Integer) return String is
begin
   return Ada.Strings.Fixed.Trim(Integer'Image(I), Ada.Strings.Left);
end To_String;

-- Compares integer left with the integer right for order. Returns a negative integer, 
-- zero, or a positive integer as left is less than, equal to, or greater than right
function compareTo(left, right : Integer) return Integer is
begin
	IF left < right THEN
		return(-1);
	ELSIF left > right THEN
		return(1);
	ELSE
		return(0);
	END IF;
end;

-- Sorts array of integers by Quicksort. The integers are compared using the function 'comparator'
PROCEDURE QuickSort(a : in out IntegerArray; comparator : Comparator_Function_Access) is
  	PROCEDURE Sort ( left, right : integer ) is
		i, j, tmp, pivot : integer;
  	BEGIN
	    i := left;
	    j := right;
	    pivot := a((left + right) / 2);

	    loop
	      	WHILE comparator.all(a(i), pivot) < 0 loop 
	        	i := i + 1;
	      	end loop;
	      
			WHILE comparator.all(a(j), pivot) > 0 loop
				j := j - 1;
			end loop;

			IF i <= j THEN
				tmp := a(i);
				a(i) := a(j);
				a(j) := tmp;
				j := j - 1;
				i := i + 1;
			END IF;

	      	exit when i > j;
	    end loop;

	    IF left < j THEN
	      Sort(left,j);
	    END IF;

	    IF i < right THEN
	      Sort(i,right);
	    END IF;
  	END;
Begin
  Sort(1, a'Length);
END;

-- A print-function that can be assigned to the node’s visit function pointer. The
-- function prints the node’s ID on STDOUT seperated by a single whitespace
PROCEDURE print(node: TreeNode_Access) is
BEGIN
	Ada.Text_IO.Put(To_String(node.all.ID) & ' ');
END;

-- Insert new node with ID 'element' at the right place in the tree
PROCEDURE insertID(Tree : in out TreeNode_Access; insertID: Integer) is
	insertNode : TreeNode_Access;
	ParentPtr : TreeNode_Access;
	CurrentNodePtr : TreeNode_Access;
BEGIN
	CurrentNodePtr := Tree;
	ParentPtr := null;

	WHILE (CurrentNodePtr /= null) LOOP
		IF CurrentNodePtr.all.ID /= insertID THEN
			ParentPtr := CurrentNodePtr;

			IF CurrentNodePtr.all.ID > insertID THEN
				CurrentNodePtr := CurrentNodePtr.all.left;
			ELSE 
				CurrentNodePtr := CurrentNodePtr.all.right;
			END IF;
		END IF;
	END loop;

	-- Allocate the memory for the nodes dynamically at run-time }
	insertNode := new TreeNode'(ParentPtr, null, null, insertID, print'Access);

	IF ParentPtr = null THEN
		Tree := insertNode;
	ELSE
		IF ParentPtr.all.ID > insertID THEN 
			ParentPtr.all.left := insertNode;
		ELSE 
			ParentPtr.all.right := insertNode;
		END IF;
	END IF;
END;

-- Depth first traversal that traverses the tree from its root and invokes the visit method
-- (http://en.wikipedia.org/wiki/Tree_traversal#Depth-first)
PROCEDURE depthFirstTraversal(root: TreeNode_Access) is
BEGIN 
	IF root /= null THEN
		-- Visit the root
		root.all.visit.all(root);
		--Ada.Text_IO.Put_Line("DEBUG: Node ID = " & To_String(root.all.ID));
		-- Traverse the left subtree
		depthFirstTraversal(root.all.left);
		-- Traverse the right subtree
		depthFirstTraversal(root.all.right);
	END IF;
END;

-- Counts the occurences of separator in str
-- Ported to Ada from: http://lists.freepascal.org/fpc-pascal/2007-July/014721.html}
function Occurs(str: string; separator: character) return integer is
  nSep: integer;
begin
  	nSep:= 0;

	for i in str'Range loop
	  if str(i) = separator then
	  	nSep := nSep + 1;
	  end if;
	end loop;
	
	return nSep;
end;

-- Tokenize String into array of integer
-- Taken and modified from: http://rosettacode.org/wiki/Tokenize_a_string#Ada
function Split(Source_String: string; separator: string) return IntegerArray is
	ParsedNumbers_Array : IntegerArray(1..Occurs(Source_String, separator(separator'First)) + 1);
   	Index_List : array(Source_String'Range) of Natural;
   	Next_Index : Natural := Index_List'First;
   	i : Integer;
begin
	i := 1;
   	Index_List(Next_Index) := Source_String'First;
	while Index_List(Next_Index) < Source_String'Last loop
	  Next_Index := Next_Index + 1;
	  Index_List(Next_Index) := 1 + Index(Source_String(Index_List(Next_Index - 1)..Source_String'Last), separator);
	  if Index_List(Next_Index) = 1 then 
	     Index_List(Next_Index) := Source_String'Last + 2;
	  end if;

	  ParsedNumbers_Array(i) := Integer'Value(Source_String(Index_List(Next_Index - 1)..Index_List(Next_Index)-2));
	  i := i + 1;
	end loop;

	ParsedNumbers_Array(i) := Integer'Value(Source_String(Index_List(Next_Index)..Source_String'Last));
	return ParsedNumbers_Array;
end;

-- Main
numbersString: Unbounded_String;
tree: TreeNode_Access;

begin
	-- Creating empty tree by setting the "root" node to NIL
	tree := null;

	-- Read integers from STDIN and put them into an array
	--Ada.Text_IO.Unbounded_IO.Get_Line(numbersString);
	numbersString := Ada.Strings.Unbounded.To_Unbounded_String("9 2 1 8 4 7 3 6 5 0");
	
	declare
		numbersArray: IntegerArray := Split(Ada.Strings.Unbounded.To_String(numbersString), " ");
	begin
		-- Sort in place
		--QuickSort(numbersArray, compareTo'Access);

		-- Insert integers into tree
		for i in numbersArray'Range loop
      		--Ada.Text_IO.Put_Line(To_String(numbersArray(i)));
      		insertID(tree, numbersArray(i));
   		end loop;

		-- Print tree depth-first
		depthFirstTraversal(tree);
	end;
end exercise1;