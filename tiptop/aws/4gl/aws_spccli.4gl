# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Library name...: aws_spccli
# Descriptions...: 透過 Web Services 將 TIPTOP 表單與 SPC 整合
# Return code....: '0' 表單開立不成功
#                  '1' 表單開立成功
# Date & Author..: 06/08/02 By Echo
# Modify.........: No.FUN-680130 06/09/15 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No.FUN-720042 07/02/27 By Brendan Genero 2.0 整合
# Modify.........: No.TQC-720066 07/02/28 By Echo 抓取 UI 畫面欄位值時，欄位名稱應為 colName 屬性，無 colName 屬性時才以抓取 name 屬性
#
 
IMPORT com
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
#No.FUN-720042
 
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
DEFINE g_qc_prog          LIKE zz_file.zz01         #No.FUN-680130 VARCHAR(10)
DEFINE g_result_value     STRING
DEFINE g_spc_key1         LIKE wcb_file.wcb03
DEFINE g_spc_key2         LIKE wcb_file.wcb04
DEFINE g_spc_key3         LIKE wcb_file.wcb05
DEFINE g_spc_key4         LIKE wcb_file.wcb06
DEFINE g_spc_key5         LIKE wcb_file.wcb07
 
FUNCTION aws_spccli(p_prog,p_head,p_action)
DEFINE p_prog             LIKE zz_file.zz01         #No.FUN-680130 VARCHAR(10)
DEFINE p_head             om.DomNode
DEFINE p_action           STRING
DEFINE buf                base.StringBuffer
DEFINE l_str              STRING
DEFINE l_status           LIKE type_file.num10      #No.FUN-680130 INTEGER
DEFINE l_cnt              LIKE type_file.num10      #No.FUN-680130 INTEGER
 
    LET g_strXMLInput = NULL
    LET g_status = 1
 
   IF g_aza.aza64 matches '[ Nn]' OR g_aza.aza64 IS NULL THEN #未設定與 SPC 整合
       CALL cl_err('aza64','mfg3559',1)      
       LET g_status = 0
       RETURN g_status
   END IF
 
    CALL aws_spccli_prepareRequest('CreateQC',p_action,p_prog)
    IF g_status = 0 THEN
          RETURN g_status
    END IF
 
    CALL aws_spccli_qcInfoSet(p_prog,p_head)
    IF g_status = 0 THEN
         RETURN g_status 
    END IF
 
    CALL aws_spccli_processRequest()
 
    #轉換 & 為 &amp; 
    LET buf = base.StringBuffer.create()
    CALL buf.append(g_strXMLInput)
    CALL buf.replace( "&","&amp;", 0)
    LET g_strXMLInput = buf.toString()
 
    LET SPCService_soapServerLocation = g_spcsoap  #指定 Soap server location
    CALL fgl_ws_setOption("http_invoketimeout", 60)                   #若 60 秒內無回應則放棄
    CALL SPCService_TipTopToSPCData(g_strXMLInput)
          RETURNING l_status, g_result
 
    CALL aws_spccli_file()                       #記錄傳遞的XML字串 
 
    IF l_status = 0 THEN
 
         CALL aws_spccli_processResult()
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
 
    IF p_action = "insert" THEN
       SELECT COUNT(*) INTO l_cnt FROM wca_file where wca01=g_prog
       IF l_cnt > 0 THEN 
             CALL aws_spccli_update()
       END IF                  
    END IF
    RETURN g_status
 
