# Prog. Version..: '5.30.06-13.03.19(00007)'     #
#
# Pattern name...: axmr422.4gl
# Descriptions...: 借貨出貨單
# Date & Author..: No.FUN-750036 07/05/10 by rainy
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A60190 10/07/07 By Smapmin 增加償價數量的呈現
# Modify.........: No:TQC-B30093 11/03/09 By zhangll wc -> STRING
# Modify.........: No:MOD-B40061 11/04/11 By lilingyu 當選擇"僅打印未償還的資料"時,無資料顯示,其實應該是有值的
# Modify.........: No:CHI-BB0037 11/12/14 By Vampire 增加[是否要列印結案資料]選項
# Modify.........: No:TQC-BB0222 12/01/06 By lilingyu 暫先還原MOD-B40061的修改處
# Modify.........: No:TQC-CB0023 12/11/07 By wuxj  借貨單號欄位開窗增加過濾條件 
# Modify.........: No:MOD-CB0207 13/01/31 By Elise 報表請排除列印借貨償價訂單

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
  DEFINE g_seq_item     LIKE type_file.num5        # No.FUN-680137 SMALLINT
END GLOBALS
   DEFINE tm  RECORD                         # Print condition RECORD
             #wc      LIKE type_file.chr1000,     # No.FUN-680137 VARCHAR(500)             # Where condition
              wc      STRING,  #Mod No:TQC-B30093
              a       LIKE type_file.chr1,        #僅列印未償還資料
              b       LIKE type_file.chr1,        #是否要列印結案資料  #CHI-BB0037 add
              more    LIKE type_file.chr1         # No.FUN-680137 VARCHAR(01)              # Input more condition(Y/N)
              END RECORD,
          g_m  ARRAY[40] OF LIKE oao_file.oao06,   #No.MOD-610046
          l_outbill   LIKE oga_file.oga01    # 出貨單號,傳參數用
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000    #No.FUN-680137  VARCHAR(72)
DEFINE g_sma115         LIKE sma_file.sma115
DEFINE g_sma116         LIKE sma_file.sma116
DEFINE l_zaa02          LIKE zaa_file.zaa02
DEFINE i                LIKE type_file.num10       # No.FUN-680137 INTEGER
DEFINE l_i,l_cnt        LIKE type_file.num5         #No.FUN-680137 SMALLINT
DEFINE  g_show_msg  DYNAMIC ARRAY OF RECORD  #FUN-650020
          oga01     LIKE oga_file.oga01,
          oga03     LIKE oga_file.oga03,
          occ02     LIKE occ_file.occ02,
          occ18     LIKE occ_file.occ18,
          ze01      LIKE ze_file.ze01,
          ze03      LIKE ze_file.ze03
                   END RECORD
DEFINE  g_oga01     LIKE oga_file.oga01   #FUN-650020
 
