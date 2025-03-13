# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Library name...: aws_efcli2
# Descriptions...: 透過 Web Services 將 TIPTOP 表單與 EasyFlow 整合
# Input parameter: p_head    表頭資料
#                  p_body1   單身資料1
#                  p_body2   單身資料2
#                  p_body3   單身資料3
#                  p_body4   單身資料4
#                  p_body5   單身資料5
# Return code....: '0' 表單開立不成功
#                  '1' 表單開立成功
# Usage .........: call aws_efcli2(p_head, p_body1, p_body2, p_body3, p_body4, p_body5)
# Date & Author..: 05/05/04 By Echo
# Modify.........: No.FUN-550075 05/05/18 By Echo 新增EasyFlow站台設定
# Modify.........: No.MOD-560007 05/06/02 By Echo 重新定義FUN名稱
# Modify.........: No.FUN-570230 05/07/29 By Echo 將開單的pid存至aws_efcli2-日期.log
# Modify.........: No.MOD-580132 05/08/12 By Echo update單據狀態值失敗後必須RETURN 0 (將mark拿掉)
# Modify.........: No.FUN-580011 05/08/19 By Echo 判斷當單據不需簽核時，選擇「簽核狀況」應提示訊息
# Modify.........: No.MOD-590183 05/09/12 By Echo 定義單別為char(3)放大為char(5)
# Modify.........: No.FUN-660155 06/06/22 By Czl cl_err --> cl_err3
# Modify.........: No.TQC-660062 06/06/29 By Pengu 程式段有用到azu_file的地方全部delete掉
# Modify.........: No.FUN-680130 06/09/01 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No.MOD-690128 06/11/10 By Echo 調整{+}分隔符號時的程式段落，修正組where的條件。
# Modify.........: No.FUN-6B0024 06/12/25 By Echo 加強防範 TIPTOP & EasyFlow 狀態碼不一致,
#                                                 若未收到EasyFlow回傳的訊息，且重覆呼叫3次
# Modify.........: No.FUN-710010 07/01/16 By chingyuan TIPTOP與EasyFlow GP整合
# Modify.........: No.MOD-720032 07/02/06 By Smapmin 除了狀況碼不為S1WR且未確認外,其餘皆可查看簽核狀況
# Modify.........: No.FUN-720042 07/02/21 By Brendan Genero 2.0 整合
# Modify.........: No.TQC-720066 07/02/28 By Echo 抓取 UI 畫面欄位值時，欄位名稱應為 colName 屬性，無 colName 屬性時才以抓取 name 屬性
# Modify.........: No.FUN-710063 07/05/14 By Echo XML 特殊字元處理功能
# Modify.........: No.FUN-750113 07/05/29 By JackLai 與EasyFlowGP整合時<OrgUnitID>這個標籤應由目前的送簽人部門改為表單關係人的部門
# Modify.........: No.TQC-750259 07/06/04 By Echo 增加記錄 SOAP error 錯誤訊息
# Modify.........: No.TQC-760155 07/06/20 By JackLai 修正傳送多個相關文件到 EasyFlowGP 時, 第二個附件之後檔案的副檔名不正確
# Modify.........: No.FUN-790020 07/09/11 By Brendan 修正 GP 5X Primary Key 功能時無法正確處理相關文件
# Modify.........: No.FUN-770047 07/09/26 by Echo 新增整合-備註功能
# Modify.........: No.FUN-780049 07/09/26 By Echo 若回傳不完整的XML格式字串或錯誤訊息時，則直接顯示對方回傳的資料
# Modify.........: No.FUN-7C0055 07/12/19 By Echo 調整 timeout 訊息
# Modify.........: No.FUN-860073 08/06/19 By Echo EF GP 傳遞附件內容時，增加原始檔名的tag
# Modify.........: No.MOD-890129 08/09/15 By Smapmin 將原先抓取畫面上的值來判斷合理性的部份,改為抓取實體資料庫的值
# Modify.........: No.MOD-890161 08/09/18 By Smapmin 組夾檔資料的XML之前,先將XML字串做轉換.
# Modify.........: No.FUN-890073 08/09/18 By Vicky 設定開單送簽時，告知 EasyFlow 附件個數
# Modify.........: No.FUN-930133 09/03/25 By Vicky 送簽時將 wsc_file 中的簽核流程資訊清除，避免送簽中列印報表時列印出舊的簽核資訊
# Modify.........: No.FUN-960137 09/06/18 By Vicky Request字串增加TIPTOP主機資訊 (多TP 對 一EF GP)
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:CHI-9C0016 09/12/09 By Dido gae_file key值調整 
# Modify.........: No:MOD-A50176 10/05/27 By sabrina "export COLUMNS=132...."這句語法在SUN機器執行時會有錯誤
# Modify.........: No:FUN-940120 10/09/15 By Jay 增加開單時控管，呼叫EF開單之前先lock資料
# Modify.........: No:FUN-B10061 11/01/27 By jrg542 把呼叫cl_doc.4gl cl_getcl_getfileextension 改成os.Path.extension() 
# Modify.........: No:FUN-B20029 11/04/01 By Echo TIPTOP 與 CROSS 整合功能: 透過 CROSS 平台串接 EasyFlow  
# Modify.........: No:FUN-B30160 11/06/17 By Jenjwu 於送簽CreatForm的xml中，增加Language節點，以便EF判斷應載入哪個ColumntSet檔進行解析 
# Modify.........: No:FUN-B90032 11/09/05 By minpp 程序撰写规范修改
# Modify.........: No:MOD-BA0203 11/10/28 By suncx 如果遇到TextEdit型備注欄位，內容出現換行時，轉到E-F系統只會顯示備注的最后一行
# Modify.........: No:FUN-BB0061 11/11/10 By Jay EasyFlow送簽時針對數值資料增加XML tag內容
# Modify.........: No:CHI-BC0010 11/12/20 By ka0132 調整維護單頭,單身欄位功能
# Modify.........: No:TQC-BC0167 11/12/29 By ka0132 非hard code程式欄位輸出異常 
# Modify.........: No:FUN-C40086 12/05/29 By Kevin 資安欄位傳送
# Modify.........: No:FUN-C40061 12/07/09 By Kevin (1)使用 gcb13 當作是上傳者
#                                                  (2)定義 |eol| 表示跳行符號
# Modify.........: No:FUN-C70031 12/07/10 By Kevin cl_err開單成功移到 Commit work 之後執行
# Modify.........: No.CHI-C70021 12/07/25 By Kevin 調整 wsc15 程式代號,當做刪除條件
# Modify.........: No:FUN-CA0078 13/01/11 By zack 檢查Record 和 table 筆數是否一致

IMPORT com   #FUN-720042
IMPORT os   #No.FUN-9C0009  
DATABASE ds
#FUN-720042
 
GLOBALS "../4gl/aws_efgw.inc"
GLOBALS "../4gl/awsef.4gl"
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_efgpgw.inc"         #No.FUN-710010
GLOBALS "../4gl/aws_crossgw.inc"        #No:FUN-B20029
GLOBALS                                 #FUN-C40086 start 
   DEFINE g_data_mask  DYNAMIC ARRAY OF RECORD
              field     STRING,
              datavalue STRING
          END RECORD

END GLOBALS                             #FUN-C40086 end
 
DEFINE g_wse         RECORD LIKE wse_file.*
DEFINE g_wsf         RECORD LIKE wsf_file.*
DEFINE g_wsi         RECORD LIKE wsi_file.*
DEFINE g_wap         RECORD LIKE wap_file.*         #No:FUN-B20029
DEFINE channel       base.Channel
DEFINE g_wse03       LIKE wse_file.wse03
DEFINE g_wse04       LIKE wse_file.wse04
DEFINE g_wse05       LIKE wse_file.wse05
DEFINE g_wse06       LIKE wse_file.wse06
DEFINE g_wse07       LIKE wse_file.wse07
DEFINE g_efsoap      STRING
DEFINE g_formNum_key VARCHAR(100)                   #FUN-770047
#DEFINE g_formid     VARCHAR(5)             #MOD-590183
 
FUNCTION aws_efcli2(p_formNum)
DEFINE p_head                om.DomNode
DEFINE p_body1               om.DomNode
DEFINE p_body2               om.DomNode
DEFINE p_body3               om.DomNode
DEFINE p_body4               om.DomNode
DEFINE p_body5               om.DomNode
DEFINE p_formNum             LIKE wse_file.wse03    #No.FUN-680130 VARCHAR(20)
DEFINE l_status              LIKE type_file.num10,  #No.FUN-680130 INTEGER
       l_str                 STRING,
       l_sql                 STRING,
       l_Result              STRING
DEFINE l_i                 LIKE type_file.num10,  #No.FUN-680130 INTEGER
       l_wc                 STRING,
       l_p1                  LIKE type_file.num10,  #No.FUN-680130 INTEGER
       l_p2                  LIKE type_file.num10,  #No.FUN-680130 INTEGER
       l_tag                 STRING,
       l_formNum             STRING
DEFINE buf                   base.StringBuffer            
DEFINE l_file                STRING,                #FUN-520020
       l_pid                 STRING,
       l_cmd                 STRING,
       lch_cmd               base.Channel,
       ls_result             STRING
DEFINE lnode_item            om.DomNode
DEFINE l_window              ui.Window 
DEFINE l_value               STRING
DEFINE i                     LIKE type_file.num10,  #No.FUN-680130 INTEGER
       l_cnt                 LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE l_wsd02               LIKE wsd_file.wsd02