END FUNCTION 
FUNCTION aws_spccli_base(p_tabname,p_record,p_action)
DEFINE p_tabname     STRING
DEFINE p_record      om.DomNode
DEFINE p_action      STRING
DEFINE buf           base.StringBuffer
DEFINE l_str         STRING
DEFINE l_status      LIKE type_file.num10   #No.FUN-680130 INTEGER
 
    LET g_strXMLInput = NULL
    LET g_status = 1
    IF g_aza.aza64 matches '[ Nn]' OR g_aza.aza64 IS NULL THEN  #未設定與 SPC 整合
       LET g_status = 0
       IF g_prog = 'aws_spccfg' THEN
          CALL cl_err('aza64','mfg3559',1)      
          RETURN
       ELSE
          RETURN g_status
       END IF 
    END IF
 
    CALL aws_spccli_prepareRequest('BaseInfoSet',p_action,'')
    IF g_status = 0 THEN
       IF g_prog = 'aws_spccfg' THEN
          RETURN
       ELSE
          RETURN g_status
       END IF 
    END IF
 
    IF g_prog != 'aws_spccfg' THEN
       CALL aws_spccli_BaseInfoSet(p_tabname,p_record)
       IF g_status = 0 THEN
            RETURN g_status 
       END IF
    ELSE
       CALL aws_spccli_BaseInfoSet_all(p_tabname)
       IF g_status = 0 THEN
            RETURN  
       END IF
    END IF
   
    CALL aws_spccli_processRequest()
 
    #轉換 & 為 &amp; 
    LET buf = base.StringBuffer.create()
    CALL buf.append(g_strXMLInput)
    CALL buf.replace( "&","&amp;", 0)
    LET g_strXMLInput = buf.toString()
 
    LET SPCService_soapServerLocation = g_spcsoap  #指定 Soap server location
    CALL fgl_ws_setOption("http_invoketimeout", 60)                   #若 60 秒內無回應則放棄
    CALL SPCService_TipTopToSPCData(g_strXMLInput)
          RETURNING l_status, g_result
 
    CALL aws_spccli_file()                       #記錄傳遞的XML字串 
 
    IF l_status = 0 THEN
 
       CALL aws_spccli_processResult()
       LET g_result_value = aws_xml_getTagAttribute(g_result_xml,"Status", "result")
       
       IF g_result_value != '1' OR g_result_value IS NULL
       THEN
          IF fgl_getenv('FGLGUI') = '1' THEN
             LET l_str = "XML parser error:\n\n",
                         aws_xml_getTagAttribute(g_result_xml,"Status","desc")
          ELSE
             LET l_str = "XML parser error: ",
                         aws_xml_getTagAttribute(g_result_xml,"Status","desc")
          END IF
          CALL cl_err(l_str, '!', 1)   #XML 字串有問題
          IF g_prog = 'aws_spccfg' THEN
             RETURN
          ELSE
             RETURN 2 
          END IF 
       ELSE
          IF g_prog = 'aws_spccfg' THEN
             CALL cl_err('', 'aws-088', 1)   #顯示執行訊息
             RETURN
          ELSE
             RETURN 1
          END IF
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
       IF g_prog = 'aws_spccfg' THEN
          RETURN
       ELSE
          RETURN 2 
       END IF 
    END IF
 
END FUNCTION 
 
FUNCTION aws_spccli_file()
    DEFINE l_str        STRING,
           l_file       STRING,
           l_cmd        STRING
    DEFINE l_ch         base.Channel
 
    #-----------------------------------------------------------------------
    # 記錄此次傳遞的 xml
    #-----------------------------------------------------------------------
    LET l_file = fgl_getenv("TEMPDIR"), "/aws_spccli-", TODAY USING 'YYYYMMDD', ".log"
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
 
FUNCTION aws_spccli_prepareRequest(p_method,p_action,p_prog)
DEFINE p_method      STRING
DEFINE p_action      STRING
DEFINE p_prog        LIKE zz_file.zz01     #No.FUN-680130 VARCHAR(10)
DEFINE l_client      STRING,
       l_spcsiteip   STRING
DEFINE l_wce02       LIKE wce_file.wce02
DEFINE l_wce03       LIKE wce_file.wce03
DEFINE l_wce04       LIKE wce_file.wce04
 
    SELECT wce02,wce03,wce04 INTO l_wce02,l_wce03,l_wce04
      FROM wce_file where wce01 = 'E' AND wce06 = g_plant
        AND wce05 = '*' AND wce07 = '*'
    IF l_wce02 IS NULL THEN
       CALL cl_err3('sel','wce_file',g_plant,'',100,'','',1)
       LET g_status = 0
       RETURN
    END IF
 
    LET l_client = cl_getClientIP()       #Client IP
    LET g_spcsoap = l_wce03 CLIPPED       #EasyFlow SOAP
    LET l_spcsiteip = l_wce02 CLIPPED     #EasyFlow server IP
   #LET l_spcsitename = l_wce04 CLIPPED   #EasyFlow server name
 
 
    LET g_req_doc = om.DomDocument.create("Request")
    LET g_request = g_req_doc.getDocumentElement()
    CALL g_request.setAttribute("name", p_method CLIPPED)
    CALL g_request.setAttribute("action", p_action CLIPPED)
    CALL g_request.setAttribute("version", "1.0")
    LET g_snode = g_request.createChild("Info")
    CALL g_snode.setAttribute("senderIp", l_client)
    CALL g_snode.setAttribute("receiverIp", l_spcsiteip )
    CALL g_snode.setAttribute("userId", g_user )
    IF p_method CLIPPED = "CreateQC" THEN
        LET g_snode = g_request.createChild("ProgramID")
        CALL g_snode.setAttribute("name", p_prog)
    END IF
    LET g_dnode = g_request.createChild("Database")
    CALL g_dnode.setAttribute("name", g_dbs CLIPPED)
    LET g_rnode = g_dnode.createChild("Record")
 
