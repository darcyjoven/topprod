# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcr120.4gl
# Descriptions...: 銷售毛利分析表
# Date & Author..: 95/01/23
# Modify.........: No:8535 03/10/21 Melody oracle 版run出來銷售成本均無資料(台精)
# Modify ........: No:8741 03/11/25 By Melody 修改PRINT段
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.MOD-4B0100 04/11/12 By ching 銷售額應抓未稅
# Modify.........: No.FUN-4B0064 04/11/25 By Carol 加入"匯率計算"功能
# Modify.........: No.MOD-530122 05/03/16 By Carol QBE欄位順序調整
# Modify.........: No.MOD-530181 05/03/21 By kim Define金額單價位數改為DEC(20,6)
# Modify.........: No.FUN-560011 05/06/07 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗
# Modify.........: No.FUN-570190 05/08/05 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.MOD-580106 05/08/29 by rosayu 將QBE料件編號與工廠選擇可以開窗查詢
# Modify.........: No.FUN-590110 05/09/23 by wujie  報表轉xml
# Modify.........: NO.FUN-5B0015 05/11/02 BY yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: NO.TQC-5B0019 05/11/08 By Sarah 將[1,xx]清除後加CLIPPED
# Modify.........: No.FUN-5C0002 05/12/05 By Sarah 補印ima021
# Modify.........: No.FUN-5B0123 05/12/08 By Sarah 應排除出至境外倉部份(add oga00<>'3')
# Modify.........: No.FUN-610079 06/01/20 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.TQC-610051 06/02/22 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-670039 06/07/12 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-660126 06/07/24 By rainy remove s_chknplt
# Modify.........: No.FUN-670098 06/07/24 By rainy 排除不納入成本計算倉庫
# Modify.........: No.FUN-680122 06/09/07 By zdyllq 類型轉換
# Modify.........: No.FUN-660073 06/09/13 By Nicola 訂單樣品修改
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-6A0078 06/11/09 By ice 修正報表格式錯誤;修正FUN-6A0146/FUN-680122改錯部分
# Modify.........: No.CHI-690007 06/12/08 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.CHI-6A0063 06/12/14 By rainy  銷退資料屬「5、折讓」的部份，銷退金額改抓ohb1
# Modify.........: No.MOD-710129 07/01/23 By jamie ima131變數宣告請調整為LIKE,目前ima131的長度為10碼.
#                                                  MISC的判斷需取前四碼
# Modify.........: No.MOD-710154 07/01/25 By rainy 內部銷貨obg14t->obb14
# Modify.........: No.MOD-710197 07/02/01 By jamie 銷退資料有關銷退金額的計算,建議直接取ohb14,因為ohb16已經乘以轉換率,會造成金額錯誤。
# Modify.........: No.MOD-720042 07/03/01 By TSD.hoho 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/04/02 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No:tina 07/11/22 By Carol 排行計算邏輯調整
# Modify.........: No.MOD-7B0233 07/11/29 By Pengu 列印自用銷貨時串tlf的條件錯誤
# Modify.........: No.FUN-7B0044 07/12/19 By Sarah 1.移除Input中的"應加減折讓/雜項發票/內部自用"
#                                                  2.增加Input選項，資料內容：1.關係人、2.非關係人、3.全部
# Modify.........: No.FUN-7C0101 08/01/24 By Zhangyajun 成本改善增加成本計算類型(type1)
# Modify.........: No.FUN-830002 08/03/03 By dxfwo 成本改善的index之前改過后出現報表打印不出來的問題修改
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.MOD-860264 08/07/16 By Pengu 已轉CR的程式裡不應有cl_outnam()去取程式名稱
# Modify.........: No.FUN-870151 08/08/15 By xiaofeizhu  匯率調整為用azi07取位
# Modify.........: No.MOD-890146 08/09/23 By Pengu 在計算銷貨成本時先做取位後在做加總
# Modify.........: No.MOD-840687 08/12/23 By Pengu 單價金額未考慮小數位數
# Modify.........: No.FUN-940102 09/04/20 By dxfwo  新增使用者對營運中心的權限管控
# Modify.........: No.MOD-950210 09/05/19 By Pengu “寄銷出貨”不應納入 “銷貨收入”
# Modify.........: No.MOD-960309 09/06/25 By mike 將tmp_sql變數的資料型態改成SRTING
# Modify.........: No.TQC-970305 09/07/28 By liuxqa create table 改為CREATE TEMP TABLE.
# Modify.........: No.MOD-980129 09/08/17 By Carrier 銷售量與銷退量都去掉換貨出貨的情況
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-9C0059 09/12/30 By kim GP5.1成本改善問題修改
# Modify.........: No.FUN-9C0073 10/01/12 By chenls 程序精簡
# Modify.........: No.FUN-A10098 10/01/21 By wuxj  GP5.2 跨DB報表財務類   修改
# Modify.........: No.TQC-A40130 10/04/28 By Carrier 加oha09 not matches..此项不知道是哪张单,好多单在一行中
#                                                    追单MOD-980190/MOD-980240/MOD-990139
# Modify.........: No.FUN-A70084 10/07/23 By lutingting GP5.2報表修改
# Modify.........: No:MOD-A70147 10/07/26 By Sarah 1.排序增加成本分群
#                                                  2.報表增加以分群資料做群組
#                                                  3.調整排序,依照sr.order,sr.order_num,sr,item,sr.ima01
# Modify.........: No.FUN-A80109 10/08/19 By lutingting 修正FUN-A10098問題 cl_get_target_table()中應該傳PLANT 
# Modify.........: No:MOD-A90115 10/09/17 By Summer 當tm.data='3'或'4'時,抓取azf03後將值改為給oba02
# Modify.........: No:MOD-B20053 11/02/14 By FUNCTION sort()UPDATE語法有誤 
# Modify.........: No:MOD-B70078 11/07/08 By JoHung 修改tmp_sql，SUM(ohb14*oha24)->SUM(ohb14)*oha24
# Modify.........: No:MOD-B90101 11/09/16 By johung 加入借貨償價
# Modify.........: No:MOD-BA0082 11/10/12 By johung 修正MOD-B70078
# Modify.........: No.MOD-BC0287 11/12/29 By ck2yuan 將r120_curs4x、r120_curs4x_2外圍的SELECT拿掉，改用FOREACH的方式加總
# Modify.........: No.TQC-BB0182 12/01/11 By pauline 取消過濾plant條
# Modify.........: No.MOD-C30868 12/03/27 By ck2yuan 避免sr.item、sr.order1為空時,造成排序失敗 故將CLIPPED拿掉
# Modify.........: No:MOD-C60149 12/06/18 By ck2yuan 控卡匯率不可為小於等於0
# Modify.........: No:MOD-C70090 12/07/09 By ck2yuan 給定變數初始值,避免變數為null而計算錯誤
# Modify.........: No:CHI-C30012 12/07/27 By bart 金額取位改抓ccz26
# Modify.........: No:CHI-A70023 13/01/30 By Alberti 調整成品替代的銷貨收入

DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE tm     RECORD
               wc       STRING,                #FUN-7B0044 add
               order    LIKE type_file.num5,   #排名方式    #No.FUN-680122 SMALLINT,
               dec      LIKE type_file.chr1,   #No.FUN-680122 VARCHAR(1),  #金額單位(1)元(2)千(3)萬
               num      LIKE type_file.num5,   #No.FUN-680122 SMALLINT,
               azk01    LIKE azk_file.azk01,
               azk04    LIKE azk_file.azk04,
               data     LIKE type_file.num5,   #資料選擇    #No.FUN-680122 SMALLINT,
               plant_1,plant_2,plant_3,plant_4,plant_5 LIKE azp_file.azp01,  #No.FUN-680122 VARCHAR(10)
               plant_6,plant_7,plant_8                 LIKE azp_file.azp01,  #No.FUN-680122 VARCHAR(10)
               type     LIKE type_file.chr1,   #資料內容(1)關係人(2)非關係人(3)全部  #FUN-7B0044 add
               type1    LIKE type_file.chr1,   #No.FUN-7C0101 VARCHAR(1)
               detail   LIKE type_file.chr1,   # Prog. Version..: '5.30.06-13.03.12(01),  #No.TQC-6A0078
               azh01    LIKE azh_file.azh01,
               azh02    LIKE azh_file.azh02,
               yy1_b,mm1_b,mm1_e  LIKE type_file.num5,      #No.FUN-680122 SMALLINT,
               more     LIKE type_file.chr1    #No.FUN-680122 VARCHAR(01)
              END RECORD
DEFINE g_bdate,g_edate  LIKE type_file.dat     #No.FUN-680122 DATE
DEFINE g_dash3    LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(400)
DEFINE g_bookno   LIKE aaa_file.aaa01          #No.FUN-670039
DEFINE g_base     LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE #multi fac
       g_delsql   LIKE type_file.chr1000,      #execute sys_cmd  #No.FUN-680122 VARCHAR(50)
       g_tname    LIKE type_file.chr20,        #No.FUN-680122 VARCHAR(20),               #tmpfile name
       g_tname1   LIKE type_file.chr20,        #No.FUN-680122 VARCHAR(20),               #tmpfile name
       g_delsql1  LIKE type_file.chr1000,      #execute sys_cmd  #No.FUN-680122 VARCHAR(50)
       g_idx,g_k  LIKE type_file.num10,        #No.FUN-680122 INTEGER,
       g_ary      DYNAMIC ARRAY OF RECORD      #被選擇之工廠
                   plant    LIKE azp_file.azp01,     #No.FUN-680122 VARCHAR(10)
                   dbs_new  LIKE type_file.chr21     #No.FUN-680122 VARCHAR(21)
                  END RECORD,
       g_tmp      DYNAMIC ARRAY OF RECORD      #被選擇之工廠
                   p        LIKE azp_file.azp01,     #No.FUN-680122 VARCHAR(10)
                   d        LIKE type_file.chr21     #No.FUN-680122 VARCHAR(21)
                  END RECORD,
       g_sum      RECORD
                   qty      LIKE ogb_file.ogb16,  #No.FUN-680122 DEC(15,3),  #數量(內銷) #TQC-840066
                   amt      LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),  #金額(內銷)
                   cost     LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),  #成本(內銷)
                   qty1     LIKE ogb_file.ogb16,     #No.FUN-680122 DEC(15,3),  #數量(內退) #TQC-840066
                   amt1     LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),  #金額(內退)
                   cost1    LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),  #成本(內退)
                   dae_amt  LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6), #折讓
                   dac_amt  LIKE type_file.num20_6   #No.FUN-680122 DEC(20,6)  #雜項發票
                  END RECORD
DEFINE g_i        LIKE type_file.num5     #count/index for any purpose  #No.FUN-680122 SMALLINT
DEFINE l_table    STRING   #Add MOD-720042 By TSD.hoho CR11 add
DEFINE g_sql      STRING   #Add MOD-720042 By TSD.hoho CR11 add
DEFINE g_str      STRING   #Add MOD-720042 By TSD.hoho CR11 add
DEFINE l_ctype_str STRING  #CHI-9C0059
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
   LET g_sql = "item.type_file.chr20,     ima01.type_file.chr1000,",
               "qty.ogb_file.ogb16,       amt.type_file.num20_6,",
               "cost.type_file.num20_6,   rq_qty.ogb_file.ogb16,",
               "rq_amt.type_file.num20_6, rq_cost.type_file.num20_6,",
               "amt_n_s.type_file.num20_6,bonus_s.type_file.num20_6,",
               "amt_n.type_file.num20_6,  qty_n.ogb_file.ogb16,",
               "cost_n.type_file.num20_6, unt.type_file.num20_6,",
               "uus.type_file.num20_6,    unt1.type_file.num20_6,",
               "uus1.type_file.num20_6,   bonus.type_file.num20_6,",
               "bonus_r.type_file.num20_6,order_sys.type_file.chr30,",
               "order_num.ogb_file.ogb16, oba02.oba_file.oba02,",
               "azf03.azf_file.azf03,     ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,   s_qty.ogb_file.ogb16,",  #TQC-840066
               "s_amt.type_file.num20_6,  s_cost.type_file.num20_6,",
               "s_qty1.ogb_file.ogb16,    s_amt1.type_file.num20_6,",
               "s_cost1.type_file.num20_6,s_dae_a.type_file.num20_6,",
               "s_dac_a.type_file.num20_6,g_azi03.azi_file.azi03,",
               "g_azi04.azi_file.azi04,   g_azi05.azi_file.azi05,",
               "t_azi03.azi_file.azi03,   t_azi04.azi_file.azi04,",
               "t_azi05.azi_file.azi05,   ccz27.ccz_file.ccz27,",
               "t_azi07.azi_file.azi07,   order1.type_file.chr30"  #No:FUN-870151  #MOD-A70147 add order1
   LET l_table = cl_prt_temptable('axcr120',g_sql) CLIPPED  #產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                       " ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                       " ?,?)"   #No:FUN-870151  #No:MOD-840687 modify  #MOD-A70147 add ?
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
   LET tm.plant_7 = g_ary[7].plant
   LET tm.plant_8 = g_ary[8].plant
   LET g_pdate    = ARG_VAL(1)
   LET g_towhom   = ARG_VAL(2)
   LET g_rlang    = ARG_VAL(3)
   LET g_bgjob    = ARG_VAL(4)
   LET g_prtway   = ARG_VAL(5)
   LET g_copies   = ARG_VAL(6)
   LET tm.wc      = ARG_VAL(7)
   LET tm.order   = ARG_VAL(8)
   LET tm.dec     = ARG_VAL(9)
   LET tm.num     = ARG_VAL(10)
   LET tm.azk01   = ARG_VAL(11)
   LET tm.azk04   = ARG_VAL(12)
   LET tm.data    = ARG_VAL(13)
   LET tm.plant_1 = ARG_VAL(14)
   LET tm.plant_2 = ARG_VAL(15)
   LET tm.plant_3 = ARG_VAL(16)
   LET tm.plant_4 = ARG_VAL(17)
   LET tm.plant_5 = ARG_VAL(18)
   LET tm.plant_6 = ARG_VAL(19)
   LET tm.plant_7 = ARG_VAL(20)
   LET tm.plant_8 = ARG_VAL(21)
   LET tm.type    = ARG_VAL(22)   #FUN-7B0044 add
   LET tm.detail  = ARG_VAL(23)
   LET tm.azh01   = ARG_VAL(24)
   LET tm.azh02   = ARG_VAL(25)
   LET tm.yy1_b   = ARG_VAL(26)
   LET tm.mm1_b   = ARG_VAL(27)
   LET tm.mm1_e   = ARG_VAL(28)
   LET g_rep_user = ARG_VAL(29)
   LET g_rep_clas = ARG_VAL(30)
   LET g_template = ARG_VAL(31)
   LET g_bookno   = ARG_VAL(32)
   LET tm.type1   = ARG_VAL(33)   #No.FUN-7C0101 add
   LET g_rpt_name = ARG_VAL(34)  #No.FUN-7C0078
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r120_tm(0,0)
   ELSE
      CALL r120()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo
END MAIN
 
