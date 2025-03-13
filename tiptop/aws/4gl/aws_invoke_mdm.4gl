# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#{
# Program name...: aws_invoke_mdm.4gl
# Descriptions...: 透過 Web Services  TIPTOP 與 CROSS-MDM 整合
# Date & Author..: 2011/05/06 by Jay
# Memo...........:
# Modify.........: 新建立 FUN-B50032
# Modify.........: No.FUN-BB0161 11/11/29 By ka0132 提供更新編碼狀態服務
# Modify.........: No:FUN-C60080 12/06/26 By Kevin 重新連線 database ds
# Modify.........: No:FUN-C70031 12/07/10 By Kevin 檢查是否已連線 ds
#}

IMPORT xml

DATABASE ds

#FUN-B50032
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

DEFINE g_request_root    om.DomNode      #Request XML Dom Node
DEFINE g_reqdoc          om.DomDocument  
DEFINE g_master_data     DYNAMIC ARRAY of RECORD
         sch01             LIKE sch_file.sch01,
         sch02             LIKE sch_file.sch02,
         field_value       STRING
                         END RECORD
DEFINE g_srvcode         STRING          #錯誤代碼
DEFINE g_msg             STRING          #錯誤訊息
 
#[
# Description....: 提供服務呼叫invokeMdm(入口function)
# Date & Author..: 2011/05/09 by Jay
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_invoke_mdm()  
    WHENEVER ERROR CONTINUE

    #FUN-C60080 start
    CALL aws_ttsrv_conn_ds()   #FUN-C70031
    #FUN-C60080 end

    #紀錄 Request XML
    CALL aws_ttsrv_writeRequestLog()    
    LET g_request.request = cl_coding_de(g_request.request)         #FUN-BB0161 解碼

    #--------------------------------------------------------------------------#
    # CROSS平台Request資訊                                                     #
    #--------------------------------------------------------------------------#
    CALL aws_invoke_mdm_process()

    LET g_response.response = cl_coding_en(g_response.response)     #FUN-BB0161 編碼

    #紀錄 Response XML
    CALL aws_ttsrv_writeResponseLog()   
END FUNCTION


#[
# Description....: CROSS平台invokeMdm服務處理
# Date & Author..: 2011/05/09 by Jay
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_invoke_mdm_process()
   DEFINE l_service          STRING               #服務名稱
   DEFINE l_mdm_table_name   STRING               #主資料表名稱
   DEFINE l_table            LIKE sch_file.sch01  #同步資料表名稱
   DEFINE l_field_name       LIKE sch_file.sch02  #有效/無效碼欄位

   LET g_srvcode = ""
   LET g_msg = ""
   LET g_request_root = aws_cross_stringToXml(g_request.request)
    
   IF g_request_root IS NULL THEN
      CALL aws_sync_prod_doSyncProcess_response("586", "Request isn't valid XML document.") #FUN-BB0161
      display "error: 586  Request isn't valid XML document. "       ##FUN-BB0161
      CALL cl_err("Response isn't valid XML document","!",1)
      RETURN
   END IF

   #尋找對應名稱的tag資料,取得CROSS平台要求服務名稱                              
   LET l_service = aws_cross_getTagValue(g_request_root, "service", "name")

   IF cl_null(l_service) OR l_service CLIPPED <> "syncMasterData" THEN
      CALL aws_sync_prod_doSyncProcess_response("586", "Service name isn't valid.")  #FUN-BB0161
      display "error: 100  Service name isn't valid.. "   #FUN-BB0161
      RETURN
   END IF

   #取得主資料表名稱
   LET l_mdm_table_name = aws_cross_getTagValue(g_request_root, "MdmTableName", "@chars")
   LET l_mdm_table_name = l_mdm_table_name.toLowerCase()

   #判斷資料表是否屬於可同步的資料表範圍,順便取得TIPTOP端需同步之資料表名稱和欄位資訊
   CALL aws_invoke_mdm_syncTable(l_mdm_table_name) RETURNING l_table, l_field_name
   IF cl_null(l_table) THEN
      CALL aws_sync_prod_doSyncProcess_response("583", cl_getmsg("aws-719", g_lang))
      RETURN
   END IF

   #呼叫原先services程式
   IF NOT aws_invoke_mdm_callFunction(l_table, l_field_name) THEN
      RETURN
   END IF

   IF cl_null(g_response.response) THEN
       LET g_srvcode = "586"                #服務未按照正常流程執行
       LET g_msg = "Service abnormal." 
    END IF

    IF g_status.code = "0" THEN
       LET g_srvcode = "000"
       LET g_msg = ""
    ELSE
       LET g_srvcode = "586"
       LET g_msg = "status: ", g_status.code, ";  sqlcode:", g_status.sqlcode, ";  ",
                   "description: ", g_status.description
    END IF
     
    CALL aws_sync_prod_doSyncProcess_response(g_srvcode, g_msg)
    DISPLAY "code: ",g_srvcode , "  msg: ",g_msg                        #FUN-BB0161
