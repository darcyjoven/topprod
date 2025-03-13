# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aws_process_sub.4gl
# Descriptions...: 解析ERPII整合暫存檔批次拋轉DB作業
# Date & Author..: 12/04/18 By Abby
# Modify.........: 新建立 DEV-C40006
# Modify.........: NO.FUN-C50095 12/05/23 By Lilan BUG修正 
# Modify.........: No.FUN-C70008 12/07/13 By Mandy 程式執行效率優化
# Modify.........: NO.TQC-C80077 12/08/13 By Mandy 因為FREE時,已將檔案釋放,所以後面的rm 已是多餘的動作,需mark
# Modify.........: No.FUN-D10092 13/01/20 By Abby  PLM GP5.3追版以上單號
    
IMPORT os 
DATABASE ds

#DEV-C40006
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
DEFINE tm        RECORD
                   wc       STRING,
                   wcf09_1  LIKE wcf_file.wcf09,
                   wcf09_2  LIKE wcf_file.wcf09,
                   wcf09_3  LIKE wcf_file.wcf09,
                   wcf09_4  LIKE wcf_file.wcf09,
                   wcf09_5  LIKE wcf_file.wcf09,
                   wcf01    LIKE wcf_file.wcf01,
                   wcf06    LIKE wcf_file.wcf06
                 END RECORD
DEFINE g_wcf     DYNAMIC ARRAY OF RECORD LIKE wcf_file.*  #程式變數(Program Variables)
DEFINE l_wcf     DYNAMIC ARRAY OF RECORD LIKE wcf_file.*  #程式變數(Program Variables)
DEFINE g_cnt1    LIKE type_file.num10
DEFINE g_wc      LIKE type_file.chr1000
DEFINE g_sql     STRING
DEFINE g_textstr  STRING
#--------------------------------------------------------------------------#
# Service Request String(XML)                                              #
#--------------------------------------------------------------------------#
DEFINE l_request RECORD            
                   request        STRING,       #呼叫 TIPTOP 服務時傳入的 XML
                   xmlheader      STRING,
                   xmlbody        STRING,
                   xmltrailer     STRING,
                   xml            STRING
                 END RECORD
DEFINE l_request_root    om.DomNode    #Request XML Dom Node
DEFINE l_node            om.DomNode
DEFINE l_list       om.NodeList
 