FUNCTION r120_tm(p_row,p_col)
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01     #No.FUN-580031
   DEFINE p_row,p_col   LIKE type_file.num5,    #No.FUN-680122 SMALLINT
          l_date        LIKE type_file.dat,     #No.FUN-680122 DATE
          l_cmd         LIKE type_file.chr1000  #No.FUN-680122 VARCHAR(400)
   DEFINE li_result     LIKE type_file.num5     #No.FUN-940102
   DEFINE l_cnt         LIKE type_file.num5     #FUN-A70084
 
   LET p_row = 2 LET p_col = 20
   CALL s_dsmark(g_bookno)
 
   OPEN WINDOW r120_w AT p_row,p_col WITH FORM "axc/42f/axcr120"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   CALL r120_set_entry() RETURNING l_cnt   #FUN-A70084

   INITIALIZE tm.* TO NULL
   LET tm.data   = 2
   LET tm.order  = 1
   LET tm.num    = 0
   LET tm.type   ='3'   #FUN-7B0044 add
   LET tm.type1  ='1'   #No.FUN-7C0101 add
   LET tm.detail ='N'
   LET tm.more  = 'N'
   LET tm.dec   = '1'
   LET tm.yy1_b = g_ccz.ccz01
   LET tm.mm1_b = g_ccz.ccz02
   LET tm.mm1_e = g_ccz.ccz02
   LET tm.azk01 = g_aza.aza17     #No.B509 010510 by linda mod
   LET tm.azk04 = 1
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
   LET g_base   = 1
 
   WHILE TRUE
      LET tm.wc=NULL
      CONSTRUCT BY NAME tm.wc ON ima01,ima11,ima131,ima12
      ##
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
         ON ACTION controlp
            IF INFIELD(ima01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima01
               NEXT FIELD ima01
            END IF
 
         ON ACTION locale
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            LET g_action_choice = "locale"
            EXIT CONSTRUCT
 
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
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r855_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo
         EXIT PROGRAM
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.order,tm.dec,tm.num,tm.azk01,tm.azk04,tm.data,
                    tm.plant_1,tm.plant_2,tm.plant_3,tm.plant_4,
                    tm.plant_5,tm.plant_6,tm.plant_7,tm.plant_8,
                    tm.type,tm.type1,tm.detail,tm.azh01,       #FUN-7B0044 add tm.type,del tm.sum_code   #No.FUN-7C0101 add tm.type1
                    tm.yy1_b,tm.mm1_b,tm.mm1_e,tm.more
         WITHOUT DEFAULTS
 
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
         AFTER FIELD order
            IF cl_null(tm.order) OR tm.order NOT MATCHES '[012345]' THEN   #MOD-A70147 add 5
               NEXT FIELD order
            END IF
 
         AFTER FIELD dec
            IF tm.dec NOT MATCHES '[123]' THEN NEXT FIELD dec END IF
            CASE tm.dec WHEN 1 LET g_base = 1
                        WHEN 2 LET g_base = 1000
                        WHEN 3 LET g_base = 10000
                        OTHERWISE NEXT FIELD dec
            END CASE
 
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
        #MOD-C60149 str add-----
         AFTER FIELD azk04
            IF tm.azk04 <= 0 THEN
               LET tm.azk04 = NULL
               CALL cl_err('','axm-987',0)
               NEXT FIELD azk04
            END IF
        #MOD-C60149 end add-----

         AFTER FIELD data
            IF cl_null(tm.data) OR tm.data NOT MATCHES '[234]' THEN
               NEXT FIELD data
            END IF
 
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
               NEXT FIELD sum_code
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
                  IF NOT r120_chkplant(tm.plant_1) THEN
                    CALL cl_err(tm.plant_1,g_errno,0)
                    NEXT FIELD plant_1
                  END IF
                  LET g_ary[1].plant = tm.plant_1
                  LET g_ary[1].dbs_new = g_dbs_new
                  SELECT azw02 INTO m_legal[1] FROM azw_file WHERE azw01 = tm.plant_1   #FUN-A70084
               CALL s_chk_demo(g_user,tm.plant_1) RETURNING li_result
                IF not li_result THEN
                 NEXT FIELD plant_1
                END IF
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
                  IF NOT r120_chkplant(tm.plant_2) THEN
                    CALL cl_err(tm.plant_2,g_errno,0)
                    NEXT FIELD plant_2
                  END IF
                  LET g_ary[2].plant = tm.plant_2
                  LET g_ary[2].dbs_new = g_dbs_new
                  SELECT azw02 INTO m_legal[2] FROM azw_file WHERE azw01 = tm.plant_2   #FUN-A70084
               CALL s_chk_demo(g_user,tm.plant_2) RETURNING li_result
                IF not li_result THEN
                 NEXT FIELD plant_2
                END IF
               ELSE           # 輸入之工廠編號為' '或NULL
                  LET g_ary[2].plant = tm.plant_2
               END IF
            END IF
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_2) THEN
                IF NOT r120_chklegal(m_legal[2],1) THEN
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
                  IF NOT r120_chkplant(tm.plant_3) THEN
                    CALL cl_err(tm.plant_3,g_errno,0)
                    NEXT FIELD plant_3
                  END IF
                  LET g_ary[3].plant = tm.plant_3
                  LET g_ary[3].dbs_new = g_dbs_new
                  SELECT azw02 INTO m_legal[3] FROM azw_file WHERE azw01 = tm.plant_3   #FUN-A70084
               CALL s_chk_demo(g_user,tm.plant_3) RETURNING li_result
                IF not li_result THEN
                 NEXT FIELD plant_3
                END IF
               ELSE           # 輸入之工廠編號為' '或NULL
                  LET g_ary[3].plant = tm.plant_3
               END IF
            END IF
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_3) THEN
                IF NOT r120_chklegal(m_legal[3],2) THEN
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
                  IF NOT r120_chkplant(tm.plant_4) THEN
                    CALL cl_err(tm.plant_4,g_errno,0)
                    NEXT FIELD plant_4
                  END IF
                  LET g_ary[4].plant = tm.plant_4
                  LET g_ary[4].dbs_new = g_dbs_new
                  SELECT azw02 INTO m_legal[4] FROM azw_file WHERE azw01 = tm.plant_4  #FUN-A70084
               CALL s_chk_demo(g_user,tm.plant_4) RETURNING li_result
                IF not li_result THEN
                 NEXT FIELD plant_4
                END IF
               ELSE           # 輸入之工廠編號為' '或NULL
                  LET g_ary[4].plant = tm.plant_4
               END IF
            END IF
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_4) THEN
                IF NOT r120_chklegal(m_legal[4],3) THEN
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
                  IF NOT r120_chkplant(tm.plant_5) THEN
                    CALL cl_err(tm.plant_5,g_errno,0)
                    NEXT FIELD plant_5
                  END IF
                  LET g_ary[5].plant = tm.plant_5
                  LET g_ary[5].dbs_new = g_dbs_new
                  SELECT azw02 INTO m_legal[5] FROM azw_file WHERE azw01 = tm.plant_5  #FUN-A70084
               CALL s_chk_demo(g_user,tm.plant_5) RETURNING li_result
                IF not li_result THEN
                 NEXT FIELD plant_5
                END IF
               ELSE           # 輸入之工廠編號為' '或NULL
                  LET g_ary[5].plant = tm.plant_5
               END IF
            END IF
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_5) THEN
                IF NOT r120_chklegal(m_legal[5],4) THEN
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
               LET m_legal[6] = g_legal  #FUN-A70084
            ELSE
               IF NOT cl_null(tm.plant_6) THEN
                              # 檢查工廠並將新的資料庫放在g_dbs_new
                  IF NOT r120_chkplant(tm.plant_6) THEN
                    CALL cl_err(tm.plant_6,g_errno,0)
                    NEXT FIELD plant_6
                  END IF
                  LET g_ary[6].plant = tm.plant_6
                  LET g_ary[6].dbs_new = g_dbs_new
                  SELECT azw02 INTO m_legal[6] FROM azw_file WHERE azw01 = tm.plant_6   #FUN-A70084
               CALL s_chk_demo(g_user,tm.plant_6) RETURNING li_result
                IF not li_result THEN
                 NEXT FIELD plant_6
                END IF
               ELSE           # 輸入之工廠編號為' '或NULL
                  LET g_ary[6].plant = tm.plant_6
               END IF
            END IF
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_6) THEN
                IF NOT r120_chklegal(m_legal[6],5) THEN
                   CALL cl_err(tm.plant_6,g_errno,0)
                   NEXT FIELD plant_6
                END IF
             END IF
            #FUN-A70084--add--end

 
         AFTER FIELD plant_7
            LET tm.plant_7 = duplicate(tm.plant_7,6)  # 不使工廠編號重覆
            LET g_plant_new = tm.plant_7
            IF tm.plant_7 = g_plant  THEN
               LET g_dbs_new=' '
               LET g_ary[7].plant = tm.plant_7
               LET g_ary[7].dbs_new = g_dbs_new
               LET m_legal[7] = g_legal  #FUN-A70084
            ELSE
               IF NOT cl_null(tm.plant_7) THEN
                              # 檢查工廠並將新的資料庫放在g_dbs_new
                  IF NOT r120_chkplant(tm.plant_7) THEN
                    CALL cl_err(tm.plant_7,g_errno,0)
                    NEXT FIELD plant_7
                  END IF
                  LET g_ary[7].plant = tm.plant_7
                  LET g_ary[7].dbs_new = g_dbs_new
                  SELECT azw02 INTO m_legal[7] FROM azw_file WHERE azw01 = tm.plant_7  #FUN-A70084
               CALL s_chk_demo(g_user,tm.plant_7) RETURNING li_result
                IF not li_result THEN
                 NEXT FIELD plant_7
                END IF
               ELSE           # 輸入之工廠編號為' '或NULL
                  LET g_ary[7].plant = tm.plant_7
               END IF
            END IF
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_7) THEN
                IF NOT r120_chklegal(m_legal[7],6) THEN
                   CALL cl_err(tm.plant_7,g_errno,0)
                   NEXT FIELD plant_7
                END IF
             END IF
             #FUN-A70084--add--end

 
         AFTER FIELD plant_8
            LET tm.plant_8 = duplicate(tm.plant_8,7)  # 不使工廠編號重覆
            LET g_plant_new = tm.plant_8
            IF tm.plant_8 = g_plant  THEN
               LET g_dbs_new=' '
               LET g_ary[8].plant = tm.plant_8
               LET g_ary[8].dbs_new = g_dbs_new
               LET m_legal[8] = g_legal  #FUN-A70084
            ELSE
               IF NOT cl_null(tm.plant_8) THEN
                              # 檢查工廠並將新的資料庫放在g_dbs_new
                  IF NOT r120_chkplant(tm.plant_8) THEN
                    CALL cl_err(tm.plant_8,g_errno,0)
                    NEXT FIELD plant_8
                  END IF
                  LET g_ary[8].plant = tm.plant_8
                  LET g_ary[8].dbs_new = g_dbs_new
                  SELECT azw02 INTO m_legal[8] FROM azw_file WHERE azw01 = tm.plant_8   #FUN-A70084
               CALL s_chk_demo(g_user,tm.plant_8) RETURNING li_result
                IF not li_result THEN
                 NEXT FIELD plant_8
                END IF
               ELSE           # 輸入之工廠編號為' '或NULL
                  LET g_ary[8].plant = tm.plant_8
               END IF
            END IF
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_8) THEN
                IF NOT r120_chklegal(m_legal[8],7) THEN
                   CALL cl_err(tm.plant_8,g_errno,0)
                   NEXT FIELD plant_8
                END IF
             END IF
            #FUN-A70084--add--end
 
         AFTER FIELD type
            IF cl_null(tm.type) OR tm.type NOT MATCHES '[123]' THEN
               NEXT FIELD type
            END IF
 
        AFTER FIELD type1
           IF cl_null(tm.type1) OR tm.type1 NOT MATCHES '[12345]' THEN
              NEXT FIELD type1
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
 
         AFTER FIELD yy1_b
            IF cl_null(tm.yy1_b) THEN NEXT FIELD yy1_b END IF
 
         AFTER FIELD mm1_b
            IF cl_null(tm.mm1_b) OR tm.mm1_b >12 OR tm.mm1_b <1 THEN
               NEXT FIELD mm1_b
            END IF
 
         AFTER FIELD mm1_e
            IF cl_null(tm.mm1_e) OR tm.mm1_e >12 OR tm.mm1_e <1 OR
               tm.mm1_e < tm.mm1_b THEN
               NEXT FIELD mm1_e
            END IF
 
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
                    LET g_qryparam.form ="q_zxy"    #No.FUN-940102
                    LET g_qryparam.arg1 = g_user    #No.FUN-940102
                    LET g_qryparam.default1 = tm.plant_1
                    CALL cl_create_qry() RETURNING tm.plant_1
                    DISPLAY BY NAME tm.plant_1
                    NEXT FIELD plant_1
               WHEN INFIELD(plant_2)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_zxy"    #No.FUN-940102
                    LET g_qryparam.arg1 = g_user    #No.FUN-940102
                    LET g_qryparam.default1 = tm.plant_2
                    CALL cl_create_qry() RETURNING tm.plant_2
                    DISPLAY BY NAME tm.plant_2
                    NEXT FIELD plant_2
               WHEN INFIELD(plant_3)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_zxy"    #No.FUN-940102
                    LET g_qryparam.arg1 = g_user    #No.FUN-940102
                    LET g_qryparam.default1 = tm.plant_3
                    CALL cl_create_qry() RETURNING tm.plant_3
                    DISPLAY BY NAME tm.plant_3
                    NEXT FIELD plant_3
               WHEN INFIELD(plant_4)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_zxy"    #No.FUN-940102
                    LET g_qryparam.arg1 = g_user    #No.FUN-940102
                    LET g_qryparam.default1 = tm.plant_4
                    CALL cl_create_qry() RETURNING tm.plant_4
                    DISPLAY BY NAME tm.plant_4
                    NEXT FIELD plant_4
               WHEN INFIELD(plant_5)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_zxy"    #No.FUN-940102
                    LET g_qryparam.arg1 = g_user    #No.FUN-940102
                    LET g_qryparam.default1 = tm.plant_5
                    CALL cl_create_qry() RETURNING tm.plant_5
                    DISPLAY BY NAME tm.plant_5
                    NEXT FIELD plant_5
               WHEN INFIELD(plant_6)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_zxy"    #No.FUN-940102
                    LET g_qryparam.arg1 = g_user    #No.FUN-940102
                    LET g_qryparam.default1 = tm.plant_6
                    CALL cl_create_qry() RETURNING tm.plant_6
                    DISPLAY BY NAME tm.plant_6
                    NEXT FIELD plant_6
               WHEN INFIELD(plant_7)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_zxy"    #No.FUN-940102
                    LET g_qryparam.arg1 = g_user    #No.FUN-940102
                    LET g_qryparam.default1 = tm.plant_7
                    CALL cl_create_qry() RETURNING tm.plant_7
                    DISPLAY BY NAME tm.plant_7
                    NEXT FIELD plant_7
               WHEN INFIELD(plant_8)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_zxy"    #No.FUN-940102
                    LET g_qryparam.arg1 = g_user    #No.FUN-940102
                    LET g_qryparam.default1 = tm.plant_8
                    CALL cl_create_qry() RETURNING tm.plant_8
                    DISPLAY BY NAME tm.plant_8
                    NEXT FIELD plant_8
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
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF
            IF cl_null(tm.plant_1) AND cl_null(tm.plant_2) AND
               cl_null(tm.plant_3) AND cl_null(tm.plant_4) AND
               cl_null(tm.plant_5) AND cl_null(tm.plant_6) AND
               cl_null(tm.plant_7) AND cl_null(tm.plant_8) AND l_cnt < =1 THEN   #FUN-A70084 add l_cnt<=1
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
            FOR g_idx = 1  TO  8
               IF cl_null(g_ary[g_idx].plant) THEN
                  CONTINUE FOR
               END IF
               LET g_k=g_k+1
               LET g_tmp[g_k].p=g_ary[g_idx].plant
               LET g_tmp[g_k].d=g_ary[g_idx].dbs_new
            END FOR
            FOR g_idx = 1  TO 8
               IF g_idx > g_k THEN
                  LET g_ary[g_idx].plant=NULL
                  LET g_ary[g_idx].dbs_new=NULL
               ELSE
                  LET g_ary[g_idx].plant=g_tmp[g_idx].p
                  LET g_ary[g_idx].dbs_new=g_tmp[g_idx].d
               END IF
            END FOR
           END IF   #FUN-A70084
            IF cl_null(tm.azk01) THEN
               LET tm.azk04 = 0
               #LET t_azi03 = g_azi03 #CHI-C30012
               #LET t_azi04 = g_azi04 #CHI-C30012
               #LET t_azi05 = g_azi05 #CHI-C30012
               LET t_azi07 = g_azi07    #No.FUN-870151
            ELSE
               #SELECT azi03,azi04,azi05,azi07 INTO t_azi03,t_azi04,t_azi05,t_azi07 #No.FUN-870151 #CHI-C30012
               SELECT azi07 INTO t_azi07 #CHI-C30012
                      FROM azi_file WHERE azi01 = tm.azk01
            END IF
            #CHI-C30012---begin
            LET t_azi03 = g_ccz.ccz26
            LET t_azi04 = g_ccz.ccz26
            LET t_azi05 = g_ccz.ccz26
            #CHI-C30012---end
 
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
         CLOSE WINDOW r120_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='axcr120'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('axcr120','9031',1)
         ELSE
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.order CLIPPED,"'",
                        " '",tm.dec CLIPPED,"'",
                        " '",tm.num CLIPPED,"'",
                        " '",tm.azk01 CLIPPED,"'",
                        " '",tm.azk04 CLIPPED,"'",
                        " '",tm.data CLIPPED,"'",
                        " '",tm.plant_1 CLIPPED,"'",
                        " '",tm.plant_2 CLIPPED,"'",
                        " '",tm.plant_3 CLIPPED,"'",
                        " '",tm.plant_4 CLIPPED,"'",
                        " '",tm.plant_5 CLIPPED,"'",
                        " '",tm.plant_6 CLIPPED,"'",
                        " '",tm.plant_7 CLIPPED,"'",
                        " '",tm.plant_8 CLIPPED,"'",
                        " '",tm.type CLIPPED,"'",       #FUN-7B0044 add
                        " '",tm.type1 CLIPPED,"'",       #No.FUN-7C0101 add
                        " '",tm.detail CLIPPED,"'",
                        " '",tm.azh01 CLIPPED,"'",
                        " '",tm.azh02 CLIPPED,"'",
                        " '",tm.yy1_b CLIPPED,"'",
                        " '",tm.mm1_b CLIPPED,"'",
                        " '",tm.mm1_e CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",
                        " '",g_rep_clas CLIPPED,"'",
                        " '",g_template CLIPPED,"'",
                        " '",g_bookno CLIPPED,"'"
            CALL cl_cmdat('axcr120',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW axcr111_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r120()
      ERROR ""
   END WHILE
   CLOSE WINDOW r120_w
 
END FUNCTION
 
FUNCTION r120()
DEFINE l_name       LIKE type_file.chr20,    #External(Disk) file name  #No.FUN-680122 VARCHAR(20)
       l_sql        LIKE type_file.chr1000,  #RDSQL STATEMENT  #No.FUN-680122 VARCHAR(2000)
       l_item       LIKE type_file.chr20,    #No.FUN-680122 VARCHAR(20),
       l_tmp        LIKE type_file.chr8,     #No.FUN-680122 VARCHAR(8),
       l_za05       LIKE type_file.chr1000,  #No.FUN-680122 VARCHAR(40)
       l_flag       LIKE type_file.chr1,     #No.FUN-680122 VARCHAR(1)
       sr        RECORD
                  item       LIKE type_file.chr20,    #No.FUN-680122 VARCHAR(20),
                  order1     LIKE ima_file.ima01,     #MOD-A70147 add
                  ima01      LIKE type_file.chr1000,  #No.FUN-680122 VARCHAR(40),  #NO.FUN-5B0015
                  qty        LIKE ogb_file.ogb16,     #No.FUN-680122 DEC(15,3), #TQC-840066
                  amt        LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
                  cost       LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
                  rq_qty     LIKE ogb_file.ogb16,     #No.FUN-680122 DEC(15,3), #TQC-840066
                  rq_amt     LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
                  rq_cost    LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
                  amt_n_s    LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
                  bonus_s    LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
                  amt_n      LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
                  qty_n      LIKE ogb_file.ogb16,     #No.FUN-680122 DEC(15,3), #TQC-840066
                  cost_n     LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
                  unt        LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
                  uus        LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
                  unt1       LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
                  uus1       LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
                  bonus      LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
                  bonus_r    LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
                  order      LIKE type_file.chr30,    #No.FUN-680122 VARCHAR(30),  #No.TQC-6A0078
                  order_num  LIKE ogb_file.ogb16      #No.FUN-680122 DEC(15,3)  #TQC-840066
                 END RECORD,
       l_data    RECORD
                  oba02     LIKE oba_file.oba02,
                  azf03     LIKE azf_file.azf03,
                  ima02     LIKE ima_file.ima02,
                  ima021    LIKE ima_file.ima021
                 END RECORD,
       dec_name  LIKE cre_file.cre08,
       l_plant   STRING
 
   ### *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
 
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axcr120'
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   CALL get_tmpfile()
 
 
   CALL sort()
 
   IF tm.num >0 and tm.order >2 THEN
      CASE tm.order
         WHEN 4               #BY 淨額   #MOD-A70147 mod 3->4
            LET l_sql=" SELECT item,order1,ima01,qty,amt,cost,rq_qty,rq_amt,",  #MOD-A70147 add order1
                      " rq_cost,amt_n_s,bonus_s",
                      " FROM ",g_tname CLIPPED,
                      " WHERE ((amt_n_s<=",tm.num," AND amt_n_s>=1)",
                      " OR (bonus_s<=",tm.num," AND bonus_s>=1))",
                      " UNION ALL ",
                      " SELECT 'Other','Other','Other',sum(qty),sum(amt),sum(cost),",  #MOD-A70147 add 'Other'
                      " sum(rq_qty),sum(rq_amt),sum(rq_cost),99999,99999",
                      " FROM ",g_tname CLIPPED,
                      " WHERE NOT ((amt_n_s<=",tm.num," AND amt_n_s>=1)",
                      " OR (bonus_s<=",tm.num," AND bonus_s>=1))",
                      " GROUP BY item,ima01"
         WHEN 5               #BY 毛利   #MOD-A70147 mod 4->5
            LET l_sql=" SELECT item,order1,ima01,qty,amt,cost,rq_qty,rq_amt,",  #MOD-A70147 add order1
                      " rq_cost,amt_n_s,bonus_s",
                      " FROM ",g_tname CLIPPED,
                      " WHERE ((amt_n_s<=",tm.num," AND amt_n_s>=1)",
                      " OR (bonus_s<=",tm.num," AND bonus_s>=1))",
                      " UNION ALL ",
                      " SELECT 'Other','Other','Other',sum(qty),sum(amt),sum(cost),",  #MOD-A70147 add 'Other'
                      " sum(rq_qty),sum(rq_amt),sum(rq_cost),99999,99999",
                      " FROM ",g_tname CLIPPED,
                      " WHERE NOT ((amt_n_s<=",tm.num," AND amt_n_s>=1)",
                      " OR (bonus_s<=",tm.num," AND bonus_s>=1))",
                      " GROUP BY item,ima01"
         OTHERWISE
            LET l_sql=" SELECT item,order1,ima01,qty,amt,cost,rq_qty,rq_amt,",  #MOD-A70147 add order1
                      " rq_cost,amt_n_s,bonus_s",
                      " FROM ",g_tname CLIPPED
      END CASE
   ELSE
      LET l_sql=" SELECT item,order1,ima01,qty,amt,cost,rq_qty,rq_amt,",  #MOD-A70147 add order1
                " rq_cost,amt_n_s,bonus_s",
                " FROM ",g_tname CLIPPED
   END IF
 
   PREPARE r120_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare1:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo
      EXIT PROGRAM
   END IF
 
   DECLARE r120_curs1 CURSOR FOR r120_prepare1
 
   CALL cl_outnam('axcr120') RETURNING l_name
 
   LET g_pageno = 0
   LET g_line= 0
 
   FOREACH r120_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
      END IF
 
      LET sr.amt=sr.amt/g_base
      LET sr.cost=sr.cost/g_base
      LET sr.rq_amt=sr.rq_amt/g_base
      LET sr.rq_cost=sr.rq_cost/g_base
 
      IF sr.qty !=0 THEN
         LET sr.unt=sr.amt/sr.qty
         LET sr.unt1=sr.cost/sr.qty
      ELSE
         LET sr.unt=sr.amt
         LET sr.unt1=sr.cost
      END IF
 
      IF tm.azk04 >0 THEN
         LET sr.uus=sr.unt/tm.azk04
         LET sr.uus1=sr.unt1/tm.azk04
      END IF
 
      LET sr.qty_n=sr.qty-sr.rq_qty
      LET sr.amt_n=sr.amt-sr.rq_amt
      LET sr.cost_n=sr.cost-sr.rq_cost
 
      ### 毛利
      LET sr.bonus=(sr.amt_n-sr.cost_n)
      IF sr.amt_n<>0 THEN
         LET sr.bonus_r=sr.bonus/sr.amt_n*100
      ELSE
         LET sr.bonus_r=-100
      END IF
 
      CASE tm.order
        #WHEN 0                                             #MOD-A70147 mark
        #   LET sr.order=sr.ima01   LET sr.order_num=null   #MOD-A70147 mark
         WHEN 4  #MOD-A70147 mod 3->4
            LET sr.order=null       LET sr.order_num=sr.amt_n_s
         WHEN 5  #MOD-A70147 mod 4->5
            LET sr.order=null       LET sr.order_num=sr.bonus_s
         OTHERWISE
        #   LET sr.order=null       LET sr.order_num=null   #MOD-A70147 mark
            LET sr.order=sr.order1  LET sr.order_num=null   #MOD-A70147
      END CASE
 
      IF sr.qty<>0 OR sr.rq_qty<>0 OR sr.amt <>0 OR
         sr.rq_amt <>0 OR sr.cost<>0 OR sr.rq_cost <>0 THEN
 
         ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
 
         LET l_data.oba02 = ''
         LET l_data.azf03 = ''
         LET l_data.ima02 = ''
         LET l_data.ima021 = ''
 
         CASE tm.data
             WHEN '2'
                   SELECT oba02 INTO l_data.oba02 FROM oba_file
                    WHERE oba01=sr.item
             WHEN '3'
                   SELECT azf03 INTO l_data.oba02 FROM azf_file #MOD-A90115 mod azf03->oba02
                    WHERE azf01=sr.item AND azf02 = 'F'
             WHEN '4'
                   SELECT azf03 INTO l_data.oba02 FROM azf_file #MOD-A90115 mod azf03->oba02
                    WHERE azf01=sr.item AND azf02 = 'G'
         END CASE
         SELECT ima02 INTO l_data.ima02 FROM ima_file WHERE ima01=sr.ima01
         IF STATUS=NOTFOUND THEN LET l_data.ima02=null END IF
         SELECT ima021 INTO l_data.ima021 FROM ima_file WHERE ima01=sr.ima01
         IF STATUS=NOTFOUND THEN LET l_data.ima021=null END IF
 
         IF g_sum.dae_amt IS NULL THEN LET g_sum.dae_amt = 0 END IF
         IF g_sum.amt IS NULL     THEN LET g_sum.amt = 0 END IF
         IF g_sum.cost IS NULL    THEN LET g_sum.cost = 0 END IF
         IF g_sum.qty1 IS NULL    THEN LET g_sum.qty1 = 0 END IF
         IF g_sum.amt1 IS NULL    THEN LET g_sum.amt1 = 0 END IF
         IF g_sum.cost1 IS NULL   THEN LET g_sum.cost1 = 0 END IF
         IF g_sum.dac_amt IS NULL THEN LET g_sum.dac_amt = 0 END IF
 
         EXECUTE insert_prep USING
           sr.item     ,sr.ima01     ,sr.qty       ,sr.amt      ,sr.cost,
           sr.rq_qty   ,sr.rq_amt    ,sr.rq_cost   ,sr.amt_n_s  ,sr.bonus_s,
           sr.amt_n    ,sr.qty_n     ,sr.cost_n    ,sr.unt      ,sr.uus,
           sr.unt1     ,sr.uus1      ,sr.bonus     ,sr.bonus_r  ,sr.order,
           sr.order_num,l_data.oba02 ,l_data.azf03 ,l_data.ima02,l_data.ima021,
           g_sum.qty   ,g_sum.amt    ,g_sum.cost   ,g_sum.qty1  ,g_sum.amt1,
           g_sum.cost1 ,g_sum.dae_amt,g_sum.dac_amt,
           #g_azi03     ,g_azi04      ,g_azi05      ,  #CHI-C30012
           g_ccz.ccz26  ,g_ccz.ccz26  ,g_ccz.ccz26  ,  #CHI-C30012
           t_azi03     ,t_azi04      ,t_azi05      ,g_ccz.ccz27 ,
           t_azi07     ,sr.order1   #No:FUN-870151  #MOD-A70147 add sr.order1
      END IF
   END FOREACH
 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'ima01,ima11,ima131,ima12')
           RETURNING tm.wc
      LET g_str = tm.wc
   ELSE
      LET g_str = " "
   END IF
 
   LET l_plant = g_ary[1].plant CLIPPED," ", g_ary[2].plant CLIPPED," ",
                 g_ary[3].plant CLIPPED," ", g_ary[4].plant CLIPPED," ",
                 g_ary[5].plant CLIPPED," ", g_ary[6].plant CLIPPED," ",
                 g_ary[7].plant CLIPPED," ", g_ary[8].plant CLIPPED
 
   #            p1    ;    p2      ;    p3      ;    p4      ;    p5
   LET g_str = g_str,";",tm.azh02,";",tm.azk01,";",tm.azk04,";",tm.dec,";",
   #            p6       ;    p7      ;    p8      ;    p9       ;     p10
               tm.yy1_b,";",tm.mm1_b,";",tm.mm1_e,";",tm.detail,";",tm.order,";",
   #            p11     ;    p12        p13
               l_plant,";",tm.type,";",tm.type1  #tm.sum_code   #FUN-7B0044 add tm.type del tm.sum_code
 
   CALL cl_prt_cs3('axcr120','axcr120',l_sql,g_str)   #FUN-710080 modify
   #Modify MOD-720042 By TSD.hoho CR11---------------------------------------(E)
 
   LET g_delsql= " DROP TABLE ",g_tname CLIPPED
   PREPARE del_cmd FROM g_delsql
   EXECUTE del_cmd
 
   LET g_delsql1= " DROP TABLE ",g_tname1 CLIPPED
   PREPARE del_dpm1 FROM g_delsql1
   EXECUTE del_dpm1
 
