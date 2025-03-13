# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: axmr620.4gl
# Descriptions...: 出貨明細表
# Input parameter:
# Return code....:
# Date & Author..: 95/02/10 By Nick
# Modify.........: 95/07/04 By Danny (是否將原幣金額轉成本幣金額)
# Modify.........: 01-04-06 BY ANN CHEN B312 1.不包含出貨通知單
#                                            2.不應包含作廢資料
# Modify.........: NO.MOD-490092 04-09-06 BY Smapmin 放大"未稅金額"欄位寬度並調整欄位位置
# Modify.........: NO.FUN-4A0021 04/10/04 By Echo 出貨單號,送貨客戶,帳款客戶,人員編號要開窗
# Modify.........: No.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: NO.FUN-530031 05/03/22 By Carol 單價/金額欄位所用的變數型態應為 dec(20,6),匯率 dec(20,10)
# Modify.........: NO.MOD-530781 05/04/04 By wujie 增加料件編號查詢
# Modify.........: No.FUN-550070  05/05/27 By yoyo單據編號格式放大
# Modify.........: No.FUN-580004 05/08/09 by day  報表加雙單位參數
# Modify.........: No.MOD-550164 05/09/02 By pengu 若幣別不同時,條件選項的將原儦籅鷖B轉成本幣金額又沒有勾選,
                                          #        則列印出的合計不合乎邏輯,因為幣別不同不可合計
# Modify.........: No.FUN-5C0075 05/12/22 by wujie 若成品替代oaz23 = Y，則多一選項：是否列印替代料號
# Modify.........: No.FUN-610020 06/01/18 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-660167 06/06/23 By Douzh cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6B0137 06/11/27 By jamie 當使用計價單位,但不使用多單位時,單位一是NULL,導致單位註解內容為空
# Modify.........: No.TQC-6C0041 06/12/08 By ray 報表格式修改
# Modify.........: No.FUN-710081 06/02/01 By yoyo   Crystal report党蜊
# Modify.........: No.TQC-730113 07/04/05 By Nicole 增加CR參數
# Modify.........: No.MOD-7A0115 07/10/19 By Claire l_flag需改初始值
# Modify.........: No.MOD-7B0229 07/11/28 By Claire 出貨單身若二筆不同的AR不可取oga10應回取omb01
# Modify.........: No.MOD-890003 08/09/02 By Smapmin 明細金額需在程式段就先取位，以避免到了rpt段時造成明細金額加總與總計不合
# Modify.........: No.FUN-8B0025 08/12/23 By xiaofeizhu 新增多營運中心INPUT
# Modify.........: No.MOD-940242 09/04/17 By lutingting抓取賬款編號時要判斷是否已作廢
# Modify.........: No.FUN-940102 09/04/27 BY destiny 檢查使用者的資料庫使用權限
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9A0107 09/10/16 By lilingyu 排除oga09 = '8'(客戶簽收)這情況,否則當出貨單走簽收流程時,出貨明細資料會雙倍顯示
# Modify.........: No:FUN-9C0071 10/01/11 By huangrh 精簡程式
# Modify.........: No:FUN-A10056 10/01/12 by dxfwo  跨DB處理
# Modify.........: No:TQC-A50044 10/05/17 By Carrier FROM TABLE错误
# Modify.........: No.FUN-A70084 10/07/19 By lutingting GP5.2報表修改,INPUT營運中心改為QBE
# Modify.........: No:CHI-AC0013 10/12/08 By Summer 執行速度過慢,要將FOREACH裡用到的CURSOR都搬到FOREACH外  
# Modify.........: No:CHI-B10027 11/01/18 By Smapmin 增加是否列印借貨出貨資料的選項
# Modify.........: No:MOD-B40096 11/04/18 BY Summer 報表中抓取帳款單號的判斷只抓12:出貨
# Modify.........: No:FUN-950110 11/05/11 By lixiang 增加報表列印條件--出貨單類別oga00
# Modify.........: No:FUN-940116 11/05/11 By lixiang 增加報表條件選項
# Modify.........: No:TQC-B50069 11/05/17 By lixia 開窗全選報錯修改
# Modify.........: No:MOD-D40008 13/04/03 By Vampire 依條件儲存所帶出來的資料,在列印時,依然會以預設值顯示

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
  DEFINE g_seq_item     LIKE type_file.num5       # No.FUN-680137 SMALLINT
