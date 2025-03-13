# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: aglq703.4gl
# Descriptions...: 遞延收入金額檢核查詢
# Date & Author..: #FUN-AB0105 10/12/06 By vealxu 
# Modify.........: No.FUN-B70059 11/07/20 by belle 增加條件選項設定收入分類，可單獨只設定"客戶"
# Modify.........: No.TQC-B80254 11/08/31 by belle 判斷若oct22為null的話，以oct08為條件SUM(oct14-oct15)與sum(abb07)金額做為比對

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE 
    tm    RECORD
          oma02     LIKE oma_file.oma01,
          npqtype_1 LIKE npq_file.npqtype,
          wc        LIKE type_file.chr1000
          END RECORD
DEFINE
    g_omb DYNAMIC ARRAY OF RECORD
          npqtype   LIKE npq_file.npqtype,
          omb00     LIKE omb_file.omb00,
          omb01     LIKE omb_file.omb01,
          omb03     LIKE omb_file.omb03,
          omb04     LIKE omb_file.omb04,
          ima02     LIKE ima_file.ima02,
          npq28     LIKE npq_file.npq28,
          type      LIKE type_file.chr1,
          npq03     LIKE npq_file.npq03,
          aag02_1   LIKE aag_file.aag02,
          npq07     LIKE npq_file.npq07,
          oct13     LIKE oct_file.oct13,
          aag02_2   LIKE aag_file.aag02,
          oct12     LIKE oct_file.oct12,
          abb01     LIKE abb_file.abb01,
          abb02     LIKE abb_file.abb02,
          abb03     LIKE abb_file.abb03,
          aag02_3   LIKE aag_file.aag02,
          abb07     LIKE abb_file.abb07
        END RECORD
DEFINE   g_rec_b  LIKE type_file.num5  	  #單身筆數
DEFINE   g_cnt          LIKE type_file.num10
DEFINE   g_i            LIKE type_file.num5
DEFINE   g_row_count    LIKE type_file.num10
DEFINE   g_curs_index   LIKE type_file.num10
DEFINE   g_jump         LIKE type_file.num10
DEFINE   g_no_ask      LIKE type_file.num5 
DEFINE   g_cnt1,g_cnt2  LIKE type_file.num5
DEFINE   g_cnt3,g_cnt4  LIKE type_file.num5
DEFINE   g_cnt5         LIKE type_file.num5     #FUN-B70059
DEFINE   g_sql          STRING
DEFINE   g_bookno1      LIKE aza_file.aza81
DEFINE   g_bookno2      LIKE aza_file.aza81
DEFINE   g_flag         LIKE type_file.chr1

MAIN
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP                      #輸入的方式: 不打轉
   DEFER INTERRUPT                         #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   OPEN WINDOW q703_w WITH FORM "agl/42f/aglq703"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   CALL q703_menu()
   CLOSE WINDOW q703_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

#QBE 查詢資料
FUNCTION q703_cs()
   DEFINE   l_cnt LIKE type_file.num5
   DEFINE   l_sql LIKE type_file.chr1000
   DEFINE   l_buf STRING

   CLEAR FORM #清除畫面
   CALL g_omb.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL		 # Default condition
   CALL cl_set_head_visible("","YES")
   LET tm.npqtype_1 = '0'
   DISPLAY BY NAME tm.npqtype_1

   CONSTRUCT BY NAME tm.wc ON oma02
     
      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      AFTER FIELD oma02
         LET l_buf = GET_FLDBUF(oma02)
         IF cl_null(l_buf) THEN
            CALL cl_err('oma02','aap-099',0)
            NEXT FIELD oma02
         END IF

      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION qbe_save
         CALL cl_qbe_save()

      ON ACTION qbe_select
         CALL cl_qbe_select()
 
   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF
   INPUT BY NAME tm.npqtype_1 WITHOUT DEFAULTS
      BEFORE INPUT
         IF g_aza.aza63 = 'Y' THEN
            CALL cl_set_comp_entry("npqtype_1",TRUE)
         ELSE
            CALL cl_set_comp_entry("npqtype_1",FALSE)
         END IF
      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   END INPUT
   IF INT_FLAG THEN RETURN END IF
 
END FUNCTION

FUNCTION q703_menu()

   WHILE TRUE
      CALL q703_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q703_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_omb),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION q703_q()

    CALL q703_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL q703_b_fill()
END FUNCTION

