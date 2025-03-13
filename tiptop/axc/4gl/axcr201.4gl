# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcr201.4gl
# Descriptions...: 價差與量差分析表
# Date & Author..:
# Modify.........: No:8488 tm.azk01='TWD' 改為 tm.azk01=g_aza.aza17
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.FUN-4B0064 04/11/25 By Carol 加入"匯率計算"功能
# Modify.........: No.FUN-4C0071 04/12/13 By pengu  匯率幣別欄位修改，與aoos010的azi17做判斷，
                                                   #如果二個幣別相同時，匯率強制為 1
# Modify.........: No.MOD-530122 05/03/16 By Carol QBE欄位順序調整
# Modify.........: No.MOD-530181 05/03/22 By kim Define金額單價位數改為DEC(20,6)
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-570190 05/08/08 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.FUN-590110 05/09/23 by will 報表轉xml格式
# Modify.........: No.FUN-5A0059 05/11/02 By Sarah 補印ima021
# Modify.........: No.FUN-5B0123 05/12/08 By Sarah 應排除出至境外倉部份(add oga00<>'3')
# Modify.........: No.TQC-610051 06/02/22 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.MOD-640009 06/04/04 By Claire tlf037->tlf027   tlf036->tlf026
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-670039 06/07/12 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-660126 06/07/24 By rainy remove s_chknplt
# Modify.........: No.FUN-670098 06/07/24 By rainy 排除不納入成本計算倉庫
# Modify.........: No.FUN-680122 06/09/01 By zdyllq 類型轉換  
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-6A0078 06/11/09 By ice 修正報表格式錯誤;修正FUN-680122改錯部分
# Modify.........: No.FUN-660073 06/12/07 By Nicola 訂單樣品修改
# Modify.........: No.CHI-690007 06/12/26 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.MOD-710129 07/01/23 By jamie MISC的判斷需取前四碼
# Modify.........: No.MOD-710149 07/01/22 By jamie 1.ima01、tlf01變數宣告調整為LIKE or VARCHAR(40)
#                                                  2.銷貨成本重複INSERT  
# Modify.........: No.MOD-720042 07/03/13 By TSD.hoho 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/04/02 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.FUN-7C0101 08/01/23 By Zhangyajun 成本改善增加成本計算類型(type)
# Modify.........: No.MOD-860264 08/07/16 By Pengu 已轉CR的程式裡不應有cl_outnam()去取程式名稱
# Modify.........: No.FUN-870151 08/08/15 By xiaofeizhu  匯率調整為用azi07取位
# Modify.........: No.FUN-940102 09/04/24 BY destiny 檢查使用者的資料庫使用權限
# Modify.........: No.MOD-950231 09/05/25 By mike 09/05/22 將 EXECUTE insert_prep 中的cc08搬致ccz27后面
# Modify.........: No.MOD-950210 09/05/26 By Pengu “寄銷出貨”不應納入 “銷貨收入”
# Modify.........: No.TQC-970305 09/07/30 By liuxqa create table 改為CREATE TEMP TABLE.
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9A0050 09/10/12 By Pengu 執行時會出現-284的錯誤
# Modify.........: No.FUN-A10098 10/01/19 By baofei GP5.2跨DB報表--財務類
# Modify.........: No.FUN-9C0073 10/01/26 By chenls 程序精簡
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No.TQC-A40139 10/05/05 By Carrier FUN-830159/MOD-9B0145追单
# Modify.........: No:MOD-A60140 10/06/22 By Sarah 當tm.group選2.銷售時,Temptable的資料由FUNCTION get_dpm()寫入
# Modify.........: No:CHI-A70001 10/07/06 By Summer 增加"資料內容:1.關係人 2.非關係人 3.全部"
# Modify.........: No:MOD-A70084 10/07/09 By Sarah 若為多倉儲出貨時,銷貨金額會重覆抓取
# Modify.........: No.FUN-A70084 10/07/26 By lutingting GP5.2報表修改,營運中心統一為兩排,每排四個 
# Modify.........: No:MOD-B60120 11/07/17 By Pengu 未考慮銷退數量與金額
# Modify.........: No:FUN-B90130 11/11/03 By wujie  增加oma75的条件  
# Modify.........: No.TQC-BB0182 12/01/13 By pauline 取消過濾plant條件
# Modify.........: No:MOD-C10075 12/01/16 By Smapmin 排除簽收流程中原出貨單據
# Modify.........: No:MOD-C30734 12/03/15 By ck2yuan 修改抓title的代號
# Modify.........: No:MOD-C30812 12/03/21 By ck2yuan 新增title p20 去取代原本固定的title
# Modify.........: No:MOD-C30854 12/03/27 By ck2yuan 乘上匯率會造成與axcr761數值有尾差,故依g_azi03做取位,傳azk01相對應azi03到報表取位
# Modify.........: No:CHI-C50069 12/06/26 By Sakura 原"列印樣品銷貨"欄位改用RadioBox(1.一般出貨,2.樣品出貨,3.全部)
# Modify.........: No:CHI-C30012 12/07/27 By bart 金額取位改抓ccz26
# Modify.........: No:CHI-A70023 13/01/30 By Alberti 調整成品替代的銷貨收入
# Modify.........: No:TQC-C60055 13/01/30 By Alberti 註解不能穿插在sql語法中間,會造成編譯錯誤,並修改CHI-A70023追單錯誤
# Modify.........: No:MOD-C60152 13/01/30 By Alberti 修正CHI-A70023錯誤

DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE g_wc string  #No.FUN-580092 HCN
   DEFINE tm  RECORD
              ima01   LIKE ima_file.ima01,   #料號
              ima131  LIKE ima_file.ima131,     # Prog. Version..: '5.30.06-13.03.12(04)             #產品分類
              ima11   LIKE ima_file.ima11,     # Prog. Version..: '5.30.06-13.03.12(04)             #其他分群三
              ima12   LIKE ima_file.ima12,   #成本分群
              data  LIKE type_file.num5,           #No.FUN-680122     SMALLINT         #資料選擇 0/1
              b       LIKE type_file.num5,         #CHI-C50069 add                     #列印樣品銷
              group LIKE type_file.num5,           #No.FUN-680122     SMALLINT          #資料選擇 1/2
              detail  LIKE type_file.chr1,           #No.FUN-680122CHAR(01)
              yy1_b,mm1_b,mm1_e LIKE type_file.num5,           #No.FUN-680122SMALLINT
              yy2_b,mm2_b,mm2_e LIKE type_file.num5,           #No.FUN-680122SMALLINT
              plant_1,plant_2,plant_3,plant_4,plant_5,plant_6 LIKE cre_file.cre08,           #No.FUN-680122CHAR(10)
              plant_7,plant_8   LIKE azp_file.azp01,          #FUN-A70084           
              type2   LIKE type_file.chr1,   #資料內容(1)關係人(2)非關係人(3)全部  #CHI-A70001 add
              sum_code LIKE type_file.chr1,           #No.FUN-680122CHAR(01)
              azk01   LIKE azk_file.azk01,
              azk04   LIKE azk_file.azk04,
              azh01   LIKE azh_file.azh01,
              azh02   LIKE azh_file.azh02,
              dec     LIKE type_file.num5,           #No.FUN-680122SMALLINT  #金額單位(1)元(2)千(3)萬
              more    LIKE type_file.chr1,           #No.FUN-680122CHAR(01)
              type    LIKE type_file.chr1            #No.FUN-7C0101 VARCHAR(1)
              END RECORD
 
   DEFINE g_dash3      LIKE type_file.chr1000         #No.FUN-680122CHAR(200)
   DEFINE g_bookno     LIKE aaa_file.aaa01            #No.FUN-670039
   DEFINE g_bdate1,g_edate1,g_bdate2,g_edate2 LIKE type_file.dat             #No.FUN-680122DATE
   DEFINE g_base       LIKE type_file.num10,          #No.FUN-680122INTEGER
          g_azi RECORD LIKE azi_file.*
   DEFINE  #multi fac
           g_delsql   LIKE type_file.chr1000,        #execute sys_cmd        #No.FUN-680122CHAR(50)
           g_tname    LIKE type_file.chr20,          #No.FUN-680122CHAR(20)  #tmpfile name
           g_tname1   LIKE type_file.chr20,          #No.FUN-680122CHAR(20)  #tmpfile name
           g_delsql1  LIKE type_file.chr1000,        #execute sys_cmd        #No.FUN-680122CHAR(50)
           g_idx,g_k  LIKE type_file.num10,          #No.FUN-680122INTEGER
           g_ary DYNAMIC ARRAY OF RECORD             #被選擇之工廠
           plant      LIKE cre_file.cre08,           #No.FUN-680122CHAR(08)
           dbs_new    LIKE type_file.chr1000         #No.FUN-680122CHAR(21) 
           END RECORD ,
           g_tmp DYNAMIC ARRAY OF RECORD             #被選擇之工廠
           p          LIKE cre_file.cre08,           #No.FUN-680122CHAR(08)
           d          LIKE type_file.chr1000         #No.FUN-680122CHAR(21) 
           END RECORD ,
           g_sum RECORD
           #   qty    LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3)  #數量(內銷)#FUN-A20044
              qty    LIKE type_file.num15_3,           #No.FUN-680122DEC(15,3)  #數量(內銷)#FUN-A20044
              amt    LIKE ima_file.ima32,           #No.FUN-680122DEC(20,6)  #金額(內銷)
              cost   LIKE ima_file.ima32,           #No.FUN-680122DEC(20,6)  #成本(內銷)
           #   qty1   LIKE ima_file.ima26,           #No.FUN-680122DEC(20,6)  #數量(內退)#FUN-A20044
              qty1   LIKE type_file.num15_3,           #No.FUN-680122DEC(20,6)  #數量(內退)#FUN-A20044
              amt1   LIKE ima_file.ima32,           #No.FUN-680122DEC(20,6)  #金額(內退)
              cost1  LIKE ima_file.ima32,           #No.FUN-680122DEC(20,6)  #成本(內退)
              dae_amt LIKE ima_file.ima32,          #No.FUN-680122DEC(20,6)  #折讓
              dac_amt LIKE ima_file.ima32           #No.FUN-680122DEC(20,6)  #雜項發票
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE l_table   STRING   #Add MOD-720042 By TSD.hoho CR11 add
DEFINE g_sql     STRING   #Add MOD-720042 By TSD.hoho CR11 add
DEFINE g_str     STRING   #Add MOD-720042 By TSD.hoho CR11 add
DEFINE m_legal           ARRAY[10] OF LIKE azw_file.azw02   #FUN-A70084
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
 
   # CREATE TEMP TABLE
   LET g_sql = " item.ima_file.ima03,",
               " ima01.ima_file.ima01,",
               " qty.type_file.num15_3,",#FUN-A20044  #No.TQC-A40139
               " amt.ima_file.ima32,",
               " cost.ima_file.ima32,",
               " qty1.type_file.num15_3,",#FUN-A20044 #No.TQC-A40139
               " amt1.ima_file.ima32,",
               " cost1.ima_file.ima32,",
               " amt_ut.ima_file.ima32,",
               " amt_ut1.ima_file.ima32,",
               " cst_ut.ima_file.ima32,",
               " cst_ut1.ima_file.ima32,",
               " dif1.ima_file.ima32,",
               " dif2.ima_file.ima32,",
               " odr.type_file.chr1000,",
               " ima02.ima_file.ima02,",
               " ima021.ima_file.ima021,",
               " oba02.oba_file.oba02,",
               " s_qty.type_file.num15_3,",#FUN-A20044 #No.TQC-A40139
               " s_amt.ima_file.ima32,",
               " s_cost.ima_file.ima32,",
               " s_qty1.type_file.num15_3,",#FUN-A20044 #No.TQC-A40139
               " s_amt1.ima_file.ima32,",
               " s_cost1.ima_file.ima32,",
               " s_dae_a.ima_file.ima32,",
               " s_dac_a.ima_file.ima32,",
               " azi03.azi_file.azi03,",
               " azi04.azi_file.azi04,",
               " azi05.azi_file.azi05,",
               " ccz27.ccz_file.ccz27,",
               " ccc08.ccc_file.ccc08,",   #No.FUN-7C0101 add
               " azi07.azi_file.azi07,",   #No.FUN-870151
               " t_azi03.azi_file.azi03 "   #MOD-C30854 add
 
   LET l_table = cl_prt_temptable('axcr201',g_sql) CLIPPED  #產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
                      " ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
                      " ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) "        #No.FUN-870151 Add "?" #MOD-C30854 add "?"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',STATUS,1) EXIT PROGRAM
   END IF
 
   LET tm.plant_1 = g_ary[1].plant
   LET tm.plant_2 = g_ary[2].plant
   LET tm.plant_3 = g_ary[3].plant
   LET tm.plant_4 = g_ary[4].plant
   LET tm.plant_5 = g_ary[5].plant
   LET tm.plant_6 = g_ary[6].plant
   LET tm.plant_7 = g_ary[7].plant  #FUN-A70084
   LET tm.plant_8 = g_ary[8].plant  #FUN-A70084
   LET g_pdate  = ARG_VAL(1)        
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET g_wc    = ARG_VAL(7)
   LET tm.data     = ARG_VAL(8)
   LET tm.yy1_b    = ARG_VAL(9)
   LET tm.mm1_b    = ARG_VAL(10)
   LET tm.mm1_e    = ARG_VAL(11)
   LET tm.yy2_b    = ARG_VAL(12)
   LET tm.mm2_b    = ARG_VAL(13)
   LET tm.mm2_e    = ARG_VAL(14)
   LET tm.plant_1  = ARG_VAL(15)
   LET tm.plant_2  = ARG_VAL(16)
   LET tm.plant_3  = ARG_VAL(17)
   LET tm.plant_4  = ARG_VAL(18)
   LET tm.plant_5  = ARG_VAL(19)
   LET tm.plant_6  = ARG_VAL(20)
