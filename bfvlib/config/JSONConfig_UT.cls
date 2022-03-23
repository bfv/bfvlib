 
 /*------------------------------------------------------------------------
    File        : JSONConfig_UT
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Wed Mar 23 10:47:12 CET 2022
    Notes       : 
  ----------------------------------------------------------------------*/

using bfvlib.config.IConfig.
using bfvlib.config.JSONConfig.
using OpenEdge.Core.Assert.

block-level on error undo, throw.

class bfvlib.config.JSONConfig_UT:
  
  define private variable cfg as IConfig no-undo.
  
  @Setup.
  method public void setUp():
      cfg = new JSONConfig().
      cfg:LoadConfig("bfvlib/config/sample01.json").
  end method.
    
  @TearDown.
  method public void tearDown():
    if (valid-object(cfg)) then
      delete object cfg.
  end method.
      
  @Test.
  method public void InitReturnsValidConfig():
    Assert:Equals(true, valid-object(cfg)).
  end method.
  
  @Test. 
  method public void GetSimpleProperty():   
    Assert:Equals("abcde12345", cfg:Get("apikey")).
  end method.
      
  @Test. 
  method public void GetNested1Deep():
    Assert:Equals("smtp.bfv.io", cfg:Get("email.host")). 
  end method.
  
  @Test. 
  method public void GetNested4Deep():
    Assert:Equals("0110", cfg:Get("nest0.nest01.nest011.nest0110")). 
  end method.
  
  @Test. 
  method public void GetInherited():   
    Assert:Equals("system1_bfv-io", cfg:Get("name")).
  end method.

  @Test. 
  method public void GetInherited2Deep():   
    Assert:Equals("bfv.io", cfg:Get("company")).
  end method.

  @Test. 
  method public void GetOverridden():   
    Assert:Equals("test", cfg:Get("environment")).
  end method.
  
  @Test. 
  method public void GetNonExistent():   
    Assert:Equals(?, cfg:Get("<non-existent>")).
  end method.

  @Test. 
  method public void GetDefault():   
    Assert:Equals("default", cfg:Get("<non-existent>", "default")).
  end method.
  
end class.
