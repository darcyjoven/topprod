# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aapt330.4gl
# Descriptions...: 付款單
# Date & Author..: 92/12/16 BY Roger
# Modify.........: No.FUN-630010 06/03/08 By saki 流程訊息通知功能
# Modify.........: No.FUN-640240 06/05/16 By Echo 自動執行確認功能
 
# Modify.........: No.FUN-690028 06/09/12 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
MAIN
#     DEFINE  l_time LIKE type_file.chr8            #No.FUN-6A0055
# DEFINE g_plant       VARCHAR(12)              #No.FUN-630010
  DEFINE g_argv1       LIKE apf_file.apf01
  DEFINE g_argv2       STRING                #No.FUN-630010執行功能
  DEFINE lc_plant      LIKE apb_file.apb03   # No.FUN-690028 VARCHAR(12)            #No.FUN-630010
 
   #FUN-640240
   IF FGL_GETENV("FGLGUI") <> "0" THEN
      OPTIONS
          INPUT NO WRAP
   END IF
   #END FUN-640240
 
   DEFER INTERRUPT
 
   #No.FUN-630010 --start-- 移位 調換參數順序
#  LET g_plant=ARG_VAL(1)                 #工廠編號
#  LET g_argv1=ARG_VAL(2)
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
 
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
         RETURNING g_time    #No.FUN-6A0055
   CALL t310('33',lc_plant,g_argv1,g_argv2) #No.FUN-630010
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
         RETURNING g_time    #No.FUN-6A0055
END MAIN
