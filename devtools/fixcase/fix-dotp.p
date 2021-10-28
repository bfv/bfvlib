

using devtools.fixcase.CaseFixer from propath.
using devtools.fixcase.RunDotPLogic from propath.

define variable fixer as CaseFixer no-undo.

fixer = new CaseFixer("../../io/output-p/", new RunDotPLogic()).
fixer:ProcessFile("../../io/input/input.run-dot-p.list").

message "done w/ .p's" view-as alert-box.