FUNCTION q703_b_fill()              #BODY FILL UP
   DEFINE l_sql           STRING
   DEFINE l_oma    RECORD LIKE oma_file.*
   DEFINE l_omb    RECORD LIKE omb_file.*
   DEFINE l_oct    RECORD LIKE oct_file.*
   DEFINE l_cnt           LIKE type_file.num5
   DEFINE l_bdate,l_edate LIKE npp_file.npp02
   DEFINE l_oct1   RECORD
           oct00          LIKE oct_file.oct00,
           oct01          LIKE oct_file.oct01,
           oct02          LIKE oct_file.oct02,
           oct09          LIKE oct_file.oct09,
           oct10          LIKE oct_file.oct10,
           oct11          LIKE oct_file.oct11,
           oct13          LIKE oct_file.oct13
              END RECORD
   DEFINE l_oct2   RECORD
           oct03          LIKE oct_file.oct03,
           oct00          LIKE oct_file.oct00,
           oct04          LIKE oct_file.oct04,
           oct05          LIKE oct_file.oct05,
           oct08          LIKE oct_file.oct08,
           oct09          LIKE oct_file.oct09,
           oct10          LIKE oct_file.oct10,
           oct22          LIKE oct_file.oct22,
           oct11          LIKE oct_file.oct11,
           oct13          LIKE oct_file.oct13,
           oct12          LIKE oct_file.oct12,
           oct20          LIKE oct_file.oct20        #TQC-B80254
              END RECORD

   DEFINE l_npq    RECORD
           npqtype        LIKE npq_file.npqtype,
           npq28          LIKE npq_file.npq28,
           npq03          LIKE npq_file.npq03,
           npq07          LIKE npq_file.npq07
              END RECORD

   DEFINE l_abb00         LIKE abb_file.abb00
   DEFINE l_abb01         LIKE abb_file.abb01
   DEFINE l_abb02         LIKE abb_file.abb02
   DEFINE l_abb03         LIKE abb_file.abb03
   DEFINE l_abb07         LIKE abb_file.abb07
   DEFINE l_ocs_cnt       LIKE type_file.num5
   DEFINE l_ocs    RECORD LIKE ocs_file.*
   DEFINE l_npq07f        LIKE npq_file.npq07f
   DEFINE l_aaa03         LIKE aaa_file.aaa03
   DEFINE l_azi04_2       LIKE azi_file.azi04
   DEFINE l_npq25         LIKE npq_file.npq25
   DEFINE l_yy            LIKE type_file.num5
   DEFINE l_mm            LIKE type_file.num5
   DEFINE l_oct09         LIKE oct_file.oct09
   DEFINE l_oct10         LIKE oct_file.oct10
   DEFINE l_abb03_1       LIKE abb_file.abb03   #TQC-B80254            

   LET l_sql=" SELECT oma_file.*,omb_file.* ",
             "   FROM oma_file,omb_file",
             "  WHERE oma01 = omb01",
             "    AND omaconf = 'Y' ",
             "    AND (oma00='12' OR oma00 = '21')",
             "    AND ",tm.wc
   PREPARE q703_pb FROM l_sql
   DECLARE q703_bcs                       #BODY CURSOR
        CURSOR FOR q703_pb


   CALL g_omb.clear()
   LET g_rec_b=0
   LET g_cnt = 1

   FOREACH q703_bcs INTO l_oma.*,l_omb.*
      IF STATUS THEN
         CALL cl_err("foreach",STATUS,1)
         EXIT FOREACH
      END IF

      IF l_omb.omb00='12' THEN
         LET l_sql = "SELECT npqtype,npq28,npq03,npq07",
                     "  FROM npq_file",
                     " WHERE npq01 = '",l_omb.omb01,"'",
                     "   AND npq29 = '",l_omb.omb03,"'",
                     "   AND npqsys= 'AR' ",
                     "   AND npq011= '1' ",
                     "   AND npq28 IS NOT NULL ",
                     "   AND npq00 = '2' ",
                     "   AND npqtype = '",tm.npqtype_1,"'",
                     "ORDER BY npqtype,npq28,npq03"
         PREPARE q703_pb1 FROM l_sql
         DECLARE q703_bcs1                       #BODY CURSOR
              CURSOR FOR q703_pb1
         FOREACH q703_bcs1 INTO l_npq.*
            IF STATUS THEN
               CALL cl_err("foreach q703_bcs1",STATUS,1)
               EXIT FOREACH
            END IF
            SELECT COUNT(*) INTO l_cnt
              FROM oct_file
             WHERE oct00 = l_npq.npqtype
               AND oct01 = l_omb.omb01
               AND oct02 = l_omb.omb03
               AND oct11 = l_npq.npq28
               AND oct16 = '1'
            IF l_cnt = 0 THEN
               LET g_omb[g_cnt].type    = '1'
               LET g_omb[g_cnt].npqtype = l_npq.npqtype
               LET g_omb[g_cnt].omb00   = l_omb.omb00
               LET g_omb[g_cnt].omb01   = l_omb.omb01
               LET g_omb[g_cnt].omb03   = l_omb.omb03
               LET g_omb[g_cnt].omb04   = l_omb.omb04
               LET g_omb[g_cnt].npq28   = l_npq.npq28
               LET g_omb[g_cnt].npq03   = l_npq.npq03
               LET g_omb[g_cnt].npq07   = l_npq.npq07
               SELECT ima02 INTO g_omb[g_cnt].ima02
                 FROM ima_file
                WHERE ima01 = g_omb[g_cnt].omb04
               IF g_omb[g_cnt].npqtype = '0' THEN
                  SELECT aag02 INTO g_omb[g_cnt].aag02_1
                    FROM aag_file
                   WHERE aag00 = g_aza.aza81
                     AND aag01 = l_npq.npq03
               ELSE
                  SELECT aag02 INTO g_omb[g_cnt].aag02_1
                    FROM aag_file
                   WHERE aag00 = g_aza.aza82
                     AND aag01 = l_npq.npq03
               END IF
               LET g_cnt=g_cnt+1
               IF g_cnt>g_max_rec THEN
            #     CALL cl_err("",9035,0)
                  EXIT FOREACH
               END IF
            ELSE
               SELECT * INTO l_oct.*
                 FROM oct_file
                WHERE oct00 = l_npq.npqtype
                  AND oct01 = l_omb.omb01
                  AND oct02 = l_omb.omb03
                  AND oct11 = l_npq.npq28
                  AND oct16 = '1'
               IF l_npq.npq07 <> l_oct.oct12 THEN
                  LET g_omb[g_cnt].npqtype = l_npq.npqtype
                  LET g_omb[g_cnt].omb00   = l_omb.omb00
                  LET g_omb[g_cnt].omb01   = l_omb.omb01
                  LET g_omb[g_cnt].omb03   = l_omb.omb03
                  LET g_omb[g_cnt].omb04   = l_omb.omb04
                  LET g_omb[g_cnt].npq28   = l_npq.npq28
                  LET g_omb[g_cnt].npq03   = l_npq.npq03
                  LET g_omb[g_cnt].npq07   = l_npq.npq07
                  SELECT ima02 INTO g_omb[g_cnt].ima02
                    FROM ima_file
                   WHERE ima01 = g_omb[g_cnt].omb04
                  LET g_omb[g_cnt].type = '2'
                  IF g_omb[g_cnt].npqtype = '0' THEN
                     SELECT aag02 INTO g_omb[g_cnt].aag02_1
                       FROM aag_file
                      WHERE aag00 = g_aza.aza81
                        AND aag01 = l_npq.npq03
                     SELECT aag02 INTO g_omb[g_cnt].aag02_2
                       FROM aag_file
                      WHERE aag00 = g_aza.aza81
                        AND aag01 = l_oct.oct13
                  ELSE
                     SELECT aag02 INTO g_omb[g_cnt].aag02_1
                       FROM aag_file
                      WHERE aag00 = g_aza.aza82
                        AND aag01 = l_npq.npq03
                     SELECT aag02 INTO g_omb[g_cnt].aag02_2
                       FROM aag_file
                      WHERE aag00 = g_aza.aza82
                        AND aag01 = l_oct.oct13
                  END IF
                  LET g_omb[g_cnt].oct12 = l_oct.oct12
                  LET g_omb[g_cnt].oct13 = l_oct.oct13
                  LET g_cnt=g_cnt+1
                  IF g_cnt>g_max_rec THEN
                  #  CALL cl_err("",9035,0)
                     EXIT FOREACH
                  END IF
               END IF
            END IF
         END FOREACH
         LET l_sql = " SELECT oct00,oct01,oct02,oct09,oct10,oct11,oct13 ",
                     "   FROM oct_file,oma_file ",
                     "  WHERE oct16 = '1' ",
                     "    AND oct01 = '",l_oma.oma01,"'",
                     "    AND oct01 = oma01 ",
                     "    AND oma00 = '12' ",
                     "    AND ",tm.wc
         PREPARE q703_pb2 FROM l_sql
         DECLARE q703_bcs2                       #BODY CURSOR
              CURSOR FOR q703_pb2
         FOREACH q703_bcs2 INTO l_oct1.*
            IF STATUS THEN
               CALL cl_err("foreach q703_bcs2",STATUS,1)
               EXIT FOREACH
            END IF
            LET l_bdate = MDY(l_oct1.oct10,1,l_oct1.oct09)
            LET l_oct10 = l_oct1.oct10 + 1
            LET l_oct09 = l_oct1.oct09
            IF l_oct10 = 13 THEN LET l_oct10=1 LET l_oct09=l_oct09+1 END IF
            LET l_edate = MDY(l_oct10,1,l_oct09)-1
            SELECT COUNT(*) INTO l_cnt
              FROM npp_file,npq_file
             WHERE npp01 = npq01
               AND npptype=npqtype
               AND npp02 BETWEEN l_bdate AND l_edate
               AND npqsys = 'AR'
               AND npq011 = '1'
               AND npq00  = '2'
               AND npqtype= tm.npqtype_1
               AND npq01  = l_oct1.oct01
               AND npq03  = l_oct1.oct13
               AND npq29  = l_oct1.oct02
               AND npq28  = l_oct1.oct11
            IF l_cnt = 0 THEN
               LET g_omb[g_cnt].npqtype = tm.npqtype_1
               LET g_omb[g_cnt].omb00   = l_omb.omb00
               LET g_omb[g_cnt].omb01   = l_omb.omb01
               LET g_omb[g_cnt].omb03   = l_omb.omb03
               LET g_omb[g_cnt].omb04   = l_omb.omb04
               LET g_omb[g_cnt].type    = '3'
               LET g_omb[g_cnt].oct12   = l_oct.oct12
               LET g_omb[g_cnt].oct13   = l_oct.oct13
               SELECT ima02 INTO g_omb[g_cnt].ima02
                 FROM ima_file
                WHERE ima01 = g_omb[g_cnt].omb04
               IF g_omb[g_cnt].npqtype = '0' THEN
                  SELECT aag02 INTO g_omb[g_cnt].aag02_2
                    FROM aag_file
                   WHERE aag00 = g_aza.aza81
                     AND aag01 = g_omb[g_cnt].oct13
               ELSE
                  SELECT aag02 INTO g_omb[g_cnt].aag02_2
                    FROM aag_file
                   WHERE aag00 = g_aza.aza82
                     AND aag01 = g_omb[g_cnt].oct13
               END IF
               LET g_cnt=g_cnt+1
               IF g_cnt>g_max_rec THEN
            #     CALL cl_err("",9035,0)
                  EXIT FOREACH
               END IF
            END IF
         END FOREACH
