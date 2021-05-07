 
 /*------------------------------------------------------------------------
    File        : SelectiveCompiler
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Thu May 28 13:15:40 CEST 2020
    Notes       : 
        The SelectiveCompiler and the CompileDirectory method traverse 
        a given directory for *.cls, *.p & *.w's. Those files are
        checked for the need for re-compilation. The criteria for 
        a recompile are:
        - no .r available
        - the source is newer than the rcode
        - the CRC of one of the tables is different between .r and db
        (to cover the case where the db changed and the source not)
        What is not taken into account is whether .i's used are changed.
        This would dramatically slow down a selective compile and therefor
        defeat the purpose. The only to get this right is a full compile.
  ----------------------------------------------------------------------*/

using Consultingwerk.Util.FileHelper from propath.

block-level on error undo, throw.

class SelectiveCompiler: 
    
    {Consultingwerk/Util/TempTables/ttFileNames.i &ACCESS=private}
    
    define temp-table ttcrc no-undo 
        field tableName as character
        field crcValue as integer
        index tableName as primary unique tableName
        .
        

    method public void CompileDirectory(directoryName as character, recurseDirectory as logical):
        this-object:CompileDirectory(directoryName, recurseDirectory, false).
    end method.
    
    
    method public void CompileDirectory(directoryName as character, recurseDirectory as logical, forceCompile as logical):
                
        FileHelper:GetFileList(directoryName, "*.cls", output table ttFileNames).
        this-object:processSourceFiles(table ttFileNames, forceCompile).
        
        FileHelper:GetFileList(directoryName, "*.p", output table ttFileNames).
        this-object:processSourceFiles(table ttFileNames, forceCompile).

        FileHelper:GetFileList(directoryName, "*.w", output table ttFileNames).
        this-object:processSourceFiles(table ttFileNames, forceCompile).

    end method.
    
    
    method private void processSourceFiles(table ttFilenames, forceCompile as logical):
        
        define variable recompile as logical no-undo.
        
        for each ttFileNames:
            recompile = (forceCompile or this-object:checkForNeedToRecompile(ttFileNames.FileName)).
            if (recompile) then do:
                this-object:compileFile(ttFileNames.FileName).
            end.
        end.
        
    end method.
    
    
    method private logical checkForNeedToRecompile(sourceFilename as character):
        
        define variable rcodeFilename as character no-undo.
        define variable tableCount as integer no-undo.
        define variable i as integer no-undo.
        define variable currentTable as character no-undo.
        define variable currentTableCrc as integer no-undo.
        define variable tableCrcInDb as integer no-undo.
        define variable sourceIsNewer as logical no-undo.
        
        rcodeFilename = this-object:getRcodeFilename(sourceFilename).
        
        if (search(rcodeFilename) = ?) then 
            return true.
        
        sourceIsNewer = isSourceNewerThanSource(sourceFilename, rcodeFilename).
        if (sourceIsNewer) then 
            return true.
            
        rcode-info:file-name = rcodeFilename.
        if (rcode-info:table-list = "") then 
            return false.
            
        tableCount = num-entries(rcode-info:table-list).
        
        do i = 1 to tableCount:
            
            currentTable = entry(i, rcode-info:table-list).
            currentTableCrc = integer(entry(i, rcode-info:table-crc-list)).
            tableCrcInDb = this-object:getTableCrc(currentTable).
            
            if (currentTableCrc <> tableCrcInDb) then
                return true. 
        end.
        
        return false.
        
    end method.
    
    
    method private logical isSourceNewerThanSource(sourceFilename as character, rcodeFilename as character):
        
        define variable sourceModTime as datetime no-undo.
        define variable rcodeModTime as datetime no-undo.
        
        file-info:file-name = sourceFilename.
        sourceModTime = datetime(file-info:file-mod-date, file-info:file-mod-time * 1000).
        
        file-info:file-name = rcodeFilename.
        rcodeModTime = datetime(file-info:file-mod-date, file-info:file-mod-time * 1000).
        
        return (sourceModTime > rcodeModTime).
        
    end method.
    
    
    method private integer getTableCrc(tableName as character):
        
        define variable tableCrc as integer no-undo.
        
        find ttcrc where ttcrc.tableName = tableName no-error.
        if (not available(ttcrc)) then do:
            create ttcrc.
            assign 
                ttcrc.tableName = tableName
                ttcrc.crcValue = this-object:getTableCrcFromDb(tableName)
                .
        end.
        
        tableCrc = ttcrc.crcValue.
        
        return tableCrc.
        
    end method.
    
    
    method private integer getTableCrcFromDb(tableName as character):
        
        define variable tableCrcFromDb as integer no-undo.
        define variable bufferHandle as handle no-undo.
        
        create buffer bufferHandle for table tableName.
        tableCrcFromDb = bufferHandle:crc-value.
        
        return tableCrcFromDb.
        
        finally:
            if (valid-handle(bufferHandle)) then 
                delete object bufferHandle.
        end.
      
    end method.
    
    
    method private void compileFile(sourceFilename as character):
        
        do on error undo, throw:
            
            compile value(sourceFilename) save generate-md5.
            
            catch err1 as Progress.Lang.Error :  
                this-object:deleteRcode(sourceFilename).    // compilation failed, make sure the old .r isn't left
            end catch.
        end.      
        
    end method.
    
    
    method private void deleteRcode(sourceFilename as character):
      
        define variable rcodeFilename as character no-undo.
        
        rcodeFilename = this-object:getRcodeFilename(sourceFilename).
        if (search(rcodeFilename) <> ?) then
            os-delete value(rcodeFilename).
         
    end method.
    
    
    method private character getRcodeFilename(sourceFilename as character):
      
        define variable rcodeFilename as character no-undo.
        define variable baseFilename as character no-undo.
        
        rcodeFilename = substring(sourceFilename, 1, r-index(sourceFilename, ".")) + "r".
        
        return rcodeFilename.
        
    end method.
    
end class.