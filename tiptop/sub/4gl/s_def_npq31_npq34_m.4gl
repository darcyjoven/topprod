# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_def_npq31_npq34_m.4gl
# Descriptions...: 依彈性設定預設異動碼值(跨庫)
# Date & Author..: 11/01/25 FUN-AA0087 BY chenmoyan
# Modify.........: No.TQC-B30030 11/03/03 By yinhy 32區鏈接報錯，過單到32區
# Modify.........: No.MOD-C60199 12/06/25 By Polly 若已在彈性異動碼設定就不應再重新給予

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_def_npq31_npq34_m(p_npq,p_bookno,p_plant) #TQC-B30030
DEFINE p_npq      RECORD LIKE npq_file.*
DEFINE p_bookno   LIKE aag_file.aag00
DEFINE p_plant      LIKE type_file.chr21
DEFINE l_aag      RECORD LIKE aag_file.*
DEFINE l_npq31    LIKE npq_file.npq31
DEFINE l_npq32    LIKE npq_file.npq32
DEFINE l_npq33    LIKE npq_file.npq33
DEFINE l_npq34    LIKE npq_file.npq34
DEFINE l_sql      STRING

   WHENEVER ERROR CALL cl_err_msg_log
   
   LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'aag_file'),
               " WHERE aag01 = '",p_npq.npq03,"'",
               "   AND aag00 = '",p_bookno,"'"
	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE aag_p FROM l_sql                                                                                                      
   DECLARE aag_c CURSOR FOR aag_p
   OPEN aag_c
   FETCH aag_c INTO l_aag.*
      
   IF NOT cl_null(l_aag.aag31) THEN
      CALL s_def_npq31_34_m(l_aag.aag31,p_npq.*,p_plant) RETURNING l_npq31
   END IF
   
   IF NOT cl_null(l_aag.aag32) THEN
      CALL s_def_npq31_34_m(l_aag.aag32,p_npq.*,p_plant) RETURNING l_npq32
   END IF
   
   IF NOT cl_null(l_aag.aag33) THEN
      CALL s_def_npq31_34_m(l_aag.aag33,p_npq.*,p_plant) RETURNING l_npq33
   END IF
   
   IF NOT cl_null(l_aag.aag34) THEN
      CALL s_def_npq31_34_m(l_aag.aag34,p_npq.*,p_plant) RETURNING l_npq34
   END IF
   
   RETURN l_npq31,l_npq32,l_npq33,l_npq34

END FUNCTION

FUNCTION s_def_npq31_34_m(p_ahe01,p_npq,p_plant)
DEFINE p_ahe01    LIKE ahe_file.ahe01
DEFINE p_npq      RECORD LIKE npq_file.*
DEFINE p_plant      LIKE type_file.chr21
DEFINE l_ahe      RECORD LIKE ahe_file.*
DEFINE l_npq31    LIKE npq_file.npq31
DEFINE l_str      STRING
DEFINE l_sql      STRING
DEFINE l_ahe09    LIKE ahe_file.ahe09
DEFINE l_aag31    LIKE aag_file.aag31     #MOD-C60199 add
DEFINE l_aag32    LIKE aag_file.aag32     #MOD-C60199 add
DEFINE l_aag33    LIKE aag_file.aag33     #MOD-C60199 add
DEFINE l_aag34    LIKE aag_file.aag34     #MOD-C60199 add
DEFINE cl_sql     STRING                  #MOD-C60199 add
DEFINE cl_sql1    STRING                  #MOD-C60199 add
DEFINE l_aza81    LIKE aza_file.aza81     #MOD-C60199 add

   LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'ahe_file'),
               " WHERE ahe01 = '",p_ahe01,"'"
	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE ahe_p FROM l_sql
   DECLARE ahe_c CURSOR FOR ahe_p
   OPEN ahe_c
   FETCH ahe_c INTO l_ahe.*     
     
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
     #--------------------------------MOD-C60199-----------------(S)
     #RETURN ''
      LET cl_sql = "SELECT aza81 FROM ",cl_get_target_table(p_plant,'aza_file')
      CALL cl_replace_sqldb(cl_sql) RETURNING cl_sql
      CALL cl_parse_qry_sql(cl_sql,p_plant) RETURNING cl_sql
      PREPARE cc FROM cl_sql
      DECLARE cc_1 CURSOR FOR cc
      OPEN cc_1
      FETCH cc_1 INTO l_aza81

      LET cl_sql1 = "SELECT aag31,aag32,aag33,aag34 FROM ",cl_get_target_table(p_plant,'aag_file'),
                    " WHERE aag01 = '",p_npq.npq03,"'",
                    "   AND aag00 = '",l_aza81,"'"
      CALL cl_replace_sqldb(cl_sql1) RETURNING cl_sql1
      CALL cl_parse_qry_sql(cl_sql1,p_plant) RETURNING cl_sql1
      PREPARE cc1 FROM cl_sql1
      DECLARE cc_11 CURSOR FOR cc1
      OPEN cc_11
      FETCH cc_11 INTO l_aag31,l_aag32,l_aag33,l_aag34
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
     #--------------------------------MOD-C60199-----------------(E)
   END IF
    
END FUNCTION
#FUN-AA0087
