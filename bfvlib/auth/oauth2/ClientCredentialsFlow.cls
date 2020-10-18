 
 /*------------------------------------------------------------------------
    File        : ClientCredentialsFlow
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Thu Sep 24 08:31:02 CEST 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using bfvlib.auth.oauth2.Oauth2Flow.
using bfvlib.auth.oauth2.IOauth2Login.
using bfvlib.net.HttpHelper.
using bfvlib.net.HttpRequestOptions.
using bfvlib.net.HttpWwwFormUrlEncodedBody.
using OpenEdge.Net.HTTP.IHttpResponse.

block-level on error undo, throw.

class bfvlib.auth.oauth2.ClientCredentialsFlow inherits Oauth2Flow implements IOauth2Login: 
    
    define public property TokenEndpoint as character no-undo get. set.
    define public property ClientSecret as character no-undo get. set.
    define public property Audience as character no-undo get. set.
    
    constructor public ClientCredentialsFlow():
        this-object:GrantType = 'client_credentials'.   
    end.
    
    method public logical Login():
        
        define variable options as HttpRequestOptions no-undo.
        define variable body as longchar no-undo.
        define variable authResponse as IHttpResponse no-undo.
        define variable succesfulLogin as logical no-undo.
        
        options = this-object:createOptions().            
        body = this-object:createBody().
        
        authResponse = HttpHelper:Post(this-object:TokenEndpoint, body, options).
        
        succesfulLogin = (authResponse:StatusCode = 200).
        if (succesfulLogin) then 
            this-object:processAuthResponse(authResponse).
        
        return succesfulLogin.
            
    end method.  // Login
    
    
    method private void processAuthResponse(authResponse as IHttpResponse):
      
            
      
    end method.
    
    
    method private longchar createBody():
        
        define variable body as HttpWwwFormUrlEncodedBody no-undo.
        
        body = new HttpWwwFormUrlEncodedBody(). 
        body:SetParameter('grant_type', this-object:GrantType).
        body:SetParameter('client_id', this-object:ClientId).
        body:SetParameter('client_secret', this-object:ClientSecret).

        if (this-object:Scope > '') then 
            body:SetParameter('scope', this-object:Scope).
        
        if (this-object:Audience > '') then 
            body:SetParameter('audience', this-object:Audience).
            
        return body:GetData().
        
    end method.  // createBody
    
    
    method private HttpRequestOptions createOptions():
      
        define variable options as HttpRequestOptions no-undo.
        
        options = new HttpRequestOptions().
        options:ContentType = 'application/x-www-form-urlencoded'.               
    
        return options.
      
    end method.  // createOptions
    
end class.