# Prog. Version..: '5.30.06-13.03.18(00003)'     #
#
# Program name...: aws_check_card.4gl
# Descriptions...: 查詢髮卡信息 
# Date & Author..: No.FUN-CA0090 12/10/23 by xumm 
# Modify.........: No.FUN-D10095 13/01/28 By xumm XML格式调整
# Modify.........: No.FUN-D30017 13/03/14 By baogc 储值金额大于0时判断是否可储值

DATABASE ds 

GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"  #TIPTOP Service Gateway 使用的全域變數檔


DEFINE g_return RECORD                  #回傳值必須宣告為一個 RECORD 變數
       CardAMT  LIKE lpt_file.lpt10,    #金額
       RealAMT  LIKE lpt_file.lpt13     #实际充值金额
                END RECORD 
                
#[
# Description....: 查詢髮卡退卡信息(入口 function)
# Date & Author..: 2012/10/23 by xumeimei 
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_check_card()

    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序

    #--------------------------------------------------------------------------#
    # POS查詢積分抵現信息                                                         #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_check_card_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION

#[
# Description....: 依據傳入資訊查詢髮卡信息
# Date & Author..: 2012/10/23 by xumeimei 
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_check_card_process()
DEFINE l_sql     STRING 
DEFINE l_shop    LIKE azw_file.azw01        #門店編號
DEFINE l_bcard   LIKE lpt_file.lpt02        #開始卡號
DEFINE l_ecard   LIKE lpt_file.lpt021       #結束卡號
DEFINE l_ctno    LIKE lpj_file.lpj02        #卡種
DEFINE l_ramt    LIKE lpt_file.lpt13        #充值金额
DEFINE l_lph23   LIKE lph_file.lph23        #購卡金額
DEFINE l_amt1    LIKE lpj_file.lpj06        #实际充值金额
DEFINE l_dis_amt LIKE lpj_file.lpj06        #折扣金额
DEFINE l_add_amt LIKE lpj_file.lpj06        #加值金额
DEFINE l_node    om.DomNode                 #FUN-D10095 Add
DEFINE l_lph03   LIKE lph_file.lph03        #FUN-D30017 Add

   #取得各項參數
  #FUN-D10095 Mark&Add Begin ---
  #LET l_bcard = aws_ttsrv_getParameter("BeginCard")
  #LET l_ecard = aws_ttsrv_getParameter("EndCard")
  #LET l_ramt = aws_ttsrv_getParameter("RechargeAMT")
  #LET l_shop = aws_ttsrv_getParameter("Shop")   
  #LET l_ctno = aws_ttsrv_getParameter("CTNO")
   LET l_node = aws_ttsrv_getTreeMasterRecord(1,"CheckCard")
   LET l_bcard = aws_ttsrv_getRecordField(l_node,"BeginCard")
   LET l_ecard = aws_ttsrv_getRecordField(l_node,"EndCard")
   LET l_ramt = aws_ttsrv_getRecordField(l_node,"RechargeAMT")
   LET l_shop = aws_ttsrv_getRecordField(l_node,"Shop")
   LET l_ctno = aws_ttsrv_getRecordField(l_node,"CTNO")
  #FUN-D10095 Mark&Add End -----

   #調用基本的檢查
   IF aws_pos_check() = 'N' THEN 
      RETURN 
   END IF 

   IF NOT aws_chk_card('CheckCard',l_bcard,l_ecard,l_ctno,'',l_shop) THEN
      RETURN
   END IF

  #FUN-D30017 Add Begin ---
  #若储值金额不为空且大于0,则检查该卡是否可储值
   IF NOT cl_null(l_ramt) AND l_ramt > 0 THEN
      INITIALIZE l_lph03 TO NULL
      LET l_sql = "SELECT lph03 FROM ",cl_get_target_table(l_shop,'lph_file'),
                  " WHERE lph01 = '",l_ctno CLIPPED,"' "
      PREPARE sel_lph03_pre FROM l_sql
      EXECUTE sel_lph03_pre INTO l_lph03
      IF l_lph03 = 'N' THEN
         CALL aws_pos_get_code('aws-915',l_bcard,NULL,NULL)
         LET g_success = 'N'
         RETURN 
      END IF
   END IF
  #FUN-D30017 Add End -----

   #按條件查詢髮卡退卡信息
   TRY 
     LET l_sql = "SELECT lph23",
                 "  FROM ",cl_get_target_table(l_shop,"lpj_file"),",",
                           cl_get_target_table(l_shop,"lph_file"),
                 " WHERE lpj02 = lph01", 
                 "   AND lpj03 = '",l_bcard,"'",
                 "   AND lpj02 = '",l_ctno,"'"
     PREPARE sel_lpj_pre FROM l_sql
     EXECUTE sel_lpj_pre INTO l_lph23
     CALL s_calculation_card_amt(l_bcard,l_ramt,g_today,l_shop)
          RETURNING l_amt1,l_dis_amt,l_add_amt
     IF cl_null(l_amt1) THEN LET l_amt1 = l_ramt END IF

     LET g_return.CardAMT = l_lph23
     LET g_return.RealAMT = l_amt1
   CATCH 
      IF sqlca.sqlcode THEN
         LET g_status.sqlcode = sqlca.sqlcode
      END IF 
      CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
   END TRY 
   #CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(g_return))                          #FUN-D10095 Mark
   CALL aws_ttsrv_addTreeMaster(base.TypeInfo.create(g_return), "CheckCard") RETURNING l_node  #FUN-D10095 Add
END FUNCTION 

#FUN-CA0090
