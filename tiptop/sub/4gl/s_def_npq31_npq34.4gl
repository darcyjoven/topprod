# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_def_npq31_npq34.4gl
# Descriptions...: 依彈性設定預設異動碼值
# Date & Author..: 11/01/25 FUN-AA0087 BY vealxu 
# Modify.........: No.TQC-B30030 11/03/03 By yinhy 32區鏈接報錯，過單到32區
# Modify.........: No.MOD-C60199 12/06/25 By Polly 若已在彈性異動碼設定就不應再重新給予

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_def_npq31_npq34(p_npq,p_bookno)   #TQC-B30030
DEFINE p_npq      RECORD LIKE npq_file.*
DEFINE p_bookno   LIKE aag_file.aag00      
DEFINE l_aag      RECORD LIKE aag_file.*
DEFINE l_npq31    LIKE npq_file.npq31
DEFINE l_npq32    LIKE npq_file.npq32
DEFINE l_npq33    LIKE npq_file.npq33
DEFINE l_npq34    LIKE npq_file.npq34

   WHENEVER ERROR CALL cl_err_msg_log
   
   SELECT * INTO l_aag.* FROM aag_file 
    WHERE aag01=p_npq.npq03
      AND aag00=p_bookno
   
   IF NOT cl_null(l_aag.aag31) THEN
      CALL s_def_npq31_34(l_aag.aag31,p_npq.*) RETURNING l_npq31
   END IF
   
   IF NOT cl_null(l_aag.aag32) THEN
      CALL s_def_npq31_34(l_aag.aag32,p_npq.*) RETURNING l_npq32
   END IF
   
   IF NOT cl_null(l_aag.aag33) THEN
      CALL s_def_npq31_34(l_aag.aag33,p_npq.*) RETURNING l_npq33
   END IF
   
   IF NOT cl_null(l_aag.aag34) THEN
      CALL s_def_npq31_34(l_aag.aag34,p_npq.*) RETURNING l_npq34
   END IF
   
   RETURN l_npq31,l_npq32,l_npq33,l_npq34

END FUNCTION

FUNCTION s_def_npq31_34(p_ahe01,p_npq)
DEFINE p_ahe01    LIKE ahe_file.ahe01
DEFINE p_npq      RECORD LIKE npq_file.*
DEFINE l_ahe      RECORD LIKE ahe_file.*
DEFINE l_npq31    LIKE npq_file.npq31
DEFINE l_str      STRING
DEFINE l_ahe09    LIKE ahe_file.ahe09
DEFINE l_aag31    LIKE aag_file.aag31     #MOD-C60199 add
DEFINE l_aag32    LIKE aag_file.aag32     #MOD-C60199 add
DEFINE l_aag33    LIKE aag_file.aag33     #MOD-C60199 add
DEFINE l_aag34    LIKE aag_file.aag34     #MOD-C60199 add

   SELECT * INTO l_ahe.* 
     FROM ahe_file
    WHERE ahe01=p_ahe01
     
   IF l_ahe.ahe03='4' THEN
      CASE l_ahe.ahe05
         WHEN 'npq00'   LET l_npq31 = p_npq.npq00
         WHEN 'npq01'   LET l_npq31 = p_npq.npq01
         WHEN 'npq011'  LET l_npq31 = p_npq.npq011
         WHEN 'npq02'   LET l_npq31 = p_npq.npq02
         WHEN 'npq03'   LET l_npq31 = p_npq.npq03
         WHEN 'npq04'   LET l_npq31 = p_npq.npq04
         WHEN 'npq05'   LET l_npq31 = p_npq.npq05
         WHEN 'npq06'   LET l_npq31 = p_npq.npq06
         WHEN 'npq07'   LET l_npq31 = p_npq.npq07
         WHEN 'npq07f'  LET l_npq31 = p_npq.npq07f
         WHEN 'npq08'   LET l_npq31 = p_npq.npq08
         WHEN 'npq11'   LET l_npq31 = p_npq.npq11
         WHEN 'npq12'   LET l_npq31 = p_npq.npq12
         WHEN 'npq13'   LET l_npq31 = p_npq.npq13
         WHEN 'npq14'   LET l_npq31 = p_npq.npq14
         WHEN 'npq15'   LET l_npq31 = p_npq.npq15
         WHEN 'npq21'   LET l_npq31 = p_npq.npq21
         WHEN 'npq22'   LET l_npq31 = p_npq.npq22
         WHEN 'npq23'   LET l_npq31 = p_npq.npq23
         WHEN 'npq24'   LET l_npq31 = p_npq.npq24
         WHEN 'npq25'   LET l_npq31 = p_npq.npq25
         WHEN 'npq26'   LET l_npq31 = p_npq.npq26
         WHEN 'npq27'   LET l_npq31 = p_npq.npq27
         WHEN 'npq28'   LET l_npq31 = p_npq.npq28
         WHEN 'npq29'   LET l_npq31 = p_npq.npq29
         WHEN 'npq30'   LET l_npq31 = p_npq.npq30
         WHEN 'npq31'   LET l_npq31 = p_npq.npq31
         WHEN 'npq32'   LET l_npq31 = p_npq.npq32
         WHEN 'npq33'   LET l_npq31 = p_npq.npq33
         WHEN 'npq34'   LET l_npq31 = p_npq.npq34
         WHEN 'npq35'   LET l_npq31 = p_npq.npq35
         WHEN 'npq36'   LET l_npq31 = p_npq.npq36
         WHEN 'npq37'   LET l_npq31 = p_npq.npq37
         WHEN 'npq930'  LET l_npq31 = p_npq.npq930
         WHEN 'npqsys'  LET l_npq31 = p_npq.npqsys
         WHEN 'npqtype' LET l_npq31 = p_npq.npqtype
         OTHERWISE LET l_npq31=''
      END CASE
   
      LET l_str=l_npq31
      LET l_ahe09 = l_str.getLength()
      IF l_ahe09 < l_ahe.ahe09 THEN
         LET l_str=l_str.subString(l_ahe.ahe08,l_ahe09)
      ELSE
         LET l_str=l_str.subString(l_ahe.ahe08,l_ahe.ahe09)
      END IF
      RETURN l_str
   ELSE
     #------------------------MOD-C60199--------------------(S)
     #RETURN ''                                #MOD-C60199 mark
      SELECT aag31,aag32,aag33,aag34
        INTO l_aag31,l_aag32,l_aag33,l_aag34
        FROM aag_file
       WHERE aag01=p_npq.npq03
         AND aag00=g_aaz.aaz64
      IF p_ahe01 = l_aag31 THEN
         LET l_npq31 = p_npq.npq31
      END IF
      IF p_ahe01 = l_aag32 THEN
         LET l_npq31 = p_npq.npq32
      END IF
      IF p_ahe01 = l_aag33 THEN
         LET l_npq31 = p_npq.npq33
      END IF
      IF p_ahe01 = l_aag34 THEN
         LET l_npq31 = p_npq.npq34
      END IF
      RETURN l_npq31
     #------------------------MOD-C60199--------------------(E)
   END IF
    
END FUNCTION
#FUN-AA0087
