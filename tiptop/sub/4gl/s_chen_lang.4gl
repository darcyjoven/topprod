# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_chen_lang.4gl
# Descriptions...: 請選擇列印(0.中文/1.英文/2.簡體)報表:[chr]
# Date & Author..: 03/01/27 By Mandy
# Usage..........: CALL s_chen_lang(p_row,p_col,p_lang) RETURN g_lang
# Input parameter: p_row,p_col,p_velue,p_lang
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_chen_lang(p_row,p_col,p_lang)
   DEFINE l_chr	LIKE type_file.chr1,             #No.FUN-680147 VARCHAR(1)
          p_row,p_col,l	LIKE type_file.num5,     #No.FUN-680147 SMALLINT
          p_lang        LIKE type_file.chr1      #No.FUN-680147 VARCHAR(1)
 
   WHENEVER ERROR CALL cl_err_msg_log
	LET INT_FLAG=0
 
   LET p_col = 0 LET p_col = 10 
   OPEN WINDOW s_chen_lang_w AT p_row,p_col WITH FORM "sub/42f/s_chen_lang"
   ATTRIBUTE( STYLE = g_win_style )
 
   CALL cl_ui_locale("s_chen_lang")
 
   LET l_chr = p_lang
   WHILE TRUE
      INPUT l_chr WITHOUT DEFAULTS FROM chr
      IF INT_FLAG THEN 
         LET INT_FLAG = 0 
         LET l_chr = p_lang 
      END IF
      IF NOT cl_null(l_chr) THEN EXIT WHILE END IF
   END WHILE
	CLOSE WINDOW s_chen_lang_w
 	RETURN l_chr
END FUNCTION
