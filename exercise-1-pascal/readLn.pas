program Exercise1;

Uses sysutils;

var
	numbersString: String;
	numbersArray: Array of Integer;
	number: Integer;

type
   ArrayOfInteger = array of Integer;

{ Counts the occurences of separator in str }
function Occurs(CONST str, separator: string): Integer; 
	var 
	  i, nSep: Integer;

	begin 
	  nSep:= 0;

	  for i:= 1 to Length(str) do 
	    if str[i] = separator then Inc(nSep); 
	  
	  Occurs:= nSep; 
	end;

{ Splits string containing Integers separated by separator into array of Integer }
function Split(const str, separator: string): ArrayOfInteger;
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

{ Exercise 1: Read numbers from STDIN, sort them using QuickSort and then build a binary tree }
begin
	Write ('INPUT: Numbers separated by whitespace : ');
	
	ReadLn (numbersString);
	numbersArray := Split(numbersString, ' ');

	for number in numbersArray do
		WriteLn (number);	
end.