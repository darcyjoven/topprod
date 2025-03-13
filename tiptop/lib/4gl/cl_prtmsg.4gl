# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_prompt
# Descriptions...: 詢問 l_msg
# Input parameter: p_row,p_col,l_msg
# RETURN code....: 1 FOR TRUE  : 是
#                  0 FOR FALSE : 否
# Usage .........: if cl_sure(p_row,p_col,l_msg)
# Date & Author..: 89/10/17 By LYS
#        Modify..: 04/03/10 By saki
# Revise record..:
# Modify........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"
 
FUNCTION cl_prtmsg(p_row,p_col,p_code,p_lang)
   DEFINE   p_row,p_col   LIKE type_file.num5,          #No.FUN-690005 SMALLINT
            p_lang        LIKE type_file.chr1,             #No.FUN-690005  VARCHAR(01)
            p_code        LIKE ze_file.ze01,               #No.FUN-690005  VARCHAR(10)
            ls_msg        LIKE ze_file.ze03,           #No.FUN-690005  VARCHAR(55)
            l_prtmsg      LIKE type_file.chr1000           #No.FUN-690005  VARCHAR(50)
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW cl_prtmsg_w WITH FORM "lib/42f/cl_prtmsg"
        ATTRIBUTE(STYLE="lib")
 
   IF cl_null(p_lang) THEN
      LET p_lang = g_lang
   END IF
 
   SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = p_code AND ze02 = p_lang
 
   DISPLAY ls_msg TO FORMONLY.msg
 
   INPUT l_prtmsg WITHOUT DEFAULTS FROM FORMONLY.input_name
 
      ON ACTION cancel
         LET l_prtmsg = ""
         EXIT INPUT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   END INPUT
 
   IF (INT_FLAG) THEN
      LET INT_FLAG = FALSE
      LET l_prtmsg = ""
   END IF
 
   CLOSE WINDOW cl_prtmsg_w
 
   RETURN l_prtmsg
 
END FUNCTION
