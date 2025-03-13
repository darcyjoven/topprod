# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: artr805.4gl
# Descriptions...: 百貨專櫃核算差異表
# Date & Author..: No.FUN-B50156 11/05/31 By baogc

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD 
              wc1     LIKE type_file.chr1000,
              wc2     LIKE type_file.chr1000,
              wc3     LIKE type_file.chr1000,
              bdate   LIKE type_file.dat,
              edate   LIKE type_file.dat,
              state   LIKE type_file.chr1,
              detail  LIKE type_file.chr1,
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
   LET g_sql = "rcdplant.rcd_file.rcdplant,",
               "azw08.azw_file.azw08,",
               "rce03.rce_file.rce03,",
               "tqa02.tqa_file.tqa02,",
               "rcd04.rcd_file.rcd04,",
               "rcd02.rcd_file.rcd02,",
               "rce06.rce_file.rce06,",
               "rce04.rce_file.rce04,",
               "rce05.rce_file.rce05,",
               "diff.rce_file.rce06,",
               "strnum.type_file.num5,",
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05"
               
   LET l_table = cl_prt_temptable('artr805',g_sql) CLIPPED 
   IF l_table = -1 THEN EXIT PROGRAM END IF                
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
 
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
   LET tm.wc1   = ARG_VAL(7)
   LET tm.wc2   = ARG_VAL(8)
   LET tm.wc3   = ARG_VAL(9)
 
   IF cl_null(g_bgjob) or g_bgjob = 'N'
      THEN CALL artr805_tm(0,0)
      ELSE CALL artr805()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION artr805_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01 
