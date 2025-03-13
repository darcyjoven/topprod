# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_rbmsg
# Descriptions...: 顯示 ROLLBACK WORK 訊息
# Input parameter: p_code   訊息種類
# Usage .........: call cl_rbmsg(1)
# Date & Author..: 92/07/07 By Lin
#
# Modify........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.TQC-8A0074 08/10/29 By Smapmin 判斷是否背景作業，條件需再加上 g_gui_type 
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"
 
FUNCTION cl_rbmsg(p_code)
DEFINE   p_code    LIKE type_file.num5              #No.FUN-690005  SMALLINT
DEFINE   ls_msg    LIKE ze_file.ze03,               #No.FUN-690005  VARCHAR(100)
         ls_msg2   LIKE ze_file.ze03,               #No.FUN-690005  VARCHAR(100)
         ls_msg3   LIKE ze_file.ze03                #No.FUN-690005  VARCHAR(100)
 
   #-----TQC-8A0074---------
   IF g_bgjob = 'Y' AND g_gui_type NOT MATCHES "[13]"  THEN 
      RETURN
   END IF
   #-----END TQC-8A0074-----
 
   SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = 'lib-028' AND ze02 = g_lang
   SELECT ze03 INTO ls_msg2 FROM ze_file WHERE ze01 = 'lib-029' AND ze02 = g_lang
   SELECT ze03 INTO ls_msg3 FROM ze_file WHERE ze01 = 'lib-030' AND ze02 = g_lang
 
   CASE 
      WHEN p_code = 1  ERROR ls_msg CLIPPED
      WHEN p_code = 2  ERROR ls_msg2 CLIPPED
      WHEN p_code = 3  MESSAGE ls_msg2 CLIPPED
      WHEN p_code = 4  MESSAGE ls_msg3 CLIPPED
      OTHERWISE EXIT CASE
   END CASE
END FUNCTION
