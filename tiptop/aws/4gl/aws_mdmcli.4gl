# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Library name...: aws_mdmcli
# Descriptions...: 透過 Web Services 將 TIPTOP 表單與 MDM 整合
# Parameter......: p_tabname - STRING - Table 名稱
#                : p_atction - STRING - 功能選項
#                : p_record  - DomNode -  主檔、單頭 <DataSet> XML Node
#                : p_record2 - DomNode -  單身1 <DataSet> XML Node
#                : p_record3 - DomNode -  單身2 <DataSet> XML Node
#                : p_record4 - DomNode -  單身3 <DataSet> XML Node
#                : p_record5 - DomNode -  單身4 <DataSet> XML Node
# Return code....: '0' 無設定與 MDM 整合表單
#                  '1' 表單開立成功
#                  '2' 開立不成功
# Date & Author..: 08/06/05 By Echo FUN-850147
# Modify.........: 08/07/30 By kevin FUN-870166
# Modify.........: 08/09/24 By kevin FUN-890113 多筆傳送
# Modify.........: 09/01/13 By claire MOD-910133 abmi600複制BOM時, 單身會失敗
#
 
IMPORT com
IMPORT util
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
#FUN-850147
 
GLOBALS "../4gl/aws_mdmgw.inc"
GLOBALS "../../config/top.global"
GLOBALS
   DEFINE ms_locale       STRING
   DEFINE g_service       STRING
   DEFINE g_mdm_key       STRING
END GLOBALS
 
DEFINE channel            base.Channel
DEFINE g_mdmsoap          STRING
DEFINE g_result           STRING
DEFINE g_result_xml       om.DomNode
DEFINE g_result_value     STRING
DEFINE g_tabname          STRING
DEFINE g_flowname         STRING
DEFINE g_loginuser        STRING
DEFINE g_record           om.DomNode
DEFINE g_record2          om.DomNode
DEFINE g_record3          om.DomNode
DEFINE g_record4          om.DomNode
DEFINE g_record5          om.DomNode
DEFINE g_pre_record       om.DomNode
DEFINE g_action           STRING
DEFINE g_systemID         STRING
DEFINE g_status           LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE g_cnt              LIKE type_file.num10
DEFINE g_show_errmsg      LIKE type_file.chr1 #是否show 錯誤訊息
DEFINE g_mdmtabname       STRING
DEFINE g_sql_err          STRING
 
