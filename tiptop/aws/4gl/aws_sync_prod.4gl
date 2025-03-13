# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#{
# Program name...: aws_sync_prod.4gl
# Descriptions...: CROSS請求TIPTOP提供各註冊資訊服務
# Date & Author..: 2011/04/06 by Jay
# Memo...........:
# Modify.........: 新建立  #FUN-B30003
#
#}
# Modify.........: No:FUN-B80064 11/08/05 By Lujh 模組程序撰寫規範修正
# Modify.........: No:FUN-BB0010 11/12/29 By ka0132 增加CROSS同步TIPTOP註冊資訊
# Modify.........: No.FUN-BB0161 11/11/29 By ka0132 提供更新編碼狀態服務 & CROSS服務流程自動化處理
# Modify.........: No:FUN-C20087 12/03/06 By Abby CROSS同步資訊至aws_crosscfg時，也同步至各產品原設定檔
# Modify.........: No:FUN-C60080 12/06/26 By Kevin 重新連線 database ds
# Modify.........: No:FUN-C70031 12/07/10 By Kevin 補上 ROLLBACK WORK
# Modify.........: No:FUN-C80059 12/08/20 By kevin 提供 getEncodingState服務取得產品目前編碼狀態

IMPORT xml

DATABASE ds

#FUN-B30003
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

DEFINE g_request_root    om.DomNode      #Request XML Dom Node
DEFINE g_response_root   om.DomNode      #Response XML Dom Node
DEFINE g_wap             RECORD LIKE  wap_file.* 
DEFINE g_forupd_sql      STRING
DEFINE g_tp_version      STRING
 
#[
# Description....: 提供服務呼叫syncProd(入口function)
# Date & Author..: 2011/04/06 by Jay
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_sync_prod()  
    WHENEVER ERROR CONTINUE

    #FUN-C60080 start
    CALL aws_ttsrv_conn_ds()   #FUN-C70031
    #FUN-C60080 end

    #紀錄 Request XML
    CALL aws_ttsrv_writeRequestLog()   

    #--------------------------------------------------------------------------#
    # CROSS平台Request資訊                                                       #
    #--------------------------------------------------------------------------#
    CALL aws_sync_prod_process()

    #紀錄 Request XML
    CALL aws_ttsrv_writeResponseLog()   
END FUNCTION


#[
# Description....: CROSS平台syncProd服務處理
# Date & Author..: 2011/04/06 by Jay
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_sync_prod_process()
   DEFINE l_service   STRING            #服務名稱
   
   LET g_request_root = aws_cross_stringToXml(g_request.request)
    
   IF g_request_root IS NULL THEN
      CALL aws_sync_prod_doSyncProcess_response("100", "Request isn't valid XML document.")
      CALL cl_err("Response isn't valid XML document","!",1)
      RETURN
   END IF

   #取得TIPTOP版本
   LET g_tp_version = cl_get_tp_version()

   #尋找對應名稱的tag資料,取得CROSS平台要求服務名稱                              
   LET l_service = aws_cross_getTagValue(g_request_root,"service","name")

   IF cl_null(l_service) THEN
      CALL aws_sync_prod_doSyncProcess_response("100", "Request isn't valid XML document.")
   END IF

   CASE l_service
       WHEN "getProdRegInfo"    #請求產品提供註冊資訊
          CALL aws_sync_prod_getProdRegInfo()

       WHEN "getSrvRegInfo"     #請求產品提供服務註冊資訊
          CALL aws_sync_prod_getSrvRegInfo()

       WHEN "doSyncProcess"     #傳送同步資訊至產品
          CALL aws_sync_prod_doSyncProcess()

       WHEN "syncEncodingState" #供更新編碼狀態服務 #No.FUN-BB0161
          CALL aws_sync_encoding_state()            #No.FUN-BB0161
       
       WHEN "getEncodingState"  #取得編碼狀態服務   #No.FUN-C80059
          CALL aws_sync_getEncodingState()          #No.FUN-C80059

       OTHERWISE
          CALL aws_sync_prod_doSyncProcess_response("100", "Error service name: " || l_service)
   END CASE

   CALL crosscfg_upd_plt('Y')  #FUN-C20087
   
