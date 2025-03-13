# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcr170.4gl
# Descriptions...: 關係人營業額與總營業額比較表
# Date & Author..:
# Modify.........: No:8488 tm.azk01='TWD' 改為 tm.azk01=g_aza.aza17
# Modify ........: No:8741 03/11/25 By Melody 修改PRINT段
# Modify.........: No.FUN-4B0064 04/11/25 By Carol 加入"匯率計算"功能
# Modify.........: No.FUN-4C0071 04/12/13 By pengu  匯率幣別欄位修改，與aoos010的azi17做判斷，
                                                   #如果二個幣別相同時，匯率強制為 1
# Modify.........: No.FUN-4C0099 04/12/29 By kim 報表轉XML功能
# Modify.........: No.MOD-530122 05/03/16 By Carol QBE欄位順序調整
# Modify.........: No.MOD-530181 05/03/21 By kim Define金額單價位數改為DEC(20,6)
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-570190 05/08/08 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.MOD-570086 05/07/05 By kim 沒有進行單位換算(tlf10->tlf10*tlf60)
# Modify.........: No.FUN-5B0123 05/12/08 By Sarah 應排除出至境外倉部份(add oga00<>'3')
# Modify.........: No.FUN-610020 06/01/10 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.TQC-610051 06/02/22 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-670039 06/07/12 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-660126 06/07/24 By rainy remove s_chknplt
# Modify.........: No.FUN-670098 06/07/24 By rainy 排除不納入成本計算倉庫
# Modify.........: No.FUN-680122 06/09/01 By zdyllq 類型轉換 
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-6A0078 06/11/09 By ice 修正報表格式錯誤;修正FUN-6A0146/FUN-680122改錯部分
# Modify.........: No.CHI-690007 06/12/26 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.MOD-710129 07/01/23 By jamie MISC的判斷需取前四碼 
# Modify.........: No.Fun-7C0101 08/01/28 By Zhangyajun 成本改善增加成本計算類型字段(type)
# Modify.........: No.FUN-830002 08/03/03 By dxfwo 成本改善的index之前改過后出現報表打印不出來的問題修改
# Modify.........: No.FUN-870151 08/08/15 By xiaofeizhu  匯率調整為用azi07取位
# Modify.........: No.FUN-940102 09/04/24 BY destiny 檢查使用者的資料庫使用權限
# Modify.........: No.MOD-950210 09/05/26 By Pengu “寄銷出貨”不應納入 “銷貨收入”
# Modify.........: No.TQC-970305 09/07/30 By liuxqa create table 改為CREATE TEMP TABLE.
# Modify.........: No.TQC-980163 09/09/01 By liuxqa 將產生的table名寫死。
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-970199 09/09/22 By baofei 1.oga09 IN ('2',,'3','8')2和3中間多一個,                                        
#                                                   2.tmp_sql改為string                                                             
#                                                   3.修改打印營運中心改為打印資料庫  
# Modify.........: No.TQC-980293 09/10/14 By baofei PREPARE r170_prepare0 sql中" GROUP BY 1，2" 改為GROUP BY MONTH(tlf06),tlfccost  
# Modify.........: No.FUN-A10098 10/01/19 By baofei GP5.2跨DB報表--財務類
# Modify.........: No.FUN-9C0073 10/01/26 By chenls 程序精簡
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26*
# Modify.........: No.FUN-A70084 10/07/26 By lutingting GP5.2報表修改
# Modify.........: No:CHI-B70039 11/08/04 By joHung 金額 = 計價數量 x 單價
# Modify.........: No:FUN-B90130 11/11/03 By wujie  增加oma75的条件  
# Modify.........: No.TQC-BB0182 12/01/13 By pauline 取消過濾plant條件
# Modify.........: No:CHI-C30012 12/07/27 By bart 金額取位改抓ccz26

DATABASE ds
 
