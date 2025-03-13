# Prog. Version..: '5.30.03-12.09.18(00000)'     #
#
# Program Name...: s_code.4gl
# Descriptions...: 取得代码组内容(hrag_file)
# Date & Author..: 13/04/15 By yangjian 
# Usage..........: CALL s_code(p_hrag01,p_hrag06) RETURNING l_hrag.*
# Input Parameter: p_hrag01   代码组编号 
#                  p_hrag06   代码项编号
# Return Code....: l_hrag.*   代码组资料
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_code(p_hrag01,p_hrag06)
DEFINE
    p_hrag01        LIKE hrag_file.hrag01,
    p_hrag06        LIKE hrag_file.hrag06,
    l_hrag          RECORD  LIKE hrag_file.*,
    g_sql           STRING
 
    WHENEVER ERROR CALL cl_err_msg_log
    
    LET g_errno = ''
    INITIALIZE l_hrag.* TO NULL 

    LET g_sql = "SELECT hrag_file.* FROM hrag_file ",
                " WHERE hrag01 = ? ",
                "   AND hrag06 = ? "
    PREPARE hrag_prep FROM g_sql
    EXECUTE hrag_prep USING p_hrag01,p_hrag06 INTO l_hrag.*

    CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='ghr-032'
                                INITIALIZE l_hrag.* TO NULL
       WHEN l_hrag.hragacti = 'N'    LET g_errno='9028'                          
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
    END CASE

    RETURN l_hrag.*
    
END FUNCTION



