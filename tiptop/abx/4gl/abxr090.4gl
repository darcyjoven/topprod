# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abxr090.4gl
# Descriptions...: 內銷按月彙報報表
# Date & Author..: 96/08/02 By STAR
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-550033 05/05/19 By day   單據編號加大
# Modify.........: No.FUN-5B0013 05/11/02 By Rosayu 將料號/品名/規格 欄位設成[1,,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: NO.TQC-5B0028 05/11/07 BY yiting 料號需放大到四十碼
# Modify.........: No.TQC-610081 06/02/16 By Pengu Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-660052 05/06/13 By ice cl_err3訊息修改
# Modify.........: NO.FUN-680025 06/08/24 By flowld voucher型報表轉template1
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換
# Modify.........: No.FUN-690108 06/10/13 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0007 06/10/23 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.CHI-6A0004 06/10/26 By Jackho  本（原）幣取位修改
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.TQC-6A0083 06/11/14 By xumin 報表寬度不符問題調整
# Modify.........: No.FUN-740077 07/04/19 By TSD.Achick報表改寫由Crystal Report產出
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A70217 10/07/30 By Sarah 將bxe_file改為OUTER
# Modify.........: No:MOD-CC0167 12/12/26 By Elise 放大異動原因代碼1、異動原因代碼2欄位
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                # Print condition RECORD
              wc      STRING,  # Where condition  #No.FUN-680062 VARCHAR(1000)
              a       LIKE bxr_file.bxr01,     #No.FUN-680062 VARCHAR(2)  #MOD-CC0167 mod chr2->bxr01
              b       LIKE type_file.chr20,    #No.FUN-680062 VARCHAR(16)  
              a2      LIKE bxr_file.bxr01,     #FUN-6A0007  #MOD-CC0167 mod chr2->bxr01
              bdate   LIKE type_file.dat,      #No.FUN-680062 date
              edate   LIKE type_file.dat,      #No.FUN-680062 date
              #FUN-6A0007...............begin
              s            LIKE type_file.chr4,      # 排列順序項目     
              u            LIKE type_file.chr4,      # 小計     
              yy           LIKE type_file.num5,         # 申報年       
              mm           LIKE type_file.num5,         # 申報月    
              detail_flag  LIKE type_file.chr1,      # 明細列印否    
              rname        LIKE type_file.chr1,      # 報表名稱    
              choice       LIKE type_file.chr1,      # 列印區分    
              ima15        LIKE type_file.chr1,      # 1.保稅 2.非保稅 3.全部     
              #FUN-6A0007...............end
              more    LIKE type_file.chr1      # Input more condition(Y/N) #No.FUN-680062 VARCHAR(1)
           END RECORD,
       g_bxr02        LIKE bxr_file.bxr02,
       g_bxr02b      LIKE bxr_file.bxr02        #FUN-6A0007
       #g_dash1_1      LIKE type_file.chr1000   # Dash line  #No.FUN-680062 VARCHAR(300) #FUN-6A0007
 
