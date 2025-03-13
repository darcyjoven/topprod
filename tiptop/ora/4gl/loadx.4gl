DATABASE ds

MAIN
DEFINE l_db     VARCHAR(40)
DEFINE l_file   VARCHAR(40)
DEFINE l_sql    VARCHAR(60)

LET l_db=ARG_VAL(1)
LET l_file=ARG_VAL(2)
LET l_sql=ARG_VAL(3)

DISPLAY "LOAD FROM ",l_file," ",l_sql

DATABASE l_db
LOAD FROM l_file l_sql

END MAIN
