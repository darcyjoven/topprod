# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_brand_data.4gl
# Descriptions...: 提供取得 ERP 廠牌資料服務
# Date & Author..: 2010/08/24 by Lilan
# Memo...........:
# Modify.........: 新建立 FUN-A80127
#
#}

DATABASE ds

#FUN-A80127

GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

#[
# Description....: 提供取得 ERP 廠牌資料服務(入口 function)
# Date & Author..: 2010/08/24 by Lilan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_brand_data()
    DEFINE l_str  STRING,
           l_i    LIKE type_file.num10

    
    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 廠牌資料                                                        #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_brand_data_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION


#[
# Description....: 查詢 ERP 廠牌資料
# Date & Author..: 2010/08/24 by Lilan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_brand_data_process()
    DEFINE l_mse       RECORD LIKE mse_file.*
    DEFINE l_wc        STRING
    DEFINE l_node      om.DomNode
    DEFINE l_sql       STRING

 
    LET l_wc = aws_ttsrv_getParameter("condition")   #取由呼叫端呼叫時給予的 SQL Condition
   
    IF cl_null(l_wc) THEN
       LET l_wc = " 1=1" 
    END IF
    
    LET l_sql = "SELECT * FROM mse_file ",
                " WHERE ", 
                l_wc,
                " ORDER BY mse01 "
                 
    DECLARE mse_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    
    FOREACH mse_curs INTO l_mse.*
      
        LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_mse), "mse_file")   #加入此筆資料到單身
    END FOREACH

    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF 
END FUNCTION
