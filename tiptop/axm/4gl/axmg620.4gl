# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: axmg620.4gl
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
# Modify.........: No:FUN-C70057 12/07/13 By lixiang CR報表改GR報表
# Modify.........: No:FUN-CB0058 12/12/20 By yangtt 清除4rp中detail里的定位點

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
              d      LIKE type_file.chr1,   
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
DEFINE  m_plant     LIKE azw_file.azw01   #FUN-A70084
DEFINE  g_wc        LIKE type_file.chr1000   #FUN-A70084 

###GENGRE###START
TYPE sr1_t RECORD
    order1 LIKE type_file.chr20,
    order2 LIKE type_file.chr20,
    order3 LIKE type_file.chr20,    
    oga01 LIKE oga_file.oga01,
    oga02 LIKE oga_file.oga02,
    oga03 LIKE oga_file.oga03,
    oga032 LIKE oga_file.oga032,
    oga04 LIKE oga_file.oga04,
    occ02 LIKE occ_file.occ02,
    oga14 LIKE oga_file.oga14,
    gen02 LIKE gen_file.gen02,
    oga15 LIKE oga_file.oga15,
    gem02 LIKE gem_file.gem02,
    ogb03 LIKE ogb_file.ogb03,
    ogb31 LIKE ogb_file.ogb31,
    ogb04 LIKE ogb_file.ogb04,
    ogb06 LIKE ogb_file.ogb06,
    ima021 LIKE ima_file.ima021,
    str2 LIKE type_file.chr50,
    ogb05 LIKE ogb_file.ogb05,
    oga23 LIKE oga_file.oga23,
    oga23_1 LIKE oga_file.oga23,
    oga23_2 LIKE oga_file.oga23,
    oga23_3 LIKE oga_file.oga23,
    ogb13 LIKE ogb_file.ogb13,
    ogb12 LIKE ogb_file.ogb12,
    ogb916 LIKE ogb_file.ogb916,
    ogb917 LIKE ogb_file.ogb917,
    ogb14 LIKE ogb_file.ogb14,
    oga10 LIKE oga_file.oga10,
    y LIKE type_file.chr1,    
    c LIKE type_file.chr1,    
    oaz23 LIKE type_file.chr1,
    ogc175 LIKE ogc_file.ogc17,
    ima025 LIKE ima_file.ima02,
    ima0215 LIKE ima_file.ima021,
    ogc125 LIKE ogc_file.ogc12,
    azi03 LIKE azi_file.azi03,
    azi04 LIKE azi_file.azi04,
    azi05 LIKE azi_file.azi05,
    plant LIKE azp_file.azp01
END RECORD
###GENGRE###END

TYPE sr2_t   RECORD
     oga23   LIKE oga_file.oga23,
     ogb14   LIKE ogb_file.ogb14
END RECORD
DEFINE l_table1     STRING 
DEFINE l_table2     STRING
DEFINE l_table3     STRING

TYPE sr3_t RECORD
    agd03_1  LIKE agd_file.agd03,
    agd03_2  LIKE agd_file.agd03,
    agd03_3  LIKE agd_file.agd03,
    agd03_4  LIKE agd_file.agd03,
    agd03_5  LIKE agd_file.agd03,
    agd03_6  LIKE agd_file.agd03,
    agd03_7  LIKE agd_file.agd03,
    agd03_8  LIKE agd_file.agd03,
    agd03_9  LIKE agd_file.agd03,
    agd03_10 LIKE agd_file.agd03,
    agd03_11 LIKE agd_file.agd03,
    agd03_12 LIKE agd_file.agd03,
    agd03_13 LIKE agd_file.agd03,
    agd03_14 LIKE agd_file.agd03,
    agd03_15 LIKE agd_file.agd03,
    oga01    LIKE oga_file.oga01,
    ogb03    LIKE ogb_file.ogb03,
    plant    LIKE azp_file.azp01
END RECORD
TYPE sr4_t RECORD
    color    LIKE agd_file.agd03,
    ogb12_1  LIKE ogb_file.ogb12,
    ogb12_2  LIKE ogb_file.ogb12,
    ogb12_3  LIKE ogb_file.ogb12,
    ogb12_4  LIKE ogb_file.ogb12,
    ogb12_5  LIKE ogb_file.ogb12,
    ogb12_6  LIKE ogb_file.ogb12,
    ogb12_7  LIKE ogb_file.ogb12,
    ogb12_8  LIKE ogb_file.ogb12,
    ogb12_9  LIKE ogb_file.ogb12,
    ogb12_10 LIKE ogb_file.ogb12,
    ogb12_11 LIKE ogb_file.ogb12,
    ogb12_12 LIKE ogb_file.ogb12,
    ogb12_13 LIKE ogb_file.ogb12,
    ogb12_14 LIKE ogb_file.ogb12,
    ogb12_15 LIKE ogb_file.ogb12,
    oga01    LIKE oga_file.oga01,
    ogb03    LIKE ogb_file.ogb03,
    plant    LIKE azp_file.azp01
