DATABASE ds
MAIN
  DEFINE l_db VARCHAR(40)
  DEFINE l_sql VARCHAR(200)
 
  LET l_db=ARG_VAL(1)

  IF l_db IS NULL OR l_db = ' ' THEN
     DISPLAY "Analyze Whole Database"
     LET l_sql="BEGIN DBMS_STATS.GATHER_DATABASE_STATS(null); END;"
  ELSE 
     DISPLAY "Analyze Database ",l_db
     DATABASE l_db
     LET l_sql="BEGIN DBMS_STATS.GATHER_SCHEMA_STATS(null); END;"
  END IF
  PREPARE analyze_pre FROM l_sql
  EXECUTE analyze_pre
END MAIN
