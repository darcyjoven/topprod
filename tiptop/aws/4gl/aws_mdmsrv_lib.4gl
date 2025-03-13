# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#{
# Program name...: aws_mdmsrv_lib.4gl
# Descriptions...: 處理 TIPTOP 服務的共用 FUNCTION
# Date & Author..: 2008/06/05 by Echo
# Memo...........:
# Modify.........: 新建立 FUN-850147
# Modify.........: 08/09/24 By kevin FUN-890113 多筆傳送
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No.FUN-A10080 10/01/15 By Echo 重新過單
#}
IMPORT com
 

IMPORT os   #No.FUN-9C0009  
DATABASE ds
 
#FUN-850147 #FUN-A10080
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"
GLOBALS "../4gl/aws_mdmsrv_global.4gl"
GLOBALS
 DEFINE g_mdm_field  DYNAMIC ARRAY WITH DIMENSION 2 OF RECORD
                       name    STRING,     #欄位名稱
                       value   STRING      #欄位值
                     END RECORD
END GLOBALS
DEFINE g_wsw04       LIKE wsw_file.wsw04
 
#[
# Description....: 記錄參數字串至記錄檔中
# Date & Author..: 2007/09/05 by Echo
# Parameter......: p_cmd - STRING - 判別傳入參數(in)/回傳參數(out)
# Return.........: none
# Memo...........:
#
#]
FUNCTION aws_mdmsrv_file(p_cmd)
DEFINE p_cmd           STRING
DEFINE l_str           STRING,
       l_file          STRING,
       l_cmd           STRING
DEFINE l_ch            base.Channel
DEFINE l_node          om.DomNode
 
 
    LET l_file = fgl_getenv("TEMPDIR"), "/aws_mdmsrv-", TODAY USING 'YYYYMMDD', ".log"
    LET l_ch = base.Channel.create()
    CALL l_ch.openFile(l_file, "a")
    CALL l_ch.setDelimiter("")
    IF STATUS = 0 THEN
       IF p_cmd = "in" THEN
          LET l_str = "#--------------------------- (", CURRENT YEAR TO SECOND, ") ----------------------------#"
          CALL l_ch.write(l_str)
          CALL l_ch.write("")
          LET l_str = "Method: ", syncMasterData_in.in0.mddTableName CLIPPED
          CALL l_ch.write(l_str)
         
          CALL l_ch.write("Request XML:")
          #-----------------------------------------------------------------------#
          # 將輸入參數的 XML 文件轉換成紀錄於 log 檔中的字串                      #
          #-----------------------------------------------------------------------#
          LET l_str = aws_ttsrv_translateParameterXmlToString(base.TypeInfo.create(syncMasterData_in))
          CALL l_ch.write(l_str)
          CALL l_ch.write("")
         
       ELSE
          CALL l_ch.write("Response XML:")
          #--------------------------------------------------------------------#
          # 將輸入參數的 XML 文件轉換成紀錄於 log 檔中的字串                   #
          #--------------------------------------------------------------------#
          LET l_str = aws_ttsrv_translateParameterXmlToString(base.TypeInfo.create(syncMasterData_out))
          CALL l_ch.write(l_str)
          CALL l_ch.write("")
          CALL l_ch.write("#------------------------------------------------------------------------------#")
          
       END IF
 
       CALL l_ch.write("")
       CALL l_ch.close()
 
#      LET l_cmd = "chmod 666 ", l_file CLIPPED, " >/dev/null 2>&1"   #No.FUN-9C0009
#      RUN l_cmd                                          #No.FUN-9C0009
       IF os.Path.chrwx(l_file CLIPPED,438) THEN END IF   #No.FUN-9C0009
    ELSE
       DISPLAY "Can't open log file."
    END IF
END FUNCTION 
 
#[
# Description....: 將傳入參數轉換成 TIPTOP Services Gateway 參數格式  
# Date & Author..: 2007/09/05 by Echo
# Parameter......: p_table1,p_table2,p_table3,p_table4,p_table5
# Return.........: none
# Memo...........:
#
#]
FUNCTION aws_mdmsrv_trans_ttsrv(p_table1,p_table2,p_table3,p_table4,p_table5)
DEFINE p_service          STRING
DEFINE p_table1           STRING
DEFINE p_table2           STRING
DEFINE p_table3           STRING
DEFINE p_table4           STRING
DEFINE p_table5           STRING
DEFINE l_req_doc          om.DomDocument
DEFINE l_request          om.DomNode,
       l_anode            om.DomNode,
       l_cnode            om.DomNode,
       l_fnode            om.DomNode,
       l_mnode            om.DomNode,
       l_onode            om.DomNode,
       l_lnode            om.DomNode,
       l_rnode            om.DomNode,
       l_rnode2           om.DomNode,
       l_access_node      om.DomNode,
       l_req_node         om.DomNode,
       l_par_node         om.DomNode,
       l_doc_node         om.DomNode
