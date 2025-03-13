# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Library name...: aws_apscli
# Descriptions...: 透過 Web Services 將 TIPTOP 與 APS 整合
# Input parameter:
# Return code....:  
#                  
# Usage .........: call aws_apscli()
# Date & Author..: 97/04/24 By kevin #FUN-840179
# Modify.........: No.MOD-870105 08/07/09 By kevin 加入sleep 
# Modify.........: No.MOD-8B0184 08/11/19 By kevin 回傳連線失敗
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
 
 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/27 By douzh GP5.2集團架構調整,azp相關修改
# Modify.........: No.FUN-B50050 11/05/06 By Mandy---GP5.25 追版:以上為GP5.1 的單號---
# Modify.........: No.FUN-B50050 11/05/06 By Mandy---GP5.25 追版:以下為GP5.25的單號---str---
# Modify.........: No:FUN-990012 09/09/08 By Mandy (1)第二次抓KEY時,並未成功
#                                                  (2)APS回饋的訊息區分-99:APS回饋失敗,KEY重覆,請至APS檢查
#                                                                      -98:APS回饋失敗,KEY抓取錯誤,請至APS檢查
#                                                                       -1:網路連線失敗
#                                                                   
# Modify.........: No:FUN-B30107 11/03/15 By Mandy 使用環境變數:DCIMCP_Client,層級為系統變數
# Modify.........: No.FUN-B50050 11/05/06 By Mandy---GP5.25 追版----------------------end---
# Modify.........: No:FUN-CC0150 12/12/28 By Mandy 傳給APS時增加傳<code9> 此碼傳legal code(法人)
# Modify.........: No:FUN-D10041 13/01/09 By Mandy 呼叫 APSBrowser.exe 時需傳入語系別(-L)及是否登入(-S)參數

IMPORT com
IMPORT os   #No.FUN-9C0009  
DATABASE ds
#FUN-840179
GLOBALS "../4gl/aws_apsgw.inc"
GLOBALS "../../config/top.global"
 
DEFINE g_apskey string
DEFINE g_vlg04  LIKE vlg_file.vlg04
DEFINE g_vzv01  LIKE vzv_file.vzv01
DEFINE g_vzv02  LIKE vzv_file.vzv02
DEFINE g_vzv03  LIKE vzv_file.vzv03
DEFINE g_command_id		STRING
DEFINE g_result       STRING
 
FUNCTION initSoap()
DEFINE l_azp01   LIKE azp_file.azp01
 
   IF cl_null(g_vlg04) THEN
#FUN-980020--begin
#     SELECT azp01 INTO l_azp01 FROM azp_file WHERE azp03 = g_dbs
#     
#     IF SQLCA.SQLCODE THEN
#        CALL cl_err3('sel','azp_file','','',SQLCA.sqlcode,'','',1)
#        RETURN FALSE
#     END IF
   
#     SELECT vlg04 INTO g_vlg04 FROM vlg_file WHERE vlg01= l_azp01
      SELECT vlg04 INTO g_vlg04 FROM vlg_file WHERE vlg01= g_plant
#FUN-980020--end
       
      IF SQLCA.SQLCODE THEN         
         CALL cl_err('','aps-501',1)
         RETURN FALSE         
      END IF
      
      LET Aps_APeSService_APeSServiceSoapLocation = g_vlg04      
   END IF 
   RETURN TRUE
END FUNCTION
 
#取回key
FUNCTION aws_aps_login()
   DEFINE l_status	LIKE type_file.num10   
     
   IF NOT initSoap() THEN
   	  RETURN
   END IF
   
   CALL fgl_ws_setOption("http_invoketimeout", 60)         #若 60 秒內無回應則放棄
   CALL Aps_Login("tiptop","tiptop") RETURNING l_status, g_apskey         
   CALL aws_apscli_log(base.TypeInfo.create(Aps_Login),l_status,g_apskey) RETURNING g_result
   
END FUNCTION
 
