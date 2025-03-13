# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: aglq170.4gl
# Descriptions...: 歷史傳票單維護作業
# Date & Author..: 92/03/26 BY MAY
# Modify.........: No.FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A60158 10/06/23 By Dido 取消 g_bookno 給予 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
  DEFINE 
   #g_bookno           LIKE aba_file.aba01,      #NO.3421 010824 by plum
    g_bookno           LIKE aba_file.aba00,      #ARG_1 帳別     
    #傳票單的種類:'1' 一般傳票 '2' 轉回傳票 '3' 應計傳票 7' 歷史傳票查詢
#       l_time    LIKE type_file.chr8                #No.FUN-6A0073
    g_argv2           LIKE type_file.chr1           #No.FUN-680098  VARCHAR(1)                   
MAIN
 
    OPTIONS
 
        INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
  #LET g_bookno = ARG_VAL(1)          #參數-1(帳別)         #MOD-A60158 mark
   LET g_argv2 = "7"                  #參數-2 '7' 歷史傳票查詢
   CALL t110(g_bookno,g_argv2)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
