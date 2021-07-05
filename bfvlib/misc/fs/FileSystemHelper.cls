 
 /*------------------------------------------------------------------------
    File        : FileSystemHelper
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Tue Jun 22 11:42:37 CEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

class bfvlib.misc.fs.FileSystemHelper: 
  
  method public static longchar GetFileContent(filenameIn as character):
    
    define variable fqFilename as character no-undo.
    define variable fileContent as longchar no-undo.
    
    fileContent = ?.
    
    do on error undo, throw:
      
      file-info:filename = filenameIn.
      fqFilename = file-info:full-pathname.
      
      if (fqFilename <> ?) then
        copy-lob file fqFilename to fileContent.
      
      catch err1 as Progress.Lang.Error :
        // hide error
      end catch.
    end.     
     
    fileContent = trim(fileContent).
     
    return fileContent.
    
  end method.  // GetFileContent
  
end class.