{FUNCTION aws_mdmcli(p_tabname,p_action,p_record,p_record2,p_record3,p_record4,p_record5)
DEFINE p_tabname   STRING
DEFINE p_record      om.DomNode
DEFINE p_record2     om.DomNode
DEFINE p_record3     om.DomNode
DEFINE p_record4     om.DomNode
DEFINE p_record5     om.DomNode
DEFINE p_action      STRING
DEFINE buf           base.StringBuffer
DEFINE l_str         STRING
 
    IF g_aza.aza85 matches '[ Nn]' OR cl_null(g_aza.aza85) THEN          #未設定與 EasyFlow 簽核
      #CALL cl_err('aza85','mfg3562',0)
       LET g_success='N'
       RETURN 0
    END IF
 
    LET g_status = 1
    LET g_tabname = p_tabname
    LET g_systemId = "DSCMDM"
 
    LET g_record = p_record
    LET g_record2 = p_record2
    LET g_record3 = p_record3
    LET g_record4 = p_record4
    LET g_record5 = p_record5
    LET g_action = p_action
 
    #--------------------------------------------------------------------------#
    #處理 Request 資料                                                         #
    #--------------------------------------------------------------------------#
    CALL aws_mdmcli_prepareRequest()
 
    LET IMDMWebService_IMDMWebServiceMulePortLocation = g_aza.aza86   #指定 Soap server location
    CALL fgl_ws_setOption("http_invoketimeout", 60) #若 60 秒內無回應則放棄
 
    CALL invokeMDMFlow_g() RETURNING g_status
 
    #CALL aws_mdmcli_file()                          #記錄傳遞的XML字串 
 
    IF g_status = 0 THEN
          
       IF (ns2invokeMDMFlowResponse.out.status != 2) OR
          (ns2invokeMDMFlowResponse.out.status IS NULL)
       THEN
          LET l_str = ns2invokeMDMFlowResponse.out.status,' ',
                      ns2invokeMDMFlowResponse.out.errorMessage
          IF fgl_getenv('FGLGUI') = '1' THEN
             LET l_str = "XML parser error:\n\n",l_str
          ELSE
             LET l_str = "XML parser error: ",l_str
          END IF
          CALL cl_err(l_str, '!', 1)   #XML 字串有問題
          RETURN 2 
       ELSE
          RETURN 1
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
       RETURN 2 
    END IF
 
END FUNCTION
}
 
 
FUNCTION aws_mdmcli_file(p_logerr)
    DEFINE l_str        STRING,
           l_file       STRING,
           l_cmd        STRING,
           p_logerr     STRING
    DEFINE l_ch         base.Channel
 
    #-----------------------------------------------------------------------
    # 記錄此次傳遞的 xml
    #-----------------------------------------------------------------------
    IF p_logerr = "Y" THEN
    	 LET l_file = fgl_getenv("TEMPDIR"), "/aws_mdmcli_err-", TODAY USING 'YYYYMMDD', ".log"
    ELSE    	
       LET l_file = fgl_getenv("TEMPDIR"), "/aws_mdmcli-", TODAY USING 'YYYYMMDD', ".log"
    END IF
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
       #-----------------------------------------------------------------------#
       # 將輸入參數的 XML 文件轉換成紀錄於 log 檔中的字串                      #
       #-----------------------------------------------------------------------#
       LET l_str = aws_ttsrv_translateParameterXmlToString(base.TypeInfo.create(ns2invokeMDMFlow))
 
       CALL l_ch.write(l_str)
       CALL l_ch.write("")
 
       CALL l_ch.write("Response XML:")
       IF g_status = 0 THEN
          #--------------------------------------------------------------------#
          # 將輸入參數的 XML 文件轉換成紀錄於 log 檔中的字串                   #
          #--------------------------------------------------------------------#
          LET l_str = aws_ttsrv_translateParameterXmlToString(base.TypeInfo.create(ns2invokeMDMFlowResponse))
          
          CALL l_ch.write(l_str)
       ELSE
          CALL l_ch.write("")
          IF fgl_getenv('FGLGUI') = '1' THEN
             LET l_str = "   Connection failed:\n\n",
                      "     [Code]: ", wserror.code, "\n",
                      "     [Action]: ", wserror.action, "\n",
                      "     [Description]: ", wserror.description
          ELSE
             LET l_str = "   Connection failed: ", wserror.description
          END IF
          CALL l_ch.write(l_str)
          CALL l_ch.write("")
       END IF
 
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
 
#[
# Description....: 處理 Request 參數
# Date & Author..: 2007/08/30 by Echo
# Parameter......: none
# Return.........: none
#
#]
FUNCTION aws_mdmcli_prepareRequest()
DEFINE k              LIKE type_file.num10
DEFINE i              LIKE type_file.num10
DEFINE n_record       om.DomNode
DEFINE nl_record      om.NodeList
DEFINE cnt_record     LIKE type_file.num10
 
    
    LET ns2invokeMDMFlow.in0.action = "multi"
    LET ns2invokeMDMFlow.in0.applicationNameFrom = "TIPTOP"
    LET ns2invokeMDMFlow.in0.applicationNameTo =  "MDM"
    LET ns2invokeMDMFlow.in0.flowName = g_flowname #"MDM01"
    LET ns2invokeMDMFlow.in0.mddTableName = g_mdmtabname
    LET ns2invokeMDMFlow.in0.username = 'tiptop'    
    CALL  ns2invokeMDMFlow.in0.records.Record.clear() ##清空record
         
