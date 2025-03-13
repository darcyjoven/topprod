# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: aws_member_upgrade.4gl
# Descriptions...: 會員升等確認
# Date & Author..: No.FUN-CC0135 12/12/25 by xumm 
# Modify.........: No.FUN-D10095 13/01/28 By xumm XML格式调整

DATABASE ds 

GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔


DEFINE g_return    RECORD                #回傳值必須宣告為一個 RECORD 變數
       Success     LIKE type_file.chr1,  #升等成功否
       Grade       LIKE lpk_file.lpk10   #更新成功后等级
                   END RECORD 
DEFINE g_lpk10     LIKE lpk_file.lpk10
DEFINE g_flag      LIKE type_file.chr1
#[
# Description....: 查詢會員升等是否成功(入口 function)
# Date & Author..: 2012/12/25 by xumeimei 
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_member_upgrade()

    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序

    #--------------------------------------------------------------------------#
    # POS查詢會員升等是否成功                                                        #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_member_upgrade_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION

#[
# Description....: 依據傳入資訊查詢會員升等是否成功
# Date & Author..: 2012/12/25 by xumeimei 
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_member_upgrade_process()
DEFINE l_sql        STRING 
DEFINE l_shop       LIKE azw_file.azw01        #門店編號
DEFINE l_cardno     LIKE lpj_file.lpj03        #卡號
DEFINE l_isupgrade  LIKE type_file.chr1        #是否升等
DEFINE l_success    LIKE type_file.chr1        #是否升等成功
DEFINE l_grade      LIKE lpk_file.lpk10        #更新成功后等级
DEFINE l_guid       LIKE rxu_file.rxu01        #GUID
DEFINE l_ctno       LIKE lpj_file.lpj02        #卡种
DEFINE l_node       om.DomNode                 #FUN-D10095 Add


   #取得各項參數
  #FUN-D10095 Mark&Add Begin ---
  #LET l_shop = aws_ttsrv_getParameter("Shop")
  #LET l_cardno = aws_ttsrv_getParameter("CardNO")
  #LET l_isupgrade = aws_ttsrv_getParameter("IsUpgrade")
  #LET l_guid = aws_ttsrv_getParameter("GUID")
   LET l_node = aws_ttsrv_getTreeMasterRecord(1,"MemberUpgrade")
   LET l_shop = aws_ttsrv_getRecordField(l_node,"Shop")
   LET l_cardno = aws_ttsrv_getRecordField(l_node,"CardNO")
   LET l_isupgrade = aws_ttsrv_getRecordField(l_node,"IsUpgrade")
   LET l_guid = aws_ttsrv_getRecordField(l_node,"GUID")
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
   #按條件查詢會員升等是否成功
   LET g_success = 'Y'
   BEGIN WORK
   IF NOT aws_upgrade(l_guid,l_cardno,l_isupgrade,l_shop) THEN 
      LET l_success = 'N'
      LET l_grade = g_lpk10
   ELSE
      LET l_success = 'Y'
      LET l_grade = g_lpk10
   END IF
   IF g_success = 'N' THEN
      CALL aws_pos_get_code('aws-932',l_cardno,NULL,NULL)
      ROLLBACK WORK
   ELSE
      COMMIT WORK
   END IF
   LET g_return.Success = l_success
   LET g_return.Grade = l_grade
   #CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(g_return))                              #FUN-D10095 Mark
   CALL aws_ttsrv_addTreeMaster(base.TypeInfo.create(g_return), "MemberUpgrade") RETURNING l_node  #FUN-D10095 Add
