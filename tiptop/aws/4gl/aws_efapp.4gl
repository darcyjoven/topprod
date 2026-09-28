# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Library name...: aws_efapp
# Descriptions...: 
# Input parameter: 
# Return code....: 
# Usage .........:
# Date & Author..: 
# Modify.........: 
# Modify.........: No.FUN-590076 05/09/16 By Echo g_wsk.wsk05及SourceFormNum 將原定義的CHAR(20)放大至CHAR(80)
# Modify.........: No.TQC-5B0218 05/12/05 By echo 簽核單別種類combobox的表單及簡稱應加CLIPPED
# Modify.........: No.FUN-640184 06/04/12 By Echo 自動執行確認功能
# Modify.........: No.FUN-640181 06/05/09 By Alexstar 若在「系統參數設定作業(aoos010)」裡未設定「簽核流程與EasyFlow串聯」，
#                                                     請"隱藏"整合單據作業裡的「EasyFlow送簽」及「簽核狀況」Button.
# Modify.........: No.FUN-660155 06/06/22 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680130 06/09/01 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No.MOD-690128 06/11/10 By Echo 調整{+}分隔符號時的程式段落，修正組where的條件。
# Modify.........: No.MOD-6B0020 06/11/03 By Echo 在 GetFlowAction 段未收到 easyflow 的回傳,簽核功能的action應不能點選
# Modify.........: No.FUN-6B0024 06/12/25 By Echo 加強防範 TIPTOP & EasyFlow 狀態碼不一致,
#                                                 若未收到EasyFlow回傳的訊息，且重覆呼叫3次
# Modify.........: No.FUN-710010 07/01/16 By chingyuan TIPTOP與EasyFlow GP整合
# Modify.........: No.FUN-720042 07/02/21 By Brendan Genero 2.0 整合
# Modify.........: No.FUN-710063 07/05/14 By Echo XML 特殊字元處理功能
# Modify.........: No.TQC-750259 07/06/04 By Echo 增加記錄 SOAP error 錯誤訊息
# Modify.........: No.FUN-770022 07/07/11 By Echo 非標準整合單據時，隱藏"EasyFlow 送簽","簽核狀況" Action
# Modify.........: No.FUN-780070 07/08/27 By Echo wsk_file 調整 index :增加 wsk05(TIPTOP 表單單號) 
# Modify.........: No.FUN-780049 07/09/26 By Echo 若回傳不完整的XML格式字串或錯誤訊息時，則直接顯示對方回傳的資料
# Modify.........: No.TQC-7B0029 07/11/06 By Echo 調整 wsk_file 存取方式, 增加 SourceFormNum 環境變數
# Modify.........: No.FUN-7C0003 07/12/03 By Echo 「簽核表單」頁面，填表人、表單關係人欄位要顯示員工代號+員工姓名
# Modify.........: No.FUN-7C0055 07/12/19 By Echo 調整 timeout 訊息
# Modify.........: No.FUN-7C0094 07/12/26 By Echo 簽核完，取得下一筆資料時，呼叫 EasyFlow 取得資料時，不限制15筆.
# Modify.........: No.TQC-860022 08/06/10 By Echo 調整程式遺漏 ON IDLE 程式段
# Modify.........: No.FUN-880046 08/08/12 by Echo Genero 2.11 調整
# Modify.........: No.FUN-940047 09/04/10 By Vicky 調整 aws_efapp_wsk() 抓不到 wsk05 時就離開程式
# Modify.........: No.FUN-960137 09/06/18 By Vicky Request字串增加TIPTOP主機資訊 (多TP 對 一EF GP)
#                                            Echo  抓取ef人員資料有 & 符號問題
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:FUN-A30047 10/03/11 by Echo GP5.2 控制簽核action的顯示
# Modify.........: No:CHI-A50019 10/05/14 By sabrina 在呼叫aws_efstat2_approveLog前先sleep 5秒。
# Modify.........: No:FUN-880099 10/08/24 By Jay 整合EasyFlow GP 簽核功能
# Modify.........: No:FUN-A80087 10/08/31 By Lilan 新增取得環境變數的FUNCTION(EFLogonID)
# Modify.........: No:FUN-960057 10/09/15 By Jay aws_efstat2_approveLog()增加傳遞程式代號
# Modify.........: No:TQC-A50153 10/12/31 By Jay 改善EFGP簽核完畢後讀取下一張表單的處理速度
# Modify.........: NO:TQC-9A0191 11/04/07 By Jenjwu 修正加簽人員名單中，xml內容包含&符號便無法執行之錯誤
# Modify.........: No:FUN-B30003 11/04/11 By Jay TIPTOP 與 CROSS 整合功能: 透過 CROSS 平台串接 EasyFlow  
# Modify.........: No:TQC-B60311 11/07/06 By tsai_yen Genero 2.32.03 調整
# Modify.........: No:FUN-B80064 11/08/05 By Lujh 模組程序撰寫規範修正
# Modify.........: No:CHI-BC0010 11/12/20 By ka0132 調整維護單頭,單身欄位功能

IMPORT com   #FUN-720042

IMPORT os   #No.FUN-9C0009  
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/awsef.4gl"
GLOBALS "../4gl/aws_efgw.inc"
GLOBALS "../4gl/aws_efgpgw.inc"         #No.FUN-710010
GLOBALS "../4gl/aws_crossgw.inc"        #No:FUN-B30003

GLOBALS
DEFINE  g_ef_sql              STRING,
        g_ef_sqlcode          LIKE type_file.num5               #No.FUN-680130 SMALLINT

#No:FUN-A30047 -- start --
DEFINE  g_approve_act             DYNAMIC ARRAY OF RECORD
          name                STRING,
          value               LIKE type_file.num5
                              END RECORD
#No:FUN-A30047 -- end --
END GLOBALS
#END FUN-640184
 
 
DEFINE g_efsoap                   STRING           
DEFINE channel                    base.Channel
DEFINE buf                        base.StringBuffer
DEFINE l_status                   LIKE type_file.num10,         #No.FUN-680130 INTEGER
       l_Result                   STRING
DEFINE dom_doc                    om.DomDocument
DEFINE n,n_record                 om.DomNode
DEFINE nl_record                  om.NodeList
DEFINE g_cnt                      LIKE type_file.num10,         #No.FUN-680130 INTEGER
       g_sql                      STRING
DEFINE g_wse                      RECORD LIKE wse_file.*,
       g_wsf                      RECORD LIKE wsf_file.*,
#      g_wsk                      RECORD LIKE wsk_file.*
       g_wsk   RECORD
              wsk01              LIKE wsk_file.wsk01,           #No.FUN-680130 VARCHAR(20)
              wsk02              LIKE wsk_file.wsk02,   
              wsk03              LIKE wsk_file.wsk03,           #No.FUN-680130 VARCHAR(10) 
              wsk04              LIKE wsk_file.wsk04,           #No.FUN-680130 VARCHAR(5)           
              wsk05              LIKE wsk_file.wsk05,           #No.FUN-680130 VARCHAR(80)
              wsk06              LIKE wsk_file.wsk06,           #No.FUN-680130 VARCHAR(10)            
              wsk07              LIKE wsk_file.wsk07,           #No.FUN-680130 VARCHAR(10)            
              wsk08              LIKE wsk_file.wsk08,           #No.FUN-680130 VARCHAR(20)          
              wsk09              LIKE wsk_file.wsk09,           #No.FUN-680130 VARCHAR(10)
              wsk10              LIKE wsk_file.wsk10,           #No.FUN-680130 VARCHAR(04)
              wsk11              LIKE wsk_file.wsk11,           #No.FUN-680130 VARCHAR(04)
              wsk12              LIKE wsk_file.wsk12,           #No.FUN-680130 VARCHAR(04)
              wsk13              LIKE wsk_file.wsk13,           #No.FUN-680130 VARCHAR(04)
              wsk14              LIKE wsk_file.wsk14,           #No.FUN-680130 VARCHAR(10)
              wsk15              LIKE wsk_file.wsk15,           #No.FUN-680130 VARCHAR(10)
              wsk16              LIKE wsk_file.wsk16            #No.FUN-880099 VARCHAR(40)
              END RECORD                     
DEFINE g_form  RECORD             
               SourceFormID       LIKE wsk_file.wsk04,          #No.FUN-680130 VARCHAR(5) 
               SourceFormNum      LIKE wsk_file.wsk05,          #No.FUN-680130 VARCHAR(100)
               FormCreatorID      STRING,
               FormOwnerID        STRING,
               TargetFormID       STRING,
               TargetSheetNo      STRING,
               TargetWorkItemOID  STRING,                       #FUN-880099
               LastStage          LIKE type_file.chr1,          #No.FUN-680130 VARCHAR(1)
               FlowNo             STRING,
               BranchNo           STRING,
               SerialNo           STRING,
               SignNum            STRING,
               Agree              LIKE type_file.chr1,          #No.FUN-680130 VARCHAR(1)
               Deny               LIKE type_file.chr1,          #No.FUN-680130 VARCHAR(1)
               Withdraw           LIKE type_file.chr1,          #No.FUN-680130 VARCHAR(1)
               ModifyFlow         LIKE type_file.chr1,          #No.FUN-680130 VARCHAR(1)
               Origin             LIKE type_file.chr1,          #No.FUN-680130 VARCHAR(1)
               Action             STRING,
               ActionCondition    STRING,
               ActionCondition2   STRING,
               Date               STRING,
               Time               STRING,
               Status             STRING,
               Description        STRING
               END RECORD     
 
DEFINE         g_flowuser         LIKE type_file.num5    #No.FUN-680130 SMALLINT
DEFINE         g_phrase           LIKE type_file.chr1000      #簽核意見  #No.FUN-680130 VARCHAR(255)
DEFINE         g_wap              RECORD LIKE wap_file.*      #No:FUN-B30003

FUNCTION aws_efapp_formID()
    DEFINE formdesc     LIKE type_file.chr1000                           #No.FUN-680130 VARCHAR(100)
    DEFINE formid       LIKE type_file.chr1000                           #No.FUN-680130 VARCHAR(100)
    DEFINE l_file       STRING,
           l_cmd        STRING,
           lch_cmd      base.Channel,
           l_pid        STRING,
           l_i          LIKE type_file.num10,                            #No.FUN-680130 INTEGER
           l_str        STRING
    DEFINE lcbo_target ui.ComboBox
    DEFINE l_cross_status        LIKE type_file.num5    #No.FUN-B30003
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    CALL aws_efapp_XMLHeader("GetTTFormID")
  
    LET g_strXMLInput =  g_strXMLInput CLIPPED,
        "           <PlantID>",g_plant CLIPPED,"</PlantID>", ASCII 10
 
    CALL aws_efapp_XMLTrailer()
 
    ###轉換 & 為 &amp; 
    #FUN-710063
    #LET buf = base.StringBuffer.create()
    #CALL buf.append(g_strXMLInput)
    #CALL buf.replace( "&","&amp;", 0)
    #LET g_strXMLInput = buf.toString()
    LET g_strXMLInput = aws_xml_replace(g_strXMLInput)
    #END FUN-710063
 
    #LET EFGateWay_soapServerLocation = g_efsoap  #指定 Soap server location

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
       CALL aws_cross_invokeSrv(l_str,"GetTTFormID","sync",g_strXMLInput) 
            RETURNING l_cross_status, l_status, l_Result
       IF NOT l_cross_status  THEN
          RETURN 0
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
 
    CALL aws_efapp_file(l_status) #紀錄傳入 EasyFlow 的字串  #TQC-750259
    
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
             LET l_str = "XML parser error:\n\n", l_str
          ELSE
             LET l_str = "XML parser error: ", l_str
          END IF
          #END FUN-780049
          CALL cl_err(l_str, '!', 1)   #XML 字串有問題
          RETURN 0
       END IF
 
       LET l_file = FGL_GETPID() USING '<<<<<<<<<<'
       LET l_file = "aws_efapp_formID_",l_file CLIPPED,".xml"
 
       LET buf = base.StringBuffer.create()
       CALL buf.append(l_Result)
       CALL buf.replace( "&amp;", "&", 0)
       LET l_Result = buf.toString()
       LET channel = base.Channel.create()
       CALL channel.openFile(l_file, "w")
       CALL channel.setDelimiter("")               #FUN-880046
       CALL channel.write(l_Result)
       CALL channel.close()
#      LET l_cmd = "chmod 777 ",l_file CLIPPED," 2>/dev/null"  #No.FUN-9C0009
#      RUN l_cmd                                          #No.FUN-9C0009
       IF os.Path.chrwx(l_file CLIPPED,511) THEN END IF   #No.FUN-9C0009
 
       LET dom_doc = om.DomDocument.createFromXmlFile(l_file)
       LET n = dom_doc.getDocumentElement()
       LET nl_record = n.selectByTagName("Record")
       LET g_cnt = nl_record.getLength()
       #FUN-880099 --start
       #LET lcbo_target = ui.ComboBox.forName("strfilter")  mark
       IF g_aza.aza72 = 'N' THEN 
          LET lcbo_target = ui.ComboBox.forName("strfilter")
       ELSE
             LET lcbo_target = ui.ComboBox.forName("strfilter_gp") 
       END IF 
       #FUN-880099 --end
       FOR l_i = 1 to g_cnt
           LET n_record = nl_record.item(l_i)
           IF g_aza.aza72 = 'N' THEN      #FUN-880099
              LET formid = n_record.getAttribute("targetFormID")
              LET formdesc = formid CLIPPED,":",n_record.getAttribute("formDesc")
              CALL lcbo_target.addItem(formid CLIPPED, formdesc CLIPPED) #TQC-5B0218
           #FUN-880099 --start
           ELSE                 
                 LET formid = n_record.getAttribute("targetProgramID")
              LET formdesc = formid CLIPPED,":",n_record.getAttribute("targetProcessName")
              CALL lcbo_target.addItem(formid CLIPPED, formdesc CLIPPED)
           END IF 
           #FUN-880099 --end
       END FOR
  
       LET l_cmd = "rm ",l_file CLIPPED," 2>/dev/null"      #FUN-570230
       RUN l_cmd
       RETURN 1
 
    ELSE
       IF fgl_getenv('FGLGUI') = '1' THEN
          LET l_str = "Connection failed:\n\n", 
                   "  [Code]: ", wserror.code, "\n",
                   "  [Action]: ", wserror.action, "\n",
                   "  [Description]: ", wserror.description
       ELSE
          LET l_str = "Connection failed: ", wserror.description
       END IF
       CALL cl_err(l_str, '!', 1)   #連接失敗
       LET l_status = 0
       RETURN 0
    END IF
END FUNCTION
 