END FUNCTION
 
 
#[
# Description....: 抓取欄位資料，並轉換成 MDM 系統的欄位名稱
# Date & Author..: 2007/08/30 by Echo
# Parameter......: p_record - DomNode    - Record Dom Node
# Return.........: none
#
#]
FUNCTION aws_mdmcli_field(p_wsw05)
    DEFINE l_tok_param  base.StringTokenizer
    DEFINE l_str      STRING,
           l_name     STRING,
           l_value    STRING
    DEFINE l_pos      LIKE type_file.num10
    DEFINE l_i,l_j    LIKE type_file.num10
    DEFINE p_wsw05    STRING #record 字串
 
      LET l_i = 4             
      LET l_j = 0
      
   	  LET l_tok_param = base.StringTokenizer.createExt(p_wsw05 ,"|","",TRUE)   	  
   	  WHILE l_tok_param.hasMoreTokens()
   	  	   LET l_str   = l_tok_param.nextToken()
   	  	   LET l_pos   = l_str.getIndexOf( "=", 1)
   	  	   LET l_name  = l_str.subString( 1 ,l_pos-1)
   	  	   LET l_value = l_str.subString(l_pos+1 , l_str.getLength())
   	  	   IF l_value IS NULL  THEN
   	  	   	  LET l_value = " "
   	  	   END IF
   	  	   LET l_j = l_j + 1
   	  	   IF l_j = 1 THEN
   	  	   	  #--------------------------------------------------------------------#
              #Field固定預設前三組，分別是DB、Company、Language                    #
              #--------------------------------------------------------------------#
   	  	   	  LET ns2invokeMDMFlow.in0.records.Record[g_cnt].fields.Field[1].name = "DB"
              LET ns2invokeMDMFlow.in0.records.Record[g_cnt].fields.Field[1].value =  l_value CLIPPED
              LET ns2invokeMDMFlow.in0.records.Record[g_cnt].fields.Field[2].name = "COMPANY"
              LET ns2invokeMDMFlow.in0.records.Record[g_cnt].fields.Field[2].value = "DSC" 
              LET ns2invokeMDMFlow.in0.records.Record[g_cnt].fields.Field[3].name = "LANGUAGE"
              LET ns2invokeMDMFlow.in0.records.Record[g_cnt].fields.Field[3].value =  ms_locale 
              LET ns2invokeMDMFlow.in0.records.Record[g_cnt].action = g_action
              LET ns2invokeMDMFlow.in0.records.Record[g_cnt].id = g_cnt
              LET ns2invokeMDMFlow.in0.records.Record[g_cnt].refId = " " 
   	  	   	  CONTINUE WHILE
   	  	   END IF
   	  	   IF l_name IS NOT NULL THEN
   	  	   	  LET ns2invokeMDMFlow.in0.records.Record[g_cnt].fields.Field[l_i].name  = l_name
              LET ns2invokeMDMFlow.in0.records.Record[g_cnt].fields.Field[l_i].value = l_value 
   	  	   END IF   	  	   
           LET l_i = l_i + 1     
   	  END WHILE
   	  
END FUNCTION
 
#FUN-870166 --start--
#[
# Description....: 提供背景執行功能
# Date & Author..: 2008/08/28 by kevin
# Parameter......: none
# Return.........: none
#
#]
FUNCTION aws_mdm_bgjob()
DEFINE l_sql     string
DEFINE l_i       LIKE type_file.num10 
DEFINE l_wsv     DYNAMIC ARRAY OF RECORD	               
                    wsv01 LIKE wsv_file.wsv01
                 END RECORD
 
    LET l_sql = "SELECT UNIQUE wsv01 ",
                " FROM wsv_file ORDER BY wsv01 "
        
    PREPARE wsv_sql FROM l_sql
    DECLARE wsv_cs CURSOR FOR wsv_sql    	
    CALL l_wsv.clear()
    
    LET l_i = 1
    FOREACH wsv_cs INTO l_wsv[l_i].*     	 
    	 IF STATUS THEN
         CALL cl_err('foreach:',STATUS,0)
         EXIT FOREACH
       END IF
       CALL aws_mdmcli(l_wsv[l_i].wsv01)
       LET l_i = l_i + 1
    END FOREACH
    
END FUNCTION
 
 
FUNCTION aws_mdmcli(p_prog)
DEFINE l_wsv     DYNAMIC ARRAY OF RECORD
                    wsv02   LIKE wsv_file.wsv02, #檔案代碼
                    wsv04   LIKE wsv_file.wsv02, #MDM檔案名稱
                    wsv05   LIKE wsv_file.wsv05, #流程名稱
                    wsv06   LIKE wsv_file.wsv06  #單筆最大傳送筆數                   
                 END RECORD
