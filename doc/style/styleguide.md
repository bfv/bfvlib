# Style guide OpenEdge 4GL

Programming styles are (most of the time) highly subjective. It helps however to have a clear set of rules to make the code look uniform and to avoid discussion.
These rules are influenced by C# and TypeScript.

## case
Although PSC persists in writing documentation in uppercase, every mainstream language nowadays is written in lowercase (statements that is).
Apart from that there's lowerCamelCase and UpperCamelCase for all sorts of members/variables etc.
Other files, like the one on classes, contain some extra guidance on casing.

### statements
4GL statements are written in __lowercase__!

### directories
Directory names are written in __lowercase__ only. This simplyfies working on *nix file systems.

### package names
In the end package names are directories, so __lowercase__

### class names
Class names are in UpperCamelCase.

fully qualified class name example: `bfvlib.serialize.SimpleJsonSerializer`

### non-class files
.p, .i, .w file names are in __lowercase__


## structure

### indents
The indents are spaces, not tabs. The tab size is 4 spaces.

### order
The order within a source is
- block-level first
- `using`s second
- the rest

### if-then-else
If's are written like:

if (_expression_) then
    _statement_
else
    _statement_

with do-blocks:
if (_expression_) then do:
    _statement_
end.
else do:
    _statement_
end.

_then_ or _do_ NOT on a new line

