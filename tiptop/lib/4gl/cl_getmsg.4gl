# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_getmsg
# Descriptions...: 依訊息代碼取出系統錯誤訊息檔(ze_file)內的錯誤訊息.
# Input parameter: p_code	訊息代碼
#                  p_lang	語言別
# Return code....: l_msg	錯誤訊息.
# Usage .........: let g_msg = cl_getmsg(p_code,p_lang)
# Date & Author..: 89/09/04 By LYS
#
# Modify.........: No.FUN-690005 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-870095 08/07/30 By clover  可傳替換變數進入
 
DATABASE ds #FUN-690005
 
FUNCTION cl_getmsg(p_code,p_lang)
DEFINE
    p_code	LIKE type_file.chr8,        #No.FUN-690005 VARCHAR(07),
    p_lang	LIKE type_file.chr1,        #No.FUN-690005 VARCHAR(01),
    l_msg       LIKE ze_file.ze03           #No.FUN-690005 VARCHAR(255)
 
    WHENEVER ERROR CALL cl_err_msg_log
    LET l_msg=''
    SELECT ze03 INTO l_msg FROM ze_file
      WHERE ze01=p_code AND ze02=p_lang
    RETURN l_msg
END FUNCTION
########################################################################
#Descriptions...: 依訊息代碼取出系統錯誤訊息檔(ze_file)內的錯誤訊息.
#Input parameter: p_code訊息代碼
#                 p_lang語言別
#                 p_str 替換變數 
# Return code....: l_msg錯誤訊息.
# Usage .........: let g_msg = cl_getmsg(p_code,p_lang,p_str)
# Date & Author..: 2008/07/30 by clover  No.FUN-870095
########################################################################
FUNCTION cl_getmsg_parm(p_code,p_lang,p_str)
DEFINE
    p_code      LIKE type_file.chr8,        #No.FUN-690005 VARCHAR(07),
    p_lang      LIKE type_file.chr1,        #No.FUN-690005 VARCHAR(01),
    l_msg       LIKE ze_file.ze03,          #No.FUN-690005 VARCHAR(255)
    p_str       STRING                      #No.FUN-870095
 
 
   WHENEVER ERROR CALL cl_err_msg_log
    LET l_msg=''
    SELECT ze03 INTO l_msg FROM ze_file
      WHERE ze01=p_code AND ze02=p_lang
    LET l_msg = cl_replace_err_msg(l_msg,p_str)
    RETURN l_msg
END FUNCTION
 
