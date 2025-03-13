# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Program Name...:s_reason_code.4gl
# Descriptions...:抓去理由碼默認值
# Date & Author..: NO.FUN-CB0087 2012/11/28 By xujing
# Input Parameter:p_no       異動單號
#                 p_no1      來源單號
#                 p_ggc03    分群碼
#                 p_ggc04    料號
#                 p_ggc05    倉庫編號
#                 p_ggc06    員工編號
#                 p_ggc07    部門編號
# Modify.........: No.TQC-D20042 13/02/25 By xianghui 多角流程撈取當前營運中心的理由碼

DATABASE ds
GLOBALS "../../config/top.global"

FUNCTION s_reason_code(p_no,p_no1,p_ggc03,p_ggc04,p_ggc05,p_ggc06,p_ggc07)
DEFINE l_ggc01   LIKE ggc_file.ggc01    #異動單據單別
DEFINE l_ggc02   LIKE ggc_file.ggc02    #來源單據單別
DEFINE l_ggc08   LIKE ggc_file.ggc08    #理由碼
DEFINE p_no      STRING,  
       p_no1     STRING,
       p_ggc03   LIKE ggc_file.ggc03,
       p_ggc04   LIKE ggc_file.ggc04,
       p_ggc05   STRING,
       p_ggc06   LIKE ggc_file.ggc06,
       p_ggc07   LIKE ggc_file.ggc07
DEFINE g_sql     STRING

CALL get_no(p_no,p_no1) RETURNING l_ggc01,l_ggc02

LET g_sql = "SELECT ggc08 FROM ggc_file WHERE 1=1"
IF NOT cl_null(l_ggc01) THEN LET g_sql = g_sql," AND (ggc01='",l_ggc01 CLIPPED,"' OR ggc01='*') " END IF 
IF NOT cl_null(l_ggc02) THEN LET g_sql = g_sql," AND (ggc02='",l_ggc02 CLIPPED,"' OR ggc02='*') " END IF 
IF NOT cl_null(p_ggc04) THEN
   IF cl_null(p_ggc03) THEN SELECT ima06 INTO p_ggc03 FROM ima_file WHERE ima01 = p_ggc04 END IF
   LET g_sql = g_sql," AND (ggc04='",p_ggc04 CLIPPED,"' OR ggc04='*') "
END IF 
IF NOT cl_null(p_ggc03) THEN LET g_sql = g_sql," AND (ggc03='",p_ggc03 CLIPPED,"' OR ggc03='*') " END IF 
IF NOT cl_null(p_ggc05) THEN LET g_sql = g_sql," AND (ggc05 IN('",p_ggc05 CLIPPED,"') OR ggc05='*') " END IF 
IF NOT cl_null(p_ggc06) THEN LET g_sql = g_sql," AND (ggc06='",p_ggc06 CLIPPED,"' OR ggc06='*') " END IF 
IF NOT cl_null(p_ggc07) THEN LET g_sql = g_sql," AND (ggc07='",p_ggc07 CLIPPED,"' OR ggc07='*') " END IF 
LET g_sql = g_sql," AND ggc09 = 'Y' AND ggcacti='Y'"

PREPARE ggc_prep FROM g_sql
DECLARE ggc_curs SCROLL CURSOR  FOR ggc_prep
OPEN ggc_curs
FETCH FIRST ggc_curs INTO l_ggc08

RETURN l_ggc08
END FUNCTION 

FUNCTION get_str(l_no)                     #根據aoos010中單別規則設置抓去單別
DEFINE l_no  STRING 
DEFINE l_num LIKE type_file.num5 
DEFINE l_str STRING 
CASE g_aza.aza41
     WHEN '1'
        LET l_str = l_no.subString(1,3)
     WHEN '2'
        LET l_str = l_no.subString(1,4)
     WHEN '3'
        LET l_str = l_no.subString(1,5)
END CASE 
RETURN l_str
END FUNCTION

FUNCTION get_no(p_no,p_no1)
DEFINE p_no      STRING,  
       p_no1     STRING
DEFINE l_ggc01   LIKE ggc_file.ggc01    #異動單據單別
DEFINE l_ggc02   LIKE ggc_file.ggc02    #來源單據單別
DEFINE li_inx    LIKE type_file.num5
LET li_inx = p_no.getIndexOf("-",1)    #獲取異動單號中'-'的位置
IF li_inx <= 0 THEN
   CALL get_str(p_no) RETURNING l_ggc01      #
ELSE
   CALL s_get_doc_no(p_no) RETURNING l_ggc01
END IF

LET li_inx = p_no1.getIndexOf("-",1)   #獲取來源單號中'-'的位置
IF li_inx <= 0 THEN
   CALL get_str(p_no1) RETURNING l_ggc02
ELSE
   CALL s_get_doc_no(p_no1) RETURNING l_ggc02
END IF

RETURN l_ggc01,l_ggc02
END FUNCTION

# FUNCTION Name...:s_get_where()
# Descriptions...:獲取控管理由碼的條件
# Input Parameter:p_no       異動單號
#                 p_no1      來源單號
#                 p_ggc03    分群碼
#                 p_ggc04    料號
#                 p_ggc05    倉庫編號
#                 p_ggc06    員工編號
#                 p_ggc07    部門編號
FUNCTION s_get_where(p_no,p_no1,p_ggc03,p_ggc04,p_ggc05,p_ggc06,p_ggc07)
DEFINE l_ggc01   LIKE ggc_file.ggc01    #異動單據單別
DEFINE l_ggc02   LIKE ggc_file.ggc02    #來源單據單別
DEFINE p_no      STRING,
       p_no1     STRING,
       p_ggc03   LIKE ggc_file.ggc03,
       p_ggc04   LIKE ggc_file.ggc04,
       p_ggc05   STRING,
       p_ggc06   LIKE ggc_file.ggc06,
       p_ggc07   LIKE ggc_file.ggc07