END FUNCTION
 
FUNCTION get_tmpfile()
DEFINE l_dot     LIKE type_file.chr1,              #No.FUN-680122 VARCHAR(1)
       l_title   LIKE type_file.chr1000,           #No.FUN-680122 VARCHAR(100)
       l_groupby LIKE type_file.chr1000,           #No.FUN-680122 VARCHAR(100)
       l_sql     LIKE type_file.chr1000,           #No.FUN-680122 VARCHAR(200)
       l_col     LIKE type_file.chr1000,           #No.FUN-680122 VARCHAR(200)
       tmp_sql   STRING,                           #MOD-960309
       de_qty    LIKE ogb_file.ogb16,              #No.FUN-680122 DEC(15,3), #TQC-840066
       de_amt    LIKE type_file.num20_6,           #No.FUN-680122 DEC(20,6),
       de_cost   LIKE type_file.num20_6,           #No.FUN-680122 DEC(20,3)
       rq_qty    LIKE ogb_file.ogb16,              #No.FUN-680122 DEC(15,3), #TQC-840066
       rq_amt    LIKE type_file.num20_6,           #No.FUN-680122 DEC(20,6),
       rq_cost   LIKE type_file.num20_6,           #No.FUN-680122 DEC(20,6)
       gettmp    RECORD
                  item    LIKE type_file.chr20,    #No.FUN-680122 VARCHAR(20),
                  order1  LIKE ima_file.ima01,     #MOD-A70147 add
                  ima01   LIKE ima_file.ima01,     #No.FUN-680122 VARCHAR(40), #NO.FUN-5B0015
                  qty     LIKE ogb_file.ogb16,     #No.FUN-680122 DEC(15,3), #TQC-840066
                  amt     LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
                  cost    LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
                  rq_qty  LIKE ogb_file.ogb16,     #No.FUN-680122 DEC(15,3), #TQC-840066
                  rq_amt  LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
                  rq_cost LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
                  amt_n_s LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
                  bonus_s LIKE type_file.num20_6   #No.FUN-680122 DEC(20,6)
                 END RECORD
