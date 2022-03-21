 
 /*------------------------------------------------------------------------
    File        : HttpRequestOptions
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Mon Aug 13 09:34:59 CEST 2018
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.Core.Collections.StringStringMap.
using bfvlib.net.HttpRequestOptions.

block-level on error undo, throw.

class bfvlib.net.HttpRequestOptions: 
  
  define public property Accept as character no-undo get. set.
  define public property ContentType as character no-undo get. set.
  
  define public property Headers as StringStringMap no-undo get. private set.
  define public property QueryParameters as StringStringMap no-undo get. private set.
  
  define public property ViaProxy as character no-undo get. set.
  define public property SSLVerifyHost as logical no-undo initial true get. set.
  
  constructor public HttpRequestOptions():
    this-object:Headers = new StringStringMap().  
    this-object:QueryParameters = new StringStringMap().  
  end. 
  
  method public HttpRequestOptions AddHeader(headerName as character, headerValue as longchar):
    this-object:Headers:Put(headerName, headerValue).
    return this-object.
  end method.
  
  method public HttpRequestOptions AddQueryParameter(parameterName as character, parameterValue as longchar):
    this-object:queryParameters:Put(parameterName, parameterValue).
    return this-object.
  end method.  
   
end class.