END RECORD

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
 
   LET g_sql = "order1.type_file.chr20,",
               "order2.type_file.chr20,",
               "order3.type_file.chr20,",
               "oga01.oga_file.oga01,",
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
               " oga23_1.oga_file.oga23,",
               " oga23_2.oga_file.oga23,",
               " oga23_3.oga_file.oga23,",
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
               
   LET l_table = cl_prt_temptable('axmg620',g_sql) CLIPPED
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)
      EXIT PROGRAM 
   END IF
   
   LET g_sql = " oga23.oga_file.oga23,",
               " ogb14.ogb_file.ogb14,"
   LET l_table1= cl_prt_temptable('axmg6201',g_sql) CLIPPED
   IF l_table1 = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)
      EXIT PROGRAM 
   END IF

   LET g_sql = "agd03_1.agd_file.agd03,",
               "agd03_2.agd_file.agd03,",
               "agd03_3.agd_file.agd03,",
               "agd03_4.agd_file.agd03,",
               "agd03_5.agd_file.agd03,",
               "agd03_6.agd_file.agd03,",
               "agd03_7.agd_file.agd03,",
               "agd03_8.agd_file.agd03,",
               "agd03_9.agd_file.agd03,",
               "agd03_10.agd_file.agd03,",
               "agd03_11.agd_file.agd03,",
               "agd03_12.agd_file.agd03,",
               "agd03_13.agd_file.agd03,",
               "agd03_14.agd_file.agd03,",
               "agd03_15.agd_file.agd03,",
               "oga01.oga_file.oga01,",
               "ogb03.ogb_file.ogb03,",
               "plant.azp_file.azp01"
   LET l_table2 = cl_prt_temptable('axmg6202',g_sql) CLIPPED
   IF  l_table2 = -1 THEN
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)
       EXIT PROGRAM
   END IF
   LET g_sql = "color.agd_file.agd03,",
               "ogb12_1.ogb_file.ogb12,",
               "ogb12_2.ogb_file.ogb12,",
               "ogb12_3.ogb_file.ogb12,",
               "ogb12_4.ogb_file.ogb12,",
               "ogb12_5.ogb_file.ogb12,",
               "ogb12_6.ogb_file.ogb12,",
               "ogb12_7.ogb_file.ogb12,",
               "ogb12_8.ogb_file.ogb12,",
               "ogb12_9.ogb_file.ogb12,",
               "ogb12_10.ogb_file.ogb12,",
               "ogb12_11.ogb_file.ogb12,",
               "ogb12_12.ogb_file.ogb12,",
               "ogb12_13.ogb_file.ogb12,",
               "ogb12_14.ogb_file.ogb12,",
               "ogb12_15.ogb_file.ogb12,",
               "oga01.oga_file.oga01,",
               "ogb03.ogb_file.ogb03,",
               "plant.azp_file.azp01"
   LET l_table3 = cl_prt_temptable('axmg6203',g_sql) CLIPPED
   IF  l_table3 = -1 THEN
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)
       EXIT PROGRAM
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
   LET tm.type  = ARG_VAL(17)
   LET tm.oga00 = ARG_VAL(28)   #No.FUN-950110
   LET tm.x     = ARG_VAL(29)   #No.FUN-940116
   LET tm.v     = ARG_VAL(30)   #No.FUN-940116
   LET g_wc = ARG_VAL(18)
   LET tm.a = ARG_VAL(19)   #CHI-B10027
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL axmg620_tm(0,0)        # Input print condition
      ELSE CALL axmg620()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmg620_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
   DEFINE l_oaz23     LIKE oaz_file.oaz23    #No.FUN-5C0075
 
   LET p_row = 3 LET p_col = 15
 
   OPEN WINDOW axmg620_w AT p_row,p_col WITH FORM "axm/42f/axmg620"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
   SELECT oaz23 INTO l_oaz23 FROM oaz_file
   IF l_oaz23 = 'N' THEN
      CALL cl_set_comp_visible("c",FALSE)
   END IF
   IF s_industry("slk") AND g_azw.azw04 = '2' THEN
      CALL cl_set_comp_visible("d",TRUE)
      CALL cl_set_comp_visible("y,c,more",FALSE)
   ELSE
      CALL cl_set_comp_visible("d",FALSE)
      CALL cl_set_comp_visible("y,c,more",TRUE)
   END IF
   CALL cl_set_comp_visible("b,group02",FALSE)

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
   LET tm.c    = 'N' 
   LET tm.a    = 'N'     #CHI-B10027
   IF s_industry("slk") AND g_azw.azw04 = '2' THEN
      LET tm.d    = 'Y'  
   ELSE
      LET tm.d    = 'N'
   END IF
   LET tm.more = 'N'
   LET tm.x='2'       #No.FUN-940116
   LET tm.v='2'       #No.FUN-940116
   LET tm.oga00='A'   #No.FUN-950110
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.type  = '3'
WHILE TRUE

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
     CLOSE WINDOW axmg620_w 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time
     CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)    #FUN-C70057 add
     EXIT PROGRAM
  END IF

   CONSTRUCT BY NAME tm.wc ON oga01,oga02,oga03,oga04,oga14,oga15,oga23,ogb04
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
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
                IF s_industry("slk") AND g_azw.azw04 = '2' THEN
                   LET g_qryparam.form = "q_ima01_slk"
                ELSE
                   LET g_qryparam.form = "q_ima"
                END IF          
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
      LET INT_FLAG = 0 CLOSE WINDOW axmg620_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)    #FUN-C70057 add
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.more         # Condition
 
   INPUT BY NAME tm.oga00,tm.d,tm.y,tm.c,tm.a,tm.type,       #No.FUN-950110 add tm.oga00
                 tm.x,tm.v,
                 tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
                 tm2.u1,tm2.u2,tm2.u3,
                 tm.more WITHOUT DEFAULTS    #No.FUn-5C0075
                 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         
       AFTER FIELD oga00
          IF tm.oga00 NOT MATCHES '[A1234]' THEN
             NEXT FIELD oga00
          END IF

       AFTER FIELD type
          IF cl_null(tm.type) OR tm.type NOT MATCHES '[123]' THEN
             NEXT FIELD type
          END IF                 
       
      AFTER FIELD d
        IF cl_null(tm.d) OR tm.d NOT MATCHES '[YN]' THEN
           NEXT FIELD d
        END IF

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
         
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axmg620_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)    #FUN-C70057 add
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmg620'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axmg620','9031',1)   
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
                         " '",tm.d CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",tm.y CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",  
                         " '",g_rep_user CLIPPED,"'",      #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",      #No.FUN-570264
                         " '",g_template CLIPPED,"'",      #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'",      #No.FUN-7C0078
                         " '",tm.type CLIPPED,"'",         #FUN-8B0025                         
                         " '",g_wc CLIPPED,"'",         #FUN-A70084
                         " '",tm.a CLIPPED,"'"    #CHI-B10027
                         
         CALL cl_cmdat('axmg620',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmg620_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)    #FUN-C70057 add
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmg620()
   ERROR ""
END WHILE
   CLOSE WINDOW axmg620_w
END FUNCTION
 
