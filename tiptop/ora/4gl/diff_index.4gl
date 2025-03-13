# 1. table 內的primary key 是否存在  —if not 則秀warning
# 2. Index / primary key 的 naming rule 是否合格
# 3. 任兩指定 db 的同 table 內 index/primary key
#    A.	組成欄位是否一致
#    B.	欄位順序是否一致
#    C.	是否超過 16 個欄位 (超過會在SQL Server出現問題)


DATABASE ds

DEFINE g_zta DYNAMIC ARRAY OF RECORD
         zta01  VARCHAR(20),
         zta17  VARCHAR(20)        
                END RECORD
DEFINE l_name    VARCHAR(20)
DEFINE l_unique  VARCHAR(10)                
DEFINE g_table   VARCHAR(10)
DEFINE li_cnt    INTEGER
DEFINE li_pos    INTEGER
DEFINE l_sql    STRING
DEFINE l_arg1   VARCHAR(10)
DEFINE l_arg2   VARCHAR(10)
DEFINE l_schema  VARCHAR(10)
DEFINE l_sch2    VARCHAR(10)

MAIN

   LET l_arg1  = ARG_VAL(1)
   LET l_arg2  = ARG_VAL(2)
   LET g_table = ARG_VAL(3)
   IF l_arg2 IS NULL OR l_arg1 = l_arg2 THEN 
      CALL diff_error()
      EXIT PROGRAM 
   END IF 
   
   IF g_table IS NULL  THEN
      LET g_table = "%"
   ELSE
      LET g_table = g_table ,"%"
   END IF
   
   LET l_schema =  l_arg1 CLIPPED
   LET l_sch2   =  l_arg2 CLIPPED

   LET l_sql = " SELECT LOWER(table_name),owner FROM all_tables ", 
               " WHERE LOWER(owner)='", l_arg1 ,"' ",
               "   AND LOWER(table_name) LIKE ? ",
               " ORDER BY table_name "
   PREPARE g_zta_pre FROM l_sql
   DECLARE g_zta_cur CURSOR FOR g_zta_pre

   LET li_cnt = 1
   FOREACH g_zta_cur USING g_table INTO g_zta[li_cnt].*
      LET li_cnt = li_cnt + 1  
   END FOREACH
   CALL g_zta.deleteElement(li_cnt)
   
   CALL diff_index()
END MAIN


