# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: ggli6071.4gl
# Descriptions...: 股東權益科目分類/群組歸屬作業(總帳)
# Date & Author..: 11/06/28 By lixiang (FUN-B60144)
# Modify.........: NO.FUN-BB0037 11/11/22 By lilingyu 合併報表移植

DATABASE ds

GLOBALS "../../config/top.global"    #FUN-BB0037

MAIN
DEFINE p_row,p_col   LIKE type_file.num5  
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)
         RETURNING g_time

   CALL i017('2')
   CALL  cl_used(g_prog,g_time,2)     #計算使用時間 (退出使間)
         RETURNING g_time
END MAIN
#FUN-B60144--