FUNCTION axmg620()
   DEFINE l_name    LIKE type_file.chr20,      # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
          l_time    LIKE type_file.chr8,       #No.FUN-6A0094
          l_sql     STRING,                    #TQC-B50069
          l_chr     LIKE type_file.chr1,       #No.FUN-680137 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
         l_order    ARRAY[5] OF LIKE oea_file.oea01,             # No.FUN-680137  VARCHAR(16)   #No.FUN-550070
         sr               RECORD  order1 LIKE type_file.chr20, 
                                  order2 LIKE type_file.chr20,
                                  order3 LIKE type_file.chr20,
                                  oga01 LIKE oga_file.oga01,
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
     DEFINE     sr2          sr2_t      #FUN-C70057   

     DEFINE l_imx01        LIKE imx_file.imx01
     DEFINE l_imx02        LIKE imx_file.imx02
     DEFINE l_agd03        LIKE agd_file.agd03
     DEFINE l_agd04        LIKE agd_file.agd04
     DEFINE l_imx000       LIKE imx_file.imx000
     DEFINE l_color        LIKE agd_file.agd03
     DEFINE sr3      sr3_t   
     DEFINE sr4      sr4_t
     DEFINE l_n            LIKE type_file.num5
     DEFINE l_imx    DYNAMIC ARRAY OF RECORD
                 imx02   LIKE imx_file.imx02
                     END RECORD
 
     CALL cl_del_data(l_table) 
     CALL cl_del_data(l_table1) 
     CALL cl_del_data(l_table2)  
     CALL cl_del_data(l_table3)
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file   #FUN-560229
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup')
   
   LET g_sql = " INSERT INTO ",g_cr_db_str CLIPPED,l_table clipped,
               " VALUES(?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",  
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"
   PREPARE insert_prept FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)
      EXIT PROGRAM
   END IF

   LET g_sql = " INSERT INTO ",g_cr_db_str CLIPPED,l_table1 clipped,
               " VALUES(?,?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)
      EXIT PROGRAM
   END IF

  #款式明細
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep2:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)
      EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
               " VALUES(?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"
   PREPARE insert_prep3 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep3:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)
      EXIT PROGRAM
   END IF

   LET l_sql = "SELECT azw01 FROM azw_file,azp_file ",
               " WHERE azp01 = azw01 AND azwacti = 'Y'",
               "   AND azw01 IN (SELECT zxy03 FROM zxy_file WHERE zxy01 = '",g_user,"')",
               "   AND ",g_wc CLIPPED 
   PREPARE sel_azw01_pre FROM l_sql
   DECLARE sel_azw01_cur CURSOR FOR sel_azw01_pre
   FOREACH sel_azw01_cur INTO m_plant
     IF cl_null(m_plant) THEN CONTINUE FOREACH END IF 
     
     LET l_sql = "SELECT azi03,azi04 ",                                                                              
                 "  FROM ",cl_get_target_table(m_plant, 'azi_file'),  
                 " WHERE azi01=? "                                                                                                                                                                                  
     PREPARE azi_prepare FROM l_sql                                                                                          
     DECLARE azi_c  CURSOR FOR azi_prepare                                                                                 

     LET l_sql = "SELECT gen02 ",                                                                              
                 "  FROM ",cl_get_target_table(m_plant, 'gen_file'),  
                 " WHERE gen01=? "                                                                                                                                                                                  
     PREPARE g620_prepare1 FROM l_sql                                                                                          
     DECLARE g620_c1  CURSOR FOR g620_prepare1                                                                                 

     LET l_sql = "SELECT gem02 ",                                                                              
                 "  FROM ",cl_get_target_table(m_plant, 'gem_file'),  
                 " WHERE gem01=? "                                                                                                                                                                                  
     PREPARE g620_prepare2 FROM l_sql                                                                                          
     DECLARE g620_c2  CURSOR FOR g620_prepare2                                                                                 

     LET l_sql = "SELECT ima021 ",                                                                              
                 "  FROM ",cl_get_target_table(m_plant, 'ima_file'),  
                 " WHERE ima01=? "                                                                                                                                                                                  
     PREPARE g620_prepare3 FROM l_sql                                                                                          
     DECLARE g620_c3  CURSOR FOR g620_prepare3                                                                                 

     LET l_sql = "SELECT ima021,ima906 ",                                                                              
                 "  FROM ",cl_get_target_table(m_plant, 'ima_file'),  
                 " WHERE ima01=? "                                                                                                                                                                                  
     PREPARE g620_prepare4 FROM l_sql                                                                                          
     DECLARE g620_c4  CURSOR FOR g620_prepare4                                                                                 

     LET l_sql = "SELECT omb01",                                                                                                 
                 "  FROM ",cl_get_target_table(m_plant, 'omb_file'),",",
                 cl_get_target_table(m_plant, 'oma_file'),               
                 " WHERE omb01 = oma01",                                                                              
                 "   AND omb31=? ",                                                                                  
                 "   AND omb32=? ",   
                 "   AND oma00='12'",      #MOD-B40096 add
                 "   AND omavoid = 'N'"    #不可作廢                                                                               
     PREPARE g620_prepare5 FROM l_sql                                                                                          
     DECLARE g620_c5  CURSOR FOR g620_prepare5                                                                                 

     LET l_sql = "SELECT oaz23",                                                                              
                 "  FROM ",cl_get_target_table(m_plant, 'oaz_file')  
     PREPARE g620_prepare6 FROM l_sql                                                                                          
     DECLARE g620_c6  CURSOR FOR g620_prepare6                                                                                 

     LET l_sql = "SELECT ima02,ima021",                                                                              
                 "  FROM ",cl_get_target_table(m_plant, 'ima_file'),  
                 " WHERE ima01=? "                                                                                                                                            
     PREPARE g620_prepare7 FROM l_sql                                                                                          
     DECLARE g620_c7  CURSOR FOR g620_prepare7                                                                                 

     LET l_sql = "SELECT DISTINCT(imx01),agd04,agd03",
                 "  FROM ",cl_get_target_table(m_plant, 'imx_file'),
                 "  ,    ",cl_get_target_table(m_plant, 'agd_file'),
                 "  ,    ",cl_get_target_table(m_plant, 'ima_file'),
                 " WHERE imx01=agd02 AND imx00=? AND ima01=? ",
                 "   AND agd01 IN (SELECT ima940 FROM ",cl_get_target_table(m_plant, 'ima_file'),
                 "                  WHERE ima01 = ?) ",
                 " ORDER BY agd04 " 
     PREPARE g620_prepare8 FROM l_sql
     DECLARE g620_c8 CURSOR FOR g620_prepare8

     LET l_sql = "SELECT DISTINCT(imx02),agd04,agd03",
                 "  FROM ",cl_get_target_table(m_plant, 'imx_file'),
                 "  ,    ",cl_get_target_table(m_plant, 'agd_file'),
                 "  ,    ",cl_get_target_table(m_plant, 'ima_file'),
                 " WHERE imx02=agd02 AND imx00=? AND ima01=? ",
                 "   AND agd01 IN (SELECT ima941 FROM ",cl_get_target_table(m_plant, 'ima_file'),
                 "                  WHERE ima01 = ?) ",
                 " ORDER BY agd04 "
     PREPARE g620_prepare9 FROM l_sql
     DECLARE g620_c9 CURSOR FOR g620_prepare9

     IF tm.d = "Y" THEN
        LET l_sql = "SELECT DISTINCT '','','',",
                    "       oga01,oga02,oga03,oga032,oga04,occ02,oga14, ",
                    "       oga15,ogbslk03,ogbslk31,ogbslk04,ogbslk06,ogbslk05, ",
                    "       ogbslk13,ogbslk12,ogbslk14,oga10, ",
                    "       azi03,azi04,azi05,oga23,oga24, ",
                    "       ogbslk05,ogbslk12,ogbslk05,ogbslk12,ogbslk05,ogbslk12,  ", #No.FUN-580004
                    "       occ37",                                        #NO.FUN-8B0025
                    "  FROM ",cl_get_target_table(m_plant, 'oga_file'),
                    "  LEFT OUTER JOIN ",cl_get_target_table(m_plant, 'occ_file'),
                    "          ON oga_file.oga04 = occ_file.occ01,",
                    cl_get_target_table(m_plant, 'ogbslk_file'),",",
                    cl_get_target_table(m_plant, 'azi_file'),
                    " WHERE oga01 = ogbslk_file.ogbslk01 ",
                    "   AND oga23 = azi_file.azi01 ",
                    "   AND oga09 != '1' AND oga09 !='5'", #No.B312 010406
                    "   AND oga09 != '7' AND oga09 !='9'", #No.FUN-610020
                    "   AND oga09 != '8' ",                #MOD-9A0107
                    "   AND ogaconf != 'X' ", #No.B312
                    "   AND ",tm.wc CLIPPED
     ELSE 
        LET l_sql = "SELECT '','','',",
                    "       oga01,oga02,oga03,oga032,oga04,occ02,oga14, ",
              	    "       oga15,ogb03,ogb31,ogb04,ogb06,ogb05, ",
              	    "       ogb13,ogb12,ogb14,oga10, ",
                    "       azi03,azi04,azi05,oga23,oga24, ",
                    "       ogb910,ogb912,ogb913,ogb915,ogb916,ogb917,  ", #No.FUN-580004
                    "       occ37",                                        #NO.FUN-8B0025
                    "  FROM ",cl_get_target_table(m_plant, 'oga_file'),
                    "  LEFT OUTER JOIN ",cl_get_target_table(m_plant, 'occ_file'),
                    "          ON oga_file.oga04 = occ_file.occ01,",  
                    cl_get_target_table(m_plant, 'ogb_file'),",",            
                    cl_get_target_table(m_plant, 'azi_file'),               
                    " WHERE oga01 = ogb_file.ogb01 ",
                    "   AND oga23 = azi_file.azi01 ",
                    "   AND oga09 != '1' AND oga09 !='5'", #No.B312 010406
                    "   AND oga09 != '7' AND oga09 !='9'", #No.FUN-610020
                    "   AND oga09 != '8' ",                #MOD-9A0107 
                    "   AND ogaconf != 'X' ", #No.B312
                    "   AND ",tm.wc CLIPPED	
     END IF

     IF tm.a = 'N' THEN
        LET l_sql = l_sql," AND oga09 != 'A' "
     END IF
     IF tm.oga00 MATCHES '[1234]' THEN
        LET l_sql=l_sql CLIPPED,"  AND oga00='",tm.oga00,"' "
     END IF

     IF tm.x='1' THEN LET l_sql=l_sql CLIPPED," AND ogaconf='Y' " END IF
     IF tm.x='2' THEN LET l_sql=l_sql CLIPPED," AND ogaconf='N' " END IF
     IF tm.v='1' THEN LET l_sql=l_sql CLIPPED," AND ogapost='Y' " END IF
     IF tm.v='2' THEN LET l_sql=l_sql CLIPPED," AND ogapost='N' " END IF

     PREPARE axmg620_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)    #FUN-C70057 add
        EXIT PROGRAM
           
     END IF
     DECLARE axmg620_curs1 CURSOR FOR axmg620_prepare1
 
     FOREACH axmg620_curs1 INTO sr.*,l_occ37                          #FUN-8B0025 Add l_occ37
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        FOR g_i = 1 TO 3
           CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.oga01
                WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.oga02 USING 'YYYYMMDD'
                WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.oga03
                WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.oga04
                WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.oga14
                WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.oga15
                WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.oga23
                WHEN tm.s[g_i,g_i] = '8' LET l_order[g_i] = m_plant
                OTHERWISE LET l_order[g_i] = '-'
           END CASE
        END FOR
        LET sr.order1 = l_order[1]
        LET sr.order2 = l_order[2]
        LET sr.order3 = l_order[3]
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

           OPEN azi_c USING sr.oga23 #CHI-AC0013
           FETCH azi_c INTO sr.azi03,sr.azi04
           SELECT azi05 INTO sr.azi05
               FROM azi_file WHERE azi01=sr.oga23
        END IF       
       #LET sr.ogb14 = cl_digcut(sr.ogb14,sr.azi04)   #MOD-890003
        OPEN g620_c1 USING sr.oga14 #CHI-AC0013                                                                                    
        FETCH g620_c1 INTO l_gen02
        OPEN g620_c2 USING sr.oga15 #CHI-AC0013                                                                                    
        FETCH g620_c2 INTO l_gem02
       
        IF sr.ogb04[1,4] !='MISC' THEN
           OPEN g620_c3 USING sr.ogb04 #CHI-AC0013                                                                                   
           FETCH g620_c3 INTO l_ima021
        ELSE
           LET l_ima021 = ''
        END IF
        OPEN g620_c4 USING sr.ogb04 #CHI-AC0013                                                                                    
        FETCH g620_c4 INTO l_ima021,l_ima906
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
        OPEN g620_c5 USING sr.oga01,sr.ogb03 #CHI-AC0013                                                                                   
        FETCH g620_c5 INTO sr.oga10
 
        OPEN g620_c6                                                                                    
        FETCH g620_c6 INTO l_oaz23
        IF l_oaz23 = 'Y' AND tm.c='Y' THEN
           LET g_sql = "SELECT ogc12,ogc17 ",
                       "  FROM ",cl_get_target_table(m_plant, 'ogc_file'),   #NO.FUN-A70084
                       " WHERE ogc01 = '",sr.oga01,"'"
           PREPARE ogc_prepare FROM g_sql
           DECLARE ogc_cs CURSOR FOR ogc_prepare
           FOREACH ogc_cs INTO g_ogc.*
              LET l_flag = 'Y'
              OPEN g620_c7 USING g_ogc.ogc17 #CHI-AC0013
              FETCH g620_c7 INTO l_ima02t,l_ima021t
              EXECUTE insert_prept USING sr.order1,sr.order2,sr.order3,sr.oga01,sr.oga02,
                                  sr.oga03,sr.oga032,sr.oga04,sr.occ02,sr.oga14,
                                 l_gen02,sr.oga15,l_gem02,sr.ogb03,sr.ogb31,sr.ogb04,
                                 sr.ogb06,l_ima021,l_str2,sr.ogb05,sr.oga23,sr.oga23,sr.oga23,sr.oga23,
                                 sr.ogb13,sr.ogb12,sr.ogb916,sr.ogb917,sr.ogb14,
                                sr.oga10,tm.y,
                                tm.c,     l_oaz23,  g_ogc.ogc17, l_ima02t,l_ima021t,     #FUN-8B0025 mod
                                g_ogc.ogc12,sr.azi03, sr.azi04, sr.azi05, m_plant     #FUN-A70084
           END FOREACH
        END IF
        IF l_flag != 'Y' THEN
            EXECUTE insert_prept USING sr.order1,sr.order2,sr.order3,sr.oga01,sr.oga02,
                                  sr.oga03,sr.oga032,sr.oga04,sr.occ02,sr.oga14,
                                 l_gen02,sr.oga15,l_gem02,sr.ogb03,sr.ogb31,sr.ogb04,
                                 sr.ogb06,l_ima021,l_str2,sr.ogb05,sr.oga23,sr.oga23,sr.oga23,sr.oga23,
                                 sr.ogb13,sr.ogb12,sr.ogb916,sr.ogb917,sr.ogb14,
                                sr.oga10,tm.y,tm.c,l_oaz23,
                                g_ogc.ogc17,l_ima02t,l_ima021t,g_ogc.ogc12,sr.azi03,
                                sr.azi04,sr.azi05,m_plant                           #FUN-A70084
        END IF
        LET l_flag = 'N'

        #加載母料件編號的尺寸
        LET l_i = 1
        INITIALIZE sr3.* TO NULL
        FOREACH g620_c9 USING sr.ogb04,sr.ogb04,sr.ogb04 INTO l_imx02,l_agd04,l_agd03
           IF l_i = 1 THEN
              LET sr3.agd03_1 = l_agd03
              LET l_imx[l_i].imx02 = l_imx02
           END IF
           IF l_i = 2 THEN
              LET sr3.agd03_2 = l_agd03
              LET l_imx[l_i].imx02 = l_imx02
           END IF
           IF l_i = 3 THEN
              LET sr3.agd03_3 = l_agd03
              LET l_imx[l_i].imx02 = l_imx02
           END IF
           IF l_i = 4 THEN
              LET sr3.agd03_4 = l_agd03
              LET l_imx[l_i].imx02 = l_imx02
           END IF
           IF l_i = 5 THEN
              LET sr3.agd03_5 = l_agd03
              LET l_imx[l_i].imx02 = l_imx02
           END IF
           IF l_i = 6 THEN
              LET sr3.agd03_6 = l_agd03
              LET l_imx[l_i].imx02 = l_imx02
           END IF
           IF l_i = 7 THEN
              LET sr3.agd03_7 = l_agd03
              LET l_imx[l_i].imx02 = l_imx02
           END IF
           IF l_i = 8 THEN
              LET sr3.agd03_8 = l_agd03
              LET l_imx[l_i].imx02 = l_imx02
           END IF
           IF l_i = 9 THEN
              LET sr3.agd03_9 = l_agd03
              LET l_imx[l_i].imx02 = l_imx02
           END IF
           IF l_i = 10 THEN
              LET sr3.agd03_10 = l_agd03
              LET l_imx[l_i].imx02 = l_imx02
           END IF
           IF l_i = 11 THEN
              LET sr3.agd03_11 = l_agd03
              LET l_imx[l_i].imx02 = l_imx02
           END IF
           IF l_i = 12 THEN
              LET sr3.agd03_12 = l_agd03
              LET l_imx[l_i].imx02 = l_imx02
           END IF
           IF l_i = 13 THEN
              LET sr3.agd03_13 = l_agd03
              LET l_imx[l_i].imx02 = l_imx02
           END IF
           IF l_i = 14 THEN
              LET sr3.agd03_14 = l_agd03
              LET l_imx[l_i].imx02 = l_imx02
           END IF
           IF l_i = 15 THEN
              LET sr3.agd03_15 = l_agd03
              LET l_imx[l_i].imx02 = l_imx02
           END IF
           LET l_i = l_i + 1
        END FOREACH
        LET l_i = l_i -1
        EXECUTE insert_prep2 USING sr3.agd03_1, sr3.agd03_2, sr3.agd03_3, sr3.agd03_4, sr3.agd03_5,
                                   sr3.agd03_6, sr3.agd03_7, sr3.agd03_8, sr3.agd03_9, sr3.agd03_10,
                                   sr3.agd03_11,sr3.agd03_12,sr3.agd03_13,sr3.agd03_14,sr3.agd03_15,
                                   sr.oga01,sr.ogb03,m_plant
        #加載母料件編號的顏色和數量
        FOREACH g620_c8 USING sr.ogb04,sr.ogb04,sr.ogb04 INTO l_imx01,l_agd04,l_color
           INITIALIZE sr4.* TO NULL
           LET sr4.color = l_color
           FOR l_n  = 1 TO l_i
              SELECT imx000 INTO l_imx000 FROM imx_file WHERE imx00 = sr.ogb04
                                                          AND imx01 = l_imx01 AND imx02 = l_imx[l_n].imx02
              CASE l_n
                 WHEN "1"
                    SELECT ogb12 INTO sr4.ogb12_1 FROM ogb_file,ogbi_file WHERE ogb04=l_imx000 AND ogb01=ogbi01
                                                                            AND ogb03=ogbi03 AND ogbplant=ogbiplant
                                                                            AND ogbi01=sr.oga01
                                                                            AND ogbislk02=sr.ogb03 
                 WHEN "2"
                    SELECT ogb12 INTO sr4.ogb12_2 FROM ogb_file,ogbi_file WHERE ogb04=l_imx000 AND ogb01=ogbi01
                                                                            AND ogb03=ogbi03 AND ogbplant=ogbiplant
                                                                            AND ogbi01=sr.oga01
                                                                            AND ogbislk02=sr.ogb03
                 WHEN "3"
                    SELECT ogb12 INTO sr4.ogb12_3 FROM ogb_file,ogbi_file WHERE ogb04=l_imx000 AND ogb01=ogbi01
                                                                            AND ogb03=ogbi03 AND ogbplant=ogbiplant
                                                                            AND ogbi01=sr.oga01
                                                                            AND ogbislk02=sr.ogb03 
                 WHEN "4"
                    SELECT ogb12 INTO sr4.ogb12_4 FROM ogb_file,ogbi_file WHERE ogb04=l_imx000 AND ogb01=ogbi01
                                                                            AND ogb03=ogbi03 AND ogbplant=ogbiplant
                                                                            AND ogbi01=sr.oga01
                                                                            AND ogbislk02=sr.ogb03
                 WHEN "5"
                    SELECT ogb12 INTO sr4.ogb12_5 FROM ogb_file,ogbi_file WHERE ogb04=l_imx000 AND ogb01=ogbi01
                                                                            AND ogb03=ogbi03 AND ogbplant=ogbiplant
                                                                            AND ogbi01=sr.oga01
                                                                            AND ogbislk02=sr.ogb03
                 WHEN "6"
                    SELECT ogb12 INTO sr4.ogb12_6 FROM ogb_file,ogbi_file WHERE ogb04=l_imx000 AND ogb01=ogbi01
                                                                            AND ogb03=ogbi03 AND ogbplant=ogbiplant
                                                                            AND ogbi01=sr.oga01
                                                                            AND ogbislk02=sr.ogb03
                 WHEN "7"
                    SELECT ogb12 INTO sr4.ogb12_7 FROM ogb_file,ogbi_file WHERE ogb04=l_imx000 AND ogb01=ogbi01
                                                                            AND ogb03=ogbi03 AND ogbplant=ogbiplant
                                                                            AND ogbi01=sr.oga01
                                                                            AND ogbislk02=sr.ogb03
                 WHEN "8"
                    SELECT ogb12 INTO sr4.ogb12_8 FROM ogb_file,ogbi_file WHERE ogb04=l_imx000 AND ogb01=ogbi01
                                                                            AND ogb03=ogbi03 AND ogbplant=ogbiplant
                                                                            AND ogbi01=sr.oga01
                                                                            AND ogbislk02=sr.ogb03
                 WHEN "9"
                    SELECT ogb12 INTO sr4.ogb12_9 FROM ogb_file,ogbi_file WHERE ogb04=l_imx000 AND ogb01=ogbi01
                                                                            AND ogb03=ogbi03 AND ogbplant=ogbiplant
                                                                            AND ogbi01=sr.oga01
                                                                            AND ogbislk02=sr.ogb03
                 WHEN "10"
                    SELECT ogb12 INTO sr4.ogb12_10 FROM ogb_file,ogbi_file WHERE ogb04=l_imx000 AND ogb01=ogbi01
                                                                            AND ogb03=ogbi03 AND ogbplant=ogbiplant
                                                                            AND ogbi01=sr.oga01
                                                                            AND ogbislk02=sr.ogb03
                 WHEN "11"
                    SELECT ogb12 INTO sr4.ogb12_11 FROM ogb_file,ogbi_file WHERE ogb04=l_imx000 AND ogb01=ogbi01
                                                                            AND ogb03=ogbi03 AND ogbplant=ogbiplant
                                                                            AND ogbi01=sr.oga01
                                                                            AND ogbislk02=sr.ogb03 
                 WHEN "12"
                    SELECT ogb12 INTO sr4.ogb12_12 FROM ogb_file,ogbi_file WHERE ogb04=l_imx000 AND ogb01=ogbi01
                                                                            AND ogb03=ogbi03 AND ogbplant=ogbiplant
                                                                            AND ogbi01=sr.oga01
                                                                            AND ogbislk02=sr.ogb03 
                 WHEN "13"
                    SELECT ogb12 INTO sr4.ogb12_13 FROM ogb_file,ogbi_file WHERE ogb04=l_imx000 AND ogb01=ogbi01
                                                                            AND ogb03=ogbi03 AND ogbplant=ogbiplant
                                                                            AND ogbi01=sr.oga01
                                                                            AND ogbislk02=sr.ogb03 
                 WHEN "14"
                    SELECT ogb12 INTO sr4.ogb12_14 FROM ogb_file,ogbi_file WHERE ogb04=l_imx000 AND ogb01=ogbi01
                                                                            AND ogb03=ogbi03 AND ogbplant=ogbiplant
                                                                            AND ogbi01=sr.oga01
                                                                            AND ogbislk02=sr.ogb03
                 WHEN "15"
                    SELECT ogb12 INTO sr4.ogb12_15 FROM ogb_file,ogbi_file WHERE ogb04=l_imx000 AND ogb01=ogbi01
                                                                            AND ogb03=ogbi03 AND ogbplant=ogbiplant
                                                                            AND ogbi01=sr.oga01
                                                                            AND ogbislk02=sr.ogb03
              END CASE
           END FOR
           #FUN-CB0058-----add---str--
           IF sr4.ogb12_1 = 0 THEN LET sr4.ogb12_1 = ' ' END IF
           IF sr4.ogb12_2 = 0 THEN LET sr4.ogb12_2 = ' ' END IF
           IF sr4.ogb12_3 = 0 THEN LET sr4.ogb12_3 = ' ' END IF
           IF sr4.ogb12_4 = 0 THEN LET sr4.ogb12_4 = ' ' END IF
           IF sr4.ogb12_5 = 0 THEN LET sr4.ogb12_5 = ' ' END IF
           IF sr4.ogb12_6 = 0 THEN LET sr4.ogb12_6 = ' ' END IF
           IF sr4.ogb12_7 = 0 THEN LET sr4.ogb12_7 = ' ' END IF
           IF sr4.ogb12_8 = 0 THEN LET sr4.ogb12_8 = ' ' END IF
           IF sr4.ogb12_9 = 0 THEN LET sr4.ogb12_9 = ' ' END IF
           IF sr4.ogb12_10 = 0 THEN LET sr4.ogb12_10 = ' ' END IF
           IF sr4.ogb12_11 = 0 THEN LET sr4.ogb12_11 = ' ' END IF
           IF sr4.ogb12_12 = 0 THEN LET sr4.ogb12_12 = ' ' END IF
           IF sr4.ogb12_13 = 0 THEN LET sr4.ogb12_13 = ' ' END IF
           IF sr4.ogb12_14 = 0 THEN LET sr4.ogb12_14 = ' ' END IF
           IF sr4.ogb12_15 = 0 THEN LET sr4.ogb12_15 = ' ' END IF
           #FUN-CB0058-----add---end--
           IF cl_null(sr4.ogb12_1) AND cl_null(sr4.ogb12_2) AND cl_null(sr4.ogb12_3) AND
              cl_null(sr4.ogb12_4) AND cl_null(sr4.ogb12_5) AND cl_null(sr4.ogb12_6) AND
              cl_null(sr4.ogb12_7) AND cl_null(sr4.ogb12_8) AND cl_null(sr4.ogb12_9) AND
              cl_null(sr4.ogb12_10) AND cl_null(sr4.ogb12_11) AND cl_null(sr4.ogb12_12) AND
              cl_null(sr4.ogb12_13) AND cl_null(sr4.ogb12_14) AND cl_null(sr4.ogb12_15) THEN
           ELSE 
              EXECUTE insert_prep3 USING sr4.color,   sr4.ogb12_1, sr4.ogb12_2, sr4.ogb12_3, sr4.ogb12_4, sr4.ogb12_5,
                                         sr4.ogb12_6, sr4.ogb12_7, sr4.ogb12_8, sr4.ogb12_9, sr4.ogb12_10,
                                         sr4.ogb12_11,sr4.ogb12_12,sr4.ogb12_13,sr4.ogb12_14,sr4.ogb12_15,
                                         sr.oga01,sr.ogb03,m_plant
           END IF
        END FOREACH
     END FOREACH
   END FOREACH    #FUN-A70084   
 
   LET l_sql = " SELECT oga23,SUM(ogb14) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " GROUP BY oga23 "
   PREPARE g620_cur1 FROM l_sql
   DECLARE g620_cs1 CURSOR FOR g620_cur1 
   FOREACH g620_cs1 INTO sr2.*
      EXECUTE insert_prep1 USING sr2.*
   END FOREACH

   IF tm.d = "Y" THEN
      LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                  "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
                  "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
                  "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,"|"
   ELSE
      LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                  "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
   END IF  
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axmg620'  
   IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
      CALL cl_wcchp(tm.wc,'oga01,oga02,oga03,oga04,oga14,oga15,oga23,ogb04')   #No.FUN-6C0039
            RETURNING tm.wc                
   END IF     

   IF s_industry("slk") AND g_azw.azw04 = "2" AND tm.d = "Y" THEN
      LET g_template="axmg620_slk"
      CALL axmg620_slk_grdata()
   ELSE
      IF g_sma.sma116 MATCHES '[23]' THEN
         LET g_template="axmg620"
      ELSE
         IF g_sma115 ='Y' THEN
            LET g_template="axmg620_1"
         ELSE
            LET g_template="axmg620_2"
         END IF
      END IF    
      CALL axmg620_grdata()
   END IF
     
