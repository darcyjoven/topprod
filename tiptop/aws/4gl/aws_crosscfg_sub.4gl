# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aws_crosscfg_sub
# Descriptions...: CROSS 整合設定作業
# Date & Author..:No:FUN-C20087 12/03/06 By Abby 將目前與CROSS整合的ERPII站台設定檔：BI、CRM、EF NET、EF GP、Portal、HRM，
#                                                銜接進aws_crosscfg，SOAP網址以外的資料寫入/讀取來源仍為原站台設定檔。
#

DATABASE ds

#FUN-C20087

GLOBALS "../../config/top.global"

DEFINE g_gcf    RECORD LIKE gcf_file.*  #BI站台參數
DEFINE g_gch    RECORD LIKE gch_file.*  #BI站台參數
DEFINE g_wge    RECORD LIKE wge_file.*  #CRM站台參數
DEFINE g_wsj    RECORD LIKE wsj_file.*  #EF站台參數
DEFINE g_war1   RECORD LIKE war_file.*  #CROSS產品站台設定參數
DEFINE l_length LIKE type_file.num5


FUNCTION crosscfg_upd_plt(p_crossbg)
   DEFINE p_crossbg  LIKE type_file.chr1     #是否為CROSS平台下放產品資訊時的背景呼叫 
   DEFINE l_cnt    LIKE type_file.num5   

   IF p_crossbg = 'Y' THEN
      LET g_plant = 'DS'
   END IF 

   BEGIN WORK

   INITIALIZE g_war1.* TO NULL
   SELECT COUNT(*) INTO l_cnt FROM war_file
    WHERE war03 = 'CRM'
   IF l_cnt > 0 THEN
      #抓取CRM是否有例外站台,若沒有則抓取標準站台
      SELECT * INTO g_war1.* FROM war_file
       WHERE war02 = g_plant
         AND war03 = 'CRM'
      IF cl_null(g_war1.war01) THEN
         #抓取標準站台
         SELECT * INTO g_war1.* FROM war_file
          WHERE war02 = '*'
            AND war03 = 'CRM'
         IF NOT cl_null(g_war1.war01) THEN
            CALL crosscfg_upd_crm()
         ELSE
            CALL crosscfg_del_crm()
         END IF
      ELSE
         #抓取例外站台
         CALL crosscfg_upd_crm()
      END IF
   END IF   

   INITIALIZE g_war1.* TO NULL
   SELECT COUNT(*) INTO l_cnt FROM war_file
    WHERE war03 = 'EFGP'
   IF l_cnt > 0 THEN
      #抓取EFGP是否有例外站台,若沒有則抓取標準站台
      SELECT * INTO g_war1.* FROM war_file
       WHERE war02 = g_plant
         AND war03 = 'EFGP'
      IF cl_null(g_war1.war01) THEN
         CALL crosscfg_del_ef()  
         #抓取標準站台
         SELECT * INTO g_war1.* FROM war_file
          WHERE war02 = '*'
            AND war03 = 'EFGP'
         IF NOT cl_null(g_war1.war01) THEN
            CALL crosscfg_upd_ef()
         ELSE
            CALL crosscfg_del_ef()
         END IF
      ELSE
         #抓取例外站台
         CALL crosscfg_upd_ef()
      END IF
   END IF  

   INITIALIZE g_war1.* TO NULL
   SELECT COUNT(*) INTO l_cnt FROM war_file
    WHERE war03 = 'EFNET'
   IF l_cnt > 0 THEN
      #抓取EFNET是否有例外站台,若沒有則抓取標準站台
      SELECT * INTO g_war1.* FROM war_file
       WHERE war02 = g_plant
         AND war03 = 'EFNET'
      IF cl_null(g_war1.war01) THEN
         CALL crosscfg_del_ef()  
         #抓取標準站台
         SELECT * INTO g_war1.* FROM war_file
          WHERE war02 = '*'
            AND war03 = 'EFNET'
         IF NOT cl_null(g_war1.war01) THEN
            CALL crosscfg_upd_ef()
         ELSE
            CALL crosscfg_del_ef()
         END IF
      ELSE
         #抓取例外站台
         CALL crosscfg_upd_ef()
      END IF
   END IF
   COMMIT WORK

