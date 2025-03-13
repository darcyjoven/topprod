# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Library name...: aws_efstat2
# Descriptions...: 查詢 EasyFlow 表單 簽核流程及簽核意見
# Input parameter: p_formNum 表單單號
# Return code....: l_url 瀏覽網址
# Usage .........: call aws_efstat2(p_formNum)
# Date & Author..: 92/05/14 By Brendan
# Modify.........: No.MOD-4B0222 04/11/23 By Echo 將 XML 中特殊定義的字元( &) 取代為標準規範中的取代字元(&amp;)
# Modify.........: No.FUN-4C0082 04/10/13 By Echo 提供 library function, 使 ERP 憑證輸出時可列印 EasyFlow 簽核人員姓名, 職稱及簽核時間
# Modify.........: No.MOD-530792 05/03/28 by Echo VARCHAR->CHAR
# Modify.........: No.FUN-550075 05/05/18 By Echo 新增EasyFlow站台設定
# Modify.........: No.MOD-560007 05/06/02 By Echo 重新定義FUN名稱
# Modify.........: No.FUN-570230 05/07/29 By Echo 將簽核狀況傳遞xml的log資料存至aws_efcli2-日期.log
#                                                 將單據簽核流程(GetApproveLog)記錄在 aws_efsrv2-日期.log
# Modify.........: No.FUN-5C0030 05/12/14 By Echo 增加記錄GetApproveLog處理時間
# Modify.........: No.FUN-660155 06/06/22 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680130 06/09/05 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No.FUN-710010 07/01/05 By ching-yuan TIPTOP與EasyFlow GP整合
# Modify.........: No.FUN-720042 07/02/27 By Brendan Genero 2.0 整合
# Modify.........: No.TQC-720066 07/02/28 By Echo 抓取 UI 畫面欄位值時，欄位名稱應為 colName 屬性，無 colName 屬性時才以抓取 name 屬性
# Modify.........: No.TQC-740286 07/04/25 By Echo 查詢簽核狀況異常, 抓取azg_file排序錯誤
# Modify.........: No.FUN-710063 07/05/14 By Echo XML 特殊字元處理功能
# Modify.........: No.TQC-750259 07/06/04 By Echo 增加記錄 SOAP error 錯誤訊息
# Modify.........: No.FUN-780049 07/09/26 By Echo 若回傳不完整的XML格式字串或錯誤訊息時，則直接顯示對方回傳的資料
# Modify.........: No.TQC-7B0061 07/11/13 By Echo 查看「簽核狀況」時，簽核狀態選擇「0:放棄」會有錯誤 
# Modify.........: No.TQC-820022 08/02/25 By Smapmin 組出送簽單號時,複合Key的尾端要加上CLIPPED
# Modify.........: No.TQC-860022 08/06/10 By Echo 調整程式遺漏 ON IDLE 程式段
# Modify.........: No.FUN-880046 08/08/12 by Echo Genero 2.11 調整
# Modify.........: No.FUN-8C0017 08/12/03 By Vicky 簽核流程(GetApproveLog)，增加一 tag 傳遞圖檔名稱<PicName>
# Modify.........: No.FUN-930133 09/03/23 By Vicky 增加取得 EasyFlow GP 簽核結果(GetApproveLog)
# Modify.........: No.FUN-960137 09/06/18 By Vicky Request字串增加TIPTOP主機資訊 (多TP 對 一EF GP)
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:FUN-9C0073 10/01/11 By chenls 程序精簡
# Modify.........: No:MOD-A30158 10/03/22 By sabrina 增加 azg06欄位判斷
# Modify.........: No:FUN-960057 10/09/15 By Jay 增加 azg09 欄位判斷
# Modify.........: No:FUN-B30003 11/04/11 By Jay TIPTOP 與 CROSS 整合功能: 透過 CROSS 平台串接 
# Modify.........: No:FUN-B10067 11/06/17 By jenjwu 增加簽核時間存放至wsc_file之wsc14
# Modify.........: No:FUN-C40005 12/04/03 By Kevin 修改GetApproveLog 使用 retry 的機制
# Modify.........: No:FUN-C40060 12/04/18 By Kevin TIPTOP 固定傳遞 <ApproveType>NORMAL</ApproveType>
# Modify.........: No:CHI-C70021 12/07/25 By Kevin 修改 wsc15 存放程式代號
# Modify.........: No:FUN-C90012 12/09/07 By Kevin 增加 wsc16 存放EF簽核人員工號
# Modify.........: No:FUN-CC0076 12/12/19 By Kevin 在B2B環境開啟 URL  


IMPORT com
IMPORT os   #No.FUN-9C0009 
DATABASE ds
 
