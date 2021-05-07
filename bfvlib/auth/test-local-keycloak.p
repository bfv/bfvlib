

using bfvlib.auth.OAuth2Config.
using bfvlib.auth.OAuth2Authenticator.
using bfvlib.auth.AuthenticationReponse.

define variable config as OAuth2Config no-undo.
define variable authenticator as OAuth2Authenticator no-undo.
define variable response as AuthenticationReponse no-undo.

log-manager:logfile-name = "./kc.log".
log-manager:logging-level = 5.

config = new OAuth2Config(
  "http://keycloak.bfv.io:8081/auth/realms/COKZ/protocol/openid-connect/token",
  "ExspectGuiClient"
).

authenticator = new OAuth2Authenticator(config).

response = authenticator:DirectGrantLogin("bfv", "bfv").

message response:ToString() view-as alert-box.

