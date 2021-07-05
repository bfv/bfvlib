
var char host = 'localhost'.
var int port = 3110.
 
var handle has.
var logical connectOk. 
var char replyString.

create server has.

connectOk = has:connect(substitute('-URL http://&1:&2/apsv', host, port)).

run bfvlib/pas/ping.p ('abc123', output replyString).

message 'done' view-as alert-box.