FUNCTION diff_index()
   DEFINE i          INTEGER
   DEFINE l_res      INTEGER 
   DEFINE l_no_pk    INTEGER
   DEFINE l_no_idx   INTEGER
   DEFINE l_idx_name STRING
   
    LET l_sql="SELECT DISTINCT LOWER(index_name),uniqueness", #get all indexes
              "  FROM all_indexes ",
              " WHERE LOWER(table_name)=? ",
              "   AND LOWER(owner)='",l_schema,"'"
    PREPARE col_src_pre FROM l_sql 
    DECLARE col_src_cur CURSOR FOR col_src_pre       
    
    LET l_sql="SELECT COUNT(*)",
              "  FROM all_indexes ",
              " WHERE LOWER(table_name)=?",
              "   AND LOWER(owner)='",l_sch2,"'",
              "   AND LOWER(index_name)=? "
    PREPARE col_tgr_pre FROM l_sql 
    DECLARE col_tgr_cur CURSOR FOR col_tgr_pre
    
    LET l_sql = "SELECT LOWER(CONSTRAINT_NAME)",  #get Constraint
               "  FROM ALL_CONSTRAINTS ",
               " WHERE LOWER(OWNER)='",l_schema,"' ",
               "   AND LOWER(TABLE_NAME)=? ",
               "  AND CONSTRAINT_NAME NOT like 'SYS_%' "  
    PREPARE pk_src_pre FROM l_sql 
    DECLARE pk_src_cur CURSOR FOR pk_src_pre 
    
    LET l_sql = "SELECT COUNT(*)",
               "  FROM ALL_CONSTRAINTS ",
               " WHERE LOWER(OWNER)='",l_sch2,"' ",
               "   AND LOWER(TABLE_NAME)=? ",
               "   AND LOWER(CONSTRAINT_NAME)=?"                    
    PREPARE pk_tgr_pre FROM l_sql 
    DECLARE pk_tgr_cur CURSOR FOR pk_tgr_pre                  
    
    
    LET l_sql = "SELECT COUNT(*)",              #get synonyms
               "  FROM all_synonyms ",
               " WHERE LOWER(OWNER)='",l_sch2,"' ",
               "   AND LOWER(synonym_name)=? "
               
    PREPARE syn_pre FROM l_sql 
    DECLARE syn_cur CURSOR FOR syn_pre                       
               
    FOR i=1  TO g_zta.getLength()   
    	  LET l_no_idx = 1   
        FOREACH col_src_cur USING g_zta[i].zta01 INTO l_name, l_unique
        	 LET l_no_idx = 0
           OPEN col_tgr_cur USING g_zta[i].zta01,l_name
           FETCH  col_tgr_cur INTO l_res
           
           IF l_res=0 THEN
              OPEN syn_cur USING g_zta[i].zta01
              FETCH  syn_cur INTO l_res
              
              IF l_res > 0 THEN 
              	  #It's synonym
              ELSE
                 DISPLAY "table->",l_sch2,".",g_zta[i].zta01, " not exists index ", l_name 
              END IF
           ELSE
           	 CALL diff_cols(g_zta[i].zta01,l_name)
           END IF 
        END FOREACH
        
        IF l_no_idx = 1 THEN
          DISPLAY "Warning:" ,g_zta[i].zta01, " has no index "
        END IF
       
        LET l_no_pk = 1
        FOREACH pk_src_cur USING g_zta[i].zta01 INTO l_name
       	   LET l_no_pk = 0
           OPEN pk_tgr_cur USING g_zta[i].zta01,l_name
           FETCH  pk_tgr_cur INTO l_res                       
           
           IF l_res=0 THEN
              OPEN syn_cur USING g_zta[i].zta01
              FETCH  syn_cur INTO l_res
              
              IF l_res > 0 THEN 
              	  #It's synonym
              ELSE
                 DISPLAY   "table->",l_sch2,".",g_zta[i].zta01, " not exists Primary key ", l_name 
              END IF
          	     ELSE		        	 
              LET l_idx_name = l_name		        	 
              IF l_idx_name.getIndexOf("pk",1) > 1 THEN
                  #It's primary key
              ELSE
                  DISPLAY "Primary key name is not correct :", g_zta[i].zta01 , "." ,l_idx_name
              END IF
              CALL diff_pk(g_zta[i].zta01,l_name)
           END IF 
       END FOREACH
         
       IF l_no_pk = 1 THEN
          DISPLAY "Warning:" ,g_zta[i].zta01, " has no primary key constraint "
       END IF
         
   END FOR
END FUNCTION 

FUNCTION diff_pk(p_table,p_cons)
   DEFINE p_table   VARCHAR(20)
   DEFINE p_cons    VARCHAR(20) 
   DEFINE l_pos     SMALLINT
   DEFINE l_str     STRING
   DEFINE l_str2    STRING

     LET l_sql = "SELECT LOWER(COLUMN_NAME),LOWER(POSITION) FROM ALL_CONS_COLUMNS",
                   " WHERE LOWER(OWNER)='",l_schema,"' ",
                   "   AND LOWER(TABLE_NAME) =? ",
                   "   AND LOWER(CONSTRAINT_NAME) =? ",
                   " ORDER BY POSITION "
     PREPARE dif_src_pre  FROM l_sql 
     DECLARE dif_src_cur CURSOR FOR dif_src_pre  
           
     LET l_sql = "SELECT LOWER(COLUMN_NAME),LOWER(POSITION) FROM ALL_CONS_COLUMNS",
                   " WHERE LOWER(OWNER)='",l_schema,"' ",
                   "   AND LOWER(TABLE_NAME) =? ",
                   "   AND LOWER(CONSTRAINT_NAME) =? ",
                   " ORDER BY POSITION "
     PREPARE dif_tgr_pre  FROM l_sql 
     DECLARE dif_tgr_cur CURSOR FOR dif_tgr_pre  
      
     FOREACH dif_src_cur USING p_table,p_cons INTO l_name, l_pos         
        IF l_pos = 1 THEN
           LET l_str = l_name
        ELSE
           LET l_str = l_str,"," ,l_name 
        END IF
     END FOREACH    

     IF l_pos >16 THEN
     	 DISPLAY "table : ",p_table, "." , p_cons, " more than 16 index columns"
     END IF
     
    FOREACH dif_tgr_cur USING p_table,p_cons INTO l_name, l_pos         
       IF l_pos = 1 THEN
          LET l_str2 = l_name
       ELSE
          LET l_str2 = l_str2,"," ,l_name 
       END IF
    END FOREACH	 
    
    IF l_pos >16 THEN
     	 DISPLAY "table : ",p_table, "." , p_cons, " more than 16 index columns"
    END IF
      
    IF l_str <> l_str2 THEN
       DISPLAY "table : ",p_table, "." , p_cons , " is different"
       DISPLAY l_str
       DISPLAY l_str2
    ELSE
    	#is same columns
    END IF	  
