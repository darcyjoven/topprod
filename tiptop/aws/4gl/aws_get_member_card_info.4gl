# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: aws_get_member_card_info.4gl
# Descriptions...: 提供POS讀取會員卡信息的服務
# Date & Author..: 12/06/01 by suncx
# Modify.........: No.FUN-C50138 12/06/01 by suncx 新增程序
# Modify.........: No.FUN-D10095 13/01/25 By xumm XML格式调整

DATABASE ds 

GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

#[
# Description....: 提供POS讀取會員卡信息的服務(入口 function)
# Date & Author..: 2012/05/29 by suncx
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_get_member_card_info()

    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序

    #--------------------------------------------------------------------------#
    # POS讀取會員卡信息                                                           #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_member_card_info_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION



#[
# Description....: 依據傳入資訊修改POS收銀員密碼
# Date & Author..: 2012/06/01 by suncx
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_get_member_card_info_process()
    DEFINE l_cardno  STRING,                  #查詢號
           l_shop    STRING,                  #門店編號 
           l_guid    STRING                   #傳輸編號 
    DEFINE l_node    om.DomNode
    DEFINE l_sql     STRING,
           l_cnt     LIKE type_file.num5,
           l_i,l_j,l_n LIKE type_file.num5, 
           l_wc      STRING
    DEFINE l_lnk05   LIKE lnk_file.lnk05,     #卡生效范围审核码
           l_lpj05   LIKE lpj_file.lpj05
    DEFINE l_master RECORD                    #回傳值必須宣告為一個 RECORD 變數
                    tf_Card_Status_CardNO     LIKE lpj_file.lpj03,   #卡号
                    tf_Card_Status_MemberNO   LIKE lpj_file.lpj01,   #会员编号
                    tf_Card_Status_CTNO       LIKE lpj_file.lpj02,   #卡种
                    tf_Card_Status_CardStatus LIKE lpj_file.lpj09,   #卡状态
                    tf_Card_Status_Validity   LIKE type_file.chr8,   #有效期止
                    tf_Card_Status_CNFFLG     LIKE lpk_file.lpkacti, #有效否
                    tf_Member_MemberNO        LIKE lpk_file.lpk01,   #会员编号
                    tf_Member_MerberName      LIKE lpk_file.lpk04,   #会员姓名
                    tf_Member_BirthDay        LIKE type_file.chr8,   #出生日期
                    tf_Member_MenberGrade     LIKE lpk_file.lpk10,   #会员等级
                    tf_Member_MenberType      LIKE lpk_file.lpk13,   #会员类型
                    tf_Member_Address         LIKE lpk_file.lpk15,   #会员地址
                    tf_Member_Postalcode      LIKE lpk_file.lpk16,   #邮政编码
                    tf_Member_Telephone       LIKE lpk_file.lpk17,   #电话
                    tf_Member_Mobile          LIKE lpk_file.lpk18,   #手机
                    tf_Member_Email           LIKE lpk_file.lpk19,   #邮箱
                    tf_Member_CNFFLG          LIKE lpk_file.lpkacti  #有效否
                    END RECORD
    DEFINE l_detail DYNAMIC ARRAY OF RECORD 
                    tf_Member_Day_MemberNO    LIKE lpa_file.lpa01,   #会员编码
                    tf_Member_Day_MemorialNO  LIKE lpa_file.lpa02,   #纪念日代码
                    tf_Member_Day_Explain     LIKE lpc_file.lpc02,   #代码说明
                    tf_Member_Day_MDate       LIKE type_file.chr8,   #纪念日日期
                    tf_Member_Day_CNFFLG      LIKE lpa_file.lpaacti  #有效否
                    END RECORD
    DEFINE l_node1   om.DomNode               #FUN-D10095 Add     
    DEFINE l_subnode om.DomNode               #FUN-D10095 Add

    #取得各項參數
   #FUN-D10095 Mark&Add Begin ---
   #LET l_cardno = aws_ttsrv_getParameter("CardNO") 
   #LET l_shop   = aws_ttsrv_getParameter("Shop")
    LET l_node1  = aws_ttsrv_getTreeMasterRecord(1,"GetMemberCardInfo")
    LET l_shop   = aws_ttsrv_getRecordField(l_node1,"Shop")
    LET l_cardno = aws_ttsrv_getRecordField(l_node1,"CardNO")
   #FUN-D10095 Mark&Add End ---
    #LET l_guid   = aws_ttsrv_getParameter("GUID")
    LET l_guid   = aws_pos_get_ConnectionMsg("guid")
    #LET l_master.GUID = l_guid
    IF cl_null(l_guid) THEN
       RETURN 
    ELSE 
       #CALL aws_ttsrv_addParameterGuid(l_guid)
    END IF 
    #調用基本的檢查
    IF aws_pos_check() = 'N' THEN 
       RETURN 
    END IF 

    #判斷查詢號是卡號，還是手機號
    TRY 
       LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_shop,"lpj_file"),
                   " WHERE lpj03 = '",l_cardno,"'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       PREPARE sel_cnt_pre FROM l_sql
       EXECUTE sel_cnt_pre INTO l_cnt
       IF l_cnt > 0 THEN     #存在卡號則是按卡號查詢，否則按手機號查詢
          LET l_wc = " lpj03 = '",l_cardno,"'"
       ELSE 
          LET l_wc = " lpk18 = '",l_cardno,"'"
       END IF 
       
       #按條件查詢會員卡信息
       LET l_sql = " SELECT lpj03,lpj01,lpj02,lpj09,",cl_tp_tochar("lpj05","YYYYMMDD"),",'Y',lpk01,lpk04,",cl_tp_tochar("lpk05",'YYYYMMDD'),",",
                   "        lpk10,lpk13,lpk15,lpk16,lpk17,lpk18,lpk19,lpkacti,lnk05,lpj05",
                   "   FROM ",cl_get_target_table(l_shop,"lpj_file"),
                   "   LEFT JOIN ",cl_get_target_table(l_shop,"lpk_file")," ON lpk01=lpj01 ",
                   "   LEFT JOIN ",cl_get_target_table(l_shop,"lnk_file")," ON lnk01=lpj02 ",
                   "         AND lnk02 = '1' AND lnk03 ='",l_shop,"'",
                   "  WHERE ",l_wc CLIPPED
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       DECLARE sel_lpj_curs CURSOR FROM l_sql
       LET l_i = 0
       LET l_n = 0
       FOREACH sel_lpj_curs INTO l_master.*,l_lnk05,l_lpj05
          IF sqlca.sqlcode THEN
             LET g_status.sqlcode = sqlca.sqlcode
             CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
             EXIT FOREACH 
          END IF 
          LET l_node = aws_ttsrv_addTreeMaster(base.TypeInfo.create(l_master), "CardInfo")      #FUN-D10095 Add
          LET l_i = l_i+1
          #会员卡在本门店不能使用
          IF cl_null(l_lnk05) OR l_lnk05 = 'N' THEN 
             CALL aws_pos_get_code('aws-906',l_master.tf_Card_Status_CardNO,NULL,NULL)
             CONTINUE FOREACH
          END IF 
          
          #会员卡已失效
          IF l_lpj05 < g_today OR 
             l_master.tf_Member_CNFFLG = 'N' THEN 
             LET l_master.tf_Card_Status_CNFFLG = 'N'
             CALL aws_pos_get_code('aws-907',l_master.tf_Card_Status_CardNO,NULL,NULL) 
             CONTINUE FOREACH
          END IF 
          
          #會員卡狀態不符合
          IF l_master.tf_Card_Status_CardStatus <> '2' THEN 
             CALL aws_pos_get_code('aws-908',l_master.tf_Card_Status_CardNO,l_master.tf_Card_Status_CardStatus,'2') 
             CONTINUE FOREACH
          END IF

          CALL l_detail.clear()
          LET l_j = 1
          LET l_sql = "SELECT lpa01,lpa02,lpc02,",cl_tp_tochar("lpa03",'YYYYMMDD'),",lpaacti ",
                      "  FROM ",cl_get_target_table(l_shop,"lpa_file"),
                      "  LEFT JOIN ",cl_get_target_table(l_shop,"lpc_file"),
                      "         ON lpc00='8' AND lpc01=lpa02 ",
                      " WHERE lpa01 = '",l_master.tf_Card_Status_MemberNO,"'"
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql
          DECLARE sel_lpa_curs CURSOR FROM l_sql
          FOREACH sel_lpa_curs INTO l_detail[l_j].*
             LET l_subnode = aws_ttsrv_addTreeDetail(l_node, base.TypeInfo.create(l_detail[l_j]), "MemberDay" , "1" , l_j )   #FUN-D10095 Add
             #新增一笔返回的纪念日
             LET l_j = l_j+1
          END FOREACH  
          CALL l_detail.deleteElement(l_j)
         #FUN-D10095------mark---str
         ##新增一笔返回的Master
         #LET  l_node = aws_ttsrv_addMasterRecord(base.Typeinfo.create(l_master),"CardInfo")
         ##新增返回的纪念日明细
         #CALL aws_ttsrv_addDetailRecord(l_node, base.Typeinfo.create(l_detail),"MemberDay")
         #FUN-D10095------mark---end
          LET l_n = l_n+1
       END FOREACH 
       IF l_i = 0 THEN 
          #会员卡不存在
          CALL aws_pos_get_code('aws-905',l_cardno,NULL,NULL)
       END IF
       IF l_n > 0 THEN 
          LET g_status.description = NULL
          LET g_status.code = 0
       END IF 
   CATCH 
      IF sqlca.sqlcode THEN
         LET g_status.sqlcode = sqlca.sqlcode
      END IF 
      CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
   END TRY 

END FUNCTION 
#No.FUN-C50138