END FUNCTION
 
#------------------------------------------------------------------------------
# 處理 Request xml string, 傳送至 SPC server
#------------------------------------------------------------------------------
FUNCTION aws_spccli_processRequest()
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
 
FUNCTION aws_spccli_qcInfoSet(p_prog,p_head)
DEFINE p_prog           LIKE wcc_file.wcc01    #No.FUN-680130 VARCHAR(10)
DEFINE p_head           om.DomNode
DEFINE n_field          om.DomNode
DEFINE n_record         om.DomNode
DEFINE lnode_item       om.DomNode
DEFINE nl_record        om.NodeList 
DEFINE nl_field         om.NodeList 
DEFINE l_cnt            LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE l_wcb02          LIKE wcb_file.wcb02
DEFINE l_wcc02          LIKE wcc_file.wcc02
DEFINE l_value          STRING
DEFINE l_name           STRING
DEFINE l_sql            STRING
DEFINE cnt_record       LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE cnt_field        LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE i                LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE j                LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE l_window         ui.Window
#TQC-720066
DEFINE ln_w             om.DomNode
DEFINE nl_node          om.NodeList
DEFINE l_i              LIKE type_file.num10   
#END TQC-720066
 
 
     SELECT count(*) INTO l_cnt FROM wcc_file
      WHERE wcc01 = p_prog
 
     IF l_cnt = 0 THEN
       CALL cl_err('','aws-090',1)      
       LET g_status = 0
       RETURN
     END IF
 
     SELECT wcb02 INTO l_wcb02 FROM wcb_file where wcb01 = p_prog
 
     CALL aws_spccli_key(p_prog,p_head)
 
     LET g_tnode = g_rnode.createChild("Table")
     CALL g_tnode.setAttribute("name", l_wcb02 CLIPPED)
 
     LET l_sql = "SELECT wcc02 FROM wcc_file WHERE wcc01 = ? ",
                 " ORDER BY wcc02"
     DECLARE wcc_cs CURSOR FROM l_sql
 
     LET nl_record = p_head.selectByTagName("Record")
     LET cnt_record = nl_record.getLength()
     FOR i=1 to cnt_record
        LET g_rownode = g_tnode.createChild("Row")
        #TQC-720066
        #OPEN wcc_cs USING p_prog
        #FOREACH wcc_cs INTO l_wcc02
        FOREACH wcc_cs USING p_prog INTO l_wcc02
        #TQC-720066
          LET l_value = ""
          LET n_record = nl_record.item(i)
          LET nl_field = n_record.selectByTagName("Field")
          LET cnt_field = nl_field.getLength()
          FOR j =1 to cnt_field
            LET n_field  = nl_field.item(j)
            LET l_name = n_field.getAttribute("name")
            
            IF l_name CLIPPED = l_wcc02 CLIPPED THEN
               LET l_value = n_field.getAttribute("value")
               CALL g_rownode.setAttribute(l_wcc02, l_value)
            END IF
          END FOR
          IF l_value = "" OR l_value IS NULL THEN
             IF p_prog = g_prog THEN
                LET l_window = ui.Window.getCurrent()
                #TQC-720066
                LET ln_w = l_window.getNode()
                LET nl_node = ln_w.selectByTagName("FormField")
                LET l_cnt = nl_node.getLength()
                #LET lnode_item = l_window.findNode("FormField",l_wcc02 CLIPPED)
                #IF lnode_item IS NULL THEN
                #    LET lnode_item = l_window.findNode("FormField","formonly." || l_wcc02  CLIPPED)
                #END IF
                #IF lnode_item IS NULL THEN
                #   LET l_value = aws_spccli_cf(l_wcc02,g_spc_key1,g_spc_key2,g_spc_key3,g_spc_key4,g_spc_key5)
                #ELSE
                #   LET l_value = lnode_item.getAttribute("value")
                #END IF
                FOR l_i = 1 TO l_cnt
                     LET lnode_item = nl_node.item(l_i)
                     LET l_name = lnode_item.getAttribute("colName")
                     IF cl_null(l_name) THEN
                        LET l_name = lnode_item.getAttribute("name")
                     END IF
                     IF l_name = l_wcc02 CLIPPED THEN
                        LET l_value = lnode_item.getAttribute("value")
                        EXIT FOR
                     END IF
                END FOR
             
                IF l_value IS NOT NULL THEN
                   LET l_value = aws_spccli_cf(l_wcc02,g_spc_key1,g_spc_key2,g_spc_key3,g_spc_key4,g_spc_key5)
                END IF
                #END TQC-720066
             ELSE
                LET l_value = aws_spccli_cf(l_wcc02,g_spc_key1,g_spc_key2,g_spc_key3,g_spc_key4,g_spc_key5)
             END IF
             CALL g_rownode.setAttribute(l_wcc02, l_value) 
          END IF
        END FOREACH
        CLOSE wcc_cs
     END FOR
