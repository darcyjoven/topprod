# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aimq102.4gl
# Descriptions...: 料件數量明細查詢-靜態資料
#			g_argv1	# 1.依料號 2.依工單 3.依訂單 4.依BOM
#			g_argv2	# 1.料號   2.工單   3.訂單   4.產品
# Date & Author..: 91/11/25 By Wu  
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
  DEFINE 
        g_ima       RECORD LIKE ima_file.*,
        g_argv1     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        g_argv2     LIKE ima_file.ima01,    #INPUT ARGUMENT - 1
        g_ima01     LIKE ima_file.ima01,    #所要查詢的key
        g_sql       string                  #No.FUN-580092 HCN
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0074
   CALL aimq102(g_argv1,g_argv2)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0074
END MAIN
 
