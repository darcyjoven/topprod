# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aimi153.4gl
# Descriptions...: 料件申請資料維護作業 - 採購資料
# Date & Author..: No.FUN-670033 06/08/31 By Mandy
# Modify.........: No.FUN-690026 06/09/13 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
  DEFINE
    g_argv1             LIKE imaa_file.imaa01,
    g_imaa              RECORD LIKE imaa_file.*,
    g_imaa_t            RECORD LIKE imaa_file.*,
    g_imaa01_t          LIKE imaa_file.imaa01,
    g_sw                LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    g_wc,g_sql          string                  #No.FUN-580092 HCN
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_argv1 = ARG_VAL(1)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   CALL aimi153(g_argv1,' ')
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