END FUNCTION

#[
# Description....: 建立 Request XML  Document
# Date & Author..: 2010/05/09 by Jay
# Parameter......: p_table        - STRING   - 同步資料表名稱
# Parameter......: p_field_name   - STRING   - 有效/無效碼欄位名稱
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_invoke_mdm_createRequest(p_table, p_field_name)   
   DEFINE p_table                LIKE sch_file.sch01
   DEFINE p_field_name           LIKE sch_file.sch02
   DEFINE l_request_root         om.DomNode              #Request XML Dom Node
   DEFINE l_node                 om.DomNode
   DEFINE l_document_node        om.DomNode
   DEFINE l_recordset_node       om.DomNode
   DEFINE l_master_node          om.DomNode
   DEFINE l_record_node          om.DomNode
   DEFINE l_field_node           om.DomNode
   DEFINE l_node_list            om.NodeList
   DEFINE l_application          STRING                  #呼叫端系統代號
   DEFINE l_source               STRING                  #呼叫端來源 IP or Host
   DEFINE l_name                 STRING                  #此次呼叫指定存取的 ERP 營運中心代碼
   DEFINE l_language             STRING                  #此次呼叫指定存取的 ERP 營運中心代碼
   DEFINE l_action               STRING                  #資料執行動作，可為insert、update、delete
   DEFINE l_i                    LIKE type_file.num5
   DEFINE l_cnt                  LIKE type_file.num5

   LET g_srvcode = ""
   LET g_msg = ""
   LET g_reqdoc = om.DomDocument.create("request")     
   LET l_request_root = g_reqdoc.getDocumentElement()  

   #建立 <Access> tag
   LET l_node = l_request_root.createChild("Access") 

   #建立 <Access>/<Authentication> tag 及相關屬性
   LET l_node = aws_invoke_mdm_param(l_node, "Authentication", "user|tiptop,password|\"\"", "")

   #建立 <Access>/<Connection> tag 及相關屬性                
   LET l_application = aws_cross_getTagValue(g_request_root, "host", "prod")
   LET l_source = aws_cross_getTagValue(g_request_root, "host", "ip")
   LET l_node = aws_invoke_mdm_param(l_node, "Connection", 
                                     "application|" || l_application || ",source|" || l_source, "") 

   #建立 <Access>/<Organization> tag 及相關屬性                
   LET l_name = aws_cross_getTagValue(g_request_root, "PlantCode", "@chars")
   LET l_node = aws_invoke_mdm_param(l_node, "Organization", "name|" || l_name, "")

   #建立 <Access>/<Locale> tag 及相關屬性                
   LET l_language = aws_cross_getTagValue(g_request_root, "host", "lang")
   IF cl_null(l_language) THEN
      LET l_language = "en_us"
   END IF
   LET l_node = aws_invoke_mdm_param(l_node, "Locale", "language|" || l_language, "")

   #建立 <RequestContent> tag
   LET l_node = l_request_root.createChild("RequestContent")

   #建立 <RequestContent>/<Parameter> tag 及相關屬性
   LET l_node = aws_invoke_mdm_param(l_node, "Parameter", "", "")

   #找出此次資料執行動作
   LET l_action = aws_cross_getTagValue(g_request_root, "record", "action")
   LET l_action = l_action.toUpperCase()

   #建立 <RequestContent>/<Document> tag
   LET l_document_node = l_node.createChild("Document")
   
   #建立 <RequestContent>/<Document>/<RecordSet> tag 及相關屬性
   LET l_recordset_node = l_document_node.createChild("RecordSet")
   CALL l_recordset_node.setAttribute("id", "1")

   #建立 <RequestContent>/<Document>/<RecordSet>/<Master> tag
   LET l_master_node = l_recordset_node.createChild("Master")
   CALL l_master_node.setAttribute("name", p_table)

   #建立 <RequestContent>/<Document>/<RecordSet>/<Master>/<Record> tag
   LET l_record_node = l_master_node.createChild("Record")

   #同步欄位與欄位值   
   LET l_node_list = g_request_root.selectByPath("//record/field")
   FOR l_i = 1 TO l_node_list.getLength()
       LET l_node = l_node_list.item(l_i)
       LET g_master_data[l_i].sch01 = p_table CLIPPED
       LET g_master_data[l_i].sch02 = aws_cross_getTagValue(l_node, "field", "name")
       LET g_master_data[l_i].field_value  = aws_cross_getTagValue(l_node, "field", "@chars")

       
       #檢查欄位名稱是否正確
       SELECT COUNT(*) INTO l_cnt FROM sch_file 
         WHERE sch01 = g_master_data[l_i].sch01 AND sch02 =  g_master_data[l_i].sch02
       IF SQLCA.sqlcode THEN
          LET g_srvcode = "585"
          LET g_msg = "sqlcode:", SQLCA.sqlcode
          RETURN 
       END IF
       IF l_cnt < 1 THEN
          LET g_srvcode = "584"
          LET g_msg = "Field name isn't valid."
          RETURN
       END IF
   END FOR

   #CALL aws_invoke_mdm_check_data(l_action, l_name)
   #如果是delete狀態,則要將acti欄位UPDATE成"N"
   IF NOT cl_null(p_field_name) AND l_action.trim() = "DELETE" THEN
      LET l_cnt = g_master_data.getLength()
      LET g_master_data[l_cnt + 1].sch01 = p_table
      LET g_master_data[l_cnt + 1].sch02 = p_field_name
      LET g_master_data[l_cnt + 1].field_value = "N"
   END IF

   #上述FUNCTION操作有錯,直接return
   IF NOT cl_null(g_srvcode) THEN
      RETURN
   END IF

   #建立的XML基本資料內容
   LET l_cnt = g_master_data.getLength()
   FOR l_i = 1 TO l_cnt
       #建立 <RequestContent>/<Document>/<RecordSet>/<Master>/<Record>/<Field> tag
       LET l_field_node = aws_invoke_mdm_param(l_record_node, "Field", 
                              "name|" || g_master_data[l_i].sch02 || ",value|" || g_master_data[l_i].field_value, "")
   END FOR
   
   LET g_request.request = l_request_root.toString()
   LET g_srvcode = ""