DEFINE li_rq_qty  LIKE ogb_file.ogb16,    #No.FUN-680122 DEC(15,3), #TQC-840066
       li_rq_amt  LIKE type_file.num20_6, #DEC(20,6),
       li_rq_cost LIKE type_file.num20_6,  #DEC(20,6),
       l_rq_qty   LIKE ogb_file.ogb16,     #MOD-BC0287 add 
       l_rq_amt   LIKE type_file.num20_6,  #MOD-BC0287 add
       l_rq_cost  LIKE type_file.num20_6   #MOD-BC0287 add
DEFINE qty_1,qty_2,qty_3     LIKE type_file.num20_6,         #No:CHI-A70023 modify
       amt_1,amt_2,amt_3     LIKE type_file.num20_6,         #No:CHI-A70023 modify
       cost_1,cost_2,cost_3  LIKE type_file.num20_6          #No:CHI-A70023 modify
 
   LET g_tname='r120_tmp'
   LET g_delsql= " DROP TABLE ",g_tname CLIPPED
   PREPARE del_pxx FROM g_delsql
   EXECUTE del_pxx
   LET l_sql=null
   LET l_col=null
   LET tmp_sql=
        "CREATE TEMP TABLE ",g_tname CLIPPED," (", #No.TQC-970305 mod
              " item    LIKE type_file.chr20, ",        #CHI-9C0059
              " order1  LIKE ima_file.ima01,",          #MOD-A70147 add
              " ima01   LIKE ima_file.ima01,",          #CHI-9C0059
              " qty     LIKE ogb_file.ogb16,",          #CHI-9C0059
              " amt     LIKE type_file.num20_6,",       #CHI-9C0059
              " cost    LIKE type_file.num20_6,",       #CHI-9C0059
              " rq_qty  LIKE ogb_file.ogb16,",          #CHI-9C0059
              " rq_amt  LIKE type_file.num20_6,",       #CHI-9C0059
              " rq_cost LIKE type_file.num20_6,",       #CHI-9C0059
              " amt_n_s LIKE type_file.num20_6,",       #CHI-9C0059
              " bonus_s LIKE type_file.num20_6)"        #CHI-9C0059
   PREPARE cre_p1 FROM tmp_sql
   EXECUTE cre_p1
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('Create axcr120_tmp:' ,SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo
      EXIT PROGRAM
   END IF
   CASE tm.data
      WHEN '2' LET l_title=" ima131,"  #產品分類
      WHEN '3' LET l_title=" ima11,"   #其他分群碼 三
      WHEN '4' LET l_title=" ima12,"   #成本分群碼
   END CASE
  #str MOD-A70147 add
   CASE tm.order
      WHEN 0    LET l_title=l_title CLIPPED,"ima01,"     #料件編號
      WHEN 1    LET l_title=l_title CLIPPED,"ima131,"    #產品分類
      WHEN 2    LET l_title=l_title CLIPPED,"ima11,"     #其他分群碼 三
      WHEN 3    LET l_title=l_title CLIPPED,"ima12,"     #成本分群碼
      OTHERWISE LET l_title=l_title CLIPPED,"' ',"
   END CASE
  #end MOD-A70147 add
   IF tm.detail MATCHES '[Yy]' THEN    #要印料件
      LET l_title=l_title CLIPPED," ima01,"
   ELSE
      LET l_title=l_title CLIPPED,"'',"
   END IF
   LET l_groupby = s_groupby(l_title CLIPPED)
 
   CALL s_ymtodate(tm.yy1_b,tm.mm1_b,tm.yy1_b,tm.mm1_e)
        RETURNING g_bdate,g_edate
 
   # 準備Insert Into Temp File
   LET tmp_sql=
       " INSERT INTO ",g_tname CLIPPED,
       " (item,order1,ima01,qty,amt,cost,rq_qty,rq_amt,rq_cost,amt_n_s,bonus_s) ",  #MOD-A70147 add order1
       " VALUES(?,?,?,?,?, ?,?,?,?,?, ?)"                                           #MOD-A70147 add ?
   PREPARE r120_ins FROM tmp_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('r120_ins:',SQLCA.sqlcode,1)
      EXECUTE del_cmd #delete tmpfile
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo
      EXIT PROGRAM
   END IF
 
   FOR g_idx=1 TO g_k
      CASE tm.type1 
         WHEN '3'  LET l_ctype_str = " AND ccc08 = ogb092 "
         WHEN '5'  LET l_ctype_str = " AND ccc08 = imd09  "
         OTHERWISE LET l_ctype_str = " AND ccc08=' ' "
      END CASE
      ### 準備讀取 折讓資料 的 cursor
      LET tmp_sql= " SELECT SUM(omb12), ",
                   " SUM(omb16),",
                   " SUM(CAST((omb12*ccc23) AS DECIMAL(20,",t_azi04,")))",
               #FUN-A10098  ---start---    
               #   " FROM ",g_ary[g_idx].dbs_new CLIPPED,"omb_file",
               #       " ,",g_ary[g_idx].dbs_new CLIPPED,"oma_file",
               # " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"ccc_file",
               #       " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
               # " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"occ_file",   #FUN-7B0044 add
               # " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"ogb_file",   #CHI-9C0059
               # " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"imd_file",   #CHI-9C0059
                   " FROM ",cl_get_target_table(g_ary[g_idx].plant,'omb_file'),",",
                            cl_get_target_table(g_ary[g_idx].plant,'oma_file'),",",
                  " OUTER ",cl_get_target_table(g_ary[g_idx].plant,'ccc_file'),",",
                            cl_get_target_table(g_ary[g_idx].plant,'ima_file'),",",
                  " OUTER ",cl_get_target_table(g_ary[g_idx].plant,'occ_file'),",",
                  " OUTER ",cl_get_target_table(g_ary[g_idx].plant,'ogb_file'),",",
                  " OUTER ",cl_get_target_table(g_ary[g_idx].plant,'imd_file'),
               #FUN-A10098  ---end---
                   " WHERE (oma02 BETWEEN '",g_bdate,"' AND '",g_edate,"') ",
                   " AND omb_file.omb31 = ogb_file.ogb01 ", #CHI-9C0059
                   " AND omb_file.omb32 = ogb_file.ogb03 ", #CHI-9C0059
                   " AND imd_file.imd01 = ogb_file.ogb09 ", #CHI-9C0059
                   l_ctype_str,  #CHI-9C0059
              " AND ccc02=YEAR(oma02) ", #CHI-9C0059
              " AND ccc03=MONTH(oma02) ", #CHI-9C0059
              " AND omaconf = 'Y' AND oma00 = '25' ",
              " AND ccc_file.ccc01 = omb_file.omb04 AND omb04=ima01",
              " AND oma01=omb01 ",
              " AND oma_file.oma03 = occ_file.occ01 ",
              " AND ccc07 = '",tm.type1,"'",   #No.FUN-7C0101 add  #No.MOD-980129 #CHI-9C0059
              " AND ",tm.wc CLIPPED
      CASE tm.type
         WHEN '1'   #關係人
             LET tmp_sql=tmp_sql CLIPPED," AND occ_file.occ37='Y'"
         WHEN '2'   #非關係人
             LET tmp_sql=tmp_sql CLIPPED," AND occ_file.occ37='N'"
      END CASE
      CASE tm.data
         WHEN '2'
             LET tmp_sql=tmp_sql CLIPPED," AND ima131 = ? " #產品分類
         WHEN '3'
             LET tmp_sql=tmp_sql CLIPPED," AND ima11 = ? "  #其他分群碼 三
         WHEN '4'
             LET tmp_sql=tmp_sql CLIPPED," AND ima12 = ? "  #成本分群碼
      END CASE
     #str MOD-A70147 add
      CASE tm.order
         WHEN 0    LET tmp_sql=tmp_sql CLIPPED," AND ima01 = ?"   #料件編號
         WHEN 1    LET tmp_sql=tmp_sql CLIPPED," AND ima131= ?"   #產品分類
         WHEN 2    LET tmp_sql=tmp_sql CLIPPED," AND ima11 = ?"   #其他分群碼 三
         WHEN 3    LET tmp_sql=tmp_sql CLIPPED," AND ima12 = ?"   #成本分群碼
      END CASE
     #end MOD-A70147 add
      IF tm.detail MATCHES '[Yy]' THEN #要印料件
         LET tmp_sql=tmp_sql CLIPPED," AND ima01 = ? "
      END IF
 
	CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql		#FUN-920032
     #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
      PREPARE r120_prepare4xk FROM tmp_sql
      DECLARE r120_curs4xk CURSOR FOR r120_prepare4xk
 
      CASE tm.type1 
         WHEN '3'  LET l_ctype_str = " AND ccc_file.ccc08 = ohb_file.ohb092 "
         WHEN '5'  LET l_ctype_str = " AND ccc08 = imd09  "
         OTHERWISE LET l_ctype_str = " AND ccc08=' ' "
      END CASE

      ### 準備讀取 銷退資料 的 cursor
     #MOD-BA0082 -- mark begin --
     #LET tmp_sql= " SELECT SUM(ohb16), ",
#    #             " SUM(ohb14*oha24),",      #MOD-B70078 mark
     #             " SUM(ohb14)*oha24,",      #MOD-B70078
     #             " SUM(CAST((ohb16*ccc23) AS DECIMAL(20,",t_azi04,")))",
     #MOD-BA0082 -- mark end --
      #MOD-BA0082 -- begin --
     #LET tmp_sql= " SELECT SUM(A),SUM(B),SUM(C) FROM (",                     #MOD-BC0287 mark
     #             " SELECT SUM(ohb16) A, ",                                  #MOD-BC0287 mark
      LET tmp_sql= " SELECT SUM(ohb16) A, ",                                  #MOD-BC0287 add
                   " SUM(ohb14)*oha24 B,",
                   " SUM(CAST((ohb16*ccc23) AS DECIMAL(20,",t_azi04,"))) C",
      #MOD-BA0082 -- end --
               #FUN-A10098  ---start---
               #   " FROM ",g_ary[g_idx].dbs_new CLIPPED,"ohb_file",
               #       " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
               #       " ,",g_ary[g_idx].dbs_new CLIPPED,"oha_file",
               # " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"ccc_file",
               # " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"imd_file",   #CHI-9C0059
               # " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"occ_file",   #FUN-7B0044 add
                   " FROM ",cl_get_target_table(g_ary[g_idx].plant,'ohb_file'),",",
                            cl_get_target_table(g_ary[g_idx].plant,'ima_file'),",",
                            cl_get_target_table(g_ary[g_idx].plant,'oha_file'),",",
                  " OUTER ",cl_get_target_table(g_ary[g_idx].plant,'ccc_file'),",",
                  " OUTER ",cl_get_target_table(g_ary[g_idx].plant,'imd_file'),",",
                  " OUTER ",cl_get_target_table(g_ary[g_idx].plant,'occ_file'),
               #FUN-A10098  ---end---
                   " WHERE (oha02 BETWEEN '",g_bdate,"' AND '",g_edate,"') ",
                   " AND imd_file.imd01 = ohb_file.ohb09 ", #CHI-9C0059
                   l_ctype_str,  #CHI-9C0059
              " AND ccc02=YEAR(oha02) ",   #CHI-9C0059
              " AND ccc03=MONTH(oha02) ",  #CHI-9C0059
              " AND ccc07 = '",tm.type1,"'",   #No.FUN-7C0101 add  #No.MOD-980129 #CHI-9C0059
              " AND ohaconf = 'Y' AND ohapost = 'Y' ",
              " AND ccc_file.ccc01 = ohb_file.ohb04 AND ohb04 = ima01 ",
              " AND oha01 = ohb01 ",
              " AND oha_file.oha03 = occ_file.occ01 ",
              #No.TQC-A40130  --Begin
              #" AND oha09 <> '5' ",     #CHI-6A0063 add
              " AND oha09 NOT IN ('2','5','6') ",
              #No.TQC-A40130  --End  
              " AND ",tm.wc CLIPPED
     CASE tm.type
        WHEN '1'   #關係人
            LET tmp_sql = tmp_sql CLIPPED," AND occ_file.occ37='Y'"
        WHEN '2'   #非關係人
            LET tmp_sql = tmp_sql CLIPPED," AND occ_file.occ37='N'"
     END CASE
     #No.TQC-A40130  --Begin
     #LET tmp_sql = tmp_sql CLIPPED," AND oha09 <> '2' "   #No.MOD-980129
     #No.TQC-A40130  --End  
      CASE tm.data
         WHEN '2'
             LET tmp_sql=tmp_sql CLIPPED," AND ima131 = ? " #產品分類
         WHEN '3'
             LET tmp_sql=tmp_sql CLIPPED," AND ima11 = ? "  #其他分群碼 三
         WHEN '4'
             LET tmp_sql=tmp_sql CLIPPED," AND ima12 = ? "  #成本分群碼
      END CASE
     #str MOD-A70147 add
      CASE tm.order
         WHEN 0    LET tmp_sql=tmp_sql CLIPPED," AND ima01 = ?"   #料件編號
         WHEN 1    LET tmp_sql=tmp_sql CLIPPED," AND ima131= ?"   #產品分類
         WHEN 2    LET tmp_sql=tmp_sql CLIPPED," AND ima11 = ?"   #其他分群碼 三
         WHEN 3    LET tmp_sql=tmp_sql CLIPPED," AND ima12 = ?"   #成本分群碼
      END CASE
     #end MOD-A70147 add
      IF tm.detail MATCHES '[Yy]' THEN #要印料件
         LET tmp_sql=tmp_sql CLIPPED," AND ima01 = ? "
      END IF
     #LET tmp_sql = tmp_sql," GROUP BY oha24)"   #MOD-BA0082 add   #MOD-BC0287 mark
      LET tmp_sql = tmp_sql," GROUP BY oha24"    #MOD-BC0287 add
      CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql   #FUN-920032
     #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
      PREPARE r120_prepare4x FROM tmp_sql
      DECLARE r120_curs4x CURSOR FOR r120_prepare4x
     #MOD-BA0082 -- mark begin --
     #LET tmp_sql = " SELECT SUM(ohb16), ",
#    #              " SUM(ohb14*oha24),",       #MOD-B70078 mark
     #              " SUM(ohb14)*oha24,",       #MOD-B70078
     #              " SUM(CAST((ohb16*ccc23) AS DECIMAL(20,",t_azi04,")))",
     #MOD-BA0082 -- mark end --
      #MOD-BA0082 -- begin --
     #LET tmp_sql= " SELECT SUM(A),SUM(B),SUM(C) FROM (",                      #MOD-BC0287 mark
     #             " SELECT SUM(ohb16) A, ",                                   #MOD-BC0287 mark
      LET tmp_sql= " SELECT SUM(ohb16) A, ",                                   #MOD-BC0287 add
                   " SUM(ohb14)*oha24 B,",
                   " SUM(CAST((ohb16*ccc23) AS DECIMAL(20,",t_azi04,"))) C",
      #MOD-BA0082 -- end --
                #FUN-A10098  ---start---   
                #   " FROM ",g_ary[g_idx].dbs_new CLIPPED,"ohb_file",
                #       " ,",g_ary[g_idx].dbs_new CLIPPED,"oha_file",
                # " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"ccc_file",
                #       " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
                # " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"occ_file",   #FUN-7B0044 add
                # " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"imd_file",   #CHI-9C0059
                   " FROM ",cl_get_target_table(g_ary[g_idx].plant,'ohb_file'),",",
                            cl_get_target_table(g_ary[g_idx].plant,'oha_file'),",",
                  " OUTER ",cl_get_target_table(g_ary[g_idx].plant,'ccc_file'),",",
                            cl_get_target_table(g_ary[g_idx].plant,'ima_file'),",",
                  " OUTER ",cl_get_target_table(g_ary[g_idx].plant,'occ_file'),",",
                  " OUTER ",cl_get_target_table(g_ary[g_idx].plant,'imd_file'),
                #FUN-A10098  ---end---
                  " WHERE (oha02 BETWEEN '",g_bdate,"' AND '",g_edate,"') ",
                  " AND imd_file.imd01 = ohb_file.ohb09 ", #CHI-9C0059
                  l_ctype_str,  #CHI-9C0059
              " AND ccc02=YEAR(oha02) ",  #CHI-9C0059
              " AND ccc03=MONTH(oha02) ", #CHI-9C0059
              " AND ccc07 = '",tm.type1,"'",   #No.FUN-7C0101 add  #No.MOD-980129  #CHI-9C0059
              " AND ohaconf = 'Y' AND ohapost = 'Y' ",
              " AND ccc_file.ccc01 = ohb_file.ohb04 AND ohb04 = ima01 ",
              " AND oha01 = ohb01 ",
              " AND oha_file.oha03 = occ_file.occ01 ",
              " AND oha09 = '5' ",     #
              " AND ",tm.wc CLIPPED
      CASE tm.type
         WHEN '1'   #關係人
             LET tmp_sql=tmp_sql CLIPPED," AND occ_file.occ37='Y'"
         WHEN '2'   #非關係人
             LET tmp_sql=tmp_sql CLIPPED," AND occ_file.occ37='N'"
      END CASE
      CASE tm.data
         WHEN '2'
             LET tmp_sql=tmp_sql CLIPPED," AND ima131 = ? " #產品分類
         WHEN '3'
             LET tmp_sql=tmp_sql CLIPPED," AND ima11 = ? "  #其他分群碼 三
         WHEN '4'
             LET tmp_sql=tmp_sql CLIPPED," AND ima12 = ? "  #成本分群碼
      END CASE
     #str MOD-A70147 add
      CASE tm.order
         WHEN 0    LET tmp_sql=tmp_sql CLIPPED," AND ima01 = ?"   #料件編號
         WHEN 1    LET tmp_sql=tmp_sql CLIPPED," AND ima131= ?"   #產品分類
         WHEN 2    LET tmp_sql=tmp_sql CLIPPED," AND ima11 = ?"   #其他分群碼 三
         WHEN 3    LET tmp_sql=tmp_sql CLIPPED," AND ima12 = ?"   #成本分群碼
      END CASE
     #end MOD-A70147 add
      IF tm.detail MATCHES '[Yy]' THEN #要印料件
         LET tmp_sql=tmp_sql CLIPPED," AND ima01 = ? "
      END IF
     #LET tmp_sql = tmp_sql," GROUP BY oha24)"   #MOD-BA0082 add  #MOD-BC0287 mark
      LET tmp_sql = tmp_sql," GROUP BY oha24 "   #MOD-BC0287 add 
      CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql   #FUN-920032
     #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
      PREPARE r120_prepare4x_2 FROM tmp_sql
      DECLARE r120_curs4x_2 CURSOR FOR r120_prepare4x_2
 
      CASE tm.type1 
         WHEN '3'  LET l_ctype_str = " AND ccc08 = ogb092 "
         WHEN '5'  LET l_ctype_str = " AND ccc08 = imd09  "
         OTHERWISE LET l_ctype_str = " AND ccc08=' ' "
      END CASE

      LET tmp_sql= " SELECT ",
                  #   銷售量      銷售收入          銷售成本
                   " sum(ogb16),0,",
                   " sum(CAST((ogb16*ccc23) AS DECIMAL(20,",t_azi04,")))",
               #FUN-A10098  ---start---
               #   " FROM ",g_ary[g_idx].dbs_new CLIPPED,"ogb_file",
               # " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"azf_file",  #No.FUN-660073
               #       " ,",g_ary[g_idx].dbs_new CLIPPED,"oga_file",
               # " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"ccc_file",
               #       " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
               # " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"occ_file",  #FUN-7B0044 add
               # " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"imd_file",   #CHI-9C0059
                   " FROM ",cl_get_target_table(g_ary[g_idx].plant,'ogb_file'),",",
               #  " OUTER ",cl_get_target_table(g_ary[g_idx].plant,'azf_file'),",",  #No.TQC-A40130
                            cl_get_target_table(g_ary[g_idx].plant,'oga_file'),",",
                  " OUTER ",cl_get_target_table(g_ary[g_idx].plant,'ccc_file'),",",
                            cl_get_target_table(g_ary[g_idx].plant,'ima_file'),",",
                  " OUTER ",cl_get_target_table(g_ary[g_idx].plant,'occ_file'),",",
                  " OUTER ",cl_get_target_table(g_ary[g_idx].plant,'imd_file'),
               #FUN-A10098  ----end---              
                   " WHERE ",tm.wc CLIPPED,
                   " AND ima01=ogb04 AND oga01 = ogb01 ",
               #No.TQC-A40130  --Begin
               #   " AND ogb_file.ogb1001=azf_file.azf01 AND azf_file.azf08 <>'Y' ",  #No.FUN-660073
                   " AND (ogb1001 IS NULL OR ogb1001 IN( ",                       
                   "      SELECT azf01 FROM ",cl_get_target_table(g_ary[g_idx].plant,'azf_file'),
                   "       WHERE azf08 <>'Y')) ",
               #No.TQC-A40130  --End  
                   " AND (oga02 BETWEEN '",g_bdate,"' AND '",g_edate,"') ",
                  " AND ccc02=YEAR(oga02) ", #CHI-9C0059
                  " AND ccc03=MONTH(oga02) ", #CHI-9C0059
                  " AND ccc07 = '",tm.type1,"'",   #No.FUN-7C0101 add  #No.MOD-980129 #CHI-9C0059
                  " AND oga_file.oga03=occ_file.occ01 ",
                  " AND ccc_file.ccc01=ima_file.ima01 ",
                   " AND (oga65 != 'Y' OR oga09 = '8') ",     #No.TQC-A40130
                  #" AND oga09 IN ('2','3','4','6','8') AND ogaconf = 'Y' AND ogapost = 'Y' ",  #No.FUN-610079   #MOD-B90101 mark
                   " AND oga09 IN ('2','3','4','6','8','A') ",                                  #MOD-B90101
                   " AND ogaconf = 'Y' AND ogapost = 'Y' ",                                     #MOD-B90101
                   " AND ogb17 = 'N'",  #MOD-710154 #CHI-9C0059
                   " AND imd_file.imd01 = ogb_file.ogb09 ", #CHI-9C0059
                   l_ctype_str   #CHI-9C0059
                   #no:5681上行加 oga09 MATCHES'[2346]'
     LET tmp_sql = tmp_sql CLIPPED," AND oga00 <> '2' "   #No.MOD-980129
      CASE tm.type
         WHEN '1'   #關係人
             LET tmp_sql=tmp_sql CLIPPED," AND occ_file.occ37='Y'"
         WHEN '2'   #非關係人
             LET tmp_sql=tmp_sql CLIPPED," AND occ_file.occ37='N'"
      END CASE
      CASE tm.data
         WHEN '2'
             LET tmp_sql=tmp_sql CLIPPED," AND ima131 = ? " #產品分類
         WHEN '3'
             LET tmp_sql=tmp_sql CLIPPED," AND ima11 = ? "  #其他分群碼 三
         WHEN '4'
             LET tmp_sql=tmp_sql CLIPPED," AND ima12 = ? "  #成本分群碼
      END CASE
     #str MOD-A70147 add
      CASE tm.order
         WHEN 0    LET tmp_sql=tmp_sql CLIPPED," AND ima01 = ?"   #料件編號
         WHEN 1    LET tmp_sql=tmp_sql CLIPPED," AND ima131= ?"   #產品分類
         WHEN 2    LET tmp_sql=tmp_sql CLIPPED," AND ima11 = ?"   #其他分群碼 三
         WHEN 3    LET tmp_sql=tmp_sql CLIPPED," AND ima12 = ?"   #成本分群碼
      END CASE
     #end MOD-A70147 add
      IF tm.detail MATCHES '[Yy]' THEN #要印料件
         LET tmp_sql=tmp_sql CLIPPED," AND ima01 = ? "
      END IF
      LET tmp_sql = tmp_sql CLIPPED," AND oga00 NOT IN ('A','3','7') "   #FUN-5B0123   #No.MOD-950210 modify
 
	CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql		#FUN-920032
     #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
      PREPARE r120_prepareog FROM tmp_sql
      DECLARE r120_cursog CURSOR FOR r120_prepareog
 
      CASE tm.type1 
         WHEN '3'  LET l_ctype_str = " AND ccc08 = ogc092 "
         WHEN '5'  LET l_ctype_str = " AND ccc08 = imd09  "
         OTHERWISE LET l_ctype_str = " AND ccc08=' ' "
      END CASE

      # 多倉儲批出貨取ogc_file
      LET tmp_sql= " SELECT ",
                   #   銷售量      銷售收入          銷售成本
                   " sum(ogc16),0,",
                   " sum(CAST((ogc16*ccc23) AS DECIMAL(20,",t_azi04,"))) ",
               #FUN-A10098  ---start--- 
               #   " FROM ",g_ary[g_idx].dbs_new CLIPPED,"ogb_file",
               # " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"azf_file",  #No.FUN-660073
               #       " ,",g_ary[g_idx].dbs_new CLIPPED,"oga_file",
               #       " ,",g_ary[g_idx].dbs_new CLIPPED,"ogc_file",
               # " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"ccc_file",
               #       " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
               # " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"occ_file",  #FUN-7B0044 add
               # " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"imd_file",   #CHI-9C0059
                   " FROM ",cl_get_target_table(g_ary[g_idx].plant,'ogb_file'),",",
               #  " OUTER ",cl_get_target_table(g_ary[g_idx].plant,'azf_file'),",",  #No.TQC-A40130
                            cl_get_target_table(g_ary[g_idx].plant,'oga_file'),",",
                            cl_get_target_table(g_ary[g_idx].plant,'ogc_file'),",",
                  " OUTER ",cl_get_target_table(g_ary[g_idx].plant,'ccc_file'),",",
                            cl_get_target_table(g_ary[g_idx].plant,'ima_file'),",",
                            cl_get_target_table(g_ary[g_idx].plant,'tlf_file'),",",  #No:CHI-A70023 add
                  " OUTER ",cl_get_target_table(g_ary[g_idx].plant,'occ_file'),",",
                  " OUTER ",cl_get_target_table(g_ary[g_idx].plant,'imd_file'),
               #FUN-A10098  ----end---
               
                   " WHERE ",tm.wc CLIPPED,
                 #----------No:CHI-A70023 modify
                 # " AND ima01=ogb04 AND oga01 = ogb01 ",
                   " AND oga01 = ogb01 ",
                 #----------No:CHI-A70023 end  
                   " AND ogb01=ogc01 AND ogb03 = ogc03 ",
               #No.TQC-A40130  --Begin
               #   " AND ogb_file.ogb1001=azf_file.azf01 AND azf_file.azf08 <>'Y' ",  #No.FUN-660073
                   " AND (ogb1001 IS NULL OR ogb1001 IN( ",                       
                   "      SELECT azf01 FROM ",cl_get_target_table(g_ary[g_idx].plant,'azf_file'),
                   "       WHERE azf08 <>'Y')) ",
               #No.TQC-A40130  --End  
                   " AND (oga02 BETWEEN '",g_bdate,"' AND '",g_edate,"') ",
                  " AND ccc02=YEAR(oga02) ", #CHI-9C0059
                  " AND ccc03=MONTH(oga02) ", #CHI-9C0059
                  " AND ccc07 = '",tm.type1,"'",   #No.FUN-7C0101 add  #No.MOD-980129 #CHI-9C0059
                  " AND oga_file.oga03=occ_file.occ01 ",
                  " AND ccc_file.ccc01=ima_file.ima01 ",
                   " AND (oga65 != 'Y' OR oga09 = '8') ",     #No.TQC-A40130
                  #" AND oga09 IN ('2','3','4','6','8') AND ogaconf = 'Y' AND ogapost = 'Y' ",  #No.FUN-610079   #MOD-B90101
                   " AND oga09 IN ('2','3','4','6','8','A') ",                                  #MOD-B90101
                   " AND ogaconf = 'Y' AND ogapost = 'Y' ",                                     #MOD-B90101
                   " AND ogb17 = 'Y'",
                   #no:5681上行加 oga09 MATCHES'[2346]'
                   " AND imd_file.imd01 = ogc_file.ogc09 ", #CHI-9C0059
                   l_ctype_str   #CHI-9C0059
     LET tmp_sql = tmp_sql CLIPPED," AND oga00 <> '2' "   #No.MOD-980129
      CASE tm.type
         WHEN '1'   #關係人
             LET tmp_sql=tmp_sql CLIPPED," AND occ_file.occ37='Y'"
         WHEN '2'   #非關係人
             LET tmp_sql=tmp_sql CLIPPED," AND occ_file.occ37='N'"
      END CASE
      CASE tm.data
         WHEN '2'
             LET tmp_sql=tmp_sql CLIPPED," AND ima131 = ? " #產品分類
         WHEN '3'
             LET tmp_sql=tmp_sql CLIPPED," AND ima11 = ? "  #其他分群碼 三
         WHEN '4'
             LET tmp_sql=tmp_sql CLIPPED," AND ima12 = ? "  #成本分群碼
      END CASE
     #str MOD-A70147 add
      CASE tm.order
         WHEN 0    LET tmp_sql=tmp_sql CLIPPED," AND ima01 = ?"   #料件編號
         WHEN 1    LET tmp_sql=tmp_sql CLIPPED," AND ima131= ?"   #產品分類
         WHEN 2    LET tmp_sql=tmp_sql CLIPPED," AND ima11 = ?"   #其他分群碼 三
         WHEN 3    LET tmp_sql=tmp_sql CLIPPED," AND ima12 = ?"   #成本分群碼
      END CASE
     #end MOD-A70147 add
      IF tm.detail MATCHES '[Yy]' THEN #要印料件
         LET tmp_sql=tmp_sql CLIPPED," AND ima01 = ? "
      END IF
      LET tmp_sql = tmp_sql CLIPPED," AND oga00 NOT IN ('A','3','7') "   #FUN-5B0123   #No.MOD-950210 modify
 
	CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql		#FUN-920032
     #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
      PREPARE r120_prepareog_1 FROM tmp_sql
      DECLARE r120_cursog_1 CURSOR FOR r120_prepareog_1
 
      CASE tm.type1 
         WHEN '3'  LET l_ctype_str = " AND ccc08 = ogb092 "
         WHEN '5'  LET l_ctype_str = " AND ccc08 = imd09  "
         OTHERWISE LET l_ctype_str = " AND ccc08=' ' "
      END CASE

      #單獨計算銷售收入
      LET tmp_sql= " SELECT ",
                   #   銷售量      銷售收入          銷售成本
                   " 0,sum(ogb14*oga24),0 ",                             #MOD-710154
               #FUN-A10098   ---start--- 
               #   " FROM ",g_ary[g_idx].dbs_new CLIPPED,"ogb_file",
               # " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"azf_file",  #No.FUN-660073
               #       " ,",g_ary[g_idx].dbs_new CLIPPED,"oga_file",
               # " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"ccc_file",
               #       " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
               # " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"occ_file",   #FUN-7B0044 add
               # " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"imd_file",   #CHI-9C0059
                   " FROM ",cl_get_target_table(g_ary[g_idx].plant,'ogb_file'),",",
               #  " OUTER ",cl_get_target_table(g_ary[g_idx].plant,'azf_file'),",",  #No.TQC-A40130
                            cl_get_target_table(g_ary[g_idx].plant,'oga_file'),",",
                  " OUTER ",cl_get_target_table(g_ary[g_idx].plant,'ccc_file'),",",
                            cl_get_target_table(g_ary[g_idx].plant,'ima_file'),",",
                  " OUTER ",cl_get_target_table(g_ary[g_idx].plant,'occ_file'),",",
                  " OUTER ",cl_get_target_table(g_ary[g_idx].plant,'imd_file'),
               #FUN-A10098  ----end---
                   " WHERE ",tm.wc CLIPPED,
                   " AND ima01=ogb04 AND oga01 = ogb01 ",
               #No.TQC-A40130  --Begin
               #   " AND ogb_file.ogb1001=azf_file.azf01 AND azf_file.azf08 <>'Y' ",  #No.FUN-660073
                   " AND (ogb1001 IS NULL OR ogb1001 IN( ",                       
                   "      SELECT azf01 FROM ",cl_get_target_table(g_ary[g_idx].plant,'azf_file'),
                   "       WHERE azf08 <>'Y')) ",
               #No.TQC-A40130  --End  
                   " AND (oga02 BETWEEN '",g_bdate,"' AND '",g_edate,"') ",
                  " AND ccc02=YEAR(oga02) ", #CHI-9C0059
                  " AND ccc03=MONTH(oga02) ", #CHI-9C0059
                  " AND ccc07 = '",tm.type1,"'",   #No.FUN-7C0101 add  #No.MOD-980129 #CHI-9C0059
                  " AND oga_file.oga03=occ_file.occ01 ",
                  " AND ccc_file.ccc01=ima_file.ima01 ",
                   " AND (oga65 != 'Y' OR oga09 = '8') ",     #No.TQC-A40130
                  #" AND oga09 IN ('2','3','4','6','8') AND ogaconf = 'Y' AND ogapost = 'Y' ",  #No.FUN-610079   #MOD-B90101 mark
                   " AND oga09 IN ('2','3','4','6','8','A') ",                                  #MOD-B90101
                   " AND ogaconf = 'Y' AND ogapost = 'Y' ",                                     #MOD-B90101
                   " AND ogb17 = 'N' ", #No:CHI-A70023 add
                   #no:5681上行加 oga09 MATCHES'[2346]'
                   " AND imd_file.imd01 = ogb_file.ogb09 ", #CHI-9C0059
                   l_ctype_str   #CHI-9C0059
     LET tmp_sql = tmp_sql CLIPPED," AND oga00 <> '2' "   #No.MOD-980129
      CASE tm.type
         WHEN '1'   #關係人
             LET tmp_sql=tmp_sql CLIPPED," AND occ_file.occ37='Y'"
         WHEN '2'   #非關係人
             LET tmp_sql=tmp_sql CLIPPED," AND occ_file.occ37='N'"
      END CASE
      CASE tm.data
         WHEN '2'
             LET tmp_sql=tmp_sql CLIPPED," AND ima131 = ? " #產品分類
         WHEN '3'
             LET tmp_sql=tmp_sql CLIPPED," AND ima11 = ? "  #其他分群碼 三
         WHEN '4'
             LET tmp_sql=tmp_sql CLIPPED," AND ima12 = ? "  #成本分群碼
      END CASE
     #str MOD-A70147 add
      CASE tm.order
         WHEN 0    LET tmp_sql=tmp_sql CLIPPED," AND ima01 = ?"   #料件編號
         WHEN 1    LET tmp_sql=tmp_sql CLIPPED," AND ima131= ?"   #產品分類
         WHEN 2    LET tmp_sql=tmp_sql CLIPPED," AND ima11 = ?"   #其他分群碼 三
         WHEN 3    LET tmp_sql=tmp_sql CLIPPED," AND ima12 = ?"   #成本分群碼
      END CASE
     #end MOD-A70147 add
      IF tm.detail MATCHES '[Yy]' THEN #要印料件
         LET tmp_sql=tmp_sql CLIPPED," AND ima01 = ? "
      END IF
      LET tmp_sql = tmp_sql CLIPPED," AND oga00 NOT IN ('A','3','7') "   #FUN-5B0123   #No.MOD-950210 modify
 
	CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql		#FUN-920032
     #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
      PREPARE r120_prepareog_2 FROM tmp_sql
      DECLARE r120_cursog_2 CURSOR FOR r120_prepareog_2

      #--------------------No:CHI-A70023 add
      LET tmp_sql= " SELECT ",
                   #   銷售量      銷售收入          銷售成本
                   " 0,sum(ogc16*(ogb14/ogb12)*oga24),0 ",
                   " FROM ",g_ary[g_idx].dbs_new CLIPPED,"ogb_file",
                       " ,",g_ary[g_idx].dbs_new CLIPPED,"oga_file",
                       " ,",g_ary[g_idx].dbs_new CLIPPED,"ogc_file",
                 " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"ccc_file",
                       " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
                       " ,",g_ary[g_idx].dbs_new CLIPPED,"tlf_file",
                 " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"occ_file",
                 " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"imd_file",
                   " WHERE ",tm.wc CLIPPED,
                   " AND oga01 = ogb01 ",
                   " AND (ogb1001 IS NULL OR ogb1001 IN( ",
                   "      SELECT azf01 FROM ",g_ary[g_idx].dbs_new CLIPPED,
                   "      azf_file WHERE azf08 <>'Y')) ",
                   " AND (oga02 BETWEEN '",g_bdate,"' AND '",g_edate,"') ",
                   " AND ogb01=ogc01 AND ogb03 = ogc03 ",
                   " AND ccc02=YEAR(oga02) ",
                   " AND ccc03=MONTH(oga02) ",
                   " AND ccc07 = '",tm.type1,"'",
                   " AND oga03=occ_file.occ01 ",
                   " AND ccc_file.ccc01=ima01 ",
                   " AND (oga65 != 'Y' OR oga09 = '8') ",
                   " AND oga09 IN ('2','3','4','6','8','A') ",                               
                   " AND ogaconf = 'Y' AND ogapost = 'Y' ",                         
                   " AND ogb17 = 'Y'",
                   " AND tlf905 = oga01 AND tlf906 = ogb03 AND tlf01 = ima01",
                   " AND ((tlf66 = 'X' AND ogc17 = tlf01) OR ((tlf66 !='X' OR tlf66 IS NULL) AND ogb04=tlf01 AND tlf902=ogc09 AND tlf903=ogc091 AND tlf904=ogc092)) ",     #TQC-C60134 add tlf66 IS NULL
                   " AND imd_file.imd01 = ogc_file.ogc09 ",
                   l_ctype_str
     LET tmp_sql = tmp_sql CLIPPED," AND oga00 <> '2' "
      CASE tm.type
         WHEN '1'   #關係人
             LET tmp_sql=tmp_sql CLIPPED," AND occ37='Y'"
         WHEN '2'   #非關係人
             LET tmp_sql=tmp_sql CLIPPED," AND occ37='N'"
      END CASE
      CASE tm.data
         WHEN '2'
             LET tmp_sql=tmp_sql CLIPPED," AND ima131 = ? " #產品分類
         WHEN '3'
             LET tmp_sql=tmp_sql CLIPPED," AND ima11 = ? "  #其他分群碼 三
         WHEN '4'
             LET tmp_sql=tmp_sql CLIPPED," AND ima12 = ? "  #成本分群碼
      END CASE
      CASE tm.order
         WHEN 0    LET tmp_sql=tmp_sql CLIPPED," AND ima01 = ?"   #料件編號
         WHEN 1    LET tmp_sql=tmp_sql CLIPPED," AND ima131= ?"   #產品分類
         WHEN 2    LET tmp_sql=tmp_sql CLIPPED," AND ima11 = ?"   #其他分群碼 三
         WHEN 3    LET tmp_sql=tmp_sql CLIPPED," AND ima12 = ?"   #成本分群碼
      END CASE
      IF tm.detail MATCHES '[Yy]' THEN #要印料件
         LET tmp_sql=tmp_sql CLIPPED," AND ima01 = ? "
      END IF
      LET tmp_sql = tmp_sql CLIPPED," AND oga00 NOT IN ('A','3','7') "
        CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql
      PREPARE r120_prepareog_3 FROM tmp_sql
      DECLARE r120_cursog_3 CURSOR FOR r120_prepareog_3
    #--------------------No:CHI-A70023 end
 
      CASE tm.type1 
         WHEN '3'  LET l_ctype_str = " AND ccc_file.ccc08 = ogb_file.ogb092 "
         WHEN '5'  LET l_ctype_str = " AND ccc_file.ccc08 = imd_file.imd09  "
         OTHERWISE LET l_ctype_str = " AND ccc08=' ' "
      END CASE

      LET tmp_sql =    #出貨單刪除
          " SELECT SUM(tlf10),SUM(ogb14*oga24)*-1,SUM(tlfc21)  ",  #MOD-4B0100   #No.FUN-7C0101 mod tlf21->tlfc21
      #FUN-A10098  ---start---
      #   " FROM ",g_ary[g_idx].dbs_new CLIPPED,"tlf_file",
      #       " ,",g_ary[g_idx].dbs_new CLIPPED,"tlfc_file",      #No.FUN-7C0101 add
      #       " ,",g_ary[g_idx].dbs_new CLIPPED,"smy_file",
      # " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"ccc_file",
      #       " ,",g_ary[g_idx].dbs_new CLIPPED,"oga_file",
      #       " ,",g_ary[g_idx].dbs_new CLIPPED,"ogb_file",
      # " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"azf_file",  #No.FUN-660073
      #       " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
      # " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"occ_file",  #FUN-7B0044 add
      # " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"imd_file",   #CHI-9C0059
          " FROM ",cl_get_target_table(g_ary[g_idx].plant,'tlf_file'),",",
                   cl_get_target_table(g_ary[g_idx].plant,'tlfc_file'),",",
                   cl_get_target_table(g_ary[g_idx].plant,'smy_file'),",",
         " OUTER ",cl_get_target_table(g_ary[g_idx].plant,'ccc_file'),",",
                   cl_get_target_table(g_ary[g_idx].plant,'oga_file'),",",
                   cl_get_target_table(g_ary[g_idx].plant,'ogb_file'),",",
      #  " OUTER ",cl_get_target_table(g_ary[g_idx].plant,'azf_file'),",",  #No.TQC-A40130
                   cl_get_target_table(g_ary[g_idx].plant,'ima_file'),",",
         " OUTER ",cl_get_target_table(g_ary[g_idx].plant,'occ_file'),",",
         " OUTER ",cl_get_target_table(g_ary[g_idx].plant,'imd_file'),
      #FUN-A10098  ----end---
          " WHERE ",tm.wc CLIPPED,
          " AND tlf61=smyslip AND smydmy1 = 'Y' ",
          " AND (tlf03 = 723 OR tlf03 = 725) AND tlf02 = 50 ",
          " AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
          " AND tlf_file.tlf01=ccc_file.ccc01 ",
          " AND ccc_file.ccc02=YEAR(tlf06) AND ccc_file.ccc03=MONTH(tlf06) ",
          " AND ccc_file.ccc07 = '",tm.type1,"'",   #No.FUN-7C0101 add
          " AND oga_file.oga03=occ_file.occ01 ",   #FUN-7B0044 add
          " AND tlf_file.tlf01=ima01 ",
          #No.TQC-A40130  --Begin
          #   " AND ogb_file.ogb1001=azf_file.azf01 AND azf_file.azf08 <>'Y' ",  #No.FUN-660073
              " AND (ogb1001 IS NULL OR ogb1001 IN( ",                       
              "      SELECT azf01 FROM ",cl_get_target_table(g_ary[g_idx].plant,'azf_file'),
              "       WHERE azf08 <>'Y')) ",
          #No.TQC-A40130  --End  
          " AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
          " AND (oga65 != 'Y' OR oga09 = '8') ",     #No.TQC-A40130
         #" AND tlf026=ogb01 AND tlf027=ogb03 AND ogb01=oga01 AND oga09 IN ('2','3','4','6','8') ",  #No.FUN-610079   #MOD-B90101 mark
          " AND tlf026=ogb01 AND tlf027=ogb03 AND ogb01=oga01 ",                                     #MOD-B90101
          " AND oga09 IN ('2','3','4','6','8','A') ",                                                #MOD-B90101
          " AND tlfc_file.tlfc01 = tlf01 AND tlfc_file.tlfc02 = tlf02 ",
          " AND tlfc_file.tlfc03 = tlf03 AND tlfc_file.tlfc06 = tlf06 ",          #No.FUN-830002
          " AND tlfc_file.tlfc13 = tlf13",                              #No.FUN-830002
          " AND tlfc_file.tlfc902= tlf902 AND tlfc_file.tlfc903 = tlf903",        #No.FUN-830002
          " AND tlfc_file.tlfc904= tlf904 AND tlfc_file.tlfc905 = tlf905 ",
          " AND tlfc_file.tlfc906= tlf906 AND tlfc_file.tlfc907 = tlf907",        #No.FUN-830002
          " AND tlfctype = '",tm.type1,"'",  #CHI-9C0059
          #no:5681上行加 oga09 MATCHES '[2346]'
          " AND imd_file.imd01 = ogb_file.ogb09 ", #CHI-9C0059
          l_ctype_str,   #CHI-9C0059
          " AND tlfcost = tlfccost ", #CHI-9C0059
          " AND tlf_file.tlfcost = ccc_file.ccc08 "  #CHI-9C0059
     LET tmp_sql = tmp_sql CLIPPED," AND oga00 <> '2' "   #No.MOD-980129
      CASE tm.type
         WHEN '1'   #關係人
             LET tmp_sql=tmp_sql CLIPPED," AND occ_file.occ37='Y'"
         WHEN '2'   #非關係人
             LET tmp_sql=tmp_sql CLIPPED," AND occ_file.occ37='N'"
      END CASE
      CASE tm.data
         WHEN '2'
             LET tmp_sql=tmp_sql CLIPPED," AND ima131 = ? " #產品分類
         WHEN '3'
             LET tmp_sql=tmp_sql CLIPPED," AND ima11 = ? "  #其他分群碼 三
         WHEN '4'
             LET tmp_sql=tmp_sql CLIPPED," AND ima12 = ? "  #成本分群碼
      END CASE
     #str MOD-A70147 add
      CASE tm.order
         WHEN 0    LET tmp_sql=tmp_sql CLIPPED," AND ima01 = ?"   #料件編號
         WHEN 1    LET tmp_sql=tmp_sql CLIPPED," AND ima131= ?"   #產品分類
         WHEN 2    LET tmp_sql=tmp_sql CLIPPED," AND ima11 = ?"   #其他分群碼 三
         WHEN 3    LET tmp_sql=tmp_sql CLIPPED," AND ima12 = ?"   #成本分群碼
      END CASE
     #end MOD-A70147 add
      IF tm.detail MATCHES '[Yy]' THEN #要印料件
         LET tmp_sql=tmp_sql CLIPPED," AND ima01 = ? "
      END IF
      LET tmp_sql = tmp_sql CLIPPED," AND oga00 NOT IN ('A','3','7') "   #FUN-5B0123   #No.MOD-950210 modify
	CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql		#FUN-920032
     #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098 #TQC-BB0182 mark
      PREPARE r120_prepareog_r FROM tmp_sql
      DECLARE r120_cursog_r CURSOR FOR r120_prepareog_r
 
      LET tmp_sql=
          " SELECT DISTINCT ",l_title CLIPPED,"0,0,0,0,0,0,0,0 ",
        #FUN-A10098   ---start---
        # " FROM ",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
        # " LEFT OUTER JOIN ",g_ary[g_idx].dbs_new CLIPPED,"ccc_file",
          #" FROM ",cl_get_target_table(g_ary[g_idx].dbs_new,'ima_file'),   #FUN-A80109
          " FROM ",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),    #FUN-A80109
          " LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'ccc_file'),
        #FUN-A10098  ---end---
          " ON (ccc_file.ccc01=ima_file.ima01 ",
          " AND ccc_file.ccc02=",tm.yy1_b,
          " AND ccc_file.ccc03 BETWEEN ",tm.mm1_b," AND ",tm.mm1_e,
          " AND ccc07 = '",tm.type1,"'",
          " AND (ccc61 !=0 or ccc62 !=0 or ccc63 !=0)) ",
          " WHERE ",tm.wc CLIPPED,
          " GROUP BY ",l_groupby CLIPPED
	CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql		#FUN-920032
     #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
      PREPARE r120_prepare3 FROM tmp_sql
      DECLARE r120_curs3 CURSOR FOR r120_prepare3
      FOREACH r120_curs3 INTO gettmp.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
         END IF
