# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_create_quotation_data.4gl
# Descriptions...: 提供建立報價單資料的服務
# Date & Author..: 2007/02/09 by Brendan
# Memo...........:
# Modify.........: 新建立 FUN-720021
# Modify.........: No.FUN-840004 08/07/07 By Echo 新架構的 Services 與舊架構必須進行區別，
#                                                 因此需調整舊 Services 的程式名稱
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
#FUN-720021
#FUN-840004
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
DEFINE g_oqt01     LIKE oqt_file.oqt01,       #報價單單號
       g_sql1      STRING,                    #單頭 SQL
       g_sql2      DYNAMIC ARRAY OF STRING,   #單身 SQL(可能有多筆)
       g_table     STRING,
       g_table2    STRING
 
#[
# Description....: 提供建立報價單資料的服務(入口 function)
# Date & Author..: 2007/02/09 by Brendan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_createQuotationData_g()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_initial()   # 服務初始化動作
    
    #--------------------------------------------------------------------------#
    # 檢查登入資訊                                                             #
    #--------------------------------------------------------------------------#
    IF NOT aws_ttsrv_checkSignIn(g_createQuotationData_in.signIn) THEN    
       LET g_status.code = "aws-100"   #登入檢查錯誤
    END IF
    
    #--------------------------------------------------------------------------#
    # 新增報價單資料                                                           #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_createQuotationData_add()
    END IF
    
    LET g_createQuotationData_out.status = aws_ttsrv_getStatus()
END FUNCTION
 
 
#[
# Description....: 依據傳入資訊新增一筆 ERP 報價單資料
# Date & Author..: 2007/02/09 by Brendan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_createQuotationData_add()
  DEFINE l_i         LIKE type_file.num10
  DEFINE l_j         LIKE type_file.num10
  DEFINE l_ref       STRING
  DEFINE l_root      om.DomNode,
         l_root2     om.DomNode,
         l_record    om.DomNode,
         l_record2   om.DomNode,
         l_list      om.NodeList,
         l_status    LIKE type_file.num5
 
  
  LET g_table = "oqt_file"
  LET g_table2 = "oqu_file"
  
  LET l_root = aws_ttsrv_stringToXml(g_createQuotationData_in.oqt)
  IF l_root IS NULL THEN
     LET g_status.code = "aws-101"   #傳入資料參數錯誤
     RETURN
  END IF
    
  LET l_root2 = aws_ttsrv_stringToXml(g_createQuotationData_in.oqu)
  IF l_root2 IS NULL THEN
     LET g_status.code = "aws-101"   #傳入資料參數錯誤
     RETURN
  END IF
   
  IF NOT aws_ttsrv_getServiceColumn(g_service) THEN
     LET g_status.code = "aws-102"   #讀取服務設定錯誤
     RETURN
  END IF 
 
  #----------------------------------------------------------------------------#
  # 報價單資料處理,首先抓取單頭的 Record 資料,                                 #
  # 並依據單頭 Record 的識別碼流水號, 再抓取相對應的單身 Record 資料           #
  #----------------------------------------------------------------------------#
  LET l_list = l_root.selectByTagName("Record")
  FOR l_i = 1 TO l_list.getLength()
      LET l_record = l_list.item(l_i)
  
      #------------------------------------------------------------------------#
      # 讀取單頭的識別碼流水號, 再抓取相對應的報價單單身 Record                #
      #------------------------------------------------------------------------#
      LET l_ref = l_record.getAttribute("ref")   #讀取識別碼流水號
      LET l_record2 = aws_ttsrv_getDataSetRefRecord(l_root2, l_ref)
    
      # 初始化動作
      INITIALIZE g_sql1 TO NULL
      LET l_status = TRUE
      CALL g_sql2.clear()
 
      #------------------------------------------------------------------------#
      # 報價單單頭處理                                                         #
      #------------------------------------------------------------------------#    
      CALL aws_createQuotationData_head(l_record)
      IF g_status.code != "0" THEN
         RETURN
      END IF
    
      IF l_record2 IS NOT NULL THEN
         #---------------------------------------------------------------------#
         # 報價單單身處理                                                      #
         #---------------------------------------------------------------------#
         CALL aws_createQuotationData_body(l_record2)
         IF g_status.code != "0" THEN
            RETURN
         END IF
      ELSE
         #---------------------------------------------------------------------#
         # 若無單身資料時，則回傳錯誤訊息，並記錄錯誤單頭                      #
         #---------------------------------------------------------------------#
         LET g_status.code = "mfg-009"
         RETURN
      END IF
    
      #------------------------------------------------------------------------#
      # 執行單頭 INSERT SQL                                                    #
      #------------------------------------------------------------------------#
      BEGIN WORK
      EXECUTE IMMEDIATE g_sql1                   
      IF SQLCA.SQLCODE THEN
         LET g_status.code = SQLCA.SQLCODE       #單頭資料寫入錯誤
         LET g_status.sqlcode = SQLCA.SQLCODE
         LET l_status = FALSE
         ROLLBACK WORK
      ELSE
         #---------------------------------------------------------------------#
         # 執行單身 INSERT SQL                                                 #
         #---------------------------------------------------------------------#
         FOR l_j = 1 TO g_sql2.getLength()
             EXECUTE IMMEDIATE g_sql2[l_j]
             IF SQLCA.SQLCODE THEN
                LET g_status.code = SQLCA.SQLCODE   #單身資料寫入錯誤
                LET g_status.sqlcode = SQLCA.SQLCODE
                LET l_status = FALSE
                ROLLBACK WORK
                EXIT FOR
             END IF
         END FOR
    END IF
    IF l_status THEN
       #-----------------------------------------------------------------------#
       # 回傳 ERP 報價單單號                                                   #
       #-----------------------------------------------------------------------#
       LET g_createQuotationData_out.oqt01 = g_oqt01 CLIPPED
       COMMIT WORK  
    END IF
 
 
    
    RETURN   #一次只處理一筆資料, 故直接 RETURN
  END FOR  
