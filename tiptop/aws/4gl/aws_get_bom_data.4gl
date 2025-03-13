# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#{
# Program name...: aws_get_bom_data.4gl
# Descriptions...: 提供取得 ERP BOM 資料服務
# Date & Author..: 2007/03/26 by Joe
# Memo...........:
# Modify.........: 新建立  #FUN-840004
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A70106 11/07/05 By Mandy GP5.1追版至GP5.25---str----
# Modify.......... No.FUN-AA0035 10/10/18 By Mandy 增加傳遞condition1 條件,可輸入bmb_file的相關條件值
# Modify.........: No.FUN-A70106 11/07/05 By Mandy GP5.1追版至GP5.25---end----
 
DATABASE ds
 
#FUN-840004
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
           
 
#[
# Description....: 提供取得 ERP BOM 資料服務(入口 function)
# Date & Author..: 2007/03/26 by Joe  #FUN-720021
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_bom_data()
 
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP BOM 資料                                                        #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_bom_data_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 查詢 ERP BOM 
# Date & Author..: 2007/03/26 by Joe
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_bom_data_process()
    DEFINE l_bma       RECORD LIKE bma_file.*
    DEFINE l_bmb       DYNAMIC ARRAY OF RECORD LIKE bmb_file.*
    DEFINE l_sql       STRING
    DEFINE l_wc        STRING
    DEFINE l_wc1       STRING #FUN-AA0035 add
    DEFINE l_i         LIKE type_file.num10
    DEFINE l_node      om.DomNode
 
    
    LET l_wc = aws_ttsrv_getParameter("condition")   #取由呼叫端呼叫時給予的 SQL Condition
    #FUN-AA0035---add---str---
    LET l_wc1= aws_ttsrv_getParameter("condition1")  #取由呼叫端呼叫時給予的 SQL Condition 
    IF cl_null(l_wc1) THEN
        LET l_wc1= " 1=1 "
    END IF
    #FUN-AA0035---add---end---
    
    LET l_sql = "SELECT * FROM bma_file WHERE ",
                l_wc, 
                " AND bmaacti = 'Y' ORDER BY bma01"
                 
    DECLARE bma_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF  
 
   #LET l_sql = "SELECT * FROM bmb_file WHERE bmb01 = ? ORDER BY bmb02"                 #FUN-AA0035 mark
    LET l_sql = "SELECT * FROM bmb_file WHERE bmb01 = ? AND ",l_wc1," ORDER BY bmb02"   #FUN-AA0035 add
    DECLARE bmb_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
   
    FOREACH bma_curs INTO l_bma.*
      
       CALL l_bmb.clear()
       LET l_i = 1
       FOREACH bmb_curs USING l_bma.bma01 INTO l_bmb[l_i].*
          LET l_i = l_i + 1
       END FOREACH
       CALL l_bmb.deleteElement(l_i)
    
       LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_bma), "bma_file")   #加入此筆單頭資料至 Response 中
       CALL aws_ttsrv_addDetailRecord(l_node, base.TypeInfo.create(l_bmb), "bmb_file")   #加入此筆單頭的單身資料至 Response 中
       
    END FOREACH
    
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF  
END FUNCTION
#FUN-A70106