#str MOD-A70147 mod
#增加參數gettmp.order1
         IF tm.detail MATCHES '[Yy]' THEN #資料選擇
           #str MOD-A70147 add
            IF tm.order = 4 OR tm.order = 5 THEN
               OPEN r120_curs4x USING gettmp.item  ,gettmp.ima01
               OPEN r120_curs4x_2 USING gettmp.item,gettmp.ima01  #CHI-6A0063
               OPEN r120_cursog USING gettmp.item  ,gettmp.ima01
               OPEN r120_cursog_1 USING gettmp.item,gettmp.ima01		
               OPEN r120_cursog_2 USING gettmp.item,gettmp.ima01
               OPEN r120_cursog_3 USING gettmp.item,gettmp.ima01   #No:CHI-A70023 add
               OPEN r120_cursog_r USING gettmp.item,gettmp.ima01
            ELSE
           #end MOD-A70147 add
               OPEN r120_curs4x USING gettmp.item  ,gettmp.order1,gettmp.ima01
               OPEN r120_curs4x_2 USING gettmp.item,gettmp.order1,gettmp.ima01  #CHI-6A0063
               OPEN r120_cursog USING gettmp.item  ,gettmp.order1,gettmp.ima01
               OPEN r120_cursog_1 USING gettmp.item,gettmp.order1,gettmp.ima01		
               OPEN r120_cursog_2 USING gettmp.item,gettmp.order1,gettmp.ima01
               OPEN r120_cursog_3 USING gettmp.item,gettmp.order1,gettmp.ima01  #No:CHI-A70023 add
               OPEN r120_cursog_r USING gettmp.item,gettmp.order1,gettmp.ima01
            END IF   #MOD-A70147 add
         ELSE
           #str MOD-A70147 add
            IF tm.order = 4 OR tm.order = 5 THEN
               OPEN r120_curs4x USING gettmp.item  
               OPEN r120_curs4x_2 USING gettmp.item  #CHI-6A0063
               OPEN r120_cursog USING gettmp.item  
               OPEN r120_cursog_1 USING gettmp.item             
               OPEN r120_cursog_2 USING gettmp.item
               OPEN r120_cursog_3 USING gettmp.item   #No:CHI-A70023 add
               OPEN r120_cursog_r USING gettmp.item
            ELSE
           #end MOD-A70147 add
               OPEN r120_curs4x USING gettmp.item  ,gettmp.order1  
               OPEN r120_curs4x_2 USING gettmp.item,gettmp.order1     #CHI-6A0063
               OPEN r120_cursog USING gettmp.item  ,gettmp.order1 
               OPEN r120_cursog_1 USING gettmp.item,gettmp.order1                
               OPEN r120_cursog_2 USING gettmp.item,gettmp.order1 
               OPEN r120_cursog_3 USING gettmp.item,gettmp.order1  #No:CHI-A70023 add
               OPEN r120_cursog_r USING gettmp.item,gettmp.order1 
            END IF   #MOD-A70147 add
         END IF
