# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_rollback_voucher_data.4gl
# Descriptions...: 提供還原傳票資料的服務
# Date & Author..: 2010/03/25 by Mandy
# Memo...........:
# Modify.........: 新建立FUN-A30090
# Modify.........: No.FUN-AA0022 10/10/13 By Mandy HR GP5.2 追版
#
#}
# Modify.........: No.FUN-B40056 11/06/03 By guoch 刪除資料時一併刪除tic_file的資料

DATABASE ds

#FUN-9A0090

GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔


#[
# Description....: 提供還原傳票資料的服務(入口 function)
# Date & Author..: 2010/03/25 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_rollback_voucher_data()
 
    
    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 還原傳票資料                                                           #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_rollback_voucher_data_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION


#[
# Description....: 依據傳入資訊還原 ERP 傳票資料
# Date & Author..: 2010/03/25 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_rollback_voucher_data_process()
    DEFINE g_bookno   LIKE aaa_file.aaa01
    DEFINE l_aaa03    LIKE aaa_file.aaa03
    DEFINE l_i        LIKE type_file.num10
    DEFINE l_j        LIKE type_file.num10
    DEFINE l_sql      STRING        
    DEFINE l_cnt      LIKE type_file.num10
    DEFINE l_cnt1     LIKE type_file.num10
    DEFINE l_cnt2     LIKE type_file.num10
    DEFINE l_aba00    LIKE aba_file.aba00
    DEFINE l_aba01    LIKE aba_file.aba01
    DEFINE l_aba20    LIKE aba_file.aba20
    DEFINE l_aaz84    LIKE aaz_file.aaz84
    DEFINE l_node1    om.DomNode
    DEFINE l_node2    om.DomNode
    DEFINE l_flag     LIKE type_file.num10
    DEFINE l_return   RECORD                           #回傳值必須宣告為一個 RECORD 變數, 且此 RECORD 需包含所有要回傳的欄位名稱與定義
                         aba01   LIKE aba_file.aba01   #回傳的欄位名稱
                      END RECORD

        
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的傳票資料                                        #
    #--------------------------------------------------------------------------#
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("aba_file")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***
    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF
    
    BEGIN WORK
    
    FOR l_i = 1 TO l_cnt1       
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "aba_file")   #目前處理單檔的 XML 節點
        
        LET l_aba00 = aws_ttsrv_getRecordField(l_node1, "aba00")   #取得此筆單檔資料的欄位值 #帳別
        SELECT COUNT(*) INTO l_cnt 
          FROM aaa_file 
         WHERE aaa01 = l_aba00
        IF l_cnt = 0 THEN
           LET g_status.code = "agl-095"   #無此帳別
           EXIT FOR
        END IF
        LET g_bookno= l_aba00
        LET l_aba01 = aws_ttsrv_getRecordField(l_node1, "aba01")   #取得此筆單檔資料的欄位值 #傳票編號
        SELECT aba20 INTO l_aba20 
          FROM aba_file 
         WHERE aba00 = l_aba00
           AND aba01 = l_aba01
        IF NOT cl_null(l_aba20) AND l_aba20 MATCHES '[Ss1]' THEN
           LET g_status.code = "mfg3557"   #本單據目前已送簽或已核准
           EXIT FOR
        END IF
        SELECT aaz84 INTO l_aaz84
          FROM aaz_file
         WHERE aaz00 = '0' 
        CALL aws_rollback_voucher_undo(l_aaz84,l_aba00,l_aba01)
        IF NOT cl_null(g_errno) THEN
            LET g_status.code = g_errno
        END IF

        #全部處理都成功才 COMMIT WORK
        IF g_status.code = "0" THEN
           LET g_status.description = "Executed successfully!"
           LET l_return.aba01 = l_aba01
           CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))   #回傳 ERP 還原的傳票單號
           COMMIT WORK
        ELSE
           ROLLBACK WORK
        END IF
    END FOR
END FUNCTION



FUNCTION aws_rollback_voucher_undo(p_aaz84,p_aba00,p_aba01)
   DEFINE  p_aaz84      LIKE aaz_file.aaz84
   DEFINE  p_aba00      LIKE aba_file.aba00
   DEFINE  p_aba01      LIKE aba_file.aba01

   LET g_errno = ''
   IF p_aaz84 = '2' THEN   #還原方式為作廢 
       UPDATE aba_file  
          SET abaacti = 'N' 
        WHERE aba01 = p_aba01
          AND aba00 = p_aba00
       IF SQLCA.sqlcode THEN
           LET g_errno = 'aws-600' #傳票作廢失敗!
       END IF
   ELSE
       #=>刪傳票身
       DELETE FROM abb_file 
        WHERE abb01 = p_aba01
          AND abb00 = p_aba00
       IF SQLCA.sqlcode THEN
           LET g_errno = 'aws-601' #刪除傳票單身失敗!
       END IF
       #=>刪傳票頭
       DELETE FROM aba_file 
        WHERE aba01 = p_aba01
          AND aba00 = p_aba00
       IF SQLCA.sqlcode THEN
           LET g_errno = 'aws-602' #刪除傳票單頭失敗!
       END IF
       #=>刪傳票"額外摘要"
       DELETE FROM abc_file 
        WHERE abc01 = p_aba01
          AND abc00 = p_aba00
       IF SQLCA.sqlcode THEN
           LET g_errno = 'aws-603' #刪除傳票"額外摘要"失敗!
       END IF
 #FUN-B40056  --Begin
       DELETE FROM tic_file 
        WHERE tic04 = p_aba01
          AND tic00 = p_aba00
       IF SQLCA.sqlcode THEN
           LET g_errno = 'aws-601'
       END IF
 #FUN-B40056  --End

   END IF
END FUNCTION
#新建立FUN-A30090
#FUN-AA0022
