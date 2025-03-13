# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apjr300.4gl
# Descriptions...: 專案應收帳款明細表
# Date & Author..: 08/03/24 By shiwuying
# Modify.........: No.FUN-830102 2008/03/24 By shiwuying 因規格改動較大，故重寫此程序
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD		                # Print condition RECORD
              wc     STRING,
              more   LIKE type_file.chr1
              END RECORD
 
   DEFINE   g_i             LIKE type_file.num5 #count/index for any purpose 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                              # Supress DEL key function
 
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
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r300_tm(0,0)	
   ELSE
      CALL r300()		
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION r300_tm(p_row,p_col)
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01
   DEFINE p_row,p_col	LIKE type_file.num5,
          l_cmd		LIKE type_file.chr1000
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5
      LET p_col = 18
   ELSE
      LET p_row = 4
      LET p_col = 11
   END IF
   OPEN WINDOW r300_w AT p_row,p_col
        WITH FORM "apj/42f/apjr300"
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
      CONSTRUCT BY NAME  tm.wc ON pja01,pjb02,pja05,pja09,pja08
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
             
      ON ACTION controlp
         CASE
            WHEN INFIELD(pja01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_pja"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pja01
               NEXT FIELD pja01
                  
            WHEN INFIELD(pjb02)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_pjb"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pjb02
               NEXT FIELD pjb02
                  
            WHEN INFIELD(pja09)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_gem"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pja09
               NEXT FIELD pja09
                  
            WHEN INFIELD(pja08)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_gen"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pja08
               NEXT FIELD pja08
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
         CLOSE WINDOW r300_w
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
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
           
         ON ACTION CONTROLG
            CALL cl_cmdask()	# Command execution
 
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
         CLOSE WINDOW r300_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
                WHERE zz01='apjr300'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('apjr300','9031',1)
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
            CALL cl_cmdat('apjr300',g_time,l_cmd)
         END IF
         CLOSE WINDOW r300_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r300()
      ERROR ""
   END WHILE
   CLOSE WINDOW r300_w
END FUNCTION
 
FUNCTION r300()
   DEFINE l_name     LIKE type_file.chr20
   DEFINE #l_sql      LIKE type_file.chr1000
          l_sql        STRING       #NO.FUN-910082
   DEFINE l_str      LIKE type_file.chr1000
   DEFINE sr         RECORD
                     pja01     LIKE    pja_file.pja01,    #專蚰N號
                     pja02     LIKE    pja_file.pja02,
                     pja05     LIKE    pja_file.pja05,
                     pjb02     LIKE    pjb_file.pjb02,
                     pjb03     LIKE    pjb_file.pjb03,
                     pja09     LIKE    pja_file.pja09,    #部門代號
                     gem02     LIKE    gem_file.gem02 ,   #部門名稱
                     pja08     LIKE    pja_file.pja08,    #員工代號
                     gen02     LIKE    gen_file.gen02,    #員工姓名
                     oma01     LIKE    oma_file.oma01,    #帳款編號
                     oma02     LIKE    oma_file.oma02,    #帳款日期
                     oma03     LIKE    oma_file.oma03,    #客戶編號
                     oma032    LIKE    oma_file.oma032,   #客戶簡稱
                     oma23     LIKE    oma_file.oma23,    #幣別
                     oma54t    LIKE    oma_file.oma54t,   #原幣金額
                     oma56t    LIKE    oma_file.oma56t,   #本幣金額
                     oma61     LIKE    oma_file.oma61     #本幣未付
                     END RECORD
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND pjauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND pjagrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN
   #      LET tm.wc = tm.wc clipped," AND pjagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pjauser', 'pjagrup')
   #End:FUN-980030
 
   LET l_sql = " SELECT pja01,pja02,pja05,pjb02,pjb03,pja09,gem02,pja08,gen02,",
               "        oma01,oma02,oma03,oma032,oma23,oma54t,oma56t,oma61 ",
               "   FROM pja_file,pjb_file,gem_file,gen_file,oma_file,omb_file ",
               "  WHERE pja01=pjb01 AND pja09=gem01 AND pja08 = gen01 ",
               "    AND oma01=omb01 AND pjb01=omb41 AND pjb02=omb42 ",
               "    AND ",tm.wc CLIPPED  
 
   LET l_str=tm.wc clipped
   IF g_zz05='Y' THEN
      CALL cl_wcchp(l_str,'pja01,pjb02,pja05,pja09,pja08')
         RETURNING l_str
   ELSE 
      LET l_str=''
   END IF
   CALL cl_prt_cs1('apjr300','apjr300',l_sql,l_str)
END FUNCTION
#No.FUN-830102
