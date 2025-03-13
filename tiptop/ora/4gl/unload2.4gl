DATABASE ds

MAIN
DEFINE l_db     VARCHAR(40)
DEFINE l_file   VARCHAR(40)
DEFINE l_table  VARCHAR(40)
DEFINE l_sql    VARCHAR(60)
DEFINE l_where  VARCHAR(60)

LET l_db=ARG_VAL(1)
LET l_file=ARG_VAL(2)
LET l_table=ARG_VAL(3)
LET l_where=ARG_VAL(4)

LET l_sql="SELECT * FROM ",l_table CLIPPED," WHERE ",l_where
DISPLAY l_sql
DISPLAY "UNLOAD TO ",l_file," ",l_sql

DATABASE l_db
UNLOAD TO l_file l_sql

END MAIN
