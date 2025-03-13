# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: artg210.4gl
# Descriptions...: 盤點資料清冊列印
# Date & Author..: No.FUN-B30207 11/03/30 by baogc
# Modify.........: No.FUN-B40080 11/04/25 By rainy 以 g_bgjob判斷是否開畫面，改為以tm.wc判斷
# Modify.........: No.FUN-BC0026 12/01/30 By Pauline列印前是否有參考p_zz中的設定列印條件選項
# Modify.........: No.FUN-C40071 12/04/20 By wangrr CR轉GR
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE    tm     RECORD
          wc     LIKE type_file.chr1000, 
          store  LIKE type_file.chr1,
          state  LIKE type_file.chr1,
          sort   LIKE type_file.chr1,
          more   LIKE type_file.chr1
                 END RECORD
DEFINE    g_wc        STRING,
          g_str       STRING,
          g_sql       STRING,
          l_table     STRING
 
###GENGRE###START
TYPE sr1_t RECORD
    ruw01 LIKE ruw_file.ruw01,
    ruw04 LIKE ruw_file.ruw04,
    ruw05 LIKE ruw_file.ruw05,
    ruw07 LIKE ruw_file.ruw07,
    rux02 LIKE rux_file.rux02,
    rux03 LIKE rux_file.rux03,
    ima021 LIKE ima_file.ima021,
    rux05 LIKE rux_file.rux05,
    rux04 LIKE rux_file.rux04,
    rux06 LIKE rux_file.rux06,
    rux09 LIKE rux_file.rux09
END RECORD
###GENGRE###END

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

   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.wc    = cl_replace_str(tm.wc,"\\\"","'")
 
   LET g_sql  = "ruw01.ruw_file.ruw01,",
                "ruw04.ruw_file.ruw04,",
                "ruw05.ruw_file.ruw05,",
                "ruw07.ruw_file.ruw07,",
                "rux02.rux_file.rux02,",
                "rux03.rux_file.rux03,",
                "ima021.ima_file.ima021,",
                "rux05.rux_file.rux05,",
                "rux04.rux_file.rux04,",
                "rux06.rux_file.rux06,",
                "rux09.rux_file.rux09"    #FUN-C40071 remove ','
   LET l_table = cl_prt_temptable('artg210',g_sql) CLIPPED
   IF l_table = -1 THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-C40071
      CALL cl_gre_drop_temptable(l_table) #FUN-C40071
      EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-C40071
      CALL cl_gre_drop_temptable(l_table) #FUN-C40071 
      EXIT PROGRAM
   END IF
 
   IF cl_null(g_rlang) THEN
      LET g_rlang = g_lang
   END IF

   #IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN     #FUN-B40080
   IF cl_null(tm.wc) THEN                         #FUN-B40080
      CALL g210_tm(0,0)
   ELSE
      CALL artg210()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table)  #FUN-C40071
END MAIN
 
