# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: aimi111.4gl
# Descriptions...: 料件基本資料建立作業-採購資料(aimi111)
# Date & Author..: 92/01/07 By MAY
# Modify.........: No.FUN-690026 06/09/13 By Carrier 欄位型態用LIKE定義
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   離開MAIN時沒有cl_used(1)和cl_used(2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
  DEFINE
    g_argv1       LIKE imz_file.imz01,
    g_imz         RECORD LIKE imz_file.*,
    g_imz_t       RECORD LIKE imz_file.*,
    g_imz01_t     LIKE imz_file.imz01,
    g_sw          LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    g_wc,g_sql    string                  #No.FUN-580092 HCN
 
MAIN
   DEFER INTERRUPT
 
 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
     
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211
   LET g_argv1 = ARG_VAL(1)
   CALL aimi111(g_argv1)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN
#Patch....NO.TQC-610036 <> #
