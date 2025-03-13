# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: aws_recharge_card.4gl
# Descriptions...: 提供POS储值卡充值的服務
# Date & Author..: No.FUN-CA0090 12/10/22 by shiwuying
# Modify.........: No:FUN-CB0028 12/10/23 by shiwuying 逻辑调整
# Modify.........: No:FUN-D10095 13/01/28 By xumm XML格式调整
# Modify.........: No:FUN-D20096 13/02/28 By dongsz 增加卡種CardType

DATABASE ds 

GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"       #TIPTOP Service Gateway 使用的全域變數檔


DEFINE g_return RECORD                       #回傳值必須宣告為一個 RECORD 變數
       RechargeAMT   LIKE lpj_file.lpj06,    #实际充值金额
       CardAmount    LIKE lpj_file.lpj06,    #卡余额
       CardType      LIKE lpj_file.lpj02,    #卡種         #FUN-D20096 add
       MerberName    LIKE lpk_file.lpk04     #会员姓名
                END RECORD 
                
#[
# Description....: 提供POS储值卡充值的服務(入口 function)
# Date & Author..: 2012/10/22 by shiwuying
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_recharge_card()

    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序

    #--------------------------------------------------------------------------#
    # POS储值卡充值                                                            #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_recharge_card_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION

#[
# Description....: 依據傳入資訊储值卡充值信息
# Date & Author..: 2012/10/12 by baogc
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_recharge_card_process()
 DEFINE l_sql     STRING 
 DEFINE l_shop    LIKE azw_file.azw01    #門店編號
 DEFINE l_cardno  LIKE lpj_file.lpj03    #卡號
 DEFINE l_amt     LIKE lpj_file.lpj06    #需充值金额
 DEFINE l_amt1    LIKE lpj_file.lpj06    #实际充值金额
 DEFINE l_lpj06   LIKE lpj_file.lpj06    #卡余额
 DEFINE l_lpk04   LIKE lpk_file.lpk04    #会员姓名
 DEFINE l_dis_amt LIKE lpj_file.lpj06    #折扣金额
 DEFINE l_add_amt LIKE lpj_file.lpj06    #加值金额
 DEFINE l_node    om.DomNode             #FUN-D10095 Add

   #取得各項參數
  #FUN-D10095 Mark&Add Begin ---
  #LET l_shop   = aws_ttsrv_getParameter("Shop")
  #LET l_cardno = aws_ttsrv_getParameter("CardNO") 
  #LET l_amt    = aws_ttsrv_getParameter("AMT") 
   LET l_node = aws_ttsrv_getTreeMasterRecord(1,"RechargeCard")
   LET l_shop = aws_ttsrv_getRecordField(l_node,"Shop") 
   LET l_cardno = aws_ttsrv_getRecordField(l_node,"CardNO")
   LET l_amt = aws_ttsrv_getRecordField(l_node,"AMT")
  #FUN-D10095 Mark&Add End -----
   

   #調用基本的檢查
   IF aws_pos_check() = 'N' THEN 
      RETURN 
   END IF 

   IF NOT aws_chk_card('RechargeCard',l_cardno,null,'','',l_shop) THEN
      RETURN
   END IF
   #按條件查詢會員卡信息
   TRY 
      LET l_sql = " SELECT lpj06,lpj02,lpk04 ",        #FUN-D20096 add lpj02
                 #FUN-CB0028 Begin---
                 #"   FROM ",cl_get_target_table(l_shop,"lpj_file")," LEFT OUTER JOIN ",
                 #           cl_get_target_table(l_shop,"lnk_file")," ON (lpj02 = lnk01 AND lnk02 = '1' AND ",
                 #"                                                       lnk03 ='",l_shop,"' AND lnk05 = 'Y'),",
                 #           cl_get_target_table(l_shop,"lph_file"),",",
                 #           cl_get_target_table(l_shop,"lpk_file"),
                 #"  WHERE lpj01 = lpk01 AND lph01 = lpj02 ",
                 #"    AND lpj03 = '",l_cardno,"'"
                  "   FROM ",cl_get_target_table(l_shop,"lpj_file")," LEFT OUTER JOIN ",
                             cl_get_target_table(l_shop,"lnk_file")," ON (lpj02 = lnk01 AND lnk02 = '1' AND ",
                  "                                                       lnk03 ='",l_shop,"' AND lnk05 = 'Y') LEFT OUTER JOIN ",
                             cl_get_target_table(l_shop,"lpk_file")," ON (lpj01 = lpk01) ",
                  "  WHERE lpj03 = '",l_cardno,"'"
                 #FUN-CB0028 End-----
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      PREPARE sel_lpj06_pre FROM l_sql
      EXECUTE sel_lpj06_pre INTO l_lpj06,g_return.CardType,l_lpk04      #FUN-D20096 g_return.CardType
      CALL s_calculation_card_amt(l_cardno,l_amt,g_today,l_shop)
         RETURNING l_amt1,l_dis_amt,l_add_amt
      IF cl_null(l_amt1) THEN LET l_amt1 = l_amt END IF

      LET g_return.RechargeAMT = l_amt1
      LET g_return.CardAmount = l_lpj06
      LET g_return.MerberName = l_lpk04
   CATCH 
      IF sqlca.sqlcode THEN
         LET g_status.sqlcode = sqlca.sqlcode
      END IF 
      CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
   END TRY 
   #CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(g_return))                             #FUN-D10095 Mark
   CALL aws_ttsrv_addTreeMaster(base.TypeInfo.create(g_return), "RechargeCard") RETURNING l_node  #FUN-D10095 Add
END FUNCTION 

#FUN-CA0090
