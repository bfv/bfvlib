 
 /*------------------------------------------------------------------------
    File        : OAuth2Config
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Thu Apr 29 10:17:10 CEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.

block-level on error undo, throw.

class bfvlib.auth.OAuth2Config: 
  
  define public property TokenEndpoint as character no-undo get. private set.
  define public property ClientId as character no-undo get. private set.
  
  constructor public OAuth2Config(tokenEndpoint as character, clientId as character):
    this-object:TokenEndpoint = tokenEndpoint.
    this-object:ClientId = clientId.
  end constructor.
  
end class.