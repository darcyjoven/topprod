# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcr760.4gl
# Descriptions...: 銷貨出庫成本月報(新)
# Date & Author..: 01/04/09 By Ostrich
# Modify ........: No:8741 報表列印格式調整
# Modify.........: No.MOD-490321 By Kammy 印製時 ima02 只印12碼，字數較多就會
#                                         導致整張報表無法 view
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.MOD-530794 05/03/29 By wujie   對齊欄位
# Modify.........: No.FUN-550025 05/05/19 By elva 單據編號格式放大
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-570190 05/08/08 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.MOD-570078 05/07/05 By kim 沒有進行單位換算(tlf10->tlf10*tlf60)
# Modify.........: No.FUN-570262 05/10/13 By Rosayu axcr760和axcr761銷貨金額不一致
# Modify.........: NO.FUN-5B0015 05/11/02 BY yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: NO.TQC-5B0019 05/11/08 By Sarah 變更p_zz的報表寬度,但列印出來的g_dash,g_dash2長度沒有改變
# Modify.........: No.FUN-5B0082 05/11/16 By Sarah 報表少印"其他"欄位
# Modify.........: No.FUN-5B0123 05/12/08 By Sarah 應排除出至境外倉部份(add oga00<>'3')
# Modify.........: No.TQC-610051 06/02/23 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680122 06/09/19 By yjkhero 類型轉換  
# Modify.........: No.TQC-680047 06/09/20 By Claire 排除作廢單據
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Hellen 本原幣取位修改
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-660073 06/12/08 By Nicola 訂單樣品修改
# Modify.........: No.CHI-690007 06/01/05 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.MOD-710127 07/01/23 By jamie DEFINE段的順序amt04,amt05與l_sql的順序不一致
# Modify.........: No.MOD-720042 07/02/26 By TSD.Jin 報表改為CR且明細(tm.a)功能有用
# Modify.........: No.FUN-710080 07/04/02 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.MOD-780262 07/10/30 By Pengu 出貨時若為多倉儲出貨，則銷貨金額會重複
# Modify.........: No.MOD-7B0167 07/11/30 By Carol 調整ora ->azf08有OUTER
# Modify.........: No.FUN-7C0101 08/01/24 By shiwuying 成本改善，CR增加類別編號tlfccost
# Modify.........: No.FUN-830002 08/03/06 By Cockroach l_sql增加tlf_file與tlfc_file關聯字段 
# Modify.........: No.FUN-840173 08/06/09 By Sherrt 可選擇印出樣品銷貨
# Modify.........: No.MOD-880256 08/09/01 By Pengu 調整出入庫的判斷邏輯
# Modify.........: No.MOD-8A0162 08/10/17 By chenl 增加sql條件，azf02='G'
# Modify.........: No.MOD-8A0273 08/11/20 By chenl 修正sql條件，azf02='2'
# Modify.........: No.MOD-920106 09/02/07 By claire OUTER azf_file語法錯誤
# Modify.........: No.CHI-930028 09/03/13 By shiwuying 取消程式段有做tlf021[1,4]或tlf031[1,4]的程式碼改成不做只取前4碼的限制
# Modify.........: No.MOD-940269 09/05/21 By Pengu 應排除出至境外倉的單據資料
# Modify.........: No.MOD-950210 09/05/26 By Pengu “寄銷出貨”不應納入 “銷貨收入
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0073 10/01/12 By chenls 程序精簡
# Modify.........: No.FUN-A30044 10/03/11 By vealxu 新增列印銷退入庫成本checkbox欄位
# Modify.........: No:MOD-A40041 10/04/13 By Summer LET sr.amt06= sr.amt07 * -1應該為LET sr.amt06= sr.amt06 * -1 
# Modify.........: No:TQC-A40139 10/04/29 By Carrier 1.追单MOD-9A0184/MOD-980250
# Modify.........: No:FUN-9B0017 10/08/23 By chenmoyan 銷貨收入要將aglt700的遞延收入納入計算
# Modify.........: NO.FUN-A60007 10/08/27 by chenmoyan oct_file加入帳別
# Modify.........: No:MOD-9C0373 10/11/26 By sabrina 多倉儲出貨時，銷貨成本歸在第一筆
# Modify.........: No:MOD-AC0102 10/12/13 By sabrina 排除oga65='Y'的資料
# Modify.........: No:CHI-B60079 11/06/29 By Vampire 將 ima2_file 註解
# Modify.........: No:MOD-C20208 12/02/24 By ck2yuan 若wticket為NULL，就再撈oma_file串oha_file
# Modify.........: No:MOD-C20181 12/02/27 By yinhy 大陸版本報表格式選擇一般時異動數及金額欄位更改
# Modify.........: No:CHI-C50069 12/06/26 By Sakura 原"列印樣品銷貨"欄位改用RadioBox(1.一般出貨,2.樣品出貨,3.全部)
# Modify.........: No:CHI-C30012 12/07/30 By bart 金額取位改抓ccz26
# Modify.........: No:FUN-C80088 12/11/08 By bart QBE增加欄位"訂單部門(oea15)
# Modify.........: No:FUN-CB0031 12/11/07 By wujie 走开票流程的时候,排除出货单到发票仓的tlf资料，开票金额按axmt670的金额来计算
# Modify.........: No:MOD-CB0215 12/11/22 By wujie 考虑开票流程，不纳入成本计算的情况 
# Modify.........: No:FUN-C80092 12/12/07 By fengrui 打印樣品銷貨欄位給預設值'N'
# Modify.........: No:MOD-D10160 13/01/17 By bart 總金額的正負是相反的
# Modify.........: No:MOD-D10246 13/01/28 By wujie 启用发出商品纳入成本计算参数时，凭证编号从axmt670抓
# Modify.........: No:CHI-A70023 13/01/30 By Alberti 調整成品替代的銷貨收入

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           #wc      LIKE type_file.chr1000, #No.FUN-680122 VARCHAR(300) #FUN-C80088
           wc      STRING,  #FUN-C80088
           bdate   LIKE type_file.dat,     #No.FUN-680122 DATE
           edate   LIKE type_file.dat,     #No.FUN-680122 DATE
           type    LIKE tlfc_file.tlfctype,#No.FUN-7C0101 add
           a       LIKE type_file.chr1,    #No.FUN-680122 VARCHAR(1)
           b       LIKE type_file.chr1,    #No.FUN-840173
           c       LIKE type_file.chr1,    #No.FUN-A30044 VARCHAR(1)
           g       LIKE type_file.chr1,    #No.FUN-680122 VARCHAR(1)
           more    LIKE type_file.chr1     #No.FUN-680122 VARCHAR(1)
           END RECORD
