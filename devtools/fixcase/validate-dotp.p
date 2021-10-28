
{devtools/fixcase/datastructures.i}

temp-table ttchanged:read-json("file", "D:\PDS\boo\output\run-dot-p-changed.json").

for each ttchanged where length(ttchanged.originalStatement) <> length(ttchanged.correctedStatement):
  message 
    length(ttchanged.originalStatement) skip 
    ttchanged.originalStatement skip 
    ttchanged.correctedStatement skip
    length(ttchanged.correctedStatement) 
    view-as alert-box.
end. 

message "done" view-as alert-box.