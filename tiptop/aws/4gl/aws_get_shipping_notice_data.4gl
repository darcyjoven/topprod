# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_shipping_notice_data.4gl
# Descriptions...: 提供取得 ERP 出貨通知單資料服務
# Date & Author..: No.FUN-840012 08/05/09 By Nicola
# Memo...........:
# Modify.........: No.FUN-930101 09/04/01 By sabrina oga09要多抓取〝5.三角貿易通知單〞
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
#No.FUN-840012
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
           
#[
# Description....: 提供取得 ERP 出貨通知單資料服務(入口 function)
# Date & Author..: No.FUN-840012 08/05/09 By Nicola
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_shipping_notice_data()
 
   WHENEVER ERROR CONTINUE
 
   CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
   
   #--------------------------------------------------------------------------#
   # 查詢 ERP po 資料                                                         #
   #--------------------------------------------------------------------------#
   IF g_status.code = "0" THEN
      CALL aws_get_shipping_notice_data_process()
   END IF
 
   CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
 
END FUNCTION
 
#[
# Description....: 查詢 ERP 出貨通知單資料
# Date & Author..: No.FUN-840012 08/05/09 By Nicola
# Parameter......:
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_shipping_notice_data_process()
   DEFINE l_oga01  LIKE oga_file.oga01
   DEFINE l_oga    RECORD LIKE oga_file.*
   DEFINE l_ogb    DYNAMIC ARRAY OF RECORD LIKE ogb_file.*
   DEFINE l_sql    STRING
   DEFINE l_wc     STRING
   DEFINE l_i      LIKE type_file.num10
   DEFINE l_node   om.DomNode
   DEFINE l_ogb12a LIKE ogb_file.ogb12
   DEFINE l_ogb12b LIKE ogb_file.ogb12
 
   LET l_wc = aws_ttsrv_getParameter("condition")   #取由呼叫端呼叫時給予的 SQL Condition
 
   LET l_oga01 = aws_ttsrv_getParameter("oga01")   #取由呼叫端呼叫時給予的 SQL Condition
 
   IF cl_null(l_wc) THEN LET l_wc=" 1=1" END IF
 
   LET l_sql = "SELECT * FROM oga_file WHERE oga01 = '",l_oga01,"'",
               "   AND oga09 IN ('1','5')"       #FUN-930101 add    #一般出貨單和多角貿易出貨單都要抓取
              #"   AND oga09 = '1'"              #FUN-930101 mark
 
   DECLARE oga_curs CURSOR FROM l_sql 
   IF SQLCA.SQLCODE THEN
      LET g_status.code = SQLCA.SQLCODE
      LET g_status.sqlcode = SQLCA.SQLCODE
      RETURN
   END IF
 
   LET l_sql = "SELECT * FROM ogb_file ",
               " WHERE ogb01 = '",l_oga01,"'",
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
 
   CALL l_ogb.clear()
   LET l_i = 1
 
   FOREACH ogb_curs INTO l_ogb[l_i].*
 
      #檢查出貨數必須<=通知單應出數-累計出貨數
      #對應到的出貨通知單上的數量
      LET l_ogb12a = 0
 
      SELECT SUM(ogb12) INTO l_ogb12a
        FROM ogb_file,oga_file
       WHERE ogb01 = oga01
         AND oga09 IN ('1','5') 
         AND oga01 = l_oga01
         AND ogb03 = l_ogb[l_i].ogb03 
         AND ogb31 = l_ogb[l_i].ogb31
         AND ogb32 = l_ogb[l_i].ogb32
         AND ogb04 = l_ogb[l_i].ogb04
         AND ogaconf != 'X'
     
      IF cl_null(l_ogb12a) THEN 
         LET l_ogb12a = 0 
      END IF
 
      # 此出貨通知單已耗用在出貨單的量
      LET l_ogb12b = 0
 
      SELECT SUM(ogb12) INTO l_ogb12b
        FROM ogb_file,oga_file
       WHERE ogb01 = oga01
         AND oga09 IN ('2','4','6') 
         AND oga011 = l_oga01
        #AND ogb03 = l_ogb[l_i].ogb03      #FUN-930101 mark 不判斷項次，因為出通單單身的資料在出貨單可能會分好幾筆出貨
         AND ogb31 = l_ogb[l_i].ogb31
         AND ogb32 = l_ogb[l_i].ogb32
         AND ogb04 = l_ogb[l_i].ogb04
         AND ogaconf != 'X'
 
      IF cl_null(l_ogb12b) THEN
         LET l_ogb12b = 0
      END IF
 
      LET l_ogb[l_i].ogb12 = l_ogb12a - l_ogb12b
 
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
