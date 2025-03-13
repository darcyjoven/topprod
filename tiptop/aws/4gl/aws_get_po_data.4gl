# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_po_data.4gl
# Descriptions...: 提供取得 ERP po 資料服務
# Date & Author..: 2008/04/03 by kim (FUN-840012)
# Memo...........:
# Modify.........:
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
           
 
#[
# Description....: 提供取得 ERP po 資料服務(入口 function)
# Date & Author..: 2008/04/03 by kim  (FUN-840012)
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_po_data()
 
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP po 資料                                                         #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_po_data_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 查詢 ERP po 
# Date & Author..: 2008/04/03 by kim (FUN-840012)
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_po_data_process()
    DEFINE l_pmm       RECORD LIKE pmm_file.*
    DEFINE l_pmn       DYNAMIC ARRAY OF RECORD LIKE pmn_file.*
    DEFINE l_sql       STRING
    DEFINE l_wc        STRING
    DEFINE l_i         LIKE type_file.num10
    DEFINE l_node      om.DomNode
 
 
    LET l_wc = aws_ttsrv_getParameter("condition")   #取由呼叫端呼叫時給予的 SQL Condition
    IF cl_null(l_wc) THEN LET l_wc=" 1=1" END IF
    LET l_sql = "SELECT * FROM pmm_file WHERE ",
                l_wc,
                " AND pmm18 = 'Y' ",
                " AND pmm25 = '2' ",
                " AND pmmacti = 'Y' ",
                " ORDER BY pmm01"
                 
    DECLARE pmm_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF  
 
    LET l_sql = "SELECT * FROM pmn_file WHERE pmn01 = ? AND pmn16='2' ",
               #" AND (pmn20-pmn50+pmn55>0) ORDER BY pmn01,pmn02"
                " AND (pmn16 IN ('0','1','2','X')) ORDER BY pmn01,pmn02"
    DECLARE pmn_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
   
    FOREACH pmm_curs INTO l_pmm.*
      
       CALL l_pmn.clear()
       LET l_i = 1
       FOREACH pmn_curs USING l_pmm.pmm01 INTO l_pmn[l_i].*
          LET l_i = l_i + 1
       END FOREACH
       CALL l_pmn.deleteElement(l_i)
 
       IF l_pmn.getlength()>0 THEN  #避免帶出有單頭,無單身的資料
          LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_pmm), "pmm_file")   #加入此筆單頭資料至 Response 中
          CALL aws_ttsrv_addDetailRecord(l_node, base.TypeInfo.create(l_pmn), "pmn_file")   #加入此筆單頭的單身資料至 Response 中
       END IF
    END FOREACH
    
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF  
END FUNCTION
