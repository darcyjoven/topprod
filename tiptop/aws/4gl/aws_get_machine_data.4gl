# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_machine_data.4gl
# Descriptions...: 提供取得 ERP 機器資料服務
# Date & Author..: 2010/02/05 by Lilan
# Memo...........:
# Modify.........: 新建立 FUN-A20026
#----------------------------------------------------------------------------------------------
# Modify.........: No.FUN-A20026 11/06/20 By Abby GP5.1追版至GP5.25
#
#}

DATABASE ds

#FUN-A20026

GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔


#[
# Description....: 提供取得 ERP 機器資料服務(入口 function)
# Date & Author..: 2010/02/05 by Lilan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_machine_data()


    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 機器資料                                                        #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_machine_data_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION


#[
# Description....: 查詢 ERP 機器資料
# Date & Author..: 2010/02/05 by Lilan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_machine_data_process()
    DEFINE l_eci   RECORD LIKE eci_file.*
    DEFINE l_wc    STRING
    DEFINE l_sql   STRING
    DEFINE l_node  om.DomNode

   
    LET l_wc = aws_ttsrv_getParameter("condition")   #取由呼叫端呼叫時給予的 SQL Condition
    
    LET l_sql = "SELECT * FROM eci_file WHERE ",
                 l_wc, 
                 " ORDER BY eci01"

    DECLARE eci_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF

    FOREACH eci_curs INTO l_eci.*
    
        LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_eci), "eci_file")   #加入此筆單檔資料至 Response 中        
    
    END FOREACH
    
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
END FUNCTION
