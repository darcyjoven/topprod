# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aapt330.4gl
# Descriptions...: 退款單
# Date & Author..: 2010/04/28 BY wujie
# Modify.........: No.FUN-A40003 10/04/28 By wujie 新增退款单

DATABASE ds
 
GLOBALS "../../config/top.global"
 
MAIN
#No.FUN-A40003
  DEFINE g_argv1       LIKE apf_file.apf01
  DEFINE g_argv2       STRING                #No.FUN-630010執行功能
  DEFINE lc_plant      LIKE apb_file.apb03   # No.FUN-690028 VARCHAR(12)            #No.FUN-630010
 
   IF FGL_GETENV("FGLGUI") <> "0" THEN
      OPTIONS
          INPUT NO WRAP
   END IF
 
   DEFER INTERRUPT
 
   LET g_argv1=ARG_VAL(1)
   LET g_argv2=ARG_VAL(2)
   LET lc_plant=ARG_VAL(3)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   IF cl_null(lc_plant) THEN
      LET lc_plant = g_plant
   END IF
 
   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
         RETURNING g_time 
   CALL t310('32',lc_plant,g_argv1,g_argv2)
   CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)
         RETURNING g_time  
END MAIN