DEFINE l_wse03               LIKE wse_file.wse03
DEFINE l_ze03                LIKE ze_file.ze03              #FUN-6B0024
#TQC-720066
DEFINE ln_w                  om.DomNode
DEFINE nl_node               om.NodeList
DEFINE l_name                STRING
#END TQC-720066
DEFINE l_FormStatus          LIKE type_file.chr1    #No.FUN-940120 add 
DEFINE l_cross_status        LIKE type_file.num5    #No.FUN-B20029

    WHENEVER ERROR CALL cl_err_msg_log
    
    SELECT wsd02 INTO l_wsd02 FROM wsd_file where wsd01 = g_prog
    SELECT wse03,wse04,wse05,wse06,wse07 INTO g_wse03,g_wse04,g_wse05,g_wse06,g_wse07
           FROM wse_file where wse01 = g_prog

    LET g_formNum = p_formNum
    LET g_formNum_key = g_formNum
    let g_wse04 = null
    let g_wse05 = null
    let g_wse06 = null
    let g_wse07 = null
 
    IF l_wsd02 = 'Y' THEN
          CALL aws_efcli2_cf()           #Hard-Code
         #  run "echo ' line 255 "||g_strXMLInput||"' >> /u1/out/darcy.log"
          display "test"
         #  CALL aws_efcli2_format()       #NO.FUN-BB0061
         #  run "echo ' line 258 "||g_strXMLInput||"' >> /u1/out/darcy.log"
    ELSE           
          CALL aws_efcli2_setcf(p_head,p_body1,p_body2,p_body3,p_body4,p_body5)   #組傳入 EasyFlow 的 XML 資料
    END IF
    IF g_strXMLInput = '' OR g_strXMLInput IS NULL THEN
      #  run "echo ' line 264 ' >> /u1/out/darcy.log"
       RETURN 0
    END IF
 
    #MOD-690128 
    #若單號(g_formNum) 包含其他條件則擷取出來(以{+} 為區隔)
    #LET l_wc = ""
    #LET l_i = 1
    #LET l_tag = "{+}"
    #LET l_formNum = g_formNum
    #LET l_p1 = l_formNum.getIndexOf(l_tag,1)
    #IF l_p1 != 0 THEN
    # WHILE l_i <= LENGTH(l_formNum)
    #  LET l_p1 = l_formNum.getIndexOf(l_tag,l_i)
    #  LET l_p2 = l_formNum.getIndexOf(l_tag,l_p1+3)
 
    #  IF l_p2 = 0 THEN
    #     LET l_wc = l_wc CLIPPED," AND ", l_formNum.subString(l_p1+l_tag.getLength(),l_formNum.getLength())
    #     EXIT WHILE
    #  ELSE
    #     LET l_wc = l_wc CLIPPED," AND ", l_formNum.subString(l_p1+l_tag.getLength(),l_p2-1)
    #  END IF
 
    #  LET l_i = l_p2 - 1
 
    # END WHILE
    #END IF
 
     CALL aws_efapp_wc_key(g_formNum CLIPPED) RETURNING l_wc
    #--FUN-940120--start--
    #呼叫EF開單之前，先將資料lock，若lock失敗就不送簽
    SELECT * INTO g_wse.* FROM wse_file where wse01 = g_prog
    IF SQLCA.SQLCODE OR SQLCA.SQLCODE = NOTFOUND THEN
      #  run "echo ' line 297 ' >> /u1/out/darcy.log"
       CALL cl_err3("sel","wse_file",g_prog,"",SQLCA.sqlcode,"","select wse fail:", 0)
       RETURN 0
    END IF
   #  run "echo ' line 300 ' >> /u1/out/darcy.log"
    BEGIN WORK
    LET l_sql = "SELECT ",g_wse.wse10 CLIPPED,
                 " FROM ",g_wse.wse02 CLIPPED,
                " WHERE ",g_wse.wse03 CLIPPED,"= ?"
    IF LENGTH(l_wc) != 0 THEN
       LET l_sql = l_sql CLIPPED, l_wc
    END IF
    LET l_sql = l_sql CLIPPED, " FOR UPDATE"
    LET l_sql = cl_forupd_sql(l_sql)
    DECLARE ef_status_cl CURSOR FROM l_sql
   #  run "echo ' line 311 ' >> /u1/out/darcy.log"
    LET l_FormStatus = ""
   #  run "echo ' line 313 ' >> /u1/out/darcy.log"
   #  run "echo ' line 316 l_sql "||l_sql||" g_formNum_key "||g_formNum_key||"' >> /u1/out/darcy.log"
    if cl_null(g_formNum_key) then let g_formNum_key=g_formNum end if #darcy:2023/05/22 add
    OPEN ef_status_cl USING g_formNum_key
    IF STATUS THEN
       CALL cl_err("OPEN ef_status_cl:", STATUS, 1)
       CLOSE ef_status_cl
       ROLLBACK WORK
      #  run "echo ' line 316 ' >> /u1/out/darcy.log"
       RETURN 0
    END IF
    FETCH ef_status_cl INTO l_FormStatus
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_formNum_key,SQLCA.sqlcode,1)     # 資料被他人LOCK
       CLOSE ef_status_cl
       ROLLBACK WORK
      #  run "echo ' line 324 ef_status_cl sql "||l_sql||" key "||g_formNum_key||"' >> /u1/out/darcy.log"
       RETURN 0
    END IF
    DISPLAY "StatusValueBeforeCreateForm:", l_FormStatus
    #--FUN-940120--end--
 
    #END MOD-690128
 
  ###轉換 & 為 &amp; 
    #FUN-710063
    #LET buf = base.StringBuffer.create()
    #CALL buf.append(g_strXMLInput)
    #CALL buf.replace( "&","&amp;", 0)
    #LET g_strXMLInput = buf.toString()
    #LET g_strXMLInput = aws_xml_replace(g_strXMLInput)   #MOD-890161
    #END FUN-710063
  
    #LET EFGateWay_soapServerLocation = g_efsoap  #指定 Soap server location
    
    #No.FUN-710010 --start--
    IF g_aza.aza72 = 'N' THEN 
        LET EFGateWay_soapServerLocation = g_efsoap    #指定 Soap server location
    ELSE #指定EasyFlowGP的SOAP網址
        LET EFGPGateWay_soapServerLocation = g_efsoap  #指定 Soap server location
    END IF
    #No.FUN-710010 --end--
    
    #FUN-6B0024
    FOR l_i = 1 TO 4

        #No:FUN-B20029 -- start --
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
           CALL aws_cross_invokeSrv(l_str,"CreateForm","sync",g_strXMLInput) 
                RETURNING l_cross_status, l_status, l_Result
           IF NOT l_cross_status  THEN
              CLOSE ef_status_cl  
              ROLLBACK WORK       
            #   run "echo ' line 371 ' >> /u1/out/darcy.log"
              RETURN 0
           END IF
        ELSE
           CALL fgl_ws_setOption("http_invoketimeout", 60)     #若 60 秒內無回應則放棄
           #CALL EFGateWay_TipTopCoordinator(g_strXMLInput)    #連接 EasyFlow SOAP server
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
        END IF
        #No:FUN-B20029 -- end --
         # run " echo ' 395 \n xml "||g_strXMLInput||"\n out "||l_status||" \n re " ||l_Result||"'"
       #IF NOT (l_status = 1 AND wsError.description= "Timeout reached.")
        IF NOT (l_status !=0 AND (wsError.description.getIndexOF("reached timeout",1) > 0))  #FUN-7C0055
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
 
    #紀錄傳入 EasyFlow 的字串
    LET channel = base.Channel.create()
    LET l_file = "aws_efcli2-", TODAY USING 'YYYYMMDD', ".log"
    CALL channel.openFile(l_file, "a")
 
    IF STATUS = 0 THEN
       CALL channel.setDelimiter("")
       LET l_str = "#--------------------------- (", CURRENT YEAR TO SECOND, ") ----------------------------#"
       CALL channel.write(l_str)
       CALL channel.write("")
       LET l_str = "Program: ", g_prog CLIPPED
       CALL channel.write(l_str)
       LET l_str = "Form Number: ", g_formNum CLIPPED          #FUN-770047
       CALL channel.write(l_str)
       CALL channel.write("")
       #FUN-570230
       LET l_str = "GETPID: "
       CALL channel.write(l_str)
       LET l_pid = FGL_GETPID() USING '<<<<<<<<<<'
      #LET l_cmd = "export COLUMNS=132; ps -ef | grep ",l_pid," | grep -v 'grep'"    #MOD-A50176 mark
       LET l_cmd = "COLUMNS=132; export COLUMNS; ps -ef | grep ",l_pid," | grep -v 'grep'"    #MOD-A50176 add
       LET lch_cmd = base.Channel.create()
       CALL lch_cmd.openPipe(l_cmd, "r")
       WHILE lch_cmd.read(ls_result)
              CALL channel.write(ls_result)
       END WHILE
       CALL lch_cmd.close()   #No:FUN-B90032
       CALL channel.write("")
       #END FUN-570230
 
       CALL channel.write("Request XML:")
       CALL channel.write(g_strXMLInput)
       CALL channel.write("")
 
       #紀錄 EasyFlow 回傳的資料
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
#      #RUN "chmod 666 l_file CLIPPED >/dev/null 2>/dev/null"     #NO.FUN-520020
#       LET l_cmd = "chmod 666 ", l_file CLIPPED, " >/dev/null 2>/dev/null" #MOD-560007 #No.FUN-9C0009
#      RUN l_cmd                                          #No.FUN-9C0009
       IF os.Path.chrwx(l_file CLIPPED,438) THEN END IF   #No.FUN-9C0009
    ELSE
       DISPLAY "Can't open log file."
    END IF
 
 ## END No.FUN-520020  
  
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
          CLOSE ef_status_cl   #FUN-940120
          ROLLBACK WORK        #FUN-940120
         #  run "echo ' line 504 ' >> /u1/out/darcy.log"
          RETURN 0
       END IF
       
       #No.FUN-710010 --start--
       #若與EasyFlowGP整合, 則無須處理 ActionStatus
       IF g_aza.aza72 = 'N' THEN
          IF (aws_xml_getTag(l_Result, "ActionStatus") != 'Y') OR 
             (aws_xml_getTag(l_Result, "ActionStatus") IS NULL) THEN
             IF fgl_getenv('FGLGUI') = '1' THEN
                LET l_str = "Form creation error:\n\n", 
                            aws_xml_getTag(l_Result, "ActionDescribe")
             ELSE
                LET l_str = "Form creation error: ",
                            aws_xml_getTag(l_Result, "ActionDescribe")
             END IF
             CALL cl_err(l_str, '!', 1)   #開單失敗
             CLOSE ef_status_cl   #FUN-940120
             ROLLBACK WORK        #FUN-940120
            #  run "echo ' line 523 ' >> /u1/out/darcy.log"
             RETURN 0
          END IF
       END IF
       #No.FUN-710010 --end--
       
       CALL aws_eflog(l_Result)        #記錄 log
       #CALL cl_err(NULL, 'aws-066', 1)   #開單成功  #FUN-C70031
 
       #--FUN-930133--start--
       SELECT COUNT(*) INTO l_cnt from wsc_file where wsc01 = g_formNum
                                                  AND wsc15 = g_prog      #CHI-C70021
       IF l_cnt > 0 THEN
          DELETE FROM wsc_file where wsc01 = g_formNum
                                 AND wsc15 = g_prog      #CHI-C70021
          IF SQLCA.sqlcode THEN
             CALL cl_err3("del","wsc_file",g_formNum,"",SQLCA.sqlcode,"","",0)
          END IF
       END IF
       #--FUN-930133--end--
 
#No:9026
       CASE aws_xml_getTag(l_Result, "Status")
            WHEN '1' LET g_chr = 'S'   #開單成功, 等待簽核
            WHEN '3' LET g_chr = '1'   #開單成功且簽核完成(流程設為 '通知')
       END CASE
 
       #更新單頭檔狀態碼
       SELECT * INTO g_wse.* FROM wse_file WHERE wse01 = g_prog
       IF SQLCA.SQLCODE OR SQLCA.SQLCODE = NOTFOUND THEN
#         CALL cl_err("select wse failed: ", SQLCA.SQLCODE, 0)   #No.FUN-660155
          CALL cl_err3("sel","wse_file",g_prog,"",SQLCA.sqlcode,"","select wse failed:", 0)   #No.FUN-660155)   #No.FUN-660155
          CLOSE ef_status_cl   #FUN-940120
          ROLLBACK WORK        #FUN-940120
         #  run "echo ' line 557 ' >> /u1/out/darcy.log"
          RETURN 0
       END IF
       LET l_sql = "UPDATE ", g_wse.wse02 CLIPPED, " SET ",
                   g_wse.wse10 CLIPPED, " = '", g_chr, "'",
                   " WHERE ",  g_wse.wse03 CLIPPED, " = '", g_formNum_key CLIPPED, "'"  #FUN-770047
       IF LENGTH(l_wc) != 0 THEN
          LET l_sql = l_sql CLIPPED, l_wc
       END IF
       LET l_str = "update ", g_wse.wse10 CLIPPED, " failed: "
       EXECUTE IMMEDIATE l_sql
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN   #SQL 執行失敗
          CALL cl_err(l_str, SQLCA.SQLCODE, 1)
          CLOSE ef_status_cl   #FUN-940120
          ROLLBACK WORK        #FUN-940120
         #  run "echo ' line 572 ' >> /u1/out/darcy.log"
          RETURN 0             #MOD-580132
       END IF
  
       #更新單身檔狀態碼
       SELECT MAX(wsf02) INTO l_cnt FROM wsf_file WHERE wsf01 = g_prog  
       IF l_cnt > 0 THEN
          FOR i = 1 TO l_cnt 
             SELECT * INTO g_wsf.* FROM wsf_file WHERE wsf01 = g_prog AND wsf02 = i 
             IF SQLCA.SQLCODE OR SQLCA.SQLCODE = NOTFOUND THEN
#               CALL cl_err("select wsf failed: ", SQLCA.SQLCODE, 0)   #No.FUN-660155
                CALL cl_err3("sel","wsf_file",g_prog,"",SQLCA.sqlcode,"","select wsf failed", 0)   #No.FUN-660155)   #No.FUN-660155
                CLOSE ef_status_cl   #FUN-940120
                ROLLBACK WORK        #FUN-940120
               #  run "echo ' line 586 ' >> /u1/out/darcy.log"
                RETURN 0
             END IF
            
             IF (g_wsf.wsf03 CLIPPED IS NOT NULL) AND 
                (g_wsf.wsf04 CLIPPED IS NOT NULL) AND
                (g_wsf.wsf09 CLIPPED IS NOT NULL) THEN
                LET l_sql = "UPDATE ", g_wsf.wsf03 CLIPPED, " SET ",
                            g_wsf.wsf09 CLIPPED, " = '", g_chr, "'",
                            " WHERE ",  g_wsf.wsf04 CLIPPED, " = '", g_formNum_key CLIPPED, "'"     #FUN-770047
                IF LENGTH(l_wc) != 0 THEN
                   LET l_sql = l_sql CLIPPED, l_wc
                END IF
                LET l_str = "update ", g_wsf.wsf09 CLIPPED, " failed: "
                EXECUTE IMMEDIATE l_sql
                IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN   #SQL 執行失敗
                   CALL cl_err(l_str, SQLCA.SQLCODE, 1)
                   CLOSE ef_status_cl   #FUN-940120
                   ROLLBACK WORK        #FUN-940120
                  #  run "echo ' line 605 ' >> /u1/out/darcy.log"
                   RETURN 0             #MOD-580132
                END IF
             ELSE
                EXIT FOR
             END IF
          END FOR
       END IF
##    
       CLOSE ef_status_cl   #FUN-940120
       COMMIT WORK          #FUN-940120
       #darcy:2023/05/19 add s---
       #防止退出
       if g_bgjob = 'Y' then
       else
       #darcy:2023/05/19 add e---
    #    CALL cl_err(NULL, 'aws-066', 1)   #開單成功  #FUN-C70031
       end if #darcy:2023/05/19 add 
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
       CLOSE ef_status_cl   #FUN-940120
       ROLLBACK WORK        #FUN-940120
      #  run "echo ' line 636 ' >> /u1/out/darcy.log"
       RETURN 0
    END IF
END FUNCTION
 
 
FUNCTION aws_efcli2_XMLHeader()
#TQC-5A0129
DEFINE l_client         STRING,
       l_efsiteip    STRING,
       l_efsitename  STRING,
       l_i           LIKE type_file.num5,    #No.FUN-680130 SMALLINT
#END TQC-5A0129
       l_lang         STRING                 #FUN-B30160 增加l_lang節點
DEFINE l_wse02       LIKE wse_file.wse02 
DEFINE l_wse03       LIKE wse_file.wse03 
DEFINE l_wse12       LIKE wse_file.wse12
DEFINE l_wse13       LIKE wse_file.wse13
DEFINE l_wsj02       LIKE wsj_file.wsj02
DEFINE l_wsj03       LIKE wsj_file.wsj03
DEFINE l_wsj04       LIKE wsj_file.wsj04
define l_wse12_v,l_wse13_v varchar(40)
DEFINE l_wse12_value STRING
DEFINE l_wse13_value STRING,
       l_title       LIKE type_file.chr1000 #No.FUN-680130 VARCHAR(100)
DEFINE lnode_item    om.DomNode
DEFINE l_window      ui.Window 
DEFINE l_value       STRING
DEFINE l_sql         LIKE type_file.chr1000 #No.FUN-680130 VARCHAR(200)
DEFINE l_wsi02       LIKE wsi_file.wsi02
#TQC-720066
DEFINE ln_w          om.DomNode
DEFINE nl_node       om.NodeList
DEFINE l_name        STRING
DEFINE l_cnt         LIKE type_file.num5
#END TQC-720066
#No.FUN-750113 --start--
DEFINE l_cnt2        LIKE type_file.num10
DEFINE l_gen01       LIKE gen_file.gen01
DEFINE l_gen03       LIKE gen_file.gen03
DEFINE l_zx01        LIKE zx_file.zx01
DEFINE l_zx03        LIKE zx_file.zx03
DEFINE l_orgUnitID   STRING
#No.FUN-750113 --end--
DEFINE l_tpip        STRING,   #FUN-960137
       l_tpenv       STRING    #FUN-960137
