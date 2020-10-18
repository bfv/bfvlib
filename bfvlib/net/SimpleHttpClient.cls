 
 /*------------------------------------------------------------------------
    File        : SimpleHttpClient
    Purpose     : 
    Syntax      : 
    Description : The purpose of SimpleHttpClient to provide a (relative) fast http client for IPC. No https or fancy stuff.
                  The idea is to offer light weight communication to local processes like f.e. nodejs based on http, because that's
                  where everything is going.
    Author(s)   : bronco
    Created     : Sun Jul 05 09:22:51 CEST 2020
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using Progress.Json.ObjectModel.JsonObject from propath.
using bfvlib.net.IReadResponse from propath.

class bfvlib.net.SimpleHttpClient implements IReadResponse: 
    
    define public property Host as character no-undo get. set.
    define public property Port as integer no-undo get. set.
    define public property Accept as character initial '*/*' no-undo get. set.
    define public property ContenType as character no-undo initial 'text/plain' get. set.
    
    define private variable httpseparator as character initial '~r~n'.
    define private variable client as handle no-undo.
    define private variable responseHandler as handle no-undo.
    define private variable responseText as longchar no-undo.
    
    
    constructor public SimpleHttpClient():
        
    end.
    
    constructor public SimpleHttpClient(host as character, port as integer):
        this-object:Host = host.
        this-object:Port = port.
        create socket this-object:client.
        this-object:Connect().
        
    end.
    
    method public void SetHeader(headerName as character, headerValue as character):
        
    end method.
    
    method public logical Connect():
        
        define variable resultOK as logical no-undo.
        
        create socket this-object:client.
        resultOK = this-object:client:connect(substitute('-H &1 -S &2', this-object:Host, this-object:Port)).
        
        run bfvlib/net/readresponse.p persistent set responseHandler (client, this-object).
        client:set-read-response-procedure('getResponse', responseHandler).
        
        return resultOK.
        
    end method.
    
    method public longchar Get(path as character):
        
        return this-object:sendMessage(
            this-object:createMessageText('GET', path, '')
        ).
        
    end method.

    method public longchar Post(path as character, body as longchar):
        return this-object:sendMessage(
            this-object:createMessageText('POST', path, body)
        ).
    end method.
    
    
    method public longchar Post(path as character, json as JsonObject):
        
        define variable bodyText as longchar no-undo.
        
        this-object:ContenType = 'application/json'.
        json:Write(bodyText, true).  // we want neat message which are readable
        
        return this-object:sendMessage(
            this-object:createMessageText('POST', path, bodyText)
        ).                        
    end method.
    
    
    method private longchar createMessageText(verb as character, path as character, bodyText as longchar):
        
        define variable messageText as longchar no-undo.
        
        messageText = substitute('&1 &2 HTTP/1.1', verb, path) + httpseparator.
        messageText = messageText + substitute('Host: &1:&2', this-object:Host, this-object:Port) + httpseparator.
        messageText = messageText + substitute('Accept: &1', this-object:Accept) + httpseparator.
        messageText = messageText + substitute('Content-Type: &1', this-object:ContenType) + httpseparator.
        
        if (lookup(verb, 'POST,PUT,PATCH') > 0) then
            messageText = messageText + substitute('Content-Length: &1', length(bodyText, 'raw')) + httpseparator.
            
        messageText = messageText + httpseparator.
        
        if (lookup(verb, 'POST,PUT,PATCH') > 0) then
            messageText = messageText + bodyText + httpseparator.
        
        return messageText.
        
    end method.
    
    
    method private longchar sendMessage(messageText as longchar):
      
        define variable messageBytes as memptr no-undo.
        define variable messageSizeInBytes as integer no-undo.
        define variable responseBody as longchar no-undo.
        
        messageSizeInBytes = length(messageText, 'raw') + 1.
        set-size(messageBytes) = messageSizeInBytes.
        put-string(messageBytes, 1) = messageText.
        
        this-object:client:write(messageBytes, 1, messageSizeInBytes - 1).  // - 1 => skip the string trailing zero
        
        this-object:responseText = ''.
        
        wait-for read-response of client.
                
        responseBody = substring(this-object:responseText, index(this-object:responseText, httpseparator + httpseparator) + 4).

        return responseBody.
        
        finally:
            set-size(messageBytes) = 0.
        end.
      
    end method.
    
    method public void ProcessResponse(responseText as longchar):
        this-object:responseText = responseText.
    end method.
    
end class.