FUNCTION aws_efapp_formInfo(p_ef,p_forminfo,p_intfilter,p_strfilter,p_curr_page,p_page_size)    #FUN-7C0094
DEFINE  p_ef DYNAMIC ARRAY OF RECORD
            ef01     LIKE wsk_file.wsk04, #TIPTOP 單別
            ef02     LIKE wsk_file.wsk05, #TIPTOP 單號           #FUN-590076
            ef03     LIKE wsk_file.wsk03, #TIPTOP 程式代號
            ef04     LIKE wsk_file.wsk08, #EasyFlow 單別
            ef05     LIKE type_file.chr1, #重要性 #No.FUN-680130 VARCHAR(1)
            ef06     LIKE type_file.chr4, #簽核結果#No.FUN-680130 VARCHAR(4)
            ef07     LIKE type_file.chr4, #簽核狀態#No.FUN-680130 VARCHAR(4)
            ef08     STRING,              #填表人  #No.FUN-680130 VARCHAR(10) #FUN-7C0003
            ef09     STRING,              #關係人  #No.FUN-680130 VARCHAR(10) #FUN-7C0003
            ef10     STRING,              #表單簡稱
            ef11     LIKE wsk_file.wsk09, #EasyFlow 表單單號
            ef12     STRING,              #主旨
            ef13     STRING,              #收件日期時間
            ef14     STRING,              #表單來源
            ef15     LIKE wsk_file.wsk10, #關號
            ef16     LIKE wsk_file.wsk11, #支號
            ef17     LIKE wsk_file.wsk12, #流水號
            ef18     LIKE wsk_file.wsk13  #簽核序號
        END RECORD
DEFINE l_items      STRING,
       lch_cmd      base.Channel,
       l_file       STRING,              
       l_pid        STRING,
       l_cmd        STRING,
       l_i          LIKE type_file.num10,                                #No.FUN-680130 INTEGER
       l_str        STRING
 
DEFINE  p_forminfo        LIKE type_file.chr1000,                        #No.FUN-680130 VARCHAR(50)
        p_strfilter       LIKE type_file.chr1000,                        #No.FUN-680130 VARCHAR(50)
        p_intfilter       LIKE type_file.chr1000,                        #No.FUN-680130 VARCHAR(50)
        p_curr_page       LIKE type_file.num10,  # Current Page Number   #No.FUN-680130 INTEGER
        p_total_page      LIKE type_file.num10,                          #No.FUN-680130 INTEGER
        p_page_size       LIKE type_file.num10   # Page Size             #FUN-7C0094
DEFINE  l_cross_status    LIKE type_file.num5                            #No.FUN-B30003
 
    WHENEVER ERROR CALL cl_err_msg_log
    
    CALL aws_efapp_XMLHeader("GetFormInfo")
 
    LET g_strXMLInput =  g_strXMLInput CLIPPED,
        "           <PlantID>",g_plant CLIPPED,"</PlantID>", ASCII 10,
        "           <TargetFormKind>Form_",p_forminfo CLIPPED,"</TargetFormKind>", ASCII 10,
        "           <TargetFormID>",p_strfilter CLIPPED,"</TargetFormID>", ASCII 10,
        "           <TargetSign>",p_intfilter CLIPPED,"</TargetSign>", ASCII 10,
        "           <TargetCurrentPage>",p_curr_page USING '<<<<<<<<<<',"</TargetCurrentPage>", ASCII 10,
       #"           <TargetPageSize>15</TargetPageSize>", ASCII 10  #預設15筆
        "           <TargetPageSize>",p_page_size USING '<<<<<<<<<<',"</TargetPageSize>", ASCII 10  #FUN-7C0094
 
      
    CALL aws_efapp_XMLTrailer()
 
    ###轉換 & 為 &amp; 
    #FUN-710063
    #LET buf = base.StringBuffer.create()
    #CALL buf.append(g_strXMLInput)
    #CALL buf.replace( "&","&amp;", 0)
    #LET g_strXMLInput = buf.toString()
    LET g_strXMLInput = aws_xml_replace(g_strXMLInput)
    #END FUN-710063
 
    #LET EFGateWay_soapServerLocation = g_efsoap  #指定 Soap server location

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
       CALL aws_cross_invokeSrv(l_str,"GetFormInfo","sync",g_strXMLInput) 
            RETURNING l_cross_status, l_status, l_Result
       IF NOT l_cross_status  THEN
          LET p_curr_page = 1
          LET p_total_page = 1
          RETURN 0,p_curr_page,p_total_page
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
    
    CALL aws_efapp_file(l_status) #紀錄傳入 EasyFlow 的字串  #TQC-750259
  
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
             LET l_str = "XML parser error:\n\n", l_str
          ELSE
             LET l_str = "XML parser error: ", l_str
          END IF
          #END FUN-780049
          CALL cl_err(l_str, '!', 1)   #XML 字串有問題
          LET p_curr_page = 1
          LET p_total_page = 1
          RETURN 0,p_curr_page,p_total_page
       END IF
 
       LET l_file = FGL_GETPID() USING '<<<<<<<<<<'
       LET l_file = "aws_efapp_formID_",l_file CLIPPED,".xml"
 
       LET buf = base.StringBuffer.create()
       CALL buf.append(l_Result)
       CALL buf.replace( "&amp;", "&", 0)
       LET l_Result = buf.toString()
       LET channel = base.Channel.create()
       CALL channel.openFile(l_file, "w")
       CALL channel.setDelimiter("")               #FUN-880046
       CALL channel.write(l_Result)
       CALL channel.close()
#      LET l_cmd = "chmod 777 ",l_file CLIPPED," 2>/dev/null" #No.FUN-9C0009 
#      RUN l_cmd                                          #No.FUN-9C0009  
       IF os.Path.chrwx(l_file CLIPPED,511) THEN END IF   #No.FUN-9C0009   
 
       LET l_items = "All"
       LET dom_doc = om.DomDocument.createFromXmlFile(l_file)
       LET n = dom_doc.getDocumentElement()
       LET nl_record = n.selectByTagName("Record")
       LET g_cnt = nl_record.getLength()
       FOR l_i = 1 to g_cnt
           LET n_record = nl_record.item(l_i)
           LET p_ef[l_i].ef01 = n_record.getAttribute("sourceFormID")
           LET p_ef[l_i].ef02 = n_record.getAttribute("sourceFormNum")
           LET p_ef[l_i].ef03 = n_record.getAttribute("programID")
           LET p_ef[l_i].ef04 = n_record.getAttribute("targetFormID")
           LET p_ef[l_i].ef05 = n_record.getAttribute("importance")
           LET p_ef[l_i].ef06 = n_record.getAttribute("signResult")
           LET p_ef[l_i].ef07 = n_record.getAttribute("signStatus")
           LET p_ef[l_i].ef08 = n_record.getAttribute("formCreatorID")
           LET p_ef[l_i].ef09 = n_record.getAttribute("formOwnerID")
           LET p_ef[l_i].ef10 = n_record.getAttribute("formDesc")
           LET p_ef[l_i].ef11 = n_record.getAttribute("targetSheetNo")
           LET p_ef[l_i].ef12 = n_record.getAttribute("subject")
           LET p_ef[l_i].ef13 = n_record.getAttribute("receiverTime")
           LET p_ef[l_i].ef14 = n_record.getAttribute("source")
           LET p_ef[l_i].ef15 = n_record.getAttribute("flowno")
           LET p_ef[l_i].ef16 = n_record.getAttribute("branchno")
           LET p_ef[l_i].ef17 = n_record.getAttribute("serialno")
           LET p_ef[l_i].ef18 = n_record.getAttribute("signNum")
 
           LET p_ef[l_i].ef08 = aws_efapp_name(p_ef[l_i].ef08) #FUN-7C0003 
           LET p_ef[l_i].ef09 = aws_efapp_name(p_ef[l_i].ef09) #FUN-7C0003 
       END FOR
 
       LET l_cmd = "rm ",l_file CLIPPED," 2>/dev/null"      #FUN-570230
       RUN l_cmd
       LET p_curr_page = aws_xml_getTag(l_Result, "TargetCurrentPage")
       LET p_total_page = aws_xml_getTag(l_Result, "TargetTotalPage")
       IF p_total_page = 0 THEN
            LET p_curr_page = 1
            LET p_total_page = 1
       END IF
       RETURN 1,p_curr_page,p_total_page
 
    ELSE
       IF fgl_getenv('FGLGUI') = '1' THEN
          LET l_str = "Connection failed:\n\n", 
                   "  [Code]: ", wserror.code, "\n",
                   "  [Action]: ", wserror.action, "\n",
                   "  [Description]: ", wserror.description
       ELSE
          LET l_str = "Connection failed: ", wserror.description
       END IF
       CALL cl_err(l_str, '!', 1)   #連接失敗
       LET p_curr_page = 1
       LET p_total_page = 1
       RETURN 0,p_curr_page,p_total_page
    END IF
 
END FUNCTION
 