#FUN-A70084--mod--str--add plant_7&plant_8
#  LET tm.type2   = ARG_VAL(21) #CHI-A70001 add
# #CHI-A70001 mod +1 --start--
#  LET tm.group    = ARG_VAL(22)
#  LET tm.detail   = ARG_VAL(23)
#  LET tm.sum_code = ARG_VAL(24)
#  LET tm.azk01= ARG_VAL(25)
#  LET tm.azk04= ARG_VAL(26)
#  LET tm.azh01= ARG_VAL(27)
#  LET tm.dec= ARG_VAL(28)
#  LET g_rep_user = ARG_VAL(29)
#  LET g_rep_clas = ARG_VAL(30)
#  LET g_template = ARG_VAL(31)
#  LET g_bookno = ARG_VAL(32)
#  LET tm.type = ARG_VAL(33)   #No.FUN-7C0101 add
#  LET g_rpt_name = ARG_VAL(34)  #No.FUN-7C0078
# #CHI-A70001 mod +1 --end--
   LET tm.plant_7 = ARG_VAL(21)
   LET tm.plant_8 = ARG_VAL(22)
   LET tm.type2   = ARG_VAL(23)
   LET tm.group    = ARG_VAL(24)
   LET tm.detail   = ARG_VAL(25)
   LET tm.sum_code = ARG_VAL(26)
   LET tm.azk01= ARG_VAL(27)
   LET tm.azk04= ARG_VAL(28)
   LET tm.azh01= ARG_VAL(29)
   LET tm.dec= ARG_VAL(30)
   LET g_rep_user = ARG_VAL(31)
   LET g_rep_clas = ARG_VAL(32)
   LET g_template = ARG_VAL(33)
   LET g_bookno = ARG_VAL(34)
   LET tm.type = ARG_VAL(35)   #No.FUN-7C0101 add
   LET g_rpt_name = ARG_VAL(36)  #No.FUN-7C0078
#FUN-A70084--mod--end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r201_tm(0,0)
      ELSE CALL r201()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION r201_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_date         LIKE type_file.dat,           #No.FUN-680122DATE,
          l_cmd          LIKE type_file.chr1000       #No.FUN-680122CHAR(400) 
   DEFINE l_cnt          LIKE type_file.num5           #No.FUN-A70084
 
   IF p_row = 0 THEN LET p_row = 2 LET p_col = 10 END IF
   CALL s_dsmark(g_bookno)
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 2 LET p_col = 20
   ELSE LET p_row = 2 LET p_col = 10
   END IF
   OPEN WINDOW r201_w AT p_row,p_col
        WITH FORM "axc/42f/axcr201"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   CALL r201_set_visible() RETURNING l_cnt    #FUN-A70084
   INITIALIZE tm.* TO NULL
   LET tm.data = 1
   LET tm.b = '3' #CHI-C50069 add
   LET tm.group = 1
   LET tm.detail ='N'
   LET tm.type2='3' #CHI-A70001 add
   LET tm.sum_code='N'
   LET tm.more = 'N'
   LET tm.dec= 1
   LET tm.yy1_b = g_ccz.ccz01
   LET tm.mm1_b = g_ccz.ccz02
   LET tm.mm1_e = g_ccz.ccz02
   LET tm.type = g_ccz.ccz28  #No.FUN-7C0101
   LET tm.azk01= g_aza.aza17  #No:8488
   LET tm.azk04=1
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET g_base   = 1
WHILE TRUE
   LET g_wc=NULL
   CONSTRUCT BY NAME  g_wc ON ima01,ima11,ima131,ima12
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
     ON ACTION locale
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
     ON ACTION CONTROLP
        IF INFIELD(ima01) THEN
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_ima"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO ima01
           NEXT FIELD ima01
        END IF
 
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r855_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM 
   END IF
   IF g_wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME
              tm.data,tm.b, #CHI-C50069 add tm.b
              tm.yy1_b,tm.mm1_b,tm.mm1_e,
              tm.yy2_b,tm.mm2_b,tm.mm2_e,
              tm.plant_1,tm.plant_2,tm.plant_3,tm.plant_4,
              tm.plant_5,tm.plant_6,tm.plant_7,tm.plant_8,tm.type2, #CHI-A70001 add tm.type2,   #FUN-A70084 add plant_7&plant_8
              tm.group,
              tm.type,   #No.FUN-7C0101 add
              tm.detail,
              tm.sum_code,
              tm.azk01,
              tm.azk04,
              tm.azh01,
              tm.dec,
              tm.more
 
   WITHOUT DEFAULTS
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)

         BEFORE FIELD plant_1
             LET tm.plant_1 = g_plant
             DISPLAY tm.plant_1 TO FORMONLY.plant_1
             IF g_multpl= 'N' THEN             # 不為多工廠環境
                LET tm.plant_1 = g_plant
                LET g_plant_new = NULL
                LET g_dbs_new   = NULL
                LET g_ary[1].plant = g_plant
                LET g_ary[1].dbs_new = g_dbs_new
                DISPLAY tm.plant_1 TO FORMONLY.plant_1
                LET g_k=1
                LET g_tmp[g_k].p=g_ary[g_k].plant
                LET g_tmp[g_k].d=g_ary[g_k].dbs_new
                NEXT FIELD detail
             END IF
 
         AFTER FIELD plant_1
             LET g_plant_new = tm.plant_1
             IF tm.plant_1 = g_plant  THEN
                LET g_dbs_new =' '
                LET g_ary[1].plant = tm.plant_1
                LET g_ary[1].dbs_new = g_dbs_new
                LET m_legal[1] = g_legal   #FUN-A70084
             ELSE
                IF NOT cl_null(tm.plant_1) THEN
                                #檢查工廠並將新的資料庫放在g_dbs_new
                   IF NOT r201_chkplant(tm.plant_1) THEN
                     CALL cl_err(tm.plant_1,g_errno,0)
                     NEXT FIELD plant_1
                   END IF
                   IF NOT s_chk_demo(g_user,tm.plant_1) THEN  
                      NEXT FIELD plant_1 
                   END IF              
                   LET g_ary[1].plant = tm.plant_1
                   LET g_ary[1].dbs_new = g_dbs_new
                   SELECT azw02 INTO m_legal[1] FROM azw_file WHERE azw01 = tm.plant_1   #FUN-A70084
                ELSE            # 輸入之工廠編號為' '或NULL
                   LET g_ary[1].plant = tm.plant_1
                END IF
             END IF
             
         AFTER FIELD plant_2
             LET tm.plant_2 = duplicate(tm.plant_2,1)  # 不使工廠編號重覆
             LET g_plant_new = tm.plant_2
             IF tm.plant_2 = g_plant  THEN
                LET g_dbs_new=' '
                LET g_ary[2].plant = tm.plant_2
                LET g_ary[2].dbs_new = g_dbs_new
                LET m_legal[2] = g_legal  #FUN-A70084
             ELSE
                IF NOT cl_null(tm.plant_2) THEN
                               # 檢查工廠並將新的資料庫放在g_dbs_new
                   IF NOT r201_chkplant(tm.plant_2) THEN
                     CALL cl_err(tm.plant_2,g_errno,0)
                     NEXT FIELD plant_2
                   END IF
                   LET g_ary[2].plant = tm.plant_2
                   LET g_ary[2].dbs_new = g_dbs_new
                   SELECT azw02 INTO m_legal[2] FROM azw_file WHERE azw01 = tm.plant_2   #FUN-A70084
                   IF NOT s_chk_demo(g_user,tm.plant_2) THEN  
                      NEXT FIELD plant_2 
                   END IF              
                ELSE           # 輸入之工廠編號為' '或NULL
                   LET g_ary[2].plant = tm.plant_2
                END IF
             END IF
             #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_2) THEN
                IF NOT r201_chklegal(m_legal[2],1) THEN
                   CALL cl_err(tm.plant_2,g_errno,0)
                   NEXT FIELD plant_2
                END IF
             END IF
             #FUN-A70084--add--end

         AFTER FIELD plant_3
             LET tm.plant_3 = duplicate(tm.plant_3,2)  # 不使工廠編號重覆
             LET g_plant_new = tm.plant_3
             IF tm.plant_3 = g_plant  THEN
                LET g_dbs_new=' '
                LET g_ary[3].plant = tm.plant_3
                LET g_ary[3].dbs_new = g_dbs_new
                LET m_legal[3] = g_legal   #FUN-A70084
             ELSE
                IF NOT cl_null(tm.plant_3) THEN
                               # 檢查工廠並將新的資料庫放在g_dbs_new
                   IF NOT r201_chkplant(tm.plant_3) THEN
                     CALL cl_err(tm.plant_3,g_errno,0)
                     NEXT FIELD plant_3
                   END IF
                   LET g_ary[3].plant = tm.plant_3
                   LET g_ary[3].dbs_new = g_dbs_new
                   SELECT azw02 INTO m_legal[3] FROM azw_file WHERE azw01 = tm.plant_3   #FUN-A70084
                   IF NOT s_chk_demo(g_user,tm.plant_3) THEN  
                      NEXT FIELD plant_3 
                   END IF              
                ELSE           # 輸入之工廠編號為' '或NULL
                   LET g_ary[3].plant = tm.plant_3
                END IF
             END IF
             #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_3) THEN
                IF NOT r201_chklegal(m_legal[3],2) THEN
                   CALL cl_err(tm.plant_3,g_errno,0)
                   NEXT FIELD plant_3
                END IF
             END IF
             #FUN-A70084--add--end
 
         AFTER FIELD plant_4
             LET tm.plant_4 = duplicate(tm.plant_4,3)  # 不使工廠編號重覆
             LET g_plant_new = tm.plant_4
             IF tm.plant_4 = g_plant  THEN
                LET g_dbs_new=' '
                LET g_ary[4].plant = tm.plant_4
                LET g_ary[4].dbs_new = g_dbs_new
                LET m_legal[4] = g_legal   #FUN-A70084
             ELSE
                IF NOT cl_null(tm.plant_4) THEN
                               # 檢查工廠並將新的資料庫放在g_dbs_new
                   IF NOT r201_chkplant(tm.plant_4) THEN
                     CALL cl_err(tm.plant_4,g_errno,0)
                     NEXT FIELD plant_4
                   END IF
                   LET g_ary[4].plant = tm.plant_4
                   LET g_ary[4].dbs_new = g_dbs_new
                   SELECT azw02 INTO m_legal[4] FROM azw_file WHERE azw01 = tm.plant_4  #FUN-A70084
                   IF NOT s_chk_demo(g_user,tm.plant_4) THEN  
                      NEXT FIELD plant_4 
                   END IF              
                ELSE           # 輸入之工廠編號為' '或NULL
                   LET g_ary[4].plant = tm.plant_4
                END IF
             END IF
             #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_4) THEN
                IF NOT r201_chklegal(m_legal[4],3) THEN
                   CALL cl_err(tm.plant_4,g_errno,0)
                   NEXT FIELD plant_4
                END IF
             END IF
             #FUN-A70084--add--end
 
 
         AFTER FIELD plant_5
             LET tm.plant_5 = duplicate(tm.plant_5,4)  # 不使工廠編號重覆
             LET g_plant_new = tm.plant_5
             IF tm.plant_5 = g_plant  THEN
                LET g_dbs_new=' '
                LET g_ary[5].plant = tm.plant_5
                LET g_ary[5].dbs_new = g_dbs_new
                LET m_legal[5] = g_legal   #FUN-A70084
             ELSE
                IF NOT cl_null(tm.plant_5) THEN
                               # 檢查工廠並將新的資料庫放在g_dbs_new
                   IF NOT r201_chkplant(tm.plant_5) THEN
                     CALL cl_err(tm.plant_5,g_errno,0)
                     NEXT FIELD plant_5
                   END IF
                   LET g_ary[5].plant = tm.plant_5
                   LET g_ary[5].dbs_new = g_dbs_new
                   SELECT azw02 INTO m_legal[5] FROM azw_file WHERE azw01 = tm.plant_5  #FUN-A70084
                   IF NOT s_chk_demo(g_user,tm.plant_5) THEN  
                      NEXT FIELD plant_5 
                   END IF              
                ELSE           # 輸入之工廠編號為' '或NULL
                   LET g_ary[5].plant = tm.plant_5
                END IF
             END IF
             #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_5) THEN
                IF NOT r201_chklegal(m_legal[5],4) THEN
                   CALL cl_err(tm.plant_5,g_errno,0)
                   NEXT FIELD plant_5
                END IF
             END IF
             #FUN-A70084--add--end
 
         AFTER FIELD plant_6
             LET tm.plant_6 = duplicate(tm.plant_6,5)  # 不使工廠編號重覆
             LET g_plant_new = tm.plant_6
             IF tm.plant_6 = g_plant  THEN
                LET g_dbs_new=' '
                LET g_ary[6].plant = tm.plant_6
                LET g_ary[6].dbs_new = g_dbs_new
             ELSE
                IF NOT cl_null(tm.plant_6) THEN
                               # 檢查工廠並將新的資料庫放在g_dbs_new
                   IF NOT r201_chkplant(tm.plant_6) THEN
                     CALL cl_err(tm.plant_6,g_errno,0)
                     NEXT FIELD plant_6
                   END IF
                   LET g_ary[6].plant = tm.plant_6
                   LET g_ary[6].dbs_new = g_dbs_new
                   SELECT azw02 INTO m_legal[6] FROM azw_file WHERE azw01 = tm.plant_6   #FUN-A70084
                   IF NOT s_chk_demo(g_user,tm.plant_6) THEN  
                      NEXT FIELD plant_6 
                   END IF              
                ELSE           # 輸入之工廠編號為' '或NULL
                   LET g_ary[6].plant = tm.plant_6
                END IF
             END IF
             #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_6) THEN
                IF NOT r201_chklegal(m_legal[6],5) THEN
                   CALL cl_err(tm.plant_6,g_errno,0)
                   NEXT FIELD plant_6
                END IF
             END IF
             #FUN-A70084--add--end

