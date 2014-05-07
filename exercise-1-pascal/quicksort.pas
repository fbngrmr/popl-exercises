program Sorting;

VAR
    elements : array of integer;

TYPE 
    { Type of the element array. }
    IntegerArray = ARRAY OF Integer;

PROCEDURE swap(VAR a, b: integer);
    VAR
        t: integer;
    BEGIN
        t := a;
        a := b;
        b := t;
    END;

PROCEDURE Quicksort(VAR arr : IntegerArray; left : integer; right : integer);
    var
        pivot : integer;
        leftIdx : integer;
        rightIdx : integer;

    begin

        Randomize;

        if (right - left) > 0 then
            begin
                { Random number between left and right }
                pivot := arr[Random(right - left) + left];  
                
                leftIdx := left;
                rightIdx := right;

                while leftIdx < rightIdx do
                begin
                    while arr[leftIdx] < pivot do
                    begin
                        leftIdx := leftIdx + 1;
                    end;

                    while arr[rightIdx] > pivot do
                    begin
                        rightIdx := rightIdx - 1;
                    end;

                    Swap(arr[leftIdx], arr[rightIdx]);
                end;

                if left < rightIdx then
                    Quicksort(arr, left, rightIdx - 1);

                if leftIdx < right then
                    Quicksort(arr, leftIdx + 1, right);
            end;
    end;    
begin
    elements[0] := 2;
    elements[1] := 1;

    Quicksort(elements, 0, 1);
end.