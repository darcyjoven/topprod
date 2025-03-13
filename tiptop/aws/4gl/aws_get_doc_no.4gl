# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#{
# Program name...: aws_get_doc_no.4gl
# Descriptions...: 提供 ERP 單據自動取號服務
# Date & Author..: 2008/03/03 by Brendan
# Memo...........:
# Modify.........: 新建立  #FUN-840004
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980094 09/09/15 By TSD.hoho GP5.2 跨資料庫語法修改
 
DATABASE ds
 
#FUN-840004 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
           
 
#[
# Description....: 提供 ERP 單據自動取號服務服務(入口 function)
# Date & Author..: 2008/03/03 by Brendan  #FUN-720021
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_doc_no()
 
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 單據自動取號                                                        #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_doc_no_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 自動取號
# Date & Author..: 2008/03/03 by Brendan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_doc_no_process()
    DEFINE l_sys       LIKE smu_file.smu03,
           l_slip      STRING,
           l_date      LIKE type_file.dat,
           l_type      STRING,
           l_tab       STRING,
           l_fld       STRING,
           l_dbs       STRING,
           l_runcard   LIKE type_file.chr1,
           l_smy       STRING
    DEFINE l_result    LIKE type_file.num5
    DEFINE l_return    RECORD             #回傳值必須宣告為一個 RECORD 變數, 且此 RECORD 需包含所有要回傳的欄位名稱與定義
                          slip   STRING   #回傳的欄位名稱
                       END RECORD
 
    
    
    #取得各項參數
    LET l_sys = aws_ttsrv_getParameter("sys")
    LET l_slip = aws_ttsrv_getParameter("slip")
    LET l_date = aws_ttsrv_getParameter("date")
    LET l_type = aws_ttsrv_getParameter("type")
    LET l_tab = aws_ttsrv_getParameter("tab")
    LET l_fld = aws_ttsrv_getParameter("fld")
    LET l_dbs = aws_ttsrv_getParameter("dbs")
    LET l_runcard = aws_ttsrv_getParameter("runcard")
    LET l_smy = aws_ttsrv_getParameter("smy")
    
    BEGIN WORK
 
    #單據編號檢查
   #CALL s_check_no(l_sys, l_slip, l_slip, l_type, l_tab, l_fld, l_dbs)  #FUN-980094 mark
    CALL s_check_no(l_sys, l_slip, l_slip, l_type, l_tab, l_fld, g_plant)  #FUN-980094
         RETURNING l_result, l_return.slip
   
    IF l_result THEN
       #依照系統別、單別自動編號
      #CALL s_auto_assign_no(l_sys, l_slip, l_date, l_type, l_tab, l_fld, l_dbs, l_runcard, l_smy) #FUN-980094 mark
       CALL s_auto_assign_no(l_sys, l_slip, l_date, l_type, l_tab, l_fld, g_plant, l_runcard, l_smy) #FUN-980094
            RETURNING l_result, l_return.slip 
        
       IF l_result THEN
            COMMIT WORK
       ELSE
            ROLLBACK WORK
            LET g_status.code = "sub-146"
       END IF
    ELSE
       ROLLBACK WORK
       LET g_status.code = "sub-141"
    END IF
    
    IF g_status.code = "0" THEN
       CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))   #回傳自動取號結果
    END IF
END FUNCTION
