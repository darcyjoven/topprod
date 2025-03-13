# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_ebo_get_cust_data.4gl
# Descriptions...: 提供取得 ERP 客戶資料服務
# Date & Author..: 2008/06/18 by kevin
# Memo...........:
# Modify.........: 新建立    #FUN-860068
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
#FUN-860068
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
#[
# Description....: 提供取得 ERP 客戶資料服務(入口 function)
# Date & Author..: 2008/06/18 by kevin
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ebo_get_cust_data()
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_ebo_get_cust_data_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序    
END FUNCTION
 
 
#[
# Description....: 查詢 ERP 客戶編號
# Date & Author..: 2008/06/18 by kevin
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ebo_get_cust_data_process()
    DEFINE l_occ       RECORD LIKE occ_file.*
    DEFINE l_node      om.DomNode
    DEFINE l_sql       STRING
    DEFINE l_eccode    STRING
    DEFINE l_occ01     LIKE occ_file.occ01
    DEFINE l_cnt       LIKE type_file.num5
    DEFINE l_return    RECORD            #回傳值必須宣告為一個 RECORD 變數
                         WSCode   STRING #回傳的欄位名稱
                       END RECORD
 
    LET l_eccode = aws_ttsrv_getParameter("SendID")   #取由呼叫端呼叫時給予的 SQL Condition
    
    LET l_sql = "SELECT erpcode FROM commmst WHERE type='01' ",
                " AND eccode='", l_eccode ,"'" 
    
    DECLARE customer_curs CURSOR FROM l_sql
    
    OPEN customer_curs
    FETCH customer_curs INTO l_occ01
    CLOSE customer_curs
    
    IF cl_null(l_occ01) THEN
       LET g_status.code = 1
       LET l_return.WSCode="1"
    	 CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
       RETURN
    END IF
    
     SELECT count(*) INTO l_cnt 
       FROM occ_file 
      WHERE occacti = 'Y'
        AND occ01 = l_occ01
    
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF    
  
    IF l_cnt >0 THEN
    	 LET g_status.code = 0
    	 LET l_return.WSCode="0"
    	 CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
    ELSE
    	 LET g_status.code = 2
    	 LET l_return.WSCode="2"
    	 CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
    END IF 
   
END FUNCTION
