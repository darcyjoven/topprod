# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: agli0171.4gl
# Descriptions...: 股東權益科目分類/群組歸屬作業(總帳)
# Date & Author..: 11/06/28 By lixiang (FUN-B60144)
# Modify.........: No.FUN-BB0065 12/03/06 by belle  agli0171 單獨拆4gl/4fd,agli017分開

DATABASE ds

GLOBALS "../../config/top.global"

MAIN
DEFINE p_row,p_col   LIKE type_file.num5  
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)
         RETURNING g_time

  #CALL i017('2')	  ##FUN-BB0065 mark
   CALL i0171('2')    ##FUN-BB0065 mod 
   CALL  cl_used(g_prog,g_time,2)     #計算使用時間 (退出使間)
         RETURNING g_time
END MAIN
#FUN-B60144--