#        LET l_sql = "SELECT oct_file.*",
#                    "  FROM oct_file,oma_file",
#                    " WHERE oct16 = '2'",
#                    "   AND oct01 = '",l_oma.oma01,"'",
#                    "   AND oct00 = '12'",
#                    "   AND ",tm.wc
#        PREPARE q703_pb3 FROM l_sql
#        DECLARE q703_bcs3                       #BODY CURSOR
#             CURSOR FOR q703_pb3
#        FOREACH q703_bcs3 INTO l_oct1.*
#           IF STATUS THEN
#              CALL cl_err("foreach q703_bcs2",STATUS,1)
#              EXIT FOREACH
#           END IF
#           IF l_oct.oct08 IS NOT NULL THEN
#              IF l_oct.oct00 = '0' THEN
#                 LET l_oct.oct00 = g_aza.aza81
#              ELSE
#                 LET l_oct.oct00 = g_aza.aza82
#              END IF
#           END IF
#           SELECT abb01,abb02,abb03,abb07 INTO l_abb01,l_abb02,l_abb03,l_abb07
#             FROM abb_file
#            WHERE abb00 = l_oct.oct00
#              AND abb02 = l_oct.oct22
#              AND abb03 = l_oct.oct13
#           IF l_abb07 <> l_oct.oct14 THEN
#              LET g_omb[g_cnt].npqtype = l_oct.oct00
#              LET g_omb[g_cnt].omb00   = l_omb.omb00
#              LET g_omb[g_cnt].omb01   = l_omb.omb01
#              LET g_omb[g_cnt].omb03   = l_omb.omb03
#              LET g_omb[g_cnt].npq28   = l_oct.oct11
#              LET g_omb[g_cnt].type    = '4'
#              LET g_omb[g_cnt].oct12   = l_oct.oct14
#              LET g_omb[g_cnt].oct13   = l_oct.oct13
#              LET g_omb[g_cnt].abb01   = l_abb01
#              LET g_omb[g_cnt].abb02   = l_abb02
#              LET g_omb[g_cnt].abb03   = l_abb03
#              LET g_omb[g_cnt].abb07   = l_abb07
#              SELECT ima02 INTO g_omb[g_cnt].ima02
#                FROM ima_file
#               WHERE ima01 = g_omb[g_cnt].omb04
#              IF g_omb[g_cnt].npqtype = '0' THEN
#                 SELECT aag02 INTO g_omb[g_cnt].aag02_2
#                   FROM aag_file
#                  WHERE aag00 = g_aza.aza81
#                    AND aag01 = g_omb[g_cnt].oct13
#              ELSE
#                 SELECT aag02 INTO g_omb[g_cnt].aag02_2
#                   FROM aag_file
#                  WHERE aag00 = g_aza.aza82
#                    AND aag01 = g_omb[g_cnt].oct13
#              END IF
#           END IF
#        END FOREACH
      ELSE
         CALL q703_chk_ocs(l_oma.*,l_omb.*) RETURNING l_ocs_cnt #檢查是否有設定售貨基本資料
         CASE
            WHEN g_cnt1 > 0 
               LET g_sql = "SELECT * FROM ocs_file",
                           " WHERE ocs012 = '",l_omb.omb04,"'",
                           "   AND ocs011 = '",l_oma.oma03,"'",
                           "   AND (ocs01 IS NULL OR ocs01 = ' ')"
            WHEN g_cnt4 > 0 
               LET g_sql = "SELECT ocs_file.* FROM ocs_file,ima_file ",
                           " WHERE ima01 = '",l_omb.omb04,"'",
                           "   AND ima131=ocs01",
                           "   AND ocs011='",l_oma.oma03,"'",
                           "   AND (ocs012 IS NULL OR ocs12 = ' ')"
            WHEN g_cnt2 >0 
               LET g_sql = "SELECT * FROM ocs_file",
                           " WHERE ocs012='",l_omb.omb04,"'",
                           "   AND (ocs011 IS NULL OR ocs011=' ')",
                           "   AND (ocs01 IS NULL OR ocs01=' ')"
            WHEN g_cnt3 > 0
              #LET g_sql = "SELECT * FROM ocs_file",                   #FUN-B70059 原SQL語句有誤,漏寫ima_file
               LET g_sql = "SELECT * FROM ocs_file,ima_file ",
                           " WHERE ima01='",l_omb.omb04,"'",
                           "   AND ima131=ocs01 ",
                           "   AND ocs011=' ' AND ocs012=' ')"
           #FUN-B70059--begin
            WHEN g_cnt5 > 0 #客戶
                LET g_sql="SELECT * FROM ocs_file",
                          " WHERE ocs011='",l_oma.oma03,"'",           #客戶編號
                          "   AND (ocs012 IS NULL OR ocs012 = ' ')",   #料號
                          "   AND (ocs01 IS NULL OR ocs01 = ' ')"
           #FUN-B70059--end
         END CASE
         PREPARE q703_gl_pre2 FROM g_sql
         DECLARE q703_gl_cs2 CURSOR WITH HOLD FOR q703_gl_pre2
         INITIALIZE l_ocs.* TO NULL
         LET l_npq.npq07=0
         LET l_npq07f=0
         FOREACH q703_gl_cs2 INTO l_ocs.*
            IF STATUS THEN
               CALL cl_err("foreach q703_bcs2",STATUS,1)
               EXIT FOREACH
            END IF
            CALL q703_def_cnt(l_oma.*,l_omb.*,l_ocs.ocs04) 
                   RETURNING l_npq.npq07,l_npq07f
            IF tm.npqtype_1 = '0' THEN
               LET l_npq.npq03 = l_ocs.ocs03
            ELSE
               LET l_npq.npq03 = l_ocs.ocs031
            END IF

            IF l_npq.npq07 <> 0 THEN
               IF tm.npqtype_1 = '1' THEN
                  CALL s_get_bookno(YEAR(l_oma.oma02)) 
                       RETURNING g_flag,g_bookno1,g_bookno2
                  SELECT aaa03 INTO l_aaa03 FROM aaa_file
                   WHERE aaa01 = g_aza.aza82
                  SELECT azi04 INTO l_azi04_2 FROM azifile
                   WHERE azi01 = l_aaa03
                  CALL s_newrate(g_bookno1,g_bookno2,l_oma.oma23,l_oma.oma24,l_oma.oma02)
                       RETURNING l_npq25
                  LET l_npq.npq07 = l_npq07f * l_npq25
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,l_azi04_2)
               ELSE
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
               END IF
            END IF
            SELECT COUNT(*) INTO l_cnt
              FROM oct_file
             WHERE oct00 = tm.npqtype_1
               AND oct01 = l_omb.omb01
               AND oct02 = l_omb.omb03
               AND oct11 = l_ocs.ocs02
               AND oct16 = '3'
            IF l_cnt = 0 THEN
               LET g_omb[g_cnt].npqtype = tm.npqtype_1
               LET g_omb[g_cnt].omb00   = l_omb.omb00
               LET g_omb[g_cnt].omb01   = l_omb.omb01
               LET g_omb[g_cnt].omb03   = l_omb.omb03
               LET g_omb[g_cnt].omb04   = l_omb.omb04
               LET g_omb[g_cnt].npq28   = l_ocs.ocs02
               LET g_omb[g_cnt].type    = '1'
               LET g_omb[g_cnt].npq03   = l_npq.npq03
               LET g_omb[g_cnt].npq07   = l_npq.npq07
               SELECT ima02 INTO g_omb[g_cnt].ima02
                 FROM ima_file
                WHERE ima01 = g_omb[g_cnt].omb04
               IF g_omb[g_cnt].npqtype = '0' THEN
                  SELECT aag02 INTO g_omb[g_cnt].aag02_1
                    FROM aag_file
                   WHERE aag00 = g_aza.aza81
                     AND aag01 = g_omb[g_cnt].npq03
               ELSE
                  SELECT aag02 INTO g_omb[g_cnt].aag02_1
                    FROM aag_file
                   WHERE aag00 = g_aza.aza82
                     AND aag01 = g_omb[g_cnt].npq03
               END IF
               LET g_cnt=g_cnt+1
               IF g_cnt>g_max_rec THEN
            #     CALL cl_err("",9035,0)
                  EXIT FOREACH
               END IF
            ELSE
               SELECT * INTO l_oct.*
                 FROM oct_file
                WHERE oct00 = tm.npqtype_1
                  AND oct01 = l_omb.omb01
                  AND oct02 = l_omb.omb03
                  AND oct11 = l_ocs.ocs02
                  AND oct16 = '3'
               IF l_npq.npq07 <> l_oct.oct12 THEN
                  LET g_omb[g_cnt].npqtype = tm.npqtype_1
                  LET g_omb[g_cnt].omb00   = l_omb.omb00
                  LET g_omb[g_cnt].omb01   = l_omb.omb01
                  LET g_omb[g_cnt].omb03   = l_omb.omb03
                  LET g_omb[g_cnt].omb04   = l_omb.omb04
                  LET g_omb[g_cnt].npq28   = l_ocs.ocs02
                  LET g_omb[g_cnt].type    = '2'
                  LET g_omb[g_cnt].npq03   = l_npq.npq03
                  LET g_omb[g_cnt].npq07   = l_npq.npq07
                  LET g_omb[g_cnt].oct12   = l_oct.oct12
                  LET g_omb[g_cnt].oct13   = l_oct.oct13
                  SELECT ima02 INTO g_omb[g_cnt].ima02
                    FROM ima_file
                   WHERE ima01 = g_omb[g_cnt].omb04
                  IF tm.npqtype_1 = '0' THEN
                     SELECT aag02 INTO g_omb[g_cnt].aag02_1
                       FROM aag_file
                      WHERE aag00 = g_aza.aza81
                        AND aag01 = g_omb[g_cnt].npq03

                     SELECT aag02 INTO g_omb[g_cnt].aag02_2
                       FROM aag_file
                      WHERE aag00 = g_aza.aza81
                        AND aag01 = g_omb[g_cnt].oct13
                  ELSE
                     SELECT aag02 INTO g_omb[g_cnt].aag02_1
                       FROM aag_file
                      WHERE aag00 = g_aza.aza82
                        AND aag01 = g_omb[g_cnt].npq03

                     SELECT aag02 INTO g_omb[g_cnt].aag02_2
                       FROM aag_file
                      WHERE aag00 = g_aza.aza82
                        AND aag01 = g_omb[g_cnt].oct13
                  END IF
                  LET g_cnt=g_cnt+1
                  IF g_cnt>g_max_rec THEN
                #    CALL cl_err("",9035,0)
                     EXIT FOREACH
                  END IF
               END IF
            END IF
         END FOREACH
      END IF
      LET l_yy = YEAR(l_oma.oma02)
      LET l_mm = MONTH(l_oma.oma02)
      LET l_sql = "SELECT oct03,oct00,oct04,oct05,oct08,oct09,oct10,oct22,oct11,oct13,",
                  "       SUM(oct14-oct15), ",
                  "       oct20",                       #TQC-B80254
                  "  FROM oct_file ",
                  " WHERE (oct16 = '2' OR oct16 = '4')",
                  "   AND oct00 = '",tm.npqtype_1,"'",
                  "   AND oct09 = ",l_yy,
                  "   AND oct10 = ",l_mm,
                  "   AND oct08 IS NOT NULL",
                  "   AND oct04 = '",l_omb.omb31,"'",   #TQC-B80254
                  " GROUP BY oct03,oct00,oct04,oct05,oct08,oct09,oct10,oct22,oct11,oct13,oct20",   #TQC-B80254
                  " ORDER BY oct09,oct10"
      PREPARE q703_oct_pre FROM l_sql
      DECLARE q703_oct_cs CURSOR WITH HOLD FOR q703_oct_pre
      FOREACH q703_oct_cs INTO l_oct2.*
         IF l_oct2.oct00 = '0' THEN
            LET l_abb00 = g_aza.aza81
         ELSE
            LET l_abb00 = g_aza.aza82
         END IF
        #TQC-B80254--Begin--
         IF cl_null(l_oct2.oct22) THEN
            IF l_oct2.oct12 > 0 THEN
               LET l_abb03_1 = l_oct2.oct20
            ELSE
               LET l_abb03_1 = l_oct2.oct13
            END IF
           #計算匯總會計科目--sum(abb07)
            SELECT abb01,'',abb03,sum(abb07) INTO l_abb01,l_abb02,l_abb03,l_abb07
              FROM abb_file
             WHERE abb00 = l_abb00
               AND abb01 = l_oct2.oct08
               AND abb03 = l_abb03_1
             GROUP BY abb01,abb03
           #計算匯總會計科目--sum(oct14-oct15)
            SELECT SUM(oct14-oct15) INTO l_oct2.oct12
              FROM oct_file 
             WHERE (oct16 = '2' OR oct16 = '4')
               AND oct00 = tm.npqtype_1
               AND oct09 = l_yy
               AND oct10 = l_mm
               AND oct08 = l_oct2.oct08
         ELSE
        #TQC-B80254---End--- 
            SELECT abb01,abb02,abb03,abb07 INTO l_abb01,l_abb02,l_abb03,l_abb07
              FROM abb_file
             WHERE abb00 = l_abb00
               AND abb01 = l_oct2.oct08
               AND abb02 = l_oct2.oct22
         END IF   #TQC-B80254
         IF cl_null(l_abb07) OR l_abb07 <> l_oct2.oct12 THEN
            LET g_omb[g_cnt].npqtype = l_oct2.oct00
            LET g_omb[g_cnt].omb01   = l_oct2.oct04
            LET g_omb[g_cnt].omb00   = l_oma.oma00
            LET g_omb[g_cnt].omb03   = l_oct2.oct05
            LET g_omb[g_cnt].omb04   = l_oct2.oct03
            LET g_omb[g_cnt].npq28   = l_oct2.oct11
            LET g_omb[g_cnt].type    = '4'
            LET g_omb[g_cnt].oct12   = l_oct2.oct12
            LET g_omb[g_cnt].oct13   = l_oct2.oct13
            LET g_omb[g_cnt].abb01   = l_abb01
            LET g_omb[g_cnt].abb02   = l_abb02
            LET g_omb[g_cnt].abb03   = l_abb03
            LET g_omb[g_cnt].abb07   = l_abb07
            SELECT ima02 INTO g_omb[g_cnt].ima02
              FROM ima_file
             WHERE ima01 = g_omb[g_cnt].omb04
            IF l_oct.oct00 = '0' THEN
               SELECT aag02 INTO g_omb[g_cnt].aag02_2
                 FROM aag_file
                WHERE aag00 = g_aza.aza81
                  AND aag01 = g_omb[g_cnt].oct13
               SELECT aag02 INTO g_omb[g_cnt].aag02_3
                 FROM aag_file
                WHERE aag00 = g_aza.aza81
                  AND aag01 = g_omb[g_cnt].abb03
            ELSE
               SELECT aag02 INTO g_omb[g_cnt].aag02_2
                 FROM aag_file
                WHERE aag00 = g_aza.aza82
                  AND aag01 = g_omb[g_cnt].oct13
               SELECT aag02 INTO g_omb[g_cnt].aag02_3
                 FROM aag_file
                WHERE aag00 = g_aza.aza82
                  AND aag01 = g_omb[g_cnt].abb03
            END IF
            LET g_cnt=g_cnt+1
            IF g_cnt>g_max_rec THEN
      #        CALL cl_err("",9035,0)
               EXIT FOREACH
            END IF
         END IF
      END FOREACH
      LET l_yy = YEAR(l_oma.oma02)
      LET l_mm = MONTH(l_oma.oma02)
      LET l_sql = "SELECT oct03,oct00,oct04,oct05,oct08,oct09,oct10,oct22,oct11,oct13,",
                  "       oct12,oct20 ",         #TQC-B80254 add oct20 
                  "  FROM oct_file ",
                  " WHERE oct16 = '3'",
                  "   AND oct00 = '",tm.npqtype_1,"'",
                  "   AND oct09 = ",l_yy,
                  "   AND oct10 = ",l_mm,
                  "   AND oct08 IS NOT NULL",
                  " ORDER BY oct09,oct10"
      PREPARE q703_oct_pre1 FROM l_sql
      DECLARE q703_oct_cs1 CURSOR WITH HOLD FOR q703_oct_pre1
      FOREACH q703_oct_cs1 INTO l_oct2.*
         IF l_oct2.oct00 = '0' THEN
            LET l_abb00 = g_aza.aza81
         ELSE
            LET l_abb00 = g_aza.aza82
         END IF
        #TQC-B80254--Begin--
         IF cl_null(l_oct2.oct22) THEN
           #計算匯總會計科目--sum(abb07)
            SELECT abb01,'',abb03,sum(abb07) INTO l_abb01,l_abb02,l_abb03,l_abb07
              FROM abb_file
             WHERE abb00 = l_abb00
               AND abb01 = l_oct2.oct08
               AND abb03 = l_oct2.oct13
             GROUP BY abb01,abb03
           #計算匯總會計科目--sum(oct12)
            SELECT SUM(oct12) INTO l_oct2.oct12
              FROM oct_file 
             WHERE oct16 = '3'
               AND oct00 = tm.npqtype_1
               AND oct09 = l_yy
               AND oct10 = l_mm
               AND oct08 = l_oct2.oct08 
         ELSE
        #TQC-B80254---End---
            SELECT abb01,abb02,abb03,abb07 INTO l_abb01,l_abb02,l_abb03,l_abb07
              FROM abb_file
             WHERE abb00 = l_abb00
               AND abb01 = l_oct2.oct08
               AND abb02 = l_oct2.oct22
         END IF   #TQC-B80254
         IF cl_null(l_abb07) OR l_abb07 <> l_oct2.oct12 THEN
            LET g_omb[g_cnt].npqtype = l_oct2.oct00
            LET g_omb[g_cnt].omb01   = l_oct2.oct04
            LET g_omb[g_cnt].omb00   = l_oma.oma00
            LET g_omb[g_cnt].omb03   = l_oct2.oct05
            LET g_omb[g_cnt].omb04   = l_oct2.oct03
            LET g_omb[g_cnt].npq28   = l_oct2.oct11
            LET g_omb[g_cnt].type    = '4'
            LET g_omb[g_cnt].oct12   = l_oct2.oct12
            LET g_omb[g_cnt].oct13   = l_oct2.oct13
            LET g_omb[g_cnt].abb01   = l_abb01
            LET g_omb[g_cnt].abb02   = l_abb02
            LET g_omb[g_cnt].abb03   = l_abb03
            LET g_omb[g_cnt].abb07   = l_abb07
            SELECT ima02 INTO g_omb[g_cnt].ima02
              FROM ima_file
             WHERE ima01 = g_omb[g_cnt].omb04
            IF l_oct.oct00 = '0' THEN
               SELECT aag02 INTO g_omb[g_cnt].aag02_2
                 FROM aag_file
                WHERE aag00 = g_aza.aza81
                  AND aag01 = g_omb[g_cnt].oct13
               SELECT aag02 INTO g_omb[g_cnt].aag02_3
                 FROM aag_file
                WHERE aag00 = g_aza.aza81
                  AND aag01 = g_omb[g_cnt].abb03
            ELSE
               SELECT aag02 INTO g_omb[g_cnt].aag02_2
                 FROM aag_file
                WHERE aag00 = g_aza.aza82
                  AND aag01 = g_omb[g_cnt].oct13
               SELECT aag02 INTO g_omb[g_cnt].aag02_3
                 FROM aag_file
                WHERE aag00 = g_aza.aza82
                  AND aag01 = g_omb[g_cnt].abb03
            END IF
            LET g_cnt=g_cnt+1
            IF g_cnt>g_max_rec THEN
      #        CALL cl_err("",9035,0)
               EXIT FOREACH
            END IF
         END IF
      END FOREACH
      IF g_cnt>g_max_rec THEN
         CALL cl_err("",9035,0)
         EXIT FOREACH
      END IF
      
   END FOREACH

   LET g_rec_b=g_cnt-1
   LET g_cnt  = g_rec_b
   DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION

FUNCTION q703_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680098  char(1) 


   IF p_ud <> "G" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_omb TO s_omb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

         CALL cl_show_fld_cont() 

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION accept
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION q703_def_cnt(l_oma,l_omb,l_ocs04)
DEFINE l_omb     RECORD LIKE omb_file.*
DEFINE l_oma     RECORD LIKE oma_file.*
DEFINE l_ocs04   LIKE ocs_file.ocs04
DEFINE l_omb16   LIKE omb_file.omb16
DEFINE l_omb14   LIKE omb_file.omb14
DEFINE l_def     LIKE oct_file.oct12
DEFINE l_def_f   LIKE oct_file.oct12
DEFINE l_azi04_2 LIKE azi_file.azi04
DEFINE l_npq25   LIKE npq_file.npq25
DEFINE l_aaa03   LIKE aaa_file.aaa03
    CALL s_get_bookno(YEAR(l_oma.oma02)) 
         RETURNING g_flag,g_bookno1,g_bookno2
    SELECT aaa03 INTO l_aaa03 FROM aaa_file                                      
     WHERE aaa01 = g_bookno2                                                     
    SELECT azi04 INTO l_azi04_2 FROM azi_file                                    
     WHERE azi01 = l_aaa03 
    SELECT azi04 INTO l_azi04_2 FROM azi_file
     WHERE azi01 = l_aaa03

    LET l_def = 0
    LET l_def_f = 0    　	　	　	　	　	　	　	　	　	　	　	　	　
    LET g_sql="SELECT azi04 FROM azi_file ",
              " WHERE azi01='",l_oma.oma23,"' AND aziacti = 'Y' "
    PREPARE t703_gl_azi_pre FROM g_sql
    DECLARE t703_gl_azi_cs CURSOR FOR t703_gl_azi_pre
    OPEN t703_gl_azi_cs
    FETCH t703_gl_azi_cs INTO t_azi04
    IF STATUS THEN
       LET t_azi04 = 0
    END IF
    CLOSE t703_gl_azi_cs

    #依售貨動作不同，所設定的百分比及期數做遞延收入計算
    LET g_sql="SELECT SUM(omb16),SUM(omb14) ",  
              "  FROM omb_file ",
              " WHERE omb01='",l_omb.omb01,"' ",
              "   AND omb03='",l_omb.omb03,"' "	
    PREPARE t703_gl_omb_1_pre FROM g_sql
    DECLARE t703_gl_omb_1_cs CURSOR FOR t703_gl_omb_1_pre
    OPEN t703_gl_omb_1_cs
    FETCH t703_gl_omb_1_cs INTO l_omb16,l_omb14  #本幣未稅/原幣未稅
    CLOSE t703_gl_omb_1_cs
　   	　	　	　	　	　	　	　	　	　	　	　
    IF tm.npqtype_1 = '1' THEN
       CALL s_newrate(g_bookno1,g_bookno2,l_oma.oma23,
                      l_oma.oma24,l_oma.oma02)
       RETURNING l_npq25
       LET l_omb16 = l_omb14 * l_npq25
       LET l_omb16 = cl_digcut(l_omb16,l_azi04_2)
    END IF

    IF l_omb16 <> 0 THEN
       IF l_oma.oma00 = '12' AND l_omb.omb38 = '2' THEN
           LET l_def= (l_omb16*l_ocs04)/100   #總遞延收入= 銷貨金額 * 百分比
           LET l_def_f= (l_omb14*l_ocs04)/100
       ELSE    