FUNCTION aws_efapp_flowaction(p_actions)
    DEFINE p_actions    STRING
    DEFINE l_items      STRING,
           lch_cmd      base.Channel,
           l_file       STRING,              
           l_pid        STRING,
           l_cmd        STRING,
           l_i          LIKE type_file.num10,  #No.FUN-680130 INTEGER
           l_str        STRING
    DEFINE formdesc     LIKE type_file.chr1000 #No.FUN-680130 VARCHAR(100) 
    DEFINE formid       LIKE type_file.chr1000 #No.FUN-680130 VARCHAR(100)
    DEFINE l_window     ui.Window
    DEFINE lnode_item   om.DomNode
    DEFINE l_ze03       LIKE ze_file.ze03              #FUN-6B0024
    DEFINE l_cnt        LIKE type_file.num10           #FUN-770022
    DEFINE l_cross_status   LIKE type_file.num5        #No.FUN-B30003
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    CALL g_approve_act.clear()             #TQC-B60311
    SELECT COUNT(*) INTO l_cnt FROM wsd_file WHERE wsd01 = g_prog  #FUN-770022
    #FUN-640181---start---
    IF g_aza.aza23 matches '[ Nn]' OR l_cnt = 0 THEN               #FUN-770022
       CALL cl_set_act_visible("easyflow_approval,approval_status",FALSE)
       CALL aws_efapp_act_status("easyflow_approval,approval_status",FALSE)   #TQC-B60311
    END IF
    #FUN-640181---end---
 
    #EasyFlow 簽核 action 隱藏(依觸發的資料匣)
    #MOD-6B0020
    #CALL cl_set_act_visible("agree, deny, modify_flow, withdraw, org_withdraw, phrase", TRUE)
    CALL cl_set_act_visible("agree, deny, modify_flow, withdraw, org_withdraw, phrase", FALSE)
    CALL aws_efapp_act_status("agree, deny, modify_flow, withdraw, org_withdraw, phrase", FALSE)   #TQC-B60311
    CASE g_wsk.wsk14 CLIPPED
         WHEN "Info"
    #          CALL cl_set_act_visible("agree, deny, modify_flow, withdraw, org_withdraw, phrase", FALSE)
         WHEN "Sent"
         #FUN-880099 --start
              IF g_aza.aza72 = "Y" THEN                         
                 CALL cl_set_act_visible(p_actions, FALSE)
                 CALL aws_efapp_act_status(p_actions, FALSE)   #TQC-B60311
                 CALL cl_set_act_visible("org_withdraw", TRUE)  #EFGP 抽單
                 CALL aws_efapp_act_status("org_withdraw", TRUE)   #TQC-B60311
                 RETURN ''
              END IF
              
         WHEN "Withdraw"
         
         #FUN-880099 --end
    #          CALL cl_set_act_visible("agree, deny, modify_flow, withdraw, phrase", FALSE)  
         WHEN "Inbox"
    #          CALL cl_set_act_visible("org_withdraw", FALSE)
         OTHERWISE
    #         CALL cl_set_act_visible("agree, deny, modify_flow, withdraw, org_withdraw, phrase", FALSE)
              RETURN ''
    END CASE
    #END MOD-6B0020
 
    #隱藏原程式在進行簽核時不該出現的 action
    CALL cl_set_act_visible(p_actions, FALSE)
    CALL aws_efapp_act_status(p_actions, FALSE)   #TQC-B60311
    
    CALL aws_efapp_XMLHeader("GetFlowAction")
 
    LET g_strXMLInput =  g_strXMLInput CLIPPED,
        "           <PlantID>",g_plant CLIPPED,"</PlantID>", ASCII 10,
        "           <ProgramID>",g_prog CLIPPED,"</ProgramID>", ASCII 10,
        "           <SourceFormID>",g_form.SourceFormID CLIPPED,"</SourceFormID>", ASCII 10,
        "           <SourceFormNum>",g_form.SourceFormNum CLIPPED,"</SourceFormNum>", ASCII 10,
        "           <FormCreatorID>",g_form.FormCreatorID CLIPPED,"</FormCreatorID>", ASCII 10,
        "           <FormOwnerID>",g_form.FormOwnerID CLIPPED,"</FormOwnerID>", ASCII 10,
        "           <TargetFormID>",g_form.TargetFormID CLIPPED,"</TargetFormID>", ASCII 10,
        "           <TargetSheetNo>",g_form.TargetSheetNo CLIPPED,"</TargetSheetNo>", ASCII 10
    IF g_aza.aza72 MATCHES '[Nn]' THEN                    #FUN-880099     
       LET g_strXMLInput =  g_strXMLInput CLIPPED,        #FUN-880099 
           "        <FlowNo>",g_form.FlowNo CLIPPED,"</FlowNo>", ASCII 10,
           "        <BranchNo>",g_form.BranchNo CLIPPED,"</BranchNo>", ASCII 10,
           "        <SerialNo>",g_form.SerialNo CLIPPED,"</SerialNo>", ASCII 10,
           "        <SignNum>",g_form.SignNum CLIPPED,"</SignNum>", ASCII 10,
           "        <SelectedFolder>Form_",g_wsk.wsk14 CLIPPED,"</SelectedFolder>",ASCII 10
    #FUN-880099 --start
    ELSE
       LET g_strXMLInput =  g_strXMLInput CLIPPED,
           "        <TargetWorkItemOID>",g_form.TargetWorkItemOID CLIPPED,"</TargetWorkItemOID>", ASCII 10
    END IF
    #FUN-880099 --end
    CALL aws_efapp_XMLTrailer()
 
    ###轉換 & 為 &amp; 
    #FUN-710063
    #LET buf = base.StringBuffer.create()
    #CALL buf.append(g_strXMLInput)
    #CALL buf.replace( "&","&amp;", 0)
    #LET g_strXMLInput = buf.toString()
    LET g_strXMLInput = aws_xml_replace(g_strXMLInput)
    #END FUN-710063
 
    #LET EFGateWay_soapServerLocation = g_efsoap  #指定 Soap server location
    
    #No.FUN-710010 --start--
    IF g_aza.aza72 = 'N' THEN 
        LET EFGateWay_soapServerLocation = g_efsoap  #指定 Soap server location
    ELSE #指定EasyFlowGP的SOAP網址
        LET EFGPGateWay_soapServerLocation = g_efsoap  #指定 Soap server location
    END IF
    #No.FUN-710010 --end--
    
    #FUN-6B0024
    FOR l_i = 1 TO 4
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
           CALL aws_cross_invokeSrv(l_str,"GetFlowAction","sync",g_strXMLInput) 
                RETURNING l_cross_status, l_status, l_Result
           IF NOT l_cross_status  THEN  
              RETURN ''
           END IF
        ELSE
        #No:FUN-B30003 -- end --
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
        
       #IF NOT (l_status = 1 AND wsError.description= "Timeout reached.")
        IF NOT (l_status !=0 AND wsError.description= "TCP Connection reached timeout.")  #FUN-7C0055
           OR (l_i = 4)
        THEN
             EXIT FOR
        ELSE
           SELECT ze03 INTO l_ze03 FROM ze_file
                WHERE ze01 = 'aws-094' AND ze02 = g_lang
           LET l_str = cl_replace_err_msg(l_ze03,l_i)
           MENU "Exclamation" ATTRIBUTE(STYLE="dialog", COMMENT=l_str CLIPPED, IMAGE="exclamation")
             ON ACTION accept
                EXIT MENU
             ON ACTION cancel
                LET INT_FLAG = 1
                EXIT MENU
             ON IDLE 5
                EXIT MENU
           END MENU
           IF INT_FLAG THEN
                 LET INT_FLAG = 0
                 EXIT FOR
           END IF
           CALL ui.interface.refresh()
           SLEEP 5
        END IF
    END FOR
    #END FUN-6B0024
    
    CALL aws_efapp_file(l_status) #紀錄傳入 EasyFlow 的字串  #TQC-750259
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
             LET l_str = "XML parser error:\n\n", l_str
          ELSE
             LET l_str = "XML parser error: ", l_str
          END IF
          #END FUN-780049
          CALL cl_err(l_str, '!', 1)   #XML 字串有問題
          RETURN ''
       END IF
 
       LET g_form.TargetFormID = aws_xml_getTag(l_Result, "TargetFormID")
       LET g_form.TargetSheetNo = aws_xml_getTag(l_Result, "TargetSheetNo")
       LET g_form.LastStage = aws_xml_getTag(l_Result, "LastStage")
       LET g_form.FlowNo = aws_xml_getTag(l_Result, "FlowNo")
       LET g_form.BranchNo = aws_xml_getTag(l_Result, "BranchNo")
       LET g_form.SerialNo = aws_xml_getTag(l_Result,  "SerialNo")
       LET g_form.Agree = aws_xml_getTag(l_Result,  "Agree")
       LET g_form.Deny = aws_xml_getTag(l_Result,  "Deny")
       LET g_form.Withdraw = aws_xml_getTag(l_Result,  "Withdraw")
       LET g_form.ModifyFlow = aws_xml_getTag(l_Result,  "ModifyFlow")
       LET g_form.Origin = aws_xml_getTag(l_Result,  "OriginatorWithdraw")

       #FUN-880099 --start
       IF g_aza.aza72 = "Y" THEN
             LET g_form.FlowNo = aws_xml_getTag(l_Result, "ActivityId")          
       END IF
       #FUN-880099 --end
 
       #MOD-6B0020
       #No:FUN-A30047 -- start --
       #CALL g_approve_act.clear()             #TQC-B60311 mark
       CASE                                    #FUN-880099 
       WHEN g_wsk.wsk14 = "Sent"               #FUN-880099
            IF g_form.Origin = "Y" THEN
                 CALL cl_set_act_visible("org_withdraw", TRUE)
                 CALL aws_efapp_act_status("org_withdraw", TRUE)
            END IF
       WHEN g_wsk.wsk14 = "Inbox"              #FUN-880099
               IF g_form.Agree = "Y"  THEN
                    CALL cl_set_act_visible("agree", TRUE)
                    CALL aws_efapp_act_status("agree", TRUE)
               END IF
               IF g_form.Deny = "Y"  THEN
                    CALL cl_set_act_visible("deny", TRUE)
                    CALL aws_efapp_act_status("deny", TRUE)
               END IF

               #FUN-880099 --start
               #IF g_form.Withdraw = "Y" THEN
               #     CALL cl_set_act_visible("withdraw", TRUE)
               #     CALL aws_efapp_act_status("withdraw", TRUE)
               #END IF
               IF g_aza.aza72 = "Y" THEN
                    CALL cl_set_act_visible("withdraw", FALSE)
                    CALL aws_efapp_act_status("withdraw", FALSE)   #TQC-B60311
               ELSE
                  IF g_form.Withdraw = "Y" THEN
                     CALL cl_set_act_visible("withdraw", TRUE)
                     CALL aws_efapp_act_status("withdraw", TRUE)
                  END IF
               END IF
               #FUN-880099 --end

               IF g_form.ModifyFlow = "Y" THEN
                    CALL cl_set_act_visible("modify_flow", TRUE)
                    CALL aws_efapp_act_status("modify_flow", TRUE)
               END IF

               #皆不同意時隱藏「簽核意見」
               IF g_form.Agree = "Y" OR  g_form.Deny = "Y" OR
                  g_form.Withdraw = "Y" OR g_form.ModifyFlow = "Y"
               THEN
                    CALL cl_set_act_visible("phrase", TRUE)
                    CALL aws_efapp_act_status("phrase", TRUE)
               END IF
       
       #FUN-880099 --start
       WHEN  g_wsk.wsk14 = "Withdraw"
             #CALL cl_set_act_visible("agree", FALSE)     #TQC-B60311 mark
             #CALL cl_set_act_visible("deny", FALSE)      #TQC-B60311 mark
             #CALL cl_set_act_visible("phrase", FALSE)    #TQC-B60311 mark
             CALL cl_set_act_visible("agree,deny,phrase,withdraw", FALSE)  #TQC-B60311
             CALL aws_efapp_act_status("agree,deny,phrase,withdraw", FALSE)   #TQC-B60311
             CALL cl_set_act_visible("withdraw", TRUE)
             CALL aws_efapp_act_status("withdraw", TRUE)
       END CASE
       #FUN-880099 --end

       #No:FUN-A30047 -- end --
       #END MOD-6B0020
 
       RETURN g_form.LastStage
 
    ELSE
       IF fgl_getenv('FGLGUI') = '1' THEN
          LET l_str = "Connection failed:\n\n", 
                   "  [Code]: ", wserror.code, "\n",
                   "  [Action]: ", wserror.action, "\n",
                   "  [Description]: ", wserror.description
       ELSE
          LET l_str = "Connection failed: ", wserror.description
       END IF
       CALL cl_err(l_str, '!', 1)   #連接失敗
       RETURN ''
    END IF
END FUNCTION
 
FUNCTION aws_efapp_backflow()
    DEFINE lch_cmd             base.Channel,
           l_pid               STRING,
           l_i                 LIKE type_file.num10,  #No.FUN-680130 INTEGER
           l_str               STRING
    DEFINE formdesc            LIKE type_file.chr1000 #No.FUN-680130 VARCHAR(100)
    DEFINE formid              LIKE type_file.chr1000 #No.FUN-680130 VARCHAR(100)
    DEFINE l_file              STRING,
           l_cmd               STRING
 
    DEFINE l_back DYNAMIC ARRAY OF RECORD
                   flowNo        STRING,
                   BranchNo      STRING,
                   routingRole   STRING
                  END RECORD,
           l_flowNo        STRING,
           l_BranchNo      STRING,
           l_routingRole   STRING
    DEFINE l_ze03              LIKE ze_file.ze03      #FUN-880099 
    DEFINE l_cross_status      LIKE type_file.num5    #No.FUN-B30003
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    CALL aws_efapp_XMLHeader("GetBackFlow")

    #FUN-880099 --start
    IF g_aza.aza72="Y"  THEN            #需要輸入簽核意見
       IF cl_null(g_phrase) THEN        
          CALL cl_err('','aws-523',1)                
          RETURN ""
       END IF   
    END IF     
    #FUN-880099 --end
  
    LET g_strXMLInput =  g_strXMLInput CLIPPED,
        "           <PlantID>",g_plant CLIPPED,"</PlantID>", ASCII 10,
        "           <ProgramID>",g_prog CLIPPED,"</ProgramID>", ASCII 10,
        "           <SourceFormID>",g_form.SourceFormID CLIPPED,"</SourceFormID>", ASCII 10,
        "           <SourceFormNum>",g_form.SourceFormNum CLIPPED,"</SourceFormNum>", ASCII 10,
        "           <FormCreatorID>",g_form.FormCreatorID CLIPPED,"</FormCreatorID>", ASCII 10,
        "           <FormOwnerID>",g_form.FormOwnerID CLIPPED,"</FormOwnerID>", ASCII 10,
        "           <TargetFormID>",g_form.TargetFormID CLIPPED,"</TargetFormID>", ASCII 10,
        "           <TargetSheetNo>",g_form.TargetSheetNo CLIPPED,"</TargetSheetNo>", ASCII 10
    IF g_aza.aza72 MATCHES '[Nn]' THEN                  #FUN-880099
       LET g_strXMLInput =  g_strXMLInput CLIPPED,      #FUN-880099
           "        <FlowNo>",g_form.FlowNo CLIPPED,"</FlowNo>", ASCII 10,
           "        <BranchNo>",g_form.BranchNo CLIPPED,"</BranchNo>", ASCII 10,
           "        <SerialNo>",g_form.SerialNo CLIPPED,"</SerialNo>", ASCII 10,
           "        <SignNum>",g_form.SignNum CLIPPED,"</SignNum>", ASCII 10
    #FUN-880099 --start
    ELSE
       LET g_strXMLInput =  g_strXMLInput CLIPPED,
           "        <TargetWorkItemOID>",g_form.TargetWorkItemOID CLIPPED,"</TargetWorkItemOID>", ASCII 10
    END IF 
    #FUN-880099 --end
 
    CALL aws_efapp_XMLTrailer()
 
    ###轉換 & 為 &amp; 
    #FUN-710063
    #LET buf = base.StringBuffer.create()
    #CALL buf.append(g_strXMLInput)
    #CALL buf.replace( "&","&amp;", 0)
    #LET g_strXMLInput = buf.toString()
    LET g_strXMLInput = aws_xml_replace(g_strXMLInput)
    #END FUN-710063
 
    #LET EFGateWay_soapServerLocation = g_efsoap  #指定 Soap server location

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
       CALL aws_cross_invokeSrv(l_str,"GetBackFlow","sync",g_strXMLInput) 
            RETURNING l_cross_status, l_status, l_Result
       IF NOT l_cross_status  THEN
          RETURN ""
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
    
    CALL aws_efapp_file(l_status) #紀錄傳入 EasyFlow 的字串  #TQC-750259
    
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
             LET l_str = "XML parser error:\n\n", l_str
          ELSE
             LET l_str = "XML parser error: ", l_str
          END IF
          #END FUN-780049
          CALL cl_err(l_str, '!', 1)   #XML 字串有問題
          RETURN ""
       END IF
 
       LET l_file = FGL_GETPID() USING '<<<<<<<<<<'
       LET l_file = "aws_efapp_formID_",l_file CLIPPED,".xml"
 
       LET buf = base.StringBuffer.create()
       CALL buf.append(l_Result)
       CALL buf.replace( "&amp;", "&", 0)
       LET l_Result = buf.toString()
       LET channel = base.Channel.create()
       CALL channel.openFile(l_file, "w")
       CALL channel.setDelimiter("")               #FUN-880046
       CALL channel.write(l_Result)
       CALL channel.close()
#      LET l_cmd = "chmod 777 ",l_file CLIPPED," 2>/dev/null"  #No.FUN-9C0009
#      RUN l_cmd                                          #No.FUN-9C0009 
       IF os.Path.chrwx(l_file CLIPPED,511) THEN END IF   #No.FUN-9C0009 
 
       LET dom_doc = om.DomDocument.createFromXmlFile(l_file)
       LET n = dom_doc.getDocumentElement()
       LET nl_record = n.selectByTagName("Record")
       LET g_cnt = nl_record.getLength()

       IF g_aza.aza72 MATCHES '[Nn]' THEN                 #FUN-880099 
          FOR l_i = 1 to g_cnt
              LET n_record = nl_record.item(l_i)
              LET l_back[l_i].flowNo  = n_record.getAttribute("flowNo")
              LET l_back[l_i].BranchNo = n_record.getAttribute("BranchNo")
              LET l_back[l_i].routingRole = n_record.getAttribute("routingRole")
          END FOR
       #FUN-880099 --start
       ELSE
             SELECT ze03 INTO l_ze03 FROM ze_file
                WHERE ze01 = 'aws-099' AND ze02 = g_lang
             LET l_back[1].flowNo  = ""            
          LET l_back[1].BranchNo = ""
          LET l_back[1].routingRole = l_ze03                
          
             FOR l_i = 1 to g_cnt
              LET n_record = nl_record.item(l_i)
              LET l_back[l_i+1].flowNo  = n_record.getAttribute("activityId")         #Record 從2開始累加
              LET l_back[l_i+1].BranchNo = n_record.getAttribute("activityIdName")
              LET l_back[l_i+1].routingRole = n_record.getAttribute("routingRole")
          END FOR
          IF g_cnt = 0 THEN
               LET g_cnt = 1        #預設第一筆填表人
          END IF
       END IF 
       #FUN-880099 --end
       
       LET l_cmd = "rm ",l_file CLIPPED," 2>/dev/null"      #FUN-570230
       RUN l_cmd
 
       IF g_cnt > 0 THEN
          CALL q_aws(l_back) RETURNING l_flowNo,l_BranchNo,l_routingRole
          IF cl_null(l_flowNo) AND cl_null(l_BranchNo) AND 
             cl_null(l_routingRole)
          THEN
              RETURN ""
          ELSE
              IF cl_null(l_flowNo) AND cl_null(l_BranchNo)  #填表人
              THEN              
                     LET g_form.ActionCondition = "0000|0000"
                     RETURN "Y"
              ELSE
                     LET g_form.BranchNo = l_flowNo               #FUN-880099  退回關卡
                     LET g_form.ActionCondition = l_flowNo CLIPPED,"|",l_BranchNo
                     RETURN "N"
              END IF
          END IF
       ELSE
          RETURN ""
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
       CALL cl_err(l_str, '!', 1)   #連接失敗
       RETURN ""
    END IF
END FUNCTION
 
