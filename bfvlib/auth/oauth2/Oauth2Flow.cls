 
 /*------------------------------------------------------------------------
    File        : Oauth2Flow
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Thu Sep 24 08:32:18 CEST 2020
    Notes       : 
  ----------------------------------------------------------------------*/


block-level on error undo, throw.

using bfvlib.auth.oauth2.IOauth2Token.

class bfvlib.auth.oauth2.Oauth2Flow implements IOauth2Token: 
    
    define protected property GrantType as character no-undo get. set.
    define public property ClientId as character no-undo get. set.
    define public property Scope as character no-undo get. set.
    define public property Token as character no-undo get. protected set. 
        
end class.