END FUNCTION

#[
# Description....: CROSS請求產品提供註冊資訊
# Date & Author..: 2011/04/06 by Jay
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_sync_prod_getProdRegInfo()
   DEFINE l_pnode           om.DomNode
   DEFINE l_sql             STRING              #BB0010
   DEFINE l_i               INTEGER             #BB0010
   DEFINE l_wsr01           LIKE wsr_file.wsr01 #BB0010
   DEFINE l_wao02           LIKE wao_file.wao02 #BB0010
   DEFINE l_status          INTEGER             #BB0010
   DEFINE l_count           INTEGER             #BB0010
   TRY
      SELECT * INTO g_wap.* FROM wap_file
   
      LET g_response_root = aws_cross_createRequest("action|reg" ,"")

      #payload 資訊
      LET l_pnode = g_response_root.createChild("payload")            #建立 <payload>

        #No.FUN-BB0161 - Start -
        #LET l_pnode = aws_crosscli_param(l_pnode,"wsdl","string",g_wap.wap03)           #TIPTOP WSDL          mark
        #LET l_pnode = aws_crosscli_param(l_pnode,"retrytimes","integer",g_wap.wap05)    #服務連線失敗重試次數 mark
        #LET l_pnode = aws_crosscli_param(l_pnode,"retryinterval","integer",g_wap.wap06) #服務連線失敗重試間隔 mark
        #LET l_pnode = aws_crosscli_param(l_pnode,"concurrence","integer",g_wap.wap07)   #同時連線人數         mark
        
        LET l_count = 1
        SELECT COUNT(*) INTO l_count FROM waq_file #waq_file為空, 進行第一次新增動作
        IF l_count = 0 THEN
            LET l_status = 0  #若執行結束後l_status不為零代表執行錯誤
            BEGIN WORK    
            
            #自動新增 TIPTOP接口服務清單
            LET l_sql = "SELECT wsr01 FROM wsr_file where wsr02 ='S'"
            PREPARE l_wsr FROM l_sql
            DECLARE l_wsrc CURSOR FOR l_wsr
            OPEN l_wsrc
            FOREACH l_wsrc INTO l_wsr01
                INSERT INTO waq_file(waq01, waq02) VALUES ('T', l_wsr01)
                IF SQLCA.SQLCODE THEN
                    LET g_status.code = SQLCA.SQLCODE
                    LET g_status.sqlcode = SQLCA.SQLCODE
                    LET l_status = l_status + 1
                END IF
            END FOREACH
            CLOSE l_wsrc
        
            #自動新增EF接口服務清單
            LET l_sql = "SELECT wao02 FROM wao_file where wao01 ='T'"
            PREPARE l_wao FROM l_sql
            DECLARE l_waoc CURSOR FOR l_wao
            OPEN l_waoc
            FOREACH l_waoc INTO l_wao02
                INSERT INTO waq_file(waq01, waq02) VALUES ('E', l_wao02)
                IF SQLCA.SQLCODE THEN
                    LET g_status.code = SQLCA.SQLCODE
                    LET g_status.sqlcode = SQLCA.SQLCODE
                    LET l_status = l_status + 1
                END IF
            END FOREACH
            CLOSE l_waoc
              
            IF l_status = 0 THEN #DB存取無錯誤
                COMMIT WORK
            ELSE
                DISPLAY "Insert Tiptop, EF service info error"
                ROLLBACK WORK
            END IF
        END IF
        
        #No.FUN-BB0161 -  End -
      LET g_response.response = g_response_root.toString()
   CATCH
      ROLLBACK WORK     #FUN-C70031
      CALL aws_sync_prod_doSyncProcess_response("100", "Processing failure: aws_sync_prod_getProdRegInfo()")
   END TRY 
   
END FUNCTION