FUNCTION aws_efapp_flowuser()
    DEFINE lch_cmd      base.Channel,
           l_pid        STRING,
           l_i          LIKE type_file.num10,  #No.FUN-680130 INTEGER
           l_str        STRING
    DEFINE formdesc     LIKE type_file.chr1000 #No.FUN-680130 VARCHAR(100)
    DEFINE formid       LIKE type_file.chr1000 #No.FUN-680130 VARCHAR(100)
    DEFINE l_file       STRING,
           l_cmd        STRING,
           l_page_size  LIKE type_file.num5    #FUN-880099 
    DEFINE l_user RECORD
              empID      LIKE type_file.chr20,  #No.FUN-680130 VARCHAR(20)
              empName    LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(100)
              depID      LIKE type_file.chr20,  #No.FUN-680130 VARCHAR(20)
              depName    LIKE type_file.chr1000 #No.FUN-680130 VARCHAR(100)
                  END RECORD
    DEFINE l_cross_status   LIKE type_file.num5 #No.FUN-B30003
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF g_flowuser = FALSE THEN
    
       CALL aws_efapp_XMLHeader("GetModifyFlowUser")
       
       LET g_strXMLInput =  g_strXMLInput CLIPPED,
           "           <PlantID>",g_plant CLIPPED,"</PlantID>", ASCII 10,
           "           <ProgramID>",g_prog CLIPPED,"</ProgramID>", ASCII 10,
           "           <SourceFormID>",g_form.SourceFormID CLIPPED,"</SourceFormID>", ASCII 10,
           "           <SourceFormNum>",g_form.SourceFormNum CLIPPED,"</SourceFormNum>", ASCII 10,
           "           <FormCreatorID>",g_form.FormCreatorID CLIPPED,"</FormCreatorID>", ASCII 10,
           "           <FormOwnerID>",g_form.FormOwnerID CLIPPED,"</FormOwnerID>", ASCII 10,
           "           <TargetFormID>",g_form.TargetFormID CLIPPED,"</TargetFormID>", ASCII 10,
           "           <TargetSheetNo>",g_form.TargetSheetNo CLIPPED,"</TargetSheetNo>", ASCII 10
       IF g_aza.aza72 MATCHES '[Nn]' THEN                  #FUN-880099
          LET g_strXMLInput =  g_strXMLInput CLIPPED,      #FUN-880099
              "        <FlowNo>",g_form.FlowNo CLIPPED,"</FlowNo>", ASCII 10,
              "        <BranchNo>",g_form.BranchNo CLIPPED,"</BranchNo>", ASCII 10,
              "        <SerialNo>",g_form.SerialNo CLIPPED,"</SerialNo>", ASCII 10,
              "        <SignNum>",g_form.SignNum CLIPPED,"</SignNum>", ASCII 10
       #FUN-880099 --start
       ELSE
             SELECT aza34 INTO l_page_size FROM aza_file
             
             LET g_strXMLInput =  g_strXMLInput CLIPPED,    
              "        <TargetPageSize>",l_page_size,"</TargetPageSize>", ASCII 10,
              "        <TargetCurrentPage>1</TargetCurrentPage>", ASCII 10
       END IF
       #FUN-880099 --end
       
       CALL aws_efapp_XMLTrailer()
       
       ###轉換 & 為 &amp; 
       #FUN-710063
       #LET buf = base.StringBuffer.create()
       #CALL buf.append(g_strXMLInput)
       #CALL buf.replace( "&","&amp;", 0)
       #LET g_strXMLInput = buf.toString()
       LET g_strXMLInput = aws_xml_replace(g_strXMLInput)
       #END FUN-710063
       
       #LET EFGateWay_soapServerLocation = g_efsoap  #指定 Soap server location

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
          CALL aws_cross_invokeSrv(l_str,"GetModifyFlowUser","sync",g_strXMLInput) 
               RETURNING l_cross_status, l_status, l_Result
          IF NOT l_cross_status  THEN
             RETURN 0
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
       
       CALL aws_efapp_file(l_status) #紀錄傳入 EasyFlow 的字串  #TQC-750259
       
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
                LET l_str = "XML parser error:\n\n", l_str
             ELSE
                LET l_str = "XML parser error: ", l_str
             END IF
             #END FUN-780049
             CALL cl_err(l_str, '!', 1)   #XML 字串有問題
             RETURN 0
          END IF
       
          LET l_file = FGL_GETPID() USING '<<<<<<<<<<'
          LET l_file = "aws_efapp_formID_",l_file CLIPPED,".xml"
          
          #No.FUN-960137  -- start --
          #LET buf = base.StringBuffer.create()
          #CALL buf.append(l_Result)
          #CALL buf.replace( "&amp;", "&", 0)
          #LET l_Result = buf.toString()
          #No.FUN-960137  -- end --

          LET channel = base.Channel.create()
          CALL channel.openFile(l_file, "w")
          CALL channel.setDelimiter("")               #FUN-880046
          CALL channel.write(l_Result)
          CALL channel.close()
#         LET l_cmd = "chmod 777 ",l_file CLIPPED," 2>/dev/null" #No.FUN-9C0009
#         RUN l_cmd                                          #No.FUN-9C0009
          IF os.Path.chrwx(l_file CLIPPED,511) THEN END IF   #No.FUN-9C0009   
          
          DROP TABLE user_tmp
          #FUN-680130  --begin
          CREATE TEMP TABLE user_tmp
             (empID      LIKE type_file.chr20,  
              empName    LIKE type_file.chr1000,
              depID      LIKE type_file.chr20,  
              depName    LIKE type_file.chr1000);
          #FUN-680130  --end
          
          LET dom_doc = om.DomDocument.createFromXmlFile(l_file)
          LET n = dom_doc.getDocumentElement()
          LET nl_record = n.selectByTagName("Record")
          LET g_cnt = nl_record.getLength()
          FOR l_i = 1 to g_cnt
              LET n_record = nl_record.item(l_i)
              LET l_user.empID = n_record.getAttribute("employeeId")    
              LET l_user.empName = n_record.getAttribute("employeeName")  
              LET l_user.depID = n_record.getAttribute("departmentId")
              LET l_user.depName = n_record.getAttribute("departmentName")

              #No.FUN-960137  -- start --
              LET buf = base.StringBuffer.create()
              CALL buf.append(l_user.depName)
              CALL buf.replace( "&amp;", "&", 0)
              LET l_user.depName = buf.toString()
              #No.FUN-960137  -- end --
              
              #TQC-9A0191 -start-
              LET buf = base.StringBuffer.create()
              CALL buf.append(l_user.empName)
              CALL buf.replace( "&amp;", "&", 0)
              LET l_user.empName = buf.toString()
              #TQC-9A0191  -end-    
              
              INSERT INTO user_tmp VALUES(l_user.empID,l_user.empName,l_user.depID,
                                          l_user.depName)
          END FOR
          LET l_cmd = "rm ",l_file CLIPPED," 2>/dev/null"      #FUN-570230
          RUN l_cmd
          IF g_cnt > 0 THEN
               CALL q_aws2(TRUE,TRUE) RETURNING g_form.ActionCondition2
               LET g_flowuser = TRUE 
               IF cl_null(g_form.ActionCondition2) THEN
                    RETURN 0
               END IF 
          ELSE
               RETURN 0
          END IF
          RETURN 1
       ELSE
          IF fgl_getenv('FGLGUI') = '1' THEN
             LET l_str = "Connection failed:\n\n", 
                      "  [Code]: ", wserror.code, "\n",
                      "  [Action]: ", wserror.action, "\n",
                      "  [Description]: ", wserror.description
          ELSE
             LET l_str = "Connection failed: ", wserror.description
          END IF
          CALL cl_err(l_str, '!', 1)   #連接失敗
          RETURN 0
       END IF
    ELSE
       CALL q_aws2(TRUE,TRUE) RETURNING g_form.ActionCondition2
       IF NOT cl_null(g_form.ActionCondition2) THEN
          RETURN 1
       ELSE
          RETURN 0
       END IF 
    END IF
END FUNCTION
 