END FUNCTION

FUNCTION crosscfg_upd_crm()
   DEFINE l_forupd_sql STRING

   #FOR CRM產品站台參數更新
   LET l_forupd_sql = "SELECT * FROM wge_file ",
                      " WHERE wge01 = 'C' ",
                      "   AND wge05 = '*' ",
                      "   AND wge06 = '",g_plant,"'",
                      "   AND wge07 = '*' FOR UPDATE"
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE crosscfg_wge_cl CURSOR FROM l_forupd_sql  # LOCK CURSOR

   OPEN crosscfg_wge_cl
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE crosscfg_wge_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH crosscfg_wge_cl INTO g_wge.*
   IF SQLCA.sqlcode THEN
      #若CRM設定檔無資料
      IF SQLCA.sqlcode = 100 THEN
         LET g_wge.wge01 = 'C'
         LET g_wge.wge02 = g_war1.war05
         CALL crosscfg_getlen(g_war1.war07) RETURNING l_length 
         LET g_wge.wge03 = g_war1.war07[1,l_length-5]
         LET g_wge.wge04 = g_plant
         LET g_wge.wge05 = '*'
         LET g_wge.wge06 = g_plant
         LET g_wge.wge07 = '*'
         LET g_wge.wge08 = "http://",g_wge.wge02,"/WebCRM71"
         INSERT INTO wge_file VALUES (g_wge.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err("ins wge_file err:",SQLCA.sqlcode,1)
            CLOSE crosscfg_wge_cl
            ROLLBACK WORK
            RETURN
         END IF
      ELSE
         CALL cl_err("wge02 LOCK:",SQLCA.sqlcode,1)
         CLOSE crosscfg_wge_cl
         ROLLBACK WORK
         RETURN
      END IF
   ELSE
      UPDATE wge_file SET wge02 = g_war1.war05 ,wge03 = g_wge.wge03 ,wge08 = g_wge.wge08
       WHERE wge01 = g_wge.wge01
         AND wge05 = g_wge.wge05
         AND wge06 = g_wge.wge06
         AND wge07 = g_wge.wge07
      IF SQLCA.sqlcode THEN
         CALL cl_err("upd wge_file err:",SQLCA.sqlcode,1)
         CLOSE crosscfg_wge_cl
         ROLLBACK WORK
         RETURN
      END IF
   END IF
   CLOSE crosscfg_wge_cl
END FUNCTION

FUNCTION crosscfg_upd_ef()
   DEFINE l_forupd_sql STRING

   #FOR EasyFlow產品站台參數更新
   LET l_forupd_sql = "SELECT * FROM wsj_file ",
                      " WHERE wsj01 = ? ",
                      "   AND wsj05 = '*' ",
                      "   AND wsj06 = ? ",
                      "   AND wsj07 = '*' FOR UPDATE"
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE crosscfg_wsj_cl CURSOR FROM l_forupd_sql  # LOCK CURSOR

   OPEN crosscfg_wsj_cl USING g_war1.war01,g_war1.war02
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE crosscfg_wsj_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH crosscfg_wsj_cl INTO g_wsj.*
   IF SQLCA.sqlcode THEN
      #若EF設定檔無資料
      IF SQLCA.sqlcode = 100 THEN
         LET g_wsj.wsj01 = g_war1.war01
         LET g_wsj.wsj02 = g_war1.war05
         CALL crosscfg_getlen(g_war1.war07) RETURNING l_length 
         LET g_wsj.wsj03 = g_war1.war07[1,l_length-5]
         LET g_wsj.wsj04 = g_war1.war03
         LET g_wsj.wsj05 = '*'
         LET g_wsj.wsj06 = g_war1.war02
         LET g_wsj.wsj07 = '*'
         INSERT INTO wsj_file VALUES (g_wsj.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err("ins wsj_file err:",SQLCA.sqlcode,1)
            CLOSE crosscfg_wsj_cl
            ROLLBACK WORK
            RETURN
         END IF
      ELSE
         CALL cl_err("wsj02 LOCK:",SQLCA.sqlcode,1)
         CLOSE crosscfg_wsj_cl
         ROLLBACK WORK
         RETURN
      END IF
   ELSE
      CALL crosscfg_getlen(g_war1.war07) RETURNING l_length 
      LET g_wsj.wsj03 = g_war1.war07[1,l_length-5]
      UPDATE wsj_file SET wsj02 = g_war1.war05 ,wsj03 = g_wsj.wsj03 ,wsj04 = g_war1.war03
       WHERE wsj01 = g_wsj.wsj01
         AND wsj05 = g_wsj.wsj05
         AND wsj06 = g_wsj.wsj06
         AND wsj07 = g_wsj.wsj07
      IF SQLCA.sqlcode THEN
         CALL cl_err("upd wsj_file err:",SQLCA.sqlcode,1)
         CLOSE crosscfg_wsj_cl
         ROLLBACK WORK
         RETURN
      END IF
   END IF
   CLOSE crosscfg_wsj_cl
END FUNCTION

FUNCTION crosscfg_del_crm()
   DEFINE l_forupd_sql STRING

   #FOR CRM產品站台參數更新
   LET l_forupd_sql = "SELECT * FROM wge_file ",
                      " WHERE wge01 = 'C' ",
                      "   AND wge05 = '*' ",
                      "   AND wge06 = '",g_plant,"'",
                      "   AND wge07 = '*' FOR UPDATE"
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE crosscfg_wge_del_cl CURSOR FROM l_forupd_sql  # LOCK CURSOR

   OPEN crosscfg_wge_del_cl
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE crosscfg_wge_del_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH crosscfg_wge_del_cl INTO g_wge.*
   IF SQLCA.sqlcode AND SQLCA.sqlcode <> 100 THEN
      CALL cl_err("wge02 LOCK:",SQLCA.sqlcode,1)
      CLOSE crosscfg_wge_del_cl
      ROLLBACK WORK
      RETURN
   END IF
   DELETE FROM wge_file
    WHERE wge01 = g_wge.wge01
      AND wge05 = g_wge.wge05
      AND wge06 = g_wge.wge06
      AND wge07 = g_wge.wge07
   IF SQLCA.sqlcode THEN
      CALL cl_err("del wge_file err:",SQLCA.sqlcode,1)
      CLOSE crosscfg_wge_del_cl
      ROLLBACK WORK
      RETURN
   END IF
   CLOSE crosscfg_wge_del_cl
END FUNCTION

FUNCTION crosscfg_del_ef()
   DEFINE l_forupd_sql STRING

   #FOR EasyFlow產品站台參數更新
   LET l_forupd_sql = "SELECT * FROM wsj_file ",
                      " WHERE wsj01 = 'E' ",
                      "   AND wsj05 = '*' ",
                      "   AND wsj06 = '",g_plant,"'",
                      "   AND wsj07 = '*' FOR UPDATE"
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE crosscfg_wsj_del_cl CURSOR FROM l_forupd_sql  # LOCK CURSOR

   OPEN crosscfg_wsj_del_cl
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE crosscfg_wsj_del_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH crosscfg_wsj_del_cl INTO g_wsj.*
   IF SQLCA.sqlcode AND SQLCA.sqlcode <> 100 THEN
      CALL cl_err("wsj02 LOCK:",SQLCA.sqlcode,1)
      CLOSE crosscfg_wsj_del_cl
      ROLLBACK WORK
      RETURN
   END IF
   DELETE FROM wsj_file
    WHERE wsj01 = g_wsj.wsj01
      AND wsj05 = g_wsj.wsj05
      AND wsj06 = g_wsj.wsj06
      AND wsj07 = g_wsj.wsj07
   IF SQLCA.sqlcode THEN
      CALL cl_err("del wsj_file err:",SQLCA.sqlcode,1)
      CLOSE crosscfg_wsj_del_cl
      ROLLBACK WORK
      RETURN
   END IF
   CLOSE crosscfg_wsj_del_cl
END FUNCTION

FUNCTION crosscfg_getlen(p_strlen)
   DEFINE p_strlen   STRING

   LET l_length = p_strlen.getlength()
   RETURN l_length  
END FUNCTION
