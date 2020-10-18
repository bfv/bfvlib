

define variable i as integer no-undo.
define variable j as integer no-undo.
define variable t1 as int64 no-undo.
define variable t2 as int64 no-undo.
define variable t3 as int64 no-undo.

i = 0.
j = 0.

t1 = etime(false).
repeat:
    
    if (j < 10000000) then
        j = j + 1.
    else
        leave.
        
end.

t2 = etime(false).

i = 0.
j = 0.

repeat:
    
    if (j < 10000000) then do:
        j = j + 1.
    end.
    else
        leave.
        
end.

t3 = etime(false).

message (t2 - t1) (t3 - t2) view-as alert-box.
