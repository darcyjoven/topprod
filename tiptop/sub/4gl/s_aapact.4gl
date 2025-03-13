# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Program name...: s_aapact
# Descriptions...: 檢查會計科目
# Date & Author..: 2003/12/12 By Roger
# Memo...........:
# Usage..........: CALL s_aapact(p_sw,p_actno) RETURNING l_actno
# Input Parameter: p_sw  檢查方式
#                    1.檢查應付系統會計科目
#                    2.檢查總帳系統會計科目
#                  p_actno 科目編號
# Return Code....: l_actno 會計科目名稱
#                  g_errno 檢查結果,不是空白時表示有錯誤
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-730020 07/03/13 By Carrier 會計科目加帳套
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-A50102 10/07/08 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_aapact(p_sw,p_bookno,p_actno)  #No.FUN-730020
   DEFINE p_sw		LIKE type_file.chr1   	#No.FUN-680147 VARCHAR(1)
   DEFINE p_bookno      LIKE aag_file.aag00     #No.FUN-730020
   DEFINE p_actno	LIKE aag_file.aag01 	#No.FUN-680147 VARCHAR(24)
   DEFINE l_aag02 	LIKE aag_file.aag02 	#No.FUN-680147 VARCHAR(30)
   DEFINE l_sql 	LIKE type_file.chr1000	#No.FUN-680147 VARCHAR(1000)
   DEFINE l_aag03 	LIKE aag_file.aag03     #No.FUN-680147 VARCHAR(1)
   DEFINE l_aag07 	LIKE aag_file.aag07     #No.FUN-680147 VARCHAR(1)
   DEFINE l_acti 	LIKE type_file.chr1   	#No.FUN-680147 VARCHAR(1)
 
   LET g_errno = ' '
   IF p_actno = 'MISC' THEN RETURN '' END IF
   LET l_aag02 = NULL
#FUN-A50102-----add start------
   CASE 
      WHEN g_sys="AAP" OR g_sys="CAP"         
           LET g_plant_new = g_apz.apz04p

      WHEN g_sys="ABX" OR g_sys="CBX" OR g_sys="ABT" OR g_sys="CBT"
           OR g_sys="AXR" OR g_sys="CXR" OR g_sys="GXR" 
           OR g_sys="CGXR" 
           LET g_plant_new = g_ooz.ooz02p 
          
      WHEN g_sys="ADM" OR g_sys="CDM" OR g_sys="AXM" OR g_sys="CXM"  
           OR g_sys="ATM" OR g_sys="CTM" OR g_sys="AXS"
           OR g_sys="CXS" OR g_sys="GIS" OR g_sys="CGIS"
           LET g_plant_new = g_oaz.oaz02p 

      WHEN g_sys="AMD" OR g_sys="CMD" OR g_sys="GAP" OR g_sys="CGAP"
           LET g_plant_new = g_apz.apz02p
          
      OTHERWISE
           LET g_plant_new = g_plant 
   END CASE
#FUN-A50102-----add start------ 
   #LET l_sql = "SELECT aag02,aag03,aag07,aagacti FROM ",g_gl_dbs,"aag_file",
   LET l_sql = "SELECT aag02,aag03,aag07,aagacti FROM ",cl_get_target_table(g_plant_new,'aag_file'), #FUN-A50102
               " WHERE aag01 = '",p_actno CLIPPED,"'",
               "   AND aag00 = '",p_bookno CLIPPED,"'"  #No.FUN-730020
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
   PREPARE s_aapact_p FROM l_sql
   DECLARE s_aapact_c CURSOR FOR s_aapact_p
   CASE WHEN p_sw = '1'
		     SELECT aag02,aagacti INTO l_aag02,l_acti FROM aag_file
                    WHERE aag01 = p_actno AND aag00 = p_bookno  #No.FUN-730020
		     CASE WHEN STATUS = 100 LET g_errno = 'aap-060'
                  WHEN STATUS != 0  LET g_errno = STATUS USING '-------'
                  WHEN l_acti='N'   LET g_errno = '9028'
             END CASE
        WHEN p_sw = '2'
		     OPEN s_aapact_c
             FETCH s_aapact_c INTO l_aag02,l_aag03,l_aag07,l_acti
		     CASE WHEN STATUS = 100 LET g_errno = 'aap-060'
                  WHEN STATUS != 0  LET g_errno = STATUS USING '-------'
                  WHEN l_aag03 != '2' LET g_errno = 'agl-177'
                  WHEN l_aag07 = '1'  LET g_errno = 'agl-131'
                  WHEN l_acti='N'   LET g_errno = '9028'
             END CASE
        OTHERWISE LET g_errno = 'aap-061'
   END CASE
   RETURN l_aag02
END FUNCTION