DEFINE l_record_cnt       LIKE type_file.num10
DEFINE l_field_cnt        LIKE type_file.num10
DEFINE l_i                LIKE type_file.num10
DEFINE l_j                LIKE type_file.num10
DEFINE l_cnt              LIKE type_file.num10
DEFINE buf                base.StringBuffer
DEFINE l_plant            STRING
DEFINE l_lang             STRING
DEFINE l_xmlFile          STRING
DEFINE l_name             STRING
DEFINE l_b_cnt            LIKE type_file.num10
DEFINE l_wss01            LIKE wss_file.wss01   #FUN-890113
DEFINE l_wss06            LIKE wss_file.wss04   #FUN-890113
DEFINE l_cnt2             LIKE type_file.num10  #FUN-890113
 
 
 
   CALL g_mdm_field.clear()
 
    #--------------------------------------------------------------------------#
    #<!-- 傳入參數內容(XML 形式)範例 -->
    #<Request>
    #  <Access> 	<!-- 存取訊息 -->
    #	  <Authentication user="tiptop" password="tiptop"/>
    #	  <Connection application="DSCMDM" source="192.168.1.2"/>
    #	  <Organization name="DS-1"/>
    #     <Locale language="zh_tw"/>
    #  <Access>
    #  <RequestContent>
    #     <Parameter/>
    #     <Document>   
    #  	     <RecordSet id="1" >
    #    	<Master name="occ_file"> 
    #    	   <Record>
    #	             <Field name="occ01" value="cust_id" />
    #                <Field name="occ02" value="客戶簡稱" />
    #  	           </Record>	
    #	        </Master>
    #        </RecordSet>
    #     </Document>
    #  </RequestContent>
    #</Request>
    #--------------------------------------------------------------------------#
    LET l_req_doc = om.DomDocument.create("Request")
    LET l_request = l_req_doc.getDocumentElement()
 
    # -- 呼叫存取資訊 -- #
    LET l_access_node = l_request.createChild("Access")
    LET l_anode = l_access_node.createChild("Authentication")
   #CALL l_anode.setAttribute("user", syncMasterData_in.in0.username CLIPPED)
   #CALL l_anode.setAttribute("password", syncMasterData_in.in0.username CLIPPED)
    CALL l_anode.setAttribute("user", g_user)
    CALL l_anode.setAttribute("password", g_user)
 
    LET l_cnode = l_access_node.createChild("Connection")
    CALL l_cnode.setAttribute("application","DSCMDM")
    CALL l_cnode.setAttribute("source","")
 
    LET l_onode = l_access_node.createChild("Organization")
    #CALL l_onode.setAttribute("name",l_plant)
 
    LET l_lnode = l_access_node.createChild("Locale")
    #CALL l_lnode.setAttribute("language","")
 
    # -- 呼叫端所傳送的資料本體 -- #
    LET l_req_node = l_request.createChild("RequestContent")
    LET l_par_node = l_req_node.createChild("Parameter")
    LET l_doc_node = l_req_node.createChild("Document")
    LET l_b_cnt = 0 
    LET l_record_cnt = syncMasterData_in.in0.records.Record.getLength()
    FOR l_i = 1 TO l_record_cnt
 
        #FUN-890113 start
        #IF syncMasterData_in.in0.records.Record[l_i].id = 1 THEN 
           LET l_rnode = l_doc_node.createChild("RecordSet")
           CALL l_rnode.setAttribute("id", syncMasterData_in.in0.records.Record[l_i].id)
           
           LET l_mnode = l_rnode.createChild("Master")
           CALL l_mnode.setAttribute("name",p_table1)
        #ELSE
        #   IF syncMasterData_in.in0.records.Record[l_i].refid = 1 AND l_b_cnt = 0 THEN
        #      LET l_b_cnt = l_b_cnt + 1
        #      CASE l_b_cnt
        #           WHEN '1'  LET l_name = p_table2
        #           WHEN '2'  LET l_name = p_table3
        #           WHEN '3'  LET l_name = p_table4
        #           WHEN '4'  LET l_name = p_table5
        #      END CASE
        #      LET l_mnode = l_rnode.createChild("Detail")
        #      CALL l_mnode.setAttribute("name",l_name)
        #   END IF
        #END IF
        #FUN-890113 end
        LET l_rnode2 = l_mnode.createChild("Record")
        LET l_field_cnt = syncMasterData_in.in0.records.Record[l_i].fields.Field.getLength()
        #field 有三個欄位為固定值，分別為: 資料庫, 公司，語言別
        FOR l_j = 1 TO l_field_cnt
            CASE syncMasterData_in.in0.records.Record[l_i].fields.Field[l_j].name
              WHEN "DB"
                 LET l_plant = syncMasterData_in.in0.records.Record[l_i].fields.Field[l_j].value CLIPPED
                 CALL l_onode.setAttribute("name",l_plant)
 
              WHEN "Company"
 
              WHEN "Language"
                 LET l_lang = syncMasterData_in.in0.records.Record[l_i].fields.Field[l_j].value CLIPPED
                 CALL l_lnode.setAttribute("language",l_lang)
                 CASE l_lang 
                   WHEN "ZH_TW" 
                         LET g_lang = "0"
                   OTHERWISE
                         LET g_lang = "1"
                 END CASE
                 display g_lang
 
              OTHERWISE
                 #FUN-890113 start 
                 LET l_wss01 = g_service
                 LET l_wss06 = syncMasterData_in.in0.records.Record[l_i].fields.Field[l_j].name CLIPPED
                 SELECT COUNT(*)  INTO l_cnt2 FROM  wss_file where wss01 =  l_wss01
                        and wss02 = 'S' and wss03='DSCMDM' and wss06 = l_wss06
 
                 IF l_cnt2 > 0 THEN #判斷欄位是否存在於wss_file中
                    LET l_cnt = l_cnt + 1
                    LET g_mdm_field[l_i,l_cnt].name = l_wss06
                    LET g_mdm_field[l_i,l_cnt].value = syncMasterData_in.in0.records.Record[l_i].fields.Field[l_j].value CLIPPED
                    LET l_fnode = l_rnode2.createChild("Field")
                    CALL l_fnode.setAttribute("name", g_mdm_field[l_i,l_cnt].name CLIPPED)
                    CALL l_fnode.setAttribute("value", g_mdm_field[l_i,l_cnt].value CLIPPED)
                 END IF
                 #FUN-890113 end
            END CASE
        END FOR       
    END FOR
   
    LET l_xmlFile = fgl_getenv("TEMPDIR"), "/", "aws_mdmsrv_", FGL_GETPID() USING '<<<<<<<<<<', ".xml"
    CALL l_request.writeXML(l_xmlFile)
    LET g_request.request = aws_ttsrv_xmlToString(l_request) 
    LET buf = base.StringBuffer.create()
    CALL buf.append(g_request.request)
    CALL buf.replace( "\n","", 0)
    LET g_request.request = buf.toString()
    display "g_mdm_dataSet:", g_request.request
 
    RUN "rm -f " || l_xmlFile || " >/dev/null 2>&1"
 
