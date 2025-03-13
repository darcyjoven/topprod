# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_create_quotation_data.4gl
# Descriptions...: 提供建立報價單資料的服務
# Date & Author..: 2008/02/09 by Brendan
# Memo...........:
# Modify.........: 新建立 FUN-840004
#
#}
# Modify.........: No.FUN-980030 09/08/31 By Hiko  加上GP5.2的相關設定
# Modify.........: No.FUN-930139 10/08/30 By Lilan FOR GP5.2新增欄位
#                                              單頭:oqtplant,oqtlegal 
#                                              單身:oquplant,oqulegal             
# Modify.........: No.FUN-C20054 12/02/08 By Lilan 新增欄位:oqtoriu, oqtorig 
 
DATABASE ds
 
#FUN-840004
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
 
#[
# Description....: 提供建立報價單資料的服務(入口 function)
# Date & Author..: 2007/02/09 by Brendan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_quotation_data()
 
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 新增報價單資料                                                           #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_quotation_data_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 依據傳入資訊新增 ERP 報價單資料
# Date & Author..: 2007/02/09 by Brendan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_quotation_data_process()
    DEFINE l_i        LIKE type_file.num10,
           l_j        LIKE type_file.num10
    DEFINE l_sql      STRING        
    DEFINE l_cnt      LIKE type_file.num10,
           l_cnt1     LIKE type_file.num10,
           l_cnt2     LIKE type_file.num10
    DEFINE l_oqt01    LIKE oqt_file.oqt01,
           l_oqt02    LIKE oqt_file.oqt02
    DEFINE l_oqu03    LIKE oqu_file.oqu03
    DEFINE l_node1    om.DomNode,
           l_node2    om.DomNode
    DEFINE l_flag     LIKE type_file.num10
    DEFINE l_return   RECORD                           #回傳值必須宣告為一個 RECORD 變數, 且此 RECORD 需包含所有要回傳的欄位名稱與定義
                         oqt01   LIKE oqt_file.oqt01   #回傳的欄位名稱
                      END RECORD
 
        
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的報價單資料                                        #
    #--------------------------------------------------------------------------#
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("oqt_file")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***
    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF
    
    BEGIN WORK
    
    FOR l_i = 1 TO l_cnt1       
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "oqt_file")        #目前處理單檔的 XML 節點
        
        LET l_oqt01 = aws_ttsrv_getRecordField(l_node1, "oqt01")         #取得此筆單檔資料的欄位值
        LET l_oqt02 = aws_ttsrv_getRecordField(l_node1, "oqt02")
        
        #----------------------------------------------------------------------#
        # 報價單自動取號                                                       #
        #----------------------------------------------------------------------#       
        CALL s_check_no("AXM", l_oqt01, "", "10", "oqt_file", "oqt01", "")
             RETURNING l_flag, l_oqt01
        IF NOT l_flag THEN
           LET g_status.code = "axm-551"   #報價單自動取號失敗
           EXIT FOR
        END IF
        CALL s_auto_assign_no("AXM", l_oqt01, l_oqt02, "10", "oqt_file", "oqt01", "", "", "")
             RETURNING l_flag, l_oqt01
        IF NOT l_flag THEN
           LET g_status.code = "axm-551"   #報價單自動取號失敗
           EXIT FOR
        END IF
        
        CALL aws_ttsrv_setRecordField(l_node1, "oqt01", l_oqt01)    #更新 XML 取號完成後的報價單單號欄位(oqt01)
        CALL aws_ttsrv_setRecordField(l_node1, "oqtplant", g_plant) #FUN-930139 add
        CALL aws_ttsrv_setRecordField(l_node1, "oqtlegal", g_legal) #FUN-930139 add
       #FUN-C20054 add str---
        CALL aws_ttsrv_setRecordField(l_node1, "oqtoriu", g_user)
        CALL aws_ttsrv_setRecordField(l_node1, "oqtorig", g_grup)
       #FUN-C20054 add end---
       
        IF NOT aws_create_quotation_data_default(l_node1) THEN      #檢查報價單欄位預設值           
           EXIT FOR
        END IF
        
        LET l_sql = aws_ttsrv_getRecordSql(l_node1, "oqt_file", "I", NULL)   #I 表示取得 INSERT SQL
   
        #----------------------------------------------------------------------#
        # 執行單頭 INSERT SQL                                                  #
        #----------------------------------------------------------------------#
        EXECUTE IMMEDIATE l_sql
        IF SQLCA.SQLCODE THEN
           LET g_status.code = SQLCA.SQLCODE
           LET g_status.sqlcode = SQLCA.SQLCODE
           EXIT FOR
        END IF
        
        #----------------------------------------------------------------------#
        # 處理單身資料                                                         #
        #----------------------------------------------------------------------#
        LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "oqu_file")       #取得目前單頭共有幾筆單身資料
        IF l_cnt2 = 0 THEN
           LET g_status.code = "mfg-009"   #必須有單身資料
           EXIT FOR
        END IF
        
        FOR l_j = 1 TO l_cnt2
            LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j, "oqu_file")   #目前單身的 XML 節點
        
            CALL aws_ttsrv_setRecordField(l_node2, "oqu01", l_oqt01)     #寫入自動編號產生的報價單單號  
            CALL aws_ttsrv_setRecordField(l_node2, "oquplant", g_plant)  #FUN-930139 add
            CALL aws_ttsrv_setRecordField(l_node2, "oqulegal", g_legal)  #FUN-930139 add

            #------------------------------------------------------------------#
            # 檢查料件編號資料是否正確                                         #
            #------------------------------------------------------------------#
            LET l_oqu03 = aws_ttsrv_getRecordField(l_node2, "oqu03")
            SELECT COUNT(*) INTO l_cnt FROM ima_file WHERE ima01 = l_oqu03
            IF l_cnt = 0 THEN
               LET g_status.code = "mfg0002"   #料件主檔中無此料件編號
               EXIT FOR
            END IF
            
            LET l_sql = aws_ttsrv_getRecordSql(l_node2, "oqu_file", "I", NULL)   #I 表示取得 INSERT SQL
            
            #------------------------------------------------------------------#
            # 執行單身 INSERT SQL                                              #
            #------------------------------------------------------------------#
            EXECUTE IMMEDIATE l_sql
            IF SQLCA.SQLCODE THEN
               LET g_status.code = SQLCA.SQLCODE
               LET g_status.sqlcode = SQLCA.SQLCODE
               EXIT FOR
            END IF
        END FOR
        IF g_status.code != "0" THEN   #如果單身處理有任何錯誤, 則離開
           EXIT FOR
        END IF
        
    END FOR
    
    #全部處理都成功才 COMMIT WORK
    IF g_status.code = "0" THEN
       LET l_return.oqt01 = l_oqt01
       CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))   #回傳 ERP 建立的報價單單號
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
    
