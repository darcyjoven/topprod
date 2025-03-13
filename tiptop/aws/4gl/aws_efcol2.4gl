# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aws_efcol2
# Descriptions...: 傳遞 TIPTOP 表單與 EasyFlow 整合欄位
# Date & Author..: 
# Modify.........: No.FUN-550075 05/05/18 By Echo 新增EasyFlow站台設定
# Modify.........: No.MOD-560007 05/06/02 By Echo 重新定義FUN名稱
# Modify.........: No.FUN-570230 05/07/29 By Echo 將傳遞xml的log資料存至aws_efcli2-日期.log
# Modify.........: No.FUN-680130 06/09/01 By Xufeng 字段類型定義改為LIKE
# Modify.........: No.FUN-710010 07/01/16 By chingyuan TIPTOP與EasyFlow GP整合     
# Modify.........: No.FUN-720042 07/02/27 Genero 2.0
# Modify.........: No.FUN-710063 07/05/14 By Echo XML 特殊字元處理功能
# Modify.........: No.TQC-750259 07/06/04 By Echo 增加記錄 SOAP error 錯誤訊息
# Modify.........: No.FUN-770047 07/09/26 by Echo 新增整合-備註功能
# Modify.........: No.FUN-780049 07/09/26 By Echo 若回傳不完整的XML格式字串或錯誤訊息時，則直接顯示對方回傳的資料
# Modify.........: No.FUN-960137 09/06/18 By Vicky Request字串增加TIPTOP主機資訊 (多TP 對 一EF GP)
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:CHI-9C0016 09/12/09 By Dido gae_file key值調整 
# Modify.........: No:TQC-970047 10/09/15 By Jay CALL aws_xml_replace()改為取得欄位說明後就CALL aws_xml_replaceStr()
# Modify.........: No:FUN-B30003 11/04/11 By Jay TIPTOP 與 CROSS 整合功能: 透過 CROSS 平台串接 
# Modify.........: No:FUN-C40086 12/05/02 By Kevin 資安欄位傳送
 
IMPORT com

IMPORT os   #No.FUN-9C0009 
DATABASE ds
#No.FUN-720042
GLOBALS "../4gl/aws_efgw.inc"
GLOBALS "../../config/top.global"
GLOBALS "../4gl/awsef.4gl"
GLOBALS "../4gl/aws_efgpgw.inc" #No.FUN-710010
GLOBALS "../4gl/aws_crossgw.inc"#No:FUN-B30003
 
DEFINE channel base.Channel
 
DEFINE g_cfg_prog  	LIKE wsd_file.wsd01,
       g_type	        LIKE type_file.chr1    #No.FUN-680130 VARCHAR(1)                                 
 
DEFINE g_efsoap     STRING
DEFINE g_wap        RECORD LIKE wap_file.*     #No:FUN-B30003
 
