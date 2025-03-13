# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Library name...: cl_err
# Descriptions...: 顯示錯誤訊息於螢幕第24行
# Date & Author..: 89/09/04 By LYS
# Usage..........: CALL cl_err(p_msg,err_code,p_n)
# Input parameter: p_msg	錯誤訊息的附加說明
#                  err_code	錯誤訊息代碼(可為文字或數字)
#                  p_n		顯示錯誤訊息後是否應按(CR)繼續或停留秒數
#                     		0:不必按(CR)繼續 1:按(CR)繼續
#                     		> 1 :停留秒數
#                               -1:當TEXT MODE 時效果如 '0'
#                                  當GUI MODE 時效果如 '1'
# Return code....: void
# Modify.........: 05/04/01 alex 在傳參數加上 CLIPPED or .trim()
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-860016 08/06/10 By saki 增加ON IDLE段
# Modify.........: No.FUN-B30004 11/03/07 By jrg542 註解掉沒有用到的程式      
 
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION cl_err(p_msg,err_code,p_n)
   DEFINE p_msg    	LIKE type_file.chr1000,  #No.FUN-690005 VARCHAR(256),
          err_code	LIKE ze_file.ze01,       #No.FUN-690005 VARCHAR(7),
          err_coden	LIKE type_file.num10,    #No.FUN-690005 INTEGER,
          p_n   	LIKE type_file.num5,     #No.FUN-690005 SMALLINT,
          l_errmsg      LIKE ze_file.ze03,       #No.FUN-690005 VARCHAR(70),
          l_msg         LIKE type_file.chr1000,  #No.FUN-690005 VARCHAR(256),
          l_sqlerrd ARRAY[6] OF LIKE type_file.num10,   #FUN-690005 INTEGER,
          l_chr    	LIKE type_file.chr1      #No.FUN-690005 VARCHAR(1)
   DEFINE g_i           LIKE type_file.num5,     #No.FUN-690005 SMALLINT
          g_ans         LIKE type_file.chr1000   #No.FUN-690005 VARCHAR(10)
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   # 2004/03/24 by saki : 轉call cl_err_msg 將來要整個替換
   IF p_n = 1 THEN
      LET p_n = -1
   END IF
   CALL cl_err_msg(p_msg CLIPPED,err_code,NULL,p_n)
   RETURN
