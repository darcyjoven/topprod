# Prog. Version..: '5.30.05-13.03.26(00001)'     #
#
# Pattern name...: aimq103.4gl
# Descriptions...: 料件數量明細查詢-靜態資料
#			g_argv1	# 1.依料號 2.依工單 3.依訂單 4.依BOM
#			g_argv2	# 1.料號   2.工單   3.訂單   4.產品
# Date & Author..: 13/02/05 By xianghui
# Modify.........: No.FUN-D20019 13/02/05 By xianghui
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
  DEFINE 
        g_ima       RECORD LIKE ima_file.*,
        g_argv1     LIKE type_file.chr1,    
        g_argv2     LIKE ima_file.ima01,    #INPUT ARGUMENT - 1
        g_ima01     LIKE ima_file.ima01,    #所要查詢的key
        g_sql       string                  
 
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  
   CALL aimq103(g_argv1,g_argv2)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN
##FUN-D20019 