END FUNCTION
 
 
#[
# Description....: 報價單設定欄位預設值
# Date & Author..: 2007/02/11 by Brendan
# Parameter......: p_node   - om.DomNode - 報價單單頭 XML 節點 
# Return.........: l_status - INTEGER    - TRUE / FALSE 預設值檢查結果
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_quotation_data_default(p_node)
    DEFINE p_node      om.DomNode
    DEFINE l_oqt04     LIKE oqt_file.oqt04,
           l_oqt06     LIKE oqt_file.oqt06,
           l_oqt07     LIKE oqt_file.oqt07,
           l_oqt10     LIKE oqt_file.oqt10,
           l_oqt11     LIKE oqt_file.oqt11,
           l_oqtconf   LIKE oqt_file.oqtconf   #報價單確認碼
    DEFINE l_cnt       LIKE type_file.num5
 
  
    #--------------------------------------------------------------------------#
    # 檢查客戶編號資料是否正確                                                 #
    #--------------------------------------------------------------------------#
    LET l_oqt04 = aws_ttsrv_getRecordField(p_node, "oqt04")
    SELECT COUNT(*) INTO l_cnt FROM occ_file WHERE occ01 = l_oqt04
    IF l_cnt = 0 THEN
       LET g_status.code = "mfg4106"   #無此客戶編號資料存在
       RETURN FALSE
    END IF
 
    #--------------------------------------------------------------------------#
    # 依據 ERP 業務員編號，自動預設部門編號(若呼叫端無給予部門編號欄位值時)    #
    #--------------------------------------------------------------------------#
    LET l_oqt06 = aws_ttsrv_getRecordField(p_node, "oqt06")    
    IF cl_null(l_oqt06) THEN
       LET l_oqt07 = aws_ttsrv_getRecordField(p_node, "oqt07")
       SELECT gen03 INTO l_oqt06 FROM gen_file WHERE gen01 = l_oqt07
       CALL aws_ttsrv_setRecordField(p_node, "oqt06", l_oqt06)
       IF cl_null(l_oqt06) THEN   #若欄位值為 NULL 值且又是必要輸入欄位,則回傳提示訊息
          #LET g_status.description = cl_getmsg('aws-098', g_lang)  
       END IF 
    END IF
 
    #--------------------------------------------------------------------------#
    # 依據 ERP 客戶編號, 自動預設交易條件(若呼叫端無給予交易條件欄位值時)      #
    #--------------------------------------------------------------------------#
    LET l_oqt10 = aws_ttsrv_getRecordField(p_node, "oqt10")
    IF cl_null(l_oqt10) THEN
       SELECT occ44 INTO l_oqt10 FROM occ_file WHERE occ01 = l_oqt04      
       CALL aws_ttsrv_setRecordField(p_node, "oqt10", l_oqt10)
       IF cl_null(l_oqt10) THEN   #若欄位值為 NULL 值且又是必要輸入欄位,則回傳提示訊息
          #LET g_status.description = cl_getmsg('aws-098', g_lang)
       END IF 
    END IF
 
    #--------------------------------------------------------------------------#
    # 依據 ERP 客戶編號, 自動預設運輸方式(若呼叫端無給予運輸方式欄位值時)      #
    #--------------------------------------------------------------------------#
    LET l_oqt11 = aws_ttsrv_getRecordField(p_node, "oqt11")
    IF cl_null(l_oqt11) THEN
       SELECT occ47 INTO l_oqt11 FROM occ_file WHERE occ01 = l_oqt04     
       CALL aws_ttsrv_setRecordField(p_node, "oqt11", l_oqt11)
       IF cl_null(l_oqt11) THEN   #若欄位值為 NULL 值且又是必要輸入欄位,則回傳提示訊息  
          #LET g_status.description = cl_getmsg('aws-098', g_lang)
       END IF 
    END IF
 
    #--------------------------------------------------------------------------#
    # 當欄位預設值異常時，則不可自動確認                                       #
    #--------------------------------------------------------------------------#
    LET l_oqtconf = aws_ttsrv_getRecordField(p_node, "oqtconf")
    IF l_oqtconf = "Y" AND ( NOT cl_null(g_status.description) ) THEN
       #-----------------------------------------------------------------------#
       # 異常時，確認碼為「N:未確認」、狀況碼為「0:開立」                      #
       #-----------------------------------------------------------------------#
       CALL aws_ttsrv_setRecordField(p_node, "oqtconf", "N")
       CALL aws_ttsrv_setRecordField(p_node, "oqt21", "0")
    ELSE
       #-----------------------------------------------------------------------#
       # 確認碼為「Y:已確認」，狀況碼應該「1:已核准」;                         #
       # 確認碼為「N:已確認」，狀況碼應該「0:開立」                            #
       #-----------------------------------------------------------------------#
       IF l_oqtconf = "Y" THEN
          CALL aws_ttsrv_setRecordField(p_node, "oqt21", "1")
       ELSE
          CALL aws_ttsrv_setRecordField(p_node, "oqt21", "0")
       END IF
    END IF
    
    RETURN TRUE
END FUNCTION
