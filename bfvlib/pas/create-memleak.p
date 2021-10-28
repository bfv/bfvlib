define input parameter leakSize as integer no-undo.

define variable leak as memptr no-undo.

if (leakSize > 0) then
  set-size(leak) = leakSize.

message substitute("ATTENTION: create-memleak.p called with leaksize: &1", leakSize).
