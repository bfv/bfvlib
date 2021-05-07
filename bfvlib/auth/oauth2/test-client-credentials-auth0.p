
using bfvlib.auth.oauth2.ClientCredentialsFlow.

define variable flow as ClientCredentialsFlow no-undo.
define variable loginOK as logical no-undo.

message 'start' view-as alert-box.

flow = new ClientCredentialsFlow().

flow:TokenEndpoint = 'https://bfv-io.eu.auth0.com/oauth/token'.
flow:ClientId = '2YFgQmYfxhsTFc2l4McYDpDzKTemAAmq'.
flow:ClientSecret = 'RDTFKEdIyTRM2sp3oC2KFRifziQPakD63YOAzLorIQ72xNcldkxPGjGyDFB3Gj55'.
flow:Audience = 'https://bfv-io.eu.auth0.com/api/v2/'.

loginOK = flow:Login().

message 'loginOK:' loginOK view-as alert-box.
