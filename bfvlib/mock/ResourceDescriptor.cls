 
 /*------------------------------------------------------------------------
    File        : ResourceDescriptor
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bronco
    Created     : Fri May 08 19:11:01 CEST 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using bfvlib.mock.HttpVerbs from propath.

block-level on error undo, throw.

class bfvlib.mock.ResourceDescriptor: 
    
    define public property ResourceName as character no-undo get. set.
    define public property Plural as character no-undo get. set.
    define public property Verbs as HttpVerbs no-undo get. set.
    
    
end class.