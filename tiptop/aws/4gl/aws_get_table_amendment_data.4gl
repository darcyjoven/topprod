# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_table_amendment_data.4gl
# Descriptions...: 提供取得 ERP 檔案架構服務
# Date & Author..: 2009/04/23 by sabrina
# Memo...........:
# Modify.........: 新建立    #FUN-930139
# Modify.........: No:FUN-930139 10/08/13 By Lilan 追版(GP5.1==>GP5.2)
# Modify.........: No.FUN-A90024 10/12/02 By Jay 調整各DB利用sch_file取得table與field等資訊
#
#}

DATABASE ds

GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此

#[
# Description....: 提供取得 ERP 檔案架構服務(入口 function)
# Date & Author..: 2009/04/23 by sabrina
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........: No.FUN-930139 09/04/023 By sabrina 新建立
#
#]
FUNCTION aws_get_table_amendment_data()

    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 檔案架構                                                        #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_table_amendment_data_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序    
END FUNCTION


#[
# Description....: 查詢 ERP 檔案架構
# Date & Author..: 2009/04/23 by sabrina
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........: No.FUN-930139 09/04/23 By sabrina 新建立
#
#]
FUNCTION aws_get_table_amendment_data_process()
    DEFINE l_ztb       RECORD
                       ztb01    LIKE ztb_file.ztb01,
                       ztb02    LIKE ztb_file.ztb02,
                       ztb03    LIKE ztb_file.ztb03,
                       ztb04    LIKE ztb_file.ztb04,
                       ztb08    LIKE ztb_file.ztb08,  
                       scale    LIKE ztb_file.ztb08,
                       ztb09    LIKE ztb_file.ztb09,
                       gaq03    LIKE gaq_file.gaq03
                       END RECORD
    DEFINE l_tmp       RECORD
                       ztb01    LIKE ztb_file.ztb01,
                       ztb02    LIKE ztb_file.ztb02,
                       ztb03    LIKE ztb_file.ztb03,
                       ztb04    LIKE ztb_file.ztb04,
                       num01    LIKE type_file.num10,
                       num02    LIKE type_file.num10,
                       scale    LIKE type_file.num10,
                       #ztb09    LIKE ztb_file.ztb09,      #FUN-A90024 mark
                       sch03    LIKE sch_file.sch03,       #FUN-A90024
                       gaq03    LIKE gaq_file.gaq03
                       END RECORD
    DEFINE l_node      om.DomNode
    DEFINE l_sql       STRING
    DEFINE l_tabname   LIKE ztb_file.ztb01
    DEFINE l_owner     STRING
 
    LET l_tabname = aws_ttsrv_getParameter("table_name")   #取由呼叫端呼叫時給予的 SQL Condition
    LET l_owner = aws_ttsrv_getParameter("owner")          #取由呼叫端呼叫時給予的 SQL Condition

    #---FUN-A90024---start-----
    #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
    #目前統一用sch_file紀錄TIPTOP資料結構
    #LET l_sql = "SELECT table_name as ztb01, owner as ztb02, ",
    #            "       column_name as ztb03, data_type as ztb04,",
    #            "       data_precision as num01, data_length as num02, ", 
    #            "       data_scale as scale,",
    #            "       nullable as ztb09, gaq03 ",
    #            "  FROM all_tab_columns,gaq_file ",
    #            " WHERE lower(column_name) = gaq01",
    #            "   AND gaq02 ='", g_lang CLIPPED,"' ",
    #            "   AND lower(table_name) = '",l_tabname CLIPPED, "' ",
    #            "   AND owner = '",l_owner CLIPPED, "' ", 
    #            " ORDER BY table_name, column_name "     
    CALL cl_query_prt_temptable() 
    CALL cl_query_prt_getlength(l_tabname, 'N', 'm', '0') 

    LET l_sql = "SELECT '", l_tabname, "' as ztb01, '", l_owner, "' as ztb02, ",
                "       xabc02 as ztb03, xabc06 as ztb04,",
                "       xabc04 as num01, xabc04 as num02, ", 
                "       xabc05 as scale,",
                "       sch03 as ztb09, xabc03 as gaq03 ",
                "  FROM xabc , sch_file ",
                " WHERE sch01 = '",l_tabname CLIPPED, "' ",
                "   AND sch02 = xabc02 ",
                "  ORDER BY xabc01"
    #---FUN-A90024---end-------
                 
    DECLARE tmp_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    
    FOREACH tmp_curs INTO l_tmp.*
        LET l_ztb.ztb01 = l_tmp.ztb01
        LET l_ztb.ztb02 = l_tmp.ztb02
        LET l_ztb.ztb03 = l_tmp.ztb03
        LET l_ztb.ztb04 = l_tmp.ztb04
        #LET l_ztb.ztb09 = l_tmp.ztb09   #FUN-A90024 mark
        LET l_ztb.gaq03 = l_tmp.gaq03        
 
        IF cl_null(l_tmp.num01) THEN
           LET l_ztb.ztb08 = l_tmp.num02
        ELSE
           LET l_ztb.ztb08 = l_tmp.num01
        END IF
       
        #IF l_ztb.ztb04 = 'NUMBER' THEN   #FUN-A90024 mark
        IF l_ztb.ztb04 = 'number' OR l_ztb.ztb04 = 'decimal' THEN    #FUN-A90024
           LET l_ztb.scale = l_tmp.scale

           IF l_ztb.ztb08 <> '0' THEN
              LET l_ztb.ztb08 = l_ztb.ztb08 CLIPPED,',',l_ztb.scale CLIPPED
           END IF
        #---FUN-A90024---start-----
        ELSE
           LET l_ztb.scale = l_tmp.scale
           IF l_tmp.scale = -1 THEN
              LET l_ztb.scale = ''
           END IF
        #---FUN-A90024---end-------
        END IF	

        #---FUN-A90024---start-----
        IF l_tmp.sch03 > 255 THEN   #大於等於256就表該欄位為Not Null
           LET l_ztb.ztb09 = 'N'
        ELSE
           LET l_ztb.ztb09 = 'Y'
        END IF
        #---FUN-A90024---end-------
   
        LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_ztb), "ztb_file")   #加入此筆單檔資料至 Response 中
    END FOREACH

    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
END FUNCTION