END FUNCTION
 
 
#[
# Description....: 報價單單頭資料處理
# Date & Author..: 2007/02/11 by Brendan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_createQuotationData_head(p_record)
    DEFINE p_record   om.DomNode
    DEFINE l_status   LIKE type_file.num10,
           l_oqt02    LIKE oqt_file.oqt02
    
    
    #--------------------------------------------------------------------------#
    # 由傳入的 XML 資料中讀取他系統欄位與欄位值(報價單單頭)                    #
    #--------------------------------------------------------------------------#
    CALL aws_ttsrv_parseDataSetRecrodField(p_record, g_table)
    
    #--------------------------------------------------------------------------#
    # 若給予 ERP 報價單單別(非空值), 則自動產生 ERP 報價單單號                 #
    #--------------------------------------------------------------------------#
    IF NOT cl_null(g_createQuotationData_in.oayslip) THEN
       LET l_oqt02 = aws_ttsrv_getServiceColumnValue(g_table, "oqt02")
 
       #-----------------------------------------------------------------------#
       # 1. GP 1.X 呼叫: $SUB/4gl/s_axmauno.4gl 自動取號 function              #
       #    原 s_axmauno.4gl 應需做調整以能被正確以服務型態存取                #
       # 2. GP 3.X 呼叫: $SUB/4gl/s_auto_assign_no.4gl 自動取號 function       #
       #    原 s_auto_assign_no.4gl 應需做調整以能被正確以服務型態存取         #
       #-----------------------------------------------------------------------#
       BEGIN WORK
 
       CALL s_check_no("AXM",g_createQuotationData_in.oayslip,"","10","oqt_file","oqt01","")
          RETURNING l_status,g_oqt01
       IF (NOT l_status) THEN
          LET g_status.code = "axm-551"   #報價單自動取號失敗
          ROLLBACK WORK
          RETURN
       END IF
 
       CALL s_auto_assign_no("AXM",g_oqt01, l_oqt02,"10","oqt_file","oqt01","","","")
            RETURNING l_status, g_oqt01
 
       IF (NOT l_status) THEN
          LET g_status.code = "axm-551"   #報價單自動取號失敗
          ROLLBACK WORK
          RETURN
       END IF
       COMMIT WORK
       
       CALL aws_ttsrv_setServiceColumnValue(g_table, "oqt01", g_oqt01)   #寫入自動編號產生的報價單單號
    END IF
    
    #--------------------------------------------------------------------------#
    # 檢查並設定報價單其他相關欄位預設值                                       #
    #--------------------------------------------------------------------------#
    CALL aws_createQuotationData_default()  
    IF g_status.code != "0" THEN
       RETURN
    END IF
 
    #--------------------------------------------------------------------------#
    # 組合出 INSERT SQL                                                        #
    #--------------------------------------------------------------------------#
    LET g_sql1 = aws_ttsrv_getInsertSql(g_table)
    DISPLAY g_sql1   #可用來輸出並最事後檢查 INSERT SQL 是否正確   
