# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcr161.4gl
# Descriptions...: 客戶別營業與毛利排行比較表
# Date & Author..: 98/05/26 By Star
# Modified.......:
# Modify.........: No:8488 tm.azk01='TWD' 改為 tm.azk01=g_aza.aza17
# Modify.........: No.MOD-4C0078 04/12/14 By pengu sql 中判斷 oga09 = '2' 之兩處，皆應該改為 oga09 !='1' AND oga09 !='5
# Modify.........: No.MOD-530181 05/03/21 By kim Define金額單價位數改為DEC(20,6)
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大
# Modify.........: No.FUN-560011 05/06/07 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-570190 05/08/08 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.MOD-570085 05/07/05 By kim 沒有進行單位換算(tlf10->tlf10*tlf60)
# Modify.........: No.FUN-580014 05/08/22 By trisy 2.0憑証類報表修改,轉XML格式
# Modify.........: No.FUN-5B0123 05/12/08 By Sarah 應排除出至境外倉部份(add oga00<>'3')
# Modify.........: No.MOD-5C0082 05/12/19 By kim 變動的報表表頭名稱會累加
# Modify.........: No.FUN-610020 06/01/10 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.TQC-610051 06/02/22 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-660187 06/07/05 By kim '客戶'資料,目前報表採用tlf_file(出貨客戶),但應該用'帳款客戶'(oma_file/occ_file)分析
# Modify.........: No.FUN-670039 06/07/12 By Carrier 帳別擴充為5碼 
# Modify.........: No.FUN-660126 06/07/24 By rainy remove s_chknplt
# Modify.........: No.FUN-670098 06/07/24 By rainy 排除不納入成本計算倉庫
# Modify.........: No.FUN-680017 06/07/05 By Claire FUN-680187 改回使用tlf19
# Modify.........: No.FUN-680122 06/09/07 By ice 欄位類型修改
# Modify.........: No.FUN-660073 06/09/15 By Nicola 訂單樣品修改
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-690007 06/12/26 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.MOD-710129 07/01/23 By jamie MISC的判斷需取前四碼
# Modify.........: No.TQC-740060 07/04/12 By kim tmp_sql 改定義為STRING
# Modify.........: No.TQC-7B0120 07/11/21 By shengbb imag 改為 ima
# Modify.........: No.FUN-7C0101 08/01/28 By Zhangyajun 成本改善增加成本計算類型字段(type)
# Modify.........: No.FUN-830002 08/03/03 By dxfwo 成本改善的index之前改過后出現報表打印不出來的問題修改
# Modify.........: No.FUN-870151 08/08/15 By xiaofeizhu  匯率調整為用azi07取位
# Modify.........: No.FUN-940102 09/04/24 BY destiny 檢查使用者的資料庫使用權限
# Modify.........: No.MOD-950210 09/05/26 By Pengu “寄銷出貨”不應納入 “銷貨收入”
# Modify.........: No.TQC-970305 09/07/30 By liuxqa create table 改為CREATE TEMP TABLE.
# Modify.........: No.TQC-980163 09/09/01 By liuxqa 將產生的臨時表表名寫死。
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-970290 09/09/22 By baofei 修改打印營運中心改為打印資料庫 
# Modify.........: No.TQC-9A0187 09/11/03 By xiaofeizhu 標準SQL修改 
# Modify.........: No.FUN-A10098 10/01/18 By baofei GP5.2跨DB報表--財務類 
# Modify.........: No.FUN-9C0073 10/01/26 By chenls  程序精簡
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26*
# Modify.........: No.TQC-A40139 10/05/06 By Carrier MOD-9A0038 追单 & 修改SQL中两次join tlfc_file为一次
# Modify.........: No.FUN-A70084 10/07/26 By lutingting GP5.2報表修改 AXC營運中心欄位統一為兩排,各四個,共計8個,本作業拿掉PLANT_9
# Modify.........: No:MOD-B20050 11/02/14 By sabrina 報表印出的資料與表頭沒有對齊
# Modify.........: No:MOD-B30724 11/03/31 By sabrina sr.tlf19[1,15]應改為sr.tlf19[1,10] 
# Modify.........: No:MOD-B30674 11/07/17 By JoHung 調整r161_c1的sql
# Modify.........: No:CHI-B70039 11/08/04 By joHung 金額 = 計價數量 x 單價
# Modify.........: No:FUN-B90130 11/11/29 By wujie  增加oma75的条件  
# Modify.........: No.TQC-BB0182 12/01/13 By pauline 取消過濾plant條件
# Modify.........: No:CHI-C30012 12/07/27 By bart 金額取位改抓ccz26
# Modify.........: No:MOD-D10179 13/01/24 By bart 排除簽收單

DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE g_wc string  #No.FUN-580092 HCN
   DEFINE tm  RECORD
              tlf19   LIKE tlf_file.tlf19,   #客戶編號  #FUN-660187  #FUN-680017
             #oga03   LIKE oga_file.oga03,   #客戶編號  #FUN-660187  #FUN-680017
              tlf01   LIKE tlf_file.tlf01,   #料號
              ima131  LIKE ima_file.ima131,  #產品分類 #No.FUN-680122 VARCHAR(04)
              ima11   LIKE ima_file.ima11,   #其他分群三 #No.FUN-680122 VARCHAR(04)
              ima12   LIKE ima_file.ima12,   #成本分群
              detail  LIKE type_file.chr1,   #是否印明細 #No.FUN-680122 VARCHAR(1)
              data    LIKE type_file.num5,   #資料選擇 #No.FUN-680122 SMALLINT
              order   LIKE type_file.num5,   #排名方式 #No.FUN-680122 SMALLINT
              num     LIKE type_file.num5,   #No.FUN-680122 SMALLINT
              leng    LIKE type_file.num5,   #1:80/2:132 #No.FUN-680122 SMALLINT
              yy1_b,mm1_b,mm1_e LIKE type_file.num5,   #No.FUN-680122 SMALLINT
              type    LIKE type_file.chr1,    #No.FUN-7C0101 VARCHAR(1)
              plant_1,plant_2,plant_3,plant_4,plant_5 LIKE azp_file.azp01, #No.FUN-680122 VARCHAR(10)
             #plant_6,plant_7,plant_8,plant_9         LIKE azp_file.azp01, #No.FUN-680122 VARCHAR(10)   #FUN-A70084
              plant_6,plant_7,plant_8                 LIKE azp_file.azp01, #No.FUN-A70084       
              sum_code LIKE type_file.chr1,   #No.FUN-680122 VARCHAR(1)
              azk01   LIKE azk_file.azk01,
              azk04   LIKE azk_file.azk04,
              azh01   LIKE azh_file.azh01,
              azh02   LIKE azh_file.azh02,
              dec     LIKE type_file.chr1,   #金額單位(1)元(2)千(3)萬 #No.FUN-680122 VARCHAR(1)
              more    LIKE type_file.chr1,   #No.FUN-680122 VARCHAR(1)
              wc      STRING          #TQC-630166
              END RECORD
 
   DEFINE g_bdate,g_edate LIKE type_file.dat    #No.FUN-680122 DATE
   DEFINE g_bookno        LIKE aaa_file.aaa01   #No.FUN-670039
   DEFINE g_base          LIKE type_file.num10,  #No.FUN-680122 INTEGER
          g_amt_n         LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
          g_bonus         LIKE type_file.num20_6 #No.FUN-680122 DEC(20,6)
   DEFINE  #multi fac
           g_delsql   LIKE type_file.chr1000, #execute sys_cmd #No.FUN-680122 VARCHAR(50)
           g_tname    LIKE type_file.chr20,   #tmpfile name #No.FUN-680122 VARCHAR(20)
           g_tname1   LIKE type_file.chr20,   #tmpfile name #No.FUN-680122 VARCHAR(20)
           g_delsql1  LIKE type_file.chr1000, #execute sys_cmd #No.FUN-680122 VARCHAR(50)
           g_idx,g_k  LIKE type_file.num10,   #No.FUN-680122 INTEGER
           g_ary DYNAMIC ARRAY OF RECORD      #被選擇之工廠
           plant      LIKE type_file.chr8,    #No.FUN-680122 VARCHAR(8)
           dbs        LIKE type_file.chr1000, #TQC-970290   
           dbs_new    LIKE type_file.chr21    #No.FUN-680122 VARCHAR(21)
           END RECORD,
           g_tmp DYNAMIC ARRAY OF RECORD      #被選擇之工廠
           p          LIKE type_file.chr8,    #No.FUN-680122 VARCHAR(8)
           d          LIKE type_file.chr21    #No.FUN-680122 VARCHAR(21)
           END RECORD ,
           g_sum RECORD
             # qty     LIKE ima_file.ima26,    #數量(內銷) #No.FUN-680122 DEC(15,3)#FUN-A20044
              qty     LIKE type_file.num15_3,    #數量(內銷) #No.FUN-680122 DEC(15,3)#FUN-A20044
              amt     LIKE type_file.num20_6, #金額(內銷) #No.FUN-680122 DEC(20,6)
              cost    LIKE type_file.num20_6, #成本(內銷) #No.FUN-680122 DEC(20,6)
            #  qty1    LIKE ima_file.ima26,    #數量(內退) #No.FUN-680122 DEC(15,3)#FUN-A20044
              qty1    LIKE type_file.num15_3,    #數量(內退) #No.FUN-680122 DEC(15,3)#FUN-A20044
              amt1    LIKE type_file.num20_6, #金額(內退) #No.FUN-680122 DEC(20,6)
              cost1   LIKE type_file.num20_6, #成本(內退) #No.FUN-680122 DEC(20,6)
              ome_amt LIKE type_file.num20_6, #折讓 #No.FUN-680122 DEC(20,6)
              oma_amt LIKE type_file.num20_6  #雜項發票 #No.FUN-680122 DEC(20,6)
              END RECORD
 
DEFINE g_i       LIKE type_file.num5    #count/index for any purpose #No.FUN-680122 SMALLINT
DEFINE g_head1   STRING                 #No.FUN-580014
DEFINE m_legal   ARRAY[10] OF LIKE azw_file.azw02   #FUN-A70084 

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
 
   LET tm.plant_1 = g_ary[1].plant
   LET tm.plant_2 = g_ary[2].plant
   LET tm.plant_3 = g_ary[3].plant
   LET tm.plant_4 = g_ary[4].plant
   LET tm.plant_5 = g_ary[5].plant
   LET tm.plant_6 = g_ary[6].plant
   LET tm.plant_7 = g_ary[7].plant
   LET tm.plant_8 = g_ary[8].plant
  #LET tm.plant_9 = g_ary[9].plant    #FUN-A70084
   LET g_pdate  = ARG_VAL(1)        
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET g_wc    = ARG_VAL(7)
   LET tm.num     = ARG_VAL(8)
   LET tm.yy1_b   = ARG_VAL(9)
   LET tm.mm1_b   = ARG_VAL(10)
   LET tm.mm1_e   = ARG_VAL(11)
   LET tm.azk01   = ARG_VAL(12)
   LET tm.azk04   = ARG_VAL(13)
   LET tm.azh01   = ARG_VAL(14)
   LET tm.azh02   = ARG_VAL(15)
   LET tm.plant_1 = ARG_VAL(16)
   LET tm.plant_2 = ARG_VAL(17)
   LET tm.plant_3 = ARG_VAL(18)
   LET tm.plant_4 = ARG_VAL(19)
   LET tm.plant_5 = ARG_VAL(20)
   LET tm.plant_6 = ARG_VAL(21)
   LET tm.plant_7 = ARG_VAL(22)
   LET tm.plant_8 = ARG_VAL(23)
#FUN-A70084--mod--str--拿掉PLANT_9 
#  LET tm.plant_9 = ARG_VAL(24)
#  LET tm.order   = ARG_VAL(25)
#  LET tm.data    = ARG_VAL(26)
#  LET tm.dec     = ARG_VAL(27)
#  LET tm.detail  = ARG_VAL(28)
#  LET tm.sum_code= ARG_VAL(29)
#  LET g_rep_user = ARG_VAL(30)
#  LET g_rep_clas = ARG_VAL(31)
#  LET g_template = ARG_VAL(32)
#  LET g_bookno = ARG_VAL(33)
#  LET tm.type    = ARG_VAL(34)
   LET tm.order   = ARG_VAL(24)
   LET tm.data    = ARG_VAL(25)
   LET tm.dec     = ARG_VAL(26)
   LET tm.detail  = ARG_VAL(27)
   LET tm.sum_code= ARG_VAL(28)
   LET g_rep_user = ARG_VAL(29)
   LET g_rep_clas = ARG_VAL(30)
   LET g_template = ARG_VAL(31)
   LET g_bookno = ARG_VAL(32)
   LET tm.type    = ARG_VAL(33)