DEFINE l_creator_tag STRING    #FUN-C40086 
 
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

    CASE g_lang                                   # FUN-B30160 #指定語言別
         WHEN '0' LET l_lang = "Big5"             # FUN-B30160
         WHEN '1' LET l_lang = "ISO8859"          # FUN-B30160
         WHEN '2' LET l_lang = "GB"               # FUN-B30160
         OTHERWISE LET l_lang = "ISO8859"         # FUN-B30160
    END CASE                                      # FUN-B30160
    
 
    # LET l_window = ui.Window.getCurrent()
 
    SELECT wse02,wse03,wse12,wse13 INTO l_wse02,l_wse03,l_wse12,l_wse13 FROM wse_file where wse01= g_prog  #表單關係人
    
    #TQC-720066
    #LET lnode_item = l_window.findNode("FormField",l_wse12 CLIPPED)
    #IF lnode_item IS NULL THEN
    #    LET l_wse12_value = ""
    #ELSE
    #    LET l_wse12_value = lnode_item.getAttribute("value")
    #END IF
    #LET lnode_item = l_window.findNode("FormField",l_wse13 CLIPPED)
    #IF lnode_item IS NULL THEN
    #        SELECT * INTO g_wsi.* FROM wsi_file WHERE wsi01 = g_prog 
    #           AND wsi02 = l_wse13 AND wsi05 = g_wse03
    #        IF g_wsi.wsi06 IS NULL OR g_wsi.wsi06 = ""THEN
    #           LET l_sql = "SELECT ",g_wsi.wsi02 CLIPPED," FROM ",g_wsi.wsi03 CLIPPED,
    #                    " WHERE ",g_wsi.wsi04 CLIPPED," = '", g_formNum CLIPPED,"'"
    #        ELSE
    #           LET l_sql = "SELECT ",g_wsi.wsi02 CLIPPED," FROM ",g_wsi.wsi03 CLIPPED,
    #                    " WHERE ",g_wsi.wsi04 CLIPPED," = '", g_formNum CLIPPED,"'"
    #                    ," AND ",g_wsi.wsi06 CLIPPED
    #        END IF
    #      DECLARE wsi_cs CURSOR FROM l_sql
    #      FOREACH wsi_cs INTO l_wsi02 
    #      END FOREACH   
    #      LET l_wse13_value = l_wsi02
    #ELSE
    #    LET l_wse13_value = lnode_item.getAttribute("value")
    #END IF
    # LET ln_w = l_window.getNode()
    # LET nl_node = ln_w.selectByTagName("FormField")
    # LET l_cnt = nl_node.getLength()
    # FOR l_i = 1 TO l_cnt
    #      LET lnode_item = nl_node.item(l_i)
    #      LET l_name = lnode_item.getAttribute("colName")
    #      IF cl_null(l_name) THEN
    #         LET l_name = lnode_item.getAttribute("name")
    #      END IF
    #      IF l_name = l_wse12 CLIPPED THEN
    #         LET l_wse12_value = lnode_item.getAttribute("value")
    #         EXIT FOR
    #      END IF
    # END FOR
    # LET l_wse13_value = ""
    # FOR l_i = 1 TO l_cnt
    #      LET lnode_item = nl_node.item(l_i)
    #      LET l_name = lnode_item.getAttribute("colName")
    #      IF cl_null(l_name) THEN
    #         LET l_name = lnode_item.getAttribute("name")
    #      END IF
    #      IF l_name = l_wse13 CLIPPED THEN
    #         LET l_wse13_value = lnode_item.getAttribute("value")
    #         EXIT FOR
    #      END IF
    # END FOR
    # IF cl_null(l_wse13_value) THEN
    #         SELECT * INTO g_wsi.* FROM wsi_file WHERE wsi01 = g_prog 
    #            AND wsi02 = l_wse13 AND wsi05 = g_wse03
    #         IF g_wsi.wsi06 IS NULL OR g_wsi.wsi06 = ""THEN
    #            LET l_sql = "SELECT ",g_wsi.wsi02 CLIPPED," FROM ",g_wsi.wsi03 CLIPPED,
    #                     " WHERE ",g_wsi.wsi04 CLIPPED," = '", g_formNum CLIPPED,"'"
    #         ELSE
    #            LET l_sql = "SELECT ",g_wsi.wsi02 CLIPPED," FROM ",g_wsi.wsi03 CLIPPED,
    #                     " WHERE ",g_wsi.wsi04 CLIPPED," = '", g_formNum CLIPPED,"'"
    #                     ," AND ",g_wsi.wsi06 CLIPPED
    #         END IF
    #       DECLARE wsi_cs CURSOR FROM l_sql
    #       FOREACH wsi_cs INTO l_wsi02 
    #       END FOREACH   
    #       LET l_wse13_value = l_wsi02
    # END IF
    #END TQC-720066

    #darcy:2023/06/26 add s---
    let l_sql = "select ",l_wse12,", ", l_wse13," from ",l_wse02," where ",l_wse03," = '",g_formNum,"'"
    prepare apmi255_get_user_p from l_sql
    execute apmi255_get_user_p into l_wse12_v,l_wse13_v
    let l_wse12_value=l_wse12_v
    let l_wse13_value=l_wse13_v
    #darcy:2023/06/26 add e---
    #darcy:2022/10/17 add s---
    # 通过接口获取BPM接口组织架构
    call cws_bpm_getGem(l_wse13_value) returning l_gen03
    let l_orgUnitID = l_gen03
    if cl_null(l_gen03) then
    #darcy:2022/10/17 add e---
      SELECT COUNT(*) INTO l_cnt2 FROM gen_file where gen01=l_gen01
      IF l_cnt2 > 0 THEN
         # get dept ID by employee ID
         SELECT gen03 INTO l_gen03 FROM gen_file where gen01=l_gen01
         LET l_orgUnitID = l_gen03 CLIPPED
      ELSE
         # get dept ID by user ID
         SELECT zx03 INTO l_zx03 FROM zx_file where zx01=l_zx01
         LET l_orgUnitID = l_zx03 CLIPPED
      END IF
      #No.FUN-750113 --end--
    end if #darcy:2022/10/17 add
 
    #MOD-560007
    IF g_wse04 IS NOT NULL THEN
        LET g_formNum = g_formNum CLIPPED,"{+}", g_wse04 CLIPPED,"=", g_key1
       IF g_wse05 IS NOT NULL THEN
           LET g_formNum = g_formNum CLIPPED,"{+}", g_wse05 CLIPPED ,"=", g_key2
           IF g_wse06 IS NOT NULL THEN
               LET g_formNum = g_formNum CLIPPED ,"{+}", g_wse06 CLIPPED ,"=",g_key3 
               IF g_wse07 IS NOT NULL THEN
                   LET g_formNum = g_formNum CLIPPED,"{+}", g_wse07 CLIPPED,"=", g_key4
               END IF
           END IF
       END IF
    END IF
     #MOD-560007
 
    SELECT gaz03 INTO l_title FROM gaz_file 
          where gaz01= g_prog AND gaz02 = g_lang 
 
    LET g_formid = s_get_doc_no(g_formNum)           #MOD-590183

    #FUN-C40086 start
    LET l_creator_tag = SFMT("<FormCreatorID%1>%2" , aws_efcli2_scrtyitem(g_prog,l_wse12)
                                                      , aws_efcli2_getdata(l_wse12 , l_wse12_value))
    #FUN-C40086 end
 
    LET g_strXMLInput =                           #組 XML Header
        "    <Request>", ASCII 10,
        "    <RequestMethod>CreateForm</RequestMethod>", ASCII 10,
        "    <LogOnInfo>", ASCII 10,
        "    <SenderIP>", l_client CLIPPED, "</SenderIP>", ASCII 10,
        "    <ReceiverIP>", l_efsiteip CLIPPED, "</ReceiverIP>", ASCII 10,
        "    <EFSiteName>", l_efsitename CLIPPED, "</EFSiteName>", ASCII 10,
        "    <EFLogonID>", g_user CLIPPED, "</EFLogonID>", ASCII 10,
        #"   <OrgUnitID>", g_grup CLIPPED, "</OrgUnitID>", ASCII 10, #No.FUN-710010 #No.FUN-750113 
        "    <OrgUnitID>", l_orgUnitID CLIPPED, "</OrgUnitID>", ASCII 10, #No.FUN-750113
        "    <TPServerIP>",l_tpip CLIPPED, "</TPServerIP>", ASCII 10,    #FUN-960137
        "    <TPServerEnv>",l_tpenv CLIPPED, "</TPServerEnv>", ASCII 10, #FUN-960137
        "    </LogOnInfo>", ASCII 10,
        "    <RequestContent>", ASCII 10,
        "    <Form>", ASCII 10,
        "    <Language>", l_lang CLIPPED, "</Language>", ASCII 10,        #FUN-B30160
        "    <PlantID>", g_plant CLIPPED, "</PlantID>", ASCII 10,
        "    <ProgramID>", g_prog CLIPPED, "</ProgramID>", ASCII 10,
        "    <SourceFormID>",  g_formid, "</SourceFormID>", ASCII 10, #MOD-590183
        "    <SourceFormNum>", g_formNum CLIPPED, "</SourceFormNum>", ASCII 10,
        #"    <FormCreatorID>", l_wse12_value CLIPPED, "</FormCreatorID>", ASCII 10, #FUN-C40086  #FUN-560007
        "   ", l_creator_tag , "</FormCreatorID>", ASCII 10,   #FUN-C40086
        "    <FormOwnerID>", l_wse13_value  CLIPPED, "</FormOwnerID>", ASCII 10,
        "    <ContentText>", ASCII 10,
        "    <title>", l_title CLIPPED, "</title>", ASCII 10,
        "    <head>", ASCII 10
END FUNCTION
 
 
FUNCTION aws_efcli2_XMLTrailer()
 
    #FUN-770047
    IF g_aza.aza72 = 'Y' THEN
       CALL aws_efcli2_memo()                       #組備註資料
    END IF
    #END FUN-770047
 
    LET g_strXMLInput = aws_xml_replace(g_strXMLInput)   #MOD-890161
    CALL aws_efcli2_attach()   #是否有附件
 
    LET g_strXMLInput = g_strXMLInput CLIPPED,   #組 XML Trailer
        "   </ContentText>", ASCII 10,
        "  </Form>", ASCII 10,
        " </RequestContent>", ASCII 10,
        "</Request>"
END FUNCTION
 
 
FUNCTION aws_efcli2_attach()
    DEFINE l_ind    RECORD LIKE ind_file.*,
#          l_desc    LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(100) 
#          l_file    LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(100)
           l_cnt    LIKE type_file.num5,   #No.FUN-680130 SMALLINT
           l_i        LIKE type_file.num5,   #No.FUN-680130 SMALLINT
           l_j        LIKE type_file.num5    #No.FUN-680130 SMALLINT
 
    DEFINE l_wsa03      LIKE wsa_file.wsa03,
           l_p1         LIKE type_file.num10,  #No.FUN-680130 INTEGER
           l_p2         LIKE type_file.num10,  #No.FUN-680130 INTEGER
           l_wc         STRING,
           gs_wc        STRING,
           l_sql        LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(1000)
           l_key        STRING,
           l_tag        STRING
    DEFINE gr_key       RECORD
                       gca01 LIKE gca_file.gca01,
                       gca02 LIKE gca_file.gca02,
                       gca03 LIKE gca_file.gca03,
                       gca04 LIKE gca_file.gca04,
                       gca05 LIKE gca_file.gca05
                    END RECORD
    DEFINE l_wse03      LIKE wse_file.wse03
    
    #No.FUN-710010 --start--
    DEFINE l_filename STRING
    DEFINE l_content  STRING
    DEFINE l_cmd      STRING
    DEFINE l_gca07    LIKE gca_file.gca07
    DEFINE l_gca08    LIKE gca_file.gca08
    DEFINE l_gca09    LIKE gca_file.gca09
    DEFINE l_gca10    LIKE gca_file.gca10
    DEFINE l_gcb      RECORD LIKE gcb_file.*
    DEFINE l_gcb09    LIKE gcb_file.gcb09
    #No.FUN-710010 --end--
 
       SELECT wse03 INTO l_wse03 FROM wse_file WHERE wse01 = g_prog
       LET l_key = l_wse03 CLIPPED , "=" , g_formNum
             LET l_i = 1
      LET l_tag = "{+}"
      LET l_p1 = l_key.getIndexOf(l_tag,1)
      IF l_p1 != 0 THEN
        #MOD-690128
        #LET l_wc = l_key.subString(1, l_p1-1)
        #LET gr_key.gca01 = l_wc
 
        #WHILE l_i <= l_key.getLength()
        # LET l_p1 = l_key.getIndexOf(l_tag,l_i)
        # LET l_p2 = l_key.getIndexOf(l_tag,l_p1+3)
        # IF l_p2 = 0 THEN
        #    LET l_wc = l_key.subString(l_p1+l_tag.getLength(),l_key.getLength())
        # ELSE
        #    LET l_wc = l_key.subString(l_p1+l_tag.getLength(),l_p2-1)
        # END IF
 
        # IF cl_null(gr_key.gca02) THEN
        #    LET gr_key.gca02 = l_wc
        # ELSE IF cl_null(gr_key.gca03) THEN
        #    LET gr_key.gca03 = l_wc
        # ELSE IF cl_null(gr_key.gca04) THEN
        #    LET gr_key.gca04 = l_wc
        # ELSE
        #    LET gr_key.gca05 = l_wc
        # END IF
        # END IF
        # END IF
 
        # IF l_p2 = 0 THEN EXIT WHILE END IF
        # LET l_i = l_p2 - 1
 
        #END WHILE
 
        LET gr_key.gca01 = aws_efapp_key(l_key,1)
        IF cl_null(gr_key.gca02) THEN
           LET gr_key.gca02 = aws_efapp_key(l_key,2)
        END IF
        IF cl_null(gr_key.gca03) THEN
            LET gr_key.gca03 = aws_efapp_key(l_key,3)
        END IF
        IF cl_null(gr_key.gca04) THEN
            LET gr_key.gca04 = aws_efapp_key(l_key,4)
        END IF
        IF cl_null(gr_key.gca05) THEN
            LET gr_key.gca05 = aws_efapp_key(l_key,5)
        END IF
        #END MOD-690128
 
      ELSE
          LET gr_key.gca01 = l_key
      END IF
      LET gs_wc = "gca01 = '",gr_key.gca01 CLIPPED, "'"
       
      #-- No.FUN-790020 BEGIN --------------------------------------------------
      # Primary Key 不允許塞入 NULL 值, 故以空白代替
      #-------------------------------------------------------------------------
      IF NOT cl_null(gr_key.gca02) THEN
         LET gs_wc = gs_wc, " AND gca02 = '", gr_key.gca02 CLIPPED, "'"
      ELSE
         LET gs_wc = gs_wc, " AND gca02 = ' '"
      END IF
      IF NOT cl_null(gr_key.gca03) THEN
         LET gs_wc = gs_wc, " AND gca03 = '", gr_key.gca03 CLIPPED, "'"
      ELSE
         LET gs_wc = gs_wc, " AND gca03 = ' '"
      END IF
      IF NOT cl_null(gr_key.gca04) THEN
         LET gs_wc = gs_wc, " AND gca04 = '", gr_key.gca04 CLIPPED, "'"
      ELSE
         LET gs_wc = gs_wc, " AND gca04 = ' '"
      END IF
      IF NOT cl_null(gr_key.gca05) THEN
         LET gs_wc = gs_wc, " AND gca05 = '", gr_key.gca05 CLIPPED, "'"
      ELSE
         LET gs_wc = gs_wc, " AND gca05 = ' '"
      END IF
 
      LET l_sql = "SELECT COUNT(*) from gca_file WHERE ", gs_wc ," AND gca08 IN ('DOC','URL','TXT') AND gca11 = 'Y'"
 
      PREPARE attach_precount FROM l_sql
      DECLARE attach_count CURSOR FOR attach_precount
      OPEN attach_count
      FETCH attach_count INTO l_cnt
      #IF l_cnt = 0 THEN
      #   LET g_strXMLInput = g_strXMLInput CLIPPED,
      #       "    <attachment>N</attachment>", ASCII 10
      #ELSE
      #   LET g_strXMLInput = g_strXMLInput CLIPPED,
      #       "    <attachment>Y</attachment>", ASCII 10
      #END IF
      
      #No.FUN-710010 --start--
      CLOSE attach_count
      IF g_aza.aza72 = 'N' THEN         #與EasyFlow整合
         #-FUN-890073--start--告知EF附件個數
         IF l_cnt = 0 THEN
            LET g_strXMLInput = g_strXMLInput CLIPPED,
                "    <attachment>0</attachment>", ASCII 10
         ELSE
            LET g_strXMLInput = g_strXMLInput CLIPPED,
                "    <attachment>", l_cnt, "</attachment>", ASCII 10
         END IF
         #-FUN-890073--end--
      ELSE                              #與EasyFlow GP整合
         IF l_cnt > 0 THEN              #有相關文件
            LET g_strXMLInput = g_strXMLInput CLIPPED,"    <attachment>", ASCII 10
            
            LET l_sql = "SELECT gca07,gca08,gca09,gca10 FROM gca_file WHERE ",gs_wc,
                        " AND gca08 IN ('DOC','URL','TXT') AND gca11 = 'Y'"
            
            DECLARE attach2 CURSOR FROM l_sql
            FOREACH attach2 INTO l_gca07,l_gca08,l_gca09,l_gca10
               IF SQLCA.SQLCODE THEN
                  CALL cl_err("foreach gca_file: ", SQLCA.SQLCODE, 0)
                  EXIT FOREACH
               END IF
               
               LOCATE l_gcb.gcb09 IN MEMORY
               SELECT * INTO l_gcb.* FROM gcb_file
                WHERE gcb01=l_gca07 AND gcb02=l_gca08
                  AND gcb03=l_gca09 AND gcb04=l_gca10
                  
               IF SQLCA.SQLCODE THEN
                  CALL cl_err("select gcb_file: ", SQLCA.SQLCODE, 0)
                  FREE l_gcb.gcb09
                  CONTINUE FOREACH
               END IF
               FREE l_gcb.gcb09
               
               CASE l_gcb.gcb02
               WHEN "DOC"
                  #將gcb09的內容產生成檔案
                 # LET l_filename = FGL_GETENV("TEMPDIR"),"/",l_gcb.gcb01 CLIPPED, #FUN-10061
                  LET l_filename = FGL_GETENV("TEMPDIR"),os.Path.separator(),l_gcb.gcb01 CLIPPED,
                                #".", cl_getFileExtension()             #No.TQC-760155
                               # ".", cl_getFileExtension(l_gcb.gcb07)   #No.TQC-760155
                                ".", os.Path.extension(l_gcb.gcb07)   #FUN-B10061
                  LOCATE l_gcb09 IN FILE l_filename
                  SELECT gcb09 INTO l_gcb09 FROM gcb_file 
                   WHERE gcb01=l_gcb.gcb01 AND gcb02=l_gcb.gcb02
                     AND gcb03=l_gcb.gcb03 AND gcb04=l_gcb.gcb04
 
                  IF SQLCA.SQLCODE THEN
                     CALL cl_err("select gcb_file.gcb09: ", SQLCA.SQLCODE, 0)
                     FREE l_gcb09
                     CONTINUE FOREACH
                  END IF
                  
                  #更改檔案權限
