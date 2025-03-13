# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_chk_schema_has_built.4gl
# Descriptions...: 判斷Schema是否已經建立.
# Date & Author..: 2009/12/14 by Hiko
# Modify.........: No.FUN-9B0012 09/12/14 By Hiko 新建程式
# Modify.........: No.FUN-A10073 10/01/14 By Hiko dba_users改成all_users
# Modify.........: No.FUN-A70028 10/05/28 By Hiko 增加SQL Server的判斷.
# Modify.........: No.FUN-AA0017 10/10/13 By jay 增加 Sybase ASE 的判斷
 
DATABASE ds
 
##########################################################################
# Private Func...: FALSE
# Descriptions...: 判斷Schema是否已經建立.
# Input parameter: p_schema Schema 
# Return code....: TRUE/FALSE
# Usage..........: CALL cl_chk_schema_has_built(l_azw05)
# Date & Author..: 2009/09/14 by Hiko
##########################################################################

FUNCTION cl_chk_schema_has_built(p_schema)
   DEFINE p_schema LIKE azw_file.azw05
   DEFINE l_cnt SMALLINT
   DEFINE l_db_type STRING  #FUN-A70028
   DEFINE ls_sql    STRING  #FUN-AA0017

   LET l_db_type = cl_db_get_database_type() #FUN-A70028

   LET p_schema = p_schema CLIPPED

   CASE l_db_type #FUN-A70028
      WHEN "ORA"
         SELECT count(*) INTO l_cnt FROM all_users WHERE username=UPPER(p_schema) #FUN-A10073
      WHEN "MSV"
         LET p_schema = FGL_GETENV("MSSQLAREA"),"_",p_schema
         SELECT count(*) INTO l_cnt FROM sys.databases WHERE name=LOWER(p_schema) 
      WHEN "ASE"              #FUN-AA0017
#        SELECT count(*) INTO l_cnt FROM sys.databases WHERE name=LOWER(p_schema) 
         LET ls_sql = " SELECT COUNT(*) ",  #DB是否存在
                      " FROM master.dbo.sysdatabases ",
                      " WHERE name = ? "

         PREPARE hasDB_pre FROM ls_sql
         DECLARE hasDB_cur CURSOR FOR hasDB_pre

         OPEN hasDB_cur USING p_schema
         FETCH hasDB_cur INTO l_cnt
         CLOSE hasDB_cur
   END CASE

   RETURN (l_cnt>0)
END FUNCTION
