# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_voucher_document_data.4gl
# Descriptions...: 提供取得 ERP 傳票單別資料服務
# Date & Author..: 2009/11/05 by Mandy
# Memo...........:
# Modify.........: 新建立 FUN-9A0090
# Modify.........: No.FUN-AA0022 10/10/13 By Mandy HR GP5.2 追版
#
#}

DATABASE ds

#FUN-9A0090

GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此

DEFINE g_table     STRING

#[
# Description....: 提供取得 ERP 傳票單別資料服務(入口 function)
# Date & Author..: 2009/11/05 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_voucher_document_data()
    
    WHENEVER ERROR CONTINUE
    
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 傳票單別編號                                                        #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_voucher_document_data_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序    
END FUNCTION


#[
# Description....: 查詢 ERP 傳票單別編號
# Date & Author..: 2009/11/05 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_voucher_document_data_process()
    DEFINE l_aac       RECORD LIKE aac_file.*
    DEFINE l_node      om.DomNode
    DEFINE l_sql       STRING
    DEFINE l_wc        STRING
 
    LET l_wc = aws_ttsrv_getParameter("condition")   #取由呼叫端呼叫時給予的 SQL Condition
   
    IF cl_null(l_wc) THEN
       LET l_wc = " 1=1" 
    END IF
    
    LET l_sql="SELECT * FROM aac_file WHERE ",l_wc,
              " ORDER BY aac01"
  
    DECLARE aac_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    
    FOREACH aac_curs INTO l_aac.*
        
       LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_aac), "aac_file")   #加入此筆單檔資料至 Response 中
    END FOREACH

    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
END FUNCTION
#FUN-AA0022
