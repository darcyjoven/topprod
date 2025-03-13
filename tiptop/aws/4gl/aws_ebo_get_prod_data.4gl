# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_ebo_get_prod_data.4gl
# Descriptions...: 提供取得 ERP 客戶品號服務
# Date & Author..: 2008/06/18 by kevin
# Memo...........:
# Modify.........: 新建立    #FUN-860068
# Modify.........: NO.MOD-8B0177 08/11/18 By kevin 查不到離開for
#
#}
 
DATABASE ds
#FUN-860068
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
#[
# Description....: 提供取得 ERP 客戶品號服務(入口 function)
# Date & Author..: 2008/06/18 by kevin
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ebo_get_prod_data()
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶品號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_ebo_get_prod_data_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序    
END FUNCTION
 
 
#[
# Description....: 查詢 ERP 客戶品號
# Date & Author..: 2008/06/18 by kevin
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ebo_get_prod_data_process()    
    DEFINE l_node       om.DomNode
    DEFINE l_sql        STRING
    DEFINE l_eccode     STRING
    DEFINE l_obk03      LIKE obk_file.obk03
    DEFINE l_occ01      LIKE occ_file.occ01
    DEFINE l_lineitemno STRING 
    DEFINE l_cnt        LIKE type_file.num5
    DEFINE l_cnt1       LIKE type_file.num5
    DEFINE l_i          LIKE type_file.num5   #筆數
    DEFINE l_return     RECORD                #回傳值必須宣告為一個 RECORD 變數
                          WSCode      STRING, #回傳的欄位名稱
                          LineItemNo  STRING
                        END RECORD
                        
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("tmp_file")                       
    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF
    
    FOR l_i = 1 TO l_cnt1       
        LET l_node = aws_ttsrv_getMasterRecord(l_i, "tmp_file")        #目前處理單檔的 XML 節點 
               
        LET l_eccode = aws_ttsrv_getRecordField(l_node, "SendID")      #客戶編號
        LET l_obk03  = aws_ttsrv_getRecordField(l_node, "PartNo_BY")             #品號
        LET l_lineitemno = aws_ttsrv_getRecordField(l_node, "LineItemNo")
        
        IF cl_null(l_eccode) OR cl_null(l_obk03) THEN #MOD-8B0177
           LET g_status.code = "aws-101"
           RETURN
        END IF
        
        LET l_sql = "SELECT erpcode FROM commmst WHERE type='01' ",
                    " AND eccode='", l_eccode ,"'"
        
        DECLARE customer_curs CURSOR FROM l_sql
        
        OPEN customer_curs
        FETCH customer_curs INTO l_occ01
        CLOSE customer_curs
        
        IF cl_null(l_occ01) THEN
           LET g_status.code = 1
           LET l_return.WSCode="1"
           LET l_return.LineItemNo=l_lineitemno
           LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_return), "tmp_file")
           RETURN
        END IF
        
         SELECT count(*) INTO l_cnt 
           FROM obk_file
          WHERE obk02 = l_occ01
            AND obk03 = l_obk03
        
        IF SQLCA.SQLCODE THEN
           LET g_status.code = SQLCA.SQLCODE
           LET g_status.sqlcode = SQLCA.SQLCODE
           RETURN
        END IF    
        
        IF l_cnt >0 THEN
           LET g_status.code = 0
           LET l_return.WSCode="0"
           LET l_return.LineItemNo=l_lineitemno
               
           LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_return), "tmp_file")        	 
        ELSE
           LET g_status.code = 2
           LET l_return.WSCode="2"
           LET l_return.LineItemNo=l_lineitemno
        	 
           LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_return), "tmp_file")
           EXIT FOR
        END IF 
    END FOR
END FUNCTION
