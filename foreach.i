&if "{5}" <> "nodef" &then 
define variable {2} as {1} no-undo.
define variable {2}Iterator as OpenEdge.Core.Collections.IIterator no-undo.
&endif

{2}Iterator = {4}:Iterator().

do while({2}Iterator:HasNext()):

  {2} = cast({2}Iterator:Next(), "{1}").