 
 /*------------------------------------------------------------------------
    File        : CaseFixer
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Thu Aug 19 10:48:25 CEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

using devtools.fixcase.IFileTypeSpecific.

block-level on error undo, throw.

class devtools.fixcase.CaseFixer: 
  
  {devtools/fixcase/datastructures.i}
  
  define private variable specificLogic as IFileTypeSpecific no-undo.
  define private variable outputDirectory as character no-undo.
  define private variable totalChangedLines as integer no-undo.
  define private variable baseDir as character no-undo.
  define private variable pathSeparator as character no-undo.
  
  define private stream inputList.
  
  
  constructor CaseFixer(outputDir as character, logic as IFileTypeSpecific):
    specificLogic = logic.
    outputDirectory = outputDir.
    pathSeparator = (if (opsys = "win32") then "~\" else "/").
    baseDir = getBaseDirectory().
  end constructor.
  
  
  method public void ProcessFile(inputFilename as character):
    
    readInput(inputFilename).
    processList().
    generateReplaceScript().
    outputChangedList().
    
  end method.  // ProcessFile
  
  
  method private void readInput(inputFilename as character):
    
    define variable currentLine as character no-undo.
    
    input stream inputList from value(search(inputFilename)).
    output to value(outputDirectory + "rejected.txt").
    
    repeat:
      
      import stream inputList unformatted currentLine.
       
      if (specificLogic:CanSkipLine(currentLine)) then do:
        put unformatted currentLine + "~n".
        next.   
      end.
      
      create ttline.
      assign 
        ttline.originalInput = currentLine
        ttline.sourcename = trim(entry(1, currentLine, ":"))
        ttline.originalStatement = trim(substring(currentLine, index(currentLine, ":") + 1))
        ttline.filenameInSource = specificLogic:GetFilenameInSource(ttline.originalStatement)
        .
      
      catch err1 as Progress.Lang.Error :
        // hide error
      end catch.
            
    end.  // repeat

    finally:
      output close.
      input stream inputList close.
    end.
    
  end method.  // readInput
  
  
  method private void processList():
  
    for each ttline:
      
      find first ttfile where ttfile.firstUse = ttline.filenameInSource no-error.
      if (not available(ttfile)) then do:
        create ttfile.
        ttfile.correctCased = replace(getActalFilename(ttline.filenameInSource), "~\", "/").
        ttfile.firstUse = ttline.filenameInSource.
      end.
      
      if (not can-find(first ttoccurrence where ttoccurrence.occurrence = ttline.filenameInSource)) then do:
        create ttoccurrence.
        ttoccurrence.occurrence = ttline.filenameInSource.  
      end.
      
      ttline.correctedStatement = replace(ttline.originalStatement, ttline.filenameInSource, ttfile.correctCased).
      
    end.  // for each ttfile
  
    temp-table ttfile:write-json("file", outputDirectory + specificLogic:OutputPrefix + "-files.json", true).
    temp-table ttoccurrence:write-json("file", outputDirectory + specificLogic:OutputPrefix + "-occurrence.json", true).
    temp-table ttline:write-json("file", outputDirectory + specificLogic:OutputPrefix + "-processed.json", true).          
    
    for each ttline:
      if (compare(ttline.originalStatement, "eq", ttline.correctedStatement, "CASE-SENSITIVE") or 
          ttline.correctedStatement = ?) then do:
        create ttignored.
        buffer-copy ttline to ttignored.
      end.
      else do:
        create ttchanged.
        buffer-copy ttline to ttchanged.
      end.

    end.
    
    temp-table ttchanged:write-json("file", outputDirectory + specificLogic:OutputPrefix + "-changed.json", true).
    temp-table ttignored:write-json("file", outputDirectory + specificLogic:OutputPrefix + "-unchanged.json", true).
      
  end method.  // processList
  
  
  method private character getActalFilename (usedFilename as character):
    
    define variable actualFilename as character no-undo.
     
    file-info:file-name = search(usedFilename).
    actualFilename = getExactPathName(file-info:full-pathname).
    actualFilename = replace(actualFilename, baseDir + "source" + pathSeparator, "").
    
    if (basedir matches "*" + pathSeparator) then
      actualFilename = replace(actualFilename, baseDir, "").
    else
      actualFilename = replace(actualFilename, baseDir + pathSeparator, "").
    
    return actualFilename.
    
  end method.  // getActalFilename


  method private character getExactPathName (pathName as character):
    
    /* implementation unfortunately uses .NET, inspiration from:
     * https://stackoverflow.com/questions/325931/getting-actual-file-name-with-proper-casing-on-windows-with-net
     */
      
    define variable di as System.IO.DirectoryInfo no-undo.
    define variable infos as System.IO.FileSystemInfo extent no-undo.
  
    if (not (System.IO.File:Exists(pathName) OR System.IO.Directory:Exists(pathName))) then
      return pathName.
      
    di = new System.IO.DirectoryInfo(pathName).
    
    if (di:Parent <> ?) then do:    
      infos = di:Parent:GetFileSystemInfos(di:Name).
      
      return System.IO.Path:Combine(
        GetExactPathName(di:Parent:FullName), 
        infos[1]:Name
      ).
              
    end.
    else do:
      return caps(di:Name).
    end. 
  
  end method.  // GetExactPathName


  method private character escapeRegexChars (expr as character):
    
    define variable replaceChars as character no-undo.
    define variable replaceChar as character no-undo.
    define variable charCount as integer no-undo.
    define variable i as integer no-undo.
    
    // first backslash!
    replaceChars = "~\~"/().:~{~}?&".
    charCount = length(replaceChars).
    
    do i = 1 to charCount:
      replaceChar = substring(replaceChars, i, 1).
      expr = replace(expr, replaceChar, "~\" + replaceChar).
    end.   
       
    return expr.
      
  end method.  // escapeRegexChars


  method private void generateReplaceScript():
    
    define variable i as integer no-undo.
    define variable j as integer no-undo.
    define variable changeExpr as character no-undo.
    
    output to value(outputDirectory + specificLogic:OutputPrefix + "-fix-case.sh").
    
    put unformatted "#!/bin/bash~n".
    put unformatted "echo ~"start: `date`~"~n~n".
    
    i = 0.
    for each ttline:
      i = i + 1.
    end.
    put unformatted substitute("# eval RUN's: &1", i) + "~n".
    
    i = 0.
    for each ttignored:
      i = i + 1.
    end.
    put unformatted substitute("# ignored: &1 occurrences~n", i).
    
    i = 0. j= 0.
    for each ttchanged break by ttchanged.sourcename:
      i = i + 1.
      if (first-of(ttchanged.sourcename)) then 
        j = j + 1.
    end.
    put unformatted substitute("# to change: &1 occurrences in &2 files~n~n", i, j).
    
    totalChangedLines = 0.
    for each ttchanged:
      
      totalChangedLines = totalChangedLines + 1.
      
      changeExpr = substitute(
        "sed -i -E ~"s/&1/&2/~" &3~n", 
        escapeRegexChars(ttchanged.originalStatement),
        escapeRegexChars(ttchanged.correctedStatement),
        ttchanged.sourcename
      ).
      
      if (not can-find(first ttsedline where ttsedline.replaceExpr = changeExpr
                                         and ttsedline.sourceName = ttchanged.sourcename)) then do:
        put unformatted changeExpr.
        create ttsedline.
        assign 
          ttsedline.replaceExpr = changeExpr
          ttsedline.sourceName = ttchanged.sourcename
          .
      end.
      else do:
        delete ttchanged.  // this replace was already done 
      end.
      
    end.
    put unformatted "~necho ~"  end: `date`~"~n~n".
    put unformatted "#EOF~n".
    
    finally:
      output close.
    end.
    
  end method.  // generateReplaceScript


  method private void outputChangedList():
  
    define variable changeCount as integer no-undo.
    define variable errorFlag as character no-undo.
    
    output to value(outputDirectory + specificLogic:OutputPrefix + "-check.txt").
    
    for each ttchanged:
      
      errorFlag = (if (length(ttchanged.correctedStatement) <> length(ttchanged.originalStatement)) then "***** error *****: " else "").
      
      put unformatted errorFlag + ttchanged.sourcename "~n".
      put unformatted ttchanged.originalStatement "~n".
      put unformatted ttchanged.correctedStatement "~n~n".
      
      changeCount = changeCount + 1.
      
    end.
    
    put unformatted substitute("total changed lines: &1 (&2 sed commands)~n", totalChangedLines, changeCount).
    
    finally:
      output close.
    end.
    
  end method.  // outputChangedList


  method private character getBaseDirectory():
    
    define variable baseDir as character no-undo.
    
    file-info:file-name = ".".
    baseDir = file-info:full-pathname.
    
    baseDir = baseDir + pathSeparator.
    
    return baseDir.
     
  end method.  // getBaseDirectory
    
end class.
