PROGRAM quicksort;

{$mode objfpc}{$H+}
uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes;

const
   max = 10;

TYPE
   IntegerArray = array of integer;
   ProcPtr = function(left, right : integer): integer;

FUNCTION compareTo(left, right : integer) : integer;
   BEGIN
      if left < right then
         begin
            exit(-1);
         end
      else if left > right then
         begin
            exit(1);
         end
      else
         begin
            exit(0);
         end
   END;

{ Note: "var" means a is passed by REFERENCE }
PROCEDURE qsort(VAR a: IntegerArray; sort_function : ProcPtr);
{ sort array a using quicksort }

   procedure sort(l, r: integer);
   { local procedure to sort a[l..r] }
   
      procedure swap(var x, y: integer);
      { local procedure to swap x and y. }
         var
            tmp : integer;
         begin
            tmp := x;
            x := y;
            y := tmp;
         end; { swap }
   
      var
         i, j, x: integer;
      begin
               
         i := l;
         j := r;
         x := a[Random(r - l) + l];  

         repeat
            while sort_function(a[i], x) < 0 do
               i := i + 1;
      
            while sort_function(a[j], x) > 0 do
               j := j - 1;

            if not(i > j) then
               begin
                  swap(a[i], a[j]);
                  i := i + 1;
                  j := j - 1;
               end;
         until i > j;

         if l < j then
            sort(l, j);
         if i < r then
            sort(i, r);
         end; { sort }

   begin
      sort(1, max);
   end; { qsort }

var
   data: IntegerArray;
   i: integer;
begin
   { Dynamically initialize array }
   SetLength(data, max);

   write('Creating ',Max,' random numbers between 1 and 500000');
   randomize;
   for i := 1 to max do
      data[i] := 1 + random(100);
   writeln;
   writeln('Sorting...');

   qsort(data, @compareTo);
   
   writeln('Printing the last ',max,' numbers:');
   for i := 1 to max do
   begin
      write(data[i]:7);
      if (i mod 10)=0 then
      writeln;
   end;
end.