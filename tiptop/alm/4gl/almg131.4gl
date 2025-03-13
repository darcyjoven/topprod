# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: almg131.4gl
# Descriptions...: 場地明細統計表
# Date & Author..: No.FUN-C50041 12/05/10 By suncx
# Modify.........: No.FUN-C60062 12/06/29 By yangxf CR转GR

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm  RECORD                       # Print condition RECORD
           wc       STRING, 
           lmd07   LIKE lmd_file.lmd07,
           sub     LIKE type_file.chr1, # Order by sequence
           more    LIKE type_file.chr1  # Input more condition(Y/N)
           END RECORD 
DEFINE   g_sql           STRING
DEFINE   g_str           STRING
DEFINE   l_table         STRING
DEFINE   l_store         STRING 
DEFINE   g_wc            STRING         #FUN-C60062 add 

###GENGRE###START
TYPE sr1_t RECORD
    lmd01 LIKE lmd_file.lmd01,
    lmd16 LIKE lmd_file.lmd16,
    lmdstore LIKE lmd_file.lmdstore,
    azp02 LIKE azp_file.azp02,
    lmd03 LIKE lmd_file.lmd03,
    lmb03 LIKE lmb_file.lmb03,
    lmd04 LIKE lmd_file.lmd04,
    lmc04 LIKE lmc_file.lmc04,
    lmd14 LIKE lmd_file.lmd14,
    lmy04 LIKE lmy_file.lmy04,
    lmd06 LIKE lmd_file.lmd06,
    lmd15 LIKE lmd_file.lmd15,
    lmd05 LIKE lmd_file.lmd05,
    lmd07 LIKE lmd_file.lmd07,
    lmd10 LIKE lmd_file.lmd10,
    lmd11 LIKE lmd_file.lmd11,
    lmd12 LIKE lmd_file.lmd12,
    lmd13 LIKE lmd_file.lmd13
END RECORD
###GENGRE###END