FUNCTION aws_efcol2(p_type, p_prog)
    DEFINE p_prog	LIKE wsd_file.wsd01,
           p_type	LIKE type_file.chr1,   #No.FUN-680130 VARCHAR(1) 
           l_Result	STRING,
           l_str	STRING,
           l_status	LIKE type_file.num10,  #No.FUN-680130 INTEGER
           l_cmd        STRING,
           l_file       STRING
 
    DEFINE buf          base.StringBuffer
    DEFINE l_cross_status   LIKE type_file.num5    #No.FUN-B30003
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF p_prog IS NULL THEN CALL cl_err('',-400,0) RETURN END IF   #尚未查詢資料
    LET g_type = p_type
    LET g_cfg_prog = p_prog
    CALL aws_efcol2_columnSet()       #組傳遞的 XML字串
    
  ###轉換 & 為 &amp; 
    #FUN-710063
    #LET buf = base.StringBuffer.create()
    #CALL buf.append(g_strXMLInput)
    #CALL buf.replace( "&", "&amp;", 0)
    #LET g_strXMLInput = buf.toString()
    #LET g_strXMLInput = aws_xml_replace(g_strXMLInput)  #TQC-970047 mark
    #END FUN-710063
 
   # DISPLAY g_strXMLInput
   # RETURN
    #LET EFGateWay_soapServerLocation = g_efsoap                       #指定 Soap server location

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
       CALL aws_cross_invokeSrv(l_str,"ColumnSet","sync",g_strXMLInput) 
            RETURNING l_cross_status, l_status, l_Result
       IF NOT l_cross_status  THEN
          RETURN 
       END IF
    ELSE
    #No:FUN-B30003 -- end --
       #No.FUN-710010 --start--
       IF g_aza.aza72 = 'N' THEN 
           LET EFGateWay_soapServerLocation = g_efsoap  #指定 Soap server location
       ELSE #指定EasyFlowGP的SOAP網址
           LET EFGPGateWay_soapServerLocation = g_efsoap  #指定 Soap server location
       END IF
       #No.FUN-710010 --end--
    
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
    END IF   #No:FUN-B30003
    
    #記錄傳入的 XML 字串
    LET channel = base.Channel.create()
 
    #FUN-570230
    LET l_file = "aws_efcli2-", TODAY USING 'YYYYMMDD', ".log"
    CALL channel.openFile(l_file, "a")
    #CALL channel.openFile("aws_efcol2.log", "w")
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
 
       #TQC-750259
       IF l_status = 0 THEN
          CALL channel.write(l_Result)
       ELSE
          CALL channel.write("")
          IF fgl_getenv('FGLGUI') = '1' THEN
             LET l_str = "   Connection failed:\n\n",
                      "     [Code]: ", wserror.code, "\n",
                      "     [Action]: ", wserror.action, "\n",
                      "     [Description]: ", wserror.description
          ELSE
             LET l_str = "   Connection failed: ", wserror.description
          END IF
          CALL channel.write(l_str)
          CALL channel.write("")
       END IF
       #END TQC-750259
 
       CALL channel.write("#------------------------------------------------------------------------------#")
       CALL channel.close()
       #FUN-570230
       #RUN "chmod 666 aws_efcol2.log >/dev/null 2>/dev/null"
