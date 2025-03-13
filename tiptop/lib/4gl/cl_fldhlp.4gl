# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_fldhlp
# Descriptions...: 顯示欄位說明 ( 4行 WINDOW 顯示 )
# Input parameter: p_field_name
# Usage .........: call cl_fldhlp(p_field_name)
# Date & Author..: 89/09/04 By LYS
# Revised Record.: 90/11/01 By LYS
# Revised Record.: 95/12/28 By grace 離開時按兩次才能離開   
#         Modify.: 04/02/17 By saki
#
# Modify.........: No.FUN-690005 06/09/10 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.TQC-860016 08/06/10 By saki 增加ON IDLE段
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"
 
FUNCTION cl_fldhlp(p_field_name)
   DEFINE p_field_name	LIKE type_file.chr20,  #No.FUN-690005 VARCHAR(10),
          l_d1    	LIKE type_file.chr20,  #No.FUN-690005 VARCHAR(20),
          i,l_row   	LIKE type_file.num5,   #No.FUN-690005 SMALLINT,
          l_chr   	LIKE type_file.chr1,   #No.FUN-690005 VARCHAR(1),
          l_cnt,l_arrno	LIKE type_file.num5,   #No.FUN-690005 SMALLINT,
          l_zq		ARRAY[20] OF LIKE type_file.chr1000#No.FUN-690005 VARCHAR(70)
   DEFINE g_i           LIKE type_file.num5,   #No.FUN-690005 SMALLINT,
          g_ans         LIKE type_file.chr20,  #No.FUN-690005 VARCHAR(10),
          l_msg         LIKE type_file.chr1000 #No.FUN-690005 VARCHAR(55)
   DEFINE   ls_msg      LIKE ze_file.ze03,     #No.FUN-690005 VARCHAR(100),
            lc_title    LIKE ze_file.ze03      #No.FUN-690005 VARCHAR(50)
 
   LET l_arrno = 18
   WHENEVER ERROR CALL cl_err_msg_log
   DECLARE zq_curs CURSOR FOR
           SELECT zq03,zq04 FROM zq_file
            WHERE zq01 = p_field_name
              AND zq02 = g_lang
             ORDER BY zq03
   FOR l_cnt = 1 TO l_arrno
       LET l_zq[l_cnt] = ' '
   END FOR
   LET l_cnt = 1
   FOREACH zq_curs INTO i,l_zq[l_cnt]
           LET l_cnt = l_cnt + 1
           IF l_cnt > l_arrno THEN EXIT FOREACH END IF
   END FOREACH
   LET l_row = 24 - l_cnt
#--genero
#  OPEN WINDOW cl_fldhlp_w AT l_row,3
#       WITH l_cnt ROWS, 70 COLUMNS ATTRIBUTE(BORDER)
   FOR i = 1 TO l_cnt-1
       DISPLAY l_zq[i] AT i,1
   END FOR
 
   SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = 'lib-002' AND ze02 = g_lang
   SELECT ze03 INTO lc_title FROM ze_file WHERE ze01 = 'lib-041' AND ze02 = g_lang
 
   MENU lc_title ATTRIBUTE (STYLE="dialog", COMMENT=ls_msg CLIPPED, IMAGE="question")
      ON ACTION ok
         EXIT MENU
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU
   
      #No.TQC-860016 --start--
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
      #No.TQC-860016 ---end---
   END MENU
 
   IF INT_FLAG THEN LET INT_FLAG = 0 END IF
 
# CLOSE WINDOW cl_fldhlp_w
END FUNCTION
