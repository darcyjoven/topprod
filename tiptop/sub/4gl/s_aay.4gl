# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Program name...: s_abh.4gl
# Descriptions...: 帳別限定使用者維護
# Date & Author..: 06/05/08 By Sarah
# Usage..........: s_aay(p_bookno)
# Modify.........: No.FUN-660140 06/06/21 By Sarah 帳別放大成5碼
# Modify.........: NO.FUN-670091 06/08/01 BY rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-960330 09/07/06 By chenmoyan 去掉關于事物的操作
# Modify.........: No.MOD-B70077 11/07/08 By Dido 若不存在 zx_file 時,不可離開直到存在為止 
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_aay(p_bookno)
   DEFINE p_bookno	LIKE aay_file.aay01     #FUN-660140 LIKE aba_file.aba18->LIKE type_file.chr1000	#No.FUN-680147 VARCHAR(5)
   DEFINE g_success	LIKE type_file.chr1   	#No.FUN-680147 VARCHAR(1)
   DEFINE b_aay 	RECORD LIKE aay_file.*
   DEFINE l_aay         ARRAY[30] OF RECORD
   			aay02	LIKE aay_file.aay02,    #No.FUN-680147 VARCHAR(10)
   			zx02 	LIKE zx_file.zx01 	#No.FUN-680147 VARCHAR(10)
   			END RECORD
   DEFINE i,j,k		LIKE type_file.num10     	#No.FUN-680147 INTEGER
 
   WHENEVER ERROR CALL cl_err_msg_log
   IF cl_null(p_bookno) THEN
      CALL cl_err('','-400',0) 
      RETURN
   END IF
 
   OPEN WINDOW s_aay_w AT 10,20 WITH FORM "sub/42f/s_aay"
   ATTRIBUTE(STYLE=g_win_style)
 
   CALL cl_ui_locale("s_aay") 
 
   DECLARE s_aay_c CURSOR FOR 
      SELECT aay02,zx02 FROM aay_file LEFT OUTER JOIN zx_file ON aay02 = zx01
       WHERE aay01=p_bookno
       ORDER BY 1
   LET i=1
   FOREACH s_aay_c INTO l_aay[i].*
      LET i=i+1
      IF i > 30 THEN EXIT FOREACH END IF
   END FOREACH
   CALL SET_COUNT(i-1)
   INPUT ARRAY l_aay WITHOUT DEFAULTS FROM s_aay.*
      BEFORE ROW
         LET i = ARR_CURR()
         LET j = SCR_LINE()
      AFTER FIELD aay02
         IF l_aay[i].aay02 IS NOT NULL THEN
            SELECT zx02 INTO l_aay[i].zx02
              FROM zx_file
             WHERE zx01=l_aay[i].aay02 
            IF STATUS THEN
               #CALL cl_err('sel zx:',STATUS,0) NEXT FIELD aay02              #FUN-670091 reamrk
               CALL cl_err3("sel","zx_file",l_aay[i].aay02,"",STATUS,"","",0) #FUN-670091
               NEXT FIELD aay02      #MOD-B70077
            END IF
            DISPLAY l_aay[i].zx02 TO s_aay[j].zx02
         END IF
      AFTER ROW       
         IF INT_FLAG THEN EXIT INPUT  END IF
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT  END IF
      AFTER DELETE       
         LET i = ARR_COUNT()
         INITIALIZE l_aay[i+1].* TO NULL
      ON ACTION controlp   #ok
         CASE
            WHEN INFIELD(aay02)   #使用者代碼
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zx"
               LET g_qryparam.default1 = l_aay[i].aay02
               CALL cl_create_qry() RETURNING l_aay[i].aay02
               DISPLAY l_aay[i].aay02 TO aay02
               NEXT FIELD aay02
         END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   
   END INPUT
   IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW s_aay_w RETURN END IF
   LET g_success='Y'
   DELETE FROM aay_file WHERE aay01=p_bookno
 
   IF STATUS THEN CALL cl_err('del aay:',STATUS,1) LET g_success='N' END IF
   FOR i=1 TO 30
      IF l_aay[i].aay02 IS NULL THEN CONTINUE FOR END IF
      LET b_aay.aay01=p_bookno
      LET b_aay.aay02=l_aay[i].aay02
      INSERT INTO aay_file VALUES(b_aay.*)
      IF STATUS THEN CALL cl_err('ins aay:',STATUS,1)LET g_success='N' END IF
   END FOR
#  IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF        #No.TQC-960330
   CLOSE WINDOW s_aay_w
END FUNCTION
 
FUNCTION s_aay_d(p_bookno)
   DEFINE p_bookno	LIKE aay_file.aay01     #FUN-660140 LIKE aba_file.aba18->LIKE type_file.chr1000	#No.FUN-680147  VARCHAR(5)
   DEFINE x		LIKE aay_file.aay02     #No.FUN-680147 VARCHAR(10)
   DEFINE str		LIKE type_file.chr1000	#No.FUN-680147 VARCHAR(100)
 
   DECLARE s_aay_d_c CURSOR FOR 
      SELECT aay02 FROM aay_file WHERE aay01=p_bookno ORDER BY 1
   FOREACH s_aay_d_c INTO x
      IF str IS NULL
         THEN LET str=x
         ELSE LET str=str CLIPPED,',',x
      END IF
   END FOREACH
   RETURN str
END FUNCTION