DEFINE l_i       LIKE type_file.num10 
DEFINE l_j       LIKE type_file.num10 
DEFINE max_count LIKE type_file.num10 
DEFINE t         LIKE type_file.num10 #剩餘傳送量
DEFINE p_prog    LIKE wsv_file.wsv01 #程式代號
DEFINE l_cnt     LIKE type_file.num10
DEFINE l_cnt2    LIKE type_file.num10
DEFINE l_sql     string 
DEFINE l_sql2    string
 
DEFINE l_wsw     DYNAMIC ARRAY OF RECORD
   	                   wsw02  LIKE wsw_file.wsw02
   	                   #wsw03  LIKE wsw_file.wsw03,
                       #wsw04  LIKE wsw_file.wsw04                       
                 END RECORD
                 
DEFINE l_wsv2    DYNAMIC ARRAY OF RECORD
                    wsv02   LIKE wsv_file.wsv02, #檔案代碼
                    wsv04   LIKE wsv_file.wsv02, #MDM檔案名稱
                    wsv05   LIKE wsv_file.wsv05, #流程名稱
                    wsv06   LIKE wsv_file.wsv06  #單筆最大傳送筆數                   
                 END RECORD
   
   LET l_sql = "SELECT wsv02,wsv04,wsv05,wsv06 FROM wsv_file ",
                " WHERE wsv01=? and wsv03='H' "
                
   PREPARE wsv_pre FROM l_sql
   DECLARE wsv_curs CURSOR FOR wsv_pre
   	
   LET l_sql = "SELECT wsw02,wsw03,wsw04,wsw05,wsw06,wsw07,wsw08 FROM wsw_file ",              
               " WHERE wsw01=? and wsw02=? and wsw09='0' "
               
   PREPARE wsw_pre FROM l_sql
   DECLARE w_curs CURSOR FOR wsw_pre	
   
   BEGIN WORK ##part 1
   LET g_sql_err = FALSE 
   CALL l_wsv.clear()
   
   LET l_i = 1   
   FOREACH wsv_curs USING p_prog INTO l_wsv[l_i].*  
   	  IF STATUS THEN      	 
         CALL cl_err('foreach:',STATUS,0)
         EXIT FOREACH
      END IF
      LET g_flowname   = l_wsv[l_i].wsv05
      LET g_mdmtabname = l_wsv[l_i].wsv04
      LET g_tabname    = l_wsv[l_i].wsv02
      LET max_count    = l_wsv[l_i].wsv06
      
      #先處理單頭
        
      SELECT COUNT(*) INTO l_cnt 
        FROM wsw_file WHERE wsw01=p_prog and wsw02=l_wsv[l_i].wsv02 and wsw09='0'
        
      IF g_tabname IS NOT NULL AND l_cnt > 0  THEN
      	  IF l_cnt <= max_count THEN  #只需傳送一次  	   
      	     CALL aws_mdmcli2(p_prog,g_tabname,"H",max_count)
      	  ELSE    #需傳送多次
      	  	 LET t = l_cnt 	   
      	  	 WHILE (t > 0)
      	  	    CALL aws_mdmcli2(p_prog,g_tabname,"H",max_count)
      	  	    IF g_show_errmsg = 'Y' THEN 
      	  	    	 RETURN 
      	  	    END IF
      	  	    LET t = t - max_count      	  	    
      	  	 END WHILE    
      	  END IF
   	  END IF
      LET l_i = l_i + 1
   END FOREACH
   CLOSE wsv_curs
   IF g_sql_err = FALSE THEN
   	  COMMIT WORK
   	  IF g_show_errmsg = 'Y' THEN 
   	  	RETURN 
   	  END IF
   ELSE
      RETURN
   END IF
   
   #處理單身
   SELECT count(*) INTO l_cnt2 
      FROM wsv_file WHERE wsv01=p_prog and wsv03='D' 
     
   CALL l_wsv.clear()   
   LET l_i = 1
   BEGIN WORK ##part 2
   
   IF l_cnt2 > 0  THEN
      LET l_sql2 = "SELECT wsv02,wsv04,wsv05,wsv06 FROM wsv_file WHERE wsv01= ? and wsv03='D' "
      PREPARE tbl_pre FROM l_sql2
      DECLARE tbl_curs CURSOR FOR tbl_pre
 
      FOREACH tbl_curs USING p_prog INTO l_wsv[l_i].*
      	 LET g_flowname   = l_wsv[l_i].wsv05
         LET g_mdmtabname = l_wsv[l_i].wsv04
         LET g_tabname    = l_wsv[l_i].wsv02
         LET max_count    = l_wsv[l_i].wsv06
         
         SELECT COUNT(*) INTO l_cnt 
         FROM wsw_file WHERE wsw01=p_prog and wsw02=l_wsv[l_i].wsv02 and wsw09='0'
        
         IF g_tabname IS NOT NULL AND l_cnt > 0  THEN
      	    IF l_cnt <= max_count THEN  #只需傳送一次  	   
      	       CALL aws_mdmcli2(p_prog,g_tabname,"D",max_count)
      	    ELSE    #需傳送多次
      	  	   LET t = l_cnt 	   
      	  	   WHILE (t > 0)
      	  	      CALL aws_mdmcli2(p_prog,g_tabname,"D",max_count)
      	  	      IF g_show_errmsg = 'Y' THEN 
      	  	    	   RETURN 
      	  	    END IF
      	  	    LET t = t - max_count      	  	    
      	  	  END WHILE    
      	    END IF
   	     END IF
   	     LET l_i = l_i + 1
      END FOREACH      
      CLOSE tbl_curs
   END IF
   IF g_sql_err = FALSE THEN
   	  COMMIT WORK   	  
   END IF
   
