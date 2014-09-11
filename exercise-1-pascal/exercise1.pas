program exercise1;

USES sysutils;

TYPE
  IntegerArray = ARRAY OF integer;
  ProcPtr = function(left, right : Integer): Integer;

	TreeNodePtr = ^TreeNode;
	VisitProcPtr = Procedure(node: TreeNodePtr);
	TreeNode = RECORD
		parent : TreeNodePtr; // pointer to the parent node
		left: TreeNodePtr; // pointer to the left node
		right: TreeNodePtr; // pointer to the right node
		ID: Integer; // Integer ID of the node
		visit: VisitProcPtr; // function pointer to functions that have no return value and a pointer to a node
	END;

{ Compares integer left with the integer right for order. Returns a negative integer, 
zero, or a positive integer as left is less than, equal to, or greater than right }
FUNCTION compareTo(left, right : Integer) : Integer;
BEGIN
	IF left < right THEN
	BEGIN
		exit(-1);
	END
	ELSE IF left > right THEN
	BEGIN
		exit(1);
	END
	ELSE
	BEGIN
		exit(0);
	END
END;

{ Sorts array of integers by Quicksort. The integers are compared using the function 'comparator' }
PROCEDURE QuickSort(Var a : IntegerArray; comparator : ProcPtr);
  PROCEDURE Sort ( left, right : integer );
  VAR 
    i, j, tmp, pivot : integer;
  BEGIN
    i:=left;
    j:=right;
    pivot := a[Random(right - left) + left];

    REPEAT
      // sort_function(a[i], x) < 0
      WHILE comparator(a[i], pivot) < 0 DO 
        i := i + 1;
      // sort_function(a[j], x) > 0
      WHILE comparator(a[j], pivot) > 0 DO
        j := j - 1;
      IF i <= j THEN
      BEGIN
        tmp := a[i];
        a[i] := a[j];
        a[j] := tmp;
        j := j - 1;
        i := i + 1;
      END;
    UNTIL i > j;

    IF left < j THEN
      Sort(left,j);
    IF i < right THEN
      Sort(i,right);
  END;
Begin
  Sort(0, Length(a) - 1);
END;

{ A print-function that can be assigned to the node’s visit function pointer. The
  function prints the node’s ID on STDOUT seperated by a single whitespace }
PROCEDURE print(node: TreeNodePtr);
BEGIN
	write(node^.ID, ' ');
END;

{ Insert new node with ID 'element' at the right place in the tree }
PROCEDURE insertID(VAR Tree : TreeNodePtr; insertID: Integer);
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

	{ Allocate the memory for the nodes dynamically at run-time }
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

{ Depth first traversal that traverses the tree from its root and invokes the visit method
  (http://en.wikipedia.org/wiki/Tree_traversal#Depth-first) }
PROCEDURE depthFirstTraversal(root: TreeNodePtr);
BEGIN 
	IF root <> NIL THEN
	BEGIN
		{ Visit the root. }
		root^.visit(root);
		{ Traverse the left subtree. }
		depthFirstTraversal(root^.left);
		{ Traverse the right subtree. }
		depthFirstTraversal(root^.right);
	END
END;

{ Counts the occurences of separator in str
  Taken and modified from: http://lists.freepascal.org/fpc-pascal/2007-July/014721.html}
function Occurs(const str, separator: string): integer;
var
  i, nSep: integer;
begin
  nSep:= 0;

  for i:= 1 to Length(str) do
    if str[i] = separator then Inc(nSep);

  exit(nSep);
end;

{ Splits string containing Integers separated by separator into array of Integer 
  Taken and modified from: http://lists.freepascal.org/fpc-pascal/2007-July/014719.html }
function Split(const str, separator: string): IntegerArray;
  var 
    i, n: Integer; 
    strline, strfield: string;
    results : IntegerArray;
  begin
    { Number of occurences of the separator }   
    n:= Occurs(str, separator);

    { Size of the array to be returned is the number of occurences of the separator }
    SetLength(results, n + 1);

    i := 0;

    strline:= str;

    repeat 
      if Pos(separator, strline) > 0 then 
        begin 
          strfield:= Copy(strline, 1, Pos(separator, strline) - 1); 
          strline:= Copy(strline, Pos(separator, strline) + 1, Length(strline) - pos(separator,strline)); 
        end 
      else 
        begin 
          strfield:= strline; 
          strline:= ''; 
        end; 
      
      results[i]:= StrToInt(strfield);
      Inc(i);
    until strline= '';

    Exit(results);
  end;

VAR
  number: integer;
  numbersString: String;
  numbersArray: IntegerArray;
  tree: TreeNodePtr;
BEGIN
  { Initialize RNG }
  Randomize;

  { Creating empty tree by setting the "root" node to NIL }
  tree := NIL;

  { Read integers from STDIN and put them into an array }
  ReadLn (numbersString);
  numbersArray := Split(numbersString, ' ');
   
  { Sort in place }
  QuickSort(numbersArray, @compareTo);
  
  { Insert integers into tree }
  FOR number IN numbersArray DO
  BEGIN
    insertID(tree, number); 
  END;

  { Print tree depth-first }
  depthFirstTraversal(tree);
END.