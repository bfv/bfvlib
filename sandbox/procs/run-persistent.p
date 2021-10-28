
block-level on error undo, throw.

define variable hProc as handle no-undo.

run sandbox/procs/non-persistent.p persistent set hProc.

message 'done' view-as alert-box.