#end MOD-A70147 mod
         LET de_qty = 0 LET de_amt = 0 LET de_cost = 0
         LET qty_1 = 0 LET amt_1 = 0 LET cost_1 = 0
         LET qty_2 = 0 LET amt_2 = 0 LET cost_2 = 0
         LET qty_3 = 0 LET amt_3 = 0 LET cost_3 = 0  #No:CHI-A70023 add
         #-------------------------MOD-BC0287 str ------------------------------------
         #FETCH r120_curs4x INTO gettmp.rq_qty,gettmp.rq_amt,gettmp.rq_cost
         LET gettmp.rq_qty  = 0    #MOD-C70090  modify l_rq_qty  -> gettmp.rq_qty
         LET gettmp.rq_amt  = 0    #MOD-C70090  modify li_rq_amt -> gettmp.rq_amt
         LET gettmp.rq_cost = 0    #MOD-C70090  modify li_rq_cost-> gettmp.rq_cost
         FOREACH r120_curs4x INTO l_rq_qty,l_rq_amt,l_rq_cost
            LET gettmp.rq_qty  = gettmp.rq_qty  + l_rq_qty
            LET gettmp.rq_amt  = gettmp.rq_amt  + l_rq_amt
            LET gettmp.rq_cost = gettmp.rq_cost + l_rq_cost
         END FOREACH
         #-------------------------MOD-BC0287 end ------------------------------------
         IF cl_null(gettmp.rq_qty) THEN  LET gettmp.rq_qty = 0 END IF
         IF cl_null(gettmp.rq_amt) THEN  LET gettmp.rq_amt = 0 END IF
         IF cl_null(gettmp.rq_cost) THEN  LET gettmp.rq_cost = 0 END IF
         #-------------------------MOD-BC0287 str ------------------------------------
         #FETCH r120_curs4x_2 INTO li_rq_qty,li_rq_amt,li_rq_cost
         LET li_rq_qty  = 0         #MOD-C70090  modify l_rq_qty -> li_rq_qty
         LET li_rq_amt  = 0
         LET li_rq_cost = 0
         FOREACH r120_curs4x_2 INTO l_rq_qty,l_rq_amt,l_rq_cost
            LET li_rq_qty  = li_rq_qty  + l_rq_qty
            LET li_rq_amt  = li_rq_amt  + l_rq_amt
            LET li_rq_cost = li_rq_cost + l_rq_cost
         END FOREACH
         #-------------------------MOD-BC0287 end ------------------------------------
         IF cl_null(li_rq_qty) THEN  LET li_rq_qty = 0 END IF
         IF cl_null(li_rq_amt) THEN  LET li_rq_amt = 0 END IF
         IF cl_null(li_rq_cost) THEN  LET li_rq_cost = 0 END IF
         LET gettmp.rq_qty = gettmp.rq_qty + li_rq_qty
         LET gettmp.rq_amt = gettmp.rq_amt + li_rq_amt
         LET gettmp.rq_cost = gettmp.rq_cost + li_rq_cost
         FETCH r120_cursog INTO gettmp.qty,gettmp.amt,gettmp.cost
         FETCH r120_cursog_1 INTO qty_1,amt_1,cost_1
         IF cl_null(qty_1) THEN LET qty_1 = 0 END IF
         IF cl_null(amt_1) THEN LET amt_1 = 0 END IF
         IF cl_null(cost_1) THEN LET cost_1 = 0 END IF
         FETCH r120_cursog_2 INTO qty_2,amt_2,cost_2
         IF cl_null(qty_2) THEN LET qty_2 = 0 END IF
         IF cl_null(amt_2) THEN LET amt_2 = 0 END IF
         IF cl_null(cost_2) THEN LET cost_2 = 0 END IF
        #----------No:CHI-A70023 add
         FETCH r120_cursog_3 INTO qty_3,amt_3,cost_3
         IF cl_null(qty_3) THEN LET qty_3 = 0 END IF
         IF cl_null(amt_3) THEN LET amt_3 = 0 END IF
         IF cl_null(cost_3) THEN LET cost_3 = 0 END IF
        #----------No:CHI-A70023 end
         FETCH r120_cursog_r INTO de_qty,de_amt,de_cost
         CLOSE r120_curs4x
         CLOSE r120_curs4x_2
         CLOSE r120_cursog
         CLOSE r120_cursog_1
         CLOSE r120_cursog_2
         CLOSE r120_cursog_r
         IF cl_null(de_qty) THEN LET de_qty = 0 END IF
         IF cl_null(de_amt) THEN LET de_amt = 0 END IF
         IF cl_null(de_cost) THEN LET de_cost = 0 END IF
 
         IF cl_null(gettmp.rq_qty) THEN LET gettmp.rq_qty = 0 END IF
         IF cl_null(gettmp.rq_amt) THEN LET gettmp.rq_amt = 0 END IF
         IF cl_null(gettmp.rq_cost) THEN LET gettmp.rq_cost = 0 END IF
 
         IF cl_null(gettmp.qty) THEN LET gettmp.qty = 0 END IF
         IF cl_null(gettmp.amt) THEN LET gettmp.amt = 0 END IF
         IF cl_null(gettmp.cost) THEN LET gettmp.cost = 0 END IF
         LET gettmp.qty = gettmp.qty + de_qty + qty_1 + qty_2
         LET gettmp.amt = gettmp.amt + de_amt + amt_1 + amt_2
         LET gettmp.cost = gettmp.cost + de_cost + cost_1 + cost_2
         LET gettmp.qty = gettmp.qty + de_qty + qty_1 + qty_2 + qty_3       #No:CHI-A70023 modify
         LET gettmp.amt = gettmp.amt + de_amt + amt_1 + amt_2 + amt_3       #No:CHI-A70023 modify
         LET gettmp.cost = gettmp.cost + de_cost + cost_1 + cost_2 +cost_3  #No:CHI-A70023 modify
         EXECUTE r120_ins USING gettmp.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare3:',SQLCA.sqlcode,1)
            PREPARE del_cmd2 FROM g_delsql
            EXECUTE del_cmd2 #delete tmpfile
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo
            EXIT PROGRAM
         END IF
      END FOREACH
   END FOR  #for g_inx  dbs
