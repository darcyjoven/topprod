DATABASE ds

MAIN
DEFINE l_db     LIKE type_file.chr50
DEFINE l_file   LIKE type_file.chr50
DEFINE l_sql    LIKE type_file.chr100

LET l_db=ARG_VAL(1)
LET l_file=ARG_VAL(2)
LET l_sql=ARG_VAL(3)

DISPLAY "LOAD FROM ",l_file," ",l_sql

DATABASE l_db
LOAD FROM l_file l_sql

END MAIN