END GLOBALS
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc     STRING,         # Where condition
            #FUN-A70084--mark--str--
            # b       LIKE type_file.chr1,            #No.FUN-8B0025 VARCHAR(1)
            # p1      LIKE azp_file.azp01,            #No.FUN-8B0025 VARCHAR(10)
            # p2      LIKE azp_file.azp01,            #No.FUN-8B0025 VARCHAR(10)
            # p3      LIKE azp_file.azp01,            #No.FUN-8B0025 VARCHAR(10)
            # p4      LIKE azp_file.azp01,            #No.FUN-8B0025 VARCHAR(10) 
            # p5      LIKE azp_file.azp01,            #No.FUN-8B0025 VARCHAR(10)
            # p6      LIKE azp_file.azp01,            #No.FUN-8B0025 VARCHAR(10)
            # p7      LIKE azp_file.azp01,            #No.FUN-8B0025 VARCHAR(10)
            # p8      LIKE azp_file.azp01,            #No.FUN-8B0025 VARCHAR(10)
            #FUN-A70084--mark--end 
              type    LIKE type_file.chr1,            #No.FUN-8B0025 VARCHAR(1)
              x       LIKE type_file.chr1,            #No:FUN-940116
              v       LIKE type_file.chr1,            #No:FUN-940116
              s      LIKE type_file.chr3,         # No.FUN-680137 VARCHAR(3)        # Order by sequence
              t      LIKE type_file.chr3,         # No.FUN-680137 VARCHAR(3)        # Eject sw
              u      LIKE type_file.chr3,         # No.FUN-680137 VARCHAR(3)        # Group total sw
              oga00  LIKE oga_file.oga00,         # No.FUN-950110
              y      LIKE type_file.chr1,         # No.FUN-680137 VARCHAR(1)        # Input more condition(Y/N)
              c      LIKE type_file.chr1,         # No.FUN-680137 VARCHAR(1)        # PRINT sub Item #No.FUN-5C0075
              a      LIKE type_file.chr1,         #CHI-B10027
              more   LIKE type_file.chr1          # No.FUN-680137 VARCHAR(1)        # Input more condition(Y/N)
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose    #No.FUN-680137 SMALLINT
DEFINE   g_sma115        LIKE sma_file.sma115   #No.FUN-580004
DEFINE   g_sma116        LIKE sma_file.sma116   #No.FUN-580004
DEFINE   g_sql         STRING
DEFINE   l_table       STRING
DEFINE   l_str         STRING
DEFINE   l_sql         STRING
DEFINE   l_flag        LIKE type_file.chr1
#DEFINE m_dbs       ARRAY[10] OF LIKE type_file.chr20   #No.FUN-8B0025 ARRAY[10] OF VARCHAR(20) #FUN-A70084
DEFINE  m_plant     LIKE azw_file.azw01   #FUN-A70084
DEFINE  g_wc        LIKE type_file.chr1000   #FUN-A70084 

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
 
   LET g_sql = "oga01.oga_file.oga01,",
               " oga02.oga_file.oga02,",
               " oga03.oga_file.oga03,",
               " oga032.oga_file.oga032,",
               " oga04.oga_file.oga04,",
               " occ02.occ_file.occ02,",
               " oga14.oga_file.oga14,",
               " gen02.gen_file.gen02,",
               " oga15.oga_file.oga15,",
               " gem02.gem_file.gem02,",
               " ogb03.ogb_file.ogb03,",
               " ogb31.ogb_file.ogb31,",
               " ogb04.ogb_file.ogb04,",
               " ogb06.ogb_file.ogb06,",
               " ima021.ima_file.ima021,",
               " str2.type_file.chr50,",
               " ogb05.ogb_file.ogb05,",
               " oga23.oga_file.oga23,",
               " ogb13.ogb_file.ogb13,",
               " ogb12.ogb_file.ogb12,",
               " ogb916.ogb_file.ogb916,",
               " ogb917.ogb_file.ogb917,",
               " ogb14.ogb_file.ogb14,",
               " oga10.oga_file.oga10,",
               " y.type_file.chr1,",
               " c.type_file.chr1,",
               " oaz23.type_file.chr1,",
               " ogc175.ogc_file.ogc17,",
               " ima025.ima_file.ima02,",
               " ima0215.ima_file.ima021,",
               " ogc125.ogc_file.ogc12,",
               " azi03.azi_file.azi03,",
               " azi04.azi_file.azi04,",
               " azi05.azi_file.azi05,",
               "plant.azp_file.azp01"                           #FUN-8B0025 add
               
   LET l_table = cl_prt_temptable('axmr620',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = " INSERT INTO ",g_cr_db_str CLIPPED,l_table clipped,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,", 
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"  #FUN-8B0025 add?
   PREPARE insert_prept111 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',STATUS,1) EXIT PROGRAM 
   END IF 
    
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   LET tm.y  = ARG_VAL(11)
   LET tm.c  = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
#FUN-A70084--mod--str--
#  LET tm.b     = ARG_VAL(17)
#  LET tm.p1    = ARG_VAL(18)
#  LET tm.p2    = ARG_VAL(19)
#  LET tm.p3    = ARG_VAL(20)
#  LET tm.p4    = ARG_VAL(21)
#  LET tm.p5    = ARG_VAL(22)
#  LET tm.p6    = ARG_VAL(23)
#  LET tm.p7    = ARG_VAL(24)
#  LET tm.p8    = ARG_VAL(25)
#  LET tm.type  = ARG_VAL(26)
   LET tm.type  = ARG_VAL(17)
   LET tm.oga00 = ARG_VAL(28)   #No.FUN-950110
   LET tm.x     = ARG_VAL(29)   #No.FUN-940116
   LET tm.v     = ARG_VAL(30)   #No.FUN-940116
   LET g_wc = ARG_VAL(18)
   LET tm.a = ARG_VAL(19)   #CHI-B10027
#FUN-A70084--mod--end
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL axmr620_tm(0,0)        # Input print condition
      ELSE CALL axmr620()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmr620_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
   DEFINE l_oaz23     LIKE oaz_file.oaz23    #No.FUN-5C0075
 
   LET p_row = 3 LET p_col = 15
 
   OPEN WINDOW axmr620_w AT p_row,p_col WITH FORM "axm/42f/axmr620"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
   SELECT oaz23 INTO l_oaz23 FROM oaz_file
   IF l_oaz23 = 'N' THEN
      CALL cl_set_comp_visible("c",FALSE)
   END IF
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm2.s1  = '3'
   LET tm2.s2  = '7'
   LET tm2.u1  = 'Y'
   LET tm2.u2  = 'N'
   LET tm2.u3  = 'N'
   LET tm2.t1  = 'N'
   LET tm2.t2  = 'N'
   LET tm2.t3  = 'N'
   LET tm.y    = 'N'
   LET tm.c    = 'N'     #No.FUN-5C0075
   LET tm.a    = 'N'     #CHI-B10027
   LET tm.more = 'N'
   LET tm.x='2'       #No.FUN-940116
   LET tm.v='2'       #No.FUN-940116
   LET tm.oga00='A'   #No.FUN-950110
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
  #LET tm.b ='N'        #FUN-A70084
  #LET tm.p1=g_plant    #FUN-A70084
   LET tm.type  = '3'
  #FUN-A70084--mark--str--
  #CALL r620_set_entry_1()               
  #CALL r620_set_no_entry_1()
  #CALL r620_set_comb()           
  #FUN-A70084--mark--end
WHILE TRUE
#FUN-A70084--add--str--
   CONSTRUCT BY NAME g_wc ON azw01

      BEFORE CONSTRUCT
          CALL cl_qbe_init()

      ON ACTION controlp
            IF INFIELD(azw01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azw"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = "azw02 = '",g_legal,"' ",
                                      " AND azw01 IN(SELECT zxy03 FROM zxy_file WHERE zxy01 = '",g_user,"' )"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO azw01
               NEXT FIELD azw01
            END IF

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
     CLOSE WINDOW axmr620_w 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time
     EXIT PROGRAM
  END IF
#FUN-A70084--add--end

   CONSTRUCT BY NAME tm.wc ON oga01,oga02,oga03,oga04,oga14,oga15,oga23,ogb04
         BEFORE CONSTRUCT
           #CALL cl_qbe_init() #MOD-D40008 mark
            CALL cl_qbe_display_condition(lc_qbe_sn) #MOD-D40008 add
 
       ON ACTION locale
         LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT CONSTRUCT
 
       ON ACTION CONTROLP
           CASE
              WHEN INFIELD(oga01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_oga8"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oga01
                NEXT FIELD oga01
 
              WHEN INFIELD(oga03)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_occ"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oga03
                NEXT FIELD oga03
 
              WHEN INFIELD(oga04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_occ"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oga04
                NEXT FIELD oga04
 
              WHEN INFIELD(oga14)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gen"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oga14
                NEXT FIELD oga14
 
              WHEN INFIELD(oga15)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gem"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oga15
                NEXT FIELD oga15
 
              WHEN INFIELD(ogb04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ogb04
                NEXT FIELD ogb04
 
           END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr620_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.more         # Condition
 
  #FUN-A70084--mod--str--
  #INPUT BY NAME tm.b,tm.p1,tm.p2,tm.p3,                                                               
  #              tm.p4,tm.p5,tm.p6,tm.p7,tm.p8,tm.type,                                                 
   #-----CHI-B10027---------
   #調整輸入順序
   #INPUT BY NAME tm.type, 
   ##FUN-A70084--mod--end
   #              tm2.s1,tm2.s2,tm2.s3,
   #              tm2.t1,tm2.t2,tm2.t3,
   #              tm2.u1,tm2.u2,tm2.u3,
   #              tm.y,tm.c,tm.more WITHOUT DEFAULTS    #No.FUn-5C0075
   INPUT BY NAME tm.oga00,tm.y,tm.c,tm.a,tm.type,       #No.FUN-950110 add tm.oga00
                 tm.x,tm.v,                             #No.FUN-940116
                 tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
                 tm2.u1,tm2.u2,tm2.u3,
                 tm.more WITHOUT DEFAULTS    #No.FUn-5C0075
   #-----END CHI-B10027-----
                 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
            #MOD-D40008 add start -----
             LET tm.oga00 = GET_FLDBUF(oga00)
             LET tm.y = GET_FLDBUF(y)
             LET tm.c = GET_FLDBUF(c)
             LET tm.a = GET_FLDBUF(a)
             LET tm.type = GET_FLDBUF(type)
             LET tm.x = GET_FLDBUF(x)
             LET tm.v = GET_FLDBUF(v)
             LET tm2.s1 = GET_FLDBUF(s1)
             LET tm2.s2 = GET_FLDBUF(s2)
             LET tm2.s3 = GET_FLDBUF(s3)
             LET tm2.t1 = GET_FLDBUF(t1)
             LET tm2.t2 = GET_FLDBUF(t2)
             LET tm2.t3 = GET_FLDBUF(t3)
             LET tm2.u1 = GET_FLDBUF(u1)
             LET tm2.u2 = GET_FLDBUF(u2)
             LET tm2.u3 = GET_FLDBUF(u3)
             LET tm.more = GET_FLDBUF(more)
            #MOD-D40008 add end   -----
         
#FUN-A70084--mark--str--
#      AFTER FIELD b
#          IF NOT cl_null(tm.b)  THEN
#             IF tm.b NOT MATCHES "[YN]" THEN
#                NEXT FIELD b       
#             END IF
#          END IF
#                   
#      ON CHANGE  b
#         LET tm.p1=g_plant
#         LET tm.p2=NULL
#         LET tm.p3=NULL
#         LET tm.p4=NULL
#         LET tm.p5=NULL
#         LET tm.p6=NULL
#         LET tm.p7=NULL
#         LET tm.p8=NULL
#         DISPLAY BY NAME tm.p1,tm.p2,tm.p3,tm.p4,tm.p5,tm.p6,tm.p7,tm.p8       
#         CALL r620_set_entry_1()      
#         CALL r620_set_no_entry_1()
#         CALL r620_set_comb()
#FUN-A70084--mark--end          

       #No.FUN-950110--ADD--
       AFTER FIELD oga00
          IF tm.oga00 NOT MATCHES '[A1234]' THEN
             NEXT FIELD oga00
          END IF
       #No.FUN-950110--END--

       AFTER FIELD type
          IF cl_null(tm.type) OR tm.type NOT MATCHES '[123]' THEN
             NEXT FIELD type
          END IF                 
       
#FUN-A70084--mark--str--
#      AFTER FIELD p1
#         IF cl_null(tm.p1) THEN NEXT FIELD p1 END IF
#         SELECT azp01 FROM azp_file WHERE azp01 = tm.p1
#         IF STATUS THEN 
#            CALL cl_err3("sel","azp_file",tm.p1,"",STATUS,"","sel azp",1)   
#            NEXT FIELD p1 
#         END IF
#        IF NOT cl_null(tm.p1) THEN 
#           IF NOT s_chk_demo(g_user,tm.p1) THEN              
#              NEXT FIELD p1          
#           END IF  
#        END IF              
#      
#      AFTER FIELD p2
#         IF NOT cl_null(tm.p2) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p2
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p2,"",STATUS,"","sel azp",1)   
#               NEXT FIELD p2 
#            END IF
#           IF NOT s_chk_demo(g_user,tm.p2) THEN
#              NEXT FIELD p2
#           END IF            
#         END IF
#      
#      AFTER FIELD p3
#         IF NOT cl_null(tm.p3) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p3
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p3,"",STATUS,"","sel azp",1)   
#               NEXT FIELD p3 
#            END IF
#           IF NOT s_chk_demo(g_user,tm.p3) THEN
#              NEXT FIELD p3
#           END IF            
#         END IF
#      
#      AFTER FIELD p4
#         IF NOT cl_null(tm.p4) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p4
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p4,"",STATUS,"","sel azp",1)  
#               NEXT FIELD p4 
#            END IF
#           IF NOT s_chk_demo(g_user,tm.p4) THEN
#              NEXT FIELD p4
#           END IF            
#         END IF
#      
#      AFTER FIELD p5
#         IF NOT cl_null(tm.p5) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p5
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p5,"",STATUS,"","sel azp",1)    
#               NEXT FIELD p5 
#            END IF
#           IF NOT s_chk_demo(g_user,tm.p5) THEN
#              NEXT FIELD p5
#           END IF            
#         END IF
#      
#      AFTER FIELD p6
#         IF NOT cl_null(tm.p6) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p6
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p6,"",STATUS,"","sel azp",1)  
#               NEXT FIELD p6 
#            END IF
#           IF NOT s_chk_demo(g_user,tm.p6) THEN
#              NEXT FIELD p6
#           END IF            
#         END IF
#      
#      AFTER FIELD p7
#         IF NOT cl_null(tm.p7) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p7
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p7,"",STATUS,"","sel azp",1) 
#               NEXT FIELD p7 
#            END IF
#           IF NOT s_chk_demo(g_user,tm.p7) THEN
#              NEXT FIELD p7
#           END IF            
#         END IF
#      
#      AFTER FIELD p8
#         IF NOT cl_null(tm.p8) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p8
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p8,"",STATUS,"","sel azp",1)   
#               NEXT FIELD p8 
#            END IF
#           IF NOT s_chk_demo(g_user,tm.p8) THEN
#              NEXT FIELD p8
#           END IF            
#         END IF       
#FUN-A70084--mark--end
 
      AFTER FIELD y
        IF cl_null(tm.y) OR tm.y NOT MATCHES '[YN]' THEN
           NEXT FIELD y
        END IF
      AFTER FIELD c
        IF cl_null(tm.c) OR tm.c NOT MATCHES '[YN]' THEN
           NEXT FIELD c
        END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      #UI
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         ON ACTION qbe_save
            CALL cl_qbe_save()
         
