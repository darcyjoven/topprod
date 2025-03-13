# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_qty_conversion.4gl
# Descriptions...: 提供取得 ERP 單位換算後之數量
# Date & Author..: No.FUN-840012 08/05/06 By Nicola
# Memo...........:
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
#No.FUN-840012
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
#[
# Descriptions...: 提供取得 ERP 單位換算後之數量
# Date & Author..: No.FUN-840012 08/05/06 By Nicola
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_qty_conversion()
 
   WHENEVER ERROR CONTINUE
 
   CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
   
   #--------------------------------------------------------------------------#
   # 查詢 ERP 料件主要倉儲資料                                                #
   #--------------------------------------------------------------------------#
   IF g_status.code = "0" THEN
      CALL aws_get_qty_conversion_process()
   END IF
 
   CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
 
END FUNCTION
 
#[
# Descriptions...: 提供取得 ERP 單位換算後之數量
# Date & Author..: No.FUN-840012 08/05/06 By Nicola
# Parameter......: 回傳換算後之數量 
# Return.........: none
# Memo...........:
#
#]
FUNCTION aws_get_qty_conversion_process()
   DEFINE l_sql   STRING
   DEFINE l_node  om.DomNode
   DEFINE l_item  LIKE ima_file.ima01
   DEFINE l_sunit LIKE smd_file.smd02
   DEFINE l_dunit LIKE smd_file.smd03
   DEFINE l_sqty  LIKE imn_file.imn10
   DEFINE l_flag  LIKE type_file.num5
   DEFINE l_fac   LIKE ima_file.ima31_fac
   DEFINE l_qty   RECORD
                     fac LIKE ima_file.ima31_fac,
                     qty LIKE imn_file.imn10
                  END RECORD
 
   LET l_item = aws_ttsrv_getParameter("item")   #取由呼叫端呼叫時給予的料號
   LET l_sunit = aws_ttsrv_getParameter("sunit")   #取由呼叫端呼叫時給予的料號
   LET l_dunit = aws_ttsrv_getParameter("dunit")   #取由呼叫端呼叫時給予的料號
   LET l_sqty = aws_ttsrv_getParameter("sqty")   #取由呼叫端呼叫時給予的料號
 
   IF cl_null(l_item) THEN
      LET g_status.code = "aws-105"
      RETURN
   END IF
 
   IF cl_null(l_sunit) THEN
      LET g_status.code = "aws-106"
      RETURN
   END IF
 
   IF cl_null(l_dunit) THEN
      LET g_status.code = "aws-107"
      RETURN
   END IF
 
   IF cl_null(l_sqty) OR l_sqty <= 0 THEN
      LET g_status.code = "aim-120"
      RETURN
   END IF
 
   CALL s_umfchk(l_item,l_sunit,l_dunit) RETURNING l_flag,l_fac
 
   IF l_flag = 1 THEN
      LET g_status.code="abm-731"
      RETURN
   END IF
 
   LET l_qty.qty = l_sqty * l_fac
 
   LET l_qty.fac = l_fac
 
   CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_qty))
   
END FUNCTION