FUNCTION aws_insert_command(p_command_id, p_code1, p_code2, p_code3, p_code4, p_code5,
                                 p_code6, p_code7, p_code8, p_code9) #FUN-CC0150 add p_code9
   DEFINE	p_command_id		STRING
   DEFINE	p_code1		      STRING
   DEFINE	p_code2		      STRING
   DEFINE	p_code3		      STRING
   DEFINE	p_code4		      STRING
   DEFINE	p_code5		      STRING
   DEFINE	p_code6		      STRING
   DEFINE	p_code7		      STRING
   DEFINE	p_code8		      STRING
   DEFINE	p_code9		      STRING #FUN-CC0150 add p_code9
   DEFINE l_status	      LIKE type_file.num10
   DEFINE l_result        STRING
   
   LET g_command_id=p_command_id
   LET g_vzv01=p_code2
   LET g_vzv02=p_code3
   LET g_result=""
   
   IF NOT initSoap() THEN
   	  RETURN
   END IF
   LET g_apskey = NULL          #FUN-990012 add
   CALL aws_aps_login()         #FUN-990012 add
   IF cl_null(g_apskey) THEN
   	 #CALL aws_aps_login()  #FUN-990012 mark
   	  IF g_result="F" THEN
   	  	 RETURN FALSE   	  	 
   	  END IF
   END IF
   
   CALL fgl_ws_setOption("http_invoketimeout", 60)         #若 60 秒內無回應則放棄
   
   
   IF NOT cl_null(g_apskey) THEN
      CALL Aps_InsertCommand(p_command_id, p_code1, p_code2, p_code3, p_code4, p_code5,
                                  p_code6, p_code7, p_code8, p_code9, g_apskey) #FUN-CC0150 add p_code9
              RETURNING l_status, l_result   
      
      CALL aws_apscli_log(base.TypeInfo.create(Aps_InsertCommand),l_status,l_result) RETURNING g_result           
   ELSE
   	  CALL aws_apscli_log(null,0,"Cannot find APS Key")  RETURNING g_result #MOD-8B0184
   END IF
   
   #MOD-8B0184 start
   IF g_result="F" THEN
   	  RETURN FALSE   	  	 
   ELSE
   		RETURN TRUE
   END IF
   #MOD-8B0184 end
   
END FUNCTION
 
#記錄request message
FUNCTION aws_log_request(p_record)
   DEFINE p_record   om.DomNode
   DEFINE l_list     om.NodeList
   DEFINE l_list2     om.NodeList
   DEFINE l_i        LIKE type_file.num10
   DEFINE l_k        LIKE type_file.num10
   DEFINE l_node     om.DomNode
   DEFINE l_node2    om.DomNode  
   DEFINE l_name     STRING,          
          l_value    STRING,
          l_result   STRING    
 
   
   LET l_list = p_record.selectByTagName("Record")
   FOR l_k = 1 TO l_list.getLength()
       LET l_node = l_list.item(l_k)       
 
       LET l_list2 = l_node.selectByTagName("Field")
       FOR l_i = 1 TO l_list2.getLength()
           LET l_node2 = l_list2.item(l_i)
 
           INITIALIZE l_name TO NULL
           INITIALIZE l_value TO NULL
           LET l_name = l_node2.getAttribute("name")
           LET l_value = l_node2.getAttribute("value")
           LET l_result = l_result,"<",l_name,">\n",l_value,"\n"
       END FOR      
   END FOR       
   RETURN l_result
   
END FUNCTION   
 
FUNCTION aws_apscli_log(p_record,p_status,p_result)
    DEFINE p_record     om.DomNode
    DEFINE p_status	    LIKE type_file.num10
    DEFINE p_result     STRING
    DEFINE l_file       STRING,                
           l_str        STRING,
           l_request    STRING
    DEFINE l_i          LIKE type_file.num10
    DEFINE channel      base.Channel
    DEFINE p_command_id		STRING
    DEFINE l_result     STRING
 
    LET l_result = "Y"    
    
    LET channel = base.Channel.create()
    LET l_file = fgl_getenv("TEMPDIR"), "/",
                 "aws_apscli-", TODAY USING 'YYYYMMDD', ".log"
 
    CALL channel.openFile(l_file, "a")    
 
    IF STATUS = 0 THEN
       CALL channel.setDelimiter("")
       LET l_str = "#--------------------------- (", CURRENT YEAR TO SECOND, ") ----------------------------#"
       CALL channel.write(l_str)
       CALL channel.write("")
       IF p_record IS NOT NULL THEN
          CALL channel.write("Request XML:")
          CALL aws_log_request(p_record) RETURNING l_request
          CALL channel.write(l_request)
       END IF
       
       CALL channel.write("")
       CALL channel.write("Response XML:")
 
       IF p_status = 0 THEN
         #FUN-990012 mod---str---
          CASE p_result
               WHEN -99
                    LET l_str = '-99:APS err,<Key>repeated !'
               WHEN -98
                    LET l_str = '-98:APS err,<Key>failed !'
               WHEN -1
                    LET l_str = '-1:Connection failed !'
               OTHERWISE
                    LET l_str = p_result
          END CASE
          CALL channel.write(l_str)
         #CALL channel.write(p_Result)
         #FUN-990012 mod---end---
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
          LET l_result = "F" #MOD-8B0184
          CALL cl_err(l_str, '!', 1)   #連接失敗
       END IF
 
       CALL channel.write("")
       CALL channel.write("#------------------------------------------------------------------------------#")
       CALL channel.close()
#      RUN "chmod 666 " || l_file || " >/dev/null 2>&1"   #No.FUN-9C0009
       IF os.Path.chrwx(l_file CLIPPED,438) THEN END IF   #No.FUN-9C0009
    ELSE
       DISPLAY "Can't open log file."
    END IF
    
    RETURN l_result #MOD-8B0184
    
END FUNCTION
 
