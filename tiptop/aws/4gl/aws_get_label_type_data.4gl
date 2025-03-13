# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_label_type_data.4gl
# Descriptions...: 提供取得 ERP 盤點標籤別相關資料
# Date & Author..: 2008/05/19 by kim (FUN-840012)
# Memo...........:
# Modify.........:
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
           
 
#[
# Description....: 提供取得 ERP 盤點標籤別相關資料(入口 function)
# Date & Author..: 2008/05/19 by kim  (FUN-840012)
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_label_type_data()
 
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 查詢 盤點標籤別 資料                                                     #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_label_type_data_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 查詢 ERP 盤點標籤別
# Date & Author..: 2008/05/19 by kim (FUN-840012)
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_label_type_data_process()
    DEFINE l_pib       RECORD LIKE pib_file.*
    DEFINE l_sql       STRING
    DEFINE l_wc        STRING
    DEFINE l_i         LIKE type_file.num10
    DEFINE l_node      om.DomNode
 
    LET l_wc = aws_ttsrv_getParameter("condition")   #取由呼叫端呼叫時給予的 SQL Condition
    IF cl_null(l_wc) THEN LET l_wc=" 1=1" END IF
    LET l_sql = "SELECT * FROM pib_file WHERE ",
                l_wc," AND pibacti='Y' ",
                " ORDER BY pib01"
 
    DECLARE pib_curs CURSOR FROM l_sql
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF  
 
    FOREACH pib_curs INTO l_pib.*
       IF SQLCA.SQLCODE THEN
          LET g_status.code = SQLCA.SQLCODE
          LET g_status.sqlcode = SQLCA.SQLCODE
          RETURN
       END IF  
       LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_pib), "pib_file")   #加入此筆單檔資料至 Response 中
 
    END FOREACH
    
END FUNCTION
