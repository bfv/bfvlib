
def var host as char init 'localhost' no-undo.
def var port as int init 3110 no-undo.
 
def var has as handle no-undo.
def var connectOk as logical no-undo. 
def var replyString as char no-undo.

create server has.

connectOk = has:connect(substitute('-URL http://&1:&2/apsv', host, port)).

run bfvlib/pas/ping.p ('abc123', output replyString).

message 'done' view-as alert-box.
