# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_mfg_document.4gl
# Descriptions...: 提供他系統呼叫以取得 TIPTOP 製造管理系統單據別及會計年月
# Date & Author..: 2008/04/08 by kim (FUN-840012)
# Memo...........:
# Modify.........:
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
           
 
#[
# Description....: 提供他系統呼叫以取得 TIPTOP 製造管理系統單據別及會計年月(入口 function)
# Date & Author..: 2008/04/08 by kim  (FUN-840012)
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_mfg_document()
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 提供他系統呼叫以取得 TIPTOP 製造管理系統單據別及會計年月                 #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_mfg_document_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 查詢 ERP po 
# Date & Author..: 2008/04/08 by kim (FUN-840012)
# Parameter......: 系統別,單據性質 (採購收貨單:p_smysys='apm',p_smykind='3')
# Return.........: 符合條件的單據代碼&會計年度&會計期別
# Memo...........: 
# Modify.........:
#
#]
FUNCTION aws_get_mfg_document_process()
    DEFINE l_smysys    LIKE smy_file.smysys
    DEFINE l_smykind   LIKE smy_file.smykind
    DEFINE l_smy       RECORD LIKE smy_file.*
    DEFINE l_sql       STRING
    DEFINE l_wc        STRING
    DEFINE l_i         LIKE type_file.num10
    DEFINE l_node      om.DomNode
    DEFINE l_return    RECORD             #回傳值必須宣告為一個 RECORD 變數, 且此 RECORD 需包含所有要回傳的欄位名稱與定義
                          sma51 LIKE sma_file.sma51,   #回傳的欄位名稱
                          sma52 LIKE sma_file.sma52,   #回傳的欄位名稱
                          sma53 LIKE sma_file.sma53    #回傳的欄位名稱
                       END RECORD
 
 
    LET l_wc = aws_ttsrv_getParameter("condition")   #取由呼叫端呼叫時給予的 SQL Condition
    LET l_smysys = aws_ttsrv_getParameter("sys")
    LET l_smykind = aws_ttsrv_getParameter("kind")
    IF cl_null(l_wc) THEN LET l_wc=" 1=1" END IF
    LET l_sql = "SELECT * FROM smy_file WHERE ",
                l_wc,
                " AND smysys = '",l_smysys,"' ",
                " AND smykind = '",l_smykind,"' ",
                " AND smyacti = 'Y' ",
                " ORDER BY smyslip"
 
    DECLARE smy_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF  
 
   FOREACH smy_curs INTO l_smy.*
       IF SQLCA.SQLCODE THEN
          LET g_status.code = SQLCA.SQLCODE
          LET g_status.sqlcode = SQLCA.SQLCODE
          RETURN
       END IF
   
       LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_smy), "smy_file")   #加入此筆單檔資料至 Response 中
   
   END FOREACH
   
   SELECT sma51,sma52,sma53 INTO l_return.sma51,l_return.sma52,l_return.sma53
     FROM sma_file WHERE sma00='0'
   CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return)) 
END FUNCTION