DEFINE p_row,p_col    LIKE type_file.num5
 
   LET p_row = 6 LET p_col = 20
 
   OPEN WINDOW artr805_w AT p_row,p_col WITH FORM "art/42f/artr805"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more   = 'N'
   LET tm.bdate  = MDY(MONTH(g_today),1,YEAR(g_today))
   LET tm.edate  = MDY(MONTH(g_today),cl_days(YEAR(g_today),MONTH(g_today)),YEAR(g_today))
   LET tm.state  = 'Y'
   LET tm.detail = 'N'
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
 
   WHILE TRUE
      DIALOG
         CONSTRUCT BY NAME tm.wc1 ON rcd01
            BEFORE CONSTRUCT
               CALL cl_qbe_init()

            ON ACTION controlp
               CASE
                  WHEN INFIELD(rcd01)
                     CALL q_rcd(TRUE,TRUE,g_plant,'','','') RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rcd01
                     NEXT FIELD rcd01
               END CASE
         END CONSTRUCT
            
         CONSTRUCT BY NAME tm.wc2 ON azw01
            BEFORE CONSTRUCT
               CALL cl_qbe_init()
            
            ON ACTION controlp
               CASE
                  WHEN INFIELD(azw01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form = "q_azw"
                     LET g_qryparam.where = " azw01 IN ",g_auth," AND azwacti = 'Y'"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO azw01
                     NEXT FIELD azw01
               END CASE

         END CONSTRUCT
         
         CONSTRUCT BY NAME tm.wc3 ON rce03
            BEFORE CONSTRUCT
               CALL cl_qbe_init()

            ON ACTION controlp
               CASE
                  WHEN INFIELD(rce03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form = "q_tqa"
                     LET g_qryparam.arg1 = "29"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rce03
                     NEXT FIELD rce03
               END CASE
         END CONSTRUCT

         ON ACTION accept
            EXIT DIALOG

         ON ACTION cancel
            LET INT_FLAG = 1
            EXIT DIALOG

         ON ACTION locale
            CALL cl_show_fld_cont() 
            LET g_action_choice = "locale"
            EXIT DIALOG
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
 
         ON ACTION about     
            CALL cl_about()  
 
         ON ACTION HELP      
            CALL cl_show_help()
 
         ON ACTION controlg    
            CALL cl_cmdask()  
 
 
         ON ACTION EXIT
            LET INT_FLAG = 1
            EXIT DIALOG

         ON ACTION qbe_select
            CALL cl_qbe_select()
 
      END DIALOG
      LET tm.wc1 = tm.wc1 CLIPPED,cl_get_extra_cond('luauser', 'luagrup')
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW artr805_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      IF tm.wc1 = ' 1=1' AND tm.wc2 = ' 1=1' AND tm.wc3 = ' 1=1' THEN 
         CALL cl_err('','9046',0) 
         CONTINUE WHILE 
      END IF
      INPUT BY NAME tm.bdate,tm.edate,tm.state,tm.detail,tm.more WITHOUT DEFAULTS  
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)

         AFTER FIELD bdate
            IF NOT cl_null(tm.bdate) AND NOT cl_null(tm.edate) THEN
               IF tm.bdate > tm.edate THEN
                  CALL cl_err('','alm-402',0)
                  NEXT FIELD bdate
               END IF
            END IF

         AFTER FIELD edate
            IF NOT cl_null(tm.bdate) AND NOT cl_null(tm.edate) THEN
               IF tm.bdate > tm.edate THEN
                  CALL cl_err('','alm-403',0)
                  NEXT FIELD edate
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
         LET INT_FLAG = 0 CLOSE WINDOW artr805_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL artr805()
      ERROR ""
   END WHILE
   CLOSE WINDOW artr805_w
END FUNCTION
 
FUNCTION artr805()
DEFINE l_sql     LIKE type_file.chr1000
DEFINE l_shop    LIKE azw_file.azw01
DEFINE sr           RECORD
                 rcdplant LIKE rcd_file.rcdplant,
                 azw08    LIKE azw_file.azw08,
                 rce03    LIKE rce_file.rce03,
                 tqa02    LIKE tqa_file.tqa02,
                 rcd04    LIKE rcd_file.rcd04,
                 rcd02    LIKE rcd_file.rcd02,
                 rce06    LIKE rce_file.rce06,
                 rce04    LIKE rce_file.rce04,
                 rce05    LIKE rce_file.rce05,
                 diff     LIKE rce_file.rce06,
                 strnum   LIKE type_file.num5
                    END RECORD
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>>  *** ##
   CALL cl_del_data(l_table)
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'artr805'
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog

     LET l_sql = "SELECT azw01 FROM azw_file ",
                 " WHERE ",tm.wc2,
                 "   AND azw01 IN ",g_auth," AND azwacti = 'Y' "

     PREPARE sel_azw_pre FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM 
     END IF
     DECLARE sel_azw_cs CURSOR FOR sel_azw_pre
     
     FOREACH sel_azw_cs INTO l_shop
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
        LET l_sql = 
                 "SELECT rcdplant,'',rce03,'',rcd04,'',",
                 "       SUM(rce06),SUM(rce04),SUM(rce05),'',1",
                 "  FROM ",cl_get_target_table(l_shop,'rcd_file'),
                 "      ,",cl_get_target_table(l_shop,'rce_file'),
                 " WHERE rcd01 = rce01",
                 "   AND ",tm.wc1,
                 "   AND ",tm.wc3,
                 "   AND rcdplant IN ",g_auth,
                 "   AND rcdplant = '",l_shop,"' ",
                 "   AND rcd02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' "
        CASE tm.state
           WHEN 'N'
              LET l_sql = l_sql," AND rcdconf = 'N'"
           WHEN 'Y'
              LET l_sql = l_sql," AND rcdconf = 'Y'"
           WHEN 'A'
              LET l_sql = l_sql," AND rcdconf <> 'X'"
        END CASE
        LET l_sql = l_sql," GROUP BY rcdplant,rce03,rcd04"

        PREPARE sel_rcd_pre1 FROM l_sql
        DECLARE sel_rcd_cs1 CURSOR FOR sel_rcd_pre1
        FOREACH sel_rcd_cs1 INTO sr.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
           END IF
           LET sr.rce06 = cl_digcut(sr.rce06,g_azi04)
           LET sr.rce05 = cl_digcut(sr.rce05,g_azi04)
           LET sr.rce04 = cl_digcut(sr.rce05,g_azi04)

           LET l_sql = "SELECT azw08 FROM ",cl_get_target_table(l_shop,'azw_file'),
                       " WHERE azw01 = '",sr.rcdplant,"' AND azwacti = 'Y'"
           PREPARE sel_azw_pre1 FROM l_sql
           EXECUTE sel_azw_pre1 INTO sr.azw08

           LET l_sql = "SELECT tqa02 FROM ",cl_get_target_table(l_shop,'tqa_file'),
                       " WHERE tqa01 = '",sr.rce03,"' ",
                       "   AND tqa03 = '29' AND tqaacti = 'Y'"
           PREPARE sel_tqa_pre1 FROM l_sql
           EXECUTE sel_tqa_pre1 INTO sr.tqa02

           CASE sr.rcd04
              WHEN 'N'
                 LET sr.diff = sr.rce06 - sr.rce04
              WHEN 'Y'
                 LET sr.diff = sr.rce06 - sr.rce05
           END CASE
                    
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> *** ##
           EXECUTE insert_prep USING sr.*,g_azi03,g_azi04,g_azi05

        END FOREACH
        
        IF tm.detail = 'Y' THEN
           LET l_sql = 
                 "SELECT rcdplant,'',rce03,'',rcd04,rcd02,",
                 "       SUM(rce06),SUM(rce04),SUM(rce05),'',2",
                 "  FROM ",cl_get_target_table(l_shop,'rcd_file'),
                 "      ,",cl_get_target_table(l_shop,'rce_file'),
                 " WHERE rcd01 = rce01",
                 "   AND ",tm.wc1,
                 "   AND ",tm.wc3,
                 "   AND rcdplant IN ",g_auth,
                 "   AND rcdplant = '",l_shop,"' ",
                 "   AND rcd02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' "
           CASE tm.state
              WHEN 'N'
                 LET l_sql = l_sql," AND rcdconf = 'N'"
              WHEN 'Y'
                 LET l_sql = l_sql," AND rcdconf = 'Y'"
              WHEN 'A'
                 LET l_sql = l_sql," AND rcdconf <> 'X'"
           END CASE
           LET l_sql = l_sql," GROUP BY rcdplant,rce03,rcd04,rcd02"

           PREPARE sel_rcd_pre2 FROM l_sql
           DECLARE sel_rcd_cs2 CURSOR FOR sel_rcd_pre2
           FOREACH sel_rcd_cs2 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF
              LET sr.rce06 = cl_digcut(sr.rce06,g_azi04)
              LET sr.rce05 = cl_digcut(sr.rce05,g_azi04)
              LET sr.rce04 = cl_digcut(sr.rce05,g_azi04)

              LET l_sql = "SELECT azw08 FROM ",cl_get_target_table(l_shop,'azw_file'),
                          " WHERE azw01 = '",sr.rcdplant,"' AND azwacti = 'Y'"
              PREPARE sel_azw_pre2 FROM l_sql
              EXECUTE sel_azw_pre2 INTO sr.azw08

              LET l_sql = "SELECT tqa02 FROM ",cl_get_target_table(l_shop,'tqa_file'),
                          " WHERE tqa01 = '",sr.rce03,"' ",
                          "   AND tqa03 = '29' AND tqaacti = 'Y'"
              PREPARE sel_tqa_pre2 FROM l_sql
              EXECUTE sel_tqa_pre2 INTO sr.tqa02

              CASE sr.rcd04
                 WHEN 'N'
                    LET sr.diff = sr.rce06 - sr.rce04
                 WHEN 'Y'
                    LET sr.diff = sr.rce06 - sr.rce05
              END CASE
                    
              ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> *** ##
              EXECUTE insert_prep USING sr.*,g_azi03,g_azi04,g_azi05

           END FOREACH
        END IF
        
     END FOREACH
 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> **** ##
   CASE tm.detail
      WHEN 'N'
         LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " ORDER BY rcdplant,rce03,rcd04"
      WHEN 'Y'
         LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " ORDER BY rcdplant,rce03,rcd04,strnum,rcd02"
   END CASE
   
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc1,'rcd01')
           RETURNING tm.wc1
      CALL cl_wcchp(tm.wc2,'azw01')
           RETURNING tm.wc2
      CALL cl_wcchp(tm.wc3,'rce03')
           RETURNING tm.wc3
      LET g_str = tm.wc1,",",tm.wc2,",",tm.wc3
   END IF
   LET g_str = g_str,";",tm.bdate,";",tm.edate

   CASE tm.detail
      WHEN 'N'
         CALL cl_prt_cs3('artr805','artr805_1',l_sql,g_str)
      WHEN 'Y'
         CALL cl_prt_cs3('artr805','artr805_2',l_sql,g_str)
   END CASE
 
END FUNCTION
 
#FUN-B50156