#FUN-A70084--add--str--
         AFTER FIELD plant_7
             LET tm.plant_7 = duplicate(tm.plant_7,5)  # 不使工廠編號重覆
             LET g_plant_new = tm.plant_7
             IF tm.plant_7 = g_plant  THEN
                LET g_ary[7].plant = tm.plant_7
                LET m_legal[7] = g_legal  #FUN-A70084
             ELSE
                IF NOT cl_null(tm.plant_7) THEN
                               # 檢查工廠
                   IF NOT r201_chkplant(tm.plant_7) THEN
                     CALL cl_err(tm.plant_7,g_errno,0)
                     NEXT FIELD plant_7
                   END IF
                   LET g_ary[7].plant = tm.plant_7
                   SELECT azw02 INTO m_legal[7] FROM azw_file WHERE azw01 = tm.plant_7  #FUN-A70084
                   IF NOT s_chk_demo(g_user,tm.plant_7) THEN
                      NEXT FIELD plant_7
                   END IF
                ELSE           # 輸入之工廠編號為' '或NULL
                   LET g_ary[7].plant = tm.plant_7
                END IF
             END IF
             #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_7) THEN
                IF NOT r201_chklegal(m_legal[7],6) THEN
                   CALL cl_err(tm.plant_7,g_errno,0)
                   NEXT FIELD plant_7
                END IF
             END IF
             #FUN-A70084--add--end

         AFTER FIELD plant_8 
             LET tm.plant_8 = duplicate(tm.plant_8,5)  # 不使工廠編號重覆
             LET g_plant_new = tm.plant_8
             IF tm.plant_8 = g_plant  THEN
                LET g_ary[8].plant = tm.plant_8
                LET m_legal[8] = g_legal  #FUN-A70084
             ELSE    
                IF NOT cl_null(tm.plant_8) THEN
                               # 檢查工廠
                   IF NOT r201_chkplant(tm.plant_8) THEN
                     CALL cl_err(tm.plant_8,g_errno,0)
                     NEXT FIELD plant_8 
                   END IF  
                   LET g_ary[8].plant = tm.plant_8
                   SELECT azw02 INTO m_legal[8] FROM azw_file WHERE azw01 = tm.plant_8   #FUN-A70084
                   IF NOT s_chk_demo(g_user,tm.plant_8) THEN
                      NEXT FIELD plant_8 
                   END IF  
                ELSE           # 輸入之工廠編號為' '或NULL 
                   LET g_ary[8].plant = tm.plant_8
                END IF  
             END IF  
             #檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_8) THEN
                IF NOT r201_chklegal(m_legal[8],7) THEN
                   CALL cl_err(tm.plant_8,g_errno,0)
                   NEXT FIELD plant_8
                END IF
             END IF

#FUN-A70084--add--end
       #CHI-A70001 add --start--
         AFTER FIELD type2
            IF cl_null(tm.type2) OR tm.type2 NOT MATCHES '[123]' THEN
               NEXT FIELD type2
            END IF
       #CHI-A70001 add --end--

         AFTER FIELD type
             IF tm.type IS NULL OR tm.type NOT MATCHES '[12345]' THEN
                NEXT FIELD type
             END IF
         AFTER FIELD azk01
             IF NOT cl_null(tm.azk01) THEN
                SELECT * FROM azi_file
                WHERE azi01 = tm.azk01
                IF STATUS != 0 THEN
                   CALL cl_err3("sel","azi_file",tm.azk01,"","aap-002","","azk01",1)   #No.FUN-660127
                   NEXT FIELD azk01
                END IF
 
                # azk04 賣出匯率
                SELECT MAX(azk02) INTO l_date FROM azk_file
                SELECT azk04 INTO tm.azk04 FROM azk_file
                WHERE azk01 = tm.azk01 AND azk02 =l_date
                DISPLAY BY NAME  tm.azk04
             ELSE
                LET tm.azk04 = 0
                DISPLAY BY NAME tm.azk04
             END IF
##
         AFTER FIELD azk04                    #FUN-4C0071
             IF tm.azk01 =g_aza.aza17 THEN
                LET tm.azk04 =1
                DISPLAY tm.azk04  TO azk04
             END IF
 
         AFTER FIELD azh01
           IF NOT cl_null(tm.azh01) THEN
              SELECT azh02 INTO tm.azh02 FROM azh_file
                 WHERE azh01 = tm.azh01
                      IF SQLCA.SQLCODE = 100 THEN
                         CALL cl_err3("sel","azh_file",tm.azh01,"","mfg6217","","",1)   #No.FUN-660127
                         NEXT FIELD azh01
                      END IF
           END IF
 
         AFTER FIELD dec
           IF tm.dec NOT MATCHES '[123]' THEN NEXT FIELD dec END IF
           CASE tm.dec WHEN 1 LET g_base = 1
                       WHEN 2 LET g_base = 1000
                       WHEN 3 LET g_base = 10000
                       OTHERWISE NEXT FIELD dec
           END CASE
 
         AFTER FIELD more
           IF tm.more = 'Y' THEN
              CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies)
              RETURNING g_pdate,g_towhom,g_rlang,
                        g_bgjob,g_time,g_prtway,g_copies
           END IF
 
          ON ACTION CONTROLP
            CASE
               WHEN INFIELD(plant_1)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_zxy"               #No.FUN-940102
                    LET g_qryparam.arg1 = g_user                #No.FUN-940102
                    LET g_qryparam.default1 = tm.plant_1
                    CALL cl_create_qry() RETURNING tm.plant_1
                    DISPLAY BY NAME tm.plant_1
                    NEXT FIELD plant_1
 
               WHEN INFIELD(plant_2)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_zxy"               #No.FUN-940102
                    LET g_qryparam.arg1 = g_user                #No.FUN-940102
                    LET g_qryparam.default1 = tm.plant_2
                    CALL cl_create_qry() RETURNING tm.plant_2
                    DISPLAY BY NAME tm.plant_2
                    NEXT FIELD plant_2
 
               WHEN INFIELD(plant_3)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_zxy"               #No.FUN-940102
                    LET g_qryparam.arg1 = g_user                #No.FUN-940102
                    LET g_qryparam.default1 = tm.plant_3
                    CALL cl_create_qry() RETURNING tm.plant_3
                    DISPLAY BY NAME tm.plant_3
                    NEXT FIELD plant_3
 
               WHEN INFIELD(plant_4)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_zxy"               #No.FUN-940102
                    LET g_qryparam.arg1 = g_user                #No.FUN-940102
                    LET g_qryparam.default1 = tm.plant_4
                    CALL cl_create_qry() RETURNING tm.plant_4
                    DISPLAY BY NAME tm.plant_4
                    NEXT FIELD plant_4
 
               WHEN INFIELD(plant_5)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_zxy"               #No.FUN-940102
                    LET g_qryparam.arg1 = g_user                #No.FUN-940102
                    LET g_qryparam.default1 = tm.plant_5
                    CALL cl_create_qry() RETURNING tm.plant_5
                    DISPLAY BY NAME tm.plant_5
                    NEXT FIELD plant_5
 
               WHEN INFIELD(plant_6)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_zxy"               #No.FUN-940102
                    LET g_qryparam.arg1 = g_user                #No.FUN-940102
                    LET g_qryparam.default1 = tm.plant_6
                    CALL cl_create_qry() RETURNING tm.plant_6
                    DISPLAY BY NAME tm.plant_6
                    NEXT FIELD plant_6
 
#FUN-A70084--add--str--
               WHEN INFIELD(plant_7)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_zxy"           
                    LET g_qryparam.arg1 = g_user           
                    LET g_qryparam.default1 = tm.plant_7
                    CALL cl_create_qry() RETURNING tm.plant_7
                    DISPLAY BY NAME tm.plant_7
                    NEXT FIELD plant_7 

               WHEN INFIELD(plant_8)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_zxy"             
                    LET g_qryparam.arg1 = g_user             
                    LET g_qryparam.default1 = tm.plant_8
                    CALL cl_create_qry() RETURNING tm.plant_8
                    DISPLAY BY NAME tm.plant_8
                    NEXT FIELD plant_8 
#FUN-A70084--add--end
                WHEN INFIELD(azk01) #幣別檔
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_azi"
                     LET g_qryparam.default1 = tm.azk01
                     CALL cl_create_qry() RETURNING tm.azk01
                     DISPLAY BY NAME tm.azk01
                     NEXT FIELD azk01
                WHEN INFIELD(azk04)
                     CALL s_rate(tm.azk01,tm.azk04) RETURNING tm.azk04
                     DISPLAY BY NAME tm.azk04
                     NEXT FIELD azk04
