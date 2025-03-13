# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: aws_check_member_upgrade.4gl
# Descriptions...: 會員升等檢查
# Date & Author..: No.FUN-CC0135 12/12/25 by xumm 
# Modify.........: No.FUN-D10059 13/01/15 By dongsz 會員升等邏輯調整為調用t559sub_lqt03_uplevel函數
# Modify.........: No.FUN-D10095 13/01/28 By xumm XML格式调整

DATABASE ds 

GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔


DEFINE g_return    RECORD                #回傳值必須宣告為一個 RECORD 變數
       Isupgrade   LIKE type_file.chr1,  #是否升等
       Score       LIKE lpj_file.lpj14,  #現有積分
       Decscore    LIKE lpj_file.lpj14,  #升级所需积分
       Grade       STRING                #更新成功后等级+名称
                   END RECORD 
DEFINE g_lpk10     LIKE lpk_file.lpk10   #更新成功后等级
DEFINE g_flag      LIKE type_file.chr1  
                
#[
# Description....: 查詢會員是否可以升等(入口 function)
# Date & Author..: 2012/12/25 by xumeimei 
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_check_member_upgrade()

    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序

    #--------------------------------------------------------------------------#
    # POS查詢會員是否可以升等                                                        #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_check_member_upgrade_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION

#[
# Description....: 依據傳入資訊查詢會員是否可以升等
# Date & Author..: 2012/12/25 by xumeimei 
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_check_member_upgrade_process()
DEFINE l_sql        STRING 
DEFINE l_shop       LIKE azw_file.azw01        #門店編號
DEFINE l_cardno     LIKE lpj_file.lpj03        #卡號
DEFINE l_isupgrade  LIKE type_file.chr1        #是否升等
DEFINE l_score      LIKE lpj_file.lpj14        #現有積分
DEFINE l_decscore   LIKE lpj_file.lpj14        #升级所需积分
DEFINE l_lpj01      LIKE lpj_file.lpj01        #会员编号
DEFINE l_lpj01_1    LIKE lpj_file.lpj01        #会员编号
DEFINE l_lpj12      LIKE lpj_file.lpj12        #会员积分
DEFINE l_lpc02      LIKE lpc_file.lpc02        #更新成功后等級名稱
DEFINE l_grade      STRING                     #更新成功后等级+名称
DEFINE l_ctno       LIKE lpj_file.lpj02        #卡种
DEFINE l_node       om.DomNode                 #FUN-D10095 Add


   #取得各項參數
  #FUN-D10095 Mark&Add Begin ---
  #LET l_shop = aws_ttsrv_getParameter("Shop")
  #LET l_cardno = aws_ttsrv_getParameter("CardNO")
   LET l_node = aws_ttsrv_getTreeMasterRecord(1,"CheckMemberUpgrade")
   LET l_shop = aws_ttsrv_getRecordField(l_node,"Shop")
   LET l_cardno = aws_ttsrv_getRecordField(l_node,"CardNO") 
  #FUN-D10095 Mark&Add End -----
   LET l_sql = " SELECT lpj02 FROM ",cl_get_target_table(l_shop,"lpj_file"),
               "  WHERE lpj03 = '",l_cardno,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,l_shop) RETURNING l_sql
   PREPARE aws_sel_lpj_pre FROM l_sql
   EXECUTE aws_sel_lpj_pre INTO l_ctno

   #調用基本的檢查
   IF aws_pos_check() = 'N' THEN 
      RETURN 
   END IF 
   IF NOT aws_chk_card('MemberUpgrade',l_cardno,l_cardno,l_ctno,'1',l_shop) THEN
      RETURN
   END IF
   #按條件查詢會員是否可以升等
   TRY
     CALL aws_chk_upgrade(l_cardno,l_shop) RETURNING g_flag,g_lpk10
     IF g_flag = 'N' THEN
        LET l_isupgrade = 'N'
        LET l_score = NULL
        LET l_decscore = NULL
        LET l_grade = NULL
     ELSE
        LET l_sql = " SELECT lpj01 FROM ",cl_get_target_table(l_shop,"lpj_file"),
                    "  WHERE lpj03 = '",l_cardno,"'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
        CALL cl_parse_qry_sql(l_sql,l_shop) RETURNING l_sql
        PREPARE aws_sel_lpj_pre1 FROM l_sql
        EXECUTE aws_sel_lpj_pre1 INTO l_lpj01
        LET l_sql = " SELECT lpj01,SUM(lpj12) FROM ",cl_get_target_table(l_shop,"lpj_file"),
                    "  WHERE lpj01 = '",l_lpj01,"'",
                    "  GROUP BY lpj01"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
        CALL cl_parse_qry_sql(l_sql,l_shop) RETURNING l_sql
        PREPARE aws_sel_lpj_pre2 FROM l_sql
        EXECUTE aws_sel_lpj_pre2 INTO l_lpj01_1,l_lpj12
        LET l_sql = " SELECT lpc02 FROM ",cl_get_target_table(l_shop,"lpc_file"),
                    "  WHERE lpc00 = '6'",
                    "    AND lpc01 = '",g_lpk10,"'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
        CALL cl_parse_qry_sql(l_sql,l_shop) RETURNING l_sql
        PREPARE aws_sel_lpj_pre3 FROM l_sql
        EXECUTE aws_sel_lpj_pre3 INTO l_lpc02 
        LET l_isupgrade = 'Y'
        LET l_score = l_lpj12
        LET l_decscore = 0
        LET l_grade = g_lpk10,'+',l_lpc02 
     END IF
     LET g_return.Isupgrade = l_isupgrade
     LET g_return.Score = l_score
     LET g_return.Decscore = l_decscore
     LET g_return.Grade = l_grade
   CATCH 
      IF sqlca.sqlcode THEN
         LET g_status.sqlcode = sqlca.sqlcode
      END IF 
      CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
   END TRY 
   #CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(g_return))                                   #FUN-D10095 Mark
   CALL aws_ttsrv_addTreeMaster(base.TypeInfo.create(g_return), "CheckMemberUpgrade") RETURNING l_node  #FUN-D10095 Add
