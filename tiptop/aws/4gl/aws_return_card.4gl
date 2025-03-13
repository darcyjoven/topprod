# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Program name...: aws_return_card.4gl
# Descriptions...: 查詢退卡信息 
# Date & Author..: No.FUN-CA0090 12/11/01 by xumm 
# Modify.........: No:FUN-CB0028 12/11/13 by shiwuying 逻辑调整
# Modify.........: No:FUN-D10095 13/01/28 By xumm XML格式调整
# Modify.........: No:FUN-D20096 13/02/28 By dongsz 增加卡種CardType 

DATABASE ds 

GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"  #TIPTOP Service Gateway 使用的全域變數檔


DEFINE g_return RECORD                    #回傳值必須宣告為一個 RECORD 變數
       Returnamt  LIKE lpj_file.lpj06,    #退卡金額
       Cardamt    LIKE lpj_file.lpj06,    #卡金额
       CardType   LIKE lpj_file.lpj02     #卡種       #FUN-D20096 add
                END RECORD 
                
#[
# Description....: 查詢退卡信息(入口 function)
# Date & Author..: 2012/11/01 by xumeimei 
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_return_card()

    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序

    #--------------------------------------------------------------------------#
    # POS查詢積分抵現信息                                                         #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_return_card_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION

#[
# Description....: 依據傳入資訊查詢髮卡退卡信息
# Date & Author..: 2012/11/01 by xumeimei 
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_return_card_process()
DEFINE l_sql     STRING 
DEFINE l_sql2    STRING
DEFINE l_shop    LIKE azw_file.azw01        #門店編號
DEFINE l_cardno  LIKE lpj_file.lpj03        #卡號
DEFINE l_passwd  LIKE lpj_file.lpj26        #密碼
DEFINE l_reamt   LIKE lpj_file.lpj06        #退卡金額
DEFINE l_camt    LIKE lpj_file.lpj06        #卡金额
DEFINE l_lsn02   LIKE lsn_file.lsn02
DEFINE l_lsn04   LIKE lsn_file.lsn04
DEFINE l_lsn09   LIKE lsn_file.lsn09
DEFINE l_lsn07   LIKE lsn_file.lsn07
DEFINE g_lpv     RECORD
                 lpv23   LIKE lpv_file.lpv23,
                 lpv24   LIKE lpv_file.lpv24,
                 lpv25   LIKE lpv_file.lpv25,
                 lpv26   LIKE lpv_file.lpv26,
                 lpv27   LIKE lpv_file.lpv27,
                 lpv28   LIKE lpv_file.lpv28,
                 lpv29   LIKE lpv_file.lpv29,
                 lpv30   LIKE lpv_file.lpv30,
                 lpv31   LIKE lpv_file.lpv31,
                 lpv32   LIKE lpv_file.lpv32,
                 lpv35   LIKE lpv_file.lpv35,
                 lpv231  LIKE lpv_file.lpv231,
                 lpv232  LIKE lpv_file.lpv232,
                 lpv241  LIKE lpv_file.lpv241,
                 lpv242  LIKE lpv_file.lpv242
                 END RECORD