END FUNCTION
 
#[
# Description....: 處理回傳參數  
# Date & Author..: 2007/09/05 by Echo
# Parameter......: none
# Return.........: none
# Memo...........:
#
#]
FUNCTION aws_mdmsrv_processResponse()
 
   LET syncMasterData_out.out.action = syncMasterData_in.in0.action
   LET syncMasterData_out.out.applicationNameFrom = syncMasterData_in.in0.applicationNameFrom
   LET syncMasterData_out.out.applicationNameTo = syncMasterData_in.in0.applicationNameTo
   LET syncMasterData_out.out.createDate = CURRENT YEAR TO FRACTION(2)
   LET syncMasterData_out.out.flowName = syncMasterData_in.in0.flowName
   LET syncMasterData_out.out.id = "1"
   LET syncMasterData_out.out.mddTableName = syncMasterData_in.in0.mddTableName
   LET syncMasterData_out.out.serviceName = "ITPWebService"
   LET syncMasterData_out.out.username = syncMasterData_in.in0.username
   LET syncMasterData_out.out.loginUser = syncMasterData_in.in0.loginUser #FUN-890113
   display syncMasterData_out.out.loginUser
 
   IF g_status.code != "0" THEN
      CALL aws_mdmsrv_processErrorCode()
 
      LET syncMasterData_out.out.status = g_status.code 
      LET syncMasterData_out.out.errorMessage = g_status.description.trim()
      LET syncMasterData_out.out.syncRecords.SyncRecord[1].description = g_status.description.trim()
      LET syncMasterData_out.out.syncRecords.SyncRecord[1].id = syncMasterData_in.in0.records.Record[1].id
      LET syncMasterData_out.out.syncRecords.SyncRecord[1].Record.id = syncMasterData_in.in0.records.Record[1].id
      LET syncMasterData_out.out.syncRecords.SyncRecord[1].Record.fields.* = syncMasterData_in.in0.records.Record[1].fields.*
      LET syncMasterData_out.out.syncRecords.SyncRecord[1].status = g_status.code
   ELSE
      LET syncMasterData_out.out.status = "3"
   END IF 
   
