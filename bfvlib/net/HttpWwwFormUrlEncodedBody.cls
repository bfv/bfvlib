 
 /*------------------------------------------------------------------------
    File        : HttpBody
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Wed Sep 23 11:19:27 CEST 2020
    Notes       : 
  ----------------------------------------------------------------------*/


block-level on error undo, throw.

using bfvlib.net.IHtmlFormEncoding.


class bfvlib.net.HttpWwwFormUrlEncodedBody implements IHtmlFormEncoding: 
    
    define public property MimeType as character initial 'application/x-www-form-urlencoded' no-undo get.
     
    define private temp-table ttparam no-undo
        field paramname as character
        field paramvalue as character
        .
    
    method public void SetParameter(pname as characte, pvalue as character):
        
        find ttparam where ttparam.paramname = pname no-error.
        if (not available(ttparam)) then do:    
            create ttparam.
            ttparam.paramname = pname.
        end.
                
        ttparam.paramvalue = pvalue.
            
    end method.
    
    
    method public longchar GetData():
        
        define variable body as longchar no-undo.
        
        for each ttparam:
            body = body + (if (body > '') then '&' else '') + ttparam.paramname + '=' + ttparam.paramvalue. 
        end.
        
        return body.
        
    end method.
    
end class.