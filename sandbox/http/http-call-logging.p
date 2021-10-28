

using bfvlib.net.HttpHelper.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.IHttpMessage.
using bfvlib.misc.JSON.
using Progress.Json.ObjectModel.JsonObject.

define variable res as IHttpResponse no-undo.
define variable resEnt as IHttpMessage no-undo.
define variable resBody as longchar no-undo.

res = HttpHelper:Post("http://httpbin.org/post", "~{~"status~":~"OK~"}").

message res:Entity:GetClass():TypeName  view-as alert-box.

/*case res:Entity:GetClass():TypeName:                              */
/*  when "Progress.Json.ObjectModel.JsonObject" then                */
/*    resBody = this-object:Stringify(cast(res:Entity, JsonObject)).*/
/*end.                                                              */

message string(resBody) view-as alert-box.
