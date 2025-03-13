# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: aws_efcol
# Descriptions...: 傳遞 TIPTOP 表單與 EasyFlow 整合欄位
# Date & Author..: 92/04/14 By Brendan
 # Modify.........: No.MOD-4A0298 04/10/25 By Echo 調整客製、gae_file程式
 # Modify.........: No.MOD-4B0222 04/11/23 By Echo 將 XML 中特殊定義的字元( &) 取代為標準規範中的取代字元(&amp;)
 # Modify.........: No.MOD-530792 05/03/28 by Echo VARCHAR->CHAR
# Modify.........: No.FUN-550075 05/06/11 By Echo 新增EasyFlow站台
# Modify.........: No.FUN-570230 05/07/29 By Echo 將傳遞xml的log資料存至aws_efcli2-日期.log
# Modify.........: No.FUN-680130 06/09/01 By Xufeng 字段類型定義改為LIKE
# Modify.........: No.FUN-710010 07/01/16 By chingyuan TIPTOP與EasyFlow GP整合     
# Modify.........: No.FUN-720042 07/02/27 Genero 2.0
 
IMPORT com
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
#No.FUN-720042
GLOBALS "../4gl/aws_efgw.inc"
GLOBALS "../4gl/awsef.4gl"
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_efgpgw.inc" #No.FUN-710010
 
DEFINE channel base.Channel
 
DEFINE g_cfg_prog  	LIKE wsa_file.wsa01,   #No.FUN-680130 VARCHAR(10)
       g_type	        LIKE type_file.chr1    #No.FUN-680130 VARCHAR(1)
DEFINE g_efsoap         STRING
 
FUNCTION aws_efcol(p_type, p_prog)
    DEFINE p_prog	LIKE wsa_file.wsa01,   #No.FUN-680130 VARCHAR(10)
           p_type	LIKE type_file.chr1,   #No.FUN-680130 VARCHAR(1)
           l_Result	STRING,
           l_str	STRING,
           l_status	LIKE type_file.num10,  #No.FUN-680130 INTEGER
           l_cmd        STRING,
           l_file       STRING
 
    DEFINE buf          base.StringBuffer
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF p_prog IS NULL THEN CALL cl_err('',-400,0) RETURN END IF   #尚未查詢資料
    LET g_type = p_type
    LET g_cfg_prog = p_prog
    CALL aws_efcol_columnSet()       #組傳遞的 XML字串
 
   ##No.MOD-4B0222
  ###轉換 & 為 &amp; 
    LET buf = base.StringBuffer.create()
    CALL buf.append(g_strXMLInput)
    CALL buf.replace( "&", "&amp;", 0)
    LET g_strXMLInput = buf.toString()
   ##END No.MOD-4B0222
    #FUN-550075
    #LET EFGateWay_soapServerLocation = g_efsoap                          #指定 Soap server location
    
    #No.FUN-710010 --start--
    IF g_aza.aza72 = 'N' THEN 
        LET EFGateWay_soapServerLocation = g_efsoap  #指定 Soap server location
    ELSE #指定EasyFlowGP的SOAP網址
        LET EFGPGateWay_soapServerLocation = g_efsoap  #指定 Soap server location
    END IF
    #No.FUN-710010 --end--
    
    #LET EFGateWay_soapServerLocation = fgl_getenv('EFSOAP') CLIPPED   #指定 Soap server location
    #END FUN-550075
    CALL fgl_ws_setOption("http_invoketimeout", 60)                   #若 60 秒內無回應則放棄
    #CALL EFGateWay_TipTopCoordinator(g_strXMLInput)                   #連接 EasyFlow SOAP server
    #     RETURNING l_status, l_Result
    
    #No.FUN-710010 --start--
    IF g_aza.aza72 = 'N' THEN
        CALL EFGateWay_TipTopCoordinator(g_strXMLInput)                   #連接 EasyFlow SOAP server
          RETURNING l_status, l_Result
    ELSE
        CALL EFGPGateWay_EasyFlowGPGateWay(g_strXMLInput)    #連接 EasyFlowGP SOAP server
          RETURNING l_status, l_Result
    END IF
    #No.FUN-710010 --end--
 
    #記錄傳入的 XML 字串
    LET channel = base.Channel.create()
 
    #FUN-570230
    LET l_file = "aws_efcli-", TODAY USING 'YYYYMMDD', ".log"
    CALL channel.openFile(l_file, "a")
    #CALL channel.openFile("aws_efcol.log", "w")
    #END FUN-570230
 
    IF STATUS = 0 THEN
       CALL channel.setDelimiter("")
       LET l_str = "#--------------------------- (", CURRENT YEAR TO SECOND, ") ----------------------------#"
       CALL channel.write(l_str)
       CALL channel.write("")
       CALL channel.write("Request XML:")
       CALL channel.write(g_strXMLInput)
       CALL channel.write("")
 
       #紀錄回傳的 XML 字串
       CALL channel.write("Response XML:")
       CALL channel.write(l_Result)
       CALL channel.write("#------------------------------------------------------------------------------#")
       CALL channel.close()
       #FUN-570230
       #RUN "chmod 666 aws_efcol.log >/dev/null 2>/dev/null"
        LET l_cmd = "chmod 666 ", l_file CLIPPED, " >/dev/null 2>/dev/null"   #MOD-560007
       RUN l_cmd
       #END FUN-570230
 
    ELSE
        DISPLAY "Can't open log file."
    END IF
 
    IF l_status = 0 THEN
       IF (aws_xml_getTag(l_Result, "ReturnStatus") != 'Y') OR
          (aws_xml_getTag(l_Result, "ReturnStatus") IS NULL) THEN
          IF fgl_getenv('FGLGUI') = '1' THEN
             LET l_str = "Transmission error:\n\n", 
                         aws_xml_getTag(l_Result, "ReturnDescribe")
          ELSE
             LET l_str = "Transmission error: ",
                         aws_xml_getTag(l_Result, "ReturnDescribe")
          END IF
       ELSE
          LET l_str = "'ColumnSet' has been successfully transmitted."
       END IF
    ELSE
       IF fgl_getenv('FGLGUI') = '1' THEN
          LET l_str = "Connection failed:\n\n",
                      "  [Code]: ", wserror.code, "\n",
                      "  [Action]: ", wserror.action, "\n",
                      "  [Description]: ", wserror.description
       ELSE
          LET l_str = "Connection failed: ", wserror.description
       END IF
    END IF
    CALL cl_err(l_str, '!', 1)   #顯示執行訊息
