# Prog. Version..: '5.30.21-13.04.01(00001)'     #
# Descriptions...: 合併報表關帳作業
# Input parameter:
# Return code....:
# Date & Author..: 13/03/21 BY Lori(FUN-D20046)

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION saglp101(p_axa01,p_aaz641,p_aaz642)
   DEFINE p_axa01      LIKE axa_file.axa01,
          p_aaz641     LIKE aaz_file.aaz641,
          p_aaz642     LIKE aaz_file.aaz642   #調整合併報表關帳日(tm.aaz642)
   DEFINE l_aaz643     LIKE aaz_file.aaz643
   DEFINE l_aaz642     LIKE aaz_file.aaz642   #目前的合併報表關帳日
   DEFINE l_axa        RECORD
            axa02      LIKE axa_file.axa02,
            axa03      LIKE axa_file.axa03,
            axz03      LIKE axz_file.axz03
                       END RECORD
   DEFINE l_aaaacti    LIKE aaa_file.aaaacti
   DEFINE l_aaa07      LIKE aaa_file.aaa07
   DEFINE l_sql        STRING
   DEFINE l_upd_type   LIKE type_file.num5    #1.將關帳日往後調整 2.將關帳日往前調整
   DEFINE l_upd_flag   LIKE type_file.chr1    #是否子公司的關帳日期一併調整
   DEFINE l_upd_aaz    LIKE type_file.chr1    #個體公司更新aaa_file成功否,成功才更新合併報表關帳日
   DEFINE l_error_cnt  LIKE type_file.num5
   DEFINE l_succ_cnt   LIKE type_file.num5
   DEFINE l_ze03       LIKE ze_file.ze03

   LET l_upd_type = NULL
   LET l_upd_flag = 'N'
   LET l_error_cnt = 0
   LET l_succ_cnt  = 0

   CALL s_showmsg_init()

   #取得合併報表的帳別資料
   SELECT aaz642,aaz643 INTO l_aaz642,l_aaz643
     FROM aaz_file
    WHERE aaz00 = '0'

   #取得集團下所有公司
   LET l_sql =  "SELECT UNIQUE axa02,axa03,axz03",
                "  FROM axa_file,axz_file",
                " WHERE axa02 = axz01",
                "   AND axa01 = '",p_axa01,"' ",
                "   AND axz04 = 'Y' ",
                " UNION ",
                "SELECT UNIQUE axb04,axb05,axz03",
                "  FROM axb_file,axa_file,axz_file",
                " WHERE axa01 = axb01",
                "   AND axa02 = axb02",
                "   AND axb04 = axz01",
                "   AND axa01 = '",p_axa01,"' ",
                "   AND axz04 = 'Y' ",
                " ORDER BY 1,2"
   PREPARE p101_axa_p FROM l_sql
   DECLARE p101_axa_c CURSOR FOR p101_axa_p

   IF l_aaz643 = 'Y' AND (p_aaz642 > l_aaz642 OR cl_null(l_aaz642)) THEN
      LET l_upd_type = 1
   END IF

   #判斷是否子公司一併關帳;當關帳日(p_aaaz642)小於當下的合併報表關帳日(l_aaz642)時
   #檢查子公司的當下關帳日大於調整的關帳日期(p_aaaz642)時,顯示錯誤訊息並詢問是否覆寫關帳日(將p_aaz642覆寫到aaa07)
   IF l_aaz643 = 'Y' THEN

      FOREACH p101_axa_c INTO l_axa.*
         #取得公司目前的關帳日期
         LET l_sql = "SELECT aaa07,aaaacti ",
                     "  FROM ",cl_get_target_table(l_axa.axz03,'aaa_file'),
                     " WHERE aaa01 = '",l_axa.axa03,"' "
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_axa.axz03) RETURNING l_sql
         PREPARE p101_aaa_p2 FROM l_sql
         EXECUTE p101_aaa_p2 INTO l_aaa07,l_aaaacti

         IF l_aaa07 > p_aaz642 THEN
            LET g_showmsg = l_axa.axa03,",",l_aaa07
            CALL s_errmsg('aaa01,aaa07',g_showmsg,l_axa.axa02,'agl1065','')
         END IF
      END FOREACH
      IF NOT cl_null(g_showmsg) THEN
         LET l_upd_type = 2
         CALL s_showmsg()
         IF (cl_confirm('agl1064')) THEN
            LET l_upd_flag = 'Y'
         END IF
      END IF
   END IF

   CALL s_showmsg_init()

   #判斷是否子公司一併關帳
   IF l_upd_type = 1 OR (l_upd_type = 2 AND l_upd_flag = 'Y') THEN
      FOREACH p101_axa_c INTO l_axa.*
         #取得公司目前的關帳日期
         LET l_sql = "SELECT aaa07,aaaacti ",
                     "  FROM ",cl_get_target_table(l_axa.axz03,'aaa_file'),
                     " WHERE aaa01 = '",l_axa.axa03,"' "
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_axa.axz03) RETURNING l_sql
         PREPARE p101_aaa_p4 FROM l_sql
         EXECUTE p101_aaa_p4 INTO l_aaa07,l_aaaacti

         IF l_aaaacti = 'N' THEN
            LET g_showmsg = l_axa.axa03
            CALL s_errmsg('axa03',g_showmsg,'','9028',1)
         ELSE
            LET g_showmsg = l_axa.axa03,",",l_aaa07

            LET l_sql = "UPDATE ",cl_get_target_table(l_axa.axz03,'aaa_file'),
                        "   SET aaa07 = '",p_aaz642,"' ",
                        " WHERE aaa01 = '",l_axa.axa03,"' "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,l_axa.axz03) RETURNING l_sql
            PREPARE p101_aaa_p3 FROM l_sql

            #公司關帳日小於合併報表關帳日時才UPDATE
            IF (l_upd_type = 1 AND l_aaa07 < p_aaz642) OR l_upd_type = 2 THEN
               EXECUTE p101_aaa_p3
               IF STATUS THEN
                  LET l_error_cnt = l_error_cnt + 1
                  CALL s_errmsg('aaa01,aaa07',g_showmsg,'','agl1063',1)
               ELSE
                  LET l_succ_cnt = l_succ_cnt + 1
                  CALL s_errmsg('aaa01,aaa07',g_showmsg,l_axa.axa03,'agl1062','')
               END IF
            END IF

            IF l_upd_type = 1 AND l_aaa07 > p_aaz642 THEN
               CALL s_errmsg('aaa01,aaa07',g_showmsg,l_axa.axa03,'agl1061',1)
            END IF
         END IF
      END FOREACH
   END IF

   IF l_error_cnt > 0 THEN
      LET g_success = 'N'
      RETURN
   END IF

   LET l_upd_aaz = 'Y'

   IF l_aaz643 = 'N' OR l_aaz643 = ' ' OR l_upd_flag = 'N' THEN
      IF l_aaz642 > p_aaz642 THEN
         IF cl_null(l_axa.axa02) THEN
            LET l_sql =  "SELECT UNIQUE axa02,axa03,axz03",
                         "  FROM axa_file,axz_file",
                         " WHERE axa02 = axz01",
                         "   AND axa01 = '",p_axa01,"' ",
                         "   AND axa03 = '",p_aaz641,"' ",
                         "   AND axa04 = 'Y' ",
                         " ORDER BY 1,2"
            PREPARE p101_axa_p1 FROM l_sql
            DECLARE p101_axa_c1 CURSOR FOR p101_axa_p1
            EXECUTE p101_axa_c1 INTO l_axa.*
         END IF

         IF (cl_confirm('agl1064')) THEN
               LET l_upd_flag = 'Y'
         ELSE
            LET l_upd_flag = 'Y'
         END IF

         IF l_upd_flag = 'Y' THEN
            LET g_showmsg = p_aaz641,",",l_aaz642

            UPDATE aaa_file SET aaa07 = p_aaz642
             WHERE aaa01 = p_aaz641
            IF STATUS THEN
                LET g_success = 'N'
               CALL s_errmsg('aaa01,aaa07',g_showmsg,'','agl1063',1)
            ELSE
               LET l_upd_aaz = 'Y'
               CALL s_errmsg('aaa01,aaa07',g_showmsg,p_aaz641,'agl1062','')
            END IF
         END IF
      END IF
   END IF

   IF l_upd_aaz = 'Y'  THEN
      #更新合併報表關帳日
      UPDATE aaz_file SET aaz642 = p_aaz642
       WHERE aaz641 = p_aaz641
      IF STATUS THEN
         LET g_success = 'N'
      END IF
   END IF
END FUNCTION
#FUN-D20046
