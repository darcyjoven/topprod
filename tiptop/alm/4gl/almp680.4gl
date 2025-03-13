# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: almp680.4gl
# Descriptions...: 贈禮券遞延金額批次計算作業almp680
# Date & Author..: 12/11/23 By Lori  #FUN-CB0110
# Modify.........: No.CHI-C80041 12/12/20 By bart 排除作廢

DATABASE ds

GLOBALS "../../config/top.global"
#FUN-CB0110

DEFINE tm              RECORD
         yy            LIKE type_file.chr4,
	 mm            LIKE type_file.chr2
                       END RECORD
DEFINE g_msg           LIKE type_file.chr1000
DEFINE l_flag          LIKE type_file.chr1
DEFINE g_sql           STRING
DEFINE g_change_lang   LIKE type_file.chr1

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_bgjob     = ARG_VAL(6)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   WHILE TRUE
      CALL s_showmsg_init()
      LET g_change_lang = FALSE
      IF g_bgjob = 'N' THEN
         CALL p680_tm()
         BEGIN WORK
         CALL p680()
         IF g_success='Y' THEN
            COMMIT WORK
            CALL cl_end2(1) RETURNING l_flag    #批次作業正確結束
         ELSE
            CALL s_showmsg()
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING l_flag    #批次作業失敗
         END IF
         IF l_flag THEN
            CONTINUE WHILE
         ELSE
            CLOSE WINDOW aglp799_w
            EXIT WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p680()
         IF g_success = 'Y' THEN
            COMMIT WORK
         ELSE
            CALL s_showmsg()
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION p680_tm()
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680098 SMALLINT
          l_sw           LIKE type_file.chr1,          #重要欄位是否空白  #No.FUN-680098  char(1)
          l_cmd          LIKE type_file.chr1000,       #No.FUN-680098   char(400)
          lc_cmd         LIKE type_file.chr1000        #NO.FUN-570145   #No.FUN-680098   char(400)
   DEFINE l_j            LIKE type_file.num5

   LET p_row = 2 LET p_col = 26

   OPEN WINDOW p680_w AT p_row,p_col WITH FORM "alm/42f/almp680"
      ATTRIBUTE (STYLE = g_win_style)

   CALL cl_ui_init()
   CALL cl_opmsg('p')
   LET g_bgjob = "N"

   INPUT BY NAME tm.yy,tm.mm,g_bgjob WITHOUT DEFAULTS
      BEFORE INPUT
         LET g_bgjob = 'N'
         DISPLAY g_bgjob TO bgjob

      AFTER FIELD yy
         IF NOT cl_null(tm.yy) THEN
            IF length(tm.yy) <> 4 THEN
               CALL cl_err('','alm-h79',0)
               NEXT FIELD yy
            END IF
            FOR l_j = 1 TO 4
                IF tm.yy[l_j,l_j] NOT MATCHES '[0-9]' THEN
                   CALL cl_err('','alm-h80',0)
                   NEXT FIELD yy
                END IF
            END FOR
         END IF
      AFTER FIELD mm
         IF NOT cl_null(tm.mm) THEN
            IF length(tm.mm) <> 2 THEN
               CALL cl_err('','alm-h81',0)
               NEXT FIELD mm
            END IF
            IF tm.mm[1,1] NOT MATCHES '[01]' THEN
               CALL cl_err('','alm-h82',0)
               NEXT FIELD mm
            END IF
            IF tm.mm[1,1] = '1' THEN
               IF tm.mm[2,2] NOT MATCHES '[012]' THEN
                  CALL cl_err('','alm-h82',0)
                  NEXT FIELD mm
               END IF
            ELSE
               IF tm.mm[2,2] NOT MATCHES '[1-9]' THEN
                  CALL cl_err('','alm-h82',0)
                  NEXT FIELD mm
               END IF
            END IF
         END IF
      ON ACTION CONTROLG
         CALL cl_cmdask()    # Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      ON ACTION locale
         LET g_change_lang = TRUE
      ON ACTION about
         CALL cl_about()
      ON ACTION help
         CALL cl_show_help()
      ON ACTION exit                            #離開功能
         LET INT_FLAG = 1
         EXIT INPUT
   END INPUT

   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'almp680'
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('almp680','9031',1)
      ELSE
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",g_bgjob CLIPPED, "'"
         CALL cl_cmdat('almp680',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p680_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()
   END IF

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p680_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
END FUNCTION

FUNCTION p680()
   DEFINE l_azi04        LIKE azi_file.azi04    #取位基準
   DEFINE l_coupon RECORD
              lqe01      LIKE lqe_file.lqe01,   #券號
              lrz03      LIKE lrz_file.lrz02,   #面額
              lqe06      LIKE lqe_file.lqe06
                   END RECORD
   DEFINE l_oga01        LIKE oga_file.oga01
   DEFINE l_lqe22        LIKE lqe_file.lqe22
   DEFINE l_lqe23        LIKE lqe_file.lqe23 
   DEFINE l_calculating  LIKE type_file.chr1
   DEFINE l_cnt_1        LIKE type_file.num5
   DEFINE l_cnt_2        LIKE type_file.num5
   DEFINE l_cnt_3        LIKE type_file.num5   
   DEFINE i              LIKE type_file.num5
   DEFINE l_slip_cur     LIKE type_file.chr20 
   DEFINE l_lqe23_sum    LIKE lqe_file.lqe23
   DEFINE l_lqe23_sum1   LIKE lqe_file.lqe23
   DEFINE l_lqw12_sum    LIKE lqw_file.lqw12
   DEFINE l_lqw13_sum    LIKE lqw_file.lqw13
   DEFINE l_ogacond      LIKE oga_file.ogacond
   DEFINE l_ogacont      LIKE oga_file.ogacont
   DEFINE l_p680_tmp RECORD  
      lqe06       LIKE lqe_file.lqe06,
      lqe01       LIKE lqe_file.lqe01,
      lrz03       LIKE lrz_file.lrz02,
      slip_num    LIKE rxc_file.rxc01,
      slip_amount LIKE ogb_file.ogb14t,
      coupon_cnt  LIKE lqw_file.lqw12,
      coupon_sum  LIKE lqw_file.lqw13,
      slip_cond   LIKE oga_file.ogacond,
      slip_cont   LIKE oga_file.ogacont,
      lqe22       LIKE lqe_file.lqe22
                     END RECORD

   LET g_success = 'Y'
   LET l_calculating = NULL

   LET g_sql = "SELECT COUNT(*) FROM lqe_file ",
               " WHERE YEAR(lqe07) = '",tm.yy,"' ",
               "   AND MONTH(lqe07) = '",tm.mm,"' ",
               "   AND lqe22 <> 0 ",
               "   AND lqe23 > 0 "
   PREPARE p680_tmp_chk FROM g_sql
   EXECUTE p680_tmp_chk INTO l_cnt_1
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','','CHECK p680_tmp:',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF

   IF l_cnt_1 > 0 THEN
      LET l_calculating = cl_confirm("alm2002")
   ELSE
      LET l_calculating = '1'
   END IF

   IF l_calculating = '1' THEN 

      #依參數的本國幣別取得該幣別的小數為數取位基準
      SELECT azi04 INTO l_azi04
        FROM azi_file,aza_file 
       WHERE azi01 = aza17

      CALL p680_create_tmp()

      #Background Message
      DISPLAY "Start Getting Coupon Information"

      #將計算的營運中心範圍和券號範圍寫入TEMPLETABLE
      LET g_sql = "SELECT lqe01, ", 
                  "       (SELECT lrz02 FROM lrz_file WHERE lrz01 = lqe03),",
                  "       lqe06   ",
                  "  FROM lqe_file,lpx_file ",
                  " WHERE lqe02 = lpx01 ",
                  "   AND lqe17 IN ('1','4') ",                         #券狀態=1(發售),4(已用)
                  "   AND YEAR(lqe07) = '",tm.yy,"' ",                  #發售年份=輸入條件的年份
                  "   AND MONTH(lqe07) = '",tm.mm,"' ",                 #發售月份=輸入條件的月份
                  "   AND lpx15 = 'Y' ",                                #券種已確認 
                  "   AND lpx36 = 'Y' "                                 #券種列入計算遞延金額
      PREPARE p680_pre_01 FROM g_sql 
      DECLARE p680_cur_01 CURSOR FOR p680_pre_01
      FOREACH p680_cur_01 INTO l_coupon.*

         #Background Message
         DISPLAY "Coupon Number/Source Plant Code: ",l_coupon.lqe01," / ",l_coupon.lqe06

         LET l_lqe22 = NULL
        
         SELECT COUNT(*) INTO l_cnt_1 FROM p680_tmp  
          WHERE plant = l_coupon.lqe06
            AND lqe01 = l_coupon.lqe01
         IF l_cnt_1 = 0 THEN
            LET l_lqe22 ='1'    #隨消費贈券
            LET l_oga01 = NULL
            LET g_sql = "SELECT lqw01 FROM ",cl_get_target_table(l_coupon.lqe06,'lqw_file'),
                        "                     WHERE '",l_coupon.lqe01,"' BETWEEN lqw09 AND lqw10"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,l_coupon.lqe06) RETURNING g_sql
            PREPARE p680_oga01 FROM g_sql
            EXECUTE p680_oga01 INTO l_oga01

            IF NOT cl_null(l_oga01) THEN
               LET g_sql = "SELECT COUNT(*) FROM p680_tmp  ",
                           " WHERE slip_num = '",l_oga01,"' ",
                           "   AND plant = '",l_coupon.lqe06,"'",
                           "   AND lqe01 = '",l_coupon.lqe01,"' "
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
               CALL cl_parse_qry_sql(g_sql,l_coupon.lqe06) RETURNING g_sql
               PREPARE p680_tmp_chk1 FROM g_sql
               EXECUTE p680_tmp_chk1 INTO l_cnt_2
               IF SQLCA.sqlcode THEN
                  CALL s_errmsg('','','CHECK p680_tmp(1.1):',SQLCA.sqlcode,1)
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF

               LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_coupon.lqe06,'rxc_file')," , ",cl_get_target_table(l_coupon.lqe06,'ogb_file') ,
                         "  WHERE rxc01 = ogb01 ",
                         "    AND rxc02 = ogb03 ",
                         "    AND (rxc00,rxc01,rxc04) IN (SELECT lqw00,lqw01,lqw03 FROM ",cl_get_target_table(l_coupon.lqe06,'lqw_file'),
                         "                                 WHERE lqw00 = '02' ",
                         "                                   AND lqw01 = '",l_oga01,"') "
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
               CALL cl_parse_qry_sql(g_sql,l_coupon.lqe06) RETURNING g_sql
               PREPARE p680_tmp_chk2 FROM g_sql
               EXECUTE p680_tmp_chk2 INTO l_cnt_3
               IF SQLCA.sqlcode THEN
                  CALL s_errmsg('','','CHECK p680_tmp(1.2):',SQLCA.sqlcode,1)
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF         

               IF l_cnt_2 = 0 AND l_cnt_3 > 0 THEN
                  LET g_sql = "INSERT INTO p680_tmp(plant,lqe01,lrz03,slip_num,slip_amount,coupon_cnt,coupon_sum,slip_cond,slip_cont,lqe22) ",
                              " SELECT '",l_coupon.lqe06,"','",l_coupon.lqe01,"',",l_coupon.lrz03,",ogb01,SUM(ogb14t),",
                              "        (SELECT SUM(lqw12) FROM ",cl_get_target_table(l_coupon.lqe06,'lqw_file')," WHERE lqw01 =  ogb01 ), ",
                              "        (SELECT SUM(lqw13) FROM ",cl_get_target_table(l_coupon.lqe06,'lqw_file')," WHERE lqw01 =  ogb01 ), ",
                              "        (SELECT ogacond FROM ",cl_get_target_table(l_coupon.lqe06,'oga_file')," WHERE oga01 = ogb01), ",
                              "        (SELECT ogacont FROM ",cl_get_target_table(l_coupon.lqe06,'oga_file')," WHERE oga01 = ogb01), ",                            
                              "        '",l_lqe22,"' ",
                              "   FROM ",cl_get_target_table(l_coupon.lqe06,'ogb_file') , 
                              "  WHERE (ogb01,ogb03) IN (SELECT rxc01,rxc02 FROM ",cl_get_target_table(l_coupon.lqe06,'rxc_file'),
                              "                           WHERE (rxc00,rxc01,rxc04) IN (SELECT lqw00,lqw01,lqw03 FROM ",cl_get_target_table(l_coupon.lqe06,'lqw_file'),
                              "                                                          WHERE lqw00 = '02' ",
                              "                                                            AND lqw01 = '",l_oga01,"')) ",
                              "  GROUP BY ogb01 "
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                  CALL cl_parse_qry_sql(g_sql,l_coupon.lqe06) RETURNING g_sql
                  PREPARE p680_tmp_ins1 FROM g_sql
                  EXECUTE p680_tmp_ins1
                  IF SQLCA.sqlcode THEN
                     CALL s_errmsg('','','INSERT INTO p680_tmp(1):',SQLCA.sqlcode,1)
                     LET g_success = 'N'
                     EXIT FOREACH
                  END IF  
               END IF
            END IF

            LET l_lqe22 = '2'    #積分換券單
            LET g_sql = "SELECT COUNT(*) FROM p680_tmp ",
                        " WHERE (slip_num,lqe01) IN (SELECT lrf01,lrf02 FROM ",cl_get_target_table(l_coupon.lqe06,'lrf_file'),
                        "                                                   ,",cl_get_target_table(l_coupon.lqe06,'lrj_file'),
                        "                             WHERE lrf01 = lrj01  AND lrj14 = '0' ",
                        "                               AND lrj10 <> 'X' ",  #CHI-C80041
                        "                               AND lrf02 = '",l_coupon.lqe01,"') ",
                        "   AND plant = '",l_coupon.lqe06,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,l_coupon.lqe06) RETURNING g_sql
            PREPARE p680_tmp_chk3 FROM g_sql
            EXECUTE p680_tmp_chk3 INTO l_cnt_2 
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('','','CHECK p680_tmp(2.1):',SQLCA.sqlcode,1)
               LET g_success = 'N'
               EXIT FOREACH
            END IF

            LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_coupon.lqe06,'lrf_file')," , ",cl_get_target_table(l_coupon.lqe06,'lrj_file') ,
                        "  WHERE lrf01 = lrj01 ",
                        "    AND lrf02 = '",l_coupon.lqe01,"' ",
                        "    AND lrj14 = '0' ",
                        "    AND lrj10 <> 'X' "  #CHI-C80041
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,l_coupon.lqe06) RETURNING g_sql
            PREPARE p680_tmp_chk4 FROM g_sql
            EXECUTE p680_tmp_chk4 INTO l_cnt_3
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('','','CHECK p680_tmp(2.2):',SQLCA.sqlcode,1)
               LET g_success = 'N'
               EXIT FOREACH
            END IF

            IF l_cnt_2 = 0 AND l_cnt_3 > 0 THEN
               LET g_sql = "INSERT INTO p680_tmp(plant,lqe01,lrz03,slip_num,coupon_cnt,coupon_sum,slip_cond,lqe22) ",
                           " SELECT '",l_coupon.lqe06,"', ",
                           "        '",l_coupon.lqe01,"', ",
                                       l_coupon.lrz03,", ",
                           "           lrj01,",
                           "        (SELECT COUNT(lrf01) FROM ",cl_get_target_table(l_coupon.lqe06,'lrf_file')," WHERE lrf01 = lrj01),",
                           "        (SELECT SUM(lrf03) FROM ",cl_get_target_table(l_coupon.lqe06,'lrf_file')," WHERE lrf01 = lrj01),",
                           "           lrj12,",
                           "        '",l_lqe22,"' ",
                           "   FROM ",cl_get_target_table(l_coupon.lqe06,'lrf_file')," , ",cl_get_target_table(l_coupon.lqe06,'lrj_file') ,
                           "  WHERE lrf01 = lrj01 ",
                           "    AND lrf02 = '",l_coupon.lqe01,"' ",
                           "    AND lrj14 = '0' ",
                           "    AND lrj10 <> 'X' "  #CHI-C80041
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
               CALL cl_parse_qry_sql(g_sql,l_coupon.lqe06) RETURNING g_sql
               PREPARE p680_tmp_ins2 FROM g_sql
               EXECUTE p680_tmp_ins2               
               IF SQLCA.sqlcode THEN
                  CALL s_errmsg('','','INSERT INTO p680_tmp(2):',SQLCA.sqlcode,1)
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
            END IF               

            LET l_lqe22 = '3'    #累計消費換券單
            LET g_sql = "SELECT COUNT(*) FROM p680_tmp ",
                        " WHERE (slip_num,lqe01) IN (SELECT lrf01,lrf02 FROM ",cl_get_target_table(l_coupon.lqe06,'lrf_file'),
                        "                                                   ,",cl_get_target_table(l_coupon.lqe06,'lrj_file'),
                        "                             WHERE lrf01 = lrj01  AND lrj14 = '1' ",
                        "                               AND lrj10 <> 'X' ",  #CHI-C80041
                        "                               AND lrf02 = '",l_coupon.lqe01,"') ",
                        "   AND plant = '",l_coupon.lqe06,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,l_coupon.lqe06) RETURNING g_sql
            PREPARE p680_tmp_chk5 FROM g_sql
            EXECUTE p680_tmp_chk5 INTO l_cnt_2
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('','','CHECK p680_tmp(3.1):',SQLCA.sqlcode,1)
               LET g_success = 'N'
               EXIT FOREACH
            END IF

            LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_coupon.lqe06,'lrf_file')," , ",cl_get_target_table(l_coupon.lqe06,'lrj_file') ,
                        "  WHERE lrf01 = lrj01 ",
                        "    AND lrf02 = '",l_coupon.lqe01,"' ",
                        "    AND lrj14 = '1' ",
                        "    AND lrj10 <> 'X' "  #CHI-C80041
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,l_coupon.lqe06) RETURNING g_sql
            PREPARE p680_tmp_chk6 FROM g_sql
            EXECUTE p680_tmp_chk6 INTO l_cnt_3
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('','','CHECK p680_tmp(3.2):',SQLCA.sqlcode,1)
               LET g_success = 'N'
               EXIT FOREACH
            END IF

            IF l_cnt_2 = 0 AND l_cnt_3 > 0 THEN
               LET g_sql = "INSERT INTO p680_tmp(plant,lqe01,lrz03,slip_num,slip_amount,coupon_cnt,coupon_sum,slip_cond,lqe22) ",
                           " SELECT '",l_coupon.lqe06,"', ",
                           "        '",l_coupon.lqe01,"', ",
                                       l_coupon.lrz03,", ",
                           "           lrj01,",
                           "           lrj15,",
                           "        (SELECT COUNT(lrf01) FROM ",cl_get_target_table(l_coupon.lqe06,'lrf_file')," WHERE lrf01 = lrj01),",
                           "        (SELECT SUM(lrf03) FROM ",cl_get_target_table(l_coupon.lqe06,'lrf_file')," WHERE lrf01 = lrj01),",
                           "           lrj12,",
                           "        '",l_lqe22,"' ",                              
                           "   FROM ",cl_get_target_table(l_coupon.lqe06,'lrf_file')," , ",cl_get_target_table(l_coupon.lqe06,'lrj_file') ,
                           "  WHERE lrf01 = lrj01 ",
                           "    AND lrf02 = '",l_coupon.lqe01,"' ",
                           "    AND lrj14 = '1' ",
                           "    AND lrj10 <> 'X' "  #CHI-C80041
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
               CALL cl_parse_qry_sql(g_sql,l_coupon.lqe06) RETURNING g_sql
               PREPARE p680_tmp_ins3 FROM g_sql
               EXECUTE p680_tmp_ins3
               IF SQLCA.sqlcode THEN
                  CALL s_errmsg('','','INSERT INTO p680_tmp(3):',SQLCA.sqlcode,1)
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
            END IF                 
         END IF
      END FOREACH 

      #Background Message
      DISPLAY "End gotten Coupon Information"
      SELECT count(*) INTO l_cnt_3 FROM p680_tmp
      DISPLAY "Total Count For p680_tmp: ",l_cnt_3
      DISPLAY "Start calculating"

      LET l_slip_cur = NULL
      LET i = 0
      LET g_sql = "SELECT * FROM p680_tmp ",
                   "ORDER BY slip_num,lrz03,lqe01 "
      PREPARE p680_tmp_pre FROM g_sql
      DECLARE p680_tmp_cur CURSOR FOR p680_tmp_pre
      FOREACH p680_tmp_cur INTO l_p680_tmp.*

         #Background Message
         DISPLAY "Coupon Numer(Trans): ",l_p680_tmp.slip_num

         IF cl_null(l_slip_cur) OR l_slip_cur <> l_p680_tmp.slip_num THEN
            LET l_slip_cur = l_p680_tmp.slip_num
            LET i = 0
            LET l_lqe23 = 0
            LET l_lqe23_sum = 0
            LET l_lqe23_sum1 = 0
         END IF

         IF l_slip_cur = l_p680_tmp.slip_num THEN
            LET i = i+1
         END IF
         
         IF l_p680_tmp.lqe22 = '2' THEN
            LET l_lqe23     = 0
         ELSE
            #計算總遞延金額 = (總贈券面額/(總消費金額+總贈券面額))*總消費金額
            LET l_lqe23_sum = (l_p680_tmp.coupon_sum/(l_p680_tmp.slip_amount+l_p680_tmp.coupon_sum))*l_p680_tmp.slip_amount
            CALL cl_digcut(l_lqe23_sum,l_azi04) RETURNING l_lqe23_sum
            #計算遞延金額 = (贈券面額/總贈券面額)*總遞延金額
            LET l_lqe23     = (l_p680_tmp.lrz03/l_p680_tmp.coupon_sum)*l_lqe23_sum
            CALL cl_digcut(l_lqe23,l_azi04) RETURNING l_lqe23

            IF l_p680_tmp.coupon_cnt > 1 THEN
               IF i = l_p680_tmp.coupon_cnt THEN
                  LET l_lqe23 = l_lqe23_sum - l_lqe23_sum1
               ELSE
                  LET l_lqe23_sum1 = l_lqe23_sum1 + l_lqe23
               END IF
            END IF
         END IF

         #Backgroup Message
         DISPLAY "Coupon Num/CNT :",l_p680_tmp.lqe01," / ",l_p680_tmp.coupon_cnt
         DISPLAY "Consume Total  :",l_p680_tmp.slip_amount
         DISPLAY "LQE_SUM        :",l_lqe23_sum
         DISPLAY "Coupon/Total   :",l_p680_tmp.lrz03," / ",l_p680_tmp.coupon_sum
         DISPLAY "Source         :",l_p680_tmp.lqe22
         DISPLAY "Amount         :",l_lqe23

         UPDATE lqe_file SET lqe22 = l_p680_tmp.lqe22,
                             lqe23 = l_lqe23
          WHERE lqe01 = l_p680_tmp.lqe01        
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('','','UPDATE lqe_file:',SQLCA.sqlcode,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
      END FOREACH
      
      #Background Message
      DISPLAY "End calculated"  
   END IF
END FUNCTION

FUNCTION p680_create_tmp()
   DROP TABLE p680_tmp ;

   CREATE TEMP TABLE p680_tmp(
      plant       LIKE lqe_file.lqe06,
      lqe01       LIKE lqe_file.lqe01,
      lrz03       LIKE lrz_file.lrz02,
      slip_num    LIKE rxc_file.rxc01,
      slip_amount LIKE ogb_file.ogb14t,
      coupon_cnt  LIKE lqw_file.lqw12,
      coupon_sum  LIKE lqw_file.lqw13,
      slip_cond   LIKE oga_file.ogacond,
      slip_cont   LIKE oga_file.ogacont,
      lqe22       LIKE lqe_file.lqe22);
END FUNCTION
