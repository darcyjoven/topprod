# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_data_count.4gl
# Descriptions...: 提供取得 ERP 資料總筆數服務
# Date & Author..: 2011/08/31 by Mandy
# Memo...........:
# Modify.........: 新建立 FUN-B80191
# Modify.........: No.FUN-B90089 12/08/27 By Abby GP5.25追版至GP5.3
#
#}
 
DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
 
#[
# Description....: 提供取得 ERP 資料總筆數服務(入口 function)
# Date & Author..: 2011/08/31 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_data_count()
 
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 編號資料                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_data_count_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 查詢 ERP 編號資料
# Date & Author..: 2011/08/31 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_data_count_process()
    DEFINE l_count LIKE type_file.num10
    DEFINE l_table STRING
    DEFINE l_wc    STRING
    DEFINE l_sql   STRING
    DEFINE l_node  om.DomNode
    DEFINE l_return   RECORD                           #回傳值必須宣告為一個 RECORD 變數, 且此 RECORD 需包含所有要回傳的欄位名稱與定義
                         count   LIKE type_file.num10  #回傳的欄位名稱
                      END RECORD
 
   
    LET l_wc = aws_ttsrv_getParameter("condition")   #取由呼叫端呼叫時給予的 SQL Condition
    LET l_table = aws_ttsrv_getParameter("table")    #要取得那個TABLE的資料總筆數
    IF cl_null(l_wc) THEN LET l_wc = ' 1=1' END IF
    
    LET l_sql = "SELECT COUNT(*) FROM ",l_table CLIPPED,
                " WHERE ",l_wc 
 
    DECLARE ima_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF

    OPEN ima_curs
    FETCH ima_curs INTO l_count
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    ELSE
       LET l_return.count = l_count
       CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))   #回傳資料總筆數
    END IF
END FUNCTION
#FUN-B80191
#FUN-B90089
