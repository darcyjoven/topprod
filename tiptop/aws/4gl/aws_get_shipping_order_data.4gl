# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_shipping_order_data.4gl
# Descriptions...: 提供取得 ERP 出貨單資料服務
# Date & Author..: No.FUN-840012 08/05/09 By Nicola
# Memo...........:
# Modify.........:
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
#No.FUN-840012
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
           
#[
# Description....: 提供取得 ERP 出貨單資料服務(入口 function)
# Date & Author..: No.FUN-840012 08/05/09 By Nicola
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_shipping_order_data()
 
   WHENEVER ERROR CONTINUE
 
   CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
   
   #--------------------------------------------------------------------------#
   # 查詢 ERP po 資料                                                         #
   #--------------------------------------------------------------------------#
   IF g_status.code = "0" THEN
      CALL aws_get_shipping_order_data_process()
   END IF
 
   CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
 
END FUNCTION
 
#[
# Description....: 查詢 ERP 出貨單資料
# Date & Author..: No.FUN-840012 08/05/09 By Nicola
# Parameter......:
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_shipping_order_data_process()
   DEFINE l_oga01   LIKE oga_file.oga01
   DEFINE l_oga     RECORD LIKE oga_file.*
   DEFINE l_ogb     DYNAMIC ARRAY OF RECORD LIKE ogb_file.*
   DEFINE l_sql     STRING
   DEFINE l_i       LIKE type_file.num10
   DEFINE l_node    om.DomNode
   DEFINE l_ohb12   LIKE ohb_file.ohb12
   DEFINE l_ohb12_n LIKE ohb_file.ohb12
 
   LET l_oga01 = aws_ttsrv_getParameter("oga01")   #取由呼叫端呼叫時給予的 SQL Condition
 
   LET l_sql = "SELECT * FROM oga_file WHERE oga01 = '",l_oga01,"'",
               "   AND oga09 = '2'"
 
   DECLARE oga_curs CURSOR FROM l_sql 
   IF SQLCA.SQLCODE THEN
      LET g_status.code = SQLCA.SQLCODE
      LET g_status.sqlcode = SQLCA.SQLCODE
      RETURN
   END IF
 
   LET l_sql = "SELECT ogb_file.* FROM oga_file,ogb_file ",
               " WHERE oga01 = ogb01 ",
               "   AND ogb01 = '",l_oga01,"'",
               "   AND (oga09 = '2' OR oga09 = '3' OR oga09 = '8' OR ", 
               "        oga09 = '4' OR oga09 = '6' OR oga09 = 'A') ",
               "   AND (ogb1005='1' OR ogb1005 IS NULL) ",
               " ORDER BY ogb01,ogb03 "
 
   DECLARE ogb_curs CURSOR FROM l_sql 
   IF SQLCA.SQLCODE THEN
      LET g_status.code = SQLCA.SQLCODE
      LET g_status.sqlcode = SQLCA.SQLCODE
      RETURN
   END IF
    
   OPEN oga_curs
   IF SQLCA.SQLCODE THEN
      LET g_status.code = SQLCA.SQLCODE
      LET g_status.sqlcode = SQLCA.SQLCODE
      RETURN
   END IF
 
   FETCH oga_curs INTO l_oga.*
   IF SQLCA.SQLCODE THEN
      LET g_status.code = SQLCA.SQLCODE
      LET g_status.sqlcode = SQLCA.SQLCODE
      RETURN
   END IF
 
   IF l_oga.ogaconf != 'Y' THEN      #未確認
      LET g_status.code ="axm-184"
      RETURN
   END IF
 
   IF l_oga.ogapost = 'N' THEN    #未扣帳
      LET g_status.code ="axm-299"
      RETURN
   END IF
 
   CALL l_ogb.clear()
   LET l_i = 1
   
   FOREACH ogb_curs INTO l_ogb[l_i].*
 
      #已確認的銷退
      SELECT SUM(ohb12) INTO l_ohb12
        FROM oha_file,ohb_file
       WHERE oha01=ohb01
         AND ohb31=l_oga.oga01
         AND ohb32=l_ogb[l_i].ogb03
         AND ohaconf='Y'
 
      #未確認的銷退
      SELECT SUM(ohb12) INTO l_ohb12_n
        FROM oha_file,ohb_file
       WHERE oha01=ohb01
         AND ohb31=l_oga01
         AND ohb32=l_ogb[l_i].ogb03
         AND ohaconf='N'
 
      LET l_ogb[l_i].ogb12 = l_ogb[l_i].ogb12 - l_ohb12 - l_ohb12_n
 
      IF l_ogb[l_i].ogb12 = 0 THEN
         CONTINUE FOREACH
      END IF
 
      LET l_i = l_i + 1
 
   END FOREACH
 
   CALL l_ogb.deleteElement(l_i)
 
   LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_oga), "oga_file")   #加入此筆單頭資料至 Response 中
   CALL aws_ttsrv_addDetailRecord(l_node, base.TypeInfo.create(l_ogb), "ogb_file")   #加入此筆單頭的單身資料至 Response 中
   
   IF SQLCA.SQLCODE THEN
      LET g_status.code = SQLCA.SQLCODE
      LET g_status.sqlcode = SQLCA.SQLCODE
      RETURN
   END IF  
 
END FUNCTION