END FUNCTION

#[
# Description....: 建立 param 資料
# Date & Author..: 2010/05/09 by Jay
# Parameter......: p_node   -    DomNode   - XML Dom 
#                : p_key    -    STRING    - tag名稱
#                : p_param  -    STRING    - 增加此 tag 的屬性, 利用 ","區分屬性， 屬性名稱與屬性值用"|"區隔
#                : p_text   -    STRING    - 內容值
# Return.........: p_pnode  -    DomNode   - XML Dom 
# Memo...........:
# Modify.........:
#]
FUNCTION aws_invoke_mdm_param(p_node, p_key, p_param, p_text)
   DEFINE p_node       om.DomNode
   DEFINE p_key        STRING
   DEFINE p_param      STRING
   DEFINE p_text       STRING
   DEFINE l_tnode      om.DomNode
   DEFINE l_pnode      om.DomNode
   DEFINE l_tok        base.StringTokenizer
   DEFINE l_str        STRING
   DEFINE l_name       STRING                 #屬性名稱
   DEFINE l_value      STRING                 #屬性值
   DEFINE l_p          LIKE type_file.num5    #區隔符號(|)位置
      
   LET l_pnode = p_node.createChild(p_key)     #建立 tag

   #建立tag值
   IF NOT cl_null(p_text) THEN  
      LET l_tnode = g_reqdoc.createChars(p_text.trim())
      CALL l_pnode.appendChild(l_tnode)
   END IF

   #建立此tag屬性
   IF NOT cl_null(p_param) THEN
       LET l_tok = base.StringTokenizer.createExt(p_param, ",", "", TRUE)
       WHILE l_tok.hasMoreTokens()
             LET l_str = l_tok.nextToken()
             LET l_p  = l_str.getIndexOf("|",1)
             IF l_p > 0 THEN
                LET l_name = l_str.subString(1, l_p-1)
                LET l_value = l_str.subString(l_p+1, l_str.getLength())
             ELSE    
                LET l_name = l_str
             END IF
             CALL l_pnode.setAttribute(l_name.trim(), l_value.trim())
        END WHILE
    END IF  

    RETURN p_node
