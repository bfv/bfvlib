
using bfvlib.net.SimpleHttpClient from propath.
using Progress.Json.ObjectModel.JsonObject from propath.

define variable http as SimpleHttpClient no-undo.
define variable json as JsonObject no-undo.

http = new SimpleHttpClient('localhost', 3060).

json = new JsonObject().
json:Add('thread', 5).
json:Add('status', 'ok').

// http:Post('/', json).
// message string(http:Get('/')) view-as alert-box.
message string(http:Post('/', json)) view-as alert-box.

message 'done' view-as alert-box.
