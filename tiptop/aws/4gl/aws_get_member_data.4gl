# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_member_data.4gl 
# Descriptions...: 提供取得 ERP 會員資料服務
# Date & Author..: 2011/06/01 by Lilan
# Memo...........:
# Modify.........: 新建立  #FUN-B60003
#
#}
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"  #TIPTOP Service Gateway 使用的全域變數檔 
 
#[
# Description....: 提供取得 ERP 會員資料服務
# Date & Author..: 2011/06/01 By Lilan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........: 新建立 FUN-B60003
#]
FUNCTION aws_get_member_data()
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 會員資料                                                        #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_member_data_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序   
END FUNCTION
 
 
#[
# Description....: 查詢 ERP 會員資料
# Date & Author..: 2011/06/01 By Lilan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#]
FUNCTION aws_get_member_data_process()
    DEFINE l_lpk       RECORD LIKE lpk_file.*
    DEFINE l_node      om.DomNode
    DEFINE l_sql       STRING
    DEFINE l_wc        STRING 
    
    LET l_wc = aws_ttsrv_getParameter("condition")   #取由呼叫端呼叫時給予的 SQL Condition
   
    #空白值表示讀取全部資料
    IF cl_null(l_wc) THEN
       LET l_wc = " 1=1"
    END IF

    LET l_sql = "SELECT * FROM lpk_file ",
                " WHERE ",l_wc,
                " ORDER BY lpk01 "
 
    DECLARE lpk_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
 
    FOREACH lpk_curs INTO l_lpk.*
        
        LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_lpk), "lpk_file")   #加入此筆單檔資料至 Response 中 

    END FOREACH
 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
END FUNCTION
