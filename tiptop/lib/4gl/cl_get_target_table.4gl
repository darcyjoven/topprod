# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_get_target_table.4gl
# Descriptions...: 取得交易資料與一般資料實際上所對應的DB與Table
# Date & Author..: 2009/08/04 by Hiko
# Modify.........: FUN-A50080 by Hiko 新建程式(從cl_create_qry內的FUNCTION拉出來的程式)
# Modify.........: FUN-BA0071 by Hiko 回傳變數改為STRING

DATABASE ds
GLOBALS "../../config/top.global"

##########################################################################
# Private Func...: FALSE
# Descriptions...: FUN-980030:取得資料實際上所對應的DB與Table
# Input parameter: p_plant 營運中心
#                : p_table 資料表名稱
# Return code....: void
# Usage..........: CALL cl_get_target_table('DSV1-2', 'oea_file')
# Date & Author..: 2009/08/04 by Hiko
##########################################################################
FUNCTION cl_get_target_table(p_plant, p_table) #FUN-A50080

   DEFINE p_plant      LIKE azw_file.azw01
   DEFINE p_table      LIKE gat_file.gat01
   DEFINE l_db         LIKE azw_file.azw05
   DEFINE l_db_string  STRING #FUN-BA0071
   DEFINE l_db_cnt     LIKE type_file.num5
   DEFINE l_err        STRING
   DEFINE l_gat_sql    STRING
   DEFINE l_gat_cnt    LIKE type_file.num5
 
   IF cl_null(p_plant) THEN
      RETURN p_table
   END IF

   SELECT count(*) INTO l_db_cnt FROM azw_file WHERE azw01 = p_plant
   IF l_db_cnt>0 THEN #所有Plant都應該要存在於azw_file內.
      #判斷此Table是否有xxxplant欄位.
      IF cl_table_exist_plant(p_table) THEN
         #交易資料要抓取登入Plant所對應的Transaction DB
         SELECT azw05 INTO l_db FROM azw_file WHERE azw01 = p_plant
      ELSE
         #基本資料要抓取登入Plant所對應的DB
         SELECT azw06 INTO l_db FROM azw_file WHERE azw01 = p_plant
      END IF

      #LET l_db = s_dbstring(l_db CLIPPED),p_table CLIPPED #FUN-BA0071
      LET l_db_string = s_dbstring(l_db CLIPPED),p_table CLIPPED  #FUN-BA0071
   ELSE 
      LET l_err="Error: Does not correspond to the db name of ",p_plant 
      CALL cl_err(l_err,"!",1)
      DISPLAY l_err

      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   
   #RETURN l_db #FUN-BA0071
   RETURN l_db_string.trim() #FUN-BA0071
END FUNCTION