END FUNCTION

###GENGRE###START
FUNCTION axmg620_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("axmg620")
        IF handler IS NOT NULL THEN
            START REPORT axmg620_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY order1,order2,order3,oga23"
          
            DECLARE axmg620_datacur1 CURSOR FROM l_sql
            FOREACH axmg620_datacur1 INTO sr1.*
                OUTPUT TO REPORT axmg620_rep(sr1.*)
            END FOREACH
            FINISH REPORT axmg620_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT axmg620_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_ogb14_1_sum LIKE ogb_file.ogb14
    DEFINE l_ogb14_2_sum LIKE ogb_file.ogb14
    DEFINE l_ogb14_3_sum LIKE ogb_file.ogb14
    DEFINE l_ogb13_fmt     STRING
    DEFINE l_ogb14_fmt     STRING
    DEFINE l_ogb14_1_sum_fmt STRING
    DEFINE l_ogb14_2_sum_fmt STRING
    DEFINE l_ogb14_3_sum_fmt STRING
    DEFINE sr2   sr2_t                          
    DEFINE l_oga01_t     LIKE oga_file.oga01 
    DEFINE l_display     LIKE type_file.chr1
    DEFINE l_display1    LIKE type_file.chr1
    DEFINE l_display2    LIKE type_file.chr1
    DEFINE l_display3    LIKE type_file.chr1
    #FUN-CB0058---add---str--
    DEFINE l_oga01   LIKE oga_file.oga01
    DEFINE l_oga02   LIKE oga_file.oga02
    DEFINE l_oga03   LIKE oga_file.oga03
    DEFINE l_oga032  LIKE oga_file.oga032
    DEFINE l_oga04   LIKE oga_file.oga04
    DEFINE l_occ02   LIKE occ_file.occ02
    DEFINE l_oga14   LIKE oga_file.oga14
    DEFINE l_gen02   LIKE gen_file.gen02
    DEFINE l_oga15   LIKE oga_file.oga15
    DEFINE l_gem02   LIKE gem_file.gem02
    #FUN-CB0058---add---end--
 
    ORDER EXTERNAL BY sr1.order1,sr1.oga23_1,sr1.order2,sr1.oga23_2,sr1.order3,sr1.oga23_3
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.oga23_3

        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_ogb14_fmt = cl_gr_numfmt("ogb_file","ogb14",sr1.azi04)
            LET l_ogb13_fmt = cl_gr_numfmt("ogb_file","ogb13",sr1.azi03)
            PRINTX l_ogb14_fmt
            PRINTX l_ogb13_fmt

            IF l_oga01_t = sr1.oga01 AND (NOT cl_null(l_oga01_t)) AND (NOT cl_null(sr1.oga01)) THEN
               LET l_display = 'N'
               #FUN-CB0058---add---str--
               LET l_oga01 = " "  
               LET l_oga02 = " "  
               LET l_oga03 = " "  
               LET l_oga032= " "  
               LET l_oga04 = " "  
               LET l_occ02 = " "  
               LET l_oga14 = " "  
               LET l_gen02 = " "  
               LET l_oga15 = " "  
               LET l_gem02 = " "  
               #FUN-CB0058---add---end--
            ELSE
               LET l_display = 'Y'
               #FUN-CB0058---add---str--
               LET l_oga01 = sr1.oga01
               LET l_oga02 = sr1.oga02
               LET l_oga03 = sr1.oga03
               LET l_oga032= sr1.oga032
               LET l_oga04 = sr1.oga04
               LET l_occ02 = sr1.occ02
               LET l_oga14 = sr1.oga14
               LET l_gen02 = sr1.gen02
               LET l_oga15 = sr1.oga15
               LET l_gem02 = sr1.gem02
               #FUN-CB0058---add---end--
            END IF 
            PRINTX l_display
            #FUN-CB0058---add---str--
            PRINTX l_oga01
            PRINTX l_oga02
            PRINTX l_oga03
            PRINTX l_oga032
            PRINTX l_oga04
            PRINTX l_occ02
            PRINTX l_oga14
            PRINTX l_gen02
            PRINTX l_oga15
            PRINTX l_gem02
            #FUN-CB0058---add---end--

            IF tm.u[1,1] = 'N' OR tm.s[1,1] = '7' THEN
               LET l_display1 = 'N'
            ELSE
               LET l_display1 = 'Y'
            END IF
            IF tm.u[2,2] = 'N' OR tm.s[2,2] = '7' THEN
               LET l_display2 = 'N'
            ELSE
               LET l_display2 = 'Y'
            END IF
            IF tm.u[3,3] = 'N' OR tm.s[3,3] = '7' THEN
               LET l_display3 = 'N'
            ELSE
               LET l_display3 = 'Y'
            END IF
            PRINTX l_display1
            PRINTX l_display2
            PRINTX l_display3

            LET l_oga01_t = sr1.oga01 
            PRINTX sr1.*

        AFTER GROUP OF sr1.oga23_1
            LET l_ogb14_1_sum = GROUP SUM(sr1.ogb14)
            LET l_ogb14_1_sum_fmt = cl_gr_numfmt("ogb_file","ogb14",sr1.azi05)
            PRINTX l_ogb14_1_sum
            PRINTX l_ogb14_1_sum_fmt

        AFTER GROUP OF sr1.oga23_2
            LET l_ogb14_2_sum = GROUP SUM(sr1.ogb14)
            LET l_ogb14_2_sum_fmt = cl_gr_numfmt("ogb_file","ogb14",sr1.azi05)
            PRINTX l_ogb14_2_sum
            PRINTX l_ogb14_2_sum_fmt

        AFTER GROUP OF sr1.oga23_3
            LET l_ogb14_3_sum = GROUP SUM(sr1.ogb14)
            LET l_ogb14_3_sum_fmt = cl_gr_numfmt("ogb_file","ogb14",sr1.azi05)
            PRINTX l_ogb14_3_sum
            PRINTX l_ogb14_3_sum_fmt

        ON LAST ROW
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED

            START REPORT axmg620_subrep01
            DECLARE axmg620_subcur1 CURSOR FROM l_sql
            FOREACH axmg620_subcur1 INTO sr2.*
                OUTPUT TO REPORT axmg620_subrep01(sr2.*)
            END FOREACH
            FINISH REPORT axmg620_subrep01
