 
/*------------------------------------------------------------------------
   File        : KeycloakAuthenticator
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : bronco
   Created     : Fri Jun 26 12:56:22 CEST 2020
   Notes       : 
 ----------------------------------------------------------------------*/


block-level on error undo, throw.

using bfvlib.net.HttpFormData from propath.
using bfvlib.net.HttpHelper from propath.
using bfvlib.net.HttpRequestOptions from propath.
using OpenEdge.Net.HTTP.IHttpResponse from propath.
using Progress.Json.ObjectModel.JsonObject from propath.
using bfvlib.auth.AuthenticationReponse from propath.
using OpenEdge.Net.HTTP.ResponseBuilder from propath.
using bfvlib.auth.OAuth2Authenticator.
using bfvlib.auth.OAuth2Config.

class bfvlib.auth.OAuth2Authenticator: 
  
  define private variable config as OAuth2Config no-undo. 
  
  constructor public OAuth2Authenticator(config as OAuth2Config):
    this-object:config = config.
  end constructor.
          
          
  method public AuthenticationReponse DirectGrantLogin(username as character, password as character):
        
    define variable formData as HttpFormData no-undo.
    define variable httpOptions as HttpRequestOptions no-undo.
    define variable response as IHttpResponse no-undo.
    define variable responseJson as JsonObject no-undo.
    define variable body as longchar no-undo.
        
    httpOptions = new HttpRequestOptions().
    httpOptions:AddHeader('Content-Type', 'application/x-www-form-urlencoded').
    
    formData = new HttpFormData().
    formData:SetParameter('client_id', this-object:config:ClientId).
    formData:SetParameter('grant_type', 'password').
    formData:SetParameter('username', username).
    formData:SetParameter('password', password).
        
    body = formData:GetContent().    
message string(body) view-as alert-box.
    response = HttpHelper:Post(this-object:config:TokenEndpoint, body, httpOptions).
    responseJson = cast(response:Entity, "Progress.Json.ObjectModel.JsonObject").
              
    return (new AuthenticationReponse(responseJson)).
        
  end method.
    
end class.
