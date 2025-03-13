# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: anmp305.4gl  
# Descriptions...: 銀行對帳下載作業     
# Date & Author..: No.FUN-B30213 11/06/30 By lixia 
 
DATABASE ds
 
GLOBALS "../../config/top.global" 
 
DEFINE g_nma01         LIKE nma_file.nma01
DEFINE g_nma04         LIKE nma_file.nma04
DEFINE g_noa05         LIKE noa_file.noa05
DEFINE g_noa02         LIKE noa_file.noa02
DEFINE g_nmu23         LIKE nmu_file.nmu23
DEFINE g_b_date        LIKE type_file.dat
DEFINE g_e_date        LIKE type_file.dat
DEFINE l_nma01         LIKE nma_file.nma01
DEFINE g_success       LIKE type_file.chr1
 
#主程序開始
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM 
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN 
      EXIT PROGRAM
   END IF
 
   IF g_aza.aza73='N' THEN 
      CALL cl_err('','anm-044',1)
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_nma01 = ARG_VAL(1)
   LET g_nma04 = ARG_VAL(2) 
   LET g_noa05 = ARG_VAL(3)
   LET g_noa02 = ARG_VAL(4)
   LET g_nmu23 = ARG_VAL(5)
   LET g_b_date = ARG_VAL(6)
   LET g_e_date = ARG_VAL(7)
   LET g_bgjob = ARG_VAL(8)   
 
   LET g_success = NULL
   
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN    #非背景作業 
      CALL p305_tm(g_nma01,g_nma04,g_noa05,g_noa02,g_nmu23) RETURNING l_nma01
   ELSE                                         #若為背景作業 
      CALL p305_bg(g_nma01,g_nma04,g_noa05,g_noa02,g_b_date,g_e_date,g_bgjob) RETURNING g_success 
      IF g_success = 'Y' THEN
         CALL cl_cmmsg(1)   
      ELSE                 
         CALL cl_rbmsg(1) 
      END IF             
   END IF  
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
#FUN-B30213--end--
