function Split(const str, separator: string): ArrayOfInteger;
	var 
	  i, n: integer; 
	  strline, strfield: string;

	begin
		{ Number of occurences of the separator }		
		n:= Occurs(str, separator);

		{ Size of the array to be returned is the number of occurences of the separator }
		SetLength(Result, n + 1);

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

	  //if Split[High(Split)] = '' then SetLength(Split, Length(Split) -1); 
	end;