END FUNCTION
 
FUNCTION aws_spccli_BaseInfoSet(p_tabname,p_record)
DEFINE p_tabname        LIKE wcd_file.wcd01    #No.FUN-680130 VARCHAR(15)
DEFINE p_record         om.DomNode
DEFINE n_field          om.DomNode
DEFINE n_combo_child    om.DomNode
DEFINE n_combo          om.DomNode
DEFINE lnode_item       om.DomNode
DEFINE nl_combo         om.NodeList 
DEFINE nl_field         om.NodeList 
DEFINE l_window         ui.Window
DEFINE l_cnt            LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE l_wcd02          LIKE wcd_file.wcd02
DEFINE l_value          STRING
DEFINE l_name           STRING
DEFINE l_combo_value    STRING
DEFINE l_sql            STRING
DEFINE cnt_combo        LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE cnt_field        LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE i                LIKE type_file.num10   #No.FUN-680130 INTEGER
 
#    LET l_window = ui.Window.getCurrent()
 
     SELECT count(*) INTO l_cnt FROM wcd_file
      WHERE wcd01 = p_tabname
 
     IF l_cnt = 0 THEN
       IF g_prog = 'aws_spccfg' THEN
               CALL cl_err('','aws-087',1)      
       END IF 
       LET g_status = 0
       RETURN
     END IF
 
     LET g_tnode = g_rnode.createChild("Table")
     CALL g_tnode.setAttribute("name", p_tabname CLIPPED)
     LET g_rownode = g_tnode.createChild("Row")
 
     LET l_sql = "SELECT wcd02 FROM wcd_file WHERE wcd01 ='",p_tabname,
                 "' ORDER BY wcd02"
     DECLARE wcd_cs CURSOR FROM l_sql
     FOREACH wcd_cs INTO l_wcd02
 
       LET nl_field = p_record.selectByTagName("Field")
       LET cnt_field = nl_field.getLength()
       FOR i =1 to cnt_field
         LET n_field  = nl_field.item(i)
         LET l_name = n_field.getAttribute("name")
         
         IF l_name CLIPPED = l_wcd02 CLIPPED THEN
            LET l_value = n_field.getAttribute("value")
            
           #LET lnode_item = l_window.findNode("TableColumn",l_wcd02 CLIPPED)
           #IF lnode_item IS NULL THEN
           #   LET lnode_item = l_window.findNode("TableColumn","formonly." || l_wcd02 CLIPPED)
           #END IF
           #IF lnode_item IS NOT NULL THEN
           #   LET cnt_combo = 0 
           #   LET nl_combo = lnode_item.selectByTagName("ComboBox")
           #   LET cnt_combo = nl_combo.getLength()
           #   
           #   IF cnt_combo > 0 THEN
           #      LET n_combo = nl_combo.item(1)
           #      LET n_combo_child = n_combo.getFirstChild()
           #      WHILE n_combo_child IS NOT NULL
           #         LET l_combo_value = n_combo_child.getAttribute("name")
           #         IF l_value.equals(l_combo_value) THEN
           #             LET l_value = n_combo_child.getAttribute("text")
           #             EXIT WHILE
           #         END IF
           #         LET n_combo_child = n_combo_child.getNext()
           #      END WHILE   
           #   END IF
           #END IF
            CALL g_rownode.setAttribute(l_wcd02, l_value)
         END IF
       END FOR
     END FOREACH