END FUNCTION
 
 
FUNCTION aws_efcol_columnSet()
    DEFINE l_sql	STRING,
           l_wsa	RECORD LIKE wsa_file.*,
           l_wsb	RECORD LIKE wsb_file.*,
           l_str	LIKE gae_file.gae04,   #No.FUN-680130 VARCHAR(200)
           l_cnt        LIKE type_file.num10   #No.FUN-680130 INTEGER
 
 
    CALL aws_efcol_XMLHeader()                       #組 XML Header 字串
    IF g_type = 'S' THEN   #如果是單筆傳送
       LET l_sql = "SELECT * FROM wsa_file WHERE wsa01 ='", g_cfg_prog CLIPPED, "'"
    END IF
    IF g_type = 'W' THEN   #如果是整批傳送
       LET l_sql = "SELECT * FROM wsa_file ORDER BY wsa01"
    END IF
 
    PREPARE efcol_p1 FROM l_sql
    DECLARE efcol_c1 CURSOR WITH HOLD FOR efcol_p1
    FOREACH efcol_c1 INTO l_wsa.*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_strXMLInput = g_strXMLInput CLIPPED,
            "   <Program ",
                "name=\"", l_wsa.wsa01 CLIPPED, "\">", ASCII 10,
            "    <Head>", ASCII 10
 
        #單頭欄位
        LET l_sql = "SELECT * FROM wsb_file WHERE ",
                    " wsb01 = '", l_wsa.wsa01, "' AND ",
                    " wsb02 = '1' ORDER BY wsb03"
        PREPARE efcol_p2 FROM l_sql
        DECLARE efcol_c2 CURSOR FOR efcol_p2
        FOREACH efcol_c2 INTO l_wsb.*
            IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
            ### MOD-4A0298 ###
            #依設定的單頭欄位及語言別抓取欄位說明並組成 XML 字串
           
 
            SELECT gae04 INTO l_str FROM gae_file
               WHERE gae02 = l_wsb.wsb03 AND gae03 = g_lang AND
                    gae01 = l_wsb.wsb01 AND gae11='Y'
            IF SQLCA.SQLCODE THEN   #失敗的話以標準為說明
                SELECT gae04 INTO l_str FROM gae_file
                   WHERE gae02 = l_wsb.wsb03 AND gae03 = g_lang AND
                   gae01 = l_wsb.wsb01 AND (gae11='N' OR gae11 IS NULL)
            END IF
 
 
            ### END MOD-4A0298 ###
 
            IF SQLCA.SQLCODE THEN   #失敗的話以欄位名稱當作欄位的說明
               SELECT gaq03 INTO l_str FROM gaq_file 
                WHERE gaq01 = l_wsb.wsb03 AND
                      gaq02 = g_lang 
 
               IF SQLCA.SQLCODE THEN
                  LET l_str = l_wsb.wsb03
               END IF
            END IF
            LET g_strXMLInput = g_strXMLInput CLIPPED,
                "     <", l_wsb.wsb03 CLIPPED, ">",
                l_str CLIPPED,
                "</", l_wsb.wsb03 CLIPPED, ">", ASCII 10
        END FOREACH
 
        LET g_strXMLInput = g_strXMLInput CLIPPED,
            "    </Head>", ASCII 10,
            "    <Body>", ASCII 10
 
        #單身欄位
        LET l_sql = "SELECT * FROM wsb_file WHERE ",
                    " wsb01 = '", l_wsa.wsa01, "' AND ",
                    " wsb02 = '2' ORDER BY wsb03"
        PREPARE efcol_p3 FROM l_sql
        DECLARE efcol_c3 CURSOR FOR efcol_p3
        FOREACH efcol_c3 INTO l_wsb.*
            IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
            #依設定的單身欄位及語言別抓取欄位說明並組成 XML 字串
              
            SELECT gae04 INTO l_str FROM gae_file
               WHERE gae02 = l_wsb.wsb03 AND gae03 = g_lang AND
                    gae01 = l_wsb.wsb01 AND gae11='Y'
            IF SQLCA.SQLCODE THEN   #失敗的話以標準為說明
                SELECT gae04 INTO l_str FROM gae_file
                   WHERE gae02 = l_wsb.wsb03 AND gae03 = g_lang AND
                   gae01 = l_wsb.wsb01 AND (gae11='N' OR gae11 IS NULL)
            END IF
 
            IF SQLCA.SQLCODE THEN   #失敗的話以欄位名稱當作欄位的說明
               SELECT gaq03 INTO l_str FROM gaq_file
                WHERE gaq01 = l_wsb.wsb03 AND
                      gaq02 = g_lang
 
               IF SQLCA.SQLCODE THEN
                  LET l_str = l_wsb.wsb03
               END IF
            END IF
            LET g_strXMLInput = g_strXMLInput CLIPPED,
                "     <", l_wsb.wsb03 CLIPPED, ">",
                l_str CLIPPED,
                "</", l_wsb.wsb03 CLIPPED, ">", ASCII 10
        END FOREACH
 
        LET g_strXMLInput = g_strXMLInput CLIPPED,
            "    </Body>", ASCII 10,
            "   </Program>", ASCII 10
    END FOREACH
 
    CALL aws_efcol_XMLTrailer()                      #組 XML Trailer 字串
