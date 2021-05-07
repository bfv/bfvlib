 
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

class bfvlib.auth.KeycloakAuthenticator: 
    
    constructor public KeycloakAuthenticator():        
        define variable response as AuthenticationReponse no-undo.
        // response = this-object:DirectGrantLogin('bfv', 'bfv').
        response = this-object:DirectGrantLogin('jantine', 'jantine').
        message response:JWT:Issuer skip response:JWT:Scope view-as alert-box.
    end.
        
    method public AuthenticationReponse DirectGrantLogin(username as character, password as character):
        
        define variable tokenEndpoint as character no-undo.
        define variable formData as HttpFormData no-undo.
        define variable httpOptions as HttpRequestOptions no-undo.
        define variable response as IHttpResponse no-undo.
        define variable responseJson as JsonObject no-undo.
        define variable responseText as longchar no-undo.
        
        tokenEndpoint = 'http://keycloak.bfv.io:8081/auth/realms/COKZ/protocol/openid-connect/token'.
        
        httpOptions = new HttpRequestOptions().
        httpOptions:AddHeader('Content-Type', 'application/x-www-form-urlencoded').
        
        formData = new HttpFormData().
        formData:Add('client_id', 'ExspectClient').
        formData:Add('grant_type', 'password').
        formData:Add('username', username).
        formData:Add('password', password).
        
        response = HttpHelper:Post(tokenEndpoint, formData:GetBodyContent(), httpOptions).
        responseJson = cast(response:Entity, "Progress.Json.ObjectModel.JsonObject").
        responseJson:Write(responseText).
clipboard:value = responseText.             
        return (new AuthenticationReponse(responseJson)).
        
    end method.
    
end class.