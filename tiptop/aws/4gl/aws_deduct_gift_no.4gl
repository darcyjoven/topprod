# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: aws_deduct_gift_no.4gl
# Descriptions...: 提供POS禮券核銷的服務
# Date & Author..: 12/06/13 by suncx
# Modify.........: No.FUN-C50138 12/06/13 by suncx 新增程序
# Modify.........: No.FUN-D10040 13/01/18 By xumm 更新券资料是更新已用门店和已用日期

DATABASE ds 

GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

DEFINE g_rxu    RECORD LIKE rxu_file.*
DEFINE g_return RECORD                   #回傳值必須宣告為一個 RECORD 變數
                success      STRING,              #禮券核銷成功否 Y/N
                GUID         STRING               #传输GUID
            END RECORD 
#[
# Description....: 提供POS禮券核銷的服務(入口 function)
# Date & Author..: 2012/06/13 by suncx
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_deduct_gift_no()

    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序

    #--------------------------------------------------------------------------#
    # POS禮券核銷                                                          #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_deduct_gift_no_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION

#[
# Description....: 依據傳入資訊進行禮券核銷操作
# Date & Author..: 2012/06/13 by suncx
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_deduct_gift_no_process()
   DEFINE l_sql      STRING 
   DEFINE l_shop      LIKE lsn_file.lsnplant, #门店编号
          l_type      LIKE lsn_file.lsn02,    #销售状态 0、销售单 1、原价退货 2、议价退货3、订单 4、退订单
          l_coupon_no LIKE lqe_file.lqe01,    #券號
          l_saleno    LIKE lsn_file.lsn03,    #单号信息
          l_dbate     STRING                  #营业日期
   DEFINE l_lnk05     LIKE lnk_file.lnk05,
          l_lqe17     LIKE lqe_file.lqe17,
          l_lqe21     LIKE lqe_file.lqe21,
          l_state     LIKE lqe_file.lqe17
   
   LET l_shop = aws_ttsrv_getParameter("Shop")
   LET l_type   = aws_ttsrv_getParameter("Type")
   LET l_coupon_no = aws_ttsrv_getParameter("CouponNO")
   LET l_saleno = aws_ttsrv_getParameter("SaleNO")
   LET l_dbate  = aws_ttsrv_getParameter("BDate")   
   LET g_return.GUID = aws_pos_get_ConnectionMsg("guid")   
   
   #調用基本的檢查
   CALL aws_pos_check() RETURNING g_return.success
   IF cl_null(g_return.success) THEN LET g_return.success = 'N' END IF 
   
   IF cl_null(g_return.GUID) THEN 
      LET g_return.success = 'N'
   END IF

   IF g_return.success = 'Y' THEN 
      LET l_sql = "SELECT lqe17,lqe21,lnk05",
                  "  FROM ",cl_get_target_table(l_shop,"lqe_file"),
                  "  LEFT JOIN ",cl_get_target_table(l_shop,"lpx_file")," ON lpx01=lqe02",
                  "  LEFT JOIN ",cl_get_target_table(l_shop,"lnk_file")," ON lnk01=lpx01",
                  "        AND lnk02 = '2' AND lnk03 ='",l_shop,"'",
                  " WHERE lqe01 = '",l_coupon_no,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      TRY 
         PREPARE sel_lqe_pre FROM l_sql
         EXECUTE sel_lqe_pre INTO l_lqe17,l_lqe21,l_lnk05
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
            CALL aws_pos_get_code('aws-916',l_coupon_no,NULL,NULL) #禮券不存在         
         ELSE 
            LET g_status.sqlcode = sqlca.sqlcode
            CALL aws_pos_get_code('aws-901',NULL,NULL,NULL) #ERP系統錯誤
         END IF 
      END IF
      #判斷該券能否在此門店使用
      IF g_return.success = "Y" AND (cl_null(l_lnk05) OR l_lnk05='N') THEN 
         CALL aws_pos_get_code('aws-917',l_coupon_no,NULL,NULL)         #券在本门店不能使用  
         LET g_return.success = "N"
      END IF 

      #券是否失效
      IF g_return.success = "Y" AND l_lqe21 < g_today THEN 
         CALL aws_pos_get_code('aws-918',l_coupon_no,NULL,NULL)     #券已經失效
         LET g_return.success = "N"
      END IF 

      #檢查券的狀態
      CASE
         WHEN l_type MATCHES '[03]'
            IF g_return.success = "Y" AND l_lqe17 MATCHES '[1]' THEN 
               CALL aws_pos_get_code('aws-919',l_coupon_no,l_lqe17,'1')     #券狀態不符合
               LET g_return.success = "N"
            END IF
         OTHERWISE
            IF g_return.success = "Y" AND l_lqe17 MATCHES '[45]' THEN 
               CALL aws_pos_get_code('aws-919',l_coupon_no,l_lqe17,'1')     #券狀態不符合
               LET g_return.success = "N"
            END IF
      END CASE
      IF g_return.success = 'Y' THEN
         TRY
            BEGIN WORK 
            #更新前鎖資料
            LET l_sql = "SELECT * FROM ",cl_get_target_table(l_shop,"lqe_file"),
                        " WHERE lqe01 = ? FOR UPDATE"
            LET l_sql = cl_forupd_sql(l_sql)
            DECLARE lqe_cl CURSOR FROM l_sql
            OPEN lqe_cl USING l_coupon_no
            IF STATUS THEN
               LET g_status.sqlcode = STATUS
               CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤  
               LET g_return.success = "N"
            END IF
            IF g_return.success = 'Y' THEN
               LET l_sql = " UPDATE ",cl_get_target_table(l_shop,"lqe_file")
               CASE 
                   WHEN l_type MATCHES '[03]'
                       LET l_state = '4'
                       #LET l_sql = l_sql,"  SET lqe17 = '4' ",            #FUN-D10040 mark
                       LET l_sql = l_sql,"  SET lqe17 = '4' ",",",         #FUN-D10040 add
                                         "      lqe24 = '",l_shop,"'",",", #FUN-D10040 add
                                         "      lqe25 = '",g_today,"'",    #FUN-D10040 add
                                         "WHERE lqe17 = '1' "
                   OTHERWISE
                       LET l_state = '1'
                       #LET l_sql = l_sql,"  SET lqe17 = '1' ",            #FUN-D10040 mark
                       LET l_sql = l_sql,"  SET lqe17 = '1' ",",",         #FUN-D10040 add
                                         "      lqe24 = ''",",",           #FUN-D10040 add
                                         "      lqe25 = ''",               #FUN-D10040 add
                                         "WHERE lqe17 IN('4','5') "
               END CASE
               LET l_sql = l_sql," AND lqe01 = '",l_coupon_no,"'"  
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               PREPARE upd_amt_pre FROM l_sql
               EXECUTE upd_amt_pre
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN  
                  LET g_return.success = 'N'
                  LET g_status.sqlcode = sqlca.sqlcode
                  CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
               END IF
            
               #寫rxu_file
               IF g_return.success = 'Y' THEN
                  LET g_rxu.rxu01 = g_return.GUID
                  LET g_rxu.rxu02 = ' '
                  LET g_rxu.rxu03 = l_shop
                  LET g_rxu.rxu04 = l_saleno
                  LET g_rxu.rxu05 = g_service
                  LET g_rxu.rxu06 = '5'
                  LET g_rxu.rxu07 = l_coupon_no
                  LET g_rxu.rxu08 = l_lqe17
                  LET g_rxu.rxu09 = l_state
                  LET g_rxu.rxu10 = NULL 
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
            CLOSE lqe_cl
         CATCH 
            IF sqlca.sqlcode THEN
               LET g_status.sqlcode = sqlca.sqlcode
            END IF 
            LET g_return.success = "N"
            ROLLBACK WORK 
            CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
            CLOSE lqe_cl
         END TRY
      END IF 
   END IF 
   CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(g_return))
END FUNCTION 
#No.FUN-C50138