#                 LET l_cmd = "chmod 666 ",l_filename                    #No.FUN-9C0009 
#                 RUN l_cmd                                              #No.FUN-9C0009
                  IF os.Path.chrwx(l_filename CLIPPED,438) THEN END IF   #No.FUN-9C0009
                  
                  LET l_content = l_filename
               WHEN "TXT"
                  LET l_content = l_gcb.gcb06 CLIPPED
               WHEN "URL"
                  LET l_content = l_gcb.gcb10 CLIPPED
               OTHERWISE
                  LET l_content = ""
               END CASE
               
               #-----MOD-890161---------
               LET l_gcb.gcb02 = aws_xml_replaceStr(l_gcb.gcb02)
               LET l_gcb.gcb05 = aws_xml_replaceStr(l_gcb.gcb05)
               LET l_content = aws_xml_replaceStr(l_content)
               LET l_gcb.gcb07 = aws_xml_replaceStr(l_gcb.gcb07)
               #-----END MOD-890161-----
 
               LET g_strXMLInput = g_strXMLInput CLIPPED,
               "        <document type=\"",l_gcb.gcb02 CLIPPED,"\" desc=\"",l_gcb.gcb05 CLIPPED,
               #"\" content=\"",l_content CLIPPED,"\" filename=\"", l_gcb.gcb07 CLIPPED,"\" />", ASCII 10   #FUN-860073 
                "\" content=\"",l_content CLIPPED,"\" filename=\"", l_gcb.gcb07 CLIPPED, #FUN-C40061
                "\" owner=\"", l_gcb.gcb13 CLIPPED,"\"  />", ASCII 10                    #FUN-C40061
            END FOREACH
            LET g_strXMLInput = g_strXMLInput CLIPPED,"    </attachment>", ASCII 10
         END IF
      END IF
      #No.FUN-710010 --end--
 
END FUNCTION
 
FUNCTION aws_efcli2_setcf(p_head,p_body1,p_body2,p_body3,p_body4,p_body5)
DEFINE p_head,p_body om.DomNode
DEFINE p_body1        om.DomNode
DEFINE p_body2        om.DomNode
DEFINE p_body3        om.DomNode
DEFINE p_body4        om.DomNode
DEFINE p_body5        om.DomNode
DEFINE n_field        om.DomNode
DEFINE n_record       om.DomNode
DEFINE lnode_item     om.DomNode
DEFINE n_combo_child  om.DomNode
DEFINE n_combo        om.DomNode
DEFINE nl_field       om.NodeList
DEFINE nl_record      om.NodeList
DEFINE nl_combo_child om.NodeList
DEFINE nl_combo       om.NodeList
DEFINE cnt_field      LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE cnt_record     LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE cnt_combo      LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE p_window       STRING
DEFINE l_value        STRING,
       l_combo_value  STRING,
       l_name         STRING,
       l_wsh04        LIKE wsh_file.wsh04,
       l_wsh05        LIKE wsh_file.wsh05,
       l_wsh06        LIKE wsh_file.wsh06,
       l_wsh07        LIKE wsh_file.wsh07,
       l_wsh08        LIKE wsh_file.wsh08,
       l_reference    LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(1000)
       l_refvalue     LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(1000)
       l_wsi02        LIKE wsi_file.wsi02,
       l_wsi03        LIKE wsi_file.wsi03,
       l_wsi04        LIKE wsi_file.wsi04,
       l_wsi06        LIKE wsi_file.wsi06,
       l_sql          STRING,
       i,j,k          LIKE type_file.num10,  #No.FUN-680130 INTEGER
       l_cnt          LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE l_gae04        LIKE gae_file.gae04
