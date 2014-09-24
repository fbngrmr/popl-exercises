PROGRAM quicksort;

TYPE
   IntegerArray = array of integer;

Procedure QuickSort(Var X : IntegerArray);
  Procedure Sort ( Left, Right : LongInt );
  Var 
    i, j : LongInt;
    tmp, pivot : LongInt;         { tmp & pivot are the same type as the elements of array }
  Begin
    i:=Left;
    j:=Right;
    pivot := X[(Left + Right) shr 1]; // pivot := X[(Left + Rigth) div 2] 
    Repeat
      While pivot > X[i] Do i:=i+1;
      While pivot < X[j] Do j:=j-1;
      If i<=j Then Begin
        tmp:=X[i];
        X[i]:=X[j];
        X[j]:=tmp;
        j:=j-1;
        i:=i+1;
      End;
    Until i>j;
    If Left<j Then Sort(Left,j);
    If i<Right Then Sort(i,Right);
  End;
Begin
  Sort(0, Length(X) - 1);
END;

var
   data: IntegerArray;
   i: integer;
begin
   { Dynamically initialize array }
   SetLength(data, 10);

   write('Creating ',10,' random numbers between 1 and 500000');
   randomize;
   for i := 0 to 9 do
      data[i] := 1 + random(100);
   writeln('Sorting...');

   writeln('Printing the last ',10,' numbers:');
   for i in data do
   begin
      writeln(i);
   end;

   QuickSort(data);
   
   writeln('Printing the last ',10,' numbers:');
   for i in data do
   begin
      writeln(i);
   end;
end.