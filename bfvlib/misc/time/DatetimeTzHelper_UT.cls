 
 /*------------------------------------------------------------------------
    File        : DatetimeTzHelper_UT
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Tue Mar 22 11:20:34 CET 2022
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using bfvlib.misc.time.DatetimeTzHelper.
using OpenEdge.Core.Assert.

class bfvlib.misc.time.DatetimeTzHelper_UT:
    
    
    /*------------------------------------------------------------------------------
      Purpose:                                      
      Notes:                                      
  ------------------------------------------------------------------------------*/
  @Test. 
  method public void testIsodateToDatetimeTz(  ):
    
    define variable dtz as datetime-tz no-undo.
    
    dtz = DatetimeTzHelper:IsodateToDatetimeTz("2022-03-22T09:52:37.489+02:00").  // CEST
    Assert:Equals(dtz, datetime-tz(3, 22, 2022, 9, 52, 37, 489, 120)).
    
    dtz = DatetimeTzHelper:IsodateToDatetimeTz("2022-03-22T09:52:37.489+00:00").  // UTC
    Assert:Equals(dtz, datetime-tz(3, 22, 2022, 9, 52, 37, 489, 0)).
  
    dtz = DatetimeTzHelper:IsodateToDatetimeTz("2022-03-22T09:52:37.489Z").  // Zulu time (=UTC), 3 milli digits
    Assert:Equals(dtz, datetime-tz(3, 22, 2022, 9, 52, 37, 489, 0)).
    
    dtz = DatetimeTzHelper:IsodateToDatetimeTz("2022-03-22T09:52:37.4Z").  // Zulu time (=UTC), 1 milli digit
    Assert:Equals(dtz, datetime-tz(3, 22, 2022, 9, 52, 37, 400, 0)).
    
    dtz = DatetimeTzHelper:IsodateToDatetimeTz("2022-03-22T09:52:37.489-05:00").  // US east coast
    Assert:Equals(dtz, datetime-tz(3, 22, 2022, 9, 52, 37, 489, -300)).
    
    dtz = DatetimeTzHelper:IsodateToDatetimeTz("2022-03-22T09:52:37.489+03:45").  // Nepal
    Assert:Equals(dtz, datetime-tz(3, 22, 2022, 9, 52, 37, 489, 225)).
    
  end method.
  
end class.