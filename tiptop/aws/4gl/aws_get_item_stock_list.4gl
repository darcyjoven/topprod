# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_item_stock_list.4gl
# Descriptions...: 提供取得 ERP 料件庫存相關資料
# Date & Author..: 2008/05/14 by kim (FUN-840012)
# Memo...........:
# Modify.........:
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
           
 
#[
# Description....: 提供取得 ERP 料件庫存相關資料(入口 function)
# Date & Author..: 2008/05/14 by kim  (FUN-840012)
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_item_stock_list()
 
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 查詢 料件庫存 資料                                                         #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_item_stock_list_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 查詢 ERP 料件庫存
# Date & Author..: 2008/05/14 by kim (FUN-840012)
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_item_stock_list_process()
    DEFINE l_img       RECORD LIKE img_file.*
    DEFINE l_sql       STRING
    DEFINE l_wc        STRING
    DEFINE l_i         LIKE type_file.num10
    DEFINE l_node      om.DomNode
    DEFINE l_img01     LIKE img_file.img01                  #料件編號
    DEFINE l_img02     LIKE img_file.img02                  #倉庫編號
    DEFINE l_img03     LIKE img_file.img03                  #儲位    
    DEFINE l_img04     LIKE img_file.img04                  #批號
    DEFINE l_ima108    LIKE ima_file.ima108
 
    LET l_wc = aws_ttsrv_getParameter("condition")   #取由呼叫端呼叫時給予的 SQL Condition
    LET l_img01 = aws_ttsrv_getParameter("img01")    #可空白
    LET l_img02 = aws_ttsrv_getParameter("img02")    #可空白
    LET l_img03 = aws_ttsrv_getParameter("img03")    #可空白
    LET l_img04 = aws_ttsrv_getParameter("img04")    #可空白
 
    IF cl_null(l_wc) THEN LET l_wc=" 1=1" END IF
 
    LET l_sql = "SELECT * ",
                " FROM img_file WHERE ",
                l_wc
 
    IF NOT cl_null(l_img01) THEN
       LET l_sql=l_sql," AND img01='",l_img01,"'"    
    END IF
 
    IF NOT cl_null(l_img02) THEN
       LET l_sql=l_sql," AND img02='",l_img02,"'"
    END IF
 
    IF NOT cl_null(l_img03) THEN
       LET l_sql=l_sql," AND img03='",l_img03,"'"
    END IF
 
    IF NOT cl_null(l_img04) THEN
       LET l_sql=l_sql," AND img04='",l_img04,"'"
    END IF
 
    LET l_sql=l_sql," ORDER BY img01,img02,img03,img04"
 
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
       LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_img), "img_file")   #加入此筆單頭資料至 Respo_receiving_innse 中
    END FOREACH
 
END FUNCTION
