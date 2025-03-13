# Prog. Version..: '5.30.06-13.04.19(00010)'     #
#
# Pattern name...: axcr700.4gl
# Descriptions...: 採購入庫月報
# Date & Author..: 98/12/03 By ANN CHEN
# Modify ........: 01/04/30 By Ostrich #No.+098&B190
# Modify ........: No:4681 03/07/18 By Kammy 代買材料應考慮(tlf13=apmt230)
#                                            目前放在一般採購抓
# Modify ........: No:7761 03/08/11 By Melody 在計算sr.amt01時,sql 應將UNAP的部份剔除，否則金額會重覆計算
# Modify ........: No:8483 03/11/20 By Melody 'TRI'此段判斷應拿掉
# Modify ........: No:9451 04/04/14 By Melody 修改tlf10 為tlf10*tlf60
# Modify ........: No:9584 04/05/20 By Melody 應加上委外重工工單
# Modify ........: No:9627 04/06/03 By Melody 應加上rvv25!='Y'
# Modify ........: No:8741 03/11/25 By Melody 修改PRINT段
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.MOD-4B0106 04/11/12 By ching enale UNAP
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大
# Modify.........: No.MOD-530137 05/07/20 By ching 抓apb101,apa42='N'
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-570190 05/08/06 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.MOD-580114 05/08/16 By Claire sr.amt01先default為0
# Modify.........: No.TQC-5B0019 05/11/08 By Sarah 將料號列印欄位長度放大到40碼
# Modify.........: No.MOD-620061 06/02/23 By Carol SQL加上日期區間的條件
# Modify.........: No.TQC-610051 06/02/23 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-620060 06/02/24 By Claire 說明%樣品;*非樣品但單價=0
# Modify.........: NO.FUN-640152 06/04/11 BY yiting 倉退數為0，材料金額有值，但報表印出來沒有值 
# Modify.........: NO.MOD-660047 06/06/19 BY Claire apb101算總計
# Modify.........: No.FUN-670067 06/07/20 By Hellen voucher轉成template1
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-690007 06/12/27 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.MOD-740381 07/04/25 By Carol add run card工單入庫的資料計算
# Modify.........: No.TQC-750022 07/05/08 By arman 制表日期與報表名稱所在的行數顛倒
# Modify.........: No.MOD-7B0184 07/11/21 By Carol 倉退金額處理邏輯調整
# Modify.........: No.FUN-7C0090 07/12/25 By zhangyajun 報表轉CR
# Modify.........: No.FUN-7B0038 08/01/30 By Sarah 選擇(tm.type)增加3.製程委外
# Modify.........: No.FUN-7C0101 08/01/30 By Cockroach 增加type1(成本計算類型)和報表增加印字段tlfccost(類別編號)
# Modify.........: No.FUN-830002 08/03/03 By lala    WHERE條件修改
# Modify.........: No.FUN-830123 08/03/26 By Zhangyajun 報表修改
# Modify.........: No.FUN-830140 08/04/02 By douzh 重新過單
# Modify.........: No.MOD-840152 08/04/19 By Pengu 廠商只秀一碼且應該廠商簡稱一併秀出
# Modify.........: No.MOD-830211 08/04/19 By Pengu 委外入庫無法列印出傳票號碼
# Modify.........: No.MOD-840403 08/04/22 By Sarah 在寫入Temptable時,不需判斷tm.a跟sr.code的值,傳入CR的參數p2應傳tm.a
# Modify.........: No.MOD-860019 08/07/14 By Pengu 當應付有立暫估時其列印的金額會異常
# Modify.........: No.MOD-850234 08/07/15 By lala 更改wpmc03的變量定義
# Modify.........: No.TQC-870029 08/07/18 By lumx axcr710抓取金額要抓按發票立賬的金額+暫估的金額-暫估已來發票的金額 
# Modify.........: No.MOD-880152 08/09/03 By Pengu 計算應負帳款的退貨折讓部分應排除"扣款折讓"類型
# Modify.........: No.MOD-870005 08/09/18 By Pengu 小計時不論成本分群碼是什麼都只會代出最後一個
# Modify.........: No.MOD-870151 08/09/18 By Pengu 製程委外不會抓取AP的立帳金額
# Modify.........: No.FUN-8B0026 08/12/02 By xiaofeizhu 提供INPUT加上關系人與營運中心
# Modify.........: No.FUN-8C0047 09/01/15 By zhaijie MARK cl_outnam()
# Modify.........: No.MOD-8C0106 09/02/16 By Pengu 會撈取azf03的資料放到變數msg但msg的長度只有50
# Modify.........: No.FUN-940102 09/04/27 BY destiny 檢查使用者的資料庫使用權限
# Modify.........: No.MOD-950160 09/05/15 BY wujie   cnd06定義的長度不夠
# Modify.........: No.CHI-910019 09/05/20 By Pengu 部份的退貨折讓成本會無法抓取到AP的金額因程式段只抓apa58=2
# Modify.........: No.TQC-970180 09/07/21 By xiaofeizhu 倉退的狀態抓取SUM(apb101)多加狀態apa00 = '26'
# Modify.........: No.TQC-970185 09/07/21 BY destiny l_sql改為string
# Modify.........: No.MOD-980199 09/08/22 By Smapmin QBE條件欄位轉換
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990086 09/09/09 By Carrier 報表資料剔除 不計算成本 的資料
# Modify.........: No.FUN-9B0009 09/11/02 By lilingyu Sql改成標準寫法
# Modify.........: No.FUN-9C0073 10/01/12 By chenls 程序精簡
# Modify.........: No.FUN-A10098 10/01/19 By baofei GP5.2跨DB報表--財務類
# Modify.........: No:MOD-A40046 10/04/09 By Summer 列印多角入庫單加判斷UNAP
# Modify.........: No:MOD-A40087 10/04/16 By Sarah 改用x_flag的值來判斷sr.amt01有沒有抓到值,當x_flag='N'時才往下一關抓取
# Modify.........: No:TQC-A40139 10/05/04 By Carrier  MOD-950291/MOD-950318 追单
# Modify.........: No.FUN-A50102 10/06/11 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-A70063 10/07/08 By Sarah 抓取倉退單金額時sql條件錯誤,應改為rvv01=sr.tlf026 AND rvv02=sr.tlf027
# Modify.........: No.FUN-A70084 10/07/15 By lutingting GP5.2報表修改 m_dbs是用來存放營運中心,改為m_plant 
# Modify.........: No:MOD-A80020-10/08/06 By wujie apb101抓绝对值
# Modify.........: No:MOD-B10175 11/07/17 By Pengu 未立帳的入庫單會取不到金額
# Modify.........: No:MOD-B80092 11/08/09 By johung apa_c3增加付款單身類別為入庫的條件
# Modify.........: No.TQC-BB0182 12/01/11 By pauline 取消過濾plant條件
# Modify.........: No:MOD-C20081 12/02/08 By ck2yuan l_rvu08後續並無運用,故將其mark
# Modify.........: No:MOD-C20103 12/02/10 By ck2yuan 抓取pmm22,pmm42應考慮無採購單收貨 rva00=2
# Modify.........: No:FUN-BB0063 12/02/13 By bart 成本考慮委外倉退金額
# Modify.........: No:CHI-C30055 12/03/27 By Elise 改善效能
# Modify.........: No:FUN-C50009 12/05/15 By bart 當行業別為ICD時，入非成本倉的AP金額也要印出來
# Modify.........: No:TQC-C60021 12/06/04 By Sarah ICD行業別時,要抓入非成本倉的資料出來,只是數量顯示0
# Modify.........: No:CHI-C30012 12/07/30 By bart 金額取位改抓ccz26
# Modify.........: No:MOD-D10063 13/01/09 By bart 將畫面的"應列印異動明細"  改為 radiobox選項為 "僅列印未立帳資料" 與 "列印所有異動資料"
# Modify.........: No:CHI-B30029 13/01/11 By Alberti 系統並無ima2_file，故將此段mark
# Modify.........: No:FUN-D20078 13/02/26 By xujing 倉退單過帳寫tlf時,區分一般倉退和委外倉退,同時修正成本計算及相關查詢報表邏輯
# Modify.........: No:MOD-D40112 13/04/16 By ck2yuan 傳tm.type至報表,在報表依此變數決定title名稱
# Modify.........: No:CHI-D30019 13/04/18 By bart 1.畫面列印委外倉退欄位移除2.排除委外倉退資料不列印  
# Modify.........: No:TQC-D90023 13/09/23 By yuhuabao 添加規格欄位顯示,放寬入庫單號欄位

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm    RECORD                  # Print condition RECORD
              wc       LIKE type_file.chr1000,   #No.FUN-680122CHAR(300)      # Where condition
              bdate    LIKE type_file.dat,       #No.FUN-680122DATE
              edate    LIKE type_file.dat,       #No.FUN-680122DATE
              type     LIKE type_file.chr1,      #No.FUN-680122CHAR(1)
              a        LIKE type_file.chr1,      #No.FUN-680122CHAR(1)
              #costdown LIKE type_file.chr1,      #FUN-BB0063  #CHI-D30019
              g        LIKE type_file.chr1,      #No.FUN-680122CHAR(1)
              b        LIKE type_file.chr1,      #No.FUN-8B0026 VARCHAR(1)
              p1       LIKE azp_file.azp01,      #No.FUN-8B0026 VARCHAR(10)
              p2       LIKE azp_file.azp01,      #No.FUN-8B0026 VARCHAR(10)
              p3       LIKE azp_file.azp01,      #No.FUN-8B0026 VARCHAR(10)
              p4       LIKE azp_file.azp01,      #No.FUN-8B0026 VARCHAR(10) 
              p5       LIKE azp_file.azp01,      #No.FUN-8B0026 VARCHAR(10)
              p6       LIKE azp_file.azp01,      #No.FUN-8B0026 VARCHAR(10)
              p7       LIKE azp_file.azp01,      #No.FUN-8B0026 VARCHAR(10)
              p8       LIKE azp_file.azp01,      #No.FUN-8B0026 VARCHAR(10)
              type_1   LIKE type_file.chr1,      #No.FUN-8B0026 VARCHAR(1)
              s        LIKE type_file.chr3,      #No.FUN-8B0026 VARCHAR(3)
              t        LIKE type_file.chr3,      #No.FUN-8B0026 VARCHAR(3)
              u        LIKE type_file.chr3,      #No.FUN-8B0026 VARCHAR(3)              
              more     LIKE type_file.chr1,      #No.FUN-680122CHAR(1)  # Input more condition(Y/N)
              type1    LIKE type_file.chr1       #No.FUN-7C0101  ADD    #Cost Calculation Method      
             END RECORD