DEFINE l_gae02        LIKE gae_file.gae02
DEFINE l_window       ui.Window 
DEFINE l_wse13        LIKE wse_file.wse13
#TQC-720066
DEFINE ln_w           om.DomNode
DEFINE nl_node        om.NodeList
DEFINE l_i            LIKE type_file.num5
#END TQC-720066
DEFINE ln_strbuff     base.StringBuffer    #MOD-BA0203
DEFINE l_num_value    STRING               #FUN-BB0061 
DEFINE l_type         LIKE type_file.chr1  #FUN-BB0061
DEFINE l_format       STRING               #FUN-BB0061
DEFINE l_cnode_item   om.DomNode           #FUN-BB0061
DEFINE l_format_c     CHAR(50)             #CHI-BC0010
DEFINE l_program      CHAR(50)             #CHI-BC0010
DEFINE l_tag          CHAR(50)             #CHI-BC0010
 
     #呼叫 aws_efcli2_XMLHeader() 組出 XML Header 資訊
 
     LET l_window = ui.Window.getCurrent()
     
     
     CALL aws_efcli2_XMLHeader()
 
     #組單頭 UI 資料 
 
    DECLARE window_cs CURSOR FOR 
        SELECT wsh04,wsh05,wsh06,wsh07,wsh08 FROM wsh_file 
        WHERE wsh01=g_prog AND wsh02='M' ORDER BY wsh04
 
    FOREACH window_cs INTO l_wsh04,l_wsh05,l_wsh06,l_wsh07,l_wsh08  
        #TQC-720066
        #LET lnode_item = l_window.findNode("FormField",l_wsh05 CLIPPED)
        #IF lnode_item IS NULL THEN
        #    LET lnode_item = l_window.findNode("FormField","formonly." || l_wsh05 CLIPPED)
        #END IF
        LET l_type = "0"   #FUN-BB0061
        LET l_value = ""
        LET ln_w = l_window.getNode()
        LET nl_node = ln_w.selectByTagName("FormField")
        LET l_cnt = nl_node.getLength()
        FOR l_i = 1 TO l_cnt
             LET lnode_item = nl_node.item(l_i)
             LET l_name = lnode_item.getAttribute("colName")
             IF cl_null(l_name) THEN
                LET l_name = lnode_item.getAttribute("name")
             END IF
             IF l_name = l_wsh05 CLIPPED THEN
                LET l_value = lnode_item.getAttribute("value")
               #FUN-C40061 start
               #MOD-BA0203 add begin--------------------
               # LET ln_strbuff = base.StringBuffer.create()
               # CALL ln_strbuff.append(l_value)
               # CALL ln_strbuff.replace("\n","   ",0)
               # LET l_value = ln_strbuff.toString()
               #MOD-BA0203 add end----------------------
               #FUN-C40061 end
                #---FUN-BB0061---start-----
                IF lnode_item.getAttribute("numAlign") CLIPPED = 1 THEN
                   LET l_type = "1"
                   LET l_cnode_item = lnode_item.getFirstChild()
                   #CHI-BC0010 - Start -
                   LET l_format = aws_efcli2_format_r(g_prog, l_wsh05) 
                   IF l_format IS NULL THEN
                      LET l_format = l_cnode_item.getAttribute("format")
                   END IF 
                   #CHI-BC0010 -  End  -
                   IF (NOT cl_null(l_value)) AND (NOT cl_null(l_format))  THEN
                      LET l_value = l_value USING l_format 
                   END IF
                END IF
                #---FUN-BB0061---end-------
                EXIT FOR
             END IF
        END FOR
        #IF lnode_item IS NULL THEN
        #    LET l_value = ""
        #ELSE
        IF NOT cl_null(l_value) THEN
            LET cnt_combo = 0
        #   LET l_value = lnode_item.getAttribute("value")
        #END TQC-720066
            LET nl_combo = lnode_item.selectByTagName("ComboBox")
            LET cnt_combo = nl_combo.getLength()
            IF cnt_combo > 0 THEN                         #判斷是否為combobox
                  LET n_combo = nl_combo.item(1)
                  LET n_combo_child = n_combo.getFirstChild()
                  WHILE n_combo_child IS NOT NULL
                        LET l_combo_value = n_combo_child.getAttribute("name")
                        IF l_value.equals(l_combo_value) THEN
                            LET l_value = n_combo_child.getAttribute("text")
                            EXIT WHILE
                        END IF
                        LET n_combo_child = n_combo_child.getNext()
                  END WHILE   
            END IF
        END IF

        LET l_value = aws_efcli2_getdata( l_wsh05 ,l_value)  #FUN-C40086 

        IF l_wsh06 IS NOT NULL THEN             #參考欄位1
            LET l_refvalue = NULL
               SELECT wsi02,wsi03,wsi04,wsi06 INTO l_wsi02,l_wsi03,l_wsi04,l_wsi06 
                  FROM wsi_file where wsi01 = g_prog AND wsi05 = l_wsh05 AND wsi02 = l_wsh06
 
            LET l_sql = "SELECT ",l_wsi02 CLIPPED," FROM ",l_wsi03 CLIPPED,
                        " WHERE ",l_wsi04 CLIPPED,"='",l_value CLIPPED,"'"
 
            IF l_wsi06 IS NOT NULL THEN
               LET l_sql = l_sql CLIPPED," AND ", l_wsi06 CLIPPED 
            END IF    
            DECLARE wsh04_cs CURSOR FROM l_sql
            FOREACH wsh04_cs INTO l_refvalue
            END FOREACH
            LET l_reference = l_refvalue                                
 
            IF l_wsh07 IS NOT NULL THEN             #參考欄位2
                LET l_refvalue = NULL
                   SELECT wsi02,wsi03,wsi04,wsi06 INTO l_wsi02,l_wsi03,l_wsi04,l_wsi06 
                      FROM wsi_file where wsi01 = g_prog AND wsi05 = l_wsh05 AND wsi02 = l_wsh07
          
                LET l_sql = "SELECT ",l_wsi02 CLIPPED," FROM ",l_wsi03 CLIPPED,
                            " WHERE ",l_wsi04 CLIPPED,"='",l_value CLIPPED,"'"
          
                IF l_wsi06 IS NOT NULL THEN
                   LET l_sql = l_sql CLIPPED," AND ", l_wsi06 CLIPPED 
                END IF    
                DECLARE wsh04_cs2 CURSOR FROM l_sql
                FOREACH wsh04_cs2 INTO l_refvalue
                END FOREACH 
                LET l_reference = l_reference CLIPPED,' ', l_refvalue
 
                IF l_wsh08 IS NOT NULL THEN             #參考欄位3
                   LET l_refvalue = NULL
                   SELECT wsi02,wsi03,wsi04,wsi06 INTO l_wsi02,l_wsi03,l_wsi04,l_wsi06 
                      FROM wsi_file where wsi01 = g_prog AND wsi05 = l_wsh05 AND wsi02 = l_wsh08
          
                   LET l_sql = "SELECT ",l_wsi02 CLIPPED," FROM ",l_wsi03 CLIPPED,
                            " WHERE ",l_wsi04 CLIPPED,"='",l_value CLIPPED,"'"
          
                   IF l_wsi06 IS NOT NULL THEN
                      LET l_sql = l_sql CLIPPED," AND ", l_wsi06 CLIPPED 
                   END IF    
                   DECLARE wsh04_cs3 CURSOR FROM l_sql
                   FOREACH wsh04_cs3 INTO l_refvalue
                   END FOREACH
                   LET l_reference = l_reference CLIPPED,' ', l_refvalue
 
                END IF
             END IF
                LET g_strXMLInput = g_strXMLInput CLIPPED,
                  #"       <",l_wsh05 CLIPPED,">", l_value ," ", l_reference CLIPPED, "</",l_wsh05 CLIPPED,">", ASCII 10                         #FUN-BB0061 mark
                  #"       <",l_wsh05 CLIPPED, " type=\"", l_type, "\">", l_value ," ", l_reference CLIPPED, "</",l_wsh05 CLIPPED,">", ASCII 10   #FUN-BB0061 在tag中增加type="0"(文字):type="1"(數字)屬性給EasyFlow判斷
                   "       <",l_wsh05 CLIPPED, " type=\"", l_type, "\">", aws_efcli2_eol(l_value) ," ", aws_efcli2_eol(l_reference CLIPPED), "</",l_wsh05 CLIPPED,">", ASCII 10  #FUN-C40061 
       ELSE
            LET g_strXMLInput = g_strXMLInput CLIPPED,
              #"       <",l_wsh05 CLIPPED,">", l_value , "</",l_wsh05 CLIPPED,">", ASCII 10                                                      #FUN-BB0061 mark
              #"       <",l_wsh05 CLIPPED, " type=\"", l_type, "\">", l_value, "</",l_wsh05 CLIPPED,">", ASCII 10                                 #FUN-BB0061 在tag中增加type="0"(文字):type="1"(數字)屬性給EasyFlow判斷
               "       <",l_wsh05 CLIPPED, " type=\"", l_type, "\">", aws_efcli2_eol(l_value), "</",l_wsh05 CLIPPED,">", ASCII 10    #FUN-C40061
        END IF
    END FOREACH
 
    LET g_strXMLInput = g_strXMLInput CLIPPED,
               "    </head>", ASCII 10
 
     #組單身資料
     FOR k = 1 TO 5 
        CASE  k
           WHEN 1
             LET p_body = p_body1
           WHEN 2
             LET p_body = p_body2
           WHEN 3
             LET p_body = p_body3
           WHEN 4
             LET p_body = p_body4
           WHEN 5
             LET p_body = p_body5
        END CASE
                 
        IF aws_check_body(p_body , k) = -1 THEN  #FUN-CA0078
           LET g_strXMLInput = ''
           RETURN
        END IF
 
        IF p_body IS NOT NULL THEN
           LET g_strXMLInput = g_strXMLInput CLIPPED,   #組 XML Trailer
                               "    <body>", ASCII 10
           LET nl_record = p_body.selectByTagName("Record")
           LET cnt_record = nl_record.getLength()
           FOR i=1 to cnt_record
              LET g_strXMLInput = g_strXMLInput CLIPPED,
                                  "      <record>", ASCII 10
              LET n_record = nl_record.item(i)
              LET nl_field = n_record.selectByTagName("Field")
              LET cnt_field = nl_field.getLength()
              FOR j =1 to cnt_field
                  LET l_type = "0"   #FUN-BB0061
                  LET n_field  = nl_field.item(j)
                  LET l_value = n_field.getAttribute("value")
                  LET l_name = n_field.getAttribute("name")
                  LET l_wsh05 = l_name CLIPPED
                  SELECT count(*) INTO l_cnt FROM wsh_file
                     WHERE wsh01 = g_prog AND wsh02='D' AND wsh05 = l_wsh05
                  IF l_cnt > 0 THEN
                        SELECT wsh05,wsh06,wsh07,wsh08 INTO l_wsh05,l_wsh06,l_wsh07,l_wsh08 FROM wsh_file
                            WHERE wsh01 = g_prog AND wsh02='D' AND wsh05 = l_wsh05
           
                        LET l_gae04 = NULL
                        #TQC-720066
                        #LET lnode_item = l_window.findNode("TableColumn",l_wsh05 CLIPPED)
                        #IF lnode_item IS NULL THEN
                        #    LET lnode_item = l_window.findNode("TableColumn","formonly." || l_wsh05 CLIPPED)
                        #END IF
                        #IF lnode_item IS NOT NULL THEN
                        LET ln_w = l_window.getNode()
                        LET nl_node = ln_w.selectByTagName("TableColumn")
                        LET l_cnt = nl_node.getLength()
                        FOR l_i = 1 TO l_cnt 
                             LET lnode_item = nl_node.item(l_i)
                             LET l_name = lnode_item.getAttribute("colName")
                             IF cl_null(l_name) THEN
                                LET l_name = lnode_item.getAttribute("name")
                             END IF
                             IF l_name = l_wsh05 CLIPPED THEN
                                #---FUN-BB0061---start-----
                                IF lnode_item.getAttribute("numAlign") CLIPPED = 1 THEN
                                   LET l_type = "1"
                                   LET l_cnode_item = lnode_item.getFirstChild()
                                   #CHI-BC0010 - Start -
                                   LET l_format = aws_efcli2_format_r(g_prog, l_wsh05) 
                                   IF l_format IS NULL THEN
                                      LET l_format = l_cnode_item.getAttribute("format")
                                   END IF 
                                   #CHI-BC0010 -  End  -
                                   IF (NOT cl_null(l_value)) AND (NOT cl_null(l_format))  THEN
                                       LET l_value = l_value USING l_format                         
                                   END IF
                                END IF
                                #---FUN-BB0061---end------- 
                                LET cnt_combo = 0 
                                LET nl_combo = lnode_item.selectByTagName("ComboBox")
                                LET cnt_combo = nl_combo.getLength()
                                
                                IF cnt_combo > 0 THEN
                                     LET n_combo = nl_combo.item(1)
                                     LET n_combo_child = n_combo.getFirstChild()
                                     WHILE n_combo_child IS NOT NULL
                                           LET l_combo_value = n_combo_child.getAttribute("name")
                                           IF l_value.equals(l_combo_value) THEN
                                               LET l_value = n_combo_child.getAttribute("text")
                                               EXIT WHILE
                                           END IF
                                           LET n_combo_child = n_combo_child.getNext()
                                     END WHILE   
                                END IF
                                EXIT FOR
                             END IF
                        END FOR
                        #END TQC-720066
 
                        IF l_wsh06 IS NOT NULL THEN
                            LET l_refvalue = NULL
                            SELECT wsi02,wsi03,wsi04,wsi06 INTO l_wsi02,l_wsi03,l_wsi04,l_wsi06 
                               FROM wsi_file where wsi01 = g_prog AND wsi05 = l_wsh05 AND wsi02 = l_wsh06
                           
                            LET l_sql = "SELECT ",l_wsi02 CLIPPED," FROM ",l_wsi03 CLIPPED,
                                        " WHERE ",l_wsi04 CLIPPED,"='",l_value CLIPPED,"'"
                            IF l_wsi06 IS NOT NULL THEN
                               LET l_sql = l_sql CLIPPED," AND ", l_wsi06 CLIPPED 
                            END IF    
                            DECLARE wsh04_cs_b CURSOR FROM l_sql
                            FOREACH wsh04_cs_b INTO l_refvalue
                            END FOREACH
                            LET l_reference = l_refvalue
                            
                            IF l_wsh07 IS NOT NULL THEN             #參考欄位2
                                LET l_refvalue = NULL
                                   SELECT wsi02,wsi03,wsi04,wsi06 INTO l_wsi02,l_wsi03,l_wsi04,l_wsi06 
                                      FROM wsi_file where wsi01 = g_prog AND wsi05 = l_wsh05 AND wsi02 = l_wsh07
                            
                                LET l_sql = "SELECT ",l_wsi02 CLIPPED," FROM ",l_wsi03 CLIPPED,
                                            " WHERE ",l_wsi04 CLIPPED,"='",l_value CLIPPED,"'"
                            
                                IF l_wsi06 IS NOT NULL THEN
                                   LET l_sql = l_sql CLIPPED," AND ", l_wsi06 CLIPPED 
                                END IF    
                                DECLARE wsh04_cs_b2 CURSOR FROM l_sql
                                FOREACH wsh04_cs_b2 INTO l_refvalue
                                END FOREACH
                                LET l_reference = l_reference CLIPPED,' ', l_refvalue
                            
                                IF l_wsh08 IS NOT NULL THEN             #參考欄位3
                                   LET l_refvalue = NULL
                                   SELECT wsi02,wsi03,wsi04,wsi06 INTO l_wsi02,l_wsi03,l_wsi04,l_wsi06 
                                      FROM wsi_file where wsi01 = g_prog AND wsi05 = l_wsh05 AND wsi02 = l_wsh08
                            
                                   LET l_sql = "SELECT ",l_wsi02 CLIPPED," FROM ",l_wsi03 CLIPPED,
                                            " WHERE ",l_wsi04 CLIPPED,"='",l_value CLIPPED,"'"
                            
                                   IF l_wsi06 IS NOT NULL THEN
                                      LET l_sql = l_sql CLIPPED," AND ", l_wsi06 CLIPPED 
                                   END IF    
                                   DECLARE wsh04_cs_b3 CURSOR FROM l_sql
                                   FOREACH wsh04_cs_b3 INTO l_refvalue
                                   END FOREACH
                                   LET l_reference = l_reference CLIPPED,' ', l_refvalue
                            
                                END IF
                             END IF
                            IF l_gae04 IS NOT NULL THEN
                                LET l_value = l_value ,":",l_gae04
                            END IF
                            LET g_strXMLInput = g_strXMLInput CLIPPED,
                              #"       <",l_wsh05 CLIPPED,">", l_value ," ", l_reference CLIPPED, "</",l_wsh05 CLIPPED,">", ASCII 10                         #FUN-BB0061 mark
                              #"       <",l_wsh05 CLIPPED, " type=\"", l_type, "\">", l_value ," ", l_reference CLIPPED, "</",l_wsh05 CLIPPED,">", ASCII 10   #FUN-BB0061 在tag中增加type="0"(文字):type="1"(數字)屬性給EasyFlow判斷
                               "       <",l_wsh05 CLIPPED, " type=\"", l_type, "\">", aws_efcli2_eol(l_value) ," ", aws_efcli2_eol(l_reference) CLIPPED, "</",l_wsh05 CLIPPED,">", ASCII 10   #FUN-C40061
                        ELSE
                            IF l_gae04 IS NOT NULL THEN
                                LET l_value = l_value ,":",l_gae04
                            END IF
                            LET g_strXMLInput = g_strXMLInput CLIPPED,
                              #"       <",l_wsh05 CLIPPED,">", l_value , "</",l_wsh05 CLIPPED,">", ASCII 10                                                      #FUN-BB0061 mark
                              #"       <",l_wsh05 CLIPPED, " type=\"", l_type, "\">", l_value , "</",l_wsh05 CLIPPED,">", ASCII 10                                #FUN-BB0061 在tag中增加type="0"(文字):type="1"(數字)屬性給EasyFlow判斷
                               "       <",l_wsh05 CLIPPED, " type=\"", l_type, "\">", aws_efcli2_eol( l_value) , "</",l_wsh05 CLIPPED,">", ASCII 10   #FUN-C40061
                        END IF
                  END IF
               END FOR
              LET g_strXMLInput = g_strXMLInput CLIPPED,
                                  "      </record>", ASCII 10
           END FOR
           LET g_strXMLInput = g_strXMLInput CLIPPED,   #組 XML Trailer
                               "    </body>", ASCII 10
        ELSE
           IF k = 1 THEN
              LET g_strXMLInput = g_strXMLInput CLIPPED,   #組 XML Trailer
                                  "    <body>", ASCII 10,
                                  "    </body>", ASCII 10
 
           END IF
           EXIT FOR
        END IF
     END FOR
     #呼叫 aws_efcli2_XMLTrailer() 組出 XML Trailer 資訊
     CALL aws_efcli2_XMLTrailer()
END FUNCTION
 
FUNCTION aws_condition()
DEFINE l_window     ui.Window 
DEFINE lnode_item     om.DomNode
DEFINE l_wse03       LIKE wse_file.wse03
#-----MOD-890129---------
DEFINE l_wse04       LIKE wse_file.wse04 
DEFINE l_wse05       LIKE wse_file.wse05 
DEFINE l_wse06       LIKE wse_file.wse06 
DEFINE l_wse07       LIKE wse_file.wse07 
DEFINE l_where       STRING
DEFINE l_sql         STRING
#-----END MOD-890129-----
DEFINE l_wse08       LIKE wse_file.wse08
DEFINE l_wse09       LIKE wse_file.wse09
DEFINE l_wse10       LIKE wse_file.wse10
DEFINE l_wse11       LIKE wse_file.wse11
#TQC-720066
DEFINE ln_w          om.DomNode
DEFINE nl_node       om.NodeList
DEFINE l_name        STRING
DEFINE l_i           LIKE type_file.num5
DEFINE l_cnt         LIKE type_file.num5
#END TQC-720066
 
   SELECT * INTO g_wse.* FROM wse_file where wse01=g_prog
   IF SQLCA.SQLCODE OR SQLCA.SQLCODE = NOTFOUND THEN
