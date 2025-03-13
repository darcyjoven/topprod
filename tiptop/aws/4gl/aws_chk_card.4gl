# Prog. Version..: '5.30.06-13.03.18(00006)'     #
#
# Program name...: aws_chk_card.4gl
# Descriptions...: 依據傳入的值檢查卡的狀態
# Date & Author..: No.FUN-CA0090 12/10/24 by xumm
# Modify.........: No:FUN-CB0028 12/11/16 by shiwuying 增加卡编码规则的检查
# Modify.........: No:FUN-CB0118 12/11/26 by shiwuying 逻辑调整
# Modify.........: No:FUN-CC0135 12/12/26 by xumm 增加卡升等服务的逻辑检查
# Modify.........: No:FUN-D10095 13/01/28 By xumm XML格式调整
# Modify.........: No:FUN-D30017 13/03/11 By xumm 报错信息修改

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔


FUNCTION aws_chk_card(p_type,p_bcard,p_ecard,p_ctno,p_type1,l_shop)
   DEFINE p_type        STRING                  #服務名称
                                                #ChangeCard       #画面换卡查询
                                                #DeductPayment_2  #更新换卡状态
                                                #CheckCardType    #发卡/退卡卡种查询
                                                #CheckCard        #发卡/退卡查询
                                                #DeductPayment_1  #更新发卡/退卡状态
                                                #SelCardInfo      #储值卡读卡信息
                                                #RechargeCard     #储值卡充值
                                                #DeductPayment_3  #更新充值储值
                                                #MemberUpgrade    #卡升等服务对应卡信息
   DEFINE p_bcard       LIKE lpj_file.lpj03     #開始卡號
   DEFINE p_ecard       LIKE lpj_file.lpj03     #結束卡號
   DEFINE p_ctno        LIKE lpj_file.lpj02     #卡种
   DEFINE p_type1       LIKE type_file.chr1     #操作類型->1发卡/2退卡   1旧卡/2新卡
   DEFINE l_shop        LIKE azw_file.azw01     #門店編號
   DEFINE l_sql         STRING
   DEFINE l_i           LIKE type_file.num10
   DEFINE l_bno         LIKE type_file.num10
   DEFINE l_eno         LIKE type_file.num10
   DEFINE l_lpj03       LIKE lpj_file.lpj03
   DEFINE l_pword       LIKE lpj_file.lpj26
   DEFINE l_lpj         RECORD
                        lpj02     LIKE lpj_file.lpj02,
                        lnk03     LIKE lnk_file.lnk03,
                        lpj05     LIKE lpj_file.lpj05,
                        lpkacti   LIKE lpk_file.lpkacti,
                        lpj09     LIKE lpj_file.lpj09,
                        lpj26     LIKE lpj_file.lpj26,
                        lph03     LIKE lph_file.lph03,
                        lph07     LIKE lph_file.lph07,
                        lph06     LIKE lph_file.lph06,
                        lph37     LIKE lph_file.lph37,
                        lph32     LIKE lph_file.lph32,
                        lph33     LIKE lph_file.lph33,
                        lph34     LIKE lph_file.lph34,
                        lph35     LIKE lph_file.lph35
                        END RECORD
   DEFINE l_node        om.DomNode             #FUN-D10095 Add

  #LET l_shop = aws_ttsrv_getParameter("Shop")
   
   LET l_sql = " SELECT lpj02,lnk03,lpj05,lpkacti,lpj09,lpj26,lph03,lph07,lph06,lph37,lph32,lph33,lph34,lph35 ",
               "   FROM ",cl_get_target_table(l_shop,"lpj_file"),"  LEFT OUTER JOIN ",
                          cl_get_target_table(l_shop,"lnk_file")," ON (lpj02 = lnk01 AND lnk02 = '1' AND ",
               "                                                      lnk03 ='",l_shop,"' AND lnk05 = 'Y')",
               "          LEFT OUTER JOIN ",
              #FUN-CB0118 Begin---
              #           cl_get_target_table(l_shop,"lpk_file")," ON (lpk01 = lpj01)",",",
              #           cl_get_target_table(l_shop,"lph_file"),
                          cl_get_target_table(l_shop,"lpk_file")," ON (lpk01 = lpj01) ",
               "          LEFT OUTER JOIN ",
                          cl_get_target_table(l_shop,"lph_file")," ON (lph01 = lpj02) ",
              #FUN-CB0118 End-----
               "  WHERE lph01 = lpj02 ",
               "    AND lpj03 = '",p_bcard,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,l_shop) RETURNING l_sql
   PREPARE sel_lpj_pre FROM l_sql
   EXECUTE sel_lpj_pre INTO l_lpj.*
   IF SQLCA.sqlcode = 100 THEN
      IF p_type = 'CheckCardType' THEN
        #FUN-CB0118 Begin---
        #IF p_type1 = '0' THEN
        #   CALL aws_pos_get_code('aws-905',p_bcard,NULL,NULL)
        #   RETURN FALSE
        #ELSE            #如果是第二张以后的卡号不存在，提示出来
        #   RETURN TRUE  #如果是第一张卡不存在，表示要返回空的卡种给pos，让pos指定卡种
        #END IF
         CALL aws_pos_get_code('aws-905',p_bcard,NULL,NULL)
         RETURN FALSE
        #FUN-CB0118 End-----
      END IF
      IF p_type = 'ChangeCard' OR p_type = 'DeductPayment_2' OR 
         p_type = 'CheckCard' OR p_type = 'DeductPayment_1' OR p_type = 'MemberUpgrade' THEN  #FUN-CC0135 add OR p_type = 'MemberUpgrade'
         #Error_5:会员卡msg不存在!
         CALL aws_pos_get_code('aws-905',p_bcard,NULL,NULL)
      END IF
      IF p_type = 'SelCardInfo' OR p_type = 'RechargeCard' OR
         p_type = 'DeductPayment_3' OR p_type = 'ReturnCard' THEN
         #Error_11:储值卡msg不存在!
         CALL aws_pos_get_code('aws-911',p_bcard,NULL,NULL)
      END IF
      LET g_success = 'N'
      RETURN FALSE
   END IF
  #FUN-CB0118 Begin---
   IF cl_null(l_lpj.lpj02) THEN
      IF p_type = 'CheckCardType' THEN
         IF p_type1 = '0' THEN #如果是第二张以后的卡种不存在，提示出来
            CALL aws_pos_get_code('aws-905',p_bcard,NULL,NULL)
            RETURN FALSE
         ELSE
            RETURN TRUE        #如果是第一张卡卡种不存在，表示要返回空的卡种给pos，让pos指定卡种
         END IF
      END IF
   END IF
  #FUN-CB0118 End-----
   IF cl_null(l_lpj.lnk03) THEN
      IF p_type = 'ChangeCard' OR p_type = 'DeductPayment_2' OR 
         p_type = 'CheckCard' OR p_type = 'DeductPayment_1' OR p_type = 'MemberUpgrade' THEN  #FUN-CC0135 add OR p_type = 'MemberUpgrade'
         #Error_6:会员卡msg在本门店不能使用!
         CALL aws_pos_get_code('aws-906',p_bcard,NULL,NULL)
      END IF
      IF p_type = 'SelCardInfo' OR p_type = 'RechargeCard' OR
         p_type = 'DeductPayment_3' OR p_type = 'ReturnCard' THEN
         #Error_12:储值卡msg在本门店不能使用!
         CALL aws_pos_get_code('aws-912',p_bcard,NULL,NULL)
      END IF
      LET g_success = 'N'
      RETURN FALSE
   END IF
   IF (NOT cl_null(l_lpj.lpj05) AND l_lpj.lpj05 < g_today) OR l_lpj.lpkacti = 'N' THEN
      IF p_type = 'ChangeCard' OR p_type = 'DeductPayment_2' OR 
         p_type = 'CheckCard' OR p_type = 'DeductPayment_1' OR p_type = 'MemberUpgrade' THEN  #FUN-CC0135 add OR p_type = 'MemberUpgrade' 
         #Error_7:会员卡msg已失效!
         CALL aws_pos_get_code('aws-907',p_bcard,NULL,NULL)
      END IF
      IF p_type = 'SelCardInfo' OR p_type = 'RechargeCard' OR
         p_type = 'DeductPayment_3' OR p_type = 'ReturnCard' THEN
         #Error_13:储值卡msg已失效!
         CALL aws_pos_get_code('aws-913',p_bcard,NULL,NULL)
      END IF
      LET g_success = 'N'
      RETURN FALSE
   END IF
  
   IF l_lpj.lpj09 <> '2' THEN
      IF (p_type = 'ChangeCard' OR p_type = 'DeductPayment_2') AND p_type1 = '1' THEN #换卡旧卡检查
         #Error_8:当前会员卡msg状态为:
         CALL aws_pos_get_code('aws-908',p_bcard,l_lpj.lpj09,'2')
         LET g_success = 'N'
         RETURN FALSE
      END IF
      IF p_type = 'SelCardInfo' OR p_type = 'RechargeCard' OR p_type = 'DeductPayment_3' THEN
         #Error_8:当前储值卡msg状态为:
         CALL aws_pos_get_code('aws-908',p_bcard,l_lpj.lpj09,'2')
         LET g_success = 'N'
         RETURN FALSE
      END IF
      IF p_type = 'ReturnCard' OR (p_type = 'DeductPayment_1' AND p_type1 = '2') OR p_type = 'MemberUpgrade' THEN #退卡 #FUN-CC0135 add OR p_type = 'MemberUpgrade'
         #Error_8:当前会员卡msg状态为:
         CALL aws_pos_get_code('aws-908',p_bcard,l_lpj.lpj09,'2')
         LET g_success = 'N'
         RETURN FALSE
      END IF
   END IF
   
   IF l_lpj.lpj09 <> '1' THEN
      IF (p_type = 'ChangeCard' OR p_type = 'DeductPayment_2') AND p_type1 = '2' THEN #换卡新卡检查
         #Error_8:当前会员卡msg状态为:
         CALL aws_pos_get_code('aws-908',p_bcard,l_lpj.lpj09,'2')
         LET g_success = 'N'
         RETURN FALSE
      END IF
      IF p_type = 'CheckCardType' OR p_type = 'CheckCard' OR (p_type = 'DeductPayment_1' AND p_type1 = '1')  THEN   #发卡
         #Error_8:当前会员卡msg状态为:
         CALL aws_pos_get_code('aws-908',p_bcard,l_lpj.lpj09,'2')
         LET g_success = 'N'
         RETURN FALSE
      END IF
   END IF

   IF (p_type = 'ChangeCard' AND p_type1 = '1') OR p_type = 'ReturnCard' THEN #换卡旧卡密码检查
      #LET l_pword = aws_ttsrv_getParameter("PassWord")          #FUN-D10095 Mark
      LET l_node   = aws_ttsrv_getTreeMasterRecord(1,p_type)     #FUN-D10095 Add
      LET l_pword = aws_ttsrv_getRecordField(l_node,"PassWord")  #FUN-D10095 Add
      IF (NOT cl_null(l_pword) AND NOT cl_null(l_lpj.lpj26) AND l_pword <> l_lpj.lpj26) OR 
         (NOT cl_null(l_pword) AND cl_null(l_lpj.lpj26)) OR 
         (cl_null(l_pword) AND NOT cl_null(l_lpj.lpj26)) THEN
         CALL aws_pos_get_code('aws-933',p_bcard,NULL,NULL)
         LET g_success = 'N'
         RETURN FALSE
      END IF
   END IF
   
   IF p_type = 'SelCardInfo' OR p_type = 'RechargeCard' OR p_type = 'DeductPayment_3' THEN
      #Error_15:该卡msg不能储值!
      IF l_lpj.lph03 = 'N' THEN
         CALL aws_pos_get_code('aws-915',p_bcard,NULL,NULL)
         LET g_success = 'N'
         RETURN FALSE
      END IF
      IF p_type = 'RechargeCard' THEN
         #Error_15:该卡msg不能储值!
         IF l_lpj.lph07 = 'N' THEN
           #CALL aws_pos_get_code('aws-929',p_bcard,NULL,NULL)   #FUN-D30017 Mark 
            CALL aws_pos_get_code('aws-915',p_bcard,NULL,NULL)   #FUN-D30017 Add
            LET g_success = 'N'
            RETURN FALSE
         END IF
      END IF
   END IF

  #FUN-CB0028 Begin---
  #检查编码方式
   IF p_bcard <> p_ecard THEN
      IF p_bcard[1,l_lpj.lph33] <> p_ecard[1,l_lpj.lph33] OR
         p_bcard[l_lpj.lph33+1,l_lpj.lph32] > p_ecard[l_lpj.lph33+1,l_lpj.lph32] OR
         LENGTH(p_bcard) <> LENGTH(p_ecard) THEN
         LET g_success = 'N'
         RETURN FALSE
      END IF
   END IF
  #FUN-CB0028 End-----

   #有检查开始/结束卡号的才会走下面
   IF p_type1 = '0' THEN RETURN TRUE END IF
   IF cl_null(p_ctno) THEN LET p_ctno = l_lpj.lpj02 END IF
   #Error_27 会员卡001和其他卡卡种不同。
   IF l_lpj.lpj02 <> p_ctno THEN
      CALL aws_pos_get_code('aws-927',p_bcard,NULL,NULL)
      LET g_success = 'N'
      RETURN FALSE
   END IF
   IF p_type = 'CheckCardType' OR p_type = 'CheckCard' OR (p_type = 'DeductPayment_1' AND p_type1 = '1') THEN
      LET l_bno = p_bcard[l_lpj.lph33+1,l_lpj.lph32] + 1
      LET l_eno = p_ecard[l_lpj.lph33+1,l_lpj.lph32]
      FOR l_i = l_bno TO l_eno
         CALL aws_chk_card_lpj03(l_i,l_lpj.lph35) RETURNING l_lpj03
         LET l_lpj03 = l_lpj.lph34 CLIPPED,l_lpj03 CLIPPED
         IF NOT aws_chk_card(p_type,l_lpj03,p_ecard,p_ctno,'0',l_shop) THEN
            RETURN FALSE
         END IF
      END FOR
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION aws_chk_card_lpj03(l_i,l_lph35)
 DEFINE l_i           LIKE type_file.num10
 DEFINE l_lph35       LIKE lph_file.lph35
 DEFINE l_lpj03       LIKE lpj_file.lpj03

   CASE l_lph35
      WHEN 1 LET  l_lpj03 = l_i USING '&'
      WHEN 2 LET  l_lpj03 = l_i USING '&&'
      WHEN 3 LET  l_lpj03 = l_i USING '&&&'
      WHEN 4 LET  l_lpj03 = l_i USING '&&&&'
      WHEN 5 LET  l_lpj03 = l_i USING '&&&&&'
      WHEN 6 LET  l_lpj03 = l_i USING '&&&&&&'
      WHEN 7 LET  l_lpj03 = l_i USING '&&&&&&&'
      WHEN 8 LET  l_lpj03 = l_i USING '&&&&&&&&'
      WHEN 9 LET  l_lpj03 = l_i USING '&&&&&&&&&'
      WHEN 10 LET l_lpj03 = l_i USING '&&&&&&&&&&'
      WHEN 11 LET l_lpj03 = l_i USING '&&&&&&&&&&&'
      WHEN 12 LET l_lpj03 = l_i USING '&&&&&&&&&&&&'
      WHEN 13 LET l_lpj03 = l_i USING '&&&&&&&&&&&&&'
      WHEN 14 LET l_lpj03 = l_i USING '&&&&&&&&&&&&&&'
      WHEN 15 LET l_lpj03 = l_i USING '&&&&&&&&&&&&&&&'
      WHEN 16 LET l_lpj03 = l_i USING '&&&&&&&&&&&&&&&&'
      WHEN 17 LET l_lpj03 = l_i USING '&&&&&&&&&&&&&&&&&'
      WHEN 18 LET l_lpj03 = l_i USING '&&&&&&&&&&&&&&&&&&'
      WHEN 19 LET l_lpj03 = l_i USING '&&&&&&&&&&&&&&&&&&&'
      WHEN 20 LET l_lpj03 = l_i USING '&&&&&&&&&&&&&&&&&&&&'
      WHEN 21 LET l_lpj03 = l_i USING '&&&&&&&&&&&&&&&&&&&&&'
      WHEN 22 LET l_lpj03 = l_i USING '&&&&&&&&&&&&&&&&&&&&&&'
      WHEN 23 LET l_lpj03 = l_i USING '&&&&&&&&&&&&&&&&&&&&&&&'
      WHEN 24 LET l_lpj03 = l_i USING '&&&&&&&&&&&&&&&&&&&&&&&&'
      WHEN 25 LET l_lpj03 = l_i USING '&&&&&&&&&&&&&&&&&&&&&&&&&'
      WHEN 26 LET l_lpj03 = l_i USING '&&&&&&&&&&&&&&&&&&&&&&&&&&'
      WHEN 27 LET l_lpj03 = l_i USING '&&&&&&&&&&&&&&&&&&&&&&&&&&&'
      WHEN 28 LET l_lpj03 = l_i USING '&&&&&&&&&&&&&&&&&&&&&&&&&&&&'
      WHEN 29 LET l_lpj03 = l_i USING '&&&&&&&&&&&&&&&&&&&&&&&&&&&&&'
      WHEN 30 LET l_lpj03 = l_i USING '&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&'
      END CASE
   RETURN l_lpj03
END FUNCTION
#FUN-CA0090

