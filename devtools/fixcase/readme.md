# Case fixer

The software in the `devtool/fixcase` is make sure that `RUN ... .p` statements and `{include.i}` are correctly case in the source.
The current implementation is class based and is started via either:

- `fix-dotp.p`
  
- `fix-include-refs.p`

## Running the CaseFixer
The fix-dotp.p looks like:

```
using devtools.fixcase.CaseFixer from propath.
using devtools.fixcase.RunDotPLogic from propath.

define variable fixer as CaseFixer no-undo.

fixer = new CaseFixer("../../io/output-p/", new RunDotPLogic()).
fixer:ProcessFile("../../io/input/input.run-dot-p.list").

message "done w/ .p's" view-as alert-box.
```

So you can specify a few things:

-  the input file (`ProcessFile` method's parameter)

-  the output directory for the results (first parameter of `CaseFixer` constructor)

In theory you can inject a alternate implementation of `IFileTypeSpecific` but that's not necessary for now.

## Input file 
The input file as used is the result of `grep -i "run.*\.p"` (RUN .p's) or  `grep -ir "{.*\.i"`  (include refs)
to give an idea, the contents looks like:
```./source/AbsenceGroupSetup.w:      RUN enable.p(ptc_ReasonGroup.ReasonGroupID:HANDLE).```

## Output files
Various output files are put in the output dir:

- `rejected.txt`              - a list of lines from the input which are rejected straightaway. This is based on rules programmed into `IFileTypeSpecific:CanSkipLine`

- `run-dot-p-processed.json`  - JSON dump of temp-table (ttline) representation of all lines which are not rejected, with extracted information of the input.

- `run-dot-p-unchanged.json`  - all `ttline` records which don't result in replacements in the sources.

- `run-dot-p-changed.json`    - the ttline which result changes to the code. The `originalStatement` and `correctedStatement` are not found to be the same in a case-sensitive compare.

- `run-dot-p-check.txt`       - text representation of before and after the replacements. Handy for assessing what will be done to the sources

- `run-dot-p-files.json`      - the first encounter of a .p name together with it correct case

- `run-dot-p-occurrence.json` - all the correct cased .p filenames

- `run-dot-p-fix-case.sh`     - the resulting script which, when executed, applies all the changes to the sources.

## shell script to execute

The resulting script (`run-dot-p-fix-case.sh`) which needs to be executed by `bash` containing all the `sed` commands to correct the case.

A fragment of `run-dot-p-fix-case.sh`:
```
sed -i -E "s/RUN enable\.p\(uShowInactive\:HANDLE\)\./RUN ENABLE\.P\(uShowInactive\:HANDLE\)\./" ./source/AbsenceGroupSetup.w
sed -i -E "s/RUN enable\.p\(uButtonAddAbs\:HANDLE\)\./RUN ENABLE\.P\(uButtonAddAbs\:HANDLE\)\./" ./source/AbsenceGroupSetup.w
sed -i -E "s/RUN enable\.p\(uButtonDelAbs\:HANDLE\)\./RUN ENABLE\.P\(uButtonDelAbs\:HANDLE\)\./" ./source/AbsenceGroupSetup.w
sed -i -E "s/RUN enable\.p\(uBG-Color\:HANDLE\)\./RUN ENABLE\.P\(uBG-Color\:HANDLE\)\./" ./source/AbsenceGroupSetup.w
sed -i -E "s/RUN enable\.p\(uFG-Color\:HANDLE\)\./RUN ENABLE\.P\(uFG-Color\:HANDLE\)\./" ./source/AbsenceGroupSetup.w
sed -i -E "s/RUN enable\.p\(uAbsenceGroupBrowser\:HANDLE\)\./RUN ENABLE\.P\(uAbsenceGroupBrowser\:HANDLE\)\./" ./source/AbsenceGroupSetup.w
sed -i -E "s/RUN enable\.p\(u_button_info\:HANDLE\)\./RUN ENABLE\.P\(u_button_info\:HANDLE\)\./" ./source/AbsenceGroupSetup.w
sed -i -E "s/RUN enable\.p\(uReasonBrowser\:HANDLE\)\./RUN ENABLE\.P\(uReasonBrowser\:HANDLE\)\./" ./source/AbsenceGroupSetup.w
sed -i -E "s/RUN init_sys\.p\(TRUE\)\./RUN INIT_SYS\.P\(TRUE\)\./" ./source/ac-server.w
sed -i -E "s/RUN accnv03I\.p\(0, 6, FALSE, \?, \?, TIME\)\.*\//RUN accnv03i\.p\(0, 6, FALSE, \?, \?, TIME\)\.*\//" ./source/ac-server.w
```