DEFINE l_node    om.DomNode             #FUN-D10095 Add


   #取得各項參數
  #FUN-D10095 Mark&Add Begin ---
  #LET l_cardno = aws_ttsrv_getParameter("CardNO")
  #LET l_passwd = aws_ttsrv_getParameter("PassWord")
  #LET l_shop = aws_ttsrv_getParameter("Shop")   
   LET l_node = aws_ttsrv_getTreeMasterRecord(1,"ReturnCard")
   LET l_cardno = aws_ttsrv_getRecordField(l_node,"CardNO")
   LET l_passwd = aws_ttsrv_getRecordField(l_node,"PassWord")
   LET l_shop = aws_ttsrv_getRecordField(l_node,"Shop")
  #FUN-D10095 Mark&Add End -----


   #調用基本的檢查
   IF aws_pos_check() = 'N' THEN 
      RETURN 
   END IF 

   IF NOT aws_chk_card('ReturnCard',l_cardno,null,'','',l_shop) THEN
      RETURN
   END IF

   #按條件查詢退卡信息
   TRY 
     LET l_sql = "SELECT lpj06,lpj02",         #FUN-D20096 add lpj02
                 "  FROM ",cl_get_target_table(l_shop,"lpj_file"),
                 " WHERE lpj03 = '",l_cardno,"'" 
     PREPARE sel_lpj_pre FROM l_sql
     EXECUTE sel_lpj_pre INTO l_camt,g_return.CardType          #FUN-D20096 add g_return.CardType
     LET g_lpv.lpv35 = 0
     LET g_lpv.lpv232 = 0
     LET g_lpv.lpv231 = 0
     LET g_lpv.lpv23 = 0
     LET g_lpv.lpv241 = 0
     LET g_lpv.lpv242 = 0
     LET g_lpv.lpv24 = 0
     LET g_lpv.lpv25 = 0
     LET g_lpv.lpv26 = 0
     LET g_lpv.lpv27 = 0
     LET g_lpv.lpv28 = 0
     LET g_lpv.lpv29 = 0
     LET g_lpv.lpv30 = 0
     LET g_lpv.lpv31 = 0
     LET g_lpv.lpv32 = 0
     LET l_sql2 = "SELECT lsn02,lsn04,lsn09,lsn07 ",
                  "  FROM ",cl_get_target_table(l_shop,'lsn_file'),
                 #FUN-CB0028 Begin---
                  " WHERE lsn01 = '",l_cardno,"'"
                 #" WHERE (lsnplant = '",l_shop,"')",
                 #"   AND lsn01 = '",l_cardno,"'"
                 #FUN-CB0028 End-----
     PREPARE sel_lsn_pre FROM l_sql2
     DECLARE sel_lsn_curs CURSOR FOR sel_lsn_pre
     FOREACH sel_lsn_curs INTO l_lsn02,l_lsn04,l_lsn09,l_lsn07
        CASE l_lsn02
            WHEN '1'        #開帳
               LET g_lpv.lpv35 = g_lpv.lpv35 + (l_lsn04 * (l_lsn07 / 100 ))     #可退
            WHEN '2'        #發卡
               LET g_lpv.lpv232 = g_lpv.lpv232 + l_lsn09
               LET g_lpv.lpv231 = g_lpv.lpv231 + ((l_lsn04 - l_lsn09 ) * (1-(l_lsn07 / 100)))
               LET g_lpv.lpv23 = g_lpv.lpv23 + (l_lsn04 - g_lpv.lpv232 - g_lpv.lpv231)
            WHEN '3'        #儲值卡充值
               LET g_lpv.lpv242 = g_lpv.lpv242 + l_lsn09
               LET g_lpv.lpv241 = g_lpv.lpv241 + ((l_lsn04 - l_lsn09 ) * (1-(l_lsn07 / 100)))
               LET g_lpv.lpv24 = g_lpv.lpv24 + (l_lsn04 - l_lsn09 - (l_lsn04 - l_lsn09 ) * (1-(l_lsn07 / 100)))
            WHEN '5'        #換卡
               LET g_lpv.lpv35 = g_lpv.lpv35 + (l_lsn04 - l_lsn09)     #可退
            WHEN '6'        #訂單
               LET g_lpv.lpv25 = g_lpv.lpv25 + l_lsn04
            WHEN '7'        #ERP出貨單
               LET g_lpv.lpv26 = g_lpv.lpv26 + l_lsn04
            WHEN '8'        #ERP銷退單
               LET g_lpv.lpv27 = g_lpv.lpv27 + l_lsn04
            WHEN '9'        #預收退款
               LET g_lpv.lpv28 = g_lpv.lpv28 + l_lsn04
            WHEN 'A'        #押金收取
               LET g_lpv.lpv29 = g_lpv.lpv29 + l_lsn04
            WHEN 'B'        #押金返還
               LET g_lpv.lpv30 = g_lpv.lpv30 + l_lsn04
            WHEN 'C'        #費用收取
               LET g_lpv.lpv31 = g_lpv.lpv31 + l_lsn04
            WHEN 'D'        #費用支出
               LET g_lpv.lpv32 = g_lpv.lpv32 + l_lsn04
         END CASE
     END FOREACH
     LET l_reamt = g_lpv.lpv23 + g_lpv.lpv24 + g_lpv.lpv25 + g_lpv.lpv26 +
                   g_lpv.lpv27 + g_lpv.lpv28 + g_lpv.lpv29 + g_lpv.lpv30 + 
                   g_lpv.lpv31 + g_lpv.lpv32 + g_lpv.lpv35
     IF cl_null(l_camt) THEN
        LET l_camt = 0 
     END IF
     IF l_reamt < 0 THEN
        LET l_reamt = 0
     END IF
     LET g_return.Returnamt = l_reamt
     LET g_return.Cardamt = l_camt
   CATCH 
      IF sqlca.sqlcode THEN
         LET g_status.sqlcode = sqlca.sqlcode
      END IF 
      CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
   END TRY 
   #CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(g_return))                           #FUN-D10095 Mark
   CALL aws_ttsrv_addTreeMaster(base.TypeInfo.create(g_return), "ReturnCard") RETURNING l_node  #FUN-D10095 Add
END FUNCTION 
#FUN-CA0090