DEFINE g_i             LIKE type_file.num5       #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000    #No.FUN-680122CHAR(72)
DEFINE l_table         STRING
DEFINE g_str           STRING 
DEFINE g_sql           STRING
#DEFINE m_dbs          ARRAY[10] OF LIKE type_file.chr20  #No.FUN-8B0026 ARRAY[10] OF VARCHAR(20)   #FUN-A70084
DEFINE m_plant         ARRAY[10] OF LIKE azp_file.azp01   #FUN-A70084
DEFINE m_legal         ARRAY[10] OF LIKE azw_file.azw02   #FUN-A70084
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
   
   LET g_sql="chr1.type_file.chr1,ima12.ima_file.ima12,",
             "ima01.ima_file.ima01,ima02.ima_file.ima02,",
             "ima021.ima_file.ima021,",                               #No.TQC-D90023 add 
             "tlfccost.tlfc_file.tlfccost,tlf021.tlf_file.tlf021,",   #FUN-7C0101 ADD tlfccost
             "tlf031.tlf_file.tlf031,tlf06.tlf_file.tlf06,",
             "tlf026.tlf_file.tlf026,tlf027.tlf_file.tlf027,",
             "tlf036.tlf_file.tlf036,tlf037.tlf_file.tlf037,",
             "tlf01.tlf_file.tlf01,tlf10.tlf_file.tlf10,",
             "tlfc21.tlfc_file.tlfc21,tlf13.tlf_file.tlf13,",  #FUN-7C0101 tlf21-->tlfc21  
             "tlf65.tlf_file.tlf65,tlf19.tlf_file.tlf19,",
             "tlf905.tlf_file.tlf905,tlf906.tlf_file.tlf906,",
             "tlf907.tlf_file.tlf907,tlf221.tlf_file.tlf221,",
             "azi03.azi_file.azi03,ccz27.ccz_file.ccz27,",
             "cnd06.type_file.chr100,pmc03.pmc_file.pmc03,",   #No.MOD-950160  #No.MOD-870005 modify 
             "msg.azf_file.azf03,plant.azp_file.azp01,",       #No.MOD-870005 add   #No.MOD-8C0106 modify #FUN-8B0026
             "ima57.ima_file.ima57,ima08.ima_file.ima08"       #FUN-8B0026
   LET l_table=cl_prt_temptable('axcr700',g_sql)CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
             "        ?,?,?,?,?, ?,?,?,?,? ,?)"  #FUN-7C0101 ADD ?  #No.MOD-870005 add ? #FUN-8B0026 Add ?,?,? #TQC-D90023 add 1?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   #LET tm.a    = 'N' #MOD-D10063
   LET tm.a    = '1'  #MOD-D10063
   LET tm.g    = '1'
   LET tm.type1= ARG_VAL(17)          #FUN-7C0101 ADD
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.type  = ARG_VAL(10)
   LET tm.a  = ARG_VAL(11)
   LET tm.g  = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   LET tm.b     = ARG_VAL(18)
   LET tm.p1    = ARG_VAL(19)
   LET tm.p2    = ARG_VAL(20)
   LET tm.p3    = ARG_VAL(21)
   LET tm.p4    = ARG_VAL(22)
   LET tm.p5    = ARG_VAL(23)
   LET tm.p6    = ARG_VAL(24)
   LET tm.p7    = ARG_VAL(25)
   LET tm.p8    = ARG_VAL(26)
   LET tm.type_1= ARG_VAL(27)   
   LET tm.s     = ARG_VAL(28)
   LET tm.t     = ARG_VAL(29)
   LET tm.u     = ARG_VAL(30)   
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
      THEN CALL axcr700_tm(0,0)
      ELSE CALL axcr700()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr700_tm(p_row,p_col)
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col      LIKE type_file.num5     #No.FUN-680122 SMALLINT
DEFINE l_flag           LIKE type_file.chr1     #No.FUN-680122 VARCHAR(1)
DEFINE l_bdate,l_edate  LIKE type_file.dat      #No.FUN-680122DATE
DEFINE l_cmd            LIKE type_file.chr1000  #No.FUN-680122CHAR(400)
DEFINE l_cnt            LIKE type_file.num5     #No.FUN-A70084

   IF p_row = 0 THEN LET p_row = 4 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 15
   END IF
   OPEN WINDOW axcr700_w AT p_row,p_col
        WITH FORM "axc/42f/axcr700"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   CALL r700_set_visible() RETURNING l_cnt    #FUN-A70084
   INITIALIZE tm.* TO NULL
   CALL s_azm(g_ccz.ccz01,g_ccz.ccz02) RETURNING l_flag,l_bdate,l_edate
   LET tm.bdate= l_bdate
   LET tm.edate= l_edate
   LET tm.type = '1'
   LET tm.more= 'N'
   #LET tm.a   = 'N' #MOD-D10063
   LET tm.a = '1'  #MOD-D10063
   #LET tm.costdown = 'N'  #FUN-BB0063  #CHI-D30019
   LET tm.g   = '1'
   LET tm.type1 = g_ccz.ccz28       #FUN-7C0101 ADD
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'
   LET tm.s ='12 '
   LET tm.t ='Y  '
   LET tm.u ='Y  '
   LET tm.type_1  = '3'
   LET tm.b ='N'
   LET tm.p1=g_plant
   CALL r700_set_entry_1()               
   CALL r700_set_no_entry_1()
   CALL r700_set_comb()           
   
 WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ima12,ima01,ima57,ima08 ,tlf19
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr700_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF

   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF

   #INPUT BY NAME tm.bdate,tm.edate,tm.type1,tm.a,tm.costdown,tm.type ,tm.g,  #FUN-7C0101 ADD tm.type1  #FUN-BB0063 #CHI-D30019
   INPUT BY NAME tm.bdate,tm.edate,tm.type1,tm.a,tm.type ,tm.g,  #CHI-D30019   
                 tm.b,tm.p1,tm.p2,tm.p3,                                                    #FUN-8B0026
                 tm.p4,tm.p5,tm.p6,tm.p7,tm.p8,tm.type_1,                                   #FUN-8B0026 
                 tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,                                 #FUN-8B0026
                 tm2.u1,tm2.u2,tm2.u3,                                                      #FUN-8B0026   
                 tm.more
      WITHOUT DEFAULTS
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF

      AFTER FIELD edate
         IF cl_null(tm.edate) OR tm.edate<tm.bdate THEN NEXT FIELD edate END IF

      AFTER FIELD type1
         IF tm.type1 IS NULL OR tm.type1 NOT MATCHES '[12345]' THEN NEXT FIELD type1 END IF

      AFTER FIELD type
         IF cl_null(tm.type) OR tm.type not matches '[123]'   #FUN-7B0038 add 3
         THEN NEXT FIELD type
         END IF

      AFTER FIELD g
         IF cl_null(tm.g   ) OR tm.g    not matches '[123]'
         THEN NEXT FIELD g
         END IF
         IF tm.g  =  '1'
            THEN NEXT FIELD more
         END IF
        
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
         CALL r700_set_entry_1()      
         CALL r700_set_no_entry_1()
         CALL r700_set_comb()       
       
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
            IF NOT s_chk_demo(g_user,tm.p2) THEN              
               NEXT FIELD p2          
            END IF            
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[2] FROM azw_file WHERE azw01 = tm.p2
            IF NOT r700_chklegal(m_legal[2],1) THEN
               CALL cl_err(tm.p2,g_errno,0)
               NEXT FIELD p2
            END IF
            #FUN-A70084--add--end
         END IF
 
      AFTER FIELD p3
         IF NOT cl_null(tm.p3) THEN
            SELECT azp01 FROM azp_file WHERE azp01 = tm.p3
            IF STATUS THEN 
               CALL cl_err3("sel","azp_file",tm.p3,"",STATUS,"","sel azp",1)   
               NEXT FIELD p3 
            END IF
            IF NOT s_chk_demo(g_user,tm.p3) THEN
               NEXT FIELD p3
            END IF            
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[3] FROM azw_file WHERE azw01 = tm.p3
            IF NOT r700_chklegal(m_legal[3],2) THEN
               CALL cl_err(tm.p3,g_errno,0)
               NEXT FIELD p3
            END IF
            #FUN-A70084--add--end
         END IF
 
      AFTER FIELD p4
         IF NOT cl_null(tm.p4) THEN
            SELECT azp01 FROM azp_file WHERE azp01 = tm.p4
            IF STATUS THEN 
               CALL cl_err3("sel","azp_file",tm.p4,"",STATUS,"","sel azp",1)  
               NEXT FIELD p4 
            END IF
            IF NOT s_chk_demo(g_user,tm.p4) THEN
               NEXT FIELD p4
            END IF            
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[4] FROM azw_file WHERE azw01 = tm.p4
            IF NOT r700_chklegal(m_legal[4],3) THEN
               CALL cl_err(tm.p4,g_errno,0)
               NEXT FIELD p4
            END IF
            #FUN-A70084--add--end
         END IF
 
      AFTER FIELD p5
         IF NOT cl_null(tm.p5) THEN
            SELECT azp01 FROM azp_file WHERE azp01 = tm.p5
            IF STATUS THEN 
               CALL cl_err3("sel","azp_file",tm.p5,"",STATUS,"","sel azp",1)    
               NEXT FIELD p5 
            END IF
            IF NOT s_chk_demo(g_user,tm.p5) THEN
               NEXT FIELD p5
            END IF            
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[5] FROM azw_file WHERE azw01 = tm.p5
            IF NOT r700_chklegal(m_legal[5],4) THEN
               CALL cl_err(tm.p5,g_errno,0)
               NEXT FIELD p5
            END IF
            #FUN-A70084--add--end
         END IF
 
      AFTER FIELD p6
         IF NOT cl_null(tm.p6) THEN
            SELECT azp01 FROM azp_file WHERE azp01 = tm.p6
            IF STATUS THEN 
               CALL cl_err3("sel","azp_file",tm.p6,"",STATUS,"","sel azp",1)  
               NEXT FIELD p6 
            END IF
            IF NOT s_chk_demo(g_user,tm.p6) THEN
               NEXT FIELD p6
            END IF            
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[6] FROM azw_file WHERE azw01 = tm.p6
            IF NOT r700_chklegal(m_legal[6],5) THEN
               CALL cl_err(tm.p6,g_errno,0)
               NEXT FIELD p6
            END IF
            #FUN-A70084--add--end
         END IF
 
      AFTER FIELD p7
         IF NOT cl_null(tm.p7) THEN
            SELECT azp01 FROM azp_file WHERE azp01 = tm.p7
            IF STATUS THEN 
               CALL cl_err3("sel","azp_file",tm.p7,"",STATUS,"","sel azp",1) 
               NEXT FIELD p7 
            END IF
            IF NOT s_chk_demo(g_user,tm.p7) THEN
               NEXT FIELD p7
            END IF            
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[7] FROM azw_file WHERE azw01 = tm.p7
            IF NOT r700_chklegal(m_legal[7],6) THEN
               CALL cl_err(tm.p7,g_errno,0)
               NEXT FIELD p7
            END IF
            #FUN-A70084--add--end
         END IF
 
      AFTER FIELD p8
         IF NOT cl_null(tm.p8) THEN
            SELECT azp01 FROM azp_file WHERE azp01 = tm.p8
            IF STATUS THEN 
               CALL cl_err3("sel","azp_file",tm.p8,"",STATUS,"","sel azp",1)   
               NEXT FIELD p8 
            END IF
            IF NOT s_chk_demo(g_user,tm.p8) THEN
               NEXT FIELD p8
            END IF            
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[8] FROM azw_file WHERE azw01 = tm.p8
            IF NOT r700_chklegal(m_legal[8],7) THEN
               CALL cl_err(tm.p8,g_errno,0)
               NEXT FIELD p8
            END IF
            #FUN-A70084--add--end
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
 
      ON ACTION CONTROLG
         CALL cl_cmdask()    # Command execution
      
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr700_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr700'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr700','9031',1)   
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
                         " '",tm.type1 CLIPPED,"'",       #FUN-7C0101 ADD
                         " '",tm.type  CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",                 #TQC-610051
                         " '",tm.g CLIPPED,"'",                 #TQC-610051
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'",           #No.FUN-7C0078
                         " '",tm.b CLIPPED,"'" ,     #FUN-8B0026
                         " '",tm.p1 CLIPPED,"'" ,    #FUN-8B0026
                         " '",tm.p2 CLIPPED,"'" ,    #FUN-8B0026
                         " '",tm.p3 CLIPPED,"'" ,    #FUN-8B0026
                         " '",tm.p4 CLIPPED,"'" ,    #FUN-8B0026
                         " '",tm.p5 CLIPPED,"'" ,    #FUN-8B0026
                         " '",tm.p6 CLIPPED,"'" ,    #FUN-8B0026
                         " '",tm.p7 CLIPPED,"'" ,    #FUN-8B0026
                         " '",tm.p8 CLIPPED,"'" ,    #FUN-8B0026
                         " '",tm.type_1 CLIPPED,"'" ,#FUN-8B0026                        
                         " '",tm.s CLIPPED,"'" ,     #FUN-8B0026
                         " '",tm.t CLIPPED,"'" ,     #FUN-8B0026
                         " '",tm.u CLIPPED,"'"       #FUN-8B0026                         
 
         CALL cl_cmdat('axcr700',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr700_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr700()
   ERROR ""
END WHILE
   CLOSE WINDOW axcr700_w
END FUNCTION

#CHI-C30055-------------------(S)-----------------------
FUNCTION r700_def_cur(l_i)
DEFINE l_sql     STRING
DEFINE l_i       LIKE type_file.num5
DEFINE l_rva00   LIKE rva_file.rva00

   LET l_sql = "SELECT apa44 ",                                                                              
               "  FROM ",cl_get_target_table(m_plant[l_i],'apb_file'),",",
                         cl_get_target_table(m_plant[l_i],'apa_file'),
               " WHERE apb21=?",
               "   AND apb22=?",
               "   AND apb01=apa01 ",
               "   AND apa42 = 'N' ",
               "   AND apb34 <> 'Y'"
               ,"  AND apb29 = '1'"   
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql             
   PREPARE apa_prepare3 FROM l_sql                                                                                          
   DECLARE apa_c3  CURSOR FOR apa_prepare3
   
   
   LET l_sql = "SELECT SUM(apb101) ",                       
               "  FROM ",cl_get_target_table(m_plant[l_i],'apb_file'),",",
                         cl_get_target_table(m_plant[l_i],'apa_file'),
               " WHERE apa01 = apb01 AND apa42 = 'N'",
               "   AND apb29='1' AND  apb21=? ",
               "   AND apb22=? AND apb12=? ",
               "   AND (apa00 ='11' OR apa00 = '16') ",
               "   AND apb34 <> 'Y'",
               "   AND apa02 BETWEEN ? AND ? "       
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql             
   PREPARE apb_prepare3 FROM l_sql                                                                                          
   DECLARE apb_c3  CURSOR FOR apb_prepare3     
   
   
   LET l_sql = "SELECT ale09 ",                                                                                                                                               
               "  FROM ",cl_get_target_table(m_plant[l_i],'ale_file'),                                                                  
               " WHERE ale16=?",
               "   AND ale17=?",
               "   AND ale11=?" 
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql           
   PREPARE ale_prepare3 FROM l_sql                                                                                          
   DECLARE ale_c3  CURSOR FOR ale_prepare3     
   
   
   LET l_sql = "SELECT SUM(apb101) ",                                                                              
               "  FROM ",cl_get_target_table(m_plant[l_i],'apb_file'),",",
                         cl_get_target_table(m_plant[l_i],'apa_file'),
               " WHERE apa01 = apb01 AND apa42 = 'N'",
               "   AND apb29='1' AND  apb21=?",
               "   AND apb22=? AND apb12=? ",
               "   AND apa00 ='16' ",
               "   AND apb34 <> 'Y'",
               "   AND apa02 BETWEEN ? AND ? "       
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql          
   PREPARE apb_prepare2 FROM l_sql                                                                                          
   DECLARE apb_c2  CURSOR FOR apb_prepare2    
   
   
   LET l_sql = "SELECT rvv04,rvv05,rvv39 ",                                                                                                                                                    
               "  FROM ",cl_get_target_table(m_plant[l_i],'rvv_file'),
               " WHERE rvv01=?",
               "   AND rvv02=?",
               "   AND rvv25<>'Y'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              
   PREPARE rvv_prepare3 FROM l_sql                                                                                          
   DECLARE rvv_c3  CURSOR FOR rvv_prepare3                
   
   
  #IF l_rva00 <> '2' THEN   #TQC-C60021 mark
      LET l_sql = "SELECT pmm22,rva06,pmm42 ",                                                                              
                  "  FROM ",cl_get_target_table(m_plant[l_i],'rvb_file'),",",
                            cl_get_target_table(m_plant[l_i],'pmm_file'),",",
                            cl_get_target_table(m_plant[l_i],'rva_file'),
                  " WHERE rvb01=? AND rvb02=?",
                  "   AND pmm01=rvb04 AND rva01 =rvb01",
                  "   AND rvaconf <> 'X'  AND pmm18 <> 'X' "     
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql            
      PREPARE pmm_prepare2_0 FROM l_sql                                                                                          
      DECLARE pmm_c2_0  CURSOR FOR pmm_prepare2_0
  #ELSE                     #TQC-C60021 mark
      LET l_sql = "SELECT rva113,rva06,rva114 ",
                  "  FROM ",cl_get_target_table(m_plant[l_i],'rvb_file'),",",
                            cl_get_target_table(m_plant[l_i],'rva_file'),
                  " WHERE rvb01=? AND rvb02=?",
                  "   AND rva01 = rvb01 AND rvaconf <> 'X'  "
  #END IF                   #TQC-C60021 mark
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql            
      PREPARE pmm_prepare2 FROM l_sql                                                                                          
      DECLARE pmm_c2  CURSOR FOR pmm_prepare2         
   
   
   LET l_sql = "SELECT apa44 ",                                                                              
               "  FROM ",cl_get_target_table(m_plant[l_i],'apb_file'),",",
                         cl_get_target_table(m_plant[l_i],'apa_file'),
               " WHERE apb21=? AND apb22=?",
               "   AND apb01=apa01",
               "   AND apa42 = 'N'  AND apb34 <> 'Y' "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql          
   PREPARE apa_prepare2 FROM l_sql                                                                                          
   DECLARE apa_c2  CURSOR FOR apa_prepare2       
   
   
   LET l_sql = "SELECT SUM(apb101) ",                                                                              
               "  FROM ",cl_get_target_table(m_plant[l_i],'apb_file'),",",
                         cl_get_target_table(m_plant[l_i],'apa_file'),
               " WHERE apa01 = apb01 AND apa42 = 'N'",
               "   AND apb29='3' AND  apb21=?",
               "   AND apb22=? AND apb12=? ",
               "   AND apa00 ='21' ",
               "   AND (apa58 ='2' OR apa58 = '3') ",   
               "   AND apb34 <> 'Y'",
               "   AND apa02 BETWEEN ? AND ? "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              
   PREPARE apb_prepare1 FROM l_sql          
   DECLARE apb_c1  CURSOR FOR apb_prepare1       
   
   
   LET l_sql = "SELECT SUM(ABS(apb101)) ",                                                                             
               "  FROM ",cl_get_target_table(m_plant[l_i],'apb_file'),",",
                         cl_get_target_table(m_plant[l_i],'apa_file'),
               " WHERE apa01 = apb01 AND apa42 = 'N'",
               "   AND apb29='3' AND  apb21=?",
               "   AND apb22=? AND apb12=? ",
               "   AND (apa00 ='11' OR apa00 = '26') ",                         
               "   AND apb34 <> 'Y'",
               "   AND apa02 BETWEEN ? AND ? " 
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql             
   PREPARE apb_prepare4 FROM l_sql                                                                                          
   DECLARE apb_c4  CURSOR FOR apb_prepare4      
   
   
   LET l_sql = "SELECT ale09 ",                                                                                                                                         
               "  FROM ",cl_get_target_table(m_plant[l_i],'ale_file'),   
               " WHERE ale16=?",   
               "   AND ale17=?",   
               "   AND ale11=?"                             
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              
   PREPARE ale_prepare2 FROM l_sql                                                                                          
   DECLARE ale_c2  CURSOR FOR ale_prepare2    
   
   
   LET l_sql = "SELECT SUM(apb101) ",                                                                              
               "  FROM ",cl_get_target_table(m_plant[l_i],'apb_file'),",",
                         cl_get_target_table(m_plant[l_i],'apa_file'),
               " WHERE apa01 = apb01 AND apa42 = 'N'",
               "   AND apb29='3' AND  apb21=?",
               "   AND apb22=? AND apb12=? ",
               "   AND apa00 ='26' ",
               "   AND (apa58 ='2' OR apa58 = '3') ",  
               "   AND apb34 <> 'Y'",
               "   AND apa02 BETWEEN ? AND ? "     
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql            
   PREPARE apb_prepare5 FROM l_sql                                                                                          
   DECLARE apb_c5  CURSOR FOR apb_prepare5                   
   
   
   LET l_sql = "SELECT rvv04,rvv05,rvv39 ",                                                                                                                                                  
               "  FROM ",cl_get_target_table(m_plant[l_i],'rvv_file'),
               " WHERE rvv01=?", 
               "   AND rvv02=?",  
               "   AND rvv25<>'Y'"                                     
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql            
   PREPARE rvv_prepare2 FROM l_sql                                                                                          
   DECLARE rvv_c2  CURSOR FOR rvv_prepare2             
   
   
   IF l_rva00 <> '2'THEN                                       
      LET l_sql = "SELECT pmm22,rva06,pmm42 ",                                                                              
                  "  FROM ",cl_get_target_table(m_plant[l_i],'rvb_file'),",",
                            cl_get_target_table(m_plant[l_i],'pmm_file'),",", 
                            cl_get_target_table(m_plant[l_i],'rva_file'),    
                  " WHERE rvb01=? AND rvb02=?",
                  "   AND pmm01=rvb04 AND rva01 = rvb01",
                  "   AND rvaconf <> 'X'  AND pmm18 <> 'X' "   
   ELSE
       LET l_sql = "SELECT rva113,rva06,rva114 ",
                   "  FROM ",cl_get_target_table(m_plant[l_i],'rvb_file'),",",
                             cl_get_target_table(m_plant[l_i],'rva_file'),
                   " WHERE rvb01=? AND rvb02=?",
                   "   AND rva01 = rvb01 AND rvaconf <> 'X'  "
   END IF
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql                      
   PREPARE pmm_prepare1 FROM l_sql                                                                                          
   DECLARE pmm_c1  CURSOR FOR pmm_prepare1       
   
   
   LET l_sql = "SELECT COUNT(*) ",                                                                              
               "  FROM ",cl_get_target_table(m_plant[l_i],'rvv_file'),  
               " WHERE rvv01 = ?",
               "   AND rvv02 = ?",
               "   AND rvv25 = 'Y' "   
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              
   PREPARE rvv_prepare1 FROM l_sql                                                                                          
   DECLARE rvv_c1  CURSOR FOR rvv_prepare1              
   
   
   LET l_sql = "SELECT azf03 ",                                                                              
               "  FROM ",cl_get_target_table(m_plant[l_i],'azf_file'),
               " WHERE azf01=? AND azf02='G'"          
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql             
   PREPARE azf_prepare1 FROM l_sql                                                                                          
   DECLARE azf_c1  CURSOR FOR azf_prepare1              
   
   
   LET l_sql = "SELECT pmc03,pmc903 ",                                                                              
               "  FROM ",cl_get_target_table(m_plant[l_i],'pmc_file'), 
               " WHERE pmc01= ?"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql             
   PREPARE pmc_prepare1 FROM l_sql                                                                                          
   DECLARE pmc_c1  CURSOR FOR pmc_prepare1         
   
   
   LET l_sql = "SELECT ima202 ",                                                                              
               "  FROM ",cl_get_target_table(m_plant[l_i],'ima2_file'), 
               " WHERE ima201= ?"                        
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql             
   PREPARE ima_prepare1 FROM l_sql                                                                                          
   DECLARE ima_c1  CURSOR FOR ima_prepare1                  
   
   
   LET l_sql = "SELECT ima131 ",                                                                              
               "  FROM ",cl_get_target_table(m_plant[l_i],'ima_file'), 
               " WHERE ima01 = ?"                          
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              
   PREPARE ima_prepare2 FROM l_sql                                                                                          
   DECLARE ima_c2  CURSOR FOR ima_prepare2                   
   
   
   LET l_sql = "SELECT azf03 ",                                                                              
               "  FROM ",cl_get_target_table(m_plant[l_i],'azf_file'),  
               " WHERE azf01=? AND azf02='G'"                                                                                                                                                                                 
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              
   PREPARE azf_prepare4 FROM l_sql                                                                                          
   DECLARE azf_c4  CURSOR FOR azf_prepare4       
   
   
   LET l_sql = "SELECT azf03 ",                                                                              
               "  FROM ",cl_get_target_table(m_plant[l_i],'azf_file'), 
               " WHERE azf01=? AND azf02='G'"             
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql             
   PREPARE azf_prepare5 FROM l_sql                                                                                          
   DECLARE azf_c5  CURSOR FOR azf_prepare5           
END FUNCTION 
#CHI-C30055-------------------(E)-----------------------

 
FUNCTION axcr700()
   DEFINE l_name      LIKE type_file.chr20,       #No.FUN-680122CHAR(20)        # External(Disk) file name
          l_sql       STRING,                     #No.TQC-970185 
          l_chr       LIKE type_file.chr1,        #No.FUN-680122 VARCHAR(1)
          l_rvv04     LIKE rvv_file.rvv04,
          l_rvv05     LIKE rvv_file.rvv05,
          l_rvv39     LIKE rvv_file.rvv39,
          l_rva00     LIKE rva_file.rva00,        #MOD-C20103 add
          l_rva06     LIKE rva_file.rva06,
          l_pmm22     LIKE pmm_file.pmm22,
          l_pmm42     LIKE pmm_file.pmm42,
          wima01      LIKE ima_file.ima01,        #No.FUN-680122char(  3)
          wima201     LIKE type_file.chr2,        #No.FUN-680122char(  2)
          wpmc03      LIKE pmc_file.pmc03,        #No.MOD-850234
          wima202     LIKE tlf_file.tlf19,        #No.FUN-7C0090
          l_company   LIKE type_file.chr50,      
          sr RECORD
             code     LIKE type_file.chr1,        #No.FUN-680122CHAR(01)
             ima12    LIKE ima_file.ima12,
             ima01    LIKE ima_file.ima01,
             ima02    LIKE ima_file.ima02,
             ima021   LIKE ima_file.ima021,       #No.TQC-D90023 add
             tlfccost LIKE tlfc_file.tlfccost,    #FUN-7C0101 ADD
             tlf021   LIKE tlf_file.tlf021,
             tlf031   LIKE tlf_file.tlf031,
             tlf06    LIKE tlf_file.tlf06,
             tlf026   LIKE tlf_file.tlf026,
             tlf027   LIKE tlf_file.tlf027,
             tlf036   LIKE tlf_file.tlf036,
             tlf037   LIKE tlf_file.tlf037,
             tlf01    LIKE tlf_file.tlf01,
             tlf10    LIKE tlf_file.tlf10,
             tlfc21   LIKE tlfc_file.tlfc21,      #FUN-7C0101 tlf21-->tlfc21  
             tlf13    LIKE tlf_file.tlf13,
             tlf65    LIKE tlf_file.tlf65,
             tlf19    LIKE tlf_file.tlf19,
             tlf905   LIKE tlf_file.tlf905,
             tlf906   LIKE tlf_file.tlf906,
             tlf907   LIKE tlf_file.tlf907,
             amt01    LIKE tlf_file.tlf221        #材料金額
             END RECORD,
          l_n         LIKE type_file.num5,        #No.FUN-680122 SMALLINT
         #l_rvu08     LIKE rvu_file.rvu08,        #MOD-C20081 mark
          l_i         LIKE type_file.num5,        #No.FUN-8B0026 SMALLINT
          l_dbs       LIKE azp_file.azp03,        #No.FUN-8B0026
          l_azp03     LIKE azp_file.azp03,        #No.FUN-8B0026
          l_pmc903    LIKE pmc_file.pmc903,       #No.FUN-8B0026
          i           LIKE type_file.num5,        #No.FUN-8B0026
          l_ima57     LIKE ima_file.ima57,        #No.FUN-8B0026
          l_ima08     LIKE ima_file.ima08,        #No.FUN-8B0026         
          l_slip      LIKE smy_file.smyslip,      #No.MOD-990086
          l_smydmy1   LIKE smy_file.smydmy1,      #No.MOD-990086
          x_flag      LIKE type_file.chr1,        #MOD-A40087 add
          l_cnt       LIKE type_file.num5         #FUN-A70084 
          #l_costdown  STRING                      #FUN-BB0063 #CHI-D30019
   #FUN-C50009---begin
   DEFINE sr1 RECORD  
              tlf036   LIKE tlf_file.tlf036,
              tlf037   LIKE tlf_file.tlf037,
              tlf026   LIKE tlf_file.tlf026,
              tlf027   LIKE tlf_file.tlf027,
              tlf01    LIKE tlf_file.tlf01
              END RECORD
   DEFINE l_amt01      LIKE tlf_file.tlf221
   DEFINE o_tlf036     LIKE tlf_file.tlf036
   DEFINE o_tlf026     LIKE tlf_file.tlf026
   DEFINE o_tlf01      LIKE tlf_file.tlf01
   #FUN-C50009---end

   CALL cl_del_data(l_table)             #No.FUN-7C0090
   
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
#FUN-A70084--mod--str-- 
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
      
   FOR l_i = 1 to 8                                                          #FUN-8B0026
     #刪除存放委外工單入非成本倉tlf資料的Temptable
      DROP TABLE axcr700_temp    #FUN-C50009
     #DELETE FROM axcr700_temp   #FUN-C50009

     #FUN-A70084--mod--str--ms_dbs-->m_plant
     #IF cl_null(m_dbs[l_i]) THEN CONTINUE FOR END IF                       #FUN-8B0026
     #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=m_dbs[l_i]          #FUN-8B0026
      IF cl_null(m_plant[l_i]) THEN CONTINUE FOR END IF 
      CALL r700_set_visible() RETURNING l_cnt    #FUN-A70084
      IF l_cnt>1 THEN   #Single DB
         LET m_plant[1] = g_plant
      END IF 
     #FUN-A70084--mod--end
     #LET l_azp03 = l_dbs CLIPPED                                           #FUN-8B0026   #FUN-A70084
     #LET l_dbs = s_dbstring(l_dbs CLIPPED)                                         #FUN-8B0026  #FUN-A70084
 
     CASE tm.type
       WHEN '1'    #一般採購
#       LET l_sql = "SELECT '',ima12,ima01,ima02,tlfccost,",          #FUN-7C0101 ADD tlfccost #TQC-D90023 mark
        LET l_sql = "SELECT '',ima12,ima01,ima02,ima021,tlfccost,",   #TQC-D90023 add ima021
                          " tlf021,tlf031,tlf06,tlf026,tlf027,tlf036,tlf037,",
                          " tlf01,tlf10*tlf60,tlfc21,tlf13,tlf65,tlf19,tlf905,tlf906,tlf907,0,ima57,ima08",    #No.9451  #FUN-7C0101 tlf21-->tlfc21  #FUN-8B0026 Add ,ima57,ima08
                   #" FROM ",l_dbs CLIPPED,"tlf_file ",
                   #" LEFT OUTER JOIN ",l_dbs CLIPPED,"tlfc_file ",
                    " FROM ",cl_get_target_table(m_plant[l_i],'tlf_file'),
                    " LEFT OUTER JOIN ",cl_get_target_table(m_plant[l_i],'tlfc_file'),  #FUN-A10098   #FUN-A70084 m_dbs-->m_plant
                    "   ON tlfc01 = tlf01  AND tlfc02 = tlf02  AND tlfc03 = tlf03 AND ",  #FUN-A10098
                    "      tlfc06 = tlf06  AND tlfc13 = tlf13  AND ",
                    "      tlfc902= tlf902 AND tlfc903= tlf903 AND ",
                    "      tlfc904= tlf904 AND tlfc905= tlf905 AND ",
                    "      tlfc906= tlf906 AND tlfc907= tlf907 AND ",
                    "      tlfctype = '",tm.type1,"'",
                   #"     ,",l_dbs CLIPPED,"ima_file",  #FUN-A10098
                   #"     ,",cl_get_target_table(m_dbs[l_i],'ima_file'),  #FUN-A10098   #FUN-A70084
                    "     ,",cl_get_target_table(m_plant[l_i],'ima_file'), #FUN-A70084
                    " WHERE ima01 = tlf01",
                    "   AND (tlf13 = 'apmt150' OR tlf13 = 'apmt1072' ",
                    "    OR  tlf13 = 'apmt230') ", #No.4681 add  
                    "   AND ",tm.wc CLIPPED,
                    "   AND (tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')",
                   #"   AND tlf902 NOT IN (SELECT jce02 FROM ",l_dbs CLIPPED,"jce_file)" #JIT除外   #FUN-8B0026 Add ",l_dbs CLIPPED,"  #FUN-A10098
                   #"   AND tlf902 NOT IN (SELECT jce02 FROM ",cl_get_target_table(m_dbs[l_i],'jce_file'),")"    #FUN-A10098     #FUN-A70084
                    "   AND tlf902 NOT IN (SELECT jce02 FROM ",cl_get_target_table(m_plant[l_i],'jce_file'),")",    #FUN-A10098   #FUN-A70084
                    "   AND NOT EXISTS(SELECT 1 FROM ",cl_get_target_table(m_plant[l_i],'rvu_file')," WHERE rvu01 = tlf905 AND rvu00 = '3' AND RVU08 = 'SUB' ) "  #CHI-D30019
       WHEN '2'    #委外工單
#CHI-D30019---begin
#        #FUN-BB0063(S)
#        IF tm.costdown ='Y' THEN
##          LET l_costdown =" OR tlf13 = 'apmt1072' "        #FUN-D20078 mark
#           LET l_costdown =" OR (tlf13 = 'asft6201' OR tlf13 = 'apmt230') "   #FUN-D20078 add
#        ELSE
#           LET l_costdown =''
#        END IF
#        #FUN-BB0063(E)
#CHI-D30019---end
#       LET l_sql = "SELECT '',ima12,ima01,ima02,tlfccost,",              #FUN-7C0101 ADD tlfccost ##TQC-D90023 mark
        LET l_sql = "SELECT '',ima12,ima01,ima02,ima021,tlfccost,",       #TQC-D90023 add
                          " tlf021,tlf031,tlf06,tlf026,tlf027,tlf036,tlf037,",
                          " tlf01,tlf10*tlf60,tlfc21,tlf13,tlf65,tlf19,tlf905,tlf906,tlf907,0,ima57,ima08", #No.9451  #FUN-7C0101 tlf21-->tlfc21 #	FUN-8B0026 Add ,ima57,ima08 
                   #"  FROM ",l_dbs CLIPPED,"tlf_file ",
                   #"  LEFT OUTER JOIN ",l_dbs CLIPPED,"tlfc_file ",
                    "  FROM ",cl_get_target_table(m_plant[l_i],'tlf_file'),
                    "  LEFT OUTER JOIN ",cl_get_target_table(m_plant[l_i],'tlfc_file'),   #FUN-A10098   #FUN-A70084 m_dbs-->m_plant
                    "    ON tlfc01 = tlf01  AND tlfc02 = tlf02  AND ",  #FUN-A10098
                    "       tlfc03 = tlf03  AND tlfc06 = tlf06  AND ",
                    "       tlfc13 = tlf13  AND ",  #FUN-9B0009  add
                    "       tlfc902= tlf902 AND tlfc903= tlf903 AND ",
                    "       tlfc904= tlf904 AND tlfc905= tlf905 AND ",
                    "       tlfc906= tlf906 AND tlfc907= tlf907 AND ",
                    "       tlfctype =  '",tm.type1,"'",
                   #"      ,",l_dbs CLIPPED,"ima_file,",l_dbs CLIPPED,"sfb_file ",   #FUN-A10098
                   #"      ,",cl_get_target_table(m_dbs[l_i],'ima_file'),",",
                   #          cl_get_target_table(m_dbs[l_i],'sfb_file'),   #FUN-A10098
                    "      ,",cl_get_target_table(m_plant[l_i],'ima_file'),",",
                              cl_get_target_table(m_plant[l_i],'sfb_file'),   #FUN-A10098   #FUN-A70084
                    " WHERE ima01 = tlf01",
                    "   AND sfb01 = tlf62",
                    "   AND (sfb02 = 7 OR sfb02 = 8) ",  #No:9584
                    #"   AND (tlf13 = 'asft6201' OR tlf13 = 'asft6101' OR tlf13 = 'asft6231'",l_costdown,") ",  #MOD-740381 add  tlf13='asft6231'  #FUN-BB0063  #CHI-D30019
                    "   AND (tlf13 = 'asft6201' OR tlf13 = 'asft6101' OR tlf13 = 'asft6231') ",  #CHI-D30019
                    "   AND ",tm.wc CLIPPED,
                    "   AND (tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')",
                   #"   AND tlf902 NOT IN (SELECT jce02 FROM ",l_dbs CLIPPED,"jce_file)" #JIT除外   #FUN-8B0026 Add ",l_dbs CLIPPED,"  #FUN-A10098
                   #"   AND tlf902 NOT IN (SELECT jce02 FROM ",cl_get_target_table(m_dbs[l_i],'jce_file'),")" #FUN-A10098  	 #FUN-A70084
                    "   AND tlf902 NOT IN (SELECT jce02 FROM ",cl_get_target_table(m_plant[l_i],'jce_file'),")", #FUN-A10098   #FUN-A70084  
                  #," ORDER BY tlf01,tlf036,tlf037,tlf026,tlf027"   #FUN-C50009  #TQC-C60021 mark
                    "   AND NOT EXISTS(SELECT 1 FROM ",cl_get_target_table(m_plant[l_i],'rvu_file')," WHERE rvu01 = tlf905 AND rvu00 = '3' AND RVU08 = 'SUB' ) "  #CHI-D30019
        #str TQC-C60021 add
        #ICD行業別時,要抓入非成本倉的資料出來,只是數量顯示0
         IF s_industry('icd') THEN
            LET l_sql = l_sql CLIPPED," UNION ",
#                       "SELECT '',ima12,ima01,ima02,tlfccost,",  ##TQC-D90023 mark
                        "SELECT '',ima12,ima01,ima02,ima021,tlfccost,",  #TQC-D90023 add
                        "       tlf021,tlf031,tlf06,tlf026,tlf027,tlf036,tlf037,",
                        "       tlf01,0,tlfc21,tlf13,tlf65,tlf19,tlf905,tlf906,tlf907,0,ima57,ima08",
                        "  FROM ",cl_get_target_table(m_plant[l_i],'tlf_file'),
                        "  LEFT OUTER JOIN ",cl_get_target_table(m_plant[l_i],'tlfc_file'),
                        "    ON tlfc01 = tlf01  AND tlfc02 = tlf02  AND ",
                        "       tlfc03 = tlf03  AND tlfc06 = tlf06  AND ",
                        "       tlfc13 = tlf13  AND ",
                        "       tlfc902= tlf902 AND tlfc903= tlf903 AND ",
                        "       tlfc904= tlf904 AND tlfc905= tlf905 AND ",
                        "       tlfc906= tlf906 AND tlfc907= tlf907 AND ",
                        "       tlfctype =  '",tm.type1,"'",
                        "      ,",cl_get_target_table(m_plant[l_i],'ima_file'),",",
                                  cl_get_target_table(m_plant[l_i],'sfb_file'),
                        " WHERE ima01 = tlf01",
                        "   AND sfb01 = tlf62",
                        "   AND (sfb02 = 7 OR sfb02 = 8) ",
                        #"   AND (tlf13 = 'asft6201' OR tlf13 = 'asft6101' OR tlf13 = 'asft6231'",l_costdown,") ",  #CHI-D30019
                        "   AND (tlf13 = 'asft6201' OR tlf13 = 'asft6101' OR tlf13 = 'asft6231') ",  #CHI-D30019
                        "   AND ",tm.wc CLIPPED,
                        "   AND (tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')",
                        "   AND tlf902 IN (SELECT jce02 FROM ",cl_get_target_table(m_plant[l_i],'jce_file'),")",
                        "   AND NOT EXISTS(SELECT 1 FROM ",cl_get_target_table(m_plant[l_i],'rvu_file')," WHERE rvu01 = tlf905 AND rvu00 = '3' AND RVU08 = 'SUB' ) "  #CHI-D30019
         END IF
        #end TQC-C60021 add
       WHEN '3'   #非委外工單但製程有委外,不用輸入倉庫,所以不考慮倉庫
        LET tm.wc = cl_replace_str(tm.wc,'tlf19','rvu04')   #MOD-980199
#CHI-D30019---begin
#        #FUN-BB0063(S)
#        IF tm.costdown ='Y' THEN
#           LET l_costdown =" OR rvu00='3' "
#        ELSE
#           LET l_costdown =''
#        END IF
#        #FUN-BB0063(E)
#CHI-D30019---end
        #No.TQC-A40139  --Begin
#       LET l_sql = "SELECT rvu00,ima12,ima01,ima02,tlfccost,",          #FUN-7C0101 ADD tlfccost
#       LET l_sql = "SELECT rvu00,ima12,ima01,ima02,'',",                #TQC-D90023 mark
        LET l_sql = "SELECT rvu00,ima12,ima01,ima02,ima021,'',",         #TQC-D90023 add
        #No.TQC-A40139  --End  
                   #" '','',rvu03,rvu01,'',rvu01,rvv02,", #FUN-BB0063 mark
                    " '','',rvu03,rvu01,rvv02,rvu01,rvv02,", #FUN-BB0063 add
                    #倉庫,倉庫,單據日,來源異動單號,異動項次,目的異動單號,異動項次   #項次不考慮,因為一張入庫一個ap
                    " rvv31,rvv87,0,'','',rvu04,rvv01,rvv02,1,0,ima57,ima08", #只會有入不會有出   #FUN-8B0026 Add ,ima57,ima08
                    #異動料件編號,異動數量,成會異動成本,異動命令代號,傳票編號,異動廠商�客戶編號/部門編號,單號,項次,入出庫碼
                  # "  FROM ",l_dbs CLIPPED,"rvu_file,",
                  #           l_dbs CLIPPED,"rvv_file,",
                  #           l_dbs CLIPPED,"ima_file,",
                  #           l_dbs CLIPPED,"sfb_file,",
                  #           l_dbs CLIPPED,"tlf_file LEFT OUTER JOIN ",l_dbs CLIPPED,"tlfc_file ",    #FUN-9B0009  #FUN-A10098
        #No.TQC-A40139  --Begin
                   #"  FROM ",cl_get_target_table(m_dbs[l_i],'rvu_file'),",",cl_get_target_table(m_dbs[l_i],'rvv_file'),",",cl_get_target_table(m_dbs[l_i],'ima_file'),",",   #FUN-A10098
                   #          cl_get_target_table(m_dbs[l_i],'sfb_file'),",",cl_get_target_table(m_dbs[l_i],'tlf_file')," LEFT OUTER JOIN ",cl_get_target_table(m_dbs[l_i],'tlf_file'),    #FUN-A10098
                   #FUN-A70084--mod--str--m_dbs-->m_plant
                   #"  FROM ",cl_get_target_table(m_dbs[l_i],'rvu_file'),",",cl_get_target_table(m_dbs[l_i],'rvv_file'),",",cl_get_target_table(m_dbs[l_i],'ima_file'),",",   #FUN-A10098
                   #          cl_get_target_table(m_dbs[l_i],'sfb_file'),
                    "  FROM ",cl_get_target_table(m_plant[l_i],'rvu_file'),",",
                              cl_get_target_table(m_plant[l_i],'rvv_file'),",",
                              cl_get_target_table(m_plant[l_i],'ima_file'),",",   #FUN-A10098
                              cl_get_target_table(m_plant[l_i],'sfb_file'),
#FUN-A70084--mod--end
#                   "    ON tlfc01 = tlf01  AND  tlfc02 = tlf02",  
#                   "   AND tlfc03 = tlf03  AND  tlfc06 = tlf06", 
#                   "   AND tlfc13 = tlf13", 
#                   "   AND tlfc902= tlf902 AND  tlfc903= tlf903",
#                   "   AND tlfc904= tlf904 AND  tlfc905= tlf905",
#                   "   AND tlfc906= tlf906 AND  tlfc907= tlf907",
#                   "   AND tlfctype  =  '",tm.type1,"'",                
        #No.TQC-A40139  --End  
                    " WHERE rvu01 = rvv01  ",
                    "   AND rvu08='SUB' ",
                    "   AND ima01 = rvv31 ",
                    "   AND rvv18 = sfb01 ",
                    "   AND sfb02 not in('7','8') ",
                    #"   AND (rvu00='1'",l_costdown," )", #FUN-BB0063  #CHI-D30019
                    "   AND rvu00='1' ",  #CHI-D30019
                    "   AND ",tm.wc CLIPPED,
                    "   AND rvuconf = 'Y' ",
                    "   AND (rvu03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')"                                   #FUN-9B0009 dele ','
        LET tm.wc = cl_replace_str(tm.wc,'rvu04','tlf19')   #MOD-980199
     END CASE
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
    #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098  #FUN-A70084 
    #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A10098  #TQC-BB0182 mark 
     PREPARE axcr700_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE axcr700_curs1 CURSOR FOR axcr700_prepare1
    #str TQC-C60021 mark
    ##FUN-C50009---begin
    #  IF s_industry('icd') AND tm.type='2' THEN
    #     #抓取委外工單入非成本倉的tlf資料
    #     LET l_sql = "SELECT tlf036,tlf037,tlf026,tlf027,tlf01 ",
    #                 "  FROM ",cl_get_target_table(m_plant[l_i],'tlf_file'),
    #                 "  LEFT OUTER JOIN ",cl_get_target_table(m_plant[l_i],'tlfc_file'),
    #                 "    ON tlfc01 = tlf01  AND tlfc02 = tlf02  AND ",
    #                 "       tlfc03 = tlf03  AND tlfc06 = tlf06  AND ",
    #                 "       tlfc13 = tlf13  AND ",
    #                 "       tlfc902= tlf902 AND tlfc903= tlf903 AND ",
    #                 "       tlfc904= tlf904 AND tlfc905= tlf905 AND ",
    #                 "       tlfc906= tlf906 AND tlfc907= tlf907 AND ",
    #                 "       tlfctype =  '",tm.type1,"'",
    #                 "      ,",cl_get_target_table(m_plant[l_i],'ima_file'),",",
    #                           cl_get_target_table(m_plant[l_i],'sfb_file'),
    #                 " WHERE ima01 = tlf01",
    #                 "   AND sfb01 = tlf62",
    #                 "   AND (sfb02 = 7 OR sfb02 = 8) ",
    #                 "   AND (tlf13 = 'asft6201' OR tlf13 = 'asft6101' OR tlf13 = 'asft6231'",l_costdown,") ",
    #                 "   AND ",tm.wc CLIPPED,
    #                 "   AND (tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')",
    #                 "   AND tlf902 IN (SELECT jce02 FROM ",cl_get_target_table(m_plant[l_i],'jce_file'),")",
    #                 "  INTO TEMP axcr700_temp WITH NO LOG "
    #     PREPARE r700_tmp_prep FROM l_sql
    #     IF STATUS THEN
    #        CALL cl_err('r700_tmp_prep:',STATUS,1)      
    #     END IF
    #     EXECUTE r700_tmp_prep
    #
    #     #抓取委外入庫單入非成本倉單號
    #     LET l_sql = "SELECT * FROM axcr700_temp WHERE tlf036=? AND tlf01=?"
    #     CALL cl_replace_sqldb(l_sql) RETURNING l_sql             
    #     PREPARE r700_p0_1 FROM l_sql
    #     DECLARE r700_c0_1 CURSOR FOR r700_p0_1
    #
    #     #抓取委外倉退單入非成本倉單號
    #     LET l_sql = "SELECT * FROM axcr700_temp WHERE tlf026=? AND tlf01=?"
    #     CALL cl_replace_sqldb(l_sql) RETURNING l_sql              
    #     PREPARE r700_p0_2 FROM l_sql
    #     DECLARE r700_c0_2 CURSOR FOR r700_p0_2
    #
    #     #抓取委外入庫單入非成本倉的AP金額(應付金額 或 暫估應付金額)
    #     LET l_sql = "SELECT SUM(apb101) ",
    #                 "  FROM ",cl_get_target_table(m_plant[l_i],'apb_file'),",",
    #                           cl_get_target_table(m_plant[l_i],'apa_file'),
    #                 " WHERE apa01 = apb01 AND apa42 = 'N'",
    #                 "   AND apb29='1' AND apb21=? AND apb22=? AND apb12=?",
    #                 "   AND (apa00 ='11' OR apa00 = '16') ",
    #                 "   AND apb34 <> 'Y'",
    #                 "   AND apa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' "
    #     CALL cl_replace_sqldb(l_sql) RETURNING l_sql              
    #     PREPARE apb_prepare3_1 FROM l_sql
    #     DECLARE apb_c3_1 CURSOR FOR apb_prepare3_1
    #
    #     #抓取委外入庫單入非成本倉的AP金額(暫估應付金額)
    #     LET l_sql = "SELECT SUM(apb101) ",
    #                 "  FROM ",cl_get_target_table(m_plant[l_i],'apb_file'),",",
    #                           cl_get_target_table(m_plant[l_i],'apa_file'),
    #                 " WHERE apa01 = apb01 AND apa42 = 'N'",
    #                 "   AND apb29='1' AND apb21=? AND apb22=? AND apb12=?",
    #                 "   AND apa00 ='16' ",
    #                 "   AND apb34 <> 'Y'",
    #                 "   AND apa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' "
    #     CALL cl_replace_sqldb(l_sql) RETURNING l_sql              
    #     PREPARE apb_prepare2_1 FROM l_sql
    #     DECLARE apb_c2_1 CURSOR FOR apb_prepare2_1
    #
    #     #抓取委外倉退單入非成本倉的AP金額(應付折讓金額)
    #     LET l_sql = "SELECT SUM(apb101) ",
    #                 "  FROM ",cl_get_target_table(m_plant[l_i],'apb_file'),",",
    #                           cl_get_target_table(m_plant[l_i],'apa_file'),
    #                 " WHERE apa01 = apb01 AND apa42 = 'N'",
    #                 "   AND apb29='3' AND apb21=? AND apb22=? AND apb12=?",
    #                 "   AND apa00 ='21' ",
    #                 "   AND (apa58 ='2' OR apa58 = '3') ",   
    #                 "   AND apb34 <> 'Y'",
    #                 "   AND apa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' "
    #     CALL cl_replace_sqldb(l_sql) RETURNING l_sql              
    #     PREPARE apb_prepare1_1 FROM l_sql
    #     DECLARE apb_c1_1 CURSOR FOR apb_prepare1_1
    #
    #     #抓取委外倉退單入非成本倉的AP金額(應付帳款裡的折讓金額 或 暫估應付折讓金額)
    #     LET l_sql = "SELECT SUM(ABS(apb101)) ",
    #                 "  FROM ",cl_get_target_table(m_plant[l_i],'apb_file'),",",
    #                           cl_get_target_table(m_plant[l_i],'apa_file'),
    #                 " WHERE apa01 = apb01 AND apa42 = 'N'",
    #                 "   AND apb29='3' AND apb21=? AND apb22=? AND apb12=?",
    #                 "   AND (apa00 ='11' OR apa00 = '26') ",
    #                 "   AND apb34 <> 'Y'",
    #                 "   AND apa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' "
    #     CALL cl_replace_sqldb(l_sql) RETURNING l_sql              
    #     PREPARE apb_prepare4_1 FROM l_sql
    #     DECLARE apb_c4_1  CURSOR FOR apb_prepare4_1
    #
    #     #抓取委外倉退單入非成本倉的AP金額(暫估應付折讓金額)
    #     LET l_sql = "SELECT SUM(apb101) ",
    #                 "  FROM ",cl_get_target_table(m_plant[l_i],'apb_file'),",",
    #                           cl_get_target_table(m_plant[l_i],'apa_file'),
    #                 " WHERE apa01 = apb01 AND apa42 = 'N'",
    #                 "   AND apb29='3' AND apb21=? AND apb22=? AND apb12=?",
    #                 "   AND apa00 ='26' ",
    #                 "   AND (apa58 ='2' OR apa58 = '3') ",   
    #                 "   AND apb34 <> 'Y'",
    #                 "   AND apa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' "
    #     CALL cl_replace_sqldb(l_sql) RETURNING l_sql             
    #     PREPARE apb_prepare5_1 FROM l_sql
    #     DECLARE apb_c5_1  CURSOR FOR apb_prepare5_1
    #  END IF
    ##FUN-C50009---end
    #end TQC-C60021 mark
     
     LET g_pageno = 0
    #LET o_tlf036 = ' '   #FUN-C50009 add   #TQC-C60021 mark
    #LET o_tlf026 = ' '   #FUN-C50009 add   #TQC-C60021 mark
    #LET o_tlf01  = ' '   #FUN-C50009 add   #TQC-C60021 mark

     CALL r700_def_cur(l_i) #CHI-C30055 add
#CHI-C30055----------------str-------------------------     
     FOREACH axcr700_curs1 INTO sr.*,l_ima57,l_ima08                         #FUN-8B0026 Add ,l_ima57,l_ima08
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET x_flag = 'N'    #No:MOD-B10175 add
 
       LET l_slip = s_get_doc_no(sr.tlf905)
       SELECT smydmy1 INTO l_smydmy1 FROM smy_file
        WHERE smyslip = l_slip
       IF l_smydmy1 = 'N' OR cl_null(l_smydmy1) THEN
          CONTINUE FOREACH
       END IF
 
       IF tm.type = '3' THEN
          IF sr.code = '1' THEN 
             LET sr.tlf13 = 'asft6201'
          ELSE
             #CHI-D30019---begin
             ##FUN-BB0063(S)
             #IF sr.code = '3' THEN
             #   LET sr.tlf13 = 'apmt1072'
             #ELSE
             ##FUN-BB0063(E)
             #CHI-D30019---end
                LET sr.tlf13 = 'asft6101'
             #END IF  #CHI-D30019
          END IF
       END IF 
#MOD-C20081 str mark-----          
#         LET l_sql = "SELECT rvu08 ",                                                                              
##FUN-A10098---BEGIN
##                      "  FROM ",l_dbs CLIPPED,"rvu_file,",                                                                          
##                                l_dbs CLIPPED,"rvv_file ",
#                     #FUN-A70084--mod--str--
#                     #"  FROM ",cl_get_target_table(m_dbs[l_i],'rvu_file'),",",
#                     #          cl_get_target_table(m_dbs[l_i],'rvv_file'),
#                      "  FROM ",cl_get_target_table(m_plant[l_i],'rvu_file'),",",
#                                cl_get_target_table(m_plant[l_i],'rvv_file'),
#                     #FUN-A70084--mod--end
##FUN-A10098---END
#                     " WHERE rvv01='",sr.tlf905,"'",
#                     "   AND rvv02='",sr.tlf906,"'",
#                     "   AND rvu01 = rvv01 ",
#                     "   AND rvuconf !='X'"   
#         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#        #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098    #FUN-A70084                                                                                                                                                                              
#        #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
#         PREPARE rvu_prepare3 FROM l_sql                                                                                          
#         DECLARE rvu_c3  CURSOR FOR rvu_prepare3                                                                                 
#         OPEN rvu_c3                                                                                    
#         FETCH rvu_c3 INTO l_rvu08
#MOD-C20081 end mark-----          
 
       LET sr.code=' '
       #-->採購入庫(內外購)
       IF sr.tlf13 = 'apmt150' OR sr.tlf13='asft6201' OR sr.tlf13='asft6231' #MOD-740381 add  tlf13='asft6231'
          or sr.tlf13 = 'apmt230' THEN    #No.4681 add 
 
         #IF cl_null(sr.tlf65) OR sr.tlf65 = ' ' THEN                        #MOD-A40046 mark
          IF cl_null(sr.tlf65) OR sr.tlf65 = ' ' OR sr.tlf65 = 'UNAP' THEN   #MOD-A40046 

#            LET l_sql = "SELECT apa44 ",                                                                              
#FUN-A10098---BEGIN
#                        "  FROM ",l_dbs CLIPPED,"apb_file,",                                                                          
#                                  l_dbs CLIPPED,"apa_file ",
#                       #FUN-A70084--mod--str--
#                       #"  FROM ",cl_get_target_table(m_dbs[l_i],'apb_file'),",",
#                       #          cl_get_target_table(m_dbs[l_i],'apa_file'),
#                        "  FROM ",cl_get_target_table(m_plant[l_i],'apb_file'),",",
#                                  cl_get_target_table(m_plant[l_i],'apa_file'),
#                       #FUN-A70084--mod--end
#FUN-A10098---END
#                        " WHERE apb21='",sr.tlf036,"'",
#                        "   AND apb22='",sr.tlf037,"'",
#                        "   AND apb01=apa01 ",
#                        "   AND apa42 = 'N' ",
#                        "   AND apb34 <> 'Y'"
#                        ,"  AND apb29 = '1'"   #MOD-B80092 add
#            CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#           #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098  #FUN-A70084                                                                                                                                                                                 
#           #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
#            PREPARE apa_prepare3 FROM l_sql                                                                                          
#            DECLARE apa_c3  CURSOR FOR apa_prepare3                                                                                 
             OPEN apa_c3 USING sr.tlf036,sr.tlf037                                                                                    
             FETCH apa_c3 INTO sr.tlf65
          END IF
          IF cl_null(sr.tlf65) THEN LET sr.tlf65 = 'UNAP' END IF
                    
#         LET l_sql = "SELECT SUM(apb101) ",                       
#FUN-A10098---BEGIN                                                       
#                     "  FROM ",l_dbs CLIPPED,"apb_file,",                                                                          
#                               l_dbs CLIPPED,"apa_file ",
#                    #FUN-A70084--mod--str--
#                    #"  FROM ",cl_get_target_table(m_dbs[l_i],'apb_file'),",",
#                    #          cl_get_target_table(m_dbs[l_i],'apa_file'),
#                     "  FROM ",cl_get_target_table(m_plant[l_i],'apb_file'),",",
#                               cl_get_target_table(m_plant[l_i],'apa_file'),
#                    #FUN-A70084--mod--end
#FUN-A10098---END
#                     " WHERE apa01 = apb01 AND apa42 = 'N'",
#                     "   AND apb29='1' AND  apb21='",sr.tlf036,"'",
#                     "   AND apb22='",sr.tlf037,"' AND apb12='",sr.tlf01,"' ",
#                     "   AND (apa00 ='11' OR apa00 = '16') ",
#                     "   AND apb34 <> 'Y'",
#                     "   AND apa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' "       
#         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#        #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098   #FUN-A70084                                                                                                                                                                           
#        #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark 
#         PREPARE apb_prepare3 FROM l_sql                                                                                          
#         DECLARE apb_c3  CURSOR FOR apb_prepare3                                                                                 
          OPEN apb_c3 USING sr.tlf036,sr.tlf037,sr.tlf01,tm.bdate,tm.edate                                                                                   
          FETCH apb_c3 INTO sr.amt01
          IF cl_null(sr.amt01) THEN LET x_flag = 'N' ELSE LET x_flag = 'Y' END IF   #MOD-A40087 add
         #str TQC-C60021 mark
         ##FUN-C50009---begin
         ##抓取委外入庫單入非成本倉的AP金額
         #IF s_industry('icd') AND tm.type='2' AND x_flag='Y' THEN
         #   INITIALIZE sr1.* TO NULL
         #   IF sr.tlf036 != o_tlf036 OR sr.tlf01 != o_tlf01 THEN
         #      FOREACH r700_c0_1 USING sr.tlf036,sr.tlf01 INTO sr1.*
         #         OPEN apb_c3_1 USING sr1.tlf036,sr1.tlf037,sr1.tlf01
         #         FETCH apb_c3_1 INTO l_amt01
         #         IF cl_null(l_amt01) THEN LET l_amt01=0 END IF
         #         LET sr.amt01=sr.amt01+l_amt01
         #
         #         LET o_tlf036 = sr1.tlf036  #記錄舊值
         #         LET o_tlf01  = sr1.tlf01   #記錄舊值
         #      END FOREACH
         #   END IF
         #END IF
         #end TQC-C60021 mark
         ##FUN-C50009---end
         #IF sr.amt01 IS NULL THEN LET sr.amt01 = 0 END IF # MOD-580114    #No:MOD-B10175 mark
         #IF  sr.amt01 = 0 THEN    #MOD-580114 add  #MOD-A40087 mark
          IF x_flag = 'N' THEN                      #MOD-A40087
#            LET l_sql = "SELECT ale09 ",                                                                              
#                         "  FROM ",l_dbs CLIPPED,"ale_file ",    #FUN-A10098                                                                      
#                       #"  FROM ",cl_get_target_table(m_dbs[l_i],'ale_file'),  #FUN-A10098    #FUN-A70084                                                                  
#                        "  FROM ",cl_get_target_table(m_plant[l_i],'ale_file'),  #FUN-A10098    #FUN-A70084                                                                  
#                        " WHERE ale16='",sr.tlf036,"'",
#                        "   AND ale17='",sr.tlf037,"'",
#                        "   AND ale11='",sr.tlf01,"'" 
#            CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#           #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098      #FUN-A70084                                                                                                                                                                          
#           #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark 
#            PREPARE ale_prepare3 FROM l_sql                                                                                          
#            DECLARE ale_c3  CURSOR FOR ale_prepare3                                                                                 
             OPEN ale_c3 USING sr.tlf036,sr.tlf037,sr.tlf01                                                                                    
             FETCH ale_c3 INTO sr.amt01
             IF cl_null(sr.amt01) THEN LET x_flag = 'N' ELSE LET x_flag = 'Y' END IF   #MOD-A40087 add
                    
            #IF sr.amt01 IS NULL THEN LET sr.amt01 = 0 END IF  #No:MOD-860019 add  #No:MOD-B10175 mark
            #IF  sr.amt01 = 0 THEN  #MOD-580114 add  #MOD-A40087 mark
             IF x_flag = 'N' THEN                    #MOD-A40087
                LET sr.code='*'
                #取暫估金額且當作未請款資料
 
#               LET l_sql = "SELECT SUM(apb101) ",                                                                              
#FUN-A10098---BEGIN
#                           "  FROM ",l_dbs CLIPPED,"apb_file,",                                                                          
#                                     l_dbs CLIPPED,"apa_file ",
#                          #FUN-A70084--mod--str--
#                          #"  FROM ",cl_get_target_table(m_dbs[l_i],'apb_file'),",",
#                          #          cl_get_target_table(m_dbs[l_i],'apa_file'),
#                           "  FROM ",cl_get_target_table(m_plant[l_i],'apb_file'),",",
#                                     cl_get_target_table(m_plant[l_i],'apa_file'),
#                          #FUN-A70084--mod--end
#FUN-A10098---END
#                           " WHERE apa01 = apb01 AND apa42 = 'N'",
#                           "   AND apb29='1' AND  apb21='",sr.tlf036,"'",
#                           "   AND apb22='",sr.tlf037,"' AND apb12='",sr.tlf01,"' ",
#                           "   AND apa00 ='16' ",
#                           "   AND apb34 <> 'Y'",
#                           "   AND apa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' "       
#               CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#              #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098  #FUN-A70084                                                                                                                                                                           
#              #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
#               PREPARE apb_prepare2 FROM l_sql                                                                                          
#               DECLARE apb_c2  CURSOR FOR apb_prepare2                                                                                 
                OPEN apb_c2 USING sr.tlf036,sr.tlf037,sr.tlf01,tm.bdate,tm.edate                                                                                    
                FETCH apb_c2 INTO sr.amt01
                IF cl_null(sr.amt01) THEN LET x_flag = 'N' ELSE LET x_flag = 'Y' END IF   #MOD-A40087 add
               #str TQC-C60021 mark
               ##FUN-C50009---begin
               ##抓取委外入庫單入非成本倉的AP金額
               #IF s_industry('icd') AND tm.type='2' AND x_flag='Y' THEN
               #   INITIALIZE sr1.* TO NULL
               #   IF sr.tlf036 != o_tlf036 OR sr.tlf01 != o_tlf01 THEN
               #      FOREACH r700_c0_1 USING sr.tlf036,sr.tlf01 INTO sr1.*
               #         OPEN apb_c2_1 USING sr1.tlf036,sr1.tlf037,sr1.tlf01
               #         FETCH apb_c2_1 INTO l_amt01
               #         IF cl_null(l_amt01) THEN LET l_amt01=0 END IF
               #         LET sr.amt01=sr.amt01+l_amt01
               #
               #         LET o_tlf036 = sr1.tlf036  #記錄舊值
               #         LET o_tlf01  = sr1.tlf01   #記錄舊值
               #      END FOREACH
               #   END IF
               #END IF
               ##FUN-C50009---end
               #end TQC-C60021 mark
                               
               #IF sr.amt01 IS NULL THEN LET sr.amt01 = 0 END IF   #No:MOD-B10175 mark
                #-->取採購單價
               #IF sr.amt01 = 0 THEN  #No:MOD-860019 add  #MOD-A40087 mark
                IF x_flag = 'N' THEN                      #MOD-A40087
#                  LET l_sql = "SELECT rvv04,rvv05,rvv39 ",                                                                              
#               #               "  FROM ",l_dbs CLIPPED,"rvv_file ", #FUN-A10098                                                                         
#                             #"  FROM ",cl_get_target_table(m_dbs[l_i],'rvv_file'),#FUN-A10098   #FUN-A70084                                                                      
#                              "  FROM ",cl_get_target_table(m_plant[l_i],'rvv_file'),#FUN-A70084
#                              " WHERE rvv01='",sr.tlf036,"'",
#                              "   AND rvv02='",sr.tlf037,"'",
#                              "   AND rvv25<>'Y'"
#                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#                 #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098 #FUN-A70084                                                                                                                                                                                
#                 #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
#                  PREPARE rvv_prepare3 FROM l_sql                                                                                          
#                  DECLARE rvv_c3  CURSOR FOR rvv_prepare3                                                                                 
                   OPEN rvv_c3 USING sr.tlf036,sr.tlf037                                                                                    
                   FETCH rvv_c3 INTO l_rvv04,l_rvv05,l_rvv39
                   IF STATUS = 0 THEN
                      SELECT rva00 INTO l_rva00 FROM rva_file WHERE rva01=l_rvv04   #MOD-C20103 add
                     #IF l_rva00 <> '2' THEN                                        #MOD-C20103 add 
                     #  LET l_sql = "SELECT pmm22,rva06,pmm42 ",                                                                              
#FUN-A10098---BEGIN
#                    #               "  FROM ",l_dbs CLIPPED,"rvb_file,",
#                    #                         l_dbs CLIPPED,"pmm_file,",                                                                           
#                    #                         l_dbs CLIPPED,"rva_file ",
                     #             #FUN-A70084--mod--str--m_dbs-->m_plant
                     #             #"  FROM ",cl_get_target_table(m_dbs[l_i],'rvb_file'),",",
                     #             #          cl_get_target_table(m_dbs[l_i],'pmm_file'),",",
                     #             #          cl_get_target_table(m_dbs[l_i],'rva_file'),
                     #              "  FROM ",cl_get_target_table(m_plant[l_i],'rvb_file'),",",
                     #                        cl_get_target_table(m_plant[l_i],'pmm_file'),",",
                     #                        cl_get_target_table(m_plant[l_i],'rva_file'),
                     #             #FUN-A70084--mod--end
#FUN-A10098---END
                     #              " WHERE rvb01='",l_rvv04,"' AND rvb02='",l_rvv05,"'",
                     #              "   AND pmm01=rvb04 AND rva01 = rvb01",
                     #              "   AND rvaconf <> 'X'  AND pmm18 <> 'X' "     
                     ##MOD-C20103 str  add------
                     #ELSE
                     #  LET l_sql = "SELECT rva113,rva06,rva114 ",
                     #              "  FROM ",cl_get_target_table(m_plant[l_i],'rvb_file'),",",
                     #                        cl_get_target_table(m_plant[l_i],'rva_file'),
                     #              " WHERE rvb01='",l_rvv04,"' AND rvb02='",l_rvv05,"'",
                     #              "   AND rva01 = rvb01   AND rvaconf <> 'X'  "
                     #END IF
                     ##MOD-C20103 end  add------
                     #CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
                     #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098   #FUN-A70084                                                                                                                                                                           
                     #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
                     #PREPARE pmm_prepare2 FROM l_sql                                                                                          
                     #DECLARE pmm_c2  CURSOR FOR pmm_prepare2                                                                                 
                     #str TQC-C60021 add
                      IF l_rva00 <> '2' THEN
                         OPEN pmm_c2_0 USING l_rvv04,l_rvv05
                         FETCH pmm_c2_0 INTO l_pmm22,l_rva06,l_pmm42
                      ELSE
                     #end TQC-C60021 add
                        #OPEN pmm_c2 USING l_rvv04,l_rvv05,l_rvv04,l_rvv05   #TQC-C60021 mark
                         OPEN pmm_c2 USING l_rvv04,l_rvv05                   #TQC-C60021
                         FETCH pmm_c2 INTO l_pmm22,l_rva06,l_pmm42
                      END IF   #TQC-C60021 add
                                                                                       
                      IF STATUS <> 0 THEN
                         LET l_pmm22=' '
                         LET l_pmm42= 1
                      END IF
                      IF l_pmm42 IS NULL THEN LET l_pmm42=1 END IF
                      LET sr.amt01=l_rvv39*l_pmm42
                   END IF
                END IF             #No.MOD-860019 add
             END IF
          END IF
          IF sr.amt01 IS NULL THEN LET sr.amt01 = 0 END IF   #No:MOD-B10175 add
       END IF
       #-->倉庫退貨
       IF sr.tlf13 = 'apmt1072' or sr.tlf13 = 'asft6101' THEN
           IF cl_null(sr.tlf65) OR sr.tlf65 = ' ' THEN
 
#             LET l_sql = "SELECT apa44 ",                                                                              
#FUN-A10098---BEGIN
#                          "  FROM ",l_dbs CLIPPED,"apb_file,",                                                                          
#                                    l_dbs CLIPPED,"apa_file ",
#                        #FUN-A770084--mod--str--m_dbs-->m_plant
#                        #"  FROM ",cl_get_target_table(m_dbs[l_i],'apb_file'),",",
#                        #          cl_get_target_table(m_dbs[l_i],'apa_file'),
#                         "  FROM ",cl_get_target_table(m_plant[l_i],'apb_file'),",",
#                                   cl_get_target_table(m_plant[l_i],'apa_file'),
#                        #FUN-A70084--mod--end
#FUN-A10098---END
#                         " WHERE apb21='",sr.tlf026,"' AND apb22='",sr.tlf027,"'",
#                         "   AND apb01=apa01",
#                         "   AND apa42 = 'N'  AND apb34 <> 'Y' "
#            CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#           #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098    #FUN-A70084                                                                                                                                                                                  
#           #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
#            PREPARE apa_prepare2 FROM l_sql                                                                                          
#            DECLARE apa_c2  CURSOR FOR apa_prepare2                                                                                 
             OPEN apa_c2 USING sr.tlf026,sr.tlf027                                                                                    
             FETCH apa_c2 INTO sr.tlf65
                             
           END IF
           IF cl_null(sr.tlf65) THEN LET sr.tlf65 = 'UNAP' END IF
 
#          LET l_sql = "SELECT SUM(apb101) ",                                                                              
#FUN-A10098---BEGIN
#                      "  FROM ",l_dbs CLIPPED,"apb_file,",                                                                          
#                                l_dbs CLIPPED,"apa_file ",
#                     #FUN-A70084--mod--str--m_dbs-->m_plant
#                     #"  FROM ",cl_get_target_table(m_dbs[l_i],'apb_file'),",",
#                     #          cl_get_target_table(m_dbs[l_i],'apa_file'),
#                      "  FROM ",cl_get_target_table(m_plant[l_i],'apb_file'),",",
#                                cl_get_target_table(m_plant[l_i],'apa_file'),
#                     #FUN-A70084--mod--end
#FUN-A10098---END
#                      " WHERE apa01 = apb01 AND apa42 = 'N'",
#                      "   AND apb29='3' AND  apb21='",sr.tlf026,"'",
#                      "   AND apb22='",sr.tlf027,"' AND apb12='",sr.tlf01,"' ",
#                      "   AND apa00 ='21' ",
#                      "   AND (apa58 ='2' OR apa58 = '3') ",   #No.CHI-910019 add 
#                      "   AND apb34 <> 'Y'",
#                      "   AND apa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' "
#          CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#         #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098                                                                                                                                                                                   
#         #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A10098    #FUN-A70084    #TQC-BB0182 mark 
#          PREPARE apb_prepare1 FROM l_sql                                                                                          
#          DECLARE apb_c1  CURSOR FOR apb_prepare1                                                                                 
           OPEN apb_c1 USING sr.tlf026,sr.tlf027,sr.tlf01,tm.bdate,tm.edate                                                                                     
           FETCH apb_c1 INTO sr.amt01
           IF cl_null(sr.amt01) THEN LET x_flag = 'N' ELSE LET x_flag = 'Y' END IF   #MOD-A40087 add
          #str TQC-C60021 mark
          ##FUN-C50009---begin
          ##抓取委外倉退單入非成本倉的AP金額
          #IF s_industry('icd') AND tm.type='2' AND x_flag='Y' THEN
          #   INITIALIZE sr1.* TO NULL
          #   IF sr.tlf026 != o_tlf026 OR sr.tlf01 != o_tlf01 THEN
          #      FOREACH r700_c0_2 USING sr.tlf026,sr.tlf01 INTO sr1.*
          #         OPEN apb_c1_1 USING sr1.tlf026,sr1.tlf027,sr1.tlf01
          #         FETCH apb_c1_1 INTO l_amt01
          #         IF cl_null(l_amt01) THEN LET l_amt01=0 END IF
          #         LET sr.amt01=sr.amt01+l_amt01
          #
          #         LET o_tlf026 = sr1.tlf026  #記錄舊值
          #         LET o_tlf01  = sr1.tlf01   #記錄舊值
          #      END FOREACH
          #   END IF
          #END IF
          ##FUN-C50009---end
          #end TQC-C60021 mark
        
         #IF cl_null(sr.amt01) THEN LET sr.amt01 = 0 END IF  #No:MOD-860019 add  #No:MOD-B10175 mark
          #抓取當月驗退沖帳的驗退金額
         #IF sr.amt01 = 0 THEN   #MOD-A40087 mark
          IF x_flag = 'N' THEN   #MOD-A40087
#            LET l_sql = "SELECT SUM(ABS(apb101)) ",         #No.MOD-A80020                                                                      
#FUN-A10098---BEGIN
#                         "  FROM ",l_dbs CLIPPED,"apb_file,",                                                                          
#                                   l_dbs CLIPPED,"apa_file ",
#                       #FUN-A70084--mod--str-- m_dbs-->m_plant
#                       #"  FROM ",cl_get_target_table(m_dbs[l_i],'apb_file'),",",
#                       #          cl_get_target_table(m_dbs[l_i],'apa_file'),
#                        "  FROM ",cl_get_target_table(m_plant[l_i],'apb_file'),",",
#                                  cl_get_target_table(m_plant[l_i],'apa_file'),
#                       #FUN-A70084--mod--end
#FUN-A10098---END
#                        " WHERE apa01 = apb01 AND apa42 = 'N'",
#                        "   AND apb29='3' AND  apb21='",sr.tlf026,"'",
#                        "   AND apb22='",sr.tlf027,"' AND apb12='",sr.tlf01,"' ",
#                        "   AND (apa00 ='11' OR apa00 = '26') ",                          #TQC-970180 Add
#                        "   AND apb34 <> 'Y'",
#                        "   AND apa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' " 
#            CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#           #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098       #FUN-A70084                                                                                                                                                                           
#           #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql     #FUN-A70084   #TQC-BB0182 mark 
#            PREPARE apb_prepare4 FROM l_sql                                                                                          
#            DECLARE apb_c4  CURSOR FOR apb_prepare4                                                                                 
             OPEN apb_c4 USING sr.tlf026,sr.tlf027,sr.tlf01,tm.bdate,tm.edate                                                                                   
             FETCH apb_c4 INTO sr.amt01
             IF cl_null(sr.amt01) THEN LET x_flag = 'N' ELSE LET x_flag = 'Y' END IF   #MOD-A40087 add
            #str TQC-C60021 mark
            ##FUN-C50009---begin
            ##抓取委外倉退單入非成本倉的AP金額
            #IF s_industry('icd') AND tm.type='2' AND x_flag='Y' THEN
            #   INITIALIZE sr1.* TO NULL
            #   IF sr.tlf026 != o_tlf026 OR sr.tlf01 != o_tlf01 THEN
            #      FOREACH r700_c0_2 USING sr.tlf026,sr.tlf01 INTO sr1.*
            #         OPEN apb_c4_1 USING sr1.tlf026,sr1.tlf027,sr1.tlf01
            #         FETCH apb_c4_1 INTO l_amt01
            #         IF cl_null(l_amt01) THEN LET l_amt01=0 END IF
            #         LET sr.amt01=sr.amt01+l_amt01
            #
            #         LET o_tlf026 = sr1.tlf026  #記錄舊值
            #         LET o_tlf01  = sr1.tlf01   #記錄舊值
            #      END FOREACH
            #   END IF
            #END IF
            ##FUN-C50009---end
            #end TQC-C60021 mark
 
              #IF cl_null(sr.amt01) THEN LET sr.amt01 = 0 END IF  #No:MOD-B10175 mark
          END IF
          LET sr.tlf10 = sr.tlf10 * sr.tlf907
          IF sr.amt01 > 0 THEN                      #MOD-7B0184-add
             LET sr.amt01 = sr.amt01 * sr.tlf907
          END IF                                    #MOD-7B0184-add
          LET sr.tlf031 = sr.tlf021
      #END IF    #No:MOD-B10175 mark
       #IF cl_null(sr.amt01)  OR sr.amt01 = 0 THEN   #MOD-A40087 mark
        IF x_flag = 'N' THEN                         #MOD-A40087
#          LET l_sql = "SELECT ale09 ",                                                                              
##                      "  FROM ",l_dbs CLIPPED,"ale_file ",          #FUN-A10098                                                                  
#                     #"  FROM ",cl_get_target_table(m_dbs[l_i],'ale_file'),    #FUN-A10098   #FUN-A70084                                                                
#                      "  FROM ",cl_get_target_table(m_plant[l_i],'ale_file'),    #FUN-A70084
#                      " WHERE ale16='",sr.tlf026,"'",   #MOD-A70063 mod tlf036->tlf026
#                      "   AND ale17='",sr.tlf027,"'",   #MOD-A70063 mod tlf037->tlf027
#                      "   AND ale11='",sr.tlf01,"'"                             
#          CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#         #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098    #FUN-A70084                                                                                                                                                
#         #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql   #FUN-A70084   #TQC-BB0182 mark 
#          PREPARE ale_prepare2 FROM l_sql                                                                                          
#          DECLARE ale_c2  CURSOR FOR ale_prepare2                                                                                 
           OPEN ale_c2 USING sr.tlf026,sr.tlf027,sr.tlf01                                                                                    
           FETCH ale_c2 INTO sr.amt01
           IF cl_null(sr.amt01) THEN LET x_flag = 'N' ELSE LET x_flag = 'Y' END IF   #MOD-A40087 add
              
          #IF cl_null(sr.amt01) THEN LET sr.amt01 = 0 END IF    #No:MOD-860019 add  #No:MOD-B10175 mark
          #IF  sr.amt01 = 0 THEN  #MOD-580114 add  #MOD-A40087 mark
           IF x_flag = 'N' THEN                    #MOD-A40087
               LET sr.code='*'
               #抓取倉退立暫估金額，且當作未請款金額
              #IF sr.amt01 = 0 THEN   #MOD-A40087 mark
 
#                 LET l_sql = "SELECT SUM(apb101) ",                                                                              
#FUN-A10098---BEGIN
#                              "  FROM ",l_dbs CLIPPED,"apb_file,",                                                                          
#                                        l_dbs CLIPPED,"apa_file ",
#                            #FUN-A70084--mod--str--m_dbs-->m_plant
#                            #"  FROM ",cl_get_target_table(m_dbs[l_i],'apb_file'),",",
#                            #          cl_get_target_table(m_dbs[l_i],'apa_file'),
#                             "  FROM ",cl_get_target_table(m_plant[l_i],'apb_file'),",",
#                                       cl_get_target_table(m_plant[l_i],'apa_file'),
#                            #FUN-A70084--mod--end
#FUN-A10098---END
#                             " WHERE apa01 = apb01 AND apa42 = 'N'",
#                             "   AND apb29='3' AND  apb21='",sr.tlf026,"'",
#                             "   AND apb22='",sr.tlf027,"' AND apb12='",sr.tlf01,"' ",
#                             "   AND apa00 ='26' ",
#                             "   AND (apa58 ='2' OR apa58 = '3') ",   #No.CHI-910019 add
#                             "   AND apb34 <> 'Y'",
#                             "   AND apa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' "     
#                 CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#                #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098   #FUN-A70084                                                                                                                                                                           
#                #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql   #FUN-A70084  #TQC-BB0182 mark      
#                 PREPARE apb_prepare5 FROM l_sql                                           
#                 DECLARE apb_c5  CURSOR FOR apb_prepare5                                                                                 
                  OPEN apb_c5 USING sr.tlf026,sr.tlf027,sr.tlf01,tm.bdate,tm.edate                                                                                     
                  FETCH apb_c5 INTO sr.amt01
                  IF cl_null(sr.amt01) THEN LET x_flag = 'N' ELSE LET x_flag = 'Y' END IF   #MOD-A40087 add
                 #str TQC-C60021 mark
                 ##FUN-C50009---begin
                 ##抓取委外倉退單入非成本倉的AP金額
                 #IF s_industry('icd') AND tm.type='2' AND x_flag='Y' THEN
                 #   INITIALIZE sr1.* TO NULL
                 #   IF sr.tlf026 != o_tlf026 OR sr.tlf01 != o_tlf01 THEN
                 #      FOREACH r700_c0_2 USING sr.tlf026,sr.tlf01 INTO sr1.*
                 #         OPEN apb_c5_1 USING sr1.tlf026,sr1.tlf027,sr1.tlf01
                 #         FETCH apb_c5_1 INTO l_amt01
                 #         IF cl_null(l_amt01) THEN LET l_amt01=0 END IF
                 #         LET sr.amt01=sr.amt01+l_amt01
                 #
                 #         LET o_tlf026 = sr1.tlf026  #記錄舊值
                 #         LET o_tlf01  = sr1.tlf01   #記錄舊值
                 #      END FOREACH
                 #   END IF
                 #END IF
                 ##FUN-C50009---end
                 #end TQC-C60021 mark
              
                 #IF cl_null(sr.amt01) THEN LET sr.amt01 = 0 END IF   #No:MOD-B10175 mark
              #END IF   #MOD-A40087 mark
               #-->取採購單價
              #IF sr.amt01 = 0 THEN    #No:MOD-860019 add  #MOD-A40087 mark
               IF x_flag = 'N' THEN                        #MOD-A40087
 
#                 LET l_sql = "SELECT rvv04,rvv05,rvv39 ",                                                                              
#                      #       "  FROM ",l_dbs CLIPPED,"rvv_file ",   #FUN-A10098                                                                        
#                            #"  FROM ",cl_get_target_table(m_dbs[l_i],'rvv_file'),  #FUN-A10098  #FUN-A70084                                                                      
#                             "  FROM ",cl_get_target_table(m_plant[l_i],'rvv_file'), #FUN-A70084 
#                             " WHERE rvv01='",sr.tlf026,"'",  #MOD-A70063 mod tlf036->tlf026
#                             "   AND rvv02='",sr.tlf027,"'",  #MOD-A70063 mod tlf037->tlf027
#                             "   AND rvv25<>'Y'"                                     
#                 CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#                #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098 #FUN-A70084     
#                #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084   #TQC-BB0182 mark
#                 PREPARE rvv_prepare2 FROM l_sql                                                                                          
#                 DECLARE rvv_c2  CURSOR FOR rvv_prepare2                                                                                 
                  OPEN rvv_c2 USING sr.tlf026,sr.tlf027                                                                                    
                  FETCH rvv_c2 INTO l_rvv04,l_rvv05,l_rvv39
                   
                   IF (l_rvv04 IS NOT NULL OR l_rvv05 IS NOT NULL OR l_rvv39 IS NOT NULL) THEN
                       SELECT rva00 INTO l_rva00 FROM rva_file WHERE rva01=l_rvv04   #MOD-C20103 add
                      #IF l_rva00 <> '2'THEN                                         #MOD-C20103 add 
                      #  LET l_sql = "SELECT pmm22,rva06,pmm42 ",                                                                              
#FUN-A10098---BEGIN
#                     #               "  FROM ",l_dbs CLIPPED,"rvb_file,",
#                     #                         l_dbs CLIPPED,"pmm_file,",                                                                           
#                     #                         l_dbs CLIPPED,"rva_file ",
                      #             #FUN-A70084--mod--str--m_dbs--m_plant
                      #             #"  FROM ",cl_get_target_table(m_dbs[l_i],'rvb_file'),",",
                      #             #          #cl_get_target_table(m_dbs[l_i],'pmm_file'),"pmm_file,",
                      #             #          #cl_get_target_table(m_dbs[l_i],'rva_file'),"rva_file ",
                      #             #          cl_get_target_table(m_dbs[l_i],'pmm_file'),",",   #FUN-A50102
                      #             #          cl_get_target_table(m_dbs[l_i],'rva_file'),       #FUN-A50102
                      #              "  FROM ",cl_get_target_table(m_plant[l_i],'rvb_file'),",",
                      #                        cl_get_target_table(m_plant[l_i],'pmm_file'),",", 
                      #                        cl_get_target_table(m_plant[l_i],'rva_file'),    
                      #             #FUN-A70084--mod--end
#FUN-A10098---END
                      #              " WHERE rvb01='",l_rvv04,"' AND rvb02='",l_rvv05,"'",
                      #              "   AND pmm01=rvb04 AND rva01 = rvb01",
                      #              "   AND rvaconf <> 'X'  AND pmm18 <> 'X' "   
                      ##MOD-C20103 str  add------
                      #ELSE
                      #  LET l_sql = "SELECT rva113,rva06,rva114 ",
                      #              "  FROM ",cl_get_target_table(m_plant[l_i],'rvb_file'),",",
                      #                        cl_get_target_table(m_plant[l_i],'rva_file'),
                      #              " WHERE rvb01='",l_rvv04,"' AND rvb02='",l_rvv05,"'",
                      #              "   AND rva01 = rvb01   AND rvaconf <> 'X'  "
                      #END IF
                      ##MOD-C20103 end  add------                      
                      #CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102            
                      #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098   #FUN-A70084                                                                                                                                                                      
                      #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084     #TQC-BB0182 mark 
                      #PREPARE pmm_prepare1 FROM l_sql                                                                                          
                      #DECLARE pmm_c1  CURSOR FOR pmm_prepare1                                                                                 
                       OPEN pmm_c1 USING l_rvv04,l_rvv05,l_rvv04,l_rvv05                                                                                   
                       FETCH pmm_c1 INTO l_pmm22,l_rva06,l_pmm42
                          
                       IF STATUS <> 0 THEN
                           LET l_pmm22=' '
                           LET l_pmm42= 1
                       END IF
                       IF l_pmm42 IS NULL THEN LET l_pmm42=1 END IF
                       LET sr.amt01=l_rvv39*l_pmm42
                  END IF
               END IF         #No.MOD-860019 add
               IF sr.amt01 > 0 THEN                      
                  LET sr.amt01 = sr.amt01 * sr.tlf907
               END IF                                   
           END IF
       END IF
       IF cl_null(sr.amt01) THEN LET sr.amt01 = 0 END IF   #No:MOD-B10175 add
     END IF   #No:MOD-B10175 add
       LET l_n = 0
 
#      LET l_sql = "SELECT COUNT(*) ",                                                                              
#           #       "  FROM ",l_dbs CLIPPED,"rvv_file ",   #FUN-A10098
#                 #"  FROM ",cl_get_target_table(m_dbs[l_i],'rvv_file'),  #FUN-A10098  #FUN-A70084
#                  "  FROM ",cl_get_target_table(m_plant[l_i],'rvv_file'),  #FUN-A70084
#                  " WHERE rvv01 = '",sr.tlf905,"'",
#                  "   AND rvv02 = '",sr.tlf906,"'",
#                  "   AND rvv25 = 'Y' "   
#      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102            
#     #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098    #FUN-A70084                                                                                                                                                                           
#     #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
#      PREPARE rvv_prepare1 FROM l_sql                                                                                          
#      DECLARE rvv_c1  CURSOR FOR rvv_prepare1                                                                                 
       OPEN rvv_c1 USING sr.tlf905,sr.tlf906                                                                                   
       FETCH rvv_c1 INTO l_n
         
       IF l_n > 0 THEN
          LET sr.amt01 = 0
          LET sr.code = '%'     #樣品另外識別
       END IF
#---------------------------------
        LET g_msg=' '             #No.FUN-7C0090
#CHI-D30019---begin        
#       #FUN-BB0063(S)
#       #處理委外倉退
#       IF tm.costdown='Y' AND tm.type MATCHES '[23]' AND 
##         sr.tlf13='apmt1072' AND (sr.amt01=0 OR sr.amt01 IS NULL) THEN  #FUN-D20078 mark
#          (sr.tlf13='asft6201' OR sr.tlf13='apmt230') AND (sr.amt01=0 OR sr.amt01 IS NULL) THEN   #FUN-D20078 add 
#          SELECT rvv39*-1 INTO sr.amt01 FROM rvv_file 
#           WHERE rvv01=sr.tlf026 AND rvv02=sr.tlf027
#          IF sr.amt01 IS NULL THEN
#             LET sr.amt01 = 0
#          END IF
#       END IF
#       #FUN-BB0063(E)
#CHI-D30019---end      
       CASE tm.g
       WHEN '2'
          LET  wima01  = sr.ima01        
 
#         LET l_sql = "SELECT azf03 ",                                                                              
#              #       "  FROM ",l_dbs CLIPPED,"azf_file ",   #FUN-A10098
#                    #"  FROM ",cl_get_target_table(m_dbs[l_i],'azf_file'),   #FUN-A10098  #FUN-A70084
#                     "  FROM ",cl_get_target_table(m_plant[l_i],'azf_file'), #FUN-A70084
#                     " WHERE azf01='",sr.ima12,"' AND azf02='G'"          
#         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#        #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098     #FUN-A70084                                                                                                                                                                  
#        #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084   #TQC-BB0182 mark 
#         PREPARE azf_prepare1 FROM l_sql                                                                                          
#         DECLARE azf_c1  CURSOR FOR azf_prepare1                                                                                 
          OPEN azf_c1 USING sr.ima12                                                                                   
          FETCH azf_c1 INTO g_msg
          
             EXECUTE insert_prep USING sr.code,
#                sr.ima12,wima01,sr.ima02,sr.tlfccost,sr.tlf021,sr.tlf031,sr.tlf06,  #FUN-7C0101 ADD sr.tlfccost ##TQC-D90023 mark
                 sr.ima12,wima01,sr.ima02,sr.ima021,sr.tlfccost,sr.tlf021,sr.tlf031,sr.tlf06,     #TQC-D90023 add
                 sr.tlf026,sr.tlf027,sr.tlf036,sr.tlf037,sr.tlf01,sr.tlf10,
                 sr.tlfc21,sr.tlf13,sr.tlf65,sr.tlf19,sr.tlf905,sr.tlf906,    #FUN-7C0101 tlf21-->tlfc21
                 #sr.tlf907,sr.amt01,g_azi03,g_ccz.ccz27,l_company,wpmc03,g_msg    #No.MOD-840596 add pmc03   #No.MOD-870005 add g_msg #CHI-C30012
                 sr.tlf907,sr.amt01,g_ccz.ccz26,g_ccz.ccz27,l_company,wpmc03,g_msg #CHI-C30012
                #,m_dbs[l_i],l_ima57,l_ima08                                    #FUN-8B0026 Add m_dbs[l_i],l_ima57,l_ima08   #FUN-A70084
                 ,m_plant[l_i],l_ima57,l_ima08                                  #FUN-A70084   
       WHEN '3'
        LET wpmc03  = ' '
        LET wima202 = ' '
        LET wima201 = sr.tlf01[1,2]
        #No.TQC-A40139  --Begin
        #IF tm.type_1 = '1' THEN     
        #   LET l_sql = "SELECT pmc03 ",                                                                              
        #        #       "  FROM ",l_dbs CLIPPED,"pmc_file ",  #FUN-A10098
        #               "  FROM ",cl_get_target_table(m_dbs[l_i],'pmc_file'),  #FUN-A10098
        #               " WHERE pmc01= '",sr.tlf19,"' AND pmc903='Y'"
        #ELSE IF tm.type_1 = '2' THEN
        #   LET l_sql = "SELECT pmc03 ",                                                                              
        #        #       "  FROM ",l_dbs CLIPPED,"pmc_file ",   #FUN-A10098
        #               "  FROM ",cl_get_target_table(m_dbs[l_i],'pmc_file'),  #FUN-A10098
        #               " WHERE pmc01= '",sr.tlf19,"' AND pmc903='N'"
        #ELSE
        #   LET l_sql = "SELECT pmc03 ",                                                                              
        #           #    "  FROM ",l_dbs CLIPPED,"pmc_file ",   #FUN-A10098
        #               "  FROM ",cl_get_target_table(m_dbs[l_i],'pmc_file'),  #FUN-A10098
        #               " WHERE pmc01= '",sr.tlf19,"'"
        #     END IF
        #END IF                            	                       	      
#       LET l_sql = "SELECT pmc03,pmc903 ",                                                                              
#                  #"  FROM ",cl_get_target_table(m_dbs[l_i],'pmc_file'),  #FUN-A10098  #FUN-A70084
#                   "  FROM ",cl_get_target_table(m_plant[l_i],'pmc_file'),  #FUN-A70084
#                   " WHERE pmc01= '",sr.tlf19,"'"
#       #No.TQC-A40139  --End  
#       CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#      #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098   #FUN-A70084                                                                                                                                                                                        
#      #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
#       PREPARE pmc_prepare1 FROM l_sql                                                                                          
#       DECLARE pmc_c1  CURSOR FOR pmc_prepare1                                                                                 
        OPEN pmc_c1 USING sr.tlf19                                                                                    
        #No.TQC-A40139  --Begin
       #FETCH pmc_c1 INTO wpmc03
        FETCH pmc_c1 INTO wpmc03,l_pmc903
        IF cl_null(l_pmc903) THEN LET l_pmc903 = 'N' END IF
        IF tm.type_1 = '1' THEN
           IF l_pmc903 = 'N' THEN CONTINUE FOREACH END IF
        END IF
        IF tm.type_1 = '2' THEN
           IF l_pmc903 = 'Y' THEN CONTINUE FOREACH END IF
        END IF
        #No.TQC-A40139  --End  
#CHI-B30029---mark---start---        
#       IF  wima201 <> '99' THEN
#         LET l_sql = "SELECT ima202 ",                                                                              
#                #     "  FROM ",l_dbs CLIPPED,"ima2_file ",  #FUN-A10098
#                    #"  FROM ",cl_get_target_table(m_dbs[l_i],'ima2_file'),  #FUN-A10098   #FUN-A70084
#                     "  FROM ",cl_get_target_table(m_plant[l_i],'ima2_file'), #FUN-A70084 
#                     " WHERE ima201= '",wima201,"'"                        
#         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#        #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098      #FUN-A70084                                                                                                                                                   
#        #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql   #FUN-A70084  #TQC-BB0182 mark 
#         PREPARE ima_prepare1 FROM l_sql                                                                                          
#         DECLARE ima_c1  CURSOR FOR ima_prepare1                                                                                 
#         OPEN ima_c1 USING wima201                                                                                    
#         FETCH ima_c1 INTO wima202
#       ELSE
#         LET l_sql = "SELECT ima131 ",                                                                              
#                 #    "  FROM ",l_dbs CLIPPED,"ima_file ",  #FUN-A10098
#                    #"  FROM ",cl_get_target_table(m_dbs[l_i],'ima_file'),  #FUN-A10098  #FUN-A70084
#                     "  FROM ",cl_get_target_table(m_plant[l_i],'ima_file'),  #FUN-A70084
#                     " WHERE ima01 = '",sr.tlf01,"'"                          
#         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#        #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098    #FUN-A70084                                                                                                                                                     
#        #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
#         PREPARE ima_prepare2 FROM l_sql                                                                                          
#         DECLARE ima_c2  CURSOR FOR ima_prepare2                                                                                 
#         OPEN ima_c2 USING wima201                                                                                   
#         FETCH ima_c2 INTO wima202
#       END IF
 #CHI-B30029---mark---end---

        LET l_company=sr.tlf19,'  ',wpmc03
#         LET l_sql = "SELECT azf03 ",                                                                              
#                #     "  FROM ",l_dbs CLIPPED,"azf_file ",   #FUN-A10098
#                    #"  FROM ",cl_get_target_table(m_dbs[l_i],'azf_file'),   #FUN-A10098  #FUN-A70084
#                     "  FROM ",cl_get_target_table(m_plant[l_i],'azf_file'),   #FUN-A70084
#                     " WHERE azf01='",sr.ima12,"' AND azf02='G'"                                                                                                                                                                                 
#         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#        #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098  #FUN-A70084
#        #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
#         PREPARE azf_prepare4 FROM l_sql                                                                                          
#         DECLARE azf_c4  CURSOR FOR azf_prepare4                                                                                 
          OPEN azf_c4 USING sr.ima12                                                                                   
          FETCH azf_c4 INTO g_msg
        
           EXECUTE insert_prep USING sr.code,
              #sr.ima12,wima01,sr.ima02,sr.tlfccost,sr.tlf021,sr.tlf031,sr.tlf06,    #FUN-7C0101 ADD sr.tlfccost  #TQC-D90023 mark
               sr.ima12,wima01,sr.ima02,sr.ima021,sr.tlfccost,sr.tlf021,sr.tlf031,sr.tlf06, #TQC-D90023 add
               sr.tlf026,sr.tlf027,sr.tlf036,sr.tlf037,sr.tlf01,sr.tlf10,
               sr.tlfc21,sr.tlf13,sr.tlf65,sr.tlf19,sr.tlf905,sr.tlf906,       #FUN-7C0101 tlf21-->tlfc21  
               #sr.tlf907,sr.amt01,g_azi03,g_ccz.ccz27,l_company,wpmc03,g_msg      #No.MOD-840596 add wpmc03   #No.MOD-870005 add g_msg #CHI-C30012
               sr.tlf907,sr.amt01,g_ccz.ccz26,g_ccz.ccz27,l_company,wpmc03,g_msg #CHI-C30012
              #,m_dbs[l_i],l_ima57,l_ima08                                    #FUN-8B0026 Add m_dbs[l_i],l_ima57,l_ima08  #FUN-A70084
               ,m_plant[l_i],l_ima57,l_ima08                                  #FUN-A70084 
       OTHERWISE
#         LET l_sql = "SELECT azf03 ",                                                                              
#               #      "  FROM ",l_dbs CLIPPED,"azf_file ",   #FUN-A10098
#                    #"  FROM ",cl_get_target_table(m_dbs[l_i],'azf_file'),   #FUN-A10098   #FUN-A70084
#                     "  FROM ",cl_get_target_table(m_plant[l_i],'azf_file'), #FUN-A70084
#                     " WHERE azf01='",sr.ima12,"' AND azf02='G'"             
#         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#        #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098    #FUN-A70084                                                                                                                                                                  
#        #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
#         PREPARE azf_prepare5 FROM l_sql                                                                                          
#         DECLARE azf_c5  CURSOR FOR azf_prepare5                                                                                 
          OPEN azf_c5 USING sr.ima12                                                                                   
          FETCH azf_c5 INTO g_msg
     
        EXECUTE insert_prep USING sr.code,
            #sr.ima12,sr.ima01,sr.ima02,sr.tlfccost,sr.tlf021,sr.tlf031,sr.tlf06,  #FUN-7C0101 ADD sr.tlfccost  #TQC-D90023 mark
             sr.ima12,sr.ima01,sr.ima02,sr.ima021,sr.tlfccost,sr.tlf021,sr.tlf031,sr.tlf06, #TQC-D90023 add
             sr.tlf026,sr.tlf027,sr.tlf036,sr.tlf037,sr.tlf01,sr.tlf10,
             sr.tlfc21,sr.tlf13,sr.tlf65,sr.tlf19,sr.tlf905,sr.tlf906,      #FUN-7C0101 tlf21-->tlfc21  
             #sr.tlf907,sr.amt01,g_azi03,g_ccz.ccz27,l_company,wpmc03,g_msg      #No.MOD-840596 wpmc03   #No.MOD-870005 add g_msg #CHI-C30012
             sr.tlf907,sr.amt01,g_ccz.ccz26,g_ccz.ccz27,l_company,wpmc03,g_msg #CHI-C30012
            #,m_dbs[l_i],l_ima57,l_ima08                                    #FUN-8B0026 Add m_dbs[l_i],l_ima57,l_ima08   #FUN-A70084
             ,m_plant[l_i],l_ima57,l_ima08                                  #FUN-A70084 
       END CASE
     END FOREACH
#CHI-C30055----------------end------------------------

   #str TQC-C60021 mark
   ##str FUN-C50009 add
   ##若入庫單只入非成本倉,前面那個FOREACH根本進不去
   #IF s_industry('icd') AND tm.type='2' THEN
   #   #FUN-BB0063(S)
   #   IF tm.costdown ='Y' THEN
   #      LET l_costdown =" OR tlf13 = 'apmt1072' "
   #   ELSE
   #      LET l_costdown =''
   #   END IF
   #   #FUN-BB0063(E)
   #   LET l_sql = "SELECT '',ima12,ima01,ima02,tlfccost,",
   #                     " tlf021,tlf031,tlf06,tlf026,tlf027,tlf036,tlf037,",
   #                     " tlf01,0,tlfc21,tlf13,tlf65,tlf19,tlf905,tlf906,tlf907,0,ima57,ima08",
   #               "  FROM ",cl_get_target_table(m_plant[l_i],'tlf_file'),
   #               "  LEFT OUTER JOIN ",cl_get_target_table(m_plant[l_i],'tlfc_file'),
   #               "    ON tlfc01 = tlf01  AND tlfc02 = tlf02  AND ",
   #               "       tlfc03 = tlf03  AND tlfc06 = tlf06  AND ",
   #               "       tlfc13 = tlf13  AND ",
   #               "       tlfc902= tlf902 AND tlfc903= tlf903 AND ",
   #               "       tlfc904= tlf904 AND tlfc905= tlf905 AND ",
   #               "       tlfc906= tlf906 AND tlfc907= tlf907 AND ",
   #               "       tlfctype =  '",tm.type1,"'",
   #               "      ,",cl_get_target_table(m_plant[l_i],'ima_file'),",",
   #                         cl_get_target_table(m_plant[l_i],'sfb_file'),
   #               " WHERE ima01 = tlf01",
   #               "   AND sfb01 = tlf62",
   #               "   AND (sfb02 = 7 OR sfb02 = 8) ",  #No:9584
   #               "   AND (tlf13 = 'asft6201' OR tlf13 = 'asft6101' OR tlf13 = 'asft6231'",l_costdown,") ",
   #               "   AND ",tm.wc CLIPPED,
   #               "   AND (tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')",
   #               "   AND tlf902 IN (SELECT jce02 FROM ",cl_get_target_table(m_plant[l_i],'jce_file'),")",
   #               "   AND NOT EXISTS (SELECT tlf036 FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," a",
   #               "                    WHERE ",cl_get_target_table(m_plant[l_i],'tlf_file'),".tlf036=a.tlf036)", 
   #               "   AND NOT EXISTS (SELECT tlf026 FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," a",
   #               "                    WHERE ",cl_get_target_table(m_plant[l_i],'tlf_file'),".tlf026=a.tlf026)" 
   #   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   #   PREPARE r700_p0_3 FROM l_sql
   #   DECLARE r700_c0_3 CURSOR FOR r700_p0_3
   #
   #   FOREACH r700_c0_3 INTO sr.*,l_ima57,l_ima08
   #      #-->委外採購入庫
   #      IF sr.tlf13='asft6201' OR sr.tlf13 = 'asft6101' OR sr.tlf13='asft6231' THEN
   #         #抓取委外入庫單入非成本倉的AP金額(應付金額 或 暫估應付金額) 
   #         OPEN apb_c3_1 USING sr.tlf036,sr.tlf037,sr.tlf01
   #         FETCH apb_c3_1 INTO l_amt01
   #         IF cl_null(l_amt01) THEN LET l_amt01=0 END IF
   #         IF l_amt01= 0 THEN  #抓不到,再抓取委外入庫單入非成本倉的AP金額(暫估應付金額)
   #            OPEN apb_c2_1 USING sr.tlf036,sr.tlf037,sr.tlf01
   #            FETCH apb_c2_1 INTO l_amt01
   #            IF cl_null(l_amt01) THEN LET l_amt01=0 END IF
   #         END IF
   #      #-->委外倉退
   #      ELSE
   #         #抓取委外倉退單入非成本倉的AP金額(應付折讓金額)
   #         OPEN apb_c1_1 USING sr.tlf026,sr.tlf027,sr.tlf01
   #         FETCH apb_c1_1 INTO l_amt01
   #         IF cl_null(l_amt01) THEN LET l_amt01=0 END IF
   #         IF l_amt01= 0 THEN  #抓不到,再抓取委外倉退單入非成本倉的AP金額(應付帳款裡的折讓金額 或 暫估應付折讓金額)
   #            OPEN apb_c4_1 USING sr.tlf026,sr.tlf027,sr.tlf01
   #            FETCH apb_c4_1 INTO l_amt01
   #            IF cl_null(l_amt01) THEN LET l_amt01=0 END IF
   #            IF l_amt01= 0 THEN  #還是抓不到,再抓取委外倉退單入非成本倉的AP金額(暫估應付折讓金額)
   #               OPEN apb_c5_1 USING sr.tlf026,sr.tlf027,sr.tlf01
   #               FETCH apb_c5_1 INTO l_amt01
   #               IF cl_null(l_amt01) THEN LET l_amt01=0 END IF
   #            END IF
   #         END IF
   #      END IF
   #      IF tm.type = '3' THEN
   #         IF sr.code = '1' THEN 
   #            LET sr.tlf13 = 'asft6201'
   #         ELSE
   #            IF sr.code = '3' THEN
   #               LET sr.tlf13 = 'apmt1072'
   #            ELSE
   #               LET sr.tlf13 = 'asft6101'
   #            END IF
   #         END IF
   #      END IF 
   #      CASE tm.g
   #        WHEN '2'
   #          LET  wima01  = sr.ima01        
   #          OPEN azf_c1 USING sr.ima12                                                                                   
   #          FETCH azf_c1 INTO g_msg
   #        WHEN '3'
   #          LET wpmc03  = ' '
   #          LET wima202 = ' '
   #          LET wima201 = sr.tlf01[1,2]
   #          OPEN pmc_c1 USING sr.tlf19                                                                                    
   #          FETCH pmc_c1 INTO wpmc03,l_pmc903
   #          IF cl_null(l_pmc903) THEN LET l_pmc903 = 'N' END IF
   #          IF tm.type_1 = '1' THEN
   #             IF l_pmc903 = 'N' THEN CONTINUE FOREACH END IF
   #          END IF
   #          IF tm.type_1 = '2' THEN
   #             IF l_pmc903 = 'Y' THEN CONTINUE FOREACH END IF
   #          END IF
   #          IF wima201 <> '99' THEN
   #             OPEN ima_c1 USING wima201                                                                                    
   #             FETCH ima_c1 INTO wima202
   #          ELSE
   #             OPEN ima_c2 USING wima201                                                                                   
   #             FETCH ima_c2 INTO wima202
   #          END IF
   #          LET l_company=sr.tlf19,'  ',wpmc03
   #          OPEN azf_c4 USING sr.ima12                                                                                   
   #          FETCH azf_c4 INTO g_msg
   #        OTHERWISE
   #          OPEN azf_c5 USING sr.ima12                                                                                   
   #          FETCH azf_c5 INTO g_msg
   #      END CASE
   #
   #      EXECUTE insert_prep USING sr.code,
   #         sr.ima12,sr.ima01,sr.ima02,sr.tlfccost,sr.tlf021,sr.tlf031,sr.tlf06,
   #         sr.tlf026,sr.tlf027,sr.tlf036,sr.tlf037,sr.tlf01,sr.tlf10,
   #         sr.tlfc21,sr.tlf13,sr.tlf65,sr.tlf19,sr.tlf905,sr.tlf906,
   #         sr.tlf907,l_amt01,g_azi03,g_ccz.ccz27,l_company,wpmc03,g_msg
   #         ,m_plant[l_i],l_ima57,l_ima08
   #   END FOREACH
   #END IF
   ##end FUN-C50009 add
   #end TQC-C60021 mark

   END FOR                                                                      #FUN-8B0026     
     LET g_sql="SELECT  * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   
     CALL cl_wcchp(tm.wc,'ima12,ima01,ima57,ima08,tlf19')
             RETURNING tm.wc
     LET g_str=tm.wc,";",tm.a,";",g_msg CLIPPED,";", #MOD-840403
               tm.s[1,1],";",tm.s[2,2],";",                    #FUN-8B0026
               tm.s[3,3],";",tm.t,";",tm.u,";",tm.b,";",tm.type            #FUN-8B0026   #MOD-D40112 add  tm.type
     
#根據成本計算類型決定類別編號是否列印  
  IF tm.type1 MATCHES '[12]' THEN          #FUN-7C0101 成本計算類型判定
     IF tm.g='1' THEN
     
     CALL cl_prt_cs3('axcr700','axcr700',g_sql,g_str)     #No.FUN-7C0090
 
     END IF
     IF tm.g='2' THEN
     
         CALL cl_prt_cs3('axcr700','axcr700_1_1',g_sql,g_str)#No.FUN-7C0090 #FUN-7C0101 axcr700_1 --> axcr700_1_1
 
     END IF
     IF tm.g='3' THEN   
 
        CALL cl_prt_cs3('axcr700','axcr700_2_1',g_sql,g_str) #No.FUN-7C0090 #FUN-7C0101 axcr700_2 --> axcr700_2_1 
     END IF
  ELSE                                   #FUN-7C0101 成本計算類型判定   
     IF tm.g='1' THEN                                                                                                               
        CALL cl_prt_cs3('axcr700','axcr700_1',g_sql,g_str)                                                               
     END IF                                                                                                                         
     IF tm.g='2' THEN                                                                                                               
         CALL cl_prt_cs3('axcr700','axcr700_1_2',g_sql,g_str)                                                           
     END IF                                                                                                                         
     IF tm.g='3' THEN                                                                                                               
         CALL cl_prt_cs3('axcr700','axcr700_2_2',g_sql,g_str)                                                            
     END IF                                                                                                                         
 
  END IF                #FUN-7C0101                
#FUN-7C0101 --END-- 
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)        #No.FUN-7C0090
END FUNCTION
 