##
               WHEN INFIELD(azh01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = 'q_azh'
                    LET g_qryparam.default1 = tm.azh01
                    LET g_qryparam.default2 = tm.azh02
                    CALL cl_create_qry() RETURNING tm.azh01,tm.azh02
                    DISPLAY tm.azh01, tm.azh02 TO azh01, azh02
               OTHERWISE EXIT CASE
            END CASE
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG CALL cl_cmdask()
 
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF cl_null(tm.azk01) THEN
               LET tm.azk04 = 0
               DISPLAY BY NAME tm.azk04
            END IF
##
            IF cl_null(tm.plant_1) AND cl_null(tm.plant_2) AND
               cl_null(tm.plant_3) AND cl_null(tm.plant_4) AND
               cl_null(tm.plant_5) AND cl_null(tm.plant_6) AND
               cl_null(tm.plant_7) AND cl_null(tm.plant_8) AND l_cnt <=1 THEN   #FUN-A70084 add
               CALL cl_err(0,'aap-136',0)
               NEXT FIELD plant_1
            END IF
         #FUN-A70084--add--str--
         IF l_cnt >1 THEN
            LET g_k = 1
            LET g_ary[1].plant = g_plant
         ELSE
         #FUN-A70084--add--end
            LET g_k=0
           #FOR g_idx = 1  TO  9   #FUN-A70084
            FOR g_idx = 1  TO  8   #FUN-A70084
                IF cl_null(g_ary[g_idx].plant) THEN
                   CONTINUE FOR
                END IF
                LET g_k=g_k+1
                LET g_tmp[g_k].p=g_ary[g_idx].plant
                LET g_tmp[g_k].d=g_ary[g_idx].dbs_new
            END FOR
           #FOR g_idx = 1  TO 9    #FUN-A70084
            FOR g_idx = 1  TO 8    #FUN-A70084
                IF  g_idx > g_k THEN
                    LET g_ary[g_idx].plant=NULL
                    LET g_ary[g_idx].dbs_new=NULL
                ELSE
                    LET g_ary[g_idx].plant=g_tmp[g_idx].p
                    LET g_ary[g_idx].dbs_new=g_tmp[g_idx].d
                END IF
            END FOR
         END IF     #FUN-A70084
 
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
      LET INT_FLAG = 0
      CLOSE WINDOW r201_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
       WHERE zz01='axcr201'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr201','9031',1)   
      ELSE
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",g_wc CLIPPED,"'",
                         " '",tm.data      CLIPPED,"'",
                         " '",tm.yy1_b     CLIPPED,"'",
                         " '",tm.mm1_b     CLIPPED,"'",
                         " '",tm.mm1_e     CLIPPED,"'",
                         " '",tm.yy2_b     CLIPPED,"'",
                         " '",tm.mm2_b     CLIPPED,"'",
                         " '",tm.mm2_e     CLIPPED,"'",
                         " '",tm.plant_1   CLIPPED,"'",
                         " '",tm.plant_2   CLIPPED,"'",
                         " '",tm.plant_3   CLIPPED,"'",
                         " '",tm.plant_4   CLIPPED,"'",
                         " '",tm.plant_5   CLIPPED,"'",
                         " '",tm.plant_6   CLIPPED,"'",
                         " '",tm.plant_7   CLIPPED,"'",   #FUN-A70084
                         " '",tm.plant_8   CLIPPED,"'",   #FUN-A70084
                         " '",tm.type2    CLIPPED,"'", #CHI-A70001 add
                         " '",tm.group     CLIPPED,"'",
                         " '",tm.type      CLIPPED,"'",
                         " '",tm.detail    CLIPPED,"'",
                         " '",tm.sum_code  CLIPPED,"'",
                         " '",tm.azk01 CLIPPED,"'",
                         " '",tm.azk04 CLIPPED,"'",
                         " '",tm.azh01 CLIPPED,"'",
                         " '",tm.dec  CLIPPED,"'",
                         " '",g_rep_user  CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",   
                         " '",g_template  CLIPPED,"'",
                         " '",g_bookno  CLIPPED,"'"
         CALL cl_cmdat('axcr201',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr111_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
 
   CALL cl_wait()
   CALL r201()
   ERROR ""
END WHILE
   CLOSE WINDOW r201_w
END FUNCTION
 
FUNCTION r201()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122CHAR(20)        # External(Disk) file name
          l_sql     LIKE type_file.chr1000,        # RDSQL STATEMENT        #No.FUN-680122CHAR(2000)
          l_item    LIKE type_file.chr20,          #No.FUN-680122CHAR(20)
          l_tmp     LIKE type_file.chr20,          #No.FUN-680122CHAR(8)
          l_za05    LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(40)
          l_flag    LIKE type_file.chr1,           #No.FUN-680122 VARCHAR(1)
          sr  RECORD
              item   LIKE ima_file.ima03,           #No.FUN-680122CHAR(20)
              ima01  LIKE ima_file.ima01,           #No.FUN-680122CHAR(20)
              ccc08  LIKE ccc_file.ccc08,           #No.FUN-7C0101CHAR(40)
            #  qty    LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3)#FUN-A20044
              qty    LIKE type_file.num15_3,           #No.FUN-680122DEC(15,3)#FUN-A20044
              amt    LIKE ima_file.ima32,           #No.FUN-680122 DECIMAL(20,6)
              cost   LIKE ima_file.ima32,           #No.FUN-680122DEC(20,6)
             # qty1   LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3)#FUN-A20044
              qty1   LIKE type_file.num15_3,           #No.FUN-680122DEC(15,3)#FUN-A20044
              amt1   LIKE ima_file.ima32,           #No.FUN-680122 DECIMAL(20,6)
              cost1  LIKE ima_file.ima32,           #No.FUN-680122DEC(20,6)
              amt_unit LIKE ima_file.ima32,         #No.FUN-680122 DECIMAL(20,6)
              amt_unit1 LIKE ima_file.ima32,        #No.FUN-680122 DECIMAL(20,6)
              cost_unit LIKE ima_file.ima32,        #No.FUN-680122DEC(20,6)
              cost_unit1 LIKE ima_file.ima32,       #No.FUN-680122DEC(20,6)
              dif1   LIKE ima_file.ima32,           #No.FUN-680122DEC(20,6)
              dif2   LIKE ima_file.ima32,           #No.FUN-680122DEC(20,6)
              order  LIKE type_file.chr1000         #No.FUN-680122CHAR(30)
              END RECORD,
          l_data  RECORD
                  ima02     LIKE ima_file.ima02,
                  ima021    LIKE ima_file.ima021,
                  oba02     LIKE oba_file.oba02
                  END RECORD,
         dec_name   LIKE type_file.chr1000,
         l_rep_name STRING,
         l_plant    STRING,
         l_zaa55    LIKE zaa_file.zaa08,
         l_zaa56    LIKE zaa_file.zaa08,
         l_zaa58    LIKE zaa_file.zaa08,
         l_zaa59    LIKE zaa_file.zaa08,
         l_zaa60    LIKE zaa_file.zaa08            #MOD-C30812 add
#NO.TQC-A40139  --Begin--                                                                                                           
 DEFINE l_10        LIKE type_file.chr1000                                                                                          
 DEFINE l_9         STRING                                                                                                          
 DEFINE l_1         LIKE zaa_file.zaa08                                                                                             
 DEFINE l_2         LIKE zaa_file.zaa08                                                                                             
 DEFINE l_3         LIKE zaa_file.zaa08                                                                                             
 DEFINE l_4         LIKE zaa_file.zaa08                                                                                             
 DEFINE l_5         LIKE zaa_file.zaa08                                                                                             
 DEFINE l_6         LIKE zaa_file.zaa08                                                                                             
 DEFINE l_7         LIKE zaa_file.zaa08                                                                                             
 DEFINE l_8         LIKE zaa_file.zaa08                                                                                             
#NO.TQC-A40139  --End-- 
 DEFINE l_11        LIKE zaa_file.zaa08            #MOD-C30812 add
 DEFINE l_12        LIKE zaa_file.zaa08            #MOD-C30812 add

 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
      ### *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
      CALL cl_del_data(l_table)
      SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
 
 
     CALL s_ymtodate(tm.yy1_b,tm.mm1_b,tm.yy1_b,tm.mm1_e)
     RETURNING g_bdate1,g_edate1
     CALL s_ymtodate(tm.yy2_b,tm.mm2_b,tm.yy2_b,tm.mm2_e)
     RETURNING g_bdate2,g_edate2
     CALL get_tmpfile()
     CALL get_dpm()   #內部自用,雜發票,折讓
     LET l_sql=" SELECT item ,ima01,ccc08,sum(qty),sum(amt),sum(cost),",   #No.FUN-7C0101 add ccc08
                     " sum(qty1),sum(amt1),sum(cost1),0,0,0,0,0,0 ", 
                     " FROM ",g_tname CLIPPED,
                     " GROUP BY item,ima01,ccc08 ORDER BY item,ima01,ccc08"      #No.FUN-7C0101 add 3
	     PREPARE r201_prepare1 FROM l_sql
	     IF SQLCA.sqlcode != 0 THEN
		CALL cl_err('prepare1:',SQLCA.sqlcode,1)
                CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
		EXIT PROGRAM
	     END IF
	     DECLARE r201_curs1 CURSOR FOR r201_prepare1
 
#     CALL cl_outnam('axcr201') RETURNING l_name  #No.TQC-A40139
	     LET g_pageno = 0
	     LET g_line= 0
	     FOREACH r201_curs1 INTO sr.*
	       IF SQLCA.sqlcode != 0 THEN
	          CALL cl_err('foreach:',SQLCA.sqlcode,1)
               END IF
               LET sr.amt=sr.amt/g_base
               LET sr.cost=sr.cost/g_base
               LET sr.amt1=sr.amt1/g_base
               LET sr.cost1=sr.cost1/g_base
               IF tm.azk04 >0 THEN
                  LET sr.amt=sr.amt/tm.azk04
                  LET sr.cost=sr.cost/tm.azk04
                  LET sr.amt1=sr.amt1/tm.azk04
                  LET sr.cost1=sr.cost1/tm.azk04
                 #MOD-C30854 str add------
                  #SELECT azi03 INTO t_azi03 FROM azi_file WHERE azi01 = tm.azk01  #CHI-C30012
                  LET t_azi03 = g_ccz.ccz26  #CHI-C30012
                  LET sr.amt=cl_digcut(sr.amt,t_azi03)
                  LET sr.cost=cl_digcut(sr.cost,t_azi03)
                  LET sr.amt1=cl_digcut(sr.amt1,t_azi03)
                  LET sr.cost1=cl_digcut(sr.cost1,t_azi03)
                 #MOD-C30854 end add------
               END IF
               IF sr.qty!=0 THEN
                  LET sr.amt_unit=sr.amt/sr.qty
                  LET sr.cost_unit=sr.cost/sr.qty
               ELSE
                  LET sr.amt_unit=0
                  LET sr.cost_unit=0
               END IF
               IF sr.qty1!=0 THEN
                  LET sr.amt_unit1=sr.amt1/sr.qty1
                  LET sr.cost_unit1=sr.cost1/sr.qty1
               ELSE
                  LET sr.amt_unit1=0
                  LET sr.cost_unit1=0
               END IF
 
               IF tm.group=2 THEN #銷售
                  LET sr.dif1=(sr.amt_unit-sr.amt_unit1)*sr.qty
                  LET sr.dif2=(sr.qty-sr.qty1)*sr.amt_unit1
               ELSE
                  LET sr.dif1=(sr.cost_unit-sr.cost_unit1)*sr.qty
                  LET sr.dif2=(sr.qty-sr.qty1)*sr.cost_unit1
               END IF
               IF sr.qty<>0 OR sr.qty1<>0 OR sr.amt <>0 OR
                  sr.amt1 <>0 OR sr.cost<>0 OR sr.cost1 <>0 THEN
                  #明細單身資料
                  INITIALIZE l_data.* TO NULL
                  CASE tm.data
                      WHEN '1'
                         SELECT oba02 INTO l_data.oba02 FROM oba_file
                          WHERE oba01=sr.item
                      WHEN '2'
                         SELECT azf03 INTO l_data.oba02 FROM azf_file
                          WHERE azf01=sr.item AND azf02 = 'F'
                  END CASE
                  SELECT ima02,ima021 INTO l_data.ima02,l_data.ima021   
                    FROM ima_file
                   WHERE ima01=sr.ima01
                  IF STATUS=NOTFOUND THEN
                     LET l_data.ima02 = null
                     LET l_data.ima021= null 
                  END IF
                  SELECT azi07 INTO t_azi07 FROM azi_file WHERE azi01 = tm.azk01  #No.FUN-870151  #MOD-C30854 add  #CHI-C30012
                  #SELECT azi03,azi07 INTO t_azi03,t_azi07 FROM azi_file WHERE azi01 = tm.azk01    #MOD-C30854 add #CHI-C30012
                  LET t_azi03 = g_ccz.ccz26  #CHI-C30012
                  EXECUTE insert_prep USING
                    sr.item,sr.ima01,sr.qty,sr.amt,sr.cost,               #FUN-870151
                    sr.qty1,sr.amt1,sr.cost1,sr.amt_unit,sr.amt_unit1,
                    sr.cost_unit,sr.cost_unit1,sr.dif1,sr.dif2,sr.order,
                    l_data.ima02,l_data.ima021,l_data.oba02,
                    g_sum.qty,g_sum.amt,g_sum.cost,g_sum.qty1,g_sum.amt1,
                    g_sum.cost1,g_sum.dae_amt,g_sum.dac_amt,
                    #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,sr.ccc08          #MOD-950231 #CHI-C30012
                    g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,sr.ccc08 #CHI-C30012
                    ,t_azi07,t_azi03    #No.FUN-870151    #MOD-C30854 add t_azi03
               END IF
             END FOREACH
 
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(g_wc,'ima01,ima11,ima131,ima12')
             RETURNING g_wc
        LET g_str = g_wc
     ELSE
        LET g_str = " "
     END IF
     #報表名稱
     IF NOT cl_null(tm.azh02) THEN
        LET l_rep_name = tm.azh02
     ELSE
        IF tm.group =2 THEN # 銷售
           #No.TQC-A40139  --Begin
           #LET l_rep_name = g_x[9]
           CALL cl_getmsg('axc-608',g_lang) RETURNING l_9
           LET l_rep_name = l_9 
           #No.TQC-A40139  --End  
        ELSE
           #No.TQC-A40139  --Begin
           #LET l_rep_name = g_x[10]
           CALL cl_getmsg('axc-609',g_lang) RETURNING l_9
           LET l_rep_name = l_9 
           #No.TQC-A40139  --End  
        END IF
     END IF
     #單位
     IF tm.dec ='2' THEN
        #No.TQC-A40139  --Begin
        #LET dec_name=g_x[17]
        CALL cl_getmsg('axc-610',g_lang) RETURNING l_10
        LET dec_name = l_10
        #No.TQC-A40139  --End  
     ELSE
        #No.TQC-A40139  --Begin
        #IF tm.dec='3' THEN LET dec_name=g_x[18] ELSE LET dec_name=g_x[16] END IF
        #No.TQC-A40139  --End  
        IF tm.dec='3' THEN 
           CALL cl_getmsg('axc-611',g_lang) RETURNING l_10   
           LET dec_name = l_10                               
        ELSE 
           CALL cl_getmsg('axc-612',g_lang) RETURNING l_10   
           LET dec_name = l_10                               
        END IF
     END IF
     #title
     IF tm.group=1 THEN #成本
        #No.TQC-A40139  --Begin
        #LET l_zaa55 = g_x[47] LET l_zaa56 = g_x[48]
        #LET l_zaa58 = g_x[49] LET l_zaa59 = g_x[50]
        #CALL cl_getmsg('axc-600',g_lang) RETURNING l_1        #MOD-C30734 mark
         CALL cl_getmsg('axc-613',g_lang) RETURNING l_1        #MOD-C30734 add                                                                             
         CALL cl_getmsg('axc-601',g_lang) RETURNING l_2                                                                             
         CALL cl_getmsg('axc-602',g_lang) RETURNING l_3                                                                             
         CALL cl_getmsg('axc-603',g_lang) RETURNING l_4 
	 CALL cl_getmsg('axc-614',g_lang) RETURNING l_11       #MOD-C30812 add
         LET l_zaa55 = l_1                                                                                                          
         LET l_zaa56 = l_2                                                                                                          
         LET l_zaa58 = l_3                                                                                                          
         LET l_zaa59 = l_4  
         LET l_zaa60 = l_11                                    #MOD-C30812 add
        #No.TQC-A40139  --End  
      ELSE
        #No.TQC-A40139  --Begin
        #LET l_zaa55 = g_x[71] LET l_zaa56 = g_x[72]
        #LET l_zaa58 = g_x[73] LET l_zaa59 = g_x[74]
         CALL cl_getmsg('axc-604',g_lang) RETURNING l_5                                                                             
         CALL cl_getmsg('axc-605',g_lang) RETURNING l_6                                                                             
         CALL cl_getmsg('axc-606',g_lang) RETURNING l_7                                                                             
         CALL cl_getmsg('axc-607',g_lang) RETURNING l_8                       
         CALL cl_getmsg('axc-615',g_lang) RETURNING l_12       #MOD-C30812 add                                                      
         LET l_zaa55 = l_5                                                                                                          
         LET l_zaa56 = l_6                                                                                                          
         LET l_zaa58 = l_7                                                                                                          
         LET l_zaa59 = l_8  
         LET l_zaa60 = l_12                                    #MOD-C30812 add
        #No.TQC-A40139  --End  
      END IF
     #資料庫來源
     LET l_plant = g_ary[1].plant CLIPPED,' ', g_ary[2].plant CLIPPED,' ',
                   g_ary[3].plant CLIPPED,' ', g_ary[4].plant CLIPPED,' ',
                   g_ary[5].plant CLIPPED,' ', g_ary[6].plant CLIPPED,' ',
                   g_ary[7].plant CLIPPED,' ', g_ary[8].plant CLIPPED,' ',
                   g_ary[9].plant CLIPPED
 
     #            p1    ;    p2        ;    p3      ;    p4      ;    p5
     LET g_str = g_str,";",l_rep_name,";",tm.azk01,";",tm.azk04,";",dec_name,";",
     #            p6       ;    p7      ;    p8      ;    p9       ;     p10
                 tm.yy1_b,";",tm.mm1_b,";",tm.mm1_e,";",tm.yy2_b,";",tm.mm2_b,";",
     #            p11      ;    p12        ;    p13    ;   p14     ;    p15
                 tm.mm2_e,";",tm.detail,";",l_plant,";",tm.sum_code,";",l_zaa55,";",
     #            p16     ;    p17    ;  p18         p19       ;     p20
                 l_zaa56,";",l_zaa58,";",l_zaa59,";",tm.group,";",l_zaa60              #MOD-C30812 add  l_zaa60
     CALL cl_prt_cs3('axcr201','axcr201',l_sql,g_str)   #FUN-710080 modify
 
     LET g_delsql= " DROP TABLE ",g_tname CLIPPED
     PREPARE del_cmd FROM g_delsql
     EXECUTE del_cmd
     LET g_delsql1= " DROP TABLE ",g_tname1 CLIPPED
     PREPARE del_dpm1 FROM g_delsql1
     EXECUTE del_dpm1
END FUNCTION
 
FUNCTION get_tmpfile()
DEFINE l_dot     LIKE type_file.chr1           #No.FUN-680122CHAR(1)
DEFINE l_title   LIKE type_file.chr1000        #No.FUN-680122CHAR(100)
DEFINE l_groupby LIKE type_file.chr1000        #No.FUN-680122CHAR(100)
DEFINE l_sql     LIKE type_file.chr1000        #No.FUN-680122CHAR(200)
DEFINE l_col1,l_col2  LIKE type_file.chr1000   #No.FUN-680122CHAR(200)
DEFINE tmp_sql   LIKE type_file.chr1000        #No.FUN-680122CHAR(1000)
 
 LET g_tname='r201_tmp1' 
LET g_delsql= " DROP TABLE ",g_tname CLIPPED
PREPARE del_cmd2 FROM g_delsql
EXECUTE del_cmd2
LET l_sql=null
LET tmp_sql=
#FUN-A10098---BEGIN
#     "CREATE TEMP TABLE ",g_tname CLIPPED,  #No.TQC-970305 mod
#              "(item   VARCHAR(20)," 
#             #" ima01  VARCHAR(20),",   #MOD-710149 mod
#              " ima01  VARCHAR(40),",   #MOD-710149 mod
#              " ccc08  VARCHAR(40),",   #No.FUN-7C0101 add
#              " qty    DEC(15,3),",
#              " amt    DEC(20,6),",
#              " cost   DEC(20,6),",
#              " qty1   DEC(15,3),",
#              " amt1   DEC(20,6),",
#              " cost1  DEC(20,6))"
     "CREATE TEMP TABLE ",g_tname CLIPPED,  #No.TQC-970305 mod
              "(item   LIKE type_file.chr20,",
              " ima01  LIKE ima_file.ima01,",   #MOD-710149 mod
              " ccc08  LIKE ima_file.ima01,",   #No.FUN-7C0101 add
              " qty    LIKE type_file.num15_3,",#FUN-A20044 #No.TQC-A40139
              " amt    LIKE type_file.num20_6,",#FUN-A20044  #No.TQC-A40139
              " cost   LIKE type_file.num20_6,",
              " qty1   LIKE type_file.num15_3,",#FUN-A20044 #No.TQC-A40139
              " amt1   LIKE type_file.num20_6,",#FUN-A20044  #No.TQC-A40139
              " cost1  LIKE type_file.num20_6)"#FUN-A20044   #No.TQC-A40139

#FUN-A10098---END
    PREPARE cre_p1 FROM tmp_sql
    EXECUTE cre_p1
 
    IF tm.group=1 THEN #成本   #MOD-A60140 add
       IF tm.data =1  THEN #資料選擇
          LET l_title=" ima131," #產品分類
       ELSE
          LET l_title=" ima11," #會計分類
       END IF
       IF tm.detail matches '[Yy]' THEN #要印料件
          LET l_title=l_title CLIPPED," ima01,"
       ELSE
          LET l_title=l_title CLIPPED,"'',"
       END IF
       #No.TQC-A40139  --Begin
      #LET l_col1="(sum(ccc61*-1)+sum(ccc81*-1)),sum(ccc63*-1),(sum(ccc62*-1)+sum(ccc82*-1)),0,0,0"  #No.FUN-660073
      #LET l_col2="0,0,0,(sum(ccc61*-1)+sum(ccc81*-1)),sum(ccc63*-1),(sum(ccc62*-1)+sum(ccc82*-1))"  #No.FUN-660073
      #LET l_col1="(sum(ccc61*-1)+sum(ccc81*-1)),sum(ccc63),(sum(ccc62*-1)+sum(ccc82*-1)),0,0,0"     #CHI-C50069 mark
      #LET l_col2="0,0,0,(sum(ccc61*-1)+sum(ccc81*-1)),sum(ccc63),(sum(ccc62*-1)+sum(ccc82*-1))"     #CHI-C50069 mark
#CHI-C50069---add---START
       CASE tm.b
         WHEN '1'
           LET l_col1="sum(ccc61*-1),sum(ccc63),sum(ccc62*-1),0,0,0"
           LET l_col2="0,0,0,sum(ccc61*-1),sum(ccc63),sum(ccc62*-1)"
         WHEN '2'
           LET l_col1="sum(ccc81*-1),0,sum(ccc82*-1),0,0,0"
           LET l_col2="0,0,0,sum(ccc81*-1),0,sum(ccc82*-1)"
         WHEN '3'
           LET l_col1="(sum(ccc61*-1)+sum(ccc81*-1)),sum(ccc63),(sum(ccc62*-1)+sum(ccc82*-1)),0,0,0"
           LET l_col2="0,0,0,(sum(ccc61*-1)+sum(ccc81*-1)),sum(ccc63),(sum(ccc62*-1)+sum(ccc82*-1))"
       END CASE
#CHI-C50069---add-----END
       #No.TQC-A40139  --End  
       LET l_title=l_title CLIPPED,"ccc08,"   #No.FUN-7C0101
       LET l_groupby = s_groupby(l_title CLIPPED)
       FOR g_idx=1 TO g_k
          LET tmp_sql= " INSERT INTO ",g_tname,
          " SELECT ",l_title CLIPPED,l_col1 CLIPPED,
#FUN-A10098---BEGIN
#          " FROM ",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
#" LEFT OUTER JOIN ",g_ary[g_idx].dbs_new CLIPPED,"ccc_file ON ima01=ccc01 AND ccc02=",tm.yy1_b," AND ",
          " FROM ",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
" LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'ccc_file')," ON ima01=ccc01 AND ccc02=",tm.yy1_b," AND",
#FUN-A10098---END
"                                                               ccc03 BETWEEN ",tm.mm1_b," AND ",tm.mm1_e," AND ",
"                                                               ccc07='",tm.type,"'",
" WHERE ",g_wc CLIPPED,
          " GROUP BY ",l_groupby CLIPPED
 	  CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
         #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark 
          PREPARE r201_prepare2 FROM tmp_sql
          EXECUTE r201_prepare2
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('prepare2:',SQLCA.sqlcode,1)
             EXECUTE del_cmd2 #delete tmpfile
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
             EXIT PROGRAM
          END IF
          LET tmp_sql= " INSERT INTO ",g_tname,
          " SELECT ",l_title CLIPPED,l_col2 CLIPPED,
#FUN-A10098---BEGIN
#          " FROM ",g_ary[g_idx].dbs_new CLIPPED,"ccc_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
          " FROM ",cl_get_target_table(g_ary[g_idx].plant,'ccc_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),

#FUN-A10098---END
          " WHERE ",g_wc CLIPPED,
          " AND ima01=ccc_file.ccc01",
          " AND ccc02=",tm.yy2_b,
          " AND ccc_file.ccc03 BETWEEN ",tm.mm2_b," AND ",tm.mm2_e,
          " AND ccc07='",tm.type,"'",       #No.FUN-7C0101 add
          " GROUP BY ",l_groupby CLIPPED
 	  CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
         #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
          PREPARE r201_prepare3 FROM tmp_sql
          EXECUTE r201_prepare3
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('prepare3:',SQLCA.sqlcode,1)
             EXECUTE del_cmd2 #delete tmpfile
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
             EXIT PROGRAM
          END IF
       END FOR  #for g_inx  dbs
    END IF                     #MOD-A60140 add
END FUNCTION
 
#No.TQC-A40139  --Begin
#REPORT r201_rep(sr)
#DEFINE l_last_sw   LIKE type_file.chr1,         #No.FUN-680122CHAR(1)
#       dec_name    LIKE type_file.chr20,        #No.FUN-680122 VARCHAR(10)
#       l_item      LIKE type_file.chr20,        #No.FUN-680122CHAR(20)
#       l_oba02     LIKE ima_file.ima02,         #No.FUN-680122 VARCHAR(30)
#       l_ima02     LIKE ima_file.ima02,         #No.FUN-680122 VARCHAR(30)
#       l_ima021    LIKE ima_file.ima021,        #No.FUN-680122 VARCHAR(30)   #FUN-5A0059
#          sr  RECORD
#              item   LIKE ima_file.ima03,         #No.FUN-680122 VARCHAR(20)
#              ima01  LIKE ima_file.ima01,         #No.FUN-680122 VARCHAR(20)
#           #   qty    LIKE ima_file.ima26,         #No.FUN-680122DEC(15,3)#FUN-A20044
#              qty    LIKE type_file.num15_3,         #No.FUN-680122DEC(15,3)#FUN-A20044
#              amt    LIKE ima_file.ima32,         #No.FUN-680122 DECIMAL(20,6)
#              cost   LIKE ima_file.ima32,         #No.FUN-680122DEC(20,6)
#           #   qty1   LIKE ima_file.ima26,         #No.FUN-680122DEC(15,3)#FUN-A20044
#              qty1   LIKE type_file.num15_3,         #No.FUN-680122DEC(15,3)#FUN-A20044
#              amt1   LIKE ima_file.ima32,         #No.FUN-680122 DECIMAL(20,6)
#              cost1  LIKE ima_file.ima32,         #No.FUN-680122DEC(20,6)
#              amt_unit LIKE ima_file.ima32,       #No.FUN-680122 DECIMAL(20,6)
#              amt_unit1 LIKE ima_file.ima32,      #No.FUN-680122 DECIMAL(20,6)
#              cost_unit LIKE ima_file.ima32,      #No.FUN-680122DEC(20,6)
#              cost_unit1 LIKE ima_file.ima32,     #No.FUN-680122DEC(20,6)
#              dif1   LIKE ima_file.ima32,         #No.FUN-680122DEC(20,6)
#              dif2   LIKE ima_file.ima32,         #No.FUN-680122DEC(20,6)
#              order  LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(30)
#              END RECORD
# 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1, g_company CLIPPED
#      PRINT
#      LET g_pageno = g_pageno + 1
#      IF  g_pageno=1 THEN LET l_item='X' END IF
#      LET pageno_total = PAGENO USING '<<<'
#      PRINT g_head CLIPPED,pageno_total
#      IF NOT cl_null(tm.azh02) THEN
#         LET g_x[1] = tm.azh02
#      ELSE
#         IF tm.group =2 THEN # 銷售
#            LET g_x[1]=g_x[9]
#         ELSE
#            LET g_x[1]=g_x[10]
#         END IF
#      END IF
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED   #No.TQC-6A0078
#      IF tm.dec ='2' THEN LET dec_name=g_x[17]
#      ELSE IF tm.dec='3' THEN	
#              LET dec_name=g_x[18]
#           ELSE
#              LET dec_name=g_x[16]
#           END IF
#      END IF
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[9]))/2)+1,g_x[11] CLIPPED,
#                   tm.azk01 CLIPPED,'/',tm.azk04 USING '<<&.&&',
#            COLUMN g_len-30,dec_name CLIPPED
#      PRINT g_dash[1,g_len]   #No.TQC-6A0078
#      PRINT COLUMN g_c[55],tm.yy1_b USING '####','/',
#            tm.mm1_b USING '##','-',tm.mm1_e USING '##',
#            COLUMN g_c[58],tm.yy2_b USING '####','/',
#            tm.mm2_b USING '##','-',tm.mm2_e USING '##'
#      PRINT COLUMN g_c[54],g_x[42],g_x[43],
#            COLUMN g_c[57],g_x[42],g_x[43],
#            COLUMN g_c[60],g_x[44],
#            COLUMN g_c[61],g_x[45],
#            COLUMN g_c[62],g_x[46]
#      IF tm.group=1 THEN #成本
#         LET g_zaa[55].zaa08 = g_x[47]
#         LET g_zaa[56].zaa08 = g_x[48]
#         LET g_zaa[58].zaa08 = g_x[49]
#         LET g_zaa[59].zaa08 = g_x[50]
#      ELSE
#         LET g_zaa[55].zaa08 = g_x[71]
#         LET g_zaa[56].zaa08 = g_x[72]
#         LET g_zaa[58].zaa08 = g_x[73]
#         LET g_zaa[59].zaa08 = g_x[74]
#      END IF
#      PRINT g_x[51],g_x[52],g_x[53],g_x[54],g_x[55],g_x[56],
#            g_x[57],g_x[58],g_x[59],g_x[60],g_x[61]
#           ,g_x[62]   #FUN-5A0059
#      PRINT g_dash1
# 
#      LET l_last_sw = 'n'
# 
#   ON EVERY ROW
#      LET l_ima02 = ''
#      LET l_ima021= ''   #FUN-5A0059
#      LET l_oba02 = ''
#      CASE tm.data
#          WHEN '1'
#                SELECT oba02 INTO l_oba02 FROM oba_file
#                 WHERE oba01=sr.item
#          WHEN '2'
#                SELECT azf03 INTO l_oba02 FROM azf_file
#                 WHERE azf01=sr.item AND azf02 = 'F' #6818
#      END CASE
#      SELECT ima02,ima021 INTO l_ima02,l_ima021   #FUN-5A0059
#        FROM ima_file
#      WHERE ima01=sr.ima01
#      IF STATUS=NOTFOUND THEN
#         LET l_ima02 = null
#         LET l_ima021= null   #FUN-5A0059
#      END IF
#      IF tm.detail matches '[Yy]' THEN
#         IF sr.item <> l_item THEN
#            PRINT COLUMN g_c[51],'**',sr.item[1,8],COLUMN g_c[52],l_oba02[1,26]
#            LET l_item=sr.item
#         END IF
#          PRINT COLUMN g_c[51],sr.ima01[1,15],COLUMN g_c[52],l_ima02 CLIPPED; #MOD-4A0238
#          PRINT COLUMN g_c[53],l_ima021 CLIPPED   #FUN-5A0059
#      ELSE
#         PRINT COLUMN g_c[51],sr.item[1,15],COLUMN g_c[52],l_oba02[1,26];
#      END IF
#      IF tm.group=2 THEN #銷售
#         PRINT COLUMN g_c[54],cl_numfor(sr.qty,54,g_ccz.ccz27), #CHI-690007 0->ccz27
#               COLUMN g_c[55],cl_numfor(sr.amt,55,g_azi03),    #FUN-570190
#               COLUMN g_c[56],cl_numfor(sr.amt_unit,56,g_azi03),    #FUN-570190
#               COLUMN g_c[57],cl_numfor(sr.qty1,57,g_ccz.ccz27), #CHI-690007 0->ccz27
#               COLUMN g_c[58],cl_numfor(sr.amt1,58,g_azi03),    #FUN-570190
#               COLUMN g_c[59],cl_numfor(sr.amt_unit1,59,g_azi03),    #FUN-570190
#               COLUMN g_c[60],cl_numfor(sr.dif1,60,0),
#               COLUMN g_c[61],cl_numfor(sr.dif2,61,0) ,
#               COLUMN g_c[62],cl_numfor((sr.dif1+sr.dif2),62,0)
#      ELSE
#         PRINT COLUMN g_c[54],cl_numfor(sr.qty,54,g_ccz.ccz27), #CHI-690007 0->ccz27
#               COLUMN g_c[55],cl_numfor(sr.cost,55,g_azi03),    #FUN-570190
#               COLUMN g_c[56],cl_numfor(sr.cost_unit,56,g_azi03),    #FUN-570190
#               COLUMN g_c[57],cl_numfor(sr.qty1,57,g_ccz.ccz27), #CHI-690007 0->ccz27
#               COLUMN g_c[58],cl_numfor(sr.cost1,58,g_azi03),    #FUN-570190
#               COLUMN g_c[59],cl_numfor(sr.cost_unit1,59,g_azi03),    #FUN-570190
#               COLUMN g_c[60],cl_numfor(sr.dif1,60,0),
#               COLUMN g_c[61],cl_numfor(sr.dif2,61,0),
#               COLUMN g_c[62],cl_numfor((sr.dif1+sr.dif2),62,0)
#      END IF
#   ON LAST ROW
#      PRINT g_dash2[1,g_len]
#      IF tm.group=2 THEN #銷售
#         PRINT COLUMN g_c[54],cl_numfor(sum(sr.qty),54,g_ccz.ccz27), #CHI-690007 0->ccz27
#               COLUMN g_c[55],cl_numfor(sum(sr.amt),55,g_azi03),    #FUN-570190
#               COLUMN g_c[56],cl_numfor(0,56,2),
#               COLUMN g_c[57],cl_numfor(sum(sr.qty1),57,g_ccz.ccz27), #CHI-690007 0->ccz27
#               COLUMN g_c[58],cl_numfor(sum(sr.amt1),58,g_azi03),    #FUN-570190
#               COLUMN g_c[59],cl_numfor(0,59,2),
#               COLUMN g_c[60],cl_numfor(sum(sr.dif1),60,0),
#               COLUMN g_c[61],cl_numfor(sum(sr.dif2),61,0),
#               COLUMN g_c[62],cl_numfor(sum(sr.dif1+sr.dif2),62,0)
#      ELSE
#         PRINT COLUMN g_c[54],cl_numfor(sum(sr.qty),54,g_ccz.ccz27), #CHI-690007 0->ccz27
#               COLUMN g_c[55],cl_numfor(sum(sr.cost),55,g_azi03),    #FUN-570190
#               COLUMN g_c[56],cl_numfor(0,56,2),
#               COLUMN g_c[57],cl_numfor(sum(sr.qty1),57,g_ccz.ccz27), #CHI-690007 0->ccz27
#               COLUMN g_c[58],cl_numfor(sum(sr.cost1),58,g_azi03),    #FUN-570190
#               COLUMN g_c[59],cl_numfor(0,59,2),
#               COLUMN g_c[60],cl_numfor(sum(sr.dif1),60,0),
#               COLUMN g_c[61],cl_numfor(sum(sr.dif2),61,0),
#               COLUMN g_c[62],cl_numfor(sum(sr.dif1+sr.dif2),62,0)
#      END IF
#      PRINT g_dash[1,g_len]
#      PRINT ' data from : ',
#            g_ary[1].plant CLIPPED,' ', g_ary[2].plant CLIPPED,' ',
#            g_ary[3].plant CLIPPED,' ', g_ary[4].plant CLIPPED,' ',
#            g_ary[5].plant CLIPPED,' ', g_ary[6].plant CLIPPED,' ',
#            g_ary[7].plant CLIPPED,' ', g_ary[8].plant CLIPPED,' ',
#            g_ary[9].plant CLIPPED
#      IF tm.sum_code matches '[Yy]' THEN
#         PRINT ' ',g_x[31] CLIPPED,' ',g_x[32] CLIPPED,'     ',g_x[33]
#         PRINT cl_numfor(g_sum.qty,13,g_ccz.ccz27), #CHI-690007 0->ccz27
#               cl_numfor(g_sum.amt,13,g_azi03),    #FUN-570190
#               cl_numfor(g_sum.cost,14,g_azi03),    #FUN-570190
#               cl_numfor(g_sum.qty1,13,g_ccz.ccz27), #CHI-690007 0->ccz27
#               cl_numfor(g_sum.amt1,13,g_azi03) ,    #FUN-570190
#               cl_numfor(g_sum.cost1,13,g_azi03),    #FUN-570190
#               cl_numfor(g_sum.dae_amt,13,g_azi03), #折讓    #FUN-570190
#               cl_numfor(g_sum.dac_amt,13,g_azi03)  #雜項發票    #FUN-570190
#      END IF
#      PRINT g_dash[1,g_len]
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      LET l_last_sw='y'
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#No.TQC-A40139  --End  
 