FUNCTION aws_efapp_formapproval()
    DEFINE l_items      STRING,
           lch_cmd      base.Channel,
           l_file       STRING,              
           l_pid        STRING,
           l_cmd        STRING,
           l_str        STRING
   DEFINE formdesc     LIKE type_file.chr1000 #No.FUN-680130 VARCHAR(100)
   DEFINE formid       LIKE type_file.chr1000 #No.FUN-680130 VARCHAR(100)
   DEFINE l_window     ui.Window
   DEFINE lnode_item   om.DomNode
   DEFINE ls_status    LIKE type_file.chr1    #No.FUN-680130 VARCHAR(1)
   DEFINE l_ze03       LIKE ze_file.ze03,              #FUN-6B0024
          l_i          LIKE type_file.num10            #FUN-6B0024
   DEFINE l_addusers   STRING                 #FUN-880099
   DEFINE l_tok        base.StringTokenizer   #FUN-880099
   DEFINE l_cross_status   LIKE type_file.num5         #No.FUN-B30003
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    #FUN-640184
 
    IF (g_action_choice CLIPPED = "confirm") THEN
       RETURN 1
    END IF
 
    IF (fgl_getenv("EASYFLOW") = '1' AND g_gui_type = 0) THEN
       CASE g_form.Status
           WHEN '2'                     #抽單, 撤簽
                LET ls_status = 'W'
           WHEN '3'                    #同意
                LET ls_status = '1'
           WHEN '4'                    #不同意
                LET ls_status = 'R'
       END CASE
 
       CALL aws_efapp_status(ls_status,g_form.SourceFormNum,g_prog) RETURNING l_status,l_str
       display l_status,"->",l_str
       RETURN l_status
    END IF
    #END FUN-640184
 
    CASE g_action_choice CLIPPED
         WHEN 'org_withdraw'                   #抽單 
              LET ls_status = 'W'
         WHEN 'agree'                          #同意
              LET ls_status = '1'
         WHEN 'deny'                           #不同意
              LET ls_status = 'R'
              #FUN-880099 --start
              IF g_aza.aza72="Y"  THEN 
                 IF (g_action_choice CLIPPED = "deny" AND g_form.ActionCondition CLIPPED = "0000|0000" ) THEN
                     #deny
                 ELSE
                    LET g_action_choice = "disagree"             #disagree=不准(退回重辦)
                 END IF
              END IF
              #FUN-880099 --end
    END CASE
 
    IF g_action_choice CLIPPED != "deny" THEN
           LET g_form.ActionCondition = ""
    END IF
 
    #判斷當 1.同意且最後一關; 2.不同意且退單至填表人; 3.抽單時; 
    #需要update狀態值
    IF (g_action_choice CLIPPED = "agree" AND g_form.LastStage = "Y" AND 
        (g_form.ActionCondition2 CLIPPED = "" OR cl_null(g_form.ActionCondition2)) ) OR
       (g_action_choice CLIPPED = "deny" AND g_form.ActionCondition CLIPPED = "0000|0000" ) OR
       (g_action_choice CLIPPED = "org_withdraw") 
    THEN
       #FUN-640184
       CALL aws_efapp_status(ls_status,g_form.SourceFormNum,g_prog) RETURNING l_status,l_str
       IF l_status = 0 THEN
           RETURN l_status
       END IF
 
       #判斷是否程式代號有在維護作業中設定
      #SELECT * INTO g_wse.* FROM wse_file WHERE wse01 = g_prog
      #IF SQLCA.SQLCODE OR SQLCA.SQLCODE = NOTFOUND THEN
      #   CALL cl_err("Select wse failed: ", SQLCA.SQLCODE, 0)
      #   RETURN 0
      #ELSE
      #   CASE g_action_choice CLIPPED
      #        WHEN 'org_withdraw'                   #抽單 
      #             LET ls_status = 'W'
      #        WHEN 'agree'                          #同意
      #             LET ls_status = '1'
      #        WHEN 'deny'                           #不同意
      #             LET ls_status = 'R'
      #   END CASE
 
      #  #若單號(g_form.SourceFormNum) 包含其他條件則擷取出來(以{+} 為區隔)
    
      #   LET l_wc = "" 
      #   LET l_i = 1
      #   LET l_tag = "{+}"
      #   LET l_g_formNum = g_form.SourceFormNum
      #   LET l_p1 = l_g_formNum.getIndexOf(l_tag,1)
      #   IF l_p1 != 0 THEN
      #     WHILE l_i <= l_g_formNum.getLength()
      #      LET l_p1 = l_g_formNum.getIndexOf(l_tag,l_i)
      #      LET l_p2 = l_g_formNum.getIndexOf(l_tag,l_p1+3)
      #      IF l_p2 = 0 THEN
      #         LET l_wc = l_wc CLIPPED," AND ", l_g_formNum.subString(l_p1+l_tag.getLength(),l_g_formNum.getLength())
      #         EXIT WHILE
      #      ELSE
      #         LET l_wc = l_wc CLIPPED," AND ", l_g_formNum.subString(l_p1+l_tag.getLength(),l_p2-1)
      #      END IF
 
      #      LET l_i = l_p2 - 1
 
      #     END WHILE
      #   END IF
 
      #   #取真正單號
      #   IF LENGTH(l_wc) != 0 THEN
      #      LET l_p1 = l_g_formNum.getIndexOf(l_tag,1)
      #      LEt g_formNum = l_g_formNum.subString(1, l_p1-1)
      #   ELSE
      #      LET g_formNum = g_form.SourceFormNum
      #   END IF
      #   #更新單頭檔狀態碼
      #   LET g_sql = "UPDATE ", g_wse.wse02 CLIPPED, " SET ",
      #               g_wse.wse10 CLIPPED, " = '", ls_status CLIPPED, "'",
      #               " WHERE ",  g_wse.wse03 CLIPPED, " = '", g_formNum CLIPPED, "'"
      #   IF LENGTH(l_wc) != 0 THEN
      #      LET g_sql = g_sql CLIPPED, l_wc
      #   END IF
      #   EXECUTE IMMEDIATE g_sql
      #   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN   #SQL 執行失敗
      #      CALL cl_err("Update wsf failed: ", SQLCA.SQLCODE, 0)
      #      RETURN 0
      #   END IF
      #   
      #   #更新單身檔狀態碼
      #   SELECT MAX(wsf02) INTO l_cnt FROM wsf_file WHERE wsf01 = g_prog 
      #   IF l_cnt > 0 THEN
      #      FOR l_i = 1 TO l_cnt
      #         SELECT * INTO g_wsf.* FROM wsf_file WHERE wsf01 = g_prog AND wsf02 = l_i
      #         IF SQLCA.SQLCODE OR SQLCA.SQLCODE = NOTFOUND THEN
      #            CALL cl_err("select wsf failed: ", SQLCA.SQLCODE, 0)
      #            RETURN 0
      #         END IF
      #      
      #         IF (g_wsf.wsf03 CLIPPED IS NOT NULL) AND 
      #            (g_wsf.wsf04 CLIPPED IS NOT NULL) AND
      #            (g_wsf.wsf09 CLIPPED IS NOT NULL) THEN
      #            LET g_sql = "UPDATE ", g_wsf.wsf03 CLIPPED, " SET ",
      #                        g_wsf.wsf09 CLIPPED, " = '", ls_status CLIPPED, "'",
      #                        " WHERE ",  g_wsf.wsf04 CLIPPED, " = '", g_formNum CLIPPED, "'"
      #            IF LENGTH(l_wc) != 0 THEN
      #               LET g_sql = g_sql CLIPPED, l_wc
      #            END IF
      #            EXECUTE IMMEDIATE g_sql
      #            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN   #SQL 執行失敗
      #               CALL cl_err("Update wsf failed: ", SQLCA.SQLCODE, 0)
      #               RETURN 0
      #            END IF
      #         ELSE
      #            EXIT FOR
      #         END IF
      #      END FOR  
      #   END IF
      #END IF
      #END FUN-640184
    END IF
    CALL aws_efapp_XMLHeader("DoFormApproval")
 
    LET g_strXMLInput =  g_strXMLInput CLIPPED,
        "           <PlantID>",g_plant CLIPPED,"</PlantID>", ASCII 10,
        "           <ProgramID>",g_prog CLIPPED,"</ProgramID>", ASCII 10,
        "           <SourceFormID>",g_form.SourceFormID CLIPPED,"</SourceFormID>", ASCII 10,
        "           <SourceFormNum>",g_form.SourceFormNum CLIPPED,"</SourceFormNum>", ASCII 10,
        "           <FormCreatorID>",g_form.FormCreatorID CLIPPED,"</FormCreatorID>", ASCII 10,
        "           <FormOwnerID>",g_form.FormOwnerID CLIPPED,"</FormOwnerID>", ASCII 10,
        "           <TargetFormID>",g_form.TargetFormID CLIPPED,"</TargetFormID>", ASCII 10,
        "           <TargetSheetNo>",g_form.TargetSheetNo CLIPPED,"</TargetSheetNo>", ASCII 10
    IF g_aza.aza72 MATCHES '[Nn]' THEN                 #FUN-880099
       LET g_strXMLInput =  g_strXMLInput CLIPPED,     #FUN-880099     
           "        <FlowNo>",g_form.FlowNo CLIPPED,"</FlowNo>", ASCII 10,
           "        <BranchNo>",g_form.BranchNo CLIPPED,"</BranchNo>", ASCII 10,
           "        <SerialNo>",g_form.SerialNo CLIPPED,"</SerialNo>", ASCII 10,
           "        <SignNum>",g_form.SignNum CLIPPED,"</SignNum>", ASCII 10,
           #"        <Action>",g_action_choice CLIPPED,"</Action>",ASCII 10,     #FUN-880099  移到下面另外處理
           "        <ActionCondition>",g_form.ActionCondition CLIPPED,"</ActionCondition>",ASCII 10,
           "        <ActionCondition2>",g_form.ActionCondition2 CLIPPED,"</ActionCondition2>",ASCII 10
    #FUN-880099 --start
    ELSE
       LET g_strXMLInput =  g_strXMLInput CLIPPED,
           "        <TargetWorkItemOID>",g_form.TargetWorkItemOID CLIPPED,"</TargetWorkItemOID>", ASCII 10
          
       CASE g_action_choice CLIPPED
          WHEN  'withdraw'           # 撤簽
                LET g_strXMLInput =  g_strXMLInput CLIPPED,
                     " <CurrentOwnerID>",g_form.FormOwnerID CLIPPED,"</CurrentOwnerID>", ASCII 10
                    
          WHEN  'org_withdraw'       # 抽單
                LET g_strXMLInput =  g_strXMLInput CLIPPED,
                     " <AbortedManType>1</AbortedManType> ", ASCII 10
                    
          WHEN  'disagree'           # 退回重辦
                LET g_strXMLInput =  g_strXMLInput CLIPPED,       
                       SFMT(" <ReexecuteActivityInfo targetActivityId='%1' currentActivityId='%2' type='0'/> ",
                                  g_form.BranchNo,g_form.FlowNo), ASCII 10
        END CASE
         
        LET l_addusers = g_form.ActionCondition2   
        IF l_addusers.getLength()> 0 THEN
           LET g_action_choice = "modify_flow"      # 加簽(modify_flow)
           LET l_str = "           <AddedActivityInfo name=\"modify_flow\"  addMode=\"POST\" userMode=\"FIRST_GET_FIRST_WIN\"  executeMode=\"NORMAL\" >", ASCII 10
           LET l_tok = base.StringTokenizer.create(l_addusers,"|")

           WHILE l_tok.hasMoreTokens()                 
                  LET l_str = l_str, "             <Record employeeId=\"", l_tok.nextToken() ,"\"/>", ASCII 10
           END WHILE       
           LET l_str = l_str,"           </AddedActivityInfo>", ASCII 10
           LET g_strXMLInput =  g_strXMLInput CLIPPED, l_str
        END IF            
    END IF 

    LET g_strXMLInput =  g_strXMLInput CLIPPED,
        "           <Action>",g_action_choice CLIPPED,"</Action>",ASCII 10,
    #FUN-880099 --end
        "           <Description>",g_phrase CLIPPED, "</Description>", ASCII 10
    
    CALL aws_efapp_XMLTrailer()
 
    ###轉換 & 為 &amp; 
    #FUN-710063
    #LET buf = base.StringBuffer.create()
    #CALL buf.append(g_strXMLInput)
    #CALL buf.replace( "&","&amp;", 0)
    #LET g_strXMLInput = buf.toString()
    LET g_strXMLInput = aws_xml_replace(g_strXMLInput)
    #END FUN-710063
 
    #LET EFGateWay_soapServerLocation = g_efsoap  #指定 Soap server location
    
    #No.FUN-710010 --start--
    IF g_aza.aza72 = 'N' THEN 
        LET EFGateWay_soapServerLocation = g_efsoap  #指定 Soap server location
    ELSE #指定EasyFlowGP的SOAP網址
        LET EFGPGateWay_soapServerLocation = g_efsoap  #指定 Soap server location
    END IF
    #No.FUN-710010 --end--
    
    #FUN-6B0024
    FOR l_i = 1 TO 4
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
           CALL aws_cross_invokeSrv(l_str,"DoFormApproval","sync",g_strXMLInput) 
                RETURNING l_cross_status, l_status, l_Result
           IF NOT l_cross_status  THEN     
              RETURN 0
           END IF
        ELSE
        #No:FUN-B30003 -- end --
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
        
       #IF NOT (l_status = 1 AND wsError.description= "Timeout reached.")
        IF NOT (l_status !=0 AND wsError.description= "TCP Connection reached timeout.")  #FUN-7C0055
           OR (l_i = 4)
        THEN
             EXIT FOR
        ELSE
           SELECT ze03 INTO l_ze03 FROM ze_file
                WHERE ze01 = 'aws-094' AND ze02 = g_lang
           LET l_str = cl_replace_err_msg(l_ze03,l_i)
           MENU "Exclamation" ATTRIBUTE(STYLE="dialog", COMMENT=l_str CLIPPED, IMAGE="exclamation")
             ON ACTION accept
                EXIT MENU
             ON ACTION cancel
                LET INT_FLAG = 1
                EXIT MENU
             ON IDLE 5
                EXIT MENU
           END MENU
           IF INT_FLAG THEN
                 LET INT_FLAG = 0
                 EXIT FOR
           END IF
           CALL ui.interface.refresh()
           SLEEP 5
        END IF
    END FOR
    #END FUN-6B0024
 
    CALL aws_efapp_file(l_status) #紀錄傳入 EasyFlow 的字串  #TQC-750259
  
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
             LET l_str = "XML parser error:\n\n", l_str
          ELSE
             LET l_str = "XML parser error: ", l_str
          END IF
          #END FUN-780049
          CALL cl_err(l_str, '!', 1)   #XML 字串有問題
          RETURN 0
       END IF

       IF g_aza.aza72 MATCHES '[Nn]' THEN     #FUN-880099
          LET g_form.SourceFormNum = aws_xml_getTag(l_Result, "SourceFormNum")
          LET g_form.Status = aws_xml_getTag(l_Result, "Status")
       #FUN-880099 start
       ELSE
             CASE
                   WHEN (g_action_choice='withdraw'  OR g_action_choice='org_withdraw' ) 
                   LET g_form.Status = '2'     #抽單 
              WHEN (g_action_choice='agree')
                   LET g_form.Status = '3'     #同意
              WHEN (g_action_choice='disagree' OR g_action_choice='deny' )                                   
                   LET g_form.Status = '4'     #不同意
          END CASE
       END IF 
       #FUN-880099 end
 
       CALL aws_eflog(l_Result)                         #寫入 log 
 
       #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
       IF g_form.Status = "1" AND g_action_choice CLIPPED = "agree" AND 
          g_form.LastStage = "Y"  AND 
          (g_form.ActionCondition2 CLIPPED = "" OR cl_null(g_form.ActionCondition2)) 
       THEN
          RETURN 2
       END IF
          
       IF (g_action_choice CLIPPED = "agree" AND g_form.LastStage = "Y" AND 
          (g_form.ActionCondition2 CLIPPED = "" OR cl_null(g_form.ActionCondition2)) ) OR
          (g_action_choice CLIPPED = "deny" AND g_form.ActionCondition CLIPPED = "0000|0000" ) OR
          (g_action_choice CLIPPED = "org_withdraw") 
       THEN
            LET g_progID = g_prog                              #FUN-960057
            SLEEP 5    #CHI-A50019 add
            CALL aws_efstat2_approveLog(g_form.SourceFormNum)       ##FUN-4C0082 
       END IF
       RETURN 1
    ELSE
       IF fgl_getenv('FGLGUI') = '1' THEN
          LET l_str = "Connection failed:\n\n", 
                   "  [Code]: ", wserror.code, "\n",
                   "  [Action]: ", wserror.action, "\n",
                   "  [Description]: ", wserror.description
       ELSE
          LET l_str = "Connection failed: ", wserror.description
       END IF
       CALL cl_err(l_str, '!', 1)   #連接失敗
       RETURN 0
    END IF
END FUNCTION
 
FUNCTION aws_efapp_XMLHeader(p_method)
DEFINE p_method     LIKE type_file.chr20             #No.FUN-680130 VARCHAR(20)
DEFINE l_client     LIKE type_file.chr20,            #No.FUN-680130 VARCHAR(20)     
       l_efsiteip   LIKE type_file.chr20,            #No.FUN-680130 VARCHAR(20)
       l_efsitename LIKE type_file.chr20,            #No.FUN-680130 VARCHAR(20)     
       l_i          LIKE type_file.num5          #No.FUN-680130 SMALLINT
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
        " <RequestMethod>",p_method CLIPPED,"</RequestMethod>", ASCII 10,
        " <LogOnInfo>", ASCII 10,
        "   <SenderIP>", l_client CLIPPED, "</SenderIP>", ASCII 10,
        "   <ReceiverIP>", l_efsiteip CLIPPED, "</ReceiverIP>", ASCII 10,
        "   <EFSiteName>", l_efsitename CLIPPED, "</EFSiteName>", ASCII 10,
        "   <EFLogonID>", g_user CLIPPED, "</EFLogonID>", ASCII 10,
        "   <TPServerIP>",l_tpip CLIPPED, "</TPServerIP>", ASCII 10,    #FUN-960137
        "   <TPServerEnv>",l_tpenv CLIPPED, "</TPServerEnv>", ASCII 10, #FUN-960137
        " </LogOnInfo>", ASCII 10,
        " <RequestContent>", ASCII 10,
        "   <ContentText>", ASCII 10
    IF g_aza.aza72 MATCHES '[Nn]' THEN                #FUN-880099
       LET g_strXMLInput =  g_strXMLInput CLIPPED,    #FUN-880099
           "     <Form>", ASCII 10
    #FUN-880099 --start
    ELSE
       LET g_strXMLInput =  g_strXMLInput CLIPPED,
           "     <Language>Big5</Language>", ASCII 10,      
           "     <Form>", ASCII 10
    END IF 
    #FUN-880099 --end
 
END FUNCTION
 
 
FUNCTION aws_efapp_XMLTrailer()
 
    LET g_strXMLInput = g_strXMLInput CLIPPED,   #組 XML Trailer
        "     </Form>", ASCII 10,
        "   </ContentText>", ASCII 10,
        " </RequestContent>", ASCII 10,
        "</Request>"
END FUNCTION
 
FUNCTION aws_efapp_file(p_status)                             #TQC-750259
  DEFINE p_status     LIKE type_file.num10                    #TQC-750259
  DEFINE l_file       STRING,
         l_cmd        STRING,
         l_str        STRING
              
    LET channel = base.Channel.create()
    LET l_file = "aws_efcli2-", TODAY USING 'YYYYMMDD', ".log"
    CALL channel.openFile(l_file, "a")
 
    IF STATUS = 0 THEN
       CALL channel.setDelimiter("")
       LET l_str = "#--------------------------- (", CURRENT YEAR TO SECOND, ") ----------------------------#"
       CALL channel.write(l_str)
       CALL channel.write("")
       CALL channel.write("Request XML:")
       CALL channel.write(g_strXMLInput)
       CALL channel.write("")
 
       #紀錄 EasyFlow 回傳的資料
       CALL channel.write("Response XML:")
 
       #TQC-750259
       IF p_status = 0 THEN
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
       #RUN "chmod 666 l_file CLIPPED >/dev/null 2>/dev/null"     #NO.FUN-520020
#       LET l_cmd = "chmod 666 ", l_file CLIPPED, " >/dev/null 2>/dev/null" #MOD-560007 #No.FUN-9C0009
#      RUN l_cmd                                          #No.FUN-9C0009   
       IF os.Path.chrwx(l_file CLIPPED,438) THEN END IF   #No.FUN-9C0009  
    ELSE
       DISPLAY "Can't open log file."
    END IF
END FUNCTION
 
