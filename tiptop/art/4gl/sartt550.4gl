# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: sartt550.4gl
# Descriptions...: 檢查對帳機構在指定日期範圍和供應商的情況下，是佛已經對過帳
# Date & Author..: NO.FUN-870006 08/11/27 By  Sunyanchun
# Input Parameter：p_type    對帳類型    
#                  p_no      對帳單號
#                  p_org     機構別
#                  p_vender  供應商
#                  p_start   對帳開始日期
#                  p_end     對帳結束日期
# Return Code....: 是否對過帳的標識：1.沒有被其他機構對過 2.已經被其它機構對過
#                  對過帳的機構                   
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-960130 09/12/09 By Cockroach PASS NO.
# Modify.........: No:FUN-9C0133 09/12/24 By Cockroach 跨DB查詢方式修改
# Modify.........: No.FUN-A50102 10/06/12 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_tqb     DYNAMIC ARRAY OF RECORD
          choice    LIKE type_file.chr1,
          azw01     LIKE azw_file.azw01
                  END RECORD
DEFINE  g_org     STRING
DEFINE  g_sql     STRING
DEFINE  g_n       LIKE type_file.num5
DEFINE  g_flag    LIKE type_file.num5
 
FUNCTION s_check(p_type,p_no,p_org,p_vender,p_start,p_end)
DEFINE p_type     LIKE  rvc_file.rvc00
DEFINE p_no       LIKE  rvc_file.rvc01
DEFINE p_org      LIKE  rvc_file.rvcplant
DEFINE p_vender   LIKE  rvc_file.rvc03
DEFINE p_start    LIKE  rvc_file.rvc04
DEFINE p_end      LIKE  rvc_file.rvc05
DEFINE l_org      LIKE  rvd_file.rvd03
DEFINE l_dbs      LIKE  azp_file.azp03
DEFINE l_azw01    LIKE  azw_file.azw01
DEFINE l_n        LIKE  type_file.num5
DEFINE l_str      STRING
    
    #查詢當前機構是否為總部
    #SELECT DISTINCT tqa05 INTO l_all FROM tqb_file,tqa_file 
    #    WHERE tqa01 = tqb03 AND tqa03 = '14' AND azw01 = p_org
    #      AND tqbacti = 'Y'
    
    LET g_sql = "SELECT rvd03 FROM rvd_file ",
                " WHERE rvd00 = '",p_type,"'",
                "   AND rvd01 = '",p_no,"'"
    PREPARE pre_rvd FROM g_sql
    DECLARE rvd_cur CURSOR FOR pre_rvd
    
    LET g_flag = TRUE
    FOREACH rvd_cur INTO l_org
       IF l_org IS NULL THEN CONTINUE FOREACH END IF
       LET g_org = "("
       IF l_org = p_org THEN            #當前機構為對帳機構
          #IF l_all = 'Y' THEN           #當前機構是總部
          #   CONTINUE FOREACH
          #END IF
          CALL s_find_on_org(l_org)     
       ELSE                             #當前機構是對帳機構的上級
          LET g_org = g_org,"'",l_org,"',"
          CALL s_find_on_org(l_org)
          CALL s_del_cur_org(p_org)     #去除當前機構,因為當前機構在為其下級機構對帳，判斷當前機構是否對帳，無意義 
       END IF
       LET g_org = g_org.subString(1,g_org.getLength()-1),")"
       
       LET g_sql = "SELECT azw01 FROM azw_file WHERE azw01 IN ",g_org
       PREPARE pre_sel_tqb FROM g_sql
       DECLARE cur_sel_tqb CURSOR FOR pre_sel_tqb
       
       FOREACH cur_sel_tqb INTO l_azw01
          IF l_azw01 IS NULL THEN CONTINUE FOREACH END IF
         #FUN-9C0133 MARK&ADD START--------------------------------  
         #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_azw01
         #LET l_dbs = l_dbs||"."
          LET g_plant_new = l_azw01
          CALL s_gettrandbs()
          LET l_dbs=g_dbs_tra
          LET l_dbs=s_dbstring(l_dbs CLIPPED)
         #FUN-9C0133 END-------------------------------------------   
          LET l_n = 0
          #LET g_sql = "SELECT COUNT(*) FROM ",l_dbs,"rvc_file ", #FUN-A50102
          LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_azw01, 'rvc_file'), #FUN-A50102
                      " WHERE rvc00 = '",p_type,"'",
                      "   AND rvc03 = '",p_vender,"'",
                      "   AND ((rvc04 BETWEEN '",p_start,"' AND '",p_end,"')",
                      "    OR ( rvc05 BETWEEN '",p_start,"' AND '",p_end,"'))",
                      "   AND rvcconf = 'Y' AND rvcplant = '",l_azw01,"'"
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
          CALL cl_parse_qry_sql(g_sql, l_azw01) RETURNING g_sql  #FUN-A50102
          PREPARE pre_rvc FROM g_sql
          EXECUTE pre_rvc INTO l_n
          IF l_n IS NULL THEN LET l_n = 0 END IF
          IF l_n > 0 THEN
             IF l_azw01 != p_org THEN
                CALL s_errmsg('rvcplant',l_azw01,l_azw01,'art-554',1)
                #RETURN 0,l_azw01
                LET g_flag = FALSE
             END IF
          END IF   
       END FOREACH   
    END FOREACH
    
    IF SQLCA.SQLCODE THEN
       CALL s_errmsg('rvd03',p_org,p_org,SQLCA.SQLCODE,1)
       LET g_flag = FALSE
       #RETURN 0,l_org
    END IF
    
    RETURN g_flag
