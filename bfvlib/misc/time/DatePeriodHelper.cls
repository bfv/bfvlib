 
 /*------------------------------------------------------------------------
    File        : DateHelper
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Thu Jun 10 09:47:03 CEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/


block-level on error undo, throw.

using bfvlib.misc.time.DatePeriod.

class bfvlib.misc.time.DatePeriodHelper: 
  
  method public static DatePeriod GetCurrentMonth(referenceDate as date):
    
    define variable periodFirstDay as date no-undo.
    define variable periodLastDay as date no-undo.
    
    periodFirstDay = date(month(referenceDate), 1, year(referenceDate)).
    periodLastDay = add-interval(periodFirstDay, 1, "months") - 1.
    
    return new DatePeriod(
      periodFirstDay,
      periodLastDay
    ).
    
  end method.  /* GetCurrentMonth */
  

  method public static DatePeriod GetPreviousMonth(referenceDate as date):
    
    define variable periodLastDay as date no-undo.
    
    periodLastDay = date(month(referenceDate), 1, year(referenceDate)) - 1.
    
    return new DatePeriod(
      date(month(periodLastDay), 1, year(periodLastDay)),
      periodLastDay
    ).
    
  end method.  /* GetPreviousMonth */


  method public static DatePeriod GetNextMonth(referenceDate as date):
    
    define variable periodFirstDay as date no-undo.
    define variable periodLastDay as date no-undo.
    define variable tmpDate as date no-undo.
    
    tmpDate = add-interval(referenceDate, 1, "months").
    periodFirstDay = date(month(tmpDate), 1, year(tmpDate)).
    periodLastDay = add-interval(periodFirstDay, 1, "months") - 1.
    
    return new DatePeriod(
      periodFirstDay,
      periodLastDay
    ).
    
  end method.  /* GetCurrentMonth */
  
end class.
