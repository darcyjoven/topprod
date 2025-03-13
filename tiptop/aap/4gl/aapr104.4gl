# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapr104.4gl
# Descriptions...: 入庫金額明細表列印
# Date & Author..: 97/10/01  By  Felicity  Tseng
# Modify.........: no:7819 03/08/29 By Nicola:驗退顯示負值
# Modify.........: No:9567 04/05/18 By Kitty AP立帳金額約Line 265兩段sql不該都取apb21=rvv.rvv01
#                  應依rvu00 拆開,且不需做amt1=amt11-amt12
# Modify.........: No.FUN-4C0097 04/12/21 By Nicola 報表架構修改
#                                                   增加列印廠商編號rvu04、規格ima021
# Modify.........: No.MOD-510149 05/02/25 By Nicola 客戶若無收貨資料的倉退資料印不出
# Modify.........: No.FUN-550030 05/05/18 By ice 單據編號欄位放大
# Modify.........: No.FUN-560011 05/06/03 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-560089 05/06/21 By Smapmin 單位數量改抓計價單位計價數量
# Modify.........: No.FUN-570244 05/07/22 By jackie 料件編號欄位加CONTROLP
# Modify.........: No.FUN-580003 05/08/01 By jackie 雙單位報表修改
# Modify.........: No.MOD-5A0215 05/10/20 By Smapmin 組合sql段含有發票檔rvw_file,故需加上額外條件
# Modify.........: No.FUN-5B0013 05/11/01 By Rosayu 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.MOD-620032 06/02/14 By Smapmin 分次請款者,會造成ap請款單價double,改用AVG()
# Modify.........: NO.FUN-630043 06/03/14 By Melody 多工廠帳務中心功能修改
# Modify.........: No.TQC-650010 06/05/05 By Smapmin OUTER語法有誤
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.FUN-660117 06/06/16 By Rainy Char改為 Like
# Modify.........: No.FUN-660122 06/06/27 By Hellen cl_err --> cl_err3
# Modify.........: No.TQC-610053 06/07/03 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/30 By Jackho  本（原）幣取位修改
# Modify.........: No.TQC-740326 07/04/27 By dxfwo  排序第二、三個欄位未有默認值
# Modify.........: No.FUN-770093 07/10/09 By johnray 報表功能改為使用CR
# Modify.........: No.FUN-750117 08/03/26 By Sarah 1.增加INPUT選項allo_sw(分攤前/分攤後),misc(列印MISC料件)
#                                                  2.報表增加"異動類別"欄位,顯示中文對應說明
# Modify.........: No.MOD-840061 08/04/09 By Smapmin 僅改ora檔
# Modify.........: No.MOD-840069 08/04/14 By Smapmin 修改選擇AP立帳金額的單價與金額抓取方式
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT段漏了ON IDLE控制
# Modify.........: No.TQC-870027 08/07/17 By lumx  當選擇AP立賬金額的時候 增加排除里暫估的條件
# Modify.........: No.MOD-880112 08/08/14 By Sarah tm.amt_sw='2'段,組sql時條件apa00 MATCHES '1*',應改為apa00='11'
# Modify.........: No.MOD-880150 08/08/21 By Sarah aapr104_aqc_prep CURSOR的SQL,條件apb08=apb081取消,將apb03=aqc03改為apb02=aqc03
# Modify.........: No.MOD-8A0102 08/10/15 By Sarah 分攤金額變數沒清空,造成沒分攤的入庫單也會有分攤金額
# Modify.........: No.MOD-8B0089 08/11/07 By chenl 選擇AP立賬時，應排除作廢單據.
# Modify.........: No.MOD-8B0071 08/11/07 By Sarah 將MOD-870112修改段還原,rvu00='3'抓AP立帳金額時,需增加抓apa00='11'的資料
# Modify.........: No.MOD-920277 09/02/20 By Dido  由於後面會處理 rvu00 = '2','3' * -1 ,因此抓取 amt1,qty 時,直接取絕對值 
# Modify.........: No.FUN-940102 09/04/20 By dxfwo  新增使用者對營運中心的權限管控
# Modify.........: No.MOD-970217 09/07/23 By mike 將l_table改為宣告成STRING   
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9A0042 09/10/09 By mike l_table里增加azi03,azi04,azi05等栏位,请依每一笔资料的币别抓取取位的小数位数       
# Modify.........: No:MOD-9C0067 09/12/07 By wujie 排除退料 
# Modify.........: No.FUN-9C0077 10/01/04 By baofei 程式精簡
# Modify.........: No.FUN-A10098 10/01/19 By chenls 拿掉plant 跨DB改為不跨DB aza53程序段拿掉
# Modify.........: No.CHI-A40017 10/04/22 By liuxqa 修正MOD-AC0067 
# Modify.........: No:CHI-A40041 10/05/04 By Summer 增加 rvu01 可以開窗
# Modify.........: No.FUN-A60056 10/06/21 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No:CHI-B30020 11/04/01 By Dido 增加傳遞原幣與本幣金額至報表
# Modify.........: No:MOD-B60246 11/06/30 By Dido 若為11類且有倉退單時,金額不須再乘-1
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.MOD-BA0019 11/10/11 By Polly aapr104_aqc_prep排除作廢的單據aqaconf <> 'X'，不能納入計算
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題
# Modify.........: No.FUN-BB0002 11/01/11 By pauline rvb22無資料時進入取rvv22
# Modify.........: No.TQC-C70053 12/07/09 By lujh 報表數據會將VMI存儲倉的採購入庫單號也抓出來，VMI存儲倉的採購入庫單是無需進行結算的，不用在此報表中抓出，請過濾
# Modify.........: No.MOD-C70140 12/07/11 By yinhy 排除rvv89為Y的資料
# Modify.........: No.MOD-CB0010 12/11/01 By yinhy 修正sql語句
# Modify.........: No.MOD-CB0018 12/11/02 By yinhy 驗退,倉退單據，勾選收料金額時，數量和金額應為負值

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
  DEFINE g_seq_item     LIKE type_file.num5        # No.FUN-690028 SMALLINT