#       LET l_cmd = "chmod 666 ", l_file CLIPPED, " >/dev/null 2>/dev/null" #MOD-560007 #No.FUN-9C0009
#      RUN l_cmd                                          #No.FUN-9C0009
       IF os.Path.chrwx(l_file CLIPPED,438) THEN END IF   #No.FUN-9C0009
       #END FUN-570230
 
    ELSE
        DISPLAY "Can't open log file."
    END IF
 
    IF l_status = 0 THEN
       IF (aws_xml_getTag(l_Result, "ReturnStatus") != 'Y') OR
          (aws_xml_getTag(l_Result, "ReturnStatus") IS NULL) THEN
          #FUN-780049
          IF aws_xml_getTag(l_Result, "ReturnStatus") IS NULL THEN
               LET l_str = l_Result
          ELSE
               LET l_str = aws_xml_getTag(l_Result, "ReturnDescribe")
          END IF
          IF fgl_getenv('FGLGUI') = '1' THEN
             LET l_str = "Transmission error:\n\n", l_str
          ELSE
             LET l_str = "Transmission error: ", l_str
          END IF
          #END FUN-780049
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
 
 
FUNCTION aws_efcol2_columnSet()
    DEFINE l_sql	STRING,
           l_wsd	RECORD LIKE wsd_file.*,
           l_wsh	RECORD LIKE wsh_file.*,
           l_str	LIKE gae_file.gae04,   #No.FUN-680130 VARCHAR(200)
           l_cnt        LIKE type_file.num10   #No.FUN-680130 INTEGER
    DEFINE k            LIKE type_file.num10   #No.FUN-680130 INTEGER
 
    CALL aws_efcol2_XMLHeader()                       #組 XML Header 字串
    
    #FUN-C40086 --start-- 
    LET l_sql = " SELECT gdu07 FROM gdv_file,gdu_file ",
               "  WHERE gdv05 = gdu01 ",
               "    AND gdv01 = ? ",
               "    AND gdv02 = ? "
    PREPARE gdv_pre FROM l_sql
    DECLARE gdv_curs CURSOR FOR gdv_pre
    #FUN-C40086 --end--
    
    IF g_type = 'S' THEN   #如果是單筆傳送
       LET l_sql = "SELECT * FROM wsd_file WHERE wsd01 ='", g_cfg_prog CLIPPED, "'"
    END IF
    IF g_type = 'W' THEN   #如果是整批傳送
       LET l_sql = "SELECT * FROM wsd_file ORDER BY wsd01"
    END IF
    
    PREPARE efcol_p1 FROM l_sql
    DECLARE efcol_c1 CURSOR WITH HOLD FOR efcol_p1
    FOREACH efcol_c1 INTO l_wsd.*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_strXMLInput = g_strXMLInput CLIPPED,
            "   <Program ",
                "name=\"", l_wsd.wsd01 CLIPPED, "\">", ASCII 10,
            "    <Head>", ASCII 10
 
        #單頭欄位
        LET l_sql = "SELECT * FROM wsh_file WHERE ",
                    " wsh01 = '", l_wsd.wsd01, "' AND ",
                    " wsh02 = 'M' ORDER BY wsh04"
        PREPARE efcol_p2 FROM l_sql
        DECLARE efcol_c2 CURSOR FOR efcol_p2
        FOREACH efcol_c2 INTO l_wsh.*
            IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
            #依設定的單頭欄位及語言別抓取欄位說明並組成 XML 字串
           
 
            SELECT gae04 INTO l_str FROM gae_file
               WHERE gae02 = l_wsh.wsh05 AND gae03 = g_lang 
                 AND gae01 = l_wsh.wsh01 AND gae11='Y'
                 AND gae12 = g_sma.sma124                      #CHI-9C0016
            IF SQLCA.SQLCODE THEN   #失敗的話以標準為說明
                SELECT gae04 INTO l_str FROM gae_file
                   WHERE gae02 = l_wsh.wsh05 AND gae03 = g_lang 
                     AND gae01 = l_wsh.wsh01 AND (gae11='N' OR gae11 IS NULL)
                     AND gae12 = g_sma.sma124                  #CHI-9C0016
            END IF
 
 
 
            IF SQLCA.SQLCODE THEN   #失敗的話以欄位名稱當作欄位的說明
               SELECT gaq03 INTO l_str FROM gaq_file 
                WHERE gaq01 = l_wsh.wsh05 AND
                      gaq02 = g_lang 
 
               IF SQLCA.SQLCODE THEN
                  LET l_str = l_wsh.wsh05
               END IF
            END IF
            LET l_str = aws_xml_replaceStr(l_str)      #TQC-970047 add
            LET g_strXMLInput = g_strXMLInput CLIPPED,
                #"     <", l_wsh.wsh05 CLIPPED, ">",                                   #FUN-C40086
                "     <", l_wsh.wsh05 CLIPPED, aws_efcol2_scrtyitem(l_wsd.wsd01,l_wsh.wsh05) ,">", #FUN-C40086
                l_str CLIPPED,
                "</", l_wsh.wsh05 CLIPPED, ">", ASCII 10
        END FOREACH
 
        LET g_strXMLInput = g_strXMLInput CLIPPED,
            "    </Head>", ASCII 10
 
        #單身欄位
        SELECT MAX(wsh03) INTO l_cnt FROM wsh_file where wsh01 = l_wsd.wsd01 AND 
             wsh02 = 'D'
        IF l_cnt > 0 THEN 
           FOR K = 1 TO l_cnt 
              LET g_strXMLInput = g_strXMLInput CLIPPED,
                   "    <Body>", ASCII 10
              LET l_sql = "SELECT * FROM wsh_file WHERE ",
                          " wsh01 = '", l_wsd.wsd01, "' AND ",
                          " wsh02 = 'D' AND wsh03 =" ,k," ORDER BY wsh04"
              PREPARE efcol_p3 FROM l_sql
              DECLARE efcol_c3 CURSOR FOR efcol_p3
              FOREACH efcol_c3 INTO l_wsh.*
                  IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
             
                  #依設定的單身欄位及語言別抓取欄位說明並組成 XML 字串
                    
                  SELECT gae04 INTO l_str FROM gae_file
                     WHERE gae02 = l_wsh.wsh05 AND gae03 = g_lang 
                       AND gae01 = l_wsh.wsh01 AND gae11='Y'
                       AND gae12 = g_sma.sma124                          #CHI-9C0016
                  IF SQLCA.SQLCODE THEN   #失敗的話以標準為說明
                      SELECT gae04 INTO l_str FROM gae_file
                         WHERE gae02 = l_wsh.wsh05 AND gae03 = g_lang 
                           AND gae01 = l_wsh.wsh01 AND (gae11='N' OR gae11 IS NULL)
                           AND gae12 = g_sma.sma124                      #CHI-9C0016
                  END IF
             
                  IF SQLCA.SQLCODE THEN   #失敗的話以欄位名稱當作欄位的說明
                     SELECT gaq03 INTO l_str FROM gaq_file
                      WHERE gaq01 = l_wsh.wsh05 AND
                            gaq02 = g_lang
             
                     IF SQLCA.SQLCODE THEN
                        LET l_str = l_wsh.wsh05
                     END IF
                  END IF
                  LET l_str = aws_xml_replaceStr(l_str)      #TQC-970047 add
                  LET g_strXMLInput = g_strXMLInput CLIPPED,
                      #"     <", l_wsh.wsh05 CLIPPED, ">",   #FUN-C40086
                      "     <", l_wsh.wsh05 CLIPPED, aws_efcol2_scrtyitem(l_wsd.wsd01,l_wsh.wsh05) , ">",  #FUN-C40086
                      l_str CLIPPED,
                      "</", l_wsh.wsh05 CLIPPED, ">", ASCII 10
              END FOREACH
              LET g_strXMLInput = g_strXMLInput CLIPPED,
                   "    </Body>", ASCII 10
           END FOR
        ELSE
           LET g_strXMLInput = g_strXMLInput CLIPPED,
                  "    <Body>", ASCII 10,
                  "    </Body>", ASCII 10
        END IF
 
        #FUN-770047
        IF g_aza.aza72 = 'Y' THEN
           CALL aws_efcol2_memo(l_wsd.wsd01 CLIPPED)     #組備註字串
        END IF
        #END FUN-770047
 
        LET g_strXMLInput = g_strXMLInput CLIPPED,
            "   </Program>", ASCII 10
    END FOREACH
 
    CALL aws_efcol2_XMLTrailer()                      #組 XML Trailer 字串