GLOBALS "../4gl/aws_efgw.inc"
GLOBALS "../4gl/aws_efgpgw.inc" #No.FUN-710010
GLOBALS "../4gl/awsef.4gl"
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_crossgw.inc"        #No:FUN-B30003
 
DEFINE g_type	LIKE type_file.chr1,    #查詢選擇 #No.FUN-680130 VARCHAR(1)   
       g_str	STRING
DEFINE channel  base.Channel
DEFINE buf      base.StringBuffer
DEFINE l_status	LIKE type_file.num10,        #No.FUN-680130 INTEGER
       l_Result	STRING
DEFINE g_efsoap STRING
DEFINE g_wse    RECORD LIKE wse_file.*
DEFINE g_wap    RECORD LIKE wap_file.*       #No:FUN-B30003

FUNCTION aws_efstat2()
    DEFINE p_formNum    STRING,
           l_file       STRING
    DEFINE l_cmd	STRING,
           l_p1         LIKE type_file.num10   #No.FUN-680130 INTEGER
 
    DEFINE lnode_item   om.DomNode
    DEFINE l_window     ui.Window
    DEFINE l_value      STRING
    DEFINE ln_w         om.DomNode
    DEFINE nl_node      om.NodeList
    DEFINE l_name       STRING
    DEFINE l_i          LIKE type_file.num5
    DEFINE l_cnt        LIKE type_file.num5
    DEFINE l_cross_status   LIKE type_file.num5    #No.FUN-B30003
    DEFINE l_method     LIKE type_file.chr20       #No.FUN-B30003
    DEFINE l_str        STRING                     #No.FUN-B30003
    DEFINE l_url        STRING                     #No.FUN-B30003
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF g_aza.aza72 = 'N' THEN
       CALL aws_efstat2_type()             #詢問查詢何種狀態
       IF INT_FLAG THEN   #離開
          LET INT_FLAG = 0
          RETURN
       END IF
    END IF
    
    SELECT * INTO g_wse.* FROM wse_file where wse01 = g_prog
    LET l_window = ui.Window.getCurrent()
 
   LET ln_w = l_window.getNode()
   LET nl_node = ln_w.selectByTagName("FormField")
   LET l_cnt = nl_node.getLength()
 
   FOR l_i = 1 TO l_cnt
        LET lnode_item = nl_node.item(l_i)
        LET l_name = lnode_item.getAttribute("colName")
        IF cl_null(l_name) THEN
           LET l_name = lnode_item.getAttribute("name")
        END IF
        IF l_name = g_wse.wse03 CLIPPED THEN
           LET g_formNum = lnode_item.getAttribute("value")
           EXIT FOR
        END IF
   END FOR
   IF g_wse.wse04 IS NOT NULL THEN
       FOR l_i = 1 TO l_cnt
            LET lnode_item = nl_node.item(l_i)
            LET l_name = lnode_item.getAttribute("colName")
            IF cl_null(l_name) THEN
               LET l_name = lnode_item.getAttribute("name")
            END IF
            IF l_name = g_wse.wse04 CLIPPED THEN
               LET l_value = lnode_item.getAttribute("value")
               LET g_formNum = g_formNum CLIPPED,"{+}", g_wse.wse04 CLIPPED,"=", l_value   #TQC-820022
               EXIT FOR
            END IF
       END FOR
   END IF
   IF g_wse.wse05 IS NOT NULL THEN
       FOR l_i = 1 TO l_cnt
            LET lnode_item = nl_node.item(l_i)
            LET l_name = lnode_item.getAttribute("colName")
            IF cl_null(l_name) THEN
               LET l_name = lnode_item.getAttribute("name")
            END IF
            IF l_name = g_wse.wse05 CLIPPED THEN
               LET l_value = lnode_item.getAttribute("value")
               LET g_formNum = g_formNum CLIPPED,"{+}", g_wse.wse05 CLIPPED,"=", l_value   #TQC-820022
               EXIT FOR
            END IF
       END FOR
   END IF
   IF g_wse.wse06 IS NOT NULL THEN
       FOR l_i = 1 TO l_cnt
            LET lnode_item = nl_node.item(l_i)
            LET l_name = lnode_item.getAttribute("colName")
            IF cl_null(l_name) THEN
               LET l_name = lnode_item.getAttribute("name")
            END IF
            IF l_name = g_wse.wse06 CLIPPED THEN
               LET l_value = lnode_item.getAttribute("value")
               LET g_formNum = g_formNum CLIPPED ,"{+}", g_wse.wse06 CLIPPED,"=", l_value   #TQC-820022
               EXIT FOR
            END IF
       END FOR
   END IF
   IF g_wse.wse07 IS NOT NULL THEN
       FOR l_i = 1 TO l_cnt
            LET lnode_item = nl_node.item(l_i)
            LET l_name = lnode_item.getAttribute("colName")
            IF cl_null(l_name) THEN
               LET l_name = lnode_item.getAttribute("name")
            END IF
            IF l_name = g_wse.wse07 CLIPPED THEN
               LET l_value = lnode_item.getAttribute("value")
               LET g_formNum = g_formNum CLIPPED,"{+}", g_wse.wse07 CLIPPED,"=", l_value   #TQC-820022
               EXIT FOR
            END IF
       END FOR
   END IF
 
    display "g_formNum:",g_formNum
    CALL aws_efstat2_cf()   #組傳入 EasyFlow 的 XML 資料
    IF g_strXMLInput = '' OR g_strXMLInput IS NULL THEN
       RETURN
    END IF
 
 
   ###轉換 & 為 &amp; ###
    LET g_strXMLInput = aws_xml_replace(g_strXMLInput)
 
 
    #No:FUN-B30003 -- start --
    #-------------------------------------------------------------------------------------#
    # TIPTOP 與 CROSS 整合: 透過 CROSS 平台呼叫 EasyFlow                                  #
    #-------------------------------------------------------------------------------------#
    SELECT wap02 INTO g_wap.wap02 FROM wap_file
    IF g_wap.wap02 = 'Y' THEN  #使用CROSS整合平台
       IF g_aza.aza72 = 'N' THEN
          LET l_str = "EFNET"
          CASE g_type
               WHEN '1' LET l_method = "GetFormFlow"         #查詢簽核流程
               WHEN '2' LET l_method = "GetApproveOpinion"   #查詢簽核意見
          END CASE
       ELSE
          LET l_str = "EFGP"
          LET l_method = "GetFormFlow"                      #查詢簽核流程
       END IF
       #呼叫 CROSS 平台發出整合活動請求
       CALL aws_cross_invokeSrv(l_str,l_method,"sync",g_strXMLInput) 
            RETURNING l_cross_status, l_status, l_Result
       IF NOT l_cross_status  THEN
          RETURN
       END IF
    ELSE
    #No:FUN-B30003 -- end --
       IF g_aza.aza72 = 'N' THEN 
           LET EFGateWay_soapServerLocation = g_efsoap  #指定 Soap server location
       ELSE #指定EasyFlowGP的SOAP網址
           LET EFGPGateWay_soapServerLocation = g_efsoap  #指定 Soap server location
       END IF
    
       CALL fgl_ws_setOption("http_invoketimeout", 60)                   #若 60 秒內無回應則放棄
 
       IF g_aza.aza72 = 'N' THEN
           CALL EFGateWay_TipTopCoordinator(g_strXMLInput)                   #連接 EasyFlow SOAP server
             RETURNING l_status, l_Result
       ELSE
           CALL EFGPGateWay_EasyFlowGPGateWay(g_strXMLInput)    #連接 EasyFlowGP SOAP server
             RETURNING l_status, l_Result
       END IF
    END IF   #No:FUN-B30003
 
    #紀錄傳入 EasyFlow 的字串
    LET channel = base.Channel.create()
 
    LET l_file = "aws_efcli2-", TODAY USING 'YYYYMMDD', ".log"
    CALL channel.openFile(l_file, "a")
 
    IF STATUS = 0 THEN
        CALL channel.setDelimiter("")
        LET g_str = "#--------------------------- (", CURRENT YEAR TO SECOND, ") ----------------------------#"
        CALL channel.write(g_str)
        CALL channel.write("")
        LET g_str = "Program: ", g_prog CLIPPED
        CALL channel.write(g_str)
        LET g_str = "Form Number: ", p_formNum CLIPPED
        CALL channel.write(g_str)
        CALL channel.write("")
        CALL channel.write("Request XML:")
        CALL channel.write(g_strXMLInput)
        CALL channel.write("")
    
        #紀錄 EasyFlow 回傳的資料
        CALL channel.write("Response XML:")
 
        IF l_status = 0 THEN
           CALL channel.write(l_Result)
        ELSE
           CALL channel.write("")
           IF fgl_getenv('FGLGUI') = '1' THEN
              LET g_str = "   Connection failed:\n\n",
                       "     [Code]: ", wserror.code, "\n",
                       "     [Action]: ", wserror.action, "\n",
                       "     [Description]: ", wserror.description
           ELSE
              LET g_str = "   Connection failed: ", wserror.description
           END IF
           CALL channel.write(g_str)
           CALL channel.write("")
        END IF
 
        CALL channel.write("#------------------------------------------------------------------------------#")
        CALL channel.close()
        IF os.Path.chrwx(l_file CLIPPED,438) THEN END IF   #No.FUN-9C0009
 
    ELSE
        DISPLAY "Can't open log file."
    END IF
 
    IF l_status = 0 THEN
       IF (aws_xml_getTag(l_Result, "ReturnStatus") != 'Y') OR
          (aws_xml_getTag(l_Result, "ReturnStatus") IS NULL) THEN
          IF aws_xml_getTag(l_Result, "ReturnStatus") IS NULL THEN
               LET g_str = l_Result
          ELSE
               LET g_str = aws_xml_getTag(l_Result, "ReturnDescribe")
          END IF
          IF fgl_getenv('FGLGUI') = '1' THEN
             LET g_str = "Get status error:\n\n", g_str
          ELSE
             LET g_str = "Get status error: ", g_str
          END IF
          CALL cl_err(g_str, '!', 1)   #XML 字串有問題
          RETURN
       END IF
 
       LET buf = base.StringBuffer.create()
       CALL buf.append(l_Result)
       CALL buf.replace( "&amp;", "&", 0)
       LET l_Result = buf.toString() 
       LET l_p1 = l_Result.getIndexOf("<URL>", 1)

       #FUN-CC0076 start 
       LET l_url = aws_xml_getTag(l_Result, "URL")
       IF NOT cl_null(FGL_GETENV("WEBAREA")) THEN
          DISPLAY l_url
          CALL ui.Interface.frontCall( "standard", "launchurl", [l_url], [] )
       ELSE
          IF cl_open_url(aws_xml_getTag(l_Result, "URL")) THEN
          END IF
       END IF
       #FUN-CC0076 end 
    ELSE
       IF fgl_getenv('FGLGUI') = '1' THEN
          LET g_str = "Connection failed:\n\n",
                      "  [Code]: ", wserror.code, "\n",
                      "  [Action]: ", wserror.action, "\n",
                      "  [Description]: ", wserror.description
       ELSE
          LET g_str = "Connection failed: ", wserror.description
       END IF
       CALL cl_err(g_str, '!', 1)   #連接失敗
    END IF