#[
# Description....: CROSS請求產品提供服務註冊資訊
# Date & Author..: 2011/04/06 by Jay
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_sync_prod_getSrvRegInfo()
   DEFINE l_pnode      om.DomNode
   DEFINE l_sql        STRING
   DEFINE l_waq02      LIKE waq_file.waq02   #已註冊TIPTOP服務清單

   TRY
      LET l_sql = "SELECT waq02 FROM waq_file"
      PREPARE getSrvRegInfo_prepare FROM l_sql           #預備一下
      DECLARE waq_curs CURSOR FOR getSrvRegInfo_prepare
   
      LET g_response_root = aws_cross_createRequest("action|reg" ,"")

      #payload 資訊
      LET l_pnode = g_response_root.createChild("payload")            #建立 <payload>

      FOREACH waq_curs INTO l_waq02
         LET l_pnode = aws_crosscli_param(l_pnode,"srvname","string",l_waq02)  #TIPTOP服務清單
      END FOREACH

      LET g_response.response = g_response_root.toString()
   CATCH
      CALL aws_sync_prod_doSyncProcess_response("100", "Processing failure: aws_sync_prod_getSrvRegInfo()")
   END TRY 
   
END FUNCTION

#[
# Description....: CROSS傳送同步資訊至產品
# Date & Author..: 2011/04/06 by Jay
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_sync_prod_doSyncProcess()
   DEFINE l_pnode      om.DomNode
   DEFINE l_node_list  om.NodeList
   DEFINE l_node       om.DomNode   
   DEFINE l_i          LIKE type_file.num5
   DEFINE l_sql        STRING
   DEFINE l_wap04      LIKE wap_file.wap04       #CROSS WSDL 位置
   DEFINE l_wsdl       LIKE wap_file.wap04
   DEFINE l_war        RECORD LIKE war_file.*    #CROSS平台註冊的產品主機
   DEFINE l_cnt        LIKE type_file.num5       #FUN-BB0010
   DEFINE l_wap        RECORD LIKE wap_file.*    #FUN-BB0010
   DEFINE l_cross_wsdl LIKE wap_file.wap04       #FUN-BB0010  XML傳過來的CROSS WSDL 位置
   DEFINE l_war03a     DYNAMIC ARRAY OF LIKE war_file.war03  #FUN-BB0161
   DEFINE l_wi,l_wcpr  INTEGER                               #FUN-BB0161
   DEFINE l_wsql       STRING                                #FUN-BB0161
   
   
   TRY
      #檢查CROSS 整合設定檔(wap_file)
      LET g_forupd_sql = "SELECT * from wap_file WHERE wap01 = '0' ",
                         " FOR UPDATE "
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      DECLARE wap_curs CURSOR FROM g_forupd_sql
   
      BEGIN WORK

      #---FUN-BB0010---start-----
      #此段因為已經在下面會做wap_file TIPTOP註冊資訊的同步動作
      #所以這段全mark
      #OPEN wap_curs
      #LET l_wsdl = aws_cross_getTagValue(g_request_root, "cross", "wsdl")
      #SELECT wap04 INTO l_wap04 FROM wap_file WHERE wap01 = '0'
      
      ##檢查CROSS平台的WSDL檔網址是否變更
      #IF l_wsdl <> l_wap04 THEN
      #   UPDATE wap_file SET wap04 = l_wsdl WHERE wap01 = '0'
      #   IF SQLCA.sqlcode THEN
      #      CALL cl_err("wap01 = '0'", SQLCA.sqlcode, 0)
      #      ROLLBACK WORK  
      #      CLOSE wap_curs
      #      CALL aws_sync_prod_doSyncProcess_response("100", "Fail")
      #      RETURN
      #   END IF
      #END IF
      #CLOSE wap_curs
      #---FUN-BB0010---end-------

      #檢查各產品站台設定(war_file)
      LET g_forupd_sql = "SELECT * from war_file ", 
                         "  WHERE war01 = ? AND war02 = ? AND war03 = ? FOR UPDATE "
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      DECLARE war_curs1 CURSOR FROM g_forupd_sql
      
      #FUN-BB0161 - Start -
      #LET l_sql = "SELECT war01, war02, war07 FROM war_file ",
      #            "  WHERE war03 = ? AND war04 = ? AND ",
      #            "    war05 = ?" # AND war06 = ? " #FUN-BB0161 mark
      #PREPARE doSyncProcess_prepare FROM l_sql           #預備一下
      #DECLARE war_curs2 CURSOR FOR doSyncProcess_prepare
      

      #依各產品檢查WSDL檔網址是否變更

      LET l_wi = 1
      LET l_wsql = "SELECT war03 FROM war_file"
      PREPARE l_war03 FROM l_wsql
      DECLARE l_war03c CURSOR FOR l_war03
      OPEN l_war03c
      FOREACH l_war03c INTO l_war03a[l_wi]
          LET l_wi = l_wi + 1
      END FOREACH
      CLOSE l_war03c
      #FUN-BB0161 -  End  -
      
      LET l_node_list = g_request_root.selectByPath("//prodlist/prod")
      FOR l_i = 1 TO l_node_list.getLength()
          LET l_node = l_node_list.item(l_i)
          LET l_war.war03 = l_node.getAttribute("name")
          LET l_war.war04 = l_node.getAttribute("ver")
          LET l_war.war05 = l_node.getAttribute("ip")
          LET l_war.war06 = l_node.getAttribute("id")
          LET l_wsdl = l_node.getAttribute("wsdl")

          #---FUN-BB0010---start-----
          IF l_war.war03 = "TIPTOP" THEN
             LET l_cnt = 1 #FUN-BB0161 確保預設值不為0
             SELECT COUNT(*) INTO l_cnt FROM wap_file WHERE wap01 = '0'
             LET l_cross_wsdl = aws_cross_getTagValue(g_request_root, "cross", "wsdl")
             IF l_cnt = 0 THEN
                LET l_wap.wap01 = "0"       
                LET l_wap.wap02 = "Y"             #是否使用CROSS整合平台
                #LET l_wap.wap03 = l_wsdl         #TIPTOP WSDL 位置       #FUN-BB0161 mark
                LET l_wap.wap03 = NULL            #TIPTOP WSDL 位置       #FUN-BB0161
                LET l_wap.wap04 = l_cross_wsdl    #CROSS WSDL 位置
                #LET l_wap.wap05 = 3              #服務連線失敗重試次數   #FUN-BB0161 mark
                LET l_wap.wap05 = NULL            #服務連線失敗重試次數   #FUN-BB0161
                #LET l_wap.wap06 = 3              #服務連線失敗重試間隔   #FUN-BB0161 mark
                LET l_wap.wap06 = NULL            #服務連線失敗重試間隔   #FUN-BB0161
                #LET l_wap.wap07 = 50             #同時連線人數           #FUN-BB0161 mark
                LET l_wap.wap07 = NULL            #同時連線人數           #FUN-BB0161
                LET l_wap.wap08 = "Y"             #產品主機是否已註冊
                LET l_wap.wap09 = "N"             #編碼狀態是否已啟動     #FUN-BB0161
                LET l_wap.wapdate = g_today
                LET l_wap.wapuser = g_user
                LET l_wap.wapmodu = g_user
                LET l_wap.wapgrup = g_grup
                LET l_wap.waporiu = g_user 
                LET l_wap.waporig = g_grup 
                INSERT INTO wap_file VALUES (l_wap.*)
                IF SQLCA.sqlcode THEN
                   CALL cl_err(l_wap.wap01, SQLCA.sqlcode, 0)
                   ROLLBACK WORK  
                   CLOSE war_curs1
                   #CLOSE war_curs2 #FUN-BB0161 mark
                   CALL aws_sync_prod_doSyncProcess_response("100", "Fail")
                   RETURN
                END IF
             ELSE
                OPEN wap_curs
                IF STATUS THEN
                   CALL cl_err("wap01=0", SQLCA.sqlcode, 0)
                   ROLLBACK WORK  
                   CLOSE wap_curs
                   CLOSE war_curs1
                   #CLOSE war_curs2 #FUN-BB0161 mark
                   CALL aws_sync_prod_doSyncProcess_response("100", "Fail")
                   RETURN
                END IF
                FETCH wap_curs INTO l_wap.*               # 對DB鎖定
                IF SQLCA.sqlcode THEN
                   CALL cl_err("wap01=0", SQLCA.sqlcode, 0)
                   ROLLBACK WORK  
                   CLOSE wap_curs
                   CLOSE war_curs1
                   #CLOSE war_curs2 #FUN-BB0161 mark
                   CALL aws_sync_prod_doSyncProcess_response("100", "Fail")
                   RETURN
                END IF          
                LET l_wap.wap02 = "Y"             #是否使用CROSS整合平台
                #LET l_wap.wap03 = l_wsdl         #TIPTOP WSDL 位置       #FUN-BB0161 mark
                LET l_wap.wap03 = NULL            #TIPTOP WSDL 位置       #FUN-BB0161
                LET l_wap.wap04 = l_cross_wsdl    #CROSS WSDL 位置
                LET l_wap.wap08 = "Y"             #產品主機是否已註冊
                LET l_wap.wap09 = "N"             #編碼狀態是否已啟動     #FUN-BB0161
                
                UPDATE wap_file SET wap_file.* = l_wap.*    # 更新DB
                  WHERE wap01 = l_wap.wap01
                  
                IF SQLCA.sqlcode THEN
                   CALL cl_err("wap01=0", SQLCA.sqlcode, 0)
                   ROLLBACK WORK  
                   CLOSE wap_curs
                   CLOSE war_curs1
                   #CLOSE war_curs2 #FUN-BB0161 mark
                   CALL aws_sync_prod_doSyncProcess_response("100", "Fail")
                   RETURN
                END IF      
             END IF
          ELSE
          #FUN-BB0161 - Start -
          LET l_wcpr = 0
          FOR l_wi = 1 TO l_war03a.getLength()
              IF l_war03a[l_wi] = l_war.war03 THEN
                  LET l_wcpr = 1
                  EXIT FOR
              END IF
          END FOR

          IF l_wcpr = 0 THEN
              INSERT INTO war_file(war01, war02, war03, war04, war05, war06, war07) 
                VALUES ('S', '*', l_war.war03, l_war.war04, l_war.war05, l_war.war06, l_wsdl)
              IF SQLCA.sqlcode THEN
                   CALL cl_err("", SQLCA.sqlcode, 0)
                   ROLLBACK WORK 
                   RETURN
                END IF      
          END IF 
           
          #---FUN-BB0010---end-------
          IF l_war.war06 IS NULL THEN
             LET l_sql = "SELECT war01, war02, war07 FROM war_file ",
                "  WHERE war03 = ? AND war04 = ? AND ",
                "    war05 = ? AND war06 IS NULL "
          ELSE 
             LET l_sql = "SELECT war01, war02, war07 FROM war_file ",
                "  WHERE war03 = ? AND war04 = ? AND ",
                #"    war05 = ? AND war06 = ", l_war.war06            #FUN-C70031
                 "    war05 = ? AND war06 = '", l_war.war06 , "'"     #FUN-C70031
          END IF
          PREPARE doSyncProcess_prepare FROM l_sql
          DECLARE war_curs2 CURSOR FOR doSyncProcess_prepare
          OPEN war_curs2 USING l_war.war03, l_war.war04, l_war.war05 
          #FUN-BB0161 -  End  -

             FOREACH war_curs2 INTO l_war.war01, l_war.war02, l_war.war07
                IF l_wsdl <> l_war.war07 THEN
                   OPEN war_curs1 USING l_war.war01, l_war.war02, l_war.war03
                   UPDATE war_file SET war07 = l_wsdl 
                     WHERE war01 = l_war.war01 AND war02 = l_war.war02 AND war03 = l_war.war03 
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(l_war.war01, SQLCA.sqlcode, 0)
                      ROLLBACK WORK  
                      CLOSE war_curs1
                      CLOSE war_curs2
                      CALL aws_sync_prod_doSyncProcess_response("100", "Fail")
                      RETURN
                   END IF
                END IF
             END FOREACH
          END IF   #FUN-BB0010
      END FOR  

      CLOSE war_curs1
      CLOSE war_curs2
      COMMIT WORK
      CALL aws_sync_prod_doSyncProcess_response("000", "OK")
   CATCH
      ROLLBACK WORK     #FUN-C70031
      CALL aws_sync_prod_doSyncProcess_response("100", "Processing failure: aws_sync_prod_doSyncProcess()")
   END TRY 
