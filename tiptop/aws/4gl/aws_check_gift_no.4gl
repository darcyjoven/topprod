# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: aws_check_gift_no.4gl
# Descriptions...: 提供POS讀取禮券信息的服務
# Date & Author..: 12/06/13 by suncx
# Modify.........: No.FUN-C50138 12/06/13 by suncx 新增程序
# Modify.........: No:FUN-D10040 13/01/18 By xumm 添加折扣券逻辑
# Modify.........: No.FUN-D10095 13/01/25 By xumm XML格式调整

DATABASE ds 

GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔


DEFINE g_return RECORD                   #回傳值必須宣告為一個 RECORD 變數
                CouponAmt   LIKE lrz_file.lrz02,    #礼券金额 
                GIFTCTF     LIKE lpx_file.lpx01,    #券种编号 
                GIFTCTFName LIKE lpx_file.lpx02,    #劵种名称 
                PAYCH       LIKE lpx_file.lpx05,    #是否可找零 
                MUSTCH      LIKE lpx_file.lpx29,    #最大找零金额 
                Spill       LIKE type_file.chr1,    #溢收 
                ISMCouponNO LIKE type_file.chr1,    #是否管理劵号 
                ISBilling   LIKE type_file.chr1,    #是否已开发票 
                CanReturn   LIKE type_file.chr1,    #是否可退货 
                AbsorbRate  LIKE type_file.num5,    #退货吸收比率 
                LBDate      LIKE type_file.chr8,    #有效期起 20120101
                LEDate      LIKE type_file.chr8,    #有效期讫 20120102
                CNFFLG      LIKE type_file.chr1     #有效否 Y/N
                #GUID        STRING 
            END RECORD 

#[
# Description....: 提供POS讀取禮券信息的服務(入口 function)
# Date & Author..: 2012/06/13 by suncx
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_check_gift_no()

    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序

    #--------------------------------------------------------------------------#
    # POS讀取禮券信息                                                           #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_check_gift_no_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION

#[
# Description....: 依據傳入資訊POS讀取禮券信息
# Date & Author..: 2012/06/13 by suncx
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_check_gift_no_process()
   DEFINE l_sql       STRING
   DEFINE l_guid      STRING 
   DEFINE l_shop      LIKE azw_file.azw01,   #門店編號
          l_coupon_no LIKE lqe_file.lqe01,   #券號
          l_type      STRING,
          l_lnk05     LIKE lnk_file.lnk05,
          l_lqe17     LIKE lqe_file.lqe17,
          l_lqe21     LIKE lqe_file.lqe21
   DEFINE l_node      om.DomNode             #FUN-D10095 Add

  #FUN-D10095 Mark&Add Begin ---
  #LET l_shop = aws_ttsrv_getParameter("Shop")
  #LET l_coupon_no =aws_ttsrv_getParameter("CouponNO")
  #LET l_type = aws_ttsrv_getParameter("Type")
   LET l_node = aws_ttsrv_getTreeMasterRecord(1,"CheckGiftNo")
   LET l_shop = aws_ttsrv_getRecordField(l_node,"Shop")
   LET l_coupon_no = aws_ttsrv_getRecordField(l_node,"CouponNO")
   LET l_type = aws_ttsrv_getRecordField(l_node,"Type")
  #FUN-D10095 Mark&Add End -----
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
      #LET l_sql = "SELECT lrz02,lqe02,lpx02,lpx05,lpx29,'Y','Y',lpx26,'Y',100,",    #FUN-D10040 mark
      LET l_sql = "SELECT CASE lpx26 WHEN '1' THEN lrz02 WHEN '2' THEN lpx37 END,lqe02,lpx02,lpx05,lpx29,'Y','Y',lpx38,'Y',100,", #FUN-D10040 add
                  "       ",cl_tp_tochar("lqe20","YYYYMMDD"),",",cl_tp_tochar("lqe21","YYYYMMDD"),",",
                  "       'Y',lnk05,lqe17,lqe21",
                  "  FROM ",cl_get_target_table(l_shop,"lqe_file"),
                  "  LEFT JOIN ",cl_get_target_table(l_shop,"lpx_file")," ON lpx01=lqe02",
                  "  LEFT JOIN ",cl_get_target_table(l_shop,"lrz_file")," ON lrz01=lqe03",
                  "  LEFT JOIN ",cl_get_target_table(l_shop,"lnk_file")," ON lnk01=lpx01",
                  "        AND lnk02 = '2' AND lnk03 ='",l_shop,"'",
                  " WHERE lqe01 = '",l_coupon_no,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      PREPARE sel_lqe_pre FROM l_sql
      EXECUTE sel_lqe_pre INTO g_return.*,l_lnk05,l_lqe17,l_lqe21
      IF SQLCA.sqlcode THEN 
         IF SQLCA.sqlcode = 100 THEN 
            CALL aws_pos_get_code('aws-916',l_coupon_no,NULL,NULL) #禮券不存在
         ELSE 
            LET g_status.sqlcode = sqlca.sqlcode
            CALL aws_pos_get_code('aws-901',NULL,NULL,NULL) #ERP系統錯誤
         END IF 
         RETURN 
      END IF 

      #判斷該券能否在此門店使用
      IF cl_null(l_lnk05) OR l_lnk05='N' THEN 
         CALL aws_pos_get_code('aws-917',l_coupon_no,NULL,NULL)         #券在本门店不能使用  
         RETURN 
      END IF 

      #券是否失效
      IF l_lqe21 < g_today THEN 
         LET g_return.CNFFLG = 'N'
         CALL aws_pos_get_code('aws-918',l_coupon_no,NULL,NULL)     #券已經失效
         RETURN 
      END IF 

      #檢查券的狀態
      CASE 
         WHEN l_type MATCHES '[03]'
            IF l_lqe17 <> '1' THEN 
               CALL aws_pos_get_code('aws-919',l_coupon_no,l_lqe17,'1')     #券狀態不符合
               RETURN 
            END IF
         WHEN l_type MATCHES '[124]'
            IF l_lqe17 NOT MATCHES '[54]'  THEN 
               CALL aws_pos_get_code('aws-919',l_coupon_no,l_lqe17,'1')     #券狀態不符合
               RETURN 
            END IF
      END CASE
      IF cl_null(g_return.MUSTCH) THEN LET g_return.MUSTCH=0 END IF 
   CATCH 
      IF sqlca.sqlcode THEN
         LET g_status.sqlcode = sqlca.sqlcode
      END IF 
      CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
      RETURN
   END TRY
   #CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(g_return))                            #FUN-D10095 Mark
   CALL aws_ttsrv_addTreeMaster(base.TypeInfo.create(g_return), "CheckGiftNo") RETURNING l_node  #FUN-D10095 Add
END FUNCTION  
#No.FUN-C50138
