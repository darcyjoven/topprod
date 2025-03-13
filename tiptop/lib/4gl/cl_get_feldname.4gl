# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_get_feldname
# Descriptions...: 依欄位代碼取出系統欄位名稱設定維護作業(p_feldname)內的欄位名稱
# Input parameter: p_gaq01      欄位代碼
#                  p_lang       語言別
# Return code....: l_gaq03      欄位說明
# Usage .........: let g_msg = cl_get_feldname(p_gaq01,p_lang)
# Date & Author..: 05/09/29 By Mandy
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"
 
FUNCTION cl_get_feldname(p_gaq01,p_lang)
DEFINE
   p_gaq01     LIKE gaq_file.gaq01,
   p_lang      LIKE gaq_file.gaq02,
   l_gaq03     LIKE gaq_file.gaq03
 
   WHENEVER ERROR CALL cl_err_msg_log
   LET l_gaq03=''
   SELECT gaq03 INTO l_gaq03 FROM gaq_file
     WHERE gaq01=p_gaq01
       AND gaq02=p_lang
     RETURN l_gaq03
END FUNCTION
 
