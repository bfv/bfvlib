using OpenEdge.Core.Collections.List.
using OpenEdge.Core.String.

def var dataArray as List no-undo.
dataArray = new List().
dataArray:Add(new String("hallo")).
dataArray:Add(new String("hoppa")).
dataArray:Add(new String("hatseflatse")).


{foreach.i String kreet in dataArray}
  message string(kreet:Value) view-as alert-box.
end.
