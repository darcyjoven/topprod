# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_create_customer_data.4gl
# Descriptions...: 提供建立客戶基本資料的服務
# Date & Author..: 2007/02/06 by Brendan
# Memo...........:
# Modify.........: 新建立 FUN-720021
# Modify.........: No.FUN-830097 08/03/24 By Kevin occ246設定default 工廠 
# Modify.........: No.FUN-830117 08/03/25 By Kevin occ1004設定開立狀態
# Modify.........: No.FUN-830122 08/03/25 By Kevin occacti設定有效狀態
# Modify.........: No.FUN-840004 08/06/17 By Echo 新架構的 Services 與舊架構必須進行區別，
#                                                 因此需調整舊 Services 的程式名稱
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
#FUN-720021
#FUN-840004
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
DEFINE g_table     STRING
 
#[
# Description....: 提供建立客戶基本資料的服務(入口 function)
# Date & Author..: 2007/02/06 by Brendan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_createCustomerData_g()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_initial()   # 服務初始化動作
    
    #--------------------------------------------------------------------------#
    # 檢查登入資訊                                                             #
    #--------------------------------------------------------------------------#
    IF NOT aws_ttsrv_checkSignIn(g_createCustomerData_in.signIn) THEN    
       LET g_status.code = "aws-100"   #登入檢查錯誤
    END IF
    
    #--------------------------------------------------------------------------#
    # 新增客戶基本資料                                                         #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_createCustomerData_add()
    END IF
    
    LET g_createCustomerData_out.status = aws_ttsrv_getStatus()
END FUNCTION
 
 
#[
# Description....: 依據傳入資訊新增一筆 ERP 客戶基本資料
# Date & Author..: 2007/02/08 by Brendan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_createCustomerData_add()
    DEFINE l_i         LIKE type_file.num10,
           l_root      om.DomNode,
           l_list      om.NodeList,
           l_record    om.DomNode,
           l_sql       STRING
               
    
    LET g_table = "occ_file"
 
    LET l_root = aws_ttsrv_stringToXml(g_createCustomerData_in.occ)
    IF l_root IS NULL THEN
       LET g_status.code = "aws-101"   #傳入資料參數錯誤
       RETURN
    END IF
           
    #--------------------------------------------------------------------------#
    # 填充服務所使用 TABLE, 其欄位名稱及欄位預設值                             #
    #--------------------------------------------------------------------------#    
    IF NOT aws_ttsrv_getServiceColumn(g_service) THEN
       LET g_status.code = "aws-102"   #讀取服務設定錯誤
       RETURN
    END IF
   
    #--------------------------------------------------------------------------#
    # 客戶基本資料處理                                                         #
    #--------------------------------------------------------------------------#
    LET l_list = l_root.selectByTagName("Record")
    FOR l_i = 1 TO l_list.getLength()
        LET l_record = l_list.item(l_i)
       
        #----------------------------------------------------------------------#
        # 由傳入的 XML 資料中讀取他系統欄位與欄位值                            #
        #----------------------------------------------------------------------#
        CALL aws_ttsrv_parseDataSetRecrodField(l_record, g_table)           
        
        CALL aws_ttsrv_setServiceColumnValue(g_table, "occ246", g_signIn.organization)#No.FUN-830097
        CALL aws_ttsrv_setServiceColumnValue(g_table, "occ1004", "0")#No.FUN-830117
        CALL aws_ttsrv_setServiceColumnValue(g_table, "occacti", "Y")#No.FUN-830122
 
        #----------------------------------------------------------------------#
        # 組合出 INSERT/UPDATE SQL                                             #
        #----------------------------------------------------------------------#
        LET l_sql = aws_createCustomerData_sql()
        IF cl_null(l_sql) THEN
           RETURN    
        END IF
        DISPLAY l_sql   #可用來輸出並在事後檢查 SQL 是否正確
   
        #----------------------------------------------------------------------#
        # 執行 INSERT/UPDATE SQL                                               #
        #----------------------------------------------------------------------#
        BEGIN WORK
        EXECUTE IMMEDIATE l_sql
        IF SQLCA.SQLCODE THEN
           LET g_status.code = SQLCA.SQLCODE   #資料寫入錯誤
           LET g_status.sqlcode = SQLCA.SQLCODE
           ROLLBACK WORK
        ELSE
           COMMIT WORK
        END IF
        
        RETURN   #一次只處理一筆資料, 故直接 RETURN
    END FOR
END FUNCTION
 
 
#[
# Description....: 判斷此筆資料是否已建立，並組合出 INSERT/UPDATE SQL
# Date & Author..: 2007/02/08 by Echo
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_createCustomerData_sql()
    DEFINE l_occ01     LIKE occ_file.occ01
    DEFINE l_sql       STRING
    DEFINE l_cnt       LIKE type_file.num5
 
 
    #--------------------------------------------------------------------------#
    # 檢查欄位值是否為 Null 值                                                 #
    #--------------------------------------------------------------------------#
    LET l_occ01 = aws_ttsrv_getServiceColumnValue(g_table, "occ01")
    IF cl_null(l_occ01) THEN
       LET g_status.code = "-286"   #主鍵的欄位值為 NULL.
       RETURN NULL
    END IF
 
    #--------------------------------------------------------------------------#
    # 判斷此資料是否已經建立,若已建立則 Update 資料                            #
    #--------------------------------------------------------------------------#
    SELECT COUNT(*) INTO l_cnt FROM occ_file WHERE occ01 = l_occ01
    IF l_cnt = 0 THEN
        #----------------------------------------------------------------------#
        # 組合出 INSERT SQL                                                    #
        # 傳入參數: (1)TABLE 名稱                                              #
        #----------------------------------------------------------------------#
        LET l_sql = aws_ttsrv_getInsertSql(g_table)  
    ELSE
        #----------------------------------------------------------------------#
        # 組合出 UPDATE SQL                                                    #
        # 傳入參數: (1) XML 資料, (2)TABLE 名稱, (3-7) KEY 值欄位              #
        #----------------------------------------------------------------------#
        LET l_sql = aws_ttsrv_getUpdateSql(g_table, 'occ01', '', '', '', '')  
    END IF
 
    RETURN l_sql
END FUNCTION
