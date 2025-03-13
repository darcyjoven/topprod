# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: aimi105.4gl
# Descriptions...: 料件基本資料維護作業-成本要素值資料
# Date & Author..: 91/11/04 By Wu
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B90105 11/10/18 by linlin 子料件不可修改，母料件更新資料
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_imb               RECORD LIKE imb_file.*,
    g_imb_t             RECORD LIKE imb_file.*,
    g_imb01_t           LIKE imb_file.imb01,
    g_argv1             LIKE imb_file.imb01,
    g_cost_code         LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    g_wc,g_sql          string  #No.FUN-580092 HCN
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_argv1 = ARG_VAL(1)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
#FUN-B90105---add---begin---
   IF s_industry('slk') THEN
      UPDATE zz_file SET zz13='N' WHERE zz01=g_prog
   END IF
#FUN-B90105---add---end---
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   CALL aimi105(g_argv1)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