END FUNCTION
 
FUNCTION aws_spccli_BaseInfoSet_all(p_tabname)
DEFINE p_tabname        STRING
DEFINE l_cnt            LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE l_i              LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE l_wcd01          LIKE wcd_file.wcd01
DEFINE l_wcd02          LIKE wcd_file.wcd02
DEFINE l_sql            STRING
DEFINE l_str            STRING
DEFINE l_wcd02_dyn      DYNAMIC ARRAY OF STRING
DEFINE l_table_data RECORD
                       field01 LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(255) 
                       field02 LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(255) 
                       field03 LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(255) 
                       field04 LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(255) 
                       field05 LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(255) 
                       field06 LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(255) 
                       field07 LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(255) 
                       field08 LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(255) 
                       field09 LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(255) 
                       field10 LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(255) 
                       field11 LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(255) 
                       field12 LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(255) 
                       field13 LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(255) 
                       field14 LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(255) 
                       field15 LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(255) 
                       field16 LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(255) 
                       field17 LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(255) 
                       field18 LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(255) 
                       field19 LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(255) 
                       field20 LIKE type_file.chr1000 #No.FUN-680130 VARCHAR(255)
                  END RECORD
 
  SELECT count(*) INTO l_cnt FROM wcd_file
  IF l_cnt = 0 THEN
    IF g_prog = 'aws_spccfg' THEN
            CALL cl_err('','aws-087',1)      
    END IF 
    LET g_status = 0
    RETURN
  END IF
 
  LET l_sql = "SELECT wcd02 FROM wcd_file WHERE wcd01 = ? ",
              " ORDER BY wcd02"
  DECLARE wcd_all2_cs CURSOR FROM l_sql
 
  LET l_sql = "SELECT unique wcd01 FROM wcd_file ORDER BY wcd01"
  DECLARE wcd_all_cs CURSOR FROM l_sql
  FOREACH wcd_all_cs INTO l_wcd01
    LET l_str = ""
    IF p_tabname.getIndexOf(l_wcd01 CLIPPED,1) > 0 THEN
       LET g_tnode = g_rnode.createChild("Table")
       CALL g_tnode.setAttribute("name", l_wcd01 CLIPPED)
       
       SELECT COUNT(*) INTO l_cnt FROM wcd_file WHERE wcd01 = l_wcd01
       LET l_i = 0
       INITIALIZE l_table_data.* TO NULL
       CALL l_wcd02_dyn.clear()
       #TQC-720066
       #OPEN wcd_all2_cs USING l_wcd01
       #FOREACH wcd_all2_cs INTO l_wcd02
       FOREACH wcd_all2_cs USING l_wcd01 INTO l_wcd02
       #END TQC-720066
            LET l_i = l_i + 1
            LET l_wcd02_dyn[l_i] = l_wcd02
            IF l_i = 1 THEN
                 LET l_str = l_wcd02
            ELSE
                 LET l_str = l_str,",",l_wcd02
            END IF 
       END FOREACH
       CLOSE wcd_all2_cs 
       
       LET l_sql = "SELECT ",l_str," FROM ",l_wcd01
       PREPARE wcd_all3_pre FROM l_sql
       DECLARE wcd_all3_cs CURSOR FOR wcd_all3_pre
       FOREACH wcd_all3_cs INTO l_table_data.*
         LET g_rownode = g_tnode.createChild("Row")
         FOR l_i = 1 TO l_cnt
           CASE l_i 
             WHEN 1
               CALL g_rownode.setAttribute(l_wcd02_dyn[l_i], l_table_data.field01)
             WHEN 2
               CALL g_rownode.setAttribute(l_wcd02_dyn[l_i], l_table_data.field02)
             WHEN 3
               CALL g_rownode.setAttribute(l_wcd02_dyn[l_i], l_table_data.field03)
             WHEN 4
               CALL g_rownode.setAttribute(l_wcd02_dyn[l_i], l_table_data.field04)
             WHEN 5
               CALL g_rownode.setAttribute(l_wcd02_dyn[l_i], l_table_data.field05)
             WHEN 6
               CALL g_rownode.setAttribute(l_wcd02_dyn[l_i], l_table_data.field06)
             WHEN 7
               CALL g_rownode.setAttribute(l_wcd02_dyn[l_i], l_table_data.field07)
             WHEN 8
               CALL g_rownode.setAttribute(l_wcd02_dyn[l_i], l_table_data.field08)
             WHEN 9
               CALL g_rownode.setAttribute(l_wcd02_dyn[l_i], l_table_data.field09)
             WHEN 10
               CALL g_rownode.setAttribute(l_wcd02_dyn[l_i], l_table_data.field10)
             WHEN 11
               CALL g_rownode.setAttribute(l_wcd02_dyn[l_i], l_table_data.field11)
             WHEN 12
               CALL g_rownode.setAttribute(l_wcd02_dyn[l_i], l_table_data.field12)
             WHEN 13
               CALL g_rownode.setAttribute(l_wcd02_dyn[l_i], l_table_data.field13)
             WHEN 14
               CALL g_rownode.setAttribute(l_wcd02_dyn[l_i], l_table_data.field14)
             WHEN 15
               CALL g_rownode.setAttribute(l_wcd02_dyn[l_i], l_table_data.field15)
             WHEN 16
               CALL g_rownode.setAttribute(l_wcd02_dyn[l_i], l_table_data.field16)
             WHEN 17
               CALL g_rownode.setAttribute(l_wcd02_dyn[l_i], l_table_data.field17)
             WHEN 18
               CALL g_rownode.setAttribute(l_wcd02_dyn[l_i], l_table_data.field18)
             WHEN 19
               CALL g_rownode.setAttribute(l_wcd02_dyn[l_i], l_table_data.field19)
             WHEN 20
               CALL g_rownode.setAttribute(l_wcd02_dyn[l_i], l_table_data.field20)
           END CASE
         END FOR 
       END FOREACH
       CLOSE wcd_all3_cs
    END IF
  END FOREACH
  CLOSE wcd_all_cs
