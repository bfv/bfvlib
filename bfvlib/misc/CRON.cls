 
 /*------------------------------------------------------------------------
    File        : CRON
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Sun Apr 19 14:27:41 CEST 2020
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS bfvlib.misc.CRON: 
    
    method public datetime-tz GetNext(moment as datetime-tz, cronParameters as character):
        
        define variable nextRunTime as datetime-tz no-undo.
        
        return nextRunTime.
        
    end.
    
END CLASS.