
using bfvlib.config.ConfigMapFileConfigProvider.

define variable config as bfvlib.config.IConfigProvider no-undo.

config = new ConfigMapFileConfigProvider().
message config:GetValue('environment') config:GetValue('environment.version') view-as alert-box.