END FUNCTION
 
 
FUNCTION aws_efstat2_type()
 
    CASE
       WHEN g_lang = '0'
          LET g_str = "請選擇 1.查看簽核流程 2.查看簽核意見 0.離開: "
       WHEN g_lang = '2'
          LET g_str = "請選擇 1.查看簽核流程 2.查看簽核意見 0.離開: "
       OTHERWISE
          LET g_str = "Select 1.View Form Flow 2.View Approve Opinion 0.Exit:"
    END CASE
 
    WHILE TRUE
        #提示輸入查詢選項
        LET g_type = NULL
        PROMPT g_str CLIPPED FOR CHAR g_type
           ON IDLE g_idle_seconds
               CALL cl_on_idle()
       
           ON ACTION about         #MOD-4C0121
              CALL cl_about()      #MOD-4C0121
       
           ON ACTION controlg      #MOD-4C0121
              CALL cl_cmdask()     #MOD-4C0121
       
           ON ACTION help          #MOD-4C0121
              CALL cl_show_help()  #MOD-4C0121
        END PROMPT
        IF g_type MATCHES "[012]" OR INT_FLAG THEN
           EXIT WHILE
        ELSE
           CONTINUE WHILE
        END IF
    END WHILE
 
   IF g_type = 0 THEN
      LET INT_FLAG = 1
   END IF
 
 