END FUNCTION
 
FUNCTION aws_mdm_showmsg_init()   
   CALL s_showmsg_init() #開啟錯誤訊息資訊
   LET g_show_errmsg = 'N'
END FUNCTION
 
FUNCTION aws_mdm_showmsg()
   IF g_show_errmsg = 'Y' AND g_bgjob = "N" THEN
      CALL s_showmsg()
   ELSE
    	MESSAGE 'Transfer Data OK'
   END IF
END FUNCTION
   
FUNCTION aws_mdmcli2(p_prog,p_wsw02,p_type,p_max_count)
   DEFINE p_prog      LIKE wsv_file.wsv01 #程式代號 
   DEFINE p_wsw02     LIKE wsw_file.wsw02   
   DEFINE p_type      LIKE wsv_file.wsv03
   DEFINE p_max_count LIKE type_file.num10 
   DEFINE l_wsv02   LIKE wsv_file.wsv02 #檔案代碼
   DEFINE l_wsv05   LIKE wsv_file.wsv05 #流程名稱
   DEFINE l_sql     STRING   
   DEFINE l_msg     STRING   
   DEFINE l_wsw     DYNAMIC ARRAY OF RECORD
   	                   wsw02  LIKE wsw_file.wsw02,
   	                   wsw03  LIKE wsw_file.wsw03,
                       wsw04  LIKE wsw_file.wsw04,
                       wsw05  LIKE wsw_file.wsw05,
                       wsw06  LIKE wsw_file.wsw06,
                       wsw07  LIKE wsw_file.wsw07,
                       wsw08  LIKE wsw_file.wsw08
                    END RECORD
   DEFINE l_wsw2    RECORD
   	                   wsw02  LIKE wsw_file.wsw02,
   	                   wsw03  LIKE wsw_file.wsw03,
                       wsw04  LIKE wsw_file.wsw04,
                       wsw05  LIKE wsw_file.wsw05,
                       wsw06  LIKE wsw_file.wsw06,
                       wsw07  LIKE wsw_file.wsw07,
                       wsw08  LIKE wsw_file.wsw08
                    END RECORD                    
   DEFINE l_str     STRING
   DEFINE l_i       LIKE type_file.num10 
   DEFINE l_id      LIKE type_file.num10 
   DEFINE buf       base.StringBuffer 
   DEFINE l_list1   om.NodeList 
   DEFINE l_node    om.DomNode
   
   
   	
   CALL l_wsw.clear()
   LET l_i = 1
   #--------------------------------------------------------------------#
   #準備 Request 資料                                                   #
   #--------------------------------------------------------------------#
   CALL aws_mdmcli_prepareRequest()
   
   FOREACH w_curs USING p_prog,p_wsw02 INTO l_wsw[l_i].*
   	  LET g_action    = l_wsw[l_i].wsw04
   	  LET g_loginuser = l_wsw[l_i].wsw08   
   	  LET ns2invokeMDMFlow.in0.loginUser =  g_loginuser
      
      #--------------------------------------------------------------------#
      #抓取欄位資料，並轉換成 MDM 系統的欄位名稱                           #
      #--------------------------------------------------------------------#
      
      LET g_cnt = l_i      
      CALL aws_mdmcli_field(l_wsw[l_i].wsw05)
      LET l_i = l_i +  1	
      IF l_i > p_max_count THEN
      	 EXIT FOREACH
      END IF 
   END FOREACH 
 
   CLOSE w_curs
   #準備傳送資料    
      LET IMDMWebService_IMDMWebServiceMulePortLocation = g_aza.aza86   #指定 Soap server location
      
      CALL fgl_ws_setOption("http_invoketimeout", 60) #若 60 秒內無回應則放棄
      
      CALL invokeMDMFlow_g() RETURNING g_status      
      
      CALL aws_mdmcli_file("N")   #記錄傳遞的XML字串
         
      IF g_status = 0 THEN
        IF (ns2invokeMDMFlowResponse.out.status != 2) OR
            (ns2invokeMDMFlowResponse.out.status IS NULL) THEN
            	
            LET  g_showmsg = ns2invokeMDMFlowResponse.out.errorMessage
                	
            LET l_id = ns2invokeMDMFlowResponse.out.syncrecords.syncrecord[1].id
            DISPLAY "error id",l_id             
            LET  buf = base.StringBuffer.create() #FUN-890113
            CALL buf.append(g_showmsg)
            #CALL buf.replace(" ","", 0) #清除空白
            CALL buf.replace("\n","", 0)
            CALL buf.replace("	","", 0)
            LET  g_showmsg = buf.toString()
                  
            LET  l_msg = p_prog,"/",l_wsw[l_id].wsw02,"/",l_wsw[l_id].wsw03          
            CALL s_errmsg("wsw01,wsw02,wsw03",l_msg,g_showmsg,ns2invokeMDMFlowResponse.out.status,1)
            LET g_show_errmsg = 'Y'
            
            LET l_wsw2.wsw02 = l_wsw[l_id].wsw02
            LET l_wsw2.wsw03 = l_wsw[l_id].wsw03
            LET l_wsw2.wsw04 = l_wsw[l_id].wsw04
            LET l_wsw2.wsw06 = l_wsw[l_id].wsw06
            LET l_wsw2.wsw07 = l_wsw[l_id].wsw07
            
            LET g_cnt = ns2invokeMDMFlowResponse.out.syncrecords.syncrecord.getLength()
            
            # IF g_cnt = 1 THEN 
               UPDATE wsw_file SET wsw09 = "2" #執行失敗
                WHERE wsw01 = p_prog
                  AND wsw02 = l_wsw2.wsw02
                  AND wsw03 = l_wsw2.wsw03
                  AND wsw04 = l_wsw2.wsw04
                  AND wsw06 = l_wsw2.wsw06     
                  AND wsw07 = l_wsw2.wsw07
                  AND wsw09 = '0'
               
                IF SQLCA.SQLCODE THEN
                   CALL cl_err3("upd","wsw_file",p_prog,l_wsw2.wsw02,SQLCA.sqlcode,"","aws_mdmcli",0)                      
                   ROLLBACK WORK  
                   LET g_sql_err = TRUE
                   RETURN               	   
                END IF                  
            #END IF
                
            CALL aws_mdmcli_file("Y")   #記錄傳遞的XML字串到ERROR LOG
        ELSE
        	  FOR l_i =1 TO g_cnt 
        	  	 
                LET l_wsw2.wsw02 = l_wsw[l_i].wsw02
                LET l_wsw2.wsw03 = l_wsw[l_i].wsw03
                LET l_wsw2.wsw04 = l_wsw[l_i].wsw04            
                LET l_wsw2.wsw06 = l_wsw[l_i].wsw06
                LET l_wsw2.wsw07 = l_wsw[l_i].wsw07
            
                UPDATE wsw_file SET wsw09 = "1" #成功
                 WHERE wsw01 = p_prog
                   AND wsw02 = l_wsw2.wsw02
                   AND wsw03 = l_wsw2.wsw03
                   AND wsw04 = l_wsw2.wsw04
                   AND wsw06 = l_wsw2.wsw06     
                   AND wsw07 = l_wsw2.wsw07
                   AND wsw09 = '0'
                
                IF SQLCA.SQLCODE THEN
                   CALL cl_err3("upd","wsw_file",p_prog,l_wsw2.wsw02,SQLCA.sqlcode,"","aws_mdmcli",0)                      
                   ROLLBACK WORK  
                   LET g_sql_err = TRUE
                   RETURN              	   
                END IF
            END FOR
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
         CALL aws_mdmcli_file("Y")   #記錄傳遞的XML字串
         CALL cl_err(l_str, '!', 1)   #連接失敗    
         RETURN
     END IF
      
