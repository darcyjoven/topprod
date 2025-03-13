# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_create_potential_customer_data.4gl
# Descriptions...: 提供建立潛在客戶主檔資料服務
# Date & Author..: 2009/03/24 by sabrina
# Memo...........:
# Modify.........: No:FUN-930139 10/08/13 By Lilan 追版(GP5.1==>GP5.2)
#
#}

DATABASE ds

#FUN-840004

GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔


#[
# Description....: 提供建立潛在客戶主檔資料服務(入口 function)
# Date & Author..: 2009/03/24 by sabrina 
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_potential_customer_data()
    
    
    WHENEVER ERROR CONTINUE
    
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 建立潛在客戶主檔資料                                                     #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_potential_customer_data_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION


#[
# Description....: 依據傳入資訊新增一筆 ERP 潛在客戶主檔資料
# Date & Author..: 2009/03/24 by sabrina
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_potential_customer_data_process()
    DEFINE l_i       LIKE type_file.num10
    DEFINE l_sql     STRING        
    DEFINE l_cnt1    LIKE type_file.num10,
           l_cnt2    LIKE type_file.num10
    DEFINE l_ofd01   LIKE ofd_file.ofd01
    DEFINE l_wc      STRING
    DEFINE l_node    om.DomNode
   
        
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的客戶基本資料                                      #
    #--------------------------------------------------------------------------#
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("ofd_file")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***
    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF
    
    BEGIN WORK
    
    FOR l_i = 1 TO l_cnt1       
        LET l_node = aws_ttsrv_getMasterRecord(l_i, "ofd_file")         #目前處理單檔的 XML 節點
        
        LET l_ofd01 = aws_ttsrv_getRecordField(l_node, "ofd01")         #取得此筆單檔資料的欄位值
        IF cl_null(l_ofd01) THEN
           LET g_status.code = "-286"                                   #主鍵的欄位值不可為 NULL
           EXIT FOR
        END IF
        CALL aws_ttsrv_setRecordField(l_node, "ofd22", "0")             #新建立的資料狀態預設為〝0：登錄〞
        CALL aws_ttsrv_setRecordField(l_node, "ofdacti", "Y")
        CALL aws_ttsrv_setRecordField(l_node, "ofduser", g_user) 
        CALL aws_ttsrv_setRecordField(l_node, "ofdgrup", g_grup) 
        CALL aws_ttsrv_setRecordField(l_node, "ofddate", g_today)
        CALL aws_ttsrv_setRecordField(l_node, "ofd28", 0)
        CALL aws_ttsrv_setRecordField(l_node, "ofd29", 0)
        
        #----------------------------------------------------------------------#
        # 判斷此資料是否已經建立, 若已建立則為 Update                          #
        #----------------------------------------------------------------------#
        SELECT COUNT(*) INTO l_cnt2 FROM ofd_file WHERE ofd01 = l_ofd01
        IF l_cnt2 = 0 THEN
           LET l_sql = aws_ttsrv_getRecordSql(l_node, "ofd_file", "I", NULL)   #I 表示取得 INSERT SQL
        ELSE
           LET l_wc = " ofd01 = '", l_ofd01 CLIPPED, "' "                      #UPDATE SQL 時的 WHERE condition
           LET l_sql = aws_ttsrv_getRecordSql(l_node, "ofd_file", "U", l_wc)   #U 表示取得 UPDATE SQL
        END IF
   
        #----------------------------------------------------------------------#
        # 執行 INSERT / UPDATE SQL                                             #
        #----------------------------------------------------------------------#
        display l_sql
        EXECUTE IMMEDIATE l_sql
        IF SQLCA.SQLCODE THEN
           LET g_status.code = SQLCA.SQLCODE
           LET g_status.sqlcode = SQLCA.SQLCODE
           EXIT FOR
        END IF
    END FOR
    
    #全部處理都成功才 COMMIT WORK
    IF g_status.code = "0" THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
END FUNCTION
#FUN-930139
