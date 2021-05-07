 
 /*------------------------------------------------------------------------
    File        : HttpFormData
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Fri Jun 26 13:02:35 CEST 2020
    Notes       : 
  ----------------------------------------------------------------------*/


block-level on error undo, throw.

using bfvlib.net.IHtmlFormEncoding from propath.
using bfvlib.net.HttpHelper from propath.


class bfvlib.net.HttpFormData implements IHtmlFormEncoding: 
    
    define public property MimeType as character initial 'application/x-www-form-urlencoded' no-undo get. private set.
    define public property Boundary as character no-undo 
        get. 
        set(boundaryValue as character):
            Boundary = '--' + boundaryValue.
        end.
        
    define private temp-table ttparam no-undo
        field paramname as character
        field paramvalue as character
        .
        
    method public longchar GetData():
        
        define variable body as longchar no-undo.
        
        for each ttparam:
            body = body + (if (body > '') then HttpHelper:Separator else '') + ttparam.paramname + '=' + ttparam.paramvalue. 
        end.

        return body.
        
    end method.
    
    method public void SetParameter(pname as character, pvalue as character):
        
        find ttparam where ttparam.paramname = pname no-error.
        if (not available(ttparam)) then do:    
            create ttparam.
            ttparam.paramname = pname.
        end.
                
        ttparam.paramvalue = pvalue.
            
    end method.
    
    method public longchar GetContent():
      return GetData().
    end method.
    
    method private character sanatize(valueIn as character):
        @todo(what="implentation santize").
        return valueIn.  // todo
    end method.
    
end class.