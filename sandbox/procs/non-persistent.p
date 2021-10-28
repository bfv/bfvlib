
using Progress.Lang.AppError.

if (this-procedure:persistent) then
  undo, throw new AppError(substitute('&1 should not be ran persistently', this-procedure:file-name), -1).

function isOrderOK returns logical private (orderNumber as integer):
  
  define variable orderOK as logical no-undo.

  return orderOK.

end function.  // isOrderOK

message "hello world" view-as alert-box.
