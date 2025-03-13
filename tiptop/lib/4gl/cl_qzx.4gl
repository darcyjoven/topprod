# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Library name...: cl_qzx (External file name : cl_qzx.4gl)
# Descriptions...: 對 g_user 提供可執行程式的視窗查詢.
# Input parameter: p_row,p_col
#                  p_key
# Return code....: p_key    使用者基本檔代碼
# Usage .........: call cl_qzx(p_row,p_col,p_key) returning p_key
# Date & Author..: 91/05/29 By kitty
# Modify.........: No.TQC-630109 06/03/10 By saki Array最大筆數控制
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.FUN-9B0156 09/11/30 By alex 調整ATTRIBUTES
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
FUNCTION cl_qzx(p_row,p_col,p_key)
	 DEFINE	p_row,p_col	LIKE type_file.num5,          #No.FUN-690005 SMALLINT
   		p_key		LIKE zx_file.zx01,
		l_begin_key	LIKE zx_file.zx01,
   		l_zx ARRAY[30] of RECORD
   				zx01 LIKE zx_file.zx01,
				zx02 LIKE zx_file.zx02
			END RECORD,
		l_arrno	       LIKE type_file.num5,             #No.FUN-690005	SMALLINT
                l_zx01         LIKE zx_file.zx01,
		l_n,l_ac	LIKE type_file.num5,          #No.FUN-690005 SMALLINT
		l_exit_sw       LIKE type_file.chr1,          #No.FUN-690005 VARCHAR(1)
		l_wc  		LIKE type_file.chr1000,       #No.FUN-690005 VARCHAR(1000)
		l_sql 		LIKE type_file.chr1000,       #No.FUN-690005 VARCHAR(1000)
                l_time		LIKE type_file.chr8           #No.FUN-690005 VARCHAR(8) 
 
   WHENEVER ERROR CALL cl_err_msg_log

   LET l_arrno = 30
 
   OPEN WINDOW cl_qzx_w WITH FORM "lib/42f/cl_qzx"
      ATTRIBUTE(STYLE="lib" CLIPPED)                    #FUN-9B0156
   CALL cl_ui_locale("cl_qzx")
 
   IF p_key IS NULL THEN
      LET l_begin_key = ' '
   ELSE
      LET l_begin_key = p_key
   END IF

   WHILE TRUE
     LET l_exit_sw = "y"
     LET l_ac = 1
     CALL cl_opmsg('q')

     IF g_lang='0' THEN
        CONSTRUCT l_wc ON zx01,zx02 FROM s_zx[1].*
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE CONSTRUCT
        END CONSTRUCT
     ELSE
        CONSTRUCT l_wc ON zx01,zx02e FROM s_zx[1].zx01,s_zx[1].zx02
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE CONSTRUCT
        END CONSTRUCT
     END IF

     IF INT_FLAG THEN LET INT_FLAG=0 EXIT WHILE END IF
 
     IF g_lang='0' THEN
        LET l_sql = "SELECT zx01,zx02 FROM zx_file WHERE ",l_wc CLIPPED," ORDER BY zx01"
     ELSE
        LET l_sql = "SELECT zx01,zx02e FROM zx_file WHERE ",l_wc CLIPPED, " ORDER BY zx01"
     END IF

     PREPARE cl_qzx_prepare FROM l_sql
     DECLARE zx_curs CURSOR FOR cl_qzx_prepare
     FOREACH zx_curs INTO l_zx[l_ac].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
	LET l_ac = l_ac + 1
        IF l_ac > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
     END FOREACH

     CALL SET_COUNT(l_ac - 1)
     CALL cl_set_act_visible("accept,cancel", FALSE)

     DISPLAY ARRAY l_zx TO s_zx.* 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DISPLAY
     END DISPLAY
     CALL cl_set_act_visible("accept,cancel", TRUE)
 
     IF INT_FLAG THEN LET INT_FLAG = 0 END IF
     IF l_exit_sw = "y" THEN EXIT WHILE  END IF
   END WHILE
   CLOSE WINDOW cl_qzx_w

   RETURN p_key
END FUNCTION

