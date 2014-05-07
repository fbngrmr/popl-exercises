PROGRAM quicksort;

const
   max = 800000;

TYPE
   LongIntegerArray = array of longint;

{ Note: "var" means a is passed by REFERENCE }
PROCEDURE qsort(var a: LongIntegerArray);
{ sort array a using quicksort }

   procedure sort(l, r: longint);
   { local procedure to sort a[l..r] }
   
      procedure swap(var x, y: longint);
      { local procedure to swap x and y. }
         var
            tmp : longint;
         begin
            tmp := x;
            x := y;
            y := tmp;
         end; { swap }
   
      var
         i, j, x: longint;
      begin
               
         i := l;
         j := r;
         x := a[Random(r - l) + l];  

         repeat
            while a[i]<x do
               i := i+1;
      
            while x<a[j] do
               j := j-1;
            if not(i>j) then
               begin
                  swap(a[i], a[j]);
                  i := i+1;
                  j := j-1;
               end;
         until i>j;

         if l<j then
            sort(l, j);
         if i<r then
            sort(i, r);
         end; { sort }

   begin
      sort(1, max);
   end; { qsort }

var
   data: LongIntegerArray;
   i: longint;

begin
   { Dynamically initialize array }
   SetLength(data, max);

   write('Creating ',Max,' random numbers between 1 and 500000');
   randomize;
   for i := 1 to max do
      data[i] := 1 + random(500000);
   writeln;
   writeln('Sorting...');
   qsort(data);
   writeln('Printing the last 100 numbers:');
   for i := 1 to 100 do
   begin
      write(data[max-100+i]:7);
      if (i mod 10)=0 then
   writeln;
   end;
end.