END FUNCTION
 
# CALL aws_mdmdata
# 傳入參數: (1)TABLE名稱
#           (2)功能：insert(新增),update(修改),delete(刪除)
#           (3)KEY值
#           (4)Record資料
#           (5) TIPTOP 服務代碼
# 回傳參數:  0:無與 MDM 整合 , 1:呼叫 MDM 成功 , 2:呼叫 MDM 失敗
 
FUNCTION aws_mdmdata(p_table,p_action,p_key,p_record,p_service)
   DEFINE p_table    LIKE wsv_file.wsv02
   DEFINE p_action   string
   DEFINE p_key      LIKE wsw_file.wsw03
   DEFINE p_record   om.DomNode
   DEFINE p_service  string   
   DEFINE l_j,l_i    LIKE type_file.num10
   DEFINE l_name     STRING,
          l_value    STRING,
          l_sql      STRING,
          l_sql2     STRING,
          l_wsw04    LIKE wsw_file.wsw04,
          l_wsw05    LIKE wsw_file.wsw05,
          l_wsw07    LIKE wsw_file.wsw07,
          l_wsw09    LIKE wsw_file.wsw09,
          l_wss06    LIKE wss_file.wss06
   DEFINE l_list1    om.NodeList,
          l_list2    om.NodeList
   DEFINE l_node     om.DomNode,
          l_child    om.DomNode,
          l_record   om.DomNode,
          l_field    om.DomNode  
   DEFINE li_i       LIKE type_file.num5
   DEFINE l_wss      DYNAMIC ARRAY OF RECORD
                         wss04  LIKE wss_file.wss04,                       
                         wss06  LIKE wss_file.wss06                         
                     END RECORD
   DEFINE l_user     LIKE zx_file.zx01
  
  
    IF g_aza.aza85 matches '[ Nn]' OR cl_null(g_aza.aza85) THEN
       #MOD-910133 mark
       #LET g_success='N' #FUN-890113  
       RETURN 0
    END IF
    
    LET l_sql = " select wss06  from wss_file where wss01=? ", 
                "    and wss02 = 'C' and wss03='DSCMDM' and wss04=? "
       
    PREPARE wss_sql FROM l_sql
    DECLARE wss_curs CURSOR FOR wss_sql    	
       
    LET l_wsw07 = TIME
    LET l_wsw05 = "g_plant","=",g_plant,"|"
    LET l_list1 = p_record.selectByTagName("Record")
    FOR l_i = 1 TO l_list1.getLength()
    	  LET l_record = l_list1.item(l_i)        
        LET l_list2 = l_record.selectbyTagName("Field")
       
        FOR l_j = 1 TO l_list2.getLength()
            INITIALIZE l_name TO NULL
            INITIALIZE l_value TO NULL
            LET l_field = l_list2.item(l_j)
            LET l_name = l_field.getAttribute("name")
            LET l_value = l_field.getAttribute("value")            
            CALL aws_mdm_wss06(p_service,l_name) RETURNING l_wss06
            IF l_wss06 IS NOT NULL THEN            	   
            	 IF l_name='zx01' THEN
            	    LET l_user = l_value CLIPPED
            	 END IF 
            	 IF l_name='zx10' THEN  #加密
            	    LET g_mdm_key = "Y"
            	    LET l_value = cl_tokenkey(l_user)   
            	END IF      		
               LET l_wsw05 = l_wsw05 ,l_wss06 CLIPPED ,"=",l_value,"|"
            END IF
       END FOR
    END FOR
    
    #判斷是否同筆資料(key值相同)狀態為未處理或失敗   
    LET l_sql2 = " SELECT wsw04,wsw09 FROM wsw_file ",
                 " WHERE wsw01 = ? and wsw02 = ? and wsw03 = ? ",
                 "   and wsw09 in ('0','2') ",
                 " ORDER BY wsw06 DESC,wsw07 DESC"
       
    PREPARE wsw04_sql FROM l_sql2
    DECLARE wsw04_curs CURSOR FOR wsw04_sql    	
      	
    OPEN wsw04_curs USING g_prog,p_table,p_key
    
    FETCH wsw04_curs INTO l_wsw04,l_wsw09
    
    CLOSE wsw04_curs
    
    IF NOT cl_null(l_wsw04) AND l_wsw09 <> '2' THEN ##FUN-890113 保留2:傳送失敗
       UPDATE wsw_file  SET wsw09 = '3' #將未處理資料狀態改為3:舊資料
        WHERE wsw01 = g_prog
          AND wsw02 = p_table
    	    AND wsw03 = p_key
    	    AND wsw04 = l_wsw04
    	    AND wsw09 = l_wsw09
    END IF
    	         
    CASE p_action 
    	 WHEN "insert"
    	      IF l_wsw04 = "delete" THEN
    	      	 #舊:delete，新:insert時，action 改為 update
    	         LET l_wsw04 = "update"
    	      ELSE
    	         LET l_wsw04 = "insert"
    	      END IF
    	      
    	      INSERT INTO wsw_file
              VALUES(g_prog,p_table,p_key,l_wsw04,l_wsw05,g_today,l_wsw07,g_user,'0') 
                
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","wsw_file",p_key,'',SQLCA.sqlcode,"","",1)
               RETURN 2         
            END IF
    		
       WHEN "delete"    	     
    	      IF l_wsw04 = "insert" THEN        	 
    	      	 #舊:insert，新:delete時 此二筆的wsw09 皆改為3:舊資料
    	      	 LET l_wsw09 = '3'  
    	      ELSE
    	      	 LET l_wsw09 = '0'
    	      END IF
    	      
    	      INSERT INTO wsw_file
              VALUES(g_prog,p_table,p_key,"delete",l_wsw05,g_today,l_wsw07,g_user,l_wsw09) 
                
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","wsw_file",p_key,'',SQLCA.sqlcode,"","",1)
               RETURN 2         
            END IF  
    
       WHEN "update"    	      
    	      IF l_wsw04 = "insert" THEN
    	         #舊:insert，新:update時，action 改為 insert 
    	         LET l_wsw04 = "insert" 	
    	      ELSE
    	         LET l_wsw04 = "update" 	
    	      END IF
    	      
    	      INSERT INTO wsw_file
              VALUES(g_prog,p_table,p_key,l_wsw04,l_wsw05,g_today,l_wsw07,g_user,'0') 
                
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","wsw_file",p_key,'',SQLCA.sqlcode,"","",1)
               RETURN 2         
            END IF
    END CASE 
     
    RETURN 1
END FUNCTION
 
FUNCTION aws_mdm_wss06(p_service,p_name)
 DEFINE p_service  LIKE wss_file.wss01
 DEFINE p_name     LIKE wss_file.wss04
 DEFINE l_wss06    LIKE wss_file.wss06
 
   OPEN wss_curs USING p_service,p_name
   FETCH wss_curs INTO l_wss06
   CLOSE wss_curs
   
   RETURN  l_wss06     
END FUNCTION
#FUN-870166 --end--