FUNCTION aws_process_p1()
   DEFINE lc_cmd LIKE type_file.chr1000
   DEFINE l_j    LIKE type_file.num5
   
   OPEN WINDOW aws_process_w WITH FORM "aws/42f/aws_process"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   LET g_bgjob = "N"

   CALL cl_ui_init()
   
   WHILE TRUE
      LET g_action_choice = ''
      LET tm.wcf09_1 = 'N'
      LET tm.wcf09_2 = 'N'
      LET tm.wcf09_3 = 'N'
      LET tm.wcf09_4 = 'N'
      LET tm.wcf09_5 = 'N'

      CALL cl_opmsg('z')
      CONSTRUCT BY NAME tm.wc ON wcf02

         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         
         ON ACTION locale

            EXIT CONSTRUCT
            LET g_action_choice = "locale"
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION qbe_select
            CALL cl_qbe_select()

 
      END CONSTRUCT

      IF g_action_choice = 'locale' THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aws_process_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
                                                                                                                                                                                                                                      
      INPUT BY NAME g_bgjob,tm.wcf09_1,tm.wcf09_2,tm.wcf09_3,tm.wcf09_4,tm.wcf09_5,tm.wcf01,tm.wcf06 WITHOUT DEFAULTS

         ON ACTION CONTROLZ
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION locale
            LET g_action_choice='locale'
            EXIT INPUT
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
   
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
 
      IF g_action_choice = 'locale' THEN
         LET g_action_choice=' '
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aws_process_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "aws_process"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('aws_process','9031',0)   
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET lc_cmd = lc_cmd CLIPPED,     
                            " '",g_bgjob CLIPPED,"'",
                            " '",tm.wcf06 CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.wcf01 CLIPPED,"'",
                            " '",tm.wcf09_1 CLIPPED,"'",
                            " '",tm.wcf09_2 CLIPPED,"'",
                            " '",tm.wcf09_3 CLIPPED,"'",
                            " '",tm.wcf09_4 CLIPPED,"'",
                            " '",tm.wcf09_5 CLIPPED,"'"
            CALL cl_cmdat('aws_process',g_time,lc_cmd) 
         END IF
         CLOSE WINDOW aws_process_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION aws_process_p2()
  DEFINE l_flag     LIKE type_file.chr1
  DEFINE l_i        LIKE type_file.num5
  DEFINE l_cnt      LIKE type_file.num10
  DEFINE l_return   RECORD                    #回傳值必須宣告為一個 RECORD 變數, 且此 RECORD 需包含所有要回傳的欄位名稱與定義
                       bmx01   STRING         #回傳的欄位名稱
                    END RECORD
  DEFINE l_pkwhere  STRING
  DEFINE l_wcf17    LIKE wcf_file.wcf17
  DEFINE l_description  STRING
  DEFINE l_forupd_sql   STRING
  DEFINE l_msg          STRING
  DEFINE l_bak_prog LIKE type_file.chr20      #程式代號備份用
  DEFINE l_replace      STRING
  DEFINE l_locfile      STRING                #LOCATE檔案路徑與檔名
  DEFINE l_tmpstr       STRING           
  DEFINE ls_get_file    base.Channel 
  DEFINE l_d            om.DomDocument        #FUN-C70008 add
  DEFINE l_n            om.DomNode            #FUN-C70008 add
  DEFINE l_x            om.DomNode            #FUN-C70008 add
  DEFINE l_cmd       STRING                   


  #依條件抓出要做後續動作的DataKey 
   IF cl_null(tm.wc) THEN
      LET g_wc = " 1=1"
   ELSE
      LET g_wc = tm.wc
   END IF

   IF NOT cl_null(tm.wcf01) THEN
      LET g_wc = g_wc CLIPPED," AND wcf01 = '",tm.wcf01,"'"
   END IF

   IF NOT cl_null(tm.wcf06) THEN
      LET g_wc = g_wc CLIPPED," AND wcf06 = '",tm.wcf06,"'"
   END IF

   LET l_flag = 'N'   #判斷是否有加入wcf09的條件式

   IF tm.wcf09_1 = 'Y' THEN
      IF l_flag = 'N' THEN
         LET g_wc = g_wc CLIPPED," AND wcf09 IN ('CreateItemMasterData'"
         LEt l_flag = 'Y'
      ELSE
         LET g_wc = g_wc CLIPPED,",'CreateItemMasterData'"
      END IF
   END IF       

   IF tm.wcf09_2 = 'Y' THEN
      IF l_flag = 'N' THEN
         LET g_wc = g_wc CLIPPED," AND wcf09 IN ('CreateRepSubPBOMData'"
         LEt l_flag = 'Y'
      ELSE
         LET g_wc = g_wc CLIPPED,",'CreateRepSubPBOMData'"
      END IF 
   END IF

   IF tm.wcf09_3 = 'Y' THEN
      IF l_flag = 'N' THEN
         LET g_wc = g_wc CLIPPED," AND wcf09 IN ('CreateItemApprovalData'"
         LET l_flag = 'Y'
      ELSE
         LET g_wc = g_wc CLIPPED,",'CreateItemApprovalDat'"
      END IF 
   END IF

   IF tm.wcf09_4 = 'Y' THEN
      IF l_flag = 'N' THEN
         LET g_wc = g_wc CLIPPED," AND wcf09 IN ('CreatePLMBOMData'"
         LEt l_flag = 'Y'
      ELSE
         LET g_wc = g_wc CLIPPED,",'CreatePLMBOMData'"
      END IF 
   END IF

   IF tm.wcf09_5 = 'Y' THEN
      IF l_flag = 'N' THEN
         LET g_wc = g_wc CLIPPED," AND wcf09 IN ('CreateSupplierItemData'"
         LEt l_flag = 'Y'
      ELSE
         LET g_wc = g_wc CLIPPED,",'CreateSupplierItemData'"
      END IF 
   END IF
   
   IF l_flag = 'Y' THEN
      LEt g_wc = g_wc CLIPPED,")"
   END IF


   LET g_sql = "SELECT wcf06,wcf09 FROM wcf_file",
               " WHERE wcf17 NOT IN ('Y','S','F')",
               "   AND wcflegal = '",g_legal,"'",
               "   AND wcfplant = '",g_plant,"'",
               "   AND wcf07 > 0 ",   #表示已傳送完整
               "   AND ",g_wc,
               " ORDER BY wcf06"

   LET l_msg = "in FUNCION aws_process_p2()|",
               "BEFORE PREPARE aws_process_datakeypre FROM g_sql:",g_sql
   LET l_msg=cl_replace_str(l_msg, "'", "\"")

   LET g_transaction = 'N'    
   IF g_bgjob = 'Y' THEN
      CALL aws_syslog("PLM","","3","aws_process_sub","",l_msg,"N")  #執行紀錄寫入syslog   
   ELSE
      CALL aws_syslog("PLM","","4","aws_process_sub","",l_msg,"N")  #執行紀錄寫入syslog 
   END IF

   PREPARE aws_process_datakeypre FROM g_sql
   IF STATUS THEN 
      CALL cl_err('prepare datakey:',STATUS,0) 
      LET g_success = 'N'
      RETURN
   END IF
   DECLARE aws_process_datakeycurs SCROLL CURSOR WITH HOLD FOR aws_process_datakeypre
   IF STATUS THEN 
      CALL cl_err('declare datakey:',STATUS,0)
      LET g_success = 'N' 
      RETURN 
   END IF

   CALL g_wcf.clear()
   LET l_cnt = 1
   FOREACH aws_process_datakeycurs INTO g_wcf[l_cnt].wcf06,g_wcf[l_cnt].wcf09
      IF STATUS THEN                                                              
         CALL cl_err('FOREACH wcf06:',STATUS,0)
         LET g_success='N'
         EXIT FOREACH
      END IF
      IF l_cnt = 1 THEN
          CALL aws_process_upd() 
          IF g_success = 'N' THEN 
             EXIT FOREACH
          END IF
      END IF
      
     #依DataKey值找出相關wcf_file資料
      LET g_sql = "SELECT wcf01,wcf02,wcf03,wcflegal,wcfplant,wcf06,wcf07,wcf08,wcf09,wcf11,wcf17 ",
                  "  FROM wcf_file ",
                  " WHERE wcf06 = '",g_wcf[l_cnt].wcf06,"'",
                  " ORDER BY wcf08"

      PREPARE aws_process_pre FROM g_sql
      IF STATUS THEN 
         CALL cl_err('prepare:',STATUS,0) 
         LET g_success = 'N'
         RETURN
      END IF
      DECLARE aws_process_curs CURSOR FOR aws_process_pre
      IF STATUS THEN 
         CALL cl_err('declare:',STATUS,0)
         LET g_success = 'N' 
         RETURN 
      END IF

      CALL l_wcf.clear()
      LET g_cnt1 = 1 
      INITIALIZE l_request.* TO NULL
      FOREACH aws_process_curs INTO l_wcf[g_cnt1].wcf01,l_wcf[g_cnt1].wcf02,l_wcf[g_cnt1].wcf03,l_wcf[g_cnt1].wcflegal,l_wcf[g_cnt1].wcfplant,l_wcf[g_cnt1].wcf06,l_wcf[g_cnt1].wcf07,l_wcf[g_cnt1].wcf08,l_wcf[g_cnt1].wcf09,l_wcf[g_cnt1].wcf11,l_wcf[g_cnt1].wcf17
         IF STATUS THEN                                                              
            CALL cl_err('FOREACH wcf_file:',STATUS,0)
            LET g_success='N'
            EXIT FOREACH
         END IF

        #LET l_pkwhere = "AND wcf01 = '",l_wcf[g_cnt1].wcf01,"'"
        #CALL cl_sqltext_to_str("wcf_file","wcf10",l_pkwhere) RETURNING g_textstr
         LET l_locfile = FGL_GETENV("TEMPDIR"),"/aws_process-",l_wcf[g_cnt1].wcf01,'.txt'
         LOCATE l_wcf[g_cnt1].wcf10 IN FILE l_locfile
         SELECT wcf10 INTO l_wcf[g_cnt1].wcf10
           FROM wcf_file
          WHERE wcf01 = l_wcf[g_cnt1].wcf01

         IF SQLCA.SQLCODE THEN
            CALL cl_err3("sel","wcf_file",l_wcf[g_cnt1].wcf01,"",SQLCA.sqlcode,"","",0)
            EXIT FOREACH
         ELSE
           #FUN-C70008--mark---str---
           ##將文字檔內容導致字串l_str_file
           #LET g_textstr = ''
           #LET l_tmpstr = ''
           #LET ls_get_file = base.Channel.create()
           #CALL ls_get_file.openFile(l_locfile, "r")
           #WHILE ls_get_file.read(l_tmpstr)      
           #     LET g_textstr = g_textstr,l_tmpstr
           #END WHILE 
           #FUN-C70008--mark---end---
           #FUN-C70008--add----str---
            LET l_d = om.DomDocument.create("")
            LET l_n = l_d.getDocumentElement()

            LET l_x = l_n.loadxml(l_locfile)
            LET g_textstr= l_x.toString()
            
            #透過上述的方式取到的g_textstr第一行會自動加上<?xml version='1.0' encoding='UTF-8'?>\n
            #所以下面的指令的動作即為將第一行移除
            LET g_textstr = g_textstr.subString(g_textstr.getIndexOf("\n",1)+1,g_textstr.getLength()) 
           #FUN-C70008--add----end---
         END IF

         IF l_wcf[g_cnt1].wcf07 = 1 THEN   #表示沒有分批
            LET g_request.request = g_textstr
            LET g_request_root = aws_ttsrv_stringToXml(g_request.request)
         ELSE
            CALL aws_process_wcf10()
            LET l_request.request=cl_replace_str(l_request.request, "\"", "'")
            LET g_request.request = l_request.request
            LET g_request_root = aws_ttsrv_stringToXml(g_request.request)
         END IF
         LET g_cnt1 = g_cnt1 + 1

         FREE l_wcf[g_cnt1].wcf10
        #LET l_cmd = "rm ",l_locfile  #TQC-C80077 mark
        #RUN l_cmd                    #TQC-C80077 mark
      END FOREACH

      LET l_replace = "<?xml version='1.0' encoding='UTF-8'?>"
      LET g_request.request=cl_replace_str(g_request.request,l_replace, "")
      CALL aws_process_default()

     #因Service裡會運用到g_prog = 'aws_ttsrv2'時，代表是由Service做邏輯判斷
      LET l_bak_prog = g_prog
      LET g_prog = 'aws_ttsrv2'

      CASE g_wcf[l_cnt].wcf09
         WHEN 'CreateItemMasterData'     #建立正式料件主檔資料
            CALL aws_create_itemmaster_data_process() 
         WHEN 'CreateRepSubPBOMData'     #建立P-BOM取替代資料
            CALL aws_create_repsub_pbom_data_process()
         WHEN 'CreateItemApprovalData'   #建立料件承認資料
            CALL aws_create_item_approval_data_process()
         WHEN 'CreatePLMBOMData'         #建立PLM P-BOM資料
            CALL aws_create_plm_bom_data_process()
         WHEN 'CreateSupplierItemData'   #建立料件/供應商資料
            CALL aws_create_supplier_item_data_process()
         OTHERWISE                       #其他   
            CALL cl_err('declare:',STATUS,0)
            LET g_status.code = 'aws-808'
            CALL cl_err('ERP:','aws-808',0)
            LET g_success="N" 
      END CASE
  
      LET g_prog = l_bak_prog

     #回饋TempTable批次處理狀況
      LET g_wcf[l_cnt].wcf12 = g_status.code
      LET g_wcf[l_cnt].wcf13 = g_status.sqlcode
      LET g_wcf[l_cnt].wcf14 = g_status.description
      LET g_wcf[l_cnt].wcf15 = g_today
      LET g_wcf[l_cnt].wcf16 = CURRENT HOUR TO FRACTION(3)
      IF g_status.code = '0' THEN
         LET g_wcf[l_cnt].wcf17 = 'Y'
      ELSE
         LET g_wcf[l_cnt].wcf17 = 'F'
      END IF


     #回饋紀錄TIPTOP單據單號(wcf18)  #僅有CreatePLMBOMData會回傳值
      IF cl_null(g_return_keyno) THEN
         LET g_wcf[l_cnt].wcf18 = ' '
      ELSE
         LET g_wcf[l_cnt].wcf18 = g_return_keyno
      END IF

      LET l_description=cl_replace_str(g_status.description, "'", "|")
    
      LET g_transaction = 'N'   #呼叫syslog前資料庫是否為交易狀態
      LET l_msg = g_wcf[l_cnt].wcf09,":",l_description
      CALL aws_syslog("PLM",g_wcf[l_cnt].wcf06,"3","aws_process_sub",g_status.code,l_msg,"N")  #執行紀錄寫入syslog

      WHENEVER ERROR CONTINUE
      BEGIN WORK
      LET l_forupd_sql = "SELECT wcf01 FROM wcf_file WHERE wcf06 = ? FOR UPDATE"
      LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
      DECLARE wcf_cl CURSOR FROM l_forupd_sql

      #-------------------------------------------------------------------#
      # 鎖住將被更改或取消的資料                                          #
      #-------------------------------------------------------------------#
      IF NOT aws_update_wcf_updchk(g_wcf[l_cnt].wcf06) THEN
         LET g_success = 'N'
      ELSE
         LET g_success = 'Y'
      END IF

      IF g_success = 'Y' THEN 
         LET g_sql = "UPDATE wcf_file ",
                     "   SET wcf12 = '",g_wcf[l_cnt].wcf12,"',",
                     "       wcf13 = '",g_wcf[l_cnt].wcf13,"',",
                     "       wcf14 = '",l_description,"',",
                     "       wcf15 = '",g_wcf[l_cnt].wcf15,"',",
                     "       wcf16 = '",g_wcf[l_cnt].wcf16,"',",
                     "       wcf17 = '",g_wcf[l_cnt].wcf17,"',",
                     "       wcf18 = '",g_wcf[l_cnt].wcf18,"'",
                     " WHERE wcf06 = '",g_wcf[l_cnt].wcf06,"'",
                     "   AND wcf17 = 'S' "                      #FUN-C50095 add:多此過濾避免覆蓋已處理過的DataKey資料
         EXECUTE IMMEDIATE g_sql
         IF SQLCA.SQLCODE THEN
            CALL cl_err('upd process_status:',STATUS,0)
            LET g_success = 'N'
            ROLLBACK WORK
         ELSE
            COMMIT WORK
         END IF   
         CLOSE wcf_cl
      END IF

      LET l_cnt = l_cnt + 1  
   END FOREACH
   
