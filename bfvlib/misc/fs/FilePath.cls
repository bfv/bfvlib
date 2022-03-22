 
/*------------------------------------------------------------------------
   File        : FilePath
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : bronco
   Created     : Thu Oct 28 15:37:28 CEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

block-level on error undo, throw.

using bfvlib.misc.fs.FilePath.
using Progress.Lang.AppError.

class bfvlib.misc.fs.FilePath: 
  
  define public static property Separator as char initial "/" no-undo get. set.
  
  constructor static FilePath():
    if (opsys = "win32") then
      FilePath:Separator = "~\". 
  end constructor.
  
  
  method public static character Base(filename as character):
    
    define variable pos as int no-undo.
    
    filename = replace(filename, "~\", "/").
    
    if (substring(filename, length(filename)) = "/") then
      filename = substring(filename, 1, length(filename) - 1).
      
    pos = r-index(filename, "/").
    if (pos > 0) then 
      filename = substring(filename, pos + 1).
    
    return filename.
      
  end method.  // Base
  
  
  method public static char Clean(filename as char):
    
  end method.  // Clean
  
  
  method public static char Dir(filename as char):

    define variable pos as int no-undo.
    
    filename = replace(filename, "~\", "/").
    
    if (substring(filename, length(filename)) = "/") then
      filename = substring(filename, 1, length(filename) - 1).
      
    pos = r-index(filename, "/").
    if (pos > 0) then 
      filename = substring(filename, 1, pos - 1).
    
    if ((opsys = "unix" and filename = "") or (opsys = "win32" and filename matches "*:")) then
      filename = filename + "/".
       
    return filename.
  
  end method.  // Dir
  
  
  method public static char Ext(filename as char):
    
    define variable pos as int no-undo.
    define variable ext as char no-undo.
    
    filename = FilePath:Base(filename).
    pos = r-index(filename, ".").
    if (pos > 0) then
      ext = substring(filename, pos).
    
    if (ext = ".") then 
      ext = "".
        
    return ext.
       
  end method.  // Ext
  
  
  method public static char FromSlash(filename as char):
    filename = replace(filename, "~\", FilePath:Separator).
    filename = replace(filename, "/", FilePath:Separator).
    return filename.
  end method.  // FromSlash
  
  
  method public static character GetWindowsName(filename as character):
    return replace(filename, "/", "~\").
  end method.  // GetWindowsName


  method public static char Glob(filename as char):
    undo, throw new AppError("FilePath:Glob is not implemented", -1).
  end method.  // Glob
  
  
  method public static logical IsAbs(filename as char):
    filename = FilePath:FromSlash(filename).
    return ((opsys = "win32" and filename matches ".:~\*") or (opsys = "unix" and filename begins "/")).
  end method.  // IsAbs
  
  
  method public static char Join(part1 as char, part2 as char):
    
    define variable result as character no-undo.
    
    part1 = replace(part1, "~\", "/").
    part2 = replace(part2, "~\", "/").
    
    if (part1 matches "*/") then 
      result = part1 + part2.
    else 
      result = part1 + "/" + part2.
    
    return result.
    
  end method.  // Join
  
  method public static character Join(part1 as character, part2 as character, part3 as character):    
    return FilePath:Join(FilePath:Join(part1, part2), part3).
  end method.  // Join
  
  method public static character Join(part1 as character, part2 as character, part3 as character, part4 as character):    
    return FilePath:Join(FilePath:Join(part1, part2, part3), part4).
  end method.  // Join
  
  // 5 parts is (should be) enough)
  method public static character Join(part1 as character, part2 as character, part3 as character, part4 as character, part5 as character):  
    return FilePath:Join(FilePath:Join(part1, part2, part3, part4), part5).
  end method.  // Join
    
end class.
