# update-schema.xml
    
The script is an Ant script designed to update one of more databases 
based on (version controlled) .df & .st files. These .df and .st files
are expected to reside all in the same directory. This script reads 
a property file with the following structure:
    
```
databases=sports2000,docu

schema.location=exsysserver/Schema
database.tmp.location=tmp/db

sports2000.db.name=sports2000
sports2000.db.port=8401
sports2000.db.host=localhost

docu.db.name=docu
docu.db.port=8404
docu.db.host=localhost
```
    
The location properties are relative to `${basedir}`. The delta's are created
in `${database.tmp.location}` and can be reviewed before they are applied to
the target databases.

If the database is called sports2000 then the .df is expected to be sports2000.df (in the `${schema.location}`) and the .st file sports2000.st.

The script can be called like:

`ant -f update-schema.xml -DDLC=c:/dlc/117 [-Dpropertyfile=<alternate-dir>]`

The scripts expects ant-contrib-1.0b3.jar to be in the lib dir of Ant.     
