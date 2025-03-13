# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: aimi101.4gl
# Descriptions...: 料件基本資料維護作業 - 庫存資料
# Date & Author..: 91/11/01 By Wu
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B90102 11/10/21 By qiaozy 服飾行業子料件不可修改，母料件需要把資料更新到子料件中

DATABASE ds
 
GLOBALS "../../config/top.global"
 
  DEFINE
    g_argv1             LIKE ima_file.ima01,
    g_ima               RECORD LIKE ima_file.*,
    g_ima_t             RECORD LIKE ima_file.*,
    g_ima01_t           LIKE ima_file.ima01,
    g_sw                LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    g_ss                LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    g_wc,g_sql          string  #No.FUN-580092 HCN
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_argv1 = ARG_VAL(1)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
#FUN-B90102----add--begin---- 服飾行業
   IF s_industry('slk') THEN
      UPDATE zz_file SET zz13='N' WHERE zz01=g_prog
   END IF
#FUN-B90102----add--END--------- 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   CALL aimi101(g_argv1)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