END FUNCTION
 
#[
# Description....: 處理「刪除」action 動作
# Date & Author..: 2007/02/06 by Brendan
# Parameter......: p_file - STRING - 檔案名稱
#                : p_key1 - STRING - key值欄位#1
#                : p_key2 - STRING - key值欄位#2
#                : p_key3 - STRING - key值欄位#3
#                : p_key4 - STRING - key值欄位#4
#                : p_key5 - STRING - key值欄位#5
# Return.........: none
# Memo...........:
#
#]
FUNCTION aws_mdmsrv_delete(p_file,p_key1,p_key2,p_key3,p_key4,p_key5)
DEFINE p_file        STRING
DEFINE p_key1        STRING
DEFINE p_key2        STRING
DEFINE p_key3        STRING
DEFINE p_key4        STRING
DEFINE p_key5        STRING
DEFINE l_key         STRING
DEFINE l_sql         STRING
DEFINE l_sql2        STRING
DEFINE l_cnt         LIKE type_file.num10
DEFINE l_i           LIKE type_file.num10
DEFINE l_j           LIKE type_file.num10
DEFINE l_record_cnt  LIKE type_file.num10
DEFINE l_field_cnt   LIKE type_file.num10
DEFINE l_wss03       LIKE wss_file.wss03
 
   DATABASE ds
   CALL cl_ins_del_sid(1,'') #FUN-980030
 
   LET l_wss03 = 'DSCMDM'
 
   LET l_sql = "SELECT COUNT(*) FROM wss_file ",
               " WHERE wss01 = '",g_service,"'",
               "   AND wss02 = 'S'",
               "   AND wss03 = '",l_wss03 CLIPPED,"'"
   PREPARE wss_precount FROM l_sql
   DECLARE wss_count CURSOR FOR wss_precount
   OPEN wss_count
   FETCH wss_count INTO l_cnt
   IF l_cnt = 0 THEN
      LET l_wss03 ='*' 
   END IF
 
   #定義抓取他系統欄位的 cursor
   CALL aws_mdmsrv_lib_wss_cs(l_wss03)
 
   LET l_record_cnt = syncMasterData_in.in0.records.Record.getLength()
   FOR l_i = 1 TO l_record_cnt
 
       #組合 Delete 的 WHERE 條件式
       LET l_sql = ""
       IF NOT cl_null(p_key1) THEN
          LET l_key = p_key1
          LET p_key1 = aws_mdmsrv_wss(l_i,p_key1)
          LET l_sql =  p_key1
          IF NOT cl_null(p_key2) THEN
             LET l_key = l_key ,"|", p_key2
             LET p_key2 = aws_mdmsrv_wss(l_i,p_key2)
             LET l_sql = l_sql,' AND ', p_key2
             IF NOT cl_null(p_key3) THEN
                LET l_key = l_key ,"|", p_key3
                LET p_key3 = aws_mdmsrv_wss(l_i,p_key3)
                LET l_sql = l_sql,' AND ', p_key3
                IF NOT cl_null(p_key4) THEN
                   LET l_key = l_key ,"|", p_key4
                   LET p_key4 = aws_mdmsrv_wss(l_i,p_key4)
                   LET l_sql = l_sql,' AND ', p_key4
                   IF NOT cl_null(p_key5) THEN
                      LET l_key = l_key ,"|", p_key5
                      LET p_key5 = aws_mdmsrv_wss(l_i,p_key5)
                      LET l_sql = l_sql,' AND ', p_key5
                   END IF  
                END IF
             END IF  
          END IF  
       END IF  
       CALL aws_mdmsrv_wsw(p_file,l_key,l_i)
       IF g_wsw04 = 'delete' THEN
          CONTINUE FOR
       END IF
 
       LET l_field_cnt = syncMasterData_in.in0.records.Record[l_i].fields.Field.getLength()
       #field 有三個欄位為固定值，分別為: 資料庫, 公司，語言別
       FOR l_j = 1 TO l_field_cnt
           IF syncMasterData_in.in0.records.Record[l_i].fields.Field[l_j].name ="DB" THEN
              LET g_plant = syncMasterData_in.in0.records.Record[l_i].fields.Field[l_j].value
              SELECT COUNT(*) INTO l_cnt FROM azp_file WHERE azp01 = g_plant
              IF l_cnt = 0 THEN
                 LET g_status.code = "aws-083"
                 LET g_status.description = cl_getmsg(g_status.code, '0')
                 RETURN
              END IF
              IF NOT aws_ttsrv_changeDatabase() THEN
                 LET g_status.code = "aws-083"
                 LET g_status.description = cl_getmsg(g_status.code, '0')
                 RETURN
              END IF
 
              LET l_cnt = 0
              LET l_sql2 = "SELECT COUNT(*) FROM ", p_file ," WHERE ",l_sql
              display l_sql2
              PREPARE mdm_precount FROM l_sql2
              DECLARE mdm_count CURSOR FOR mdm_precount
              OPEN mdm_count
              FETCH mdm_count INTO l_cnt
              IF l_cnt = 0 THEN
                 LET g_status.code = "100" 
                 LET g_status.description = cl_getmsg(g_status.code, '0')
                 RETURN
              END IF
              CLOSE mdm_count
              
              #執行刪除動作
              LET l_sql2 = "DELETE FROM ",p_file," WHERE ",l_sql
              display "l_sql2:",l_sql2
              BEGIN WORK
              EXECUTE IMMEDIATE l_sql2
              IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN   #SQL 執行失敗
                 LET g_status.code = SQLCA.SQLCODE            #資料寫入錯誤
                 LET g_status.sqlcode = SQLCA.SQLCODE
                 LET g_status.description = cl_getmsg(g_status.code, '0')
                 ROLLBACK WORK
              ELSE
                 COMMIT WORK
              END IF
              EXIT FOR
           END IF
       END FOR       
   END FOR
 
