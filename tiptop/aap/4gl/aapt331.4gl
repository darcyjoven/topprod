# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aapt331.4gl
# Descriptions...: 付款單
# Date & Author..: 06/09/27 By Jackho
 
# Modify.........: No.FUN-6A0055 06/10/25 By ice l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
MAIN
#     DEFINE  l_time LIKE type_file.chr8            #No.FUN-6A0055
  DEFINE g_argv1       LIKE apf_file.apf01
  DEFINE g_argv2       STRING                #執行功能
  DEFINE lc_plant      LIKE apb_file.apb03 
 
   IF FGL_GETENV("FGLGUI") <> "0" THEN
      OPTIONS
          INPUT NO WRAP
   END IF
   #END FUN-640240
 
   DEFER INTERRUPT
 
   #No.FUN-630010 --start-- 移位 調換參數順序
   LET g_argv1=ARG_VAL(1)
   LET g_argv2=ARG_VAL(2)
   LET lc_plant=ARG_VAL(3)
   #No.FUN-630010 ---end---
 
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
 
   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)  #No.FUN-6A0055
         RETURNING g_time    #No.FUN-6A0055
   CALL t310('34',lc_plant,g_argv1,g_argv2)
   CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)  #No.FUN-6A0055
         RETURNING g_time    #No.FUN-6A0055
END MAIN
