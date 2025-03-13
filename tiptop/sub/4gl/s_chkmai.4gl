# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_chkmai.4gl
# Descriptions...: 檢查報表結構的使用者及部門權限
# Date & Author..: 07/01/16 by rainy   #FUN-6C0068
# Usage..........: s_chkmai(p_mai01,'GGR')
# Input Parameter: ps_mai01       報表結構編號
#                  ps_sys         系統別
# Return Code....: li_result      結果(TRUE/FALSE)
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_chkmai(ps_mai01,ps_sys)   #FUN-6C0068
   DEFINE   ps_mai01        LIKE mai_file.mai01
   DEFINE   ps_sys          LIKE type_file.chr3
   DEFINE   lc_sys          LIKE type_file.chr3
   DEFINE   ls_sql          STRING
   DEFINE   li_result       LIKE type_file.num5     
   DEFINE   li_cnt          LIKE type_file.num5
   DEFINE   lc_gen03        LIKE gen_file.gen03     # 部門代號
   
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET li_result = TRUE
   LET g_errno = NULL
 
   IF cl_null(ps_mai01) THEN
      RETURN FALSE
   END IF
 
 
   SELECT zx03 INTO lc_gen03 FROM zx_file where zx01=g_user   #抓此人所屬部門
   IF SQLCA.SQLCODE THEN
      LET lc_gen03 = NULL
   END IF
   LET lc_sys = UPSHIFT(ps_sys) CLIPPED
   
   SELECT COUNT(*) INTO li_cnt FROM smu_file WHERE smu01 = ps_mai01 AND upper(smu03) = lc_sys  
   IF li_cnt > 0 THEN               #USER權限存有資料,並g_user判斷是否存在
      SELECT COUNT(*) INTO li_cnt FROM smu_file WHERE smu01 = ps_mai01 AND smu02 = g_user AND upper(smu03) = lc_sys   
      IF li_cnt = 0 THEN
         IF lc_gen03 IS NULL THEN   #g_user沒有部門
            LET g_errno = "aoo-110" 
         ELSE
            SELECT COUNT(*) INTO li_cnt FROM smv_file WHERE smv01 = ps_mai01 AND smv02 = lc_gen03 AND upper(smv03) = lc_sys  
            IF li_cnt = 0 THEN      #CHECK g_user部門是否存在
               LET g_errno = "aoo-110" 
            END IF
         END IF
       END IF
   ELSE
     SELECT COUNT(*) INTO li_cnt FROM smv_file WHERE smv01 = ps_mai01 AND upper(smv03) = lc_sys  
     IF li_cnt > 0 THEN
        IF lc_gen03 IS NULL THEN   #g_user沒有部門
           LET g_errno = "aoo-110" 
        ELSE
           SELECT COUNT(*) INTO li_cnt FROM smv_file WHERE smv01 = ps_mai01 AND smv02 = lc_gen03 AND upper(smv03) = lc_sys  
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
