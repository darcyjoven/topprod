# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: aws_get_cash_card_info.4gl
# Descriptions...: 提供POS讀取儲值卡、現金卡信息的服務
# Date & Author..: 12/06/11 by suncx
# Modify.........: No:FUN-C50138 12/06/11 by suncx 新增程序
# Modify.........: No:FUN-CA0090 12/10/23 by shiwuying 增加两个返回值
# Modify.........: No.FUN-D10095 13/01/25 By xumm XML格式调整

DATABASE ds 

GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

DEFINE g_return RECORD                   #回傳值必須宣告為一個 RECORD 變數
                cardAmount  LIKE lpj_file.lpj06, #卡余额
                CardNO      LIKE lpj_file.lpj03, #卡号
                CTNO        LIKE lpj_file.lpj02  #卡種
               ,ReturnSC    LIKE type_file.chr1, #储值卡能否退货     #FUN-CA0090
                ReturnRate  LIKE type_file.num5  #储值卡退货吸收比率 #FUN-CA0090
            END RECORD 
#[
# Description....: 提供POS讀取儲值卡、現金卡信息的服務(入口 function)
# Date & Author..: 2012/06/11 by suncx
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_get_cash_card_info()

    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序

    #--------------------------------------------------------------------------#
    # POS讀取儲值卡、現金卡信息                                                          #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_cash_card_info_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION

#[
# Description....: 依據傳入資訊讀取儲值卡、現金卡信息
# Date & Author..: 2012/06/11 by suncx
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_get_cash_card_info_process()
    DEFINE l_sql      STRING 
    DEFINE l_shop     STRING,       #門店編號
           l_password STRING  
    DEFINE l_guid     STRING 
    DEFINE l_lpj RECORD
                 lpj05   LIKE lpj_file.lpj05,     #有效期止
                 lpj06   LIKE lpj_file.lpj06,     #儲值卡餘額
                 lpj09   LIKE lpj_file.lpj09,     #卡狀態
                 lpj26   LIKE lpj_file.lpj26,     #卡密码   #FUN-D10095 Add
                 lph03   LIKE lph_file.lph03,     #可儲值否
                 lnk05   LIKE lnk_file.lnk05
                 END RECORD           
    DEFINE l_node        om.DomNode               #FUN-D10095 Add

    #取得各項參數
   #FUN-D10095 Mark&Add Begin ---
   #LET g_return.CardNO = aws_ttsrv_getParameter("CardNO") 
   #LET l_shop = aws_ttsrv_getParameter("Shop")
   #LET l_password = aws_ttsrv_getParameter("PassWord")
    LET l_node   = aws_ttsrv_getTreeMasterRecord(1,"GetCashCardInfo")
    LET g_return.CardNO = aws_ttsrv_getRecordField(l_node,"CardNO")
    LET l_shop = aws_ttsrv_getRecordField(l_node,"Shop")
    LET l_password = aws_ttsrv_getRecordField(l_node,"PassWord")
   #FUN-D10095 Mark&Add End ---
    #LET l_guid = aws_ttsrv_getParameter("GUID")
    LET l_guid = aws_pos_get_ConnectionMsg("guid")
    #LET g_return.GUID = l_guid
    IF cl_null(l_guid) THEN
       RETURN 
    ELSE 
       #CALL aws_ttsrv_addParameterGuid(l_guid)
    END IF 

    #調用基本的檢查
    IF aws_pos_check() = 'N' THEN 
       RETURN 
    END IF 

    TRY 
       LET l_sql = " SELECT lpj02,lpj05,lpj06,lpj09,lpj26,lph03,lnk05",    #FUN-D10095 add lpj26
                   "   FROM ",cl_get_target_table(l_shop,"lpj_file"),
                   "   LEFT JOIN ",cl_get_target_table(l_shop,"lph_file")," ON lph01=lpj02 ",
                   "   LEFT JOIN ",cl_get_target_table(l_shop,"lnk_file")," ON lnk01=lpj02 ",
                   "         AND lnk02 = '1' AND lnk03 ='",l_shop,"'",
                   "  WHERE lpj03 = '",g_return.CardNO,"'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       PREPARE sel_lpj_pre FROM l_sql
       EXECUTE sel_lpj_pre INTO g_return.CTNO,l_lpj.*
       
       IF sqlca.sqlcode THEN 
          IF sqlca.sqlcode = 100 THEN 
             CALL aws_pos_get_code('aws-911',g_return.CardNO,NULL,NULL) #儲值卡不存在         
          ELSE 
             LET g_status.sqlcode = sqlca.sqlcode
             CALL aws_pos_get_code('aws-901',NULL,NULL,NULL) #ERP系統錯誤
          END IF 
          RETURN
       END IF

       #判断儲值卡在本门店能否使用
       IF cl_null(l_lpj.lnk05) OR l_lpj.lnk05='N' THEN 
          CALL aws_pos_get_code('aws-912',g_return.CardNO,NULL,NULL)         #儲值卡在本门店不能使用             
          RETURN
       END IF

       #判断儲值卡是否失效
       IF (NOT cl_null(l_lpj.lpj05) AND l_lpj.lpj05 <= g_today) THEN 
          CALL aws_pos_get_code('aws-913',g_return.CardNO,NULL,NULL)         #儲值卡失效            
          RETURN
       END IF

       #检查儲值卡状态
       IF l_lpj.lpj09 <> '2' THEN 
          CALL aws_pos_get_code('aws-914',g_return.CardNO,l_lpj.lpj09,'2')  #儲值卡状态不符合          
          RETURN
       END IF   

       #检查儲值卡是否可儲值
       IF cl_null(l_lpj.lph03) OR l_lpj.lph03 = 'N' THEN 
          CALL aws_pos_get_code('aws-915',g_return.CardNO,NULL,NULL)         #儲值卡不可儲值            
          RETURN
       END IF

       #FUN-D10095--------add---------str
       #判断儲值卡密码是否正确
       IF NOT ((cl_null(l_lpj.lpj26) AND cl_null(l_password)) 
               OR (NOT cl_null(l_lpj.lpj26) AND NOT cl_null(l_password) AND l_password = l_lpj.lpj26)) THEN      
          CALL aws_pos_get_code('aws-922',g_return.CardNO,NULL,NULL)         #儲值卡密码错误
          RETURN
       END IF
       #FUN-D10095--------add---------end

       IF cl_null(l_lpj.lpj06) THEN LET l_lpj.lpj06 = 0 END IF 
       LET g_return.cardAmount = l_lpj.lpj06
       LET g_return.ReturnSC = 'Y'    #FUN-CA0090
       LET g_return.ReturnRate = 100  #FUN-CA0090
       #CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(g_return))                                #FUN-D10095 Mark
       CALL aws_ttsrv_addTreeMaster(base.TypeInfo.create(g_return), "GetCashCardInfo") RETURNING l_node  #FUN-D10095 Add
    CATCH 
       IF sqlca.sqlcode THEN
          LET g_status.sqlcode = sqlca.sqlcode
       END IF 
       CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
    END TRY 
END FUNCTION 
#FUN-D10095------ADD-----END
#No.FUN-C50138
