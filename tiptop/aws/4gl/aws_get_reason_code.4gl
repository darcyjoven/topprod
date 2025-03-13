# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_reason_code.4gl
# Descriptions...: 提供取得 ERP 理由碼資料服務
# Date & Author..: No.FUN-850020 08/05/05 By Nicola
# Modify.........: No.FUN-840012 08/08/26 by kim 增加一個參數
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
#No.FUN-850020
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
#[
# Description....: 提供取得 ERP 理由碼資料服務(入口 function)
# Date & Author..: No.FUN-850020 08/05/05 By Nicola
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_reason_code()
 
   WHENEVER ERROR CONTINUE
 
   CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
   
   #--------------------------------------------------------------------------#
   # 查詢 ERP 理由碼編號資料                                                  #
   #--------------------------------------------------------------------------#
   IF g_status.code = "0" THEN
      CALL aws_get_reason_code_process()
   END IF
 
   CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
 
END FUNCTION
 
#[
# Description....: 查詢 ERP 理由碼編號資料
# Date & Author..: No.FUN-850020 08/05/05 By Nicola
# Parameter......: 回傳所有理由碼
# Return.........: none
# Memo...........:
#
#]
FUNCTION aws_get_reason_code_process()
   DEFINE l_sql   STRING
   DEFINE l_where STRING #FUN-840012
   DEFINE l_node  om.DomNode
   DEFINE l_azf   RECORD
                     azf01 LIKE azf_file.azf01,
                     azf03 LIKE azf_file.azf03
                  END RECORD
   #FUN-840012
   SELECT sma79 INTO g_sma.sma79
                FROM sma_file
               WHERE sma00='0'
   IF g_sma.sma79='Y' THEN
      LET l_where=" AND azf02='A' "
   ELSE
      LET l_where=" AND azf02='2' "
   END IF
 
   LET l_sql = "SELECT azf01,azf03 FROM azf_file ",
               " WHERE azfacti='Y' ",
               l_where,
               " ORDER BY azf01"
   
   DECLARE azf_curs CURSOR FROM l_sql 
 
   IF SQLCA.SQLCODE THEN
      LET g_status.code = SQLCA.SQLCODE
      LET g_status.sqlcode = SQLCA.SQLCODE
      RETURN
   END IF
   
   FOREACH azf_curs INTO l_azf.*
      IF SQLCA.SQLCODE THEN
         LET g_status.code = SQLCA.SQLCODE
         LET g_status.sqlcode = SQLCA.SQLCODE
         RETURN
      END IF
 
      LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_azf), "azf_file")   #加入此筆單檔資料至 Response 中
   
   END FOREACH
 
END FUNCTION
