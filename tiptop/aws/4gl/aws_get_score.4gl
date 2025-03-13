# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Program name...: aws_get_score.4gl
# Descriptions...: 提供POS查詢積分抵現信息的服務
# Date & Author..: 12/06/14 by suncx
# Modify.........: No.FUN-C50138 12/06/14 by suncx 新增程序
# Modify.........: No.FUN-D10095 13/01/25 By xumm XML格式调整

DATABASE ds 

GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔


DEFINE g_return RECORD                   #回傳值必須宣告為一個 RECORD 變數
                DCash  LIKE lpj_file.lpj06, #可抵金额
                DScore LIKE lpj_file.lpj12  #可抵积分
                #GUID   STRING               #传输GUID
            END RECORD 
#[
# Description....: 提供POS查詢積分抵現信息的服務(入口 function)
# Date & Author..: 2012/06/14 by suncx
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_get_score()

    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序

    #--------------------------------------------------------------------------#
    # POS查詢積分抵現信息                                                           #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_score_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION

#[
# Description....: 依據傳入資訊查詢積分抵現信息
# Date & Author..: 2012/06/14 by suncx
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_get_score_process()
   DEFINE l_sql     STRING 
   DEFINE l_guid    STRING
   DEFINE l_shop    LIKE azw_file.azw01,   #門店編號
          l_cardno  LIKE lpj_file.lpj03    #卡號
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
   DEFINE l_node    om.DomNode             #FUN-D10095 Add

   #取得各項參數
  #FUN-D10095 Mark&Add Begin ---
  #LET l_shop = aws_ttsrv_getParameter("Shop")
  #LET l_cardno = aws_ttsrv_getParameter("CardNO") 
   LET l_node = aws_ttsrv_getTreeMasterRecord(1,"GetScore")
   LET l_shop = aws_ttsrv_getRecordField(l_node,"Shop")
   LET l_cardno = aws_ttsrv_getRecordField(l_node,"CardNO")
  #FUN-D10095 Mark&Add End -----
   #LET g_return.GUID = aws_ttsrv_getParameter("GUID")
   LET l_guid = aws_pos_get_ConnectionMsg("guid")
   
   IF cl_null(l_guid) THEN
      RETURN 
   END IF 

   #調用基本的檢查
   IF aws_pos_check() = 'N' THEN 
      RETURN 
   END IF 

   #按條件查詢會員卡信息
   TRY 
       LET l_sql = " SELECT lpj05,lpj09,lpj12,lpkacti,lph37,lph38,lph39,lnk05 ",
                   "   FROM ",cl_get_target_table(l_shop,"lpj_file"),
                   "   LEFT JOIN ",cl_get_target_table(l_shop,"lpk_file")," ON lpk01=lpj01 ",
                   "   LEFT JOIN ",cl_get_target_table(l_shop,"lph_file")," ON lph01=lpj02 ",
                   "   LEFT JOIN ",cl_get_target_table(l_shop,"lnk_file")," ON lnk01=lpj02 ",
                   "         AND lnk02 = '1' AND lnk03 ='",l_shop,"'",
                   "  WHERE lpj03 = '",l_cardno,"'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       PREPARE sel_lpj_pre FROM l_sql
       EXECUTE sel_lpj_pre INTO l_lpj.*
       IF sqlca.sqlcode THEN 
          IF sqlca.sqlcode = 100 THEN 
             CALL aws_pos_get_code('aws-905',l_cardno,NULL,NULL) #卡不存在         
          ELSE 
             LET g_status.sqlcode = sqlca.sqlcode
             CALL aws_pos_get_code('aws-901',NULL,NULL,NULL) #ERP系統錯誤
          END IF 
       END IF
       #判断会员卡在本门店能否使用
       IF cl_null(l_lpj.lnk05) OR l_lpj.lnk05='N' THEN 
          CALL aws_pos_get_code('aws-906',l_cardno,NULL,NULL)         #会员卡在本门店不能使用  
          RETURN             
       END IF
       
       #判断会员卡是否失效
       IF (NOT cl_null(l_lpj.lpj05) AND l_lpj.lpj05 <= g_today) OR cl_null(l_lpj.lpkacti) OR   
          l_lpj.lpkacti = 'N' THEN 
          CALL aws_pos_get_code('aws-907',l_cardno,NULL,NULL)         #会员卡失效
          RETURN            
       END IF 
       #检查会员卡状态
       IF l_lpj.lpj09 <> '2' THEN 
          CALL aws_pos_get_code('aws-908',l_cardno,l_lpj.lpj09,'2')  #会员卡状态不符合
          RETURN            
       END IF 
       #检查会员卡是否可积分抵現
       IF cl_null(l_lpj.lph37) OR l_lpj.lph37 = 'N' THEN 
          CALL aws_pos_get_code('aws-920',l_cardno,NULL,NULL)         #会员卡不积分抵現
          RETURN           
       END IF

       IF cl_null(l_lpj.lph38) THEN LET l_lpj.lph38 = 1 END IF 
       IF cl_null(l_lpj.lph39) THEN LET l_lpj.lph39 = 0 END IF 
       IF cl_null(l_lpj.lpj12) THEN LET l_lpj.lpj12 = 0 END IF 
       LET g_return.DScore = l_lpj.lpj12
       LET g_return.DCash = (l_lpj.lpj12/l_lpj.lph38)*l_lpj.lph39
   CATCH 
       IF sqlca.sqlcode THEN
          LET g_status.sqlcode = sqlca.sqlcode
       END IF 
       CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
   END TRY 
   #CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(g_return))                         #FUN-D10095 Mark
   CALL aws_ttsrv_addTreeMaster(base.TypeInfo.create(g_return), "GetScore") RETURNING l_node  #FUN-D10095 Add
END FUNCTION 
#No.FUN-C50138
