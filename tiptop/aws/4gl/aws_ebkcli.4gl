# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Library name...: aws_ebkcli
# Descriptions...: 透過 Web Services 將 TIPTOP 表單與 eBanking 整合
# Return code....: '0' 表單開立不成功
#                  '1' 表單開立成功
# Date & Author..: 06/09/15 By Kevin
# Modify.........: No.FUN-680130 06/09/15 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No.FUN-720042 07/02/27 By Brendan Genero 2.0 調整
#
IMPORT com   #FUN-720042
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
#FUN-720042
 
GLOBALS "../4gl/aws_spcgw.inc"
GLOBALS "../4gl/awsef.4gl"
GLOBALS "../../config/top.global"
GLOBALS
DEFINE  mi_spc_trigger   LIKE type_file.num10       #No.FUN-680130 INTEGER
DEFINE  mi_spc_status    LIKE type_file.num10       #No.FUN-680130 INTEGER
END GLOBALS
 
DEFINE channel            base.Channel
DEFINE g_spcsoap          STRING
DEFINE g_result           STRING
DEFINE g_result_xml       om.DomNode
DEFINE g_request          om.DomNode,
       g_snode            om.DomNode,
       g_dnode            om.DomNode,
       g_rnode            om.DomNode,
       g_tnode            om.DomNode,
       g_rownode          om.DomNode
DEFINE g_req_doc          om.DomDocument
DEFINE g_status           LIKE type_file.num10      #No.FUN-680130 INTEGER
DEFINE g_qc_prog          LIKE type_file.chr1000    #No.FUN-680130 VARCHAR(10)
DEFINE g_result_value     STRING
 
FUNCTION aws_ebkcli(p_prog,p_key,p_action)
DEFINE p_prog             LIKE type_file.chr1000    #No.FUN-680130 VARCHAR(10)
DEFINE p_key              STRING
DEFINE p_action           STRING
DEFINE buf                base.StringBuffer
DEFINE l_str              STRING
DEFINE l_status           LIKE type_file.num10      #No.FUN-680130 INTEGER
DEFINE l_cnt              LIKE type_file.num10      #No.FUN-680130 INTEGER
 
    LET g_strXMLInput = NULL
    LET g_status = 1
 
   IF chk_ebklog(p_key) THEN #無採購註記記錄
       CALL cl_err('aza65','mfg3559',1)      
       LET g_status = 0
       RETURN g_status
   END IF
   
   IF g_aza.aza65 matches '[ Nn]' OR g_aza.aza65 IS NULL THEN #未設定與 eBanking 整合
       CALL cl_err('aza65','mfg3559',1)      
       LET g_status = 0
       RETURN g_status
   END IF
 
    CALL aws_ebkcli_prepareRequest('EBK040',p_action,p_prog)
    IF g_status = 0 THEN
       RETURN g_status
    END IF
 
    CALL aws_ebkcli_getErpData(p_prog,p_key)
    IF g_status = 0 THEN
         RETURN g_status 
    END IF
 
    CALL aws_ebkcli_processRequest()
 
    #轉換 & 為 &amp; 
    LET buf = base.StringBuffer.create()
    CALL buf.append(g_strXMLInput)
    CALL buf.replace( "&","&amp;", 0)
    LET g_strXMLInput = buf.toString()
 