#FUN-A70084--mark--str--
#     ON ACTION CONTROLP
#        CASE
#           WHEN INFIELD(p1)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p1
#              CALL cl_create_qry() RETURNING tm.p1
#              DISPLAY BY NAME tm.p1
#              NEXT FIELD p1
#           WHEN INFIELD(p2)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p2
#              CALL cl_create_qry() RETURNING tm.p2
#              DISPLAY BY NAME tm.p2
#              NEXT FIELD p2
#           WHEN INFIELD(p3)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p3
#              CALL cl_create_qry() RETURNING tm.p3
#              DISPLAY BY NAME tm.p3
#              NEXT FIELD p3
#           WHEN INFIELD(p4)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p4
#              CALL cl_create_qry() RETURNING tm.p4
#              DISPLAY BY NAME tm.p4
#              NEXT FIELD p4
#           WHEN INFIELD(p5)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p5
#              CALL cl_create_qry() RETURNING tm.p5
#              DISPLAY BY NAME tm.p5
#              NEXT FIELD p5
#           WHEN INFIELD(p6)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p6
#              CALL cl_create_qry() RETURNING tm.p6
#              DISPLAY BY NAME tm.p6
#              NEXT FIELD p6
#           WHEN INFIELD(p7)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p7
#              CALL cl_create_qry() RETURNING tm.p7
#              DISPLAY BY NAME tm.p7
#              NEXT FIELD p7
#           WHEN INFIELD(p8)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p8
#              CALL cl_create_qry() RETURNING tm.p8
#              DISPLAY BY NAME tm.p8
#              NEXT FIELD p8
#        END CASE                        
#FUN-A70084--mark--end
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axmr620_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmr620'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axmr620','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",tm.y CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",            #No.TQC-610089 add
                         " '",g_rep_user CLIPPED,"'",      #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",      #No.FUN-570264
                         " '",g_template CLIPPED,"'",      #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'",      #No.FUN-7C0078
                        #FUN-A70084--mark--str--
                        #" '",tm.b CLIPPED,"'" ,           #FUN-8B0025
                        #" '",tm.p1 CLIPPED,"'" ,          #FUN-8B0025
                        #" '",tm.p2 CLIPPED,"'" ,          #FUN-8B0025
                        #" '",tm.p3 CLIPPED,"'" ,          #FUN-8B0025
                        #" '",tm.p4 CLIPPED,"'" ,          #FUN-8B0025
                        #" '",tm.p5 CLIPPED,"'" ,          #FUN-8B0025
                        #" '",tm.p6 CLIPPED,"'" ,          #FUN-8B0025
                        #" '",tm.p7 CLIPPED,"'" ,          #FUN-8B0025
                        #" '",tm.p8 CLIPPED,"'" ,          #FUN-8B0025
                        #FUN-A70084--mark--end
                         " '",tm.type CLIPPED,"'",         #FUN-8B0025                         
                         " '",g_wc CLIPPED,"'",         #FUN-A70084
                         " '",tm.a CLIPPED,"'"    #CHI-B10027
                         
         CALL cl_cmdat('axmr620',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmr620_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmr620()
   ERROR ""
END WHILE
   CLOSE WINDOW axmr620_w
END FUNCTION
 
FUNCTION axmr620()
   DEFINE l_name    LIKE type_file.chr20,      # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
          l_time    LIKE type_file.chr8,       #No.FUN-6A0094
          #l_sql     LIKE type_file.chr1000,    # RDSQL STATEMENT                 #No.FUN-680137 VARCHAR(600)
          l_sql     STRING,                    #TQC-B50069
          l_chr     LIKE type_file.chr1,       #No.FUN-680137 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
         l_order    ARRAY[5] OF LIKE oea_file.oea01,             # No.FUN-680137  VARCHAR(16)   #No.FUN-550070
         sr               RECORD order1 LIKE oea_file.oea01,     # No.FUN-680137  VARCHAR(16)
                                 order2 LIKE oea_file.oea01,     # No.FUN-680137  VARCHAR(16)
                                 order3 LIKE oea_file.oea01,     # No.FUN-680137  VARCHAR(16)
                                  oga01 LIKE oga_file.oga01,    #
                                  oga02 LIKE oga_file.oga02,
                                  oga03 LIKE oga_file.oga03,
                                  oga032 LIKE oga_file.oga032,
                                  oga04 LIKE oga_file.oga04,
				  occ02 LIKE occ_file.occ02,
                                  oga14 LIKE oga_file.oga14,
                                  oga15 LIKE oga_file.oga15,
                                  ogb03 LIKE ogb_file.ogb03,   #單身項次
                                  ogb31 LIKE ogb_file.ogb31,
                                  ogb04 LIKE ogb_file.ogb04,
                                  ogb06 LIKE ogb_file.ogb06,
                                  ogb05 LIKE ogb_file.ogb05,
                                  ogb13 LIKE ogb_file.ogb13,
                                  ogb12 LIKE ogb_file.ogb12,
                                  ogb14 LIKE ogb_file.ogb14,
				  oga10	LIKE oga_file.oga10,
				  azi03	LIKE azi_file.azi03,
				  azi04	LIKE azi_file.azi04,
				  azi05	LIKE azi_file.azi05,
				  oga23 LIKE oga_file.oga23,
				  oga24 LIKE oga_file.oga24,
				  ogb910 LIKE ogb_file.ogb910,
				  ogb912 LIKE ogb_file.ogb912,
				  ogb913 LIKE ogb_file.ogb913,
				  ogb915 LIKE ogb_file.ogb915,
				  ogb916 LIKE ogb_file.ogb916,
				  ogb917 LIKE ogb_file.ogb917
                        END RECORD
     DEFINE l_i,l_cnt          LIKE type_file.num5               #No.FUN-580004        #No.FUN-680137 SMALLINT
     DEFINE i                  LIKE type_file.num5               #No.FUN-580004        #No.FUN-680137 SMALLINT
     DEFINE l_zaa02            LIKE zaa_file.zaa02  #No.FUN-580004
     DEFINE  l_gen02      LIKE gen_file.gen02,
             l_gem02      LIKE gem_file.gem02,
             l_ima021t    LIKE ima_file.ima021,
             l_ima906     LIKE ima_file.ima906,
             l_str2       LIKE type_file.chr50,
             l_ogb915     STRING,
             l_ogb912     STRING,
             l_ogb12      STRING
 DEFINE
      g_ogc        RECORD
                   ogc12 LIKE ogc_file.ogc12,
                   ogc17 LIKE ogc_file.ogc17
              END RECORD,
      l_oaz23   LIKE oaz_file.oaz23,
      l_ima02   LIKE ima_file.ima02,
      l_ima021  LIKE ima_file.ima021,
      l_ima02t  LIKE ima_file.ima02
     DEFINE     l_dbs      LIKE azp_file.azp03                               
     DEFINE     l_azp03    LIKE azp_file.azp03                               
     DEFINE     l_occ37    LIKE occ_file.occ37                               
    
     CALL cl_del_data(l_table)  #FUN-8B0025 換位置
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file   #FUN-560229
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup')
   
#FUN-A70084--mark--str--
#   FOR i = 1 TO 8 LET m_dbs[i] = NULL END FOR
#   LET m_dbs[1]=tm.p1
#   LET m_dbs[2]=tm.p2
#   LET m_dbs[3]=tm.p3
#   LET m_dbs[4]=tm.p4
#   LET m_dbs[5]=tm.p5
#   LET m_dbs[6]=tm.p6
#   LET m_dbs[7]=tm.p7
#   LET m_dbs[8]=tm.p8
#FUN-A70084--mark--end
 
#FUN-A70084--mod--str--
#  FOR l_i = 1 to 8                                                          #FUN-8B0025
#      IF cl_null(m_dbs[l_i]) THEN CONTINUE FOR END IF                       #FUN-8B0025 
#      SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=m_dbs[l_i]          #FUN-8B0025 
#      LET l_dbs = s_dbstring(l_dbs CLIPPED)                                         #FUN-8B0025
   LET l_sql = "SELECT azw01 FROM azw_file,azp_file ",
               " WHERE azp01 = azw01 AND azwacti = 'Y'",
               "   AND azw01 IN (SELECT zxy03 FROM zxy_file WHERE zxy01 = '",g_user,"')",
               "   AND ",g_wc CLIPPED 
   PREPARE sel_azw01_pre FROM l_sql
   DECLARE sel_azw01_cur CURSOR FOR sel_azw01_pre
   FOREACH sel_azw01_cur INTO m_plant
     IF cl_null(m_plant) THEN CONTINUE FOREACH END IF 
#FUN-A70084--mod--end
        
     #CHI-AC0013 add --start--
     LET l_sql = "SELECT azi03,azi04 ",                                                                              
                 "  FROM ",cl_get_target_table(m_plant, 'azi_file'),  
                 " WHERE azi01=? "                                                                                                                                                                                  
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql  
     CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql  
     PREPARE azi_prepare FROM l_sql                                                                                          
     DECLARE azi_c  CURSOR FOR azi_prepare                                                                                 

     LET l_sql = "SELECT gen02 ",                                                                              
                 "  FROM ",cl_get_target_table(m_plant, 'gen_file'),  
                 " WHERE gen01=? "                                                                                                                                                                                  
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql     
     CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql 
     PREPARE r620_prepare1 FROM l_sql                                                                                          
     DECLARE r620_c1  CURSOR FOR r620_prepare1                                                                                 

     LET l_sql = "SELECT gem02 ",                                                                              
                 "  FROM ",cl_get_target_table(m_plant, 'gem_file'),  
                 " WHERE gem01=? "                                                                                                                                                                                  
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql     
     CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql 
     PREPARE r620_prepare2 FROM l_sql                                                                                          
     DECLARE r620_c2  CURSOR FOR r620_prepare2                                                                                 

     LET l_sql = "SELECT ima021 ",                                                                              
                 "  FROM ",cl_get_target_table(m_plant, 'ima_file'),  
                 " WHERE ima01=? "                                                                                                                                                                                  
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql     
     CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql  
     PREPARE r620_prepare3 FROM l_sql                                                                                          
     DECLARE r620_c3  CURSOR FOR r620_prepare3                                                                                 

     LET l_sql = "SELECT ima021,ima906 ",                                                                              
                 "  FROM ",cl_get_target_table(m_plant, 'ima_file'),  
                 " WHERE ima01=? "                                                                                                                                                                                  
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql    
     CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql  
     PREPARE r620_prepare4 FROM l_sql                                                                                          
     DECLARE r620_c4  CURSOR FOR r620_prepare4                                                                                 

     LET l_sql = "SELECT omb01",                                                                                                 
                 "  FROM ",cl_get_target_table(m_plant, 'omb_file'),",",
                 cl_get_target_table(m_plant, 'oma_file'),               
                 " WHERE omb01 = oma01",                                                                              
                 "   AND omb31=? ",                                                                                  
                 "   AND omb32=? ",   
                 "   AND oma00='12'",      #MOD-B40096 add
                 "   AND omavoid = 'N'"    #不可作廢                                                                               
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql      
     CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql 
     PREPARE r620_prepare5 FROM l_sql                                                                                          
     DECLARE r620_c5  CURSOR FOR r620_prepare5                                                                                 

     LET l_sql = "SELECT oaz23",                                                                              
                 "  FROM ",cl_get_target_table(m_plant, 'oaz_file')  
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql     
     CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql  
     PREPARE r620_prepare6 FROM l_sql                                                                                          
     DECLARE r620_c6  CURSOR FOR r620_prepare6                                                                                 

     LET l_sql = "SELECT ima02,ima021",                                                                              
                 "  FROM ",cl_get_target_table(m_plant, 'ima_file'),  
                 " WHERE ima01=? "                                                                                                                                            
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
     CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql  
     PREPARE r620_prepare7 FROM l_sql                                                                                          
     DECLARE r620_c7  CURSOR FOR r620_prepare7                                                                                 
     #CHI-AC0013 add --end-- 
 
     LET l_sql = "SELECT '','','',",
                 "       oga01,oga02,oga03,oga032,oga04,occ02,oga14, ",
		 "       oga15,ogb03,ogb31,ogb04,ogb06,ogb05, ",
		 "       ogb13,ogb12,ogb14,oga10, ",
                 "       azi03,azi04,azi05,oga23,oga24, ",
                 "       ogb910,ogb912,ogb913,ogb915,ogb916,ogb917,  ", #No.FUN-580004
                 "       occ37",                                        #NO.FUN-8B0025
#                "  FROM ",l_dbs CLIPPED,"oga_file, ",                  #FUN-8B0025 mod   #NO.FUN-A10056
#                " OUTER ",l_dbs CLIPPED,"occ_file, ",                  #FUN-8B0025 mod   #NO.FUN-A10056
#                          l_dbs CLIPPED,"ogb_file, ",                  #FUN-8B0025 mod   #NO.FUN-A10056
#                          l_dbs CLIPPED,"azi_file  ",                  #FUN-8B0025 mod   #NO.FUN-A10056              
                #FUN-A70084--mod--str--m_dbs-->m_plant
                #"  FROM ",cl_get_target_table(m_dbs[l_i], 'oga_file'),",",  #NO.FUN-A10056
                #" OUTER ",cl_get_target_table(m_dbs[l_i], 'occ_file'),",",  #NO.FUN-A10056
                #cl_get_target_table(m_dbs[l_i], 'ogb_file'),",",            #NO.FUN-A10056
                #cl_get_target_table(m_dbs[l_i], 'azi_file'),                #NO.FUN-A10056
                 "  FROM ",cl_get_target_table(m_plant, 'oga_file'),
                 "  LEFT OUTER JOIN ",cl_get_target_table(m_plant, 'occ_file'),
                 "          ON oga_file.oga04 = occ_file.occ01,",  
                 cl_get_target_table(m_plant, 'ogb_file'),",",            
                 cl_get_target_table(m_plant, 'azi_file'),               
                #FUN-A70084--mod--end
                 " WHERE oga01 = ogb_file.ogb01 ",
                #"   AND oga_file.oga04 = occ_file.occ01 ",   #FUN-A70084
                 "   AND oga23 = azi_file.azi01 ",
                 "   AND oga09 != '1' AND oga09 !='5'", #No.B312 010406
                 "   AND oga09 != '7' AND oga09 !='9'", #No.FUN-610020
                 "   AND oga09 != '8' ",                #MOD-9A0107 
                 "   AND ogaconf != 'X' ", #No.B312
                 "   AND ",tm.wc CLIPPED	

     #-----CHI-B10027---------
     IF tm.a = 'N' THEN
        LET l_sql = l_sql," AND oga09 != 'A' "
     END IF
     #-----END CHI-B10027-----

     #No.FUN-950110--ADD--
         IF tm.oga00 MATCHES '[1234]' THEN
            LET l_sql=l_sql CLIPPED,"  AND oga00='",tm.oga00,"' "
         END IF
     #No.FUN-950110--END--

     #No.FUN-940116--ADD--
         IF tm.x='1' THEN LET l_sql=l_sql CLIPPED," AND ogaconf='Y' " END IF
         IF tm.x='2' THEN LET l_sql=l_sql CLIPPED," AND ogaconf='N' " END IF
         IF tm.v='1' THEN LET l_sql=l_sql CLIPPED," AND ogapost='Y' " END IF
         IF tm.v='2' THEN LET l_sql=l_sql CLIPPED," AND ogapost='N' " END IF
     #No.FUN-940116--END--

    #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql   #NO.FUN-A10056  #FUN-A70084
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql      #FUN-A70084
     CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql   #NO.FUN-A70084
     PREPARE axmr620_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
           
     END IF
     DECLARE axmr620_curs1 CURSOR FOR axmr620_prepare1
 
     FOREACH axmr620_curs1 INTO sr.*,l_occ37                          #FUN-8B0025 Add l_occ37
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
        IF cl_null(l_occ37) THEN LET l_occ37 = 'N' END IF
        IF tm.type = '1' THEN
           IF l_occ37  = 'N' THEN  CONTINUE FOREACH END IF
        END IF
        IF tm.type = '2' THEN   #非關係人
           IF l_occ37  = 'Y' THEN  CONTINUE FOREACH END IF
        END IF
       
       IF tm.y='Y' THEN    #將原幣金額轉成本幣金額
          LET sr.oga23=g_aza.aza17            #幣別
          LET sr.ogb14=sr.ogb14 * sr.oga24    #未稅金額*匯率
          LET sr.ogb13=sr.ogb13 * sr.oga24    #No.B512 add by linda 換成本幣
 
           #CHI-AC0013 mark --start--
           #LET l_sql = "SELECT azi03,azi04 ",                                                                              
#          #            "  FROM ",l_dbs CLIPPED,"azi_file",                     #NO.FUN-A10056
           #           #"  FROM ",cl_get_target_table(m_dbs[l_i], 'azi_file'),  #NO.FUN-A10056  #FUN-A70084
           #            "  FROM ",cl_get_target_table(m_plant, 'azi_file'),  #NO.FUN-A70084
           #            " WHERE azi01='",sr.oga23,"'"                                                                                                                                                                                  
           #   #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql   #NO.FUN-A10056  #FUN-A70084
           #    CALL cl_replace_sqldb(l_sql) RETURNING l_sql      #FUN-A70084
           #    CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql   #NO.FUN-A70084
           #    PREPARE azi_prepare FROM l_sql                                                                                          
           #    DECLARE azi_c  CURSOR FOR azi_prepare                                                                                 
           #    OPEN azi_c                                                                                    
           #CHI-AC0013 mark --end--
                OPEN azi_c USING sr.oga23 #CHI-AC0013                                                                                    
                FETCH azi_c INTO sr.azi03,sr.azi04
            SELECT azi05 INTO sr.azi05
              FROM azi_file WHERE azi01=sr.oga23         
           
       END IF
       LET sr.ogb14 = cl_digcut(sr.ogb14,sr.azi04)   #MOD-890003
        #CHI-AC0013 mark --start--
        #LET l_sql = "SELECT gen02 ",                                                                              
#       #            "  FROM ",l_dbs CLIPPED,"gen_file",                        #NO.FUN-A10056
        #           #"  FROM ",cl_get_target_table(m_dbs[l_i], 'gen_file'),     #NO.FUN-A10056   #FUN-A70084
        #            "  FROM ",cl_get_target_table(m_plant, 'gen_file'),     #NO.FUN-A70084
        #            " WHERE gen01='",sr.oga14,"'"                                                                                                                                                                                  
        #   #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql   #NO.FUN-A10056   #FUN-A70084
        #    CALL cl_replace_sqldb(l_sql) RETURNING l_sql      #FUN-A70084
        #    CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql   #NO.FUN-A70084
        #    PREPARE r620_prepare1 FROM l_sql                                                                                          
        #    DECLARE r620_c1  CURSOR FOR r620_prepare1                                                                                 
        #    OPEN r620_c1                                                                                    
        #CHI-AC0013 mark --end--
             OPEN r620_c1 USING sr.oga14 #CHI-AC0013                                                                                    
             FETCH r620_c1 INTO l_gen02
        #CHI-AC0013 mark --start--
        #LET l_sql = "SELECT gem02 ",                                                                              
#       #            "  FROM ",l_dbs CLIPPED,"gem_file",                        #NO.FUN-A10056
        #           #"  FROM ",cl_get_target_table(m_dbs[l_i], 'gem_file'),     #NO.FUN-A10056   #FUN-A70084
        #            "  FROM ",cl_get_target_table(m_plant, 'gem_file'),     #NO.FUN-A70084
        #            " WHERE gem01='",sr.oga15,"'"                                                                                                                                                                                  
        #    CALL cl_replace_sqldb(l_sql) RETURNING l_sql      #FUN-A70084
        #   #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql   #NO.FUN-A10056   #FUN-A70084 
        #    CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql   #NO.FUN-A70084
        #    PREPARE r620_prepare2 FROM l_sql                                                                                          
        #    DECLARE r620_c2  CURSOR FOR r620_prepare2                                                                                 
        #    OPEN r620_c2                                                                                    
        #CHI-AC0013 mark --end--
             OPEN r620_c2 USING sr.oga15 #CHI-AC0013                                                                                    
             FETCH r620_c2 INTO l_gem02
       
       IF sr.ogb04[1,4] !='MISC' THEN
          #CHI-AC0013 mark --start--
          #LET l_sql = "SELECT ima021 ",                                                                              
#         #            "  FROM ",l_dbs CLIPPED,"ima_file",                        #NO.FUN-A10056
          #           #"  FROM ",cl_get_target_table(m_dbs[l_i], 'ima_file'),     #NO.FUN-A10056  #FUN-A70084
          #            "  FROM ",cl_get_target_table(m_plant, 'ima_file'),     #NO.FUN-A70084
          #            " WHERE ima01='",sr.ogb04,"'"                                                                                                                                                                                  
          #    CALL cl_replace_sqldb(l_sql) RETURNING l_sql      #FUN-A70084
          #   #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql   #NO.FUN-A10056  #FUN-A70084
          #    CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql   #NO.FUN-A70084
          #    PREPARE r620_prepare3 FROM l_sql                                                                                          
          #    DECLARE r620_c3  CURSOR FOR r620_prepare3                                                                                 
          #    OPEN r620_c3                                                                                    
          #CHI-AC0013 mark --end--
               OPEN r620_c3 USING sr.ogb04 #CHI-AC0013                                                                                   
               FETCH r620_c3 INTO l_ima021
       ELSE
         LET l_ima021 = ''
       END IF
          #CHI-AC0013 mark --start--
          #LET l_sql = "SELECT ima021,ima906 ",                                                                              
#         #            "  FROM ",l_dbs CLIPPED,"ima_file",
          #           #"  FROM ",cl_get_target_table(m_dbs[l_i], 'ima_file'),     #NO.FUN-A10056  #FUN-A70084
          #            "  FROM ",cl_get_target_table(m_plant, 'ima_file'),     #NO.FUN-A70084
          #            " WHERE ima01='",sr.ogb04,"'"                                                                                                                                                                                  
          #    CALL cl_replace_sqldb(l_sql) RETURNING l_sql      #FUN-A70084
          #   #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql   #NO.FUN-A10056   #FUN-A70084
          #    CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql   #NO.FUN-A70084
          #    PREPARE r620_prepare4 FROM l_sql                                                                                          
          #    DECLARE r620_c4  CURSOR FOR r620_prepare4                                                                                 
          #    OPEN r620_c4                                                                                    
          #CHI-AC0013 mark --end--
               OPEN r620_c4 USING sr.ogb04 #CHI-AC0013                                                                                    
               FETCH r620_c4 INTO l_ima021,l_ima906
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
                LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
                IF cl_null(sr.ogb915) OR sr.ogb915 = 0 THEN
                    CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
                    LET l_str2 = l_ogb912, sr.ogb910 CLIPPED
                ELSE
                   IF NOT cl_null(sr.ogb912) AND sr.ogb912 > 0 THEN
                      CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
                      LET l_str2 = l_str2 CLIPPED,',',l_ogb912, sr.ogb910 CLIPPED
                   END IF
                END IF
            WHEN "3"
                IF NOT cl_null(sr.ogb915) AND sr.ogb915 > 0 THEN
                    CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
                    LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
                END IF
         END CASE
      ELSE
      END IF
      IF g_sma.sma116 MATCHES '[23]' THEN    #No.FUN-610076
            IF sr.ogb05  <> sr.ogb916 THEN   #No.TQC-6B0137  mod
               CALL cl_remove_zero(sr.ogb12) RETURNING l_ogb12
               LET l_str2 = l_str2 CLIPPED,"(",l_ogb12,sr.ogb05 CLIPPED,")"
            END IF
      END IF
     #因有同出貨單但項次為不同AR,以單身的出貨項次去取omb01
      LET sr.oga10=''
       #CHI-AC0013 mark --start--
       #LET l_sql = "SELECT omb01",                                                                                                 
#      #            "  FROM ",l_dbs CLIPPED,"omb_file,",l_dbs CLIPPED,"oma_file", #MOD-940242     #NO.FUN-A10056                                   
       #           #FUN-A70084--mod--str--m_dbs-->m_plant
       #           #"  FROM ",cl_get_target_table(m_dbs[l_i], 'omb_file'),",",    #NO.FUN-A10056
       #           #cl_get_target_table(m_dbs[l_i], 'oma_file'),                  #NO.FUN-A10056
       #            "  FROM ",cl_get_target_table(m_plant, 'omb_file'),",",
       #            cl_get_target_table(m_plant, 'oma_file'),               
       #           #FUN-A70084--mod--end
       #            " WHERE omb01 = oma01",   #MOD-940242                                                                           
       #            "   AND omb31='",sr.oga01,"'",                                                                                  
       #            "   AND omb32='",sr.ogb03,"'",   
       #            "   AND omavoid = 'N'"    #MOD-940242不可作廢                                                                               
       #    CALL cl_replace_sqldb(l_sql) RETURNING l_sql      #FUN-A70084
       #   #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql   #NO.FUN-A10056 #FUN-A70084
       #    CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql   #NO.FUN-A70084
       #    PREPARE r620_prepare5 FROM l_sql                                                                                          
       #    DECLARE r620_c5  CURSOR FOR r620_prepare5                                                                                 
       #    OPEN r620_c5                                                                                    
       #CHI-AC0013 mark --end--
            OPEN r620_c5 USING sr.oga01,sr.ogb03 #CHI-AC0013                                                                                   
            FETCH r620_c5 INTO sr.oga10
 
      LET l_flag = 'N'  #MOD-7A0115
       #CHI-AC0013 mark --start--
       #LET l_sql = "SELECT oaz23",                                                                              
#      #            "  FROM ",l_dbs CLIPPED,"oaz_file"
       #           #"  FROM ",cl_get_target_table(m_dbs[l_i], 'oaz_file')   #NO.FUN-A10056  #FUN-A70084
       #            "  FROM ",cl_get_target_table(m_plant, 'oaz_file')   #NO.FUN-A70084
       #    CALL cl_replace_sqldb(l_sql) RETURNING l_sql      #FUN-A70084
       #   #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql   #NO.FUN-A10056   #FUN-A70084
       #    CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql   #NO.FUN-A70084
       #    PREPARE r620_prepare6 FROM l_sql                                                                                          
       #    DECLARE r620_c6  CURSOR FOR r620_prepare6                                                                                 
       #CHI-AC0013 mark --end--
            OPEN r620_c6                                                                                    
            FETCH r620_c6 INTO l_oaz23
      IF l_oaz23 = 'Y' AND tm.c='Y' THEN
         LET g_sql = "SELECT ogc12,ogc17 ",
#                    "  FROM ",l_dbs CLIPPED,"ogc_file", #FUN-8B0025 mod      #NO.FUN-A10056                 
#                    "  FROM ",cl_get_target_table(m_dbs[l_i], 'oma_file'),   #NO.FUN-A10056  #No.TQC-A50044
                    #"  FROM ",cl_get_target_table(m_dbs[l_i], 'ogc_file'),   #NO.FUN-A10056  #No.TQC-A50044   #FUN-A70084
                     "  FROM ",cl_get_target_table(m_plant, 'ogc_file'),   #NO.FUN-A70084
                     " WHERE ogc01 = '",sr.oga01,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql      #FUN-A70084  
        #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql   #NO.FUN-A10056   #FUN-A70084
         CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql   #NO.FUN-A70084
         PREPARE ogc_prepare FROM g_sql
         DECLARE ogc_cs CURSOR FOR ogc_prepare
         FOREACH ogc_cs INTO g_ogc.*
            LET l_flag = 'Y'
             #CHI-AC0013 mark --start--
             #LET l_sql = "SELECT ima02,ima021",                                                                              
#            #            "  FROM ",l_dbs CLIPPED,"ima_file",
             #           #"  FROM ",cl_get_target_table(m_dbs[l_i], 'ima_file'),   #NO.FUN-A10056   #FUN-A70084
             #            "  FROM ",cl_get_target_table(m_plant, 'ima_file'),   #NO.FUN-A70084
             #            " WHERE ima01='",g_ogc.ogc17,"'"                                                                                                                                            
             #    CALL cl_replace_sqldb(l_sql) RETURNING l_sql      #FUN-A70084
             #   #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql   #NO.FUN-A10056   #FUN-A70084
             #    CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql   #NO.FUN-A70084
             #    PREPARE r620_prepare7 FROM l_sql                                                                                          
             #    DECLARE r620_c7  CURSOR FOR r620_prepare7                                                                                 
             #    OPEN r620_c7                                                                                    
             #CHI-AC0013 mark --end--
                  OPEN r620_c7 USING g_ogc.ogc17 #CHI-AC0013                                                                                   
                  FETCH r620_c7 INTO l_ima02t,l_ima021t
            EXECUTE insert_prept111 USING sr.oga01,sr.oga02,
                                sr.oga03,sr.oga032,sr.oga04,sr.occ02,sr.oga14,
                               l_gen02,sr.oga15,l_gem02,sr.ogb03,sr.ogb31,sr.ogb04,
                               sr.ogb06,l_ima021,l_str2,sr.ogb05,sr.oga23,
                               sr.ogb13,sr.ogb12,sr.ogb916,sr.ogb917,sr.ogb14,
                              sr.oga10,tm.y,
                              tm.c,     l_oaz23,  g_ogc.ogc17, l_ima02t,l_ima021t,     #FUN-8B0025 mod
                             #g_ogc.ogc12,sr.azi03, sr.azi04, sr.azi05, m_dbs[l_i]     #FUN-8B0025 mod   #FUN-A70084
                              g_ogc.ogc12,sr.azi03, sr.azi04, sr.azi05, m_plant     #FUN-A70084
         END FOREACH      	 
      END IF
      IF l_flag != 'Y' THEN
          EXECUTE insert_prept111 USING sr.oga01,sr.oga02,
                                sr.oga03,sr.oga032,sr.oga04,sr.occ02,sr.oga14,
                               l_gen02,sr.oga15,l_gem02,sr.ogb03,sr.ogb31,sr.ogb04,
                               sr.ogb06,l_ima021,l_str2,sr.ogb05,sr.oga23,
                               sr.ogb13,sr.ogb12,sr.ogb916,sr.ogb917,sr.ogb14,
                              sr.oga10,tm.y,tm.c,l_oaz23,
                              g_ogc.ogc17,l_ima02t,l_ima021t,g_ogc.ogc12,sr.azi03,
                             #sr.azi04,sr.azi05,m_dbs[l_i]                             #FUN-8B0025 add m_dbs[l_i]   #FUN-A70084
                              sr.azi04,sr.azi05,m_plant                           #FUN-A70084  
      END IF
      LET l_flag = 'N' 
     END FOREACH
 
   #END FOR   #FUN-8B0025  add   #FUN-A70084
    END FOREACH    #FUN-A70084   
 
     LET l_sql = " SELECT *",
                 "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axmr620'  
     IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'oga01,oga02,oga03,oga04,oga14,oga15,oga23,ogb04')   #No.FUN-6C0039
              RETURNING tm.wc                
     END IF     
     LET l_str = tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",
                 tm.u[1,1],";",tm.u[2,2],";",tm.u[3,3],";",
                 tm.wc CLIPPED,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3]
    #IF tm.b='Y' THEN    #FUN-A70084 
        IF g_sma.sma116 MATCHES '[23]' THEN 
           CALL cl_prt_cs3('axmr620','axmr620_3',l_sql,l_str)
        ELSE 
           IF g_sma115 ='Y' THEN
              CALL cl_prt_cs3('axmr620','axmr620_4',l_sql,l_str)
           ELSE 
              CALL cl_prt_cs3('axmr620','axmr620_5',l_sql,l_str)
           END IF
        END IF
   #FUN-A70084--mark--str--
   # ELSE
   #    IF g_sma.sma116 MATCHES '[23]' THEN 
   #       CALL cl_prt_cs3('axmr620','axmr620',l_sql,l_str)
   #    ELSE 
   #       IF g_sma115 ='Y' THEN
   #          CALL cl_prt_cs3('axmr620','axmr620_1',l_sql,l_str)
   #       ELSE 
   #          CALL cl_prt_cs3('axmr620','axmr620_2',l_sql,l_str)
   #       END IF
   #    END IF
   # END IF 
   #FUN-A70084--mark--end
     
