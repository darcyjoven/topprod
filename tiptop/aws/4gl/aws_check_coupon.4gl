# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Program name...: aws_check_coupon.4gl
# Descriptions...: 查詢售券/退券信息 
# Date & Author..: No.FUN-CA0090 12/10/25 by xumm 
# Modify.........: No:FUN-CB0118 12/11/28 by shiwuying 券检查call aws_deduct_payment.4gl中的aws_chk_coupon()
# Modify.........: No:FUN-D10040 13/01/18 By xumm 添加折扣券逻辑S
# Modify.........: No:FUN-D10095 13/01/28 By xumm XML格式调整

DATABASE ds 

GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"  #TIPTOP Service Gateway 使用的全域變數檔


DEFINE g_return     RECORD                  #回傳值必須宣告為一個 RECORD 變數
       GIFTCTF      LIKE lpx_file.lpx01,    #券種
       CouponAMT    LIKE lrz_file.lrz02     #金額
                    END RECORD 
                
#[
# Description....: 儲值卡讀卡信息(入口 function)
# Date & Author..: 2012/10/25 by xumeimei 
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_check_coupon()

    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序

    #--------------------------------------------------------------------------#
    # POS查詢積分抵現信息                                                         #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_check_coupon_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION

#[
# Description....: 依據傳入資訊查詢售券/退券信息
# Date & Author..: 2012/10/25 by xumeimei 
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_check_coupon_process()
DEFINE l_sql            STRING 
DEFINE l_shop           LIKE azw_file.azw01        #門店編號
DEFINE l_bgift          LIKE lpz_file.lpz03        #開始券號
DEFINE l_egift          LIKE lpz_file.lpz04        #結束券號
DEFINE l_optype         LIKE type_file.chr1        #操作类型/0发券1退券
DEFINE l_lqe02          LIKE lqe_file.lqe02
DEFINE l_lpx21          LIKE lpx_file.lpx21
DEFINE l_lpx22          LIKE lpx_file.lpx22
DEFINE l_cnt            LIKE type_file.num5
DEFINE l_num            LIKE type_file.num5
DEFINE l_lqe            RECORD
              lqe01     LIKE lqe_file.lqe01,
              lqe02     LIKE lqe_file.lqe02,
              lnk03     LIKE lnk_file.lnk03,
              lpx15     LIKE lpx_file.lpx15,
              lqe21     LIKE lqe_file.lqe21,
              lqe17     LIKE lqe_file.lqe17,
              lrz02     LIKE lrz_file.lrz02
                        END RECORD
