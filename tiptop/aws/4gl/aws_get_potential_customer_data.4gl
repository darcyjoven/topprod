# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_potential_customer_data.4gl
# Descriptions...: 提供取得 ERP 潛在客戶主檔資料服務
# Date & Author..: 2009/04/23 by sabrina
# Memo...........:
# Modify.........: 新建立    #FUN-930139
# Modify.........: No:FUN-930139 10/08/13 By Lilan 追版(GP5.1==>GP5.2)
#
#}

DATABASE ds

GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此

#[
# Description....: 提供取得 ERP 潛在客戶主檔資料服務(入口 function)
# Date & Author..: 2009/04/23 by sabrina
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........: No.FUN-930139 09/04/023 By sabrina 新建立
#
#]
FUNCTION aws_get_potential_customer_data()

    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 潛在客戶主檔編號                                                #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_potential_customer_data_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序    
END FUNCTION


#[
# Description....: 查詢 ERP 潛在客戶主檔編號
# Date & Author..: 2009/04/23 by sabrina
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........: No.FUN-930139 09/04/23 By sabrina 新建立
#
#]
FUNCTION aws_get_potential_customer_data_process()
    DEFINE l_ofd       RECORD LIKE ofd_file.*
    DEFINE l_node      om.DomNode
    DEFINE l_sql       STRING
    DEFINE l_wc        STRING
 
    LET l_wc = aws_ttsrv_getParameter("condition")   #取由呼叫端呼叫時給予的 SQL Condition
   
    IF cl_null(l_wc) THEN
       LET l_wc = " 1=1" 
    END IF
    
    LET l_sql = "SELECT * FROM ofd_file WHERE ofdacti = 'Y' AND ",
                 l_wc," ORDER BY ofd01 "
                 
    DECLARE ofd_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    
    FOREACH ofd_curs INTO l_ofd.*
    	
        LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_ofd), "ofd_file")   #加入此筆單檔資料至 Response 中
    END FOREACH

    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
END FUNCTION
#FUN-930139