END FUNCTION

FUNCTION aws_process_wcf10()
 DEFINE l_access     om.DomNode
 DEFINE l_parameter  om.DomNode

   CALL aws_process_xmlbody()
   
  #串接XML header/trailer
   IF l_wcf[g_cnt1].wcf07 <> 0 THEN  #判斷是否為最後一包
     #組XML header
      LET l_list = l_request_root.selectByTagName("Access")
      LET l_access = l_list.item(1)    
      LET l_request.xml = l_access.toString()
      LET l_request.xmlheader  =  l_request.xmlheader CLIPPED,l_request.xml,
                                  "<RequestContent>", ASCII 10
      
      LET l_list = l_request_root.selectByTagName("Parameter")
      LET l_parameter = l_list.item(1)    
      LET l_request.xml = l_parameter.toString()
      LET l_request.xmlheader  = 
          "<Request>", ASCII 10,
           l_request.xmlheader CLIPPED,l_request.xml,
          "<Document>"

     #組XML trailer
      LET l_request.xmltrailer = 
          "   </Document>", ASCII 10,
          " </RequestContent>", ASCII 10,
          "</Request>"
          
      LET l_request.request = l_request.xmlheader CLIPPED,l_request.xmlbody CLIPPED,l_request.xmltrailer
   
      CALL aws_syslog("PLM",l_wcf[g_cnt1].wcf06,"3","aws_process_wcf10","",l_request.request,"N")
      CALL aws_process_logfile(l_request.request)
   END IF