DEFINE l_node           om.DomNode             #FUN-D10095 Add



   #取得各項參數
  #FUN-D10095 Mark&Add Begin ---
  #LET l_shop = aws_ttsrv_getParameter("Shop")
  #LET l_bgift = aws_ttsrv_getParameter("BeginCoupon") 
  #LET l_egift = aws_ttsrv_getParameter("EndCoupon") 
  #LET l_optype = aws_ttsrv_getParameter("OPType")
   LET l_node = aws_ttsrv_getTreeMasterRecord(1,"CheckCoupon")
   LET l_shop = aws_ttsrv_getRecordField(l_node,"Shop")
   LET l_bgift = aws_ttsrv_getRecordField(l_node,"BeginCoupon")
   LET l_egift = aws_ttsrv_getRecordField(l_node,"EndCoupon")
   LET l_optype = aws_ttsrv_getRecordField(l_node,"OPType")
  #FUN-D10095 Mark&Add End -----


   #調用基本的檢查
   IF aws_pos_check() = 'N' THEN 
      RETURN 
   END IF 

   #按條件查詢售券/退券信息
   TRY
     #FUN-CB0118 Begin---
      IF NOT aws_chk_coupon(l_bgift,l_egift,l_optype,l_shop) THEN
         LET g_success = 'N'
         RETURN
      END IF
     
     #FUN-D10040 Mark&Add STR----- 
     #LET l_sql = "SELECT lqe02,lrz02",
     #            "  FROM ",cl_get_target_table(l_shop,"lqe_file"),"  LEFT OUTER JOIN ",
     #                      cl_get_target_table(l_shop,"lrz_file")," ON (lqe03 = lrz01) ",
     #            " WHERE lqe01 = '",l_bgift,"' "
      LET l_sql = "SELECT lqe02,CASE lpx26 WHEN '1' THEN lrz02 WHEN '2' THEN lpx37 END ",
                  "  FROM ",cl_get_target_table(l_shop,"lqe_file"),
                  "  LEFT JOIN ",cl_get_target_table(l_shop,"lpx_file")," ON lpx01=lqe02",
                  "  LEFT JOIN ",cl_get_target_table(l_shop,"lrz_file")," ON lrz01=lqe03",
                  "  LEFT JOIN ",cl_get_target_table(l_shop,"lnk_file")," ON lnk01=lpx01",
                  "        AND lnk02 = '2' AND lnk03 ='",l_shop,"'",
                  " WHERE lqe01 = '",l_bgift,"' "
      #FUN-D10040 Mark&Add END-----
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      PREPARE sel_lqe_per FROM l_sql
      EXECUTE sel_lqe_per INTO l_lqe.lqe02,l_lqe.lrz02
      LET g_return.GIFTCTF = l_lqe.lqe02
      LET g_return.CouponAMT = l_lqe.lrz02
     #LET l_sql = "SELECT lpx21,lpx22 FROM ",cl_get_target_table(l_shop,"lpx_file"),",",
     #                                       cl_get_target_table(l_shop,"lqe_file"),
     #            " WHERE lqe02 = lpx01",
     #            "   AND lqe01 = '",l_bgift,"'"
     #PREPARE sel_lpx_per FROM l_sql
     #EXECUTE sel_lpx_per INTO l_lpx21,l_lpx22
     ##Error_16:礼券msg不存在!
     #IF SQLCA.sqlcode = 100 THEN
     #   CALL aws_pos_get_code('aws-916',l_bgift,NULL,NULL)
     #   RETURN
     #END IF
     #LET l_num = l_egift[l_lpx22+1,l_lpx21] - l_bgift[l_lpx22+1,l_lpx21] + 1

     #LET l_sql = "SELECT lqe01,lqe02,lnk03,lpx15,lqe21,lqe17,lrz02",
     #            "  FROM ",cl_get_target_table(l_shop,"lpx_file"),",",
     #                      cl_get_target_table(l_shop,"lqe_file"),"  LEFT OUTER JOIN ",
     #                      cl_get_target_table(l_shop,"lnk_file")," ON (lqe02 = lnk01 AND lnk02 = '2' AND ",
     #            "                                                     lnk03 ='",l_shop,"' AND lnk05 = 'Y') LEFT OUTER JOIN ",
     #                      cl_get_target_table(l_shop,"lrz_file")," ON (lqe03 = lrz01) ",
     #            " WHERE lqe02 = lpx01",
     #            "   AND lqe01 BETWEEN '",l_bgift,"' AND '",l_egift,"'"
     #CALL cl_replace_sqldb(l_sql) RETURNING l_sql
     #PREPARE sel_lqe_per FROM l_sql
     #DECLARE sel_lqe_cs CURSOR FOR sel_lqe_per
     #LET l_cnt = 0
     #FOREACH sel_lqe_cs INTO l_lqe.*
     #   LET g_return.GIFTCTF = null
     #   LET g_return.CouponAMT = null
     #   #Error_17:礼券msg在本门店不能使用!
     #   IF cl_null(l_lqe.lnk03) THEN
     #      CALL aws_pos_get_code('aws-917',l_lqe.lqe01,NULL,NULL)
     #      RETURN
     #   END IF
     #   #Error_18:礼券msg已失效!
     #   IF (NOT cl_null(l_lqe.lqe21) AND l_lqe.lqe21 < g_today) OR l_lqe.lpx15 = 'N' THEN
     #      CALL aws_pos_get_code('aws-918',l_lqe.lqe01,NULL,NULL)
     #      RETURN
     #   END IF 
     #   #Error_19:礼券msg状态为：
     #   IF l_optype = '0' THEN     #发券
     #      IF l_lqe.lqe17 <> '5' AND l_lqe.lqe17 <> '2' THEN
     #         CALL aws_pos_get_code('aws-919',l_lqe.lqe01,l_lqe.lqe17,'1')
     #         RETURN
     #      END IF
     #   END IF
     #   IF l_optype = '1' THEN     #退券
     #      IF l_lqe.lqe17 <> '1' THEN
     #         CALL aws_pos_get_code('aws-919',l_lqe.lqe01,l_lqe.lqe17,'1')
     #         RETURN
     #      END IF
     #   END IF
     #   #Error_30:礼券msg与其他劵种不一致！
     #   IF l_lqe02 <> l_lqe.lqe02 THEN
     #      CALL aws_pos_get_code('aws-930',l_lqe.lqe01,NULL,NULL)
     #      RETURN
     #   END IF
     #   LET l_lqe02 = l_lqe.lqe02
     #   IF cl_null(l_lqe.lrz02) THEN
     #      LET l_lqe.lrz02 = 0
     #   END IF
     #   LET g_return.GIFTCTF = l_lqe.lqe02
     #   LET g_return.CouponAMT = l_lqe.lrz02
     #   LET l_cnt = l_cnt + 1
     #END FOREACH
     ##Error_16:礼券msg不存在!
     #IF l_cnt = 0 OR l_cnt <> l_num THEN
     #   CALL aws_pos_get_code('aws-916',l_lqe.lqe01,NULL,NULL)
     #   RETURN
     #END IF
     #FUN-CB0118 End-----
   CATCH 
      IF sqlca.sqlcode THEN
         LET g_status.sqlcode = sqlca.sqlcode
      END IF 
      CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
   END TRY 
   #CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(g_return))                            #FUN-D10095 Mark
   CALL aws_ttsrv_addTreeMaster(base.TypeInfo.create(g_return), "CheckCoupon") RETURNING l_node  #FUN-D10095 Add
END FUNCTION 

#FUN-CA0090