#          LET l_def = ((l_omb16*-1)* l_ocs04)/100   #總遞延收入= 銷貨金額 * 百分比
#          LET l_def_f= ((l_omb14*-1)* l_ocs04)/100
           LET l_def = (l_omb16* l_ocs04)/100   #總遞延收入= 銷貨金額 * 百分比
           LET l_def_f= (l_omb14* l_ocs04)/100
       END IF 
       LET l_def   = cl_digcut(l_def,g_azi04)
       LET l_def_f = cl_digcut(l_def_f,t_azi04)
    END IF
    RETURN l_def,l_def_f
END FUNCTION

FUNCTION q703_chk_ocs(l_oma,l_omb)
DEFINE l_omb RECORD LIKE omb_file.*
DEFINE l_oma RECORD LIKE oma_file.*
DEFINE l_ocs_cnt  LIKE type_file.num10

    LET l_ocs_cnt = 0
    #判斷此料件是否已經建立售貨動作資料
    LET g_sql="SELECT COUNT(*) FROM ocs_file",
              " WHERE ocs012='",l_omb.omb04,"'",   #料號
              "   AND ocs011='",l_oma.oma03,"'",     #客戶編號
              "   AND (ocs01 IS NULL OR ocs01 = ' ')" 
    PREPARE q703_gl_ocs_pre1 FROM g_sql
    DECLARE q703_gl_ocs_cs1 CURSOR FOR q703_gl_ocs_pre1
    OPEN q703_gl_ocs_cs1
    FETCH q703_gl_ocs_cs1 INTO g_cnt1
    LET l_ocs_cnt = g_cnt1
    CLOSE q703_gl_ocs_cs1
    IF g_cnt1 = 0 THEN    
       #  1.客戶編號+料號 > 2.客戶編號 +產品類別 > 3.料號 > 4.產品編號 > 5.客戶
       LET g_sql="SELECT COUNT(*) FROM ocs_file,ima_file ",	　	　	　	　	　	　
                " WHERE ima01='",l_omb.omb04,"' AND ima131=ocs01 ",  #產品類別
                "   AND ocs011='",l_oma.oma03,"'",                   #客戶編號
               #"   AND (ocs012 IS NULL OR ocs12 = ' ')"             #料號     #MOD-AC0033 mark
                "   AND (ocs012 IS NULL OR ocs012 = ' ')"            #料號     #MOD-AC0033
       PREPARE q703_gl_ocs_pre4 FROM g_sql
       DECLARE q703_gl_ocs_cs4 CURSOR FOR q703_gl_ocs_pre4
       OPEN q703_gl_ocs_cs4
       FETCH q703_gl_ocs_cs4 INTO g_cnt4
       LET l_ocs_cnt = g_cnt4
       CLOSE q703_gl_ocs_cs4
       IF g_cnt4 = 0 THEN
          LET g_sql="SELECT COUNT(*) FROM ocs_file",
                    " WHERE ocs012='",l_omb.omb04,"'",  #料號
                    "   AND (ocs011 IS NULL OR ocs011=' ')",
                    "   AND (ocs01 IS NULL OR ocs01 = ' ')"
          PREPARE q703_gl_ocs_pre2 FROM g_sql
          DECLARE q703_gl_ocs_cs2 CURSOR FOR q703_gl_ocs_pre2
          OPEN q703_gl_ocs_cs2
          FETCH q703_gl_ocs_cs2 INTO g_cnt2
          LET l_ocs_cnt = g_cnt2
          CLOSE q703_gl_ocs_cs2
          IF g_cnt2 = 0 THEN   #依產品類別
             LET g_sql="SELECT COUNT(*) FROM ocs_file,ima_file ",
                    " WHERE ima01='",l_omb.omb04,"' AND ima131=ocs01 ",
                    "   AND (ocs011 IS NULL OR ocs011=  ' ')",
                    "   AND (ocs012 IS NULL OR ocs012 = ' ')"
             PREPARE q703_gl_ocs_pre3 FROM g_sql
             DECLARE q703_gl_ocs_cs3 CURSOR FOR q703_gl_ocs_pre3
             OPEN q703_gl_ocs_cs3
             FETCH q703_gl_ocs_cs3 INTO g_cnt3
             LET l_ocs_cnt = g_cnt3
             CLOSE q703_gl_ocs_cs3　	
            #FUN-B70059--begin--
             IF g_cnt3 = 0 THEN   #依客戶
                LET g_sql="SELECT COUNT(*) FROM ocs_file",
                       " WHERE ocs011='",l_oma.oma03,"'",            #客戶編號
                       "   AND (ocs012 IS NULL OR ocs012 = ' ')" ,   #料號
                       "   AND (ocs01 IS NULL OR ocs01 = ' ')"       #產品分類碼
                PREPARE q703_gl_ocs_pre5 FROM g_sql
                DECLARE q703_gl_ocs_cs5 CURSOR FOR q703_gl_ocs_pre5
                OPEN q703_gl_ocs_cs5
                FETCH q703_gl_ocs_cs5 INTO g_cnt5
                LET l_ocs_cnt = g_cnt5
                CLOSE q703_gl_ocs_cs5　 　
             END IF
            #FUN-B70059---end---　
          END IF	　
       END IF
    END IF
    RETURN l_ocs_cnt
END FUNCTION 
#FUN-AB0105