END FUNCTION
 
 
#[
# Description....: 定義抓取他系統欄位的 cursor
# Date & Author..: 2007/02/06 by Brendan
# Parameter......: p_wss03 - STRING - 他系統代碼
# Return.........: none
# Memo...........:
#
#]
FUNCTION aws_mdmsrv_lib_wss_cs(p_wss03)
DEFINE p_wss03 STRING
DEFINE l_sql   STRING
 
   LET l_sql = "SELECT wss06 FROM wss_file ",
               " WHERE wss01 = '",g_service,"'",
               "   AND wss02 = 'S'",
               "   AND wss03 = '",p_wss03 CLIPPED,"'",
               "   AND wss04 = ? "
   DECLARE wss_cs CURSOR FROM l_sql
 
END FUNCTION
 
#[
# Description....: Mapping MDM 欄位，並組合 key值條件式
# Date & Author..: 2007/02/06 by Brendan
# Parameter......: p_i   - INTEGER - Record ID
# Parameter......: p_key - STRING - key值欄位#1
# Return.........: l_sql - STRING - key值條件式
# Memo...........:
#
#]
FUNCTION aws_mdmsrv_wss(p_i,p_key)
DEFINE p_i           LIKE type_file.num5
DEFINE p_key         STRING
DEFINE l_sql         STRING
DEFINE l_wss04       LIKE wss_file.wss04
DEFINE l_wss06       LIKE wss_file.wss06
DEFINE l_i           LIKE type_file.num5
 
      LET l_sql = p_key
      LET l_wss04 = p_key
 
      OPEN wss_cs USING l_wss04
      FETCH wss_cs INTO l_wss06
      IF NOT cl_null(l_wss06) THEN
         FOR l_i = 1 TO g_mdm_field[p_i].getLength()
             IF l_wss06 = g_mdm_field[p_i,l_i].name THEN
                LET l_sql = p_key,"='",g_mdm_field[p_i,l_i].value,"'"
             END IF
         END FOR
      END IF
      RETURN l_sql
