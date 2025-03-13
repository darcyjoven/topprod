# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: abag100.4gl
# Descriptions...: 條碼列印
# Date & Author..: No:DEV-D40006 2013/04/03 By TSD.JIE

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm   RECORD
            wc       STRING,
            iba02    LIKE iba_file.iba02,  #條碼類型 
            ibb02    LIKE ibb_file.ibb02,  #條碼產生時機點 
            type     LIKE type_file.chr1,  #印表(rpt樣版)類型
            more     LIKE type_file.chr1
            END RECORD
DEFINE g_i        LIKE type_file.num5
DEFINE g_str      STRING
DEFINE g_sql      STRING
DEFINE l_table    STRING

###GENGRE###START
TYPE sr1_t RECORD
    iba01  LIKE iba_file.iba01,      #條碼
    occ01  LIKE occ_file.occ01,      #客戶代號
    occ02  LIKE occ_file.occ02,      #客戶名稱
    ibb03  LIKE ibb_file.ibb03,      #單號
    ima02  LIKE ima_file.ima02,      #品名
    ima021 LIKE ima_file.ima021,     #規格
    qty    LIKE type_file.num15_3,   #數量
    unit   LIKE ima_file.ima55,      #單位
    ibb05  LIKE ibb_file.ibb05,      #包數
    ibb10  LIKE ibb_file.ibb10       #總包數
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
   IF (NOT cl_setup("ABA")) THEN
      EXIT PROGRAM
   END IF


   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_sql = " iba01.iba_file.iba01,",   #條碼
               " occ01.occ_file.occ01,",   #客戶代號
               " occ02.occ_file.occ02,",   #客戶名稱
               " ibb03.ibb_file.ibb03,",   #單號
               " ima02.ima_file.ima02,",   #品名
               " ima021.ima_file.ima021,", #規格
               " qty.type_file.num15_3,",  #數量
               " unit.ima_file.ima55,",    #單位
               " ibb05.ibb_file.ibb05,",   #包數
               " ibb10.ibb_file.ibb10 "    #總包數

   LET l_table = cl_prt_temptable('abag100',g_sql) CLIPPED
   IF l_table =-1 THEN EXIT PROGRAM END IF

   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES (?,?,?,?,?, ?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF

   LET g_pdate  = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET g_rep_user = ARG_VAL(7)
   LET g_rep_clas = ARG_VAL(8)
   LET g_template = ARG_VAL(9)
   LET g_rpt_name = ARG_VAL(10)
   LET tm.wc    = ARG_VAL(11)
   LET tm.iba02 = ARG_VAL(12)    #條碼類型
   LET tm.ibb02 = ARG_VAL(13)    #條碼產生時機點
   LET tm.type  = ARG_VAL(14)    #印表(rpt樣版)類型：包裝單條碼

   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL abag100_tm(0,0)        # Input print condition
   ELSE
      CALL abag100()              # Read data and create out-file
   END IF

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION abag100_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
DEFINE p_row,p_col    LIKE type_file.num5,
       l_cmd          LIKE type_file.chr1000

   LET p_row = 4 LET p_col = 16
   OPEN WINDOW abag100_w AT p_row,p_col WITH FORM "aba/42f/abag100"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   CALL cl_opmsg('p')

   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'

   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON iba01,ibb03,ibb06
         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION CONTROLP
            CASE
              WHEN INFIELD(iba01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_iba01"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO iba01
                   NEXT FIELD iba01
              WHEN INFIELD(ibb03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_ibb01"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ibb03
                   NEXT FIELD ibb03
              WHEN INFIELD(ibb06)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_ima"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ibb06
                   NEXT FIELD ibb06
            END CASE

         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT CONSTRUCT

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()

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
         LET INT_FLAG = 0
         CLOSE WINDOW abag100_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF

      INPUT BY NAME tm.iba02,tm.ibb02,tm.type,tm.more WITHOUT DEFAULTS
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)

         AFTER FIELD iba02
             IF NOt cl_null(tm.iba02) THEN
                IF tm.iba02 = 'H' OR tm.iba02 = 'D' THEN
                   LET tm.type = '2'         #印表(rpt樣版)類型：包裝單條碼
                ELSE
                   LET tm.type = '1'         #印表(rpt樣版)類型：一般條碼
                END IF
             END IF
             DISPLAY BY NAME tm.type

         AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies)
                         RETURNING g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies
            END IF

         ON ACTION CONTROLZ
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
          LET INT_FLAG = 0 CLOSE WINDOW abag100_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time
          EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL abag100()
      ERROR ""
   END WHILE
   CLOSE WINDOW abag100_w
END FUNCTION

FUNCTION abag100()
   DEFINE l_name    LIKE type_file.chr20,
          l_sql     STRING,
          l_za05    LIKE za_file.za05,
          l_ibb     RECORD LIKE ibb_file.*,
          l_iba01   LIKE iba_file.iba01,
          l_iba02   LIKE iba_file.iba02,
          l_ima02   LIKE ima_file.ima02,
          l_ima021  LIKE ima_file.ima021,
          l_occ01   LIKE occ_file.occ01,
          sr        RECORD
                    iba01      LIKE iba_file.iba01,    #條碼
                    occ01      LIKE occ_file.occ01,    #客戶代號
                    occ02      LIKE occ_file.occ02,    #客戶名稱
                    ibb03      LIKE ibb_file.ibb03,    #單號
                    ima02      LIKE ima_file.ima02,    #品名
                    ima021     LIKE ima_file.ima021,   #規格
                    qty        LIKE type_file.num15_3, #數量
                    unit       LIKE ima_file.ima55,    #單位
                    ibb05      LIKE ibb_file.ibb05,    #包數
                    ibb10      LIKE ibb_file.ibb10     #總包數
                         END RECORD

   CALL cl_del_data(l_table)

   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'abag100'
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

   IF cl_null(tm.wc)  THEN LET tm.wc = ' 1=1'  END IF
   IF cl_null(tm.type) THEN LET tm.type = '1' END IF

   LET l_sql = "SELECT ibb_file.*, iba01, iba02, ",  #條碼資訊
               "       ima02, ima021 ",              #料件資訊
               "  FROM iba_file ",
               "         LEFT JOIN ibb_file ON  iba01= ibb01",
               "         LEFT JOIN ima_file ON  ibb06= ima01",
               " WHERE ",tm.wc ,
               "   AND ibb11 = 'Y' "    #有效 
   IF NOT cl_null(tm.iba02) THEN
      LET l_sql = l_sql CLIPPED," AND iba02 = '",tm.iba02,"'"
   END IF
   IF NOT cl_null(tm.ibb02) THEN
      LET l_sql = l_sql CLIPPED," AND ibb02 = '",tm.ibb02,"'"
   END IF

   PREPARE abag100_prepare FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE abag100_curs CURSOR FOR abag100_prepare

   FOREACH abag100_curs INTO l_ibb.*,l_iba01,l_iba02,l_ima02,l_ima021
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) 
         EXIT FOREACH
      END IF

      INITIALIZE sr.* TO NULL
      LET sr.iba01 = l_iba01        #條碼
      LET sr.ibb03 = l_ibb.ibb03    #單號
      LET sr.ibb05 = l_ibb.ibb05    #包數
      LET sr.ibb10 = l_ibb.ibb10    #總包數
      LET sr.ima02 = l_ima02
      LET sr.ima021= l_ima021

      LET l_occ01 = ''
      CASE
         WHEN l_ibb.ibb02 = 'A'
            #客戶
            SELECT oea03 INTO l_occ01
              FROM sfb_file LEFT JOIN (SELECT * FROM oea_file,oeb_file WHERE oeb01 = oea01 ) oeab
                            ON oea01 = sfb22 and oeb03 = sfb221
             WHERE sfb01 = l_ibb.ibb03

            #數量.單位
            SELECT sfb08,ima55 INTO sr.qty,sr.unit
              FROM sfb_file LEFT JOIN ima_file On ima01 = sfb05
             WHERE sfb01 = l_ibb.ibb03

         WHEN l_ibb.ibb02 = 'F' OR l_ibb.ibb02 = 'G'
            #客戶
            SELECT oea03 INTO l_occ01
              FROM pmn_file LEFT JOIN (SELECT * FROM oea_file,oeb_file WHERE oeb01 = oea01 ) oeab
                            ON oea01 = pmn24 and oeb03 = pmn25
             WHERE pmn01 = l_ibb.ibb03
               AND pmn02 = l_ibb.ibb04

            #數量.單位
            SELECT pmn20,pmn07 INTO sr.qty,sr.unit
              FROM pmn_file
             WHERE pmn01 = l_ibb.ibb03
               AND pmn02 = l_ibb.ibb04

         WHEN l_ibb.ibb02 = 'H'
            #客戶
            SELECT oea03 INTO l_occ01
              FROM oea_file
             WHERE oea01 = l_ibb.ibb03

            #數量.單位
            SELECT oeb12,oeb05 INTO sr.qty,sr.unit
              FROM oeb_file
             WHERE oeb01 = l_ibb.ibb03
               AND oeb03 = l_ibb.ibb04

         WHEN l_ibb.ibb02 = 'I'
            #數量.單位
            SELECT inb09,inb08 INTO sr.qty,sr.unit
              FROM inb_file
             WHERE inb01 = l_ibb.ibb03
               AND inb03 = l_ibb.ibb04
      END CASE

      LET sr.occ01 = l_occ01
      IF cl_null(sr.qty) THEN LET sr.qty = 0 END IF

      #客戶名稱
      LET sr.occ02 = ''
      SELECT occ02 INTO sr.occ02
        FROM occ_file
       WHERE occ01 = l_occ01

      EXECUTE insert_prep USING sr.*

      UPDATE ibb_file SET ibb12 = NVL(ibb12,0) + 1
       WHERE ibb01 = l_ibb.ibb01
         AND ibb02 = l_ibb.ibb02
         AND ibb03 = l_ibb.ibb03
         AND ibb04 = l_ibb.ibb04
         AND ibb05 = l_ibb.ibb05
      IF SQLCA.sqlcode THEN
         CALL cl_err('upd ibb12',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
   END FOREACH


   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'iba01,ibb03,ibb06')
         RETURNING tm.wc
   ELSE
      LET tm.wc = ''
   END IF


   CALL abag100_grdata()    ###GENGRE###


