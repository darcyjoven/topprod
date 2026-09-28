# Prog. Version..: '5.30.06-13.03.12(00001)'     #
# Pattern name...: aimr408.4gl
# Descriptions...:  批序號庫存數量明細表
# Date & Author..: 11/09/02 FUN-B80142 By Sakura

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm  RECORD                          # Print condition RECORD
           wc      STRING,
           more    LIKE type_file.chr1     # Input more condition(Y/N)
           END RECORD
DEFINE g_i LIKE type_file.num5     #count/index for any purpose

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(11)

   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL aimr408_tm(0,0)                # Input print condition
      ELSE CALL aimr408()                      # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION aimr408_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
DEFINE p_row,p_col    LIKE type_file.num5,
       l_cmd          LIKE type_file.chr1000

   LET p_row = 6 LET p_col = 16
   OPEN WINDOW aimr408_w AT p_row,p_col WITH FORM "aim/42f/aimr408"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   CALL cl_opmsg('p')
   
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'

WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON imgs01,imgs02,imgs03,imgs04,imgs06,imgs05
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION locale
         CALL cl_dynamic_locale()      
         CALL cl_show_fld_cont()
         LET g_action_choice = "locale"
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

      ON ACTION CONTROLP
         CASE WHEN INFIELD(imgs01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ima"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO imgs01
              NEXT FIELD imgs01
         END CASE
         
      ON ACTION EXIT
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
      LET INT_FLAG = 0 CLOSE WINDOW aimr408_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF

   INPUT BY NAME tm.more WITHOUT DEFAULTS

     BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)

      ON ACTION locale
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()
        LET g_action_choice = "locale"

      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG 
         CALL cl_cmdask()    # Command execution

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
      LET INT_FLAG = 0 CLOSE WINDOW aimr408_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aimr408'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr408','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'",
                         " '",g_rpt_name CLIPPED,"'"
         CALL cl_cmdat('aimr408',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW aimr408_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aimr408()
   ERROR ""
END WHILE
   CLOSE WINDOW aimr408_w
END FUNCTION

FUNCTION aimr408()
   DEFINE l_name    LIKE type_file.chr20,   #External(Disk) file name
          l_sql     STRING,
          g_str     STRING,
          l_chr     LIKE type_file.chr1,
          l_za05    LIKE za_file.za05,
          sr        RECORD imgs01   LIKE imgs_file.imgs01,
                           ima02    LIKE ima_file.ima02,
                           ima021   LIKE ima_file.ima021,
                           imgs02   LIKE imgs_file.imgs02,
                           imgs03   LIKE imgs_file.imgs03,
                           imgs04   LIKE imgs_file.imgs04,
                           imgs06   LIKE imgs_file.imgs06,
                           imgs05   LIKE imgs_file.imgs05,
                           imgs08   LIKE imgs_file.imgs08
                    END RECORD

   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

     #====>資料權限的檢查
     IF g_priv2='4' THEN                           #只能使用自己的資料
         LET tm.wc = tm.wc clipped," AND fbouser = '",g_user,"'"
     END IF
     IF g_priv3='4' THEN                           #只能使用相同群的資料
         LET tm.wc = tm.wc clipped," AND fbogrup MATCHES '",g_grup CLIPPED,"*'"
     END IF
     IF g_priv3 MATCHES "[5678]" THEN    #群組權限
         LET tm.wc = tm.wc clipped," AND fbogrup IN ",cl_chk_tgrup_list()
     END IF     

     LET l_sql="SELECT imgs01,ima02,ima021,imgs02,imgs03,imgs04,",
               "imgs06,imgs05,imgs08,gfe03",
               "  FROM imgs_file,ima_file,gfe_file ",
               " WHERE imgs01=ima01 AND imgs07=gfe01 AND ",tm.wc,
               "   AND imgs08 <> 0 ",
               " ORDER BY imgs01,imgs02,imgs03,imgs04"
 
      IF g_zz05 = 'Y' THEN      
        CALL cl_wcchp(tm.wc,'imgs01,imgs02,imgs03,imgs04,imgs06,imgs05')
            RETURNING tm.wc
      ELSE 
        LET tm.wc = ""
      END IF
      
      LET g_str = tm.wc

      CALL cl_prt_cs1('aimr408','aimr408',l_sql,g_str)

END FUNCTION
#FUN-B80142
