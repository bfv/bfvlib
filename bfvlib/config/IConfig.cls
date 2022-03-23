
/*------------------------------------------------------------------------
    File        : IConfig
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Wed Mar 23 10:06:06 CET 2022
    Notes       : 
  ----------------------------------------------------------------------*/

interface bfvlib.config.IConfig:  
  
  method public logical LoadConfig(filename as character).
  method public character Get(path as character).
  method public character Get(path as character, defaultValue as character).
    
end interface.
