# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_create_customer_data.4gl
# Descriptions...: 提供建立客戶基本資料的服務
# Date & Author..: 2010/08/21 by Lilan
# Memo...........:
# Modify.........: 新建立 FUN-930139  GP5.1追版至GP5.2
# Modify.........: No.FUN-930139
# Modify.........: No.TQC-B80054 11/08/04 By Abby 調整CheckBox欄位預設值
#
#}
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-BA0002 11/11/07 By Abby CRM功能補強：欄位給予預設值
# Modify.........: No.FUN-C20054 12/02/08 By Lilan occ1022需預設為occ01  

DATABASE ds
 
#FUN-930139
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
 
#[
# Description....: 提供建立客戶基本資料的服務(入口 function)
# Date & Author..: 2007/02/06 by Brendan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_customer_data()
    
    
    WHENEVER ERROR CONTINUE
    
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 新增客戶基本資料                                                        #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_customer_data_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
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
FUNCTION aws_create_customer_data_process()
    DEFINE l_i       LIKE type_file.num10
    DEFINE l_sql     STRING        
    DEFINE l_cnt1    LIKE type_file.num10,
           l_cnt2    LIKE type_file.num10
    DEFINE l_occ01   LIKE occ_file.occ01
    DEFINE l_occ05   LIKE occ_file.occ05    #FUN-BA0002 add     
    DEFINE l_occ06   LIKE occ_file.occ06    #FUN-BA0002 add     
    DEFINE l_occ07   LIKE occ_file.occ07    #FUN-BA0002 add     
    DEFINE l_occ09   LIKE occ_file.occ09    #FUN-BA0002 add     
    DEFINE l_occ55   LIKE occ_file.occ55    #FUN-BA0002 add     
    DEFINE l_occ71   LIKE occ_file.occ71    #FUN-BA0002 add     
    DEFINE l_occ1022 LIKE occ_file.occ1022  #FUN-C20054 add
    DEFINE l_wc      STRING
    DEFINE l_node    om.DomNode
   
        
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的客戶基本資料                                      #
    #--------------------------------------------------------------------------#
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("occ_file")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***
    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF
    
    BEGIN WORK
    
    FOR l_i = 1 TO l_cnt1       
        LET l_node = aws_ttsrv_getMasterRecord(l_i, "occ_file")         #目前處理單檔的 XML 節點
        
        LET l_occ01 = aws_ttsrv_getRecordField(l_node, "occ01")         #取得此筆單檔資料的欄位值
        IF cl_null(l_occ01) THEN
           LET g_status.code = "-286"                                   #主鍵的欄位值不可為 NULL
           EXIT FOR
        END IF

       #FUN-BA0002 add str---
        IF g_access.application = 'CRM' THEN
           CALL aws_ttsrv_setRecordField(l_node, "occacti", "P")
        ELSE
       #FUN-BA0002 add end---
           CALL aws_ttsrv_setRecordField(l_node, "occacti", "Y")
        END IF  #FUN-BA0002 add

       #FUN-BA0002 add str---
        IF g_access.application = 'CRM' THEN
           CALL aws_ttsrv_setRecordField(l_node, "occ40", "Y")    
        ELSE
       #FUN-BA0002 add end---
           CALL aws_ttsrv_setRecordField(l_node, "occ40", "N")       #No.TQC-B80054
        END IF  #FUN-BA0002 add
       
       #FUN-BA0002 add str---
       #若該欄位無傳入值,則給予此欄位預設值
        LET l_occ05 = aws_ttsrv_getRecordField(l_node, "occ05")         #取得此筆單檔資料的欄位值
        IF cl_null(l_occ05) THEN
           CALL aws_ttsrv_setRecordField(l_node, "occ05", "1")          #變更l_node內的欄位值
        END IF
        LET l_occ06 = aws_ttsrv_getRecordField(l_node, "occ06")         #取得此筆單檔資料的欄位值
        IF cl_null(l_occ06) THEN
           CALL aws_ttsrv_setRecordField(l_node, "occ06", "1")          #變更l_node內的欄位值
        END IF
        LET l_occ07 = aws_ttsrv_getRecordField(l_node, "occ07")         #取得此筆單檔資料的欄位值
        IF cl_null(l_occ07) THEN
           CALL aws_ttsrv_setRecordField(l_node, "occ07", l_occ01)      #變更l_node內的欄位值
        END IF
        LET l_occ09 = aws_ttsrv_getRecordField(l_node, "occ09")         #取得此筆單檔資料的欄位值
        IF cl_null(l_occ09) THEN
           CALL aws_ttsrv_setRecordField(l_node, "occ09", l_occ01)      #變更l_node內的欄位值
        END IF
        LET l_occ55 = aws_ttsrv_getRecordField(l_node, "occ55")         #取得此筆單檔資料的欄位值
        IF cl_null(l_occ55) THEN
           CALL aws_ttsrv_setRecordField(l_node, "occ55", "0")          #變更l_node內的欄位值
        END IF
        LET l_occ71 = aws_ttsrv_getRecordField(l_node, "occ71")         #取得此筆單檔資料的欄位值
        IF cl_null(l_occ71) THEN
           CALL aws_ttsrv_setRecordField(l_node, "occ71", "1")
        END IF
       #FUN-BA0002 add end---

       #FUN-C20054 add str---
        LET l_occ1022 = aws_ttsrv_getRecordField(l_node, "occ1022")     #取得此筆單檔資料的欄位值
        IF cl_null(l_occ1022) THEN
           CALL aws_ttsrv_setRecordField(l_node, "occ1022", l_occ01)    #若無傳入值,則預設帶occ01
        END IF
       #FUN-C20054 add end---
 
       #FUN-BA0002 add str---
       #若不考慮傳入值(或XML規格無此欄位),則直接給予該欄位固定值
        CALL aws_ttsrv_setRecordField(l_node, "occ34", " ")       
        CALL aws_ttsrv_setRecordField(l_node, "occ63", 0)       
        CALL aws_ttsrv_setRecordField(l_node, "occ64", 0)       
        CALL aws_ttsrv_setRecordField(l_node, "occ1027", "N")       
        CALL aws_ttsrv_setRecordField(l_node, "occ66", " ")       
        CALL aws_ttsrv_setRecordField(l_node, "occ71", "1")       
        CALL aws_ttsrv_setRecordField(l_node, "occpos", "1")       
        CALL aws_ttsrv_setRecordField(l_node, "occoriu", g_user) 
        CALL aws_ttsrv_setRecordField(l_node, "occorig", g_grup) 
        CALL aws_ttsrv_setRecordField(l_node, "occ73", "N")       
       #FUN-BA0002 add end---
        CALL aws_ttsrv_setRecordField(l_node, "occ246", g_plant)
        CALL aws_ttsrv_setRecordField(l_node, "occ1004", "0")
        CALL aws_ttsrv_setRecordField(l_node, "occuser", g_user)  #No.FUN-850147
        CALL aws_ttsrv_setRecordField(l_node, "occgrup", g_grup)  #No.FUN-850147
        CALL aws_ttsrv_setRecordField(l_node, "occdate", g_today) #No.FUN-850147
        CALL aws_ttsrv_setRecordField(l_node, "occ31", "N")       #No.TQC-B80054
        CALL aws_ttsrv_setRecordField(l_node, "occ37", "N")       #No.TQC-B80054
        CALL aws_ttsrv_setRecordField(l_node, "occ56", "N")       #No.TQC-B80054
        CALL aws_ttsrv_setRecordField(l_node, "occ57", "N")       #No.TQC-B80054
        CALL aws_ttsrv_setRecordField(l_node, "occ62", "N")       #No.TQC-B80054
        CALL aws_ttsrv_setRecordField(l_node, "occ65", "N")       #No.TQC-B80054
        
        #----------------------------------------------------------------------#
        # 判斷此資料是否已經建立, 若已建立則為 Update                          #
        #----------------------------------------------------------------------#
        SELECT COUNT(*) INTO l_cnt2 FROM occ_file WHERE occ01 = l_occ01
        IF l_cnt2 = 0 THEN
           LET l_sql = aws_ttsrv_getRecordSql(l_node, "occ_file", "I", NULL)   #I 表示取得 INSERT SQL
        ELSE
           LET l_wc = " occ01 = '", l_occ01 CLIPPED, "' "                      #UPDATE SQL 時的 WHERE condition
           LET l_sql = aws_ttsrv_getRecordSql(l_node, "occ_file", "U", l_wc)   #U 表示取得 UPDATE SQL
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
