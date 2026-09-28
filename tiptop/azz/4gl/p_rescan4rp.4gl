# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: p_rescan4rp.4gl
# Descriptions...: 自動更新各語言別4rp的p_replang資料
# Date & Author..: FUN-C30004 12/03/01 By jacklai  
# Usage .........: 
# Input Parameter: ps_4rppath 4rp樣板檔路徑
#                  p_gdm01    報表樣板ID
#                  p_gdm03    語言別      
# Return code....: none
# Modify.........: No:FUN-C30004 12/03/01 By jacklai 自動更新各語言別4rp的p_replang資料

#FUN-C30004 --start--
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_argv1    STRING   #4rp路徑
DEFINE g_argv2    STRING   #報表樣板ID
DEFINE g_argv3    STRING   #語言別

MAIN
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                # 擷取中斷鍵,由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
    
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
   LET g_argv3 = ARG_VAL(3)

   IF cl_null(g_argv1) OR cl_null(g_argv2) OR cl_null(g_argv3) THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM -1
   END IF

   CALL p_replang_rescan4rp(g_argv1,g_argv2,g_argv3)

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
#FUN-C30004 --end--