END GLOBALS
 
   DEFINE tm  RECORD
              wc      LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(600)
              misc    LIKE type_file.chr1,    #FUN-750117 add
              amt_sw  LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
              LC_sw   LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
              allo_sw LIKE type_file.chr1,    #FUN-750117 add
              s       LIKE type_file.chr3,    # No.FUN-690028 VARCHAR(3),  
              t,u     LIKE type_file.chr3,    # No.FUN-690028
              more    LIKE type_file.chr1     # No.FUN-690028 VARCHAR(1)
              END RECORD,
          g_orderA    ARRAY[3] OF LIKE zaa_file.zaa08      # No.FUN-690028 VARCHAR(16)     #No.FUN-550030
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
DEFINE   g_sma115        LIKE sma_file.sma115
#No.FUN-A10098 -----mark start
#DEFINE source    LIKE azp_file.azp01  #FUN-630043    #FUN-660117
#DEFINE g_azp02   LIKE azp_file.azp02  #FUN-630043
#No.FUN-A10098 -----mark end
DEFINE g_sql     STRING
DEFINE l_table STRING #MOD-970217                    
DEFINE g_str     STRING
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055  #FUN-BB0047
   LET g_sql = "rvu00.rvu_file.rvu00,  rvu01.rvu_file.rvu01,",
               "rvu03.rvu_file.rvu03,  rvu04.rvu_file.rvu04,",
               "rvv31.rvv_file.rvv31,  rvb22.rvb_file.rvb22,",
               "pmc03.pmc_file.pmc03,  rvv031.rvv_file.rvv031,",
               "ima021.ima_file.ima021,l_str.type_file.chr1000,",
               "rvv87.rvv_file.rvv87,  rvv86.rvv_file.rvv86,",
               "rvv38.rvv_file.rvv38,  rvv39f.rvv_file.rvv39,", #CHI-B30020 add rvv39f
               "rvv39.rvv_file.rvv39,",                       
               "aqc_amt.aqc_file.aqc06,alow.type_file.chr1,",   #FUN-750117 add aqc_amt
               "pmm22.pmm_file.pmm22,  azi05.azi_file.azi05,",
               "azi03.azi_file.azi03,  azi04.azi_file.azi04" #MOD-9A0042   
   LET l_table = cl_prt_temptable('aapr104',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"   #FUN-750117 add ? #MOD-9A0042 add ?? #CHI-B30020 add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047
   LET g_pdate    = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom   = ARG_VAL(2)
   LET g_rlang    = ARG_VAL(3)
   LET g_bgjob    = ARG_VAL(4)
   LET g_prtway   = ARG_VAL(5)
   LET g_copies   = ARG_VAL(6)
   LET tm.wc      = ARG_VAL(7)
   LET tm.misc    = ARG_VAL(8)    #FUN-750117 add
   LET tm.amt_sw  = ARG_VAL(9)
   LET tm.LC_sw   = ARG_VAL(10)
   LET tm.allo_sw = ARG_VAL(11)   #FUN-750117 add
   LET tm.s       = ARG_VAL(12)
   LET tm.t       = ARG_VAL(13)
   LET tm.u       = ARG_VAL(14)
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   LET g_rpt_name = ARG_VAL(18)  #No.FUN-7C0078
 
   DROP TABLE curr_tmp
  CREATE TEMP TABLE curr_tmp(
     curr    LIKE azi_file.azi01,
     amt     LIKE type_file.num20_6,
     order1  LIKE rvv_file.rvv31,
     order2  LIKE rvv_file.rvv31,
     order3  LIKE rvv_file.rvv31);

   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL aapr104_tm(0,0)                     # Input print condition
   ELSE
      CALL aapr104()                           # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
END MAIN
 
FUNCTION aapr104_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
   DEFINE li_result    LIKE type_file.num5    #No.FUN-940102 
 
   LET p_row = 2 LET p_col = 18
   OPEN WINDOW aapr104_w AT p_row,p_col
     WITH FORM "aap/42f/aapr104"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   LET tm.s      = '123'    #No.TQC-740326                                             
   LET tm.amt_sw = '1'
   LET tm.LC_sw  = '3'
   LET tm.allo_sw= '1'      #FUN-750117 add
   LET tm.misc   = 'N'      #FUN-750117 add
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
   #genero版本default 排序,跳頁,合計值
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
 
   WHILE TRUE
#No.FUN-A10098 -----mark start
#      LET source=g_plant 
#      LET g_azp02=''
#      DISPLAY BY NAME source
#      SELECT azp02 INTO g_azp02 FROM azp_file WHERE azp01=source
#      DISPLAY g_azp02 TO FORMONLY.azp02
#      LET g_plant_new=source
#      CALL s_getdbs()
#      IF g_aza.aza53='Y' THEN
#         INPUT BY NAME source WITHOUT DEFAULTS
#            AFTER FIELD source 
#               LET g_azp02=''
#               SELECT azp02 INTO g_azp02 FROM azp_file
#                  WHERE azp01=source
#               IF STATUS THEN
#                  CALL cl_err3("sel","azp_file",source,"","100","","",0)  #No.FUN-660122
#                  NEXT FIELD source
#               END IF
#               DISPLAY g_azp02 TO FORMONLY.azp02
#               CALL s_chk_demo(g_user,source) RETURNING li_result                                                                   
#                 IF not li_result THEN                                                                                              
#                    NEXT FIELD source                                                                                               
#                 END IF                                                                                                             
#               LET g_plant_new=source
#               CALL s_getdbs()
# 
#            AFTER INPUT
#               IF INT_FLAG THEN EXIT INPUT END IF  
# 
#            ON ACTION CONTROLP
#               CASE
#                  WHEN INFIELD(source)
#                       CALL cl_init_qry_var()
#                       LET g_qryparam.form = "q_zxy"     #No.FUN-940102                                                             
#                       LET g_qryparam.arg1 = g_user      #No.FUN-940102
#                       LET g_qryparam.default1 = source
#                       CALL cl_create_qry() RETURNING source 
#                       DISPLAY BY NAME source
#                       NEXT FIELD source
#               END CASE
# 
#            ON ACTION exit              #加離開功能genero
#               LET INT_FLAG = 1
#               EXIT INPUT
# 
#            ON ACTION controlg       #TQC-860021
#               CALL cl_cmdask()      #TQC-860021
# 
#            ON IDLE g_idle_seconds   #TQC-860021
#               CALL cl_on_idle()     #TQC-860021
#               CONTINUE INPUT        #TQC-860021
# 
#            ON ACTION about          #TQC-860021
#               CALL cl_about()       #TQC-860021
# 
#            ON ACTION help           #TQC-860021
#               CALL cl_show_help()   #TQC-860021
#         END INPUT
#         IF INT_FLAG THEN
#            LET INT_FLAG = 0 
#            CLOSE WINDOW r104_w 
#            EXIT PROGRAM
#         END IF
#      END IF
#No.FUN-A10098 -----mark end
 
      CONSTRUCT BY NAME tm.wc ON rvu00,rvu01,rvu03,rvu04,rvv31,rvu08,rvb22
 
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
         ON ACTION locale
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
 
      ON ACTION CONTROLP
            CASE    #CHI-A40041 add
            #IF INFIELD(rvv31) THEN  #CHI-A40041 mark
               WHEN INFIELD(rvv31)   #料件編號  #CHI-A40041
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rvv31
                  NEXT FIELD rvv31
               #CHI-A40041 add --start--
               WHEN INFIELD(rvu01)   #入庫單號/退貨單號
                  CALL cl_init_qry_var()
                  #LET g_qryparam.form = 'q_rvu01_2'      #TQC-C70053  mark
                  LET g_qryparam.form = 'q_rvu01_4'       #TQC-C70053  add
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rvu01
                  NEXT FIELD rvu01
               WHEN INFIELD(rvu04)   #廠商編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_rvu04'
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rvu04
                  NEXT FIELD rvu04
               WHEN INFIELD(rvu08)   #採購性質
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_rvu08'
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rvu08
                  NEXT FIELD rvu08
               WHEN INFIELD(rvb22)   #發票號碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_rvb2'
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rvb22
                  NEXT FIELD rvb22
               #CHI-A40041 add --end--
            #END IF   #CHI-A40041 mark
            END CASE  #CHI-A40041 add
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
         CLOSE WINDOW aapr104_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.misc,tm.amt_sw,tm.LC_sw,tm.allo_sw,   #FUN-750117 add tm.misc,tm.allo_sw
                    tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,
                    tm2.u1,tm2.u2,tm2.u3,tm.more WITHOUT DEFAULTS
 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
         AFTER FIELD misc      #列印MISC料件
            IF tm.misc IS NULL OR tm.misc NOT MATCHES "[YN]" THEN
               NEXT FIELD misc
            END IF
 
         AFTER FIELD amt_sw    #收料金額/AP立帳金額
            IF tm.amt_sw IS NULL OR tm.amt_sw NOT MATCHES "[12]" THEN
               NEXT FIELD amt_sw
            END IF
 
         AFTER FIELD LC_sw     #非LC類/LC類/全部
            IF tm.LC_sw IS NULL OR tm.LC_sw NOT MATCHES "[123]" THEN
               NEXT FIELD LC_sw
            END IF
 
         AFTER FIELD allo_sw   #分攤前/分攤後
            IF tm.allo_sw IS NULL OR tm.allo_sw NOT MATCHES "[12]" THEN
               NEXT FIELD allo_sw
            END IF
 
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
         LET INT_FLAG = 0
         CLOSE WINDOW aapr104_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aapr104'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr104','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'" ,
                            " '",tm.misc CLIPPED,"'" ,      #FUN-750117 add
                            " '",tm.amt_sw CLIPPED,"'" ,
                            " '",tm.LC_sw CLIPPED,"'" ,
                            " '",tm.allo_sw CLIPPED,"'" ,   #FUN-750117 add
                            " '",tm.s CLIPPED,"'" ,
                            " '",tm.t CLIPPED,"'" ,
                            " '",tm.u CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aapr104',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW aapr104_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL aapr104()
      ERROR ""
 
   END WHILE
   CLOSE WINDOW aapr104_w
 
END FUNCTION
 
FUNCTION aapr104()
   DEFINE l_name    LIKE type_file.chr20,             # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
          l_sql     LIKE type_file.chr1000,           # RDSQL STATEMENT  #No.FUN-690028 VARCHAR(1200)
          l_chr     LIKE type_file.chr1,              # No.FUN-690028 VARCHAR(1)
          l_order   ARRAY[5] OF LIKE rvv_file.rvv31,  # No.FUN-690028 VARCHAR(40),  #FUN-560011
          i,j,k     LIKE type_file.num5,              # No.FUN-690028 SMALLINT
          amtf      LIKE apb_file.apb24,              #CHI-B30020
          amt1,amt11,amt12 LIKE apb_file.apb10,
          amt2      LIKE apb_file.apb08,   #MOD-840069
          qty1      LIKE apb_file.apb09,   #MOD-840069
          rvu       RECORD LIKE rvu_file.*,
          rvv       RECORD LIKE rvv_file.*,
          sr        RECORD
                       order1  LIKE rvv_file.rvv31,      # No.FUN-690028 VARCHAR(40),  #FUN-560011
                       order2  LIKE rvv_file.rvv31,      # No.FUN-690028 VARCHAR(40),  #FUN-560011
                       order3  LIKE rvv_file.rvv31,      # No.FUN-690028 VARCHAR(40),  #FUN-560011
                       rva04   LIKE rva_file.rva04,
                       rvb22   LIKE rvb_file.rvb22,
                       rvw05   LIKE rvw_file.rvw05,
                       pmc03   LIKE pmc_file.pmc03,
                       pmm22   LIKE pmm_file.pmm22,
                       ima021  LIKE ima_file.ima021,
                       rvv80   LIKE rvv_file.rvv80,               #FUN-580003
                       rvv82   LIKE rvv_file.rvv82,               #FUN-580003
                       rvv83   LIKE rvv_file.rvv83,               #FUN-580003
                       rvv85   LIKE rvv_file.rvv85                #FUN-580003
                    END RECORD
   DEFINE l_i,l_cnt          LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE l_zaa02            LIKE zaa_file.zaa02
   DEFINE l_str              LIKE type_file.chr1000
   DEFINE alow               LIKE type_file.chr1
   DEFINE l_azi05            LIKE azi_file.azi05
   DEFINE l_azi03            LIKE azi_file.azi03 #MOD-9A0042                                                                        
   DEFINE l_azi04            LIKE azi_file.azi04 #MOD-9A0042   
   DEFINE l_ima906           LIKE ima_file.ima906
   DEFINE l_rvv85            STRING
   DEFINE l_rvv82            STRING
   DEFINE l_flag             LIKE type_file.chr1   #FUN-750117 add
   DEFINE l_aqc06            LIKE aqc_file.aqc06   #FUN-750117 add   #分攤前金額
   DEFINE l_aqc08            LIKE aqc_file.aqc08   #FUN-750117 add   #分攤後金額
   DEFINE l_aqc_amt          LIKE aqc_file.aqc06   #FUN-750117 add
   DEFINE l_azw01            LIKE azw_file.azw01   #FUN-A60056 
   DEFINE l_pmm42            LIKE pmm_file.pmm42   #CHI-B30020

   CALL cl_del_data(l_table)  #No.FUN-770093
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
 
   SELECT sma115 INTO g_sma115 FROM sma_file   #FUN-580003
 

   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rvuuser', 'rvugrup')
 
   DELETE FROM curr_tmp;
 
   LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 1 小計
             "  WHERE order1=? ",
             "  GROUP BY curr"
   PREPARE tmp1_pre FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('pre_1:',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE tmp1_cs CURSOR FOR tmp1_pre
 
   LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 2 小計
             "  WHERE order1=? ",
             "    AND order2=? ",
             "  GROUP BY curr  "
   PREPARE tmp2_pre FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('pre_2:',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE tmp2_cs CURSOR FOR tmp2_pre
 
   LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 3 小計
             "  WHERE order1=? ",
             "    AND order2=? ",
             "    AND order3=? ",
             "  GROUP BY curr  "
   PREPARE tmp3_pre FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('pre_3:',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE tmp3_cs CURSOR FOR tmp3_pre
 
#FUN-A60056--add--str--
   LET l_sql = "SELECT azw01 FROM azw_file ",
               " WHERE azwacti = 'Y'",
               "   AND azw02 = '",g_legal,"'"
   PREPARE sel_azw FROM l_sql
   DECLARE sel_azw_cs CURSOR FOR sel_azw
   FOREACH sel_azw_cs INTO l_azw01
#FUN-A60056--add--end
      LET l_sql = "SELECT rvu_file.*, rvv_file.*,",
                  "       '','','', rva04, rvb22, '', pmc03,'','',rvv80,rvv82,rvv83,rvv85 ",   #TQC-650010
#No.FUN-A10098 -----mark start
#               "  FROM ",g_dbs_new CLIPPED,"rvu_file",
#               " JOIN ",g_dbs_new CLIPPED,"rvv_file ON rvu01=rvv01 ",
#               " LEFT OUTER JOIN ",g_dbs_new CLIPPED,"rva_file ON rvv04=rva01 ",
#               " LEFT OUTER JOIN ",g_dbs_new CLIPPED,"rvb_file ON rvv04=rvb01 AND rvv05=rvb02 ",   #TQC-650010
#               " LEFT OUTER JOIN ",g_dbs_new CLIPPED,"pmc_file ON rvu04=pmc01 AND rvu00 ='2' ",   #No.MOD-9C0067
#No.FUN-A10098 -----mark end
#FUN-A60056--mod--str--
##No.FUN-A10098 -----add start
#                 "  FROM rvu_file",
#                 " JOIN rvv_file ON rvu01=rvv01 ",
#                 " LEFT OUTER JOIN rva_file ON rvv04=rva01 ",
#                 " LEFT OUTER JOIN rvb_file ON rvv04=rvb01 AND rvv05=rvb02 ",   #TQC-650010
#                 #" LEFT OUTER JOIN pmc_file ON rvu04=pmc01 AND rvu00 ='2' ",   #No.MOD-9C0067
#                 " LEFT OUTER JOIN pmc_file ON rvu04=pmc01 AND rvu00 <> '2' ",   #No.MOD-9C0067  #No.CHI-A40017 mod
##No.FUN-A10098 -----add end
                  " FROM ",cl_get_target_table(l_azw01,'rvu_file'), 
                  #" JOIN ",cl_get_target_table(l_azw01,'rvv_file')," ON rvu01=rvv01 ",                 #MOD-CB0010 mark
                  " JOIN ",cl_get_target_table(l_azw01,'rvv_file')," ON rvu01=rvv01 AND rvv89 !='Y' ",  #MOD-CB0010
                  #" LEFT OUTER JOIN ",cl_get_target_table(l_azw01,'rva_file')," ON rvv04=rva01 ",      #MOD-CB0010 mark
                  " LEFT OUTER JOIN ",cl_get_target_table(l_azw01,'rva_file')," ON rvv04=rva01 AND rva_file.rvaconf !='X' ",  #MOD-CB0010
                  " LEFT OUTER JOIN ",cl_get_target_table(l_azw01,'rvb_file')," ON rvv04=rvb01 AND rvv05=rvb02 ",
                  " LEFT OUTER JOIN pmc_file ON rvu04=pmc01 AND rvu00 <> '2' ",
#FUN-A60056--mod--end
                  #" WHERE rva_file.rvaconf !='X' ",      #MOD-CB0010 mark
                  #"   AND rvuconf !='X'",                #MOD-CB0010 mark
                  #"   AND rvv89 !='Y'",   #MOD-C70140    #MOD-CB0010 mark
                  "  WHERE rvuconf !='X'",                #MOD-CB0010
                  "   AND ",tm.wc  CLIPPED
      IF tm.misc = 'N' THEN   #列印MISC料件
         LET l_sql = l_sql,"   AND rvv31[1,4] !='MISC'"
      END IF
 
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      CALL cl_parse_qry_sql(l_sql,l_azw01) RETURNING l_sql   #FUN-A60056
      PREPARE aapr104_prepare1 FROM l_sql
      IF STATUS THEN
         CALL cl_err('prepare:',STATUS,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
      DECLARE aapr104_curs1 CURSOR FOR aapr104_prepare1
 
      LET g_pageno = 0
      FOREACH aapr104_curs1 INTO rvu.*,rvv.*,sr.*
         SELECT ima021 INTO sr.ima021 FROM ima_file
          WHERE ima01 = rvv.rvv31
     #FUN-BB0002 add START
         IF cl_null(sr.rvb22) THEN
            LET sr.rvb22 = rvv.rvv22
         END IF
     #FUN-BB0002 add END
         LET sr.rvw05 = 0
         SELECT rvw05 INTO sr.rvw05 FROM rvw_file
           WHERE rvw01=sr.rvb22 AND rvw08=rvv.rvv04 AND rvw09=rvv.rvv05
         IF sr.rvw05 IS NULL THEN
            LET sr.rvw05 = 0
         END IF
         IF sr.rva04 IS NULL THEN
            LET sr.rva04 = 'N'
         END IF
         IF tm.LC_sw='1' AND sr.rva04= 'Y' THEN
            CONTINUE FOREACH
         END IF
         IF tm.LC_sw='2' AND sr.rva04<>'Y' THEN
            CONTINUE FOREACH
         END IF
         IF tm.amt_sw='1' THEN      #1.收料金額
            #幣別
           #FUN-A60056--mod--str--
           #SELECT pmm22 INTO sr.pmm22 FROM pmm_file
           # WHERE pmm01 = rvv.rvv36
           IF cl_null(rvu.rvu114) THEN      #MOD-CB0018
              LET l_sql = "SELECT pmm22,pmm42 ",     #CHI-B30020 add pmm42
                          "  FROM ",cl_get_target_table(l_azw01,'pmm_file'), 
                          " WHERE pmm01 = '",rvv.rvv36,"'"
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql
              CALL cl_parse_qry_sql(l_sql,l_azw01) RETURNING l_sql
              PREPARE sel_pmm22 FROM l_sql
              EXECUTE sel_pmm22 INTO sr.pmm22,l_pmm42  #CHI-B30020 add l_pmm42
             #FUN-A60056--mod--end
              IF SQLCA.sqlcode THEN
                 LET sr.pmm22 = ''
              END IF
            END IF        #MOD-CB0018
            LET amtf = rvv.rvv39                      #CHI-B30020 
            IF cl_null(rvu.rvu114) THEN               #MOD-CB0018
               LET amt1 = rvv.rvv39 * l_pmm42            #CHI-B30020 
            ELSE                                      #MOD-CB0018
                 LET amt1 = rvv.rvv39 * rvu.rvu114      #MOD-CB0018
            END IF                                    #MOD-CB0018
            LET amt1 = cl_digcut(amt1,g_azi04)        #CHI-B30020 
         END IF
         IF tm.amt_sw='2' THEN        #2.AP立帳金額
            LET sr.pmm22 = g_aza.aza17       #本國幣別
            IF rvu.rvu00='1' THEN     #異動類別=1.入庫
               SELECT ABS(SUM(apb24)),ABS(SUM(apb10)),AVG(apb08),ABS(SUM(apb09)) INTO amtf,amt1,amt2,qty1 #TQC-620032   #MOD-840069  #MOD-920277 #CHI-B30020 add amtf 
                 FROM apa_file,apb_file  
                WHERE apa01=apb01
                  AND apa00 MATCHES '1*'   #MOD-880112 mark   #MOD-8B0071 mark回復
                  AND apa42 <> 'Y'         #No.MOD-8B0089
                  AND apb21=rvv.rvv01
                  AND apb22=rvv.rvv02
                  AND apb34= 'N'       #TQC-870027
               IF cl_null(amtf) THEN LET amtf = 0 END IF   #CHI-B30020
               IF cl_null(amt1) THEN LET amt1 = 0 END IF 
               IF cl_null(amt2) THEN LET amt2 = 0 END IF   #MOD-840069
               IF cl_null(qty1) THEN LET qty1 = 0 END IF   #MOD-840069
            ELSE
              #SELECT SUM(apb24),SUM(apb10),AVG(apb08),SUM(apb09) INTO amtf,amt1,amt2,qty1     #CHI-B30020 add amtf #MOD-B60246 mark 
               SELECT SUM(apb24)*-1,SUM(apb10)*-1,AVG(apb08),SUM(apb09)*-1 INTO amtf,amt1,amt2,qty1  #MOD-B60246  
                 FROM apa_file,apb_file   #TQC-620032   #MOD-840069
                WHERE apa01=apb01
                 #AND ((apa00 MATCHES '2*' AND apa58!='1') OR apa00 = '11')  #MOD-8B0071      #MOD-B60246 mark
                  AND apa00 MATCHES '2*' AND apa58!='1'                      #MOD-B60246 
                  AND apa42 <> 'Y'         #No.MOD-8B0089
                  AND apb21=rvv.rvv01
                  AND apb22=rvv.rvv02
                  AND apb34= 'N'       #TQC-870027
               IF cl_null(amtf) THEN LET amtf = 0 END IF   #CHI-B30020
               IF cl_null(amt1) THEN LET amt1 = 0 END IF
               IF cl_null(amt2) THEN LET amt2 = 0 END IF   #MOD-840069
               IF cl_null(qty1) THEN LET qty1 = 0 END IF   #MOD-840069
              #-MOD-B60246-add-
               IF amtf = 0 THEN
                  SELECT SUM(apb24),SUM(apb10),AVG(apb08),SUM(apb09) INTO amtf,amt1,amt2,qty1 
                    FROM apa_file,apb_file  
                   WHERE apa01=apb01
                     AND apa00 = '11'
                     AND apa42 <> 'Y'  
                     AND apb21=rvv.rvv01
                     AND apb22=rvv.rvv02
                     AND apb34= 'N' 
               END IF
              #-MOD-B60246-end-
            END IF

           #LET rvv.rvv39=amt1  #CHI-B30020 mark

            LET rvv.rvv38=amt2
            LET rvv.rvv87=qty1
            IF cl_null(rvv.rvv87) THEN
               LET rvv.rvv87 = 0
            END IF

         END IF
 
         IF tm.amt_sw='1' THEN      #No.MOD-CB0018
            #-MOD-B60246-mark-
            IF rvu.rvu00 MATCHES '[23]' THEN            #bugno:7819
               LET rvv.rvv87 = rvv.rvv87 * -1   #FUN-560089
              #LET rvv.rvv39 = rvv.rvv39 * -1   #CHI-B30020 mark
               LET amtf = amtf * -1             #CHI-B30020      
               LET amt1 = amt1 * -1             #CHI-B30020    
            END IF
            #-MOD-B60246-end-
         END IF                     #No.MOD-CB0018

         LET alow=' '
         IF rvu.rvu00 MATCHES '[23]' THEN
            IF rvu.rvu10='Y' THEN
               LET alow='Y'
            ELSE
               LET alow='N'
            END IF
         END IF
         IF cl_null(rvv.rvv031) THEN
            SELECT ima02 INTO rvv.rvv031 FROM ima_file
               WHERE ima01 = rvv.rvv31
            IF SQLCA.SQLCODE THEN
               LET rvv.rvv031 = ' '
            END IF
         END IF
 
         #單位使用方式(1.單一單位 2.母子單位 3.參考單位)
         SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=rvv.rvv31
         LET l_str = ""
         IF g_sma115 = "Y" THEN
            CASE l_ima906
               WHEN "2"
                   CALL cl_remove_zero(sr.rvv85) RETURNING l_rvv85
                   LET l_str = l_rvv85 , sr.rvv83 CLIPPED
                   IF cl_null(sr.rvv85) OR sr.rvv85 = 0 THEN
                       CALL cl_remove_zero(sr.rvv82) RETURNING l_rvv82
                       LET l_str = l_rvv82, sr.rvv80 CLIPPED
                   ELSE
                      IF NOT cl_null(sr.rvv82) AND sr.rvv82 > 0 THEN
                         CALL cl_remove_zero(sr.rvv82) RETURNING l_rvv82
                         LET l_str = l_str CLIPPED,',',l_rvv82, sr.rvv80 CLIPPED
                      END IF
                   END IF
               WHEN "3"
                   IF NOT cl_null(sr.rvv85) AND sr.rvv85 > 0 THEN
                       CALL cl_remove_zero(sr.rvv85) RETURNING l_rvv85
                       LET l_str = l_rvv85 , sr.rvv83 CLIPPED
                   END IF
            END CASE
         END IF
         #小計,總計小數位數
         IF cl_null(rvu.rvu02) THEN                                                                                                    
            SELECT azi03,azi04,azi05 INTO l_azi03,l_azi04,l_azi05 FROM azi_file,pmc_file WHERE azi01=pmc22 AND pmc01=rvu.rvu04         
         ELSE                                                                                                                          
           #FUN-A60056--mod--str--
           #SELECT azi03,azi04,azi05 INTO l_azi03,l_azi04,l_azi05 FROM azi_file,pmm_file WHERE azi01=pmm22 AND pmm01=rvv.rvv36         
            LET l_sql  = "SELECT azi03,azi04,azi05 ",
                         "  FROM ",cl_get_target_table(l_azw01,'azi_file'),",",
                         "       ",cl_get_target_table(l_azw01,'pmm_file'),
                         " WHERE azi01=pmm22 AND pmm01='",rvv.rvv36,"' " 
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,l_azw01) RETURNING l_sql
            PREPARE sel_azi_cs FROM l_sql
            EXECUTE sel_azi_cs INTO l_azi03,l_azi04,l_azi05              
           #FUN-A60056--mod--end
         END IF                                                                                                                        
         LET l_sql = "SELECT aqc06,aqc08 ",
#No.FUN-A10098 -----mark start
#                  "  FROM ",g_dbs_new CLIPPED,"apa_file,",
#                            g_dbs_new CLIPPED,"apb_file,",
#                            g_dbs_new CLIPPED,"aqc_file ",
#No.FUN-A10098 -----mark end
#No.FUN-A10098 -----add start
                   # "  FROM apa_file,apb_file,aqc_file ",           #MOD-BA0019 mark
#No.FUN-A10098 -----add end
                     "  FROM apa_file,apb_file,aqc_file,aqa_file ",  #MOD-BA0019 add
                     " WHERE apa01 = apb01 ",
                     "   AND apb21='",rvv.rvv01,"'",
                     "   AND apb22= ",rvv.rvv02,
                     "   AND (apb34 IS NULL OR apb34='N') ",
                     "   AND (apa00='11' OR (apa00='16' AND apb21 IS NOT NULL)) ",
                     "   AND apb01=aqc02 ",
                     "   AND apb02=aqc03 ",    #MOD-880150 mod apb03->apb02
                     "   AND aqa01 = aqc01 ",  #MOD-BA0019 add
                     "   AND aqaconf <> 'X' ", #MOD-BA0019 add                  
                     " ORDER BY aqc02,aqc03"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         PREPARE aapr104_aqc_prep FROM l_sql
         IF STATUS THEN
            CALL cl_err('aapr104_aqc_prep:',STATUS,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
            EXIT PROGRAM
         END IF
         DECLARE aapr104_aqc_cs CURSOR FOR aapr104_aqc_prep
 
         LET l_flag='N'
         FOREACH aapr104_aqc_cs INTO l_aqc06,l_aqc08
            LET l_flag='Y'
            LET l_aqc_amt = 0   #MOD-8A0102 add
            IF tm.allo_sw='1' THEN    #分攤前
               LET l_aqc_amt = l_aqc06
            ELSE                      #分攤後
               LET l_aqc_amt = l_aqc08
            END IF
            IF cl_null(l_aqc_amt) THEN LET l_aqc_amt = 0 END IF
            EXECUTE insert_prep USING 
               rvu.rvu00, rvu.rvu01, rvu.rvu03,  rvu.rvu04, rvv.rvv31,
               sr.rvb22,  sr.pmc03,  rvv.rvv031, sr.ima021, l_str,
              #rvv.rvv87, rvv.rvv86, rvv.rvv38,  rvv.rvv39, l_aqc_amt,   #FUN-750117 add l_aqc_amt #CHI-B30020 mark
               rvv.rvv87, rvv.rvv86, rvv.rvv38,  amtf,      amt1,        #CHI-B30020 add amtf,amt1
               alow,      sr.pmm22,  l_azi05,
               l_azi03,l_azi04 #MOD-9A0042       
         END FOREACH
         IF l_flag='N' THEN   #FUN-750117 add
            LET l_aqc_amt = 0   #MOD-8A0102 add
            EXECUTE insert_prep USING
               rvu.rvu00,rvu.rvu01,rvu.rvu03, rvu.rvu04,rvv.rvv31,
               sr.rvb22, sr.pmc03, rvv.rvv031,sr.ima021,l_str,
              #rvv.rvv87,rvv.rvv86,rvv.rvv38, rvv.rvv39,l_aqc_amt,   #FUN-750117 add l_aqc_amt #CHI-B30020 mark
               rvv.rvv87,rvv.rvv86,rvv.rvv38, amtf,     amt1,        #CHI-B30020 add amtf,amt1
               l_aqc_amt,alow,     sr.pmm22,  l_azi05,  l_azi03,     #FUN-750117 add l_aqc_amt
               l_azi04 #MOD-9A0042        
            IF STATUS THEN
               CALL cl_err("execute insert_prep:",STATUS,1)
               EXIT FOREACH
            END IF
         END IF               #FUN-750117 add
 
      END FOREACH
   END FOREACH   #FUN-A60056
      LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
      IF g_zz05='Y' THEN
         CALL cl_wcchp(tm.wc,'rvu00,rvu01,rvu03,rvu04,rvv31,rvu08,rvb22') RETURNING tm.wc
      ELSE
         LET tm.wc = ' '
      END IF
     #LET g_str = tm.wc,";",g_zz05,";",t_azi03,";",t_azi04,";",t_azi05,";",     #CHI-B30020 mark
      LET g_str = tm.wc,";",g_zz05,";",t_azi03,";",g_azi04,";",g_azi05,";",     #CHI-B30020
                  tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";",tm.u,";",
                  tm.allo_sw   #FUN-750117 add
 
      IF g_sma115 = "Y" THEN
         LET l_name = "aapr104"
      ELSE
         LET l_name = "aapr104_1"
      END IF
      CALL cl_prt_cs3('aapr104',l_name,g_sql,g_str)
     # CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055     #FUN-B80105
 
END FUNCTION
 
REPORT aapr104_rep(rvu,rvv,sr)
   DEFINE l_last_sw     LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          rvu           RECORD LIKE rvu_file.*,
          rvv           RECORD LIKE rvv_file.*,
          l_pmm22       LIKE pmm_file.pmm22,
          sr            RECORD
                           order1  LIKE rvv_file.rvv31,      # No.FUN-690028 VARCHAR(40),  #FUN-560011
                           order2  LIKE rvv_file.rvv31,      # No.FUN-690028 VARCHAR(40),  #FUN-560011
                           order3  LIKE rvv_file.rvv31,      # No.FUN-690028 VARCHAR(40),  #FUN-560011
                           rva04   LIKE rva_file.rva04,
                           rvb22   LIKE rvb_file.rvb22,
                           rvw05   LIKE rvw_file.rvw05,
                           pmc03   LIKE pmc_file.pmc03,
                           pmm22   LIKE pmm_file.pmm22,
                           ima021  LIKE ima_file.ima021,
                           rvv80   LIKE rvv_file.rvv80,      #FUN-580003
                           rvv82   LIKE rvv_file.rvv82,      #FUN-580003
                           rvv83   LIKE rvv_file.rvv83,      #FUN-580003
                           rvv85   LIKE rvv_file.rvv85       #FUN-580003
                        END RECORD,
          sr1           RECORD
                           curr    LIKE pmm_file.pmm22,
                           amt     LIKE rvv_file.rvv39
                        END RECORD,
          alow          LIKE rvu_file.rvu10,      # No.FUN-690028 VARCHAR(4),
          qty,up,amt    LIKE rvv_file.rvv39
   DEFINE g_head1        STRING
   DEFINE l_ima906      LIKE ima_file.ima906   #No.FUN-580003
   DEFINE l_str2        LIKE type_file.chr1000     # No.FUN-690028 VARCHAR(100)              #No.FUN-580003
   DEFINE l_rvv85        STRING                         #No.FUN-580003
   DEFINE l_rvv82        STRING                         #No.FUN-580003
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.order1,sr.order2,sr.order3
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         LET g_head1= g_x[9] CLIPPED,g_orderA[1] CLIPPED,
                      '-',g_orderA[2] CLIPPED,'-',g_orderA[3] CLIPPED
         PRINT g_head1
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
               g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44]   #No.FUN-580003
         PRINT g_dash1
         LET l_last_sw = 'n'
 
      BEFORE GROUP OF sr.order1
         IF tm.t[1,1] = 'Y' THEN
            SKIP TO TOP OF PAGE
         END IF
 
      BEFORE GROUP OF sr.order2
         IF tm.t[2,2] = 'Y' THEN
            SKIP TO TOP OF PAGE
         END IF
 
      BEFORE GROUP OF sr.order3
         IF tm.t[3,3] = 'Y' THEN
            SKIP TO TOP OF PAGE
         END IF
 
      ON EVERY ROW
         LET alow=' '
         IF rvu.rvu00 MATCHES '[23]' THEN
            IF rvu.rvu10='Y' THEN
               LET alow='Y'
            ELSE
               LET alow='N'
            END IF
         END IF
         IF cl_null(rvv.rvv031) THEN
            SELECT ima02 INTO rvv.rvv031 FROM ima_file
             WHERE ima01 = rvv.rvv31
            IF SQLCA.SQLCODE THEN
               LET rvv.rvv031 = ' '
            END IF
         END IF
 
      SELECT ima906 INTO l_ima906 FROM ima_file
                         WHERE ima01=rvv.rvv31
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr.rvv85) RETURNING l_rvv85
                LET l_str2 = l_rvv85 , sr.rvv83 CLIPPED
                IF cl_null(sr.rvv85) OR sr.rvv85 = 0 THEN
                    CALL cl_remove_zero(sr.rvv82) RETURNING l_rvv82
                    LET l_str2 = l_rvv82, sr.rvv80 CLIPPED
                ELSE
                   IF NOT cl_null(sr.rvv82) AND sr.rvv82 > 0 THEN
                      CALL cl_remove_zero(sr.rvv82) RETURNING l_rvv82
                      LET l_str2 = l_str2 CLIPPED,',',l_rvv82, sr.rvv80 CLIPPED
                   END IF
                END IF
            WHEN "3"
                IF NOT cl_null(sr.rvv85) AND sr.rvv85 > 0 THEN
                    CALL cl_remove_zero(sr.rvv85) RETURNING l_rvv85
                    LET l_str2 = l_rvv85 , sr.rvv83 CLIPPED
                END IF
         END CASE
      ELSE
      END IF
 
 
         PRINT COLUMN g_c[31],rvu.rvu00,
               COLUMN g_c[32],rvu.rvu01,
               COLUMN g_c[33],rvu.rvu04,
               COLUMN g_c[34],sr.pmc03,
               COLUMN g_c[35],rvv.rvv31 ClIPPED,  #No.FUN-580003 #FUN-5B0013 add
               COLUMN g_c[36],rvv.rvv031 CLIPPED, #FUN-5B0013 add CLIPPED
               COLUMN g_c[37],sr.ima021 CLIPPED,
               COLUMN g_c[38],l_str2 CLIPPED,   #No.FUN-580003
               COLUMN g_c[39],rvv.rvv87 USING '-----------.--&',   #FUN-560089
               COLUMN g_c[40],rvv.rvv86,   #FUN-560089
               COLUMN g_c[41],cl_numfor(rvv.rvv38,41,t_azi03),          #No.CHI-6A0004 g_azi-->t_azi
               COLUMN g_c[42],cl_numfor(rvv.rvv39,42,t_azi04),          #No.CHI-6A0004 g_azi-->t_azi
               COLUMN g_c[43],sr.rvb22,
               COLUMN g_c[44],alow
 
         INSERT INTO curr_tmp VALUES(sr.pmm22,rvv.rvv39,
                                     sr.order1,sr.order2,sr.order3)
 
      AFTER GROUP OF sr.order1
         IF tm.u[1,1] = 'Y' THEN
            PRINT
            LET amt=GROUP SUM(rvv.rvv39)
            PRINT COLUMN g_c[36],g_orderA[1] CLIPPED;
            FOREACH tmp1_cs USING sr.order1 INTO sr1.*
               SELECT azi05 INTO t_azi05 FROM azi_file     #No.CHI-6A0004 g_azi-->t_azi
                WHERE azi01 = sr1.curr
               PRINT COLUMN g_c[39],sr1.curr CLIPPED,COLUMN g_c[40],g_x[17] CLIPPED,
                     COLUMN g_c[41],cl_numfor(sr1.amt,41,t_azi05) CLIPPED #No.CHI-6A0004 g_azi-->t_azi
            END FOREACH
            PRINT
         END IF
 
      AFTER GROUP OF sr.order2
         IF tm.u[2,2] = 'Y' THEN
            PRINT
            LET amt=GROUP SUM(rvv.rvv39)
            PRINT COLUMN g_c[36],g_orderA[1] CLIPPED;
            FOREACH tmp2_cs USING sr.order1,sr.order2 INTO sr1.*
               SELECT azi05 INTO t_azi05 FROM azi_file   #No.CHI-6A0004 g_azi-->t_azi
                WHERE azi01 = sr1.curr
               PRINT COLUMN g_c[39],sr1.curr CLIPPED,COLUMN g_c[40],g_x[17] CLIPPED,
                     COLUMN g_c[41],cl_numfor(sr1.amt,41,t_azi05) CLIPPED          #No.CHI-6A0004 g_azi-->t_azi
            END FOREACH
            PRINT
         END IF
 
      AFTER GROUP OF sr.order3
         IF tm.u[3,3] = 'Y' THEN
            PRINT
            LET amt=GROUP SUM(rvv.rvv39)
            PRINT COLUMN g_c[36],g_orderA[1] CLIPPED;
            FOREACH tmp3_cs USING sr.order1,sr.order2,sr.order3 INTO sr1.*
               SELECT azi05 INTO t_azi05 FROM azi_file   #No.CHI-6A0004 g_azi-->t_azi
                WHERE azi01 = sr1.curr
               PRINT COLUMN g_c[39],sr1.curr CLIPPED,COLUMN g_c[40],g_x[17] CLIPPED,
                     COLUMN g_c[41],cl_numfor(sr1.amt,41,t_azi05) CLIPPED     #No.CHI-6A0004 g_azi-->t_azi
            END FOREACH
            PRINT
         END IF
 
      ON LAST ROW
         PRINT g_dash[1,g_len]
         LET l_last_sw = 'y'
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED #No.FUN-580003
 
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED,
                  COLUMN (g_len-9),g_x[6] CLIPPED   #No.FUN-580003
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT
#No.FUN-9C0077 程式精簡
