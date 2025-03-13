# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: axcr761.4gl
# Descriptions...: 銷貨毛利分析
# Input parameter:
# Return code....:
# Date & Author..: 01/04/09 By Ostrich #No.+276
# Modify ........: No:8628 03/11/11 By Melody 改用 SUM(omb16)
# Modify ........: No:9624 04/06/03 By Melody 加上日期區間判斷
# Modify ........: No:8741 報表列印格式調整
# Modify.........: No.MOD-4A0238 04/11/18 By Smapmin 放寬ima02
# Modify.........: No.MOD-530251 05/03/27 By ching fix oma_file join
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-570190 05/08/08 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.MOD-570079 05/07/05 By kim 沒有進行單位換算(tlf10->tlf10*tlf60)
# Modify.........: No.MOD-590435 05/10/03 By Sarah 銷售金額抓的是應收帳款單身的本幣未稅金額(omb16)，未考慮作廢的單子，增加已確認,未作廢的條件判斷
# Modify.........: NO.FUN-5B0015 05/11/01 BY yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.FUN-5B0123 05/12/08 By Sarah 應排除出至境外倉部份(add oga00<>'3')
# Modify.........: No.TQC-610051 06/02/23 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-660187 06/07/05 By kim '客戶'資料,目前報表採用tlf_file(出貨客戶),但應該用'帳款客戶'(oma_file/occ_file)分析
# Modify.........: No.FUN-680017 06/08/31 By Claire FUN-660187改回tlf19
# Modify.........: No.FUN-680122 06/09/05 By zdyllq 類型轉換
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Hellen 本原幣取位修改
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-660073 06/12/08 By Nicola 訂單樣品修改
# Modify.........: No.CHI-690007 06/01/05 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.MOD-710150 07/01/24 By jamie 根據tlf_file去SQL出貨單號 + 項次,若使用多倉儲批出貨時,銷貨收入重複.
# Modify.........: No.TQC-710096 07/01/26 By Mandy l_sql內寫到OUTER,此行tlf14=azf01 AND azf08 <>'Y'在oracle的寫法,需調整
# Modify.........: No.MOD-720042 07/02/27 By TSD.Jin 報表改為CR明細(tm.a)功能有用
# Modify.........: No.FUN-710080 07/04/02 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.MOD-780262 07/10/30 By Pengu 在l_sql組出的SQL語法加上ORDER BY
# Modify.........: No.FUN-7C0101 08/01/24 By shiwuying 成本改善，CR增加類別編號tlfccost
# Modify.........: No.FUN-830002 08/03/05 By Cockroach l_sql增加tlf_file與tlfc_file關聯字段
# Modify.........: No.TQC-840025 08/04/10 By Cockroach BUG修改
# Modify.........: No.FUN-8A0065 08/11/06 By xiaofeizhu 提供INPUT加上關系人與營運中心
# Modify.........: No.MOD-8A0273 08/11/20 By chenl    增加sql條件,azf02='2'
# Modify.........: No.FUN-8B0118 08/12/01 By xiaofeizhu 報表小數位調整
# Modify.........: No.MOD-8C0092 09/02/03 By Pengu 沒有排除訂單樣品部分
# Modify.........: No.MOD-920042 09/02/07 By Pengu 傳票號碼用出貨單抓不到時應用銷退單抓
# Modify.........: No.CHI-930028 09/03/13 By shiwuying 取消程式段有做tlf021[1,4]或tlf031[1,4]的程式碼改成不做只取前4碼的限制
# Modify.........: No.FUN-940102 09/04/27 BY destiny 檢查使用者的資料庫使用權限 
# Modify.........: No.MOD-930099 09/05/21 By Pengu 格式為銷售地區時當遇來源單據為銷退單時,銷售地區會抓取不到
# Modify.........: No.MOD-940270 09/05/21 By Pengu 應排除出至境外倉的單據資料
# Modify.........: No.MOD-950210 09/05/26 By Pengu “寄銷出貨”不應納入 “銷貨收入”
# Modify.........: No.TQC-970188 09/07/21 By destiny l_sql改為string
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0073 10/01/12 By chenls 程序精簡
# Modify.........: No.FUN-A10098 10/01/19 By baofei GP5.2跨DB報表--財務類
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No.FUN-A50102 10/06/13 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.TQC-A60085 10/06/21 By liuxqa 追单MOD-970258&MOD-9C0373
# Modify.........: No.FUN-A70084 10/08/02 By lutingting GP5.2報表處理
# Modify.........: No:MOD-A80106 10/08/13 By sabrina 將MOD-9C0373前面四行mark
# Modify.........: No:FUN-9B0017 10/08/23 By chenmoyan 銷貨收入要將aglt700的遞延收入納入計算
# Modify.........: NO.FUN-A60007 10/08/27 by chenmoyan oct_file加入帳別
# Modify.........: No:MOD-B10194 11/01/25 By sabrina 若omb_file資料抓不到，改抓oga_file和ogb_file資料
# Modify.........: No:TQC-B70104 11/07/12 By guoch wc的類型設置為string
# Modify.........: No:MOD-B70215 11/07/22 By Vampire 在where條件多加 AND oga00!='2' 
# Modify.........: No.TQC-BB0182 11/01/11 By pauline 取消過濾plant條件
# Modify.........: No:MOD-C20005 12/02/17 By bart 退貨金額錯誤修正
# Modify.........: No:MOD-C20181 12/02/27 By yinhy 大陸版本異動數更改
# Modify.........: No:MOD-C30566 12/03/12 By tanxc 排除oga65='Y'的資料
# Modify.........: No:MOD-C30859 12/03/26 By ck2yuan axcr761_prepare1最後少了一個欄位給sr.wsaleamt，預設給0
# Modify.........: No:FUN-C50127 12/05/30 By suncx 報表增加顯示銷貨明細項
# Modify.........: No.FUN-C10015 12/06/05 By bart 可選擇印出樣品銷貨
# Modify.........: No:CHI-C50069 12/06/26 By Sakura 原"列印樣品銷貨"欄位改用RadioBox(1.一般出貨,2.樣品出貨,3.全部)
# Modify.........: No:CHI-C30012 12/07/30 By bart 金額取位改抓ccz26
# Modify.........: No:TQC-C80138 12/08/22 By zhangll warea_name和warea變數定義長度錯誤
# Modify.........: No:MOD-CB0253 12/11/28 By wujie 排除oga09 =9的资料
# Modify.........: No:FUN-CB0031 12/11/07 By wujie 走开票流程的时候,排除出货单到发票仓的tlf资料，开票金额按axmt670的金额来计算
# Modify.........: No:CHI-A70023 13/01/30 By Alberti 調整成品替代的銷貨收入
# Modify.........: No:MOD-C60108 13/01/30 By Alberti 給予l_flag='Y' 
# Modify.........: No:MOD-D20121 13/03/04 By bart 選擇客戶報表樣板呈現時應使用負數表達
# Modify.........: No:MOD-D40123 13/04/17 By bart 報表金額已有扣除簽退部份，但數量沒扣除
# Modify.........: No:MOD-D50185 13/05/22 By wujie 启用发出商品则未转应收部分应抓取omf档
# Modify.........: No:MOD-D60074 13/06/08 By wujie 抓取多角和销退的资料sql改进
# Modify.........: No:MOD-D80134 13/08/21 By wujie 抓取omf的资料包含在发出商品条件内
# Modify.........: No:MOD-D90159 13/09/27 By suncx l_oga09可能为空，需要增加为空的判断

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
    #       wc      LIKE type_file.chr1000,       #No.FUN-680122CHAR(300)  #TQC-B70104  mark
           wc      STRING,   #TQC-B70104
           bdate   LIKE type_file.dat,           #No.FUN-680122DATE
           edate   LIKE type_file.dat,           #No.FUN-680122DATE
           type    LIKE tlfc_file.tlfctype,      #No.FUN-7C0101 add
           a       LIKE type_file.chr1,          #No.FUN-680122CHAR(1)
           g       LIKE type_file.chr1,          #No.FUN-680122CHAR(1)
           b       LIKE type_file.chr1,          #No.FUN-8A0065 VARCHAR(1)
           c       LIKE type_file.chr1,          #FUN-C50127 add
           d       LIKE type_file.chr1,          #FUN-C10015
           p1      LIKE azp_file.azp01,          #No.FUN-8A0065 VARCHAR(10)
           p2      LIKE azp_file.azp01,          #No.FUN-8A0065 VARCHAR(10)
           p3      LIKE azp_file.azp01,          #No.FUN-8A0065 VARCHAR(10)
           p4      LIKE azp_file.azp01,          #No.FUN-8A0065 VARCHAR(10) 
           p5      LIKE azp_file.azp01,          #No.FUN-8A0065 VARCHAR(10)
           p6      LIKE azp_file.azp01,          #No.FUN-8A0065 VARCHAR(10)
           p7      LIKE azp_file.azp01,          #No.FUN-8A0065 VARCHAR(10)
           p8      LIKE azp_file.azp01,          #No.FUN-8A0065 VARCHAR(10)
           type_1  LIKE type_file.chr1,          #No.FUN-8A0065 VARCHAR(1)
           s       LIKE type_file.chr3,          #No.FUN-8A0065 VARCHAR(3)
           t       LIKE type_file.chr3,          #No.FUN-8A0065 VARCHAR(3)
           u       LIKE type_file.chr3,          #No.FUN-8A0065 VARCHAR(3)           
           more    LIKE type_file.chr1           #No.FUN-680122CHAR(1)
           END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
 
