DATABASE ds

MAIN
DEFINE l_db     VARCHAR(40)
DEFINE l_file   VARCHAR(40)
DEFINE l_table  VARCHAR(40)
DEFINE l_sql    VARCHAR(160)
DEFINE l_cnt    SMALLINT

LET l_db=ARG_VAL(1)
LET l_file=ARG_VAL(2)
LET l_table=ARG_VAL(3)

LET l_sql="SELECT * FROM ",l_table CLIPPED
#LET l_sql="SELECT * FROM ",l_table CLIPPED," where gaq02=1 "
#LET l_sql="SELECT * FROM ",l_table CLIPPED," where (gaq02=0 and gaq01 not in (select gaq01 from gaq_file where gaq02=1)) or (gaq02=1 and gaq05 is null) "
#LET l_sql="SELECT * FROM ",l_table CLIPPED," where (gaq02=0 and gaq01 not in (select gaq01 from gaq_file where gaq02=1)) "
#LET l_sql="SELECT * FROM ",l_table CLIPPED," where (gaq02=0 and gaq01 in (select gaq01 from gaq_file where gaq02=1 and gaq05 is null)) "
DISPLAY l_sql
DISPLAY "UNLOAD TO ",l_file," ",l_sql

DATABASE l_db
UNLOAD TO l_file l_sql
DISPLAY SQLCA.SQLERRD[3]
#LET l_sql="SELECT count(*) into l_cnt FROM ",l_table CLIPPED
#DISPLAY l_cnt

END MAIN
