# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: s_getdbs.4gl
# Descriptions...: 根據 PLANT CODE 得出其 DataBase name
# Date & Author..: 92/12/11 BY Roger
# Usage..........: CALL s_getdbs()
# Input Parameter: none
# Return code....: none
# Modify.........: No.FUN-680147 06/09/01 By Czl  類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-7A0065 07/11/06 By Carrier Msv需求:增加s_dbstring(),用于取得不同DB的db分隔符
# Modify.........: No.FUN-7B0012 07/11/07 By Carrier db分隔符,call s_dbstring()處理
# Modify.........: No.FUN-820017 08/02/15 By alex 修正 s_dbstring用法
# Modify.........: No.CHI-840042 08/04/22 By kim  考慮傳進來的資料庫是否已涵跨資料庫字串
# Modify.........: No.FUN-980014 09/08/03 By rainy GP5.2修改，(1)新增依plant抓取Transaction DB FUNCTION
#                                                             (2)新增依TRANS DB抓連到該TRANS DB的plant
#                                                             (3)新增check g_user有無使用某plant的權限
#                                                             (4)新增依傳入的Plant 抓 legal 值傳回
# Modify.........: No.TQC-9C0024 09/12/04 By liuxqa 当MSV传入ds.时，MSV版不可执行。
# Modify.........: No.FUN-A10121 10/01/22 By Hiko s_chk_plant的內容改為呼叫cl_user_has_plant_auth
# Modify.........: No.FUN-A50016 10/05/06 By rainy 新增一sub傳入 plant，回傳 azw05
# Modify.........: No.TQC-A50085 10/05/19 By chenmoyan MSV版本下,如果l_dbs是轉換過的db,則會再轉一次
# Modify.........: No.FUN-A50080 10/05/21 By Hiko 將cl_user_has_plant_auth的內容搬到s_chk_plant內,並移除cl_user_has_plant_aut的內容搬到s_chk_plant內,並移除cl_user_has_plant_auth.
# Modify.........: No.FUN-AA0052 10/10/14 By jay Sybase版本調整
 
DATABASE ds      #No.FUN-680147
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_getdbs()
#  IF g_plant_new = g_plant THEN 
#     LET g_dbs_new = NULL 
#     RETURN 
#  END IF
   SELECT azp03 INTO g_dbs_new FROM azp_file 
    WHERE azp01 = g_plant_new
   IF STATUS THEN LET g_dbs_new = NULL RETURN END IF
   #No.FUN-7B0012  --Begin
   #LET g_dbs_new[21,21] = ':'
   #LET g_dbs_new=g_dbs_new CLIPPED,s_dbstring()
   LET g_dbs_new=s_dbstring(g_dbs_new CLIPPED)    #FUN-820017
   #No.FUN-7B0012  --End
END FUNCTION
 
#FUN-980014 add --begin
 
# Descriptions...: 根據 g_plant_new 得出其 Transaction Database, 供 SQL 語法使用
 
FUNCTION s_gettrandbs()
  IF cl_null(g_plant_new) THEN 
     LET g_dbs_tra = NULL 
     RETURN 
  END IF

  #SELECT azw05 INTO g_dbs_tra FROM azw_file
  # WHERE azw01 = g_plant_new
  #IF STATUS THEN LET g_dbs_tra = NULL RETURN END IF

  CALL s_get_azw05( g_plant_new ) RETURNING g_dbs_tra
  LET g_dbs_tra = s_dbstring(g_dbs_tra CLIPPED)   # 回傳 db + 資料庫位元(.) 
END FUNCTION
 
#FUN-A50016 begin
# Descriptions...: 根據 PLANT CODE 得出其 Transaction Database
FUNCTION s_get_azw05(p_plant)
  DEFINE p_plant LIKE azp_file.azp01
  DEFINE l_azw05 LIKE azw_file.azw05

  IF cl_null(p_plant) THEN 
     LET p_plant = g_plant
  END IF

  SELECT azw05 INTO l_azw05 FROM azw_file
   WHERE azw01 = p_plant
  IF STATUS THEN LET l_azw05 = NULL END IF
  
  RETURN l_azw05
END FUNCTION
#FUN-A50016 end
 
# Descriptions...: 根據 TRANS DB 得出其 TRANS DB 內，g_user有權限的plant list
# Input Parameter: p_trandb     azw05 Transaction DB名稱
# Return code....: l_plt_list   STRING g_user對此Transaction DB中，有執行權限的plant list
 
FUNCTION s_getplantlist(p_trandb)
 DEFINE p_trandb          LIKE azw_file.azw05
 DEFINE l_sql             STRING
 DEFINE l_plt_list        STRING
 DEFINE l_plt             LIKE azp_file.azp01
 
   LET l_plt_list = NULL
   IF cl_null(p_trandb) THEN RETURN l_plt_list END IF
 
   LET l_sql = "SELECT azw01 FROM azw_file ",
               " WHERE azw05 = '", p_trandb  CLIPPED,"'",
               "   AND azw01 IN ( SELECT zxy03 FROM zxy_file ",
               "                              WHERE zxy01 ='",g_user CLIPPED,"')"
   PREPARE plt_pre FROM l_sql
   DECLARE plt_cur CURSOR FOR plt_pre
   FOREACH plt_cur INTO l_plt
     IF cl_null(l_plt_list) THEN
        LET l_plt_list = l_plt CLIPPED
     ELSE
        LET l_plt_list = l_plt_list CLIPPED,",",l_plt CLIPPED
     END IF
   END FOREACH
   RETURN l_plt_list
END FUNCTION
 
# Descriptions...: 根據 plant 得出其 zxy_file中，g_user有無該plant的權限
# Input Parameter: p_plant     azp01   PLANT名稱
# Return code....: TRUE/FALSE  BOOLEAM TRUE:有權限  FALSE:無權限  
 