END REPORT
###GENGRE###END

FUNCTION axmg620_slk_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()
        LET handler = cl_gre_outnam("axmg620_slk")
        IF handler IS NOT NULL THEN
            START REPORT axmg620_slk_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY plant,oga01,ogb03,oga23"
            DECLARE axmg620_slk_cur1 CURSOR FROM l_sql
            FOREACH axmg620_slk_cur1 INTO sr1.*
                OUTPUT TO REPORT axmg620_slk_rep(sr1.*)
            END FOREACH
            FINISH REPORT axmg620_slk_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT axmg620_slk_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_ogb14_sum LIKE ogb_file.ogb14
    DEFINE sr2   sr2_t
    DEFINE sr3   sr3_t
    DEFINE sr4   sr4_t
    DEFINE l_display   LIKE type_file.chr1
    DEFINE l_ima151    LIKE ima_file.ima151
    DEFINE l_ogb13_fmt     STRING
    DEFINE l_ogb14_fmt     STRING
    DEFINE l_ogb14_sum_fmt STRING
    DEFINE l_n         LIKE type_file.num5
    DEFINE l_display2  LIKE type_file.chr1
    DEFINE l_oga01_t     LIKE oga_file.oga01
    #FUN-CB0058---add---str--
    DEFINE l_oga01   LIKE oga_file.oga01
    DEFINE l_oga02   LIKE oga_file.oga02
    DEFINE l_oga03   LIKE oga_file.oga03
    DEFINE l_oga032  LIKE oga_file.oga032
    DEFINE l_oga04   LIKE oga_file.oga04
    DEFINE l_occ02   LIKE occ_file.occ02
    DEFINE l_oga14   LIKE oga_file.oga14
    DEFINE l_gen02   LIKE gen_file.gen02
    DEFINE l_oga15   LIKE oga_file.oga15
    DEFINE l_gem02   LIKE gem_file.gem02
    #FUN-CB0058---add---end--

    ORDER EXTERNAL BY sr1.oga23

    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX tm.*

        BEFORE GROUP OF sr1.oga23

        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            LET l_ogb14_fmt = cl_gr_numfmt("ogb_file","ogb14",sr1.azi04)
            LET l_ogb13_fmt = cl_gr_numfmt("ogb_file","ogb13",sr1.azi03)
            PRINTX l_ogb14_fmt
            PRINTX l_ogb13_fmt

            LET l_sql = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
                        " WHERE oga01 = '",sr1.oga01 CLIPPED,"'",
                        "   AND ogb03 = '",sr1.ogb03 CLIPPED,"'",
                        "   AND plant = '",sr1.plant CLIPPED,"'"
            DECLARE axmg620_subcur5 CURSOR FROM l_sql
            LET l_n = 0
            OPEN axmg620_subcur5
            FETCH axmg620_subcur5 INTO l_n
            LET l_display = "N"
            IF tm.d = "Y" THEN
               SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01 = sr1.ogb04
               IF l_ima151 = "Y" THEN
                  IF l_n != 0 THEN
                     LET l_display = "Y"
                  END IF
               END IF
            END IF
            PRINTX l_display

            IF l_oga01_t = sr1.oga01 AND (NOT cl_null(l_oga01_t)) AND (NOT cl_null(sr1.oga01)) THEN
               LET l_display2 = 'N'
               #FUN-CB0058---add---str--
               LET l_oga01 = " "
               LET l_oga02 = " "
               LET l_oga03 = " "
               LET l_oga032= " "
               LET l_oga04 = " "
               LET l_occ02 = " "
               LET l_oga14 = " "
               LET l_gen02 = " "  
               LET l_oga15 = " "  
               LET l_gem02 = " "  
               #FUN-CB0058---add---end--
            ELSE
               LET l_display2 = 'Y'
               #FUN-CB0058---add---str--
               LET l_oga01 = sr1.oga01
               LET l_oga02 = sr1.oga02
               LET l_oga03 = sr1.oga03
               LET l_oga032= sr1.oga032
               LET l_oga04 = sr1.oga04
               LET l_occ02 = sr1.occ02
               LET l_oga14 = sr1.oga14
               LET l_gen02 = sr1.gen02
               LET l_oga15 = sr1.oga15
               LET l_gem02 = sr1.gem02
               #FUN-CB0058---add---end--
            END IF 
            PRINTX l_display2
            #FUN-CB0058---add---str--
            PRINTX l_oga01
            PRINTX l_oga02
            PRINTX l_oga03
            PRINTX l_oga032
            PRINTX l_oga04
            PRINTX l_occ02
            PRINTX l_oga14
            PRINTX l_gen02
            PRINTX l_oga15
            PRINTX l_gem02
            #FUN-CB0058---add---end--

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                        " WHERE oga01 = '",sr1.oga01 CLIPPED,"'",
                        "   AND ogb03 = '",sr1.ogb03 CLIPPED,"'",
                        "   AND plant = '",sr1.plant CLIPPED,"'"
            START REPORT axmg620_subrep02
            DECLARE axmg620_subcur2 CURSOR FROM l_sql
            FOREACH axmg620_subcur2 INTO sr3.*
                OUTPUT TO REPORT axmg620_subrep02(sr3.*)
            END FOREACH
            FINISH REPORT axmg620_subrep02

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
                        " WHERE oga01 = '",sr1.oga01 CLIPPED,"'",
                        "   AND ogb03 = '",sr1.ogb03 CLIPPED,"'",
                        "   AND plant = '",sr1.plant CLIPPED,"'"
            START REPORT axmg620_subrep03
            DECLARE axmg620_subcur3 CURSOR FROM l_sql
            FOREACH axmg620_subcur3 INTO sr4.*
                OUTPUT TO REPORT axmg620_subrep03(sr4.*)
            END FOREACH
            FINISH REPORT axmg620_subrep03

            LET l_oga01_t = sr1.oga01
            PRINTX sr1.*

        AFTER GROUP OF sr1.oga23
            LET l_ogb14_sum = GROUP SUM(sr1.ogb14)
            LET l_ogb14_sum_fmt = cl_gr_numfmt("ogb_file","ogb14",sr1.azi05)
            PRINTX l_ogb14_sum
            PRINTX l_ogb14_sum_fmt

        ON LAST ROW
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED

            START REPORT axmg620_subrep01
            DECLARE axmg620_subcur4 CURSOR FROM l_sql
            FOREACH axmg620_subcur4 INTO sr2.*
                OUTPUT TO REPORT axmg620_subrep01(sr2.*)
            END FOREACH
            FINISH REPORT axmg620_subrep01
