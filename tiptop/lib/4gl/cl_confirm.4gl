# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_confirm.4gl
# Descriptions...: 確認畫面.
#                  依照訊息代碼將資料顯現在畫面上
# Memo...........: 
# Input parameter: ps_msg      訊息/訊息代號
# Return code....: TRUE/FALSE
# Usage..........: IF (cl_confirm("agl-021")) THEN ...
# Date & Author..: 2004/02/05 by Hiko
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-7C0045 07/12/14 By alex 更改說明
# Modify.........: No.FUN-870095 08/07/30 By clover 替換變數
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0045
 
##########################################################################
# Descriptions...: 出現讓使用者選擇是否確認的畫面.
# Memo...........: 
# Input parameter: ps_msg       STRING     訊息/訊息代號
# Return code....: TRUE/FALSE
# Usage..........: IF cl_confirm("agl-021")
# Date & Author..: 2004/02/05 by Hiko
# Modify.........: 
##########################################################################
FUNCTION cl_confirm(ps_msg)
   DEFINE   ps_msg          STRING
   DEFINE   ls_msg          LIKE type_file.chr1000       #No.FUN-690005 VARCHAR(1000)
   DEFINE   lc_msg          LIKE ze_file.ze03
   DEFINE   li_result       LIKE type_file.num5          #No.FUN-690005 SMALLINT
   DEFINE   lc_title        LIKE ze_file.ze03            #No.FUN-690005 VARCHAR(50)
 
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (cl_null(g_lang)) THEN
      LET g_lang = "1"
   END IF
   IF (cl_null(ps_msg)) THEN
      LET ps_msg = ""
   END IF
 
   SELECT ze03 INTO lc_title FROM ze_file WHERE ze01 = 'lib-042' AND ze02 = g_lang
   IF SQLCA.SQLCODE THEN
      LET lc_title = "Confirm"
   END IF
 
   LET ls_msg = ps_msg.trim()
   SELECT ze03 INTO lc_msg FROM ze_file WHERE ze01 = ls_msg AND ze02 = g_lang
   IF NOT SQLCA.SQLCODE THEN
      LET ps_msg =lc_msg CLIPPED
   END IF
  
   LET li_result = FALSE
   # LET lc_title=lc_title CLIPPED,'(',ls_msg,')' #MOD-4A0143 show ze01
 # start FUN-870095  
   IF (cl_null(lc_msg))  THEN    # FUN-870095  參數不為ze訊息代碼時，lc_title後面()內的資訊不用顯示
      LET lc_title=lc_title CLIPPED
   ELSE
 
      LET lc_title=lc_title CLIPPED,'(',ls_msg,')' #MOD-4A0143 show ze01
   END IF
  # end FUN-870095
 
   MENU lc_title ATTRIBUTE (STYLE="dialog", COMMENT=ps_msg.trim(), IMAGE="question")
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
 
####################################################################################
# Descriptions...: 出現讓使用者選擇是否確認的畫面.
# Memo...........:
# Input parameter: ps_msg   STRING     訊息/訊息代號
#                   p_str    STRING     替換變數
# Return code....: TRUE/FALSE
# Usage..........: IF cl_confirm("agl-021")
# Date & Author..: 2008/07/30 by clover
# Modify.........:
###################################################################################
FUNCTION cl_confirm_parm(ps_msg,p_str)
   DEFINE   ps_msg      STRING
   DEFINE   ls_msg      LIKE type_file.chr1000   #No.FUN-690005 VARCHAR(1000)
   DEFINE   lc_msg      LIKE ze_file.ze03
   DEFINE   li_result   LIKE type_file.num5      #No.FUN-690005 SMALLINT
   DEFINE   lc_title    LIKE ze_file.ze03        #No.FUN-690005 VARCHAR(50)
   DEFINE   p_str       STRING
 
     WHENEVER ERROR CALL cl_err_msg_log
 
   IF (cl_null(g_lang)) THEN
      LET g_lang = "1"
   END IF
   IF (cl_null(ps_msg)) THEN
      LET ps_msg = ""
   END IF
 
   SELECT ze03 INTO lc_title FROM ze_file WHERE ze01 = 'lib-042' AND ze02 = g_lang
   IF SQLCA.SQLCODE THEN
      LET lc_title = "Confirm"
   END IF
 
   LET ls_msg = ps_msg.trim()
   SELECT ze03 INTO lc_msg FROM ze_file WHERE ze01 = ls_msg AND ze02 = g_lang
   IF NOT SQLCA.SQLCODE THEN
       LET lc_msg=cl_replace_err_msg(lc_msg,p_str)   #FUN-870095
       LET ps_msg =lc_msg CLIPPED
   END IF
 
   LET li_result = FALSE
    
   IF (cl_null(lc_msg))  THEN    # FUN-870095  參數不為ze訊息代碼時，lc_title後面()內的資訊不用顯示
      LET lc_title=lc_title CLIPPED
   ELSE
      LET lc_title=lc_title CLIPPED,'(',ls_msg,')' #MOD-4A0143 show ze01
   END IF
 
   MENU lc_title ATTRIBUTE (STYLE="dialog", COMMENT=ps_msg.trim(), IMAGE="question")
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
 
