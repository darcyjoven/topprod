DATABASE ds

  DEFINE ga_source DYNAMIC ARRAY OF RECORD
            table    VARCHAR(20),
            idx_name VARCHAR(15),
            type     VARCHAR(20),
            cols     VARCHAR(200)
                 END RECORD
  DEFINE g_dbs   VARCHAR(10)
  DEFINE g_cnt   INTEGER
  
  DEFINE ga_index DYNAMIC ARRAY OF RECORD           
            idx_name VARCHAR(15),            
            col_name VARCHAR(200),
            col_pos  smaillint
                 END RECORD
MAIN
           
   LET g_dbs = ARG_VAL(1) CLIPPED
   
   CALL read_msv_index()
   #CALL read_ora_index()
   #CALL import_idx("bnm_file")
        
END MAIN

FUNCTION read_msv_index()
    DEFINE ls_sql    STRING 
    DEFINE ls_name   VARCHAR(20)
    DEFINE idx_name     VARCHAR(20)
    DEFINE idx_type     VARCHAR(200)
    DEFINE idx_key      VARCHAR(200)
    DEFINE li_i      INTEGER
    DEFINE li_cnt   INTEGER
    
    CONNECT TO g_dbs
    LET ls_sql = "SELECT zta01 FROM zta_file b,sysobjects a  ", 
     " WHERE b.zta01=a.name AND zta02='",g_dbs,"' AND zta07='T' ",
     " ORDER BY zta01 "
 
    PREPARE zta_pre FROM ls_sql
    DECLARE zta_cur CURSOR FOR zta_pre
     
    DECLARE idx_cur CURSOR FROM "SELECT COUNT(*) FROM sys.index_columns WHERE object_id = object_id(?)"
    
    LET li_i = 1
    
    FOREACH zta_cur INTO ls_name    
         OPEN idx_cur USING  ls_name
         FETCH  idx_cur INTO  li_cnt
         IF li_cnt = 0 THEN
            LET ga_source[li_i].table = ls_name
            LET li_i = li_i + 1
         ELSE
        
         END IF
     
   END FOREACH
   
   CALL  ga_source.deleteElement(li_i)
   LET g_cnt = li_i
   DISCONNECT g_dbs
   
END FUNCTION

FUNCTION read_ora_index()
  DEFINE j   INTEGER
  
  FOR j = 1 TO g_cnt
    CALL import_idx(ga_source[j].table) 
  END FOR
   
END FUNCTION

FUNCTION get_ora_indexes()
    DEFINE p_table  VARCHAR(20) 
    DEFINE l_temp   VARCHAR(20)
    DEFINE l_dbs    STRING 
    DEFINE l_sql    STRING,
           l_str    STRING,
           l_keys   STRING,
           l_unqiue STRING           
    DEFINE li_i   INTEGER
    DEFINE j      INTEGER
    
   LET l_dbs = "top30_",g_dbs
   CONNECT TO l_dbs
   
   LET l_sql= "select a.index_name,b.column_name,b.column_position "
           " from all_indexes a,all_ind_columns b"
           " where a.index_name=b.index_name " 
           " and a.owner= b.index_owner "
           " and a.owner='DS' "
           
    PREPARE ora_col_pre FROM l_sql
    DECLARE ora_col_cur CURSOR FOR ora_col_pre
    
    LET li_i = 1
    FOREACH ora_idx_cur USING p_table,g_dbs INTO ga_source[li_i].*
       
       LET li_i = li_i + 1
    END FOREACH
     
END 
                
FUNCTION import_idx(p_table)
    DEFINE p_table  VARCHAR(20) 
    DEFINE l_temp   VARCHAR(20)
    DEFINE l_dbs    STRING 
    DEFINE l_sql    STRING,
           l_str    STRING,
           l_keys   STRING,
           l_unqiue STRING           
    DEFINE li_i   INTEGER
    DEFINE j      INTEGER
    
    LET l_dbs = "top30_",g_dbs
    CONNECT TO l_dbs
    
    LET l_sql="SELECT DISTINCT lower(index_name),lower(uniqueness)",
              "  FROM all_indexes ",
              " WHERE LOWER(table_name)=?  AND LOWER(owner)=? "
    
    PREPARE ora_idx_pre FROM l_sql
    DECLARE ora_idx_cur CURSOR FOR ora_idx_pre  
    
    LET l_sql="select lower(column_name)",
              "  from all_indexes a,all_ind_columns b",
              " where lower(a.table_name)=? ",
              "   and lower(a.index_name)=? ",
              "   and a.index_name=b.index_name",
              "   and lower(a.owner)='",g_dbs CLIPPED,"'",
              "   and lower(b.index_owner)='",g_dbs CLIPPED,"'",
              "   and a.owner=b.index_owner",
              " order by column_position"
              
    PREPARE ora_idxcol_pre FROM l_sql
    DECLARE ora_idxcol_cur CURSOR FOR ora_idxcol_pre  
     
    LET  li_i = 1
    FOREACH ora_idx_cur USING p_table,g_dbs INTO ga_source[li_i].idx_name,ga_source[li_i].type

       LET j=1
       FOREACH ora_idxcol_cur USING p_table,ga_source[li_i].idx_name INTO l_temp
            IF j = 1 THEN
               LET l_keys = l_temp
            ELSE
               LET l_keys = l_keys, ",",l_temp  
            END IF
            LET j = j + 1
       END FOREACH
       
       IF ga_source[li_i].type = "unique" THEN
          LET l_str = SFMT("ALTER TABLE %1 ADD CONSTRAINT %2 PRIMARY KEY CLUSTERED (%3)", 
                            p_table,ga_source[li_i].idx_name, l_keys)
       ELSE
          LET l_str = SFMT("CREATE INDEX %1 ON %2 (%3)",
                          ga_source[li_i].idx_name, p_table, l_keys)          
       END IF
       
       DISPLAY  l_str         
       LET li_i = li_i + 1
    END FOREACH
    DISCONNECT l_dbs
           
END FUNCTION