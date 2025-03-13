# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: aws_sel_card_info.4gl
# Descriptions...: 儲值卡讀卡信息 
# Date & Author..: No.FUN-CA0090 12/10/22 By xumm 
# Modify.........: No:FUN-D10039 13/01/09 By xumm 逻辑调整
# Modify.........: No:FUN-D10095 13/01/28 By xumm XML格式调整

DATABASE ds 

GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"  #TIPTOP Service Gateway 使用的全域變數檔


DEFINE g_return   RECORD                  #回傳值必須宣告為一個 RECORD 變數
       CardAmount LIKE lpj_file.lpj06,    #儲值卡余額
       MerberName LIKE lpk_file.lpk04     #會員姓名
                  END RECORD 
                
#[
# Description....: 儲值卡讀卡信息(入口 function)
# Date & Author..: 2012/10/22 by xumeimei 
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_sel_card_info()

    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序

    #--------------------------------------------------------------------------#
    # POS查詢積分抵現信息                                                         #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_sel_card_info_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION

#[
# Description....: 依據傳入資訊查詢儲值卡余額信息
# Date & Author..: 2012/10/22 by xumeimei 
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_sel_card_info_process()
DEFINE l_sql     STRING 
DEFINE l_shop    LIKE azw_file.azw01    #門店編號
DEFINE l_cardno  LIKE lpj_file.lpj03    #卡號
DEFINE l_lpj06   LIKE lpj_file.lpj06
DEFINE l_lpk04   LIKE lpk_file.lpk04
DEFINE l_node    om.DomNode             #FUN-D10095 Add

   #取得各項參數
  #FUN-D10095 Mark&Add Begin ---
  #LET l_shop   = aws_ttsrv_getParameter("Shop")
  #LET l_cardno = aws_ttsrv_getParameter("CardNO") 
   LET l_node = aws_ttsrv_getTreeMasterRecord(1,"SelCardInfo")
   LET l_shop = aws_ttsrv_getRecordField(l_node,"Shop")
   LET l_cardno = aws_ttsrv_getRecordField(l_node,"CardNO") 
  #FUN-D10095 Mark&Add End -----
   
   #調用基本的檢查
   IF aws_pos_check() = 'N' THEN 
      RETURN 
   END IF 

   IF NOT aws_chk_card('SelCardInfo',l_cardno,null,'','',l_shop) THEN
      RETURN
   END IF 
   #按條件查詢储值卡信息
   TRY 
      LET l_sql = " SELECT lpj06,lpk04 ",
                 #FUN-D10039----mark--str
                 #"   FROM ",cl_get_target_table(l_shop,"lpj_file"),"  LEFT OUTER JOIN ",
                 #           cl_get_target_table(l_shop,"lnk_file")," ON (lpj02 = lnk01 AND lnk02 = '1' AND ",
                 #"                                                      lnk03 ='",l_shop,"' AND lnk05 = 'Y'),",
                 #           cl_get_target_table(l_shop,"lph_file"),",",
                 #           cl_get_target_table(l_shop,"lpk_file"),
                 #"  WHERE lpj01 = lpk01 AND lph01 = lpj02 ",
                 #FUN-D10039----mark--end
                 #FUN-D10039----add---str
                  "   FROM ",cl_get_target_table(l_shop,"lpj_file")," LEFT OUTER JOIN ",
                             cl_get_target_table(l_shop,"lnk_file")," ON (lpj02 = lnk01 AND lnk02 = '1' AND ",
                  "                                                       lnk03 ='",l_shop,"' AND lnk05 = 'Y') LEFT OUTER JOIN ",
                             cl_get_target_table(l_shop,"lpk_file")," ON (lpj01 = lpk01) ",",",
                             cl_get_target_table(l_shop,"lph_file"),
                  "  WHERE lph01 = lpj02 ",
                  "    AND lpj03 = '",l_cardno,"'"
                 #FUN-D10039----add---end
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      PREPARE sel_lpj_pre FROM l_sql
      EXECUTE sel_lpj_pre INTO l_lpj06,l_lpk04
      IF cl_null(l_lpj06) THEN LET l_lpj06 = 0 END IF 
      LET g_return.CardAmount = l_lpj06
      LET g_return.MerberName = l_lpk04
   CATCH 
      IF sqlca.sqlcode THEN
         LET g_status.sqlcode = sqlca.sqlcode
      END IF 
      CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
   END TRY 
   #CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(g_return))                            #FUN-D10095 Mark
   CALL aws_ttsrv_addTreeMaster(base.TypeInfo.create(g_return), "SelCardInfo") RETURNING l_node  #FUN-D10095 Add
END FUNCTION 

#FUN-CA0090
