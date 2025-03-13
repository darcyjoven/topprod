# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Program name...: s_chknpq.4gl
# Descriptions...: 檢查科目部門拒絕或允許的狀況
# Usage..........: CALL s_chkdept(p_no,p_sys,p_npq011)
# Input PARAMETER: p_acct   科目
#                  p_dept   部門
# RETURN Code....: g_errno
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-730020 07/03/13 By Carrier 會計科目加帳套
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.CHI-8C0005 08/12/09 By Sarah 增加s_chkdept_dbs(),參數增加傳遞抓取資料DB
# Modify.........: No.TQC-8C0028 08/12/15 By Sarah "   AND abb00='",p_bookno,"'"應改為"   AND aab00='",p_bookno,"'"
# Modify.........: No.FUN-980020 09/09/01 By douzh GP集團架構修改,sub相關參數
# Modify.........: No.FUN-A50102 10/06/24 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_chkdept(p_aaz72,p_acct,p_dept,p_bookno)  #No.FUN-730020
   DEFINE p_aaz72  LIKE aaz_file.aaz72 
   DEFINE p_acct   LIKE aab_file.aab01 
   DEFINE p_dept   LIKE aab_file.aab02
   DEFINE p_errno  LIKE zaa_file.zaa01           #No.FUN-680147 VARCHAR(10)
   DEFINE p_bookno LIKE aag_file.aag00           #No.FUN-730020
   DEFINE l_cnt    LIKE type_file.num5           #No.FUN-680147 SMALLINT
 
   LET p_errno = ' '
   #-->若科目有部門管理者,應check部門欄位是否為
    IF p_aaz72 = '2' THEN   #允許#
       SELECT COUNT(*) INTO l_cnt FROM aab_file
        WHERE aab01 = p_acct AND aab02 = p_dept
          AND aab00 = p_bookno  #No.FUN-730020
         IF l_cnt = 0 THEN
            LET p_errno = 'agl-209'
         END IF
    ELSE                       #拒絕
       SELECT COUNT(*) INTO l_cnt FROM aab_file 
        WHERE aab01 = p_acct AND aab02 = p_dept  
          AND aab00 = p_bookno  #No.FUN-730020
         IF l_cnt > 0 THEN
            LET p_errno = 'agl-207'
         END IF
    END IF
    RETURN p_errno
END FUNCTION
 
#str CHI-8C0005 add
#FUNCTION s_chkdept_dbs(p_aaz72,p_acct,p_dept,p_bookno,p_dbs)    #FUN-980020 mark
FUNCTION s_chkdept_dbs(p_aaz72,p_acct,p_dept,p_bookno,p_plant)   #FUN-980020
   DEFINE p_aaz72  LIKE aaz_file.aaz72
   DEFINE p_acct   LIKE aab_file.aab01
   DEFINE p_dept   LIKE aab_file.aab02
   DEFINE p_errno  LIKE zaa_file.zaa01           #No.FUN-680147 VARCHAR(10)
   DEFINE p_bookno LIKE aag_file.aag00           #No.FUN-730020
   DEFINE p_dbs    LIKE type_file.chr21
   DEFINE l_cnt    LIKE type_file.num5           #No.FUN-680147 SMALLINT
   DEFINE l_sql    STRING
   DEFINE p_plant  LIKE type_file.chr10          #No.FUN-980020
 
#FUN-980020--begin
   LET g_plant_new = p_plant
   #CALL s_getdbs()           #FUN-A50102
   #LET p_dbs = g_dbs_new     #FUN-A50102
#FUN-980020--end
 
   LET p_errno = ' '
   #-->若科目有部門管理者,應check部門欄位是否為
   IF p_aaz72 = '2' THEN   #允許
      LET l_sql = "SELECT COUNT(*) ",
                  #"  FROM ",p_dbs CLIPPED,"aab_file",
                  "  FROM ",cl_get_target_table(g_plant_new,'aab_file'), #FUN-A50102
                  " WHERE aab01='",p_acct,"'",
                  "   AND aab02='",p_dept,"'",
                  "   AND aab00='",p_bookno,"'"   #TQC-8C0028 mod
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
      PREPARE abb_p1 FROM l_sql
      DECLARE abb_c1 CURSOR FOR abb_p1
      OPEN abb_c1
      FETCH abb_c1 INTO l_cnt
      IF l_cnt = 0 THEN
         LET p_errno = 'agl-209'
      END IF
   ELSE                       #拒絕
      LET l_sql = "SELECT COUNT(*) ",
                  #"  FROM ",p_dbs CLIPPED,"aab_file",
                  "  FROM ",cl_get_target_table(g_plant_new,'aab_file'), #FUN-A50102
                  " WHERE aab01='",p_acct,"'",
                  "   AND aab02='",p_dept,"'",
                  "   AND aab00='",p_bookno,"'"   #TQC-8C0028 mod
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
      PREPARE abb_p2 FROM l_sql
      DECLARE abb_c2 CURSOR FOR abb_p2
      OPEN abb_c2
      FETCH abb_c2 INTO l_cnt
      IF l_cnt > 0 THEN
         LET p_errno = 'agl-207'
      END IF
   END IF
   RETURN p_errno
END FUNCTION
#end CHI-8C0005 add
 