END REPORT

REPORT axmg620_subrep01(sr2)
    DEFINE sr2 sr2_t
    DEFINE l_ogb14_4_sum LIKE ogb_file.ogb14
    DEFINE l_azi05       LIKE azi_file.azi05
    DEFINE l_ogb14_4_sum_fmt  STRING

    FORMAT

        ON EVERY ROW
            SELECT azi05 INTO l_azi05 FROM azi_file WHERE azi01 = sr2.oga23
            LET l_ogb14_4_sum = sr2.ogb14
            LET l_ogb14_4_sum_fmt = cl_gr_numfmt("ogb_file","ogb14",l_azi05)
            PRINTX l_ogb14_4_sum
            PRINTX l_ogb14_4_sum_fmt

            PRINTX sr2.*

END REPORT

REPORT axmg620_subrep02(sr3)
  DEFINE sr3         sr3_t
     
  FORMAT  
     ON EVERY ROW
        PRINTX sr3.*

END REPORT
REPORT axmg620_subrep03(sr4)
  DEFINE sr4 sr4_t
  DEFINE l_display2         LIKE type_file.chr1
     
  FORMAT  
     ON EVERY ROW
          IF cl_null(sr4.ogb12_1) AND cl_null(sr4.ogb12_2) AND cl_null(sr4.ogb12_3) AND cl_null(sr4.ogb12_4)
             AND cl_null(sr4.ogb12_5) AND cl_null(sr4.ogb12_6) AND cl_null(sr4.ogb12_7) AND cl_null(sr4.ogb12_8)
             AND cl_null(sr4.ogb12_9) AND cl_null(sr4.ogb12_10) AND cl_null(sr4.ogb12_11) AND cl_null(sr4.ogb12_12)
             AND cl_null(sr4.ogb12_13) AND cl_null(sr4.ogb12_14) AND cl_null(sr4.ogb12_15) THEN
             LET l_display2 = 'N'
          ELSE
             LET l_display2 = 'Y'
          END IF 
          PRINTX l_display2
          PRINTX sr4.*

END REPORT
#FUN-C70057