END FUNCTION 
FUNCTION aws_chk_upgrade(p_cardno,p_shop)
DEFINE p_cardno                 LIKE lpj_file.lpj03 
DEFINE p_shop                   LIKE azw_file.azw01 
DEFINE l_lpj01                  LIKE lpj_file.lpj01
DEFINE l_lpk21                  LIKE lpk_file.lpk21
DEFINE l_lpk01                  LIKE lpk_file.lpk01
DEFINE l_sql                    STRING
DEFINE l_lpk10                  LIKE lpk_file.lpk10
DEFINE sum_lpj07                LIKE lpj_file.lpj07
DEFINE sum_lpj14                LIKE lpj_file.lpj14
DEFINE sum_lpj15                LIKE lpj_file.lpj15
DEFINE l_lpkacti                LIKE lpk_file.lpkacti
DEFINE l_lqq01_t                LIKE lqq_file.lqq01
DEFINE l_n                      LIKE type_file.num10
DEFINE l_flag                   LIKE type_file.chr1
DEFINE l_arr   DYNAMIC ARRAY OF RECORD
       lqq01                    LIKE lqq_file.lqq01,
       lqq02                    LIKE lqq_file.lqq02,
       lqq03                    LIKE lqq_file.lqq03,
       lqq04                    LIKE lqq_file.lqq04,
       lqq05                    LIKE lqq_file.lqq05
                                END RECORD

   TRY
      LET l_sql = " SELECT lpj01 FROM ",cl_get_target_table(p_shop,"lpj_file"),
                  "  WHERE lpj03 = '",p_cardno,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,p_shop) RETURNING l_sql
      PREPARE aws_sel_lpj_pre4 FROM l_sql
      EXECUTE aws_sel_lpj_pre4 INTO l_lpj01
      LET l_sql = " SELECT lpk21 FROM ",cl_get_target_table(p_shop,"lpk_file"),
                  "  WHERE lpk01 = '",l_lpj01,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,p_shop) RETURNING l_sql
      PREPARE aws_sel_lpj_pre5 FROM l_sql
      EXECUTE aws_sel_lpj_pre5 INTO l_lpk21 
      IF l_lpk21 = 'N' THEN
         RETURN 'N',' '
      ELSE
         LET l_sql = "SELECT lpk01,lpk10,SUM(lpj07),SUM(lpj14),SUM(lpj15) ",
                     "  FROM ",cl_get_target_table(p_shop,"lpj_file")," INNER JOIN ",
                               cl_get_target_table(p_shop,"lpk_file")," ON lpk01 = lpj01",
                     " WHERE lpj01 = '",l_lpj01,"'",
                     "   AND lpj09 = '2'",
                     "  GROUP BY lpk01,lpk10"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,p_shop) RETURNING l_sql
         PREPARE aws_sel_lpj_pre6 FROM l_sql
         EXECUTE aws_sel_lpj_pre6 INTO l_lpk01,l_lpk10,sum_lpj07,sum_lpj14,sum_lpj15                  

         CALL t559sub_lqt03_uplevel(l_lpk01,l_lpk10,sum_lpj15,sum_lpj14,sum_lpj07,l_flag,'1=1',p_shop)     #FUN-D10059 add
            RETURNING l_flag,l_n,l_lqq01_t                                                       #FUN-D10059 add

     #FUN-D10059--mark--str---                                                             
      #  LET l_sql = "SELECT lqq01,lqq02,lqq03,lqq04,lqq05 ",
      #              "  FROM ",cl_get_target_table(p_shop,"lpc_file")," INNER JOIN ",
      #                        cl_get_target_table(p_shop,"lqq_file")," ON lpc01 = lqq01 ",
      #              " WHERE lpc00 = '6' AND lpcacti = 'Y' ",
      #              " ORDER BY lqq01 "
      #  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      #  CALL cl_parse_qry_sql(l_sql,p_shop) RETURNING l_sql
      #  PREPARE aws_sel_lqq_pre FROM l_sql
      #  DECLARE aws_sel_lqq_cl CURSOR FOR aws_sel_lqq_pre
      #  LET l_n = 1
      #  LET l_flag = 'N'
      #  LET l_lqq01_t = ' '
      #  FOREACH aws_sel_lqq_cl INTO l_arr[l_n].*
      #     IF SQLCA.sqlcode THEN
      #        EXIT FOREACH
      #     END IF
      #     IF l_arr[l_n].lqq01 <> l_lpk10 THEN #如果抓取的等級與當前等級相同則不比較
      #        IF l_lqq01_t <> l_arr[l_n].lqq01 THEN #同一个等级的每一个条件都判断后，通过l_flag判断是否能够升级
      #           IF l_flag = 'Y' THEN
      #              EXIT FOREACH
      #           END IF
      #           LET l_lqq01_t = l_arr[l_n].lqq01
      #           LET l_flag = 'Y'
      #        END IF
      #        CASE
      #           WHEN l_arr[l_n].lqq02 = '1'  #判斷累積積分
      #              IF l_flag = 'Y' OR l_arr[l_n].lqq03 = 'OR' THEN
      #                 IF sum_lpj14 >= l_arr[l_n].lqq04 AND sum_lpj14 <= l_arr[l_n].lqq05 THEN
      #                    LET l_flag = 'Y'
      #                 ELSE
      #                    LET l_flag = 'N'
      #                 END IF
      #              END IF
      #           WHEN l_arr[l_n].lqq02 = '2' #判斷累計金額
      #              IF l_flag = 'Y' OR l_arr[l_n].lqq03 = 'OR' THEN
      #                 IF sum_lpj15 >= l_arr[l_n].lqq04 AND sum_lpj15 <= l_arr[l_n].lqq05 THEN
      #                    LET l_flag = 'Y'
      #                 ELSE
      #                    LET l_flag = 'N'
      #                 END IF
      #              END IF
      #           WHEN l_arr[l_n].lqq02 = '3' #判斷累計消費次數
      #              IF l_flag = 'Y' OR l_arr[l_n].lqq03 = 'OR' THEN
      #                 IF sum_lpj07 >= l_arr[l_n].lqq04 AND sum_lpj07 <= l_arr[l_n].lqq05 THEN
      #                    LET l_flag = 'Y'
      #                 ELSE
      #                    LET l_flag = 'N'
      #                 END IF
      #              END IF
      #           OTHERWISE  LET l_flag = 'N'
      #        END CASE
      #     END IF
      #     LET l_n = l_n + 1
      #  END FOREACH
     #FUN-D10059--mark--end---
         IF l_flag = 'N' THEN
            RETURN 'N',l_lqq01_t 
         END IF
      END IF
   CATCH
      IF sqlca.sqlcode THEN
         LET g_status.sqlcode = sqlca.sqlcode
         CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
      END IF
      RETURN 'N',l_lqq01_t
   END TRY
   RETURN 'Y',l_lqq01_t
END FUNCTION
#FUN-CC0135
