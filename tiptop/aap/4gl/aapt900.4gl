# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: aapt900.4gl
# Descriptions...: 成本分攤作業
# Date & Author..: 99/11/08 BY Flora
# Modify.........: No.FUN-630010 06/03/07 By saki 流程訊息通知功能
 
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/26 By douzh l_time轉g_time
# Modify.........: No.TQC-750121 07/05/23 By rainy 加傳參數 g_wc(g_argv3)
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
MAIN
#     DEFINE  l_time LIKE type_file.chr8            #No.FUN-6A0055
  #DEFINE g_plant       LIKE cqa_file.cqa04      # No.FUN-690028 VARCHAR(12)   #TQC-B90211
  DEFINE g_argv1       LIKE aqa_file.aqa01
  DEFINE g_argv2       STRING                  #No.FUN-630010
  DEFINE g_argv3       STRING                  #No.TQC-750121
    OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_argv1=ARG_VAL(1)     #No.FUN-630010
   LET g_argv2=ARG_VAL(2)     #No.FUN-630010
   LET g_argv3=ARG_VAL(3)     #No.TQC-750121
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
 
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
         RETURNING g_time    #No.FUN-6A0055
   CALL t900(g_argv1,g_argv2,g_argv3)            #No.FUN-630010   #TQC-750121 add g_argv3
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
         RETURNING g_time    #No.FUN-6A0055
END MAIN