#FUN-8B0026--Begin--#
FUNCTION r700_set_entry_1()
    CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",TRUE)
END FUNCTION
FUNCTION r700_set_no_entry_1()
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
END FUNCTION
FUNCTION r700_set_comb()                                                                                                            
  DEFINE comb_value STRING                                                                                                          
  DEFINE comb_item  LIKE type_file.chr1000                                                                                          
                                                                                                                                    
    IF tm.b ='N' THEN                                                                                                         
       LET comb_value = '1,2,3,4,5'                                                                                                   
       SELECT ze03 INTO comb_item FROM ze_file                                                                                      
         WHERE ze01='axc-986' AND ze02=g_lang                                                                                      
    ELSE                                                                                                                            
       LET comb_value = '1,2,3,4,5,6'                                                                                                   
       SELECT ze03 INTO comb_item FROM ze_file                                                                                      
         WHERE ze01='axc-987' AND ze02=g_lang                                                                                       
    END IF                                                                                                                          
    CALL cl_set_combo_items('s1',comb_value,comb_item)
    CALL cl_set_combo_items('s2',comb_value,comb_item)
    CALL cl_set_combo_items('s3',comb_value,comb_item)                                                                          
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/12 
#FUN-A70084--add--str--
FUNCTION r700_set_visible()
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_azw05  LIKE azw_file.azw05

  SELECT azw05 INTO l_azw05 FROM azw_file WHERE azw01 = g_plant
  SELECT count(*) INTO l_cnt FROM azw_file
   WHERE azw05 = l_azw05

  IF l_cnt > 1 THEN
     CALL cl_set_comp_visible("group07",FALSE)
  END IF
  RETURN l_cnt
END FUNCTION

FUNCTION r700_chklegal(l_legal,n)
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
