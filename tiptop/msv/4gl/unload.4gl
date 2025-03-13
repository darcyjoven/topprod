DATABASE ds

MAIN
DEFINE l_db     LIKE type_file.chr50  #VARCHAR(40)
DEFINE l_file   LIKE type_file.chr50  #VARCHAR(40)
DEFINE l_table  LIKE type_file.chr50  #VARCHAR(40)
DEFINE l_sql    LIKE type_file.chr100 #VARCHAR(60)
DEFINE l_cnt    SMALLINT

LET l_db=ARG_VAL(1)
LET l_file=ARG_VAL(2)
LET l_table=ARG_VAL(3)

LET l_sql="SELECT * FROM ",l_table CLIPPED
DISPLAY "l_sql",l_sql
DISPLAY "UNLOAD TO ",l_file," ",l_sql

DATABASE l_db
UNLOAD TO l_file l_sql
LET l_sql="SELECT count(*) into l_cnt FROM ",l_table CLIPPED
DISPLAY l_cnt

END MAIN
