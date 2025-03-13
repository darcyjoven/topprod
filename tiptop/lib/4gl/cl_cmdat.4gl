# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_cmdat
# Descriptions...: 指定時間延後執行 UNIX 指令
# Memo...........: 
# Input parameter: p_time	指定時間
#                  p_cmd	UNIX 指令
# Return code....: none
# Usage..........: CALL cl_cmdat(p_code,p_time,p_cmd)
# Date & Author..: 91/06/10 By LYS
# Modify.........: 2004/10/26 by Brendan - Process model changed
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690103 06/10/18 By saki    變動p_time長度
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"
 
GLOBALS
   DEFINE g_forupd_sql      STRING   #SELECT ... FOR UPDATE SQL
END GLOBALS
 
FUNCTION cl_cmdat(p_code,p_time,p_cmd)
   DEFINE p_code    LIKE zz_file.zz01,           #No.FUN-690005  VARCHAR(10)
          p_time    LIKE type_file.chr8,         #No.FUN-690005  VARCHAR(5)  #No.FUN-690103
          p_cmd     STRING,
          l_n       LIKE type_file.num5          #No.FUN-690005  SMALLINT
   DEFINE l_zz08    LIKE zz_file.zz08
   DEFINE li_flag   LIKE type_file.num10,        #No.FUN-690005  INTEGER
          li_pos    LIKE type_file.num5          #No.FUN-690005  SMALLINT
 
 
   WHENEVER ERROR CALL cl_err_msg_log
   
   LET g_forupd_sql = "SELECT zz07 FROM zz_file WHERE zz01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE cl_cmdat_zz CURSOR FROM g_forupd_sql
   OPEN cl_cmdat_zz USING p_code
 
   IF SQLCA.sqlcode THEN 
      LET l_n = 0 
   END IF
 
   FETCH cl_cmdat_zz INTO l_n
   IF SQLCA.sqlcode THEN 
      LET l_n = 0 
   END IF
 
   LET l_n = l_n + 1
   UPDATE zz_file SET zz07 = l_n WHERE zz01 = p_code
   CLOSE cl_cmdat_zz
 
#----------
# Recognize what's the program code
#----------
   LET li_flag = TRUE
   SELECT zz08 INTO l_zz08 FROM zz_file WHERE zz01 = p_code
   IF SQLCA.SQLCODE THEN
      LET li_flag = FALSE
   ELSE
      LET li_pos = p_cmd.getIndexOf(l_zz08 CLIPPED, 1)
      IF li_pos = 0 THEN
         LET li_flag = FALSE
      ELSE
         LET li_pos = li_pos + LENGTH(l_zz08 CLIPPED)
      END IF
   END IF
   IF NOT li_flag THEN
      LET li_pos = p_cmd.getIndexOf("'", 1)
   END IF
   LET p_cmd = "p_cron ", p_code CLIPPED, " ", p_cmd.subString(li_pos, p_cmd.getLength())
 
#----------
# Launch 'p_cron' to configure schedule job
#----------
   CALL cl_cmdrun_wait(p_cmd)
END FUNCTION
