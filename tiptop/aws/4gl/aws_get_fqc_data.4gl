# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_fqc_data.4gl
# Descriptions...: 提供取得 ERP (可入庫)FQC單相關資料
# Date & Author..: 2008/04/17 by kim (FUN-840012)
# Memo...........:
# Modify.........:
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
           
 
#[
# Description....: 提供取得 ERP (可入庫)FQC單相關資料(入口 function)
# Date & Author..: 2008/04/17 by kim  (FUN-840012)
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_fqc_data()
 
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 查詢 (可入庫)FQC單 資料                                                  #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_fqc_data_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 查詢 ERP (可入庫)FQC單
# Date & Author..: 2008/04/17 by kim (FUN-840012)
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_fqc_data_process()
    DEFINE l_qcf       RECORD LIKE qcf_file.*
    DEFINE l_sql       STRING
    DEFINE l_wc        STRING
    DEFINE l_i         LIKE type_file.num10
    DEFINE l_node      om.DomNode
    DEFINE l_nvl       STRING
 
 
    LET l_wc = aws_ttsrv_getParameter("condition")   #取由呼叫端呼叫時給予的 SQL Condition
    IF cl_null(l_wc) THEN LET l_wc=" 1=1" END IF
    IF cl_DB_GET_DATABASE_TYPE()="MSV" THEN
       LET l_nvl="isnull"
    ELSE
       LET l_nvl="nvl"
    END IF
    LET l_sql = "SELECT * FROM qcf_file WHERE ",
                l_wc,
                " AND ( qcf03 IS NULL OR qcf03 = ' ') ",
                " AND qcfacti='Y' AND qcf09 <> '2' ",
                " AND qcf14='Y' ",
                " AND qcf091>",l_nvl,"(",
                " (SELECT SUM(sfv09) FROM sfu_file,sfv_file ",
                " WHERE sfu01=sfv01 AND sfv17=qcf01 AND sfu00 = '1' AND sfuconf<>'X')",
                ",0) ",
                " ORDER BY qcf01"
                 
    DECLARE qcf_curs CURSOR FROM l_sql
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF  
 
    FOREACH qcf_curs INTO l_qcf.*
       IF SQLCA.SQLCODE THEN
          LET g_status.code = SQLCA.SQLCODE
          LET g_status.sqlcode = SQLCA.SQLCODE
          RETURN
       END IF  
       LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_qcf), "qcf_file")   #加入此筆單檔資料至 Response 中
 
    END FOREACH
    
END FUNCTION
