# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: aws_get_card_score.4gl
# Descriptions...: 提供POS查詢會員卡可扣減積分信息的服務
# Date & Author..: No.FUN-CA0090 12/10/12 by baogc
# Modify.........: No.FUN-D10095 13/01/21 by baogc XML格式调整

DATABASE ds 

GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"  #TIPTOP Service Gateway 使用的全域變數檔


DEFINE g_return RECORD                  #回傳值必須宣告為一個 RECORD 變數
       Score    LIKE lpj_file.lpj12     #可扣減积分
                END RECORD 
                
#[
# Description....: 提供POS查詢會員卡可扣減積分信息的服務(入口 function)
# Date & Author..: 2012/10/12 by baogc
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_get_card_score()

    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序

    #--------------------------------------------------------------------------#
    # POS查詢積分抵現信息                                                         #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_card_score_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION

#[
# Description....: 依據傳入資訊查詢會員卡可扣減積分信息
# Date & Author..: 2012/10/12 by baogc
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_get_card_score_process()
DEFINE l_sql     STRING 
DEFINE l_guid    STRING
DEFINE l_shop    LIKE azw_file.azw01    #門店編號
DEFINE l_cardno  LIKE lpj_file.lpj03    #卡號
DEFINE l_lpj     RECORD
       lpj12     LIKE lpj_file.lpj12
                 END RECORD
DEFINE l_node    om.DomNode             #FUN-D10095 Add

   #取得各項參數
  #FUN-D10095 Mark&Add Begin ---
  #LET l_shop   = aws_ttsrv_getParameter("Shop")
  #LET l_cardno = aws_ttsrv_getParameter("CardNO") 
  #LET l_guid   = aws_pos_get_ConnectionMsg("guid")
  #LET l_node   = aws_ttsrv_getMasterRecord(1,"GetCardScore")
   LET l_node   = aws_ttsrv_getTreeMasterRecord(1,"GetCardScore")
   LET l_shop   = aws_ttsrv_getRecordField(l_node,"Shop")
   LET l_cardno = aws_ttsrv_getRecordField(l_node,"CardNO")
   LET l_guid   = aws_pos_get_ConnectionMsg("guid")
  #FUN-D10095 Mark&Add End -----
   
   IF cl_null(l_guid) THEN
      RETURN 
   END IF 

   #調用基本的檢查
   IF aws_pos_check() = 'N' THEN 
      RETURN 
   END IF 

   #按條件查詢會員卡信息
   TRY 
      LET l_sql = " SELECT lpj12 ",
                  "   FROM ",cl_get_target_table(l_shop,"lpj_file"),
                  "  WHERE lpj03 = '",l_cardno,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      PREPARE sel_lpj_pre FROM l_sql
      EXECUTE sel_lpj_pre INTO l_lpj.*

      IF cl_null(l_lpj.lpj12) THEN LET l_lpj.lpj12 = 0 END IF 
      LET g_return.Score = l_lpj.lpj12
   CATCH 
      IF sqlca.sqlcode THEN
         LET g_status.sqlcode = sqlca.sqlcode
      END IF 
      CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
   END TRY 
  #CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(g_return))                              #FUN-D10095 Mark
   CALL aws_ttsrv_addTreeMaster(base.TypeInfo.create(g_return), "GetCardScore") RETURNING l_node  #FUN-D10095 Add
END FUNCTION 

#FUN-CA0090
