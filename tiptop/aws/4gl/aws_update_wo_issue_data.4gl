# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_update_wo_issue_data.4gl
# Descriptions...: 提供更新工單領料單資料的服務
# Date & Author..: 2008/05/16 by kim (FUN-840012)
# Memo...........:
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-C60079 12/06/11 By fengrui 函數i501sub_y_chk添加參數
# Modify.........: No:FUN-C70014 12/07/09 By wangwei 新增RUN CARD發料作業
 
DATABASE ds
 
#FUN-840012
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
#[
# Description....: 提供更新工單領料單資料的服務(入口 function)
# Date & Author..: 2008/05/16 by kim
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_update_wo_issue_data()
 
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 新增工單領料單資料                                                       #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_update_wo_issue_data_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 依據傳入資訊更新 ERP 工單領料單資料
# Date & Author..: 2008/05/16 by kim
# Parameter......: none
# Return.........: 領料單號
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_update_wo_issue_data_process()
    DEFINE l_i        LIKE type_file.num10,
           l_j        LIKE type_file.num10
    DEFINE l_sql      STRING
    DEFINE l_cnt      LIKE type_file.num10,
           l_cnt1     LIKE type_file.num10,
           l_cnt2     LIKE type_file.num10
    DEFINE l_node1    om.DomNode,
           l_node2    om.DomNode
    DEFINE l_flag     LIKE type_file.num5
    DEFINE l_return   RECORD                           #回傳值必須宣告為一個 RECORD 變數, 且此 RECORD 需包含所有要回傳的欄位名稱與定義
                         sfp01   LIKE sfp_file.sfp01   #回傳的欄位名稱
                      END RECORD
    DEFINE l_sfp      RECORD LIKE sfp_file.*
    DEFINE l_sfs      RECORD LIKE sfs_file.*
    DEFINE l_yy,l_mm  LIKE type_file.num5       
    DEFINE l_status   LIKE sfp_file.sfpconf
    DEFINE l_cmd      STRING
    DEFINE l_prog     STRING
    DEFINE l_sfs05    LIKE sfs_file.sfs05
    DEFINE l_sfs06    LIKE sfs_file.sfs06
    DEFINE l_sfs07    LIKE sfs_file.sfs07
    DEFINE l_sfs08    LIKE sfs_file.sfs08
    DEFINE l_sfs09    LIKE sfs_file.sfs09
    DEFINE l_sfs10    LIKE sfs_file.sfs10
    DEFINE l_sfs21    LIKE sfs_file.sfs21
 
 
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的工單領料單資料                                    #
    #--------------------------------------------------------------------------#
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("sfp_file")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***
    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF
 
    SELECT * INTO g_sma.* FROM sma_file
     WHERE sma00='0'
 
    BEGIN WORK
 
    FOR l_i = 1 TO l_cnt1
        INITIALIZE l_sfp.* TO NULL
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "sfp_file")        #目前處理單檔的 XML 節點
        LET l_status = aws_ttsrv_getParameter("status")
 
        LET l_sfp.sfp01 = aws_ttsrv_getRecordField(l_node1, "sfp01")         #取得此筆單檔資料的欄位值
       #LET l_sfp.sfp02 = aws_ttsrv_getRecordField(l_node1, "sfp02")
 
        SELECT * INTO l_sfp.* FROM sfp_file
         WHERE sfp01=l_sfp.sfp01
           AND sfp06 NOT IN ('A','B','C')
        
        CASE
          WHEN SQLCA.sqlcode
             LET g_status.code=SQLCA.sqlcode
             EXIT FOR
          WHEN l_sfp.sfpconf='Y'
             LET g_status.code='9023'
             EXIT FOR
          WHEN l_sfp.sfpconf='X'
             LET g_status.code='9024'
             EXIT FOR
        END CASE
        #----------------------------------------------------------------------#
        # 處理單身資料                                                         #
        #----------------------------------------------------------------------#
        LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "sfs_file")       #取得目前單頭共有幾筆單身資料
        IF l_cnt2 = 0 THEN
           LET g_status.code = "mfg-009"   #必須有單身資料
           EXIT FOR
        END IF
 
        FOR l_j = 1 TO l_cnt2
            INITIALIZE l_sfs.* TO NULL
            LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j, "sfs_file")   #目前單身的 XML 節點
 
 
            #------------------------------------------------------------------#
            # NODE資料傳到RECORD                                               #
            #------------------------------------------------------------------#
            LET l_sfs.sfs01 = l_sfp.sfp01                                  
            LET l_sfs.sfs02 = aws_ttsrv_getRecordField(l_node2, "sfs02")  #項次       #必傳入,不可修改
           #LET l_sfs.sfs03 = aws_ttsrv_getRecordField(l_node2, "sfs03")  #工單單號   #可不必傳入,不可修改
           #LET l_sfs.sfs04 = aws_ttsrv_getRecordField(l_node2, "sfs04")  #料號       #可不必傳入,不可修改
            LET l_sfs05 = aws_ttsrv_getRecordField(l_node2, "sfs05")      #發料數量   #必傳入,不可空白
            LET l_sfs06 = aws_ttsrv_getRecordField(l_node2, "sfs06")      #發料單位   #可不必傳入,若不傳入則維持原值
            LET l_sfs07 = aws_ttsrv_getRecordField(l_node2, "sfs07")      #倉庫       #必傳入,不可空白
            LET l_sfs08 = aws_ttsrv_getRecordField(l_node2, "sfs08")      #儲位       #必傳入,可空白
            LET l_sfs09 = aws_ttsrv_getRecordField(l_node2, "sfs09")      #批號       #必傳入,可空白
            LET l_sfs10 = aws_ttsrv_getRecordField(l_node2, "sfs10")      #作業編號   #可不必傳入,若不傳入則維持原值
            LET l_sfs21 = aws_ttsrv_getRecordField(l_node2, "sfs21")      #備註       #可不必傳入,若不傳入則維持原值
                                                                          
            SELECT * INTO l_sfs.* FROM sfs_file
             WHERE sfs01 = l_sfp.sfp01
               AND sfs02 = l_sfs.sfs02
 
            IF SQLCA.sqlcode THEN
               LET g_status.code=SQLCA.sqlcode
               EXIT FOR
            END IF
 
            LET l_sfs.sfs05 = l_sfs05
 
            IF NOT cl_null(l_sfs06) THEN
               LET l_sfs.sfs06 = l_sfs06
            END IF
 
            IF NOT cl_null(l_sfs07) THEN
               LET l_sfs.sfs07 = l_sfs07
            END IF
 
            IF NOT cl_null(l_sfs08) THEN
               LET l_sfs.sfs08 = l_sfs08
            END IF
 
            IF NOT cl_null(l_sfs09) THEN
               LET l_sfs.sfs09 = l_sfs09
            END IF
 
            IF NOT cl_null(l_sfs10) THEN
               LET l_sfs.sfs10 = l_sfs10
            END IF
 
            IF NOT cl_null(l_sfs21) THEN
               LET l_sfs.sfs21 = l_sfs21
            END IF
 
            #------------------------------------------------------------------#
            # RECORD資料傳到NODE2                                              #
            #------------------------------------------------------------------#
            CALL aws_ttsrv_setRecordField_record(l_node2,base.Typeinfo.create(l_sfs))
 
            IF cl_null(l_sfs.sfs07) THEN
               LET l_sfs.sfs07=" "
               CALL aws_ttsrv_setRecordField(l_node2, "sfs07", " ")
            END IF
            IF cl_null(l_sfs.sfs08) THEN 
               LET l_sfs.sfs08=" "
               CALL aws_ttsrv_setRecordField(l_node2, "sfs08", " ")
            END IF
            IF cl_null(l_sfs.sfs09) THEN 
               LET l_sfs.sfs09=" "
               CALL aws_ttsrv_setRecordField(l_node2, "sfs09", " ")
            END IF
            IF cl_null(l_sfs.sfs10) THEN 
               LET l_sfs.sfs10=" "
               CALL aws_ttsrv_setRecordField(l_node2, "sfs10", " ")
            END IF
 
            LET l_sql = aws_ttsrv_getRecordSql(l_node2, "sfs_file", "U", NULL) #U 表示取得 UPDATE SQL
 
            LET l_sql=l_sql," WHERE sfs01='",l_sfs.sfs01,"' AND sfs02=",l_sfs.sfs02  #kim test add
            
            #------------------------------------------------------------------#
            # 執行單身 INSERT SQL                                              #
            #------------------------------------------------------------------#
            EXECUTE IMMEDIATE l_sql
            IF SQLCA.SQLCODE THEN
               LET g_status.code = SQLCA.SQLCODE
               LET g_status.sqlcode = SQLCA.SQLCODE
               EXIT FOR
            END IF
        END FOR
        IF g_status.code != "0" THEN   #如果單身處理有任何錯誤, 則離開
           EXIT FOR
        END IF
    END FOR
    
    IF g_status.code = "0" THEN
       LET l_return.sfp01 = l_sfp.sfp01
      #CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))   #回傳 ERP 建立的工單領料單單號
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
    #CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))   #回傳自動取號結果
 
   IF (l_status='Y') AND (g_status.code = "0") THEN   
       LET gi_err_code = NULL
       LET l_flag=TRUE
       BEGIN WORK
       CALL i501sub_y_chk(l_sfp.sfp01,NULL)  #FUN-840012 #TQC-C60079
       IF g_success = "Y" THEN
          CALL i501sub_y_upd(l_sfp.sfp01,NULL,TRUE)  #FUN-840012
            RETURNING l_sfp.*
       ELSE
          LET l_flag=FALSE
       END IF
 
       CASE l_sfp.sfp06
          WHEN "1" LET g_prog='asfi511'
          WHEN "2" LET g_prog='asfi512'
          WHEN "3" LET g_prog='asfi513'
          WHEN "4" LET g_prog='asfi514'
          WHEN "6" LET g_prog='asfi526'
          WHEN "7" LET g_prog='asfi527'
          WHEN "8" LET g_prog='asfi528'
          WHEN "9" LET g_prog='asfi529'
          WHEN "D" LET g_prog='asfi519'                    #FUN-C70014
       END CASE
 
       IF g_success = "Y" THEN
          CALL i501sub_s('1',l_sfp.sfp01,TRUE,'N')  #FUN-840012
       END IF
 
       IF NOT cl_null(gi_err_code) THEN
          LET g_status.code=gi_err_code
          LET l_flag=FALSE
       END IF
       IF l_flag THEN
          COMMIT WORK
       ELSE
          ROLLBACK WORK
       END IF       
    END IF
    CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))   #回傳自動取號結果
END FUNCTION
 