END FUNCTION
 
 
FUNCTION aws_efstat2_cf()
    DEFINE l_azg	RECORD LIKE azg_file.*
 
    #--FUN-960057--start--
    DECLARE stat_cs CURSOR FOR SELECT * FROM azg_file
                               WHERE azg01 = g_formNum
                                 AND azg09 = g_prog
                                 AND azg06 <> 'AutoNumber'        #MOD-A30158 add
                               ORDER BY azg02 DESC, azg03 DESC
    DECLARE stat_cs2 CURSOR FOR SELECT * FROM azg_file
                                WHERE azg01 = g_formNum
                                  AND azg06 <> 'AutoNumber'        #MOD-A30158 add
                               #ORDER BY azg02 DESC, azg06 DESC  
                                ORDER BY azg02 DESC, azg03 DESC  #TQC-740286
    OPEN stat_cs
    FETCH stat_cs INTO l_azg.*
    IF SQLCA.SQLCODE OR SQLCA.SQLCODE = NOTFOUND THEN
       OPEN stat_cs2
       FETCH stat_cs2 INTO l_azg.*
       IF SQLCA.SQLCODE OR SQLCA.SQLCODE = NOTFOUND THEN
          CALL cl_err('select azg: ', SQLCA.SQLCODE, 0)
          LET g_strXMLInput = ''
          CLOSE stat_cs
          CLOSE stat_cs2
          RETURN
       END IF
       CLOSE stat_cs2
    END IF
    CLOSE stat_cs
    #--FUN-960057--end--
 
    IF g_aza.aza72 = 'N' THEN
       CASE g_type
            WHEN '1' CALL aws_efstat2_XMLHeader("GetFormFlow")         #查詢簽核流程
            WHEN '2' CALL aws_efstat2_XMLHeader("GetApproveOpinion")   #查詢簽核意見
       END CASE
    ELSE
        CALL aws_efstat2_XMLHeader("GetFormFlow")         #查詢簽核流程
    END IF
 
    LET g_strXMLInput = g_strXMLInput CLIPPED,
        "    <TargetFormID>", l_azg.azg08 CLIPPED, "</TargetFormID>", ASCII 10,
        "    <TargetSheetNo>", l_azg.azg06 CLIPPED, "</TargetSheetNo>", ASCII 10
 
    CALL aws_efstat2_XMLTrailer()