END FUNCTION

FUNCTION aws_process_xmlbody()
   DEFINE l_str        STRING
   DEFINE l_i          INTEGER
   DEFINE l_recordset  om.DomNode

  #抓取RecordSet
   LET l_request_root = aws_ttsrv_stringToXml(g_textstr)      #將string轉成DomNode   
   LET l_list = l_request_root.selectByTagName("RecordSet")   #抓取RecordSet節點內容
   FOR l_i = 1 TO l_list.getLength()
       LET l_recordset = l_list.item(l_i)    
      #串接RecordSet
       LET l_request.xml = l_recordset.toString()  #將DomNode轉成string
       LET l_request.xmlbody = l_request.xmlbody CLIPPED,l_request.xml
   END FOR

   CALL aws_syslog("PLM",l_wcf[g_cnt1].wcf06,"3","aws_process_xmlbody","",l_request.xmlbody,"N") #Lilan 0514
END FUNCTION


#[
# Description....: 記錄 XML 字串
# Date & Author..: 2012/04/18 by Abby
# Parameter......: p_request   - STRING     - Reqeust XML 字串
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_process_logfile(p_request)
DEFINE p_status     STRING,
       p_request    STRING,
       l_file       STRING,
       l_pid        STRING,
       l_str        STRING,
       channel      base.Channel

    #記錄此次呼叫的 method name
    LET l_file = "aws_process-", TODAY USING 'YYYYMMDD', ".log"
    LET channel = base.Channel.create()

    CALL channel.openFile(l_file,  "a")
    IF STATUS = 0 THEN
        CALL channel.setDelimiter("")

        #紀錄傳遞的 XML 字串
        LET l_str = "#--------------------------- (", CURRENT YEAR TO SECOND, ") ----------------------------#"
        CALL channel.write(l_str)
        CALL channel.write("")
        CALL channel.write("Request XML:")
        CALL channel.write(p_request)
        CALL channel.write("")
        CALL channel.write("#------------------------------------------------------------------------------#")
        CALL channel.write("")
        CALL channel.close()

        IF os.Path.chrwx(l_file CLIPPED,438) THEN END IF
    ELSE
        DISPLAY "Can't open log file."
    END IF