FUNCTION aws_efapp_toolbar()
   DEFINE l_root            om.DomNode
   DEFINE l_nl              om.NodeList
   DEFINE l_toolbar         om.DomNode
   DEFINE l_child           om.DomNode
   DEFINE l_node            om.DomNode
   DEFINE l_items           DYNAMIC ARRAY OF STRING
   DEFINE l_i               LIKE type_file.num10           #No.FUN-680130 INTEGER
   DEFINE l_actionlist      om.DomNode
   DEFINE l_action_child    om.DomNode
   DEFINE l_name            STRING
   DEFINE l_image           STRING
   DEFINE l_text            STRING
 
   
   IF fgl_getenv('EASYFLOW') != "1" THEN   
            RETURN 
   END IF
   #建置 EasyFlow 簽核功能 toolbar item
   CALL l_items.clear()
   CASE                               #FUN-880099 
        WHEN g_wsk.wsk14="Info"       #FUN-880099
             RETURN
        WHEN g_wsk.wsk14="Sent"       #FUN-880099 
             LET l_items[1] = "org_withdraw"
        WHEN (g_wsk.wsk14="Inbox" OR g_wsk.wsk14="Withdraw")  #FUN-880099
             LET l_items[1] = "phrase"
             LET l_items[2] = "withdraw"
             LET l_items[3] = "modify_flow"
             LET l_items[4] = "deny"
             LET l_items[5] = "agree"
        OTHERWISE
             RETURN
   END CASE
   LET l_root = ui.Interface.getRootNode()
   LET l_nl = l_root.selectByPath("/UserInterface/ToolBar")
   LET l_toolbar = l_nl.item(1)
   LET l_child = l_toolbar.getFirstChild()
   LET l_node = l_toolbar.createChild("ToolBarSeparator")
   CALL l_toolbar.insertBefore(l_node, l_child)
   LET l_child = l_node
   LET l_nl = l_root.selectByPath("/UserInterface/ActionDefaultList")
   LET l_actionlist = l_nl.item(1)
 
   FOR l_i = 1 TO l_items.getLength()
       LET l_node = l_toolbar.createChild("ToolBarItem")
       CALL l_node.setAttribute("name", l_items[l_i])
       LET l_action_child = l_actionlist.getFirstChild()
       WHILE l_action_child IS NOT NULL
          LET l_name  = l_action_child.getAttribute("name")
          IF l_items[l_i] = l_name THEN
                 LET l_image = l_action_child.getAttribute("image")
                 LET l_text = l_action_child.getAttribute("text")
                 CALL l_node.setAttribute("image", l_image)
                 CALL l_node.setAttribute("text", l_text)
                 EXIT WHILE
          END IF
          LET l_action_child = l_action_child.getNext()
       END WHILE
       CALL l_toolbar.insertBefore(l_node, l_child)
       LET l_child = l_node
   END FOR
 
   CALL ui.Interface.refresh()
END FUNCTION
 
FUNCTION aws_efapp_phrase()
   DEFINE l_phrase_t LIKE type_file.chr1000 #No.FUN-680130 VARCHAR(255)
 
   OPEN WINDOW ef_phrase_w WITH FORM "aws/42f/aws_efphrase"
       ATTRIBUTE(STYLE="dialog")
   CALL cl_ui_locale("aws_efphrase")
 
   LET l_phrase_t = g_phrase
 
#TQC-860022
   INPUT g_phrase WITHOUT DEFAULTS FROM phrase
 
    ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT 
 
    ON ACTION about         #MOD-4C0121
       CALL cl_about()      #MOD-4C0121
 
    ON ACTION controlg      #MOD-4C0121
       CALL cl_cmdask()     #MOD-4C0121
 
    ON ACTION help          #MOD-4C0121
       CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
#END TQC-860022
 
   IF INT_FLAG THEN
      LET INT_FLAG = FALSE
      LET g_phrase = l_phrase_t
   END IF
   CLOSE WINDOW ef_phrase_w
END FUNCTION
 
FUNCTION aws_efapp_getnextforminfo()
DEFINE  l_ef DYNAMIC ARRAY OF RECORD
            ef01     LIKE wsk_file.wsk04, #TIPTOP 單別
            ef02     LIKE wsk_file.wsk05, #TIPTOP 單號        #FUN-590076
            ef03     LIKE wsk_file.wsk03, #TIPTOP 程式代號
            ef04     LIKE wsk_file.wsk08, #EasyFlow 單別
            ef05     LIKE type_file.chr1,  #重要性 #No.FUN-680130 VARCHAR(1)
            ef06     LIKE type_file.chr4,  #簽核結果#No.FUN-680130 VARCHAR(4)
            ef07     LIKE type_file.chr4,  #簽核狀態#No.FUN-680130 VARCHAR(4)
            ef08     STRING,              #填表人  #No.FUN-680130 VARCHAR(10) #FUN-7C0003
            ef09     STRING,              #關係人  #No.FUN-680130 VARCHAR(10) #FUN-7C0003
            ef10     STRING,              #表單簡稱
            ef11     LIKE wsk_file.wsk09, #EasyFlow 表單單號
            ef12     STRING,              #主旨
            ef13     STRING,              #收件日期時間
            ef14     STRING,              #表單來源
            ef15     LIKE wsk_file.wsk10, #關號
            ef16     LIKE wsk_file.wsk11, #支號
            ef17     LIKE wsk_file.wsk12, #流水號
            ef18     LIKE wsk_file.wsk13  #簽核序號
        END RECORD
#FUN-880099 --start 
DEFINE  l_efgp DYNAMIC ARRAY OF RECORD
            ef21     LIKE wsk_file.wsk04, #TIPTOP 單別 #No.FUN-680135 CHAR(5)
            ef22     LIKE wsk_file.wsk05, #TIPTOP 單號 #No:FUN-590076 #No.FUN-680135 CHAR(80)
            ef23     LIKE wsk_file.wsk03, #TIPTOP 程式代號 #No.FUN-680135 CHAR(10)
            ef24     LIKE wsk_file.wsk08, #EasyFlow 單別 #No.FUN-680135 CHAR(20)
            ef25     STRING,              #重要性
            ef26     STRING,              #
            ef27     STRING,              #簽核狀態#No.FUN-680130 CHAR(4)
            ef28     STRING,              #流程名稱
            ef29     STRING,              #名稱        關係人 
            ef30     STRING,              #來源 assignmentType
            ef31     LIKE wsk_file.wsk09, #表單單號 processOID
            ef32     STRING,              #主旨 subject 
            ef33     STRING,              #發起者
            ef331    STRING,              #流程關係人 =>relationshipName
            ef34     STRING,              #
            ef35     LIKE azg_file.azg06, #workItemOID
            ef36     STRING,              #建立時間
            ef37     STRING               #讀取次數
        END RECORD     
#FUN-880099 --end      
DEFINE  l_forminfo        LIKE type_file.chr1000,                       #No.FUN-680130 VARCHAR(50)
        l_strfilter       LIKE type_file.chr1000,                       #No.FUN-680130 VARCHAR(50)
        l_intfilter       LIKE type_file.chr1000,                       #No.FUN-680130 VARCHAR(50)
        l_curr_page       LIKE type_file.num10,  # Current Page Number  #No.FUN-680130 INTEGER
        l_total_page      LIKE type_file.num10,  # Total Pages          #No.FUN-680130 INTEGER
        l_i               LIKE type_file.num10                          #No.FUN-680130 INTEGER
 
   INITIALIZE g_form.* TO NULL
   INITIALIZE g_wse.* TO NULL 
   INITIALIZE g_wsf.* TO NULL 
   LET g_flowuser = FALSE
   LET g_phrase = ""
 
   LET l_forminfo = "Inbox"
   LET l_strfilter = "ALL"
   LET l_intfilter = "2"
   LET l_curr_page = 1
   CALL l_ef.clear()
 
   #CALL aws_efapp_formInfo(l_ef,l_forminfo, l_intfilter, l_strfilter, l_curr_page)  

   IF g_aza.aza72 MATCHES '[Nn]' THEN     #FUN-880099
      CALL aws_efapp_formInfo(l_ef,l_forminfo, l_intfilter, l_strfilter, 
                              l_curr_page, '1000')                     #FUN-7C0094
              RETURNING l_status,l_curr_page,l_total_page
 
      FOR l_i = 1 to l_ef.getLength() 
          IF l_ef[l_i].ef03 CLIPPED = g_prog CLIPPED THEN
                   LET g_form.SourceFormID  = l_ef[l_i].ef01
                   LET g_form.SourceFormNum = l_ef[l_i].ef02
                   LET g_form.FormCreatorID = l_ef[l_i].ef08
                   LET g_form.FormOwnerID   = l_ef[l_i].ef09
                   LET g_form.TargetFormID  = l_ef[l_i].ef04
                   LET g_form.TargetSheetNo = l_ef[l_i].ef11
                   LET g_form.FlowNo   = l_ef[l_i].ef15
                   LET g_form.BranchNo = l_ef[l_i].ef16
                   LET g_form.SerialNo = l_ef[l_i].ef17
                   LET g_form.SignNum  = l_ef[l_i].ef18
 
                   LET g_form.FormCreatorID = aws_efapp_getid(g_form.FormCreatorID) #FUN-7C0003
                   LET g_form.FormOwnerID = aws_efapp_getid(g_form.FormOwnerID)     #FUN-7C0003
                   RETURN 1
          END IF 
      END FOR
   #FUN-880099 --start 
   ELSE
         LET g_sql="SELECT azg01,azg09 FROM azg_file WHERE azg04='1' and azg06=?"
      PREPARE efgp_pre FROM g_sql
      DECLARE efgp_cur  SCROLL CURSOR FOR efgp_pre

      LET l_forminfo = "PerformableWorkItems"
         CALL aws_efgpapp_formInfo(l_efgp,l_forminfo, l_intfilter, l_strfilter, 
                           l_curr_page, '1000')                   
           RETURNING l_status,l_curr_page,l_total_page
      FOR l_i = 1 to l_efgp.getLength() 
             OPEN efgp_cur USING l_efgp[l_i].ef31           
           FETCH efgp_cur  INTO l_efgp[l_i].ef22 , l_efgp[l_i].ef23 
           IF l_efgp[l_i].ef23 CLIPPED = g_prog CLIPPED THEN
                   LET g_form.SourceFormID  = l_efgp[l_i].ef21
                   LET g_form.SourceFormNum = l_efgp[l_i].ef22
                   LET g_form.FormCreatorID = l_efgp[l_i].ef33
                   #LET g_form.FormOwnerID   = l_efgp[l_i].ef09
                   #LET g_form.TargetFormID  = 
                   LET g_form.TargetSheetNo = l_efgp[l_i].ef31
                   LET g_form.TargetWorkItemOID = l_efgp[l_i].ef35           

                   #LET g_form.FormCreatorID = aws_efapp_getid(g_form.FormCreatorID) #FUN-7C0003
                   #LET g_form.FormOwnerID = aws_efapp_getid(g_form.FormOwnerID)     #FUN-7C0003
                   RETURN 1
          END IF 
      END FOR           
   END IF
   #FUN-880099 --end
   
   CALL cl_err('','mfg3382',1)
   RETURN 0
END FUNCTION
 
FUNCTION aws_efapp_wsk(p_key)
DEFINE p_key            LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE l_argv           LIKE type_file.chr1000 #No.FUN-680130 VARCHAR(80)
DEFINE l_i              LIKE type_file.num10,  #No.FUN-680130 INTEGER
       l_k              LIKE type_file.num10,  #No.FUN-680130 INTEGER
       l_tag            STRING,
       l_p1             LIKE type_file.num10,  #No.FUN-680130 INTEGER
       l_p2             LIKE type_file.num10,  #No.FUN-680130 INTEGER
       l_g_formNum      STRING,
       l_pos            LIKE type_file.num10,  #No.FUN-680130 INTEGER
       l_meet           LIKE type_file.num10,  #No.FUN-680130 INTEGER
       l_wc             STRING,
  #FUN-640184           
       ls_server        STRING
