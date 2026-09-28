# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Program name...: s_chkmai.4gl
# Descriptions...: 依資料庫檢查報表結構的使用者及部門權限
# Date & Author..: 07/01/16 by rainy                #FUN-930076
# Usage..........: s_chkmai(p_mai01,'GGR')
# Input Parameter: ps_mai01       報表結構編號
#                  ps_sys         系統別
# Return Code....: li_result      結果(TRUE/FALSE)
# Modify.........: No.TQC-9C0099 09/12/14 By jan GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-A50102 10/06/24 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現

DATABASE ds

GLOBALS "../../config/top.global"    #FUN-930076

#FUNCTION s_chkdbs_mai(ps_mai01,ps_sys,p_dbs)   #FUN-6C0068  #TQC-9C0099
FUNCTION s_chkdbs_mai(ps_mai01,ps_sys,p_plant)   #FUN-6C0068 #TQC-9C0099
   DEFINE   ps_mai01        LIKE mai_file.mai01
   DEFINE   ps_sys          LIKE type_file.chr3
   DEFINE   lc_sys          LIKE type_file.chr3
   DEFINE   ls_sql          STRING
   DEFINE   li_result       LIKE type_file.num5     
   DEFINE   li_cnt          LIKE type_file.num5
   DEFINE   lc_gen03        LIKE gen_file.gen03     # 部門代號
   DEFINE   p_dbs           LIKE type_file.chr21 
   DEFINE   g_sql           STRING
   DEFINE   p_plant         LIKE type_file.chr10    #營運中心   #TQC-9C0099
   
   WHENEVER ERROR CALL cl_err_msg_log

   LET li_result = TRUE
   LET g_errno = NULL

   IF cl_null(ps_mai01) THEN
      RETURN FALSE
   END IF
   
#TQC-9C0099--begin--add----
   LET g_plant_new =  p_plant
   #CALL s_getdbs()             #FUN-A50102
   #LET p_dbs= g_dbs_new        #FUN-A50102
#TQC-9C0099--end--add---

   SELECT zx03 INTO lc_gen03 FROM zx_file where zx01=g_user   #抓此人所屬部門
   IF SQLCA.SQLCODE THEN
      LET lc_gen03 = NULL
   END IF
   LET lc_sys = UPSHIFT(ps_sys) CLIPPED
   
   #LET g_sql = "SELECT COUNT(*) FROM ",p_dbs,"smu_file",
   LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'smu_file'), #FUN-A50102
               " WHERE smu01 = '",ps_mai01,"'", 
               "   AND upper(smu03) = '",lc_sys,"'" 
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102            
   PREPARE mai_pre FROM g_sql
   DECLARE mai_cur CURSOR FOR mai_pre
   OPEN mai_cur
   FETCH mai_cur INTO li_cnt   

   IF li_cnt > 0 THEN               #USER權限存有資料,並g_user判斷是否存在
      #LET g_sql = "SELECT COUNT(*) FROM ",p_dbs,"smu_file",
      LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'smu_file'), #FUN-A50102
                  " WHERE smu01 = '",ps_mai01,"'", 
                  "   AND smu02 = '",g_user,"'", 
                  "   AND upper(smu03) = '",lc_sys,"'" 
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102 
      PREPARE mai_pre_1 FROM g_sql
      DECLARE mai_cur_1 CURSOR FOR mai_pre_1
      OPEN mai_cur_1
      FETCH mai_cur_1 INTO li_cnt   
      IF li_cnt = 0 THEN
         IF lc_gen03 IS NULL THEN   #g_user沒有部門
            LET g_errno = "aoo-110" 
         ELSE
            #LET g_sql = "SELECT COUNT(*) FROM ",p_dbs,"smv_file",
            LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'smv_file'), #FUN-A50102
                        " WHERE smv01 = '",ps_mai01,"'", 
                        "   AND smv02 = '",lc_gen03,"'", 
                        "   AND upper(smv03) = '",lc_sys,"'" 
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
            CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102            
            PREPARE mai_pre_2 FROM g_sql
            DECLARE mai_cur_2 CURSOR FOR mai_pre_2
            OPEN mai_cur_2
            FETCH mai_cur_2 INTO li_cnt   

            IF li_cnt = 0 THEN      #CHECK g_user部門是否存在
               LET g_errno = "aoo-110" 
            END IF
         END IF
       END IF
   ELSE
     #LET g_sql = "SELECT COUNT(*) FROM ",p_dbs,"smv_file",
     LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'smv_file'), #FUN-A50102
                 " WHERE smv01 = '",ps_mai01,"'", 
                 "   AND upper(smv03) = '",lc_sys,"'" 
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
     PREPARE mai_pre_3 FROM g_sql
     DECLARE mai_cur_3 CURSOR FOR mai_pre_3
     OPEN mai_cur_3
     FETCH mai_cur_3 INTO li_cnt   

     IF li_cnt > 0 THEN
        IF lc_gen03 IS NULL THEN   #g_user沒有部門
           LET g_errno = "aoo-110" 
        ELSE
           #LET g_sql = "SELECT COUNT(*) FROM ",p_dbs,"smv_file",
           LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'smv_file'), #FUN-A50102
                       " WHERE smv01 = '",ps_mai01,"'", 
                       "   AND smv02 = '",lc_gen03,",",          
                       "   AND upper(smv03) = '",lc_sys,"'" 
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
           CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102            
           PREPARE mai_pre_4 FROM g_sql
           DECLARE mai_cur_4 CURSOR FOR mai_pre_4
           OPEN mai_cur_4
           FETCH mai_cur_4 INTO li_cnt   

           IF li_cnt = 0 THEN      #CHECK g_user部門是否存在
              LET g_errno = "aoo-110" 
           END IF
        END IF
     END IF
   END IF

   IF NOT cl_null(g_errno) THEN
     LET li_result = FALSE
   END IF

   RETURN li_result
END FUNCTION
