
/*------------------------------------------------------------------------
    File        : IHtmlFormEncoding
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Wed Sep 23 16:58:55 CEST 2020
    Notes       : 
  ----------------------------------------------------------------------*/


interface bfvlib.net.IHtmlFormEncoding:  
    
    define public property MimeType as character no-undo get. 
    
    method public void SetParameter(parameterName as character, parameterValue as character).    
    method public longchar GetData().
    
end interface.