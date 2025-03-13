# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: almt720.4gl
# Descriptions...: 折扣返券促銷單作業 
# Date & Author..: NO.FUN-870010 08/08/19 By lilingyu 
# Modify.........: No.FUN-960134 09/07/20 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/27 By shiwuying
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_argv1         LIKE lqg_file.lqg01
    
MAIN
   IF FGL_GETENV("FGLGUI") <> "0" THEN
   OPTIONS
        INPUT NO WRAP    #No.FUN-9B0136
    #   FIELD ORDER FORM #No.FUN-9B0136
   END IF
 
   DEFER INTERRUPT
 
   LET g_argv1 = ARG_VAL(1)
        
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   
 
   CALL t720(g_argv1,'0')    
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   
END MAIN
#No.FUN-960134 
 
 
