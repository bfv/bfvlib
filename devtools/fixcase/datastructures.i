
define temp-table ttline no-undo
  field originalInput as character
  field sourcename as character
  field originalStatement as character
  field filenameInSource as character
  field correctedStatement as character
  index sourcename sourcename
  .

define temp-table ttchanged no-undo like ttline.
define temp-table ttignored no-undo like ttline.

define temp-table ttfile no-undo
  field correctCased as character
  field firstUse as character
  index correctCased correctCased
  index firstUse firstUse
  .

define temp-table ttoccurrence no-undo
  field occurrence as character case-sensitive 
  index occurrence occurrence
  .
  
define temp-table ttsedline no-undo
  field replaceExpr as character case-sensitive
  field sourceName as character
  index pk as primary unique sourceName replaceExpr
  .
