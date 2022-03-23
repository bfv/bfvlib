
define variable dtz as datetime-tz no-undo.

dtz = bfvlib.misc.time.DatetimeTzHelper:IsodateToDatetimeTz("2022-03-22T09:52:37.48902:00").

message iso-date(dtz) view-as alert-box.
//message iso-date(now) view-as alert-box.

catch err1 as Progress.Lang.Error :
  message err1:GetClass():TypeName skip err1:GetMessage(1) view-as alert-box.  
end catch.
