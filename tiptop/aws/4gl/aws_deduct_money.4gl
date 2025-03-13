# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Program name...: aws_deduct_money.4gl
# Descriptions...: 提供POS卡扣款请求的服務
# Date & Author..: 12/06/13 by suncx
# Modify.........: No.FUN-C50138 12/06/13 by suncx 新增程序
# Modify.........: No.FUN-D10053 13/01/11 By baogc 逻辑调整

DATABASE ds 

GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

DEFINE g_rxu    RECORD LIKE rxu_file.*
DEFINE g_return RECORD                   #回傳值必須宣告為一個 RECORD 變數
                success      STRING,              #扣款成功否 Y/N
                Balance      INTEGER,             #储值卡余额 扣款完之后的余额 
                DeductAmount LIKE lsn_file.lsn04, #扣款金额
                CardNO       LIKE lsn_file.lsn01, #储值卡卡号
                GUID         STRING               #传输GUID
            END RECORD 
#[
# Description....: 提供POS卡扣款请求的服務(入口 function)
# Date & Author..: 2012/06/13 by suncx
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_deduct_money()

    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序

    #--------------------------------------------------------------------------#
    # POS扣款请求                                                           #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_deduct_money_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION

#[
# Description....: 依據傳入資訊進行扣款操作
# Date & Author..: 2012/06/13 by suncx
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_deduct_money_process()
   DEFINE l_sql   STRING 
   DEFINE l_legal LIKE azw_file.azw02
   DEFINE l_type    LIKE lsn_file.lsn02,    #销售状态 0、销售单 1、原价退货 2、议价退货3、订单 4、退订单
          l_saleno  LIKE lsn_file.lsn03,    #单号信息
          l_dbate   STRING,                 #营业日期
          l_shop    LIKE lsn_file.lsnplant, #门店编号
          l_lsn07   LIKE lsn_file.lsn07,
          l_lsn09   LIKE lsn_file.lsn09
          
   DEFINE l_lpj RECORD
                lpj05   LIKE lpj_file.lpj05,     #有效期止
                lpj06   LIKE lpj_file.lpj06,     #儲值卡餘額
                lpj09   LIKE lpj_file.lpj09,     #卡狀態
                lph03   LIKE lph_file.lph03,     #可儲值否
                lnk05   LIKE lnk_file.lnk05
            END RECORD

   LET g_return.CardNO = aws_ttsrv_getParameter("CardNO")     
   LET g_return.DeductAmount = aws_ttsrv_getParameter("DeductAmount")     
   LET g_return.GUID = aws_pos_get_ConnectionMsg("guid")
   LET l_shop = aws_ttsrv_getParameter("Shop")
   LET l_type   = aws_ttsrv_getParameter("Type")
   LET l_saleno = aws_ttsrv_getParameter("SaleNO")
   LET l_dbate  = aws_ttsrv_getParameter("BDate")

   #調用基本的檢查
   CALL aws_pos_check() RETURNING g_return.success
   IF cl_null(g_return.success) THEN LET g_return.success = 'N' END IF 
   
   IF cl_null(g_return.GUID) THEN 
      LET g_return.success = 'N'
   END IF

   IF g_return.success = 'Y' THEN 
      TRY 
         LET l_sql = " SELECT lpj05,lpj06,lpj09,lph03,lnk05",
                     "   FROM ",cl_get_target_table(l_shop,"lpj_file"),
                     "   LEFT JOIN ",cl_get_target_table(l_shop,"lph_file")," ON lph01=lpj02 ",
                     "   LEFT JOIN ",cl_get_target_table(l_shop,"lnk_file")," ON lnk01=lpj02 ",
                     "         AND lnk02 = '1' AND lnk03 ='",l_shop,"'",
                     "  WHERE lpj03 = '",g_return.CardNO,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         PREPARE sel_lpj_pre FROM l_sql
         EXECUTE sel_lpj_pre INTO l_lpj.*
      CATCH 
         IF sqlca.sqlcode THEN
            LET g_status.sqlcode = sqlca.sqlcode
         END IF 
         LET g_return.success = "N"
         CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
      END TRY 
      IF sqlca.sqlcode AND g_return.success = "Y" THEN 
         LET g_return.success = "N"
         IF sqlca.sqlcode = 100 THEN 
            CALL aws_pos_get_code('aws-911',g_return.CardNO,NULL,NULL) #儲值卡不存在          
         ELSE 
            LET g_status.sqlcode = sqlca.sqlcode
            CALL aws_pos_get_code('aws-901',NULL,NULL,NULL) #ERP系統錯誤
         END IF 
      END IF

      #判断儲值卡在本门店能否使用
      IF g_return.success = "Y" AND (cl_null(l_lpj.lnk05) OR l_lpj.lnk05='N') THEN 
         CALL aws_pos_get_code('aws-912',g_return.CardNO,NULL,NULL)         #儲值卡在本门店不能使用 
         LET g_return.success = "N"         
      END IF

      #判断儲值卡是否失效
      IF g_return.success = "Y" AND (NOT cl_null(l_lpj.lpj05) AND l_lpj.lpj05 <= g_today) THEN 
         CALL aws_pos_get_code('aws-913',g_return.CardNO,NULL,NULL)         #儲值卡失效  
         LET g_return.success = "N"         
      END IF

      #检查儲值卡状态
      IF g_return.success = "Y" AND l_lpj.lpj09 <> '2' THEN 
         CALL aws_pos_get_code('aws-914',g_return.CardNO,l_lpj.lpj09,'2')  #儲值卡状态不符合 
         LET g_return.success = "N"         
      END IF   

      #检查儲值卡是否可儲值
      IF g_return.success = "Y" AND (cl_null(l_lpj.lph03) OR l_lpj.lph03 = 'N') THEN 
         CALL aws_pos_get_code('aws-915',g_return.CardNO,NULL,NULL)         #儲值卡不可儲值  
         LET g_return.success = "N"         
      END IF

      #檢查卡餘額是否足夠扣減
      IF cl_null(l_lpj.lpj06) THEN LET l_lpj.lpj06 = 0 END IF 
      IF g_return.success = "Y" AND l_type MATCHES '[03]' THEN 
         IF l_lpj.lpj06 - g_return.DeductAmount < 0 THEN 
            CALL aws_pos_get_code('aws-923',g_return.CardNO,NULL,NULL)         #卡余额不够扣减 
            LET g_return.success = "N" 
         END IF 
      END IF 
      #前面檢查沒有問題，則開始扣款
      IF g_return.success = "Y" THEN 
         TRY 
            BEGIN WORK
            #更新前鎖資料
            LET l_sql = "SELECT * FROM ",cl_get_target_table(l_shop,"lpj_file"),
                        " WHERE lpj03 = ? FOR UPDATE"
            LET l_sql = cl_forupd_sql(l_sql)
            DECLARE lpj_cl CURSOR FROM l_sql
            OPEN lpj_cl USING g_return.CardNO
            IF STATUS THEN
               LET g_status.sqlcode = STATUS
               CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤  
               LET g_return.success = "N"
            END IF
            #更新餘額
            IF g_return.success = 'Y' THEN 
               LET l_sql = " UPDATE ",cl_get_target_table(l_shop,"lpj_file")
               CASE  
                  WHEN l_type MATCHES '[03]'   #扣減餘額
                     LET l_sql = l_sql," SET lpj06 = lpj06 - ",g_return.DeductAmount
                  OTHERWISE     #增加餘額
                     LET l_sql = l_sql," SET lpj06 = lpj06 + ",g_return.DeductAmount
               END CASE 
               LET l_sql = l_sql,"  WHERE lpj03 = '",g_return.CardNO,"'"
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               PREPARE upd_amt_pre FROM l_sql
               EXECUTE upd_amt_pre
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN  
                  LET g_return.success = 'N'
                  LET g_status.sqlcode = sqlca.sqlcode
                  CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
               END IF 
            
               #寫積分異動檔
               LET l_lsn07 = 0
               LET l_lsn09 = 0
               SELECT azw02 INTO l_legal FROM azw_file WHERE azw01 = l_shop
               LET l_sql = "INSERT INTO ",cl_get_target_table(l_shop,"lsn_file"), 
                           "(lsn01,lsn02,lsn03,lsn04,lsn05,lsn07,lsn09,lsnlegal,lsnplant,lsnstore)", #FUN-D10053 Add ,lsnstore
                           "  VALUES(?,?,?,?,?, ?,?,?,?,?) "                                         #FUN-D10053 Add ,?
               PREPARE insert_lsm_prep FROM  l_sql
               EXECUTE insert_lsm_prep USING g_return.CardNO,l_type,l_saleno,g_return.DeductAmount,
                                             g_today,l_lsn07,l_lsn09,l_legal,l_shop,l_shop           #FUN-D10053 Add ,l_shop
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN 
                  LET g_return.success = 'N'
                  LET g_status.sqlcode = sqlca.sqlcode 
                  CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
               END IF 
               #重新獲取餘額
               LET l_sql = "SELECT lpj06 FROM ",cl_get_target_table(l_shop,"lpj_file"),
                           " WHERE lpj03 = '",g_return.CardNO,"'"
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               PREPARE sel_lpj06_pre FROM l_sql
               EXECUTE sel_lpj06_pre INTO g_return.Balance
               IF SQLCA.sqlcode THEN 
                  LET g_status.sqlcode = sqlca.sqlcode
                  CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
                  LET g_return.success = 'N' 
               END IF
               IF g_return.success = 'Y' THEN  
                  #寫rxu_file
                  LET g_rxu.rxu01 = g_return.GUID
                  LET g_rxu.rxu02 = ' '
                  LET g_rxu.rxu03 = l_shop
                  LET g_rxu.rxu04 = l_saleno
                  LET g_rxu.rxu05 = g_service
                  LET g_rxu.rxu06 = '4'
                  LET g_rxu.rxu07 = g_return.CardNO
                  LET g_rxu.rxu08 = l_lpj.lpj06
                  LET g_rxu.rxu09 = g_return.Balance
                  LET g_rxu.rxu10 = g_return.DeductAmount
                  LET g_rxu.rxu11 = g_today
                  LET g_rxu.rxu12 = g_time
                  LET g_rxu.rxu13 = aws_pos_get_ConnectionMsg("mach")
                  LET g_rxu.rxu14 = l_type
                  LET g_rxu.rxu15 = 0
                  LET g_rxu.rxuacti = 'Y'
                  CALL aws_pos_ins_rxu(g_rxu.*) RETURNING g_return.success
               END IF
            END IF 
            IF g_return.success = 'N' THEN 
               ROLLBACK WORK
            ELSE
               COMMIT WORK
            END IF 
            CLOSE lpj_cl
         CATCH 
            IF sqlca.sqlcode THEN
               LET g_status.sqlcode = sqlca.sqlcode
            END IF 
            LET g_return.success = "N"
            ROLLBACK WORK 
            CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
            CLOSE lpj_cl
         END TRY 
      END IF 
   END IF 
   CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(g_return))
END FUNCTION 
#No.FUN-C50138