FUNCTION duplicate(l_plant,n)               #檢查輸入之工廠編號是否重覆
   DEFINE l_plant     LIKE azp_file.azp01
   DEFINE l_idx,n     LIKE type_file.num10           #No.FUN-68012i2INTEGER
 
   FOR l_idx = 1 TO n
       IF g_ary[l_idx].plant = l_plant THEN
          LET l_plant = ''
       END IF
   END FOR
   RETURN l_plant
END FUNCTION
 
FUNCTION get_dpm()
DEFINE l_sql         LIKE type_file.chr1000,       #No.FUN-680122CHAR(500)
       l_wc          LIKE type_file.chr1000,       #No.FUN-680122CHAR(500)
       tmp_sql       LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(1000)
       f1,f2,f3      LIKE oeb_file.oeb13,          #No.FUN-680122DEC(20,6)
       l_title       LIKE type_file.chr1000,       #No.FUN-680122CHAR(100)
       l_groupby     LIKE type_file.chr1000,       #No.FUN-680122CHAR(100)
       l_groupby1    LIKE type_file.chr1000,       #No.FUN-680122CHAR(100)
       l_tlf026      LIKE tlf_file.tlf026,         #MOD-A70084 add
       l_tlf027      LIKE tlf_file.tlf027,         #MOD-A70084 add
       l_cnt         LIKE type_file.num5,          #MOD-A70084 add
       l_amt         LIKE ima_file.ima32,          #MOD-A70084 add
       l_ima01       LIKE ima_file.ima01,          #No:CHI-A70023 add
       l_tlf01       LIKE tlf_file.tlf01,          #No:CHI-A70023 add
       l_tlf66       LIKE tlf_file.tlf66,          #No:CHI-A70023 add
       l_azf08       LIKE type_file.chr1000,       #CHI-C50069 add
       l_dbs         LIKE type_file.chr1000,       #No:CHI-A70023 add
       l_mm          LIKE ima_file.ima89,          #No:CHI-A70023 add
       l_dpm RECORD
              item   LIKE ima_file.ima03,          #No.FUN-680122CHAR(20)
              tlf01  LIKE tlf_file.tlf01,          #No.FUN-680122CHAR(20)
              mm     LIKE ima_file.ima89,          #No.FUN-680122SMALLINT
            # qty    LIKE ima_file.ima26,          #No.FUN-680122DEC(15,3)  #數量(銷)#FUN-A20044
              qty    LIKE type_file.num15_3,       #No.FUN-680122DEC(15,3)  #數量(銷)#FUN-A20044
              amt    LIKE ima_file.ima32,          #No.FUN-680122DEC(20,6)  #金額(銷)
              cost   LIKE ima_file.ima32,          #No.FUN-680122DEC(20,6)  #成本(銷)
           #  qty1   LIKE ima_file.ima26,          #No.FUN-680122DEC(15,3)  #數量(退)#FUN-A20044
              qty1   LIKE type_file.num15_3,       #No.FUN-680122DEC(15,3)  #數量(退)#FUN-A20044
              amt1   LIKE ima_file.ima32,          #No.FUN-680122DEC(20,6)  #金額(退)
              cost1  LIKE ima_file.ima32,          #No.FUN-680122DEC(20,6)  #成本(退)
              dae_amt LIKE ima_file.ima32,         #No.FUN-680122DEC(20,6)  #折讓
              dac_amt LIKE ima_file.ima32          #No.FUN-680122DEC(20,6)  #雜項發票
              END RECORD
