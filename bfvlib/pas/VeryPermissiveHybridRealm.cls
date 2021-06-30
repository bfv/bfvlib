 
 /*------------------------------------------------------------------------
    File        : VeryPermissiveHybridRealm
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Fri Jun 18 16:52:48 CEST 2021
    Notes       : This class is created to simplify testing the security
                  models on an PAS instance. It should be used as
                  http.all.authmanager=oerealm
                  client.login.model=form
                  
  ----------------------------------------------------------------------*/

using Progress.Security.Realm.IHybridRealm.

block-level on error undo, throw.

class bfvlib.pas.VeryPermissiveHybridRealm implements IHybridRealm: 

  method public integer ValidateUser(userName as character):
    
    define variable userNumber as integer no-undo.
    
    case (userName):
      when 'admin' then 
        userNumber = 1.
      when 'user' then
        userNumber = 2.
      when 'superuser' then 
        userNumber = 3.
      when 'wsuser' then
        userNumber = 4.
      otherwise
        userNumber = -1.  
            
    end case.
    
    return userNumber.
    
  end method.  // ValidateUser


  method public logical ValidatePassword(userNumber as integer, password as character):
    return (userNumber > 0).
  end method.  // ValidatePassword


  method public character GetAttribute(userNumber as integer, attrName as character):
    
    define variable returnValue as character no-undo.
     
    case (attrName):
      when 'ATTR_ENABLED' then 
        returnValue = 'true'.
      when 'ATTR_ROLES' then 
        returnValue = getRoles(userNumber).
    end case.
    
    return returnValue.
    
  end method.  // GetAttribute
  
  
  method private character getRoles(userNumber as integer):
    
    define variable roles as character no-undo.
    
    roles = 'PSCUser'.
    
    case (userNumber):
      when 1 then
        roles = roles + ',admin'.
      when 2 then
        roles = roles + ',user'.
      when 3 then
        roles = roles + ',poweruser,user'.
      when 4 then
        roles = roles + ',webservices'.
    end case.
    
    return roles.
    
  end method.  // getRoles
  
  
  /* superfluous, but here to satisfy the interface: */
  
  method public character extent GetAttributeNames(userNumber as integer):
    undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
  end method.

  method public character extent GetUserNames(  ):
    undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
  end method.

  method public character extent GetUserNamesByQuery(queryString as character):
    undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
  end method.

  method public logical RemoveAttribute(userNumber as integer, attrName as character):
    undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
  end method.

  method public logical SetAttribute(userNumber as integer, attrName as character, attrValue as character):
    undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
  end method.

  method public logical ValidatePassword(userNumber as integer, digest as character, nonce as character, timestamp as character):  
    undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
  end method.

end class.  // VeryPermissiveHybridRealm
