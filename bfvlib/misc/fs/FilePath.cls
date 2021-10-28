 
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

class bfvlib.misc.fs.FilePath: 
  
  method public static character Join(part1 as character, part2 as character):
    
    define variable result as character no-undo.
    
    part1 = replace(part1, "~\", "/").
    part2 = replace(part2, "~\", "/").
    
    if (part1 matches "*/") then 
      result = part1 + part2.
    else 
      result = part1 + "/" + part2.
    
    return result.
    
  end method.
  
  method public static character Join(part1 as character, part2 as character, part3 as character):    
    return FilePath:Join(FilePath:Join(part1, part2), part3).
  end method.
  
  method public static character Join(part1 as character, part2 as character, part3 as character, part4 as character):    
    return FilePath:Join(FilePath:Join(part1, part2, part3), part4).
  end method.
  
  // 5 parts is (should be) enough)
  method public static character Join(part1 as character, part2 as character, part3 as character, part4 as character, part5 as character):  
    return FilePath:Join(FilePath:Join(part1, part2, part3, part4), part5).
  end method.
  
  method public static character GetWindowsName(filename as character):
    return replace(filename, "/", "~\").
  end method.
  
end class.