DEFINE l_where   STRING
DEFINE l_sql     STRING
DEFINE l_n       LIKE type_file.num5

CALL get_no(p_no,p_no1) RETURNING l_ggc01,l_ggc02

LET l_where = " 1=1"
IF NOT cl_null(l_ggc01) THEN LET l_where = l_where," AND (ggc01='",l_ggc01 CLIPPED,"' OR ggc01='*') " END IF
IF NOT cl_null(l_ggc02) THEN LET l_where = l_where," AND (ggc02='",l_ggc02 CLIPPED,"' OR ggc02='*') " END IF
IF NOT cl_null(p_ggc04) THEN
   IF cl_null(p_ggc03) THEN SELECT ima06 INTO p_ggc03 FROM ima_file WHERE ima01 = p_ggc04 END IF
   LET l_where = l_where," AND (ggc04='",p_ggc04 CLIPPED,"' OR ggc04='*') "
END IF
IF NOT cl_null(p_ggc03) THEN LET l_where = l_where," AND (ggc03='",p_ggc03 CLIPPED,"' OR ggc03='*')" END IF
IF NOT cl_null(p_ggc05) THEN LET l_where = l_where," AND (ggc05 IN('",p_ggc05 CLIPPED,"') OR ggc05='*') " END IF
IF NOT cl_null(p_ggc06) THEN LET l_where = l_where," AND (ggc06='",p_ggc06 CLIPPED,"' OR ggc06='*') " END IF
IF NOT cl_null(p_ggc07) THEN LET l_where = l_where," AND (ggc07='",p_ggc07 CLIPPED,"' OR ggc07='*') " END IF
LET l_where = l_where," AND ggcacti='Y'"

LET l_n = 0
LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ",l_where
PREPARE ggc_pre FROM l_sql
EXECUTE ggc_pre INTO l_n

IF l_n > 0 THEN
   RETURN TRUE,l_where
ELSE
   RETURN FALSE,l_where
END IF
END FUNCTION  

#TQC-D20042---add---str---
FUNCTION s_reason_code1(p_no,p_no1,p_ggc03,p_ggc04,p_ggc05,p_ggc06,p_ggc07,p_plant)
DEFINE l_ggc01   LIKE ggc_file.ggc01    #異動單據單別
DEFINE l_ggc02   LIKE ggc_file.ggc02    #來源單據單別
DEFINE l_ggc08   LIKE ggc_file.ggc08    #理由碼
DEFINE p_no      STRING,
       p_no1     STRING,
       p_ggc03   LIKE ggc_file.ggc03,
       p_ggc04   LIKE ggc_file.ggc04,
       p_ggc05   STRING,
       p_ggc06   LIKE ggc_file.ggc06,
       p_ggc07   LIKE ggc_file.ggc07,
       p_plant   LIKE type_file.chr21
DEFINE g_sql     STRING

CALL get_no(p_no,p_no1) RETURNING l_ggc01,l_ggc02

LET g_sql = "SELECT ggc08 FROM ",cl_get_target_table(p_plant,'ggc_file')," WHERE 1=1"
IF NOT cl_null(l_ggc01) THEN LET g_sql = g_sql," AND (ggc01='",l_ggc01 CLIPPED,"' OR ggc01='*') " END IF
IF NOT cl_null(l_ggc02) THEN LET g_sql = g_sql," AND (ggc02='",l_ggc02 CLIPPED,"' OR ggc02='*') " END IF
IF NOT cl_null(p_ggc04) THEN
   IF cl_null(p_ggc03) THEN SELECT ima06 INTO p_ggc03 FROM ima_file WHERE ima01 = p_ggc04 END IF
   LET g_sql = g_sql," AND (ggc04='",p_ggc04 CLIPPED,"' OR ggc04='*') "
END IF
IF NOT cl_null(p_ggc03) THEN LET g_sql = g_sql," AND (ggc03='",p_ggc03 CLIPPED,"' OR ggc03='*') " END IF
IF NOT cl_null(p_ggc05) THEN LET g_sql = g_sql," AND (ggc05 IN('",p_ggc05 CLIPPED,"') OR ggc05='*') " END IF
IF NOT cl_null(p_ggc06) THEN LET g_sql = g_sql," AND (ggc06='",p_ggc06 CLIPPED,"' OR ggc06='*') " END IF
IF NOT cl_null(p_ggc07) THEN LET g_sql = g_sql," AND (ggc07='",p_ggc07 CLIPPED,"' OR ggc07='*') " END IF
LET g_sql = g_sql," AND ggc09 = 'Y' AND ggcacti='Y'"

PREPARE ggc_prep1 FROM g_sql
DECLARE ggc_curs1 SCROLL CURSOR  FOR ggc_prep1
OPEN ggc_curs1
FETCH FIRST ggc_curs1 INTO l_ggc08

RETURN l_ggc08
END FUNCTION
#TQC-D20042---add---end--

#FUN-CB0087

