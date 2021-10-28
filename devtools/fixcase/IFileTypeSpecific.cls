
/*------------------------------------------------------------------------
    File        : IFileTypeSpecific
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Thu Aug 19 10:37:13 CEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

interface devtools.fixcase.IFileTypeSpecific:  
  
  define property OutputPrefix as character get.
  
  /* the implementation should return true if the `currentLine` is not suitable for further processing */  
  method public logical CanSkipLine (currentLine as character).

  /* method responsible for extracting the filename to be evaluated is the case is correct */
  method public character GetFilenameInSource (sourceFragment as character).
  
end interface.