END FUNCTION
 
 
FUNCTION aws_efstat2_XMLHeader(p_method)
    DEFINE p_method	LIKE type_file.chr20,  #No.FUN-680130 VARCHAR(20) 
           l_client	LIKE type_file.chr20,  #No.FUN-680130 VARCHAR(20) 
           l_efsiteip	LIKE type_file.chr20,  #No.FUN-680130 VARCHAR(20) 
           l_efsitename	LIKE type_file.chr20,  #No.FUN-680130 VARCHAR(20) 
           l_i		LIKE type_file.num5    #No.FUN-680130 SMALLINT
    DEFINE l_wsj02      LIKE wsj_file.wsj02
    DEFINE l_wsj03      LIKE wsj_file.wsj03
    DEFINE l_wsj04      LIKE wsj_file.wsj04
    DEFINE l_tpip       STRING,   #FUN-960137
           l_tpenv      STRING    #FUN-960137
 
    SELECT wsj02,wsj03,wsj04 INTO l_wsj02,l_wsj03,l_wsj04
      FROM wsj_file where wsj01 = 'E' AND wsj06 = g_plant
        AND wsj05 = '*' AND wsj07 = '*'
    IF l_wsj02 IS NULL THEN
      SELECT wsj02,wsj03,wsj04 INTO l_wsj02,l_wsj03,l_wsj04
        FROM wsj_file where wsj01 = 'S' AND wsj06 = '*'
         AND wsj05 = '*' AND wsj07 = '*'
    END IF
 
    LET l_client = cl_getClientIP()       #Client IP
    LET g_efsoap = l_wsj03 CLIPPED       #EasyFlow SOAP
    LET l_efsiteip = l_wsj02 CLIPPED     #EasyFlow server IP
    LET l_efsitename = l_wsj04 CLIPPED   #EasyFlow server name
    LET l_tpip = cl_get_tpserver_ip()    #TIPTOP IP   #FUN-960137
    LET l_tpenv = cl_get_env()           #TIPTOP ENV  #FUN-960137
 
    LET g_strXMLInput =                           #組 XML Header
        "<Request>", ASCII 10,
        " <RequestMethod>", p_method CLIPPED, "</RequestMethod>", ASCII 10,
        " <LogOnInfo>", ASCII 10,
        "  <SenderIP>", l_client CLIPPED, "</SenderIP>", ASCII 10,
        "  <ReceiverIP>", l_efsiteip CLIPPED, "</ReceiverIP>", ASCII 10,
        "  <EFSiteName>", l_efsitename CLIPPED, "</EFSiteName>", ASCII 10,
        "  <EFLogonID>", g_user CLIPPED, "</EFLogonID>", ASCII 10,
        "  <TPServerIP>",l_tpip CLIPPED, "</TPServerIP>", ASCII 10,    #FUN-960137
        "  <TPServerEnv>",l_tpenv CLIPPED, "</TPServerEnv>", ASCII 10, #FUN-960137
        " </LogOnInfo>", ASCII 10,
        " <RequestContent>", ASCII 10,
	"  <ContentText>", ASCII 10,
        "   <Form>", ASCII 10
END FUNCTION
 
 
FUNCTION aws_efstat2_XMLTrailer()
    LET g_strXMLInput = g_strXMLInput CLIPPED,   #組 XML Trailer
        "   </Form>", ASCII 10,
	"  </ContentText>", ASCII 10,
        " </RequestContent>", ASCII 10,
        "</Request>"
END FUNCTION
 
