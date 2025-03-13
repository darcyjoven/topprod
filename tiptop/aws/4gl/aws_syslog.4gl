# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#{
# Program name...: aws_syslog.4gl
# Descriptions...: 提供 PLM整合各處理環節使用(呼叫)，將當下資料處理過程記錄於wcg_file
# Date & Author..: 2012/04/18 By Lilan
# Memo...........:
# Modify.........: 新建立 #DEV-C40004
# Modify.........: NO.FUN-C50095 12/05/23 By Lilan  防呆,避免客戶家沒有使用法人架構
# Modify.........: NO.TQC-C80077 12/08/13 By Mandy 因為FREE時,已將檔案釋放,所以後面的rm 已是多餘的動作,需mark
# Modify.........: No.FUN-D10092 13/01/20 By Abby  PLM GP5.3追版以上單號
#}


IMPORT com

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"           #TIPTOP Service Gateway 使用的全域變數檔

#DEV-C40004
DEFINE g_wcg           RECORD LIKE wcg_file.*
DEFINE g_wcg10         STRING
DEFINE g_requestxml    STRING
DEFINE g_responsexml   STRING  
DEFINE g_xmlyn         VARCHAR(1)
DEFINE g_locfile1      STRING         #LOCATE檔案路徑與檔名
DEFINE g_locfile2      STRING         #LOCATE檔案路徑與檔名
DEFINE g_locfile3      STRING         #LOCATE檔案路徑與檔名


#####################################################
# Descriptions...: 整合模組處理紀錄LOG(FUNCTION入口)	
# Date & Author..: 12/04/18 By Lilan	
# Input Parameter: p_erpii : 整合產品
#                  p_datakey : DataKey
#                  p_flow : 處理流程/環節
#                  p_prog : 執行程式/功能代號
#                  p_msgid: 訊息代碼
#                  p_msg  : 訊息說明 
#                  p_xmlyn: 是否紀錄XML
# Usage..........: CALL aws_syslog("PLM","","1","aws_process","","","Y")	
# Memo...........: 傳入後，系統會自動抓取g_today/g_time/g_plant/g_dbs	
# Return code....: 	
######################################################	
FUNCTION aws_syslog(p_erpii,p_datakey,p_flow,p_prog,p_msgid,p_msg,p_xmlyn)	
   DEFINE p_erpii     LIKE wcg_file.wcg04       #整合產品
   DEFINE p_datakey   LIKE wcg_file.wcg06       #與PLM整合此變數才有傳入
   DEFINE p_flow      LIKE wcg_file.wcg07       #處理流程/環節
   DEFINE p_prog      LIKE wcg_file.wcg08       #執行程式/功能代號
   DEFINE p_msgid     LIKE wcg_file.wcg09       #訊息代碼
   DEFINE p_msg       STRING                    #訊息說明	
   DEFINE p_xmlyn     VARCHAR(1)                #是否紀錄XML
   DEFINE l_sql       STRING
   DEFINE l_cmd       STRING                    

     LET g_wcg10 = ''
     INITIALIZE g_wcg.*	TO NULL  #初始化

     LET g_wcg.wcg04 = p_erpii
     LET g_wcg.wcg06 = p_datakey
     LET g_wcg.wcg07 = p_flow
     LET g_wcg.wcg08 = p_prog
     LET g_wcg.wcg09 = p_msgid
     LET g_wcg10 = p_msg
     LET g_xmlyn = p_xmlyn     

     CALL aws_syslog_default()
     
     CALL aws_syslog_xmltofile('1',g_wcg10)      #將XML字串轉成檔案
     LOCATE g_wcg.wcg10 IN FILE g_locfile1       
     
     CALL aws_syslog_xmltofile('2',g_requestxml) #將XML字串轉成檔案 
     LOCATE g_wcg.wcg11 IN FILE g_locfile2       

     CALL aws_syslog_xmltofile('3',g_responsexml) #將XML字串轉成檔案
     LOCATE g_wcg.wcg12 IN FILE g_locfile3      

     #-------------------------------------------------------------#
     # 執行 INSERT SQL                                             #
     #-------------------------------------------------------------#
     INSERT INTO wcg_file(wcg01,wcg02,wcg03,wcg04,wcg05,wcg06,
                          wcg07,wcg08,wcg09,wcg10,wcg11,wcg12,
                          wcglegal,wcgplant)
      VALUES(g_wcg.wcg01,g_wcg.wcg02,g_wcg.wcg03,g_wcg.wcg04,g_wcg.wcg05,g_wcg.wcg06,
             g_wcg.wcg07,g_wcg.wcg08,g_wcg.wcg09,g_wcg.wcg10,g_wcg.wcg11,g_wcg.wcg12,
             g_wcg.wcglegal,g_wcg.wcgplant) 
     IF SQLCA.SQLCODE THEN
        LET g_status.code = SQLCA.SQLCODE
        LET g_status.sqlcode = SQLCA.SQLCODE
     END IF
    
     FREE g_wcg.wcg10            
     FREE g_wcg.wcg11            
     FREE g_wcg.wcg12            
    #TQC-C80077 mark---str---
    #LET l_cmd = "rm ",g_locfile1
    #RUN l_cmd
    #LET l_cmd = "rm ",g_locfile2
    #RUN l_cmd
    #LET l_cmd = "rm ",g_locfile3
    #RUN l_cmd
    #TQC-C80077 mark---end---