END FUNCTION 

#[
# Description....: 檢查欄位資料是否正確及資料是否存在
# Date & Author..: 2010/05/09 by Jay
# Parameter......: p_action       -    STRING           - 資料執行動作
#                : p_azp01        -    azp_file.azp01   - 營運中心代碼
# Return.........: none
# Memo...........:
# Modify.........:
#]
FUNCTION aws_invoke_mdm_check_data(p_action, p_azp01)
   DEFINE p_action        STRING
   DEFINE p_azp01         LIKE azp_file.azp01     #營運中心代碼
   DEFINE l_sql           STRING                  #SQL
   DEFINE l_wc            STRING                  #where 條件 
   DEFINE l_table         STRING                  #[table owner].[table]
   DEFINE l_i             LIKE type_file.num5
   DEFINE l_cnt           LIKE type_file.num5
   DEFINE l_acti_pos      LIKE type_file.num5

   LET g_srvcode = ""
   LET g_msg = ""
   LET l_acti_pos = 0
   LET l_cnt = g_master_data.getLength()
   IF l_cnt < 1 THEN
      LET g_srvcode = "586"
      LET g_msg = "No data!"
      RETURN
   END IF

   #檢查資料在資料表中是否存在
   FOR l_i = 1 TO l_cnt
       #利用pk欄位組合where條件,查詢此筆資料是否存在
       IF g_master_data[l_i].sch02 = "gem01" OR g_master_data[l_i].sch02 = "gen01" THEN
          LET l_wc = l_wc, g_master_data[l_i].sch02, " = '", 
                           g_master_data[l_i].field_value, "'"
       END IF

       #找出有效/無效碼欄位
       IF g_master_data[l_i].sch02 = "gemacti" OR g_master_data[l_i].sch02 = "genacti" THEN
          LET l_acti_pos = l_i
       END IF 
   END FOR

   #檢查table資料所屬db user name,準備後面組select sql找該筆資料是屬存在
   LET l_table = aws_invoke_mdm_check_plant(p_azp01, g_master_data[l_cnt].sch01)
   IF NOT cl_null(g_srvcode) THEN
      RETURN
   END IF
   
   LET l_sql = "SELECT COUNT(*) FROM ", l_table, 
               "  WHERE ", l_wc

   PREPARE check_data_pre FROM l_sql
   EXECUTE check_data_pre INTO l_cnt
   IF SQLCA.sqlcode THEN
      LET g_srvcode = "586"
      LET g_msg = "sqlcode:", SQLCA.sqlcode
      RETURN
   END IF

   LET p_action = p_action.toUpperCase()

   #針對各種action,判斷一下資料狀態是否符合
   CASE 
       WHEN p_action.trim() = "INSERT" 
            IF l_cnt > 0 THEN
               LET g_srvcode = "581"
               LET g_msg = "Data exists!"
            END IF
       WHEN (p_action.trim() = "UPDATE" OR p_action.trim() = "DELETE")  
            IF l_cnt < 1 THEN
               LET g_srvcode = "582"
               LET g_msg = "Data not found!"
            END IF
       OTHERWISE
          LET g_srvcode = "586"
          LET g_msg = "Record action error!"
   END CASE
   
   IF NOT cl_null(g_srvcode) THEN
      RETURN
   END IF

   #如果是delete狀態,則要將acti欄位UPDATE成"N"
   IF p_action.trim() = "DELETE" AND l_acti_pos > 0 THEN
      LET g_master_data[l_acti_pos].field_value = "N"
   END IF

   IF p_action.trim() = "DELETE" AND l_acti_pos = 0 THEN
      LET l_cnt = g_master_data.getLength()
      LET g_master_data[l_cnt + 1].sch01 = g_master_data[l_cnt].sch01
      LET g_master_data[l_cnt + 1].field_value = "N"

      IF g_master_data[l_cnt].sch01 = "gem_file" THEN
         LET g_master_data[l_cnt + 1].sch02 = "gemacti"
      ELSE
         LET g_master_data[l_cnt + 1].sch02 = "genacti"
      END IF
   END IF

   LET g_srvcode = ""
