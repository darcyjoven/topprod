# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: artr802.4gl
# Descriptions...: 專櫃抽成KEY 統計表
# Date & Author..: No.FUN-B50154 11/05/24 By baogc

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD 
              wc      LIKE type_file.chr1000,
              byear   LIKE type_file.num5,
              bmonth  LIKE type_file.num5,
              eyear   LIKE type_file.num5,
              emonth  LIKE type_file.num5,
              state   LIKE type_file.chr1,
              more    LIKE type_file.chr1 
           END RECORD
DEFINE g_cnt          LIKE type_file.num10 
DEFINE g_i            LIKE type_file.num5 
DEFINE l_table     STRING   
DEFINE g_sql       STRING 
DEFINE g_str       STRING  
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT          
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>  *** ##
   LET g_sql = "tax.type_file.chr1,",
               "shop.rch_file.rch05,",
               "shopname.azw_file.azw08,",
               "saleamt.rci_file.rci07,",
               "accountamt.rce_file.rce05,",
               "saledetail.rci_file.rci07,",
               "saleitem.rci_file.rci04,",
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05"
               
   LET l_table = cl_prt_temptable('artr802',g_sql) CLIPPED 
   IF l_table = -1 THEN EXIT PROGRAM END IF                
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?)"
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
 
   INITIALIZE tm.* TO NULL 
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
 
   IF cl_null(g_bgjob) or g_bgjob = 'N'
      THEN CALL artr802_tm(0,0)
      ELSE CALL artr802()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION artr802_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01 