END FUNCTION
 
 
#[
# Description....: 報價單單身資料處理
# Date & Author..: 2007/02/11 by Brendan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_createQuotationData_body(p_record)
    DEFINE p_record   om.DomNode
    DEFINE l_i        LIKE type_file.num10,
           l_field    om.DomNode,
           l_list     om.NodeList
    DEFINE l_oqu03    LIKE oqu_file.oqu03
    DEFINE l_cnt      LIKE type_file.num5
       
    
    #--------------------------------------------------------------------------#
    # 一筆一筆單身陸續處理, 抓取單身 Field 資料                                #
    #--------------------------------------------------------------------------#
    LET l_list = p_record.selectByTagName("Field")
    FOR l_i = 1 TO l_list.getLength()   
        LET l_field = l_list.item(l_i)
 
        CALL aws_ttsrv_parseDataSetRecrodField(l_field, g_table2)   
 
        CALL aws_ttsrv_setServiceColumnValue(g_table2, "oqu01", g_oqt01)   #寫入自動編號產生的報價單單號       
 
        #----------------------------------------------------------------------#
        # 檢查料件編號資料是否正確                                             #
        #----------------------------------------------------------------------#
        LET l_oqu03 = aws_ttsrv_getServiceColumnValue(g_table2, "oqu03")
        SELECT COUNT(*) INTO l_cnt FROM ima_file WHERE ima01 = l_oqu03
        IF l_cnt = 0 THEN
              LET g_status.code = "mfg0002"   #料件主檔中無此料件編號
              RETURN
        END IF
 
        #----------------------------------------------------------------------#
        # 組合出 INSERT SQL (單身以 Array 方式記錄多筆資料)                    #
        #----------------------------------------------------------------------#
        LET g_sql2[l_i] = aws_ttsrv_getInsertSql(g_table2)
        DISPLAY g_sql2[l_i]   #可用來輸出並最事後檢查 INSERT SQL 是否正確    
    END FOR