FUNCTION aws_efstat2_approveLog(p_formNum)
    DEFINE p_formNum		  STRING
    DEFINE l_azg	          RECORD LIKE azg_file.*
    DEFINE r                      om.XmlReader
    DEFINE e,xmlname,aws_run      String
    DEFINE ef_approvelog          DYNAMIC ARRAY OF STRING
    DEFINE l_i,i,l_cnt            LIKE type_file.num10   #No.FUN-680130 integer
    DEFINE l_wsc                  RECORD LIKE wsc_file.*
    DEFINE tag                    STRING
    DEFINE l_file                 STRING
    DEFINE l_start        DATETIME HOUR TO FRACTION(5),
           l_end          DATETIME HOUR TO FRACTION(5)
    DEFINE l_interval     INTERVAL SECOND TO FRACTION(5)
    DEFINE l_cross_status LIKE type_file.num5            #No.FUN-B30003
    DEFINE l_str          STRING                         #No.FUN-B30003
    DEFINE l_str2         STRING                         #No.FUN-B10067
    
    WHENEVER ERROR CALL cl_err_msg_log
 
    LET l_start = CURRENT HOUR TO FRACTION(5)  #FUN-5C0030
 
    LET g_formNum = p_formNum
    INITIALIZE l_wsc.* TO NULL
    #--FUN-960057--start--
    DECLARE approve_cs CURSOR FOR SELECT * FROM azg_file
                                   WHERE azg01 = g_formNum
                                     AND azg09 = g_progID
                                     AND azg06 <> 'AutoNumber'        #MOD-A30158 add
                                   ORDER BY azg02 DESC, azg03 DESC
    DECLARE approve_cs2 CURSOR FOR SELECT * FROM azg_file
                                    WHERE azg01 = g_formNum
                                      AND azg06 <> 'AutoNumber'        #MOD-A30158 add
                                    ORDER BY azg02 desc, azg03 desc 
    OPEN approve_cs
    FETCH approve_cs INTO l_azg.*
    IF SQLCA.SQLCODE OR SQLCA.SQLCODE = NOTFOUND THEN
       OPEN approve_cs2
       FETCH approve_cs2 INTO l_azg.*
       IF SQLCA.SQLCODE OR SQLCA.SQLCODE = NOTFOUND THEN
          CALL cl_err('select azg: ', SQLCA.SQLCODE, 0)
          LET g_strXMLInput = ''
          CLOSE approve_cs
          CLOSE approve_cs2
          RETURN
       END IF
       CLOSE approve_cs2
    END IF 
    CLOSE approve_cs
    #--FUN-960057--end--
 
    CALL aws_efstat2_XMLHeader("GetApproveLog")        
    display l_azg.azg08,l_azg.azg06
    LET g_strXMLInput = g_strXMLInput CLIPPED,
        "    <TargetFormID>", l_azg.azg08 CLIPPED, "</TargetFormID>", ASCII 10,
        "    <TargetSheetNo>", l_azg.azg06 CLIPPED, "</TargetSheetNo>", ASCII 10,#FUN-C40060
        "    <ApproveType>NORMAL</ApproveType>",ASCII 10                         #FUN-C40060
 
    CALL aws_efstat2_XMLTrailer()
 
    LET g_strXMLInput = aws_xml_replace(g_strXMLInput)

    #No:FUN-B30003 -- start --
    #-------------------------------------------------------------------------------------#
    # TIPTOP 與 CROSS 整合: 透過 CROSS 平台呼叫 EasyFlow                                  #
    #-------------------------------------------------------------------------------------#
    SELECT wap02 INTO g_wap.wap02 FROM wap_file
    IF g_wap.wap02 = 'Y' THEN  #使用CROSS整合平台
       IF g_aza.aza72 = 'N' THEN
          LET l_str = "EFNET"
       ELSE
          LET l_str = "EFGP"
       END IF
       #呼叫 CROSS 平台發出整合活動請求
       CALL aws_cross_invokeSrv(l_str,"GetApproveLog","sync",g_strXMLInput) 
            RETURNING l_cross_status, l_status, l_Result
       IF NOT l_cross_status  THEN
          RETURN 
       END IF
    ELSE
    #No:FUN-B30003 -- end --
       IF g_aza.aza72 = 'N' THEN
          LET EFGateWay_soapServerLocation = g_efsoap  #指定 EF Soap server location
       ELSE
          LET EFGPGateWay_soapServerLocation = g_efsoap #指定 EFGP Soap server location
       END IF
 
       CALL fgl_ws_setOption("http_invoketimeout", 60)        #若 60 秒內無回應則放棄
       #FUN-C40005 start
       FOR l_i = 1 TO 3
          IF g_aza.aza72 = 'N' THEN
             CALL EFGateWay_TipTopCoordinator(g_strXMLInput)     #連接 EasyFlow SOAP server
                  RETURNING l_status, l_Result
          ELSE
             CALL EFGPGateWay_EasyFlowGPGateWay(g_strXMLInput)   #連接 EasyFlowGP SOAP server
                  RETURNING l_status, l_Result
          END IF
          IF l_status = 0 THEN
             EXIT FOR
          END IF
          SLEEP 5
          DISPLAY "Retry:" , l_i  , " : " , l_status
       END FOR
       #FUN-C40005 end
    END IF   #No:FUN-B30003
 
 
    IF l_status = 0 THEN
       IF (aws_xml_getTag(l_Result, "ReturnStatus") != 'Y') OR
          (aws_xml_getTag(l_Result, "ReturnStatus") IS NULL) THEN
          IF aws_xml_getTag(l_Result, "ReturnStatus") IS NULL THEN
               LET g_str = l_Result
          ELSE
               LET g_str = aws_xml_getTag(l_Result, "ReturnDescribe")
          END IF
          IF fgl_getenv('FGLGUI') = '1' THEN
             LET g_str = "Get status error:\n\n", g_str
          ELSE
             LET g_str = "Get status error: ", g_str
          END IF
          CALL cl_err(g_str, '!', 1)   #XML 字串有問題
          RETURN
       END IF
       LET xmlname = FGL_GETPID() USING '<<<<<<<<<<' 
       LET xmlname = "aws_efstat2_aaprove_",xmlname,".xml"
       DISPLAY "xmlname: ",xmlname 
       
       LET buf = base.StringBuffer.create()
       CALL buf.append(l_Result)
       CALL buf.replace( "&amp;", "&", 0)
       LET l_Result = buf.toString() 
       LET aws_run = "rm ",xmlname CLIPPED," 2>/dev/null"      #FUN-570230
       RUN aws_run
 
       LET channel = base.Channel.create()
       CALL channel.openFile(xmlname, "w")
       CALL channel.setDelimiter("")                          #FUN-880046
       CALL channel.write(l_Result)
       CALL channel.close()
       IF os.Path.chrwx(xmlname CLIPPED,511) THEN END IF   #No.FUN-9C0009
 
       SELECT COUNT(*) INTO l_cnt from wsc_file where wsc01 = g_formNum
                                                  AND wsc15 = g_prog      #CHI-C70021
       IF l_cnt > 0 THEN 
           DELETE FROM wsc_file where wsc01 = g_formNum 
                                  AND wsc15 = g_prog      #CHI-C70021
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","wsc_file",g_formNum,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155
           END IF
       END IF
       
        LET r = om.XmlReader.createFileReader(xmlname)
        LET e = r.read()
        WHILE e IS NOT NULL
            CASE e 
                WHEN "StartElement"
                      IF r.getTagName() = "ContentText" THEN EXIT WHILE END IF
            END CASE
            LET e= r.read()
        END WHILE
        LET e = r.read()
        LET l_i = 1
        LET i = 1  
        WHILE e IS NOT NULL
           CASE e
                WHEN "StartElement"
                      LET tag=""
                      CASE
                         WHEN r.getTagName() = "FlowNo"
                             LET tag = "FlowNo"
                         WHEN r.getTagName() = "BranchNo"
                             LET tag = "BranchNo"
                         WHEN r.getTagName() = "EmpolyeeName"
                             LET tag = "EmpolyeeName"
                         WHEN r.getTagName() = "PositionGradeName"
                             LET tag = "PositionGradeName"
                         WHEN r.getTagName() = "ApprovalResult"
                             LET tag = "ApprovalResult"
                         WHEN r.getTagName() = "ApprovalOpinion"
                             LET tag = "ApprovalOpinion"
                         WHEN r.getTagName() = "Date"
                             LET tag = "Date"
                         WHEN r.getTagName() = "PicName"     #FUN-8C0017 add
                             LET tag = "PicName"             #FUN-8C0017 add
                         WHEN r.getTagName() = "EmpolyeeId"  #FUN-C90012  
                             LET tag = "EmpolyeeId"
                      END CASE   
                 WHEN "Characters"
                      CASE
                         WHEN tag = "FlowNo"
                             LET l_wsc.wsc04 = r.getCharacters()
                         WHEN tag = "BranchNo"
                             LET l_wsc.wsc05 = r.getCharacters()
                         WHEN tag = "EmpolyeeName"
                             LET l_wsc.wsc06 = r.getCharacters()
                         WHEN tag = "PositionGradeName"
                             LET l_wsc.wsc07 = r.getCharacters()
                         WHEN tag = "ApprovalResult"
                             LET l_wsc.wsc08 = r.getCharacters()
                         WHEN tag = "ApprovalOpinion"
                             LET l_wsc.wsc09 = r.getCharacters()
                         WHEN tag = "Date"
                             LET l_wsc.wsc10 = r.getCharacters()
                         #FUN-B10067 start
                         #FUN-C90012 EF.NET & EFGP 共用程式段
                         #IF  g_aza.aza72 = 'Y' THEN                    #判斷是否和EFGP整合，若不是則不回塞簽核時間
                             LET l_str2 = r.getCharacters()            #將簽核日期時間另存成l_str2字串                  
                             LET l_wsc.wsc10 = r.getCharacters()       #取簽核日期存至wsc10
                             LET l_wsc.wsc14 = l_str2.subString(12,l_str2.getlength()) #將簽核時間另存至wsc14
                         #ELSE
                         #    LET l_wsc.wsc10 = r.getCharacters() 
                         #END IF
                         #FUN-C90012 end
                         #FUN-B10067 end
                             
                         WHEN tag = "PicName"                    #FUN-8C0017 add
                             LET l_wsc.wsc13 = r.getCharacters() #FUN-8C0017 add

                         WHEN tag = "EmpolyeeId"                 #FUN-C90012
                             LET l_wsc.wsc16 = r.getCharacters()
                       END CASE
                WHEN "EndElement"
                      IF r.getTagName() = "ApproveLog" THEN
                         #EFGP 第一關固定為流程發起人，故不記錄其簽核資訊
                         IF g_aza.aza72 = 'N' OR i <> 1 THEN
                            LET l_wsc.wsc01 = g_formNum
                            LET l_wsc.wsc02 = l_azg.azg08
                            LET l_wsc.wsc03 = l_azg.azg06
                            LET l_wsc.wsc11 = TODAY
                            LET l_wsc.wsc12 = TIME
                            LET l_wsc.wsc15 = l_azg.azg09 #程式代號 CHI-C70021

                            INSERT INTO wsc_file VALUES (l_wsc.*)
                            IF SQLCA.sqlcode THEN 
                               CALL cl_err3("ins","wsc_file",l_wsc.wsc01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155
                            END IF
                        END IF
                        INITIALIZE l_wsc.* TO NULL
                        LET i = i + 1
                      END IF
           END CASE
           LET e= r.read()
        END WHILE
 
    ELSE
       IF fgl_getenv('FGLGUI') = '1' THEN
          LET g_str = "Connection failed:\n\n",
                      "  [Code]: ", wserror.code, "\n",
                      "  [Action]: ", wserror.action, "\n",
                      "  [Description]: ", wserror.description
       ELSE
          LET g_str = "Connection failed: ", wserror.description
       END IF
    END IF
 
    LET aws_run = "rm ",xmlname CLIPPED," 2>/dev/null"      #FUN-570230
    RUN aws_run
 
    #記錄此次呼叫的 method name
    LET l_file = "aws_efsrv2-", TODAY USING 'YYYYMMDD', ".log"
    LET channel = base.Channel.create()
 
    CALL channel.openFile(l_file,  "a")
    IF STATUS = 0 THEN
        CALL channel.setDelimiter("")
        LET g_str = "#--------------------------- (", CURRENT YEAR TO SECOND, ") ----------------------------#"
        CALL channel.write(g_str)
        CALL channel.write("")
        LET g_str = "Method: GetApproveLog"
        CALL channel.write(g_str)
        LET g_str = "Form Number: ", p_formNum CLIPPED
        CALL channel.write(g_str)
        CALL channel.write("")
 
        #紀錄傳入的 XML 字串
        CALL channel.write("Request XML:")
        CALL channel.write(g_strXMLInput)
 
        #紀錄回傳的 XML 字串
        CALL channel.write("Response XML:")
 
        IF l_status = 0 THEN
           CALL channel.write(l_Result)
        ELSE
           CALL channel.write("")
           IF fgl_getenv('FGLGUI') = '1' THEN
              LET g_str = "   Connection failed:\n\n",
                       "     [Code]: ", wserror.code, "\n",
                       "     [Action]: ", wserror.action, "\n",
                       "     [Description]: ", wserror.description
           ELSE
              LET g_str = "   Connection failed: ", wserror.description
           END IF
           CALL channel.write(g_str)
           CALL channel.write("")
        END IF
 
        #記錄TIPTOP處理的總時間
        LET l_end = CURRENT HOUR TO FRACTION(5)
        LET l_interval = l_end - l_start
        LET g_str = "Process Duration: ", l_interval ," seconds."
        CALL channel.write(g_str)
        CALL channel.write("")
 
        CALL channel.write("#------------------------------------------------------------------------------#")
        CALL channel.write("")
        CALL channel.close()
 
        IF os.Path.chrwx(l_file CLIPPED,438) THEN END IF   #No.FUN-9C0009
    ELSE
        DISPLAY "Can't open log file."
    END IF
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/11