END FUNCTION
 
#------------------------------------------------------------------------------
# 處理 request xml string, 讀取內容以為後續解析 xml content
#------------------------------------------------------------------------------
FUNCTION aws_spccli_processResult()
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
 
#更改SPC拋轉碼
FUNCTION aws_spccli_update()
DEFINE l_wcb              RECORD LIKE wcb_file.*         #單頭檔設定
DEFINE l_sql              STRING
DEFINE l_status           LIKE type_file.chr1    #No.FUN-680130 VARCHAR(1)
DEFINE l_value            STRING
DEFINE l_err              STRING
DEFINE l_window           ui.Window
DEFINE lnode_item         om.DomNode
DEFINE l_key              STRING
#TQC-720066
DEFINE ln_w             om.DomNode
DEFINE nl_node          om.NodeList
DEFINE l_name           STRING
DEFINE l_i              LIKE type_file.num10
DEFINE l_cnt            LIKE type_file.num10
#END TQC-720066
 
    IF g_status = 1 THEN
          LET l_status = '1'    #拋轉成功
    ELSE 
          LET l_status = '2'    #拋轉失敗
    END IF
    
    SELECT * INTO l_wcb.* FROM wcb_file where wcb01 = g_prog
 
    LET l_sql = "UPDATE ",l_wcb.wcb02 CLIPPED ," set ",l_wcb.wcb09 CLIPPED,
                "= '",l_status ,"' WHERE "
 
    LET l_window = ui.Window.getCurrent()
    #TQC-720066
    LET ln_w = l_window.getNode()
    LET nl_node = ln_w.selectByTagName("FormField")
    LET l_cnt = nl_node.getLength()
    #LET lnode_item = l_window.findNode("FormField",l_wcb.wcb03 CLIPPED)
    #IF lnode_item IS NULL THEN
    #    LET lnode_item = l_window.findNode("FormField","formonly." || l_wcb.wcb03  CLIPPED)
    #END IF
    #LET l_value = lnode_item.getAttribute("value")
    FOR l_i = 1 TO l_cnt
         LET lnode_item = nl_node.item(l_i)
         LET l_name = lnode_item.getAttribute("colName")
         IF cl_null(l_name) THEN
            LET l_name = lnode_item.getAttribute("name")
         END IF
         IF l_name = l_wcb.wcb03 CLIPPED THEN
            LET l_value = lnode_item.getAttribute("value")
            EXIT FOR
         END IF
    END FOR
 
    LET l_key = l_value
    LET l_sql = l_sql,l_wcb.wcb03 CLIPPED ," = '",l_value ,"'"
    
    #IF l_wcb.wcb04 IS NOT NULL THEN
    #    LET lnode_item = l_window.findNode("FormField",l_wcb.wcb04 CLIPPED)
    #    IF lnode_item IS NULL THEN
    #        LET lnode_item = l_window.findNode("FormField","formonly." || l_wcb.wcb04  CLIPPED)
    #    END IF
    #    LET l_value = lnode_item.getAttribute("value")
    #    LET l_sql = l_sql," AND ",l_wcb.wcb04 CLIPPED ," = '",l_value,"'"
 
    #    IF l_wcb.wcb05 IS NOT NULL THEN
    #       LET lnode_item = l_window.findNode("FormField",l_wcb.wcb05 CLIPPED)
    #       IF lnode_item IS NULL THEN
    #           LET lnode_item = l_window.findNode("FormField","formonly." || l_wcb.wcb05  CLIPPED)
    #       END IF
    #       LET l_value = lnode_item.getAttribute("value")
    #       LET l_sql = l_sql," AND ",l_wcb.wcb05 CLIPPED ," = '",l_value,"'"
 
    #       IF l_wcb.wcb06 IS NOT NULL THEN
    #           LET lnode_item = l_window.findNode("FormField",l_wcb.wcb06 CLIPPED)
    #           IF lnode_item IS NULL THEN
    #               LET lnode_item = l_window.findNode("FormField","formonly." || l_wcb.wcb06  CLIPPED)
    #           END IF
    #           LET l_value = lnode_item.getAttribute("value")
    #           LET l_sql = l_sql," AND ",l_wcb.wcb06 CLIPPED ," = '",l_value,"'"
    #           IF l_wcb.wcb07 IS NOT NULL THEN
    #               LET lnode_item = l_window.findNode("FormField",l_wcb.wcb07 CLIPPED)
    #               IF lnode_item IS NULL THEN
    #                   LET lnode_item = l_window.findNode("FormField","formonly." || l_wcb.wcb07  CLIPPED)
    #               END IF
    #               LET l_value = lnode_item.getAttribute("value")
    #               LET l_sql = l_sql," AND ",l_wcb.wcb07 CLIPPED ," = '",l_value,"'"
    #           END IF
    #       END IF
    #   END IF
    #END IF
    IF l_wcb.wcb04 IS NOT NULL THEN
       FOR l_i = 1 TO l_cnt
            LET lnode_item = nl_node.item(l_i)
            LET l_name = lnode_item.getAttribute("colName")
            IF cl_null(l_name) THEN
               LET l_name = lnode_item.getAttribute("name")
            END IF
            IF l_name = l_wcb.wcb04 CLIPPED THEN
               LET l_value = lnode_item.getAttribute("value")
               LET l_sql = l_sql," AND ",l_wcb.wcb04 CLIPPED ," = '",l_value,"'"
               EXIT FOR
            END IF
       END FOR
    END IF
    
    IF l_wcb.wcb05 IS NOT NULL THEN
       FOR l_i = 1 TO l_cnt
            LET lnode_item = nl_node.item(l_i)
            LET l_name = lnode_item.getAttribute("colName")
            IF cl_null(l_name) THEN
               LET l_name = lnode_item.getAttribute("name")
            END IF
            IF l_name = l_wcb.wcb05 CLIPPED THEN
               LET l_value = lnode_item.getAttribute("value")
               LET l_sql = l_sql," AND ",l_wcb.wcb05 CLIPPED ," = '",l_value,"'"
               EXIT FOR
            END IF
       END FOR
    END IF
    IF l_wcb.wcb06 IS NOT NULL THEN
       FOR l_i = 1 TO l_cnt
            LET lnode_item = nl_node.item(l_i)
            LET l_name = lnode_item.getAttribute("colName")
            IF cl_null(l_name) THEN
               LET l_name = lnode_item.getAttribute("name")
            END IF
            IF l_name = l_wcb.wcb06 CLIPPED THEN
               LET l_value = lnode_item.getAttribute("value")
               LET l_sql = l_sql," AND ",l_wcb.wcb06 CLIPPED ," = '",l_value,"'"
               EXIT FOR
            END IF
       END FOR
    END IF
    
    IF l_wcb.wcb07 IS NOT NULL THEN
       FOR l_i = 1 TO l_cnt
            LET lnode_item = nl_node.item(l_i)
            LET l_name = lnode_item.getAttribute("colName")
            IF cl_null(l_name) THEN
               LET l_name = lnode_item.getAttribute("name")
            END IF
            IF l_name = l_wcb.wcb07 CLIPPED THEN
               LET l_value = lnode_item.getAttribute("value")
               LET l_sql = l_sql," AND ",l_wcb.wcb07 CLIPPED ," = '",l_value,"'"
               EXIT FOR
            END IF
       END FOR
    END IF
    #END TQC-720066
    EXECUTE IMMEDIATE l_sql
    IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
       LET l_err = "upd ",l_wcb.wcb09 CLIPPED
       CALL cl_err3("upd",l_wcb.wcb02,l_key,"",STATUS,"",l_err,1)
       LET g_success = 'N'
    END IF
