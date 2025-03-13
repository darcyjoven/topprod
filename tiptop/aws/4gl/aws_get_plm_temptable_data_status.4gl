# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_plm_temptable_data_status.4gl
# Descriptions...: 讀取ERP Temp Table資料處理狀態服務
# Date & Author..: 2012/04/10 by Abby
# Memo...........:
# Modify.........: 新建立 DEV-C40002
# Modify.........: No.FUN-D10092 13/01/20 By Abby  PLM GP5.3追版
#
#}
 
DATABASE ds
 
#DEV-C40002
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
 
#[
# Description....: 讀取ERP Temp Table資料處理狀態服務(入口 function)
# Date & Author..: 2012/04/10 by Abby
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_plm_temptable_data_status()
 
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序

    #執行紀錄寫入syslog
    LET g_transaction = 'N'
    CALL aws_syslog("PLM","","1","aws_ttsrv2","","in FUNCTION:aws_get_plm_temptable_data","Y")
    
    #--------------------------------------------------------------------------#
    # 讀取ERP Temp Table資料處理狀態                                           #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_plm_temptable_data_status_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序

    #執行紀錄寫入syslog
    CALL aws_syslog("PLM","","1","aws_ttsrv2","","end FUNCTION:aws_get_plm_temptable_data","Y")
END FUNCTION
 
 
#[
# Description....: 讀取ERP Temp Table資料處理狀態
# Date & Author..: 2012/04/10 by Abby
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_plm_temptable_data_status_process()
   #DEFINE l_wcf   RECORD LIKE wcf_file.*
    DEFINE l_wcf   RECORD 
                      wcf06 LIKE wcf_file.wcf06,
                      wcf09 LIKE wcf_file.wcf09,
                      wcf12 LIKE wcf_file.wcf12,
                      wcf13 LIKE wcf_file.wcf13,
                      wcf14 VARCHAR(4000),         #wcf14型態為TEXT,4gl不支援,故轉換最大VARCHAR
                      wcf15 LIKE wcf_file.wcf15,
                      wcf16 LIKE wcf_file.wcf16,
                      wcf17 LIKE wcf_file.wcf17,
                      wcf18 LIKE wcf_file.wcf18
                   END RECORD
    DEFINE l_wc    STRING
    DEFINE l_sql   STRING
    DEFINE l_node  om.DomNode
    DEFINE l_msg   STRING
 
   
    LET l_wc = aws_ttsrv_getParameter("condition")   #取由呼叫端呼叫時給予的 SQL Condition
 
    IF cl_null(l_wc) THEN
       LET l_wc = ' 1=1'
    END IF
     
    LET l_sql = "SELECT wcf06,wcf09,wcf12,wcf13,CAST(wcf14 as VARCHAR(4000)),",
                "       wcf15,wcf16,wcf17,wcf18 ",
                "  FROM wcf_file ",
                " WHERE wcf07 > 0 ",   #相同DataKey只取一筆資料
                "   AND ",l_wc,    
                " ORDER BY wcf06 "

    LET l_msg = "in FUNCION aws_get_plm_temptable_data_process()|",
                "BEFORE DECLARE wcf_curs CURSOR:",l_sql
    CALL aws_syslog("PLM","","1","aws_ttsrv2","",l_msg,"N")  #執行紀錄寫入syslog
 
    DECLARE wcf_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
 
    FOREACH wcf_curs INTO l_wcf.wcf06,l_wcf.wcf09,l_wcf.wcf12,l_wcf.wcf13,l_wcf.wcf14,
                          l_wcf.wcf15,l_wcf.wcf16,l_wcf.wcf17,l_wcf.wcf18
    
        LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_wcf), "wcf_file")   #加入此筆單檔資料至 Response 中        
    
    END FOREACH
    
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF

    LET l_msg = "in FUNCION aws_del_plm_temptable_data_process()|",
                "AFTER DECLARE wcf_curs CURSOR|g_status.code=",g_status.code
    CALL aws_syslog("PLM","","1","aws_ttsrv2","",l_msg,"N")  #執行紀錄寫入syslog
END FUNCTION
#FUN-D10092
