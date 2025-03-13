# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Program name...: aws_deduct_score.4gl
# Descriptions...: 提供POS積分抵現扣減的服務
# Date & Author..: 12/06/14 by suncx
# Modify.........: No.FUN-C50138 12/06/14 by suncx 新增程序
# Modify.........: No.FUN-D10053 13/01/11 By baogc 逻辑调整

DATABASE ds 

GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

DEFINE g_rxu    RECORD LIKE rxu_file.*
DEFINE g_return RECORD                   #回傳值必須宣告為一個 RECORD 變數
                success STRING,              #操作成功否 
                DCash   LIKE lpj_file.lpj06, #扣減金额
                DScore  LIKE lpj_file.lpj12, #扣減积分
                GUID    STRING               #传输GUID
            END RECORD 
#[
# Description....: 提供POS積分抵現扣減的服務(入口 function)
# Date & Author..: 2012/06/14 by suncx
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_deduct_score()

    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序

    #--------------------------------------------------------------------------#
    # POS積分抵現扣減                                                           #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_deduct_score_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION

#[
# Description....: 依據傳入資訊積分抵現扣減
# Date & Author..: 2012/06/14 by suncx
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_deduct_score_process()
   DEFINE l_sql       STRING 
   DEFINE l_shop      LIKE azw_file.azw01,    #門店編號
          l_type      LIKE lsn_file.lsn02,    #销售状态 0、销售单 1、原价退货 2、议价退货3、订单 4、退订单
          l_cardno    LIKE lpj_file.lpj03,    #卡號
          l_saleno    LIKE lsn_file.lsn03,    #单号信息
          l_dbate     STRING                  #营业日期
   DEFINE l_lpj RECORD
                lpj05   LIKE lpj_file.lpj05,
                lpj09   LIKE lpj_file.lpj09,
                lpj12   LIKE lpj_file.lpj12,
                lpkacti LIKE lpk_file.lpkacti,
                lph37   LIKE lph_file.lph37,
                lph38   LIKE lph_file.lph38,
                lph39   LIKE lph_file.lph39,
                lnk05   LIKE lnk_file.lnk05
            END RECORD
   DEFINE l_legal   LIKE azw_file.azw02,
          l_date    LIKE type_file.dat,
          l_num     LIKE type_file.num10,
          l_lpj12_n LIKE lpj_file.lpj12

   #取得各項參數
   LET l_shop = aws_ttsrv_getParameter("Shop")
   LET l_type   = aws_ttsrv_getParameter("Type")
   LET l_cardno = aws_ttsrv_getParameter("CardNO") 
   LET g_return.DCash = aws_ttsrv_getParameter("DCash")
   LET g_return.DScore = aws_ttsrv_getParameter("DScore")
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
      #按條件查詢會員卡信息
      LET l_sql = " SELECT lpj05,lpj09,lpj12,lpkacti,lph37,lph38,lph39,lnk05 ",
                  "   FROM ",cl_get_target_table(l_shop,"lpj_file"),
                  "   LEFT JOIN ",cl_get_target_table(l_shop,"lpk_file")," ON lpk01=lpj01 ",
                  "   LEFT JOIN ",cl_get_target_table(l_shop,"lph_file")," ON lph01=lpj02 ",
                  "   LEFT JOIN ",cl_get_target_table(l_shop,"lnk_file")," ON lnk01=lpj02 ",
                  "         AND lnk02 = '1' AND lnk03 ='",l_shop,"'",
                  "  WHERE lpj03 = '",l_cardno,"'"
      TRY 
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
      IF g_return.success = "Y" AND sqlca.sqlcode THEN 
         LET g_return.success = "N"
         IF sqlca.sqlcode = 100 THEN 
            CALL aws_pos_get_code('aws-905',l_cardno,NULL,NULL) #卡不存在         
         ELSE 
            LET g_status.sqlcode = sqlca.sqlcode
            CALL aws_pos_get_code('aws-901',NULL,NULL,NULL) #ERP系統錯誤
         END IF 
      END IF
      #判断会员卡在本门店能否使用
      IF g_return.success = "Y" AND (cl_null(l_lpj.lnk05) OR l_lpj.lnk05='N') THEN 
         LET g_return.success = "N"
         CALL aws_pos_get_code('aws-906',l_cardno,NULL,NULL)         #会员卡在本门店不能使用              
      END IF
       
       #判断会员卡是否失效
       IF g_return.success = "Y" AND ((NOT cl_null(l_lpj.lpj05) AND l_lpj.lpj05 <= g_today) OR cl_null(l_lpj.lpkacti) OR   
          l_lpj.lpkacti = 'N') THEN 
          LET g_return.success = "N"
          CALL aws_pos_get_code('aws-907',l_cardno,NULL,NULL)         #会员卡失效          
       END IF 
       #检查会员卡状态
       IF g_return.success = "Y" AND l_lpj.lpj09 <> '2' THEN 
          LET g_return.success = "N"
          CALL aws_pos_get_code('aws-908',l_cardno,l_lpj.lpj09,'2')  #会员卡状态不符合         
       END IF 
       #检查会员卡是否可积分抵現
       IF g_return.success = "Y" AND (cl_null(l_lpj.lph37) OR l_lpj.lph37 = 'N') THEN 
          LET g_return.success = "N"
          CALL aws_pos_get_code('aws-920',l_cardno,NULL,NULL)         #会员卡不积分抵現        
       END IF

       IF g_return.success = "Y" THEN 
          IF cl_null(l_lpj.lph38) THEN LET l_lpj.lph38 = 0 END IF 
          IF cl_null(l_lpj.lph39) THEN LET l_lpj.lph39 = 1 END IF 
          #開始積分抵現扣減操作
          TRY 
             BEGIN WORK 
             #更新前鎖資料
             LET l_sql = "SELECT * FROM ",cl_get_target_table(l_shop,"lpj_file"),
                         " WHERE lpj03 = ? FOR UPDATE"
             LET l_sql = cl_forupd_sql(l_sql)
             DECLARE lpj_cl CURSOR FROM l_sql
             OPEN lpj_cl USING l_cardno
             IF STATUS THEN
                LET g_status.sqlcode = STATUS 
                CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤  
                LET g_return.success = "N"
             END IF
             IF g_return.success = 'Y' THEN 
                #更新積分
                LET l_sql = " UPDATE ",cl_get_target_table(l_shop,"lpj_file")
                CASE  
                   WHEN l_type MATCHES '[03]'   #扣減積分
                       LET g_return.DScore = (g_return.DCash/l_lpj.lph39)*l_lpj.lph38
                       LET l_sql = l_sql," SET lpj12 = lpj12 - ",g_return.DScore
                   OTHERWISE   
                       IF g_return.DScore <= 0 OR cl_null(g_return.DScore) THEN
                           LET g_return.DScore = (g_return.DCash/l_lpj.lph39)*l_lpj.lph38
                       END IF 
                       LET l_sql = l_sql," SET lpj12 = lpj12 + ",g_return.DScore
                END CASE 
                LET l_sql = l_sql,"  WHERE lpj03 = '",l_cardno,"'"
                CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                PREPARE upd_point_pre FROM l_sql
                EXECUTE upd_point_pre
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN  
                   LET g_status.sqlcode = sqlca.sqlcode
                   CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
                   LET g_return.success = 'N'
                END IF 

                #寫積分異動檔
                LET l_date = NULL
                LET l_num =0 
                SELECT azw02 INTO l_legal FROM azw_file WHERE azw01 = l_shop
                LET l_sql = "INSERT INTO ",cl_get_target_table(l_shop,"lsm_file"), 
                            "        (lsm01,lsm02,lsm03,lsm04,lsm05, lsm06,lsm07,lsm08,lsmlegal,lsmplant,", #FUN-D10053 Add
                            "         lsm09,lsm10,lsm11,lsm12,lsm13, lsm14,lsm15,lsmstore)",                #FUN-D10053 Add
                            "  VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?) "                             #FUN-D10053 Add ,?,?
                PREPARE insert_lsm_prep FROM  l_sql
                EXECUTE insert_lsm_prep USING l_cardno,l_type,l_saleno,g_return.DScore,g_today,l_date,l_shop,
                                              g_return.DCash,l_legal,l_shop,l_num,l_num,l_num,l_num,l_num,l_date,'2',l_shop #FUN-D10053 Add ,'2',l_shop
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN 
                   LET g_status.sqlcode = sqlca.sqlcode
                   CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
                   LET g_return.success = 'N' 
                END IF 
              
                #重新獲取積分
                LET l_sql = "SELECT lpj12 FROM ",cl_get_target_table(l_shop,"lpj_file"),
                            " WHERE lpj03 = '",l_cardno,"'"
                CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                PREPARE sel_lpj12_pre FROM l_sql
                EXECUTE sel_lpj12_pre INTO l_lpj12_n
                IF SQLCA.sqlcode THEN 
                   LET g_status.sqlcode = sqlca.sqlcode
                   CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
                   LET g_return.success = 'N' 
                END IF 
                #寫rxu_file
                IF g_return.success = 'Y' THEN 
                   LET g_rxu.rxu01 = g_return.GUID
                   LET g_rxu.rxu02 = ' '
                   LET g_rxu.rxu03 = l_shop
                   LET g_rxu.rxu04 = l_saleno
                   LET g_rxu.rxu05 = g_service
                   LET g_rxu.rxu06 = '3'
                   LET g_rxu.rxu07 = l_cardno
                   LET g_rxu.rxu08 = l_lpj.lpj12
                   LET g_rxu.rxu09 = l_lpj12_n
                   LET g_rxu.rxu10 = g_return.DScore
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