#FUN-A70084--mod--end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r161_tm(0,0)
      ELSE CALL r161()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION r161_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01    #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,   #No.FUN-680122 SMALLINT
       l_date         LIKE type_file.dat,    #No.FUN-680122 DATE
       l_cmd          LIKE type_file.chr1000 #No.FUN-680122 VARCHAR(400)
DEFINE l_cnt          LIKE type_file.num5           #No.FUN-A70084
 
   IF p_row = 0 THEN LET p_row = 2 LET p_col = 4 END IF
   CALL s_dsmark(g_bookno)
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 1 LET p_col = 20
   ELSE LET p_row = 2 LET p_col = 4
   END IF
   OPEN WINDOW r161_w AT p_row,p_col
        WITH FORM "axc/42f/axcr161"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   CALL r161_set_visible() RETURNING l_cnt    #FUN-A70084
   INITIALIZE tm.* TO NULL
   LET tm.detail ='Y'
   LET tm.data = 1
   LET tm.order = 1
   LET tm.num= 0
   LET tm.leng=2
   LET tm.sum_code='N'
   LET tm.more = 'N'
   LET tm.dec= '1'
   LET tm.yy1_b = g_ccz.ccz01
   LET tm.mm1_b = g_ccz.ccz02
   LET tm.mm1_e = g_ccz.ccz02
   LET tm.type = g_ccz.ccz28  #No.FUN-7C0101 add
   LET tm.azk01= g_aza.aza17  #No:8488
   LET tm.azk04=1
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET g_base   = 1
WHILE TRUE
   LET g_wc=NULL
   CONSTRUCT BY NAME  g_wc ON tlf19,tlf01,ima11,ima12,ima131,tlf026 #FUN-660187 tlf19->oga03 #FUN-680017 oga03->tlf19
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
        IF INFIELD(tlf01) THEN
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_tlf"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO tlf01
           NEXT FIELD tlf01
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
LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
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
 
   INPUT BY NAME tm.num,tm.yy1_b,tm.mm1_b,tm.mm1_e,tm.type,tm.azk01,tm.azk04,    #No.FUN-7C0101 add tm.type
                 tm.azh01,tm.azh02,tm.plant_1,tm.plant_2,tm.plant_3,
                 tm.plant_4,tm.plant_5,tm.plant_6,tm.plant_7,tm.plant_8,
                #tm.plant_9,tm.order,tm.data,tm.dec,tm.detail,tm.sum_code,   #FUN-A70084
                 tm.order,tm.data,tm.dec,tm.detail,tm.sum_code,              #FUN-A70084
                 tm.more WITHOUT DEFAULTS
 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
         AFTER FIELD data
             LET tm.order=tm.data
             DISPLAY BY NAME tm.order
             SELECT * FROM azi_file
             WHERE azi01 = tm.azk01
             IF STATUS != 0 THEN
                CALL cl_err3("sel","azi_file",tm.azk01,"","aap-002","","azk01",1)   #No.FUN-660127
                NEXT FIELD azk01
             END IF
             SELECT MAX(azk02) INTO l_date FROM azk_file
             SELECT azk04 INTO tm.azk04 FROM azk_file
             WHERE azk01 = tm.azk01 AND azk02 =l_date
             DISPLAY BY NAME  tm.azk04
 
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
                   IF NOT r161_chkplant(tm.plant_1) THEN
                     CALL cl_err(tm.plant_1,g_errno,0)
                     NEXT FIELD plant_1
                   END IF
                   LET g_ary[1].plant = tm.plant_1
                   LET g_ary[1].dbs_new = g_dbs_new
                   SELECT azw02 INTO m_legal[1] FROM azw_file WHERE azw01 = tm.plant_1   #FUN-A70084
                   IF NOT s_chk_demo(g_user,tm.plant_1) THEN  
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
                   IF NOT r161_chkplant(tm.plant_2) THEN
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
                IF NOT r161_chklegal(m_legal[2],1) THEN
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
                   IF NOT r161_chkplant(tm.plant_3) THEN
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
                IF NOT r161_chklegal(m_legal[3],2) THEN
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
                   IF NOT r161_chkplant(tm.plant_4) THEN
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
                IF NOT r161_chklegal(m_legal[4],3) THEN
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
                   IF NOT r161_chkplant(tm.plant_5) THEN
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
                IF NOT r161_chklegal(m_legal[5],4) THEN
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
                   IF NOT r161_chkplant(tm.plant_6) THEN
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
                IF NOT r161_chklegal(m_legal[6],5) THEN
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
                   IF NOT r161_chkplant(tm.plant_7) THEN
                     CALL cl_err(tm.plant_7,g_errno,0)
                     NEXT FIELD plant_7
                   END IF
                   LET g_ary[7].plant = tm.plant_7
                   LET g_ary[7].dbs_new = g_dbs_new
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
                IF NOT r161_chklegal(m_legal[7],6) THEN
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
                   IF NOT r161_chkplant(tm.plant_8) THEN
                     CALL cl_err(tm.plant_8,g_errno,0)
                     NEXT FIELD plant_8
                   END IF
                   LET g_ary[8].plant = tm.plant_8
                   LET g_ary[8].dbs_new = g_dbs_new
                   SELECT azw02 INTO m_legal[8] FROM azw_file WHERE azw01 = tm.plant_8   #FUN-A70084
                   IF NOT s_chk_demo(g_user,tm.plant_8) THEN  
                      NEXT FIELD plant_8 
                   END IF              
                ELSE           # 輸入之工廠編號為' '或NULL
                   LET g_ary[8].plant = tm.plant_8
                END IF
             END IF
             #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_8) THEN
                IF NOT r161_chklegal(m_legal[8],7) THEN
                   CALL cl_err(tm.plant_8,g_errno,0)
                   NEXT FIELD plant_8
                END IF
             END IF
             #FUN-A70084--add--end

 
       #FUN-A70084--mark--str--
       # AFTER FIELD plant_9
       #     LET tm.plant_9 = duplicate(tm.plant_9,7)  # 不使工廠編號重覆
       #     LET g_plant_new = tm.plant_9
       #     IF tm.plant_9 = g_plant  THEN
       #        LET g_dbs_new=' '
       #        LET g_ary[9].plant = tm.plant_9
       #        LET g_ary[9].dbs_new = g_dbs_new
       #     ELSE
       #        IF NOT cl_null(tm.plant_9) THEN
       #                       # 檢查工廠並將新的資料庫放在g_dbs_new
       #           IF NOT r161_chkplant(tm.plant_9) THEN
       #             CALL cl_err(tm.plant_9,g_errno,0)
       #             NEXT FIELD plant_9
       #           END IF
       #           LET g_ary[9].plant = tm.plant_9
       #           LET g_ary[9].dbs_new = g_dbs_new
       #           IF NOT s_chk_demo(g_user,tm.plant_9) THEN  
       #              NEXT FIELD plant_9 
       #           END IF              
       #        ELSE           # 輸入之工廠編號為' '或NULL
       #           LET g_ary[9].plant = tm.plant_9
       #        END IF
       #     END IF
       #FUN-A70084--mark--end

         AFTER FIELD sum_code
