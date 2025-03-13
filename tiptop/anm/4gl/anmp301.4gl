# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmp301.4gl  
# Descriptions...: 銀行對帳下載作業     
# Date & Author..: No.FUN-740007 07/04/02 chenl
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global" 
#No.FUN-740007
 
DEFINE g_nma01         LIKE nma_file.nma01
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
   LET g_b_date = ARG_VAL(2)
   LET g_e_date = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)   
 
   LET g_success = NULL
   
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN    #非背景作業 
      CALL p301_tm(g_nma01) RETURNING l_nma01
   ELSE                                         #若為背景作業 
      CALL p301_bg(g_nma01,g_b_date,g_e_date,g_bgjob) RETURNING g_success 
      IF g_success = 'Y' THEN
         CALL cl_cmmsg(1)   
      ELSE                 
         CALL cl_rbmsg(1) 
      END IF             
   END IF  
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
