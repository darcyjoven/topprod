# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Program Name...: s_aax.4gl
# Descriptions...: 帳別限定部門使用維護
# Usage..........: s_aax(p_bookno)
# Date & Author..: No.FUN-750022 07/08/10 By xufeng  
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-960330 09/07/06 By chenmoyan 去掉關于事物的操作
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_aax(p_bookno)
   #FUN-750022
   DEFINE p_bookno	LIKE aax_file.aax01    
   DEFINE g_success	LIKE type_file.chr1   
   DEFINE b_aax 	RECORD LIKE aax_file.*
   DEFINE l_aax         ARRAY[30] OF RECORD
   			aax02	LIKE aax_file.aax02,   
   			gem02 	LIKE gem_file.gem02 
   			END RECORD
   DEFINE i,j,k		LIKE type_file.num10     
 
   WHENEVER ERROR CALL cl_err_msg_log
   IF cl_null(p_bookno) THEN
      CALL cl_err('','-400',0) 
      RETURN
   END IF
 
   OPEN WINDOW s_aax_w AT 10,20 WITH FORM "sub/42f/s_aax"
   ATTRIBUTE(STYLE=g_win_style)
 
   CALL cl_ui_locale("s_aax") 
 
   DECLARE s_aax_c CURSOR FOR 
      SELECT aax02,gem02 FROM aax_file LEFT OUTER JOIN gem_file ON aax02=gem01 
       WHERE aax01=p_bookno 
       ORDER BY aax02
   LET i=1
   FOREACH s_aax_c INTO l_aax[i].*
      LET i=i+1
      IF i > 30 THEN EXIT FOREACH END IF
   END FOREACH
   CALL SET_COUNT(i-1)
   INPUT ARRAY l_aax WITHOUT DEFAULTS FROM s_aax.*
      BEFORE ROW
         LET i = ARR_CURR()
         LET j = SCR_LINE()
      AFTER FIELD aax02
         IF l_aax[i].aax02 IS NOT NULL THEN
            SELECT gem02 INTO l_aax[i].gem02
              FROM gem_file
             WHERE gem01=l_aax[i].aax02 
            IF STATUS THEN
               CALL cl_err3("sel","gem_file",l_aax[i].aax02,"",STATUS,"","",0) 
            END IF
            DISPLAY l_aax[i].gem02 TO s_aax[j].gem02
         END IF
      AFTER ROW       
         IF INT_FLAG THEN EXIT INPUT  END IF
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT  END IF
      AFTER DELETE       
         LET i = ARR_COUNT()
         INITIALIZE l_aax[i+1].* TO NULL
      ON ACTION controlp 
         CASE
            WHEN INFIELD(aax02) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem"
               LET g_qryparam.default1 = l_aax[i].aax02
               CALL cl_create_qry() RETURNING l_aax[i].aax02
               DISPLAY l_aax[i].aax02 TO aax02
               NEXT FIELD aax02
         END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   
   END INPUT
   IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW s_aax_w RETURN END IF
   LET g_success='Y'
   DELETE FROM aax_file WHERE aax01=p_bookno
 
   IF STATUS THEN CALL cl_err('del aax:',STATUS,1) LET g_success='N' END IF
   FOR i=1 TO 30
      IF l_aax[i].aax02 IS NULL THEN CONTINUE FOR END IF
      LET b_aax.aax01=p_bookno
      LET b_aax.aax02=l_aax[i].aax02
      INSERT INTO aax_file VALUES(b_aax.*)
      IF STATUS THEN CALL cl_err('ins aax:',STATUS,1)LET g_success='N' END IF
   END FOR
#  IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF    #No.TQC-960330
   CLOSE WINDOW s_aax_w
END FUNCTION
 
# Descriptions...: 帳別限定部門使用維護
 
FUNCTION s_aax_d(p_bookno)
   DEFINE p_bookno	LIKE aax_file.aax01     
   DEFINE x		LIKE aax_file.aax02    
   DEFINE str		LIKE type_file.chr1000
 
   DECLARE s_aax_d_c CURSOR FOR 
      SELECT aax02 FROM aax_file WHERE aax01=p_bookno ORDER BY aax02
   FOREACH s_aax_d_c INTO x
      IF str IS NULL
         THEN LET str=x
         ELSE LET str=str CLIPPED,',',x
      END IF
   END FOREACH
   RETURN str
END FUNCTION
