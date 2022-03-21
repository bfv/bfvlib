 
/*------------------------------------------------------------------------
   File        : HttpHelper
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : bronco
   Created     : Fri Aug 03 07:55:37 CEST 2018
   Notes       : 
 ----------------------------------------------------------------------*/

using OpenEdge.Net.HTTP.ClientBuilder.
using OpenEdge.Net.HTTP.IHttpClient.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.RequestBuilder.
using OpenEdge.Net.URI.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Core.WidgetHandle.
using OpenEdge.Core.String.
using OpenEdge.Core.Memptr.
using OpenEdge.Core.Collections.ISet.
using OpenEdge.Core.Collections.IIterator.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.AppError.
using bfvlib.net.HttpHelper.
using bfvlib.net.HttpRequestOptions.
using OpenEdge.Net.HTTP.IHttpClientLibrary.
using OpenEdge.Net.HTTP.Lib.ClientLibraryBuilder.

block-level on error undo, throw.

class bfvlib.net.HttpHelper: 
  
  define public static property Separator as character initial '~r~n' no-undo get.
    
  define private static variable token as character no-undo.
  
  define private static variable ciphers as character no-undo extent 4 /* initial [     
      "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",
      "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384",
      "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256",
      "TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384"
      ...
    ]*/
    .
    
  // TLS versions, note: TLSv1.0 & TLSv1.1 are NOT safe, neither are all SSL protocols  
  define private static variable protocols as character no-undo extent 2 initial [
      "TLSv1.2",
      "TLSv1.3"
    ].
  
  constructor static HttpHelper():
  end.  
  
  
  // for DELETE a body is optional
  method public static IHttpResponse Delete(url as character, body as longchar):
    return HttpHelper:execute("delete", url, body, ?).  
  end.
  
  method public static IHttpResponse Delete(url as character, body as longchar, options as HttpRequestOptions):
    return HttpHelper:execute("delete", url, body, options).
  end method.
    
  method public static IHttpResponse Get(url as character):
    return HttpHelper:execute("get", url, ?, ?).
  end method.
  
  method public static IHttpResponse Get(url as character, options as HttpRequestOptions):
    return HttpHelper:execute("get", url, ?, options).    
  end method.
  
  method public static IHttpResponse Post(url as character, body as longchar):
    return HttpHelper:execute("post", url, body, ?).  
  end.
  
  method public static IHttpResponse Post(url as character, body as longchar, options as HttpRequestOptions):
    return HttpHelper:execute("post", url, body, options).
  end method.
    
  method public static IHttpResponse Put(url as character, body as longchar):
    return HttpHelper:execute("put", url, body, ?).  
  end.
  
  method public static IHttpResponse Put(url as character, body as longchar, options as HttpRequestOptions):
    return HttpHelper:execute("put", url, body, options).
  end method.
  
  
  method private static IHttpResponse execute(verb as character, url as character, body as longchar, options as HttpRequestOptions):
      
    define variable builder as RequestBuilder no-undo.
    define variable request as IHttpRequest no-undo.
    define variable client as IHttpClient no-undo.   
    define variable response as IHttpResponse no-undo.
    
    case verb:
      when "get" then 
        builder = RequestBuilder:Get(url). 
      when "post" then
        builder = RequestBuilder:Post(url, new String(body)).
      when "put" then
        builder = RequestBuilder:Put(url, new String(body)).
      when "delete" then
        builder = RequestBuilder:Delete(url, new String(body)).        
    end.
    
    builder = HttpHelper:applyOptions(builder, options).    
    request = builder:Request.
    
    if (valid-object(options)) then
      addParametersToRequest(request, options).
      
    client = ClientBuilder
               :Build()
               :UsingLibrary(getSSLLibrary(options))
               :Client.

    response = client:Execute(request).
    
    return response.

  end method.  // execute
  
  
  method private static RequestBuilder applyOptions(builder as RequestBuilder, options as HttpRequestOptions):
    
    if (valid-object(options)) then do:
      builder = HttpHelper:checkProxy(builder, options).
      HttpHelper:addHeadersToRequest(builder, options).
    end.
    
    return builder.
    
  end method.
  
  method private static void addHeadersToRequest(builder as RequestBuilder, options as HttpRequestOptions):
    
    define variable keyset as ISet no-undo.
    define variable iterator as IIterator no-undo.
    define variable keyObject as Progress.Lang.Object no-undo.
    define variable headerName as character no-undo.
    
    if (options:Accept > "") then 
      builder:AcceptContentType(options:Accept).
      
    if (options:ContentType > "") then
      builder:ContentType(options:ContentType).
    
    keyset = options:Headers:KeySet.
    iterator = keyset:Iterator().
    
    do while (iterator:HasNext()):
      keyObject = iterator:Next().
      headerName = string(cast(keyObject, "OpenEdge.Core.String"):Value).
      builder:AddHeader(headerName, string(options:Headers:Get(headerName))). 
    end.
    
  end method.
  
  method private static void addParametersToRequest(request as IHttpRequest, options as HttpRequestOptions):
    
    define variable keyset as ISet no-undo.
    define variable iterator as IIterator no-undo.
    define variable keyObject as Progress.Lang.Object no-undo.
    define variable queryName as character no-undo.
    
    keyset = options:queryParameters:KeySet.
    iterator = keyset:Iterator().
    
    do while (iterator:HasNext()):
      keyObject = iterator:Next().
      queryName = string(cast(keyObject, "OpenEdge.Core.String"):Value).
      request:uri:AddQuery(queryName, string(options:queryParameters:Get(queryName))). 
    end.
    
  end method.
  
  method public static longchar GetLongchar(response as IHttpResponse):
    
    define variable contentType as character no-undo.
    define variable contentString as longchar no-undo.
    define variable xmlDoc as handle no-undo.
    
    contentType = response:ContentType.
    if (contentType matches "application/vnd.*+json") then
      contentType = "application/json".
      
    case (contentType):
      
      when "application/json" then do:
        cast(response:Entity, "Progress.Json.ObjectModel.JsonConstruct"):Write(contentString, true).
      end.
      
      otherwise do:
        
        if type-of(response:Entity, WidgetHandle) then do: 
          xmlDoc = cast(response:Entity, WidgetHandle):Value. 
          xmlDoc:save('longchar', contentString).
        end.
        else if type-of(response:Entity, String) then
          contentString = cast(response:Entity, String):Value. 
        else if type-of(response:Entity, Memptr) then
          contentString = cast(response:Entity, Memptr):GetString(1).
        else
          contentString = response:Entity:ToString().   
                
      end.
      
    end.
    
    return contentString.
    
  end method.

  method public static JsonObject GetJsonObject(response as IHttpResponse):
    
    define variable contentType as character no-undo.
    define variable jsonContent as JsonObject no-undo.
    
    contentType = response:ContentType.

    if (contentType = "application/json" or contentType matches "application/vnd.*+json") then
      jsonContent = cast(response:Entity, "Progress.Json.ObjectModel.JsonObject").
    else
      undo, throw new AppError("ContentType is not JSON", -1).
    
    return jsonContent.
    
  end method.
  
  method public static handle GetXml(response as IHttpResponse):
    
    define variable contentType as character no-undo.
    define variable xmlContent as handle no-undo.
    
    contentType = response:ContentType.

    case (contentType):
      when "application/xml" or when "text/xml" then do:
        create x-document xmlContent.
        //...
      end.  
    end case.
    
    return xmlContent.
    
  end method.

  method public static void CheckResponseErrors(response as IHttpResponse):
        
    if (response:StatusCode >= 400 and response:StatusCode < 600) then
      undo, throw new AppError(substitute("http error &1 - &2", response:StatusCode, response:StatusReason), -1).
          
  end method.
  
  method private static RequestBuilder checkProxy(builder as RequestBuilder, options as HttpRequestOptions):
    
    if (options:ViaProxy > "") then
      builder:ViaProxy(options:ViaProxy).    
    
    return builder.
    
  end method.

  method public static character NormalizeHeaderName (headerName as character):
    
    define variable nextCharUpper as logical no-undo.
    define variable resultString as character no-undo.
    define variable headerNameLength as integer no-undo.
    define variable i as integer no-undo.
    define variable currentChar as character no-undo.
    
    headerNameLength = length(headerName).
    nextCharUpper = true.
    do i = 1 to headerNameLength:
      
      currentChar = substring(headerName, i, 1).

      if (nextCharUpper) then do:
        resultString = resultString + caps(currentChar).
        nextCharUpper = false.
        next.
      end.  
      
      if (currentChar = '_') then
        currentChar = '-'.
      
      if (currentChar = '-') then
        nextCharUpper = true.        
      
      resultString = resultString + lc(currentChar).
      
    end.
    
    return resultString.
    
  end method.
  
  
  method public static void SetBearerToken(bearerToken as character):
    HttpHelper:token = "Bearer " + bearerToken.
  end method.

  
  method private static RequestBuilder applyAuthorization(builder as RequestBuilder):
      
    if (HttpHelper:token > "") then 
        builder:AddHeader("Authorization", HttpHelper:token).
      
    return builder.
    
  end method.
  

  method private static IHttpClientLibrary getSSLLibrary(options as HttpRequestOptions):
    
    define variable sslLibrary as IHttpClientLibrary no-undo.
    define variable clientLibBuilder as ClientLibraryBuilder no-undo.
    define variable protocols as character extent no-undo.
    
    clientLibBuilder = ClientLibraryBuilder:Build().
    clientLibBuilder = clientLibBuilder:SslVerifyHost(options:SSLVerifyHost).
    
    // Set TLS versions
    clientLibBuilder = clientLibBuilder:SetSSLProtocols(protocols).
    
    // leave ciphers for now
    // clientLibBuilder = clientLibBuilder:SetSslCiphers(ciphers).
    
    sslLibrary = clientLibBuilder:Library.
    
    return sslLibrary.
    
  end method.

end class.
