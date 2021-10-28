 
 /*------------------------------------------------------------------------
    File        : DotPLogic
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Thu Aug 19 10:42:57 CEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

using devtools.fixcase.IFileTypeSpecific.

block-level on error undo, throw.

class devtools.fixcase.RunDotPLogic implements IFileTypeSpecific: 

  define property OutputPrefix as character initial "run-dot-p" get.
  
  
  method public logical CanSkipLine(currentLine as character):
    
    define variable skipSource as logical no-undo.
    define variable runStatement as character no-undo.
    define variable bracketPos as integer no-undo.
    
    if (currentLine begins "Binary") then
        return true.
        
    runStatement = trim(entry(2, currentLine, ":")).
    
    if (not runStatement begins "run ") then 
        skipSource = true.
    else do: 
      bracketPos = index(runStatement, "(").
      if (bracketPos > 0 and bracketPos < index(runStatement, ".p")) then 
        skipSource = true.
    end.       
      
    return skipSource. 

  end method.  // CanSkipLine
  

  method public character GetFilenameInSource(sourceFragment as character):
    
    define variable dotPName as character no-undo.
    define variable endPos as integer no-undo.
    
    dotPName = trim(substring(sourceFragment, 5)).
    endPos = index(dotPName, "(").
    
    if (endPos > 0) then 
      dotPName = substring(dotPName, 1, endPos - 1).
    
    if (num-entries(dotPName, " ") > 1) then
       dotPName = entry(1, dotPName, " ").
    
    dotPName = trim(dotPName, ".").
            
    return trim(dotPName).

  end method.  // GetFilenameInSource

end class.
