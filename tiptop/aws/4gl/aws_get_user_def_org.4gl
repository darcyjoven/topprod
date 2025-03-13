# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_user_def_org.4gl
# Descriptions...: 提供取得使用者預設的營運中心
# Date & Author..: 2011/09/14 by Abby
# Memo...........:
# Modify.........: 新建立 FUN-B90089
#
#}
 
 
DATABASE ds

#FUN-B90089
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
#[
# Description....: 提供取得使用者預設的營運中心服務(入口 function)
# Date & Author..: 2011/09/14 by Abby
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_user_def_org()
 
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 
 
    #--------------------------------------------------------------------------#
    # 查詢使用者預設的營運中心代碼                                             #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_user_def_org_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 查詢使用者預設的營運中心代碼
# Date & Author..: 2011/09/14 by Abby
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_user_def_org_process()
    DEFINE l_zx    RECORD LIKE zx_file.*
    DEFINE l_node  om.DomNode
    DEFINE l_sql   STRING   
    DEFINE l_wc    STRING
    DEFINE l_return   RECORD                           #回傳值必須宣告為一個 RECORD 變數, 且此 RECORD 需包含所有要回傳的欄位名稱與定義
                         DefOrg  LIKE zx_file.zx08     #回傳的欄位名稱
                      END RECORD
    
    LET l_wc = aws_ttsrv_getParameter("userid")   #取由呼叫端呼叫時給予的 SQL Condition
    
    IF cl_null(l_wc) THEN LET l_wc = ' 1=1' END IF 

    LET l_sql = "SELECT * ",
                "  FROM zx_file ",
                " WHERE zx01 = '",l_wc,"'",
                " ORDER BY zx01"

    DECLARE zx_cur CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF    
    
    OPEN zx_cur
    FETCH zx_cur INTO l_zx.*
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    ELSE
       LET l_return.DefOrg = l_zx.zx08
       CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return)) 
    END IF

END FUNCTION
