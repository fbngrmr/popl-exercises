PROGRAM bla;

USES sysutils;

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

{ Note: "var" means a parameter is passed by REFERENCE }
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

         REPEAT
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
      sort(0, Length(a));
   end; { qsort }
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

{ Taken and modified from: http://lists.freepascal.org/fpc-pascal/2007-July/014719.html
  Splits string containing Integers separated by separator into array of Integer }
function Split(const str, separator: string): IntegerArray;
  var 
    i, n: Integer; 
    strline, strfield: string;

  begin
    { Number of occurences of the separator }   
    n:= Occurs(str, separator);

    { Size of the array to be returned is the number of occurences of the separator }
    SetLength(Split, n + 1);

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
      
      Split[i]:= StrToInt(strfield);
      Inc(i);
    until strline= '';  
  end;

var
   data: IntegerArray;
   i: integer;
   numbersString: String;
   numbersArray: IntegerArray;
begin
   writeLn('Creating random numbers between 1 and 500000');
   randomize;

   ReadLn (numbersString);
   numbersArray := Split(numbersString, ' ');

   writeln('Sorting...');

   qsort(numbersArray, @compareTo);
   
   writeln('Printing the numbers:');

  for i := 0 to Length(numbersArray) - 1  do
  begin
      writeln(numbersArray[i]);
  end;
end.