END FUNCTION

#鎖住將被更改或取消的資料
FUNCTION aws_process_upd()
  DEFINE l_wcf01      LIKE wcf_file.wcf01
  DEFINE l_forupd_sql STRING

    WHENEVER ERROR CONTINUE
    BEGIN WORK

    LET l_forupd_sql = "SELECT wcf01 FROM wcf_file",
                       " WHERE wcf17 NOT IN ('Y','S','F')",
                       "   AND wcflegal = '",g_legal,"'",
                       "   AND wcfplant = '",g_plant,"'",
                       "   AND wcf07 > 0 ",   #表示已傳送完整
                       "   AND ",g_wc,
                       "   AND wcf06 IN ( ",
                       "                  SELECT wcf06 FROM wcf_file",
                       "                   WHERE wcf17 NOT IN ('Y','S','F')",
                       "                     AND wcflegal = '",g_legal,"'",
                       "                     AND wcfplant = '",g_plant,"'",
                       "                     AND wcf07 > 0 ",   #表示已傳送完整
                       "                     AND ",g_wc,")",
                       " FOR UPDATE "
     LET l_forupd_sql = cl_forupd_sql(l_forupd_sql) 
     DECLARE aws_process_lock_cur CURSOR FROM l_forupd_sql

     OPEN aws_process_lock_cur
     IF SQLCA.sqlcode THEN
        CALL cl_err('OPEN aws_process_lock_cur:',SQLCA.sqlcode,0) 
        LET g_success = 'N'
        CLOSE aws_process_lock_cur
        ROLLBACK WORK
        RETURN
     END IF
     FETCH aws_process_lock_cur INTO l_wcf01             # 鎖住將被更改或取消的資料
     IF SQLCA.sqlcode THEN
        CALL cl_err('FETCH aws_process_lock_cur:',SQLCA.sqlcode,0) 
        LET g_success = 'N'
        CLOSE aws_process_lock_cur
        ROLLBACK WORK
        RETURN
     END IF

   #UPDATE 
   #更新wcf_file的資料狀態碼 
   #==>
   LET g_sql = "UPDATE wcf_file",
               "   SET wcf17 = 'S' ",
               " WHERE wcf17 NOT IN ('Y','S','F')",
               "   AND wcflegal = '",g_legal,"'",
               "   AND wcfplant = '",g_plant,"'",
               "   AND ",g_wc,
               "   AND wcf06 IN ( ",
               "                  SELECT wcf06 FROM wcf_file",
               "                   WHERE wcf17 NOT IN ('Y','S','F')",
               "                     AND wcflegal = '",g_legal,"'",
               "                     AND wcfplant = '",g_plant,"'",
               "                     AND wcf07 > 0 ",   
               "                     AND ",g_wc,")"
   EXECUTE IMMEDIATE g_sql
   IF SQLCA.SQLCODE THEN
       CALL cl_err('upd wcf17:',STATUS,0) 
       LET g_success = 'N'
       ROLLBACK WORK
   ELSE
       COMMIT WORK
   END IF
   CLOSE aws_process_lock_cur