END FUNCTION

#[
# Description....: CROSS傳送同步資訊至產品時,Response結果給CROSS平台
# Date & Author..: 2011/04/06 by Jay
# Parameter......: p_srvcode---Response 狀態代碼
#                  p_payload---Response 描述內容
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_sync_prod_doSyncProcess_response(p_srvcode, p_payload)
   DEFINE p_srvcode         STRING
   DEFINE p_payload         STRING
   DEFINE l_resdoc          om.DomDocument
   DEFINE l_response_root   om.DomNode        #Request XML Dom Node
   DEFINE l_pnode           om.DomNode
   DEFINE l_tnode           om.DomNode

   LET l_resdoc = om.DomDocument.create("response")     
   LET l_response_root = l_resdoc.getDocumentElement()  

   LET l_pnode = l_response_root.createChild("srvcode")    #建立 <srvcode>
   LET l_tnode = l_resdoc.createChars(p_srvcode.trim())
   CALL l_pnode.appendChild(l_tnode) 

   LET l_pnode = l_response_root.createChild("payload")    #建立 <payload>
   LET l_tnode = l_resdoc.createChars(p_payload.trim())
   CALL l_pnode.appendChild(l_tnode) 

   LET g_response.response = l_response_root.toString()
END FUNCTION
#FUN-B80064 