END FUNCTION	


FUNCTION aws_syslog_default()
   DEFINE l_msg       LIKE ze_file.ze03
   DEFINE l_serial    STRING
   DEFINE l_sb        base.StringBuffer

     #------------------------------------------#
     # 初始 g_status 變數                       #
     #------------------------------------------#
     LET g_status.code = "0"
     LET g_status.sqlcode = "0"
     LET g_status.description = ""

     LET l_serial = CURRENT HOUR TO FRACTION(3)
     LET l_sb = base.StringBuffer.create()
     CALL l_sb.append(l_serial)
     CALL l_sb.replace(":", "", 0)
     CALL l_sb.replace(".", "", 0)
     LET l_serial = l_sb.toString()

     LET g_wcg.wcg01 = TODAY USING 'YYYYMMDD',l_serial    #PK值,系統自動給值：西元日期時分秒毫秒 
     LET g_wcg.wcg02 = g_today                            #日期
     LET g_wcg.wcg03 = CURRENT HOUR TO FRACTION(3)        #時間
     LET g_wcg.wcg05 = g_dbs                              #db name

     IF cl_null(g_legal) THEN                             #FUN-C50095 add
        LET g_wcg.wcglegal = ' '                          #FUN-C50095 add
     ELSE                                                 #FUN-C50095 add
        LET g_wcg.wcglegal = g_legal                      #所屬法人
     END IF                                               #FUN-C50095 add

     LET g_wcg.wcgplant = g_plant                         #營運中心編號

     IF cl_null(g_wcg.wcg06) THEN                         #DataKey
        LET g_wcg.wcg06 = ' '
     END IF

    #依據訊息代碼(wcg09)取出對應的訊息說明
     IF cl_null(g_wcg10) THEN
        IF NOT cl_null(g_wcg.wcg09) THEN
           SELECT ze03 INTO l_msg 
             FROM ze_file 
            WHERE ze01 = g_wcg.wcg09                          
              AND ze02 = g_lang

           LET g_wcg10 = l_msg 
        END IF
     END IF

    #置換單引號
     LET g_wcg10 = cl_replace_str(g_wcg10, "'", "\"")

     IF g_xmlyn = 'Y' THEN
        IF NOT cl_null(g_request.request) THEN
           LET g_requestxml = cl_replace_str(g_request.request,'\"','\"\"')      #wcg11
           LET g_requestxml = cl_replace_str(g_request.request, "'", "\"")
        END IF
        IF NOT cl_null(g_response.response) THEN
           LET g_responsexml = cl_replace_str(g_response.response,'\"','\"\"')   #wcg12
           LET g_responsexml = cl_replace_str(g_response.response, "'", "\"")
        END IF 
     ELSE 
        LET g_requestxml = ' '
        LET g_responsexml = ' '
     END IF
END FUNCTION

#將XML字串轉成檔案 
FUNCTION aws_syslog_xmltofile(p_type,p_xml)
  DEFINE lc_channel     base.Channel
  DEFINE p_xml          STRING
  DEFINE p_type         LIKE type_file.chr1

    LET lc_channel = base.Channel.create()
    CASE p_type
         WHEN '1' 
              LET g_locfile1= FGL_GETENV("TEMPDIR"),"/syslog-",p_type,"-",g_wcg.wcg01,'.txt'
              CALL lc_channel.openFile( g_locfile1 CLIPPED, "w" )
         WHEN '2' 
              LET g_locfile2= FGL_GETENV("TEMPDIR"),"/syslog-",p_type,"-",g_wcg.wcg01,'.txt'
              CALL lc_channel.openFile( g_locfile2 CLIPPED, "w" )
         WHEN '3' 
              LET g_locfile3= FGL_GETENV("TEMPDIR"),"/syslog-",p_type,"-",g_wcg.wcg01,'.txt'
              CALL lc_channel.openFile( g_locfile3 CLIPPED, "w" )
    END CASE
    CALL lc_channel.setDelimiter("")
    CALL lc_channel.write(p_xml) 
    CALL lc_channel.close()    
END FUNCTION
#FUN-D10092
