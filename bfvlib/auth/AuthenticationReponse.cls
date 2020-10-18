 
 /*------------------------------------------------------------------------
    File        : AuthenticationReponse
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Fri Jun 26 13:56:24 CEST 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using Progress.Json.ObjectModel.JsonObject from propath.
using bfvlib.auth.JWT from propath.

block-level on error undo, throw.

class bfvlib.auth.AuthenticationReponse final: 
    
    define public property AccessToken as character no-undo get. private set.
    define public property ErrorType as character no-undo get. private set.
    define public property ErrorDescription as character no-undo get. private set.
    define public property Scope as character no-undo get. private set.
    define public property JWT as JWT no-undo get. set.
    
    constructor public AuthenticationReponse(responseJson as JsonObject):
        this-object:decompose(responseJson).
    end.
    
    
    method private void decompose(json as JsonObject):
      
        if (json:Has('error')) then do:
            this-object:ErrorType = json:GetCharacter('error').
            this-object:ErrorDescription = json:GetCharacter('error_description').
            return.    
        end.
        
        this-object:AccessToken = json:GetCharacter('access_token').     
        this-object:JWT = new JWT(this-object:AccessToken).
        
    end method.
          
end class.