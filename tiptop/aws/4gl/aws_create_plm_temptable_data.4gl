# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_create_plm_temptable_data.4gl
# Descriptions...: 提供建立PLM整合資料暫存檔的服務
# Date & Author..: 2012/04/11 by Abby
# Memo...........:
# Modify.........: 新建立 DEV-C40002
# Modify.........: NO.FUN-C50095 12/05/23 By Lilan 防呆,避免客戶家沒有使用法人架構
# Modify.........: NO.FUN-C70009 12/07/05 By Lilan 無需進行字串轉換(lib已處理)
# Modify.........: NO.TQC-C80077 12/08/13 By Mandy 因為FREE時,已將檔案釋放,所以後面的rm 已是多餘的動作,需mark
# Modify.........: No.FUN-D10092 13/01/20 By Abby  PLM GP5.3追版以上單號
#}
 
DATABASE ds
 
#DEV-C40002
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
DEFINE g_wcf         RECORD LIKE wcf_file.*
DEFINE g_wcfxml      STRING                  #因4GL不支援STRING型態對應接值變數的資料庫欄位型態為text
DEFINE g_datakeystr  STRING
DEFINE g_locfile     STRING                  #LOCATE檔案路徑與檔名
 


#[
# Description....: 提供建立PLM整合資料暫存檔的服務(入口 function)
# Date & Author..: 2012/04/11 by Abby
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_plm_temptable_data()
    
    
    WHENEVER ERROR CONTINUE
    
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序

 
    CALL aws_syslog("PLM","","1","aws_ttsrv2","","in FUNCTION:aws_create_plm_temptable_data","Y")   

    #--------------------------------------------------------------------------#
    # 新增PLM整合資料暫存檔                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_plm_temptable_data_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序

    CALL aws_syslog("PLM",g_datakeystr,"1","aws_ttsrv2","","end FUNCTION:aws_create_plm_temptable_data","Y") 
END FUNCTION
 
 
#[
# Description....: 依據傳入資訊新增一筆PLM整合資料暫存檔
# Date & Author..: 2012/04/11 by Abby
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_plm_temptable_data_process()
    DEFINE l_sql       STRING        
    DEFINE l_cmd       STRING
    DEFINE l_prog      STRING 
    DEFINE l_msg       STRING
    DEFINE l_status RECORD
              code           STRING,      #訊息代碼
              sqlcode        STRING       #SQL ERROR CODE
           END RECORD


    BEGIN WORK
          
    #----------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的PLM整合資料暫存檔資料                         #
    #                                                                      #
    # 執行 INSERT / UPDATE SQL                                             #
    #----------------------------------------------------------------------#
    IF aws_create_plm_temptable_data_default() THEN
        LOCATE g_wcf.wcf10 IN FILE g_locfile        
        
        INSERT INTO wcf_file(wcf01,wcf02,wcf03,wcf06,wcf07,wcf08,wcf09,wcf10,wcf11,wcf12,
                             wcf13,wcf14,wcf15,wcf16,wcf17,wcf18,wcflegal,wcfplant) 
                      VALUES(g_wcf.wcf01,g_wcf.wcf02,g_wcf.wcf03,g_wcf.wcf06,g_wcf.wcf07,g_wcf.wcf08,
                             g_wcf.wcf09,g_wcf.wcf10,g_wcf.wcf11,'','','','','',g_wcf.wcf17,'',
                             g_wcf.wcflegal,g_wcf.wcfplant)
        LET g_datakeystr = g_wcf.wcf08                                     #轉換型態去除空白
        LET g_datakeystr = g_wcf.wcf06,'-',g_datakeystr                    
        LET l_msg = "in FUNCION aws_create_plm_temptable_data_process()|",
                    "BEFORE EXECUTE INSERT_SQL:",l_sql
        CALL aws_syslog("PLM",g_datakeystr,"1","aws_ttsrv2","",l_msg,"Y")  #執行紀錄寫入syslog      
       
        IF SQLCA.SQLCODE THEN
           LET g_status.code = SQLCA.SQLCODE
           LET g_status.sqlcode = SQLCA.SQLCODE
        END IF
       
        LET l_status.code = g_status.code
        LET l_status.sqlcode = g_status.sqlcode

        #全部處理都成功才 COMMIT WORK
        IF g_status.code = "0" THEN
           COMMIT WORK
        
           #<tot_cnt>有傳入值表示為此批最後一包,因此主動呼叫批次作業進行處理
           IF g_wcf.wcf07 > 0 THEN
              LET l_prog = 'aws_process'
              LET l_cmd = l_prog," 'Y' '",g_wcf.wcf06 CLIPPED,"'"                    #呼叫批次時要傳入的參數
              LET l_msg = "WS(CreatePLMTempTableData) CALL aws_process:l_cmd=",l_cmd
              CALL aws_syslog("PLM",g_datakeystr,"1","aws_ttsrv2","",l_msg,"N")      #將歷程寫入sys_log 
              CALL cl_cmdrun(l_cmd)                                                  #呼叫批次作業
           END IF
        ELSE
           ROLLBACK WORK
        END IF
       
        FREE g_wcf.wcf10   
       #LET l_cmd = "rm ",g_locfile #TQC-C80077 mark
       #RUN l_cmd                   #TQC-C80077 mark
        LET l_msg = "in FUNCION aws_create_plm_temptable_data_process()|",
                    "AFTER EXECUTE INSERT_SQL|g_status.code=",g_status.code
        CALL aws_syslog("PLM",g_datakeystr,"1","aws_ttsrv2","",l_msg,"N")  #執行紀錄寫入syslog      
    ELSE
         LET l_status.code = g_status.code
         LET l_status.sqlcode = g_status.sqlcode
         CALL aws_syslog("PLM",g_datakeystr,"1","aws_ttsrv2",g_status.code,"","N")  #執行紀錄寫入syslog        
    END IF

    #還原舊值
    LET g_status.code = l_status.code
    LET g_status.sqlcode = l_status.sqlcode