END FUNCTION                      

FUNCTION diff_cols(p_table,p_cons)
   DEFINE p_table   VARCHAR(20)
   DEFINE p_cons    VARCHAR(20) 
   DEFINE l_pos     SMALLINT
   DEFINE l_str     STRING
   DEFINE l_str2    STRING
                     
    LET l_sql="select LOWER(COLUMN_NAME),LOWER(COLUMN_POSITION) ",
              "  from all_indexes a,all_ind_columns b",
              " where lower(a.table_name)=? ",
              "   and lower(a.index_name)=? ",
              "   and a.index_name=b.index_name",
              "   and lower(a.owner)='",l_schema,"'",
              "   and lower(b.index_owner)='",l_schema,"'",
              "   and a.owner=b.index_owner",
              " order by column_position"    
    PREPARE src_col  FROM l_sql 
    DECLARE src_col_cur CURSOR FOR src_col
    
    LET l_sql="select LOWER(COLUMN_NAME),LOWER(COLUMN_POSITION) ",
              "  from all_indexes a,all_ind_columns b",
              " where lower(a.table_name)=? ",
              "   and lower(a.index_name)=? ",
              "   and a.index_name=b.index_name",
              "   and lower(a.owner)='",l_schema,"'",
              "   and lower(b.index_owner)='",l_schema,"'",
              "   and a.owner=b.index_owner",
              " order by column_position"    
    PREPARE tgr_col  FROM l_sql 
    DECLARE tgr_col_cur CURSOR FOR tgr_col	
	
     FOREACH src_col_cur USING p_table,p_cons INTO l_name, l_pos         
        IF l_pos = 1 THEN
           LET l_str = l_name
        ELSE
           LET l_str = l_str,"," ,l_name 
        END IF
     END FOREACH    

     IF l_pos >16 THEN
     	DISPLAY "table : ",p_table, "." , p_cons, " more than 16 index columns"
     END IF
     
    FOREACH tgr_col_cur USING p_table,p_cons INTO l_name, l_pos         
       IF l_pos = 1 THEN
          LET l_str2 = l_name
       ELSE
          LET l_str2 = l_str2,"," ,l_name 
       END IF
    END FOREACH
    
    IF l_pos >16 THEN
       DISPLAY "table : ",p_table, "." , p_cons, " more than 16 index columns"
    END IF
    
    IF l_str <> l_str2 THEN
       DISPLAY "table : ",p_table, "." , p_cons , " is different"
       DISPLAY l_str
       DISPLAY l_str2
    ELSE
    	#is same columns
    END IF

END FUNCTION         

FUNCTION  diff_error()       
  DISPLAY "Cmd: diff_index sourceDB targetDB [table_name]"
  DISPLAY "===========For diff index use============"
  DISPLAY "Ex1: diff_index ds1 ds2 "
  DISPLAY "Ex2: diff_index ds1 ds2 aza"
END FUNCTION           