{    LET SPCService_soapServerLocation = g_spcsoap  #指定 Soap server location
    CALL fgl_ws_setOption("http_invoketimeout", 60)                   #若 60 秒內無回應則放棄
    CALL SPCService_TipTopToSPCData(g_strXMLInput)
          RETURNING l_status, g_result
}
    CALL aws_ebkcli_file()                       #記錄傳遞的XML字串 
 
 {   IF l_status = 0 THEN
 
         CALL aws_ebkcli_processResult()
         LET g_result_value = aws_xml_getTagAttribute(g_result_xml,"Status", "result")
         
         IF g_result_value != '1' OR g_result_value IS NULL
         THEN
            IF g_result_value = '0' THEN
               IF fgl_getenv('FGLGUI') = '1' THEN
                  LET l_str = "XML parser error:\n\n",
                              aws_xml_getTagAttribute(g_result_xml,"Status","desc")
               ELSE
                  LET l_str = "XML parser error: ",
                              aws_xml_getTagAttribute(g_result_xml,"Status","desc")
               END IF
               CALL cl_err(l_str, '!', 1)   #XML 字串有問題
               LET g_status = 0
            ELSE
               CALL cl_err(NULL, 'aws-092', 1)   #開單成功
               LET g_status = 1
            END IF
         ELSE
            IF p_action = "insert" THEN
               CALL cl_err(NULL, 'aws-089', 1)   #開單成功
            END IF
            LET g_status = 1
         END IF
    ELSE
      IF fgl_getenv('FGLGUI') = '1' THEN
         LET l_str = "Connection failed:\n\n", 
                  "  [Code]: ", wsError.code, "\n",
                  "  [Action]: ", wsError.action, "\n",
                  "  [Description]: ", wsError.description
      ELSE
         LET l_str = "Connection failed: ", wsError.description
      END IF
      CALL cl_err(l_str, '!', 1)   #連接失敗
      LET g_status = 0
    END IF
}
    RETURN g_status
 
END FUNCTION 
 
FUNCTION aws_ebkcli_file()
    DEFINE l_str        STRING,
           l_file       STRING,
           l_cmd        STRING
    DEFINE l_ch         base.Channel
 
    #-----------------------------------------------------------------------
    # 記錄此次傳遞的 xml
    #-----------------------------------------------------------------------
    LET l_file = fgl_getenv("TEMPDIR"), "/aws_ebkcli-", TODAY USING 'YYYYMMDD', ".log"
    LET l_ch = base.Channel.create()
    CALL l_ch.openFile(l_file, "a")
    CALL l_ch.setDelimiter("")
    IF STATUS = 0 THEN
       LET l_str = "#--------------------------- (", CURRENT YEAR TO SECOND, ") ----------------------------#"
       CALL l_ch.write(l_str)
       CALL l_ch.write("")
       LET l_str = "Program: ", g_prog CLIPPED
       CALL l_ch.write(l_str)
    
       CALL l_ch.write("Request XML:")
       CALL l_ch.write(g_strXMLInput)
       CALL l_ch.write("")
 
       CALL l_ch.write("Response XML:")
       CALL l_ch.write(g_result)
       CALL l_ch.write("")
       CALL l_ch.write("#------------------------------------------------------------------------------#")
       CALL l_ch.write("")
       CALL l_ch.write("")
       CALL l_ch.close()
 
       LET l_cmd = "chmod 666 ", l_file CLIPPED, " >/dev/null 2>&1"
       RUN l_cmd
    ELSE
       DISPLAY "Can't open log file."
    END IF
END FUNCTION
 
FUNCTION aws_ebkcli_prepareRequest(p_method,p_action,p_prog)
DEFINE p_method      STRING
DEFINE p_action      STRING
DEFINE p_prog        LIKE type_file.chr1000 #No.FUN-680130 VARCHAR(10)
DEFINE l_client      STRING,
       l_spcsiteip   STRING
 
    LET l_client = cl_getClientIP()       #Client IP
    LET g_spcsoap = "http://10.40.16.154/WebEBanking/WebEBanking.asmx"   #EasyFlow SOAP
    LET l_spcsiteip = "10.40.16.154"      #EasyFlow server IP
 
    LET g_req_doc = om.DomDocument.create("Request")
    LET g_request = g_req_doc.getDocumentElement()
    CALL g_request.setAttribute("name", p_method CLIPPED)
    CALL g_request.setAttribute("action", p_action CLIPPED)
    CALL g_request.setAttribute("version", "1.0")
    LET g_snode = g_request.createChild("Info")
    CALL g_snode.setAttribute("senderIp", l_client)
    CALL g_snode.setAttribute("receiverIp", l_spcsiteip )
    CALL g_snode.setAttribute("userId", g_user )
    #LET g_rnode = g_request.createChild("Record")
 