END FUNCTION
 
#[
# Description....: 將錯誤代碼轉換成 MDM 定義的錯誤代碼
# Date & Author..: 2008/03/31
# Parameter......: 
# Return.........: 
# Memo...........:
#
#]
FUNCTION aws_mdmsrv_processErrorCode()
 
 IF g_status.code = "403" THEN
    RETURN
 END IF
 
 LET g_status.description = g_status.code CLIPPED,":",g_status.description
 CASE g_status.code
   WHEN "-286"                      #主鍵的欄位值為 NULL.
       LET g_status.code =  "404"
   WHEN "aws-100"                   #登入檢查錯誤
       LET g_status.code =  "402"
   WHEN "aws-101"                   #傳入資料參數錯誤
       LET g_status.code =  "401"
   WHEN "aws-102"                   #讀取服務設定錯誤
       LET g_status.code =  "401"
   WHEN "aws-083"                   #切換資料庫失敗
       LET g_status.code =  "402"  
   WHEN "100"                       #資料已經不存在 無法刪除
       LET g_status.code =  "400"  
   OTHERWISE                        #資料庫存取錯誤
       LET g_status.code =  "405"  
 END CASE
 
 
END FUNCTION
 
 
 
#[
# Description....: 更改同筆資料(key值相同)狀態
# Description....: 需判斷是否同筆資料(key值相同)狀態為未處理資料
# Date & Author..: 2008/03/31
# Parameter......: p_file - INTEGER - 檔案名稱
#                : p_key - STRING - key欄位值
#                : p_id - INTEGER - Record 筆數
# Return.........: 
# Memo...........:
#
#]
FUNCTION aws_mdmsrv_wsw(p_table,p_key,p_id)
   DEFINE p_table    LIKE wsv_file.wsv02
   DEFINE p_key      STRING
   DEFINE p_id       LIKE type_file.num10
   DEFINE l_key      LIKE wss_file.wss04
   DEFINE l_wss06    LIKE wss_file.wss06
   DEFINE l_j,l_i    LIKE type_file.num10
   DEFINE l_value    LIKE wsw_file.wsw03
   DEFINE l_action    string
   DEFINE l_tok       base.StringTokenizer
 
  LET g_wsw04 = ""
 
  LET l_action = syncMasterData_in.in0.action.toLowerCase()
  IF l_action = 'insert' OR l_action = 'update' THEN
     #定義抓取他系統欄位的 cursor
     CALL aws_mdmsrv_lib_wss_cs("DSCMDM")
 
     LET p_id = g_mdm_field.getLength()
  END IF
 
  FOR l_i = 1 TO p_id
      LET l_tok = base.StringTokenizer.createExt(p_key CLIPPED,"|","",TRUE)
      WHILE l_tok.hasMoreTokens()
         LET l_key = l_tok.nextToken()
         OPEN wss_cs USING l_key
         FETCH wss_cs INTO l_wss06
         FOR l_j = 1 TO g_mdm_field[l_i].getLength()
             IF l_wss06 = g_mdm_field[l_i,l_j].name THEN
                IF cl_null(l_value) THEN
                   LET l_value = g_mdm_field[l_i,l_i].value CLIPPED
                ELSE
                   LET l_value = l_value CLIPPED, "|",g_mdm_field[l_i,l_i].value CLIPPED
                END IF
                EXIT FOR
             END IF
         END FOR
      END WHILE
      IF NOT cl_null(l_value) THEN
         #若批次檔內有未處理資料，則狀況必須更改為「3:舊資料」
         SELECT wsw04 INTO g_wsw04 FROM wsw_file 
          WHERE wsw02 = p_table AND wsw03 = l_value AND wsw09 = '0'
         IF NOT cl_null(g_wsw04) THEN
            UPDATE  wsw_file  SET wsw09 = '3'
             WHERE wsw02 = p_table AND wsw03 = l_value
               AND wsw04 = g_wsw04 AND wsw09 = '0'
         END IF
      END IF
  END FOR
END FUNCTION
