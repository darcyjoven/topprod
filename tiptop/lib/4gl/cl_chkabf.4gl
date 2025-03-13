# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_chkabf
# Descriptions...: 檢查是否擁有列印族群的權限
# Memo...........: 
# Input parameter: p_priv      族群編號
# Return code....: TRUE/FALSE
# Usage..........: IF cl_chkabf(g_priv) THEN
# Date & Author..: 96/10/28 By Danny
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"
 
GLOBALS
   DEFINE #g_user VARCHAR(10),
          #g_lang   VARCHAR(01),
          g_priv  	LIKE type_file.chr20        #No.FUN-690005 VARCHAR(10)
END GLOBALS
 
FUNCTION cl_chkabf(p_priv)
   DEFINE p_priv   	LIKE abf_file.abf02,        #No.FUN-690005 VARCHAR(10)
          l_buf   	LIKE type_file.chr1000,     #No.FUN-690005 VARCHAR(20)
          l_cnt         LIKE type_file.num5         #No.FUN-690005 SMALLINT
   DEFINE ls_msg        LIKE ze_file.ze03,          #No.FUN-690005 VARCHAR(100)
          ls_title      LIKE ze_file.ze03           #No.FUN-690005 VARCHAR(50)
 
 
   WHENEVER ERROR CALL cl_err_msg_log
   IF g_user = "informix" THEN RETURN 0 END IF
 
   IF cl_null(p_priv) THEN RETURN 1 END IF
 
   SELECT COUNT(*) INTO l_cnt FROM abf_file
    WHERE abf01 = g_user AND abf02 = p_priv AND abfacti = 'Y'
 
   SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = 'lib-019' AND ze02 = g_lang
   SELECT ze03 INTO ls_title FROM ze_file WHERE ze01 = 'lib-041' AND ze02 = g_lang
 
   IF l_cnt = 0 THEN 
      MENU ls_title ATTRIBUTE (STYLE="dialog", COMMENT=ls_msg CLIPPED, IMAGE="question")
         ON ACTION ok
            EXIT MENU
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE MENU
      END MENU
#     ERROR ls_msg
      RETURN 1 
   END IF
 
   RETURN 0
END FUNCTION