END FUNCTION
 
 
#[
# Description....: 報價單設定欄位預設值
# Date & Author..: 2007/02/11 by Brendan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_createQuotationData_default()
    DEFINE l_value    STRING,
           l_oqt04    LIKE oqt_file.oqt04,
           l_oqt07    LIKE oqt_file.oqt07,
           l_oqtconf  LIKE oqt_file.oqtconf,     #報價單確認碼
           l_gen03    LIKE gen_file.gen03,
           l_occ44    LIKE occ_file.occ44,
           l_occ47    LIKE occ_file.occ47
    DEFINE l_cnt      LIKE type_file.num5
 
  
    #--------------------------------------------------------------------------#
    # 檢查客戶編號資料是否正確                                                 #
    #--------------------------------------------------------------------------#
    LET l_oqt04 = aws_ttsrv_getServiceColumnValue(g_table, "oqt04")
    SELECT COUNT(*) INTO l_cnt FROM occ_file WHERE occ01 = l_oqt04
    IF l_cnt = 0 THEN
          LET g_status.code = "mfg4106"   #無此客戶編號資料存在
          RETURN
    END IF
 
    #--------------------------------------------------------------------------#
    # 依據 ERP 業務員編號，自動預設 ERP 部門編號                               #
    #--------------------------------------------------------------------------#
    LET l_value = aws_ttsrv_getServiceColumnValue(g_table, "oqt06")    
    IF cl_null(l_value) THEN
       LET l_oqt07 = aws_ttsrv_getServiceColumnValue(g_table, "oqt07")
      
       SELECT gen03 INTO l_gen03 FROM gen_file WHERE gen01 = l_oqt07
       
       CALL aws_ttsrv_setServiceColumnValue(g_table, "oqt06", l_gen03)
       #-----------------------------------------------------------------------#
       # 若欄位值為 NULL 值且又是必要輸入欄位,則回傳提示訊息                   #
       #-----------------------------------------------------------------------#
       IF cl_null(l_gen03) THEN
          LET g_status.description = cl_getmsg('aws-098', g_lang)
       END IF 
    END IF
 
    #--------------------------------------------------------------------------#
    # 依據 ERP 客戶編號, 自動預設 ERP 交易條件                                 #
    #--------------------------------------------------------------------------#
    LET l_value = aws_ttsrv_getServiceColumnValue(g_table, "oqt10")
    IF cl_null(l_value) THEN
       SELECT occ44 INTO l_occ44 FROM occ_file WHERE occ01 = l_oqt04
       
       CALL aws_ttsrv_setServiceColumnValue(g_table, "oqt10", l_occ44)
       #-----------------------------------------------------------------------#
       # 若欄位值為 NULL 值且又是必要輸入欄位,則回傳提示訊息                   #
       #-----------------------------------------------------------------------#
       IF cl_null(l_occ44) THEN
          LET g_status.description = cl_getmsg('aws-098', g_lang)
       END IF 
    END IF
 
    #--------------------------------------------------------------------------#
    # 依據 ERP 客戶編號, 自動預設 ERP 運輸方式                                 #
    #--------------------------------------------------------------------------#
    LET l_value = aws_ttsrv_getServiceColumnValue(g_table, "oqt11")
    IF cl_null(l_value) THEN
       SELECT occ47 INTO l_occ47 FROM occ_file WHERE occ01 = l_oqt04
       
       CALL aws_ttsrv_setServiceColumnValue(g_table, "oqt11", l_occ47)
       #-----------------------------------------------------------------------#
       # 若欄位值為 NULL 值且又是必要輸入欄位,則回傳提示訊息                   #
       #-----------------------------------------------------------------------#
       IF cl_null(l_occ47) THEN
          LET g_status.description = cl_getmsg('aws-098', g_lang)
       END IF 
    END IF
 
    #--------------------------------------------------------------------------#
    # 當欄位預設值異常時，則不可自動確認                                       #
    #--------------------------------------------------------------------------#
    LET l_oqtconf = aws_ttsrv_getServiceColumnValue(g_table, "oqtconf")
    IF l_oqtconf = "Y" AND (NOT cl_null(g_status.description)) THEN
       #-----------------------------------------------------------------------#
       # 異常時，確認碼為「N:未確認」、狀況碼為「0:開立」                      #
       #-----------------------------------------------------------------------#
       CALL aws_ttsrv_setServiceColumnValue(g_table, "oqtconf", "N")
       CALL aws_ttsrv_setServiceColumnValue(g_table, "oqt21", "0")
    ELSE
       #-----------------------------------------------------------------------#
       # 確認碼為「Y:已確認」，狀況碼應該「1:已核准」;                         #
       # 確認碼為「N:已確認」，狀況碼應該「0:開立」                            #
       #-----------------------------------------------------------------------#
       IF l_oqtconf = "Y" THEN
          CALL aws_ttsrv_setServiceColumnValue(g_table, "oqt21", "1")
       ELSE
          CALL aws_ttsrv_setServiceColumnValue(g_table, "oqt21", "0")
       END IF
    END IF
END FUNCTION
