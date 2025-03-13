# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_wcshow
# Descriptions...: 顯示組合出的RDSQL指令於螢幕20,21,22,23行
# Input parameter: p_wc (Where Condition clause)
# Usage .........: call cl_wcshow(p_wc)
# Date & Author..: 89/09/30 By LYS
# Modify.........: No.FUN-690005 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"
 
FUNCTION cl_wcshow(p_wc)
   DEFINE p_wc		LIKE type_file.chr1000,      #No.FUN-690005 VARCHAR(1000)
          l_buf		LIKE type_file.chr1000       #No.FUN-690005 VARCHAR(80)
   DEFINE g_i           LIKE type_file.num5,         #No.FUN-690005 SMALLINT
          g_ans         LIKE cre_file.cre08,         #No.FUN-690005 VARCHAR(10),
          l_msg         LIKE type_file.chr1000       #No.FUN-690005 VARCHAR(55)
 
   LET l_buf=p_wc[1,70]    DISPLAY l_buf AT 1,1
   LET l_buf=p_wc[71,140]  DISPLAY l_buf AT 2,1
   LET l_buf=p_wc[141,210] DISPLAY l_buf AT 3,1
   LET l_buf=p_wc[211,280] DISPLAY l_buf AT 4,1
   LET l_buf=p_wc[281,350] DISPLAY l_buf AT 5,1
   PROMPT '>' FOR CHAR l_buf
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
##        CONTINUE PROMPT
   
   END PROMPT
  IF INT_FLAG THEN LET INT_FLAG=0 END IF
END FUNCTION
