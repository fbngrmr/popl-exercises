with Ada.Text_IO;

package body exercise1 is

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
	    --pivot := a[Random(right - left) + left];
	    pivot := right - left;

	    loop
	      -- sort_function(a[i], x) < 0
	      WHILE comparator.all(a(i), pivot) < 0 loop 
	        i := i + 1;
	      end loop;
	      -- sort_function(a[j], x) > 0
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
  Sort(0, a'Length - 1);
END;

-- A print-function that can be assigned to the node’s visit function pointer. The
-- function prints the node’s ID on STDOUT seperated by a single whitespace
PROCEDURE print(node: TreeNodePtr) is
BEGIN
	Ada.Text_IO.Put(node^.ID, ' ');
END;
begin
	Ada.Text_IO.Put_Line("Hello, world!");
end exercise1;