FUNCTION g210_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
DEFINE p_row,p_col    LIKE type_file.num5,
       l_cmd          LIKE type_file.chr1000
       
   IF p_row = 0 THEN LET p_row = 6 LET p_col = 14 END IF
   OPEN WINDOW r210_w AT p_row,p_col WITH FORM "art/42f/artg210"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET tm.store = 'N'
   LET tm.state = '1'
   LET tm.sort = '1'
   LET g_pdate=g_today  #FUN-C40071 add
   WHILE TRUE
      DISPLAY BY NAME tm.more,tm.store,tm.state,tm.sort
      CONSTRUCT BY NAME tm.wc ON ruw02,ruw01,ruw04,ruw05,ruw06
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
              
         ON ACTION controlp
            CASE
               WHEN INFIELD(ruw02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_rus"
                  LET g_qryparam.where = "rus16 <> 'Y'"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ruw02
                  NEXT FIELD ruw02
               WHEN INFIELD(ruw01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_ruw01"
                  LET g_qryparam.arg1 = "1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ruw01
                  NEXT FIELD ruw01 
               WHEN INFIELD(ruw05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_imd01_2"
                  LET g_qryparam.arg1 = g_plant
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ruw05
                  NEXT FIELD ruw05
               WHEN INFIELD(ruw06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.where = "gen07 = '",g_plant,"'"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ruw06
                  NEXT FIELD ruw06
            END CASE
 
         ON ACTION locale
            CALL cl_show_fld_cont()
            LET g_action_choice = "locale"
            EXIT CONSTRUCT
         ON ACTION help
            CALL cl_show_help()   
            LET g_action_choice = "help"
            CONTINUE CONSTRUCT         
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
      END CONSTRUCT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN 
         LET INT_FLAG = 0 CLOSE WINDOW r210_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)  #FUN-C40071
         EXIT PROGRAM 
      END IF
      IF tm.wc= " 1=1 " THEN CALL cl_err(' ','9046',0) CONTINUE WHILE END IF
      DISPLAY BY NAME tm.store,tm.state,tm.sort
      INPUT BY NAME tm.store,tm.state,tm.sort WITHOUT DEFAULTS
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 

         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG 
            CALL cl_cmdask()
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
         ON ACTION help
            CALL cl_show_help()         
            LET g_action_choice = "help"
            CONTINUE INPUT             
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         CLOSE WINDOW r210_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         CALL cl_gre_drop_temptable(l_table)  #FUN-C40071
         EXIT PROGRAM 
      END IF
      DISPLAY BY NAME tm.more
      INPUT BY NAME tm.more WITHOUT DEFAULTS
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
            END IF
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG 
            CALL cl_cmdask()
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
         ON ACTION help
            CALL cl_show_help()         
            LET g_action_choice = "help"
            CONTINUE INPUT             
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         CLOSE WINDOW r210_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         CALL cl_gre_drop_temptable(l_table)  #FUN-C40071
         EXIT PROGRAM 
      END IF
      CALL cl_wait()
      CALL artg210()
      ERROR ""
   END WHILE
   CLOSE WINDOW r210_w
END FUNCTION
 
FUNCTION artg210()
   DEFINE l_str       STRING,
          l_sql       STRING
   DEFINE sr          RECORD
                ruw01      LIKE ruw_file.ruw01,
                ruw04      LIKE ruw_file.ruw04,
                ruw05      LIKE ruw_file.ruw05,
                ruw07      LIKE ruw_file.ruw07,
                rux        RECORD
                   rux02      LIKE rux_file.rux02,
                   rux03      LIKE rux_file.rux03,
                   ima021     LIKE ima_file.ima021,
                   rux05      LIKE rux_file.rux05,
                   rux04      LIKE rux_file.rux04,
                   rux06      LIKE rux_file.rux06,
                   rux09      LIKE rux_file.rux09
                           END RECORD
                      END RECORD
   DEFINE l_ruwconf   LIKE ruw_file.ruwconf
 
   CALL cl_del_data(l_table)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   LET l_sql =" SELECT ruw01,ruw04,ruw05,ruw07,rux02,rux03,  ",
              "        ima02,rux05,rux04,rux06,rux09,ruwconf ",
              "   FROM rux_file LEFT OUTER JOIN ima_file     ",
              "     ON ima_file.ima01 = rux_file.rux03,      ",
              "        ruw_file                              ",
              "  WHERE ruw_file.ruw00 = rux_file.rux00       ",
              "    AND ruw_file.ruw01 = rux_file.rux01       ",
              "    AND ruw00 = '1' AND ruwconf <> 'X' AND    ",tm.wc CLIPPED
   CASE tm.state
      WHEN '2'
         LET l_sql = l_sql CLIPPED," AND ruwconf = 'Y'"
      WHEN '1'
         LET l_sql = l_sql CLIPPED," AND ruwconf = 'N'"
   END CASE
   CASE tm.sort
      WHEN '1'
         LET l_sql = l_sql CLIPPED," ORDER BY ruw01,rux02"
      WHEN '2'
         LET l_sql = l_sql CLIPPED," ORDER BY ruw01,rux03"
      OTHERWISE
         LET l_sql = l_sql CLIPPED," ORDER BY ruw01,rux02"
   END CASE
 
   PREPARE r210_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)  #FUN-C40071
      EXIT PROGRAM
   END IF
   DECLARE r210_cs1 CURSOR FOR r210_prepare1

   FOREACH r210_cs1 INTO sr.*,l_ruwconf
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
     END IF
     IF l_ruwconf = 'N' THEN
        LET sr.rux.rux06 = NULL
        LET sr.rux.rux09 = NULL
     END IF
     EXECUTE insert_prep USING 
              sr.ruw01, sr.ruw04, sr.ruw05, sr.ruw07,
              sr.rux.rux02,sr.rux.rux03,sr.rux.ima021,
              sr.rux.rux05,sr.rux.rux04,sr.rux.rux06,sr.rux.rux09
   END FOREACH
#FUN-C40071--mark--str
#  LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
#   CASE tm.sort
#      WHEN '1'
#         LET l_sql = l_sql CLIPPED," ORDER BY ruw01,rux02"
#      WHEN '2'
#         LET l_sql = l_sql CLIPPED," ORDER BY ruw01,rux03"
#      OTHERWISE 
###GENGRE###         LET l_sql = l_sql CLIPPED," ORDER BY ruw01,rux02"
#   END CASE
#FUN-C40071--mark--end
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'ruw02,ruw01,ruw04,ruw05,ruw06') 
           RETURNING tm.wc 
     #LET g_str =tm.wc  #FUN-BC0026 add  #FUN-C40071 mark--
   END IF
  #LET g_str = tm.wc  #FUN-BC0026 mark
   IF tm.store = 'Y' THEN
###GENGRE###      CALL cl_prt_cs3('artg210','artg210_1',l_sql,g_str)
    LET g_template='artg210_1'  #FUN-C40071 add
    CALL artg210_grdata()    ###GENGRE###
   ELSE
###GENGRE###      CALL cl_prt_cs3('artg210','artg210_2',l_sql,g_str)
    LET g_template='artg210_2'  #FUN-C40071 add
    CALL artg210_grdata()    ###GENGRE###
   END IF
END FUNCTION
#FUN-B30207


###GENGRE###START
FUNCTION artg210_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("artg210")
        IF handler IS NOT NULL THEN
            START REPORT artg210_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
            #FUN-C40071--add--str
            CASE tm.sort
               WHEN '1'    
                  LET l_sql = l_sql CLIPPED," ORDER BY ruw01,rux02"
               WHEN '2'
                  LET l_sql = l_sql CLIPPED," ORDER BY ruw01,rux03"
               OTHERWISE
                  LET l_sql = l_sql CLIPPED," ORDER BY ruw01,rux02"
            END CASE
            #FUN-C40071--add--end
            DECLARE artg210_datacur1 CURSOR FROM l_sql
            FOREACH artg210_datacur1 INTO sr1.*
                OUTPUT TO REPORT artg210_rep(sr1.*)
            END FOREACH
            FINISH REPORT artg210_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT artg210_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5

    
    ORDER EXTERNAL BY sr1.ruw01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.ruw01

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.ruw01

        
        ON LAST ROW

END REPORT
###GENGRE###END
