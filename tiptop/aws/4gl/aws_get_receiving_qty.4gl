# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_receiving_qty.4gl
# Descriptions...: 提供取得 ERP po 已收量、未收量及可收額度、倉庫/儲位資料
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
# Description....: 提供取得 ERP po 已收量、未收量及可收額度、倉庫/儲位資料服務(入口 function)
# Date & Author..: 2008/04/08 by kim  (FUN-840012)
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_receiving_qty()
 
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP po 資料                                                         #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_receiving_qty_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 查詢 ERP po 已收量、未收量及可收額度、倉庫/儲位資料
# Date & Author..: 2008/04/08 by kim (FUN-840012)
# Parameter......: PO單號,項次
# Return.........: 已收量、未收量及可收額度、倉庫/儲位
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_receiving_qty_process()
    DEFINE l_pmn01     LIKE pmn_file.pmn01
    DEFINE l_pmn02     LIKE pmn_file.pmn02
    DEFINE l_sql       STRING
    DEFINE l_wc        STRING
    DEFINE l_i         LIKE type_file.num10
    DEFINE l_pmn       RECORD LIKE pmn_file.*
    DEFINE l_pmn50_55  LIKE pmn_file.pmn50
    DEFINE l_rvb07     LIKE rvb_file.rvb07
    DEFINE l_rvb07_1   LIKE rvb_file.rvb07
    DEFINE l_rvb07_2   LIKE rvb_file.rvb07
    DEFINE l_rvb07_3   LIKE rvb_file.rvb07
    DEFINE l_return    RECORD       #回傳值必須宣告為一個 RECORD 變數, 且此 RECORD 需包含所有要回傳的欄位名稱與定義
                          pmn50     LIKE pmn_file.pmn50,   #已交貨量
                          pmn50_55  LIKE pmn_file.pmn50,   #未收量
                          pmn20     LIKE pmn_file.pmn20,   #可收額度量
                          pmn52     LIKE pmn_file.pmn52,   #倉庫
                          pmn54     LIKE pmn_file.pmn54    #儲位
                       END RECORD
 
 
    LET l_wc = aws_ttsrv_getParameter("condition")   #取由呼叫端呼叫時給予的 SQL Condition
    LET l_pmn01 = aws_ttsrv_getParameter("pmn01")
    LET l_pmn02 = aws_ttsrv_getParameter("pmn02")
    IF cl_null(l_wc) THEN LET l_wc=" 1=1" END IF
 
    LET l_sql = "SELECT pmn_file.* FROM pmm_file,pmn_file WHERE ",
                l_wc,
                " AND pmm01=pmn01",
                " AND pmn01 = '",l_pmn01,"' ",
                " AND pmn02 = ",l_pmn02 CLIPPED              
                 
    DECLARE pmn_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF  
 
    OPEN pmn_curs
    FETCH pmn_curs INTO l_pmn.*
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       CLOSE pmn_curs
       RETURN
    END IF
    CLOSE pmn_curs    
    
    IF cl_null(l_pmn.pmn13) THEN   #超交率
       LET l_pmn.pmn13 = 0
    END IF
    IF cl_null(l_pmn.pmn50) THEN
       LET l_pmn.pmn50=0
    END IF
    IF cl_null(l_pmn.pmn55) THEN
       LET l_pmn.pmn55=0
    END IF
    
    LET l_pmn50_55=l_pmn.pmn50-l_pmn.pmn55
    IF cl_null(l_pmn50_55) THEN
       LET l_pmn50_55 = 0
    END IF
    IF cl_null(l_pmn.pmn20) THEN
       LET l_pmn.pmn20 = 0
    END IF
    
    SELECT SUM(rvb07) INTO l_rvb07_3 FROM rvb_file,rva_file
     WHERE rvb04=l_pmn.pmn01
       AND rvb03=l_pmn.pmn02
       AND rvaconf='N'
       AND rva01=rvb01
       AND rvb35='N'
       
    IF cl_null(l_rvb07_3) THEN
       LET l_rvb07_3 = 0
    END IF
 
    
    LET l_rvb07=l_pmn50_55+l_rvb07_3                            #已交量
    LET l_rvb07_1=(l_pmn.pmn20*(100+l_pmn.pmn13))/100-l_rvb07   #可交貨量
    LET l_rvb07_2=l_pmn.pmn20-l_pmn.pmn50+l_pmn.pmn55           #未收量
    
    LET l_return.pmn50 = l_rvb07       #已交量
    LET l_return.pmn50_55 = l_rvb07_2  #未收量
    LET l_return.pmn20 = l_rvb07_1     #可收額度量
    LET l_return.pmn52 = l_pmn.pmn52   #倉庫
    LET l_return.pmn54 = l_pmn.pmn54   #儲位
    
    CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
 
END FUNCTION
