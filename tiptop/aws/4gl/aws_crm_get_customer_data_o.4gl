# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_crm_get_customer_data.4gl
# Descriptions...: 提供取得 ERP 客戶資料服務
# Date & Author..: 2008/02/20 by kevin
# Memo...........:
# Modify.........: 新建立    #FUN-820029
# Modify.........: No.FUN-840004 08/06/17 By Echo 新架構的 Services 與舊架構必須進行區別，
#                                                 因此需調整舊 Services 的程式名稱
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
#FUN-840004
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
DEFINE g_table     STRING
 
#[
# Description....: 提供取得 ERP 客戶資料服務(入口 function)
# Date & Author..: 2008/02/20 by kevin   #FUN-820029
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_CRMGetCustomerData_g()
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_initial()   # 服務初始化動作
 
    #--------------------------------------------------------------------------#
    # 檢查登入資訊                                                             #
    #--------------------------------------------------------------------------#
    IF NOT aws_ttsrv_checkSignIn(g_CRMGetCustomerData_in.signIn) THEN    
       LET g_status.code = "aws-100"   #登入檢查錯誤
    END IF
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                        #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_CRMGetCustomerData_get()
    END IF
    
    LET g_CRMGetCustomerData_out.status = aws_ttsrv_getStatus()
 
END FUNCTION
 
 
#[
# Description....: 查詢 ERP 客戶編號
# Date & Author..: 2008/02/20 by kevin
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_CRMGetCustomerData_get()
    DEFINE l_occ       RECORD 
                       occ01   LIKE occ_file.occ01,
                       occ02   LIKE occ_file.occ02,
                       occ04   LIKE occ_file.occ04,
                       gen03   LIKE gen_file.gen03,
                       occ42   LIKE occ_file.occ42,
                       occ32   LIKE occ_file.occ32,
                       occ62   LIKE occ_file.occ62,
                       CreditBalance LIKE occ_file.occ63,
                       occ64   LIKE occ_file.occ64,
                       gec06   LIKE gec_file.gec06,
                       gec07   LIKE gec_file.gec07,
                       occ44   LIKE occ_file.occ44,
                       occ45   LIKE occ_file.occ45,
                       occ38   LIKE occ_file.occ38,
                       gec05   LIKE gec_file.gec05,
                       occ61   LIKE occ_file.occ61
                       END RECORD 
    DEFINE l_occ01     LIKE occ_file.occ01                   
    DEFINE l_node      om.DomNode
    DEFINE l_sql       STRING
    DEFINE l_cnt       smallint
 
 
    LET g_table = "occ_file"
 
    #--------------------------------------------------------------------------#
    # 填充服務所使用 TABLE, 其欄位名稱及相對應他系統欄位名稱                   #
    #--------------------------------------------------------------------------#
    IF NOT aws_ttsrv_getServiceColumn(g_service) THEN
       LET g_status.code = "aws-102"   #讀取服務設定錯誤
       RETURN
    END IF
 
    #--------------------------------------------------------------------------#
    #依據資料條件(condition),抓取料件資料                                      #
    #--------------------------------------------------------------------------#   
    LET l_occ01 = g_CRMGetCustomerData_in.occ01 
    
    SELECT count(*) INTO l_cnt
    from occ_file WHERE occ_file.occacti = 'Y' AND occ_file.occ01=l_occ01    
    
    IF l_cnt=0 THEN
    	 LET g_status.code = "mfg2732"   #無此客戶
       RETURN
    END IF     
    
    LET l_sql = " SELECT occ01,occ02,occ04,gen03,occ42,occ32,occ62,0,occ64,gec06,gec07",
                " ,occ44,occ45,occ38,gec05,occ61 ",
                " FROM occ_file LEFT OUTER JOIN gen_file ON occ_file.occ04=gen_file.gen01 ",
                " LEFT OUTER JOIN gec_file ON occ_file.occ41=gec_file.gec01 and gec_file.gec011='2' ",
                " WHERE occ_file.occacti = 'Y' AND occ_file.occ01=? ORDER BY occ_file.occ01 "                 
                 
    DECLARE occ_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    
    
    FOREACH occ_curs USING l_occ01 INTO l_occ.*    	  
    	  CALL s_ccc(l_occ01,'3','') RETURNING l_occ.CreditBalance #信用餘額
    	  
        #------------------------------------------------------------------#
        # 解析 RecordSet, 回傳於 Table 欄位                                #
        #------------------------------------------------------------------#
        LET l_node = aws_ttsrv_setDataSetRecord(base.TypeInfo.create(l_occ), l_node, g_table)
    END FOREACH
 
    #--------------------------------------------------------------------------#
    # Response Xml 文件改成字串                                                #
    #--------------------------------------------------------------------------#
    LET g_CRMGetCustomerData_out.occ = aws_ttsrv_xmlToString(l_node)
END FUNCTION
