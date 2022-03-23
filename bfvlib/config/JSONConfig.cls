 
 /*------------------------------------------------------------------------
    File        : Config
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Mon Mar 21 09:24:37 CET 2022
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Lang.AppError.
using Progress.Json.ObjectModel.JsonDataType.

using bfvlib.config.JSONConfig.
using bfvlib.config.IConfig.

class bfvlib.config.JSONConfig implements IConfig: 
  
  define private temp-table ttprop no-undo
    field pname as character
    field pvalue as character
    .
  
  constructor public JSONConfig():
    // LoadConfig needed
  end.
    
  constructor public JSONConfig(filename as character):
    LoadConfig(filename).
  end constructor. 
  
  
  method public character Get(path as character):
    
    define variable returnValue as character initial ? no-undo.
    
    find ttprop where ttprop.pname = path no-error.
    if (available(ttprop)) then 
      returnValue = ttprop.pvalue.
          
    return returnValue.
    
  end method.  // Get
  
  
  method public character Get(path as character, defaultValue as character):
    
    define variable returnValue as character initial ? no-undo.
    
    returnValue = Get(path).
    if (returnValue = ?) then 
      returnValue = defaultValue.
            
    return returnValue.
    
  end method.  // Get
    
  
  method public logical LoadConfig(filename as character):
    
    define variable parser as ObjectModelParser no-undo.
    define variable json as JsonObject no-undo.
    define variable parent as JSONConfig no-undo.
    define variable loadOk as logical no-undo.
    
    loadOk = true.
    do on error undo, throw:
      
      parser = new ObjectModelParser().
      json = cast(parser:ParseFile(search(filename)), JsonObject).
      
      if (json:Has("_inherits")) then do:
        parent = new JSONConfig(json:GetCharacter("_inherits")).
        parent:GetProps(output table ttprop).
      end.
      
      traverse(json, "").      
      
      catch err1 as Progress.Lang.Error :
        loadOk = false.
      end catch.
      
    end.  // do on error...
    
    return loadOk.
        
  end method.  // LoadConfig
  
  
  method public void GetProps(output table ttprop):
    // outputs just the table 
  end method.  // GetProps
  
  
  method private void traverse(json as JsonObject, prefix as character):
    
    define variable childs as character extent no-undo.
    define variable i as integer no-undo.
    define variable nodeType as integer no-undo.
    define variable nodeName as character no-undo.
    
    define variable objNode as JsonObject no-undo.
    
    childs = json:GetNames().
    do i = 1 to extent(childs):
      
      nodeName = childs[i].
      if (nodeName begins "_") then
        next.
        
      nodeType = json:GetType(nodeName).
      
      case true:
        
        when (nodeType = JsonDataType:OBJECT) then
          traverse(json:GetJsonObject(nodeName), prefix + nodeName + ".").
        
        when (nodeType = JsonDataType:BOOLEAN) then 
          assignValue(prefix + nodeName, string(json:GetLogical(nodeName), "true/false")).
        
        when (nodeType = JsonDataType:NUMBER) then 
           assignValue(prefix + nodeName, string(json:GetDecimal(nodeName))).
           
        when (nodeType = JsonDataType:STRING) then
          assignValue(prefix + nodeName, json:GetCharacter(nodeName)).
        
        otherwise do:
          // nothing? or throw an exception??
        end.
          
      end case.
      
    end.  // do i = 1 to extent(childs)...
    
  end method.  // traverse
  
  
  method private void assignValue(pname as character, pvalue as character):

    find ttprop where ttprop.pname = pname no-error.
    if (not available(ttprop)) then do:
      create ttprop.
      ttprop.pname = pname.        
    end. 
    
    ttprop.pvalue = pvalue.
    
  end method.  // assignValue
  
end class.