END FUNCTION
 
FUNCTION aws_spccli_check(p_key,p_spc,p_confirm,p_valid)
DEFINE p_key            STRING   
DEFINE p_spc            LIKE type_file.chr1    #No.FUN-680130 VARCHAR(1)
DEFINE p_confirm        LIKE type_file.chr1    #No.FUN-680130 VARCHAR(1)
DEFINE p_valid          LIKE type_file.chr1    #No.FUN-680130 VARCHAR(1)
 
   IF p_key IS NULL OR p_key = ' '              ##尚未查詢資料
   THEN
      LET g_success='N'
      RETURN
   END IF
 
   IF g_aza.aza64 matches '[ Nn]' OR g_aza.aza64 IS NULL THEN #未設定與 SPC 整合
      CALL cl_err('aza64','mfg3559',0)
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
 
FUNCTION aws_spccli_qc_chk(p_key,p_spc,p_confirm,p_valid)
DEFINE p_key            STRING   
DEFINE p_spc            LIKE type_file.chr1    #No.FUN-680130 VARCHAR(1)
DEFINE p_confirm        LIKE type_file.chr1    #No.FUN-680130 VARCHAR(1)
DEFINE p_valid          LIKE type_file.chr1    #No.FUN-680130 VARCHAR(1)
 
   IF p_key IS NULL OR p_key = ' '
   THEN 
        LET g_success='N'
        RETURN
   END IF
 
   IF g_aza.aza64 matches '[ Nn]' OR g_aza.aza64 IS NULL THEN #未設定與 SPC 整合
      CALL cl_err('aza64','mfg3559',0)
      LET g_success='N'
      RETURN
   END IF
 
   IF p_confirm matches '[Yy]'                  #判斷是否確認
     THEN
     CALL cl_err('','9023',0)
     LET g_success='N'
     RETURN
   END IF
 
   IF p_confirm matches '[X]'                 #判斷是否作廢
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
 