DEFINE p_row,p_col    LIKE type_file.num5
DEFINE l_year         STRING
 
   LET p_row = 6 LET p_col = 20
 
   OPEN WINDOW artr802_w AT p_row,p_col WITH FORM "art/42f/artr802"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more   = 'N'
   LET tm.byear  = YEAR(g_today)
   LET tm.bmonth = MONTH(g_today)
   LET tm.eyear  = YEAR(g_today)
   LET tm.emonth = MONTH(g_today)
   IF tm.bmonth = '1' THEN
      LET tm.byear  = YEAR(g_today) - 1
      LET tm.bmonth = '12'
      LET tm.eyear  = YEAR(g_today) - 1
      LET tm.emonth = '12'
   END IF
   LET tm.state  = 'Y'
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON rch01,rch05
         BEFORE CONSTRUCT
             CALL cl_qbe_init()

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(rch01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_rch"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rch01
                  NEXT FIELD rch01
               WHEN INFIELD(rch05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_azw"
                  LET g_qryparam.where = " azw01 IN ",g_auth
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rch05
                  NEXT FIELD rch05
            END CASE
 
         ON ACTION locale
            CALL cl_show_fld_cont() 
            LET g_action_choice = "locale"
            EXIT CONSTRUCT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about     
            CALL cl_about()  
 
         ON ACTION HELP      
            CALL cl_show_help()
 
         ON ACTION controlg    
            CALL cl_cmdask()  
 
 
         ON ACTION EXIT
            LET INT_FLAG = 1
            EXIT CONSTRUCT
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rchuser', 'rchgrup')
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW artr802_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
      INPUT BY NAME tm.byear,tm.bmonth,tm.eyear,tm.emonth,tm.state,tm.more WITHOUT DEFAULTS  
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
         AFTER FIELD byear
            IF NOT cl_null(tm.byear) THEN
               IF tm.byear < 0 THEN
                  CALL cl_err('','alm-105',0)
                  NEXT FIELD byear
               END IF
               LET l_year = tm.byear
               IF l_year.getLength() <> 4 THEN
                  CALL cl_err('','alm-672',0)
                  NEXT FIELD byear
               END IF
            END IF

         AFTER FIELD bmonth
            IF NOT cl_null(tm.bmonth) THEN
               IF tm.bmonth > 12 OR tm.bmonth < 1 THEN
                  CALL cl_err('','aom-580',0)
                  NEXT FIELD bmonth
               END IF
            END IF

         AFTER FIELD eyear
            IF NOT cl_null(tm.eyear) THEN
               IF tm.eyear < 0 THEN
                  CALL cl_err('','alm-105',0)
                  NEXT FIELD eyear
               END IF
               LET l_year = tm.eyear
               IF l_year.getLength() <> 4 THEN
                  CALL cl_err('','alm-672',0)
                  NEXT FIELD eyear
               END IF
            END IF

         AFTER FIELD emonth
            IF NOT cl_null(tm.emonth) THEN
               IF tm.emonth > 12 OR tm.emonth < 1 THEN
                  CALL cl_err('','aom-580',0)
                  NEXT FIELD emonth
               END IF
            END IF 

         AFTER FIELD more
            IF tm.more NOT MATCHES '[YN]' OR tm.more IS NULL THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                  g_bgjob,g_time,g_prtway,g_copies)
                  RETURNING g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies
            END IF

         AFTER INPUT
            IF NOT cl_null(tm.byear) AND NOT cl_null(tm.eyear) AND NOT cl_null(tm.bmonth) AND NOT cl_null(tm.emonth) THEN
               IF tm.byear > tm.eyear THEN
                  CALL cl_err('','art-726',0)
                  CONTINUE INPUT
               END IF
               IF tm.byear = tm.eyear THEN
                  IF tm.bmonth > tm.emonth THEN
                     CALL cl_err('','art-726',0)
                     CONTINUE INPUT
                  END IF
               END IF
            END IF

         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG 
            CALL cl_cmdask()  
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about       
            CALL cl_about()     
 
         ON ACTION help        
            CALL cl_show_help() 
 
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW artr802_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL artr802()
      ERROR ""
   END WHILE
   CLOSE WINDOW artr802_w
END FUNCTION
 
FUNCTION artr802()
DEFINE l_sql     LIKE type_file.chr1000,
       bdate     LIKE type_file.dat,
       edate     LIKE type_file.dat
DEFINE l_days    LIKE type_file.num5
DEFINE l_bdate   LIKE type_file.dat
DEFINE l_edate   LIKE type_file.dat
DEFINE l_shop    LIKE rch_file.rch01
DEFINE l_rci04   LIKE rci_file.rci04
DEFINE l_tqa02   LIKE tqa_file.tqa02
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_cnt1    LIKE type_file.num5
DEFINE l_tax     LIKE type_file.chr1
DEFINE sr           RECORD
                 tax          LIKE type_file.chr1,
                 shop         LIKE rch_file.rch05,
                 shopname     LIKE azw_file.azw08,
                 saleamt      LIKE rci_file.rci07,
                 accountamt   LIKE rce_file.rce05, 
                 saledetail   LIKE rci_file.rci07,
                 saleitem     LIKE rci_file.rci04
                    END RECORD
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>>  *** ##
   CALL cl_del_data(l_table)
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'artr802'
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog

     LET l_days = cl_days(tm.eyear,tm.emonth)
     LET bdate  = MDY(tm.bmonth,1,tm.byear)
     LET edate  = MDY(tm.emonth,l_days,tm.eyear)
 
     LET l_sql = "SELECT DISTINCT rch05 ",
                 "  FROM rch_file ",
                 " WHERE ",tm.wc,
                 "   AND rch03 BETWEEN '",tm.byear,"' AND '",tm.eyear,"' ",
                 "   AND rch04 BETWEEN '",tm.bmonth,"' AND '",tm.emonth,"' ",
                 "   AND rch05 IN ",g_auth
     CASE tm.state
        WHEN "Y"
           LET l_sql = l_sql," AND rchconf = 'Y'"
        WHEN "N"
           LET l_sql = l_sql," AND rchconf = 'N'"
        WHEN "A"
           LET l_sql = l_sql," AND rchconf <> 'X'"
     END CASE

     PREPARE sel_rch_pre FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM 
     END IF
     DECLARE sel_rch_cs CURSOR FOR sel_rch_pre
     FOREACH sel_rch_cs INTO l_shop
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
     
        LET l_sql = "SELECT SUM(rce04) ",
                    "  FROM ",cl_get_target_table(l_shop,'rce_file'),
                    "      ,",cl_get_target_table(l_shop,'rcd_file'),
                    " WHERE rcd01 = rce01 ",
                    "   AND rcdplant = ? ",
                    "   AND rcd02 BETWEEN '",bdate,"' AND '",edate,"' AND rcd04 = ?"
        CASE tm.state
           WHEN "Y"
              LET l_sql = l_sql," AND rcdconf = 'Y'"
           WHEN "N"
              LET l_sql = l_sql," AND rcdconf = 'N'"
           WHEN "A"
              LET l_sql = l_sql," AND rcdconf <> 'X'"
        END CASE

        PREPARE sel_rce_pre1 FROM l_sql
        IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time
           EXIT PROGRAM 
        END IF
        DECLARE sel_rce_cs1 CURSOR FOR sel_rce_pre1
     
        LET l_sql = "SELECT SUM(rce05) ",
                    "  FROM ",cl_get_target_table(l_shop,'rce_file'),
                    "      ,",cl_get_target_table(l_shop,'rcd_file'),
                    " WHERE rcd01 = rce01 ",
                    "   AND rcdplant = ? ",
                    "   AND rcd02 BETWEEN '",bdate,"' AND '",edate,"' AND rcd04 = ?"
        CASE tm.state
           WHEN "Y"
              LET l_sql = l_sql," AND rcdconf = 'Y'"
           WHEN "N"
              LET l_sql = l_sql," AND rcdconf = 'N'"
           WHEN "A"
              LET l_sql = l_sql," AND rcdconf <> 'X'"
        END CASE

        PREPARE sel_rce_pre2 FROM l_sql
        IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time
           EXIT PROGRAM 
        END IF
     
        LET l_sql = "SELECT rch05,rci06,SUM(rci07) ",
                    "  FROM rci_file,rch_file",
                    " WHERE rch01 = rci01 ",
                    "   AND rch03 BETWEEN '",tm.byear,"' AND '",tm.eyear,"' ",
                    "   AND rch04 BETWEEN '",tm.bmonth,"' AND '",tm.emonth,"' ",
                    "   AND rch05 = ? ",
                    "   AND rci02 = '1'"
        CASE tm.state
           WHEN "Y"
              LET l_sql = l_sql," AND rchconf = 'Y'"
           WHEN "N"
              LET l_sql = l_sql," AND rchconf = 'N'"
           WHEN "A"
              LET l_sql = l_sql," AND rchconf <> 'X'"
        END CASE
        LET l_sql = l_sql," GROUP BY rch05,rci06"

        PREPARE sel_rci_pre1 FROM l_sql
        IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time
           EXIT PROGRAM 
        END IF
        DECLARE sel_rci_cs1 CURSOR FOR sel_rci_pre1

        LET l_sql = "SELECT SUM(rci07) ",
                    "  FROM rci_file,rch_file",
                    " WHERE rch01 = rci01 ",
                    "   AND rch03 BETWEEN '",tm.byear,"' AND '",tm.eyear,"' ",
                    "   AND rch04 BETWEEN '",tm.bmonth,"' AND '",tm.emonth,"' ",
                    "   AND rch05 = ? ",
                    "   AND rci06 = ? ",
                    "   AND rci04 = ? ",
                    "   AND rci02 = '1'"
        CASE tm.state
           WHEN "Y"
              LET l_sql = l_sql," AND rchconf = 'Y'"
           WHEN "N"
              LET l_sql = l_sql," AND rchconf = 'N'"
           WHEN "A"
              LET l_sql = l_sql," AND rchconf <> 'X'"
        END CASE

        PREPARE sel_rci_pre2 FROM l_sql
        IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time
           EXIT PROGRAM 
        END IF

        LET l_sql = "SELECT DISTINCT rci04 ",
                    "  FROM rci_file,rch_file",
                    " WHERE rch01 = rci01 ",
                    "   AND rch03 BETWEEN '",tm.byear,"' AND '",tm.eyear,"' ",
                    "   AND rch04 BETWEEN '",tm.bmonth,"' AND '",tm.emonth,"' ",
                    "   AND rch05 = ?",
                    "   AND rci06 = ?"
        CASE tm.state
           WHEN "Y"
              LET l_sql = l_sql," AND rchconf = 'Y'"
           WHEN "N"
              LET l_sql = l_sql," AND rchconf = 'N'"
           WHEN "A"
              LET l_sql = l_sql," AND rchconf <> 'X'"
        END CASE

        LET l_sql = l_sql," ORDER BY rci04"
        PREPARE sel_rci_pre3 FROM l_sql
        IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time
           EXIT PROGRAM 
        END IF
        DECLARE sel_rci_cs3 CURSOR FOR sel_rci_pre3

        FOREACH sel_rci_cs1 USING l_shop INTO sr.shop,sr.tax,sr.accountamt
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
           END IF
           LET sr.accountamt = cl_digcut(sr.accountamt,g_azi05)
           CASE sr.tax
              WHEN "Y"
                 EXECUTE sel_rce_pre2 USING sr.shop,sr.tax INTO sr.saleamt
              WHEN "N"
                 EXECUTE sel_rce_pre1 USING sr.shop,sr.tax INTO sr.saleamt
           END CASE
           IF cl_null(sr.saleamt) THEN
              LET sr.saleamt = 0
           END IF
           LET sr.saleamt = cl_digcut(sr.saleamt,g_azi05)
           FOREACH sel_rci_cs3 USING sr.shop,sr.tax INTO sr.saleitem
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF
              EXECUTE sel_rci_pre2 USING sr.shop,sr.tax,sr.saleitem INTO sr.saledetail
              IF cl_null(sr.saledetail) THEN
                 LET sr.saledetail = 0
              END IF
              LET sr.saledetail = cl_digcut(sr.saledetail,g_azi04)
              SELECT azw08 INTO sr.shopname FROM azw_file WHERE azw01 = sr.shop AND azwacti = 'Y'
              SELECT tqa02 INTO l_tqa02 FROM tqa_file
               WHERE tqa01 = sr.saleitem
                 AND tqa03 = '29' AND tqaacti = 'Y'
              LET sr.saleitem = sr.saleitem CLIPPED," ",l_tqa02

              ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> *** ##
              EXECUTE insert_prep USING sr.*,g_azi03,g_azi04,g_azi05
              
           END FOREACH
        END FOREACH
     END FOREACH


   LET l_cnt = 0
   LET l_sql = "SELECT COUNT(DISTINCT saleitem),tax FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " GROUP BY tax"
   PREPARE sel_tmp_pre FROM l_sql
   DECLARE sel_tmp_cs CURSOR FOR sel_tmp_pre
   FOREACH sel_tmp_cs INTO l_cnt1,l_tax
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      IF l_cnt1 > l_cnt THEN
         LET l_cnt = l_cnt1
      END IF
   END FOREACH 
 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " ORDER BY tax,shop"
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'rch01,rch05')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET g_str = g_str,";",tm.byear,";",tm.bmonth,";",tm.eyear,";",tm.emonth,";",l_cnt
   CALL cl_prt_cs3('artr802','artr802',l_sql,g_str)
 
END FUNCTION

#FUN-B50154 