END FUNCTION


###GENGRE###START
FUNCTION abag100_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("abag100")
        IF handler IS NOT NULL THEN
            START REPORT abag100_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
          
            DECLARE abag100_datacur1 CURSOR FROM l_sql
            FOREACH abag100_datacur1 INTO sr1.*
                OUTPUT TO REPORT abag100_rep(sr1.*)
            END FOREACH
            FINISH REPORT abag100_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT abag100_rep(sr1)
    DEFINE sr1          sr1_t
    DEFINE l_lineno     LIKE type_file.num5
    DEFINE l_ibb05      LIKE type_file.chr20   #第N包
    DEFINE l_ibb10      LIKE type_file.chr20   #共N包
    DEFINE l_qty        LIKE type_file.chr20   #數量+單位
    
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX tm.*
        
        BEFORE GROUP OF sr1.iba01

        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

            LET l_ibb05 = cl_getmsg_parm('aba-198',g_lang,sr1.ibb05)
            LET l_ibb10 = cl_getmsg_parm('aba-199',g_lang,sr1.ibb10)
            LET l_qty   = sr1.qty , sr1.unit
            PRINTX l_ibb05,l_ibb10,l_qty

        AFTER GROUP OF sr1.iba01

        
        ON LAST ROW

END REPORT
###GENGRE###END
#DEV-D40006 add