FUNCTION aws_spccli_qc(p_qc_prog,p_cmd)
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
 
   LET ls_context_file = ls_temp_path,"/aws_spccli_" || ls_server CLIPPED || "_" || g_user CLIPPED || "_" || g_qc_prog CLIPPED || ".txt"
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
 
 
FUNCTION aws_spccli_key(p_prog,p_head)
DEFINE l_wcb           RECORD LIKE wcb_file.*
DEFINE p_head          om.DomNode
DEFINE p_prog          LIKE zz_file.zz01         #No.FUN-680130 VARCHAR(10)
DEFINE nl_field        om.NodeList 
DEFINE cnt_field       LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE j               LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE l_name          STRING
DEFINE n_field         om.DomNode
 
    SELECT * INTO l_wcb.* FROM wcb_file WHERE wcb01 = p_prog 
 
    LET nl_field = p_head.selectByTagName("Field")
    LET cnt_field = nl_field.getLength()
    FOR j =1 to cnt_field
      LET n_field  = nl_field.item(j)
      LET l_name = n_field.getAttribute("name")
      CASE l_name 
         WHEN l_wcb.wcb03
             LET g_spc_key1 = n_field.getAttribute("value")
         WHEN l_wcb.wcb04
             LET g_spc_key2 = n_field.getAttribute("value")
         WHEN l_wcb.wcb05
             LET g_spc_key3 = n_field.getAttribute("value")
         WHEN l_wcb.wcb06
             LET g_spc_key4 = n_field.getAttribute("value")
         WHEN l_wcb.wcb07
             LET g_spc_key5 = n_field.getAttribute("value")
      END CASE
    END FOR
END FUNCTION