MAIN

   OPTIONS
      INPUT NO WRAP          #输入的方式：不打转
   DEFER INTERRUPT           #撷取中断键

   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.lmd07 = ARG_VAL(8)
   LET tm.sub = ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF     
   
   LET g_sql =  "lmd01.lmd_file.lmd01,",   
                "lmd16.lmd_file.lmd16,",    
                "lmdstore.lmd_file.lmdstore,",  
                "azp02.azp_file.azp02,",  
                "lmd03.lmd_file.lmd03,",  
                "lmb03.lmb_file.lmb03,",  
                "lmd04.lmd_file.lmd04,",  
                "lmc04.lmc_file.lmc04,",  
                "lmd14.lmd_file.lmd14,",   
                "lmy04.lmy_file.lmy04,",
                "lmd06.lmd_file.lmd06,",
                "lmd15.lmd_file.lmd15,",
                "lmd05.lmd_file.lmd05,",
                "lmd07.lmd_file.lmd07,", 
                "lmd10.lmd_file.lmd10,",          
                "lmd11.lmd_file.lmd11,", 
                "lmd12.lmd_file.lmd12,",          
                "lmd13.lmd_file.lmd13"
 
   LET l_table = cl_prt_temptable('almg131',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   
   IF cl_null(g_bgjob) OR g_bgjob = 'N'  THEN #判斷是否是背景運行
      CALL r131_tm(5,10)                      #非背景運行，錄入打印報表條件
   ELSE 
      CALL r131()                             #按傳入條件背景列印報表
   END IF

   CALL cl_used(g_prog,g_time,2) RETURNING g_time

END MAIN

FUNCTION r131_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01,
          l_cmd          LIKE type_file.chr1000,
          l_sql          STRING 
   DEFINE l_where        STRING
   DEFINE tok            base.StringTokenizer
   DEFINE l_azw01        LIKE azw_file.azw01
   DEFINE l_n            LIKE type_file.num5

   OPEN WINDOW almg131_w AT p_row,p_col WITH FORM "alm/42f/almg131" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
       
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')

   INITIALIZE tm.* TO NULL            # Default condition
   
   
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
   LET tm.wc    = ' 1=1'
   LET tm.sub   = 'N'
   LET tm.more  = 'N'
   LET tm.lmd07 = '0'

   WHILE TRUE
      DIALOG ATTRIBUTE(UNBUFFERED)
         CONSTRUCT BY NAME tm.wc ON lmdstore,lmd03,lmd04,lmd14,lmd01
            BEFORE CONSTRUCT
               CALL cl_qbe_init()
            AFTER FIELD lmdstore
               LET l_store=GET_FLDBUF(lmdstore)
         END CONSTRUCT

         INPUT BY NAME tm.lmd07,tm.sub,tm.more ATTRIBUTE(WITHOUT DEFAULTS)
            BEFORE INPUT
               CALL cl_qbe_display_condition(lc_qbe_sn)

            ON ACTION CONTROLR
               CALL cl_show_req_fields()

         END INPUT 
            
         ON ACTION controlp
            CALL r131_get_where() RETURNING l_where
            
            CASE
               WHEN INFIELD(lmdstore) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azw13"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.where = " (azw07='",g_plant,"' OR azw01 = '",g_plant,"')"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lmdstore
                  NEXT FIELD lmdstore
               WHEN INFIELD(lmd03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lmb02_1"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.where = l_where
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lmd03
                  NEXT FIELD lmd03
               WHEN INFIELD(lmd04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lmc12"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.where = l_where
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lmd04
                  NEXT FIELD lmd04
               WHEN INFIELD(lmd14)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lmy04"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.where = l_where
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lmd14
                  NEXT FIELD lmd14
               WHEN INFIELD(lmd01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lmd07"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.where = l_where
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lmd01
                  NEXT FIELD lmd01
            END CASE 

         ON ACTION locale
            CALL cl_show_fld_cont()
            LET g_action_choice = "locale"
            EXIT DIALOG

         ON ACTION CONTROLG
            CALL cl_cmdask()
  
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG

         ON ACTION about
            CALL cl_about()

         ON ACTION HELP
            CALL cl_show_help()

         ON ACTION EXIT
            LET INT_FLAG = 1
            EXIT DIALOG

         ON ACTION ACCEPT
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                             g_bgjob,g_time,g_prtway,g_copies)
                   RETURNING g_pdate,g_towhom,g_rlang,
                             g_bgjob,g_time,g_prtway,g_copies
            END IF
            LET l_store=GET_FLDBUF(lmdstore)
            IF NOT cl_null(l_store) AND l_store <> '*' THEN
               LET tok = base.StringTokenizer.create(l_store,"|")
               WHILE tok.hasMoreTokens()
                  LET l_azw01 = tok.nextToken()
                  LET l_n = 0
                  IF l_azw01 <> g_plant THEN 
                     SELECT COUNT(*) INTO l_n
                       FROM azw_file 
                      WHERE azw01=l_azw01 AND azw07=g_plant
                     IF l_n <= 0 THEN 
                        CALL cl_err(l_azw01,"art-500",0)
                        NEXT FIELD lmdstore
                     END IF 
                  END IF  
               END WHILE 
            END IF 
            EXIT DIALOG

         ON ACTION CANCEL
            LET INT_FLAG=1
            EXIT DIALOG
      END DIALOG 
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW almg131_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='almg131'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('almg131','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,               #(at time fglgo xxxx p1 p2 p3)
                       " '",g_pdate CLIPPED,"'",
                       " '",g_towhom CLIPPED,"'",
                       " '",g_rlang CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'",
                       " '",g_prtway CLIPPED,"'",
                       " '",g_copies CLIPPED,"'",
                       " '",tm.wc CLIPPED,"'" ,
                       " '",g_rep_user CLIPPED,"'",           
                       " '",g_rep_clas CLIPPED,"'",           
                       " '",g_template CLIPPED,"'",           
                       " '",g_rpt_name CLIPPED,"'"            
            CALL cl_cmdat('almg131',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW almg131_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r131()
      ERROR ""
   END WHILE 
   
   CLOSE WINDOW almg131_w
END FUNCTION 

FUNCTION r131()
DEFINE l_sql STRING 
DEFINE sr    RECORD 
                lmd01 LIKE lmd_file.lmd01,   
                lmd16 LIKE lmd_file.lmd16,  
                lmdstore LIKE lmd_file.lmdstore,  
                azp02 LIKE azp_file.azp02,  
                lmd03 LIKE lmd_file.lmd03,  
                lmb03 LIKE lmb_file.lmb03,  
                lmd04 LIKE lmd_file.lmd04,  
                lmc04 LIKE lmc_file.lmc04,  
                lmd14 LIKE lmd_file.lmd14,  
                lmy04 LIKE lmy_file.lmy04,
                lmd06 LIKE lmd_file.lmd06,
                lmd15 LIKE lmd_file.lmd15,
                lmd05 LIKE lmd_file.lmd05,
                lmd07 LIKE lmd_file.lmd07, 
                lmd10 LIKE lmd_file.lmd10,          
                lmd11 LIKE lmd_file.lmd11, 
                lmd12 LIKE lmd_file.lmd12,          
                lmd13 LIKE lmd_file.lmd13
             END RECORD

    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('qcfuser', 'qcfgrup')           #FUN-C60062 mark

    CALL cl_del_data(l_table)
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
                "        ?,?,?,?,?, ?,?,?)"                                                                                                         
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                   
       CALL cl_err('insert_prep:',status,1)            
       CALL cl_used(g_prog,g_time,2) RETURNING g_time                                  
       EXIT PROGRAM                                                                                                                 
    END IF
    LET l_sql = "SELECT lmd01,lmd16,lmdstore,azp02,lmd03,'',lmd04,'',lmd14,", 
                "       '',lmd06,lmd15,lmd05,lmd07,lmd10,lmd11,lmd12,lmd13",
                " FROM lmd_file LEFT JOIN azp_file ON azp01=lmdstore",
                " WHERE ",tm.wc CLIPPED,
                "   AND lmdstore IN (SELECT azw01 FROM azw_file WHERE azw07='",g_plant,"' OR azw01 = '",g_plant,"')"
    CASE tm.lmd07
       WHEN '1'
          LET l_sql = l_sql,"   AND lmd07 = 'Y'"
       WHEN '2'
          LET l_sql = l_sql,"   AND lmd07 = 'N'"
    END CASE
    LET l_sql = l_sql," ORDER BY lmdstore,lmd03,lmd04,lmd14,lmd01 DESC"
    PREPARE almg131_prepare1 FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
       EXIT PROGRAM
    END IF
    DECLARE almg131_curs1 CURSOR FOR almg131_prepare1

    FOREACH almg131_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       #取得樓棟名稱
       SELECT lmb03 INTO sr.lmb03 FROM lmb_file 
        WHERE lmbstore = sr.lmdstore AND lmb02 = sr.lmd03
       #取得樓層名稱
       SELECT lmc04 INTO sr.lmc04 FROM lmc_file 
        WHERE lmcstore = sr.lmdstore AND lmc02 = sr.lmd03
          AND lmc03 = sr.lmd04
       #取得區域名稱
       SELECT lmy04 INTO sr.lmy04 FROM lmy_file 
        WHERE lmystore = sr.lmdstore AND lmy01 = sr.lmd03
          AND lmy02 = sr.lmd04 AND lmy03 = sr.lmd14
       IF cl_null(sr.lmd05) THEN LET sr.lmd05 = 0 END IF
       IF cl_null(sr.lmd06) THEN LET sr.lmd06 = 0 END IF
       IF cl_null(sr.lmd15) THEN LET sr.lmd15 = 0 END IF
          
       EXECUTE  insert_prep  USING sr.*
    END FOREACH 
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    INITIALIZE g_str TO NULL
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'lmdstore,lmd03,lmd04,lmd14,lmd01,lmd07') RETURNING g_wc
#FUN-C60062 MARK BEGIN ---
#       LET g_str = g_wc
#       IF g_str.getLength() > 1000 THEN
#          LET g_str = g_str.subString(1,600)
#          LET g_str = g_str,"..."
#       END IF
#FUN-C60062 MARK end ----
       IF g_wc.getLength() > 1000 THEN
           LET g_wc = g_wc.subString(1,600)
           LET g_wc = g_wc,"..."
       END IF 
   END IF
#FUN-C60062 MARK BEGIN ---
#   LET g_str = g_str,";",tm.sub
#   CALL cl_prt_cs1('almg131','almg131',l_sql,g_str) 
#FUN-C60062 MARK end ----
    CALL almg131_grdata()                 #FUN-C60062 add
END FUNCTION 

FUNCTION r131_get_where()
DEFINE l_where_store     STRING,  #門店條件
       l_where_lmd03     STRING,  #樓棟條件
       l_where_lmd04     STRING,  #樓層條件
       l_where_lmd14     STRING   #區域條件
DEFINE ls_where    STRING 
DEFINE l_store_str STRING,
       l_lmd03_str STRING,
       l_lmd04_str STRING,
       l_lmd14_str STRING

    CASE 
       WHEN INFIELD(lmd03)
          LET l_store_str = "lmbstore"
       WHEN INFIELD(lmd04)
          LET l_store_str = "lmcstore"
          LET l_lmd03_str = "lmc02"
       WHEN INFIELD(lmd14)
          LET l_store_str = "lmystore"
          LET l_lmd03_str = "lmy01"
          LET l_lmd04_str = "lmy02"
       WHEN INFIELD(lmd01)
          LET l_store_str = "lmdstore"
    END CASE 
    LET ls_where = l_store_str," IN (SELECT azw01 FROM azw_file WHERE azw07='",g_plant,"' OR azw01 = '",g_plant,"')"
    
    IF NOT cl_null(tm.wc) AND tm.wc <> " 1=1" THEN
       IF INFIELD(lmd01) THEN
          LET ls_where = ls_where," AND ",tm.wc
          RETURN ls_where
       END IF 
       CALL r131_get_where1("lmdstore") RETURNING l_where_store #截取門店條件
       #根據所在欄位替換門店條件字段
       IF NOT cl_null(l_where_store) AND NOT cl_null(l_store_str) THEN 
          CALL cl_replace_str(l_where_store,"lmdstore",l_store_str) RETURNING l_where_store
          LET ls_where = ls_where," AND ",l_where_store
          IF INFIELD(lmd03) THEN 
             RETURN ls_where
          END IF 
       END IF 
       
       CALL r131_get_where1("lmd03") RETURNING l_where_lmd03    #截取樓棟條件
       #根據所在欄位替換樓棟條件字段
       IF NOT cl_null(l_where_lmd03) AND NOT cl_null(l_lmd03_str) THEN 
          CALL cl_replace_str(l_where_lmd03,"lmd03",l_lmd03_str) RETURNING l_where_lmd03
          LET ls_where = ls_where," AND ",l_where_lmd03
          IF INFIELD(lmd04) THEN 
             RETURN ls_where
          END IF 
       END IF 
       CALL r131_get_where1("lmd04") RETURNING l_where_lmd04    #截取樓層條件
       #根據所在欄位替換樓層條件字段
       IF NOT cl_null(l_where_lmd04) AND NOT cl_null(l_lmd04_str) THEN 
          CALL cl_replace_str(l_where_lmd04,"lmd04",l_lmd04_str) RETURNING l_where_lmd04
          LET ls_where = ls_where," AND ",l_where_lmd04
          IF INFIELD(lmd14) THEN 
             RETURN ls_where
          END IF 
       END IF       
    END IF 
    RETURN ls_where
END FUNCTION 

FUNCTION r131_get_where1(p_field)
DEFINE p_field     STRING 
DEFINE l_str,l_end INTEGER
DEFINE l_where     STRING 
   LET l_str = tm.wc.getIndexOf(p_field,1) 
   IF l_str > 0 THEN
      LET l_end = tm.wc.getIndexOf("in",l_str)
      IF l_end > 0 THEN 
         LET l_end = tm.wc.getIndexOf(")",l_str)
      ELSE 
         LET l_end = tm.wc.getIndexOf("'",l_str)
         LET l_end = tm.wc.getIndexOf("'",l_end+1)
      END IF 
      LET l_where = tm.wc.subString(l_str,l_end)
      RETURN l_where
   ELSE
      RETURN NULL
   END IF
   
END FUNCTION 
#FUN-C50041


###GENGRE###START
FUNCTION almg131_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("almg131")
        IF handler IS NOT NULL THEN
            START REPORT almg131_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
          
            DECLARE almg131_datacur1 CURSOR FROM l_sql
            FOREACH almg131_datacur1 INTO sr1.*
                OUTPUT TO REPORT almg131_rep(sr1.*)
            END FOREACH
            FINISH REPORT almg131_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT almg131_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_lmd05_sum   LIKE lmd_file.lmd05    #FUN-C60062  add
    DEFINE l_lmd06_sum   LIKE lmd_file.lmd06    #FUN-C60062  add
    DEFINE l_lmd15_sum   LIKE lmd_file.lmd15    #FUN-C60062  add
    DEFINE l_lmd01_count LIKE type_file.num10   #FUN-C60062  add
    DEFINE l_lmd10       STRING                 #FUN-C60062  add 
    DEFINE l_lmd07       STRING                 #FUN-C60062  add
    DEFINE l_lmd05_fmt   STRING                 #FUN-C60062  add
    DEFINE l_lmd06_fmt   STRING                 #FUN-C60062  add
    DEFINE l_lmd15_fmt   STRING                 #FUN-C60062  add  
 #  ORDER EXTERNAL BY sr1.lmd01    #FUN-C60062  MARK 
    ORDER EXTERNAL BY sr1.lmdstore #FUN-C60062  add  
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX tm.*
            PRINTX g_wc
              
#       BEFORE GROUP OF sr1.lmd01     #FUN-C60062 MARK 
        BEFORE GROUP OF sr1.lmdstore  #FUN-C60062  add
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_lmd10 = cl_gr_getmsg('gre-292',g_lang,sr1.lmd10)      #FUN-C60062  add
            PRINTX l_lmd10                                              #FUN-C60062  add
            LET l_lmd07 = cl_gr_getmsg('gre-293',g_lang,sr1.lmd07)      #FUN-C60062  add
            PRINTX l_lmd07                                              #FUN-C60062  add 
            PRINTX sr1.*

#       AFTER GROUP OF sr1.lmd01     #FUN-C60062 MARK
        AFTER GROUP OF sr1.lmdstore  #FUN-C60062  add
#FUN-C60062  add begin ---
           LET l_lmd01_count = GROUP COUNT(*)
           LET l_lmd05_sum = GROUP SUM(sr1.lmd05)
           LET l_lmd06_sum = GROUP SUM(sr1.lmd06)
           LET l_lmd15_sum = GROUP SUM(sr1.lmd15)
           LET l_lmd05_fmt = cl_gr_numfmt('lmd_file','lmd05',g_azi04)
           LET l_lmd06_fmt = cl_gr_numfmt('lmd_file','lmd06',g_azi04)
           LET l_lmd15_fmt = cl_gr_numfmt('lmd_file','lmd15',g_azi04)
           PRINTX l_lmd05_fmt
           PRINTX l_lmd06_fmt
           PRINTX l_lmd15_fmt
           PRINTX l_lmd01_count
           PRINTX l_lmd05_sum
           PRINTX l_lmd06_sum
           PRINTX l_lmd15_sum 
#FUN-C60062 add end -----
        ON LAST ROW

END REPORT
###GENGRE###END
