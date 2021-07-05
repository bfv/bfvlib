/*------------------------------------------------------------------------
    File        : test-postNL-Api.p
    Purpose     : 

    Syntax      :

    Description : test procedure om de postnl api te testen

    Author(s)   : H.Hoekstra
    Created     : Thu Jun 25 12:03:15 CEST 2020
    Notes       :
  ----------------------------------------------------------------------*/
USING Progress.Json.ObjectModel.JsonObject.
USING Progress.Json.ObjectModel.ObjectModelParser FROM PROPATH.
USING Progress.Json.ObjectModel.JsonArray FROM PROPATH.
USING bfvlib.net.HttpHelper.
USING bfvlib.net.HttpRequestOptions.
USING OpenEdge.Net.HTTP.RequestBuilder FROM PROPATH.
USING OpenEdge.Net.HTTP.IHttpResponse FROM PROPATH.
 
BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ***************************  Definitions  ************************** */
DEFINE VARIABLE options         AS HttpRequestOptions NO-UNDO.
DEFINE VARIABLE oPayload        AS JsonObject         NO-UNDO.
DEFINE VARIABLE oRequest        AS LONGCHAR           NO-UNDO.
DEFINE VARIABLE oResponse       AS IHttpResponse      NO-UNDO.
DEFINE VARIABLE lcResponse      AS LONGCHAR           NO-UNDO.
DEFINE VARIABLE oJsonObject     AS JsonObject         NO-UNDO.
DEFINE VARIABLE oJsonArray      AS JsonArray          NO-UNDO.
DEFINE VARIABLE cUrl            AS CHARACTER          NO-UNDO.
DEFINE VARIABLE lRetOK          AS LOG                NO-UNDO.
DEFINE VARIABLE hTT             AS HANDLE             NO-UNDO.
DEFINE VARIABLE cApiKey         AS CHARACTER          NO-UNDO.
DEFINE VARIABLE cPlaatsStraat   AS CHARACTER          NO-UNDO.
DEFINE VARIABLE cReeksIndicatie AS CHARACTER          NO-UNDO.


  
/* ***************************  Main Block  *************************** */
message 'tested' view-as alert-box.
cApiKey = '96oqoAOIbGOEEDIoKTqRoywSWlCL15YT'.

copy-lob file 'c:\tmp\data.json' to oRequest.

options = NEW HttpRequestOptions(). 
options:ContentType = 'application/json'.
options:addHeader('apiKey', cApiKey).
cUrl = 'https://api-sandbox.postnl.nl/shipment/v2/confirm'.
oResponse = HttpHelper:Post(cUrl, oRequest, options).
lcResponse = HttpHelper:GetLongchar(oResponse) .




IF lcResponse = '' OR lcResponse = ?
THEN DO:
  message "Ophalen postcodegegevens: Communicatie met PostNL is niet goed verlopen.". 
END.    
ELSE do: 
  copy-lob lcResponse to file 'c:\tmp\temped.txt'.
end.