 
 /*------------------------------------------------------------------------
    File        : IncludeRefLogic
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Thu Aug 19 12:15:11 CEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

using devtools.fixcase.IFileTypeSpecific.

block-level on error undo, throw.

class devtools.fixcase.IncludeRefLogic implements IFileTypeSpecific: 
  
  define property OutputPrefix as character initial "include-refs" get.
  
  method public logical CanSkipLine(currentLine as character):
    
    define variable skipSource as logical no-undo.
    define variable includeRef as character no-undo.
    
    
    if (currentLine begins "Binary") then
        skipSource = true.
    
    if (not skipSource) then do:
      
      includeRef = trim(entry(2, currentLine, ":")).
      
      
      if (not includeRef begins "~{") then 
          skipSource = true.

    end.
        
    return skipSource. 

  end method.  // CanSkipLine


  method public character GetFilenameInSource(sourceFragment as character):
    
    define variable includeName as character no-undo.
    define variable endPos as integer no-undo.
    
    includeName = trim(substring(sourceFragment, 2)).
    endPos = index(includeName, ".i").
    
    if (endPos > 0) then 
      includeName = substring(includeName, 1, endPos + 1).
    
/*    if (num-entries(includeName, " ") > 1) then */
/*       includeName = entry(1, includeName, " ").*/
        
    return trim(includeName).

  end method.  // GetFilenameInSource

end class.
