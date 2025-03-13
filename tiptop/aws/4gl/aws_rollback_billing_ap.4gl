# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_rollback_billing_ap.4gl
# Descriptions...: 提供還原應付請款資料的服務
# Date & Author..: 2012/08/22 by Abby
# Memo...........:
# Modify.........: 新建立FUN-C80078
# Modify.........: FUN-D20035 13/02/22 By minpp FUNCTION t110_c()增加传入参数
#}

DATABASE ds

#FUN-C80078

GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
GLOBALS "../../aap/4gl/saapt110.global"

#[
# Description....: 提供還原應付請款資料的服務(入口 function)
# Date & Author..: 2012/08/22 by Abby
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_rollback_billing_ap()
 
    
    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 還原傳票資料                                                           #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_rollback_billing_ap_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION


#[
# Description....: 依據傳入資訊還原 ERP 應付請款資料
# Date & Author..: 2012/08/22 by Abby
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_rollback_billing_ap_process()
    DEFINE l_i        LIKE type_file.num10
    DEFINE l_sql      STRING        
    DEFINE l_cnt      LIKE type_file.num10
    DEFINE l_node     om.DomNode
    DEFINE l_return   RECORD                           #回傳值必須宣告為一個 RECORD 變數, 且此 RECORD 需包含所有要回傳的欄位名稱與定義
                         apa01   STRING                #回傳的欄位名稱(若還原多筆時,則回傳的value值為多筆,故宣告為STRING)
                      END RECORD

        
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的帳款資料                                          #
    #--------------------------------------------------------------------------#
    LET l_cnt  = aws_ttsrv_getMasterRecordLength("apa_file")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***
    IF l_cnt  = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF
     
    BEGIN WORK

    LET l_return.apa01 = NULL
    LET g_aptype = '12'
    
    FOR l_i = 1 TO l_cnt        
        LET l_node = aws_ttsrv_getMasterRecord(l_i, "apa_file")       #目前處理單檔的 XML 節點
        LET g_apa.apa01 = aws_ttsrv_getRecordField(l_node, "apa01")   #取得此筆單檔資料的欄位值 #帳款編號

        IF cl_null(g_apa.apa01) THEN
           #帳款編號不可為空!
           LET g_status.code = "aws-453"
        END IF

        SELECT apa63 INTO g_apa.apa63 
          FROM apa_file 
         WHERE apa01 = g_apa.apa01
        IF NOT cl_null(g_apa.apa63) AND g_apa.apa63 MATCHES '[Ss1]' THEN
           LET g_status.code = "mfg3557"   #本單據目前已送簽或已核准
           EXIT FOR
        END IF

       #CALL t110_c()                 #FUN-D20035
        CALL t110_c(1)                 #FUN-D20035

        IF g_success = 'N' THEN
           IF NOT cl_null(g_errno) THEN
              LET g_status.code = g_errno
           ELSE
              LET g_status.code = 'aws-455' #應付請款資料拋轉還原失敗!
           END IF
        END IF

        IF l_i = l_cnt THEN
            LET l_return.apa01 = l_return.apa01 CLIPPED,g_apa.apa01 CLIPPED
        ELSE
            LET l_return.apa01 = l_return.apa01 CLIPPED,g_apa.apa01 CLIPPED,","
        END IF
    END FOR

   #全部處理都成功才 COMMIT WORK
    IF g_status.code = "0" THEN
       LET g_status.description = "Executed successfully!"
       CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))   #回傳 ERP 還原的帳款編號
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF

END FUNCTION
