# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_invoice_type_list.4gl
# Descriptions...: 提供取得 ERP 發票別清單服務
# Date & Author..: 2011/10/03 by Abby
# Memo...........:
# Modify.........: 新建立 FUN-BA0002
#
#}
 
 
DATABASE ds
 
#FUN-BA0002
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
 
#[
# Description....: 提供取得 ERP 發票別清單服務(入口 function)
# Date & Author..: 2011/10/03 by Abby
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_invoice_type_list()
 
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 發票別清單                                                      #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_invoice_type_list_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 查詢 ERP 發票別清單
# Date & Author..: 2011/10/03 by Abby
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_invoice_type_list_process()
    DEFINE l_oom   RECORD 
                      oom03 LIKE oom_file.oom03
                   END RECORD
    DEFINE l_wc    STRING
    DEFINE l_sql   STRING
    DEFINE l_node  om.DomNode
 
   
    LET l_wc = aws_ttsrv_getParameter("condition")   #取由呼叫端呼叫時給予的 SQL Condition
    
    LET l_sql = "SELECT DISTINCT oom03 FROM oom_file WHERE ",
                 l_wc 
 
    DECLARE oom_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
 
    FOREACH oom_curs INTO l_oom.oom03
    
        LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_oom), "oom_file")   #加入此筆單檔資料至 Response 中        
    
    END FOREACH
    
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
END FUNCTION
