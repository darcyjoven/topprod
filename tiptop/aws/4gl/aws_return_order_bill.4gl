# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: aws_return_order_bill.4gl
# Descriptions...: 查詢訂單是否可退
# Date & Author..: No.FUN-CB0104 12/11/22 by xumm 
# Modify.........: No.FUN-D10095 13/01/25 By xumm XML格式调整

DATABASE ds 

GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"  #TIPTOP Service Gateway 使用的全域變數檔


DEFINE g_return   RECORD                #回傳值必須宣告為一個 RECORD 變數
       Isreturn   LIKE type_file.chr1   #是否可退
                  END RECORD 
                
#[
# Description....: 查詢訂單是否可退(入口 function)
# Date & Author..: 2012/11/22 by xumeimei 
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_return_order_bill()

    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序

    #--------------------------------------------------------------------------#
    # POS查詢積分抵現信息                                                         #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_return_order_bill_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION

#[
# Description....: 依據傳入資訊查詢訂單是否可退
# Date & Author..: 2012/11/22 by xumeimei 
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_return_order_bill_process()
DEFINE l_sql        STRING 
DEFINE l_shop       LIKE azw_file.azw01        #下訂單的門店編號
DEFINE l_btype      LIKE oea_file.oea00        #訂單類型 0->总部配送1->异店取货
DEFINE l_saleno     LIKE oea_file.oea94        #訂單編號
DEFINE l_isreturn   LIKE type_file.chr1        #是否可退
DEFINE l_shop1      LIKE azw_file.azw01
DEFINE l_ECSFLG     LIKE type_file.chr1
DEFINE l_posdbs     LIKE ryg_file.ryg00
DEFINE l_db_links   LIKE ryg_file.ryg02
DEFINE l_node       om.DomNode                 #FUN-D10095 Add

   #取得各項參數
  #FUN-D10095 Mark&Add Begin ---
  #LET l_shop = aws_ttsrv_getParameter("Shop")
  #LET l_btype = aws_ttsrv_getParameter("BillType")
  #LET l_saleno = aws_ttsrv_getParameter("SaleNo")
   LET l_node = aws_ttsrv_getTreeMasterRecord(1,"ReturnOrderBill")
   LET l_shop = aws_ttsrv_getRecordField(l_node,"Shop")
   LET l_btype = aws_ttsrv_getRecordField(l_node,"BillType")
   LET l_saleno = aws_ttsrv_getRecordField(l_node,"SaleNo")
  #FUN-D10095 Mark&Add End -----


   #調用基本的檢查
   IF aws_pos_check() = 'N' THEN 
      RETURN 
   END IF 
   #按條件查詢訂單是否可退
   TRY 
     LET l_isreturn = 'Y'
     SELECT DISTINCT ryg00,ryg02 INTO l_posdbs,l_db_links FROM ryg_file WHERE ryg00 = 'ds_pos1'
     LET l_posdbs = s_dbstring(l_posdbs)
     LET l_db_links = aws_get_orderbill_dblinks(l_db_links)
     LET l_sql = " SELECT SHOP,ECSFLG ",
                 "   FROM ",l_posdbs,"td_Sale",l_db_links,    #td_Sale交易单主表
                 "  WHERE SaleNO = '",l_saleno,"'",
                 "    AND SHOP = '",l_shop,"'",
                 "    AND TYPE = '3'"
     PREPARE sel_shop_cs FROM l_sql
     EXECUTE sel_shop_cs INTO l_shop1,l_ECSFLG
     IF SQLCA.sqlcode THEN
        LET g_status.sqlcode = sqlca.sqlcode
        LET g_status.code = sqlca.sqlcode
     END IF
     IF SQLCA.sqlcode = 100 THEN
        #訂單號不存在 
        CALL aws_pos_get_code('aws-924',l_saleno,NULL,NULL)
        LET l_isreturn = 'N'
     END IF
     IF l_shop1 <> l_shop THEN
        #下訂門店沒有此訂單號 
        CALL aws_pos_get_code('aws-925',l_saleno,NULL,NULL)
        LET l_isreturn = 'N'
     END IF 
     IF l_ECSFLG = 'Y' THEN
        #訂單已結案 
        CALL aws_pos_get_code('aws-926',l_saleno,NULL,NULL)
        LET l_isreturn = 'N'
     END IF 
     LET g_return.Isreturn = l_isreturn
   CATCH 
      IF sqlca.sqlcode THEN
         LET g_status.sqlcode = sqlca.sqlcode
      END IF 
      CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
   END TRY 
   #CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(g_return))                                #FUN-D10095 Mark
   CALL aws_ttsrv_addTreeMaster(base.TypeInfo.create(g_return), "ReturnOrderBill") RETURNING l_node  #FUN-D10095 Add
END FUNCTION 
FUNCTION aws_get_orderbill_dblinks(l_db_links)
DEFINE l_db_links LIKE ryg_file.ryg02

  IF l_db_links IS NULL OR l_db_links = ' ' THEN
     RETURN ' '
  ELSE
     LET l_db_links = '@',l_db_links CLIPPED
     RETURN l_db_links
  END IF
END FUNCTION
#FUN-CB0104
