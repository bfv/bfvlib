
block-level on error undo, throw.

using bfvlib.config.IConfig.
using bfvlib.config.JSONConfig.

define variable cfg as IConfig no-undo.

cfg = new JSONConfig("bfvlib/config/sample01.json").

message "company:" cfg:Get("company") view-as alert-box.        

do on error undo, throw:
  
  message cfg:Get("name") + ": " + cfg:Get("environment") view-as alert-box.
  message cfg:Get("email.host") + ":" + cfg:Get("email.port") view-as alert-box.
  message "nest0.nest01.nest011.nest0110:~n" cfg:Get("nest0.nest01.nest011.nest0110") view-as alert-box.
  
  catch err1 as Progress.Lang.Error :
    message "error:" err1:GetMessage(1) view-as alert-box.
  end catch.
  
end.

message "done" view-as alert-box.