END FUNCTION 
FUNCTION aws_upgrade(p_guid,p_cardno,p_isupgrade,p_shop)
DEFINE p_shop        LIKE azw_file.azw01        #門店編號
DEFINE p_cardno      LIKE lpj_file.lpj03        #卡號
DEFINE p_isupgrade   LIKE type_file.chr1        #是否升等
DEFINE p_guid        LIKE rxu_file.rxu01        #GUID
DEFINE g_lqr         RECORD LIKE lqr_file.*   
DEFINE g_lqt         RECORD LIKE lqt_file.*
DEFINE g_rxu         RECORD LIKE rxu_file.*
DEFINE l_rye04       LIKE rye_file.rye04
DEFINE li_result     LIKE type_file.num5
DEFINE l_lpj01       LIKE lpj_file.lpj01
DEFINE l_sql         STRING

   IF NOT aws_pos_guid_isExistence(p_guid) THEN
      IF p_isupgrade ='1' THEN
         LET l_sql = " SELECT lpj01 FROM ",cl_get_target_table(p_shop,"lpj_file"),
                     "  WHERE lpj03 = '",p_cardno,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,p_shop) RETURNING l_sql
         PREPARE aws_sel_lpj_pre1 FROM l_sql
         EXECUTE aws_sel_lpj_pre1 INTO l_lpj01
         LET l_sql = " UPDATE ",cl_get_target_table(p_shop,"lpk_file"),
                     "    SET lpk21 = 'N' ",
                     "  WHERE lpk01 = '",l_lpj01,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,p_shop) RETURNING l_sql
         PREPARE aws_upd_lpk_pre FROM l_sql
         EXECUTE aws_upd_lpk_pre
         IF sqlca.sqlcode THEN
            LET g_status.sqlcode = sqlca.sqlcode
            LET g_success = 'N'
            RETURN FALSE
         END IF
         LET g_rxu.rxu01 = p_guid
         LET g_rxu.rxu02 = ' '
         LET g_rxu.rxu03 = p_shop
         LET g_rxu.rxu04 = ' '
         LET g_rxu.rxu05 = 'MemberUpgrade'
         LET g_rxu.rxu06 = '12'
         LET g_rxu.rxu07 = p_cardno
         LET g_rxu.rxu08 = 'Y' 
         LET g_rxu.rxu09 = 'N'
         LET g_rxu.rxu11 = g_today
         LET g_rxu.rxu12 = TIME
         LET g_rxu.rxuacti = 'Y'
         LET g_rxu.rxu13 = aws_pos_get_ConnectionMsg("mach")
         LET g_rxu.rxu14 = '17'
         LET g_rxu.rxu16 = NULL
         CALL aws_pos_ins_rxu(g_rxu.*) RETURNING g_flag
         IF NOT cl_null(g_flag) AND g_flag = 'N' THEN
            LET g_success = 'N'
            RETURN FALSE
         END IF
      END IF
      IF p_isupgrade ='0' THEN
         CALL aws_chk_upgrade(p_cardno,p_shop) RETURNING g_flag,g_lpk10
         IF g_flag = 'N' THEN
            LET g_status.sqlcode = sqlca.sqlcode
            LET g_success = 'N'
            RETURN FALSE
         ELSE
            CALL s_get_defslip("alm","O3",p_shop,'N') RETURNING l_rye04
            IF cl_null(l_rye04) THEN
               LET g_status.sqlcode = sqlca.sqlcode
               LET g_success = 'N'
               RETURN FALSE
            END IF
            CALL s_auto_assign_no("alm",l_rye04,g_today,"O3","lqr_file","lqr",p_shop,"","")
                 RETURNING li_result,g_lqr.lqr01
            IF (NOT li_result) THEN
               LET g_status.sqlcode = sqlca.sqlcode
               LET g_success = 'N'
               RETURN FALSE
            END IF
            LET g_lqr.lqr02 = g_today
            LET g_lqr.lqr04 = g_user
            LET g_lqr.lqr05 = '2'
            LET g_lqr.lqracti = 'Y'
            LET g_lqr.lqrconf ='Y'
            LET g_lqr.lqrdate = g_today
            LET g_lqr.lqrgrup = g_grup
            CALL s_getlegal(p_shop) RETURNING g_lqr.lqrlegal
            LET g_lqr.lqrorig = g_grup
            LET g_lqr.lqroriu = g_user
            LET g_lqr.lqrplant = p_shop
            LET g_lqr.lqrmodu = g_user
            LET g_lqr.lqrud13 = NULL
            LET g_lqr.lqrud14 = NULL
            LET g_lqr.lqrud15 = NULL
            LET g_lqr.lqruser = g_user
            LET g_lqr.lqrcond = g_today
            LET g_lqr.lqrconu = g_user
            LET l_sql = " INSERT INTO ",cl_get_target_table(p_shop,"lqr_file"),
                        " (lqr01,lqr02,lqr04,lqr05,lqracti,lqrconf,lqrdate,lqrgrup,lqrlegal,lqrorig,lqroriu,lqrplant,lqrmodu,lqrud13,lqrud14,lqrud15,lqruser,lqrcond,lqrconu)",
                        " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?) "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,p_shop) RETURNING l_sql
            PREPARE aws_ins_lqr_pre FROM l_sql
            EXECUTE aws_ins_lqr_pre USING g_lqr.lqr01,g_lqr.lqr02,g_lqr.lqr04,g_lqr.lqr05,
                                          g_lqr.lqracti,g_lqr.lqrconf,g_lqr.lqrdate,g_lqr.lqrgrup,
                                          g_lqr.lqrlegal,g_lqr.lqrorig,g_lqr.lqroriu,g_lqr.lqrplant,
                                          g_lqr.lqrmodu,g_lqr.lqrud13,g_lqr.lqrud14,g_lqr.lqrud15,
                                          g_lqr.lqruser,g_lqr.lqrcond,g_lqr.lqrconu
            IF sqlca.sqlcode THEN
               LET g_status.sqlcode = sqlca.sqlcode
               LET g_success = 'N'
               RETURN FALSE
            END IF
            LET g_lqt.lqt01 = g_lqr.lqr01
            LET g_lqt.lqt02 = 1
            LET l_sql = "SELECT lpj01 FROM ",cl_get_target_table(p_shop,"lpj_file"),
                        " WHERE lpj03 = '",p_cardno,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,p_shop) RETURNING l_sql
            PREPARE aws_sel_lpj01_pre FROM l_sql
            EXECUTE aws_sel_lpj01_pre INTO l_lpj01
            LET l_sql = "SELECT lpk10 FROM ",cl_get_target_table(p_shop,"lpk_file"),
                        " WHERE lpk01 = '",l_lpj01,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,p_shop) RETURNING l_sql
            PREPARE aws_sel_lpk10_pre FROM l_sql
            EXECUTE aws_sel_lpk10_pre INTO g_lqt.lqt04
            LET l_sql = "SELECT lpj01,SUM(lpj15),SUM(lpj14),SUM(lpj07) FROM ",cl_get_target_table(p_shop,"lpj_file"),
                        " WHERE lpj01 = '",l_lpj01,"'",
                        " GROUP BY lpj01"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,p_shop) RETURNING l_sql
            PREPARE aws_sel_lpj01_lpj15_pre FROM l_sql
            EXECUTE aws_sel_lpj01_lpj15_pre INTO g_lqt.lqt03,g_lqt.lqt05,g_lqt.lqt06,g_lqt.lqt07
            LET g_lqt.lqt08 = g_lpk10
            LET g_lqt.lqtlegal = g_lqr.lqrlegal
            LET g_lqt.lqtplant = p_shop
            LET l_sql = " INSERT INTO ",cl_get_target_table(p_shop,"lqt_file"),
                        " (lqt01,lqt02,lqt04,lqt03,lqt05,lqt06,lqt07,lqt08,lqtlegal,lqtplant)",
                        " VALUES(?,?,?,?,?, ?,?,?,?,?) "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,p_shop) RETURNING l_sql
            PREPARE aws_ins_lqt_pre FROM l_sql
            EXECUTE aws_ins_lqt_pre USING g_lqt.lqt01,g_lqt.lqt02,g_lqt.lqt04,g_lqt.lqt03,g_lqt.lqt05,
                                          g_lqt.lqt06,g_lqt.lqt07,g_lqt.lqt08,g_lqt.lqtlegal,g_lqt.lqtplant
            IF sqlca.sqlcode THEN
               LET g_status.sqlcode = sqlca.sqlcode
               LET g_success = 'N'
               RETURN FALSE
            END IF
            LET l_sql = " UPDATE ",cl_get_target_table(p_shop,"lpk_file"),
                        "    SET lpk10 = '",g_lpk10,"'",
                        "  WHERE lpk01 = '",l_lpj01,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,p_shop) RETURNING l_sql
            PREPARE aws_upd_lpk_pre1 FROM l_sql
            EXECUTE aws_upd_lpk_pre1 
            IF sqlca.sqlcode THEN
               LET g_status.sqlcode = sqlca.sqlcode
               LET g_success = 'N'
               RETURN FALSE
            END IF
            LET g_rxu.rxu01 = p_guid
            LET g_rxu.rxu02 = ' '
            LET g_rxu.rxu03 = p_shop
            LET g_rxu.rxu04 = ' '
            LET g_rxu.rxu05 = 'MemberUpgrade'
            LET g_rxu.rxu06 = '12'
            LET g_rxu.rxu07 = p_cardno
            LET g_rxu.rxu08 = g_lqt.lqt04
            LET g_rxu.rxu09 = g_lpk10
            LET g_rxu.rxu11 = g_today
            LET g_rxu.rxu12 = TIME
            LET g_rxu.rxuacti = 'Y'
            LET g_rxu.rxu13 = aws_pos_get_ConnectionMsg("mach")
            LET g_rxu.rxu14 = '17'
            LET g_rxu.rxu16 = g_lqr.lqr01
            CALL aws_pos_ins_rxu(g_rxu.*) RETURNING g_flag
            IF NOT cl_null(g_flag) AND g_flag = 'N' THEN
               LET g_success = 'N'
               RETURN FALSE
            END IF
         END IF
      END IF
   ELSE
      IF p_isupgrade ='0' THEN
         LET l_sql = " SELECT lpj01 FROM ",cl_get_target_table(p_shop,"lpj_file"),
                     "  WHERE lpj03 = '",p_cardno,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,p_shop) RETURNING l_sql
         PREPARE aws_sel_lpj_pre10 FROM l_sql
         EXECUTE aws_sel_lpj_pre10 INTO l_lpj01
         LET l_sql = " SELECT lpk10 FROM ",cl_get_target_table(p_shop,"lpk_file"),
                     "  WHERE lpk01 = '",l_lpj01,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,p_shop) RETURNING l_sql
         PREPARE aws_sel_lpk10_pre1 FROM l_sql
         EXECUTE aws_sel_lpk10_pre1 INTO g_lpk10
         IF sqlca.sqlcode THEN
            LET g_status.sqlcode = sqlca.sqlcode
            LET g_success = 'N'
            RETURN FALSE
         END IF
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#FUN-CC0135