DEFINE l_cnt            LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE l_SourceFormNum  STRING    #FUN-780070
 
      IF fgl_getenv("EASYFLOW") = '1' AND g_gui_type = 0 THEN
         LET g_user = 'tiptop'
         LET ls_server = fgl_getenv("FGLAPPSERVER")
         IF cl_null(ls_server) THEN
            LET ls_server = fgl_getenv('FGLSERVER')
         END IF
      ELSE 
         LET ls_server = fgl_getenv('FGLSERVER')
      END IF
      #END FUN-640184
      IF cl_null(g_wsk.wsk05) THEN
          INITIALIZE g_form.* TO NULL
          INITIALIZE g_wse.* TO NULL 
          INITIALIZE g_wsf.* TO NULL 
          LET g_flowuser = FALSE
          LET g_phrase = "" 
 
          #TQC-7B0029 
          #FUN-780070
          #LET l_SourceFormNum = ""
          ##判斷是否程式代號有在維護作業中設定
          #SELECT * INTO g_wse.* FROM wse_file WHERE wse01 = g_prog
          #IF g_wse.wse03 IS NOT NULL THEN
          #   LET l_SourceFormNum = ARG_VAL(1)
          #   IF g_wse.wse04 IS NOT NULL THEN
          #      LET l_SourceFormNum = l_SourceFormNum,'{+}',
          #                            g_wse.wse04 CLIPPED,'=',ARG_VAL(2)
          #      IF g_wse.wse05 IS NOT NULL THEN
          #         LET l_SourceFormNum = l_SourceFormNum,'{+}',
          #                               g_wse.wse05 CLIPPED, '=',ARG_VAL(3)
          #         IF g_wse.wse06 IS NOT NULL THEN
          #            LET l_SourceFormNum = l_SourceFormNum,'{+}',
          #                                  g_wse.wse06 CLIPPED,'=',ARG_VAL(4)
          #            IF g_wse.wse07 IS NOT NULL THEN
          #               LET l_SourceFormNum = l_SourceFormNum,'{+}',
          #                                    g_wse.wse07 CLIPPED,'=',ARG_VAL(5)
          #            END IF
          #         END IF
          #      END IF
          #   END IF
          #END IF
 
          LET l_SourceFormNum = FGL_GETENV("SourceFormNum")
          #END TQC-7B0029 
          LET g_sql = "SELECT * FROM wsk_file",
                      " WHERE wsk01 = '",ls_server,"'", #FUN-640184
                      "   AND wsk02 = '",g_user CLIPPED,"'",
                      "   AND wsk03 = '",g_prog CLIPPED,"'",
                      "   AND wsk05 = '",l_SourceFormNum CLIPPED,"'"
          #END FUN-780070
          display g_sql
          DECLARE select_cur CURSOR FROM g_sql
          IF STATUS THEN
             CALL cl_err('select_cur:',status,1)
          END IF
          FOREACH select_cur INTO g_wsk.*
               IF STATUS THEN
                  CALL cl_err('select_cur:',status,1)
               END IF
          END FOREACH
 
          #FUN-780070  
          LET g_sql = "DELETE FROM wsk_file",
                      " WHERE wsk01='",ls_server,"'", #FUN-640184
                      "   AND wsk02='",g_user CLIPPED,"'",
                      "   AND wsk03='",g_prog CLIPPED,"'",
                      "   AND wsk05='",l_SourceFormNum CLIPPED,"'"
          #END FUN-780070  
             
          PREPARE delete_prep FROM g_sql
          IF STATUS THEN
             CALL cl_err('delete_prep:',status,1) 
          END IF
          EXECUTE delete_prep
          IF cl_null(g_wsk.wsk05) THEN
             #  RETURN ''     #FUN-940047 mark
             CALL cl_used(g_prog,g_time,2)   RETURNING g_time
             EXIT PROGRAM     #FUN-940047 add
          END IF
          
          LET g_form.SourceFormID  = g_wsk.wsk04
          LET g_form.SourceFormNum = g_wsk.wsk05
          LET g_form.FormCreatorID = g_wsk.wsk06
          LET g_form.FormOwnerID   = g_wsk.wsk07
          LET g_form.TargetFormID  = g_wsk.wsk08
          LET g_form.TargetSheetNo = g_wsk.wsk09
          LET g_form.TargetWorkItemOID = g_wsk.wsk16          #FUN-880099 
          LET g_form.FlowNo   = g_wsk.wsk10
          LET g_form.BranchNo = g_wsk.wsk11
          LET g_form.SerialNo = g_wsk.wsk12
          LET g_form.SignNum  = g_wsk.wsk13
          LET g_form.Status = g_wsk.wsk15        #FUN-640184 
 
          LET g_form.FormCreatorID = aws_efapp_getid(g_wsk.wsk06) #FUN-7C0003
          LET g_form.FormOwnerID = aws_efapp_getid(g_wsk.wsk07)     #FUN-7C0003
      END IF
 
      #MOD-690128
      #若單號(g_form.SourceFormNum) 包含其他條件則擷取出來(以{+} 為區隔)
      #LET l_wc = "" 
      #LET l_argv = ""
      #LET l_tag = "{+}"
      #LET l_g_formNum = g_form.SourceFormNum
      #LET l_p1 = l_g_formNum.getIndexOf(l_tag,1)
      #IF p_key = 1 THEN
      #   #取真正單號
      #   IF l_p1 > 0 THEN
      #      LEt l_argv = l_g_formNum.subString(1, l_p1-1)
      #   ELSE
      #      LET l_argv = g_form.SourceFormNum
      #   END IF
      #   RETURN l_argv
      #END IF
      #IF l_p1 != 0 THEN
      #   LET l_i = 1
      #   FOR l_k = 2 TO p_key 
      #      LET l_p1 = l_g_formNum.getIndexOf(l_tag,l_i)
      #      LET l_p2 = l_g_formNum.getIndexOf(l_tag,l_p1+3)
      #      IF l_p1 = 0 THEN
      #           RETURN ''
      #      END IF
      #      LET l_i = l_p2 - 1
      #   END FOR
 
      #   IF l_p2 = 0 THEN
      #      LET l_wc = l_g_formNum.subString(l_p1+l_tag.getLength(),l_g_formNum.getLength())
      #      LET l_p1 = l_wc.getIndexOf("=",1)
      #   ELSE
      #      LET l_wc = l_g_formNum.subString(l_p1+l_tag.getLength(),l_p2-1)
      #   END IF
      #   LET l_p1 = l_wc.getIndexOf("=",1)
      #   IF l_p1 = 0 THEN
      #        RETURN ''
      #   END IF
      #   LET l_argv = l_wc.subString(l_p1+1,l_wc.getLength())
      #   RETURN l_argv
      #END IF
      #RETURN ''
      LET l_argv = aws_efapp_key_value(g_form.SourceFormNum,p_key)
      #--FUN-940047--start--
      IF cl_null(l_argv) THEN
         CALL cl_err('Key value not found','!',1)
         CALL cl_used(g_prog,g_time,2)   RETURNING g_time
         EXIT PROGRAM
      END IF
      #--FUN-940047--end-
      RETURN l_argv
      #END MOD-690128
 
END FUNCTION
 
#FUN-640184
FUNCTION aws_efapp_status(p_status,p_formnum,p_prog)
DEFINE p_status     STRING,
       p_formnum    LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(100)
       p_prog       LIKE wse_file.wse01,   #No.FUN-680130 VARCHAR(10)
       l_tag        STRING,
       l_p1         LIKE type_file.num10,  #No.FUN-680130 INTEGER
       l_p2         LIKE type_file.num10,  #No.FUN-680130 INTEGER
       l_g_formNum  STRING,
       l_i          LIKE type_file.num10,  #No.FUN-680130 INTEGER
       l_cnt        LIKE type_file.num10,  #No.FUN-680130 INTEGER
       l_wc         STRING,
       l_lang       LIKE ze_file.ze02,     #No.FUN-680130 VARCHAR(10)
       l_str        STRING,
       l_ze03       LIKE ze_file.ze03
DEFINE l_sql        STRING                 #CHI-BC0010
DEFINE l_tmp        CHAR(50)               #CHI-BC0010

       LET l_lang = 0
       LET g_form.SourceFormNum = p_formnum
      
          #判斷是否程式代號有在維護作業中設定
          SELECT * INTO g_wse.* FROM wse_file WHERE wse01 = p_prog
          IF SQLCA.SQLCODE OR SQLCA.SQLCODE = NOTFOUND THEN
#            CALL cl_err("Select wse failed: ", SQLCA.SQLCODE, 0)   #No.FUN-660155
             CALL cl_err3("sel","wse_file",p_prog,"",SQLCA.sqlcode,"","Select wse failed:", 0)   #No.FUN-660155)   #No.FUN-660155
             SELECT ze03 INTO l_ze03 FROM ze_file
                WHERE ze01 = 'aws-082' AND ze02 = l_lang
             LET l_str = p_prog CLIPPED," ",l_ze03
             RETURN 0,l_str
          END IF
 
          #MOD-690128
          #若單號(g_form.SourceFormNum) 包含其他條件則擷取出來(以{+} 為區隔)
          #LET l_wc = "" 
          #LET l_i = 1
          #LET l_tag = "{+}"
          #LET l_g_formNum = g_form.SourceFormNum
          #LET l_p1 = l_g_formNum.getIndexOf(l_tag,1)
          #IF l_p1 != 0 THEN
          #  WHILE l_i <= l_g_formNum.getLength()
          #   LET l_p1 = l_g_formNum.getIndexOf(l_tag,l_i)
          #   LET l_p2 = l_g_formNum.getIndexOf(l_tag,l_p1+3)
          #   IF l_p2 = 0 THEN
          #      LET l_wc = l_wc CLIPPED," AND ", l_g_formNum.subString(l_p1+l_tag.getLength(),l_g_formNum.getLength())
          #      EXIT WHILE
          #   ELSE
          #      LET l_wc = l_wc CLIPPED," AND ", l_g_formNum.subString(l_p1+l_tag.getLength(),l_p2-1)
          #   END IF
 
          #   LET l_i = l_p2 - 1
 
          #  END WHILE
          #END IF
 
           CALL aws_efapp_wc_key(g_form.SourceFormNum) RETURNING l_wc
 
          #取真正單號
          IF LENGTH(l_wc) != 0 THEN
            #LET l_p1 = l_g_formNum.getIndexOf(l_tag,1)
            #LET g_formNum = l_g_formNum.subString(1, l_p1-1)
 
             LET g_formNum = aws_efapp_key(g_form.SourceFormNum,1)
 
          ELSE
             LET g_formNum = g_form.SourceFormNum
          END IF
          #END MOD-690128
 
          #更新單頭檔狀態碼
          
          #CHI-BC0010 - Start -
          #TIPTOP簽核功能，按下不准時也要判斷該筆資料是否被LOCK住
          IF g_action_choice = "deny" OR g_action_choice = "org_withdraw" THEN  
             BEGIN WORK                            

             LET l_sql = "SELECT ", g_wse.wse10 CLIPPED, " FROM ", g_wse.wse02 CLIPPED,
                         " WHERE ",  g_wse.wse03 CLIPPED, " = '", g_formNum CLIPPED, "' FOR UPDATE"
             LET l_sql = cl_forupd_sql(l_sql)
             DECLARE upd_lock CURSOR FROM l_sql
             OPEN upd_lock
             IF status <> 0 THEN
                CALL cl_err("Open upd_lock:",status,1)
                LET l_str = "Open upd_lock:",cl_getmsg(status,l_lang)
                CLOSE upd_lock                 
                ROLLBACK WORK                    
                RETURN 0,l_str
             END IF 

             FETCH upd_lock INTO l_tmp
             IF SQLCA.sqlcode THEN
                CALL cl_err("Open upd_lock:",status,1)
                LET l_str = "Open upd_lock:",cl_getmsg(SQLCA.sqlcode,l_lang)
                CLOSE upd_lock                       
                ROLLBACK WORK                         
                RETURN 0,l_str
             END IF
          END IF
          #CHI-BC0010 -  End  -
          
          LET g_sql = "UPDATE ", g_wse.wse02 CLIPPED, " SET ",
                      g_wse.wse10 CLIPPED, " = '", p_status CLIPPED, "'",
                      " WHERE ",  g_wse.wse03 CLIPPED, " = '", g_formNum CLIPPED, "'"
          IF LENGTH(l_wc) != 0 THEN
             LET g_sql = g_sql CLIPPED, l_wc
          END IF
 
          EXECUTE IMMEDIATE g_sql
 
          display "Master Update SQL:", g_sql
          display "SQLCA.SQLCODE:",SQLCA.SQLCODE
          display "SQLCA.SQLERRD[3]:",SQLCA.SQLERRD[3]
 
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN   #SQL 執行失敗
             CALL cl_err("Update wsf failed: ", SQLCA.SQLCODE, 0)
             SELECT ze03 INTO l_ze03 FROM ze_file
                WHERE ze01 = 'aws-084' AND ze02 = l_lang
             LET l_str = l_ze03 CLIPPED," Update ", g_wse.wse10 CLIPPED, " faile: ", SQLCA.SQLCODE ,"."
             LET g_ef_sql = g_sql
             LET g_ef_sqlcode = SQLCA.SQLCODE
             IF g_action_choice = "deny" OR g_action_choice = "org_withdraw" THEN    #CHI-BC0010
                CLOSE upd_lock                                                       #CHI-BC0010
                ROLLBACK WORK                                                        #CHI-BC0010
             END IF                                                                  #CHI-BC0010
             RETURN 0,l_str
          END IF
          
          #更新單身檔狀態碼
          SELECT MAX(wsf02) INTO l_cnt FROM wsf_file WHERE wsf01 = p_prog 
          IF l_cnt > 0 THEN
             FOR l_i = 1 TO l_cnt
                SELECT * INTO g_wsf.* FROM wsf_file WHERE wsf01 = p_prog AND wsf02 = l_i
                IF SQLCA.SQLCODE OR SQLCA.SQLCODE = NOTFOUND THEN
#                  CALL cl_err("select wsf failed: ", SQLCA.SQLCODE, 0)   #No.FUN-660155
                   CALL cl_err3("sel","wsf_file",p_prog,l_i,SQLCA.sqlcode,"","select wsf failed", 0)   #No.FUN-660155)   #No.FUN-660155
                   SELECT ze03 INTO l_ze03 FROM ze_file
                      WHERE ze01 = 'aws-085' AND ze02 = l_lang
                   LET l_str = l_ze03 CLIPPED," select wsf failed: ", SQLCA.SQLCODE  ,"."
                   IF g_action_choice = "deny" OR g_action_choice = "org_withdraw" THEN    #CHI-BC0010
                      CLOSE upd_lock                                                       #CHI-BC0010
                      ROLLBACK WORK                                                        #CHI-BC0010
                   END IF                                                                  #CHI-BC0010
                   RETURN 0,l_str
                END IF
             
                IF (g_wsf.wsf03 CLIPPED IS NOT NULL) AND 
                   (g_wsf.wsf04 CLIPPED IS NOT NULL) AND
                   (g_wsf.wsf09 CLIPPED IS NOT NULL) THEN
                   LET g_sql = "UPDATE ", g_wsf.wsf03 CLIPPED, " SET ",
                               g_wsf.wsf09 CLIPPED, " = '", p_status CLIPPED, "'",
                               " WHERE ",  g_wsf.wsf04 CLIPPED, " = '", g_formNum CLIPPED, "'"
                   IF LENGTH(l_wc) != 0 THEN
                      LET g_sql = g_sql CLIPPED, l_wc
                   END IF
 
                   EXECUTE IMMEDIATE g_sql
 
                   display "Detail Update SQL:", g_sql
                   display "SQLCA.SQLCODE:",SQLCA.SQLCODE
                   display "SQLCA.SQLERRD[3]:",SQLCA.SQLERRD[3]
                   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN   #SQL 執行失敗
                      CALL cl_err("Update wsf failed: ", SQLCA.SQLCODE, 0)
                      SELECT ze03 INTO l_ze03 FROM ze_file
                         WHERE ze01 = 'aws-085' AND ze02 = l_lang
                      LET l_str = l_ze03 CLIPPED," select wsf failed: ", SQLCA.SQLCODE  ,"."
                      LET g_ef_sql = g_sql
                      LET g_ef_sqlcode = SQLCA.SQLCODE
                      IF g_action_choice = "deny" OR g_action_choice = "org_withdraw" THEN    #CHI-BC0010
                         CLOSE upd_lock                                                       #CHI-BC0010
                         ROLLBACK WORK                                                        #CHI-BC0010
                      END IF                                                                  #CHI-BC0010
                      RETURN 0,l_str
                   END IF
                ELSE
                   EXIT FOR
                END IF
             END FOR  
          END IF
          IF g_action_choice = "deny" OR g_action_choice = "org_withdraw" THEN    #CHI-BC0010 
             CLOSE upd_lock                                                       #CHI-BC0010 
             COMMIT WORK                                                          #CHI-BC0010
          END IF                                                                  #CHI-BC0010
          RETURN 1,''
END FUNCTION
#END FUN-640184
 
#MOD-690128
FUNCTION aws_efapp_wc_key(p_formNum)
    DEFINE p_formNum   STRING
    DEFINE l_tok       base.StringTokenizer
    DEFINE l_tok_key   base.StringTokenizer
    DEFINE l_wc        STRING
    DEFINE l_str       STRING
    DEFINE l_str2      STRING
    DEFINE l_cnt       LIKE type_file.num10
    DEFINE l_cnt2      LIKE type_file.num10
    DEFINE l_key_str   STRING
    DEFINE buf         base.StringBuffer
 
    LET l_wc = ""
    LET l_str = ""
 
    LET buf = base.StringBuffer.create()
    CALL buf.append(p_formNum)
    CALL buf.replace( "{+}","|", 0)
    LET p_formNum = buf.toString()
 
    LET l_tok = base.StringTokenizer.createExt(p_formNum CLIPPED,"|","",TRUE)
    LET l_cnt = 0
    WHILE l_tok.hasMoreTokens()
         LET l_str = l_tok.nextToken()
         IF l_cnt = 0 THEN
            LET l_cnt = 1
         ELSE
            LET l_tok_key = base.StringTokenizer.createExt(l_str CLIPPED,"=","",TRUE)
            LET l_cnt2 = 0
            WHILE l_tok_key.hasMoreTokens()
                 LET l_str2 = l_tok_key.nextToken()
                 IF l_cnt2 = 0 THEN
                    LET l_cnt2 = 1
                    LET l_key_str = l_str2
                 ELSE
                    LET l_key_str = l_key_str ,"='",l_str2,"'"
                 END IF
            END WHILE
            LET l_wc = l_wc ," AND ",l_key_str
         END IF
    END WHILE
    RETURN l_wc
 