DEFINE l_dpm_temp    LIKE ima_file.ima32           #MOD-C30854 add
DEFINE l_tlf902      LIKE tlf_file.tlf902          #CHI-A70023 add
DEFINE l_tlf903      LIKE tlf_file.tlf903          #CHI-A70023 add
DEFINE l_tlf904      LIKE tlf_file.tlf904          #CHI-A70023 add 

 LET g_tname1='r201_tmp2'      
LET g_delsql1= " DROP TABLE ",g_tname1 CLIPPED
PREPARE del_dpm FROM g_delsql1
EXECUTE del_dpm
LET tmp_sql=
#FUN-A10098---BEGIN
#     "CREATE TEMP TABLE ",g_tname1 CLIPPED,  #No.TQC-970305 mod
#              "(item   VARCHAR(20),",  
#             #" tlf01  VARCHAR(20),",   #MOD-710149 mod
#              " tlf01  VARCHAR(40),",   #MOD-710149 mod
#              " mm     SMALLINT,",   #1/2
#              " qty    DEC(15,3),",  #數量(銷)
#              " amt    DEC(20,6),",  #金額(銷)
#              " cost   DEC(20,6),",  #成本(銷)
#              " qty1   DEC(15,3),",  #數量(退)
#              " amt1   DEC(20,6),",  #金額(退)
#              " cost1  DEC(20,6),",  #成本(退)
#              " dae_amt DEC(20,6),", #折讓
#              " dac_amt DEC(20,6))" #雜項發票
     "CREATE TEMP TABLE ",g_tname1 CLIPPED,       #No.TQC-970305 mod
              "(item   LIKE type_file.chr20,",
              " tlf01  LIKE tlf_file.tlf01,",     #MOD-710149 mod
              " tlf026 LIKE tlf_file.tlf026,",    #MOD-A70084 add
              " tlf027 LIKE tlf_file.tlf027,",    #MOD-A70084 add
              " tlf66  LIKE tlf_file.tlf66,",     #CHI-A70023 modify   #TQC-C60055
              " tlf902 LIKE tlf_file.tlf902,",    #TQC-C60055
              " tlf903 LIKE tlf_file.tlf903,",    #TQC-C60055
              " tlf904 LIKE tlf_file.tlf904,",    #TQC-C60055
              " dbs    LIKE type_file.chr1000,",  #CHI-A70023 modify   #TQC-C60055
              
              " mm     LIKE type_file.num5,",     #1/2
              " qty    LIKE type_file.num15_3,",  #數量(銷)#FUN-A20044 #No.TQC-A40139
              " amt    LIKE type_file.num20_6,",  #金額(銷)
              " cost   LIKE type_file.num20_6,",  #成本(銷)
              " qty1   LIKE type_file.num15_3,",  #數量(退)#FUN-A20044 #No.TQC-A40139
              " amt1   LIKE type_file.num20_6,",  #金額(退)
              " cost1  LIKE type_file.num20_6,",  #成本(退)
              " dae_amt LIKE type_file.num20_6,", #折讓
              " dac_amt LIKE type_file.num20_6)"  #雜項發票