END FUNCTION
 
#FUN-A70084--mark--str--
#FUNCTION r620_set_entry_1()
#    CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",TRUE)
#END FUNCTION
 
#FUNCTION r620_set_no_entry_1()
#   IF tm.b = 'N' THEN
#      CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",FALSE)
#      IF tm2.s1 = '5' THEN                                                                                                         
#         LET tm2.s1 = ' '                                                                                                          
#      END IF                                                                                                                       
#      IF tm2.s2 = '5' THEN                                                                                                         
#         LET tm2.s2 = ' '                                                                                                          
#      END IF                                                                                                                       
#      IF tm2.s3 = '5' THEN                                                                                                         
#         LET tm2.s2 = ' '                                                                                                          
#      END IF
#   END IF
#END FUNCTION
 
#FUNCTION r620_set_comb()                                                                                                            
# DEFINE comb_value STRING                                                                                                          
# DEFINE comb_item  LIKE type_file.chr1000                                                                                          
#                                                                                                                                   
#   IF tm.b ='N' THEN                                                                                                         
#      LET comb_value = '1,2,3,4,5,6,7'                                                                                                   
#      SELECT ze03 INTO comb_item FROM ze_file                                                                                      
#        WHERE ze01='axm-833' AND ze02=g_lang                                                                                      
#   ELSE                                                                                                                            
#      LET comb_value = '1,2,3,4,5,6,7,8'                                                                                                   
#      SELECT ze03 INTO comb_item FROM ze_file                                                                                      
#        WHERE ze01='axm-834' AND ze02=g_lang                                                                                       
#   END IF                                                                                                                          
#   CALL cl_set_combo_items('s1',comb_value,comb_item)
#   CALL cl_set_combo_items('s2',comb_value,comb_item)
#   CALL cl_set_combo_items('s3',comb_value,comb_item)                                                                          
#END FUNCTION
#FUN-A70084--mark--end
#No:FUN-9C0071--------精簡程式-----