END FUNCTION
 
FUNCTION sort()
DEFINE l_sql    LIKE type_file.chr1000,          #No.FUN-680122 VARCHAR(1000)
       l_sql1   LIKE type_file.chr1000,          #No.FUN-680122 VARCHAR(500)
       l_delsql LIKE type_file.chr1000,          #No.FUN-680122 VARCHAR(500)
       l_updsql LIKE type_file.chr1000,          #No.FUN-680122 VARCHAR(500)
       l_count  LIKE type_file.num20_6,          #No.FUN-680122 DEC(20,6),
       sr       RECORD
                 item    LIKE type_file.chr20,   #No.FUN-680122 VARCHAR(20),
                 order1  LIKE ima_file.ima01,    #MOD-A70147 add
                 ima01   LIKE ima_file.ima01,    #No.FUN-680122 VARCHAR(40),  #NO.FUN-5B0015
                 amt_n_s LIKE type_file.num20_6, #No.FUN-680122 DEC(20,6),
                 bonus_s LIKE type_file.num20_6  #No.FUN-680122 DEC(20,6)
                END RECORD
 
   LET l_sql=" SELECT item,order1,ima01,(amt-rq_amt),0",  #MOD-A70147 add order1
             " FROM ",g_tname,
             " WHERE amt<>0 OR rq_amt <>0 OR qty<>0 OR rq_qty<>0 ",
             " OR cost<>0 OR rq_cost<>0 ",
             " ORDER BY 4 desc "   #MOD-A70147 mod 3->4
   PREPARE r120_sort1 FROM l_sql
   LET l_count=0
   DECLARE r120_sort1_curs CURSOR WITH HOLD FOR r120_sort1
   FOREACH r120_sort1_curs INTO sr.*
      LET l_count=l_count+1
      LET l_updsql=" UPDATE ",g_tname,
                   " SET amt_n_s=",l_count
      IF sr.item IS NULL THEN
         LET l_updsql=l_updsql CLIPPED,
                      "WHERE item IS NULL "
      ELSE
         LET l_updsql=l_updsql CLIPPED,
                     #" WHERE item= '",sr.item  CLIPPED,"'"       #MOD-C30868 mark
                      " WHERE item= '",sr.item,"'"                #MOD-C30868 add
      END IF
     #str MOD-A70147 add
      IF sr.order1 IS NULL THEN
         LET l_updsql=l_updsql CLIPPED,
                     #" WHERE order1 IS NULL "        #MOD-B20053 mark
                      " AND order1 IS NULL "          #MOD-B20053 add
      ELSE
         LET l_updsql=l_updsql CLIPPED,
                     #" WHERE order1= '",sr.order1 CLIPPED,"'"       #MOD-B20053 mark
                     #" AND order1= '",sr.order1 CLIPPED,"'"         #MOD-B20053 add   #MOD-C30868 mark
                      " AND order1= '",sr.order1 ,"'"                                  #MOD-C30868 add
      END IF
     #end MOD-A70147 add
      IF tm.detail MATCHES '[Yy]' THEN
         LET l_updsql=l_updsql CLIPPED,
                      " AND ima01= '",sr.ima01 CLIPPED,"'"
      END IF
      PREPARE pre_upd_sort1 FROM l_updsql
      EXECUTE pre_upd_sort1
   END FOREACH
   LET l_sql=" SELECT item,order1,ima01,(amt-rq_amt),(amt-rq_amt-cost+rq_cost)",   #MOD-A70147 add order1
             " FROM ",g_tname,
             " WHERE amt<>0 OR rq_amt <>0 OR qty<>0 OR rq_qty<>0 ",
             " OR cost<>0 OR rq_cost<>0 ",
             " ORDER BY 5 desc "   #MOD-A70147 mod 4->5
   PREPARE r120_sort2 FROM l_sql
   LET l_count=0
   DECLARE r120_sort2_curs CURSOR WITH HOLD FOR r120_sort2
   FOREACH r120_sort2_curs INTO sr.*
      IF sr.amt_n_s<0 THEN #淨額<0,不排行
         CONTINUE FOREACH
      END IF
      LET l_count=l_count+1
      LET l_updsql=" UPDATE ",g_tname,
                  " SET bonus_s=",l_count
      IF sr.item IS NULL THEN
         LET l_updsql=l_updsql CLIPPED,
                      "WHERE item IS NULL "
      ELSE
         LET l_updsql=l_updsql CLIPPED,
                     #" WHERE item= '",sr.item  CLIPPED,"'"           #MOD-C30868 mark
                      " WHERE item= '",sr.item,"'"                    #MOD-C30868 add
      END IF
     #str MOD-A70147 add
      IF sr.order1 IS NULL THEN
         LET l_updsql=l_updsql CLIPPED,
                     #" WHERE order1 IS NULL "      #MOD-B20053 mark
                      " AND order1 IS NULL "        #MOD-B20053 add
      ELSE
         LET l_updsql=l_updsql CLIPPED,
                     #" WHERE order1= '",sr.order1 CLIPPED,"'"      #MOD-B20053 mark
                     #" AND order1= '",sr.order1 CLIPPED,"'"        #MOD-B20053 add    #MOD-C30868 mark
                      " AND order1= '",sr.order1,"'"                                   #MOD-C30868 add   
      END IF
     #end MOD-A70147 add
      IF tm.detail MATCHES '[Yy]' THEN
         LET l_updsql=l_updsql CLIPPED,
                      " AND ima01= '",sr.ima01 CLIPPED,"'"
      END IF
      PREPARE pre_upd_sort3 FROM l_updsql
      EXECUTE pre_upd_sort3
   END FOREACH