#FUN-BB0161 - Start -
#{
# Descriptions...: 提供更新編碼狀態服務
# Date & Author..: 2011/11/29 by ka0132
# Memo...........:
# Modify.........: 
#
#}

FUNCTION aws_sync_encoding_state()   
    DEFINE l_wap09           CHAR(1) 
    DEFINE l_wap09_d         CHAR(1) 
    DEFINE l_resdoc          xml.DomDocument
    DEFINE l_reqdoc          om.DomDocument
    DEFINE l_request_root    om.DomNode  
    DEFINE l_response_root   xml.DomNode          
    DEFINE l_nl              om.NodeList
    DEFINE l_n               om.DomNode   
    DEFINE l_n2              om.DomNode 
    DEFINE l_isEncoding      STRING
    DEFINE l_srvcode         xml.DomNode 
    DEFINE l_payload         xml.DomNode 
    DEFINE l_nlist           xml.DomNodeList
    DEFINE l_return          STRING
    
    LET l_resdoc = xml.DomDocument.createDocument("response")    
    LET l_response_root = l_resdoc.getDocumentElement()
    CALL l_response_root.appendChild(l_resdoc.createElement("srvcode"))    #建立 <srvcode>
    CALL l_response_root.appendChild(l_resdoc.createElement("payload"))    #建立 <payload>
    LET l_nlist = l_response_root.getElementsByTagName("srvcode")
    LET l_srvcode = l_nlist.getItem(1)
    LET l_nlist = l_response_root.getElementsByTagName("payload")
    LET l_payload = l_nlist.getItem(1)
    
    #--------------------------------------------------------------------------#
    # 進行編碼狀態更新                                                         #
    #--------------------------------------------------------------------------#

    BEGIN WORK
    
    LET l_request_root = aws_cross_stringToXml(g_request.request)

    IF l_request_root IS NULL THEN
        CALL cl_err("Response isn't valid XML document","!",1)
    RETURN
    END IF
    
    LET l_nl = l_request_root.selectByTagName("param")
    LET l_n = l_nl.item(1)
    LET l_n2 = l_n.getFirstChild()
    LET l_isEncoding = l_n2.getAttribute("@chars")
    LET l_isEncoding = l_isEncoding.toUpperCase()
    IF cl_null(l_isEncoding) THEN
        LET g_status.code = "-286"     #主鍵的欄位值不可為 NULL
        ROLLBACK WORK
    END IF

    CASE l_isEncoding
        WHEN "TRUE"
            LET l_wap09 = "Y"
        WHEN "FALSE"
            LET l_wap09 = "N"
        OTHERWISE
            LET l_wap09 = NULL #輸入錯誤
    END CASE 

    SELECT wap09 INTO l_wap09_d FROM wap_file WHERE wap01 ='0'
    
    IF l_wap09 = l_wap09_d THEN  #狀態無改變, 服務結束
        CALL l_srvcode.appendChild(l_resdoc.createNode("001")) 
        ROLLBACK WORK
        LET l_return = l_response_root.toString()
        LET g_response.response = l_return
        RETURN
    END IF 

    #----------------------------------------------------------------------#
    # 執行 INSERT / UPDATE SQL                                             #
    #----------------------------------------------------------------------#
    LET g_status.code = 0
    IF l_wap09 IS NOT NULL THEN
        UPDATE wap_file SET wap09 = l_wap09 WHERE wap01 = '0'
        CALL l_srvcode.appendChild(l_resdoc.createNode("001")) 
        IF SQLCA.SQLCODE THEN
            LET g_status.code = SQLCA.SQLCODE
            LET g_status.sqlcode = SQLCA.SQLCODE
        END IF
    ELSE
        CALL l_srvcode.appendChild(l_resdoc.createNode("100")) 
    END IF
    
    #全部處理都成功才 COMMIT WORK
    IF g_status.code = "0" THEN
        COMMIT WORK
    ELSE
        CALL l_srvcode.appendChild(l_resdoc.createNode("100")) 
        ROLLBACK WORK
    END IF

    LET l_return = l_response_root.toString()
    LET g_response.response = l_return
