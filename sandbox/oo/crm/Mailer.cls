 
 /*------------------------------------------------------------------------
    File        : Mailer
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Sun Jun 20 09:41:50 CEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

using sandbox.oo.crm.Person.

block-level on error undo, throw.

class sandbox.oo.crm.Mailer: 
  
  method public void Send():
    
    define variable bronco as Person no-undo.
    
    bronco = new Person().
    
    message bronco:Email view-as alert-box.
    
  end method.
  
end class.