END FUNCTION
 
#------------------------------------------------------------------------------
# 處理 Request xml string, 傳送至 eBanking server
#------------------------------------------------------------------------------
FUNCTION aws_ebkcli_processRequest()
    DEFINE l_msg      STRING
    DEFINE l_status   STRING
    DEFINE l_ch       base.Channel
    DEFINE l_buf      STRING
    DEFINE l_i        LIKE type_file.num10   #No.FUN-680130 INTEGER
    DEFINE l_file     STRING
 
    LET l_file = fgl_getenv("TEMPDIR"), "/", fgl_getpid() USING '<<<<<<<<<<', ".xml"
    CALL g_request.writeXml(l_file)
    LET l_ch = base.Channel.create()
    CALL l_ch.openFile(l_file, "r")
    CALL l_ch.setDelimiter(NULL)
    LET l_i = 1
    WHILE l_ch.read(l_buf)
        IF l_i != 1 THEN
           LET g_strXMLInput = g_strXMLInput, '\n'
        END IF
        LET g_strXMLInput = g_strXMLInput, l_buf CLIPPED
        LET l_i = l_i + 1
    END WHILE
    CALL l_ch.close()
    RUN "rm -f " || l_file
 
END FUNCTION
 
FUNCTION aws_ebkcli_getErpData(p_prog,p_key)
DEFINE p_prog           LIKE type_file.chr1000 #No.FUN-680130 VARCHAR(10)
DEFINE p_key            STRING
DEFINE l_cnt            LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE l_name           STRING
DEFINE l_sql            STRING
DEFINE cnt_record       LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE cnt_field        LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE i                LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE j                LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE g_rvv    DYNAMIC ARRAY OF RECORD
          rvv36   LIKE rvv_file.rvv36       
       END RECORD
 
     CASE p_prog
        WHEN "apmt540"            
            CALL makeTable_EBK040(g_request,p_key,p_prog)
        WHEN "apmt720"
            LET l_sql =  "SELECT rvv36 FROM rvu_file,rvv_file WHERE rvu01=rvv01 and rvu01='" , p_key , "'"
            PREPARE rvv_sql FROM l_sql
            DECLARE rvv_curs CURSOR FOR rvv_sql
            LET l_cnt = 1
            FOREACH rvv_curs INTO g_rvv[l_cnt].*
               LET l_cnt = l_cnt + 1
               CALL makeTable_EBK040(g_request,g_rvv[l_cnt].rvv36,p_prog)
            END FOREACH
            
     END CASE
     
 
END FUNCTION
 
#------------------------------------------------------------------------------
# 處理 request xml string, 讀取內容以為後續解析 xml content
#------------------------------------------------------------------------------
FUNCTION aws_ebkcli_processResult()
    DEFINE l_ch   base.Channel
    DEFINE l_file STRING
    DEFINE l_doc  om.DomDocument
 
    #--------------------------------------------------------------------------
    # 產生一 temp xml file
    #--------------------------------------------------------------------------
    LET l_file = fgl_getenv("TEMPDIR"), "/", fgl_getpid() USING '<<<<<<<<<<', ".xml"
    LET l_ch = base.Channel.create()
    CALL l_ch.openFile(l_file, "w")
    CALL l_ch.setDelimiter(NULL)
    CALL l_ch.write(g_result)
    CALL l_ch.close()
 
    LET l_doc = om.DomDocument.createFromXmlFile(l_file)
    RUN "rm -f " || l_file
    IF l_doc IS NULL THEN
        CALL cl_err(l_doc, 'IS NULL', 1)   #開單成功
    END IF
    LET g_result_xml = l_doc.getDocumentElement()
 
END FUNCTION
 