END FUNCTION
#FUN-BB0161 -  End -

#FUN-C80059 - Start -
#{  
# Descriptions...: 取得編碼狀態服務
# Date & Author..: 2012/08/15 by Kevin
# Memo...........:
# Modify.........:  
#         
#}     
FUNCTION aws_sync_getEncodingState()   
    DEFINE l_wap09           LIKE wap_file.wap09
    DEFINE l_resdoc          om.DomDocument
    DEFINE l_request_root    om.DomNode
    DEFINE l_response_root   om.DomNode

    DEFINE l_payload         om.DomNode
    DEFINE l_return          STRING
    DEFINE l_srvcode         STRING
    DEFINE l_pnode           om.DomNode
    DEFINE l_tnode           om.DomNode

    LET l_resdoc = om.DomDocument.create("response")
    LET l_response_root = l_resdoc.getDocumentElement()
    LET l_pnode = l_response_root.createChild("srvcode")    #建立 <srvcode>
    LET l_payload = l_response_root.createChild("payload")  #建立 <payload>

    SELECT wap09 INTO l_wap09 FROM wap_file WHERE wap01 = '0'

    IF SQLCA.SQLCODE THEN
       LET l_srvcode = "100"
    ELSE
       LET l_srvcode = "001"
       IF l_wap09 = "Y" THEN
          LET l_payload = aws_create_node_param( l_resdoc ,l_payload,"isEncoding","boolean",  "true")
       ELSE
          LET l_payload = aws_create_node_param( l_resdoc ,l_payload,"isEncoding","boolean",  "false")
       END IF
    END IF

    LET l_tnode = l_resdoc.createChars(l_srvcode.trim())
    CALL l_pnode.appendChild(l_tnode)

    LET l_return = l_response_root.toString()
    LET g_response.response = l_return
END FUNCTION

FUNCTION  aws_create_node_param(p_doc,p_node,p_key,p_type,p_text)
DEFINE p_doc        om.DomDocument
DEFINE p_node       om.DomNode
DEFINE p_key        STRING
DEFINE p_type       STRING
DEFINE p_text       STRING
DEFINE l_tnode      om.DomNode
DEFINE l_pnode      om.DomNode

       LET l_pnode = p_node.createChild("param")                     #建立 <param>
       LET l_tnode = p_doc.createChars(p_text.trim())
       CALL l_pnode.appendChild(l_tnode)
       CALL l_pnode.setAttribute("key", p_key.trim())
       CALL l_pnode.setAttribute("type", p_type.trim())

       RETURN p_node
END FUNCTION
#FUN-C80059 - end -