END FUNCTION

#[
# Description....: 設定 wcf_file 欄位預設值
# Date & Author..: 2012/04/11 by Abby
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_plm_temptable_data_default()
 DEFINE l_serial       STRING
 DEFINE l_sb           base.StringBuffer
 DEFINE lc_channel     base.Channel


   #系統自動給值：西元日期時分秒毫秒 
    LET l_serial = CURRENT HOUR TO FRACTION(3)
    LET l_sb = base.StringBuffer.create()
    CALL l_sb.append(l_serial)
    CALL l_sb.replace(":", "", 0)
    CALL l_sb.replace(".", "", 0)
    LET l_serial = l_sb.toString()
    LET g_wcf.wcf01 = TODAY USING 'YYYYMMDD',l_serial
    LET g_wcf.wcf02 = g_today
    LET g_wcf.wcf03 = CURRENT HOUR TO FRACTION(3)
     
    IF cl_null(g_legal) THEN             #FUN-C50095 add
       LET g_wcf.wcflegal = ' '          #FUN-C50095 add
    ELSE                                 #FUN-C50095 add
       LET g_wcf.wcflegal = g_legal
    END IF                               #FUN-C50095 add

    LET g_wcf.wcfplant = g_plant
    LET g_wcf.wcf06 = aws_ttsrv_getParameter("datakey")

    IF cl_null(g_wcf.wcf06) THEN
       LET g_status.code = "aws-620"         #DataKey不可空白!
       ROLLBACK WORK

       RETURN FALSE                                 
    END IF

    LET g_wcf.wcf07 = aws_ttsrv_getParameter("tot_cnt")
    IF cl_null(g_wcf.wcf07) THEN
       LET g_wcf.wcf07 = 0
    END IF

    LET g_wcf.wcf08 = aws_ttsrv_getParameter("sub_cnt")

    IF cl_null(g_wcf.wcf08) THEN
       LET g_status.code = "aws-621"         #sub_cnt不可空白!
       ROLLBACK WORK
       RETURN FALSE                          
    END IF

    LET g_wcf.wcf09 = aws_ttsrv_getParameter("ws_name")

    IF cl_null(g_wcf.wcf09) THEN
       LET g_status.code = "aws-622"         #ws_name不可空白!
       ROLLBACK WORK
       RETURN FALSE                          
    END IF

    LET g_wcfxml = g_request.request
   #LET g_wcfxml = cl_replace_str(g_wcfxml, "'", "\"") #FUN-C70009 mark
    LET g_wcf.wcf11 = g_lang
    LET g_wcf.wcf17 = 'N'

   #將XML字串轉成檔案 
    LET g_locfile = FGL_GETENV("TEMPDIR"),"/",g_wcf.wcf01,'.txt'
    LET lc_channel = base.Channel.create()
    CALL lc_channel.openFile( g_locfile CLIPPED, "w" )
    CALL lc_channel.setDelimiter("")
    CALL lc_channel.write(g_wcfxml)
    CALL lc_channel.close()   

    RETURN TRUE                               
END FUNCTION
#FUN-D10092
