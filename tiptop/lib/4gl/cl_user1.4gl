# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_user1.4gl
# Descriptions...: 設定使用者名稱,部門代碼,程式代號,系統語言別.
# Date & Author..: 2003/08/27 by Hiko
# Usage..........: CALL cl_user()
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-880019 08/09/18 By alex 註冊方式變更
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
##################################################
# Descriptions...: 設定使用者名稱,GUI Type,部門代碼,程式代號,系統語言別.
# Date & Author..: 2003/08/27 by Hiko
# Input Parameter: none
# Return code....: SMALLINT   是否設定成功
# Modify.........: No.FUN-690005 06/09/01 By hongmei 欄位類型轉換
##################################################
 
FUNCTION cl_user1()
   DEFINE   ls_err_log_dir    STRING,
            ls_err_log_cmd    STRING,
            ls_today          STRING,
            ls_err_log_name   STRING
   DEFINE   ls_cmd            STRING,
            li_invalid_sn     LIKE type_file.num5      #No.FUN-690005  SMALLINT
   DEFINE   lc_zb02           LIKE zb_file.zb02,       #No.FUN-690005 VARCHAR(1),
            ls_tty_no         STRING
 
 
   LET g_prog = ui.Interface.getName()
 
   LET ls_err_log_dir = FGL_GETENV("TOP") || "/log"
   LET ls_err_log_cmd = "mkdir -p " || ls_err_log_dir
   RUN ls_err_log_cmd
   
   LET ls_today = cl_replace_str(TODAY, "/", "")
   LET ls_err_log_name = ls_err_log_dir || "/" || ls_today || "_" || g_prog || "_user.log"
   LET ls_err_log_cmd = "rm -f " || ls_err_log_name
   RUN ls_err_log_cmd
 
   CALL STARTLOG(ls_err_log_name)
#   WHENEVER ERROR CALL cl_user_error_log
   WHENEVER ERROR CALL cl_err_msg_log
 
#  LET ls_cmd = FGL_GETENV('TOP'),'/bin/keychk'   #FUN-880019
#  RUN ls_cmd RETURNING li_invalid_sn
#  IF (li_invalid_sn) THEN
   IF NOT cl_key_check0() THEN
#     CALL ERRORLOG("Invaild installation key. Please contact your provider.")
      DISPLAY "Invaild installation key. Please contact your provider."
      RETURN FALSE
   END IF
 
   SELECT zb02 INTO lc_zb02 FROM zb_file WHERE zb00='0'
 
   #LET g_gui_type = cl_fglgui()
   LET g_gui_type = 1
 
   CASE
      WHEN (g_gui_type = 0) OR (g_gui_type = 1)
 
         IF (lc_zb02 = '2') THEN
            LET ls_tty_no = FGL_GETENV("LOGTTY")
            LET g_user = ls_tty_no.subString(6,20)
         ELSE #Login user
            #SELECT USER INTO g_user FROM SYSUSERS
            LET g_user = FGL_GETENV("LOGNAME")
         END IF
      WHEN (g_gui_type = 2) OR (g_gui_type = 3)
         LET g_user = FGL_GETENV("WEBUSER")
   END CASE
 
   SELECT zx03,zx04,zx06 INTO g_grup,g_clas,g_lang FROM zx_file WHERE zx01=g_user
   IF (SQLCA.SQLCODE) THEN
      CALL ERRORLOG(g_user CLIPPED || " has no data in zx_file.")
      DISPLAY g_user CLIPPED," has no data in zx_file."
      RETURN FALSE
   END IF
 
   RETURN TRUE
END FUNCTION