DEFINE   g_i       LIKE type_file.num5     #count/index for any purpose #No.FUN-680122 SMALLINT
 
DEFINE l_table     STRING
DEFINE g_sql       STRING
DEFINE g_str       STRING
 
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
               "tlfccost.tlfc_file.tlfccost,",    #No.FUN-7C0101 add
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
               "wsaleamt.omb_file.omb16,",
               "warea_name.oab_file.oab02,",  
               "l_azf03.azf_file.azf03,",
               "wocc02.occ_file.occ02,",   
               "wticket.oma_file.oma33,",  
               "wima202.ima_file.ima131,",
               "l_wsale_tlf21.tlf_file.tlf21,",
               "ccz27.ccz_file.ccz27,",
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,",
               "gem01.gem_file.gem01,",  #FUN-C80088
               "gem02.gem_file.gem02 "   #FUN-C80088
 
   LET l_table = cl_prt_temptable('axcr760',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?, ",                                #No.FUN-830002 ADD      
               "        ?,?,?,?,?, ?,?,?,?,?) "  #FUN-C80088
 
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
   LET tm.type=ARG_VAL(15)  #No.FUN-7C0101 add
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.a = ARG_VAL(10)
   LET tm.g = ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   IF cl_null(g_bgjob) or g_bgjob = 'N'
      THEN CALL axcr760_tm(0,0)
      ELSE CALL axcr760()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr760_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01    #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,   #No.FUN-680122     SMALLINT
          l_flag      LIKE type_file.chr1,   #No.FUN-680122     VARCHAR(01)
          l_bdate,l_edate   LIKE type_file.dat,     #No.FUN-680122 DATE
          l_cmd       LIKE type_file.chr1000 #No.FUN-680122     VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 20
   ELSE LET p_row = 5 LET p_col = 15
   END IF
   OPEN WINDOW axcr760_w AT p_row,p_col
        WITH FORM "axc/42f/axcr760"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   CALL s_azm(g_ccz.ccz01,g_ccz.ccz02)
    RETURNING l_flag,l_bdate,l_edate
   INITIALIZE tm.* TO NULL
   LET tm.bdate= l_bdate
   LET tm.edate= l_edate
   LET tm.type = g_ccz.ccz28  #No.FUN-7C0101 add
   LET tm.a   = 'N'
   LET tm.b   = 'N' #FUN-840173     #CHI-C50069 mark  #FUN-C80092 remark
  #LET tm.b   = '3' #CHI-C50069 add #FUN-C80092 mark
   LET tm.c   = 'N' #FUN-A30044
   LET tm.g    ='1'
   LET tm.more= 'N'
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'
 
 WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ima12,ima01 ,tlf905 ,tlf19,oea15 #FUN-C80088
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
        #FUN-C80088---begin
        IF INFIELD(oea15) THEN 
           CALL cl_init_qry_var()
           LET g_qryparam.state = "c"
           LET g_qryparam.form ="q_gem"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO oea15
           NEXT FIELD oea15
        END IF
        #FUN-C80088---end
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr760_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.bdate,tm.edate,tm.type,tm.a,tm.c,tm.b,tm.g, tm.more  #No.FUN-7C0101 add tm.type #FUN-840173 #No.FUN-A30044 add tm.c
      WITHOUT DEFAULTS
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD bdate
        IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
      AFTER FIELD edate
        IF cl_null(tm.edate) OR tm.edate<tm.bdate THEN NEXT FIELD edate END IF
      AFTER FIELD g
         IF tm.g NOT MATCHES '[1234]' THEN  #FUN-C80088
            NEXT FIELD g
         END IF
      AFTER FIELD type                                               #No.FUN-7C0101
         IF tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF#No.FUN-7C0101

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
      LET INT_FLAG = 0 CLOSE WINDOW axcr760_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr760'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr760','9031',1)   
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
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
         CALL cl_cmdat('axcr760',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr760_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr760()
   ERROR ""
 END WHILE
 CLOSE WINDOW axcr760_w
END FUNCTION
 
FUNCTION axcr760()
   DEFINE l_name    LIKE type_file.chr20,    # External(Disk) file name       #No.FUN-680122 VARCHAR(20)
#         l_sql     LIKE type_file.chr1000,  # RDSQL STATEMENT   #No.FUN-680122 VARCHAR(600) #FUN-9B0017 mark
          l_sql     STRING,                  #FUN-9B0017
          l_chr     LIKE type_file.chr1,     #No.FUN-680122      VARCHAR(1),
          l_za05    LIKE za_file.za05        #No.FUN-680122      VARCHAR(40)
  DEFINE wima201    LIKE type_file.chr2      #No.FUN-680122      VARCHAR( 2)
  DEFINE warea      LIKE oga_file.oga25      #No.FUN-680122      VARCHAR( 4)
  DEFINE warea_name LIKE oab_file.oab02,     #No.FUN-680122      VARCHAR(10)  
    sr  RECORD
        ima12  LIKE ima_file.ima12,
        ima01  LIKE ima_file.ima01,
        ima02  LIKE ima_file.ima02,
        ima06  LIKE ima_file.ima06,
        tlfccost LIKE tlfc_file.tlfccost,   #No.FUN-7C0101 add
        tlf02  LIKE tlf_file.tlf02,
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
        tlfc21 LIKE tlfc_file.tlfc21,      #No.FUN-7C0101
        tlf13  LIKE tlf_file.tlf13,
        tlf905 LIKE tlf_file.tlf905,
        tlf906 LIKE tlf_file.tlf906,
        tlf19  LIKE tlf_file.tlf19 ,
        tlf907 LIKE tlf_file.tlf907,
        amt01  LIKE tlfc_file.tlfc221,    #材料金額   #No.FUN-7C0101 
        amt02  LIKE tlfc_file.tlfc222,    #人工金額   #No.FUN-7C0101 
        amt03  LIKE tlfc_file.tlfc2231,   #製造費用   #No.FUN-7C0101 
        amt_d  LIKE tlfc_file.tlfc2232,   #委外加工費 #No.FUN-7C0101 
        amt05  LIKE tlfc_file.tlfc224,    #其他金額   #FUN-5B0082   #MOD-710127 mod   #No.FUN-7C0101
        amt06  LIKE tlfc_file.tlfc2241,   #No.FUN-7C0101 add
        amt07  LIKE tlfc_file.tlfc2242,   #No.FUN-7C0101 add
        amt08  LIKE tlfc_file.tlfc2243,   #No.FUN-7C0101 add
        amt04  LIKE ccc_file.ccc23  ,   #總金額
        wsaleamt  LIKE omb_file.omb16   #No.FUN-680122  decimal( 15,3)
          END RECORD
   DEFINE   wtlf01  LIKE type_file.chr3    #No.FUN-680122  VARCHAR(3)
   DEFINE l_tlf905 LIKE tlf_file.tlf905       #No.MOD-780262 add
   DEFINE l_tlf906 LIKE tlf_file.tlf906       #No.MOD-780262 add
   DEFINE l_tlf905_1 LIKE tlf_file.tlf905       #No:MOD-9C0373 add
   DEFINE l_tlf906_1 LIKE tlf_file.tlf906       #No:MOD-9C0373 add
   DEFINE l_azf03       LIKE azf_file.azf03
   DEFINE wocc02        LIKE occ_file.occ02   
   DEFINE wticket       LIKE oma_file.oma33  
   DEFINE wima202       LIKE ima_file.ima131
   DEFINE l_wima201     LIKE tlf_file.tlf01
   DEFINE l_wsale_tlf21 LIKE tlf_file.tlf21
   DEFINE l_tlf14    LIKE tlf_file.tlf14     #FUN-840173
   DEFINE l_tlf66    LIKE tlf_file.tlf66     #No:CHI-A70023 add
   DEFINE l_tlf902   LIKE tlf_file.tlf902    #CHI-A70023 add
   DEFINE l_tlf903   LIKE tlf_file.tlf903    #CHI-A70023 add
   DEFINE l_tlf904   LIKE tlf_file.tlf904    #CHI-A70023 add
   DEFINE l_oga00    LIKE oga_file.oga00     #No.MOD-940269 add
   DEFINE l_oga65    LIKE oga_file.oga65     #No:MOD-AC0102 add
   DEFINE l_azf08    LIKE azf_file.azf08     #FUN-840173
   DEFINE l_oct12    LIKE oct_file.oct12     #FUN-9B0017
   DEFINE l_oct14    LIKE oct_file.oct14     #FUN-9B0017
   DEFINE l_oct15    LIKE oct_file.oct15     #FUN-9B0017
   DEFINE l_byear    LIKE type_file.num5     #FUN-9B0017
   DEFINE l_bmonth   LIKE type_file.num5     #FUN-9B0017
   DEFINE l_bdate    LIKE type_file.num10    #FUN-9B0017
   DEFINE l_eyear    LIKE type_file.num5     #FUN-9B0017
   DEFINE l_emonth   LIKE type_file.num5     #FUN-9B0017
   DEFINE l_edate    LIKE type_file.num10    #FUN-9B0017
   DEFINE l_omb38    LIKE omb_file.omb38     #FUN-9B0017
   DEFINE l_wc       STRING  #FUN-C80088
   DEFINE l_gem01    LIKE gem_file.gem01     #FUN-C80088
   DEFINE l_gem02    LIKE gem_file.gem02     #FUN-C80088
   DEFINE l_sql1     STRING                  #No.FUN-CB0031
   
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> *** ##
   CALL cl_del_data(l_table)
     SELECT * INTO g_oaz.* FROM oaz_file     #No.FUN-CB0031
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axcr760'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 207 END IF  #No.FUN-550025
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     FOR g_i = 1 TO g_len LET g_dash2[g_i,g_i] = '-' END FOR

     #FUN-C80088---begin
     CALL cl_replace_str(tm.wc,'oea15','oga15') RETURNING l_wc
     IF tm.wc.getIndexOf('oea15',1) > 0 THEN 
        LET l_sql = "SELECT ima12,ima01,ima02,ima06,tlfccost,",  
                    " tlf02,tlf021,tlf03,tlf031,tlf06,tlf026,tlf027,", 
                    " tlf036,tlf037,tlf01,tlf10*tlf60,tlfc21,tlf13,tlf905,tlf906,", 
                    " tlf19,tlf907,tlfc221,tlfc222,tlfc2231,tlfc2232,tlfc224,tlfc2241,tlfc2242,tlfc2243,0,0,tlf14,azf08,",
                    " oea15,gem02 ",    
                    "  FROM ima_file,tlf_file LEFT OUTER JOIN azf_file ON tlf14=azf01 AND azf02='2' LEFT OUTER JOIN tlfc_file ON tlf01=tlfc01 AND tlfctype = '",tm.type,"' AND tlf06=tlfc06 AND tlf026=tlfc026 AND tlf027=tlfc027 AND tlf036=tlfc036 AND tlf037=tlfc037 AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf907=tlfc907 AND tlf905=tlfc905 AND tlf906=tlfc906, ",
                    " ogb_file,oea_file,gem_file",
                    " WHERE ima01 = tlf01", 
                    " AND tlf13 IN ('axmt620','axmt820')",
                    " AND ",tm.wc CLIPPED,
                    " and tlf902 not in (select jce02 from jce_file)",
                    " AND (tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')",
                    " AND ogb01 = tlf026",
                    " AND ogb03 = tlf027",
                    " AND ogb31 = oea01",
                    " AND oea15 = gem01",
                    " UNION ALL ",
                    " SELECT ima12,ima01,ima02,ima06,tlfccost,",  
                    " tlf02,tlf021,tlf03,tlf031,tlf06,tlf026,tlf027,", 
                    " tlf036,tlf037,tlf01,tlf10*tlf60,tlfc21,tlf13,tlf905,tlf906,", 
                    " tlf19,tlf907,tlfc221,tlfc222,tlfc2231,tlfc2232,tlfc224,tlfc2241,tlfc2242,tlfc2243,0,0,tlf14,azf08,",
                    " oga15,gem02 ",    
                    "  FROM ima_file,tlf_file LEFT OUTER JOIN azf_file ON tlf14=azf01 AND azf02='2' LEFT OUTER JOIN tlfc_file ON tlf01=tlfc01 AND tlfctype = '",tm.type,"' AND tlf06=tlfc06 AND tlf026=tlfc026 AND tlf027=tlfc027 AND tlf036=tlfc036 AND tlf037=tlfc037 AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf907=tlfc907 AND tlf905=tlfc905 AND tlf906=tlfc906, ",
                    " oga_file,gem_file",
                    " WHERE ima01 = tlf01", 
                    " AND tlf13 IN ('axmt650','axmt650sub')",
                    " AND ",l_wc CLIPPED,
                    " and tlf902 not in (select jce02 from jce_file)",
                    " AND (tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')",
                    " AND oga01 = tlf026",
                    " AND oga15 = gem01",
                    " UNION ALL ",
                    " SELECT ima12,ima01,ima02,ima06,tlfccost,",  
                    " tlf02,tlf021,tlf03,tlf031,tlf06,tlf026,tlf027,", 
                    " tlf036,tlf037,tlf01,tlf10*tlf60,tlfc21,tlf13,tlf905,tlf906,", 
                    " tlf19,tlf907,tlfc221,tlfc222,tlfc2231,tlfc2232,tlfc224,tlfc2241,tlfc2242,tlfc2243,0,0,tlf14,azf08,",
                    " oea15,gem02 ",    
                    "  FROM ima_file,tlf_file LEFT OUTER JOIN azf_file ON tlf14=azf01 AND azf02='2' LEFT OUTER JOIN tlfc_file ON tlf01=tlfc01 AND tlfctype = '",tm.type,"' AND tlf06=tlfc06 AND tlf026=tlfc026 AND tlf027=tlfc027 AND tlf036=tlfc036 AND tlf037=tlfc037 AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf907=tlfc907 AND tlf905=tlfc905 AND tlf906=tlfc906, ",
                    " ohb_file,oea_file,gem_file",
                    " WHERE ima01 = tlf01", 
                    " AND tlf13 = 'aomt800'",
                    " AND ",tm.wc CLIPPED,
                    " and tlf902 not in (select jce02 from jce_file)",
                    " AND (tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')",
                    " AND ohb01 = tlf026",
                    " AND ohb03 = tlf027",
                    " AND ohb33 = oea01",
                    " AND oea15 = gem01"
     ELSE 
        IF tm.g = '4' THEN 
           LET l_sql = "SELECT ima12,ima01,ima02,ima06,tlfccost,",  
                       " tlf02,tlf021,tlf03,tlf031,tlf06,tlf026,tlf027,", 
                       " tlf036,tlf037,tlf01,tlf10*tlf60,tlfc21,tlf13,tlf905,tlf906,", 
                       " tlf19,tlf907,tlfc221,tlfc222,tlfc2231,tlfc2232,tlfc224,tlfc2241,tlfc2242,tlfc2243,0,0,tlf14,azf08,",
                       " oea15,gem02 ",    
                       "  FROM ima_file,tlf_file LEFT OUTER JOIN azf_file ON tlf14=azf01 AND azf02='2' LEFT OUTER JOIN tlfc_file ON tlf01=tlfc01 AND tlfctype = '",tm.type,"' AND tlf06=tlfc06 AND tlf026=tlfc026 AND tlf027=tlfc027 AND tlf036=tlfc036 AND tlf037=tlfc037 AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf907=tlfc907 AND tlf905=tlfc905 AND tlf906=tlfc906 ",
                       " LEFT OUTER JOIN ogb_file ON ogb01 = tlf026 AND ogb03 = tlf027 ",
                       " LEFT OUTER JOIN oea_file ON ogb31 = oea01 ",
                       " LEFT OUTER JOIN gem_file ON oea15 = gem01",
                       " WHERE ima01 = tlf01", 
                       " AND tlf13 IN ('axmt620','axmt820')",
                       " AND ",tm.wc CLIPPED,
                       " and tlf902 not in (select jce02 from jce_file)",
                       " AND (tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')",
                       " UNION ALL ",
                       " SELECT ima12,ima01,ima02,ima06,tlfccost,",  
                       " tlf02,tlf021,tlf03,tlf031,tlf06,tlf026,tlf027,", 
                       " tlf036,tlf037,tlf01,tlf10*tlf60,tlfc21,tlf13,tlf905,tlf906,", 
                       " tlf19,tlf907,tlfc221,tlfc222,tlfc2231,tlfc2232,tlfc224,tlfc2241,tlfc2242,tlfc2243,0,0,tlf14,azf08,",
                       " oga15,gem02 ",    
                       "  FROM ima_file,tlf_file LEFT OUTER JOIN azf_file ON tlf14=azf01 AND azf02='2' LEFT OUTER JOIN tlfc_file ON tlf01=tlfc01 AND tlfctype = '",tm.type,"' AND tlf06=tlfc06 AND tlf026=tlfc026 AND tlf027=tlfc027 AND tlf036=tlfc036 AND tlf037=tlfc037 AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf907=tlfc907 AND tlf905=tlfc905 AND tlf906=tlfc906 ",
                       " LEFT OUTER JOIN oga_file ON oga01 = tlf026  ",
                       " LEFT OUTER JOIN gem_file ON oga15 = gem01",
                       " WHERE ima01 = tlf01", 
                       " AND tlf13 IN ('axmt650','axmt650sub')",
                       " AND ",l_wc CLIPPED,
                       " and tlf902 not in (select jce02 from jce_file)",
                       " AND (tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')",
                       " UNION ALL ",
                       " SELECT ima12,ima01,ima02,ima06,tlfccost,",  
                       " tlf02,tlf021,tlf03,tlf031,tlf06,tlf026,tlf027,", 
                       " tlf036,tlf037,tlf01,tlf10*tlf60,tlfc21,tlf13,tlf905,tlf906,", 
                       " tlf19,tlf907,tlfc221,tlfc222,tlfc2231,tlfc2232,tlfc224,tlfc2241,tlfc2242,tlfc2243,0,0,tlf14,azf08,",
                       " oea15,gem02 ",    
                       "  FROM ima_file,tlf_file LEFT OUTER JOIN azf_file ON tlf14=azf01 AND azf02='2' LEFT OUTER JOIN tlfc_file ON tlf01=tlfc01 AND tlfctype = '",tm.type,"' AND tlf06=tlfc06 AND tlf026=tlfc026 AND tlf027=tlfc027 AND tlf036=tlfc036 AND tlf037=tlfc037 AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf907=tlfc907 AND tlf905=tlfc905 AND tlf906=tlfc906 ",
                       " LEFT OUTER JOIN ohb_file ON ohb01 = tlf026 AND ohb03 = tlf027 ",
                       " LEFT OUTER JOIN oea_file ON ohb33 = oea01 ",
                       " LEFT OUTER JOIN gem_file ON oea15 = gem01",
                       " WHERE ima01 = tlf01", 
                       " AND tlf13 = 'aomt800'",
                       " AND ",tm.wc CLIPPED,
                       " and tlf902 not in (select jce02 from jce_file)",
                       " AND (tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')"
        ELSE 
     #FUN-C80088---end
#No.FUN-CB0031 --begin
#     LET l_sql = "SELECT ima12,ima01,ima02,ima06,tlfccost,",   #No.FUN-7C0101 add tlfccost  
#                 " tlf02,tlf021,tlf03,tlf031,tlf06,tlf026,tlf027,", 
#                 " tlf036,tlf037,tlf01,tlf10*tlf60,tlfc21,tlf13,tlf905,tlf906,", #MOD-570078  #No.FUN-7C0101 tlf21->tlfc21
#                 " tlf19,tlf907,tlfc221,tlfc222,tlfc2231,tlfc2232,tlfc224,tlfc2241,tlfc2242,tlfc2243,0,0,tlf14,azf08,'',''",#No.FUN-7C0101 #FUN-840173 #FUN-C80088
#                 "  FROM ima_file,tlf_file LEFT OUTER JOIN azf_file ON tlf14=azf01 AND azf02='2' LEFT OUTER JOIN tlfc_file ON tlf01=tlfc01 AND tlfctype = '",tm.type,"' AND tlf06=tlfc06 AND tlf026=tlfc026 AND tlf027=tlfc027 AND tlf036=tlfc036 AND tlf037=tlfc037 AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf907=tlfc907 AND tlf905=tlfc905 AND tlf906=tlfc906 ",  #MOD-920106  
#                 " WHERE ima01 = tlf01", 
#                 " AND (tlf13 LIKE 'axm%' OR tlf13 LIKE 'aomt%')",
##                " AND tlfc_file.tlfctype = '",tm.type,"'",            #No.FUN-7C0101 add
#                 " AND ",tm.wc CLIPPED,
#                 " and tlf902 not in (select jce02 from jce_file)",
#                 " AND (tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')"
##               , " ORDER BY ima01,tlf905,tlf906 "              #No.MOD-780262 add #FUN-840173   #FUN-A30044 mark

     #FUN-A30044 ---start---

     LET l_sql = "SELECT DISTINCT ima12,ima01,ima02,ima06,tlfccost,",   #No.FUN-7C0101 add tlfccost  
                 " tlf02,tlf021,tlf03,tlf031,tlf06,tlf026,tlf027,", 
                 " tlf036,tlf037,tlf01,tlf10*tlf60,tlfc21,tlf13,tlf905,tlf906,", #MOD-570078  #No.FUN-7C0101 tlf21->tlfc21
                 " tlf19,tlf907,tlfc221,tlfc222,tlfc2231,tlfc2232,tlfc224,tlfc2241,tlfc2242,tlfc2243,0,0,tlf14,tlf66,azf08,",#No.FUN-7C0101 #FUN-840173   #No:CHI-A70023 add tlf66
                 " tlf902,tlf903,tlf904,'','' ",     #CHI-A70023 add  #FUN-C80088
                 "  FROM ima_file,tlf_file LEFT OUTER JOIN azf_file ON tlf14=azf01 AND azf02='2' LEFT OUTER JOIN tlfc_file ON tlf01=tlfc01 AND tlfctype = '",tm.type,"' AND tlf06=tlfc06 AND tlf026=tlfc026 AND tlf027=tlfc027 AND tlf036=tlfc036 AND tlf037=tlfc037 AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf907=tlfc907 AND tlf905=tlfc905 AND tlf906=tlfc906 "  #MOD-920106  
     LET l_sql1 =" WHERE ima01 = tlf01", 
                 " AND (tlf13 LIKE 'axm%' OR tlf13 LIKE 'aomt%')",
                 " AND ",tm.wc CLIPPED,
                 " and tlf902 not in (select jce02 from jce_file)",
                 " AND (tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')"
                 
     IF g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'Y' THEN   #No.MOD-CB0215 add oaz93 = 'Y'
     	  LET l_sql = l_sql,",oga_file,oha_file "
     	  LET l_sql1= l_sql1," AND ((tlf905 = oga01 AND oga99 IS NOT NULL) OR (tlf905 = oha01 AND oha99 IS NOT NULL) OR tlf13 = 'axmt670')"
     END IF 
     LET l_sql = l_sql,l_sql1
#No.FUN-CB0031 --end
        END IF  #FUN-C80088
     END IF  #FUN-C80088
     #FUN-A30044 ---start---
     IF tm.c = 'Y' THEN
        #No.TQC-A40139  --Begin
       #LET l_sql = l_sql," AND tlf28 = 'S' ORDER BY ima01,tlf905,tlf906"
        LET l_sql = l_sql," AND tlf28 = 'S' ORDER BY tlf905,tlf906,ima01"
        #No.TQC-A40139  --End  
     ELSE
        #No.TQC-A40139  --Begin
       #LET l_sql = l_sql," ORDER BY ima01,tlf905,tlf906 "
        LET l_sql = l_sql," ORDER BY tlf905,tlf906,ima01 "
        #No.TQC-A40139  --End  
     END IF 
     #FUN-A30044 ---end---
 
     PREPARE axcr760_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE axcr760_curs1 CURSOR FOR axcr760_prepare1
 
     LET g_pageno = 0
     FOREACH axcr760_curs1 INTO sr.*,l_tlf14,l_tlf66,l_azf08,l_tlf902,l_tlf903,l_tlf904,l_gem01,l_gem02   #FUN-840173   #No:CHI-A70023 add l_tlf66,l_tlf902,l_tlf903,l_tlf904  #FUN-C80088
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET l_oga00 = NULL
       LET l_oga65 = NULL       #MOD-AC0102 add
       IF sr.tlf13 MATCHES 'axmt*' THEN
          SELECT oga00,oga65 INTO l_oga00,l_oga65 FROM oga_file WHERE oga01=sr.tlf905      #MOD-AC0102 add oga65,l_oga65
          IF l_oga00 = '3' OR l_oga00 ='A' OR l_oga00='7' OR l_oga65 = 'Y' THEN    #No:MOD-950210 modify   #MOD-AC0102 add l_oga65
             CONTINUE FOREACH
          END IF
       END IF
       IF cl_null(l_azf08) THEN LET l_azf08='N' END IF
 
#CHI-C50069---mark---START
#      IF tm.c = 'N' THEN    #FUN-A30044 add
#         IF tm.b='N' THEN
#            IF l_azf08='Y' THEN CONTINUE FOREACH END IF
#         ELSE
#            IF l_azf08='N' THEN CONTINUE FOREACH END IF
#         END IF
#      END IF               #FUN-A30044 add 
#CHI-C50069---mark-----END
#CHI-C50069---add---START
          CASE tm.b
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
       IF  cl_null(sr.tlfc21) THEN LET sr.tlfc21=0 END IF  #No.FUN-7C0101
       IF  cl_null(sr.amt_d)  THEN LET sr.amt_d=0 END IF
       IF  cl_null(sr.amt04)  THEN LET sr.amt04=0 END IF
       IF  cl_null(sr.amt05)  THEN LET sr.amt05=0 END IF   #FUN-5B0082
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
          LET sr.amt05= sr.amt05 * -1   #FUN-5B0082
          LET sr.amt06= sr.amt06 * -1   #No.FUN-7C0101 add #MOD-A40041 mod
          LET sr.amt07= sr.amt07 * -1   #No.FUN-7C0101 add
          LET sr.amt08= sr.amt08 * -1   #No.FUN-7C0101 add
       END IF
      #LET sr.amt04 = sr.amt01 + sr.amt02 + sr.amt03 + sr.amt_d + sr.amt05  #FUN-5B0082  #No.MOD-9B0250
       LET sr.amt04 = sr.amt01 + sr.amt02 + sr.amt03 + sr.amt_d + sr.amt05  
                      +sr.amt06+sr.amt07+sr.amt08                           #No:TQC-A40139 add
       IF  cl_null(sr.amt04)  THEN LET sr.amt01=0 END IF
       let    sr.wsaleamt = 0
     IF (sr.tlf905 <> l_tlf905 OR sr.tlf906 <> l_tlf906 OR l_tlf66 = 'X') THEN   #No.MOD-780262 add  #No:CHI-A70023 modify
     #-----------------No:CHI-A70023 add
        IF l_tlf66 = 'X' THEN
           CALL s_ogc_amt_1(sr.tlf01,sr.tlf905,sr.tlf906,l_tlf902,l_tlf903,l_tlf904,'') RETURNING sr.wsaleamt
        ELSE
       #-----------------No:CHI-A70023 end
#No.FUN-CB0031 --begin
#        SELECT omb38,SUM(omb16) INTO l_omb38,sr.wsaleamt FROM oma_file,omb_file #FUN-9B0017 add omb38
#          WHERE omb31 = sr.tlf905 AND omb32 = sr.tlf906
#            AND oma01=omb01 AND oma02 BETWEEN tm.bdate AND tm.edate
#            AND omavoid<>'Y'   #MOD-680047 add
#         GROUP BY omb38        #FUN-9B0017 add
          

        IF sr.tlf13 = 'axmt670' THEN 
           SELECT omb38,SUM(omb16) INTO l_omb38,sr.wsaleamt FROM oma_file,omb_file,omf_file
            WHERE omb31 = omf11 
              AND omb32 = omf12
              AND oma01 = omf04
              AND omf00 = sr.tlf905 
              AND omf21 = sr.tlf906
              AND oma01=omb01 AND oma02 BETWEEN tm.bdate AND tm.edate
              AND omavoid<>'Y'   #MOD-680047 add
            GROUP BY omb38 
        ELSE 
           SELECT omb38,SUM(omb16) INTO l_omb38,sr.wsaleamt FROM oma_file,omb_file #FUN-9B0017 add omb38
             WHERE omb31 = sr.tlf905 AND omb32 = sr.tlf906
               AND oma01=omb01 AND oma02 BETWEEN tm.bdate AND tm.edate
               AND omavoid<>'Y'   #MOD-680047 add
            GROUP BY omb38        #FUN-9B0017 add
        END IF 
#No.FUN-CB0031 --end
    END IF                  #No:CHI-A70023 add
        #FUN-9B0017   ---start
        #取出1.總遞延收入 2.每期折讓金額/每期遞延收入(退貨/銷貨)
         IF sr.tlf907 = 1 THEN  #退貨
           IF l_omb38 = '3' THEN
               #總遞延收入
               SELECT oct12 INTO l_oct12 FROM oct_file						
                WHERE oct04= sr.tlf905 AND oct05 =sr.tlf906						
	          AND oct16 = '3'							
                  AND oct00 = '0'  #FUN-A60007
           ELSE
               SELECT oct12 INTO l_oct12 FROM oct_file						
                WHERE oct06= sr.tlf905 AND oct07 =sr.tlf906						
	          AND oct16 = '3'							
                  AND oct00 = '0'  #FUN-A60007
           END IF
           IF cl_null(l_oct12) THEN LET l_oct12 = 0 END IF						
           #每期折讓金額
            LET l_byear=YEAR(tm.bdate)
            LET l_bmonth=MONTH(tm.bdate)
            LET l_bdate=(l_byear*12)+l_bmonth
            LET l_eyear=YEAR(tm.edate)
            LET l_emonth=MONTH(tm.edate)
            LET l_edate=(l_eyear*12)+l_emonth  
            IF l_omb38 = '3' THEN
                SELECT SUM(oct15) INTO l_oct15 FROM oct_file						
                 WHERE oct04 = sr.tlf905 AND oct05 =sr.tlf906						
	           AND oct16 ='4' 
                   AND (oct09*12)+oct10 BETWEEN l_bdate AND l_edate 							
                   AND oct00 = '0'  #FUN-A60007
            ELSE
                SELECT SUM(oct15) INTO l_oct15 FROM oct_file						
                 WHERE oct06 = sr.tlf905 AND oct07 =sr.tlf906						
	           AND oct16 ='4' 
                   AND (oct09*12)+oct10 BETWEEN l_bdate AND l_edate 							
                   AND oct00 = '0'  #FUN-A60007
            END IF
            IF cl_null(l_oct15) THEN LET l_oct15 = 0 END IF						
           #退貨時要將原本收入 - 總遞延收入 + 每期折讓金額
            LET sr.wsaleamt = sr.wsaleamt * -1  #FUN-9B0017 
            LET sr.wsaleamt = sr.wsaleamt - l_oct12 + l_oct15						
         ELSE #銷貨
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
           #銷貨時要將原本銷貨收入 - 總遞延收入 + 每期遞延收入
            LET sr.wsaleamt = sr.wsaleamt  - l_oct12 + l_oct14						
         END IF									
        #FUN-9B0017   ---end
         LET l_tlf905 = sr.tlf905    #No.MOD-780262 add
         LET l_tlf906 = sr.tlf906    #No.MOD-780262 add
      END IF                         #No.MOD-780262 add
 
     IF  cl_null(sr.wsaleamt)  THEN LET sr.wsaleamt=0 END IF
 
 
     CASE tm.g
       WHEN '1'
         #No.MOD-C20181  --Begin
          IF g_aza.aza26 = '2' THEN
             LET sr.tlf10= sr.tlf10 * -1
             LET sr.amt01= sr.amt01 * -1
             LET sr.amt02= sr.amt02 * -1
             LET sr.amt03= sr.amt03 * -1
             LET sr.amt_d= sr.amt_d * -1
             LET sr.amt05= sr.amt05 * -1
             LET sr.amt06= sr.amt06 * -1
             LET sr.amt07= sr.amt07 * -1
             LET sr.amt08= sr.amt08 * -1
             LET sr.amt04= sr.amt04 * -1 #MOD-D10160
          END IF
          #No.MOD-C20181  --End
       WHEN '2'
          LET g_len= 211    #No.FUN-550025
          LET sr.tlf10= sr.tlf10 * -1
         #MOD-9C0373---modify---start---
         #IF sr.tlf907 = 1 THEN
         #   LET sr.tlfc21    = sr.tlfc21 * -1  #No.FUN-7C0101
         #   LET sr.wsaleamt = sr.wsaleamt * -1
         #END IF
         #---------------No:CHI-A70023 modify
         #IF (sr.tlf905 <> l_tlf905_1 OR sr.tlf906 <> l_tlf906_1) THEN
         #   SELECT SUM(tlfc21*tlfc907*-1) INTO sr.tlfc21 FROM tlfc_file
         #    WHERE tlfc01 = sr.ima01
         #      AND tlfc905 = sr.tlf905
         #      AND tlfc906 = sr.tlf906
         #      AND (tlfc06 BETWEEN tm.bdate AND tm.edate)
         #   IF cl_null(sr.tlfc21) THEN LET sr.tlfc21 = 0 END IF
         #   LET l_tlf905_1 = sr.tlf905
         #   LET l_tlf906_1 = sr.tlf906
         #ELSE
         #   LET sr.tlfc21 = 0
         #   LET sr.wsaleamt = 0
         #END IF
         #---------------No:CHI-A70023 modify end
         #------------------No:MOD-9C0373 modify
       WHEN '3'
          LET g_len= 211    #No.FUN-550025
          LET sr.tlf10= sr.tlf10 * -1
         #MOD-9C0373---modify---start---
         #IF sr.tlf907 = 1 THEN
         #   LET sr.tlfc21    = sr.tlfc21 * -1  #No.FUN-7C0101
         #   LET sr.wsaleamt = sr.wsaleamt * -1
         #END IF
         #---------------No:CHI-A70023 modify
         #IF (sr.tlf905 <> l_tlf905_1 OR sr.tlf906 <> l_tlf906_1) THEN   
         #   SELECT SUM(tlfc21*tlfc907*-1) INTO sr.tlfc21 FROM tlfc_file
         #    WHERE tlfc01 = sr.ima01
         #      AND tlfc905 = sr.tlf905
         #      AND tlfc906 = sr.tlf906
         #      AND (tlfc06 BETWEEN tm.bdate AND tm.edate)
         #   IF cl_null(sr.tlfc21) THEN LET sr.tlfc21 = 0 END IF
         #   LET l_tlf905_1 = sr.tlf905
         #   LET l_tlf906_1 = sr.tlf906
         # ELSE
         #   LET sr.tlfc21 = 0 
         #   LET sr.wsaleamt = 0 
         # END IF 
         # #---------------No:CHI-A70023 modify end
         #------------------No:MOD-9C0373 modify
          SELECT oga25 INTO warea FROM oga_file WHERE oga01 = sr.tlf905
                                                  AND oga00 NOT IN ('A','3','7')     #No.MOD-950210 add
          SELECT oab02 INTO warea_name FROM oab_file WHERE oab01 = warea
       WHEN '4'
          IF g_aza.aza26 = '2' THEN 
             LET sr.tlf10= sr.tlf10 * -1
             LET sr.amt01= sr.amt01 * -1
             LET sr.amt02= sr.amt02 * -1
             LET sr.amt03= sr.amt03 * -1
             LET sr.amt_d= sr.amt_d * -1
             LET sr.amt05= sr.amt05 * -1
             LET sr.amt06= sr.amt06 * -1
             LET sr.amt07= sr.amt07 * -1
             LET sr.amt08= sr.amt08 * -1 
             LET sr.amt04= sr.amt04 * -1 #MOD-D10160
          END IF
       #FUN-C80088---end
     END CASE
 
 
     CASE 
        WHEN tm.g = '1' OR tm.g = '4' #FUN-C80088
           LET l_azf03 = NULL
           IF NOT cl_null(sr.ima12) THEN
              SELECT azf03 INTO l_azf03 FROM azf_file
               WHERE azf01=sr.ima12 AND azf02='G' 
           END IF
        WHEN tm.g = '2' OR tm.g = '3'
           LET wocc02  = ' '
           LET wticket = ' '
           LET wima202 = ' '
           LET l_wima201 =  sr.tlf01
           LET l_wsale_tlf21 = 0
           SELECT occ02 INTO wocc02  FROM occ_file WHERE occ01= sr.tlf19
           SELECT oma33 INTO wticket FROM oma_file , oga_file
            WHERE oga01 = sr.tlf905  AND  oga10 = oma01
              AND oga00 NOT IN ('A','3','7')  #No.MOD-950210 add
          #MOD-C20208 str add-----
           IF cl_null(wticket) THEN
              SELECT oma33 INTO wticket FROM oma_file , oha_file
               WHERE oha01 = sr.tlf905  AND  oha10 = oma01
           END IF
          #MOD-C20208 end add-----
#No.MOD-D10246 --begin
           IF g_oaz.oaz93 = 'Y' THEN 
              SELECT oma33 INTO wticket 
                FROM oma_file ,omf_file
               WHERE omf00 = sr.tlf905  
                 AND omf21 = sr.tlf906 
                 AND omf04 = oma01          	  
           END IF 
#No.MOD-D10246 --end
#         CHI-B60079 --- modify --- start ---
#           IF l_wima201 <> '99' THEN
#              SELECT ima202 INTO wima202 FROM ima2_file WHERE ima201= l_wima201
#           ELSE
#              SELECT ima131 INTO wima202 FROM ima_file WHERE ima01 = sr.tlf01
#           END IF
#         CHI-B60079 --- modify ---  end  ---
           IF cl_null(sr.wsaleamt) THEN LET sr.wsaleamt = 0 END IF
           IF cl_null(sr.tlfc21)    THEN LET sr.tlfc21 = 0    END IF #No.FUN-7C0101
           LET l_wsale_tlf21 = sr.wsaleamt - sr.tlfc21       #No.FUN-7C0101
     END CASE
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> *** ##
     EXECUTE insert_prep USING
        sr.ima12, sr.ima01, sr.ima02,   sr.ima06,    sr.tlf02,
        sr.tlf021,sr.tlf03, sr.tlf031,  sr.tlf06,    sr.tlf026,
        sr.tlf027,sr.tlf036,sr.tlf037,  sr.tlf01,    sr.tlfccost, sr.tlf10, #No.FUN-7C0101 add sr.tlfccost
        sr.tlfc21, sr.tlf13, sr.tlf905,  sr.tlf906,   sr.tlf19,     #No.FUN-7C0101 tlf21->tlfc21
        sr.tlf907,sr.amt01, sr.amt02,   sr.amt03,    sr.amt_d,  
        sr.amt05, sr.amt06,sr.amt07,sr.amt08,sr.amt04,sr.wsaleamt,warea_name,l_azf03,#No.FUN-7C0101 add amt06,7,8
        wocc02,   wticket,  wima202,    l_wsale_tlf21,g_ccz.ccz27,
        #g_azi03,  g_azi04,  g_azi05 #CHI-C30012
        g_ccz.ccz26,  g_ccz.ccz26,  g_ccz.ccz26, #CHI-C30012
        l_gem01,l_gem02  #FUN-C80088
 
     END FOREACH
 
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     #是否列印選擇條件
     LET g_str = NULL
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'ima12,ima01,tlf905,tlf19')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str,";",tm.bdate,";",tm.edate,";",tm.a,";",tm.type  #No.FUN-7C0101 add tm.type #FUN-840173
 
     CASE tm.g
        WHEN '1'
           IF tm.type MATCHES '[12]' THEN
              CALL cl_prt_cs3('axcr760','axcr760_1_1',l_sql,g_str)
           END IF
           IF tm.type MATCHES '[345]' THEN
              CALL cl_prt_cs3('axcr760','axcr760_1',l_sql,g_str)
           END IF
        WHEN '2'
           IF tm.type MATCHES '[12]' THEN
              CALL cl_prt_cs3('axcr760','axcr760_2_1',l_sql,g_str)
           END IF
           IF tm.type MATCHES '[345]' THEN
              CALL cl_prt_cs3('axcr760','axcr760_2',l_sql,g_str)
           END IF
        WHEN '3'
           IF tm.type MATCHES '[12]' THEN
              CALL cl_prt_cs3('axcr760','axcr760_3_1',l_sql,g_str)
           END IF
           IF tm.type MATCHES '[345]' THEN
              CALL cl_prt_cs3('axcr760','axcr760_3',l_sql,g_str)
           END IF
        #FUN-C80088---begin
        WHEN '4'
           IF tm.type MATCHES '[12]' THEN
              CALL cl_prt_cs3('axcr760','axcr760_4_1',l_sql,g_str)
           END IF
           IF tm.type MATCHES '[345]' THEN
              CALL cl_prt_cs3('axcr760','axcr760_4',l_sql,g_str)
           END IF
        #FUN-C80088---end
     END CASE
 
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/12