FUNCTION s_chk_plant(p_plant)
   DEFINE p_plant   LIKE azp_file.azp01,
          l_cnt     LIKE type_file.num5
   DEFINE l_zxy_sql STRING,
          l_zxy_cnt SMALLINT,
          l_result  BOOLEAN
 
   #Begin:FUN-A10121
   #SELECT COUNT(*) INTO l_cnt
   #  FROM zxy_file
   # WHERE zxy01 = g_user
   #   AND zxy03 = p_plant
   #
   #IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   #IF l_cnt = 0 THEN
   #End:FUN-A10121

   #Begin:FUN-A50080
   #IF NOT cl_user_has_plant_auth(g_user, p_plant) THEN
   #   CALL cl_err(p_plant,'sub-188',1)
   #   RETURN FALSE
   #ELSE
   #   RETURN TRUE
   #END IF

   LET l_result = FALSE
 
   LET l_zxy_sql = "SELECT COUNT(*) FROM zxy_file",
                   " WHERE zxy01='",g_user CLIPPED,"' AND zxy03='",p_plant CLIPPED,"'"
   DECLARE zxy_curs SCROLL CURSOR FROM l_zxy_sql
   OPEN zxy_curs
   FETCH FIRST zxy_curs INTO l_zxy_cnt
   CLOSE zxy_curs
   
   IF l_zxy_cnt > 0 THEN #判斷是否具有權限.
      LET l_result = TRUE
   ELSE
      LET l_result = FALSE
      CALL cl_err(p_plant,'sub-188',1)
   END IF
      
   RETURN l_result
   #End:FUN-A50080
END FUNCTION
 
 
# Descriptions...: 根據營運中心(plant) 得出其所屬法人(legal) 
# Input Parameter: p_plant     azp01   PLANT名稱
# Return code....: l_legal     azw02   所屬法人
 
FUNCTION s_getlegal(p_plant)
  DEFINE p_plant    LIKE  azw_file.azw01,   #營運中心
         l_legal    LIKE  azw_file.azw02    #所屬法人
 
  IF cl_null(p_plant) THEN 
     LET l_legal = NULL 
  ELSE
     SELECT azw02 INTO l_legal FROM azw_file
      WHERE azw01 = p_plant
     IF SQLCA.sqlcode THEN
       CALL cl_err(p_plant,'art-011',1)
       LET l_legal = NULL
     END IF
  END IF
  
  RETURN l_legal 
END FUNCTION
 
#FUN-980014--end
 
# Descriptions...: 根據 PLANT CODE 得出其 DataBase name
# Input Parameter: l_dbs   STRING 資料庫名稱
# Return code....: l_dbs   STRING 連線用 name reolution
 
FUNCTION s_dbstring(l_dbs)
 
   DEFINE l_dbstring      STRING
   DEFINE l_dbs           STRING   #FUN-820017
 
   IF l_dbs.trim() IS NULL THEN RETURN " " END IF
 
   LET l_dbs = l_dbs.trim()
   CASE cl_db_get_database_type()
      WHEN "IFX"
         #CHI-840042.........begin #若最後一碼為.或:,則直接回傳
         IF l_dbs.getIndexOf(':',l_dbs.getLength())>0 THEN
            RETURN l_dbs
         END IF
         #CHI-840042.........end
         LET l_dbstring = l_dbs.trim(),":"
      WHEN "ORA"
         #CHI-840042.........begin #若最後一碼為.或:,則直接回傳
         IF l_dbs.getIndexOf('.',l_dbs.getLength())>0 THEN
            RETURN l_dbs
         END IF
         #CHI-840042.........end
         LET l_dbstring = l_dbs.trim(),"."
      WHEN "MSV"
#TQC-A50085 --Begin
         IF l_dbs.getIndexOf('.dbo.',l_dbs.getLength()-5)>0 THEN
            RETURN l_dbs
         END IF
#TQC-A50085 --End
         #CHI-840042.........begin #若最後一碼為.或:,則直接回傳
         IF l_dbs.getIndexOf('.',l_dbs.getLength())>0 THEN
            LET l_dbs = FGL_GETENV("MSSQLAREA") CLIPPED,"_",l_dbs.trim(),"dbo."   #TQC-9C0024 add 
            RETURN l_dbs
         END IF
         #CHI-840042.........end
         LET l_dbstring = FGL_GETENV("MSSQLAREA") CLIPPED,"_",l_dbs.trim(),".dbo."
      #---FUN-AA0052---start-----
      WHEN "ASE"
         IF l_dbs.getIndexOf('.dbo.',l_dbs.getLength()-3)>0 THEN
            RETURN l_dbs
         END IF
         IF l_dbs.getIndexOf('.dbo',l_dbs.getLength()-3)>0 THEN
            LET l_dbs = l_dbs.trim(),"." 
            RETURN l_dbs
         END IF
         #若最後一碼為.或:,則直接回傳
         IF l_dbs.getIndexOf('.',l_dbs.getLength())>0 THEN
            LET l_dbs = l_dbs.trim(),"dbo." 
            RETURN l_dbs
         END IF
         LET l_dbstring = l_dbs.trim(),".dbo."
      #---FUN-AA0052---end-------   
      OTHERWISE
         #CHI-840042.........begin #若最後一碼為.或:,則直接回傳
         IF l_dbs.getIndexOf('.',l_dbs.getLength())>0 THEN
            RETURN l_dbs
         END IF
         #CHI-840042.........end
         LET l_dbstring = l_dbs.trim(),"."
   END CASE
 
   RETURN l_dbstring.trim()
 
END FUNCTION
 
#No.FUN-7A0065  --End  