END FUNCTION
 
 
FUNCTION aws_efcol_XMLHeader()
    DEFINE l_client     STRING,
           l_efsiteip   STRING,
           l_efsitename STRING,
           l_lang	STRING,
           l_i          LIKE type_file.num5          #No.FUN-680130 SMALLINT
    DEFINE l_wsj02 LIKE wsj_file.wsj02
    DEFINE l_wsj03 LIKE wsj_file.wsj03
    DEFINE l_wsj04 LIKE wsj_file.wsj04
 
    #FUN-550075
    SELECT wsj02,wsj03,wsj04 INTO l_wsj02,l_wsj03,l_wsj04
      FROM wsj_file where wsj01 = 'E' AND wsj06 = g_plant
       AND wsj05 = '*' AND wsj07 = '*'
    IF l_wsj02 IS NULL THEN
       SELECT wsj02,wsj03,wsj04 INTO l_wsj02,l_wsj03,l_wsj04
         FROM wsj_file where wsj01 = 'S' AND wsj06 = '*'
          AND wsj05 = '*' AND wsj07 = '*'
    END IF
 
    LET g_efsoap = l_wsj03 CLIPPED       #EasyFlow SOAP
    LET l_efsiteip = l_wsj02 CLIPPED     #EasyFlow server IP
    LET l_efsitename = l_wsj04 CLIPPED   #EasyFlow server name
    LET l_client = cl_getClientIP()       #Client IP
   # LET l_efsiteip = fgl_getenv('EFSITEIP')       #EasyFlow server IP
   # LET l_efsitename = fgl_getenv('EFSITENAME')   #EasyFlow server name
   #END FUN-550075
 
    CASE g_lang                                   #指定語言別
         WHEN '0' LET l_lang = "Big5"
         WHEN '1' LET l_lang = "ISO8859"
         WHEN '2' LET l_lang = "GB"
         OTHERWISE LET l_lang = "ISO8859"
    END CASE
 
    LET g_strXMLInput =                           #組 XML Header
        "<Request>", ASCII 10,
        " <RequestMethod>ColumnSet</RequestMethod>",  ASCII 10,
        " <LogOnInfo>",  ASCII 10,
        "  <SenderIP>", l_client CLIPPED, "</SenderIP>",  ASCII 10,
        "  <ReceiverIP>", l_efsiteip CLIPPED, "</ReceiverIP>",  ASCII 10,
        "  <EFSiteName>", l_efsitename CLIPPED, "</EFSiteName>",  ASCII 10,
        "  <EFLogonID>", g_user CLIPPED, "</EFLogonID>",  ASCII 10,
#        "  <EFLogonID>512</EFLogonID>",  ASCII 10,
        " </LogOnInfo>",  ASCII 10,
        " <RequestContent>",  ASCII 10,
        "  <ContentText>", ASCII 10,
        "   <Language>", l_lang CLIPPED, "</Language>", ASCII 10
END FUNCTION
 
 
FUNCTION aws_efcol_XMLTrailer()
    LET g_strXMLInput = g_strXMLInput CLIPPED,    #組 XML Trailer
        "  </ContentText>", ASCII 10,
        " </RequestContent>", ASCII 10,
        "</Request>"
END FUNCTION