DEFINE  g_sql      STRING
DEFINE  l_table    STRING
DEFINE  l_table1   STRING
DEFINE  l_table2   STRING
DEFINE  l_str      STRING
 
 
MAIN
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
 
   INITIALIZE tm.* TO NULL                # Default condition
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.a    = ARG_VAL(8)
   #CHI-BB0037 ----- modify start -----
   LET tm.b    = ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)
   #LET g_rep_user = ARG_VAL(9)
   #LET g_rep_clas = ARG_VAL(10)
   #LET g_template = ARG_VAL(11)
   #LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #CHI-BB0037 ----- modify end  -----
 
 #  LET g_sql ="oeb01.oeb_file.oeb01,",
 #             "oeb03.oeb_file.oeb03,",
 #             "oea03.oea_file.oea03,",
 #             "oea021.oea_file.ea032,",
 #             "oeb04.oeb_file.oeb04,",
 #             "oeb06.oeb_file.oeb06,",
 #             "ima021.ima_file.ima021,",
 #             "oeb24.oeb_file.oeb24,",
 #             "oeb30.oeb_file.oeb30,",
 #             "oeb25.oeb_file.oeb25,",
 #             "oea14.oea_file.oea14,",
 #             "gen02.gen_file.gen02 ",
 #  LET l_table = cl_prt_temptable('axmr422',g_sql) CLIPPED
 #  IF l_table = -1 THEN EXIT PROGRAM END IF
 
 
   IF cl_null(tm.wc) THEN
      CALL axmr422_tm(0,0)             # Input print condition
   ELSE
      CALL axmr422()                   # Read data and create out-file
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION axmr422_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680137 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
   DEFINE l_oaz23     LIKE oaz_file.oaz23    #No.FUN-5C0075
 
   LET p_row = 7 LET p_col = 17
 
   OPEN WINDOW axmr422_w AT p_row,p_col WITH FORM "axm/42f/axmr422"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   LET tm.a = 'N'
   LET tm.b = 'N'   #CHI-BB0037 add
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON oea03,oeb04,oea01,oea02,oea14,oeb30
 
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()                   
            EXIT CONSTRUCT
 
         ON ACTION CONTROLP
            CASE
              WHEN INFIELD(oea01)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_oea11"   
               #LET g_qryparam.where = " oea00 MATCHES '[89]'"    #TQC-CB0023 add #MOD-CB0207 mark
                LET g_qryparam.where = " oea00 MATCHES '[8]'"     #MOD-CB0207 add
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oea01
                NEXT FIELD oea01
              WHEN INFIELD(oea03)     
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_occ3"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oea03  
                   NEXT FIELD oea03  
              WHEN INFIELD(oeb04)     
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   IF g_aza.aza50='Y' THEN
                      LET g_qryparam.form ="q_ima15"   
                   ELSE
                      LET g_qryparam.form ="q_ima"   
                   END IF
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oeb04
                   NEXT FIELD oeb04
              WHEN INFIELD(oea14)     
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gen"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oea14
                   NEXT FIELD oea14
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
         CLOSE WINDOW axmr422_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
 
      IF tm.wc=" 1=1" THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      LET tm.a = 'N'
      #CHI-BB0037 ----- modify start -----
      #DISPLAY BY NAME tm.a
      #INPUT BY NAME tm.a,tm.more WITHOUT DEFAULTS
      DISPLAY BY NAME tm.a,tm.b
      INPUT BY NAME tm.a,tm.b,tm.more WITHOUT DEFAULTS
      #CHI-BB0037 ----- modify end -----
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
         #AFTER FIELD a
         #  IF cl_null(tm.a) THEN NEXT FIELD a END IF

         #CHI-BB0037 ----- modify start ----
         AFTER FIELD b
           IF NOT cl_null(tm.b) THEN
              IF tm.b NOT MATCHES '[YN]' THEN
                 NEXT FIELD b
              END IF
           END IF
         #CHI-BB0037 ----- modify end ----
           
         AFTER FIELD more
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
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW axmr422_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01 = 'axmr422'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('axmr422','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'" ,
                        " '",tm.a CLIPPED,"'" ,
                        " '",tm.b CLIPPED,"'" ,   #CHI-BB0037 add
                        " '",g_rep_user CLIPPED,"'",           
                        " '",g_rep_clas CLIPPED,"'",           
                        " '",g_template CLIPPED,"'"            
            CALL cl_cmdat('axmr422',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW axmr422_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL axmr422()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW axmr422_w
 
END FUNCTION
 
FUNCTION axmr422()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
          #l_sql     LIKE type_file.chr1000,   
          l_sql     STRING,       #NO.FUN-910082    
          sr        RECORD
                       oeb01     LIKE oeb_file.oeb01,
                       oeb03     LIKE oeb_file.oeb03,
                       oea03     LIKE oea_file.oea03,
                       oea032    LIKE oea_file.oea032,
                       oeb04     LIKE oeb_file.oeb04,
                       oeb06     LIKE oeb_file.oeb06,
                       ima021    LIKE ima_file.ima021,
                       oeb24     LIKE oeb_file.oeb24,
                       oeb30     LIKE oeb_file.oeb30,
                       oeb25     LIKE oeb_file.oeb25,
                       oeb29     LIKE oeb_file.oeb29,   #MOD-A60190
                       oea14     LIKE oea_file.oea14,
                       gen02     LIKE gen_file.gen02
                    END RECORD
   DEFINE l_msg    STRING   
   DEFINE l_msg2   STRING    
   DEFINE lc_gaq03 LIKE gaq_file.gaq03   #FUN-650020
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axmr422'  
 
   #LET g_sql = "INSERT INTO ds_report:",l_table CLIPPED," values(?,?,?,?,?,?,?,?,?,?,?) " 
   #PREPARE insert_prep FROM g_sql
   #IF STATUS THEN
   #   CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM
   #END IF
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                   #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND oeauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                   #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND oeagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
   #End:FUN-980030
 
   LET l_sql="SELECT oeb01,oeb03,oea03,oea032,oeb04,oeb06,ima021, ",
            "       oeb24,oeb30,oeb25,oeb29,oea14,gen02   ",   #MOD-A60190 add oeb29    #MOD-B40061             #TQC-BB0222
#            "       NVL(oeb24,0),oeb30,NVL(oeb25,0),NVL(oeb29,0),oea14,gen02   ",       #MOD-B40061            #TQC-BB0222
             "  FROM oea_file LEFT OUTER JOIN gen_file ON oea_file.oea14 = gen_file.gen01,oeb_file LEFT OUTER JOIN ima_file ON oeb_file.oeb04 = ima_file.ima01",
             " WHERE oea00 = '8'  AND oea01=oeb01 ",         #MOD-CB0207 add
            #" WHERE oea00 IN ('8','9')  AND oea01=oeb01 ",  #MOD-CB0207 mark
             "   AND ",tm.wc CLIPPED,
             "   AND oeaconf != 'X' " 
   IF tm.a = 'Y' THEN    #僅列印未償還資料
       LET l_sql = l_sql CLIPPED," AND oeb24 - oeb25 - oeb29 > 0"   #MOD-A60190 add oeb29    #MOD-B40061          #TQC-BB0222
#      LET l_sql = l_sql CLIPPED," AND NVL(oeb24,0) - NVL(oeb25,0) - NVL(oeb29,0) > 0"   #MOD-A60190 add oeb29    #MOD-B40061  #TQC-BB0222
   END IF
   #CHI-BB0037 ----- modify start -----
   IF tm.b = 'N' THEN
      LET l_sql = l_sql CLIPPED," AND oeb70 = 'N'"
   END IF
   #CHI-BB0037 ----- modify end -----
   LET l_sql= l_sql CLIPPED," ORDER BY oeb01,oeb03 "
 
   
   IF g_zz05 = 'Y' THEN                                                                                                          
      CALL cl_wcchp(tm.wc,'oea03,oeb04,oea01,oea02,oea14,oeb30')                                            
      RETURNING tm.wc 
   END IF
 
   LET l_str = l_str CLIPPED,";",tm.wc
   CALL cl_prt_cs1('axmr422','axmr422',l_sql,l_str)    
 
END FUNCTION
 
#FUN-750036
 