DEFINE g_i            LIKE type_file.num5      #count/index for any purpose   #No.FUN-680062 
DEFINE   g_occ01         LIKE occ_file.occ01    #FUN-6A0007 
DEFINE   g_occ02         LIKE occ_file.occ02    #FUN-6A0007 
DEFINE   g_bxe01     LIKE bxe_file.bxe01 #FUN-6A0007
DEFINE   g_bxe02     LIKE bxe_file.bxe02 #FUN-6A0007
DEFINE   g_bxe03     LIKE bxe_file.bxe03 #FUN-6A0007
DEFINE   l_table     STRING                       ### FUN-740077 add ###
DEFINE   g_sql       STRING                       ### FUN-740077 add ###
DEFINE   g_str       STRING                       ### FUN-740077 add ###
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690108
 
   #str FUN-740077 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> FUN-740077 *** ##
   LET g_sql = "order1.oab_file.oab02,   order2.oab_file.oab02,",
               "order3.oab_file.oab02,   order4.oab_file.oab02,",
               "bxi02.bxi_file.bxi02,    bxi03.bxi_file.bxi03,",      #異動日期      ,客戶編號
               "bxi13.bxi_file.bxi13,    bxj01.bxj_file.bxj01,",      #帳款客戶編號  ,單號
               "bxj03.bxj_file.bxj03,    bxj04.bxj_file.bxj04,",      #項次          ,料號
               "bxj06.bxj_file.bxj06,    bxj05.bxj_file.bxj05,",      #數量          ,單位
               "bxj15.bxj_file.bxj15,    bxj10.bxj_file.bxj10,",      #總金額        ,備註
               "bxj20.bxj_file.bxj20,    bxj13.bxj_file.bxj13,",      #單價          ,放行單號 
               "ima01.ima_file.ima01,    ima02.ima_file.ima02,",      #料號          ,品名  
               "ima021.ima_file.ima021,  ima1912.ima_file.ima1912,",  #規格          ,原產地
               "ima1916.ima_file.ima1912,occ02.occ_file.occ02,",      #保稅群組代碼
               "occ11.occ_file.occ11,    oga01.oga_file.oga01,",
               "oga27.oga_file.oga27,    ogb11.ogb_file.ogb11,",      #Invoice       ,客戶產品編號
               "bxe06.bxe_file.bxe06,    bxe07.bxe_file.bxe07,",      #工業局英文名稱,CCCODE
               "bxe02.bxe_file.bxe02,    bxe03.bxe_file.bxe03,",     
               "g_occ02.occ_file.occ02"
   LET l_table = cl_prt_temptable('abxr090',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.bdate  = ARG_VAL(8)
   LET tm.edate  = ARG_VAL(9)
   LET tm.a      = ARG_VAL(10)
   #FUN-6A0007 .....................begin
   LET tm.a2     = ARG_VAL(11)
   LET tm.s      = ARG_VAL(12)
   LET tm.u      = ARG_VAL(13)
   LET tm.yy     = ARG_VAL(14)
   LET tm.mm     = ARG_VAL(15)
   LET tm.detail_flag = ARG_VAL(16)
   LET tm.rname  = ARG_VAL(17)
   LET tm.choice = ARG_VAL(18)
   LET tm.ima15  = ARG_VAL(19)
   LET tm.b       = ARG_VAL(20)
   LET tm.more   = ARG_VAL(21)
   LET g_rep_user = ARG_VAL(22)
   LET g_rep_clas = ARG_VAL(23)
   LET g_template = ARG_VAL(24)
   LET g_rpt_name = ARG_VAL(25)  #No.FUN-7C0078
   #FUN-6A0007 .....................end
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL abxr090_tm(4,15)        # Input print condition
      ELSE CALL abxr090()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
END MAIN
 
FUNCTION abxr090_tm(p_row,p_col)
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01       #No.FUN-580031
   DEFINE p_row,p_col   LIKE type_file.num5,      #No.FUN-680062 LIKE type_file.num5
         #l_cmd         LIKE type_file.chr1000,   #No.FUN-680062 VARCHAR(1000) #FUN-6A0007
          l_cmd         LIKE zz_file.zz08         #FUN-6A0007
 
   LET p_row = 6 LET p_col = 22
 
   OPEN WINDOW abxr090_w AT p_row,p_col WITH FORM "abx/42f/abxr090"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
                                             
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   #FUN-6A0007...............begin
   LET tm.s = '2134'
   LET tm.u = 'NNNN'
   LET tm2.s1 = tm.s[1,1]   
   LET tm2.s2 = tm.s[2,2]
   LET tm2.s3 = tm.s[3,3]
   LET tm2.s4 = tm.s[4,4]
   LET tm2.u1 = tm.u[1,1]
   LET tm2.u2 = tm.u[2,2]
   LET tm2.u3 = tm.u[3,3]
   LET tm2.u4 = tm.u[4,4]
   LET tm.detail_flag = 'Y'
   LET tm.choice = '3'   #MOD-A70217 add
   LET tm.ima15 = '1'
   #FUN-6A0007...............end
   LET tm.more = 'N'
   LET tm.bdate = g_today
   LET tm.edate = g_today
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ima01,ima1916,bxi13,bxi03 #FUN-6A0007
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
    #FUN-6A0007...............begin
      ON ACTION CONTROLP
         CASE    
           WHEN INFIELD(ima01)
             CALL cl_init_qry_var()   
             LET g_qryparam.form = "q_ima"
             LET g_qryparam.state = 'c'  
             CALL cl_create_qry() RETURNING g_qryparam.multiret 
             DISPLAY g_qryparam.multiret TO ima01 
             NEXT FIELD ima01 
           WHEN INFIELD(ima1916)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_bxe01"
             LET g_qryparam.state = 'c'
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ima1916
             NEXT FIELD ima1916
         END CASE  
    #FUN-6A0007...............end
    
      ON ACTION locale
          #CALL cl_dynamic_locale()
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
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
 END CONSTRUCT
 LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW abxr090_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   #FUN-6A0007...............begin
   #INPUT BY NAME tm.bdate,tm.edate,tm.a,tm.b,tm.more
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm2.s4,tm2.u1,tm2.u2,tm2.u3,tm2.u4,
                 tm.yy,tm.mm,tm.bdate,tm.edate,tm.a,tm.a2,
                 tm.detail_flag,tm.rname,tm.choice,tm.ima15,tm.more
   #FUN-6A0007...............end
   WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      #FUN-6A0007...............begin
      AFTER FIELD yy
           IF NOT cl_null(tm.yy) AND   
              (tm.yy <= 0) THEN   
              NEXT FIELD yy   
           END IF     
 
 
      AFTER FIELD mm         
           IF NOT cl_null(tm.mm) AND   
              (tm.mm < 1 OR tm.mm > 12) THEN   
              NEXT FIELD mm   
           END IF     
 
      AFTER FIELD choice     
           IF tm.choice NOT MATCHES "[1-3]" THEN  
              NEXT FIELD choice   
           END IF  
 
      AFTER FIELD ima15
           IF tm.ima15 NOT MATCHES "[1-3]" THEN
              NEXT FIELD choice
           END IF
 
      AFTER FIELD detail_flag  
           IF tm.detail_flag NOT MATCHES "[YN]" THEN 
              NEXT FIELD detail_flag
           END IF    
 
      AFTER FIELD rname 
           IF tm.rname NOT MATCHES "[1-4]" THEN  
              NEXT FIELD rname
           END IF
 
      #FUN-6A0007...............end
 
      AFTER FIELD bdate
           IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
 
      AFTER FIELD edate
           IF cl_null(tm.edate) OR tm.edate < tm.bdate
           THEN NEXT FIELD edate END IF
 
      AFTER FIELD a
           IF cl_null(tm.a) THEN NEXT FIELD a END IF
           SELECT bxr02 INTO g_bxr02 FROM bxr_file WHERE bxr01 = tm.a
           IF STATUS THEN
              CALL cl_err3("sel","bxr_file",tm.a,"",STATUS,"","err bxr01  ",0) 
              NEXT FIELD a
           END IF
           DISPLAY g_bxr02 TO b
 
      #FUN-6A0007...............begin
      AFTER FIELD a2
           IF NOT cl_null(tm.a2) THEN
              LET  g_bxr02b = NULL
              SELECT bxr02 INTO g_bxr02b FROM bxr_file WHERE bxr01 = tm.a2
              IF STATUS THEN
                 CALL cl_err('err bxr01  ' ,STATUS,0)
                 NEXT FIELD a2
              END IF
              DISPLAY g_bxr02b TO b2
           ELSE 
              DISPLAY ' ' TO b2
           END IF
      #FUN-6A0007...............end
      
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      #FUN-6A0007...............begin
      AFTER INPUT   
           LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1],tm2.s4[1,1]
           LET tm.u = tm2.u1,tm2.u2,tm2.u3,tm2.u4
      #FUN-6A0007...............end
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(a)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_bxr'
                 LET g_qryparam.default1 = tm.a
                 CALL cl_create_qry() RETURNING tm.a
                  DISPLAY BY NAME tm.a             #No.MOD-490371
                 NEXT FIELD a
              #FUN-6A0007...............begin
              WHEN INFIELD(a2)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_bxr'
                 LET g_qryparam.default1 = tm.a2
                 CALL cl_create_qry() RETURNING tm.a2
                 DISPLAY BY NAME tm.a2        
                 NEXT FIELD a2
              #FUN-6A0007...............end
              OTHERWISE
                 EXIT CASE
           END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()    # Command execution
 
 
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
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW abxr090_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='abxr090'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abxr090','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,      #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.bdate   CLIPPED,"'",
                         " '",tm.edate   CLIPPED,"'",
                         " '",tm.a       CLIPPED,"'",
                         #FUN-6A0007...............begin
                         " '",tm.a2      CLIPPED,"'",
                         " '",tm.s       CLIPPED,"'",
                         " '",tm.u       CLIPPED,"'",
                         " '",tm.yy      CLIPPED,"'",
                         " '",tm.mm      CLIPPED,"'",
                         " '",tm.detail_flag   CLIPPED,"'",
                         " '",tm.rname   CLIPPED,"'",
                         " '",tm.choice  CLIPPED,"'",
                         " '",tm.ima15   CLIPPED,"'",
                         " '",tm.b       CLIPPED,"'",       #No.TQC-610081 add
                         " '",tm.more    CLIPPED,"'",
                         #FUN-6A0007...............end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
         CALL cl_cmdat('abxr090',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW abxr090_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abxr090()
   ERROR ""
END WHILE
   CLOSE WINDOW abxr090_w
END FUNCTION
 
FUNCTION abxr090()
   DEFINE l_name     LIKE type_file.chr20,         # External(Disk) file name      #No.FUN-680062char(20) 
          l_sql      STRING,       # RDSQL STATEMENT               #No.FUN-680062char(1000) 
          l_chr      LIKE type_file.chr1,                                          #No.FUN-680062char(1) 
          l_za05     LIKE za_file.za05,                                            #No.FUN-680062char(40)
          l_bnb14    LIKE type_file.num10,                                         #No.FUN-680062integer
          l_sfa03   LIKE sfa_file.sfa03,
          #FUN-6A0007...............begin
           l_order   ARRAY[4] OF LIKE bxj_file.bxj04,
           sr            RECORD order1    LIKE bxj_file.bxj04,
                                order2    LIKE bxj_file.bxj04,
                                order3    LIKE bxj_file.bxj04,
                                order4    LIKE bxj_file.bxj04,
                                bxi02     LIKE bxi_file.bxi02,     #異動日期
                                bxi03     LIKE bxi_file.bxi03,     #客戶編號 
                                bxi13 LIKE bxi_file.bxi13, #帳款客戶編號
                                bxj01     LIKE bxj_file.bxj01,     #單號
                                bxj03     LIKE bxj_file.bxj03,     #項次
                                bxj04     LIKE bxj_file.bxj04,     #料號
                                bxj06     LIKE bxj_file.bxj06,     #數量
                                bxj05     LIKE bxj_file.bxj05,     #單位
                                bxj15     LIKE bxj_file.bxj15,     #總金額
                                bxj10     LIKE bxj_file.bxj10,     #備註
                                bxj20 LIKE bxj_file.bxj20, #單價
                                bxj13     LIKE bxj_file.bxj13,     #放行單號  
                                ima01     LIKE ima_file.ima01,   
                                ima02     LIKE ima_file.ima02,     #品名規格
                                ima021    LIKE ima_file.ima021,    #規格
                                ima1912 LIKE ima_file.ima1912, #原產地
                                ima1916 LIKE ima_file.ima1912, #保稅群組代碼
                                occ02     LIKE occ_file.occ02,
                                occ11     LIKE occ_file.occ11,
                                oga01     LIKE oga_file.oga01,     #
                                oga27     LIKE oga_file.oga27,     #Invoice#
                                ogb11     LIKE ogb_file.ogb11,     #客戶產品編號
                                bxe06 LIKE bxe_file.bxe06,  #工業局英文名稱
                                bxe07 LIKE bxe_file.bxe07   #CCCODE
                         END RECORD
          #FUN-6A0007...............end
 
    #str FUN-740077  add
    ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-740077 *** ##
    CALL cl_del_data(l_table)
    #------------------------------ CR (2) ------------------------------#
    #end FUN-740077  add
 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-740077 add ###
 
    #FUN-6A0007...............begin
    LET l_sql = "SELECT '','','','',bxi02,bxi03,bxi13,",
                "       bxj01,bxj03,bxj04,bxj06,bxj05,bxj15,bxj10,bxj20,'',",
                "       ima01,",
                "       ima02,ima021,ima1912,ima1916,'','',oga01,oga27,'','' ",
                "  FROM bxi_file,bxj_file,ima_file,OUTER bxe_file, ",  #MOD-A70217 mod OUTER
                "       OUTER oga_file ",
                " WHERE bxi02 BETWEEN '",tm.bdate,"'",
                "   AND '",tm.edate,"'",
                "   AND bxi01 = bxj01 ",
                "   AND bxj04 = ima01 ", 
                "   AND bxi_file.bxi01 = oga_file.oga01 ",
                "   AND ima1916 = bxe_file.bxe01 ",   #FUN-6A0007     #MOD-A70217 mod
                "   AND ",tm.wc CLIPPED
    IF NOT cl_null(tm.a2) THEN 
       LET l_sql = l_sql CLIPPED," AND (bxi08='",tm.a,"' OR bxi08='",tm.a2,"') "     
    ELSE 
       LET l_sql = l_sql CLIPPED," AND bxi08='",tm.a,"' "     
    END IF
    IF NOT cl_null(tm.yy) THEN 
       LET l_sql = l_sql CLIPPED," AND bxi11=",tm.yy     
    END IF
    IF NOT cl_null(tm.mm) THEN   
       LET l_sql = l_sql CLIPPED," AND bxi12=",tm.mm
    END IF
    IF tm.choice = '1' THEN
       LET l_sql = l_sql CLIPPED," AND bxi06='2'"
    END IF
    IF tm.choice = '2' THEN
       LET l_sql = l_sql CLIPPED," AND bxi06='1'"
    END IF
    IF tm.ima15 = '1' THEN
       LET l_sql = l_sql CLIPPED," AND ima15='Y'"
    END IF
    IF tm.ima15 = '2' THEN
       LET l_sql = l_sql CLIPPED," AND ima15='N'"
    END IF
    LET l_sql = l_sql CLIPPED," ORDER BY bxi03"
    #FUN-6A0007...............end
 
    PREPARE abxr090_prepare1 FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
       EXIT PROGRAM
    END IF
    DECLARE abxr090_curs1 CURSOR FOR abxr090_prepare1
 
    LET g_pageno = 0
    FOREACH abxr090_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       #FUN-6A0007...............begin
       SELECT ogb11 INTO sr.ogb11 FROM ogb_file
        WHERE ogb01 = sr.oga01
          AND ogb04 = sr.bxj04
       #客戶簡稱、統編
       SELECT occ02,occ11 INTO sr.occ02,sr.occ11
         FROM occ_file
        WHERE occ01 = sr.bxi03
       IF STATUS THEN
          SELECT pmc03,pmc24 INTO sr.occ02,sr.occ11
            FROM pmc_file
           WHERE pmc01=sr.bxi03
       END IF
 
       IF NOT cl_null(sr.ima1916) THEN   #MOD-A70217 add 
          #工業局英文名稱、CCCODE
          SELECT bxe06,bxe07 INTO sr.bxe06,sr.bxe07
            FROM bxe_file,ima_file
           WHERE bxe01 = sr.ima1916
       END IF                            #MOD-A70217 add
       
       #FUN-6A0007...............end
       # 若前面user 按下 control-t 則會顯示目前做到第 n 筆
       IF cl_null(sr.bxj06) THEN LET sr.bxj06 = 0 END IF
       IF cl_null(sr.bxj15) THEN LET sr.bxj15 = 0 END IF
       IF cl_null(sr.bxj13) OR sr.bxj13 = ' ' THEN
          DECLARE r090_bnbs SCROLL CURSOR FOR
           SELECT bnb01 FROM bnb_file WHERE bnb04 = sr.bxj01 AND bnb03='2'
          OPEN r090_bnbs
          FETCH FIRST r090_bnbs INTO sr.bxj13
          CLOSE r090_bnbs
       END IF
       #FUN-6A0007...............begin
       FOR g_i = 1 TO 4
           CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.ima01  #料件編號
                WHEN tm.s[g_i,g_i] = '2' 
                     LET l_order[g_i] = sr.ima1916  #保稅群組代碼
                     LET g_bxe01 = sr.ima1916
                     CALL r090_bxe01()
 
                WHEN tm.s[g_i,g_i] = '3' 
                     LET l_order[g_i] = sr.bxi13  #收款客戶 
                     LET g_occ01 = sr.bxi13
                     CALL r090_occ02()
 
                WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.bxi03  #送貨客戶
                OTHERWISE LET l_order[g_i]  = '-'
           END CASE
       END FOR  
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
       LET sr.order4 = l_order[4]
       #FUN-6A0007...............end
 
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-740077 *** ##
       EXECUTE insert_prep USING 
          sr.order1 ,sr.order2,sr.order3,sr.order4,sr.bxi02,
          sr.bxi03  ,sr.bxi13 ,sr.bxj01 ,sr.bxj03 ,sr.bxj04,
          sr.bxj06  ,sr.bxj05 ,sr.bxj15 ,sr.bxj10 ,sr.bxj20,
          sr.bxj13  ,sr.ima01 ,sr.ima02 ,sr.ima021,sr.ima1912,
          sr.ima1916,sr.occ02 ,sr.occ11 ,sr.oga01 ,sr.oga27,
          sr.ogb11  ,sr.bxe06 ,sr.bxe07 ,g_bxe02 ,g_bxe03,
          g_occ02
       #------------------------------ CR (3) ------------------------------#
                                
       #end FUN-740077 add 
 
    END FOREACH
 
    #str FUN-740077 add 
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-740077 **** ##
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   
    LET g_str = ''   #MOD-A70217 add
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'ima01,ima1916,bxi13,bxi03') RETURNING tm.wc
       LET g_str = tm.wc
    END IF
    LET g_str = g_str,";",tm.s,";",tm.u,";",tm.rname,";",
                tm.yy,";",tm.mm,";",tm.bdate,";", tm.edate
 
    CALL cl_prt_cs3('abxr090','abxr090',l_sql,g_str)   
    #------------------------------ CR (4) ------------------------------#
    #end FUN-740077 add 
 
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
 
END FUNCTION
 
# 保稅規格代碼、品名、規格
FUNCTION r090_bxe01()
 
 LET g_bxe02 = NULL
 LET g_bxe03 = NULL
 
 SELECT bxe02,bxe03 INTO g_bxe02,g_bxe03
  FROM bxe_file
  WHERE bxe01 = g_bxe01
 
END FUNCTION
 
# 收款客戶
FUNCTION r090_occ02()
 
 LET g_occ02 = NULL
 
 SELECT occ02 INTO g_occ02 FROM occ_file
  WHERE occ01 = g_occ01
 
END FUNCTION
#FUN-6A0007...............end
#Patch....NO.TQC-610035 <001,002,004> #
