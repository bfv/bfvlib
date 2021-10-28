 
 /*------------------------------------------------------------------------
    File        : DatePeriod
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Thu Jun 10 09:45:49 CEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

class bfvlib.misc.time.DatePeriod: 
  
  define public property From as date no-undo get. private set.
  define public property To as date no-undo get. private set.
  
  
  constructor public DatePeriod(fromDate as date, toDate as date):
    this-object:From = fromDate.
    this-object:To = toDate.
  end constructor.
  
  
  method public override character ToString():
    
    define variable currentDateFormat as character no-undo.
        
    currentDateFormat = session:date-format.
    session:date-format = 'ymd'.
    
    return substitute(
      '&1 | &2',
      string(this-object:From, '9999-99-99'),
      string(this-object:To, '9999-99-99')
    ).
    
    finally:
      session:date-format = currentDateFormat.
    end.  
    
  end method.
  
end class.