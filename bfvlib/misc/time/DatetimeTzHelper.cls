 
 /*------------------------------------------------------------------------
    File        : DatetimeTzHelper
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Fri Aug 27 15:04:04 CEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/


block-level on error undo, throw.

using Progress.Lang.AppError.

class bfvlib.misc.time.DatetimeTzHelper: 
  
  method public static datetime-tz IsodateToDatetimeTz(isodateString as character):
    
    define variable isodate as datetime-tz no-undo.
    define variable dateStringPart as character no-undo.
    define variable timeStringPart as character no-undo.
    define variable datePart as date no-undo.
    
    do on error undo, throw:
      
      if (isodateString = "?" or isodateString = ?) then 
        return ?.
      
      dateStringPart = entry(1, isodateString, "T").
      timeStringPart = entry(2, isodateString, "T").
      
        
      catch err as Progress.Lang.Error :
        undo, throw new AppError(substitute('"&1" is not a valid isodate string', isodateString)).
      end catch.
      
    end.
    
    return isodate.
    
  end method.
  
end class.