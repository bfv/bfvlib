

using devtools.fixcase.CaseFixer.
using devtools.fixcase.IncludeRefLogic.

define variable fixer as CaseFixer no-undo.

fixer = new CaseFixer("../../io/output-i/", new IncludeRefLogic()).
fixer:ProcessFile("../../io/input/input.include-refs.list").

message "done w/ includes" view-as alert-box.
