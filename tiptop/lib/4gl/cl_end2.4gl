# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_end2
# Descriptions...: 顯示 執行結果, 並詢問是否要繼續
# Memo...........: 
# Input parameter: p_code      1 代表成功  2 代表失敗
# Return code....: TRUE/FALSE
# Usage..........: CALL cl_end2(p_code)
# Date & Author..: 04/03/10 By saki                                                                           
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"
 
FUNCTION cl_end2(p_code)
   DEFINE   p_code  LIKE type_file.num5         #No.FUN-690005  SMALLINT
   DEFINE   li_result    LIKE type_file.num5    #No.FUN-690005  SMALLINT
   DEFINE   l_chr   LIKE type_file.chr1         #No.FUN-690005  VARCHAR(1)
   DEFINE   g_i     LIKE type_file.num5,        #No.FUN-690005  SMALLINT
            g_ans   LIKE type_file.chr20,       #No.FUN-690005  VARCHAR(10),
            ls_msg  LIKE ze_file.ze03,          #No.FUN-690005  VARCHAR(55),
            lc_title LIKE ze_file.ze03      #No.FUN-690005  VARCHAR(50)
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   CASE p_code
      WHEN 1
         SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = 'lib-024' AND ze02 = g_lang
      WHEN 2
         SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = 'lib-025' AND ze02 = g_lang
   END CASE
   SELECT ze03 INTO lc_title FROM ze_file WHERE ze01 = 'lib-041' AND ze02 = g_lang
 
   MENU lc_title ATTRIBUTE (STYLE="dialog", COMMENT=ls_msg CLIPPED, IMAGE="question")
      ON ACTION yes
         LET li_result = TRUE
         EXIT MENU
      ON ACTION no
         EXIT MENU
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU
   END MENU
 
   IF (INT_FLAG) THEN
      LET INT_FLAG = FALSE
      LET li_result = FALSE
   END IF
 
   RETURN li_result
 
END FUNCTION
