# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apjr400.4gl
# Descriptions...: 專案材料庫存清單
# Date & Author..: 2008/03/25 By shiwuying
# Modify.........: No.FUN-830102 2008/03/25 By shiwuying 因規格改動較大，故重寫此程序
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                       # Print condition RECORD
             wc     STRING,                # Where Condition
             more   LIKE type_file.chr1    
             END RECORD
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                         # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APJ")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
 
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r400_tm(0,0)	
      ELSE CALL r400()		
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION r400_tm(p_row,p_col)
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01
   DEFINE p_row,p_col	LIKE type_file.num5
   DEFINE l_cmd		LIKE type_file.chr1000
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 18
   ELSE
      LET p_row = 4 LET p_col = 11
   END IF
   OPEN WINDOW r400_w AT p_row,p_col
       WITH FORM "apj/42f/apjr400"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
   WHILE TRUE
      CONSTRUCT BY NAME  tm.wc ON imgs11,imgs01,imgs02,imgs03,imgs04
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
             
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(imgs11)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pja"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imgs11
                  NEXT FIELD imgs11
               WHEN INFIELD(imgs01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ima"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imgs01
                  NEXT FIELD imgs01
               OTHERWISE EXIT CASE
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
         CLOSE WINDOW r400_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF
      INPUT BY NAME tm.more  WITHOUT DEFAULTS
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
         AFTER FIELD more
            IF tm.more NOT MATCHES'[YN]' THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y'THEN
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
         LET INT_FLAG = 0
         CLOSE WINDOW r400_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='apjr400'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('apjr400','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'", 
                         " '",g_rep_clas CLIPPED,"'", 
                         " '",g_template CLIPPED,"'" 
            CALL cl_cmdat('apjr400',g_time,l_cmd)
         END IF
         CLOSE WINDOW r400_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r400()
      ERROR ""
   END WHILE
   CLOSE WINDOW r400_w
END FUNCTION
 
FUNCTION r400()
   DEFINE l_name     LIKE type_file.chr20
   DEFINE #l_sql      LIKE type_file.chr1000
          l_sql        STRING       #NO.FUN-910082
   DEFINE l_str      LIKE type_file.chr1000
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pjauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pjagrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN
     #         LET tm.wc = tm.wc clipped," AND pjagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pjauser', 'pjagrup')
     #End:FUN-980030
 
     LET l_sql = " SELECT imgs11,imgs01,imgs02,imgs03,imgs04,SUM(imgs08) sum_imgs08,imgs07,ima02,ima021",
                 " FROM imgs_file,ima_file ",
                 " WHERE imgs01=ima01 AND imgs10='3' ",
                 "  AND ",tm.wc CLIPPED,
                 "  GROUP BY imgs11,imgs01,imgs02,imgs03,imgs04,imgs07,ima02,ima021 ",
                 "  ORDER BY imgs11,imgs01,imgs02,imgs03,imgs04"
 
     LET l_str=tm.wc clipped
     IF g_zz05='Y' THEN
        CALL cl_wcchp(l_str,'imgs11,imgs01,imgs02,imgs03,imgs04')
           RETURNING l_str
     ELSE 
        LET l_str=''
     END IF
     CALL cl_prt_cs1('apjr400','apjr400',l_sql,l_str)
END FUNCTION
#No.FUN-830102
