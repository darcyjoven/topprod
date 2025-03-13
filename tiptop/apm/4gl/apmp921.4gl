# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: apmp921.4gl
# Descriptions...: 更新供應商主廠
# Date & Author..: FUN-720041 07/03/14 BY yiting 
# Modify.........: NO.MOD-740445 07/05/02 BY yiting 
# Modify.........: NO.TQC-970183 09/07/23 BY destiny 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A20077 10/02/10 By Smapmin 抓取評價分數檔時要加上年月的條件
# Modify.........: NO.TQC-AB0018 10/11/03 By Kevin 報表需使用ORDER EXTERNAL BY
# Modify.........: No:MOD-B70216 11/07/22 By Summer 判斷評核等級時需增加等於的判斷
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql     STRING 
DEFINE g_cnt          LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE g_bdate        LIKE type_file.dat
DEFINE g_edate        LIKE type_file.dat            #FUN-720041
DEFINE g_yy           LIKE type_file.chr4
DEFINE g_mm           LIKE type_file.chr2
DEFINE g_date         LIKE type_file.chr6
DEFINE g_score1       LIKE type_file.num20_6
DEFINE g_score2       LIKE type_file.num20_6
DEFINE g_score3       LIKE type_file.num20_6
DEFINE g_i            LIKE type_file.num5
DEFINE g_ppe07_tot    LIKE ppe_file.ppe07
DEFINE g_grade        LIKE type_file.chr1
DEFINE g_len_1        LIKE type_file.num5  #NO.MOD-740445

MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   CREATE TEMP TABLE p921_file(
          pmc01     LIKE pmc_file.pmc01,
          pmc1917   LIKE pmc_file.pmc1917,
          pmc1918   LIKE pmc_file.pmc1918,
          pmc1919   LIKE pmc_file.pmc1919)
 
   CALL p921_p1()
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p921_p1()
   DEFINE l_flag      LIKE type_file.num5     #No.FUN-680136 SMALLINT
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01     #No.FUN-580031
   DEFINE l_month     LIKE type_file.chr2
 
   OPEN WINDOW p921_w WITH FORM "apm/42f/apmp921"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   WHILE TRUE
      IF s_shut(0) THEN RETURN END IF
 
      CLEAR FORM
 
      CONSTRUCT BY NAME g_wc ON pmc01,pmc02 
      
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pmc01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pmc"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmc01
                  NEXT FIELD pmc01
               WHEN INFIELD(pmc02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pmc9"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmc02
                  NEXT FIELD pmc02
            END CASE
      
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
      
         ON ACTION about
            CALL cl_about()
      
         ON ACTION help
            CALL cl_show_help()
      
         ON ACTION controlg
            CALL cl_cmdask()
      
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
      
      END CONSTRUCT
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         RETURN
      END IF
      LET g_yy = year(g_today)
      LET g_mm = month(g_today)
      IF g_mm < 10 AND length(g_mm) < 2 THEN
          LET g_mm = '0',g_mm CLIPPED
      END IF
      DISPLAY g_yy TO FORMONLY.yy
      DISPLAY g_mm TO FORMONLY.mm 
      INPUT g_yy,g_mm,g_score1,g_score2,g_score3 
            WITHOUT DEFAULTS
       FROM yy,mm,score1,score2,score3
 
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about
            CALL cl_about()
       
         ON ACTION help
            CALL cl_show_help()
       
         ON ACTION controlg
            CALL cl_cmdask()
       
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         RETURN
      END IF
 
      IF cl_sure(0,0) THEN
         BEGIN WORK               #No.FUN-710030
         LET g_success = 'Y'
         CALL apmp921()
         CALL s_showmsg()       #No.FUN-710030
         IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_end2(1) RETURNING l_flag
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING l_flag
         END IF
     
         IF l_flag THEN
            CONTINUE WHILE
         ELSE
            EXIT WHILE
         END IF
      END IF
   END WHILE
 
   CLOSE WINDOW p921_w
 
END FUNCTION
 
FUNCTION apmp921()
   DEFINE l_name	LIKE type_file.chr20, 	      # External(Disk) file name        #No.FUN-680136 VARCHAR(20)
          l_sql 	LIKE type_file.chr1000,	      # RDSQL STATEMENT                 #No.FUN-680136 VARCHAR(1000)
          l_za05	LIKE type_file.chr1000,       # No.FUN-680136 VARCHAR(40)
          sr            RECORD
                        pmc01  LIKE pmc_file.pmc01,
                        pmy02  LIKE pmy_file.pmy02,
                        pmc02  LIKE pmc_file.pmc02,
                        pmc03  LIKE pmc_file.pmc03
                        END RECORD
   DEFINE l_pmc01       LIKE pmc_file.pmc01,
          l_pmc1917     LIKE pmc_file.pmc1917,
          l_pmc1918     LIKE pmc_file.pmc1918,
          l_pmc1919     LIKE pmc_file.pmc1919
                             
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET g_wc = g_wc clipped," AND ppeuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET g_wc = g_wc clipped," AND ppegrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET g_wc = g_wc clipped," AND ppgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ppeuser', 'ppegrup')
     #End:FUN-980030
      LET g_date = g_yy,g_mm
      LET g_sql = "SELECT DISTINCT pmc01,pmy02,pmc02,pmc03 ",
                  "  FROM pmc_file,pmy_file,ppe_file",
                  " WHERE pmy01 = pmc02 ",
                  "   AND pmc01 = ppe02 ",
                  "   AND ppe01 = '",g_date,"'",   #MOD-A20077
                  "   AND ",g_wc,
                  " ORDER BY pmc02,pmc01"  #TQC-AB0018
      PREPARE p921_pmc_p FROM g_sql
      DECLARE p921_pmc_c CURSOR FOR p921_pmc_p
      CALL cl_outnam('apmp921') RETURNING l_name
      START REPORT p921_rep TO l_name
      FOREACH p921_pmc_c INTO sr.pmc01,sr.pmy02,sr.pmc02,sr.pmc03
          IF SQLCA.SQLCODE < 0 THEN 
              LET g_success = 'N'
              EXIT FOREACH 
          END IF
          OUTPUT TO REPORT p921_rep(sr.*)
     END FOREACH
     FINISH REPORT p921_rep
     ERROR ' '
     LET g_len = g_len_1   #NO.MOD-740445  #記錄最大的報表寬度
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
     #----列印完循問是否更新供應商主檔-----
     IF g_success = 'Y' THEN
         IF cl_confirm('apm1008') THEN
             LET g_sql = "SELECT pmc01,pmc1917,pmc1918,pmc1919 ",
                         "  FROM p921_file"
             PREPARE p921_p FROM g_sql
             DECLARE p921_c CURSOR FOR p921_p
             FOREACH p921_c INTO l_pmc01,l_pmc1917,l_pmc1918,l_pmc1919
               IF SQLCA.SQLCODE < 0 THEN 
                   LET g_success = 'N' 
                   EXIT FOREACH
               END IF
               UPDATE pmc_file SET pmc1917 =l_pmc1917,
                                   pmc1918 =l_pmc1918,
                                   pmc1919 =l_pmc1919
                WHERE pmc01 = l_pmc01
               IF STATUS THEN
                   CALL cl_err3("upd","p921_file","","",SQLCA.sqlcode,"","upd pmc error",0)  
                   LET g_success = "N"
               END IF
             END FOREACH
         END IF
     END IF
END FUNCTION
 
REPORT p921_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
          l_sql         LIKE type_file.chr1000,       #No.FUN-680136 VARCHAR(1000)
          l_gem02       LIKE gem_file.gem02,
          sr            RECORD
                        pmc01  LIKE pmc_file.pmc01,
                        pmy02  LIKE pmy_file.pmy02,
                        pmc02  LIKE pmc_file.pmc02,
                        pmc03  LIKE pmc_file.pmc03
                        END RECORD
   DEFINE l_ppe03       LIKE ppe_file.ppe03                   
   DEFINE l_ppa03       LIKE ppa_file.ppa03                   
   DEFINE l_cnt         LIKE type_file.num5
   DEFINE l_column      LIKE type_file.num5
   DEFINE l_cnt_1       LIKE type_file.num5
   DEFINE l_column_1    LIKE type_file.num5
   DEFINE l_ppe04       LIKE ppe_file.ppe04
   DEFINE l_ppe04_tot   LIKE ppe_file.ppe04
   DEFINE l_grade       LIKE type_file.chr1
   DEFINE l_ppecnt      LIKE type_file.num5
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
  #ORDER BY sr.pmc01,sr.pmc02
  ORDER EXTERNAL BY sr.pmc02,sr.pmc01  #TQC-AB0018
 
  FORMAT
   PAGE HEADER
      #--計算出本張報表寬度，依評核項目而定---
      LET l_column = 84
      LET g_sql = "SELECT COUNT(*) FROM ppe_file",
                  " WHERE ppe01 = '",g_date,"'",
                  "   AND ppe02 = '",sr.pmc01,"'"
#                 " ORDER BY ppe03 "                              #No.TQC-970183 
      PREPARE p921_ppecnt_p FROM g_sql
      DECLARE p921_ppecnt_c SCROLL CURSOR FOR p921_ppecnt_p
      OPEN p921_ppecnt_c
      FETCH p921_ppecnt_c INTO l_ppecnt
      IF l_ppecnt > 0 THEN 
          LET l_column = l_column + (20 * l_ppecnt)
      END IF
      LET g_len = l_column + 30
      #----------------------------------------
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      PRINT COLUMN g_len-10,g_x[3] CLIPPED,g_pageno USING '<<<'
      FOR g_i = 1 TO g_len LET g_dash2[g_i,g_i] = '=' END FOR
      FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '-' END FOR
      PRINT g_dash2[1,g_len]
      LET l_last_sw = 'n'
      IF g_len > g_len_1 THEN LET g_len_1 = g_len END IF   #NO.MOD-740445
 
#NO.MOD-740445 start-
   BEFORE GROUP OF sr.pmc02
      SKIP TO TOP OF PAGE
   #BEFORE GROUP  OF sr.pmc01
#NO.MOD-740445 end---
      LET l_cnt = 0
      LET l_column = 0
      PRINT g_x[11] CLIPPED,
            COLUMN 11,g_x[12] CLIPPED,
            COLUMN 52,g_x[13] CLIPPED,
            COLUMN 63,g_x[14] CLIPPED;
      #依apmt940料抓出評核項目
      LET g_sql = "SELECT ppe03 FROM ppe_file",
                  " WHERE ppe01 = '",g_date,"'",
                  "   AND ppe02 = '",sr.pmc01,"'",
                  " ORDER BY ppe03 "
      PREPARE p921_ppe_p FROM g_sql
      DECLARE p921_ppe_c CURSOR FOR p921_ppe_p
      LET l_column = 84
      LET l_cnt = 1
      FOREACH p921_ppe_c INTO l_ppe03
          IF SQLCA.SQLCODE < 0 THEN 
              LET g_success = 'N'
              EXIT FOREACH 
          END IF
          SELECT ppa03 INTO l_ppa03
            FROM ppa_file
           WHERE ppa02 = l_ppe03
          IF l_cnt = 1 THEN
              PRINT COLUMN l_column, l_ppa03;
          ELSE
              LET l_column = l_column + 20
              PRINT COLUMN l_column,l_ppa03;
          END IF
          LET l_cnt = l_cnt + 1
      END FOREACH
      IF l_cnt = 1 THEN
          LET l_column = l_column 
      ELSE    
          LET l_column = l_column + 20
      END IF
      PRINT COLUMN l_column,g_x[15] CLIPPED,
            COLUMN (l_column+12),g_x[16] CLIPPED,
            COLUMN (l_column+20),g_x[17] CLIPPED
      LET g_len = l_column + 30
      PRINT g_dash[1,g_len]
 
   ON EVERY ROW
      PRINT COLUMN 1,sr.pmc02 CLIPPED,
            COLUMN 11,sr.pmy02 CLIPPED,
            COLUMN 52,sr.pmc01 CLIPPED,
            COLUMN 63,sr.pmc03 CLIPPED;
      LET g_sql = "SELECT ppe04 FROM ppe_file",
                  " WHERE ppe01 = '",g_date,"'",
                  "   AND ppe02 = '",sr.pmc01,"'",
                  " ORDER BY ppe03 "
      PREPARE p921_ppe_p1 FROM g_sql
      DECLARE p921_ppe_c1 CURSOR FOR p921_ppe_p1
      LET l_column_1 = 84
      LET l_cnt_1 = 1
      FOREACH p921_ppe_c1 INTO l_ppe04
          IF cl_null(l_ppe04) THEN LET l_ppe04 = 0 END IF
          IF SQLCA.SQLCODE < 0 THEN 
              LET g_success = 'N' 
              EXIT FOREACH 
          END IF
          IF l_cnt_1 = 1 THEN
              PRINT COLUMN l_column_1, l_ppe04 USING '##&.&&';
          ELSE
              LET l_column_1 = l_column_1 + 20
              PRINT COLUMN l_column_1,l_ppe04 USING '##&.&&';
          END IF
          LET l_cnt_1 = l_cnt_1 +1 
      END FOREACH 
      IF l_ppecnt = 0 THEN 
          IF l_cnt_1 = 1 THEN
              LET l_column_1 = l_column_1 
          ELSE
              LET l_column_1 = l_column_1 + 20
          END IF
      ELSE
          LET l_column_1 = l_column_1 + 20
      END IF
      #---分數加總---
      LET l_ppe04_tot = 0 
      SELECT SUM(ppe04) INTO l_ppe04_tot  
        FROM ppe_file
       WHERE ppe01 = g_date
         AND ppe02 = sr.pmc01
      IF cl_null(l_ppe04_tot) THEN LET l_ppe04_tot = 0 END IF 
      PRINT COLUMN l_column_1,l_ppe04_tot USING '##&.&#';
 
      #--修正之後總分----
      LET g_ppe07_tot = 0 
      LET l_column_1 = l_column_1 + 12
      SELECT SUM(ppe07) INTO g_ppe07_tot   #修正之後總分
        FROM ppe_file
       WHERE ppe01 = g_date
         AND ppe02 = sr.pmc01
      IF cl_null(g_ppe07_tot) THEN LET g_ppe07_tot = 0 END IF 
      PRINT COLUMN l_column_1,g_ppe07_tot USING '##&.&#';
 
      #--評核等級---
      CASE
          WHEN g_ppe07_tot >= g_score1 #MOD-B70216 add =
              LET g_grade = 'A'
          WHEN (g_ppe07_tot < g_score1) AND (g_ppe07_tot >= g_score2) #MOD-B70216 add =
              LET g_grade = 'B'
          WHEN (g_ppe07_tot < g_score2) AND (g_ppe07_tot >= g_score3) #MOD-B70216 add =
              LET g_grade = 'C'
          OTHERWISE
              LET g_grade = 'D'
      END CASE
      LET l_column_1 = l_column_1 + 8
      PRINT COLUMN l_column_1,g_grade CLIPPED
 
      INSERT INTO p921_file(pmc01,pmc1917,pmc1918,pmc1919)
         VALUES (sr.pmc01,g_date,g_ppe07_tot,g_grade)
         IF STATUS THEN
             CALL cl_err3("ins","p921_file","","",SQLCA.sqlcode,"","ins pmc error",0)  
             LET g_success = "N"
         END IF
 
   ON LAST ROW
      PRINT g_dash2[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED 
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN
              PRINT g_dash2[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED      #No.TQC-6B0095
         ELSE SKIP 2 LINE
      END IF
END REPORT