#     CALL cl_err("select wse failed: ", SQLCA.SQLCODE, 0)   #No.FUN-660155
      CALL cl_err3("sel","wse_file",g_prog,"",SQLCA.sqlcode,"","select wse failed:", 0)   #No.FUN-660155)   #No.FUN-660155
      LET g_success='N'
      RETURN 
   END IF
 
   IF g_aza.aza23 matches '[ Nn]' THEN          #未設定與 EasyFlow 簽核
      CALL cl_err('aza23','mfg3551',0)
      LET g_success='N'
      RETURN
   END IF
 
   #TQC-720066
   LET l_window = ui.Window.getCurrent()
   LET ln_w = l_window.getNode()
   LET nl_node = ln_w.selectByTagName("FormField")
   LET l_cnt = nl_node.getLength()
 
   #LET lnode_item = l_window.findNode("FormField",g_wse.wse03 CLIPPED)
   #IF lnode_item IS NULL THEN
   #    LET l_wse03 = ""
   #ELSE
   #    LET l_wse03 = lnode_item.getAttribute("value")
   #END IF
 
   LET l_wse03 = ""
   FOR l_i = 1 TO l_cnt
        LET lnode_item = nl_node.item(l_i)
        LET l_name = lnode_item.getAttribute("colName")
        IF cl_null(l_name) THEN
           LET l_name = lnode_item.getAttribute("name")
        END IF
        IF l_name = g_wse.wse03 CLIPPED THEN
           LET l_wse03 = lnode_item.getAttribute("value")
           EXIT FOR
        END IF
   END FOR
 
   IF l_wse03 IS NULL OR l_wse03 = ' ' THEN      #尚未查詢資料
      LET g_success='N'
      RETURN
   END IF
 
   #-----MOD-890129---------
   LET l_wse03 = aws_efcli2_getdata( g_wse.wse03 , l_wse03)  #FUN-C40086

   LET l_where = " WHERE ",g_wse.wse03 CLIPPED,"='",l_wse03 CLIPPED,"' "
 
   IF NOT cl_null(g_wse.wse04) THEN
      LET l_wse04 = ""
      FOR l_i = 1 TO l_cnt
           LET lnode_item = nl_node.item(l_i)
           LET l_name = lnode_item.getAttribute("colName")
           IF cl_null(l_name) THEN
              LET l_name = lnode_item.getAttribute("name")
           END IF
           IF l_name = g_wse.wse04 CLIPPED THEN
              LET l_wse04 = lnode_item.getAttribute("value")
              EXIT FOR
           END IF
      END FOR
      LET l_where = l_where CLIPPED," AND ",g_wse.wse04 CLIPPED,"='",l_wse04 CLIPPED,"' "
   END IF
   IF NOT cl_null(g_wse.wse05) THEN
      LET l_wse05 = ""
      FOR l_i = 1 TO l_cnt
           LET lnode_item = nl_node.item(l_i)
           LET l_name = lnode_item.getAttribute("colName")
           IF cl_null(l_name) THEN
              LET l_name = lnode_item.getAttribute("name")
           END IF
           IF l_name = g_wse.wse05 CLIPPED THEN
              LET l_wse05 = lnode_item.getAttribute("value")
              EXIT FOR
           END IF
      END FOR
      LET l_where = l_where CLIPPED," AND ",g_wse.wse05 CLIPPED,"='",l_wse05 CLIPPED,"' "
   END IF
   IF NOT cl_null(g_wse.wse06) THEN
      LET l_wse06 = ""
      FOR l_i = 1 TO l_cnt
           LET lnode_item = nl_node.item(l_i)
           LET l_name = lnode_item.getAttribute("colName")
           IF cl_null(l_name) THEN
              LET l_name = lnode_item.getAttribute("name")
           END IF
           IF l_name = g_wse.wse06 CLIPPED THEN
              LET l_wse06 = lnode_item.getAttribute("value")
              EXIT FOR
           END IF
      END FOR
      LET l_where = l_where CLIPPED," AND ",g_wse.wse06 CLIPPED,"='",l_wse06 CLIPPED,"' "
   END IF
   IF NOT cl_null(g_wse.wse07) THEN
      LET l_wse07 = ""
      FOR l_i = 1 TO l_cnt
           LET lnode_item = nl_node.item(l_i)
           LET l_name = lnode_item.getAttribute("colName")
           IF cl_null(l_name) THEN
              LET l_name = lnode_item.getAttribute("name")
           END IF
           IF l_name = g_wse.wse07 CLIPPED THEN
              LET l_wse07 = lnode_item.getAttribute("value")
              EXIT FOR
           END IF
      END FOR
      LET l_where = l_where CLIPPED," AND ",g_wse.wse07 CLIPPED,"='",l_wse07 CLIPPED,"' "
   END IF
   IF NOT cl_null(g_wse.wse08) THEN 
      LET l_sql = "SELECT ",g_wse.wse08 CLIPPED," FROM ",g_wse.wse02 CLIPPED,
                  l_where
      PREPARE wse_pre1 FROM l_sql
      DECLARE wse_cur1 CURSOR FOR wse_pre1
      OPEN wse_cur1
      FETCH wse_cur1 INTO l_wse08
      IF l_wse08 IS NULL OR l_wse08 matches '[Nn]' THEN    #是否簽核
         CALL cl_err('','mfg3549',0)
         LET g_success='N'
         RETURN
      END IF
      CLOSE wse_cur1
   END IF
   IF NOT cl_null(g_wse.wse09) THEN 
      LET l_sql = "SELECT ",g_wse.wse09 CLIPPED," FROM ",g_wse.wse02 CLIPPED,
                  l_where
      PREPARE wse_pre2 FROM l_sql
      DECLARE wse_cur2 CURSOR FOR wse_pre2
      OPEN wse_cur2
      FETCH wse_cur2 INTO l_wse09
      IF l_wse09 = 'Y'    THEN                    #判斷是否確認
         CALL cl_err('','9023',0)
         LET g_success='N'
         RETURN 
      END IF
      IF l_wse09 matches '[X]' THEN   #是否作廢
         CALL cl_err('','9024',0)
          LET g_success='N'
         RETURN
      END IF
      CLOSE wse_cur2
   END IF
   IF NOT cl_null(g_wse.wse10) THEN 
      LET l_sql = "SELECT ",g_wse.wse10 CLIPPED," FROM ",g_wse.wse02 CLIPPED,
                  l_where
      PREPARE wse_pre3 FROM l_sql
      DECLARE wse_cur3 CURSOR FOR wse_pre3
      OPEN wse_cur3
      FETCH wse_cur3 INTO l_wse10
      IF l_wse10 matches '[Ss1]' THEN
         CALL cl_err('','mfg3557',0)           #本單據目前已送簽或已核准
         LET g_success='N'
         RETURN
      END IF
      IF l_wse10 matches '[9]' THEN   #是否作廢
         CALL cl_err('','9024',0)
          LET g_success='N'
         RETURN
      END IF
      CLOSE wse_cur3
   END IF
   IF NOT cl_null(g_wse.wse11) THEN 
      LET l_sql = "SELECT ",g_wse.wse11 CLIPPED," FROM ",g_wse.wse02 CLIPPED,
                  l_where
      PREPARE wse_pre4 FROM l_sql
      DECLARE wse_cur4 CURSOR FOR wse_pre4
      OPEN wse_cur4
      FETCH wse_cur4 INTO l_wse11
      IF l_wse11 IS NULL OR l_wse11 matches '[Nn]' THEN    #資料是否有效
         CALL cl_err('','aoo-013',0)
         LET g_success='N'
         RETURN
      END IF
      CLOSE wse_cur4
   END IF
 
   ##LET lnode_item = l_window.findNode("FormField",g_wse.wse08 CLIPPED)
   ##IF lnode_item IS NULL THEN
   ##    LET l_wse08 = ""
   ##ELSE
   ##    LET l_wse08 = lnode_item.getAttribute("value")
   ##END IF
   #FOR l_i = 1 TO l_cnt
   #     LET lnode_item = nl_node.item(l_i)
   #     LET l_name = lnode_item.getAttribute("colName")
   #     IF cl_null(l_name) THEN
   #        LET l_name = lnode_item.getAttribute("name")
   #     END IF
   #     IF l_name = g_wse.wse08 CLIPPED THEN
   #        LET l_wse08 = lnode_item.getAttribute("value")
   #        EXIT FOR
   #     END IF
   #END FOR
   #
   #IF l_wse08 IS NULL OR l_wse08 matches '[Nn]' THEN    #是否簽核
   #   CALL cl_err('','mfg3549',0)
   #   LET g_success='N'
   #   RETURN
   #END IF
   #
   #IF g_wse.wse09 IS NOT NULL THEN
   #   #LET lnode_item = l_window.findNode("FormField",g_wse.wse09 CLIPPED)
   #   #IF lnode_item IS NULL THEN
   #   #    LET l_wse09 = ""
   #   #ELSE
   #   #    LET l_wse09 = lnode_item.getAttribute("value")
   #   #END IF
   #   LET l_wse09 = ""
   #   FOR l_i = 1 TO l_cnt
   #        LET lnode_item = nl_node.item(l_i)
   #        LET l_name = lnode_item.getAttribute("colName")
   #        IF cl_null(l_name) THEN
   #           LET l_name = lnode_item.getAttribute("name")
   #        END IF
   #        IF l_name = g_wse.wse09 CLIPPED THEN
   #           LET l_wse09 = lnode_item.getAttribute("value")
   #           EXIT FOR
   #        END IF
   #   END FOR
   #
   #   IF l_wse09 = 'Y'    THEN                    #判斷是否確認
   #      CALL cl_err('','9023',0)
   #      LET g_success='N'
   #      RETURN 
   #   END IF
   #   IF l_wse09 matches '[X]' THEN   #是否作廢
   #      CALL cl_err('','9024',0)
   #       LET g_success='N'
   #      RETURN
   #   END IF
   #END IF
   #
   ##LET lnode_item = l_window.findNode("FormField",g_wse.wse10 CLIPPED)
   ##IF lnode_item IS NULL THEN
   ##    LET l_wse10 = ""
   ##ELSE
   ##    LET l_wse10 = lnode_item.getAttribute("value")
   ##END IF
   #LET l_wse10 = ""
   #FOR l_i = 1 TO l_cnt
   #     LET lnode_item = nl_node.item(l_i)
   #     LET l_name = lnode_item.getAttribute("colName")
   #     IF cl_null(l_name) THEN
   #        LET l_name = lnode_item.getAttribute("name")
   #     END IF
   #     IF l_name = g_wse.wse10 CLIPPED THEN
   #        LET l_wse10 = lnode_item.getAttribute("value")
   #        EXIT FOR
   #     END IF
   #END FOR
   #
   #IF l_wse10 matches '[Ss1]' THEN
   #   CALL cl_err('','mfg3557',0)           #本單據目前已送簽或已核准
   #   LET g_success='N'
   #   RETURN
   #END IF
   #IF l_wse10 matches '[9]' THEN   #是否作廢
   #   CALL cl_err('','9024',0)
   #    LET g_success='N'
   #   RETURN
   #END IF
   #
   #IF g_wse.wse11 IS NOT NULL THEN
   #   #LET lnode_item = l_window.findNode("FormField",g_wse.wse11 CLIPPED)
   #   #IF lnode_item IS NULL THEN
   #   #    LET l_wse11 = ""
   #   #ELSE
   #   #    LET l_wse11 = lnode_item.getAttribute("value")
   #   #END IF
   #   LET l_wse11 = ""
   #   FOR l_i = 1 TO l_cnt
   #        LET lnode_item = nl_node.item(l_i)
   #        LET l_name = lnode_item.getAttribute("colName")
   #        IF cl_null(l_name) THEN
   #           LET l_name = lnode_item.getAttribute("name")
   #        END IF
   #        IF l_name = g_wse.wse11 CLIPPED THEN
   #           LET l_wse11 = lnode_item.getAttribute("value")
   #           EXIT FOR
   #        END IF
   #   END FOR
   #
   #   IF l_wse11 IS NULL OR l_wse11 matches '[Nn]' THEN    #資料是否有效
   #      CALL cl_err('','aoo-013',0)
   #      LET g_success='N'
   #      RETURN
   #   END IF
   #END IF
   ##END TQC-720066
   #-----END MOD-890129-----
   LET g_success = "Y"
END FUNCTION
 
FUNCTION aws_condition2()
DEFINE l_window     ui.Window 
DEFINE lnode_item     om.DomNode
DEFINE l_wse03       LIKE wse_file.wse03
#-----MOD-890129---------
DEFINE l_wse04       LIKE wse_file.wse04
DEFINE l_wse05       LIKE wse_file.wse05
DEFINE l_wse06       LIKE wse_file.wse06
DEFINE l_wse07       LIKE wse_file.wse07
DEFINE l_where       STRING
DEFINE l_sql         STRING
#-----END MOD-890129-----
DEFINE l_wse08       LIKE wse_file.wse08           #FUN-580011
DEFINE l_wse09       LIKE wse_file.wse09   #MOD-720032
DEFINE l_wse10       LIKE wse_file.wse10
#TQC-720066
DEFINE ln_w          om.DomNode
DEFINE nl_node       om.NodeList
DEFINE l_name        STRING
DEFINE l_i           LIKE type_file.num5
DEFINE l_cnt         LIKE type_file.num5
#END TQC-720066
 
   IF g_aza.aza23 matches '[ Nn]' THEN   #未設定與 EasyFlow 簽核
      CALL cl_err('aza23','mfg3551',0)
      RETURN 0
   END IF
 
   SELECT * INTO g_wse.* FROM wse_file where wse01=g_prog
   IF SQLCA.SQLCODE OR SQLCA.SQLCODE = NOTFOUND THEN