END FUNCTION
 
FUNCTION aws_efapp_key(p_str,p_key)
    DEFINE p_str       STRING
    DEFINE p_key       LIKE type_file.num10
    DEFINE l_tok       base.StringTokenizer
    DEFINE l_str       STRING
    DEFINE l_str2      STRING
    DEFINE l_cnt       LIKE type_file.num10 
    DEFINE buf         base.StringBuffer
 
    LET l_str = ""
 
    LET buf = base.StringBuffer.create()
    CALL buf.append(p_str)
    CALL buf.replace( "{+}","|", 0)
    LET p_str = buf.toString()
 
    LET l_tok = base.StringTokenizer.createExt(p_str CLIPPED,"|","",TRUE)
    LET l_cnt = 0
    WHILE l_tok.hasMoreTokens()
         LET l_cnt = l_cnt + 1
         LET l_str = l_tok.nextToken()
         IF l_cnt = p_key THEN
             LET l_str2 = l_str
             EXIT WHILE
         END IF
    END WHILE
    RETURN l_str2
 
END FUNCTION
 
FUNCTION aws_efapp_key_value(p_formNum,p_key)
    DEFINE p_formNum   STRING
    DEFINE p_key       LIKE type_file.num10
    DEFINE l_tok       base.StringTokenizer
    DEFINE l_tok_key   base.StringTokenizer
    DEFINE l_wc        STRING
    DEFINE l_str       STRING
    DEFINE l_str2      STRING
    DEFINE l_cnt       LIKE type_file.num10
    DEFINE l_cnt2      LIKE type_file.num10
    DEFINE l_key_str   STRING
    DEFINE buf         base.StringBuffer
 
    LET l_wc = ""
    LET l_str  = ""
    LET l_str2 = ""
 
    LET buf = base.StringBuffer.create()
    CALL buf.append(p_formNum)
    CALL buf.replace( "{+}","|", 0)
    LET p_formNum = buf.toString()
 
    LET l_tok = base.StringTokenizer.createExt(p_formNum CLIPPED,"|","",TRUE)
    LET l_cnt = 0
    WHILE l_tok.hasMoreTokens()
         LET l_cnt = l_cnt + 1
         LET l_str = l_tok.nextToken()
         IF l_cnt = p_key THEN
             IF l_cnt > 0 THEN
                LET l_tok_key = base.StringTokenizer.createExt(l_str CLIPPED,"=","",TRUE)
                WHILE l_tok_key.hasMoreTokens()
                     LET l_str2 = l_tok_key.nextToken()
                END WHILE
             ELSE
                LET l_str2 = l_str
             END IF
             EXIT WHILE
         END IF
         LET l_str2 = ""
         LET l_str = ""
    END WHILE
    RETURN l_str2
 
END FUNCTION
#END MOD-690128
 
#FUN-7C0003 
FUNCTION aws_efapp_name(p_id)
DEFINE p_id      LIKE gen_file.gen01
DEFINE l_name    LIKE gen_file.gen02
DEFINE l_str     STRING
 
    LET l_str = p_id CLIPPED
 
    SELECT gen02 INTO l_name FROM gen_file WHERE gen01=p_id
    IF cl_null(l_name) THEN
       SELECT zx02 INTO l_name FROM zx_file WHERE zx01=p_id
    END IF 
    IF NOT cl_null(l_name) THEN
       LET l_str = l_str CLIPPED,"_",l_name CLIPPED
    END IF
 
    RETURN l_str
END FUNCTION
 
FUNCTION aws_efapp_getid(p_str)
DEFINE p_str    STRING
DEFINE l_str    STRING
 
    IF p_str.getIndexOf('_',1) > 0 THEN
       LET l_str = p_str.subString(1,p_str.getIndexOf('_',1)-1) 
    ELSE
       LET l_str = p_str
    END IF
 
    RETURN l_str
END FUNCTION 
#END FUN-7C0003 

#FUN-880099 --start
FUNCTION aws_efgpapp_formInfo(p_efgp,p_forminfo,p_intfilter,p_strfilter,p_curr_page,p_page_size)    #FUN-7C0094
DEFINE  p_efgp DYNAMIC ARRAY OF RECORD
            ef21     LIKE wsk_file.wsk04, #TIPTOP 單別 CHAR(5)
            ef22     LIKE wsk_file.wsk05, #TIPTOP 單號 CHAR(80)
            ef23     LIKE wsk_file.wsk03, #TIPTOP 程式代號 CHAR(10)
            ef24     LIKE wsk_file.wsk08, #EasyFlow 單別
            ef25     STRING,              #重要性
            ef26     STRING,              #表單關係人 =>FormOwnerID
            ef27     STRING,              #簽核狀態
            ef28     STRING,              #流程名稱
            ef29     STRING,              #workItemName
            ef30     STRING,              #主旨 =>subject    
            ef31     LIKE wsk_file.wsk09, #流程OID =>processOID
            ef32     STRING,              #流程序號 =>processSN 
            ef33     STRING,              #發起者
            ef331    STRING,              #流程關係人 =>relationshipName
            ef34     STRING,              #來源
            ef35     LIKE azg_file.azg06, #工作事項OID =>workItemOID
            ef36     STRING,              #建立時間 =>createdTime
            ef37     STRING               #讀取次數
        END RECORD
DEFINE l_items      STRING,
       lch_cmd      base.Channel,
       l_file       STRING,              
       l_pid        STRING,
       l_cmd        STRING,
       l_i          LIKE type_file.num10,
       l_x          LIKE type_file.num10,
       l_str        STRING,
       l_azg06      LIKE wsk_file.wsk09,
       l_cnt        LIKE type_file.num5
       

DEFINE  p_forminfo        LIKE type_file.chr1000,                        #CHAR(50)
        p_strfilter       LIKE type_file.chr1000,                        #CHAR(50)
        p_intfilter       LIKE type_file.chr1000,                        #CHAR(50)
        p_curr_page       LIKE type_file.num10,  # Current Page Number   #INTEGER
        p_total_page      LIKE type_file.num10,                          #NTEGER
        p_page_size       LIKE type_file.num10,   # Page Size  
        l_azp052          LIKE azp_file.azp052,
        l_tag             STRING
DEFINE  l_cross_status    LIKE type_file.num5     #No.FUN-B30003

    WHENEVER ERROR CALL cl_err_msg_log
    
    CALL aws_efapp_XMLHeader("GetFormInfo")

    SELECT azp052 INTO l_azp052 FROM azp_file where azp01=g_plant
   
    IF cl_null(p_intfilter) THEN
         LET l_tag = ""
    ELSE      
      LET l_tag = "           <TargetRead>",p_intfilter CLIPPED,"</TargetRead>", ASCII 10
    END IF    
  
    LET g_strXMLInput =  g_strXMLInput CLIPPED,
        "           <PlantID>",g_plant CLIPPED,"</PlantID>", ASCII 10,
        "           <TargetFormKind>",p_forminfo CLIPPED,"</TargetFormKind>", ASCII 10,
        "           <TargetProcessID>",p_strfilter CLIPPED,"</TargetProcessID>", ASCII 10,        
        "           <TimeZone>",l_azp052,"</TimeZone>", ASCII 10, l_tag,
        "           <TargetCurrentPage>",p_curr_page USING '<<<<<<<<<<',"</TargetCurrentPage>", ASCII 10,       
        "           <TargetPageSize>",p_page_size USING '<<<<<<<<<<',"</TargetPageSize>", ASCII 10  
        
    CALL aws_efapp_XMLTrailer()
   
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
       CALL aws_cross_invokeSrv(l_str,"GetFormInfo","sync",g_strXMLInput) 
            RETURNING l_cross_status, l_status, l_Result
       IF NOT l_cross_status  THEN
          LET p_curr_page = 1
          LET p_total_page = 1
          RETURN 0,p_curr_page,p_total_page
       END IF
    ELSE
    #No:FUN-B30003 -- end --
       LET EFGPGateWay_soapServerLocation = g_efsoap        #指定EasyFlowGP的SOAP網址
    
       CALL fgl_ws_setOption("http_invoketimeout", 60)      #若 60 秒內無回應則放棄
    
  
       CALL EFGPGateWay_EasyFlowGPGateWay(g_strXMLInput)    #連接 EasyFlowGP SOAP server
             RETURNING l_status, l_Result
    END IF   #No:FUN-B30003
  
  
    
    CALL aws_efapp_file(l_status) #紀錄傳入 EasyFlow 的字串 
  
    IF l_status = 0 THEN
       IF (aws_xml_getTag(l_Result, "ReturnStatus") != 'Y') OR
          (aws_xml_getTag(l_Result, "ReturnStatus") IS NULL) THEN

          IF aws_xml_getTag(l_Result, "ReturnStatus") IS NULL THEN
               LET l_str = l_Result
          ELSE
               LET l_str = aws_xml_getTag(l_Result, "ReturnDescribe")
          END IF
          IF fgl_getenv('FGLGUI') = '1' THEN
             LET l_str = "XML parser error:\n\n", l_str
          ELSE
             LET l_str = "XML parser error: ", l_str
          END IF

          CALL cl_err(l_str, '!', 1)   #XML 字串有問題
          LET p_curr_page = 1
          LET p_total_page = 1
          RETURN 0,p_curr_page,p_total_page
       END IF

       LET l_file = FGL_GETPID() USING '<<<<<<<<<<'
       LET l_file = "aws_efapp_formID_",l_file CLIPPED,".xml"

       LET buf = base.StringBuffer.create()
       CALL buf.append(l_Result)
       CALL buf.replace( "&amp;", "&", 0)
       LET l_Result = buf.toString()
       LET channel = base.Channel.create()
       CALL channel.openFile(l_file, "w")
       CALL channel.setDelimiter("") 
       CALL channel.write(l_Result)
       CALL channel.close()
       LET l_cmd = "chmod 777 ",l_file CLIPPED," 2>/dev/null"
       RUN l_cmd

       LET g_sql="SELECT azg01,azg09 FROM azg_file WHERE azg04='1' and azg06=?"
       PREPARE efgp_prepare FROM g_sql
       DECLARE efgp_cs  SCROLL CURSOR FOR efgp_prepare

       LET l_items = "All"
       LET dom_doc = om.DomDocument.createFromXmlFile(l_file)
       LET n = dom_doc.getDocumentElement()
       LET nl_record = n.selectByTagName("Record")
       LET g_cnt = nl_record.getLength()
       LET l_x = 1
       FOR l_i = 1 to g_cnt              
           LET n_record = nl_record.item(l_i)
           LET p_efgp[l_x].ef25 = n_record.getAttribute("prsInsLvlName")           
           LET p_efgp[l_x].ef27 = n_record.getAttribute("currentState")
           LET p_efgp[l_x].ef28 = n_record.getAttribute("processName")        
           LET p_efgp[l_x].ef29 = n_record.getAttribute("workItemName")
           LET p_efgp[l_x].ef30 = n_record.getAttribute("subject") 
           LET p_efgp[l_x].ef31 = n_record.getAttribute("processOID")     #targetSheetNo
           LET p_efgp[l_x].ef32 = n_record.getAttribute("processSN")
           LET p_efgp[l_x].ef33 = n_record.getAttribute("requesterName")
           LET p_efgp[l_x].ef331 = n_record.getAttribute("relationshipName")  # 表單關係人
           LET p_efgp[l_x].ef34 = n_record.getAttribute("assignmentType") #來源
           LET p_efgp[l_x].ef35 = n_record.getAttribute("workItemOID")        
           LET p_efgp[l_x].ef36 = n_record.getAttribute("createdTime")        
           LET p_efgp[l_x].ef37 = n_record.getAttribute("viewTimes")        
           OPEN efgp_cs USING p_efgp[l_x].ef31           
           FETCH efgp_cs  INTO p_efgp[l_x].ef22 ,p_efgp[l_x].ef23
        
           #No.TQC-A50153 -- start --
           #非udm_tree取得資料，而是單據程式簽完後取得下一張的表單
           #符合此單據程式即可離開迴圈, 增加處理效能
           IF p_efgp[l_x].ef23 CLIPPED = g_prog CLIPPED THEN
              EXIT FOR 
           END IF 
           #No.TQC-A50153 -- end --

           LET l_x = l_x + 1
       END FOR

       LET l_cmd = "rm ",l_file CLIPPED," 2>/dev/null"  
       RUN l_cmd
       LET p_curr_page = aws_xml_getTag(l_Result, "TargetCurrentPage")
       LET p_total_page = aws_xml_getTag(l_Result, "TargetTotalPage")
       IF p_total_page = 0 THEN
            LET p_curr_page = 1
            LET p_total_page = 1
       END IF
       RETURN 1,p_curr_page,p_total_page

    ELSE
       IF fgl_getenv('FGLGUI') = '1' THEN
          LET l_str = "Connection failed:\n\n", 
                   "  [Code]: ", wserror.code, "\n",
                   "  [Action]: ", wserror.action, "\n",
                   "  [Description]: ", wserror.description
       ELSE
          LET l_str = "Connection failed: ", wserror.description
       END IF
       CALL cl_err(l_str, '!', 1)   #連接失敗
       LET p_curr_page = 1
       LET p_total_page = 1
       RETURN 0,p_curr_page,p_total_page
    END IF

END FUNCTION
#FUN-880099 --end

#No:FUN-A30047 -- start --
FUNCTION aws_efapp_act_status(p_name,p_value)
DEFINE p_name  STRING
DEFINE p_value LIKE type_file.num5
DEFINE l_i   LIKE type_file.num5

    LET l_i = g_approve_act.getLength() + 1

    LET g_approve_act[l_i].name  =  p_name
    LET g_approve_act[l_i].value =  p_value
END FUNCTION
#No:FUN-A30047 -- end --

#FUN-A80087 add str ----------
FUNCTION aws_efapp_getEFLogonID()
    DEFINE l_EFLogonID     STRING

    LET l_EFLogonID = FGL_GETENV("EFLogonID")
    RETURN l_EFLogonID
END FUNCTION
#FUN-A80087 add end ----------
#FUN-B80064