FUNCTION chk_ebklog(p_key)
DEFINE p_key   STRING    
DEFINE l_key1  LIKE type_file.chr20 
DEFINE l_sql   STRING   
       
       LET l_sql =  "select ebklog01 from ebklog_file where ebklog01='" ,p_key , "'"
       PREPARE ebk_sql FROM l_sql
       DECLARE ebk_curs CURSOR FOR ebk_sql
       
       OPEN ebk_curs 
       FETCH ebk_curs INTO l_key1
       IF l_key1 is null THEN
          RETURN TRUE
       ELSE
          RETURN FALSE
       END IF  
       CLOSE ebk_curs
END FUNCTION
 
FUNCTION aws_ebkcli_check(p_key,p_spc,p_confirm,p_valid)
DEFINE p_key            STRING   
DEFINE p_spc            LIKE type_file.chr1    #No.FUN-680130 VARCHAR(1)
DEFINE p_confirm        LIKE type_file.chr1    #No.FUN-680130 VARCHAR(1)
DEFINE p_valid          LIKE type_file.chr1    #No.FUN-680130 VARCHAR(1)
 
   IF p_key IS NULL OR p_key = ' '              ##尚未查詢資料
   THEN
      LET g_success='N'
      RETURN
   END IF
 
   IF g_aza.aza65 matches '[ Nn]' OR g_aza.aza65 IS NULL THEN #未設定與 SPC 整合
      CALL cl_err('aza65','mfg3559',0)
      LET g_success='N'
      RETURN
   END IF
 
   IF p_confirm matches '[Nn]'                  #判斷是否確認
     THEN
     CALL cl_err('','mfg3550',0)
     LET g_success='N'
     RETURN
   END IF
 
   IF p_confirm matches '[X]'               #判斷是否作廢  
     THEN
     CALL cl_err('','9024',0)
     LET g_success='N'
     RETURN
   END IF
  
   IF p_spc matches '[1]'                #判斷是否已拋轉
     THEN
     CALL cl_err('','aqc-116',0)
     LET g_success='N'
     RETURN
   END IF
END FUNCTION
 
 
FUNCTION aws_ebkcli_qc(p_qc_prog,p_cmd)
DEFINE p_cmd           STRING
DEFINE p_qc_prog       STRING
DEFINE ls_context_file STRING
DEFINE ls_temp_path    STRING
DEFINE l_channel       base.Channel
DEFINE l_status        LIKE type_file.chr1    #No.FUN-680130 VARCHAR(1)
DEFINE l_str           STRING
DEFINE l_ze03          LIKE ze_file.ze03
DEFINE ls_server       STRING
 
   LET ls_temp_path = FGL_GETENV("TEMPDIR")
   LET ls_server = fgl_getenv("FGLAPPSERVER")
   IF cl_null(ls_server) THEN
      LET ls_server = fgl_getenv("FGLSERVER")
   END IF
 
   LET ls_context_file = ls_temp_path,"/aws_ebkcli_" || ls_server CLIPPED || "_" || g_user CLIPPED || "_" || g_qc_prog CLIPPED || ".txt"
   RUN "rm -f " || ls_context_file ||" 2>/dev/null"
 
   LET mi_spc_trigger = TRUE
 
   CALL cl_cmdrun_wait(p_cmd)
 
   LET mi_spc_trigger = FALSE
   IF mi_spc_status > 0 THEN
      LET l_status = '-'
      CALL cl_err(p_qc_prog,'aws-091',1)      
   ELSE
      LET l_channel = base.Channel.create()
      CALL l_channel.openFile(ls_context_file, "r")
      WHILE l_channel.read(l_str)
      END WHILE
      CALL l_channel.close()
      RUN "rm -f " || ls_context_file ||" 2>/dev/null"
      IF NOT cl_null(l_str) THEN
         CALL cl_err(l_str,'!',1)      
      END IF
   END IF
         
 
END FUNCTION 
