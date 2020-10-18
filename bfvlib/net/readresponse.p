
using bfvlib.net.IReadResponse from propath.

define input parameter clientSocket as handle no-undo.
define input parameter clientClass as IReadResponse no-undo.


procedure getResponse:
    
    define variable responseBytes as memptr no-undo.
    define variable responseText as longchar no-undo.
    
    if (not clientSocket:connected()) then do:
        return.
    end.
    
    do while (clientSocket:get-bytes-available() > 0):
        set-size(responseBytes) = clientSocket:get-bytes-available() + 1.
        clientSocket:read(responseBytes, 1, 1, clientSocket:get-bytes-available()).
        responseText = responseText + get-string(responseBytes, 1).
    end.
    
    clientClass:ProcessResponse(responseText).
    
    finally:
        set-size(responseBytes) = 0.
    end.
    
end procedure.
