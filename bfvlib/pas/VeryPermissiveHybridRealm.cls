 
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
using Progress.Json.ObjectModel.JsonObject.

block-level on error undo, throw.

class bfvlib.pas.VeryPermissiveHybridRealm implements IHybridRealm: 
  
  define private property users as character no-undo initial 'admin,user,superuser,wsuser,locked,expired,defaultrole' get. 
   
  method public integer ValidateUser(userName as character):
    
    define variable userNumber as integer no-undo.
    
    userNumber = lookup(userName, this-object:users).    
    
    message substitute('user: &1, id: &2', userName, userNumber).
    
    return userNumber.
    
  end method.  // ValidateUser

  
  // since this is a test class, no password check is implemented
  method public logical ValidatePassword(userNumber as integer, password as character):
    message substitute('id: &1', userNumber).
    return (userNumber > 0).
  end method.  // ValidatePassword


  method public character GetAttribute(userNumber as integer, attrName as character):
    
    define variable returnValue as character no-undo.
     
    case (attrName):
      
      when 'ATTR_ENABLED' then 
        returnValue = 'true'.
      when 'ATTR_ROLES' then 
        returnValue = getRoles(userNumber).
      when 'ATTR_LOCKED' then
        returnValue = string(userNumber = 5, 'true/false').        
      when 'ATTR_EXPIRED' then
        returnValue = string(userNumber = 6, 'true/false').        
      when 'ATTR_USERID' then 
        returnValue = getUserName(userNumber).
      when 'ATTR_PROPERTIES' then 
        returnValue = getExtraProperties(userNumber).
        
    end case.
    
    message substitute('user: &1, attr: &2, value: &3', userNumber, attrName, returnValue).
    
    return returnValue.
    
  end method.  // GetAttribute
  
  
  method private character getRoles(userNumber as integer):
    
    define variable roles as character no-undo.
    
    roles = 'user'.
    
    case (userNumber):
      when 1 then
        roles = roles + ',admin'.
      when 3 then
        roles = roles + ',poweruser'.
      when 4 then
        roles = roles + ',webservices'.
      when 7 then 
        roles = ?.
    end case.
    
    return roles.
    
  end method.  // getRoles
  
  
  method private character getExtraProperties(userNumber as integer):
    
    define variable json as JsonObject no-undo.
    define variable jsonString as longchar no-undo.
    
    json = new JsonObject().
    json:Add('date-format', 'dmy').
    json:Add('numeric-format', 'european').
    json:Add('timezone', 'CEST').
    json:Add('timezone-offset', '+02:00'). 
    
    json:Write(jsonString).
    
    return string(jsonString).
    
  end method.  // getExtraProperties
  
  
  method private character getUsername(userNumber as integer):
    return entry(userNumber, this-object:users) + '.flusso'.
  end method.  // getUsername
  
  
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
