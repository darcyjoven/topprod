# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: p_create_schema_msv.4gl
# Descriptions...: 建立Schema
# Date & Author..: 09/11/02 Kevin
# Modify.........: FUN-A70029 10/07/12 By Kevin SQL Server版本調整

import os 

DATABASE ds
#FUN-A70029
DEFINE g_dbname     VARCHAR(20)    #新建資料庫名稱
DEFINE l_table_name STRING
DEFINE l_real_sch   STRING
DEFINE l_plant_field STRING
DEFINE g_dbs        VARCHAR(20)    #TIPTOP資料庫名稱

MAIN
   DEFINE l_cmd STRING
   DEFINE l_msg STRING
   
    LET g_dbs   = ARG_VAL(1) CLIPPED
    LET l_table_name  = ARG_VAL(2) CLIPPED
    LET l_real_sch    = ARG_VAL(3) CLIPPED
    LET l_plant_field = ARG_VAL(4) CLIPPED

    LET l_real_sch = FGL_GETENV("MSSQLAREA") CLIPPED,"_",l_real_sch , ".dbo."
    LET l_cmd = "CREATE VIEW ",l_table_name, " as ",
                        "SELECT * FROM ",(l_real_sch CLIPPED),l_table_name,
                        " WHERE ",l_plant_field," = (SELECT sid02 FROM sid_file",
                                                    " WHERE sid01=(SELECT @@SPID))"
 
    TRY 
        CONNECT TO g_dbs 
        DISPLAY l_cmd
        EXECUTE IMMEDIATE l_cmd       
    CATCH
        LET l_msg = "ERROR:SQLCODE=",SQLCA.SQLCODE,",SQLERRD[2]=",SQLCA.SQLERRD[2]
        DISPLAY l_msg
    END TRY
    DISCONNECT CURRENT
    
END MAIN