# #FUN-B30004 START 
#   LET g_i=g_gui_type
#   --#IF g_i = 1 OR g_i=3 # 1.GUI 3.JAVA 
#   --#   THEN
##  --#   CALL fgl_init4js()
#   --#END IF
# 
#   IF g_lang IS NULL THEN LET g_lang='0' END IF
#   LET l_sqlerrd[1] = SQLCA.sqlerrd[1]
#   LET l_sqlerrd[2] = SQLCA.sqlerrd[2]
#   LET l_sqlerrd[3] = SQLCA.sqlerrd[3]
#   LET l_sqlerrd[4] = SQLCA.sqlerrd[4]
#   LET l_sqlerrd[5] = SQLCA.sqlerrd[5]
#   LET l_sqlerrd[6] = SQLCA.sqlerrd[6]
#   LET l_errmsg = NULL
#   SELECT ze03 INTO l_errmsg FROM ze_file
#    WHERE ze01 = err_code AND ze02 = g_lang
#   IF SQLCA.sqlcode and cl_err_numchk(err_code)
#      THEN LET err_coden = err_code
#           LET l_errmsg = err_get(err_coden)
#   END IF
# 
#   IF l_errmsg IS NULL THEN LET l_errmsg = 'Unknown error code!' END IF
#   LET l_msg=p_msg CLIPPED,' ',l_errmsg CLIPPED
# 
### Add By Raymon
#   IF err_code="-243" OR err_code="-246" OR err_code="-250" OR err_code="-263"
#      THEN 
#      LET p_n=1
#   END IF
# 
#   CASE 
#     WHEN (p_n=0 OR p_n=-1) AND g_i=0
#          IF err_code IS NULL THEN
#              ERROR ' ',p_msg CLIPPED,' ',l_errmsg CLIPPED
#          ELSE
#              ERROR '(',err_code clipped,')',p_msg CLIPPED,' ',l_errmsg CLIPPED
#          END IF
#     WHEN p_n=0 AND g_i>=1   # g_i: 1.GUI Mode 2.HTML 3.JAVA
#          IF err_code IS NULL THEN
#              ERROR ' ',p_msg CLIPPED,' ',l_errmsg CLIPPED
#          ELSE
#              ERROR '(',err_code clipped,')',p_msg CLIPPED,' ',l_errmsg CLIPPED
#          END IF
#     WHEN p_n=1 AND g_i=0
#          IF err_code IS NULL THEN
#              ERROR ' ',p_msg CLIPPED,' ',l_errmsg CLIPPED
#          ELSE
#              ERROR '(',err_code clipped,')',p_msg CLIPPED,' ',l_errmsg CLIPPED
#          END IF
#          PROMPT 'press any key to continue:' FOR CHAR l_chr
#             ON IDLE g_idle_seconds
#                CALL cl_on_idle()
###               CONTINUE PROMPT
#          
#             #No.TQC-860016 --start--
#             ON ACTION controlg
#                CALL cl_cmdask()
# 
#             ON ACTION about
#                CALL cl_about()
# 
#             ON ACTION help
#                CALL cl_show_help()
#             #No.TQC-860016 ---end---
#          END PROMPT
#          IF l_chr = '1' THEN
#              PROMPT err_code CLIPPED,
#                 ' 1:',l_sqlerrd[1],' 2:',l_sqlerrd[2],' 3:',l_sqlerrd[3],
#                 ' 4:',l_sqlerrd[4],' 5:',l_sqlerrd[5],' 6:',l_sqlerrd[6],
#                 ' <cr>:'FOR CHAR l_chr
#                 #No.TQC-860016 --start--
#                 ON IDLE g_idle_seconds
#                    CALL cl_on_idle()
# 
#                 ON ACTION controlg
#                    CALL cl_cmdask()
# 
#                 ON ACTION about
#                    CALL cl_about()
# 
#                 ON ACTION help
#                    CALL cl_show_help()
#              END PROMPT
#                 #No.TQC-860016 ---end---
#          END IF
#     WHEN p_n>1 AND g_i=0
#          IF err_code IS NULL THEN
#              ERROR ' ',p_msg CLIPPED,' ',l_errmsg CLIPPED
#          ELSE
#              ERROR '(',err_code clipped,')',p_msg CLIPPED,' ',l_errmsg CLIPPED
#          END IF
#          SLEEP p_n
#     WHEN (p_n>=1 OR p_n=-1) AND g_i>=1
##         --# CALL fgl_winmessage(err_code,l_msg,"exclamation")
#          MENU err_code
#               ATTRIBUTE ( STYLE = "dialog", COMMENT = l_msg CLIPPED, IMAGE = "exclamation" )
#               COMMAND "Close"
#             ON IDLE g_idle_seconds
#                CALL cl_on_idle()
#                CONTINUE MENU
#          
#             #No.TQC-860016 --start--
#             ON ACTION controlg
#                CALL cl_cmdask()
# 
#             ON ACTION about
#                CALL cl_about()
# 
#             ON ACTION help
#                CALL cl_show_help()
#             #No.TQC-860016 ---end---
#          END MENU
#   END CASE
# #FUN-B30004 END 
END FUNCTION
 
# Private Func...: TRUE
 
FUNCTION cl_err_numchk(err_code)
   DEFINE err_code LIKE ze_file.ze01       #No.FUN-690005  VARCHAR(7)
   DEFINE i        LIKE type_file.num5     #No.FUN-690005  SMALLINT
   FOR i = 1 TO 7
      IF cl_null(err_code[i,i]) OR
         err_code[i,i] MATCHES "[-0123456789]"
         THEN CONTINUE FOR
         ELSE RETURN FALSE
      END IF
   END FOR
   RETURN TRUE
END FUNCTION
