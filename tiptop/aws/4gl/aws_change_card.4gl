# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Program name...: aws_change_card.4gl
# Descriptions...: 會員換卡查詢信息 
# Date & Author..: No.FUN-CA0090 12/10/25 by xumm 
# Modify.........: No.FUN-D10095 13/01/28 By xumm XML格式调整
# Modify.........: No.FUN-D20096 13/02/28 By dongsz 增加卡種CardType

DATABASE ds 

GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"  #TIPTOP Service Gateway 使用的全域變數檔


DEFINE g_return     RECORD                  #回傳值必須宣告為一個 RECORD 變數
       CardCost     LIKE lph_file.lph45,    #換卡費用
       ISMPassWord  LIKE lpk_file.lpk04,    #新卡密碼管理
       CardType     LIKE lpj_file.lpj02     #卡種    #FUN-D20096 add
                    END RECORD 
                
#[
# Description....: 儲值卡讀卡信息(入口 function)
# Date & Author..: 2012/10/25 by xumeimei 
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_change_card()

    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序

    #--------------------------------------------------------------------------#
    # POS查詢積分抵現信息                                                         #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_change_card_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION

#[
# Description....: 依據傳入資訊查詢會員換卡信息
# Date & Author..: 2012/10/25 by xumeimei 
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_change_card_process()
DEFINE l_sql     STRING 
DEFINE l_shop    LIKE azw_file.azw01    #門店編號
DEFINE l_ocard   LIKE lpj_file.lpj03    #原卡號
DEFINE l_ncard   LIKE lpj_file.lpj03    #新卡號
DEFINE l_pword   LIKE lpj_file.lpj03    #密碼
DEFINE l_ccost   LIKE lph_file.lph45    #換卡費用
DEFINE l_ipword  LIKE lpj_file.lpj03    #新卡密碼管理
DEFINE l_node    om.DomNode             #FUN-D10095 Add


   #取得各項參數
  #FUN-D10095 Mark&Add Begin ---
  #LET l_shop = aws_ttsrv_getParameter("Shop")
  #LET l_ocard = aws_ttsrv_getParameter("OldCard") 
  #LET l_ncard = aws_ttsrv_getParameter("NewCard") 
  #LET l_pword = aws_ttsrv_getParameter("PassWord") 
   LET l_node = aws_ttsrv_getTreeMasterRecord(1,"ChangeCard")
   LET l_shop = aws_ttsrv_getRecordField(l_node,"Shop")
   LET l_ocard = aws_ttsrv_getRecordField(l_node,"OldCard")
   LET l_ncard = aws_ttsrv_getRecordField(l_node,"NewCard")
   LET l_pword = aws_ttsrv_getRecordField(l_node,"PassWord")
  #FUN-D10095 Mark&Add End -----


   #調用基本的檢查
   IF aws_pos_check() = 'N' THEN 
      RETURN 
   END IF 

   IF NOT aws_chk_card('ChangeCard',l_ocard,l_ocard,'','1',l_shop) THEN
      RETURN
   END IF
   IF NOT aws_chk_card('ChangeCard',l_ncard,l_ncard,'','2',l_shop) THEN
      RETURN
   END IF
   #按條件查詢會員換卡信息
   TRY 
      LET l_sql = " SELECT lph45,lph46,lpj02,lpj26 ",       #FUN-D20096 add lpj02
                  "   FROM ",cl_get_target_table(l_shop,"lpj_file"),",",
                             cl_get_target_table(l_shop,"lph_file"),
                  "  WHERE lph01 = lpj02 ",
                  "    AND lpj03 = '",l_ncard,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      PREPARE sel_lph_pre FROM l_sql
      EXECUTE sel_lph_pre INTO l_ccost,l_ipword,g_return.CardType     #FUN-D20096 add g_return.CardType
   
      IF cl_null(l_ipword) THEN
         LET l_ipword = 'N'
      END IF 
      LET g_return.CardCost = l_ccost
      LET g_return.ISMPassWord = l_ipword
   CATCH 
      IF sqlca.sqlcode THEN
         LET g_status.sqlcode = sqlca.sqlcode
      END IF 
      CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
   END TRY 
   #CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(g_return))                            #FUN-D10095 Mark
   CALL aws_ttsrv_addTreeMaster(base.TypeInfo.create(g_return), "ChangeCard") RETURNING l_node  #FUN-D10095 Add
END FUNCTION 
#FUN-CA0090