END FUNCTION

#[
# Description....: 檢查營運中心是否存在
# Date & Author..: 2010/05/09 by Jay
# Parameter......: p_plant        -    azw_file.azw01   - 營運中心代碼
#                : p_table        -    sch_file.sch01   - 資料表名稱
# Return.........: l_table        -    STRING           - [table owner].[table]
# Memo...........:
# Modify.........:
#]
FUNCTION aws_invoke_mdm_check_plant(p_plant, p_table)
   DEFINE p_plant         LIKE azw_file.azw01     #營運中心代碼
   DEFINE p_table         LIKE sch_file.sch01     #資料表名稱
   DEFINE l_db            LIKE azw_file.azw05     #[table owner].[table]
   DEFINE l_db_cnt        LIKE type_file.num5
   DEFINE l_table         STRING                  #[table owner].[table]

   LET l_table = ""
   IF cl_null(p_plant) THEN
      LET g_srvcode = "586"
      LET g_msg = "No ERP organization specified!"
      RETURN l_table
   END IF

   SELECT COUNT(*) INTO l_db_cnt FROM azw_file WHERE azw01 = p_plant
   IF l_db_cnt > 0 THEN #所有Plant都應該要存在於azw_file內.
      #判斷此Table是否有xxxplant欄位.
      IF cl_table_exist_plant(p_table) THEN
         #交易資料要抓取登入Plant所對應的Transaction DB
         SELECT azw05 INTO l_db FROM azw_file WHERE azw01 = p_plant
      ELSE
         #基本資料要抓取登入Plant所對應的DB
         SELECT azw06 INTO l_db FROM azw_file WHERE azw01 = p_plant
      END IF

      LET l_table = s_dbstring(l_db CLIPPED), p_table CLIPPED
   ELSE
      LET g_srvcode = "586"
      LET g_msg = "sqlcode:100; Access validate fail!"
      RETURN l_table
   END IF

   LET g_srvcode = ""
   RETURN l_table
END FUNCTION 

#[
# Description....: 取得需同步之資料表名稱及有效/無效碼欄位
# Date & Author..: 2010/06/02 by Jay
# Parameter......: p_mdm_table_name  - STRING           - 同步資料表名稱
# Return.........: l_table           - sch_file.sch01   - [table name]
#                : l_field_name      - sch_file.sch02   - [field name]
# Memo...........:
# Modify.........:
#]
FUNCTION aws_invoke_mdm_syncTable(p_mdm_table_name)
   DEFINE p_mdm_table_name       STRING
   DEFINE l_table                LIKE sch_file.sch01
   DEFINE l_field_name           LIKE sch_file.sch02
   
   CASE p_mdm_table_name
       WHEN "organizationunit"    #部門基本資料同步
          LET l_table = "gem_file"
          LET l_field_name = "gemacti"

       WHEN "users"               #員工基本資料同步
          LET l_table = "gen_file"
          LET l_field_name = "genacti"

       OTHERWISE
          LET l_table = ""
          LET l_field_name = ""
   END CASE

   RETURN l_table, l_field_name
END FUNCTION 

#[
# Description....: CALL Function
# Date & Author..: 2010/06/02 by Jay
# Parameter......: l_table           - sch_file.sch01   - [table name]
#                : l_field_name      - sch_file.sch02   - [field name]
# Return.........: none
# Memo...........:
# Modify.........:
#]
FUNCTION aws_invoke_mdm_callFunction(p_table, p_field_name)
   DEFINE p_table                LIKE sch_file.sch01
   DEFINE p_field_name           LIKE sch_file.sch02

   CALL g_master_data.clear()
   CALL aws_invoke_mdm_createRequest(p_table, p_field_name)

   IF NOT cl_null(g_srvcode) THEN
      CALL aws_sync_prod_doSyncProcess_response(g_srvcode, g_msg)
      RETURN FALSE
   END IF
   
   CASE p_table
       WHEN "gem_file"    #部門基本資料同步
          CALL aws_create_department_data()

       WHEN "gen_file"    #員工基本資料同步
          CALL aws_create_employee_data()
   END CASE

   RETURN TRUE
END FUNCTION 