END FUNCTION


FUNCTION aws_process_default()

    
    #------------------------------------------#
    # 初始 g_status 變數                       #
    #------------------------------------------#
    LET g_status.code = "0"
    LET g_status.sqlcode = "0"
    LET g_status.description = ""

    #因為後續services(aws_ttsrv2_lib_recordset.4gl) 中會call cl_query_prt_getlength()
    #所以需先在這裡create temptable
    CALL cl_query_prt_temptable()
   
END FUNCTION 


#[
# Description....: 鎖住將被更改或取消的資料
# Date & Author..: 2012/04/27 by Abby
# Parameter......: p_wcf06 - STRING
# Return.........: l_status - INTEGER - TRUE / FALSE Luck 結果
# Memo...........:
# Modify.........:
#]
FUNCTION aws_update_wcf_updchk(p_wcf06)
  DEFINE p_wcf06 LIKE wcf_file.wcf06
  DEFINE l_wcf01 LIKE wcf_file.wcf01

     OPEN wcf_cl USING p_wcf06
     IF SQLCA.sqlcode THEN
        LET g_status.code = SQLCA.sqlcode
        CLOSE wcf_cl
        ROLLBACK WORK
        RETURN FALSE
     END IF
     FETCH wcf_cl INTO l_wcf01                 #鎖住將被更改或取消的資料
     IF SQLCA.sqlcode THEN
        LET g_status.code = SQLCA.SQLCODE      #資料被他人LOCK
        LET g_status.sqlcode = SQLCA.SQLCODE
        CLOSE wcf_cl
        ROLLBACK WORK
        RETURN FALSE
     END IF
     RETURN TRUE
END FUNCTION
#FUN-D10092