END FUNCTION
 
REPORT r120_rep(sr)
DEFINE l_last_sw   LIKE type_file.chr1,     #No.FUN-680122 VARCHAR(1),
       dec_name    LIKE cre_file.cre08,     #No.FUN-680122 VARCHAR(10),
       l_item      LIKE type_file.chr20,    #No.FUN-680122 VARCHAR(20),
       l_oba02     LIKE type_file.chr1000,  #No.FUN-680122 VARCHAR(30),
       l_ima02     LIKE type_file.chr1000,  #No.FUN-680122 VARCHAR(30),
       l_ima021    LIKE ima_file.ima021,    #FUN-5C0002
       l_azf03     LIKE type_file.chr1000,  #No.FUN-680122 VARCHAR(30),
       sr  RECORD
              item   LIKE type_file.chr20,    #No.FUN-680122 VARCHAR(20),
              ima01  LIKE ima_file.ima01,   #No.FUN-680122 VARCHAR(40),  #NO.FUN-5B0015
              qty     LIKE pia_file.pia66,   #No.FUN-680122 DEC(15,5),
              amt     LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              cost    LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              rq_qty  LIKE ogb_file.ogb16,     #No.FUN-680122 DEC(15,3), #TQC-840066
              rq_amt  LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              rq_cost LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              amt_n_s LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              bonus_s LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              amt_n   LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              qty_n   LIKE ogb_file.ogb16,     #No.FUN-680122DEC(15,3), #TQC-840066
              cost_n  LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              unt     LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              uus     LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              unt1    LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              uus1    LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              bonus   LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              bonus_r LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              order  LIKE type_file.chr30,    #No.FUN-680122 VARCHAR(30),  #No.TQC-6A0078
              order_num  LIKE ogb_file.ogb16   #No.FUN-680122DEC(15,3)  #TQC-840066
              END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
  ORDER BY sr.order,sr.order_num,sr.item,sr.ima01
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      IF NOT cl_null(tm.azh02) THEN
         LET g_x[1] = tm.azh02
      ELSE
         LET g_x[1] = g_x[1] END IF
      PRINT COLUMN((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED   #No.TQC-6A0078
      IF tm.dec ='2' THEN LET dec_name=g_x[17]
      ELSE IF tm.dec='3' THEN
              LET dec_name=g_x[18]
           ELSE
              LET dec_name=g_x[16]
           END IF
      END IF
      LET g_pageno = g_pageno + 1
      PRINT g_x[2] CLIPPED,g_pdate,' ',TIME,
            COLUMN (g_len-FGL_WIDTH(g_x[9]))/2,g_x[11] CLIPPED,
                   tm.azk01 clipped,'/',tm.azk04 using '<<&.&&',
            COLUMN g_len-30,dec_name CLIPPED,
            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT tm.yy1_b USING '####','/',tm.mm1_b USING '##','-',
            tm.mm1_e USING '##'
      PRINT g_dash[1,g_len]
      LET g_zaa[36].zaa08 = g_zaa[36].zaa08,tm.azk01 CLIPPED
      LET g_zaa[39].zaa08 = g_zaa[39].zaa08,tm.azk01 CLIPPED
      PRINT g_x[31],g_x[32],g_x[50],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],   #FUN-5C0002
            g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],
            g_x[45],g_x[46],g_x[47],g_x[48],g_x[49]
      PRINT g_dash1
      LET l_last_sw = 'n'
      LET l_item='X'
 
   ON EVERY ROW
      LET l_ima02 = '' LET l_oba02 = '' LET l_azf03=''
      LET l_ima021 = ''   #FUN-5C0002
      CASE tm.data
          WHEN '2'
                SELECT oba02 INTO l_oba02 FROM oba_file
                 WHERE oba01=sr.item
          WHEN '3'
                SELECT azf03 INTO l_azf03 FROM azf_file   #6818
                 WHERE azf01=sr.item AND azf02 = 'F'
          WHEN '4'
                SELECT azf03 INTO l_azf03 FROM azf_file   #6818
                 WHERE azf01=sr.item AND azf02 = 'G'
      END CASE
      SELECT ima02 INTO l_ima02 FROM ima_file
      WHERE ima01=sr.ima01
      IF STATUS=NOTFOUND THEN LET l_ima02=null END IF
      SELECT ima021 INTO l_ima021 FROM ima_file
       WHERE ima01=sr.ima01
      IF STATUS=NOTFOUND THEN LET l_ima021=null END IF
      IF tm.detail MATCHES '[Yy]' THEN
         IF sr.item <> l_item AND
            (tm.order =1 OR tm.order=2 ) THEN
            PRINT COLUMN g_c[31],'**',sr.item CLIPPED,' ',l_oba02 CLIPPED   #TQC-5B0019
            LET l_item=sr.item
         END IF
          PRINT COLUMN g_c[31],sr.ima01 CLIPPED,  #NO.FUN-5B0015
                COLUMN g_c[32],l_ima02;  #MOD-4A0238
          PRINT COLUMN g_c[50],l_ima021;  #FUN-5C0002
      ELSE
         PRINT COLUMN g_c[31],sr.item CLIPPED,
               COLUMN g_c[32],l_oba02 CLIPPED;
      END IF
      IF sr.amt_n_s=99999 THEN LET sr.amt_n_s=0 END IF
      IF sr.bonus_s=99999 THEN LET sr.bonus_s=0 END IF
      PRINT COLUMN g_c[33],cl_numfor(sr.qty,33,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
            COLUMN g_c[34],cl_numfor(sr.amt,34,g_ccz.ccz26),     #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[35],cl_numfor(sr.unt,35,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[36],cl_numfor(sr.uus,36,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[37],cl_numfor(sr.cost,37,g_ccz.ccz26),     #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[38],cl_numfor(sr.unt1,38,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[39],cl_numfor(sr.uus1,39,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[40],cl_numfor(sr.rq_qty,40,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
            COLUMN g_c[41],cl_numfor(sr.rq_amt,41,g_ccz.ccz26),     #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[42],cl_numfor(sr.rq_cost,42,g_ccz.ccz26),     #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[43],cl_numfor(sr.qty_n,43,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
            COLUMN g_c[44],cl_numfor(sr.amt_n,44,g_ccz.ccz26),     #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[45],cl_numfor(sr.amt_n_s,45,0),
            COLUMN g_c[46],cl_numfor(sr.cost_n,46,g_ccz.ccz26),     #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[47],cl_numfor(sr.bonus,47,g_ccz.ccz26),     #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[48],cl_numfor(sr.bonus_s,48,0),
            COLUMN g_c[49],cl_numfor(sr.bonus_r,49,2)
   ON LAST ROW
      IF g_sum.dae_amt IS NULL THEN LET g_sum.dae_amt = 0 END IF
      IF g_sum.amt IS NULL THEN LET g_sum.amt = 0 END IF
      IF g_sum.cost IS NULL THEN LET g_sum.cost = 0 END IF
      IF g_sum.qty1 IS NULL THEN LET g_sum.qty1 = 0 END IF
      IF g_sum.amt1 IS NULL THEN LET g_sum.amt1 = 0 END IF
      IF g_sum.cost1 IS NULL THEN LET g_sum.cost1 = 0 END IF
      IF g_sum.dac_amt IS NULL THEN LET g_sum.dac_amt = 0 END IF
 
      PRINT g_dash[1,g_len]
      PRINT COLUMN g_c[32],g_x[19] CLIPPED,
            COLUMN g_c[33],cl_numfor(SUM(sr.qty),33,g_ccz.ccz27) CLIPPED, #CHI-690007 0->g_ccz.ccz27
            COLUMN g_c[34],cl_numfor(SUM(sr.amt),34,g_ccz.ccz26) CLIPPED,     #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[35],0 USING '#################&',
            COLUMN g_c[36],0 USING '#################&',
            COLUMN g_c[37],cl_numfor(SUM(sr.cost),37,g_ccz.ccz26) CLIPPED,     #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[38],0 USING '#################&',
            COLUMN g_c[39],0 USING '#################&',
            COLUMN g_c[40],cl_numfor(sum(sr.rq_qty),40,g_ccz.ccz27) CLIPPED, #CHI-690007 0->g_ccz.ccz27
            COLUMN g_c[41],cl_numfor(sum(sr.rq_amt)+g_sum.dae_amt,41,g_ccz.ccz26) CLIPPED,     #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[42],cl_numfor(sum(sr.rq_cost),42,g_ccz.ccz26) CLIPPED,     #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[43],cl_numfor(sum(sr.qty_n),43,g_ccz.ccz27) CLIPPED, #CHI-690007 0->g_ccz.ccz27
            COLUMN g_c[44],cl_numfor(sum(sr.amt_n),44,g_ccz.ccz26) CLIPPED,     #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[45],0 USING '####&',
            COLUMN g_c[46],cl_numfor(sum(sr.cost_n),46,g_ccz.ccz26) CLIPPED,     #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[47],cl_numfor(sum(sr.bonus),47,g_ccz.ccz26) CLIPPED,     #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[48],0 USING '####&';
            IF sum(sr.amt_n) <>0 THEN
               PRINT COLUMN g_c[49],SUM(sr.amt_n-sr.cost_n) /sum(sr.amt_n)*100 USING '#####&'
            ELSE
               PRINT COLUMN g_c[49],0 USING '#####&'
            END IF
      PRINT g_dash[1,g_len]
      PRINT ' data from : ',
            g_ary[1].plant CLIPPED,' ', g_ary[2].plant CLIPPED,' ',
            g_ary[3].plant CLIPPED,' ', g_ary[4].plant CLIPPED,' ',
            g_ary[5].plant CLIPPED,' ', g_ary[6].plant CLIPPED,' ',
            g_ary[7].plant CLIPPED,' ', g_ary[8].plant CLIPPED
      PRINT g_dash[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_last_sw='y'
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash2[1,g_len]
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE
         SKIP 2 LINE
      END IF
END REPORT
 
FUNCTION duplicate(l_plant,n)               #檢查輸入之工廠編號是否重覆
   DEFINE l_plant     LIKE azp_file.azp01
   DEFINE l_idx,n     LIKE type_file.num10     #No.FUN-680122 INTEGER
 
   FOR l_idx = 1 TO n
       IF g_ary[l_idx].plant = l_plant THEN
          LET l_plant = ''
       END IF
   END FOR
   RETURN l_plant
END FUNCTION
 
 
FUNCTION r120_chkplant(l_plant)
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
#No.FUN-9C0073 ----------------By chenls 10/01/12
#FUN-A70084--add--str--
FUNCTION r120_set_entry()
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_azw05  LIKE azw_file.azw05

  SELECT azw05 INTO l_azw05 FROM azw_file WHERE azw01 = g_plant
  SELECT count(*) INTO l_cnt FROM azw_file
   WHERE azw05 = l_azw05

  IF l_cnt > 1 THEN
     CALL cl_set_comp_visible("group06",FALSE)
  END IF
  RETURN l_cnt
END FUNCTION

FUNCTION r120_chklegal(l_legal,n)
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