END FUNCTION
 
 
FUNCTION aws_efcol2_XMLHeader()
    DEFINE l_client     STRING,
           l_efsiteip   STRING,
           l_efsitename STRING,
           l_lang	STRING,
           l_i          LIKE type_file.num5          #No.FUN-680130 SMALLINT
    DEFINE l_wsj02      LIKE wsj_file.wsj02
    DEFINE l_wsj03      LIKE wsj_file.wsj03
    DEFINE l_wsj04      LIKE wsj_file.wsj04
    DEFINE l_tpip       STRING,   #FUN-960137
           l_tpenv      STRING    #FUN-960137
  
    LET l_client = cl_getClientIP()       #Client IP
 
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
    LET l_tpip = cl_get_tpserver_ip()    #TIPTOP IP   #FUN-960137
    LET l_tpenv = cl_get_env()           #TIPTOP ENV  #FUN-960137
 
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
        "  <TPServerIP>",l_tpip CLIPPED, "</TPServerIP>", ASCII 10,    #FUN-960137
        "  <TPServerEnv>",l_tpenv CLIPPED, "</TPServerEnv>", ASCII 10, #FUN-960137
        " </LogOnInfo>",  ASCII 10,
        " <RequestContent>",  ASCII 10,
        "  <ContentText>", ASCII 10,
        "   <Language>", l_lang CLIPPED, "</Language>", ASCII 10
END FUNCTION
 
 
FUNCTION aws_efcol2_XMLTrailer()
    LET g_strXMLInput = g_strXMLInput CLIPPED,    #組 XML Trailer
        "  </ContentText>", ASCII 10,
        " </RequestContent>", ASCII 10,
        "</Request>"
END FUNCTION
 
