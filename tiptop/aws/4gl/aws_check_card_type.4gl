# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: aws_check_card_type.4gl
# Descriptions...: 查詢髮卡卡种信息 
# Date & Author..: No.FUN-CA0090 12/10/30 by xumm 
# Modify.........: No.FUN-D10095 13/01/25 By xumm XML格式调整

DATABASE ds 

GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"  #TIPTOP Service Gateway 使用的全域變數檔


DEFINE g_return RECORD                  #回傳值必須宣告為一個 RECORD 變數
       CTNO     LIKE lpj_file.lpj02     #卡種
                END RECORD 
                
#[
# Description....: 查詢髮卡卡种信息(入口 function)
# Date & Author..: 2012/10/30 by xumeimei 
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_check_card_type()

    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序

    #--------------------------------------------------------------------------#
    # POS查詢積分抵現信息                                                         #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_check_card_type_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION

#[
# Description....: 依據傳入資訊查詢髮卡、退卡卡种信息
# Date & Author..: 2012/10/30 by xumeimei 
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_check_card_type_process()
DEFINE l_sql     STRING 
DEFINE l_shop    LIKE azw_file.azw01        #門店編號
DEFINE l_bcard   LIKE lpt_file.lpt02        #開始卡號
DEFINE l_ecard   LIKE lpt_file.lpt021       #結束卡號
DEFINE l_lpj02   LIKE lpj_file.lpj02        #卡種
DEFINE l_node    om.DomNode                 #FUN-D10095 Add

   #取得各項參數
  #FUN-D10095 Mark&Add Begin ---
  #LET l_bcard = aws_ttsrv_getParameter("BeginCard")
  #LET l_ecard = aws_ttsrv_getParameter("EndCard")
  #LET l_shop = aws_ttsrv_getParameter("Shop")   
   LET l_node = aws_ttsrv_getTreeMasterRecord(1,"CheckCardType")
   LET l_bcard = aws_ttsrv_getRecordField(l_node,"BeginCard")
   LET l_ecard = aws_ttsrv_getRecordField(l_node,"EndCard")
   LET l_shop = aws_ttsrv_getRecordField(l_node,"Shop")
  #FUN-D10095 Mark&Add End -----


   #調用基本的檢查
   IF aws_pos_check() = 'N' THEN 
      RETURN 
   END IF 

   IF NOT aws_chk_card('CheckCardType',l_bcard,l_ecard,'','',l_shop) THEN
      RETURN
   END IF
   #按條件查詢髮卡退卡信息
   TRY
     LET l_sql = "SELECT lpj02",
                 "  FROM ",cl_get_target_table(l_shop,"lpj_file"),
                 " WHERE lpj03 = '",l_bcard,"'" 
     PREPARE sel_lpj_pre FROM l_sql
     EXECUTE sel_lpj_pre INTO l_lpj02
     LET g_return.CTNO = l_lpj02
   CATCH 
     #IF SQLCA.sqlcode = 100 THEN
     #   #Error_5:会员卡msg不存在!
     #   CALL aws_pos_get_code('aws-905',p_bcard,NULL,NULL)
     #END IF
         IF sqlca.sqlcode THEN
            LET g_status.sqlcode = sqlca.sqlcode
         END IF 
         CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
   END TRY 
   #CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(g_return))                              #FUN-D10095 Mark
   CALL aws_ttsrv_addTreeMaster(base.TypeInfo.create(g_return), "CheckCardType") RETURNING l_node  #FUN-D10095 Add
END FUNCTION 

#FUN-CA0090
