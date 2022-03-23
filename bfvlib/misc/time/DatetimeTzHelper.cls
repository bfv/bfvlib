 
 /*------------------------------------------------------------------------
    File        : DatetimeTzHelper
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Fri Aug 27 15:04:04 CEST 2021
    Notes       : This class offers ways to handle a datetime-tz according 
                  to the layed out at https://www.w3.org/TR/NOTE-datetime 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using Progress.Lang.AppError.
using bfvlib.lang.error.InvalidFormatException.

class bfvlib.misc.time.DatetimeTzHelper: 
  
  /*-----------------------
    Purpose: Converts an ISO date (yyyy-mm-ddThh:mm:ss.sss+hh:mm) to a datetime-tz
    Notes:   If the format is invalid an AppError is thrown

    @param   isodateString - the string holding the ISO date string
    @return  datetime-tz - the converted date
  */
  method public static datetime-tz IsodateToDatetimeTz(isodateString as character):
    
    define variable isodate as datetime-tz no-undo.
    define variable dateStringPart as character no-undo.
    define variable timeStringPart as character no-undo.
    define variable datePart as date no-undo.
    define variable hours as integer no-undo.
    define variable minutes as integer no-undo.
    define variable seconds as integer no-undo.
    define variable millis as integer no-undo.
    define variable digits as character no-undo initial "1234567890".
    define variable i as integer no-undo.
    define variable c as character no-undo.
    define variable tz as integer no-undo.
    define variable tzPart as character no-undo.
        
    do on error undo, throw:
      
      if (isodateString = "?" or isodateString = ?) then 
        return ?.
      
      dateStringPart = entry(1, isodateString, "T").
      timeStringPart = entry(2, isodateString, "T").
      
      datePart = date(
        integer(substring(dateStringPart, 6, 2)),
        integer(substring(dateStringPart, 9, 2)),
        integer(substring(dateStringPart, 1, 4))
      ).
            
      hours = integer(substring(timeStringPart, 1, 2)).
      minutes = integer(substring(timeStringPart, 4, 2)).
      seconds = integer(substring(timeStringPart, 7, 2)).
      
      if (substring(timeStringPart, 9, 1) = ".") then do:
        do i = 0 to 3:
          c = substring(timeStringPart, 10 + i, 1).
          if (index(digits, c) > 0) then
            millis = millis + integer(c) * exp(10, 2 - i).
          else
            leave.     
        end.
      end.
      
      tzPart = substring(timeStringPart, 10 + i).
      if (c = "Z") then 
        tz = 0.  // zulu time
      else if (c = "+" or c = "-") then do:
        tz = integer(entry(1, tzPart, ":")) * 60 + 
             integer(entry(2, tzPart, ":"))
             .
      end.
      else 
        undo, throw new AppError(substitute("invalid timezone exprssion: &1", tzPart), -2).  // invalid time expression
      
      isodate = datetime-tz(datePart, 0, tz).               
      isodate = add-interval(isodate, hours, "hours").
      isodate = add-interval(isodate, minutes, "minutes").
      isodate = add-interval(isodate, seconds, "seconds").
      isodate = add-interval(isodate, millis, "milliseconds").
            
      catch err1 as Progress.Lang.Error :
        undo, throw new InvalidFormatException(
          substitute('"&1" is not a valid ISO date string&2', isodateString, (if err1:GetMessageNum(1) = -2 then ": " + tzPart else ""))
        ).
      end catch.
      
    end.
    
    return isodate.
    
  end method.  // IsodateToDatetimeTz
  
end class.