DEFINE l_table     STRING
DEFINE g_sql       STRING
DEFINE g_str       STRING
#DEFINE m_dbs       ARRAY[10] OF LIKE type_file.chr20   #No.FUN-8A0065 ARRAY[10] OF VARCHAR(20)   #FUN-A70084
DEFINE m_plant       ARRAY[10] OF LIKE azp_file.azp01   #FUN-A70084
DEFINE m_legal       ARRAY[10] OF LIKE azw_file.azw02   #FUN-A70084 

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
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> *** ##
   LET g_sql = "ima12.ima_file.ima12,",
               "ima01.ima_file.ima01,", 
               "ima02.ima_file.ima02,",
               "ima06.ima_file.ima06,",
               "ima131.ima_file.ima131,",
               "tlfccost.tlfc_file.tlfccost,",    #No.FUN-7C0101 add
               "oeb908.oeb_file.oeb908,",
               "tlf02.tlf_file.tlf02,",
               "tlf021.tlf_file.tlf021,",
               "tlf03.tlf_file.tlf03,",
               "tlf031.tlf_file.tlf031,",
               "tlf06.tlf_file.tlf06,",
               "tlf026.tlf_file.tlf026,",
               "tlf027.tlf_file.tlf027,",
               "tlf036.tlf_file.tlf036,",
               "tlf037.tlf_file.tlf037,",
               "tlf01.tlf_file.tlf01,",
               "tlf10.tlf_file.tlf10,",
               "tlfc21.tlfc_file.tlfc21,",        #No.FUN-7C0101 tlf21->tlfc21
               "tlf13.tlf_file.tlf13,",
               "tlf905.tlf_file.tlf905,",
               "tlf906.tlf_file.tlf906,",
               "tlf19.tlf_file.tlf19,",
               "tlf907.tlf_file.tlf907,",
               "amt01.tlfc_file.tlfc221,",        #No.FUN-7C0101
               "amt02.tlfc_file.tlfc222,",        #No.FUN-7C0101
               "amt03.tlfc_file.tlfc2231,",       #No.FUN-7C0101
               "amt_d.tlfc_file.tlfc2232,",       #No.FUN-7C0101
               "amt05.tlfc_file.tlfc224,",        #No.FUN-7C0101
               "amt06.tlfc_file.tlfc2241,",        #No.FUN-7C0101
               "amt07.tlfc_file.tlfc2242,",        #No.FUN-7C0101
               "amt08.tlfc_file.tlfc2243,",        #No.FUN-7C0101
               "amt04.ccc_file.ccc23,",
            #   "wsaleamt.ima_file.ima26,",#FUN-A20044
               "wsaleamt.type_file.num15_3,",#FUN-A20044
              #"warea_name.oab_file.oab01,",
               "warea_name.oab_file.oab02,",  #TQC-C80138 mod
               "wocc02.occ_file.occ02,",
               "wticket.oma_file.oma33,",
               "l_wsale_tlf21.tlf_file.tlf21,",
               "ccz27.ccz_file.ccz27,",
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05, ",
               "plant.azp_file.azp01"                                           #FUN-8A0065                
 
   LET l_table = cl_prt_temptable('axcr761',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ",
               "         ?,?,?,?,?,",                                #No.TQC-840025 ADD 
               "        ?,?,?,?,?, ?,?,?) "                          #FUN-8A0065 Add ?
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.type=ARG_VAL(15)  #No.FUN-7C0101 add 
   LET tm.a = ARG_VAL(10)
   LET tm.g = ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   LET tm.b     = ARG_VAL(16)
   LET tm.p1    = ARG_VAL(17)
   LET tm.p2    = ARG_VAL(18)
   LET tm.p3    = ARG_VAL(19)
   LET tm.p4    = ARG_VAL(20)
   LET tm.p5    = ARG_VAL(21)
   LET tm.p6    = ARG_VAL(22)
   LET tm.p7    = ARG_VAL(23)
   LET tm.p8    = ARG_VAL(24)
   LET tm.type_1= ARG_VAL(25)   
   LET tm.s     = ARG_VAL(26)
   LET tm.t     = ARG_VAL(27)
   LET tm.u     = ARG_VAL(28)   
   LET tm.c     = ARG_VAL(29)    #FUN-C50127 add
   LET tm.d     = ARG_VAL(30)   #FUN-C10015 
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.u3   = tm.u[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF      
   IF cl_null(g_bgjob) or g_bgjob = 'N'
      THEN CALL axcr761_tm(0,0)
      ELSE CALL axcr761()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr761_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col       LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_flag            LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_bdate,l_edate   LIKE type_file.dat,            #No.FUN-680122DATE
          l_cmd             LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(400)
   DEFINE l_cnt             LIKE type_file.num5          #FUN-A70084
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 20
   ELSE LET p_row = 5 LET p_col = 15
   END IF
   OPEN WINDOW axcr761_w AT p_row,p_col
        WITH FORM "axc/42f/axcr761"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   CALL r761_set_entry() RETURNING l_cnt    #FUN-A70084
   INITIALIZE tm.* TO NULL
   CALL s_azm(g_ccz.ccz01,g_ccz.ccz02)
    RETURNING l_flag,l_bdate,l_edate
   INITIALIZE tm.* TO NULL
   LET tm.bdate= l_bdate
   LET tm.edate= l_edate
   LET tm.type = g_ccz.ccz28  #No.FUN-7C0101 add
   LET tm.a   = 'N'
   LET tm.g    ='1'
   LET tm.more= 'N'
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'
   LET tm.s ='12 '
   LET tm.t ='Y  '
   LET tm.u ='Y  '
   LET tm.type_1  = '3'
   LET tm.b ='N'
   LET tm.c ='N'    #FUN-C50127 add
  #LET tm.d ='N'   #FUN-C10015 #CHI-C50069 mark
   LET tm.d ='3'   #CHI-C50069 add
   LET tm.p1=g_plant
   CALL r761_set_entry_1()               
   CALL r761_set_no_entry_1()
   CALL r761_set_comb()           
 
 WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ima12,ima01 ,tlf905 ,tlf19, ima131 #FUN-660187 tlf19 -> oma03 #FUN-680017
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
     ON ACTION locale
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE CONSTRUCT
 
     ON ACTION controlp
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
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axcr761_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.bdate,tm.edate,tm.type,tm.a, tm.g,
                #tm.b,tm.p1,tm.p2,tm.p3,                                                    #FUN-8A0065
                 tm.b,tm.c,tm.d,tm.p1,tm.p2,tm.p3,      #FUN-C10015 add d                                         #FUN-8A0065  #FUN-C50127 add tm.c
                 tm.p4,tm.p5,tm.p6,tm.p7,tm.p8,tm.type_1,                                   #FUN-8A0065 
                 tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,                                 #FUN-8A0065
                 tm2.u1,tm2.u2,tm2.u3,                                                      #FUN-8A0065   
                 tm.more  #No.FUN-7C0101 add tm.type
      WITHOUT DEFAULTS
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD bdate
        IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
      AFTER FIELD edate
        IF cl_null(tm.edate) OR tm.edate<tm.bdate THEN NEXT FIELD edate END IF
      AFTER FIELD g
         IF tm.g NOT MATCHES '[123]' THEN
            NEXT FIELD g
         END IF
         
       ON CHANGE  g
          IF tm.g = '1' THEN
             LET tm.type_1 = '3'
          END IF
          DISPLAY BY NAME tm.type_1       
          CALL r761_set_entry_1()      
          CALL r761_set_no_entry_1()    
                           
      AFTER FIELD type                                               #No.FUN-7C0101
         IF tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF#No.FUN-7C0101
         
      AFTER FIELD b
          IF NOT cl_null(tm.b)  THEN
             IF tm.b NOT MATCHES "[YN]" THEN
                NEXT FIELD b       
             END IF
          END IF
                    
       ON CHANGE  b
          LET tm.p1=g_plant
          LET tm.p2=NULL
          LET tm.p3=NULL
          LET tm.p4=NULL
          LET tm.p5=NULL
          LET tm.p6=NULL
          LET tm.p7=NULL
          LET tm.p8=NULL
          DISPLAY BY NAME tm.p1,tm.p2,tm.p3,tm.p4,tm.p5,tm.p6,tm.p7,tm.p8       
          CALL r761_set_entry_1()      
          CALL r761_set_no_entry_1()
          CALL r761_set_comb()       

      AFTER FIELD type_1
         IF cl_null(tm.type_1) OR tm.type_1 NOT MATCHES '[123]' THEN
            NEXT FIELD type_1
         END IF                   
       
      AFTER FIELD p1
         IF cl_null(tm.p1) THEN NEXT FIELD p1 END IF
         SELECT azp01 FROM azp_file WHERE azp01 = tm.p1
         IF STATUS THEN 
            CALL cl_err3("sel","azp_file",tm.p1,"",STATUS,"","sel azp",1)   
            NEXT FIELD p1 
         END IF
         IF NOT cl_null(tm.p1) THEN 
            IF NOT s_chk_demo(g_user,tm.p1) THEN              
               NEXT FIELD p1         
           #FUN-A70084--add--str--
            ELSE
               SELECT azw02 INTO m_legal[1] FROM azw_file WHERE azw01 = tm.p1
           #FUN-A70084--add--end
            END IF  
         END IF              
      AFTER FIELD p2
         IF NOT cl_null(tm.p2) THEN
            SELECT azp01 FROM azp_file WHERE azp01 = tm.p2
            IF STATUS THEN 
               CALL cl_err3("sel","azp_file",tm.p2,"",STATUS,"","sel azp",1)   
               NEXT FIELD p2 
            END IF
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[2] FROM azw_file WHERE azw01 = tm.p2
            IF NOT r761_chklegal(m_legal[2],1) THEN
               CALL cl_err(tm.p2,g_errno,0)
               NEXT FIELD p2
            END IF 
            #FUN-A70084--add--end
            IF NOT s_chk_demo(g_user,tm.p2) THEN
               NEXT FIELD p2
            END IF            
         END IF
 
      AFTER FIELD p3
         IF NOT cl_null(tm.p3) THEN
            SELECT azp01 FROM azp_file WHERE azp01 = tm.p3
            IF STATUS THEN 
               CALL cl_err3("sel","azp_file",tm.p3,"",STATUS,"","sel azp",1)   
               NEXT FIELD p3 
            END IF
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[3] FROM azw_file WHERE azw01 = tm.p3
            IF NOT r761_chklegal(m_legal[3],2) THEN
               CALL cl_err(tm.p3,g_errno,0)
               NEXT FIELD p3
            END IF
            #FUN-A70084--add--end
            IF NOT s_chk_demo(g_user,tm.p3) THEN
               NEXT FIELD p3
            END IF            
         END IF
 
      AFTER FIELD p4
         IF NOT cl_null(tm.p4) THEN
            SELECT azp01 FROM azp_file WHERE azp01 = tm.p4
            IF STATUS THEN 
               CALL cl_err3("sel","azp_file",tm.p4,"",STATUS,"","sel azp",1)  
               NEXT FIELD p4 
            END IF
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[4] FROM azw_file WHERE azw01 = tm.p4
            IF NOT r761_chklegal(m_legal[4],3) THEN
               CALL cl_err(tm.p4,g_errno,0)
               NEXT FIELD p4
            END IF
            #FUN-A70084--add--end
            IF NOT s_chk_demo(g_user,tm.p4) THEN
               NEXT FIELD p4
            END IF            
         END IF
 
      AFTER FIELD p5
         IF NOT cl_null(tm.p5) THEN
            SELECT azp01 FROM azp_file WHERE azp01 = tm.p5
            IF STATUS THEN 
               CALL cl_err3("sel","azp_file",tm.p5,"",STATUS,"","sel azp",1)    
               NEXT FIELD p5 
            END IF
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[5] FROM azw_file WHERE azw01 = tm.p5
            IF NOT r761_chklegal(m_legal[5],4) THEN
               CALL cl_err(tm.p5,g_errno,0)
               NEXT FIELD p5
            END IF
            #FUN-A70084--add--end
            IF NOT s_chk_demo(g_user,tm.p5) THEN
               NEXT FIELD p5
            END IF            
         END IF
 
      AFTER FIELD p6
         IF NOT cl_null(tm.p6) THEN
            SELECT azp01 FROM azp_file WHERE azp01 = tm.p6
            IF STATUS THEN 
               CALL cl_err3("sel","azp_file",tm.p6,"",STATUS,"","sel azp",1)  
               NEXT FIELD p6 
            END IF
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[6] FROM azw_file WHERE azw01 = tm.p6
            IF NOT r761_chklegal(m_legal[6],5) THEN
               CALL cl_err(tm.p6,g_errno,0)
               NEXT FIELD p6
            END IF
            #FUN-A70084--add--end
            IF NOT s_chk_demo(g_user,tm.p6) THEN
               NEXT FIELD p6
            END IF            
         END IF
 
      AFTER FIELD p7
         IF NOT cl_null(tm.p7) THEN
            SELECT azp01 FROM azp_file WHERE azp01 = tm.p7
            IF STATUS THEN 
               CALL cl_err3("sel","azp_file",tm.p7,"",STATUS,"","sel azp",1) 
               NEXT FIELD p7 
            END IF
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[7] FROM azw_file WHERE azw01 = tm.p7
            IF NOT r761_chklegal(m_legal[7],6) THEN
               CALL cl_err(tm.p7,g_errno,0)
               NEXT FIELD p7
            END IF
            #FUN-A70084--add--end
            IF NOT s_chk_demo(g_user,tm.p7) THEN
               NEXT FIELD p7
            END IF            
         END IF
 
      AFTER FIELD p8
         IF NOT cl_null(tm.p8) THEN
            SELECT azp01 FROM azp_file WHERE azp01 = tm.p8
            IF STATUS THEN 
               CALL cl_err3("sel","azp_file",tm.p8,"",STATUS,"","sel azp",1)   
               NEXT FIELD p8 
            END IF
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[8] FROM azw_file WHERE azw01 = tm.p8
            IF NOT r761_chklegal(m_legal[8],7) THEN
               CALL cl_err(tm.p8,g_errno,0)
               NEXT FIELD p8
            END IF
            #FUN-A70084--add--end
            IF NOT s_chk_demo(g_user,tm.p8) THEN
               NEXT FIELD p8
            END IF            
         END IF       
                
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(p1)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
               LET g_qryparam.arg1 = g_user                #No.FUN-940102
               LET g_qryparam.default1 = tm.p1
               CALL cl_create_qry() RETURNING tm.p1
               DISPLAY BY NAME tm.p1
               NEXT FIELD p1
            WHEN INFIELD(p2)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
               LET g_qryparam.arg1 = g_user                #No.FUN-940102
               LET g_qryparam.default1 = tm.p2
               CALL cl_create_qry() RETURNING tm.p2
               DISPLAY BY NAME tm.p2
               NEXT FIELD p2
            WHEN INFIELD(p3)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
               LET g_qryparam.arg1 = g_user                #No.FUN-940102
               LET g_qryparam.default1 = tm.p3
               CALL cl_create_qry() RETURNING tm.p3
               DISPLAY BY NAME tm.p3
               NEXT FIELD p3
            WHEN INFIELD(p4)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
               LET g_qryparam.arg1 = g_user                #No.FUN-940102
               LET g_qryparam.default1 = tm.p4
               CALL cl_create_qry() RETURNING tm.p4
               DISPLAY BY NAME tm.p4
               NEXT FIELD p4
            WHEN INFIELD(p5)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
               LET g_qryparam.arg1 = g_user                #No.FUN-940102
               LET g_qryparam.default1 = tm.p5
               CALL cl_create_qry() RETURNING tm.p5
               DISPLAY BY NAME tm.p5
               NEXT FIELD p5
            WHEN INFIELD(p6)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
               LET g_qryparam.arg1 = g_user                #No.FUN-940102
               LET g_qryparam.default1 = tm.p6
               CALL cl_create_qry() RETURNING tm.p6
               DISPLAY BY NAME tm.p6
               NEXT FIELD p6
            WHEN INFIELD(p7)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
               LET g_qryparam.arg1 = g_user                #No.FUN-940102
               LET g_qryparam.default1 = tm.p7
               CALL cl_create_qry() RETURNING tm.p7
               DISPLAY BY NAME tm.p7
               NEXT FIELD p7
            WHEN INFIELD(p8)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
               LET g_qryparam.arg1 = g_user                #No.FUN-940102
               LET g_qryparam.default1 = tm.p8
               CALL cl_create_qry() RETURNING tm.p8
               DISPLAY BY NAME tm.p8
               NEXT FIELD p8
         END CASE                        
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr761_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr761'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr761','9031',1)   
      ELSE
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.type CLIPPED,"'" ,             #No.FUN-7C0101 add
                         " '",tm.a CLIPPED,"'",                 #TQC-610051
                         " '",tm.g CLIPPED,"'",                 #TQC-610051                         
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'",           #No.FUN-7C0078
                         " '",tm.b CLIPPED,"'" ,      #FUN-8A0065
                         " '",tm.p1 CLIPPED,"'" ,     #FUN-8A0065
                         " '",tm.p2 CLIPPED,"'" ,     #FUN-8A0065
                         " '",tm.p3 CLIPPED,"'" ,     #FUN-8A0065
                         " '",tm.p4 CLIPPED,"'" ,     #FUN-8A0065
                         " '",tm.p5 CLIPPED,"'" ,     #FUN-8A0065
                         " '",tm.p6 CLIPPED,"'" ,     #FUN-8A0065
                         " '",tm.p7 CLIPPED,"'" ,     #FUN-8A0065
                         " '",tm.p8 CLIPPED,"'" ,     #FUN-8A0065
                         " '",tm.type_1 CLIPPED,"'" , #FUN-8A0065           
                         " '",tm.s CLIPPED,"'" ,      #FUN-8A0065
                         " '",tm.t CLIPPED,"'" ,      #FUN-8A0065
                         " '",tm.u CLIPPED,"'" ,      #FUN-8A0065
                         " '",tm.c CLIPPED,"'" ,      #FUN-C50127 add
                         " '",tm.d CLIPPED,"'"        #FUN-C10015
 
         CALL cl_cmdat('axcr761',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr761_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr761()
   ERROR ""
END WHILE
   CLOSE WINDOW axcr761_w
END FUNCTION
 
FUNCTION axcr761()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680122CHAR(20)        # External(Disk) file name
          l_sql     STRING,                       #No.TQC-970188 
          l_chr     LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_za05    LIKE type_file.chr1000        #No.FUN-680122 VARCHAR(40)
  DEFINE wima201    LIKE type_file.chr2           #No.FUN-680122 VARCHAR( 2)
  DEFINE l_oga00    LIKE oga_file.oga00           #No.MOD-940270 add
  DEFINE l_oga65    LIKE oga_file.oga65           #No.MOD-C30566 add
 #DEFINE warea      LIKE type_file.chr4           #No.FUN-680122CHAR(4)   #TQC-C80138 mark
 #DEFINE warea_name LIKE oab_file.oab01,          #No.FUN-680122CHAR(10)  #TQC-C80138 mark
  DEFINE warea      LIKE oab_file.oab01           #No.FUN-680122CHAR(4)   #TQC-C80138 add
  DEFINE warea_name LIKE oab_file.oab02,          #No.FUN-680122CHAR(10)  #TQC-C80138 add
    sr  RECORD
        ima12  LIKE ima_file.ima12,
        ima01  LIKE ima_file.ima01,
        oeb908 like oeb_file.oeb908,
        ima02  LIKE ima_file.ima02,
        ima06  LIKE ima_file.ima06,
        ima131 LIKE ima_file.ima131,
        tlfccost LIKE tlfc_file.tlfccost,   #No.FUN-7C0101 add
        tlf02  LIKE tlf_file.tlf02,
        tlf14  LIKE tlf_file.tlf14,      #No.MOD-8C0092 add
        tlf021 LIKE tlf_file.tlf021,
        tlf03  LIKE tlf_file.tlf03,
        tlf031 LIKE tlf_file.tlf031,
        tlf06  LIKE tlf_file.tlf06,
        tlf026 LIKE tlf_file.tlf026,
        tlf027 LIKE tlf_file.tlf027,
        tlf036 LIKE tlf_file.tlf036,
        tlf037 LIKE tlf_file.tlf037,
        tlf01  LIKE tlf_file.tlf01,
        tlf10  LIKE tlf_file.tlf10,
        tlfc21  LIKE tlfc_file.tlfc21,    #No.FUN-7C0101
        tlf13  LIKE tlf_file.tlf13,
        tlf905  LIKE tlf_file.tlf905,
        tlf906  LIKE tlf_file.tlf906,
        tlf19   LIKE tlf_file.tlf19 , #FUN-680017
        tlf66   LIKE tlf_file.tlf66,  #No:CHI-A70023 add
        tlf907 LIKE tlf_file.tlf907,
        tlf902 LIKE tlf_file.tlf902,   #CHI-A70023 add
        tlf903 LIKE tlf_file.tlf903,   #CHI-A70023 add
        tlf904 LIKE tlf_file.tlf904,   #CHI-A70023 add
        amt01  LIKE tlfc_file.tlfc221,    #材料金額      #No.FUN-7C0101 
        amt02  LIKE tlfc_file.tlfc222,    #人工金額      #No.FUN-7C0101
        amt03  LIKE tlfc_file.tlfc2231,   #製造費用      #No.FUN-7C0101
        amt_d  LIKE tlfc_file.tlfc2232,   #委外加工費    #No.FUN-7C0101
        amt05  LIKE tlfc_file.tlfc224,    #No.FUN-7C0101 add
        amt06  LIKE tlfc_file.tlfc2241,   #No.FUN-7C0101 add
        amt07  LIKE tlfc_file.tlfc2242,   #No.FUN-7C0101 add
        amt08  LIKE tlfc_file.tlfc2243,   #No.FUN-7C0101 add
        amt04  LIKE ccc_file.ccc23  ,   #總金額
      #  wsaleamt  LIKE ima_file.ima26           #No.FUN-680122decimal( 15,3)#FUN-A20044
        wsaleamt  LIKE type_file.num15_3           #No.FUN-680122decimal( 15,3)#FUN-A20044
          END RECORD
   DEFINE wtlf01  LIKE ahe_file.ahe01           #No.FUN-680122CHAR(3)
   DEFINE l_tlf905 LIKE tlf_file.tlf905       #MOD-710150 mod
   DEFINE l_tlf906 LIKE tlf_file.tlf906       #MOD-710150 mod
   DEFINE l_tlf905_1 LIKE tlf_file.tlf905       #No:TQC-A60085 add
   DEFINE l_tlf906_1 LIKE tlf_file.tlf906       #No:TQC-A60085 add
 
   DEFINE l_wsale_tlf21 LIKE tlf_file.tlf21
   DEFINE wocc02        LIKE occ_file.occ02
   DEFINE wticket       LIKE oma_file.oma33
   DEFINE l_i           LIKE type_file.num5                 #No.FUN-8A0065 SMALLINT
   DEFINE l_cnt         LIKE type_file.num5                 #No.MOD-8C0092 add
   DEFINE l_dbs         LIKE azp_file.azp03                 #No.FUN-8A0065
   DEFINE l_azp03       LIKE azp_file.azp03                 #No.FUN-8A0065
   DEFINE l_occ37       LIKE occ_file.occ37                 #No.FUN-8A0065
   DEFINE i             LIKE type_file.num5                 #No.FUN-8A0065   
   DEFINE l_oma00       LIKE oma_file.oma00                 #No:TQC-A60085
   DEFINE l_omb16       LIKE omb_file.omb16                 #No:TQC-A60085
   DEFINE l_omb38       LIKE omb_file.omb38                 #No:TQC-A60085
   DEFINE l_saleamt     LIKE omb_file.omb16                 #No:TQC-A60085
   DEFINE l_oct12       LIKE oct_file.oct12                 #No:FUN-9B0017
   DEFINE l_oct14       LIKE oct_file.oct14                 #No:FUN-9B0017
   DEFINE l_oct15       LIKE oct_file.oct15                 #No:FUN-9B0017
   DEFINE l_byear       LIKE type_file.num5                 #No:FUN-9B0017
   DEFINE l_bmonth      LIKE type_file.num5                 #No:FUN-9B0017
   DEFINE l_bdate       LIKE type_file.num10                #No:FUN-9B0017
   DEFINE l_eyear       LIKE type_file.num5                 #No:FUN-9B0017
   DEFINE l_emonth      LIKE type_file.num5                 #No:FUN-9B0017
   DEFINE l_edate       LIKE type_file.num10                #No:FUN-9B0017
   DEFINE l_flag        LIKE type_file.chr1                 #MOD-B10194 add
   DEFINE l_azf08       LIKE azf_file.azf08                 #FUN-C10015
   DEFINE l_sql1     STRING                                 #No.FUN-CB0031
   DEFINE l_oga09       LIKE oha_file.oha09                 #No.MOD-CB0253
   DEFINE l_oga01       LIKE oga_file.oga01 #suncx 130926
    
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> *** ##
   CALL cl_del_data(l_table)
     SELECT * INTO g_oaz.* FROM oaz_file     #No.FUN-CB0031 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axcr761'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
     CASE tm.g
        WHEN '2'
           LET g_len= 218
        WHEN '3'
           LET g_len= 211
     END CASE
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     FOR g_i = 1 TO g_len LET g_dash2[g_i,g_i] = '-' END FOR
     
#FUN-A70084--mod-str--
#  FOR i = 1 TO 8 LET m_dbs[i] = NULL END FOR
#  LET m_dbs[1]=tm.p1
#  LET m_dbs[2]=tm.p2
#  LET m_dbs[3]=tm.p3
#  LET m_dbs[4]=tm.p4
#  LET m_dbs[5]=tm.p5
#  LET m_dbs[6]=tm.p6
#  LET m_dbs[7]=tm.p7
#  LET m_dbs[8]=tm.p8
   FOR i = 1 TO 8 LET m_plant[i] = NULL END FOR
   LET m_plant[1]=tm.p1
   LET m_plant[2]=tm.p2
   LET m_plant[3]=tm.p3
   LET m_plant[4]=tm.p4
   LET m_plant[5]=tm.p5
   LET m_plant[6]=tm.p6
   LET m_plant[7]=tm.p7
   LET m_plant[8]=tm.p8
#FUN-A70084--mod--end
 
   FOR l_i = 1 to 8                                                          #FUN-8A0065
      #FUN-A70084--mod--str--
      #IF cl_null(m_dbs[l_i]) THEN CONTINUE FOR END IF                       #FUN-8A0065
      #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=m_dbs[l_i]          #FUN-8A0065
      #LET l_azp03 = l_dbs CLIPPED                                           #FUN-8A0065
      #LET l_dbs = s_dbstring(l_dbs CLIPPED)                                         #FUN-8A0065     
       IF cl_null(m_plant[l_i]) THEN CONTINUE FOR END IF  
       CALL r761_set_entry() RETURNING l_cnt
       IF l_cnt>1 THEN LET m_plant[1] = g_plant END IF   #Single DB 
      #FUN-A70084--mod--end
     
#No.FUN-CB0031 --begin
##Mark by FUN-660187
#     LET l_sql = "SELECT ima12,ima01,' ',ima02,ima06,ima131,tlfccost,",  #No.FUN-7C0101 add tlfccost
#                 "       tlf02,tlf14,tlf021,tlf03,tlf031,tlf06,tlf026,tlf027,",   #No.MOD-8C0092 add tlf14
#                 "       tlf036,tlf037,tlf01,tlf10*tlf60,tlfc21,tlf13,tlf905,tlf906,", #MOD-570079  #No.FUN-7C0101 tlf21->tlfc21
#                 "       tlf19,tlf66,tlf907,tlf902,tlf903,tlf904,tlfc221,tlfc222,tlfc2231,tlfc2232,tlfc224,tlfc2241,tlfc2242,tlfc2243,0,0", #No.FUN-7C0101  #MOD-C30859 add 0(for wsaleamt) #CHI-A70023 tlf66,tlf902,tlf903,tlf904
#                 "       ,azf08",   #FUN-C10015
##FUN-A10098---BEGIN
##                 "  FROM ",l_dbs CLIPPED,"ima_file,",l_dbs CLIPPED,"tlf_file ",         #FUN-8A0065
##"  LEFT OUTER JOIN ",l_dbs CLIPPED,"tlfc_file ON tlfc01 = tlf01  AND tlfc06 = tlf06  AND tlfc02 = tlf02  AND tlfc03 = tlf03 AND ",
#                 "  FROM ",cl_get_target_table(m_plant[l_i],'ima_file'),",",cl_get_target_table(m_plant[l_i],'tlf_file'),     #FUN-A70084 m_dbs-->m_plant
#                 "  LEFT OUTER JOIN ",cl_get_target_table(m_plant[l_i],'azf_file')," ON tlf14=azf01 AND azf02='2' ",   #FUN-C10015
#"  LEFT OUTER JOIN ",cl_get_target_table(m_plant[l_i],'tlfc_file')," ON tlfc01 = tlf01  AND tlfc06 = tlf06  AND tlfc02 = tlf02  AND tlfc03 = tlf03 AND ",   #FUN-A70084 m_dbs-->m_plant
##FUN-A10098---BEGIN
#"                                                tlfc13 = tlf13  AND tlfc902= tlf902 AND tlfc903= tlf903 AND ",
#"                                                tlfc904= tlf904 AND tlfc907= tlf907 AND ",
#"                                                tlfc905= tlf905 AND tlfc906= tlf906 AND ",
#"                                                tlfctype = '",tm.type,"'",
#                 " WHERE ima01 = tlf01",
#                 "   AND (tlf13 LIKE 'axmt%' OR tlf13 LIKE 'aomt%')",
#                 "   AND ",tm.wc CLIPPED,
##                 "   AND tlf902 not in (SELECT jce02 from ",l_dbs CLIPPED,"jce_file)",  #FUN-A10098  #FUN-8A0065 Add ",l_dbs CLIPPED,"
#                 "   AND tlf902 not in (SELECT jce02 from ",cl_get_target_table(m_plant[l_i],'jce_file'),")",  #FUN-A10098   #FUN-A70084 m_dbs-->m_plant 
#                 "   AND (tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')",
#                 "   ORDER BY ima01,tlf905,tlf906 "                 #No.MOD-780262 add
##

     LET l_sql = "SELECT DISTINCT ima12,ima01,' ',ima02,ima06,ima131,tlfccost,", 
                 "       tlf02,tlf14,tlf021,tlf03,tlf031,tlf06,tlf026,tlf027,",  
                 "       tlf036,tlf037,tlf01,tlf10*tlf60,tlfc21,tlf13,tlf905,tlf906,", 
                 "       tlf19,tlf66,tlf907,tlf902,tlf903,tlf904,tlfc221,tlfc222,tlfc2231,tlfc2232,tlfc224,tlfc2241,tlfc2242,tlfc2243,0,0",   #CHI-A70023 tlf66,tlf902,tlf903,tlf904
                 "       ,azf08",   
                 "  FROM ",cl_get_target_table(m_plant[l_i],'ima_file'),",",cl_get_target_table(m_plant[l_i],'tlf_file'),   
                 "  LEFT OUTER JOIN ",cl_get_target_table(m_plant[l_i],'azf_file')," ON tlf14=azf01 AND azf02='2' ",  
                 "  LEFT OUTER JOIN ",cl_get_target_table(m_plant[l_i],'tlfc_file')," ON tlfc01 = tlf01  AND tlfc06 = tlf06  AND tlfc02 = tlf02  AND tlfc03 = tlf03 AND ",  
                 "                                                tlfc13 = tlf13  AND tlfc902= tlf902 AND tlfc903= tlf903 AND ",
                 "                                                tlfc904= tlf904 AND tlfc907= tlf907 AND ",
                 "                                                tlfc905= tlf905 AND tlfc906= tlf906 AND ",
                 "                                                tlfctype = '",tm.type,"'"

     LET l_sql1= " WHERE ima01 = tlf01",
                 "   AND (tlf13 LIKE 'axmt%' OR tlf13 LIKE 'aomt%' OR tlf99 IS NOT NULL )",
                 "   AND ",tm.wc CLIPPED,
                 "   AND tlf902 not in (SELECT jce02 from ",cl_get_target_table(m_plant[l_i],'jce_file'),")", 
                 "   AND (tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')"  

     LET l_sql = l_sql,l_sql1,"   ORDER BY ima01,tlf905,tlf906 "                  
#No.FUN-CB0031 --end


 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098   #FUN-A70084
    #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
     PREPARE axcr761_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE axcr761_curs1 CURSOR FOR axcr761_prepare1
 
     LET g_pageno = 0
     FOREACH axcr761_curs1 INTO sr.*,l_azf08  #FUN-C10015      
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET l_oga00 = NULL
       LET l_oga65 = NULL   #MOD-C30566 add
       IF sr.tlf13 MATCHES 'axmt*' THEN
          SELECT omf11 INTO l_oga01 FROM omf_file WHERE omf00=sr.tlf905 AND omf21=sr.tlf906
          IF cl_null(l_oga01) THEN LET l_oga01 = sr.tlf905 END IF
          SELECT oga00,oga09,oga65 INTO l_oga00,l_oga09,l_oga65 FROM oga_file WHERE oga01=l_oga01  #MOD-B80086 add oga65   MOD-CB0253 add oga09
          #IF l_oga00 = '3' OR l_oga00 ='A' OR l_oga00 = '7' OR l_oga65 = 'Y' OR l_oga09 ='9' THEN     #No.MOD-950210 modify  #MOD-B80086 add oga65  MOD-CB0253 add oga09  #MOD-D40123
          IF l_oga00 = '3' OR l_oga00 ='A' OR l_oga00 = '7' OR l_oga65 = 'Y' THEN  #MOD-D40123
             CONTINUE FOREACH
          END IF
       END IF
       #FUN-C10015---begin mark
       #IF NOT cl_null(sr.tlf14) THEN
       #   LET l_cnt = 0 
       ##   LET l_sql = "SELECT COUNT(*) FROM ",l_dbs CLIPPED,"azf_file",   #FUN-A10098
       #   LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(m_plant[l_i],'azf_file'),   #FUN-A10098  #FUN-A70084 m_dbs-->m_plant
       #               "   WHERE azf01 ='", sr.tlf14 CLIPPED,"'",
       #               "     AND azf02 = '2' ",
       #               "     AND azf08 = 'Y' "
 	   #  CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       #  #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098  #FUN-A70084
       #  #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
       #   PREPARE r761_azf FROM l_sql
       #   EXECUTE r761_azf INTO l_cnt
       #   IF STATUS THEN 
       #     CALL cl_err('sel azf',STATUS,1) 
       #     EXIT FOREACH 
       #   ELSE 
       #     IF l_cnt > 0 THEN CONTINUE FOREACH END IF
       #   END IF
       #END IF
       #FUN-C10015---end
       #FUN-C10015---begin
       IF cl_null(l_azf08) THEN LET l_azf08='N' END IF   
#CHI-C50069---mark---START
#      IF tm.d='N' THEN
#         IF l_azf08='Y' THEN CONTINUE FOREACH END IF
#      ELSE
#         IF l_azf08='N' THEN CONTINUE FOREACH END IF
#      END IF
#      #FUN-C10015---end
#CHI-C50069---mark-----END

#CHI-C50069---add---START
       CASE tm.d
         WHEN '1'
           IF l_azf08='Y' THEN CONTINUE FOREACH END IF
         WHEN '2'
           IF l_azf08='N' THEN CONTINUE FOREACH END IF
       END CASE
#CHI-C50069---add-----END
       IF  cl_null(sr.amt01)  THEN LET sr.amt01=0 END IF
       IF  cl_null(sr.amt01)  THEN LET sr.amt01=0 END IF
       IF  cl_null(sr.amt02)  THEN LET sr.amt02=0 END IF
       IF  cl_null(sr.amt03)  THEN LET sr.amt03=0 END IF
       IF  cl_null(sr.tlfc21)  THEN LET sr.tlfc21=0 END IF #No.FUN-7C0101
       IF  cl_null(sr.amt_d)  THEN LET sr.amt_d=0 END IF   #No.FUN-7C0101 add
       IF  cl_null(sr.amt04)  THEN LET sr.amt04=0 END IF   #No.FUN-7C0101 add
       IF  cl_null(sr.amt05)  THEN LET sr.amt05=0 END IF   #No.FUN-7C0101 add
       IF  cl_null(sr.amt06)  THEN LET sr.amt06=0 END IF   #No.FUN-7C0101 add
       IF  cl_null(sr.amt07)  THEN LET sr.amt07=0 END IF   #No.FUN-7C0101 add
       IF  cl_null(sr.amt08)  THEN LET sr.amt08=0 END IF   #No.FUN-7C0101 add
       #-->退料時為正值
       IF sr.tlf907 = 1 THEN
          LET sr.tlf02  = sr.tlf03
          LET sr.tlf021 = sr.tlf031
          LET sr.tlf026 = sr.tlf036
       ELSE
          LET sr.tlf10= sr.tlf10 * -1
          LET sr.amt01= sr.amt01 * -1
          LET sr.amt02= sr.amt02 * -1
          LET sr.amt03= sr.amt03 * -1
          LET sr.amt_d= sr.amt_d * -1
          LET sr.amt05= sr.amt05 * -1   #No.FUN-7C0101 add
          LET sr.amt06= sr.amt07 * -1   #No.FUN-7C0101 add
          LET sr.amt07= sr.amt07 * -1   #No.FUN-7C0101 add
          LET sr.amt08= sr.amt08 * -1   #No.FUN-7C0101 add
       END IF
       LET sr.amt04 = sr.amt01 + sr.amt02 + sr.amt03 + sr.amt_d
       IF  cl_null(sr.amt04)  THEN LET sr.amt01=0 END IF
       LET sr.wsaleamt = 0
      #IF (sr.tlf905 <> l_tlf905 OR sr.tlf906 <> l_tlf906) THEN   #MOD-710150 mod  #No:CHI-A70023 mark
       IF (sr.tlf905 <> l_tlf905 OR sr.tlf906 <> l_tlf906 OR sr.tlf66 = 'X') AND (l_oga09 <> '9' OR cl_null(l_oga09)) THEN  #No:CHI-A70023 add  #MOD-D40123 #MOD-D90159 add cl_null(l_oga09)

       #------------------No:CHI-A70023 add
        IF sr.tlf66 = 'X' THEN
           CALL s_ogc_amt_1(sr.tlf01,sr.tlf905,sr.tlf906,sr.tlf902,sr.tlf903,sr.tlf904,l_dbs) RETURNING sr.wsaleamt  
           LET l_flag = 'Y'     #MOD-C60108 add
        ELSE
       #------------------No:CHI-A70023 end

#No.FUN-CB0031 --begin
#TQC-A60085 mod --str
#          LET l_sql = "SELECT SUM(omb16) ",      #TQC-A60085 mark
#           LET l_sql = "SELECT oma00,omb16,omb38 ",
##TQC-A60085 mod --end                                                                        
#               #       "  FROM ",l_dbs CLIPPED,"oma_file,",  #FUN-A10098                                                                          
#               #                 l_dbs CLIPPED,"omb_file ",  #FUN-A10098
#                      "  FROM ",cl_get_target_table(m_plant[l_i],'oma_file'),",",  #FUN-A10098   #FUN-A70084 m_dbs-->m_plant
#                                cl_get_target_table(m_plant[l_i],'omb_file'),  #FUN-A10098   #FUN-A70084 m_dbs-->m_plant
#                      " WHERE omb31 = '",sr.tlf905,"'",
#                      "   AND omb32 = '",sr.tlf906,"'",
#                      "   AND oma01=omb01 AND (oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')",   
#                      "   AND omaconf = 'Y' AND omavoid != 'Y'"                                                                                                                                                                                   



           LET l_sql = "SELECT oma00,omb16,omb38 ",
                      "  FROM ",cl_get_target_table(m_plant[l_i],'oma_file'),",", 
                                cl_get_target_table(m_plant[l_i],'omb_file')
           IF sr.tlf13 = 'axmt670' THEN 
           	  LET l_sql  = l_sql,",",cl_get_target_table(m_plant[l_i],'omf_file') 
              LET l_sql1 = " WHERE omf00 = '",sr.tlf905,"'",
                           "   AND omf21 = '",sr.tlf906,"'",
                           "   AND omb31 = omf11",
                           "   AND omb32 = omf12",
                           "   AND oma01 = omf04",
                           "   AND oma01=omb01 AND (oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')",   
                           "   AND omaconf = 'Y' AND omavoid != 'Y'"  
           ELSE 
              LET l_sql1 = " WHERE omb31 = '",sr.tlf905,"'",
                           "   AND omb32 = '",sr.tlf906,"'",
                           "   AND oma01=omb01 AND (oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')",   
                           "   AND omaconf = 'Y' AND omavoid != 'Y'"  
           END IF 
           LET l_sql = l_sql,l_sql1
#No.FUN-CB0031 --end

 	      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098   #FUN-A70084 
         #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
          PREPARE r761_prepare3 FROM l_sql                                                                                          
          DECLARE r761_c3  CURSOR FOR r761_prepare3                                                                                 
#TQC-A60085 mod --str
          #OPEN r761_c3                                                                                    
          #FETCH r761_c3 INTO sr.wsaleamt
          LET l_saleamt = 0
          LET l_flag = 'N'           #MOD-B10194 add
          FOREACH r761_c3 INTO l_oma00,l_omb16,l_omb38
             IF cl_null(l_omb16) THEN LET l_omb16 = 0 END IF
             IF l_oma00 MATCHES '1*' AND l_omb38 = '3' THEN
               #FUN-9B0017   ---start
                IF sr.tlf907='1' THEN  #銷退
                  #總遞延收入
                   SELECT oct12 INTO l_oct12 FROM oct_file						
                    WHERE oct04 = sr.tlf905 AND oct05 =sr.tlf906						
		              AND oct16 = '3'							
                      AND oct00 = '0'  #FUN-A60007
                   IF cl_null(l_oct12) THEN LET l_oct12 = 0 END IF						
                  #每期折讓金額
                   LET l_byear=YEAR(tm.bdate)
                   LET l_bmonth=MONTH(tm.bdate)
                   LET l_bdate=(l_byear*12)+l_bmonth
                   LET l_eyear=YEAR(tm.edate)
                   LET l_emonth=MONTH(tm.edate)
                   LET l_edate=(l_eyear*12)+l_emonth 								
                   SELECT SUM(oct15) INTO l_oct15 FROM oct_file						
                    WHERE oct04 = sr.tlf905 AND oct05=sr.tlf906						
		              AND oct16 = '4'	
                      AND (oct09*12)+oct10 BETWEEN l_bdate AND l_edate						
                      AND oct00 = '0'  #FUN-A60007
                   IF cl_null(l_oct15) THEN LET l_oct15 = 0 END IF						
                  #退貨時要將原本銷貨收入 + 總遞延收入 - 每期折讓金額
                   LET l_saleamt = l_saleamt + (l_omb16 * -1)
                   LET l_saleamt = l_saleamt  - l_oct12 + l_oct15						
                ELSE #出貨
                  #總遞延收入
                   SELECT oct12 INTO l_oct12 FROM oct_file                                                                             
                    WHERE oct04 = sr.tlf905 AND oct05 =sr.tlf906                                                                       
                      AND oct16 = '1'                                                                                                  
                      AND oct00 = '0'  #FUN-A60007
                   IF cl_null(l_oct12) THEN LET l_oct12 = 0 END IF                                                                     
                  #每期遞延收入
                   LET l_byear=YEAR(tm.bdate)                                                                                          
                   LET l_bmonth=MONTH(tm.bdate)                                                                                        
                   LET l_bdate=(l_byear*12)+l_bmonth                                                                                   
                   LET l_eyear=YEAR(tm.edate)                                                                                          
                   LET l_emonth=MONTH(tm.edate)                                                                                        
                   LET l_edate=(l_eyear*12)+l_emonth                                                                                   
                   SELECT SUM(oct14) INTO l_oct14 FROM oct_file                                                                        
                    WHERE oct04 = sr.tlf905 AND oct05 =sr.tlf906                                                                       
                      AND oct16 = '2'                                                                                                  
                      AND (oct09*12)+oct10 BETWEEN l_bdate AND l_edate                                                                 
                      AND oct00 = '0'  #FUN-A60007
                   IF cl_null(l_oct14) THEN LET l_oct14 = 0 END IF                                                                     
                  #銷貨時要將原本銷貨收入 - 總遞延收入 + 每期折讓金額
                   LET l_saleamt = l_saleamt + (l_omb16 * -1)
                   LET l_saleamt = l_saleamt  - l_oct12 + l_oct14   
                END IF  
               #FUN-9B0017   ---end 
                #LET l_saleamt = l_saleamt + (l_omb16 * -1)  #FUN-9B0017 mark
             ELSE
               #FUN-9B0017   ---start
                IF sr.tlf907='1' THEN  #銷退
                  #總遞延收入
                   SELECT oct12 INTO l_oct12 FROM oct_file                                                                          
                    WHERE oct06 = sr.tlf905 AND oct07 =sr.tlf906                                                                    
                      AND oct16 = '3'                                                                                               
                      AND oct00 = '0'  #FUN-A60007
                   IF cl_null(l_oct12) THEN LET l_oct12 = 0 END IF                                                                  
                  #每期折讓金額
                   LET l_byear=YEAR(tm.bdate)                                                                                       
                   LET l_bmonth=MONTH(tm.bdate)                                                                                     
                   LET l_bdate=(l_byear*12)+l_bmonth                                                                                
                   LET l_eyear=YEAR(tm.edate)                                                                                       
                   LET l_emonth=MONTH(tm.edate)                                                                                     
                   LET l_edate=(l_eyear*12)+l_emonth                                                                                
                   SELECT SUM(oct15) INTO l_oct15 FROM oct_file                                                                     
                    WHERE oct06 = sr.tlf905 AND oct07=sr.tlf906                                                                     
                      AND oct16 = '4'                                                                                               
                      AND (oct09*12)+oct10 BETWEEN l_bdate AND l_edate                                                              
                      AND oct00 = '0'  #FUN-A60007
                   IF cl_null(l_oct15) THEN LET l_oct15 = 0 END IF                                                                  
                  #退貨時要將原本銷貨收入 + 總遞延收入 - 每期折讓金額
                   LET l_saleamt = l_saleamt + l_omb16 
                   LET l_saleamt = l_saleamt - l_oct12 - l_oct15                                                                   
                ELSE #出貨
                  #總遞延收入
                   SELECT oct12 INTO l_oct12 FROM oct_file						
                    WHERE oct04 = sr.tlf905 AND oct05 =sr.tlf906						
		      AND oct16 = '1'							
                      AND oct00 = '0'  #FUN-A60007
                   IF cl_null(l_oct12) THEN LET l_oct12 = 0 END IF						
                  #每期遞延收入
                   LET l_byear=YEAR(tm.bdate)                                                                                          
                   LET l_bmonth=MONTH(tm.bdate)                                                                                        
                   LET l_bdate=(l_byear*12)+l_bmonth                                                                                   
                   LET l_eyear=YEAR(tm.edate)                                                                                          
                   LET l_emonth=MONTH(tm.edate)                                                                                        
                   LET l_edate=(l_eyear*12)+l_emonth    
                   SELECT SUM(oct14) INTO l_oct14 FROM oct_file						
                    WHERE oct04 = sr.tlf905 AND oct05 =sr.tlf906						
     	              AND oct16 = '2'
                      AND (oct09*12)+oct10 BETWEEN l_bdate AND l_edate     							
                      AND oct00 = '0'  #FUN-A60007
                   IF cl_null(l_oct14) THEN LET l_oct14 = 0 END IF						
                  #銷貨時要將原本銷貨收入-總遞延收入+每期遞延收入
                   LET l_saleamt = l_saleamt + l_omb16 
                   LET l_saleamt = l_saleamt  - l_oct12 + l_oct14						
                END IF   
               #FUN-9B0017   ---end 
               #LET l_saleamt = l_saleamt + l_omb16  #FUN-9B0017
             END IF
             LET l_flag = 'Y'           #MOD-B10194 add
          END FOREACH
          LET sr.wsaleamt = l_saleamt
       END IF    #No:CHI-A70023 add   
#No.MOD-D50185 --begin        
         #MOD-B10194---add---start---
#          IF l_flag = 'N' THEN
#            #-----MOD-C20005---------
#            IF sr.tlf13[1,4] = 'aomt' THEN 
#               SELECT (ohb14*oha24) INTO sr.wsaleamt 
#                 FROM oha_file,ohb_file
#                WHERE oha01 = ohb01 AND oha01 = sr.tlf905
#                  AND ohb03 = sr.tlf906
#            ELSE
#            #-----END MOD-C20005-----
#               SELECT (ogb14*oga24) INTO sr.wsaleamt 
#                 FROM oga_file,ogb_file
#                WHERE oga01 = ogb01 AND oga01 = sr.tlf905
#                  AND ogb03 = sr.tlf906
#                  AND oga00!='2'          #MOD-B70215 add
#            END IF   #MOD-C20005
#          END IF
         #MOD-B10194---add---end---
         #MOD-D90159 mark begin-------------------------
         #IF sr.tlf13 = 'axmt670' THEN    #No.MOD-D80134
         #   SELECT SUM(omf19) INTO sr.wsaleamt
         #     FROM omf_file
         #     WHERE omf00 = sr.tlf905 
         #      AND omf21 = sr.tlf906  
         #      AND omf08 = 'Y' 
         #      AND omf03 BETWEEN tm.bdate AND tm.edate
         #END IF                          #No.MOD-D80134
         #MOD-D90159 mark end---------------------------
#No.MOD-D50185 --end
#TQC-A60085 mod --end
          IF  cl_null(sr.wsaleamt)  THEN LET sr.wsaleamt=0 END IF
          #MOD-D20121
          IF sr.tlf907 = 1 then
             LET sr.wsaleamt = sr.wsaleamt * -1  
          END IF
          #MOD-D20121
         #MOD-D90159 add begin-------------------------
          IF sr.tlf13 = 'axmt670' THEN    #No.MOD-D80134
             SELECT SUM(omf19) INTO sr.wsaleamt
               FROM omf_file
              WHERE omf00 = sr.tlf905
                AND omf21 = sr.tlf906
                AND omf08 = 'Y'
                AND omf03 BETWEEN tm.bdate AND tm.edate
          END IF                          #No.MOD-D80134
          IF  cl_null(sr.wsaleamt)  THEN LET sr.wsaleamt=0 END IF
         #MOD-D90159 add end---------------------------
         
        ## 保留舊值                   #MOD-710150 mod
          LET l_tlf905 = sr.tlf905    #MOD-710150 mod
          LET l_tlf906 = sr.tlf906    #MOD-710150 mod
       END IF                         #MOD-710150 mod                       
      CASE tm.g
        WHEN '1'
           LET sr.tlf10= sr.tlf10 * -1
           IF  sr.tlf907 = 1 then
               let  sr.tlfc21    = sr.tlfc21 * -1  #No.FUN-7C0101
               #let  sr.wsaleamt = sr.wsaleamt * -1  #MOD-D20121
           END IF
       #    LET l_sql = "SELECT oeb908 from ",l_dbs CLIPPED,"oeb_file",    #FUN-8A0065  #FUN-A10098
           LET l_sql = "SELECT oeb908 from ",cl_get_target_table(m_plant[l_i],'oeb_file'),  #FUN-A10098 #FUN-A70084 m_dbs-->m_plant
                       " WHERE oeb04 = '",sr.tlf01,"'"                    #FUN-8A0065
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-A50102
          #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098   #FUN-A70084
          #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
           PREPARE oeb908_prepare3 FROM l_sql                             #FUN-8A0065
           DECLARE oeb908_cur CURSOR FOR oeb908_prepare3                  #FUN-8A0065
           foreach oeb908_cur into sr.oeb908
             exit foreach
           end foreach
        WHEN '2'
           LET g_len= 218                    #FUN-5B0123
          #MOD-A80106---mark---start---
          #LET sr.tlf10= sr.tlf10 * -1
          #IF sr.tlf907 = 1 then
          #   let  sr.tlfc21    = sr.tlfc21 * -1  #No.FUN-7C0101
          #   let  sr.wsaleamt = sr.wsaleamt * -1
          #END IF
          #MOD-A80106---mark---end---
          #No.MOD-C20181  --Begin
          IF g_aza.aza26 = '2' THEN
             LET sr.tlf10= sr.tlf10 * -1
          END IF
          #No.MOD-C20181  --End
          #MOD-D20121---begin
          IF sr.tlf907 = 1 THEN
             LET sr.tlfc21 = sr.tlfc21 * -1
          END IF
          #MOD-D20121---end
#TQC-A60085 add --str
        #------------------No:CHI-A70023 modify
        # IF (sr.tlf905 <> l_tlf905_1 OR sr.tlf906 <> l_tlf906_1) THEN
        #    IF sr.tlf907 = 1 then
        #       LET  sr.wsaleamt = sr.wsaleamt * -1
        #    END IF
        #    SELECT SUM(tlfc21*tlfc907*-1) INTO sr.tlfc21 FROM tlfc_file
        #           WHERE tlfc01 = sr.ima01
        #             AND tlfc905 = sr.tlf905
        #             AND tlfc906 = sr.tlf906
        #             AND (tlfc06 BETWEEN tm.bdate AND tm.edate)
        #    IF cl_null(sr.tlfc21) THEN LET sr.tlfc21 = 0 END IF
        #    LET l_tlf905_1 = sr.tlf905
        #    LET l_tlf906_1 = sr.tlf906
        #  ELSE
        #     LET sr.tlfc21 = 0
        #     LET sr.wsaleamt = 0
        #  END IF
        #------------------No:CHI-A70023 modify end    
#TQC-A60085 add --end

        WHEN '3'
           LET g_len= 211                    #FUN-5B0123
           LET sr.tlf10= sr.tlf10 * -1
           #MOD-D20121---begin
           IF sr.tlf907 = 1 THEN
              LET sr.tlfc21 = sr.tlfc21 * -1
           END IF
           #MOD-D20121---end
          #MOD-A80106---mark---start---
          #IF sr.tlf907 = 1 then
          #   let  sr.tlfc21    = sr.tlfc21 * -1  #No.FUN-7C0101
          #   let  sr.wsaleamt = sr.wsaleamt * -1
          #END IF
          #MOD-A80106---mark---end---
#TQC-A60085 add --str
      #------------------No:CHI-A70023 modify
      #   IF (sr.tlf905 <> l_tlf905_1 OR sr.tlf906 <> l_tlf906_1) THEN
      #      IF sr.tlf907 = 1 then
      #         LET  sr.wsaleamt = sr.wsaleamt * -1
      #      END IF
      #      SELECT SUM(tlfc21*tlfc907*-1) INTO sr.tlfc21 FROM tlfc_file
      #             WHERE tlfc01 = sr.ima01
      #               AND tlfc905 = sr.tlf905
      #               AND tlfc906 = sr.tlf906
      #               AND (tlfc06 BETWEEN tm.bdate AND tm.edate)
      #      IF cl_null(sr.tlfc21) THEN LET sr.tlfc21 = 0 END IF
      #      LET l_tlf905_1 = sr.tlf905
      #      LET l_tlf906_1 = sr.tlf906
      #    ELSE
      #       LET sr.tlfc21 = 0
      #       LET sr.wsaleamt = 0
      #    END IF
      #------------------No:CHI-A70023 modify end      
#TQC-A60085 add --end
           IF sr.tlf13[1,4] = 'aomt' THEN
              LET l_sql = "SELECT oha25 ",
                     #     "  FROM ",l_dbs CLIPPED,"oha_file",  #FUN-A10098
                          "  FROM ",cl_get_target_table(m_plant[l_i],'oha_file'),  #FUN-A10098   #FUN-A70084 m_dbs-->m_plant
                          " WHERE oha01 = '",sr.tlf905,"'"
           ELSE
              LET l_sql = "SELECT oga25 ",
                     #     "  FROM ",l_dbs CLIPPED,"oga_file",   #FUN-A10098
                          "  FROM ",cl_get_target_table(m_plant[l_i],'oga_file'),   #FUN-A10098  #FUN-A70084 m_dbs-->m_plant
                          " WHERE oga01 = '",sr.tlf905,"'",
                          "   AND oga00 NOT IN ('A','3','7') "    #No.MOD-950210 modify
           END IF
 	       CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
          #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098  #FUN-A70084 
          #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
           PREPARE oga25_prepare3 FROM l_sql                                                                                          
           DECLARE oga25_c3  CURSOR FOR oga25_prepare3                                                                                 
           OPEN oga25_c3                                                                                    
           FETCH oga25_c3 INTO warea                                                   
           LET l_sql = "SELECT oab02 ",                                                                              
                  #     "  FROM ",l_dbs CLIPPED,"oab_file",      #FUN-A10098                                                                    
                       "  FROM ",cl_get_target_table(m_plant[l_i],'oab_file'),      #FUN-A10098   #FUN-A70084 m_dbs-->m_plant                                                                 
                       " WHERE oab01 = '",warea,"'"                                                                                                                                                                              
 	       CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
          #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098  #FUN-A70084
          #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
           PREPARE oab02_prepare3 FROM l_sql                                                                                          
           DECLARE oab02_c3  CURSOR FOR oab02_prepare3                                                                                 
           OPEN oab02_c3                                                                                    
           FETCH oab02_c3 INTO warea_name           
      END CASE
 
      LET l_wsale_tlf21 = 0
      IF cl_null(sr.wsaleamt) THEN LET sr.wsaleamt = 0 END IF
      IF cl_null(sr.tlfc21)    THEN LET sr.tlfc21 = 0    END IF #No.FUN-7C0101
      LET l_wsale_tlf21 = sr.wsaleamt - sr.tlfc21               #No.FUN-7C0101
      CASE
         WHEN tm.g = '2' OR tm.g = '3'
            LET wocc02  = ' '
            LET wticket = ' '
            LET wima201 =  sr.tlf01
            LET l_sql = "SELECT occ02,occ37 ",                                                                              
                   #     "  FROM ",l_dbs CLIPPED,"occ_file",        #FUN-A10098                                                                   
                        "  FROM ",cl_get_target_table(m_plant[l_i],'occ_file'),        #FUN-A10098 #FUN-A70084 m_dbs-->m_plant                                                                  
                        " WHERE occ01= '",sr.tlf19,"'"                                                                                                                                                                              
 	        CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
           #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098   #FUN-A70084
           #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
            PREPARE occ_prepare3 FROM l_sql                                                                                          
            DECLARE occ_c3  CURSOR FOR occ_prepare3                                                                                 
            OPEN occ_c3                                                                                    
            FETCH occ_c3 INTO wocc02,l_occ37                      
            IF cl_null(l_occ37) THEN LET l_occ37 = 'N' END IF
            IF tm.type_1 = '1' THEN
               IF l_occ37  = 'N' THEN  CONTINUE FOREACH END IF
            END IF
            IF tm.type_1 = '2' THEN   #非關係人
               IF l_occ37  = 'Y' THEN  CONTINUE FOREACH END IF
            END IF           
 
            IF sr.tlf13[1,4] = 'aomt' THEN
               LET l_sql = "SELECT oma33 ",                                                                              
                 #        "  FROM ",l_dbs CLIPPED,"oma_file,",     #FUN-A10098                                                                     
                 #                  l_dbs CLIPPED,"oha_file ",     #FUN-A10098
                         "  FROM ",cl_get_target_table(m_plant[l_i],'oma_file'),     #FUN-A10098   #FUN-A70084
                                   cl_get_target_table(m_plant[l_i],'oha_file'),     #FUN-A10098   #FUN-A70084                                                                   
                           " WHERE oha01 = '",sr.tlf905,"'",
                           "   AND oha10 = oma01"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
              #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098  #FUN-A70084
              #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
               PREPARE oma33_prepare4 FROM l_sql                                                                                          
               DECLARE oma33_c4  CURSOR FOR oma33_prepare4                                                                                 
               OPEN oma33_c4                                                                                    
               FETCH oma33_c4 INTO wticket
            ELSE
               LET l_sql = "SELECT oma33 ",                                                                              
                     #    "  FROM ",l_dbs CLIPPED,"oma_file,",       #FUN-A10098                                                                   
                     #              l_dbs CLIPPED,"oga_file ",       #FUN-A10098
                         "  FROM ",cl_get_target_table(m_plant[l_i],'oma_file'),",",       #FUN-A10098   #FUN-A70084
                                   cl_get_target_table(m_plant[l_i],'oga_file'),       #FUN-A70084
                           " WHERE oga01 = '",sr.tlf905,"'",
                           "   AND oga10 = oma01",
                           "   AND oga00 NOT IN ('A','3','7') "   #No.MOD-950210 add
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
              #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098   #FUN-A70084
              #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
               PREPARE oma33_prepare3 FROM l_sql                                                                                          
               DECLARE oma33_c3  CURSOR FOR oma33_prepare3                                                                                 
               OPEN oma33_c3                                                                                    
               FETCH oma33_c3 INTO wticket
            END IF     #No.MOD-920042 add
      END CASE
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> *** ##
      EXECUTE insert_prep USING
         sr.ima12, sr.ima01, sr.ima02, sr.ima06,   sr.ima131,sr.tlfccost,  #No.FUN-7C0101 add sr.tlfccost
         sr.oeb908,sr.tlf02, sr.tlf021,sr.tlf03,   sr.tlf031,
         sr.tlf06, sr.tlf026,sr.tlf027,sr.tlf036,  sr.tlf037,
         sr.tlf01, sr.tlf10, sr.tlfc21, sr.tlf13,   sr.tlf905,  #No.FUN-7C0101 tlf21->tlfc21
         sr.tlf906,sr.tlf19, sr.tlf907,sr.amt01,   sr.amt02,
         sr.amt03, sr.amt_d, sr.amt05, sr.amt06,sr.amt07,sr.amt08,sr.amt04, sr.wsaleamt,warea_name,#No.FUN-7C0101 add amt06,7,8
         #wocc02,   wticket,  l_wsale_tlf21,g_ccz.ccz27,g_azi03, #CHI-C30012
         wocc02,   wticket,  l_wsale_tlf21,g_ccz.ccz27,g_ccz.ccz26, #CHI-C30012
         #g_azi04,  g_azi05,m_plant[l_i]                                    #FUN-8B0118 Add m_dbs[l_i]  #FUN-A70084 m_dbs--?m_plant #CHI-C30012
         g_ccz.ccz26,g_ccz.ccz26,m_plant[l_i]
 
     END FOREACH
   END FOR                                                                      #FUN-8A0065     
 
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     #是否列印選擇條件
     LET g_str = NULL
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'ima12,ima01,tlf905,tlf19,ima131')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     IF cl_null(tm.s[1,1]) THEN LET tm.s[1,1] = '0' END IF                 #FUN-8A0065
     IF cl_null(tm.s[2,2]) THEN LET tm.s[2,2] = '0' END IF                 #FUN-8A0065
     IF cl_null(tm.s[3,3]) THEN LET tm.s[3,3] = '0' END IF                 #FUN-8A0065     
     LET g_str = g_str,";",tm.bdate,";",tm.edate,';',tm.a,";",tm.type,";", #No.FUN-7C0101 add tm.type
                 tm.type_1,";",tm.s[1,1],";",tm.s[2,2],";",                #FUN-8A0065
                 tm.s[3,3],";",tm.t,";",tm.u,";",tm.b,";",                 #FUN-8A0065
                 tm.c    #FUN-C50127 add
                       
     CASE tm.g
        WHEN '1'
           IF tm.type MATCHES '[12]' THEN
              CALL cl_prt_cs3('axcr761','axcr761_1_1',l_sql,g_str)
           END IF
           IF tm.type MATCHES '[345]' THEN
              CALL cl_prt_cs3('axcr761','axcr761_1',l_sql,g_str)
           END IF
        WHEN '2'
           IF tm.type MATCHES '[12]' THEN
              CALL cl_prt_cs3('axcr761','axcr761_2_1',l_sql,g_str)
           END IF
           IF tm.type MATCHES '[345]' THEN
              CALL cl_prt_cs3('axcr761','axcr761_2',l_sql,g_str)
           END IF
        WHEN '3'
           IF tm.type MATCHES '[12]' THEN
              CALL cl_prt_cs3('axcr761','axcr761_3_1',l_sql,g_str) 
           END IF
           IF tm.type MATCHES '[345]' THEN
              CALL cl_prt_cs3('axcr761','axcr761_3',l_sql,g_str) 
           END IF
     END CASE
 
END FUNCTION
 
FUNCTION r761_set_entry_1()
    CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",TRUE)
    CALL cl_set_comp_entry("type_1",TRUE)
END FUNCTION
FUNCTION r761_set_no_entry_1()
    IF tm.b = 'N' THEN
       CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",FALSE)
       IF tm2.s1 = '6' THEN
          LET tm2.s1 = ' '
       END IF
       IF tm2.s2 = '6' THEN
          LET tm2.s2 = ' '
       END IF
       IF tm2.s3 = '6' THEN
          LET tm2.s3 = ' '
       END IF
    END IF
    IF tm.g = '1' THEN
       CALL cl_set_comp_entry("type_1",FALSE)
    END IF   
END FUNCTION
FUNCTION r761_set_comb()                                                                                                            
  DEFINE comb_value STRING                                                                                                          
  DEFINE comb_item  LIKE type_file.chr1000                                                                                          
                                                                                                                                    
    IF tm.b ='N' THEN                                                                                                         
       LET comb_value = '1,2,3,4,5'                                                                                                   
       SELECT ze03 INTO comb_item FROM ze_file                                                                                      
         WHERE ze01='axc-988' AND ze02=g_lang                                                                                      
    ELSE                                                                                                                            
       LET comb_value = '1,2,3,4,5,6'                                                                                                   
       SELECT ze03 INTO comb_item FROM ze_file                                                                                      
         WHERE ze01='axc-989' AND ze02=g_lang                                                                                       
    END IF                                                                                                                          
    CALL cl_set_combo_items('s1',comb_value,comb_item)
    CALL cl_set_combo_items('s2',comb_value,comb_item)
    CALL cl_set_combo_items('s3',comb_value,comb_item)                                                                          
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/12 
#FUN-A70084--add--str--
FUNCTION r761_set_entry()
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_azw05  LIKE azw_file.azw05

  SELECT azw05 INTO l_azw05 FROM azw_file WHERE azw01 = g_plant
  SELECT count(*) INTO l_cnt FROM azw_file
   WHERE azw05 = l_azw05

  IF l_cnt > 1 THEN
     CALL cl_set_comp_visible("group07,b",FALSE)
  END IF
  RETURN l_cnt
END FUNCTION

FUNCTION r761_chklegal(l_legal,n)
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
