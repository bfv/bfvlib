

define variable has as handle no-undo.
define variable connectOk as logical no-undo.
define variable i as integer no-undo.
define variable leakSize as integer no-undo.
define variable iterations as integer no-undo.

create server has.

connectOk = has:connect('-URL http://localhost:3110/apsv').

leakSize = 1024000.
iterations = 1000.

do i = 1 to iterations:
  run bfvlib/pas/create-memleak.p on server has (leakSize).
end.

message substitute('done, iterations: &1, leak/iter: &2', iterations, leakSize) view-as alert-box.
