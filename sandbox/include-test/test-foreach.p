using OpenEdge.Core.Collections.List.
using OpenEdge.Core.String.

var List dataArray.
dataArray = new List().
dataArray:Add(new String("hallo")).
dataArray:Add(new String("hoppa")).
dataArray:Add(new String("hatseflatse")).


{foreach String kreet in dataArray}
  message string(kreet:Value) view-as alert-box.
end.