END FUNCTION
#把機構集合中的當前機構去掉
FUNCTION s_del_cur_org(p_org)
DEFINE p_org      LIKE  rvc_file.rvcplant
DEFINE l_str      STRING
DEFINE l_azw01    LIKE azw_file.azw01
 
    LET g_org = g_org.subString(1,g_org.getLength()-1),")"
    LET g_sql = "SELECT azw01 FROM azw_file WHERE azw01 IN ",g_org,
                "   AND azw01 <> '",p_org,"'"
    PREPARE pre_del_cur FROM g_sql
    DECLARE tqb10_cur CURSOR FOR pre_del_cur
 
    LET l_str = "("
    FOREACH tqb10_cur INTO l_azw01
       IF l_azw01 IS NULL THEN CONTINUE FOREACH END IF
       LET l_str = l_str,"'",l_azw01,"',"
    END FOREACH
 
    LET g_org = l_str
END FUNCTION
#找出p_org機構的所有上級機構
FUNCTION s_find_on_org(p_org)
DEFINE p_org      LIKE  rvc_file.rvcplant
DEFINE l_org      LIKE  rvd_file.rvd03
   SELECT azw06 INTO l_org FROM azw_file WHERE azw01 = p_org
   IF l_org IS NOT NULL THEN
      LET g_org = g_org,"'",l_org,"',"
      CALL s_find_on_org(l_org)
   END IF
      
END FUNCTION
 
#找出p_org機構的所有下級機構
FUNCTION s_find_down_org(p_org)
DEFINE p_org      LIKE  rvc_file.rvcplant
DEFINE l_org      LIKE  rvd_file.rvd03
DEFINE l_org1     LIKE  rvd_file.rvd03
DEFINE l_i        LIKE  type_file.num5
 
   LET g_sql = "SELECT azw01 FROM azw_file WHERE azw06 = ? "
 
   PREPARE pre_azw10 FROM g_sql
   DECLARE cur_azw10 CURSOR FOR pre_azw10
   
   FOREACH cur_azw10 USING p_org INTO l_org
      IF l_org IS NULL THEN CONTINUE FOREACH END IF
      LET g_tqb[g_n].azw01 = l_org
      LET g_tqb[g_n].choice = 'N'
      LET g_n = g_n + 1      
   END FOREACH
 
   CALL g_tqb.deleteElement(g_n)
   LET g_org = NULL
   FOR l_i = 1 TO g_tqb.getLength()
       IF g_tqb[l_i].choice = 'Y' THEN CONTINUE FOR END IF
       SELECT zxy01 FROM zxy_file WHERE zxy01 = g_user
                                    AND zxy03 = g_tqb[l_i].azw01
       IF SQLCA.SQLCODE THEN 
          LET g_tqb[l_i].choice = 'Y'
          CONTINUE FOR
       END IF
       LET g_org = g_org,"'",g_tqb[l_i].azw01,"',"
       LET g_tqb[l_i].choice = 'Y'
       CALL s_find_down_org(g_tqb[l_i].azw01) RETURNING l_org1
   END FOR
   LET g_org = "(",g_org,")"
   RETURN g_org    
END FUNCTION
#FUN-960130 
