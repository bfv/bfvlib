

define variable has as handle no-undo.
define variable connectOk as logical no-undo.
define variable replyString as character no-undo.

create server has.

connectOk = has:connect('-URL http://localhost:3110/apsv').

run bfvlib/pas/ping.p on server has ('abc123', output replyString).
run bfvlib/pas/nop.p on server has.

message substitute('done, reply: &1', replyString) view-as alert-box.