#FUN-770047
# Description....: 組備註欄位說明資料 XML
# Date & Author..: 2007/07/18 by Echo
# Parameter......: p_wsd01 - STRING - 程式代碼
# Return.........: none
# Memo...........:
# Modify.........:
#]
FUNCTION aws_efcol2_memo(p_wsd01)                        
DEFINE p_wsd01   STRING
DEFINE l_wsh	 RECORD LIKE wsh_file.*
DEFINE l_sql     STRING
DEFINE l_cnt     LIKE type_file.num10
DEFINE l_str	 LIKE type_file.chr1000
 
        #備註欄位
        LET g_strXMLInput = g_strXMLInput CLIPPED,
            "    <Memo>", ASCII 10
 
        LET l_sql = "SELECT count(*) FROM wsh_file ",
                    " WHERE wsh01 = '", p_wsd01, "'",
                    "   AND wsh02 = 'R'"
        PREPARE wsh_cnt_p FROM l_sql
        DECLARE wsh_cnt CURSOR FOR wsh_cnt_p
        OPEN wsh_cnt
        FETCH wsh_cnt INTO l_cnt
        IF l_cnt = 0 THEN
           LET g_strXMLInput = g_strXMLInput CLIPPED,
               "    </Memo>", ASCII 10
           RETURN
        END IF  
        CLOSE wsh_cnt
 
        LET l_sql = "SELECT * FROM wsh_file WHERE ",
                    " wsh01 = '", p_wsd01, "' AND ",
                    " wsh02 = 'R' ORDER BY wsh04"
        PREPARE efcol_p4 FROM l_sql
        DECLARE efcol_c4 CURSOR FOR efcol_p4
        FOREACH efcol_c4 INTO l_wsh.*
            IF STATUS THEN
               CALL cl_err('foreach:',STATUS,1) 
               EXIT FOREACH 
            END IF
 
            #依設定的備註欄位及語言別抓取欄位說明並組成 XML 字串
            SELECT gae04 INTO l_str FROM gae_file
               WHERE gae02 = l_wsh.wsh05 AND gae03 = g_lang 
                 AND gae01 = l_wsh.wsh01 AND gae11='Y'
                 AND gae12 = g_sma.sma124                          #CHI-9C0016
            IF SQLCA.SQLCODE THEN   #失敗的話以標準為說明
                SELECT gae04 INTO l_str FROM gae_file
                   WHERE gae02 = l_wsh.wsh05 AND gae03 = g_lang 
                     AND gae01 = l_wsh.wsh01 AND (gae11='N' OR gae11 IS NULL)
                     AND gae12 = g_sma.sma124                      #CHI-9C0016
            END IF
 
            IF SQLCA.SQLCODE THEN   #失敗的話以欄位名稱當作欄位的說明
               SELECT gaq03 INTO l_str FROM gaq_file 
                WHERE gaq01 = l_wsh.wsh05 AND gaq02 = g_lang 
               IF SQLCA.SQLCODE THEN
                  LET l_str = l_wsh.wsh05
               END IF
            END IF
            LET l_str = aws_xml_replaceStr(l_str)      #TQC-970047 add
            LET g_strXMLInput = g_strXMLInput CLIPPED,
                "     <", l_wsh.wsh05 CLIPPED, ">",
                l_str CLIPPED,
                "</", l_wsh.wsh05 CLIPPED, ">", ASCII 10
        END FOREACH
 
        LET g_strXMLInput = g_strXMLInput CLIPPED,
            "    </Memo>", ASCII 10
 
END FUNCTION
#END FUN-770047

#FUN-C40086 --start--
# Description....: 傳送資安欄位
# Date & Author..: 2012/05/02 by Kevin
# Parameter......: p_col - STRING - 欄位代碼
# Return.........: none
# Memo...........:
# Modify.........:
#]
FUNCTION aws_efcol2_scrtyitem(p_table,p_col) 
   DEFINE p_table   LIKE gdv_file.gdv01
   DEFINE p_col     LIKE gdv_file.gdv02
   DEFINE l_gdu07   LIKE gdu_file.gdu07
   DEFINE l_str     STRING
   
   IF g_azz.azz18 = "Y"  THEN
      OPEN gdv_curs USING p_table , p_col
      FETCH gdv_curs INTO l_gdu07
      CLOSE gdv_curs
   
      IF cl_null(l_gdu07) THEN
         LET l_str = ""
      ELSE
         LET l_str = " SecurityType='" ,l_gdu07 , "'"
      END IF
      RETURN l_str
   ELSE
      RETURN ""
   END IF 
   
END FUNCTION
#FUN-C40086 --end--
