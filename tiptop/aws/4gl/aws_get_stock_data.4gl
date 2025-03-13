# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_stock_data.4gl
# Descriptions...: 提供取得 ERP 倉庫/儲位資料服務
# Date & Author..: 2008/04/08 by kim
# Memo...........:
# Modify.........: 新建立 FUN-840012
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D40103 13/05/09 By lixh1 增加儲位有效性檢查
 
DATABASE ds
 
#FUN-840012
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
 
#[
# Description....: 提供取得 ERP 倉庫/儲位資料服務(入口 function)
# Date & Author..: 2008/04/08 by kim
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_stock_data()
 
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 倉庫/儲位編號資料                                               #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_stock_data_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 查詢 ERP 倉庫/儲位編號資料
# Date & Author..: 2008/04/08 by kim
# Parameter......: 料號-若有傳料號,則回傳img_file的倉/儲/批,若無傳料號,則回傳ime_file的所有資料
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_stock_data_process()
    DEFINE l_wc    STRING
    DEFINE l_sql   STRING
    DEFINE l_node  om.DomNode
    DEFINE l_item  LIKE ima_file.ima01
    DEFINE l_ime RECORD LIKE ime_file.*
    DEFINE l_img RECORD
                      img02 LIKE img_file.img02,
                      img03 LIKE img_file.img03,
                      img04 LIKE img_file.img04
                   END RECORD
 
    LET l_item = aws_ttsrv_getParameter("item")   #取由呼叫端呼叫時給予的料號
    LET l_wc = aws_ttsrv_getParameter("condition")   #取由呼叫端呼叫時給予的 SQL Condition
    IF cl_null(l_wc) THEN LET l_wc=" 1=1" END IF
    
    IF cl_null(l_item) THEN
       LET l_sql = "SELECT * FROM ime_file WHERE ",
                    l_wc, 
                     " AND imeacti = 'Y' ",   #FUN-D40103
                    " AND ime05 = 'Y' ORDER BY ime01,ime02"
       
       DECLARE ime_curs CURSOR FROM l_sql 
       IF SQLCA.SQLCODE THEN
          LET g_status.code = SQLCA.SQLCODE
          LET g_status.sqlcode = SQLCA.SQLCODE
          RETURN
       END IF
       
       FOREACH ime_curs INTO l_ime.*
          IF SQLCA.SQLCODE THEN
             LET g_status.code = SQLCA.SQLCODE
             LET g_status.sqlcode = SQLCA.SQLCODE
             RETURN
          END IF
          LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_ime), "ime_file")   #加入此筆單檔資料至 Response 中        
       
       END FOREACH
    ELSE
       LET l_sql = "SELECT DISTINCT img02,img03,img04 FROM img_file WHERE ",
                    l_wc,
                    " AND img01 = '",l_item,"' ",
                    " AND img23='Y' ",
                    " ORDER BY img02,img03,img04"
       
       DECLARE img_curs CURSOR FROM l_sql 
       IF SQLCA.SQLCODE THEN
          LET g_status.code = SQLCA.SQLCODE
          LET g_status.sqlcode = SQLCA.SQLCODE
          RETURN
       END IF
       
       FOREACH img_curs INTO l_img.*
          IF SQLCA.SQLCODE THEN
             LET g_status.code = SQLCA.SQLCODE
             LET g_status.sqlcode = SQLCA.SQLCODE
             RETURN
          END IF
          LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_img), "img_file")   #加入此筆單檔資料至 Response 中        
       
       END FOREACH
    END IF
END FUNCTION
