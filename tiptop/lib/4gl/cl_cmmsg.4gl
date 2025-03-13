# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_cmmsg
# Descriptions...: 顯示 COMMIT WORK 訊息
# Memo...........: 
# Input parameter: p_code   訊息種類
# Return code....: none
# Usage..........: CALL cl_cmmsg(1)
# Date & Author..: 92/07/07 By Lin
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.TQC-8A0074 08/10/29 By Smapmin 判斷是否背景作業，條件需再加上 g_gui_type 
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"
 
#GLOBALS
#   DEFINE g_lang VARCHAR(1)
#END GLOBALS
 
FUNCTION cl_cmmsg(p_code)
DEFINE   p_code    LIKE type_file.num5          #No.FUN-690005 SMALLINT
DEFINE   ls_msg    LIKE ze_file.ze03,           #No.FUN-690005 VARCHAR(100)
         ls_msg2   LIKE ze_file.ze03            #No.FUN-690005 VARCHAR(100)
 
   #-----TQC-8A0074---------
   IF g_bgjob = 'Y' AND g_gui_type NOT MATCHES "[13]"  THEN 
      RETURN
   END IF
   #-----END TQC-8A0074-----
 
   SELECT ze03 INTO ls_msg  FROM ze_file WHERE ze01 = 'lib-022' AND ze02 = g_lang
   SELECT ze03 INTO ls_msg2 FROM ze_file WHERE ze02 = 'lib_023' AND ze02 = g_lang
 
   CASE 
       WHEN p_code = 1  ERROR  ls_msg
       WHEN p_code = 2  ERROR  ls_msg2
       WHEN p_code = 3  MESSAGE ls_msg2
       WHEN p_code = 4  MESSAGE ls_msg
       OTHERWISE EXIT CASE
   END CASE
END FUNCTION