#     CALL cl_err("select wse failed: ", SQLCA.SQLCODE, 0)   #No.FUN-660155
      CALL cl_err3("sel","wse_file",g_prog,"",SQLCA.sqlcode,"","select wse failed:", 0)   #No.FUN-660155)   #No.FUN-660155
      RETURN  0
   END IF
 
   LET l_window = ui.Window.getCurrent()
   #TQC-720066
   LET ln_w = l_window.getNode()
   LET nl_node = ln_w.selectByTagName("FormField")
   LET l_cnt = nl_node.getLength()
 
   #LET lnode_item = l_window.findNode("FormField",g_wse.wse03 CLIPPED)
   #IF lnode_item IS NULL THEN
   #    LET l_wse03 = ""
   #ELSE
   #    LET l_wse03 = lnode_item.getAttribute("value")
   #END IF
   LET l_wse03 = ""
   FOR l_i = 1 TO l_cnt
        LET lnode_item = nl_node.item(l_i)
        LET l_name = lnode_item.getAttribute("colName")
        IF cl_null(l_name) THEN
           LET l_name = lnode_item.getAttribute("name")
        END IF
        IF l_name = g_wse.wse03 CLIPPED THEN
           LET l_wse03 = lnode_item.getAttribute("value")
           EXIT FOR
        END IF
   END FOR
 
   IF l_wse03 IS NULL OR l_wse03 = ' ' THEN      #尚未查詢資料
      CALL cl_err('', -400, 0)
      RETURN 0
   END IF
 
   #-----MOD-890129---------
   LET l_wse03 = aws_efcli2_getdata( g_wse.wse03 , l_wse03)  #FUN-C40086

   LET l_where = " WHERE ",g_wse.wse03 CLIPPED,"='",l_wse03 CLIPPED,"' "
 
   IF NOT cl_null(g_wse.wse04) THEN
      LET l_wse04 = ""
      FOR l_i = 1 TO l_cnt
           LET lnode_item = nl_node.item(l_i)
           LET l_name = lnode_item.getAttribute("colName")
           IF cl_null(l_name) THEN
              LET l_name = lnode_item.getAttribute("name")
           END IF
           IF l_name = g_wse.wse04 CLIPPED THEN
              LET l_wse04 = lnode_item.getAttribute("value")
              EXIT FOR
           END IF
      END FOR
      LET l_where = l_where CLIPPED," AND ",g_wse.wse04 CLIPPED,"='",l_wse04 CLIPPED,"' "
   END IF
   IF NOT cl_null(g_wse.wse05) THEN
      LET l_wse05 = ""
      FOR l_i = 1 TO l_cnt
           LET lnode_item = nl_node.item(l_i)
           LET l_name = lnode_item.getAttribute("colName")
           IF cl_null(l_name) THEN
              LET l_name = lnode_item.getAttribute("name")
           END IF
           IF l_name = g_wse.wse05 CLIPPED THEN
              LET l_wse05 = lnode_item.getAttribute("value")
              EXIT FOR
           END IF
      END FOR
      LET l_where = l_where CLIPPED," AND ",g_wse.wse05 CLIPPED,"='",l_wse05 CLIPPED,"' "
   END IF
   IF NOT cl_null(g_wse.wse06) THEN
      LET l_wse06 = ""
      FOR l_i = 1 TO l_cnt
           LET lnode_item = nl_node.item(l_i)
           LET l_name = lnode_item.getAttribute("colName")
           IF cl_null(l_name) THEN
              LET l_name = lnode_item.getAttribute("name")
           END IF
           IF l_name = g_wse.wse06 CLIPPED THEN
              LET l_wse06 = lnode_item.getAttribute("value")
              EXIT FOR
           END IF
      END FOR
      LET l_where = l_where CLIPPED," AND ",g_wse.wse06 CLIPPED,"='",l_wse06 CLIPPED,"' "
   END IF
   IF NOT cl_null(g_wse.wse07) THEN
      LET l_wse07 = ""
      FOR l_i = 1 TO l_cnt
           LET lnode_item = nl_node.item(l_i)
           LET l_name = lnode_item.getAttribute("colName")
           IF cl_null(l_name) THEN
              LET l_name = lnode_item.getAttribute("name")
           END IF
           IF l_name = g_wse.wse07 CLIPPED THEN
              LET l_wse07 = lnode_item.getAttribute("value")
              EXIT FOR
           END IF
      END FOR
      LET l_where = l_where CLIPPED," AND ",g_wse.wse07 CLIPPED,"='",l_wse07 CLIPPED,"' "
   END IF
   IF NOT cl_null(g_wse.wse08) THEN 
      LET l_sql = "SELECT ",g_wse.wse08 CLIPPED," FROM ",g_wse.wse02 CLIPPED,
                  l_where
      PREPARE wse_pre1_2 FROM l_sql
      DECLARE wse_cur1_2 CURSOR FOR wse_pre1_2
      OPEN wse_cur1_2
      FETCH wse_cur1_2 INTO l_wse08
      IF l_wse08 IS NULL OR l_wse08 matches '[Nn]' THEN    #是否簽核
         CALL cl_err('','mfg3549',0)
         LET g_success='N'
         RETURN 0
      END IF
      CLOSE wse_cur1_2
   END IF
   IF NOT cl_null(g_wse.wse09) THEN 
      LET l_sql = "SELECT ",g_wse.wse09 CLIPPED," FROM ",g_wse.wse02 CLIPPED,
                  l_where
      PREPARE wse_pre2_2 FROM l_sql
      DECLARE wse_cur2_2 CURSOR FOR wse_pre2_2
      OPEN wse_cur2_2
      FETCH wse_cur2_2 INTO l_wse09
      CLOSE wse_cur2_2
   END IF
   IF NOT cl_null(g_wse.wse10) THEN 
      LET l_sql = "SELECT ",g_wse.wse10 CLIPPED," FROM ",g_wse.wse02 CLIPPED,
                  l_where
      PREPARE wse_pre3_2 FROM l_sql
      DECLARE wse_cur3_2 CURSOR FOR wse_pre3_2
      OPEN wse_cur3_2
      FETCH wse_cur3_2 INTO l_wse10
      CLOSE wse_cur3_2
   END IF
   IF l_wse10 NOT matches '[S1WR]' AND l_wse09 = 'N' THEN
      RETURN 0
   END IF
 
   ##FUN-580011
   ##LET lnode_item = l_window.findNode("FormField",g_wse.wse08 CLIPPED)
   ##IF lnode_item IS NULL THEN
   ##    LET l_wse08 = ""
   ##ELSE
   ##    LET l_wse08 = lnode_item.getAttribute("value")
   ##END IF
   #LET l_wse08 = ""
   #FOR l_i = 1 TO l_cnt
   #     LET lnode_item = nl_node.item(l_i)
   #     LET l_name = lnode_item.getAttribute("colName")
   #     IF cl_null(l_name) THEN
   #        LET l_name = lnode_item.getAttribute("name")
   #     END IF
   #     IF l_name = g_wse.wse08 CLIPPED THEN
   #        LET l_wse08 = lnode_item.getAttribute("value")
   #        EXIT FOR
   #     END IF
   #END FOR
   #
   #IF l_wse08 IS NULL OR l_wse08 matches '[Nn]' THEN    #是否簽核
   #   CALL cl_err('','mfg3549',0)
   #   LET g_success='N'
   #   RETURN 0
   #END IF
   ##END FUN-580011
   #
   ##LET lnode_item = l_window.findNode("FormField",g_wse.wse10 CLIPPED)
   ##IF lnode_item IS NULL THEN
   ##    LET l_wse10 = ""
   ##ELSE
   ##    LET l_wse10 = lnode_item.getAttribute("value")
   ##END IF
   #
   #LET l_wse10 = ""
   #FOR l_i = 1 TO l_cnt
   #     LET lnode_item = nl_node.item(l_i)
   #     LET l_name = lnode_item.getAttribute("colName")
   #     IF cl_null(l_name) THEN
   #        LET l_name = lnode_item.getAttribute("name")
   #     END IF
   #     IF l_name = g_wse.wse10 CLIPPED THEN
   #        LET l_wse10 = lnode_item.getAttribute("value")
   #        EXIT FOR
   #     END IF
   #END FOR
   #
   ##-----MOD-720032---------
   ##LET lnode_item = l_window.findNode("FormField",g_wse.wse09 CLIPPED)
   ##IF lnode_item IS NULL THEN
   ##    LET l_wse09 = ""
   ##ELSE
   ##    LET l_wse09 = lnode_item.getAttribute("value")
   ##END IF
   #LET l_wse09 = ""
   #FOR l_i = 1 TO l_cnt
   #     LET lnode_item = nl_node.item(l_i)
   #     LET l_name = lnode_item.getAttribute("colName")
   #     IF cl_null(l_name) THEN
   #        LET l_name = lnode_item.getAttribute("name")
   #     END IF
   #     IF l_name = g_wse.wse09 CLIPPED THEN
   #        LET l_wse09 = lnode_item.getAttribute("value")
   #        EXIT FOR
   #     END IF
   #END FOR
   ##END TQC-720066
   #
   ##IF l_wse10 NOT matches '[S1WR]' THEN
   #IF l_wse10 NOT matches '[S1WR]' AND l_wse09 = 'N' THEN
   ##-----END MOD-720032----- 
   #   RETURN 0
   #END IF
   #-----END MOD-890129-----
   RETURN 1
END FUNCTION
 
#FUN-770047
# Description....: 組備註說明 XML
# Date & Author..: 2007/07/18 by Echo
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#]
FUNCTION aws_efcli2_memo()
DEFINE l_wsq           RECORD LIKE wsq_file.*
DEFINE l_memo_field DYNAMIC ARRAY OF LIKE wsh_file.wsh05
DEFINE l_table_data DYNAMIC ARRAY OF RECORD
        field001, field002, field003, field004, field005,
        field006, field007, field008, field009, field010,
        field011, field012, field013, field014, field015,
        field016, field017, field018, field019, field020 LIKE type_file.chr1000 
                    END RECORD
DEFINE n_field      om.DomNode
DEFINE n_record     om.DomNode
DEFINE nl_field     om.NodeList
DEFINE nl_record    om.NodeList
DEFINE cnt_record   LIKE type_file.num10
DEFINE l_gae04      LIKE gae_file.gae04,
       l_wsh04      LIKE wsh_file.wsh04
DEFINE l_sql        STRING
DEFINE l_field_sql  STRING
DEFINE l_value      STRING
DEFINE l_memo_cnt   LIKE type_file.num10
DEFINE l_i,l_j      LIKE type_file.num10
DEFINE l_cnt        LIKE type_file.num10
DEFINE l_memo       om.DomNode
 
     SELECT * INTO l_wsq.* FROM wsq_file WHERE wsq01 = g_prog 
     IF cl_null(l_wsq.wsq01) THEN
        LET g_strXMLInput = g_strXMLInput CLIPPED,   #組 XML Trailer
                            "    <memo>", ASCII 10,
                            "    </memo>", ASCII 10
        RETURN
     END IF
     
     DECLARE wsh_cs CURSOR FOR 
         SELECT wsh04,wsh05 FROM wsh_file 
         WHERE wsh01=g_prog AND wsh02='R' ORDER BY wsh04
     LET l_cnt = 1
     FOREACH wsh_cs INTO l_wsh04,l_memo_field[l_cnt]
         IF l_cnt = 1 THEN
            LET l_field_sql = l_memo_field[l_cnt] CLIPPED
         ELSE 
            LET l_field_sql = l_field_sql ,',', l_memo_field[l_cnt] CLIPPED
         END IF
         LET l_cnt = l_cnt +1
     END FOREACH
     LET l_memo_cnt = l_cnt - 1
   
     #組抓取備註資料的 SQL 
     LET l_sql = "SELECT ", l_field_sql," FROM ",l_wsq.wsq02 CLIPPED,
                 " WHERE ",l_wsq.wsq03 CLIPPED,"='",g_formNum_key CLIPPED,"'"
     IF NOT cl_null(l_wsq.wsq04) THEN
        LET l_sql = l_sql ," AND ", l_wsq.wsq04 CLIPPED,"='",g_key1 CLIPPED,"'"
     END IF
     IF NOT cl_null(l_wsq.wsq05) THEN
        LET l_sql = l_sql ," AND ", l_wsq.wsq05 CLIPPED,"='",g_key2 CLIPPED,"'"
     END IF
     IF NOT cl_null(l_wsq.wsq06) THEN
        LET l_sql = l_sql ," AND ", l_wsq.wsq06 CLIPPED,"='",g_key3 CLIPPED,"'"
     END IF
     IF NOT cl_null(l_wsq.wsq07) THEN
        LET l_sql = l_sql ," AND ", l_wsq.wsq07 CLIPPED,"='",g_key4 CLIPPED,"'"
     END IF
  
     LET l_sql = l_sql, " ORDER BY ", l_field_sql
  
     DECLARE memo_cs CURSOR FROM l_sql
     LET l_i = 1
     FOREACH memo_cs INTO l_table_data[l_i].*
         LET l_i = l_i + 1
     END FOREACH
     CALL l_table_data.deleteElement(l_i)
     LET l_i = l_i - 1
     IF l_i = 0 THEN
        LET g_strXMLInput = g_strXMLInput CLIPPED,   #組 XML Trailer
                            "    <memo>", ASCII 10,
                            "    </memo>", ASCII 10
        RETURN
     END IF
  
     #解析欄位資訊，並組成備註XML
     LET g_strXMLInput = g_strXMLInput CLIPPED,
                         "    <memo>", ASCII 10
  
     LET l_memo = base.TypeInfo.create(l_table_data)
     CALL l_memo.writeXML('test.xml')
     LET nl_record = l_memo.selectByTagName("Record")
     LET cnt_record = nl_record.getLength()
     FOR l_i = 1 to cnt_record
         LET g_strXMLInput = g_strXMLInput CLIPPED,
                             "      <record>", ASCII 10
  
         LET n_record = nl_record.item(l_i)
         LET nl_field = n_record.selectByTagName("Field")
         #只抓取設定的欄位數
         FOR l_j =1 to l_memo_cnt   
             LET n_field = nl_field.item(l_j)
             LET l_value = n_field.getAttribute("value")
             LET l_cnt = 0         
             LET l_sql = "SELECT COUNT(*) FROM gae_file ",
                         " WHERE gae02='",l_memo_field[l_j] CLIPPED,"_",l_value,"'",
                         "   AND gae03='",g_lang,"'",
                         "   AND gae12='",g_sma.sma124,"'"           #CHI-9C0016
             DECLARE gae_count CURSOR FROM l_sql
             OPEN gae_count
             FETCH gae_count INTO l_cnt
             IF l_cnt > 0 THEN
                 LET l_sql = "SELECT gae04 FROM gae_file ",
                         " WHERE gae02='",l_memo_field[l_j] CLIPPED,"_",l_value,"'",
                         "   AND gae03='",g_lang,"'",
                         "   AND gae11='Y' AND gae12='",g_sma.sma124,"'"           #CHI-9C0016
                 DECLARE gae_cs CURSOR FROM l_sql
                 OPEN gae_cs
                 FETCH gae_cs INTO l_gae04
                #-CHI-9C0016-add-
                 IF SQLCA.sqlcode THEN
                    LET l_sql = "SELECT gae04 FROM gae_file ",
                            " WHERE gae02='",l_memo_field[l_j] CLIPPED,"_",l_value,"'",
                            "   AND gae03='",g_lang,"'",
                            "   AND (gae11 IS NULL OR gae11 = 'N') AND gae12='",g_sma.sma124,"'" 
                    DECLARE gae_cs2 CURSOR FROM l_sql
                    OPEN gae_cs2
                    FETCH gae_cs2 INTO l_gae04
                 END IF
                #-CHI-9C0016-end-
                 LET l_value = l_value.trim(),":",l_gae04 CLIPPED
             END IF        
             LET g_strXMLInput = g_strXMLInput CLIPPED,
             "        <",l_memo_field[l_j],">",l_value,"</",l_memo_field[l_j],">", ASCII 10
         END FOR
         LET g_strXMLInput = g_strXMLInput CLIPPED,
                             "      </record>", ASCII 10
     END FOR
     LET g_strXMLInput = g_strXMLInput CLIPPED,
                         "    </memo>", ASCII 10