#啟動APS CP手調器
FUNCTION aws_open_browser(l_vzx00,l_vzx01,l_vzx02,p_type)
   DEFINE l_vzx00        LIKE vzx_file.vzx00,
          l_vzx01        LIKE vzx_file.vzx01,
          l_vzx02        LIKE vzx_file.vzx02,
          p_type         LIKE type_file.chr1
   DEFINE l_url        string,
          l_aps_path   string,
          res          string
   DEFINE l_lang_type    LIKE type_file.chr10 #FUN-D10041 add
            
  #FUN-B30107 mod---str---
  #CALL get_reg_path() RETURNING l_aps_path   
   CALL ui.Interface.frontCall( "standard", "getenv","DCIMCP_Client", [l_aps_path] )
   IF cl_null(l_aps_path) THEN
       CALL get_reg_path() RETURNING l_aps_path   
       DISPLAY "USE Old APSBrowser==> patch:",l_aps_path
   ELSE
       DISPLAY "USE New APSBrowser==> patch:",l_aps_path
   END IF
   #FUN-D10041--add--str---
   CASE g_lang
       WHEN '0'
            LET l_lang_type = 'CHT'  #繁體
       WHEN '1'
            LET l_lang_type = 'ENG'  #英文
       WHEN '2'
            LET l_lang_type = 'CHS'  #簡體
       WHEN '4'
            LET l_lang_type = 'VIET' #越南
       WHEN '5'
            LET l_lang_type = 'THAI' #泰文
       OTHERWISE
            LET l_lang_type = 'CHT'  #繁體
   END CASE
   #FUN-D10041--add--end---
  #FUN-B30107 mod---end---
   IF NOT cl_null(l_aps_path) THEN
   	  #啟動APS CP手調器
   	 #LET l_url = l_aps_path ,"/APSBrowser "," -C ",l_vzx00," -F ",l_vzx01," -V ",l_vzx02," -U ",g_user," -P ",p_type                              #FUN-D10041 mark
   	  LET l_url = l_aps_path ,"/APSBrowser "," -C ",l_vzx00," -F ",l_vzx01," -V ",l_vzx02," -U ",g_user," -P ",p_type, " -L ",l_lang_type," -S 1 " #FUN-D10041 add -S TIPTOP不需要登入APS, 所以登入選項一律設定 1
                                                                                                                                                       #FUN-D10041 add -L 語系為根據TIPTOP當下的語系別來傳入,預設 CHT                       
   	  DISPLAY l_url   	      
      CALL ui.Interface.frontCall("standard","shellexec", [l_url], [res])
   END IF
   
END FUNCTION
 
#取回Windows 機碼
FUNCTION get_reg_path()
  DEFINE l_source  STRING         
  DEFINE l_ch       base.Channel
  DEFINE l_buf      STRING
  #DEFINE l_i       LIKE type_file.num10
  DEFINE l_i        INT
  DEFINE l_file     STRING
  DEFINE l_str      STRING
  DEFINE l_cmd      STRING
  DEFINE l_url      STRING,
         l_result   STRING,
         res        LIKE type_file.num10 
  
  
    LET l_source= "c:\\aps.reg"
    LET l_url = "Cmd.exe /c \"reg query \"HKEY_LOCAL_MACHINE\\SOFTWARE\\DCI\\APS\" > ",l_source,"\" "
    DISPLAY l_url
    CALL ui.Interface.frontCall("standard","shellexec", [l_url], [res])
 
    IF res THEN #MOD-870105
       SLEEP 1
    ELSE 
       
    END IF    
 
    LET l_file = fgl_getenv("TEMPDIR"), "/", fgl_getpid() USING '<<<<<<<<<<', ".log"
    CALL FGL_GETFILE(l_source, l_file)
    #display l_file    	
    IF STATUS THEN
    	 DISPLAY "Cannot upload file "
       RETURN FALSE       
    ELSE    	
#      LET l_cmd = "chmod 666 ", l_file CLIPPED, " >/dev/null 2>&1"  #No.FUN-9C0009
#      RUN l_cmd                                          #No.FUN-9C0009
       IF os.Path.chrwx(l_file CLIPPED,438) THEN END IF   #No.FUN-9C0009
    END IF  
    
    LET l_ch = base.Channel.create()
    CALL l_ch.openFile(l_file, "r")
    CALL l_ch.setDelimiter(NULL)
    LET l_i = 1
    WHILE l_ch.read(l_buf)         
       
       	 LET l_str = l_buf CLIPPED
       	 IF ( l_str.getIndexOf("Client",1)>0 ) THEN
       	 	  CALL parseToken(l_str) RETURNING l_result       	 	  
       	 END IF
       
    END WHILE
 
    CALL l_ch.close()
    RUN "rm -f " || l_file
    RETURN l_result    
END FUNCTION   
 
FUNCTION parseToken(p_str)
  DEFINE p_str      STRING 
  DEFINE l_result   STRING  
  DEFINE l_i        INT
    
    LET l_i = p_str.getIndexOf("REG_SZ",1)
    LET l_result= p_str.substring(l_i+7 ,p_str.getLength())   
    
    RETURN l_result.trim()
    
END FUNCTION 
#FUN-B50050
