# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_payment_terms_data.4gl
# Descriptions...: 提供ERP收款條件資料服務 
# Date & Author..: 2010/12/24 By Lilan
# Memo...........:
# Modify.........: No:FUN-AC0068 2010/12/24 By Lilan 
#
#}

DATABASE ds

GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此

#[
# Description....: 取得ERP取款條件服務(入口 function)
# Date & Author..: 2010/12/24 By Lilan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_payment_terms_data()

    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP稅別資料                                                         #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_payment_terms_data_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序    
END FUNCTION


#[
# Description....: 查詢 ERP稅別資料
# Date & Author..: 2009/03/21 by sabrina 
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_payment_terms_data_process()
    DEFINE l_oag       RECORD LIKE oag_file.*
    DEFINE l_node      om.DomNode
    DEFINE l_sql       STRING
    DEFINE l_wc        STRING
 
    LET l_wc = aws_ttsrv_getParameter("condition")   #取由呼叫端呼叫時給予的 SQL Condition
   
    IF cl_null(l_wc) THEN
       LET l_wc = " 1=1" 
    END IF
    
    LET l_sql = "SELECT * FROM oag_file WHERE ",
                 l_wc," ORDER BY oag01 "
                 
    DECLARE oag_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    
    FOREACH oag_curs INTO l_oag.*
    	
        LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_oag), "oag_file")   #加入此筆單檔資料至 Response 中
    END FOREACH

    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
END FUNCTION
#FUN-AC0068
