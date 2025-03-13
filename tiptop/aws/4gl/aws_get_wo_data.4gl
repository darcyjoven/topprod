# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_wo_data.4gl
# Descriptions...: 提供取得 ERP (可入庫)工單相關資料
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
# Description....: 提供取得 ERP (可入庫)工單相關資料(入口 function)
# Date & Author..: 2008/04/17 by kim  (FUN-840012)
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_wo_data()
 
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 查詢 (可入庫)工單 資料                                                   #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_wo_data_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 查詢 ERP (可入庫)工單
# Date & Author..: 2008/04/17 by kim (FUN-840012)
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_wo_data_process()
    DEFINE l_sfb       RECORD LIKE sfb_file.*
    DEFINE l_sfa       DYNAMIC ARRAY OF RECORD LIKE sfb_file.*
    DEFINE l_sql       STRING
    DEFINE l_wc        STRING
    DEFINE l_i         LIKE type_file.num10
    DEFINE l_node      om.DomNode
 
 
    LET l_wc = aws_ttsrv_getParameter("condition")   #取由呼叫端呼叫時給予的 SQL Condition
    IF cl_null(l_wc) THEN LET l_wc=" 1=1" END IF
    LET l_sql = "SELECT * FROM sfb_file WHERE ",
                l_wc,
                " AND sfb87='Y' AND sfbacti='Y' ",
                " AND sfb02='1'",
                " AND sfb04 IN ('2','3','4','5','6','7') ",
                " ORDER BY sfb01"
                 
    DECLARE sfb_curs CURSOR FROM l_sql
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF  
 
    LET l_sql = "SELECT * FROM sfa_file WHERE sfa01 = ? ",
                " ORDER BY sfa03,sfa08,sfa12"
    DECLARE sfa_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
   
    FOREACH sfb_curs INTO l_sfb.*
       IF SQLCA.SQLCODE THEN
          LET g_status.code = SQLCA.SQLCODE
          LET g_status.sqlcode = SQLCA.SQLCODE
          RETURN
       END IF  
      
       CALL l_sfa.clear()
       LET l_i = 1
       FOREACH sfa_curs USING l_sfb.sfb01 INTO l_sfa[l_i].*
          LET l_i = l_i + 1
       END FOREACH
       CALL l_sfa.deleteElement(l_i)
 
       IF l_sfa.getlength()>0 THEN  #避免帶出有單頭,無單身的資料
          LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_sfb), "sfb_file")   #加入此筆單頭資料至 Respo_receiving_innse 中
          CALL aws_ttsrv_addDetailRecord(l_node, base.TypeInfo.create(l_sfa), "sfa_file")   #加入此筆單頭的單身資料至 Respo_receiving_innse 中
       END IF
    END FOREACH
    
END FUNCTION