# genero  script marked              IF g_multpl='N' AND cl_ku() THEN NEXT FIELD mm1_e END IF
         AFTER FIELD type
               IF cl_null(tm.type) OR tm.type NOT MATCHES '[12345]' THEN
                  NEXT FIELD type
               END IF
         AFTER FIELD azk01
                SELECT * FROM azi_file
                WHERE azi01 = tm.azk01
                IF STATUS != 0 THEN
                   CALL cl_err3("sel","azi_file",tm.azk01,"","aap-002","","azk01",1)   #No.FUN-660127
                   NEXT FIELD azk01
                END IF
             SELECT MAX(azk02) INTO l_date FROM azk_file
             SELECT azk04 INTO tm.azk04 FROM azk_file
             WHERE azk01 = tm.azk01 AND azk02 =l_date
             DISPLAY BY NAME  tm.azk04
 
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
 
               WHEN INFIELD(plant_7)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_zxy"               #No.FUN-940102
                    LET g_qryparam.arg1 = g_user                #No.FUN-940102
                    LET g_qryparam.default1 = tm.plant_7
                    CALL cl_create_qry() RETURNING tm.plant_7
                    DISPLAY BY NAME tm.plant_7
                    NEXT FIELD plant_7
 
               WHEN INFIELD(plant_8)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_zxy"               #No.FUN-940102
                    LET g_qryparam.arg1 = g_user                #No.FUN-940102
                    LET g_qryparam.default1 = tm.plant_8
                    CALL cl_create_qry() RETURNING tm.plant_8
                    DISPLAY BY NAME tm.plant_8
                    NEXT FIELD plant_8
 
              #FUN-A70084--mark--str--
              #WHEN INFIELD(plant_9)
              #     CALL cl_init_qry_var()
              #     LET g_qryparam.form = "q_zxy"               #No.FUN-940102
              #     LET g_qryparam.arg1 = g_user                #No.FUN-940102
              #     LET g_qryparam.default1 = tm.plant_9
              #     CALL cl_create_qry() RETURNING tm.plant_9
              #     DISPLAY BY NAME tm.plant_9
              #     NEXT FIELD plant_9
              #FUN-A70084--mark--end
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
         IF cl_null(tm.plant_1) AND cl_null(tm.plant_2) AND
            cl_null(tm.plant_3) AND cl_null(tm.plant_4) AND
            cl_null(tm.plant_5) AND cl_null(tm.plant_6) AND
            cl_null(tm.plant_7) AND cl_null(tm.plant_8) AND
           #cl_null(tm.plant_9) THEN     #FUN-A70084
            l_cnt <=1 THEN   #FUN-A70084
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
    #FOR g_idx = 1  TO  9    #FUN-A70084
     FOR g_idx = 1  TO  8    #FUN-A70084
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
   CALL s_ymtodate(tm.yy1_b,tm.mm1_b,tm.yy1_b,tm.mm1_e)
   RETURNING g_bdate ,g_edate
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r161_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
       WHERE zz01='axcr161'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr161','9031',1)   
      ELSE
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",g_wc CLIPPED,"'",
                         " '",tm.num      CLIPPED,"'",
                         " '",tm.yy1_b    CLIPPED,"'",
                         " '",tm.mm1_b    CLIPPED,"'",
                         " '",tm.mm1_e    CLIPPED,"'",
                         " '",tm.type    CLIPPED,"'",    #No.FUN-7C0101 add
                         " '",tm.azk01    CLIPPED,"'",
                         " '",tm.azk04    CLIPPED,"'",
                         " '",tm.azh01    CLIPPED,"'",
                         " '",tm.azh02    CLIPPED,"'",
                         " '",tm.plant_1  CLIPPED,"'",
                         " '",tm.plant_2  CLIPPED,"'",
                         " '",tm.plant_3  CLIPPED,"'",
                         " '",tm.plant_4  CLIPPED,"'",
                         " '",tm.plant_5  CLIPPED,"'",
                         " '",tm.plant_6  CLIPPED,"'",
                         " '",tm.plant_7  CLIPPED,"'",
                         " '",tm.plant_8  CLIPPED,"'",
                        #" '",tm.plant_9  CLIPPED,"'",   #FUN-A70084
                         " '",tm.order    CLIPPED,"'",
                         " '",tm.data     CLIPPED,"'",
                         " '",tm.dec      CLIPPED,"'",
                         " '",tm.detail   CLIPPED,"'",
                         " '",tm.sum_code CLIPPED,"'",
                         " '",g_rep_user  CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",   
                         " '",g_template  CLIPPED,"'",
                         " '",g_bookno  CLIPPED,"'"
         CALL cl_cmdat('axcr161',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr111_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
 
   CALL cl_wait()
   CALL r161()
   ERROR ""
END WHILE
   CLOSE WINDOW r161_w
END FUNCTION
 
FUNCTION r161()
   DEFINE l_name    LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-680122 VARCHAR(20)
          l_sql     LIKE type_file.chr1000, # RDSQL STATEMENT  #No.FUN-680122 VARCHAR(2000)
          l_tmp     LIKE type_file.chr8,    #No.FUN-680122 VARCHAR(8)
          l_za05    LIKE type_file.chr1000, #No.FUN-680122 VARCHAR(40)
          l_flag    LIKE type_file.chr1,    #No.FUN-680122 VARCHAR(1)
          sr  RECORD
              tlf19   LIKE tlf_file.tlf19,  #MOD-5C0082 #FUN-660187  #FUN-680017
              tlf01   LIKE tlf_file.tlf01,  #MOD-5C0082
              tlf026  LIKE tlf_file.tlf026,  #出貨單 #No.FUN-550025 #No.FUN-680122 VARCHAR(16)
              tlf06   LIKE tlf_file.tlf06,   #日期 #No.FUN-680122 VARCHAR(10)
              tlfccost LIKE tlfc_file.tlfccost, #No.FUN-7C0101 VARCHAR(40)
             # qty     LIKE ima_file.ima26,   #No.FUN-680122 DEC(15,3)#FUN-A20044
              qty     LIKE type_file.num15_3,   #No.FUN-680122 DEC(15,3)#FUN-A20044
              amt     LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
              cost    LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
              rq_qty  LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
              rq_amt  LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
              rq_cost LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
              amt_n_s LIKE type_file.num20_6,#凈額排行No.FUN-680122 DEC(20,6)
              bonus_s LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
              amt_n_per LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
              bonus_per LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
              uc        LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
              amt_n     LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
             # qty_n     LIKE ima_file.ima26,   #No.FUN-680122 DEC(15,3)#FUN-A20044
              qty_n     LIKE type_file.num15_3,   #No.FUN-680122 DEC(15,3)#FUN-A20044
              cost_n  LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
              uus     LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
              uus1    LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
              bonus   LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
              bonus_r LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
              order   LIKE type_file.num20_6 #No.FUN-680122 DEC(20,6)
              END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     # 定義報表之寬度
 
     CALL get_tmpfile() #
     CALL get_dpm()     #內部自用,雜發票,折讓
     CALL sort()        #排行
        LET g_amt_n=0
        LET g_bonus=0
        LET l_sql=" SELECT sum(amt-rq_amt),sum(amt-rq_amt-cost+rq_cost)",
                  " FROM ",g_tname
        PREPARE pre_totamt FROM l_sql
        DECLARE totamt_cur CURSOR FOR pre_totamt
        OPEN totamt_cur
        FETCH totamt_cur INTO g_amt_n,g_bonus
     IF tm.num >0 and tm.order >3 THEN
      LET l_sql=" SELECT tlf19,tlf01,tlf026,tlf06,tlfccost,SUM(qty),SUM(amt),SUM(cost),",  #FUN-660187 tlf19->oga03  #FUN-680017 oga03->tlf19 #No.FUN-7C0101 add tlfccost
                  " SUM(rq_qty),SUM(rq_amt),SUM(rq_cost),SUM(amt_n_s),",
                  " SUM(bonus_s),SUM(amt_n_per),SUM(bonus_per) ",
                  ",SUM(uc) ",
                  " FROM ",g_tname CLIPPED,
                  " WHERE ((amt_n_s<=",tm.num," AND amt_n_s>=1)",
                  " OR (bonus_s<=",tm.num," AND bonus_s>=1))",
                  " GROUP BY tlf19,tlf01,tlf026,tlf06,tlfccost",
                  " UNION ALL ",
                  " SELECT '其他','其他','','',tlfccost,sum(qty),sum(amt),sum(cost),",   #No.FUN-7C0101 add tlfccost
                  " sum(rq_qty),sum(rq_amt),sum(rq_cost),99999,99999,0,0,0",
                  " FROM ",g_tname CLIPPED,
                  " WHERE NOT ((amt_n_s<=",tm.num," AND amt_n_s>=1)",
                  " OR (bonus_s<=",tm.num," AND bonus_s>=1))",
                  " GROUP BY 1,2,3,4,5"
     ELSE
        LET l_sql=" SELECT * FROM ",g_tname CLIPPED
     END IF
 
     PREPARE r161_prepare FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('r161_prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM
     END IF
 
     DECLARE r161_curs1 CURSOR FOR r161_prepare
 
     CALL cl_outnam('axcr161') RETURNING l_name
     
     IF tm.type MATCHES '[12]' THEN
        LET g_zaa[33].zaa06='Y'
     END IF
     IF tm.type MATCHES '[345]' THEN
        LET g_zaa[33].zaa06='N'
     END IF
     CALL cl_prt_pos_len()         #MOD-B20050 add 
     
     START REPORT r161_rep TO l_name
     LET g_pageno = 0
     LET g_line= 0
     FOREACH r161_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
       END IF
       LET sr.uc=sr.uc/g_base
       LET sr.amt=sr.amt/g_base
       LET sr.cost=sr.cost/g_base
       LET sr.rq_amt=sr.rq_amt/g_base
       LET sr.rq_cost=sr.rq_cost/g_base
       IF sr.qty !=0 THEN
          LET sr.uus=sr.amt/sr.qty
          LET sr.uus1=sr.cost/sr.qty
       ELSE
          LET sr.uus=sr.amt
          LET sr.uus1=sr.cost
       END IF
 
       IF tm.azk04 >0 THEN
          LET sr.uc=sr.uc/tm.azk04
          LET sr.uus=sr.uus/tm.azk04
          LET sr.uus1=sr.uus1/tm.azk04
       END IF
       LET sr.qty_n=sr.qty-sr.rq_qty
       LET sr.amt_n=sr.amt-sr.rq_amt
       LET sr.cost_n=sr.cost-sr.rq_cost
       ### 毛利
       LET sr.bonus=sr.amt_n-sr.cost_n
       IF sr.amt_n<>0 THEN
           LET sr.bonus_r=sr.bonus/sr.amt_n*100
       ELSE
           LET sr.bonus_r=-100
       END IF
       CASE tm.order
         WHEN 4 LET sr.order=sr.amt_n_s
         WHEN 5 LET sr.order=sr.bonus_s
         OTHERWISE
            LET sr.order=0
       END CASE
       IF sr.qty<>0 OR sr.rq_qty<>0 OR sr.amt <>0 OR
          sr.rq_amt <>0 OR sr.cost<>0 OR sr.rq_cost <>0 THEN
          OUTPUT TO REPORT r161_rep(sr.*)
       END IF
     END FOREACH
     FINISH REPORT r161_rep
     LET g_delsql= " DROP TABLE ",g_tname CLIPPED
     PREPARE del_cmd FROM g_delsql
     EXECUTE del_cmd
     LET g_delsql1= " DROP TABLE ",g_tname1 CLIPPED
     PREPARE del_dpm1 FROM g_delsql1
     EXECUTE del_dpm1
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
FUNCTION get_tmpfile()
DEFINE
       l_tlf026x  LIKE tlf_file.tlf026,
       l_tlf027x  LIKE tlf_file.tlf027,
       l_dot      LIKE type_file.chr1,   #No.FUN-680122 VARCHAR(1)
       l_title    LIKE type_file.chr1000,#No.FUN-680122 VARCHAR(100)
       l_titlex   LIKE type_file.chr1000,#No.FUN-680122 VARCHAR(100)
       l_groupby  LIKE type_file.chr1000,#No.FUN-680122 VARCHAR(100)
       l_groupbyx LIKE type_file.chr1000,#No.FUN-680122 VARCHAR(100)
       l_sql      LIKE type_file.chr1000,#No.FUN-680122 VARCHAR(200)
       tmp_sql    STRING, #TQC-740060
       x_wc       LIKE type_file.chr1000,#No.FUN-680122 VARCHAR(2000)
       l_tlf19     LIKE tlf_file.tlf19, #MOD-5C0082 #FUN-660187 #FUN-680017
       l_tlf01     LIKE tlf_file.tlf01, #MOD-5C0082
       l_tlf026    LIKE tlf_file.tlf026,  #No.FUN-550025 #No.FUN-680122 VARCHAR(16)
       l_tlf06     LIKE tlf_file.tlf06,   #No.FUN-550025 #No.FUN-680122 VARCHAR(10)
       l_tlfccost  LIKE tlfc_file.tlfccost, #No.FUN-7C0101 VARCHAR(40)
    #   l_qty       LIKE ima_file.ima26,   #No.FUN-680122 DEC(15,3)#FUN-A20044
       l_qty       LIKE type_file.num15_3,   #No.FUN-680122 DEC(15,3)#FUN-A20044
       l_amt       LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
       l_cost      LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
    #   l_rq_qty    LIKE ima_file.ima26,   #No.FUN-680122 DEC(15,3)#FUN-A20044
       l_rq_qty    LIKE type_file.num15_3,   #No.FUN-680122 DEC(15,3)#FUN-A20044
       l_rq_amt    LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
       l_rq_cost   LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
       l_amt_n_s   LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
       l_bonus_s   LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
       l_amt_n_per LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
       l_bonus_per LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
       l_uc        LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
       l_tlf14     LIKE tlf_file.tlf14,   #MOD-B30674 add
       l_azf08     LIKE azf_file.azf08    #MOD-B30674 add
 
LET g_tname='r161_tmp'                       #No.TQC-980163 mod
LET g_delsql= " DROP TABLE ",g_tname CLIPPED
PREPARE del_cmd2 FROM g_delsql
LET l_sql=null
     LET g_delsql= " DROP TABLE ",g_tname CLIPPED
     PREPARE del_cmd1 FROM g_delsql
     EXECUTE del_cmd1
LET tmp_sql=
#   "CREATE TABLE ",g_tname CLIPPED,  #No.TQC-970305 mark #FUN-A10098---BEGIN
    "CREATE TEMP TABLE ",g_tname CLIPPED,  #No.TQC-970305 mod
             "(tlf19     LIKE tlf_file.tlf19,", #FUN-680017
             " tlf01     LIKE tlf_file.tlf01,",  #FUN-560011
             " tlf026    LIKE tlf_file.tlf026,", #出貨單       #No.FUN-550025
             " tlf06     LIKE tlf_file.tlf06,",     #日期
             " tlfccost  LIKE tlf_file.tlfcost,",               #No.FUN-7C0101
             " qty       LIKE type_file.num15_3,", #異動數量#FUN-A20044  #No.TQC-A40139
             " amt       LIKE type_file.num20_6,", #銷售金額
             " cost      LIKE type_file.num20_6,", #銷售成本
             " rq_qty    LIKE type_file.num15_3,", #銷退量#FUN-A20044  #No.TQC-A40139
             " rq_amt    LIKE type_file.num20_6,", #銷退金額
             " rq_cost   LIKE type_file.num20_6,", #銷退成本
             " amt_n_s   LIKE type_file.num20_6,", #淨額排行
             " bonus_s   LIKE type_file.num20_6,", #毛利排行
             " amt_n_per LIKE type_file.num20_6,", #淨額百分比
             " bonus_per LIKE type_file.num20_6,", #毛利百分比
             " uc        LIKE type_file.num20_6)"  #材料金額
#             "(tlf19     VARCHAR(20),", #FUN-680017
#             " tlf01     VARCHAR(40),",  #FUN-560011
#    #        " tlf026    VARCHAR(10),", #出貨單
#             " tlf026    VARCHAR(16),", #出貨單       #No.FUN-550025
#             " tlf06     VARCHAR(10),",     #日期
#             " tlfccost  VARCHAR(40),",               #No.FUN-7C0101
#             " qty       DEC(15,3),", #異動數量
#             " amt       DEC(20,6),", #銷售金額
#             " cost      DEC(20,6),", #銷售成本
#             " rq_qty    DEC(15,3),", #銷退量
#             " rq_amt    DEC(20,6),", #銷退金額
#             " rq_cost   DEC(20,6),", #銷退成本
#             " amt_n_s   DEC(20,6),", #淨額排行
#             " bonus_s   DEC(20,6),", #毛利排行
#             " amt_n_per DEC(20,6),", #淨額百分比
#             " bonus_per DEC(20,6),", #毛利百分比
#             " uc        DEC(20,6))"  #材料金額

#FUN-A10098---END
    PREPARE cre_p1 FROM tmp_sql
    EXECUTE cre_p1
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('Create axcr161_tmp:' ,SQLCA.sqlcode,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
       EXIT PROGRAM
    END IF
    IF tm.detail matches '[Yy]' THEN #要印明細
       CASE tm.data
         WHEN 0 LET l_title= "tlf19,tlf01,'','',"  #FUN-660187 tlf19->oga03  #FUN-680017
         WHEN 1 LET l_title= "tlf19,ima131,'',''," #FUN-660187 tlf19->oga03  #FUN-680017
         WHEN 2 LET l_title= "tlf19,ima11,'','',"  #FUN-660187 tlf19->oga03  #FUN-680017
         WHEN 3 LET l_title= "tlf19,tlf01,tlf026,tlf06,"  #FUN-660187 tlf19->oga03  #FUN-680017
       END CASE
    ELSE
       LET l_title="tlf19,'','','',"  #FUN-660187 tlf19->oga03 #FUN-680017
    END IF
    LET l_title=l_title CLIPPED,"tlfccost,"   #No.FUN-7C0101 add
    LET l_groupby = s_groupby(l_title CLIPPED)
      FOR g_idx=1 TO g_k         
          LET tmp_sql=" SELECT ",l_title CLIPPED,
     #       異動數量         銷售金額          成會異動成本
       " SUM(tlf10*tlf60),SUM(tlf10*tlf60*ogb13*oga24),SUM(tlfc21), ",  #BUG-490340  #MOD-570085  #No.FUN-7C0101 tlf21->tlfc21
          " 0,0,0,0,0,0,0",
     #          材料金額
       " ,SUM(ccc23a*tlf10*tlf60) ", #MOD-570085
       ",tlf14 ",                    #MOD-B30674 add

#TQC-9A0187-Add-Begin
#FUN-A10098---BEGIN
#"    FROM ",g_ary[g_idx].dbs_new CLIPPED,"tlf_file",
#"    LEFT OUTER JOIN ",g_ary[g_idx].dbs_new CLIPPED,"azf_file",  
#"      ON tlf14=azf01 AND azf08 <>'Y' ", 
#"    LEFT OUTER JOIN ",g_ary[g_idx].dbs_new CLIPPED,"ccc_file",
#          " ON tlf_file.tlf01=ccc_file.ccc01 ",
#          " AND ccc_file.ccc02=YEAR(tlf_file.tlf06) AND ccc_file.ccc03=MONTH(tlf_file.tlf06) ",
#"    LEFT OUTER JOIN ",g_ary[g_idx].dbs_new CLIPPED,"tlfc_file",
#          " ON tlfc_file.tlfc01 = tlf01 AND tlfc_file.tlfc02 = tlf02 ",
#          " AND tlfc_file.tlfc03 = tlf03 AND tlfc_file.tlfc06 = tlf06",
#          " AND tlfc_file.tlfc13 = tlf13",
#          " AND tlfc_file.tlfc902 = tlf902 AND tlfc_file.tlfc903 = tlf903",
#          " AND tlfc_file.tlfc904 = tlf904 AND tlfc_file.tlfc905 = tlf905",
#          " AND tlfc_file.tlfc906 = tlf906 AND tlfc_file.tlfc907 = tlf907",
#          " AND tlfc_file.tlfctype = '",tm.type,"'",
#" ,       ",g_ary[g_idx].dbs_new CLIPPED,"smy_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"oga_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ogb_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"tlfc_file", 
"    FROM ",cl_get_target_table(g_ary[g_idx].plant,'tlf_file'),
#"    LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'azf_file'),   #MOD-B30674 mark
#"      ON tlf14=azf01 AND azf08 <>'Y' ",                                     #MOD-B30674 mark
"    LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'ccc_file'),
          " ON tlf_file.tlf01=ccc_file.ccc01 ",
          " AND ccc_file.ccc02=YEAR(tlf_file.tlf06) AND ccc_file.ccc03=MONTH(tlf_file.tlf06) ",
"    LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'tlfc_file'),
          " ON tlfc_file.tlfc01 = tlf01 AND tlfc_file.tlfc02 = tlf02 ",
          " AND tlfc_file.tlfc03 = tlf03 AND tlfc_file.tlfc06 = tlf06",
          " AND tlfc_file.tlfc13 = tlf13",
          " AND tlfc_file.tlfc902 = tlf902 AND tlfc_file.tlfc903 = tlf903",
          " AND tlfc_file.tlfc904 = tlf904 AND tlfc_file.tlfc905 = tlf905",
          " AND tlfc_file.tlfc906 = tlf906 AND tlfc_file.tlfc907 = tlf907",
          " AND tlfc_file.tlfctype = '",tm.type,"'",
" ,       ",cl_get_target_table(g_ary[g_idx].plant,'smy_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'oga_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ogb_file'),
#         " ,",cl_get_target_table(g_ary[g_idx].plant,'tlfc_file'),  #No.TQC-A40139
#FUN-A10098---END
          " WHERE ",g_wc CLIPPED,
          " AND tlf61=smyslip AND smydmy1 = 'Y' ",
          " AND (tlf03 = 724 OR tlf03 = 72) AND tlf02 = 50 ",
          " AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
#TQC-9A0187-Add-End

          " AND tlf01=ima01 ",
          " AND tlf026=ogb01 ",
          " AND tlf027=ogb03 ",
          " AND ogb01=oga01 AND oga09 != '1' AND oga09 !='5' ",     #BUG-4C0078
          " AND oga65 <> 'Y' ",  #MOD-D10179 
          " AND ogaconf = 'Y' AND ogapost = 'Y' ",
          " AND oga00 NOT IN ('A','3','7') ",    #No.MOD-950210 add
          " AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
          " GROUP BY ",l_groupby CLIPPED,",tlf14 ",           #MOD-B30674 add tlf14
          " UNION ALL ",
          " SELECT ",l_title CLIPPED, #出貨單刪除者
#         " SUM(tlf10*tlf60),SUM(ogb12*ogb13*oga24)*-1,SUM(tlfc21), ",    #MOD-570085    #No.FUN-7C0101 tlf21->tlfc21   #CHI-B70039 mark
          " SUM(tlf10*tlf60),SUM(ogb917*ogb13*oga24)*-1,SUM(tlfc21), ",   #CHI-B70039
          " 0,0,0,0,0,0,0",
          " ,SUM(ccc23a*tlf10*tlf60) ", #MOD-570085
          " ,tlf14 ",                   #MOD-B30674 add
#          " FROM ",g_ary[g_idx].dbs_new CLIPPED,"tlf_file",  #FUN-A10098
          " FROM ",cl_get_target_table(g_ary[g_idx].plant,'tlf_file'),  #FUN-A10098

#TQC-9A0187-Add-Begin
#FUN-A10098---BEGIN
#          " LEFT OUTER JOIN ",g_ary[g_idx].dbs_new CLIPPED,"azf_file",  
#          " ON tlf14=azf_file.azf01 AND azf08 <>'Y' ",
#          " LEFT OUTER JOIN ",g_ary[g_idx].dbs_new CLIPPED,"ccc_file",
#          " ON tlf01=ccc01 ",
#          " AND ccc_file.ccc02=YEAR(tlf_file.tlf06) AND ccc_file.ccc03=MONTH(tlf_file.tlf06) ",
#          " AND ccc07 = '",tm.type,"'",
#          " LEFT OUTER JOIN ",g_ary[g_idx].dbs_new CLIPPED,"tlfc_file",
#          " ON tlfc_file.tlfc01 = tlf01 AND tlfc_file.tlfc02 = tlf02 ",
#          " AND tlfc_file.tlfc03 = tlf03 AND tlfc_file.tlfc06 = tlf06",           
#          " AND tlfc_file.tlfc13 = tlf13",                             
#          " AND tlfc_file.tlfc902 = tlf902 AND tlfc_file.tlfc903 = tlf903",     
#          " AND tlfc_file.tlfc904 = tlf904 AND tlfc_file.tlfc905 = tlf905",    
#          " AND tlfc_file.tlfc906 = tlf906 AND tlfc_file.tlfc907 = tlf907",
#          " AND tlfc_file.tlfctype = '",tm.type,"'",               
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"smy_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"oga_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ogb_file",
#         " LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'azf_file'),   #MOD-B30674 mark
#         " ON tlf14=azf_file.azf01 AND azf08 <>'Y' ",                              #MOD-B30674 mark
          " LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'ccc_file'),
          " ON tlf01=ccc01 ",
          " AND ccc_file.ccc02=YEAR(tlf_file.tlf06) AND ccc_file.ccc03=MONTH(tlf_file.tlf06) ",
          " AND ccc07 = '",tm.type,"'",
          " LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'tlfc_file'),
          " ON tlfc_file.tlfc01 = tlf01 AND tlfc_file.tlfc02 = tlf02 ",
          " AND tlfc_file.tlfc03 = tlf03 AND tlfc_file.tlfc06 = tlf06",
          " AND tlfc_file.tlfc13 = tlf13",
          " AND tlfc_file.tlfc902 = tlf902 AND tlfc_file.tlfc903 = tlf903",
          " AND tlfc_file.tlfc904 = tlf904 AND tlfc_file.tlfc905 = tlf905",
          " AND tlfc_file.tlfc906 = tlf906 AND tlfc_file.tlfc907 = tlf907",
          " AND tlfc_file.tlfctype = '",tm.type,"'",
          " ,",cl_get_target_table(g_ary[g_idx].plant,'smy_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'oga_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ogb_file'),
#FUN-A10098---END
          " WHERE ",g_wc CLIPPED,
          " AND tlf61=smyslip AND smydmy1 = 'Y' ",
          " AND (tlf03 = 723 OR tlf03 = 725) AND tlf02 = 50 ",
          " AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
#TQC-9A0187-Add-End
          " AND tlf01=ima01 ",
          " AND tlf026=ogb01 AND tlf027=ogb03 ",
          " AND ogb01=oga01 AND oga09 NOT IN ('1','5','7','9') ",   #MOD-4C0078 #No.FUN-610020
          " AND oga00 NOT IN ('A','3','7') ",    #No.MOD-950210 add
          " AND oga65 <> 'Y' ",  #MOD-D10179 
          " AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
          " GROUP BY ",l_groupby CLIPPED,",tlf14 "            #MOD-B30674 add tlf14
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
         #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
          PREPARE r161_prepare1 FROM tmp_sql
          DECLARE r161_c1 CURSOR FOR r161_prepare1
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('r161_c1:',SQLCA.sqlcode,1)
             EXECUTE del_cmd2 #delete tmpfile
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
             EXIT PROGRAM
          END IF
          # 準備Insert Into Temp File
          LET tmp_sql= " INSERT INTO ",g_tname CLIPPED,
                       " (tlf19, tlf01, tlf026, tlf06,tlfccost, qty, amt, ",  #FUN-660187 tlf19->oga03 #FUN-680017  #No.FUN-7C0101 add tlfccost
                       "  cost, rq_qty, rq_amt, rq_cost, amt_n_s, ",
                       "  bonus_s, amt_n_per, bonus_per, uc)",
                       " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
          PREPARE r161_ins FROM tmp_sql
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('r161_ins:',SQLCA.sqlcode,1)
               EXECUTE del_cmd2 #delete tmpfile
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
               EXIT PROGRAM
            END IF
          #No.TQC-A40139  --Begin
#         FOREACH r161_c1 INTO l_tlf19 #, l_tlf01, l_tlf026, l_tlf06,l_tlfccost, #FUN-660187 tlf19->oga03 #FUN-680017  #No.FUN-7C0101 add l_tlfccost
          FOREACH r161_c1 INTO l_tlf19 , l_tlf01, l_tlf026, l_tlf06,l_tlfccost, 
                   l_qty, l_amt, l_cost, l_rq_qty, l_rq_amt, l_rq_cost,
                   l_amt_n_s, l_bonus_s, l_amt_n_per, l_bonus_per, l_uc
                   ,l_tlf14   #MOD-B30674 add
          #No.TQC-A40139  --End
#MOD-B30674 -- begin --
            IF NOT cl_null(l_tlf14) THEN
               SELECT azf08 INTO l_azf08 FROM azf_file
                WHERE azf01 = l_tlf14
               IF l_azf08 = 'Y' THEN
                  CONTINUE FOREACH
               END IF
            END IF
#MOD-B30674 -- end --  
            IF l_qty=0 THEN
              LET l_uc=0
            ELSE
              LET l_uc=l_uc/l_qty
            END IF
            EXECUTE r161_ins USING l_tlf19, l_tlf01, l_tlf026, l_tlf06,l_tlfccost,  #FUN-660187 tlf19->oga03 #FUN-680017  #No.FUN-7C0101 add l_tlfccost
                  l_qty, l_amt, l_cost, l_rq_qty, l_rq_amt, l_rq_cost,
                  l_amt_n_s, l_bonus_s, l_amt_n_per, l_bonus_per, l_uc
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('r161_ins:',SQLCA.sqlcode,1)
                 EXECUTE del_cmd2 #delete tmpfile
                 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
                 EXIT PROGRAM
              END IF
          END FOREACH
          LET tmp_sql= " INSERT INTO ",g_tname,
          " SELECT ",l_title CLIPPED,
           " 0,0,0,sum(tlf10*tlf60),0,                      ", #MOD-570085
          " sum(tlfc21),0,0,0,0,0 ",                           #No.FUN-7C0101 tlf21->tlfc21
#FUN-A10098---BEGIN
#          " FROM ",g_ary[g_idx].dbs_new CLIPPED,"tlf_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"smy_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"oha_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ohb_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"tlfc_file",             #No.FUN-7C0101 add
          " FROM ",cl_get_target_table(g_ary[g_idx].plant,'tlf_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'smy_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'oha_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ohb_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'tlfc_file'), 
#FUN-A10098---END
          " WHERE ",g_wc CLIPPED,  #FUN-660187 g_wc->x_wc #FUN-680017
          " AND tlf61=smyslip AND smydmy1 = 'Y' ",
          " AND tlf02 = 731 AND tlf03 = 50 ",
          " AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
          " AND tlfc_file.tlfc01 = tlf01 AND tlfc_file.tlfc02 = tlf02 ",                                                                                
          " AND tlfc_file.tlfc03 = tlf03 AND tlfc_file.tlfc06 = tlf06",           #No.FUN-830002                                                        
          " AND tlfc_file.tlfc13 = tlf13",                              #No.FUN-830002                                                        
          " AND tlfc_file.tlfc902 = tlf902 AND tlfc_file.tlfc903 = tlf903",       #No.FUN-830002                                                        
          " AND tlfc_file.tlfc904 = tlf904 AND tlfc_file.tlfc905 = tlf905",       #No.FUN-830002                                                        
          " AND tlfc_file.tlfc906 = tlf906 AND tlfc_file.tlfc907 = tlf907",
          " AND tlfc_file.tlfctype = '",tm.type,"'",                                                  
          " AND tlf01=ima01 ",
          " AND tlf026=ohb01 AND tlf027=ohb03 AND ohb01=oha01 ",
          " AND ohaconf = 'Y' AND ohapost = 'Y' ",
          " AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
          " GROUP BY ",l_groupby CLIPPED
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
         #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
          PREPARE r161_prepare3 FROM tmp_sql
          EXECUTE r161_prepare3
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('r161_prepare3:',SQLCA.sqlcode,1)
             EXECUTE del_cmd2 #delete tmpfile
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
             EXIT PROGRAM
          END IF
          LET x_wc = change_string(g_wc,'tlf19','oma03') #FUN-660187 tlf19->oga03  #FUN-680017
          LET x_wc = change_string(x_wc,'tlf01','ima01')
          LET x_wc = change_string(x_wc,'tlf026','omb31')
          LET x_wc = change_string(x_wc,'tlf06','oma02')
          LET l_titlex = change_string(l_title,'tlf19','oma03') #FUN-660187 tlf19->oha03 #FUN-680017
          LET l_titlex = change_string(l_titlex,'tlf01','ima01')
          LET l_titlex = change_string(l_titlex,'tlf026','omb31')
          LET l_titlex = change_string(l_titlex,'tlf06','oma02')
          LET l_groupbyx = s_groupby(l_titlex CLIPPED)
          LET tmp_sql= " INSERT INTO ",g_tname,
          " SELECT ",l_titlex CLIPPED,
          " 0,0,0,0         ,SUM(omb16),                      ",
          " 0         ,0,0,0,0,0 ",
#FUN-A10098---BEGIN
#          " FROM ",g_ary[g_idx].dbs_new CLIPPED,"oma_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"omb_file",
#          " , ",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"tlfc_file",             #No.FUN-7C0101 add         
          " FROM ",cl_get_target_table(g_ary[g_idx].plant,'oma_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'omb_file'),
          " , ",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'tlfc_file'),  
#FUN-A10098---END
          " WHERE ",x_wc CLIPPED,
          " AND oma02 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
          " AND tlfc_file.tlfc01=ima01 AND tlfc_file.tlfc06 = oma02 ",
          " AND tlfc_file.tlfc026 = omb31 ",
          " AND tlfc_file.tlfctype = '",tm.type,"'",                                                  
          " AND omb04=ima01 AND omb01 = oma01 ",
          " AND (oma00 = '21' OR oma00 = '25' ) ",
          " AND omaconf = 'Y' AND omavoid = 'N' ",
          " GROUP BY ",l_groupbyx CLIPPED
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
         #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
          PREPARE r161_prepare4 FROM tmp_sql
          EXECUTE r161_prepare4
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('r161_prepare4:',SQLCA.sqlcode,1)
             EXECUTE del_cmd2 #delete tmpfile
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
             EXIT PROGRAM
          END IF
      END FOR  #for g_inx  dbs
END FUNCTION
 
FUNCTION sort()
DEFINE l_sql    LIKE type_file.chr1000, #No.FUN-680122 VARCHAR(1000)
       l_sql1   LIKE type_file.chr1000, #No.FUN-680122 VARCHAR(500)
       l_delsql LIKE type_file.chr1000, #No.FUN-680122 VARCHAR(500)
       l_updsql LIKE type_file.chr1000, #No.FUN-680122 VARCHAR(500)
       l_no     LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
          sr  RECORD
             #tlf19  VARCHAR(20), #MOD-5C0082
             #tlf01  VARCHAR(20), #MOD-5C0082
              tlf19  LIKE tlf_file.tlf19, #MOD-5C0082 #FUN-660187  #FUN-680017
             #oga03  LIKE oga_file.oga03, #FUN-660187  #FUN-680017
              tlf01  LIKE tlf_file.tlf01, #MOD-5C0082
              amt_n  LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
              bonus  LIKE type_file.num20_6 #No.FUN-680122 DEC(20,6)
          END RECORD
 
###let g_tname(tlf19,tlf01) be unique
   DROP TABLE temp_uniq
   LET l_sql="CREATE TEMP TABLE temp_uniq ", #FUN-680017 #FUN-A10098---BEGIN
             "(tlf19     LIKE tlf_file.tlf19,", #FUN-660187 tlf19->oga03 #FUN-680017
             " tlf01     LIKE tlf_file.tlf01,",   #FUN-560011
             " tlf026    LIKE tlf_file.tlf026,", #出貨單        #No.FUN-550025
             " tlf06     LIKE tlf_file.tlf06,",     #日期
             " tlfccost  LIKE tlf_file.tlfcost,",  #No.FUN-7C0101 add
             " qty       LIKE type_file.num15_3,",#FUN-A20044  #No.TQC-A40139
             " amt       LIKE type_file.num20_6,",
             " cost      LIKE type_file.num20_6,",
             " rq_qty    LIKE type_file.num15_3,",   #FUN-A20044  #No.TQC-A40139
             " rq_amt    LIKE type_file.num20_6,",
             " rq_cost   LIKE type_file.num20_6,",
             " amt_n_s   LIKE type_file.num20_6,",
             " bonus_s   LIKE type_file.num20_6,",
             " amt_n_per LIKE type_file.num20_6,",
             " bonus_per LIKE type_file.num20_6,",
             " uc        LIKE type_file.num20_6) "
#             "(tlf19     VARCHAR(20),", #FUN-660187 tlf19->oga03 #FUN-680017
#             " tlf01     VARCHAR(40),",   #FUN-560011
##             " tlf026    VARCHAR(10),", #出貨單
#             " tlf026    VARCHAR(16),", #出貨單        #No.FUN-550025
#             " tlf06     VARCHAR(10),",     #日期
#             " tlfccost  VARCHAR(40),",  #No.FUN-7C0101 add
#             " qty       DEC(15,3),",
#             " amt       DEC(20,6),",
#             " cost      DEC(20,6),",
#             " rq_qty    DEC(15,3),",
#             " rq_amt    DEC(20,6),",
#             " rq_cost   DEC(20,6),",
#             " amt_n_s   DEC(20,6),",
#             " bonus_s   DEC(20,6),",
#             " amt_n_per DEC(20,6),",
#             " bonus_per DEC(20,6),",
#             " uc        DEC(20,6)) "

#FUN-A10098---END
   PREPARE r161_unique FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('create uniquedi:',SQLCA.sqlcode,1)
   END IF
   EXECUTE r161_unique
   LET l_sql=" INSERT INTO temp_uniq ",
             " SELECT tlf19,tlf01,tlf026,tlf06,tlfccost,sum(qty),sum(amt),sum(cost),", #FUN-660187 tlf19 -> oga03  #FUN-680017  #No.FUN-7C0101
             " sum(rq_qty),sum(rq_amt),sum(rq_cost),0,0,0,0,AVG(uc)",
             " FROM ",g_tname CLIPPED," GROUP BY 1,2,3,4,5 ;",       #No.FUN-7C0101 add 5
             " DELETE FROM ",g_tname CLIPPED,";",
             " INSERT INTO ",g_tname CLIPPED," SELECT * FROM temp_uniq;"
   PREPARE r161_uniquedi FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('insert uniquedi:',SQLCA.sqlcode,1)
   END IF
   EXECUTE r161_uniquedi
 
###get sort field
   LET l_sql=" SELECT tlf19,'',sum(amt-rq_amt),0", #FUN-660187 tlf19 -> oga03  #FUN-680017
             " FROM ",g_tname,
             " WHERE (amt<>0 OR rq_amt <>0 OR qty<>0 OR rq_qty<>0 ",
             " OR cost<>0 OR rq_cost<>0) ",
        " GROUP BY tlf19 ",
        " ORDER BY 3 desc"
   PREPARE r161_sort1 FROM l_sql
   LET l_no=0
   DECLARE r161_sort1_curs CURSOR FOR r161_sort1
   FOREACH r161_sort1_curs INTO sr.*
      LET l_no=l_no+1
      LET l_updsql=" UPDATE ",g_tname,
                  " SET (amt_n_s,amt_n_per)=(",l_no,",",sr.amt_n,")",
                  " WHERE tlf19= '",sr.tlf19  CLIPPED,"'" #FUN-660187  #FUN-680017
      PREPARE pre_upd_sort1 FROM l_updsql
      EXECUTE pre_upd_sort1
   END FOREACH
   LET l_sql=" SELECT tlf19,'',sum(amt-rq_amt),sum(amt-rq_amt-cost+rq_cost)", #FUN-660187 tlf19->oga03  #FUN-680017
             " FROM ",g_tname,
             " WHERE amt<>0 OR rq_amt <>0 OR qty<>0 OR rq_qty<>0 ",
             " OR cost<>0 OR rq_cost<>0 ",
        " GROUP BY tlf19 ",
        " ORDER BY 4 desc"
   PREPARE r161_sort2 FROM l_sql
   LET l_no=0
   DECLARE r161_sort2_curs CURSOR FOR r161_sort2
   FOREACH r161_sort2_curs INTO sr.*
      IF sr.amt_n <0 THEN  # 淨額<0,不排名
         CONTINUE FOREACH
      END IF
      LET l_no=l_no+1
      LET l_updsql=" UPDATE ",g_tname,
                  " SET bonus_s =",l_no,",bonus_per= ",sr.bonus,
                  " WHERE tlf19= '",sr.tlf19  CLIPPED,"'" #FUN-660187  #FUN-680017
      PREPARE pre_upd_sort3 FROM l_updsql
      EXECUTE pre_upd_sort3
   END FOREACH
END FUNCTION
 
REPORT r161_rep(sr)
DEFINE l_last_sw   LIKE type_file.chr1,   #No.FUN-680122 VARCHAR(1)
       dec_name    LIKE azp_file.azp01,   #No.FUN-680122 VARCHAR(10)
       tlf01_desc  LIKE type_file.chr1000,#FUN-660187 30->60 #No.FUN-680122 VARCHAR(60)
       l_occ18     LIKE occ_file.occ18,   #FUN-660187 30->80 #No.FUN-660187 VARCHAR(80)
       l_amt_n     LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
       l_bonus     LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
       l_tlf06     LIKE tlf_file.tlf06,  #No.FUN-580014 #No.FUN-680122 VARCHAR(10)
       i           LIKE type_file.num5,         #TQC-970290  
          sr  RECORD
              tlf19   LIKE tlf_file.tlf19, #MOD-5C0082 #FUN-660187 #FUN-680017
              tlf01   LIKE tlf_file.tlf01, #MOD-5C0082
              tlf026  LIKE tlf_file.tlf026, #出貨單 #No.FUN-550025 #No.FUN-680122 VARCHAR(16)
              tlf06   LIKE tlf_file.tlf06,  #日期 #No.FUN-680122 DETA
              tlfccost LIKE tlfc_file.tlfccost,  #No.FUN-7C0101 VARCHAR(40)
          #    qty     LIKE ima_file.ima26, #No.FUN-680122 DEC(15,3)#FUN-A20044
              qty     LIKE type_file.num15_3, #No.FUN-680122 DEC(15,3)#FUN-A20044
              amt     LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
              cost    LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
           #   rq_qty  LIKE ima_file.ima26, #No.FUN-680122 DEC(15,3)#FUN-A20044
              rq_qty  LIKE type_file.num15_3, #No.FUN-680122 DEC(15,3)#FUN-A20044
              rq_amt  LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
              rq_cost LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
              amt_n_s LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
              bonus_s LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
              amt_n_per LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
              bonus_per LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
              uc      LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
              amt_n   LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
            #  qty_n   LIKE ima_file.ima26, #No.FUN-680122 DEC(15,3)#FUN-A20044
              qty_n   LIKE type_file.num15_3, #No.FUN-680122 DEC(15,3)#FUN-A20044
              cost_n  LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
              uus     LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
              uus1    LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
              bonus   LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
              bonus_r LIKE type_file.num20_6,#No.FUN-680122 DEC(20,6)
              order   LIKE type_file.num20_6  #No.FUN-680122 DEC(20,6)
              END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order,sr.tlf19,sr.tlf01,sr.tlf026,sr.tlf06 #FUN-660187 tlf19->oga03  #FUN-680017
  FORMAT
   PAGE HEADER
      IF NOT cl_null(tm.azh02) THEN
         LET g_x[1] = tm.azh02
      ELSE
         LET g_x[1] = g_x[1] END IF
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      IF tm.dec ='2' THEN LET dec_name=g_x[17]
      ELSE IF tm.dec='3' THEN
              LET dec_name=g_x[18]
           ELSE
              LET dec_name=g_x[16]
           END IF
      END IF
      SELECT azi07 INTO t_azi07 FROM azi_file WHERE azi01 = tm.azk01                      #No.FUN-870151
      LET g_head1 = g_x[11] CLIPPED,tm.azk01 clipped,'/',cl_numfor(tm.azk04,4,t_azi07),   #No.FUN-870151
                    ' ',dec_name CLIPPED,' ',tm.yy1_b USING '####','/',
                    tm.mm1_b USING '##','-',tm.mm1_e USING '##'
      PRINT g_head1
      PRINT g_dash
      LET g_zaa[36].zaa08=g_x[52],tm.azk01[1,3]
      LET g_zaa[38].zaa08=g_x[53],tm.azk01[1,3]
      LET g_zaa[39].zaa08=g_x[54],tm.azk01[1,3]
 
      IF tm.detail NOT MATCHES '[Yy]' THEN
         LET g_zaa[31].zaa08=g_x[10];   #No.FUN-580014
         LET g_zaa[32].zaa08=g_x[24];   #No.FUN-580014
      ELSE
         IF tm.data=3 THEN #出貨單
            LET g_zaa[31].zaa08=g_x[29];   #No.FUN-580014
            LET g_zaa[32].zaa08=g_x[30];   #No.FUN-580014
         ELSE
            LET g_zaa[31].zaa08=g_x[27];   #No.FUN-580014
            LET g_zaa[32].zaa08=g_x[28];   #No.FUN-580014
         END IF
      END IF
      FOR i=1 TO 8                                                                                                                  
          SELECT azp03 INTO g_ary[i].dbs  FROM azp_file WHERE azp01 = g_ary[i].plant                                                
      END FOR                                                                                                                       
                                                                                                                                    
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
            g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],
            g_x[47],g_x[48],g_x[49],g_x[50],g_x[51]          #No.FUN-7C0101 add g_x[51]
      PRINT g_dash1
      LET l_last_sw = 'n'
   ON EVERY ROW
      LET tlf01_desc = ' '
      CASE tm.data
         WHEN 0
              SELECT ima02 INTO tlf01_desc FROM ima_file
              WHERE ima01=sr.tlf01
              IF STATUS=NOTFOUND THEN LET tlf01_desc=null END IF
         WHEN 1
              SELECT oba02 INTO tlf01_desc FROM oba_file
               WHERE oba01=sr.tlf01
         WHEN '2'
              SELECT azf03 INTO tlf01_desc FROM azf_file
               WHERE azf01=sr.tlf01 AND azf02 = 'F' #6818
         WHEN 3
              LET tlf01_desc=null
         OTHERWISE
      END CASE
 
      IF tm.detail matches '[Yy]' THEN
         IF sr.amt_n_per <>0 THEN
            LET sr.amt_n_per=sr.amt_n/sr.amt_n_per*100
         ELSE LET sr.amt_n_per=0 END IF
         IF sr.bonus_per <>0 THEN
            LET sr.bonus_per=sr.bonus/sr.bonus_per*100
         ELSE LET sr.bonus_per=0 END IF
         IF tm.data=3 THEN #印出貨單
 
            PRINT #COLUMN g_c[31],sr.tlf01[1,15], #MOD-5C0082
                  COLUMN g_c[31],sr.tlf01,  #MOD-5C0082
                  COLUMN g_c[32],sr.tlf026,'––',sr.tlf06;
         ELSE
            PRINT #COLUMN g_c[31],sr.tlf01[1,15], #MOD-5C0082
                  COLUMN g_c[31],sr.tlf01,  #MOD-5C0082
                  COLUMN g_c[32],tlf01_desc;
         END IF
      ELSE
         SELECT occ18 INTO l_occ18 FROM occ_file
          WHERE occ01=sr.tlf19 #FUN-660187 #FUN-680017
         IF status=notfound THEN LET l_occ18=null END IF
         IF g_amt_n <>0 THEN
            LET sr.amt_n_per=sr.amt_n/g_amt_n*100
         ELSE LET sr.amt_n_per=0 END IF
         IF g_bonus <>0 THEN
            LET sr.bonus_per=sr.bonus/g_bonus*100
         ELSE LET sr.bonus_per=0 END IF
        #PRINT COLUMN g_c[31],sr.tlf19[1,15], #FUN-660187 tlf19->oga03  #FUN-680017  #MOD-B30724 mark
         PRINT COLUMN g_c[31],sr.tlf19[1,10], #MOD-B30724 add
               COLUMN g_c[32],l_occ18;
      END IF
 
      IF sr.amt_n_s=99999 THEN LET sr.amt_n_s=0 END IF
      IF sr.bonus_s=99999 THEN LET sr.bonus_s=0 END IF
     #MOD-B20050---modify---start---
     #PRINT COLUMN g_c[33],sr.tlfccost CLIPPED,               #No.FUN-7C0101 add
     #      COLUMN g_c[34],cl_numfor(sr.qty,33,g_ccz.ccz27) , #CHI-690007 0->ccz27
     #      COLUMN g_c[35],cl_numfor(sr.amt,34,g_azi03),
     #      COLUMN g_c[36],cl_numfor(sr.uus,35,g_azi03),
     #      COLUMN g_c[37],cl_numfor(sr.cost,36,g_azi03),
     #      COLUMN g_c[38],cl_numfor(sr.uus1,37,g_azi03),
     #      COLUMN g_c[39],cl_numfor(sr.uc,38,2),
     #      COLUMN g_c[40],cl_numfor(sr.rq_qty,39,g_ccz.ccz27), #CHI-690007 0->ccz27
     #      COLUMN g_c[41],cl_numfor(sr.rq_amt,40,g_azi03),
     #      COLUMN g_c[42],cl_numfor(sr.rq_cost,41,g_azi03),
     #      COLUMN g_c[43],cl_numfor(sr.qty_n,42,g_ccz.ccz27), #CHI-690007 0->ccz27
     #      COLUMN g_c[44],cl_numfor(sr.amt_n,43,g_azi03);
      PRINT COLUMN g_c[33],sr.tlfccost CLIPPED,               #No.FUN-7C0101 add
            COLUMN g_c[34],cl_numfor(sr.qty,34,g_ccz.ccz27) , #CHI-690007 0->ccz27
            COLUMN g_c[35],cl_numfor(sr.amt,35,g_ccz.ccz26),  #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[36],cl_numfor(sr.uus,36,g_ccz.ccz26),  #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[37],cl_numfor(sr.cost,37,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[38],cl_numfor(sr.uus1,38,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[39],cl_numfor(sr.uc,39,2),
            COLUMN g_c[40],cl_numfor(sr.rq_qty,40,g_ccz.ccz27), #CHI-690007 0->ccz27
            COLUMN g_c[41],cl_numfor(sr.rq_amt,41,g_ccz.ccz26),  #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[42],cl_numfor(sr.rq_cost,42,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[43],cl_numfor(sr.qty_n,43,g_ccz.ccz27), #CHI-690007 0->ccz27
            COLUMN g_c[44],cl_numfor(sr.amt_n,44,g_ccz.ccz26);   #CHI-C30012 g_azi03->g_ccz.ccz26
     #MOD-B20050---modify---end---
            IF tm.detail matches '[Yy]' THEN
               PRINT COLUMN g_c[45],cl_numfor(0,45,0),
                     COLUMN g_c[46],cl_numfor(0,46,0);
            ELSE
              #PRINT COLUMN g_c[45],cl_numfor(sr.amt_n_s,45,g_azi03),     #MOD-B20050 mark
               PRINT COLUMN g_c[45],cl_numfor(sr.amt_n_s,45,0),           #MOD-B20050 add
                     COLUMN g_c[46],cl_numfor(sr.amt_n_per,46,2) ;
            END IF
            PRINT COLUMN g_c[47],cl_numfor(sr.cost_n,47,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                  COLUMN g_c[48],cl_numfor(sr.bonus,48,0);
            IF tm.detail matches '[Yy]' THEN
               PRINT COLUMN g_c[49],cl_numfor(0,49,0),
                     COLUMN g_c[50],cl_numfor(0,50,2);
            ELSE
               PRINT COLUMN g_c[49],cl_numfor(sr.bonus_s,49,0)  ,
                     COLUMN g_c[50],cl_numfor(sr.bonus_per,50,2);
            END IF
            PRINT COLUMN g_c[51],cl_numfor(sr.bonus_r,51,2)
   AFTER GROUP OF sr.tlf19 #FUN-660187 tlf19->oga03 #FUN-680017
      SELECT occ18 INTO l_occ18 FROM occ_file
      WHERE occ01=sr.tlf19 #FUN-660187 tlf19->oga03 #FUN-680017
      IF status=notfound THEN LET l_occ18=null END IF
      IF tm.detail MATCHES '[Yy]' THEN
         PRINT g_dash2
         PRINT COLUMN g_c[31],sr.tlf19[1,10],  #FUN-660187 tlf19->oga03 #FUN-680017
               COLUMN g_c[32],l_occ18 CLIPPED,g_x[26] CLIPPED,
              #MOD-B20050---modify---start---
              #COLUMN g_c[34],cl_numfor(GROUP SUM(sr.qty),33,g_ccz.ccz27), #CHI-690007 0->ccz27
              #COLUMN g_c[35],cl_numfor(GROUP SUM(sr.amt),34,g_azi03),
              #COLUMN g_c[36],cl_numfor(0,35,0),
              #COLUMN g_c[37],cl_numfor(GROUP SUM(sr.cost),36,g_azi03),
              #COLUMN g_c[38],cl_numfor(0,37,0),
              #COLUMN g_c[39],cl_numfor(0,38,0),
              #COLUMN g_c[40],cl_numfor(GROUP SUM(sr.rq_qty),39,g_ccz.ccz27), #CHI-690007 0->ccz27
              #COLUMN g_c[41],cl_numfor(GROUP SUM(sr.rq_amt),40,g_azi03),
              #COLUMN g_c[42],cl_numfor(GROUP SUM(sr.rq_cost),41,g_azi03),
              #COLUMN g_c[43],cl_numfor(GROUP SUM(sr.qty_n),42,g_ccz.ccz27), #CHI-690007 0->ccz27
              #COLUMN g_c[44],cl_numfor(GROUP SUM(sr.amt_n),43,g_azi03),
              #COLUMN g_c[45],cl_numfor((sr.amt_n_s),44,g_azi03) ;
               COLUMN g_c[34],cl_numfor(GROUP SUM(sr.qty),34,g_ccz.ccz27), #CHI-690007 0->ccz27
               COLUMN g_c[35],cl_numfor(GROUP SUM(sr.amt),35,g_ccz.ccz26),  #CHI-C30012 g_azi03->g_ccz.ccz26
               COLUMN g_c[36],cl_numfor(0,36,0),
               COLUMN g_c[37],cl_numfor(GROUP SUM(sr.cost),37,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
               COLUMN g_c[38],cl_numfor(0,38,0),
               COLUMN g_c[39],cl_numfor(0,39,0),
               COLUMN g_c[40],cl_numfor(GROUP SUM(sr.rq_qty),40,g_ccz.ccz27), #CHI-690007 0->ccz27
               COLUMN g_c[41],cl_numfor(GROUP SUM(sr.rq_amt),41,g_ccz.ccz26),  #CHI-C30012 g_azi03->g_ccz.ccz26
               COLUMN g_c[42],cl_numfor(GROUP SUM(sr.rq_cost),42,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
               COLUMN g_c[43],cl_numfor(GROUP SUM(sr.qty_n),43,g_ccz.ccz27), #CHI-690007 0->ccz27
               COLUMN g_c[44],cl_numfor(GROUP SUM(sr.amt_n),44,g_ccz.ccz26),   #CHI-C30012 g_azi03->g_ccz.ccz26
               COLUMN g_c[45],cl_numfor((sr.amt_n_s),45,0) ;
              #MOD-B20050---modify---end---
            IF g_amt_n <>0 THEN
               PRINT COLUMN g_c[46],cl_numfor(GROUP SUM(sr.amt_n)/g_amt_n*100,46,2);
            ELSE
               PRINT COLUMN g_c[46],cl_numfor(0,46,2);
            END IF
         PRINT COLUMN g_c[47],cl_numfor(GROUP SUM(sr.cost_n),47,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
               COLUMN g_c[48],cl_numfor(GROUP SUM(sr.bonus),48,0),
               COLUMN g_c[49],cl_numfor(sr.bonus_s,49,0);
            IF g_bonus <>0 THEN
               PRINT COLUMN g_c[50],cl_numfor(GROUP SUM(sr.bonus)/g_bonus*100,50,2);
            ELSE
               PRINT COLUMN g_c[50],cl_numfor(0,50,2);
            END IF
            IF GROUP sum(sr.amt_n) <>0 THEN
               PRINT COLUMN g_c[51],cl_numfor(GROUP SUM(sr.bonus)/GROUP SUM(sr.amt_n)*100,51,2)
            ELSE
               PRINT COLUMN g_c[51],cl_numfor(0,51,2)
            END IF
        PRINT g_dash2
      END IF
   ON LAST ROW
      IF tm.detail NOT MATCHES '[Yy]' THEN
         PRINT g_dash
      END IF
      PRINT COLUMN g_c[32],g_x[25] CLIPPED,
            COLUMN g_c[34],cl_numfor(SUM(sr.qty),34,g_ccz.ccz27) , #CHI-690007 0->ccz27
            COLUMN g_c[35],cl_numfor(SUM(sr.amt),35,g_ccz.ccz26),  #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[37],cl_numfor(SUM(sr.cost),37,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[40],cl_numfor(SUM(sr.rq_qty),40,g_ccz.ccz27), #CHI-690007 0->ccz27
            COLUMN g_c[41],cl_numfor(SUM(sr.rq_amt),41,g_ccz.ccz26)  , #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[42],cl_numfor(SUM(sr.rq_cost),42,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[43],cl_numfor(SUM(sr.qty_n),43,g_ccz.ccz27),  #CHI-690007 0->ccz27
            COLUMN g_c[44],cl_numfor(SUM(sr.amt_n),44,g_ccz.ccz26),  #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[47],cl_numfor(SUM(sr.cost_n),47,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[48],cl_numfor(SUM(sr.bonus) ,48,0);
            IF sum(sr.amt_n) <>0 THEN
               PRINT COLUMN g_c[51],cl_numfor(SUM(sr.bonus)/sum(sr.amt_n)*100 ,51,2)
            ELSE
               PRINT COLUMN g_c[51],cl_numfor(0,51,2)
            END IF
      PRINT g_dash
      PRINT ' data from : ',
            g_ary[1].dbs CLIPPED,' ', g_ary[2].dbs CLIPPED,' ',                                                                     
            g_ary[3].dbs CLIPPED,' ', g_ary[4].dbs CLIPPED,' ',                                                                     
            g_ary[5].dbs CLIPPED,' ', g_ary[6].dbs CLIPPED,' ',                                                                     
            g_ary[7].dbs CLIPPED,' ', g_ary[8].dbs CLIPPED                                                                          
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(g_wc,'tlf15,ima06')
              RETURNING tm.wc
             
             CALL cl_prt_pos_wc(tm.wc)
      END IF
      IF tm.sum_code matches '[Yy]' THEN
         PRINT '   ',g_x[21],g_x[22],g_x[23],' ',g_x[12],g_x[13],g_x[14],'   ',
               g_x[19],g_x[20]
         PRINT cl_numfor(g_sum.qty ,12,g_ccz.ccz27), #CHI-690007 2->ccz27
               cl_numfor(g_sum.amt ,12,g_ccz.ccz26),    #FUN-570190  #CHI-C30012 g_azi03->g_ccz.ccz26
               cl_numfor(g_sum.cost ,12,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
               cl_numfor(g_sum.qty1 ,12,g_ccz.ccz27), #CHI-690007 2->ccz27
               cl_numfor(g_sum.amt1,12,g_ccz.ccz26),    #FUN-570190  #CHI-C30012 g_azi03->g_ccz.ccz26
               cl_numfor(g_sum.cost1,12,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
               cl_numfor(g_sum.ome_amt,12,g_ccz.ccz26), #折讓    #FUN-570190  #CHI-C30012 g_azi03->g_ccz.ccz26
               cl_numfor(g_sum.oma_amt,12,g_ccz.ccz26)  #雜項發票    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
      END IF
      PRINT g_dash[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_last_sw='y'
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
 
FUNCTION duplicate(l_plant,n)               #檢查輸入之工廠編號是否重覆
   DEFINE l_plant     LIKE azp_file.azp01
   DEFINE l_idx,n     LIKE type_file.num10  #No.FUN-680122 INTEGER
 
   FOR l_idx = 1 TO n
       IF g_ary[l_idx].plant = l_plant THEN
          LET l_plant = ''
       END IF
   END FOR
   RETURN l_plant
END FUNCTION
 
FUNCTION get_dpm()
DEFINE l_sql STRING,
       l_wc  STRING,
       l_sql1 STRING,
       tmp_sql STRING,
       x_wc STRING, #FUN-660187
       f1,f2,f3   LIKE type_file.num20_6,#No.FUN-680122 DECIMAL(20,6)
       l_title    LIKE type_file.chr1000,#No.FUN-680122 VARCHAR(100)
       l_groupby  LIKE type_file.chr1000,#No.FUN-680122 VARCHAR(100)
       l_dpm RECORD
             #tlf19  VARCHAR(20), #MOD-5C0082
             #tlf01  VARCHAR(20), #MOD-5C0082
              tlf19  LIKE tlf_file.tlf19, #MOD-5C0082 #FUN-660187  #FUN-680017
             #oga03  LIKE oga_file.oga03, #MOD-5C0082 #FUN-660187  #FUN-680017
              tlf01  LIKE tlf_file.tlf01, #MOD-5C0082
              tlfccost LIKE tlfc_file.tlfccost, #No.FUN-7C0101 VARCHAR(40)
            #  qty    LIKE ima_file.ima26, #數量(銷) #No.FUN-680122 DEC(15,3)#FUN-A20044
              qty    LIKE type_file.num15_3, #數量(銷) #No.FUN-680122 DEC(15,3)#FUN-A20044
              amt    LIKE type_file.num20_6,#金額(銷) #No.FUN-680122 DEC(20,6)
              cost   LIKE type_file.num20_6,#成本(銷) #No.FUN-680122 DEC(20,6)
            #  qty1   LIKE ima_file.ima26, #數量(退) #No.FUN-680122 DEC(15,3)#FUN-A20044
              qty1   LIKE type_file.num15_3, #數量(退) #No.FUN-680122 DEC(15,3)#FUN-A20044
              amt1   LIKE type_file.num20_6,#金額(退) #No.FUN-680122 DEC(20,6)
              cost1  LIKE type_file.num20_6,#成本(退) #No.FUN-680122 DEC(20,6)
              ome_amt LIKE type_file.num20_6,#折讓 #No.FUN-680122 DEC(20,6)
              oma_amt LIKE type_file.num20_6 #雜項發票 #No.FUN-680122 DEC(20,6)
              END RECORD
 
LET g_tname1='r161_tmp1'                      #No.TQC-980163 mod
LET g_delsql1= " DROP TABLE ",g_tname1 CLIPPED
PREPARE del_dpm FROM g_delsql1
     LET g_delsql1= " DROP TABLE ",g_tname1 CLIPPED
     PREPARE del_dpm3 FROM g_delsql1
     EXECUTE del_dpm3
LET tmp_sql=
#   "CREATE TABLE ",g_tname1 CLIPPED,  #No.TQC-970305 mark
    "CREATE TEMP TABLE ",g_tname1 CLIPPED,  #No.TQC-970305 mod #FUN-A10098---BEGIN
             "(tlf19   LIKE tlf_file.tlf19,",  #FUN-660187 tlf19->oga03 #FUN-680017
             " tlf01   LIKE tlf_file.tlf01,",   #FUN-560011
             " tlfccost LIKE tlf_file.tlfcost,",  #No.FUN-7C0101 add
             " qty     LIKE type_file.num15_3,",  #數量(銷)#FUN-A20044  #No.TQC-A40139
             " amt     LIKE type_file.num20_6,",  #金額(銷)
             " cost    LIKE type_file.num20_6,",  #成本(銷)
             " qty1    LIKE type_file.num15_3,",  #數量(退)#FUN-A20044  #No.TQC-A40139
             " amt1    LIKE type_file.num20_6,",  #金額(退)
             " cost1   LIKE type_file.num20_6,",  #成本(退)
             " ome_amt LIKE type_file.num20_6,", #折讓
             " oma_amt LIKE type_file.num20_6)" #雜項發票
#             "(tlf19   VARCHAR(20),",  #FUN-660187 tlf19->oga03 #FUN-680017
#             " tlf01   VARCHAR(40),",   #FUN-560011
#             " tlfccost VARCHAR(40),",  #No.FUN-7C0101 add
#             " qty     DEC(15,3),",  #數量(銷)
#             " amt     DEC(20,6),",  #金額(銷)
#             " cost    DEC(20,6),",  #成本(銷)
#             " qty1    DEC(15,3),",  #數量(退)
#             " amt1    DEC(20,6),",  #金額(退)
#             " cost1   DEC(20,6),",  #成本(退)
#             " ome_amt DEC(20,6),", #折讓
#             " oma_amt DEC(20,6))" #雜項發票

#FUN-A10098---END
    PREPARE cre_dpm FROM tmp_sql
    EXECUTE cre_dpm
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('Create tmp_dpm:' ,SQLCA.sqlcode,1)
       EXECUTE del_cmd2 #delete tmpfile
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
       EXIT PROGRAM
    END IF
 
    IF tm.detail matches '[Yy]' THEN #要印明細
       CASE tm.data
         WHEN 0 LET l_title= "tlf19,tlf01,"  #FUN-660187 tlf19->oga03 #FUN-680017
         WHEN 1 LET l_title= "tlf19,ima131," #FUN-660187 tlf19->oga03 #FUN-680017
         WHEN 2 LET l_title= "tlf19,ima11,"  #FUN-660187 tlf19->oga03 #FUN-680017
         WHEN 3 LET l_title= "tlf19,tlf01,"  #FUN-660187 tlf19->oga03 #FUN-680017
       END CASE
    ELSE
       LET l_title="tlf19,''," #FUN-660187 tlf19->oga03 #FUN-680017
    END IF
    LET l_title=l_title,"tlfccost,"   #No.FUN-7C0101
    LET l_groupby = s_groupby(l_title CLIPPED)
 
###內部自用銷貨
    FOR g_idx=1 TO g_k
          LET tmp_sql= " INSERT INTO ",g_tname1,
          " SELECT ",l_title CLIPPED,
     #       異動數量                 銷售金額          成會異動成本
         " sum(tlf10*tlf60),sum(ogb14*oga24),sum(tlfc21), ", #MOD-570085  #No.FUN-7C0101 tlf21->tlfc21
          " 0,0,0,0,0",
#FUN-A10098---BEGIN
#          " FROM ",g_ary[g_idx].dbs_new CLIPPED,"tlf_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"smy_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"occ_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"oga_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ogb_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"tlfc_file",             #No.FUN-7C0101 add
          " FROM ",cl_get_target_table(g_ary[g_idx].plant,'tlf_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'smy_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'occ_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'oga_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ogb_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'tlfc_file'), 
#FUN-A10098---END
          " WHERE ",g_wc CLIPPED,
          " AND (tlf03 = 724 OR tlf03 = 72) AND tlf02 = 50 ",
          " AND tlf61=smyslip AND smydmy1 = 'Y' ",
          " AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",         
          " AND tlf01=ima01 AND tlf19 = occ01 AND occ37 = 'Y' ",  #FUN-660187 tlf19->oga03  #FUN-680017
          " AND tlf036=ogb01 AND tlf037=ogb03 AND ogb01=oga01 AND oga09 NOT IN ('1','5','7','9') ",     #MOD-4C0078  #No.FUN-610020
          " AND oga00 NOT IN ('A','3','7') ",     #No.MOD-950210 add
          " AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
          " AND tlfc_file.tlfc01 = tlf01 AND tlfc_file.tlfc02 = tlf02 ",                                                                                
          " AND tlfc_file.tlfc03 = tlf03 AND tlfc_file.tlfc06 = tlf06",           #No.FUN-830002                                                        
          " AND tlfc_file.tlfc13 = tlf13",                              #No.FUN-830002                                                        
          " AND tlfc_file.tlfc902 = tlf902 AND tlfc_file.tlfc903 = tlf903",       #No.FUN-830002                                                        
          " AND tlfc_file.tlfc904 = tlf904 AND tlfc_file.tlfc905 = tlf905",       #No.FUN-830002                                                        
          " AND tlfc_file.tlfc906 = tlf906 AND tlfc_file.tlfc907 = tlf907",
          " AND tlfc_file.tlfctype = '",tm.type,"'",                                                  
          " GROUP BY ",l_groupby CLIPPED
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
         #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql     #FUN-A10098  #TQC-BB0182 mark
          PREPARE r161_predpm FROM tmp_sql
          EXECUTE r161_predpm
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('predpm:',SQLCA.sqlcode,1)
             EXECUTE del_cmd2 #delete tmpfile
             EXECUTE del_dpm
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
             EXIT PROGRAM
         END IF
    END FOR
###內部自用退貨
    FOR g_idx=1 TO g_k
          LET tmp_sql= " INSERT INTO ",g_tname1,
          " SELECT ",l_title CLIPPED,
         " 0,0,0,sum(tlf10*tlf60),sum(ohb14*oha24), ", #MOD-570085
        " sum(tlfc21),0,0 ",                           #No.FUN-7C0101 tlf21->tlfc21
#FUN-A10098---BEGIN
#          " FROM ",g_ary[g_idx].dbs_new CLIPPED,"tlf_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"smy_file",
#         " ,",g_ary[g_idx].dbs_new CLIPPED,"occ_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"oha_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ohb_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"tlfc_file",             #No.FUN-7C0101 add
          " FROM ",cl_get_target_table(g_ary[g_idx].plant,'tlf_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'smy_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'occ_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'oha_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ohb_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'tlfc_file'), 
#FUN-A10098---END
          " WHERE ",g_wc CLIPPED,  #FUN-660187  #FUN-680017
          " AND tlf02 = 731 AND tlf03 = 50 ",
          " AND tlf61=smyslip AND smydmy1 = 'Y' ",
          " AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",        
          " AND tlf01=ima01 AND oha03 = occ01 AND occ37 = 'Y' ",
          " AND tlf036=ohb01 AND tlf037=ohb03 AND ohb01=oha01 ",
          " AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
          " AND tlfc_file.tlfc01 = tlf01 AND tlfc_file.tlfc02 = tlf02 ",                                                                                
          " AND tlfc_file.tlfc03 = tlf03 AND tlfc_file.tlfc06 = tlf06",           #No.FUN-830002                                                        
          " AND tlfc_file.tlfc13 = tlf13",                              #No.FUN-830002                                                        
          " AND tlfc_file.tlfc902 = tlf902 AND tlfc_file.tlfc903 = tlf903",       #No.FUN-830002                                                        
          " AND tlfc_file.tlfc904 = tlf904 AND tlfc_file.tlfc905 = tlf905",       #No.FUN-830002                                                        
          " AND tlfc_file.tlfc906 = tlf906 AND tlfc_file.tlfc907 = tlf907",
          " AND tlfc_file.tlfctype = '",tm.type,"'",                                                  
          " GROUP BY ",l_groupby CLIPPED
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
         #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark

          PREPARE r161_pregsl FROM tmp_sql
          EXECUTE r161_pregsl
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('pregsl:',SQLCA.sqlcode,1)
             EXECUTE del_cmd2 #delete tmpfile
             EXECUTE del_dpm
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
             EXIT PROGRAM
          END IF
    END FOR
    IF tm.detail matches '[Yy]' THEN #要印料件
       CASE tm.data
         WHEN 0 LET l_title= "oma03,omb04,"
         WHEN 1 LET l_title= "oma03,ima131,"
         WHEN 2 LET l_title= "oma03,ima11,"
         WHEN 3 LET l_title= "oma03,omb04,"
       END CASE
    ELSE
       LET l_title="oma03,'',"
    END IF
    LET l_groupby = s_groupby(l_title CLIPPED)
###折讓
    LET l_wc=g_wc
    LET l_wc=change_string(l_wc,"tlf026","omb31")
    LET l_wc=change_string(l_wc,"tlf01","omb04")
    LET l_wc=change_string(l_wc,"tlf19","oma03") #FUN-660187 tlf19->oga03  #FUN-680017
    FOR g_idx=1 TO g_k
          LET tmp_sql= " INSERT INTO ",g_tname1,
          " SELECT ",l_title CLIPPED,
          " 0,0,0,0,0,0,0,SUM(omb16),0 ",   #No.FUN-7C0101 add 0
#FUN-A10098---BEGIN
#          " FROM ",g_ary[g_idx].dbs_new CLIPPED,"oma_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"omb_file",
#        # " ,",g_ary[g_idx].dbs_new CLIPPED,"ome_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"tlfc_file",             #No.FUN-7C0101 add
          " FROM ",cl_get_target_table(g_ary[g_idx].plant,'oma_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'omb_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'tlfc_file'),
#FUN-A10098---END
          " WHERE oma00='25' ", #銷貨折讓
          " AND ",l_wc CLIPPED,
          " AND oma02 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
          " AND omb04[1,4] <> 'MISC'",  #MOD-710129 mod
          " AND omb01=oma01 AND omavoid = 'N' ",
          " AND omb04=ima01 ",
          " AND tlfc_file.tlfc01 = omb04  ",
          " AND tlfc_file.tlfc026 = omb31 ",        
          " AND tlfc_file.tlfctype = '",tm.type,"'",                                                  
          " GROUP BY ",l_groupby CLIPPED
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
         #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
          PREPARE r161_preome FROM tmp_sql
          EXECUTE r161_preome
          IF SQLCA.sqlcode != 0 THEN
             EXECUTE del_cmd2 #delete tmpfile
             EXECUTE del_dpm
             CALL cl_err('preome:',SQLCA.sqlcode,1)
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
             EXIT PROGRAM
          END IF
    END FOR
###雜項發票
    FOR g_idx=1 TO g_k
          LET tmp_sql= " INSERT INTO ",g_tname1,
          " SELECT ",l_title CLIPPED,
          " 0,0,0,0,0,0,0,0,SUM(omb16) ",    #No.FUN-7C0101 add 0
#FUN-A10098---BEGIN
#          " FROM ",g_ary[g_idx].dbs_new CLIPPED,"oma_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"omb_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ome_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"tlfc_file",             #No.FUN-7C0101 add
          " FROM ",cl_get_target_table(g_ary[g_idx].plant,'oma_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'omb_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ome_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'tlfc_file'),
#FUN-A10098---END
          " WHERE oma00='14' ",
          " AND ",l_wc CLIPPED,
          " AND oma02 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
          " AND oma10=ome01 AND omb04[1,4] <> 'MISC'", #MOD-710129 mod
          " AND omb01=oma01 AND omevoid = 'N' ",
          " AND (oma75 = ome03 OR oma75 IS NULL)",    #No.FUN-B90130 
          " AND omb04=ima01 ",
          " AND tlfc_file.tlfc01 = omb04  ",
          " AND tlfc_file.tlfc026 = omb31 ",        
          " AND tlfc_file.tlfctype = '",tm.type,"'",                                                  
          " GROUP BY ",l_groupby CLIPPED
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
         #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
          PREPARE r161_preoma FROM tmp_sql
          EXECUTE r161_preoma
          IF SQLCA.sqlcode != 0 THEN
             EXECUTE del_cmd2 #delete tmpfile
             EXECUTE del_dpm
             CALL cl_err('preoma:',SQLCA.sqlcode,1)
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
             EXIT PROGRAM
          END IF
    END FOR
  ### 98.08.10 Star 折讓及內部自用部份前面已算進去..
  
 
  
  IF tm.sum_code matches '[Yy]' THEN
     LET l_sql=" SELECT sum(qty),sum(amt),sum(cost),",
             "sum(qty1),sum(amt1),sum(cost1),sum(ome_amt),sum(oma_amt)",
             " FROM ",g_tname1 CLIPPED
             PREPARE r161_sum FROM l_sql
             DECLARE sum_cursor CURSOR FOR r161_sum
             OPEN sum_cursor
             FETCH sum_cursor INTO g_sum.*
    IF g_sum.qty IS NULL THEN LET g_sum.qty=0 END IF
    IF g_sum.amt IS NULL THEN LET g_sum.amt=0 END IF
    IF g_sum.cost IS NULL THEN LET g_sum.cost=0 END IF
    IF g_sum.qty1 IS NULL THEN LET g_sum.qty1=0 END IF
    IF g_sum.amt1 IS NULL THEN LET g_sum.amt1=0 END IF
    IF g_sum.cost1 IS NULL THEN LET g_sum.cost1=0 END IF
    IF g_sum.oma_amt IS NULL THEN LET g_sum.oma_amt=0 END IF
    IF g_sum.ome_amt IS NULL THEN LET g_sum.ome_amt=0 END IF
    IF g_sum.ome_amt=' ' THEN LET g_sum.ome_amt=0 END IF
  END IF
  EXECUTE del_dpm
END FUNCTION
 
FUNCTION change_string(old_string, old_sub, new_sub)
DEFINE query_text   LIKE type_file.chr1000 #No.FUN-680122 VARCHAR(300)
DEFINE AA           LIKE type_file.chr1    #No.FUN-680122 VARCHAR(1)
 
DEFINE old_string   LIKE type_file.chr1000,#No.FUN-680122 VARCHAR(300)
       xxx_string   LIKE type_file.chr1000,#No.FUN-680122 VARCHAR(300)
       old_sub      LIKE type_file.chr1000,#No.FUN-680122 VARCHAR(128)
       new_sub      LIKE type_file.chr1000,#No.FUN-680122 VARCHAR(128)
       first_byte   LIKE type_file.chr1,   #No.FUN-680122 VARCHAR(01)
       nowx_byte    LIKE type_file.chr1,   #No.FUN-680122 VARCHAR(01)
       next_byte    LIKE type_file.chr1,   #No.FUN-680122 VARCHAR(01)
       this_byte    LIKE type_file.chr1,   #No.FUN-680122 VARCHAR(01)
       length1, length2, length3   LIKE type_file.num5,   #No.FUN-680122 smallint
                     pu1, pu2      LIKE type_file.num5,   #No.FUN-680122 smallint
       ii, jj, kk, ff, tt          LIKE type_file.num5    #No.FUN-680122 smallint
 
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
 
FUNCTION r161_chkplant(l_plant)
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
FUNCTION r161_set_visible()
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_azw05  LIKE azw_file.azw05

  SELECT azw05 INTO l_azw05 FROM azw_file WHERE azw01 = g_plant
  SELECT count(*) INTO l_cnt FROM azw_file
   WHERE azw05 = l_azw05

  IF l_cnt > 1 THEN
     CALL cl_set_comp_visible("group03",FALSE)
  END IF
  RETURN l_cnt
END FUNCTION

FUNCTION r161_chklegal(l_legal,n)
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