#FUN-A10098---END
    PREPARE cre_dpm FROM tmp_sql
    EXECUTE cre_dpm
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('Create tmp_dpm:' ,SQLCA.sqlcode,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
       EXIT PROGRAM
    END IF
 
    IF tm.data =1  THEN #資料選擇
       LET l_title=" ima131," #產品分類
    ELSE
       LET l_title=" ima11," #會計分類
    END IF
   #---------------No:CHI-A70023 modify
   #IF tm.detail matches '[Yy]' THEN #要印料件
   #   LET l_title=l_title CLIPPED," tlf01,"
   #ELSE
   #   LET l_title=l_title CLIPPED,"'',"
   #END IF
    LET l_title=l_title CLIPPED," tlf01,"
   #---------------No:CHI-A70023 end   
   #LET l_title=l_title CLIPPED,"tlf026,tlf027,"   #MOD-A70084 add                  #TQC-C60055 mark
    LET l_title=l_title CLIPPED,"tlf026,tlf027,tlf66,tlf902,tlf903,tlf904,"         #TQC-C60055 add 
    LET l_groupby = s_groupby(l_title CLIPPED)
#CHI-C50069---add---START
    CASE tm.b
      WHEN '1'
        LET l_azf08 = "(azf08 is null OR azf08 = 'N')"
      WHEN '2'
        LET l_azf08 = "azf08 = 'Y'"
      WHEN '3'
        LET l_azf08 = "(azf08 is null OR azf08 = 'N' OR azf08 = 'Y')"
    END CASE
#CHI-C50069---add-----END
 
###內部自用銷貨
    LET l_wc=g_wc
    LET l_wc=change_string(l_wc,"ima01","tlf01")
    FOR g_idx=1 TO g_k
          LET l_groupby1= l_groupby CLIPPED,", 1"
          LET tmp_sql= " INSERT INTO ",g_tname1,
         #" SELECT ",l_title CLIPPED,"1,",                                #No:CHI-A70023 mark 
          " SELECT ",l_title CLIPPED,"'",g_ary[g_idx].dbs_new,"',1,",     #No:CHI-A70023 add
     #       異動數量                 銷售金額          成會異動成本
     #  " sum(tlf10*tlf60*tlf907),sum(ogb14*oga24*tlf907),sum(tlf21*tlf907), ",                     #MOD-C30854 mark
        " sum(tlf10*tlf60*tlf907),ROUND(sum(ogb14*oga24*tlf907),",g_ccz.ccz26,"),sum(tlf21*tlf907), ",  #MOD-C30854 add #CHI-C30012 g_azi03->g_ccz.ccz26
          " 0,0,0,0,0",
#FUN-A10098---BEGIN
#          " FROM ",g_ary[g_idx].dbs_new CLIPPED,"tlf_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"smy_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"occ_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"oga_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ogb_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
          " FROM ",cl_get_target_table(g_ary[g_idx].plant,'tlf_file'),
          " LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'azf_file') CLIPPED," ON tlf14=azf01 AND azf02='2'", #CHI-C50069 add
          " ,",cl_get_target_table(g_ary[g_idx].plant,'smy_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'occ_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'oga_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ogb_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
#FUN-A10098---END
          " WHERE ",l_wc CLIPPED,
          " AND tlf03 = 724  AND tlf02 = 50 ",
          " AND tlf61=smyslip AND smydmy1 = 'Y' ",
          " AND tlf06 BETWEEN '",g_bdate1,"' AND '",g_edate1,"' ",
         #" AND tlf01=ima01 AND tlf19 = occ01 AND occ37 = 'Y' ", #CHI-A70001 mark
          " AND tlf01=ima01 AND tlf19 = occ01  ", #CHI-A70001
          " AND tlf026=ogb01 AND tlf027=ogb03 AND ogb01=oga01 ",
          " AND oga00 NOT IN ('A','3','7') ",      #No.MOD-950210 add
          " AND (oga65 = 'N' OR oga65 IS NULL) ",   #MOD-C10075
          " AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add  #CHI-A70001 mod ,
          " AND ",l_azf08 #CHI-C50069 add
          #CHI-A70001 add --start--
          CASE tm.type2
             WHEN '1'   #關係人
                LET tmp_sql=tmp_sql CLIPPED," AND occ37='Y'"
             WHEN '2'   #非關係人
                LET tmp_sql=tmp_sql CLIPPED," AND occ37='N'"
          END CASE
          #CHI-A70001 add --end--
          #" GROUP BY ",l_groupby #CHI-A70001 mark
          LET tmp_sql=tmp_sql CLIPPED," GROUP BY ",l_groupby #CHI-A70001
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
         #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
          PREPARE r201_predpm1 FROM tmp_sql
          EXECUTE r201_predpm1
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('predpm1:',SQLCA.sqlcode,1)
          END IF
 
          LET l_groupby1= l_groupby CLIPPED,", 2"
          LET tmp_sql= " INSERT INTO ",g_tname1,
         #" SELECT ",l_title CLIPPED,"2,",                                #No:CHI-A70023 mark
          " SELECT ",l_title CLIPPED,"'",g_ary[g_idx].dbs_new,"',2,",     #No:CHI-A70023 add
     #       異動數量                 銷售金額          成會異動成本
     #  " sum(tlf10*tlf60*tlf907),sum(ogb14*oga24*tlf907),sum(tlf21*tlf907), ",                     #MOD-C30854 mark
        " sum(tlf10*tlf60*tlf907),ROUND(sum(ogb14*oga24*tlf907),",g_ccz.ccz26,"),sum(tlf21*tlf907), ",  #MOD-C30854 add #CHI-C30012 g_azi03->g_ccz.ccz26
          " 0,0,0,0,0",
#FUN-A10098---BEGIN
#          " FROM ",g_ary[g_idx].dbs_new CLIPPED,"tlf_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"smy_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"occ_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"oga_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ogb_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
          " FROM ",cl_get_target_table(g_ary[g_idx].plant,'tlf_file'),
          " LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'azf_file') CLIPPED," ON tlf14=azf01 AND azf02='2'", #CHI-C50069 add
          " ,",cl_get_target_table(g_ary[g_idx].plant,'smy_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'occ_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'oga_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ogb_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
#FUN-A10098---END
          " WHERE ",l_wc CLIPPED,
          " AND tlf03 = 724  AND tlf02 = 50 ",
          " AND tlf61=smyslip AND smydmy1 = 'Y' ",
          " AND tlf06 BETWEEN '",g_bdate2,"' AND '",g_edate2,"' ",
         #" AND tlf01=ima01 AND tlf19 = occ01 AND occ37 = 'Y' ", #CHI-A70001 mark
          " AND tlf01=ima01 AND tlf19 = occ01  ", #CHI-A70001
          " AND tlf026=ogb01 AND tlf027=ogb03 AND ogb01=oga01 ",
          " AND oga00 NOT IN ('A','3','7') ",     #No.MOD-950210 add
          " AND (oga65 = 'N' OR oga65 IS NULL) ",   #MOD-C10075
          " AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add  #CHI-A70001 mod ,
          " AND ",l_azf08 #CHI-C50069 add
          #CHI-A70001 add --start--
          CASE tm.type2
             WHEN '1'   #關係人
                LET tmp_sql=tmp_sql CLIPPED," AND occ37='Y'"
             WHEN '2'   #非關係人
                LET tmp_sql=tmp_sql CLIPPED," AND occ37='N'"
          END CASE
          #CHI-A70001 add --end--
          #" GROUP BY ",l_groupby CLIPPED #CHI-A70001 mark
          LET tmp_sql=tmp_sql CLIPPED," GROUP BY ",l_groupby CLIPPED #CHI-A70001
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
         #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
          PREPARE r201_predpm2 FROM tmp_sql
          EXECUTE r201_predpm2
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('predpm2:',SQLCA.sqlcode,1)
          END IF
    END FOR
   #str MOD-A70084 add
   #---------------No:CHI-A70023 modify
   #LET l_sql = "SELECT DISTINCT tlf026,tlf027,amt FROM ",g_tname1 CLIPPED,
   #            " ORDER BY tlf026,tlf027"
   #LET l_sql = "SELECT DISTINCT tlf01,tlf66,dbs,mm,tlf026,tlf027,amt,amt1,tlf902,tlf903,tlf904 FROM ",g_tname1 CLIPPED,  #MOD-C60152 mark
    LET l_sql = "SELECT DISTINCT tlf01,tlf66,dbs,mm,tlf026,tlf027,amt,tlf902,tlf903,tlf904 FROM ",g_tname1 CLIPPED, #MOD-C60152 add   
                " ORDER BY tlf01,tlf026,tlf027"  
   #---------------No:CHI-A70023 end
    PREPARE r201_pre00 FROM l_sql
    DECLARE r201_cur00 CURSOR FOR r201_pre00
   #FOREACH r201_cur00 INTO l_tlf026,l_tlf027,l_amt                                                        #CHI-A70023 mark
    FOREACH r201_cur00 INTO l_tlf01,l_tlf66,l_dbs,l_mm,l_tlf026,l_tlf027,l_amt,l_tlf902,l_tlf903,l_tlf904  #No:CHI-A70023 add
       
      #IF NOT cl_null(l_tlf026) AND NOT cl_null(l_tlf027) THEN    #No:CHI-A70023 mark
      #--------------No:CHI-A70023 add
      IF l_tlf66 = 'X' THEN
         CALL s_ogc_amt_1(l_tlf01,l_tlf026,l_tlf027,l_tlf902,l_tlf903,l_tlf904,l_dbs) RETURNING l_amt   #MOD-C60176 mark
          
          LET l_amt = l_amt * -1
       ELSE
      #--------------No:CHI-A70023 end
          #抓取看看是否為多倉儲出貨的銷貨,若是的話銷貨金額是錯的,需重算
          LET l_cnt = 0
          SELECT COUNT(*) INTO l_cnt FROM ogc_file
           WHERE ogc01=l_tlf026 AND ogc03=l_tlf027
          IF cl_null(l_cnt) THEN LET l_cnt = 0  END IF
          IF l_cnt > 1 THEN
          
             LET l_amt = l_amt / l_cnt
            #------------------No:CHI-A70023 mark
            # LET l_sql="UPDATE ",g_tname1,
            #           "   SET amt = ",l_amt,
            #           " WHERE tlf026='",l_tlf026,"' ",
            #           "   AND tlf027= ",l_tlf027
            # PREPARE r201_pre01 FROM l_sql
            # EXECUTE r201_pre01
            # IF SQLCA.sqlcode != 0 THEN
            #    CALL cl_err('r201_pre01:',SQLCA.sqlcode,1)
            # END IF
            #------------------No:CHI-A70023 end
          END IF
       END IF
       #------------------No:CHI-A70023 add
       IF tm.detail MATCHES '[Nn]' THEN #要印料件
          LET l_ima01 = ''
       ELSE
          LET l_ima01 = l_tlf01
       END IF

       LET l_sql="UPDATE ",g_tname1,
                 "   SET amt = ",l_amt,",",
                 "       tlf01 = '",l_ima01,"'",
                 " WHERE tlf026='",l_tlf026,"' ",
                 "   AND tlf027= ",l_tlf027,
                 "   AND tlf01 ='",l_tlf01,"'",
                 "   AND dbs = '",l_dbs,"'",
                 "   AND mm = ",l_mm
       PREPARE r201_pre01 FROM l_sql
       EXECUTE r201_pre01
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('r201_pre01:',SQLCA.sqlcode,1)
       END IF
      #------------------No:CHI-A70023 end
    END FOREACH
   #end MOD-A70084 add
   #---------------No:CHI-A70023 add
   IF tm.data =1  THEN #資料選擇
      LET l_title=" ima131," #產品分類
   ELSE
      LET l_title=" ima11," #會計分類
   END IF
   IF tm.detail matches '[Yy]' THEN #要印料件
      LET l_title=l_title CLIPPED," tlf01,"
   ELSE
      LET l_title=l_title CLIPPED,"'',"
   END IF
   LET l_groupby = s_groupby(l_title CLIPPED)         
  #---------------No:CHI-A70023 end
###內部自用退貨
    FOR g_idx=1 TO g_k
          LET l_groupby1= l_groupby CLIPPED,", 1"
          LET tmp_sql= " INSERT INTO ",g_tname1,
          " SELECT ",l_title CLIPPED," '','','','','','','',1,",       #No:CHI-A70023 modify   #TQC-C60055 modify
       #" 0,0,0,sum(tlf10*tlf60*tlf907),sum(ohb14*oha24*tlf907), ",                      #MOD-C30854 mark
        " 0,0,0,sum(tlf10*tlf60*tlf907),ROUND(sum(ohb14*oha24*tlf907),",g_ccz.ccz26,"), ",   #MOD-C30854 add #CHI-C30012 g_azi03->g_ccz.ccz26
        " sum(tlf21*tlf907),0,0 ",
#FUN-A10098---BEGIN
#          " FROM ",g_ary[g_idx].dbs_new CLIPPED,"tlf_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"smy_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"occ_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"oha_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ohb_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
          " FROM ",cl_get_target_table(g_ary[g_idx].plant,'tlf_file'),
          " LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'azf_file') CLIPPED," ON tlf14=azf01 AND azf02='2'", #CHI-C50069 add
          " ,",cl_get_target_table(g_ary[g_idx].plant,'smy_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'occ_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'oha_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ohb_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
#FUN-A10098---END
          " WHERE ",g_wc CLIPPED,
          " AND tlf02 = 731 AND tlf03 = 50 ",
          " AND tlf61=smyslip AND smydmy1 = 'Y' ",
          " AND tlf06 BETWEEN '",g_bdate1,"' AND '",g_edate1,"' ",
         #" AND tlf01=ima01 AND oha03 = occ01 AND occ37 = 'Y' ", #CHI-A70001 mark
          " AND tlf01=ima01 AND oha03 = occ01  ", #CHI-A70001
          " AND tlf036=ohb01 AND tlf037=ohb03 AND ohb01=oha01 ",
          " AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add #CHI-A70001 mod ,
          " AND ",l_azf08 #CHI-C50069 add
          #CHI-A70001 add --start--
          CASE tm.type2
             WHEN '1'   #關係人
                LET tmp_sql=tmp_sql CLIPPED," AND occ37='Y'"
             WHEN '2'   #非關係人
                LET tmp_sql=tmp_sql CLIPPED," AND occ37='N'"
          END CASE
          #CHI-A70001 add --end--
          #" GROUP BY ",l_groupby CLIPPED #CHI-A70001 mark
          LET tmp_sql=tmp_sql CLIPPED," GROUP BY ",l_groupby CLIPPED #CHI-A70001
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
         #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
          PREPARE r201_pregsl1 FROM tmp_sql
          EXECUTE r201_pregsl1
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('pregsl1:',SQLCA.sqlcode,1)
          END IF
          LET l_groupby1= l_groupby CLIPPED,", 2"
          LET tmp_sql= " INSERT INTO ",g_tname1,
          " SELECT ",l_title CLIPPED," '','','','','','','',2,",       #No:CHI-A70023 modify   #TQC-C60055 modify
       #" 0,0,0,sum(tlf10*tlf60*tlf907),sum(ohb14*oha24*tlf907), ",                      #MOD-C30854 mark
        " 0,0,0,sum(tlf10*tlf60*tlf907),ROUND(sum(ohb14*oha24*tlf907),",g_ccz.ccz26,"), ",   #MOD-C30854 add #CHI-C30012 g_azi03->g_ccz.ccz26
        " sum(tlf21*tlf907),0,0 ",
#FUN-A10098---BEGIN
#          " FROM ",g_ary[g_idx].dbs_new CLIPPED,"tlf_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"smy_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"occ_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"oha_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ohb_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
          " FROM ",cl_get_target_table(g_ary[g_idx].plant,'tlf_file'),
          " LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'azf_file') CLIPPED," ON tlf14=azf01 AND azf02='2'", #CHI-C50069 add
          " ,",cl_get_target_table(g_ary[g_idx].plant,'smy_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'occ_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'oha_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ohb_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
#FUN-A10098---END
          " WHERE ",g_wc CLIPPED,
          " AND tlf02 = 731 AND tlf03 = 50 ",
          " AND tlf61=smyslip AND smydmy1 = 'Y' ",
          " AND tlf06 BETWEEN '",g_bdate2,"' AND '",g_edate2,"' ",
         #" AND tlf01=ima01 AND oha03 = occ01 AND occ37 = 'Y' ", #CHI-A70001 mark
          " AND tlf01=ima01 AND oha03 = occ01  ", #CHI-A70001
          " AND tlf036=ohb01 AND tlf037=ohb03 AND ohb01=oha01 ",
          " AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add #CHI-A70001 mod ,
          " AND ",l_azf08 #CHI-C50069 add
          #CHI-A70001 add --start--
          CASE tm.type2
             WHEN '1'   #關係人
                LET tmp_sql=tmp_sql CLIPPED," AND occ37='Y'"
             WHEN '2'   #非關係人
                LET tmp_sql=tmp_sql CLIPPED," AND occ37='N'"
          END CASE
          #CHI-A70001 add --end--
          #" GROUP BY ",l_groupby #CHI-A70001 mark
          LET tmp_sql=tmp_sql CLIPPED," GROUP BY ",l_groupby #CHI-A70001
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
         #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark 
          PREPARE r201_pregsl2 FROM tmp_sql
          EXECUTE r201_pregsl2
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('pregsl2:',SQLCA.sqlcode,1)
          END IF
    END FOR
    IF tm.data =1  THEN #資料選擇
       LET l_title=" ima131," #產品分類
    ELSE
       LET l_title=" ima11," #會計分類
    END IF
    IF tm.detail matches '[Yy]' THEN #要印料件
       LET l_title=l_title CLIPPED," ima01,"
    ELSE
       LET l_title=l_title CLIPPED,"'',"
    END IF
    LET l_title=l_title CLIPPED,"'','',"   #MOD-A70084 add
    LET l_groupby = s_groupby(l_title CLIPPED)
###折讓 dae_amt
    LET l_wc=g_wc
    FOR g_idx=1 TO g_k
          LET l_groupby1= l_groupby CLIPPED,", 1"
          LET tmp_sql= " INSERT INTO ",g_tname1,
          " SELECT ",l_title CLIPPED," '','','','','',1,",       #No:CHI-A70023 modify   #TQC-C60055 modify
          " 0,0,0,0,0,0,SUM(omb16),0 ",
#FUN-A10098---BEGIN
#          " FROM ",g_ary[g_idx].dbs_new CLIPPED,"oma_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"omb_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ome_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
          " FROM ",cl_get_target_table(g_ary[g_idx].plant,'oma_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'omb_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ome_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
#FUN-A10098---END
#         " WHERE oma33=5 AND oma39<>'4'", #銷貨折讓
          " WHERE oma00='22' AND oma01 MATCHES 'ALB*' ", #銷貨折讓
          " AND ",l_wc CLIPPED,
          " AND oma02 BETWEEN '",g_bdate1,"' AND '",g_edate1,"' ",
          " AND oma10=ome01 AND omb04[1,4] <> 'MISC'",  #MOD-710129 mod
          " AND (oma75 = ome03 OR oma75 IS NULL)",    #No.FUN-B90130 
          " AND omb01=oma01 AND omevoid = 'N' ",
          " AND omb04=ima01 ",
          " GROUP BY ",l_groupby CLIPPED
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
         #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098 #TQC-BB0182 mark
          PREPARE r201_predae1 FROM tmp_sql
          EXECUTE r201_predae1
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('predae1:',SQLCA.sqlcode,1)
          END IF
          LET l_groupby1= l_groupby CLIPPED,", 2"
          LET tmp_sql= " INSERT INTO ",g_tname1,
          " SELECT ",l_title CLIPPED," '','','','','',2,",       #No:CHI-A70023 modify   #TQC-C60055 modify
          " 0,0,0,0,0,0,SUM(omb16),0 ",
#FUN-A10098---BEGIN
#          " FROM ",g_ary[g_idx].dbs_new CLIPPED,"oma_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"omb_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ome_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
          " FROM ",cl_get_target_table(g_ary[g_idx].plant,'oma_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'omb_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ome_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
#FUN-A10098---END
#         " WHERE oma33=5 AND oma39<>'4'", #銷貨折讓
          " WHERE oma00='22' AND oma01 MATCHES 'ALB*' ", #銷貨折讓
          " AND ",l_wc CLIPPED,
          " AND oma02 BETWEEN '",g_bdate2,"' AND '",g_edate2,"' ",
          " AND oma10=ome01 AND omb04[1,4] <> 'MISC'", #MOD-710129 mod
          " AND (oma75 = ome03 OR oma75 IS NULL)",    #No.FUN-B90130  
          " AND omb01=oma01 AND omevoid = 'N' ",
          " AND omb04=ima01 ",
          " GROUP BY ",l_groupby
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
         #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
          PREPARE r201_predae2 FROM tmp_sql
          EXECUTE r201_predae2
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('predae2:',SQLCA.sqlcode,1)
          END IF
    END FOR
###雜項發票 dac_amt
    FOR g_idx=1 TO g_k
          LET l_groupby1= l_groupby CLIPPED,", 1"
          LET tmp_sql= " INSERT INTO ",g_tname1,
          " SELECT ",l_title CLIPPED," '','','','','',1,",       #No:CHI-A70023 modify   #TQC-C60055 modify
          " 0,0,0,0,0,0,0,SUM(omb12*omb14*oma24) ",
#FUN-A10098---BEGIN
#          " FROM ",g_ary[g_idx].dbs_new CLIPPED,"oma_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"omb_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ome_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
          " FROM ",cl_get_target_table(g_ary[g_idx].plant,'oma_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'omb_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ome_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
#FUN-A10098---END
                #41雜項商用發票    4.發票作廢
    #     " WHERE oma33=41 AND oma39<>'4'",
          " WHERE oma00='14' ",
          " AND ",l_wc CLIPPED,
          " AND oma02 BETWEEN '",g_bdate1,"' AND '",g_edate1,"' ",
          " AND oma10=ome01 AND omb04[1,4] <> 'MISC'",  #MOD-710129 mod
          " AND (oma75 = ome03 OR oma75 IS NULL)",    #No.FUN-B90130 
          " AND omb01=oma01 AND omevoid = 'N' ",
          " AND omb04=ima01 ",
          " GROUP BY ",l_groupby CLIPPED
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
          #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
          PREPARE r201_predac1 FROM tmp_sql
          EXECUTE r201_predac1
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('predac1:',SQLCA.sqlcode,1)
          END IF
          LET l_groupby1= l_groupby CLIPPED,", 2"
          LET tmp_sql= " INSERT INTO ",g_tname1,
          " SELECT ",l_title CLIPPED," '','','','','',2,",       #No:CHI-A70023 modify   #TQC-C60055 modify
          " 0,0,0,0,0,0,0,SUM(omb12*omb14*oma24) ",
#FUN-A10098---BEGIN
          " FROM ",cl_get_target_table(g_ary[g_idx].plant,'oma_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'omb_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ome_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
#          " FROM ",g_ary[g_idx].dbs_new CLIPPED,"oma_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"omb_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ome_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
#FUN-A10098---END
                #41雜項商用發票    4.發票作廢
    #     " WHERE oma33=41 AND oma39<>'4'",
          " WHERE oma00='14' ",
          " AND ",l_wc CLIPPED,
          " AND oma02 BETWEEN '",g_bdate2,"' AND '",g_edate2,"' ",
          " AND oma10=ome01 AND omb04[1,4] <> 'MISC'",  #MOD-710129 mod
          " AND (oma75 = ome03 OR oma75 IS NULL)",    #No.FUN-B90130 
          " AND omb01=oma01 AND omevoid = 'N' ",
          " AND omb04=ima01 ",
          " GROUP BY ",l_groupby CLIPPED
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
         #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
          PREPARE r201_predac2 FROM tmp_sql
          EXECUTE r201_predac2
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('predac2:',SQLCA.sqlcode,1)
          END IF
    END FOR
 
  LET l_sql=" SELECT item,tlf01,mm,sum(qty),sum(amt),sum(cost),",
            " sum(qty1),sum(amt1),sum(cost1),sum(dae_amt),sum(dac_amt)",
            " FROM ",g_tname1 CLIPPED,
            " GROUP BY item,tlf01,mm"
	     PREPARE r201_union FROM l_sql
	     IF SQLCA.sqlcode != 0 THEN
                EXECUTE del_dpm
		CALL cl_err('prepare r201_union:',SQLCA.sqlcode,1)
                RETURN
	     END IF
  DECLARE union_cur CURSOR FOR r201_union
  FOREACH union_cur INTO l_dpm.*
    IF l_dpm.qty IS NULL THEN LET l_dpm.qty=0 END IF
    IF l_dpm.amt IS NULL THEN LET l_dpm.amt=0 END IF
    IF l_dpm.cost IS NULL THEN LET l_dpm.cost=0 END IF
    IF l_dpm.qty1 IS NULL THEN LET l_dpm.qty1=0 END IF
    IF l_dpm.amt1 IS NULL THEN LET l_dpm.amt1=0 END IF
    IF l_dpm.cost1 IS NULL THEN LET l_dpm.cost1=0 END IF
    IF l_dpm.dac_amt IS NULL THEN LET l_dpm.dac_amt=0 END IF
    IF l_dpm.dae_amt IS NULL THEN LET l_dpm.dae_amt=0 END IF
    LET l_dpm_temp = -l_dpm.amt+l_dpm.dac_amt-l_dpm.dae_amt-l_dpm.amt1   #MOD-C30854 add
   #成本根據ccc_file為主不需再INSERT   #MOD-710149 add
    IF tm.group=2 THEN #銷售           #MOD-710149 add
       IF l_dpm.mm=1 THEN
          LET l_sql=" INSERT INTO ",g_tname,
                  " VALUES (  '",l_dpm.item  CLIPPED,"'",
                              ",'",l_dpm.tlf01 CLIPPED,"'",
                              ",''",              #No.MOD-9A0050 add
                              ",",-l_dpm.qty-l_dpm.qty1,                               #No:MOD-B60120 modify
                             #",",-l_dpm.amt+l_dpm.dac_amt-l_dpm.dae_amt-l_dpm.amt1,   #No:MOD-B60120 modify #MOD-C30854 mark
                              ",",l_dpm_temp,                                          #MOD-C30854 add
                              ",",-l_dpm.cost,
                              ",0,0,0)"
       ELSE
          LET l_sql=" INSERT INTO ",g_tname,
                  " VALUES (  '",l_dpm.item  CLIPPED,"'",
                              ",'",l_dpm.tlf01 CLIPPED,"'",
                              ",''",              #No.MOD-9A0050 add
                              ",0,0,0",
                              ",",-l_dpm.qty-l_dpm.qty1,                              #No:MOD-B60120 modify
                             #",",-l_dpm.amt+l_dpm.dac_amt-l_dpm.dae_amt-l_dpm.amt1,  #No:MOD-B60120 modify #MOD-C30854 mark
                              ",",l_dpm_temp,                                         #MOD-C30854 add
                              ",",-l_dpm.cost,")"
       END IF
   #END IF        #MOD-710149 mod   #No.MOD-9A0050 mark
       PREPARE pre_sql1 FROM l_sql
       EXECUTE pre_sql1
       IF SQLCA.sqlcode != 0 THEN
          EXECUTE del_dpm
          CALL cl_err('pre_sql1:',SQLCA.sqlcode,1)
          RETURN
       END IF
    END IF           #No.MOD-9A0050 add
  END FOREACH
 
  IF tm.sum_code matches '[Yy]' THEN
     LET l_sql=" SELECT sum(qty),sum(amt),sum(cost),",
            "sum(qty1),sum(amt1),sum(cost1),sum(dae_amt),sum(dac_amt)",
            "  FROM ",g_tname1 CLIPPED
	     PREPARE r201_sum FROM l_sql
             DECLARE sum_cursor CURSOR FOR r201_sum
             OPEN sum_cursor
             FETCH sum_cursor INTO g_sum.*
             IF g_sum.qty=0 THEN LET g_sum.qty=0 END IF
             IF g_sum.amt=0 THEN LET g_sum.amt=0 END IF
             IF g_sum.cost=0 THEN LET g_sum.cost=0 END IF
             IF g_sum.qty1=0 THEN LET g_sum.qty1=0 END IF
             IF g_sum.amt1=0 THEN LET g_sum.amt1=0 END IF
             IF g_sum.cost1=0 THEN LET g_sum.cost1=0 END IF
             IF g_sum.dae_amt=0 THEN LET g_sum.dae_amt=0 END IF
             IF g_sum.dac_amt=0 THEN LET g_sum.dac_amt=0 END IF
  END IF
  EXECUTE del_dpm
END FUNCTION
 
FUNCTION change_string(old_string, old_sub, new_sub)
DEFINE query_text   LIKE type_file.chr1000        #No.FUN-680122char(300)
DEFINE AA           LIKE type_file.chr1           #No.FUN-680122char(01)
 
DEFINE old_string   LIKE type_file.chr1000,       #No.FUN-680122char(300)
       xxx_string   LIKE type_file.chr1000,       #No.FUN-680122char(300)
       old_sub      LIKE type_file.chr1000,       #No.FUN-680122char(128)
       new_sub      LIKE type_file.chr1000,       #No.FUN-680122char(128)
       first_byte   LIKE type_file.chr1,           #No.FUN-680122char(01)
       nowx_byte    LIKE type_file.chr1,           #No.FUN-680122char(01)
       next_byte    LIKE type_file.chr1,           #No.FUN-680122char(01)
       this_byte    LIKE type_file.chr1,           #No.FUN-680122char(01)
       length1, length2, length3   LIKE type_file.num5,           #No.FUN-680122smallint
                     pu1, pu2      LIKE type_file.num5,           #No.FUN-680122smallint
       ii, jj, kk, ff, tt          LIKE type_file.num5            #No.FUN-680122smallint
 
LET length1 = length(old_string)
LET length2 = length(old_sub)
LET length3 = length(new_sub)
LET first_byte = old_sub[1,1]
LET xxx_string = " "
let pu1 = 0
 
FOR ii = 1 TO length1
    LET this_byte = old_string[ii, ii]
    LET nowx_byte = this_byte
    IF this_byte = first_byte THEN
        FOR jj = 2 TO length2
            let this_byte = old_string[ ii + jj - 1, ii + jj - 1]
            let next_byte = old_sub[ jj, jj]
            IF this_byte <> next_byte THEN
                let jj = 29999
                exit for
            END IF
        END FOR
        IF jj < 29999 THEN
           let pu1 = pu1 + 1
           let pu2 = pu1 + length3 - 1
           LET xxx_string[pu1, pu2] = new_sub CLIPPED
           LET ii = ii + length2 - 1
           LET pu1 = pu2
        ELSE
            let pu1 = pu1 + 1
            LET xxx_string[pu1,pu1] = nowx_byte
        END IF
    ELSE
        LET pu1 = pu1 + 1
        LET xxx_string[pu1,pu1] = nowx_byte
    END IF
end for
let query_text = xxx_string
#DISPLAY QUERY_TEXT CLIPPED AT 10,1
            LET INT_FLAG = 0  ######add for prompt bug
#    PROMPT " " FOR CHAR AA
RETURN query_text
end function
 
FUNCTION r201_chkplant(l_plant)
  DEFINE l_plant     LIKE azp_file.azp01
 
  SELECT azp01 FROM azp_file
   WHERE azp01 = l_plant
  IF SQLCA.SQLCODE THEN
     LET g_errno='aom-300'
     RETURN 0
  ELSE
     RETURN 1
  END IF
END FUNCTION
#No.FUN-9C0073 ----By chenls 10/01/26
#FUN-A70084--add--str--
FUNCTION r201_set_visible()
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_azw05  LIKE azw_file.azw05

  SELECT azw05 INTO l_azw05 FROM azw_file WHERE azw01 = g_plant
  SELECT count(*) INTO l_cnt FROM azw_file
   WHERE azw05 = l_azw05

  IF l_cnt > 1 THEN
     CALL cl_set_comp_visible("group04",FALSE)
  END IF
  RETURN l_cnt
END FUNCTION

FUNCTION r201_chklegal(l_legal,n)
DEFINE l_legal  LIKE azw_file.azw02
DEFINE l_idx,n  LIKE type_file.num5

   FOR l_idx = 1 TO n
       IF m_legal[l_idx]! = l_legal THEN
          LET g_errno = 'axc-600'
          RETURN 0
       END IF
   END FOR
   RETURN 1
END FUNCTION
#FUN-A70084--add--end