GLOBALS "../../config/top.global"
    DEFINE g_wc,g_wc1 string  #No.FUN-580092 HCN
   DEFINE tm  RECORD
              tlf19   LIKE tlf_file.tlf19, #客戶編號
              tlf01   LIKE tlf_file.tlf01, #料號
              ima131  LIKE ima_file.ima131,    # Prog. Version..: '5.30.06-13.03.12(04)           #產品分類
              ima11   LIKE ima_file.ima11,     # Prog. Version..: '5.30.06-13.03.12(04)            #其他分群三
              ima12   LIKE ima_file.ima12, #成本分群
              yy1_b,mm1_b,mm1_e LIKE type_file.num5,           #No.FUN-680122SMALLINT
              plant_1,plant_2,plant_3,plant_4,plant_5 LIKE cre_file.cre08,           #No.FUN-680122CHAR(10)
              plant_6,plant_7,plant_8 LIKE cre_file.cre08,           #No.FUN-680122CHAR(10)
              type    LIKE type_file.chr1,           #No.FUN-7C0101 VARCHAR(1)
              sum_code LIKE type_file.chr1,           #No.FUN-680122CHAR(01)
              azk01   LIKE azk_file.azk01,
              azk04   LIKE azk_file.azk04,
              azh01   LIKE azh_file.azh01,
              azh02   LIKE azh_file.azh02,
              dec     LIKE type_file.chr1,           # Prog. Version..: '5.30.06-13.03.12(01)       #金額單位(1)元(2)千(3)萬
              more    LIKE type_file.chr1            #No.FUN-680122CHAR(01)
              END RECORD
 
   DEFINE g_bdate,g_edate  LIKE type_file.dat            #No.FUN-680122DATE
   DEFINE g_bookno      LIKE aaa_file.aaa01    #No.FUN-670039
   DEFINE g_base      LIKE type_file.num10,          #No.FUN-680122INTEGER
          g_amt_n     LIKE oeb_file.oeb13,         #No.FUN-680122 DECIMAL(20,6)
          g_bonus     LIKE oeb_file.oeb13          #No.FUN-680122DEC(20,6)
   DEFINE  #multi fac
           g_delsql   LIKE type_file.chr1000,              #execute sys_cmd        #No.FUN-680122CHAR(50)
           g_tname    LIKE type_file.chr20,          #No.FUN-680122CHAR(20)               #tmpfile name
           g_tname1   LIKE type_file.chr20,          #No.FUN-680122CHAR(20)               #tmpfile name
           g_delsql1  LIKE type_file.chr1000,              #execute sys_cmd        #No.FUN-680122CHAR(50)
           g_idx,g_k  LIKE type_file.num10,          #No.FUN-680122INTEGER
           g_ary DYNAMIC ARRAY OF RECORD          #被選擇之工廠
           plant      LIKE cre_file.cre08,           #No.FUN-680122CHAR(10)
           dbs        LIKE type_file.chr1000,        #TQC-970199   
           dbs_new    LIKE type_file.chr1000         #No.FUN-680122CHAR(21)
           END RECORD ,
           g_tmp DYNAMIC ARRAY OF RECORD          #被選擇之工廠
           p          LIKE cre_file.cre08,           #No.FUN-680122CHAR(08)
           d          LIKE type_file.chr1000         #No.FUN-680122CHAR(21)
           END RECORD ,
           g_sum RECORD
             # qty    LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3)  #數量(內銷)#FUN-A20044
              qty    LIKE type_file.num15_3,           #No.FUN-680122DEC(15,3)  #數量(內銷)#FUN-A20044
              amt    LIKE oeb_file.oeb13,         #No.FUN-680122DEC(20,6)  #金額(內銷)
              cost   LIKE oeb_file.oeb13,         #No.FUN-680122DEC(20,6)  #成本(內銷)
            #  qty1   LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3)  #數量(內退)#FUN-A20044
              qty1   LIKE type_file.num15_3,           #No.FUN-680122DEC(15,3)  #數量(內退)#FUN-A20044
              amt1   LIKE oeb_file.oeb13,         #No.FUN-680122DEC(20,6)  #金額(內退)
              cost1  LIKE oeb_file.oeb13,         #No.FUN-680122DEC(20,6)  #成本(內退)
              dae_amt LIKE oeb_file.oeb13,         #No.FUN-680122DEC(20,6) #折讓
              dac_amt LIKE oeb_file.oeb13          #No.FUN-680122DEC(20,6)  #雜項發票
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE   m_legal         ARRAY[10] OF LIKE azw_file.azw02   #FUN-A70084
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
   LET g_pdate  = ARG_VAL(1)        
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET g_wc    = ARG_VAL(7)
   LET tm.yy1_b   = ARG_VAL(8)
   LET tm.mm1_b   = ARG_VAL(9)
   LET tm.mm1_e   = ARG_VAL(10)
   LET tm.plant_1 = ARG_VAL(11)
   LET tm.plant_2 = ARG_VAL(12)
   LET tm.plant_3 = ARG_VAL(13)
   LET tm.plant_4 = ARG_VAL(14)
   LET tm.plant_5 = ARG_VAL(15)
   LET tm.plant_6 = ARG_VAL(16)
   LET tm.plant_7 = ARG_VAL(17)
   LET tm.plant_8 = ARG_VAL(18)
   LET tm.sum_code= ARG_VAL(19)
   LET tm.azk01   = ARG_VAL(20)
   LET tm.azk04   = ARG_VAL(21)
   LET tm.azh01   = ARG_VAL(22)
   LET tm.azh02   = ARG_VAL(23)
   LET tm.dec     = ARG_VAL(24)
   LET g_rep_user = ARG_VAL(25)
   LET g_rep_clas = ARG_VAL(26)
   LET g_template = ARG_VAL(27)
   LET g_bookno = ARG_VAL(28)
   LET tm.type    = ARG_VAL(29)  #No.FUN-7C0101 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r170_tm(0,0)
      ELSE CALL r170()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION r170_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_date         LIKE type_file.dat,           #No.FUN-680122DARE
          l_cmd          LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
   DEFINE l_cnt          LIKE type_file.num5           #No.FUN-A70084
 
   IF p_row = 0 THEN LET p_row = 2 LET p_col = 11 END IF
   CALL s_dsmark(g_bookno)
   LET p_row = 2 LET p_col = 20
   OPEN WINDOW r170_w AT p_row,p_col
        WITH FORM "axc/42f/axcr170"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   CALL r170_set_visible() RETURNING l_cnt    #FUN-A70084
   INITIALIZE tm.* TO NULL
   LET tm.type = g_ccz.ccz28  #No.FUN-7C0101
   LET tm.sum_code='N'
   LET tm.more = 'N'
   LET tm.dec= '1'
   LET tm.yy1_b = g_ccz.ccz01
   LET tm.mm1_b = g_ccz.ccz02
   LET tm.mm1_e = g_ccz.ccz02
   LET tm.azk01= g_aza.aza17  #No:8488
   LET tm.azk04=1
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET g_base   = 1
WHILE TRUE
   LET g_wc=NULL
   LET g_wc1=NULL
   CONSTRUCT BY NAME  g_wc1 ON tlf19
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
   END CONSTRUCT
   LET g_wc1 = g_wc1 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   CONSTRUCT BY NAME  g_wc ON tlf01,ima131,ima11,ima12
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
   END CONSTRUCT
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
##
 
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r855_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM 
   END IF
   IF cl_null(g_wc) THEN LET g_wc = ' 1=1 ' END IF
   IF cl_null(g_wc1) THEN LET g_wc1 = ' 1=1 ' END IF
   INPUT BY NAME
              tm.yy1_b,tm.mm1_b,tm.mm1_e,
              tm.plant_1,tm.plant_2,tm.plant_3,tm.plant_4,
              tm.plant_5,tm.plant_6,tm.plant_7,tm.plant_8,
              tm.type,     #No.FUN-7C0101 add
              tm.sum_code,
              tm.azk01, tm.azk04,
              tm.azh01, tm.azh02,
              tm.dec,
              tm.more
 
   WITHOUT DEFAULTS
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
                NEXT FIELD sum_code            #不可輸入工廠欄位
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
                   IF NOT r170_chkplant(tm.plant_1) THEN
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
                   IF NOT r170_chkplant(tm.plant_2) THEN
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
                IF NOT r170_chklegal(m_legal[2],1) THEN
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
                   IF NOT r170_chkplant(tm.plant_3) THEN
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
                IF NOT r170_chklegal(m_legal[3],2) THEN
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
                   IF NOT r170_chkplant(tm.plant_4) THEN
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
                IF NOT r170_chklegal(m_legal[4],3) THEN 
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
                   IF NOT r170_chkplant(tm.plant_5) THEN
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
                IF NOT r170_chklegal(m_legal[5],4) THEN
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
                   IF NOT r170_chkplant(tm.plant_6) THEN
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
                IF NOT r170_chklegal(m_legal[6],5) THEN
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
                   IF NOT r170_chkplant(tm.plant_7) THEN
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
                IF NOT r170_chklegal(m_legal[7],6) THEN
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
                   IF NOT r170_chkplant(tm.plant_8) THEN
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
                IF NOT r170_chklegal(m_legal[8],7) THEN
                   CALL cl_err(tm.plant_8,g_errno,0)
                   NEXT FIELD plant_8
                END IF
             END IF
             #FUN-A70084--add--end
         
         AFTER FIELD type
             IF cl_null(tm.type) OR tm.type NOT MATCHES '[12345]' THEN
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
         AFTER FIELD azk04                       #FUN-4C0071
             IF tm.azk01=g_aza.aza17 THEN
                LET tm.azk04=1
                DISPLAY tm.azk04 TO azk04
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
               cl_null(tm.plant_7) AND cl_null(tm.plant_8) AND l_cnt <=1 THEN   #FUN-A70084 add l_cnt<=1
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
                IF  g_idx > g_k THEN
                    LET g_ary[g_idx].plant=NULL
                    LET g_ary[g_idx].dbs_new=NULL
                ELSE
                    LET g_ary[g_idx].plant=g_tmp[g_idx].p
                    LET g_ary[g_idx].dbs_new=g_tmp[g_idx].d
                END IF
            END FOR
      END IF   #FUN-A70084
 
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
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r170_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
 
   CALL s_ymtodate(tm.yy1_b,tm.mm1_b,tm.yy1_b,tm.mm1_e)
        RETURNING g_bdate ,g_edate
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
       WHERE zz01='axcr170'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr170','9031',1)   
      ELSE
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",g_wc CLIPPED,"'",
                         " '",tm.yy1_b    CLIPPED,"'",
                         " '",tm.mm1_b    CLIPPED,"'",
                         " '",tm.mm1_e    CLIPPED,"'",
                         " '",tm.plant_1  CLIPPED,"'",
                         " '",tm.plant_2  CLIPPED,"'",
                         " '",tm.plant_3  CLIPPED,"'",
                         " '",tm.plant_4  CLIPPED,"'",
                         " '",tm.plant_5  CLIPPED,"'",
                         " '",tm.plant_6  CLIPPED,"'",
                         " '",tm.plant_7  CLIPPED,"'",
                         " '",tm.plant_8  CLIPPED,"'",
                         " '",tm.type CLIPPED,"'",       #No.FUN-7C0101 add
                         " '",tm.sum_code CLIPPED,"'",
                         " '",tm.azk01    CLIPPED,"'",
                         " '",tm.azk04    CLIPPED,"'",
                         " '",tm.azh01    CLIPPED,"'",
                         " '",tm.azh02    CLIPPED,"'",
                         " '",tm.dec      CLIPPED,"'",
                         " '",g_rep_user  CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",   
                         " '",g_template  CLIPPED,"'",
                         " '",g_bookno  CLIPPED,"'"
         CALL cl_cmdat('axcr170',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr111_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
 
   CALL cl_wait()
   CALL r170()
   ERROR ""
END WHILE
   CLOSE WINDOW r170_w
END FUNCTION
 
FUNCTION r170()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680122CHAR(20)        # External(Disk) file name
          l_sql     LIKE type_file.chr1000,      # RDSQL STATEMENT        #No.FUN-680122CHAR(2000)
          l_tmp     LIKE cre_file.cre08,           #No.FUN-680122CHAR(8)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(40)
          l_flag    LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          sr  RECORD
              mm       LIKE type_file.num5,           #No.FUN-680122SMALLINT
              tlfccost LIKE tlfc_file.tlfccost,       #No.FUN-7C0101 VARCHAR(40)
            #  qty      LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3)#FUN-A20044
              qty      LIKE type_file.num15_3,           #No.FUN-680122DEC(15,3)#FUN-A20044
              amt      LIKE oeb_file.oeb13,         #No.FUN-680122 DECIMAL(20,6)
              cost     LIKE oeb_file.oeb13,         #No.FUN-680122DEC(20,6)
            #  tl_qty   LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3)#FUN-A20044
              tl_qty   LIKE type_file.num15_3,           #No.FUN-680122DEC(15,3)#FUN-A20044
              tl_amt   LIKE oeb_file.oeb13,         #No.FUN-680122 DECIMAL(20,6)
              tl_cost  LIKE oeb_file.oeb13,         #No.FUN-680122DEC(20,6)
              f1       LIKE oeb_file.oeb13,         #No.FUN-680122DEC(15,3)
              f2       LIKE oeb_file.oeb13,         #No.FUN-680122DEC(20,6)
              bonus    LIKE oeb_file.oeb13,         #No.FUN-680122DEC(20,6)   #客戶毛利
              bonus_r  LIKE oeb_file.oeb13,         #No.FUN-680122DEC(20,6)   #客戶毛利率
              tl_bonus   LIKE oeb_file.oeb13,       #No.FUN-680122DEC(20,6) #總毛利
              tl_bonus_r LIKE oeb_file.oeb13,       #No.FUN-680122DEC(20,6) #總毛利率
              amt_ar   LIKE oeb_file.oeb13,         #No.FUN-680122DEC(20,6)   #佔營業額百分比
              bonus_ar LIKE oeb_file.oeb13          #No.FUN-680122DEC(20,6)    #佔毛利百分比
              END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     CALL get_tmpfile() #
     CALL get_dpm()     #內部自用,雜發票,折讓
     LET l_sql=" SELECT mm,tlfccost,sum(qty),sum(amt),sum(cost),",        #No.FUN-7C0101 add tlfccost
               " sum(tl_qty),sum(tl_amt),sum(tl_cost)",
               " ,0,0,0,0,0,0",           #No.FUN-7C0101 add
               " FROM ",g_tname CLIPPED,
               " GROUP BY mm,tlfccost ORDER BY mm,tlfccost"     #No.FUN-7C0101 add 2
	     PREPARE r170_prepare1 FROM l_sql
             IF SQLCA.sqlcode != 0 THEN
 		CALL cl_err('prepare1:',SQLCA.sqlcode,1)   
 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
		EXIT PROGRAM
	     END IF
	     DECLARE r170_curs1 CURSOR FOR r170_prepare1
 
	     CALL cl_outnam('axcr170') RETURNING l_name
             
             IF tm.type MATCHES '[12]' THEN
                LET g_zaa[32].zaa06='Y'
             END IF
             IF tm.type MATCHES '[345]' THEN
                LET g_zaa[32].zaa06='N'
             END IF
     
	     START REPORT r170_rep TO l_name
	     LET g_pageno = 0
	     LET g_line= 0
	     FOREACH r170_curs1 INTO sr.*
	       IF SQLCA.sqlcode != 0 THEN
	          CALL cl_err('foreach:',SQLCA.sqlcode,1)
               END IF
               LET sr.amt=sr.amt/g_base
               LET sr.cost=sr.cost/g_base
               LET sr.tl_amt=sr.tl_amt/g_base
               LET sr.tl_cost=sr.tl_cost/g_base
 
               IF tm.azk04 >0 THEN
                  LET sr.amt=sr.amt/tm.azk04
                  LET sr.cost=sr.cost/tm.azk04
                  LET sr.tl_amt=sr.tl_amt/tm.azk04
                  LET sr.tl_cost=sr.tl_cost/tm.azk04
               END IF
               LET sr.bonus=(sr.amt-sr.cost)
               LET sr.tl_bonus=(sr.tl_amt-sr.tl_cost)
               IF sr.amt>0 THEN
                  LET sr.bonus_r=(sr.bonus)/(sr.amt)*100
               ELSE
                  LET sr.bonus_r=-100
               END IF
               IF sr.tl_amt>0 THEN
                  LET sr.tl_bonus_r=(sr.tl_bonus)/(sr.tl_amt)*100
                  LET sr.amt_ar=sr.amt/sr.tl_amt*100
               ELSE
                  LET sr.tl_bonus_r=-100
               END IF
               IF sr.tl_bonus = 0 OR sr.tl_bonus IS NULL THEN
                  LET sr.bonus_ar=0
               ELSE
                  LET sr.bonus_ar=(sr.bonus)/(sr.tl_bonus)*100
               END IF
               OUTPUT TO REPORT r170_rep(sr.*)
             END FOREACH
     FINISH REPORT r170_rep
     LET g_delsql= " DROP TABLE ",g_tname CLIPPED
     PREPARE del_cmd FROM g_delsql
     EXECUTE del_cmd
     LET g_delsql1= " DROP TABLE ",g_tname1 CLIPPED
     PREPARE del_dpm1 FROM g_delsql1
     EXECUTE del_dpm1
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
FUNCTION get_tmpfile()
DEFINE l_dot    LIKE type_file.chr1,          #No.FUN-680122CHAR(1)
       l_title  LIKE type_file.chr1000,       #No.FUN-680122CHAR(100)
       l_titlex LIKE type_file.chr1000,       #No.FUN-680122CHAR(100)
       l_sql    LIKE type_file.chr1000,       #No.FUN-680122CHAR(200)
       x_wc     LIKE type_file.chr1000,       #No.FUN-680122CHAR(2000)
       tmp_sql  STRING   #TQC-970199  
 
LET g_tname='r170_tmp'                         #No.TQC-980163 mod
LET g_delsql= " DROP TABLE ",g_tname CLIPPED
PREPARE del_cmd2 FROM g_delsql
LET l_sql=null
LET tmp_sql=
#FUN-A10098---BEGIN
     "CREATE TEMP TABLE ",g_tname CLIPPED,  #No.TQC-970305 mod    #FUN-A70084 注意：請不要在建臨時表中使用mark,會導致建臨時表出錯,FUN-A20044修改內容移至建完臨成之后
              "(mm        LIKE type_file.num5,",
              " tlfccost  LIKE tlfc_file.tlfccost,", 
              " qty       LIKE type_file.num15_3,",   #FUN-A20044
              " amt       LIKE oeb_file.oeb13,",
              " cost      LIKE oeb_file.oeb13,",
              " tl_qty    LIKE type_file.num15_3,",   #FUN-A20044
              " tl_amt    LIKE oeb_file.oeb13,",
              " tl_cost   LIKE oeb_file.oeb13,",
              " f1        LIKE oeb_file.oeb13,",
              " f2        LIKE oeb_file.oeb13)"
      
           #   " qty       LIKE ima_file.ima26,",#FUN-A20044
             # " tl_qty    LIKE ima_file.ima26,",#FUN-A20044
#     "CREATE TEMP TABLE ",g_tname CLIPPED,  #No.TQC-970305 mod
#              "(mm        SMALLINT,", #月份
#              " tlfccost  VARCHAR(40),",      #No.FUN-7C0101 add
#              " qty       DEC(15,3),",
#              " amt       DEC(20,6),",
#              " cost      DEC(20,6),",
#              " tl_qty    DEC(15,3),",
#              " tl_amt    DEC(20,6),",
#              " tl_cost   DEC(20,6),",
#              " f1        DEC(20,6),",
#              " f2        DEC(20,6))"
#FUN-A10098---END
    PREPARE cre_p1 FROM tmp_sql
    EXECUTE cre_p1
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('Create axcr170_tmp:' ,SQLCA.sqlcode,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
       EXIT PROGRAM
    END IF
      FOR g_idx=1 TO g_k
          # 關係人的銷貨
          LET tmp_sql= " INSERT INTO ",g_tname,
          " SELECT MONTH(tlf06),tlfccost,",                   #No.FUN-7C0101 add tlfccost
           " SUM(tlf10*tlf60),", #MOD-570086
#         " SUM(ogb12*ogb13*oga24),SUM(tlfc21),0,0,0,0,0",   #NO.FUN-7C0101 tlf21->tlfc21   #CHI-B70039 mark
          " SUM(ogb917*ogb13*oga24),SUM(tlfc21),0,0,0,0,0",  #CHI-B70039
#FUN-A10098---BEGIN
#          " FROM ",g_ary[g_idx].dbs_new CLIPPED,"tlf_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"smy_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"oga_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ogb_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"tlfc_file",   #No.FUN-7C0101 add
          " FROM ",cl_get_target_table(g_ary[g_idx].plant,'tlf_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'smy_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'oga_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ogb_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'tlfc_file'),
#FUN-A10098---END
          " WHERE ",g_wc CLIPPED,
          " AND ",g_wc1 CLIPPED, #關係人
          " AND tlf61=smyslip AND smydmy1 = 'Y' ",
          " AND (tlf03 = 724 OR tlf03 = 72) AND tlf02 = 50 ", #銷貨
          " AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
          " AND tlfc_file.tlfc01 = tlf01 AND tlfc_file.tlfc02 = tlf02 ",                                                                                
          " AND tlfc_file.tlfc03 = tlf03 AND tlfc_file.tlfc06 = tlf06",           #No.FUN-830002                                                        
          " AND tlfc_file.tlfc13 = tlf13",                              #No.FUN-830002                                                        
          " AND tlfc_file.tlfc902 = tlf902 AND tlfc_file.tlfc903 = tlf903",       #No.FUN-830002                                                        
          " AND tlfc_file.tlfc904 = tlf904 AND tlfc_file.tlfc905 = tlf905",       #No.FUN-830002                                                        
          " AND tlfc_file.tlfc906 = tlf906 AND tlfc_file.tlfc907 = tlf907",
          " AND tlfc_file.tlfctype = '",tm.type,"'",                                                  
          " AND tlf01=ima01 ",
          " AND tlf026=ogb01 AND tlf027=ogb03 AND ogb01=oga01 ",
          " AND ogapost = 'Y' AND ogaconf = 'Y' AND oga09 IN ('2','3','8') ",  #TQC-970199
           " AND oga00 NOT IN ('A','3','7') ",                                          #No.MOD-950210 add
          " AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
          " GROUP BY MONTH(tlf06),tlfccost "                             #TQC-980293 
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
         #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
          PREPARE r170_prepare0 FROM tmp_sql
          EXECUTE r170_prepare0
 
          LET tmp_sql= " INSERT INTO ",g_tname,
          " SELECT MONTH(tlf06),tlfccost,",                          #No.FUN-7C0101 add tlfccost
           " SUM(tlf10*tlf60),", #MOD-570086
#         " SUM(ogb12*ogb13*oga24)*-1,SUM(tlfc21)*-1,0,0,0,0,0",    #NO.FUN-7C0101 tlf21->tlfc21   #CHI-B70039 mark
          " SUM(ogb917*ogb13*oga24)*-1,SUM(tlfc21)*-1,0,0,0,0,0",   #CHI-B70039
#FUN-A10098---BEGIN
#          " FROM ",g_ary[g_idx].dbs_new CLIPPED,"tlf_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"smy_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"oga_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ogb_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"tlfc_file",       #No.FUN-7C0101 add
          " FROM ",cl_get_target_table(g_ary[g_idx].plant,'tlf_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'smy_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'oga_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ogb_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'tlfc_file'), 
#FUN-A10098---END
          " WHERE ",g_wc CLIPPED,
          " AND ",g_wc1 CLIPPED, #關係人
          " AND tlf61=smyslip AND smydmy1 = 'Y' ",
          " AND (tlf03 = 723 OR tlf03 = 725) AND tlf02 = 50 ", #銷貨單刪除
          " AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
          " AND tlfc_file.tlfc01 = tlf01 AND tlfc_file.tlfc02 = tlf02 ",
          " AND tlfc_file.tlfc03 = tlf03 AND tlfc_file.tlfc06 = tlf06",           #No.FUN-830002                                                        
          " AND tlfc_file.tlfc13 = tlf13",                              #No.FUN-830002
          " AND tlfc_file.tlfc902 = tlf902 AND tlfc_file.tlfc903 = tlf903",       #No.FUN-830002                                                        
          " AND tlfc_file.tlfc904 = tlf904 AND tlfc_file.tlfc905 = tlf905",       #No.FUN-830002
          " AND tlfc_file.tlfc906 = tlf906 AND tlfc_file.tlfc907 = tlf907",
          " AND tlfc_file.tlfctype = '",tm.type,"'",                                                  
          " AND tlf01=ima01 ",
          " AND tlf026=ogb01 AND tlf027=ogb03 AND ogb01=oga01 ",
          " AND ogapost = 'Y' AND ogaconf = 'Y' AND oga09 IN ('2','3','8') ",              #No.MOD-950210 add
           " AND oga00 NOT IN ('A','3','7') ",                                                 #No.MOD-950210 add
          " AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
          " GROUP BY MONTH(tlf06),tlfccost"                                     #No.FUN-7C0101 add 2
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
         #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
          PREPARE r170_prepare0_r FROM tmp_sql
          EXECUTE r170_prepare0_r
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('prepare0:',SQLCA.sqlcode,1)
             EXECUTE del_cmd2 #delete tmpfile
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
             EXIT PROGRAM
          END IF
          # 關係人的退貨
          LET tmp_sql= " INSERT INTO ",g_tname,
          " SELECT MONTH(tlf06),tlfccost,",                          #No.FUN-7C0101 add tlfccost
           " SUM(tlf10*tlf60)*-1,", #MOD-570086
          " SUM(ohb14*oha24)*-1,SUM(tlfc21)*-1,0,0,0,0,0",          #NO.FUN-7C0101 tlf21->tlfc21
#FUN-A10098---BEGIN
#          " FROM ",g_ary[g_idx].dbs_new CLIPPED,"tlf_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"smy_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"oha_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ohb_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"tlfc_file",       #No.FUN-7C0101 add
          " FROM ",cl_get_target_table(g_ary[g_idx].plant,'tlf_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'smy_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'oha_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ohb_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'tlfc_file'),
#FUN-A10098---END
          " WHERE ",g_wc CLIPPED,
          " AND ",g_wc1 CLIPPED, #關係人
          " AND tlf61=smyslip AND smydmy1 = 'Y' ",
          " AND tlf02 = 731 AND tlf03 = 50 ",
          " AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
          " AND tlfc_file.tlfc01 = tlf01 AND tlfc_file.tlfc02 = tlf02 ",                                                                                
          " AND tlfc_file.tlfc03 = tlf03 AND tlfc_file.tlfc06 = tlf06",           #No.FUN-830002                                                        
          " AND tlfc_file.tlfc13 = tlf13",                              #No.FUN-830002                                                        
          " AND tlfc_file.tlfc902 = tlf902 AND tlfc_file.tlfc903 = tlf903",       #No.FUN-830002                                                        
          " AND tlfc_file.tlfc904 = tlf904 AND tlfc_file.tlfc905 = tlf905",       #No.FUN-830002                                                        
          " AND tlfc_file.tlfc906 = tlf906 AND tlfc_file.tlfc907 = tlf907",      #No.FUN-830002
          " AND tlfc_file.tlfctype = '",tm.type,"'",                                                  
          " AND tlf01=ima01 ",
          " AND tlf026=ohb01 AND tlf027=ohb03 AND ohb01=oha01 ",
          " AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
          " GROUP BY MONTH(tlf06),tlfccost"                                    #No.FUN-7C0101 add 2
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
         #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
          PREPARE r170_prepare_r FROM tmp_sql
          EXECUTE r170_prepare_r
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('prepare0:',SQLCA.sqlcode,1)
             EXECUTE del_cmd2 #delete tmpfile
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
             EXIT PROGRAM
          END IF
 
          #營業總額  - 銷貨
          LET tmp_sql= " INSERT INTO ",g_tname,
          " SELECT MONTH(tlf06),tlfccost,",                         #No.FUN-7C0101 add tlfccost
          " 0,0,0,SUM(tlf10*tlf60),", #MOD-570086
          " SUM(ogb14*oga24),SUM(tlfc21),0,0 ",                    #NO.FUN-7C0101 tlf21->tlfc21
#FUN-A10098---BEGIN
#          " FROM ",g_ary[g_idx].dbs_new CLIPPED,"tlf_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"smy_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"oga_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ogb_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"tlfc_file",       #No.FUN-7C0101 add
          " FROM ",cl_get_target_table(g_ary[g_idx].plant,'tlf_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'smy_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'oga_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ogb_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'tlfc_file'),
#FUN-A10098---END
          " WHERE ",g_wc CLIPPED,
          " AND tlf61=smyslip AND smydmy1 = 'Y' ",
          " AND (tlf03 = 724 OR tlf03 = 72) AND tlf02 = 50 ", #銷貨
          " AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
          " AND tlfc_file.tlfc01 = tlf01 AND tlfc_file.tlfc02 = tlf02 ",                                                                                
          " AND tlfc_file.tlfc03 = tlf03 AND tlfc_file.tlfc06 = tlf06",           #No.FUN-830002                                                        
          " AND tlfc_file.tlfc13 = tlf13",                              #No.FUN-830002                                                        
          " AND tlfc_file.tlfc902 = tlf902 AND tlfc_file.tlfc903 = tlf903",       #No.FUN-830002                                                        
          " AND tlfc_file.tlfc904 = tlf904 AND tlfc_file.tlfc905 = tlf905",       #No.FUN-830002                                                        
          " AND tlfc_file.tlfc906 = tlf906 AND tlfc_file.tlfc907 = tlf907",      #No.FUN-830002 
          " AND tlfc_file.tlfctype = '",tm.type,"'",                                                  
          " AND tlf01=ima01 ",
          " AND tlf026=ogb01 AND tlf027=ogb03 AND ogb01=oga01 ",
           " AND oga00 NOT IN ('A','3','7') ",     #No.MOD-950210 add
          " AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
          " GROUP BY MONTH(tlf06),tlfccost"                                    #No.FUN-7C0101 add 2
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
          #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
          PREPARE r170_prepare FROM tmp_sql
          EXECUTE r170_prepare
 
          LET tmp_sql= " INSERT INTO ",g_tname,
          " SELECT MONTH(tlf06),tlfccost,", #出貨單刪除                    #No.FUN-7C0101 add tlfccost
           " 0,0,0,SUM(tlf10*tlf60)*-1,", #MOD-570086
          " SUM(ogb14*oga24)*-1,SUM(tlfc21)*-1,0,0 ",                     #NO.FUN-7C0101 tlf21->tlfc21
#FUN-A10098---BEGIN
#          " FROM ",g_ary[g_idx].dbs_new CLIPPED,"tlf_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"smy_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"oga_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ogb_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"tlfc_file",             #No.FUN-7C0101 add
          " FROM ",cl_get_target_table(g_ary[g_idx].plant,'tlf_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'smy_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'oga_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ogb_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'tlfc_file'),
#FUN-A10098---END
          " WHERE ",g_wc CLIPPED,
          " AND tlf61=smyslip AND smydmy1 = 'Y' ",
          " AND (tlf03 = 723 OR tlf03 = 725) AND tlf02 = 50 ", #銷貨
          " AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
          " AND tlfc_file.tlfc01 = tlf01 AND tlfc_file.tlfc02 = tlf02 ",                                                                                
          " AND tlfc_file.tlfc03 = tlf03 AND tlfc_file.tlfc06 = tlf06",           #No.FUN-830002                                                        
          " AND tlfc_file.tlfc13 = tlf13",                              #No.FUN-830002                                                        
          " AND tlfc_file.tlfc902 = tlf902 AND tlfc_file.tlfc903 = tlf903",       #No.FUN-830002                                                        
          " AND tlfc_file.tlfc904 = tlf904 AND tlfc_file.tlfc905 = tlf905",       #No.FUN-830002                                                        
          " AND tlfc_file.tlfc906 = tlf906 AND tlfc_file.tlfc907 = tlf907",      #No.FUN-830002 
          " AND tlfc_file.tlfctype = '",tm.type,"'",                                                  
          " AND tlf01=ima01 ",
          " AND tlf026=ogb01 AND tlf027=ogb03 AND ogb01=oga01 ",
           " AND oga00 NOT IN ('A','3','7') ",     #No.MOD-950210 add
          " AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
          " GROUP BY MONTH(tlf06),tlfccost"                                    #No.FUN-7C0101 add 2
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
         #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098   #TQC-BB0182 mark
          PREPARE r170_prepare_de FROM tmp_sql  
          EXECUTE r170_prepare_de
 
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('prepare:',SQLCA.sqlcode,1)
             EXECUTE del_cmd2 #delete tmpfile
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
             EXIT PROGRAM
          END IF
          LET tmp_sql= " INSERT INTO ",g_tname,
          " SELECT MONTH(tlf06),tlfccost,",                              #No.FUN-7C0101 add tlfccost
           " 0,0,0,SUM(tlf10*tlf60)*-1,", #MOD-570086
          "                   0,SUM(tlfc21)*-1,0,0 ",                    #NO.FUN-7C0101 tlf21->tlfc21
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
          " WHERE ",g_wc CLIPPED,
          " AND tlf02 = 731 AND tlf03 = 50 ",
          " AND tlf61=smyslip AND smydmy1 = 'Y' ",
          " AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
          " AND tlfc_file.tlfc01 = tlf01 AND tlfc_file.tlfc02 = tlf02 ",                                                                                
          " AND tlfc_file.tlfc03 = tlf03 AND tlfc_file.tlfc06 = tlf06",           #No.FUN-830002                                                        
          " AND tlfc_file.tlfc13 = tlf13",                              #No.FUN-830002                                                        
          " AND tlfc_file.tlfc902 = tlf902 AND tlfc_file.tlfc903 = tlf903",       #No.FUN-830002                                                        
          " AND tlfc_file.tlfc904 = tlf904 AND tlfc_file.tlfc905 = tlf905",       #No.FUN-830002                                                        
          " AND tlfc_file.tlfc906 = tlf906 AND tlfc_file.tlfc907 = tlf907",      #No.FUN-830002 
          " AND tlfc_file.tlfctype = '",tm.type,"'",                                                  
          " AND tlf01=ima01",
          " AND tlf026=ohb01 AND tlf027=ohb03 AND ohb01=oha01 ",
          " AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
          " GROUP BY MONTH(tlf06),tlfccost"                                    #No.FUN-7C0101 add 2
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
         #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098   #TQC-BB0182 mark
          PREPARE r170_preparerrr FROM tmp_sql
          EXECUTE r170_preparerrr
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('prepare:',SQLCA.sqlcode,1)
             EXECUTE del_cmd2 #delete tmpfile
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
             EXIT PROGRAM
          END IF
          # 銷退金額包括 折讓及銷退
          LET x_wc = change_string(g_wc,'tlf19','oma03')
          LET x_wc = change_string(x_wc,'tlf01','omb04')
          LET tmp_sql= " INSERT INTO ",g_tname,
          " SELECT MONTH(oma02),",
          " 0,0,0,0,0         ,",             #No.FUN-7C0101 add 0
"           SUM(omb16)*-1 ,0,0,0 ",
#FUN-A10098---BEGIN
#"           FROM ",g_ary[g_idx].dbs_new CLIPPED,"oma_file",
#"               ,",g_ary[g_idx].dbs_new CLIPPED,"omb_file LEFT OUTER JOIN ",g_ary[g_idx].dbs_new CLIPPED,"ima_file ON omb04 = ima01",
"           FROM ",cl_get_target_table(g_ary[g_idx].plant,'oma_file'),
"               ,",cl_get_target_table(g_ary[g_idx].plant,'omb_file')," LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'ima_file')," ON omb04 = ima01",
#FUN-A10098---END
          " WHERE ",x_wc CLIPPED,
          " AND oma02 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
          " AND omb01 = oma01 ",
          " AND (oma00 = '21' OR oma00 = '25' ) ",
          " AND omaconf = 'Y' AND omavoid = 'N' ",
          " GROUP BY MONTH(oma02)"                       
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
         #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark 
          PREPARE r160_prepare4 FROM tmp_sql
          EXECUTE r160_prepare4
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('r160_prepare4:',SQLCA.sqlcode,1)
             EXECUTE del_cmd2 #delete tmpfile
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
             EXIT PROGRAM
          END IF
      END FOR  #for g_inx  dbs
END FUNCTION
 
REPORT r170_rep(sr)
DEFINE l_last_sw   LIKE type_file.chr1,          #No.FUN-680122CHAR(1)
       dec_name    LIKE cre_file.cre08,          #No.FUN-680122CHAR(10)
       l_bonus     LIKE oeb_file.oeb13,        #No.FUN-680122DEC(20,6)
       i           LIKE type_file.num5,         #TQC-970199 
       sr  RECORD
              mm       LIKE type_file.num5,     #No.FUN-680122SMALLINT
              tlfccost LIKE tlfc_file.tlfccost, #No.FUN-7C0101CHAR(40)
          #    qty      LIKE ima_file.ima26,     #No.FUN-680122DEC(15,3)#FUN-A20044
              qty      LIKE type_file.num15_3,     #No.FUN-680122DEC(15,3)#FUN-A20044
              amt      LIKE oeb_file.oeb13,   #No.FUN-680122DEC(20,6)
              cost     LIKE oeb_file.oeb13,   #No.FUN-680122DEC(20,6)
            #  tl_qty   LIKE ima_file.ima26,     #No.FUN-680122DEC(15,3)#FUN-A20044
              tl_qty   LIKE type_file.num15_3,     #No.FUN-680122DEC(15,3)#FUN-A20044
              tl_amt   LIKE oeb_file.oeb13,   #No.FUN-680122DEC(20,6)
              tl_cost  LIKE oeb_file.oeb13,   #No.FUN-680122DEC(20,6)
              f1         LIKE oeb_file.oeb13, #No.FUN-680122DEC(20,6)
              f2         LIKE oeb_file.oeb13, #No.FUN-680122DEC(20,6)
              bonus      LIKE oeb_file.oeb13, #No.FUN-680122DEC(20,6)   #客戶毛利
              bonus_r    LIKE oeb_file.oeb13, #No.FUN-680122DEC(20,6)   #客戶毛利率
              tl_bonus   LIKE oeb_file.oeb13, #No.FUN-680122DEC(20,6) #總毛利
              tl_bonus_r LIKE oeb_file.oeb13, #No.FUN-680122DEC(20,6) #總毛利率
              amt_ar     LIKE oeb_file.oeb13, #No.FUN-680122DEC(20,6)   #佔營業額百分比
              bonus_ar   LIKE oeb_file.oeb13  #No.FUN-680122DEC(20,6)    #佔毛利百分比
              END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED    #No.TQC-6A0078
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      IF NOT cl_null(tm.azh02) THEN
         LET g_x[1] = tm.azh02
      ELSE
         LET g_x[1] = g_x[1] END IF
      IF tm.dec ='2' THEN LET dec_name=g_x[12]
      ELSE IF tm.dec='3' THEN	
              LET dec_name=g_x[13]
           ELSE
              LET dec_name=g_x[11]
           END IF
      END IF
      FOR i=1 TO 8                                                                                                                  
          SELECT azp03 INTO g_ary[i].dbs  FROM azp_file WHERE azp01 = g_ary[i].plant                                                
      END FOR                                                                                                                       
                                                                                                                                    
      SELECT azi07 INTO t_azi07 FROM azi_file WHERE azi01 = tm.azk01     #No.FUN-870151
      PRINT COLUMN (g_len-FGL_WIDTH(g_x[9]))/2,'    ',g_x[10] CLIPPED,
                  #tm.azk01 clipped,'/',tm.azk04 using '<<&.&&',         #No.FUN-870151
                   tm.azk01 clipped,'/',cl_numfor(tm.azk04,7,t_azi07),   #No.FUN-870151                   
            COLUMN g_len-30,dec_name CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,'      ',
            tm.yy1_b USING '####','/',tm.mm1_b USING '##','-',
            tm.mm1_e USING '##'
      PRINT g_dash[1,g_len]   #No.TQC-6A0078
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
            g_x[41],g_x[42]   #No.FUN-7C0101 add g_x[42]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      PRINT COLUMN g_c[31],sr.mm       USING '##',
            COLUMN g_c[32],sr.tlfccost CLIPPED,               #No.FUN-7C0101 add
            COLUMN g_c[33],cl_numfor(sr.tl_amt,32,g_ccz.ccz26),   #總營業額    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[34],cl_numfor(sr.tl_cost,33,g_ccz.ccz26),  #總成本    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[35],cl_numfor(sr.tl_bonus,34,g_ccz.ccz26), #總毛利    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[36],cl_numfor(sr.tl_bonus_r,35,2),     #毛利率
            COLUMN g_c[37],cl_numfor(sr.amt,36,g_ccz.ccz26),      #關係人營業額    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[38],cl_numfor(sr.amt_ar,37,2),         #百分比
            COLUMN g_c[39],cl_numfor(sr.cost,38,g_ccz.ccz26),     #成本    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[40],cl_numfor(sr.bonus,39,g_ccz.ccz26),    #毛利    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[41],cl_numfor(sr.bonus_ar,40,2),       #百分比
            COLUMN g_c[42],cl_numfor(sr.bonus_r,41,2)         #毛利率
   ON LAST ROW
      PRINT g_dash2
      PRINT COLUMN g_c[33],cl_numfor(sum(sr.tl_amt),33,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[34],cl_numfor(sum(sr.tl_cost),34,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[35],cl_numfor(sum(sr.tl_bonus),35,g_ccz.ccz26);    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            IF sum(sr.tl_amt) <>0 THEN
               PRINT COLUMN g_c[36],cl_numfor(sum(sr.tl_amt-sr.tl_cost)/sum(sr.tl_amt)*100,36,2);
            ELSE
               PRINT COLUMN g_c[36],0  USING '----&.&&';
            END IF
            PRINT COLUMN g_c[37],cl_numfor(sum(sr.amt),37,g_ccz.ccz26)   ;  #CHI-C30012 g_azi03->g_ccz.ccz26
            IF sum(sr.tl_amt) <>0 THEN
               PRINT COLUMN g_c[38],cl_numfor(sum(sr.amt)/sum(sr.tl_amt)*100,38,2) ;
            ELSE
               PRINT COLUMN g_c[38],0  USING '----&.&&';
            END IF
            PRINT
            COLUMN g_c[39],cl_numfor(sum(sr.cost),39,g_ccz.ccz26) ,    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[40],cl_numfor(sum(sr.bonus),40,g_ccz.ccz26)     ;    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            IF sum(sr.tl_bonus) <>0 THEN
               PRINT COLUMN g_c[41],cl_numfor(sum(sr.bonus)/sum(sr.tl_bonus)*100,41,2);
            ELSE
               PRINT COLUMN g_c[41],0  USING '----&.&&';
            END IF
            IF sum(sr.amt) <>0 THEN
               PRINT COLUMN g_c[42],cl_numfor(sum(sr.amt-sr.cost)/sum(sr.amt)*100,42,2)
            ELSE
               PRINT COLUMN g_c[42],0  USING '----&.&&'
            END IF
      PRINT g_dash[1,g_len]   #No.TQC-6A0078
      PRINT ' data from : ',
            g_ary[1].dbs CLIPPED,' ', g_ary[2].dbs CLIPPED,' ',                                                                     
            g_ary[3].dbs CLIPPED,' ', g_ary[4].dbs CLIPPED,' ',                                                                     
            g_ary[5].dbs CLIPPED,' ', g_ary[6].dbs CLIPPED,' ',                                                                     
            g_ary[7].dbs CLIPPED,' ', g_ary[8].dbs CLIPPED                                                                          
      IF tm.sum_code matches '[Yy]' THEN
         PRINT g_wc1 CLIPPED,
               COLUMN  20,g_x[15] CLIPPED,
               COLUMN  40,g_x[16] CLIPPED,
               COLUMN  60,g_x[17] CLIPPED,
               COLUMN  80,g_x[18] CLIPPED,
               COLUMN 100,g_x[19] CLIPPED,
               COLUMN 120,g_x[20] CLIPPED,
               COLUMN 140,g_x[21] CLIPPED,
               COLUMN 160,g_x[22] CLIPPED
         PRINT COLUMN  20,cl_numfor(g_sum.qty,17,g_ccz.ccz27), #CHI-690007 2->ccz27
               COLUMN  40,cl_numfor(g_sum.amt,17,g_ccz.ccz26),    #FUN-570190  #CHI-C30012 g_azi03->g_ccz.ccz26
               COLUMN  60,cl_numfor(g_sum.cost,17,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
               COLUMN  80,cl_numfor(g_sum.qty1,17,g_ccz.ccz27), #CHI-690007 2->ccz27
               COLUMN 100,cl_numfor(g_sum.amt1,17,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
               COLUMN 120,cl_numfor(g_sum.cost1,17,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
               COLUMN 140,cl_numfor(g_sum.dae_amt,17,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
               COLUMN 160,cl_numfor(g_sum.dac_amt,17,g_ccz.ccz26)     #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
      END IF
      PRINT g_dash2
      PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_last_sw='y'
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash2
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
 
FUNCTION duplicate(l_plant,n)               #檢查輸入之工廠編號是否重覆
   DEFINE l_plant     LIKE azp_file.azp01
   DEFINE l_idx,n     LIKE type_file.num10           #No.FUN-680122INTGER
 
   FOR l_idx = 1 TO n
       IF g_ary[l_idx].plant = l_plant THEN
          LET l_plant = ''
       END IF
   END FOR
   RETURN l_plant
END FUNCTION
 
FUNCTION get_dpm()
DEFINE l_sql LIKE type_file.chr1000,       #No.FUN-680122CHAR(300)
       l_wc  LIKE type_file.chr1000,       #No.FUN-680122CHAR(300)
       l_sql1 LIKE type_file.chr1000,       #No.FUN-680122CHAR(300)
       tmp_sql LIKE type_file.chr1000,       #No.FUN-680122CHAR(1500)
       f1,f2,f3 LIKE oeb_file.oeb13,     #No.FUN-680122DEC(20,6)
       l_title LIKE type_file.chr1000,       #No.FUN-680122CHAR(1500)
       l_dpm RECORD
              mm     LIKE type_file.num5,          #No.FUN-680122SMALLINT
              tlfccost LIKE tlfc_file.tlfccost,     #No.FUN-7C0101CHAR(40)
            #  qty    LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3)  #數量(銷)#FUN-A20044
              qty    LIKE type_file.num15_3,           #No.FUN-680122DEC(15,3)  #數量(銷)#FUN-A20044
              amt    LIKE oeb_file.oeb13,     #No.FUN-680122DEC(20,6)  #金額(銷)
              cost   LIKE oeb_file.oeb13,     #No.FUN-680122DEC(20,6)  #成本(銷)
             # qty1   LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3)  #數量(退)#FUN-A20044
              qty1   LIKE type_file.num15_3,           #No.FUN-680122DEC(15,3)  #數量(退)#FUN-A20044
              amt1   LIKE oeb_file.oeb13,     #No.FUN-680122DEC(20,6)  #金額(退)
              cost1  LIKE oeb_file.oeb13,     #No.FUN-680122DEC(20,6)  #成本(退)
              dae_amt LIKE oeb_file.oeb13,     #No.FUN-680122DEC(20,6) #折讓
              dac_amt LIKE oeb_file.oeb13      #No.FUN-680122DEC(20,6)  #雜項發票
              END RECORD
 
LET g_tname1='r170_tmp1'                        #No.TQC-980163 mod
LET g_delsql1= " DROP TABLE ",g_tname1 CLIPPED
PREPARE del_dpm FROM g_delsql1
LET tmp_sql=
#FUN-A10098---BEGIN
#    "CREATE TEMP TABLE ",g_tname1 CLIPPED,
#              "(tlf19  VARCHAR(10),",   #客戶編號
#              " mm     SMALLINT,",
#              " qty    DEC(15,3),",  #數量(銷)
#              " amt    DEC(20,6),",  #金額(銷)
#              " cost   DEC(20,6),",  #成本(銷)
#              " qty1   DEC(15,3),",  #數量(退)
#              " amt1   DEC(20,6),",  #金額(退)
#              " cost1  DEC(20,6),",  #成本(退)
#              " dae_amt DEC(20,6),", #折讓
#              " dac_amt DEC(20,6))" #雜項發票
    "CREATE TEMP TABLE ",g_tname1 CLIPPED, #FUN-A70084 #FUN-A70084 注意：請不要在建臨時表中使用mark,會導致建臨時表出錯,FUN-A20044修改內容移至建完臨成之后
              "(tlf19  LIKE tlf_file.tlf19,",   #客戶編號
              " mm     LIKE type_file.num5,",
              " qty    LIKE type_file.num15_3,",  #數量(銷)#FUN-A20044
              " amt    LIKE type_file.num20_6,",  #金額(銷)
              " cost   LIKE type_file.num20_6,",  #成本(銷)
              " qty1   LIKE type_file.num15_3,",  #數量(退)#FUN-A20044
              " amt1   LIKE type_file.num20_6,",  #金額(退)
              " cost1  LIKE type_file.num20_6,",  #成本(退)
              " dae_amt LIKE type_file.num20_6,", #折讓
              " dac_amt LIKE type_file.num20_6)" #雜項發票

          #    " qty    LIKE ima_file.ima26,",  #數量(銷)#FUN-A20044
            #  " qty1   LIKE ima_file.ima26,",  #數量(退)#FUN-A20044
#FUN-A10098---END
#  "CREATE TEMP TABLE ",g_tname1 CLIPPED,
#            "(tlf19    LIKE tlf_file.tlf19,",
#            " mm       LIKE ima_file.ima89,",
#          #  " qty      LIKE type_file.num15_3,",#FUN-A20044
#            " amt      LIKE ima_file.ima32,",
#            " cost     LIKE ima_file.ima23,",
#          #  " qty1     LIKE ima_file.ima26,",#FUN-A20044
#          #  " qty1     LIKE type_file.num15_3,",#FUN-A20044
#            " amt1     LIKE ima_file.ima32,",
#            " cost1    LIKE ima_file.ima32,",
#            " dae_amt  LIKE ima_file.ima32,",
#            " dac_amt  LIKE ima_file.ima32)" 
    PREPARE cre_dpm FROM tmp_sql
    EXECUTE cre_dpm
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('Create tmp_dpm:' ,SQLCA.sqlcode,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
       EXIT PROGRAM
    END IF
 
###內部自用銷貨
    FOR g_idx=1 TO g_k
          LET tmp_sql= " INSERT INTO ",g_tname1,
          " SELECT tlf19,MONTH(tlf06),",
     #       異動數量                 銷售金額          成會異動成本
#       " sum(tlf10*tlf60*tlf907),sum(ogb12*ogb13*oga24*tlf907),sum(tlf21*tlf907), ",    #CHI-B70039 mark
        " sum(tlf10*tlf60*tlf907),sum(ogb917*ogb13*oga24*tlf907),sum(tlf21*tlf907), ",   #CHI-B70039
          " 0,0,0,0,0",
#FUN-A10098---BEGIN
#          " FROM ",g_ary[g_idx].dbs_new CLIPPED,"tlf_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"smy_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"occ_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"oga_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ogb_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
          " FROM ",cl_get_target_table(g_ary[g_idx].plant,'tlf_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'smy_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'occ_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'oga_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ogb_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
#FUN-A10098---END
          " WHERE ",g_wc CLIPPED,
          " AND tlf03 = 724  AND tlf02 = 50 ",
          " AND tlf61=smyslip AND smydmy1 = 'Y' ",
          " AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
          " AND tlf01=ima01 AND tlf19 = occ01 AND occ37 = 'Y' ",
          " AND tlf036=ogb01 AND tlf037=ogb03 AND ogb01=oga01 ",
         #" AND oga00 != '3' ",   #FUN-5B0123  #No.MOD-950210 mark
           " AND oga00 NOT IN ('A','3','7') ",     #No.MOD-950210 add 
          " AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
          " GROUP BY tlf19,MONTH(tlf06)"
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
         #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark 
          PREPARE r170_predpm FROM tmp_sql
          EXECUTE r170_predpm
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('predpm:',SQLCA.sqlcode,1)
             EXECUTE del_dpm
          END IF
    END FOR
###內部自用退貨
    FOR g_idx=1 TO g_k
          LET tmp_sql= " INSERT INTO ",g_tname1,
          " SELECT tlf19,MONTH(tlf06),",
        " 0,0,0,sum(tlf10*tlf60*tlf907),sum(ohb14t*oha24*tlf907), ",
        " sum(tlf21*tlf907),0,0 ",
#FUN-A10098---BEGIN
#          " FROM ",g_ary[g_idx].dbs_new CLIPPED,"tlf_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"smy_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"occ_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"oha_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ohb_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
          " FROM ",cl_get_target_table(g_ary[g_idx].plant,'tlf_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'smy_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'occ_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'oha_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ohb_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
#FUN-A10098---END
          " WHERE ",g_wc CLIPPED,
          " AND tlf02 = 731 AND tlf03 = 50 ",
          " AND tlf61=smyslip AND smydmy1 = 'Y' ",
          " AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
          " AND tlf01=ima01 AND oha03 = occ01 AND occ37 = 'Y' ",
          " AND tlf036=ohb01 AND tlf037=ohb03 AND ohb01=oha01 ",
          " AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
          " GROUP BY tlf19,MONTH(tlf06)"
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
         #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
          PREPARE r170_pregsl FROM tmp_sql
          EXECUTE r170_pregsl
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('pregsl:',SQLCA.sqlcode,1)
             EXECUTE del_dpm
          END IF
    END FOR
###折讓
    LET l_wc=g_wc
    LET l_wc=change_string(l_wc,"tlf01","omb04")
    LET l_wc=change_string(l_wc,"tlf19","oma03")
    FOR g_idx=1 TO g_k
          LET tmp_sql= " INSERT INTO ",g_tname1,
          " SELECT oma03,MONTH(oma02),",
"           0,0,0,0,0,0,SUM(omb16),0 ",
#FUN-A10098---BEGIN
#"           FROM ",g_ary[g_idx].dbs_new CLIPPED,"oma_file",
#"               ,",g_ary[g_idx].dbs_new CLIPPED,"omb_file LEFT OUTER JOIN ",g_ary[g_idx].dbs_new CLIPPED,"ima_file ON omb04 = ima01",
"           FROM ",cl_get_target_table(g_ary[g_idx].plant,'oma_file'),
"               ,",cl_get_target_table(g_ary[g_idx].plant,'omb_file')," LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'ima_file')," ON omb04 = ima01",
#FUN-A10098---END
          " WHERE oma00='25' ", #銷貨折讓
          " AND ",l_wc CLIPPED,
          " AND oma02 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
         #" AND omb04 <> 'MISC'",       #MOD-710129 mod
          " AND omb04[1,4] <> 'MISC'",  #MOD-710129 mod
          " AND omb01=oma01 ",
#          " AND omb04 = ima_file.ima01(+) ",
          " GROUP BY oma03,MONTH(oma02)"
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
         #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
          PREPARE r170_predae FROM tmp_sql
          EXECUTE r170_predae
          IF SQLCA.sqlcode != 0 THEN
             EXECUTE del_dpm
             CALL cl_err('predae:',SQLCA.sqlcode,1)
          END IF
    END FOR
###雜項發票
    FOR g_idx=1 TO g_k
          LET tmp_sql= " INSERT INTO ",g_tname1,
          " SELECT oma03,MONTH(oma02),",
"           0,0,0,0,0,0,0,SUM(omb16) ",
#FUN-A10098---BEGIN
#"           FROM ",g_ary[g_idx].dbs_new CLIPPED,"oma_file",
#"               ,",g_ary[g_idx].dbs_new CLIPPED,"omb_file LEFT OUTER JOIN ",g_ary[g_idx].dbs_new CLIPPED,"ima_file ON omb04 = ima01 ",
#"               ,",g_ary[g_idx].dbs_new CLIPPED,"ome_file",
"           FROM ",cl_get_target_table(g_ary[g_idx].plant,'oma_file'),
"               ,",cl_get_target_table(g_ary[g_idx].plant,'omb_file')," LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'ima_file')," ON omb04 = ima01 ",
"               ,",cl_get_target_table(g_ary[g_idx].plant,'ome_file'),
#FUN-A10098---END
          " WHERE oma00='14' ",
          " AND ",l_wc CLIPPED,
          " AND oma02 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
          " AND oma10=ome01 AND omb04[1,4] <> 'MISC'",  #MOD-710129 mod
          " AND omb01=oma01 AND omevoid = 'N' ",
          " AND (oma75 = ome03 OR oma75 IS NULL)",    #No.FUN-B90130  
          " GROUP BY oma03,MONTH(oma02)"
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
          #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
          PREPARE r170_predac FROM tmp_sql
          EXECUTE r170_predac
          IF SQLCA.sqlcode != 0 THEN
             EXECUTE del_dpm
             CALL cl_err('predac:',SQLCA.sqlcode,1)
          END IF
    END FOR
   ### get dpm ALL
    LET l_sql=" INSERT INTO ",g_tname,
          " SELECT mm,0,0,0,sum(-qty),sum(-amt+dac_amt-dae_amt),sum(-cost),",
            " 0,0",
            " FROM ",g_tname1 CLIPPED,
            " GROUP BY mm"
    PREPARE pre_dpm_mm FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare dpm_mm:',SQLCA.sqlcode,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
       EXIT PROGRAM
    END IF
    EXECUTE pre_dpm_mm
   ### get dpm 關係人
    LET l_sql=" INSERT INTO ",g_tname,
            " SELECT mm,sum(-qty),sum(-amt+dac_amt-dae_amt),sum(-cost),",
            " 0,0,0,0,0",
            " FROM ",g_tname1 CLIPPED,
            " WHERE ",g_wc1 CLIPPED,
            " GROUP BY mm"
    PREPARE pre_dpm_mma FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare dpm_mma:',SQLCA.sqlcode,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
       EXIT PROGRAM
    END IF
    EXECUTE pre_dpm_mma
  ### get dpm totamt
  IF tm.sum_code MATCHES '[Yy]' THEN
     LET l_sql=" SELECT sum(qty),sum(amt),sum(cost),",
            "sum(qty1),sum(amt1),sum(cost1),sum(dae_amt),sum(dac_amt)",
            " FROM ",g_tname1 CLIPPED
	     PREPARE r170_sum FROM l_sql
             DECLARE sum_cursor CURSOR FOR r170_sum
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
       first_byte   LIKE type_file.chr1,          #No.FUN-680122char(01)
       nowx_byte    LIKE type_file.chr1,          #No.FUN-680122char(01)
       next_byte    LIKE type_file.chr1,          #No.FUN-680122char(01)
       this_byte    LIKE type_file.chr1,          #No.FUN-680122char(01)
       length1, length2, length3   LIKE type_file.num5,          #No.FUN-680122smallint
                     pu1, pu2      LIKE type_file.num5,          #No.FUN-680122smallint
       ii, jj, kk, ff, tt          LIKE type_file.num5           #No.FUN-680122smallint
 
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
 
FUNCTION r170_chkplant(l_plant)
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
#No.FUN-9C0073 ---By chenls 10/01/26
#FUN-A70084--add--str--
FUNCTION r170_set_visible()
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_azw05  LIKE azw_file.azw05

  SELECT azw05 INTO l_azw05 FROM azw_file WHERE azw01 = g_plant
  SELECT count(*) INTO l_cnt FROM azw_file
   WHERE azw05 = l_azw05

  IF l_cnt > 1 THEN
     CALL cl_set_comp_visible("group05",FALSE)
  END IF
  RETURN l_cnt
END FUNCTION

FUNCTION r170_chklegal(l_legal,n)
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
