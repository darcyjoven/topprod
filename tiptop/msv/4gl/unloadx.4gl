DATABASE ds

MAIN
DEFINE l_db       LIKE type_file.chr50
DEFINE l_file     LIKE type_file.chr50
DEFINE l_sql      LIKE type_file.chr1000

LET l_db=ARG_VAL(1)
LET l_file=ARG_VAL(2)
LET l_sql=ARG_VAL(3)

DISPLAY "UNLOAD TO ",l_file," ",l_sql

DATABASE l_db
UNLOAD TO l_file l_sql

END MAIN
