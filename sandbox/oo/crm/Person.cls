 
 /*------------------------------------------------------------------------
    File        : Person
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Sun Jun 20 09:37:59 CEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.

block-level on error undo, throw.

class sandbox.oo.crm.Person: 
  
  define public property FirstName as char no-undo get. set.
  define public property LastName as char no-undo get. set.
  
  define package-private property Email as character no-undo get. set. 
  
end class.