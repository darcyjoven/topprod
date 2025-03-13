# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_account_type_data.4gl
# Descriptions...: 提供--讀取帳別參數資料
# Date & Author..: 2009/10/28 by Mandy
# Memo...........:
# Modify.........: 新建立 FUN-9A0090
# Modify.........: No.FUN-AA0022 2010/10/13 By Mandy HR GP5.2 追版
#
#}

DATABASE ds

#FUN-9A0090

GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此

DEFINE g_table     STRING

#[
# Description....: 提供--讀取帳別參數資料服務(入口 function)
# Date & Author..: 2009/10/28 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_account_type_data()
    
    WHENEVER ERROR CONTINUE
    
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 
    
    #--------------------------------------------------------------------------#
    # 查詢 帳別參數檔   
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_account_type_data_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序    
END FUNCTION


#[
# Description....: 查詢 帳別參數檔
# Date & Author..: 2009/10/28 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_account_type_data_process()
    DEFINE l_aaa       RECORD LIKE aaa_file.*
    DEFINE l_node      om.DomNode
    DEFINE l_sql       STRING
    DEFINE l_wc        STRING
 
    LET l_wc = aws_ttsrv_getParameter("condition")   #取由呼叫端呼叫時給予的 SQL Condition
   
    IF cl_null(l_wc) THEN
       LET l_wc = " 1=1" 
    END IF
    
    LET l_sql="SELECT * FROM aaa_file WHERE ",l_wc,
              " ORDER BY aaa01"
  
    DECLARE aaa_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    
    FOREACH aaa_curs INTO l_aaa.*
        
       LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_aaa), "aaa_file")   #加入此筆單檔資料至 Response 中
    END FOREACH

    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
END FUNCTION
#FUN-AA0022