END FUNCTION 
#END FUN-770047

# --- FUN-BB0061 --- Start ---
# Description....: 格式轉換 for hard code
# Date & Author..: 2011/12/21 by ka0132
# Parameter......: l_prog(程式名稱), l_tag(欄位名稱)
# Return.........: l_format(輸出格式)
# Memo...........:
# Modify.........:
FUNCTION aws_efcli2_format()
DEFINE l_input    STRING 
DEFINE l_output   STRING 
DEFINE l_doc      om.DomDocument
DEFINE l_xml      om.DomNode
DEFINE l_cn       om.DomNode
DEFINE l_type     INTEGER 
DEFINE l_c        INTEGER 
DEFINE l_tag      CHAR(20) 
DEFINE l_program  CHAR(20)  
DEFINE l_gav06c   CHAR(50)  
DEFINE l_gav06    STRING 
DEFINE l_aza43    CHAR(5)  
DEFINE l_wsh09    LIKE wsh_file.wsh09   #CHI-BC0010
DEFINE l_wsh10    LIKE wsh_file.wsh10   #CHI-BC0010
DEFINE l_gav11    LIKE gav_file.gav11   #CHI-BC0010
DEFINE l_format   STRING                #CHI-BC0010

    LET l_input = cl_replace_str(g_strXMLInput,"\n","")
    LET l_doc = om.DomDocument.createFromString(l_input) 
    LET l_xml = l_doc.getDocumentElement()
    LET l_type = 1
    LET l_xml = l_xml.getChildByIndex(1)

    SELECT aza43 INTO l_aza43 FROM aza_file 
    IF l_aza43 ="Y" THEN
    WHILE l_xml.getParent() IS NOT NULL #scan所有node並判斷是否需要進行格式轉換
    LET l_program = g_prog
        CASE 
            WHEN l_xml.getChildByIndex(1) IS NOT NULL AND l_type <> 2   
                LET l_cn = l_xml.getFirstChild()
                LET l_tag = l_xml.getTagName() 
                #CHI-BC0010 - Start - #判斷該欄位是否有參照其他欄位
                CALL aws_efcli2_format_wsh(l_program, l_tag) RETURNING l_program, l_tag
                #CHI-BC0010 -  End  -

                LET l_gav06c = ""
                SELECT sma124 INTO l_gav11 from sma_file                         #CHI-BC0010
                SELECT gav06 INTO l_gav06c FROM gav_file                         #CHI-BC0010
                   WHERE gav02 = l_tag AND gav01 = l_program AND gav11 = l_gav11 #CHI-BC0010
                LET l_gav06 = l_gav06c
                LET l_gav06 = l_gav06.trim()
                
                IF l_gav06 IS NOT NULL THEN #gav06代表自由格式定義, 若有定義自由格式才進行轉換
                    #TQC-BC0167 - Start -
                    LET l_format = aws_efcli2_forchk(l_gav06)

                    IF l_format IS NOT NULL THEN
                        CALL l_cn.setAttribute("@chars",l_cn.getAttributeValue(1) USING l_format)
                    END IF
                    #TQC-BC0167 -  End  -
                END IF 
                
                LET l_xml = l_xml.getChildByIndex(1)
                LET l_type = 1
            WHEN l_xml.getNext() IS NULL 
                LET l_xml = l_xml.getParent()
                LET l_type = 2
            OTHERWISE  
                LET l_xml = l_xml.getNext()
                LET l_type = 3
        END CASE  
        
    END WHILE 
    END IF

    LET l_xml = l_doc.getDocumentElement()
    LET l_output = l_xml.toString()
    LET l_c = l_output.getIndexOf("?>",1) + 3
    LET l_output = l_output.subString(l_c,l_output.getLength()) #去除內建產生之標頭tag
    LET g_strXMLInput = l_output

END FUNCTION
# --- FUN-BB0061 ---  END  ---

# --- CHI-BC0010 --- Start ---
# CHI-BC0010
# Description....: 確認欄位是否有參照其他欄位格式
# Date & Author..: 2011/11/27 by ka0132
# Parameter......: l_prog(程式名稱), l_tag(欄位名稱)
# Return.........: l_prog(參照之程式名稱), l_tag(參照之欄位名稱)
# Memo...........:
# Modify.........:
FUNCTION aws_efcli2_format_wsh(l_prog, l_tag)
DEFINE l_prog   CHAR(50)              #程式代碼
DEFINE l_tag    CHAR(50)              #欄位代碼
DEFINE l_wsh09  LIKE wsh_file.wsh09   #參照的程式代碼
DEFINE l_wsh10  LIKE wsh_file.wsh10   #參照的欄位代碼
DEFINE l_wsd02  LIKE wsd_file.wsd02   #TQC-BC0167

    #TQC-BC0167 - Start -
    SELECT wsd02 INTO l_wsd02 FROM wsd_file WHERE wsd01 = l_prog 
    IF l_wsd02 = 'N' THEN 
        LET l_prog = NULL  
        LET l_tag = NULL   
    END IF      
    #TQC-BC0167 -  End  -
    
    SELECT wsh09,wsh10 INTO l_wsh09,l_wsh10 from wsh_file where wsh01 = l_prog AND wsh05 = l_tag
    IF l_wsh09 IS NOT NULL AND l_wsh10 IS NOT NULL THEN  
        LET l_prog = l_wsh09
        LET l_tag = l_wsh10
    END IF

    RETURN l_prog, l_tag
END FUNCTION

# CHI-BC0010
# Description....: 格式轉換 for 非 hard code
# Date & Author..: 2011/12/21 by ka0132
# Parameter......: l_prog(程式名稱), l_tag(欄位名稱)
# Return.........: l_format(輸出格式)
# Memo...........:
# Modify.........:
FUNCTION aws_efcli2_format_r(l_prog, l_tag)
DEFINE l_prog      CHAR(50)
DEFINE l_tag       CHAR(50)
DEFINE l_format    STRING
DEFINE l_format_c  CHAR(50)

   CALL aws_efcli2_format_wsh(l_prog, l_tag) RETURNING l_prog, l_tag
   
   IF l_prog IS NULL AND l_tag IS NULL THEN  #TQC-BC0167
      RETURN NULL                            #TQC-BC0167
   END IF                                    #TQC-BC0167
   
   IF l_prog IS NOT NULL THEN
      LET l_format_c = ""
      SELECT gav06 INTO l_format_c FROM gav_file where gav02 = l_tag AND gav01 = l_prog
      LET l_format = l_format_c
      LET l_format = l_format.trim()
      #TQC-BC0167
      IF l_format IS NOT NULL THEN #gav06代表自由格式定義, 若有定義自由格式才進行轉換
         LET l_format = aws_efcli2_forchk(l_format)
      ELSE 
         RETURN NULL
      END IF
      #TQC-BC0167
   END IF
   RETURN l_format
END FUNCTION 
# --- CHI-BC0010 ---  END  ---

# --- TQC-BC0167 --- Start ---
# TQC-BC0167
# Description....: 判斷實際使用的欄位格式
# Date & Author..: 2011/12/27 by ka0132
# Parameter......: l_prog(程式名稱), l_tag(欄位名稱)
# Return.........: l_format(輸出格式)
# Memo...........:
# Modify.........:
FUNCTION aws_efcli2_forchk(p_format)
DEFINE p_format STRING
DEFINE l_tok    base.StringTokenizer
DEFINE l_format STRING 
    LET l_tok = base.StringTokenizer.create(p_format,"|")
    WHILE l_tok.hasMoreTokens()
        LET l_format = l_tok.nextToken()
        CASE 
            WHEN l_format.getIndexOf("rate(",1)        <> 0 OR
                l_format.getIndexOf("show_fd_desc",1)  <> 0 OR
                l_format.getIndexOf("show_itme(",1)    <> 0 OR
                l_format.getIndexOf("multi_unit(",1)   <> 0 
                LET l_format = NULL
                EXIT CASE 
            WHEN l_format = "amt" 
                LET l_format = "---,---,---,---,---.######"
        END CASE
    END WHILE
    RETURN l_format 
END FUNCTION 
# --- TQC-BC0167 ---  End  ---

#FUN-C40061  start
# Description....: Textedit欄位換行格式
# Date & Author..: 2012/04/18 by Kevin
# Parameter......: p_str(輸入字串)
# Return.........: l_str(輸出格式)
# Memo...........:
# Modify.........:
FUNCTION aws_efcli2_eol(p_str)
  DEFINE p_str  STRING
  DEFINE l_str  STRING
  DEFINE l_buf  base.StringBuffer

  LET l_buf = base.StringBuffer.create()
  CALL l_buf.append(p_str)
  CALL l_buf.replace("\n","|eol|",0)

  LET l_str = l_buf.toString()

  RETURN l_str
END FUNCTION
#FUN-C40061  end

#FUN-CA0078 start
FUNCTION aws_check_body(p_body,i)
   DEFINE p_body        om.DomNode
   DEFINE nl_record     om.NodeList,
          i             LIKE type_file.num10,
          l_rec_cnt     LIKE type_file.num10,
          l_cnt         LIKE type_file.num10
   DEFINE l_sql  STRING
   DEFINE l_wc   STRING

   IF p_body IS NOT NULL OR (i=1 AND p_body IS NULL ) THEN

      IF p_body IS NOT NULL THEN
         LET nl_record = p_body.selectByTagName("Record")
         LET l_rec_cnt = nl_record.getLength()
      ELSE
         LET l_rec_cnt = 0
      END IF

      SELECT * INTO g_wsf.* FROM wsf_file WHERE wsf01 = g_prog AND wsf02 = i

      IF (g_wsf.wsf03 CLIPPED IS NOT NULL) AND
         (g_wsf.wsf04 CLIPPED IS NOT NULL) THEN

          IF Length(g_key1) > 0 THEN
             LET l_wc = " AND ", g_wsf.wsf05 CLIPPED, "='", g_key1 CLIPPED, "'"
          END IF

          IF Length(g_key2) > 0 THEN
             LET l_wc = " AND ", g_wsf.wsf06 CLIPPED, "='", g_key2 CLIPPED, "'"
          END IF

          IF Length(g_key3) > 0 THEN
             LET l_wc = " AND ", g_wsf.wsf07 CLIPPED, "='", g_key3 CLIPPED, "'"
          END IF

          IF Length(g_key4) > 0 THEN
             LET l_wc = " AND ", g_wsf.wsf08 CLIPPED, "='", g_key4 CLIPPED, "'"
          END IF

          LET l_sql = "SELECT COUNT(*) FROM  ", g_wsf.wsf03 CLIPPED,
                      " WHERE ", g_wsf.wsf04 CLIPPED, " = '", g_formNum_key CLIPPED, "'"  , l_wc

          DECLARE ef_cnt_cl CURSOR FROM l_sql
          OPEN ef_cnt_cl
          FETCH ef_cnt_cl INTO l_cnt
          CLOSE ef_cnt_cl

          IF l_cnt <> l_rec_cnt THEN  #檢查Record 和 table 筆數是否一致
             CALL cl_err(NULL, 'aws-815', 1)
             RETURN -1
          END IF
      END IF
   END IF

   RETURN 1
END FUNCTION
#FUN-CA0078 end


#FUN-C40086 start
# Description....: 取出遮罩欄位的原始資料
# Date & Author..: 2012/05/31 by kevin
# Parameter......: p_colname(欄位名稱),p_value(資料)
# Return.........: datavalue (原始資料)
# Memo...........:
# Modify.........:
FUNCTION aws_efcli2_getdata(p_colname,p_value)
   DEFINE p_colname STRING
   DEFINE p_value   STRING
   DEFINE l_cnt     LIKE type_file.num10,
          l_i       LIKE type_file.num10

   IF g_azz.azz18 = "Y"  THEN

      LET l_cnt = g_data_mask.getLength()

      FOR l_i = 1 TO l_cnt
          IF g_data_mask[l_i].field = p_colname THEN
             RETURN g_data_mask[l_i].datavalue    #原始資料
          END IF
      END FOR
   END IF
   RETURN p_value
END FUNCTION

# Description....: 取出個資類別ID
# Date & Author..: 2012/05/31 by kevin
# Parameter......: p_gdv01(畫面檔代碼),p_gdv02(欄位代碼)
# Return.........: l_gdu07(個資類別ID)
# Memo...........:
# Modify.........:
FUNCTION aws_efcli2_scrtyitem(p_gdv01,p_gdv02)
   DEFINE p_gdv01   LIKE gdv_file.gdv01
   DEFINE p_gdv02   LIKE gdv_file.gdv02
   DEFINE l_gdu07   LIKE gdu_file.gdu07
   DEFINE l_sql     STRING
   DEFINE l_str     STRING

   LET l_sql = " SELECT gdu07 FROM gdv_file,gdu_file ",
               "  WHERE gdv05 = gdu01 ",
               "    AND gdv01 = ? ",
               "    AND gdv02 = ? "
   PREPARE gdv_pre FROM l_sql
   DECLARE gdv_curs CURSOR FOR gdv_pre

   IF g_azz.azz18 = "Y"  THEN
      OPEN gdv_curs USING p_gdv01 , p_gdv02
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
#FUN-C40086 end

