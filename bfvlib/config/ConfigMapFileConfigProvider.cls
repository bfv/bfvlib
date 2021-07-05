 
 /*------------------------------------------------------------------------
    File        : ConfigMapFileConfigProvider
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Tue Jun 22 11:30:33 CEST 2021
    Notes       : The ConfigMapFileConfigProvider provider reads from the filesystem.
                  The name of the config parameter is the filename, the contents
                  of the file is the value of config parameter. This provider 
                  is designed for Kubernetes ConfigMaps.
  ----------------------------------------------------------------------*/

using bfvlib.config.IConfigProvider.
using bfvlib.misc.fs.FileSystemHelper.

block-level on error undo, throw.

class bfvlib.config.ConfigMapFileConfigProvider implements IConfigProvider: 

  define private temp-table ttvalue no-undo
    field pname as character 
    field pvalue as character
    field json as Progress.Lang.Object
    .
  
      
  method public character GetValue(configParameterName as character):
    
    define variable configValue as character no-undo.
    
    find ttvalue where ttvalue.pname = configParameterName no-error.
    if (available(ttvalue)) then
      configValue = ttvalue.pvalue.
    else
      configValue = this-object:readFromFS(configParameterName).
      
    return configValue.

  end method.  // GetValue
  
  
  method private character readFromFS(configParameterName as character):
    
    define variable configValue as character no-undo.
    
    configValue = string(FileSystemHelper:GetFileContent('./../configmap/' + configParameterName)).
   
    return configValue.
    
  end method.  // readFromFS
  
end class.