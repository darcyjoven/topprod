# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: apmr510.4gl
# Descriptions...: 驗收清單列印作業
# Date & Author..: 93/05/17  By  Felicity  Tseng
# Modify.........: No.FUN-4C0095 05/01/04 By Mandy 報表轉XML
# Modify.........: No.MOD-530173 05/03/21 By Mandy Dead Lock 壓Enter 無法跳到下一欄位(其它特殊列印條件)
# Modify.........: No.FUN-550060  05/05/31 By yoyo單據編號格式放大
# Modify.........: No.FUN-570243 05/07/25 By Trisy 料件編號開窗
# Modify.........: No.FUN-580004 05/08/04 By jackie 雙單位報表修改
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610085 06/04/04 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680136 06/09/04 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.TQC-6C0079 06/12/15 By ray 程序寫法導致報表打印出現死鎖
# Modify.........: No.FUN-810087 08/02/20 By baofei 報表輸出改為CR輸出
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-AA0005 10/10/06 By Smapmin 規格沒有資料呈現
# Modify.........: No:TQC-B80174 11/08/24 By lixia 增加開窗
# Modify.........: No.FUN-B80145 11/09/07 By Sakura 加入取apmt111無採購單號資料
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580004 --start--
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17    #FUN-560079
  DEFINE g_seq_item     LIKE type_file.num5    #No.FUN-680136 SMALLINT
END GLOBALS
#No.FUN-580004 --end--
#No.FUN-810087---Begin                                                                                                              
DEFINE l_table        STRING,                                                                                                       
       g_str          STRING,                                                                                                       
       g_sql          STRING                                                                                                        
#No.FUN-810087---End 
   DEFINE tm  RECORD
             #wc      VARCHAR(500),   #TQC-630166 mark
              wc      STRING,      #TQC-630166
              s       LIKE type_file.chr3,   #No.FUN-680136 VARCHAR(3)
              t       LIKE type_file.chr3,   #No.FUN-680136 VARCHAR(3)
              u       LIKE type_file.chr3,   #No.FUN-680136 VARCHAR(3)
              amt_sw  LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(1)
              sel_sw  LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(1)
              iqc_sw  LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(1)
              sel_sw_c LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(1)
              sub     LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(1)
              more    LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
              END RECORD,
          g_orderA    ARRAY[3] OF LIKE aaf_file.aaf03   #No.FUN-680136 VARCHAR(40)
 
   DEFINE   g_i       LIKE type_file.num5    #count/index for any purpose  #No.FUN-680136 SMALLINT
#No.FUN-580004 --start--
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_sma115        LIKE sma_file.sma115
DEFINE   g_sma116        LIKE sma_file.sma116
#No.FUN-580004 --end--
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
#No.FUN-810087---Begin                                                                                                              
    LET g_sql = " rva01.rva_file.rva01,",                                                                                           
                " rva05.rva_file.rva05,",                                                                                           
                " rva06.rva_file.rva06,",                                                                                           
                " rvb02.rvb_file.rvb02,",                                                                                           
                " rvb03.rvb_file.rvb03,",                                                                                           
                " rvb04.rvb_file.rvb04,",                                                                                           
                " rvb05.rvb_file.rvb05,",                                                                                           
                " rvb07.rvb_file.rvb07,",                                                                                           
                " rvb08.rvb_file.rvb08,",                                                                                           
                " rvb19.rvb_file.rvb19,",                                                                                           
                " rvb22.rvb_file.rvb22,",                                                                                           
                " rvb29.rvb_file.rvb29,",                                                                                           
                " rvb30.rvb_file.rvb30,",                                                                                           
                " rvb31.rvb_file.rvb31,",                                                                                           
                " pmn07.pmn_file.pmn07,",                                                                                           
                " pmn041.pmn_file.pmn041,",                                                                                         
                " pmc03.pmc_file.pmc03,",                                                                                           
                " ima021.ima_file.ima021,",                                                                                         
                " l_str2.type_file.chr1000"  
   LET l_table = cl_prt_temptable('apmr510',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?) "                                                                 
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
#No.FUN-810087---End    
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   LET tm.sel_sw  = ARG_VAL(11)
   LET tm.sel_sw_c  = ARG_VAL(12)
   LET tm.sub     = ARG_VAL(13)
#--------------No.TQC-610085 modify
   LET tm.iqc_sw     = ARG_VAL(14)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   LET g_rpt_name = ARG_VAL(18)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#--------------No.TQC-610085 end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r510_tm(0,0)
      ELSE CALL r510()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r510_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW r510_w AT p_row,p_col WITH FORM "apm/42f/apmr510"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.s    = '123'
   LET tm.sel_sw = '3'
   LET tm.iqc_sw = '3'
   LET tm.sel_sw_c='3'
   LET tm.sub    = '3'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
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
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON rva01, rva06, rva05, rvb05, rvb04
#No.FUN-570243 --start--
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP
            IF INFIELD(rvb05) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rvb05
               NEXT FIELD rvb05
            END IF
            #TQC-B80174--add--str--
            IF INFIELD(rva01) THEN
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_rvall03"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO rva01
                NEXT FIELD rva01
            END IF
            IF INFIELD(rvb04) THEN
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_pmm1"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO rvb04
                NEXT FIELD rvb04
            END IF
            #TQC-B80174--add--end--
#No.FUN-570243 --end--
 
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
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r510_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
         EXIT PROGRAM
      END IF
      IF tm.wc != ' 1=1' THEN EXIT WHILE END IF
      CALL cl_err('',9046,0)
   END WHILE
#UI
   INPUT BY NAME
                 #UI
                 tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3, tm2.u1,tm2.u2,tm2.u3,
            tm.sel_sw,tm.iqc_sw,tm.sel_sw_c,tm.sub,tm.more
            WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD sel_sw
         IF tm.sel_sw NOT MATCHES '[123]' OR cl_null(tm.sel_sw) THEN
             NEXT FIELD sel_sw
         END IF
      AFTER FIELD iqc_sw
         IF tm.iqc_sw NOT MATCHES '[123]' OR cl_null(tm.iqc_sw) THEN
             NEXT FIELD iqc_sw
         END IF
      #   IF tm.iqc_sw='2' THEN  #MOD-530173
     #      LET tm.sel_sw_c='3'
     #      DISPLAY BY NAME tm.sel_sw_c
     #   END IF
     #BEFORE FIELD sel_sw_c
     #   IF tm.iqc_sw='2' THEN NEXT FIELD sub END IF
      AFTER FIELD sel_sw_c
         IF tm.sel_sw_c NOT MATCHES '[123]' OR cl_null(tm.sel_sw_c) THEN
             NEXT FIELD sel_sw_c
         END IF
      AFTER FIELD sub
         #IF tm.iqc_sw='2' THEN  #MOD-530173
        #   NEXT FIELD iqc_sw
        #ELSE
        #   NEXT FIELD sel_sw_c
        #END IF
         IF tm.sub NOT MATCHES '[123]' THEN NEXT FIELD sub END IF
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()
      #UI
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
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r510_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='apmr510'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr510','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",tm.sel_sw CLIPPED,"'",
                         " '",tm.sel_sw_c CLIPPED,"'",
                         " '",tm.sub    CLIPPED,"'",
                         " '",tm.iqc_sw  CLIPPED,"'",        #No.TQC-610085 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmr510',g_time,l_cmd)
      END IF
      CLOSE WINDOW r510_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r510()
   ERROR ""
END WHILE
   CLOSE WINDOW r510_w
END FUNCTION
 
FUNCTION r510()
   DEFINE l_name    LIKE type_file.chr20,        # External(Disk) file name            #No.FUN-680136 VARCHAR(20)
          l_time    LIKE type_file.chr8,         # Used time for running the job       #No.FUN-680136 VARCHAR(8)
         #l_sql     LIKE type_file.chr1000,      # RDSQL STATEMENT   #TQC-630166 mark  #No.FUN-680136 
          l_sql     STRING,                      # RDSQL STATEMENT   #TQC-630166
          l_chr     LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,      #No.FUN-680136 VARCHAR(40)
#         l_order   ARRAY[5] OF VARCHAR(10),
          l_order   ARRAY[5] OF LIKE aaf_file.aaf03,            #No.FUN-680136 VARCHAR(40)
#          sr               RECORD order1 VARCHAR(10),
#                                  order2 VARCHAR(10),
#                                  order3 VARCHAR(10),
#No.FUN-550060 --start--
          sr               RECORD order1 LIKE aaf_file.aaf03,   #No.FUN-680136 VARCHAR(40)
                                  order2 LIKE aaf_file.aaf03,   #No.FUN-680136 VARCHAR(40)
                                  order3 LIKE aaf_file.aaf03,   #No.FUN-680136 VARCHAR(40)
#No.FUN-550060 --end--
                                  rva01 LIKE rva_file.rva01,  #驗收單號
                                  rva05 LIKE rva_file.rva05,  #廠商編號
                                  rva06 LIKE rva_file.rva06,  #驗收日期
                                  rvb02 LIKE rvb_file.rvb02,  #驗收單項次
                                  rvb03 LIKE rvb_file.rvb03,  #採購單項次
                                  rvb04 LIKE rvb_file.rvb04,  #採購單號
                                  rvb05 LIKE rvb_file.rvb05,  #料號
                                  rvb07 LIKE rvb_file.rvb07,  #實收量
                                  rvb08 LIKE rvb_file.rvb08,  #收貨數量
                                  rvb19 LIKE rvb_file.rvb19,  #收貨狀況
                                  rvb22 LIKE rvb_file.rvb22,  #收貨狀況
                                  rvb30 LIKE rvb_file.rvb30,  #巳入庫量
                                  rvb29 LIKE rvb_file.rvb29,
                                  rvb31 LIKE rvb_file.rvb31,
                                  pmn041 LIKE pmn_file.pmn041,#品名
                                  pmn07 LIKE pmn_file.pmn07,  #採購單位
                                  rvb10 LIKE rvb_file.rvb10,  #收料單價
                                  pmc03 LIKE pmc_file.pmc03,  #簡稱
                                  mony  LIKE pmn_file.pmn31,  #金額
                                  azi03 LIKE azi_file.azi03,
                                  azi04 LIKE azi_file.azi04,
                                  azi05 LIKE azi_file.azi05,
#No.FUN-580004 --start--
                                  pmn80 LIKE pmn_file.pmn80,
                                  pmn82 LIKE pmn_file.pmn82,
                                  pmn83 LIKE pmn_file.pmn83,
                                  pmn85 LIKE pmn_file.pmn85
                        END RECORD
     DEFINE l_i,l_cnt          LIKE type_file.num5          #No.FUN-680136 SMALLINT
     DEFINE l_zaa02            LIKE zaa_file.zaa02
     DEFINE i                  LIKE type_file.num5          #No.FUN-680136 SMALLINT
#No.FUN-580004 --end--
     DEFINE l_ima906       LIKE ima_file.ima906             #No.FUN-810087                                                          
     DEFINE l_str2         LIKE type_file.chr1000           #No.FUN-810087                                                          
     DEFINE l_pmn85        STRING                           #No.FUN-810087                                                          
     DEFINE l_pmn82        STRING                           #No.FUN-810087                                                          
     DEFINE l_ima021       LIKE ima_file.ima021             #No.FUN-810087                                                          
                                                                                                                                    
     CALL cl_del_data(l_table)                              #No.FUN-810087                                                          
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog  #No.FUN-810087
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file   #FUN-580004
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND rvauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND rvagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND rvagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rvauser', 'rvagrup')
     #End:FUN-980030

     #No.FUN-B80145---Begin---mark
     #LET l_sql = "SELECT '','','',",
     #            " rva01, rva05, rva06, rvb02, rvb03, rvb04, rvb05, ",
     #            " rvb07, rvb08, rvb19, rvb22, rvb30, rvb29, rvb31, ",
     #            " pmn041, pmn07, rvb10, pmc03,",
     #            " 0, azi03, azi04, azi05, ",
     #            " pmn80,pmn82,pmn83,pmn85 ",  #No.FUN-580004
     #            " FROM rva_file, rvb_file, pmm_file, pmn_file,",
     #            " OUTER pmc_file, OUTER  azi_file",
     #            " WHERE rva01 = rvb01 ",
     #            " AND rvaconf !='X' ",
     #            " AND pmm01 = rvb04 ",
     #            " AND pmn01 = pmm01 ",
     #            " AND pmn02 = rvb03 ",
     #            " AND pmc_file.pmc01 = rva_file.rva05 ",
     #            " AND azi_file.azi01 = pmm_file.pmm22  ",
     #            " AND pmm18 <> 'X' AND ", tm.wc CLIPPED
     #No.FUN-B80145---End---mark

     #No.FUN-B80145---Begin---add
     LET l_sql = "SELECT '','','',",
                 " rva01, rva05, rva06, rvb02, rvb03, rvb04, rvb05, ",
                 " rvb07, rvb08, rvb19, rvb22, rvb30, rvb29, rvb31, ",
                 " pmn041, pmn07, rvb10, pmc03,",
                 " 0, azi03, azi04, azi05, ",
                 " pmn80,pmn82,pmn83,pmn85 ",
                 " FROM rva_file ", 
                 " INNER JOIN rvb_file ON rva_file.rva01 = rvb_file.rvb01 ",
                 " INNER JOIN pmm_file ON pmm_file.pmm01 = rvb_file.rvb04 ",
                 " INNER JOIN pmn_file ON pmn_file.pmn01 = pmm_file.pmm01 ",
                 " AND pmn_file.pmn02 = rvb_file.rvb03 ",
                 " LEFT OUTER JOIN pmc_file ON pmc_file.pmc01 = rva_file.rva05 ", 
                 " LEFT OUTER JOIN azi_file ON azi_file.azi01 = pmm_file.pmm22 ",
                 " WHERE rvaconf !='X' ",
                 " AND pmm18 <> 'X' AND ", tm.wc CLIPPED
                 
     LET l_sql = l_sql,
                 " UNION ALL ", 
                 " SELECT '','','',",
                 " rva01, rva05, rva06, rvb02, rvb03, rvb04, rvb05, ",
                 " rvb07, rvb08, rvb19, rvb22, rvb30, rvb29, rvb31, ",
                 " ima02, rvb90, rvb10, pmc03,",
                 " 0, azi03, azi04, azi05, ",
                 " rvb80,rvb82,rvb83,rvb85 ", 
                 " FROM rva_file ", 
                 " INNER JOIN rvb_file ON rva_file.rva01 = rvb_file.rvb01 ",
                 " LEFT OUTER JOIN ima_file ON ima_file.ima01  = rvb_file.rvb05 ",
                 " LEFT OUTER JOIN pmc_file ON pmc_file.pmc01 = rva_file.rva05 ", 
                 " LEFT OUTER JOIN azi_file ON azi_file.azi01 = rva_file.rva113 ",
                 " WHERE rvaconf !='X' ",
                 " AND rva00 ='2' AND ", tm.wc CLIPPED
     #No.FUN-B80145---End---add     
     
     IF tm.sel_sw = '1' THEN                 #已確認
        LET l_sql = l_sql CLIPPED," AND rvaconf='Y' "
     END IF
     IF tm.sel_sw = '2' THEN                 #未確認
        LET l_sql = l_sql CLIPPED," AND rvaconf='N' "
     END IF
     IF tm.iqc_sw = '1' THEN
        LET l_sql = l_sql CLIPPED," AND rvb39='Y'" #no.7143
     END IF
     IF tm.iqc_sw = '2' THEN
        LET l_sql = l_sql CLIPPED," AND rvb39='N'" #no.7143
     END IF
     IF tm.sel_sw_c = '1' THEN
        LET l_sql = l_sql CLIPPED," AND rvb39='Y' AND rvb40 IS NULL" #no.7143
     END IF
     IF tm.sel_sw_c = '2' THEN
        LET l_sql = l_sql CLIPPED," AND rvb39='Y' AND rvb40 IS NOT NULL" #no.7143
     END IF
     PREPARE r510_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
     END IF
     DECLARE r510_curs1 CURSOR FOR r510_prepare1
#     CALL cl_outnam('apmr510') RETURNING l_name  #No.FUN-810087
 
#No.FUN-580004  --start
     IF g_sma115 = "Y" THEN
#            LET g_zaa[63].zaa06 = "N"     #No.FUN-810087
             LET l_name = 'apmr510'        #No.FUN-810087  
     ELSE
             LET l_name = 'apmr510_1'      #No.FUN-810087              
#            LET g_zaa[63].zaa06 = "Y"     #No.FUN-810087
     END IF
#     CALL cl_prt_pos_len()                #No.FUN-810087
#No.FUN-580004 --end--
#    IF cl_prichk('$') THEN
#         LET tm.amt_sw = 'Y'
#    ELSE LET tm.amt_sw = 'N'
#    END IF
     LET tm.amt_sw = 'N'
#     START REPORT r510_rep TO l_name   #No.FUN-810087  
#     LET g_pageno = 0                  #No.FUN-810087  
     FOREACH r510_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
          IF tm.sub = '1' THEN
             IF sr.rvb19 ='2' THEN CONTINUE FOREACH END IF
          END IF
          IF tm.sub = '2' THEN
             IF sr.rvb19 ='1' THEN CONTINUE FOREACH END IF
          END IF
          IF cl_null(sr.azi03) THEN LET sr.azi03 = 0 END IF
          IF cl_null(sr.azi04) THEN LET sr.azi04 = 0 END IF
          IF cl_null(sr.azi05) THEN LET sr.azi05 = 0 END IF
#         IF NOT cl_prichk('$') THEN LET sr.rvb10 = NULL END IF
 
          LET sr.mony = sr.rvb30 * sr.rvb10
          IF sr.mony IS NULL THEN LET sr.mony = 0 END IF
#No.FUN-810087---Begin 
#          FOR g_i = 1 TO 3
#              CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.rva01
#                                            LET g_orderA[g_i]= g_x[24]
#                   WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.rva06 USING 'YYYYMMDD'
#                                            LET g_orderA[g_i]= g_x[25]
#                   WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.rva05
#                                            LET g_orderA[g_i]= g_x[26]
#                   WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.rvb05
#                                            LET g_orderA[g_i]= g_x[27]
#                   WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.rvb04
#                                            LET g_orderA[g_i]= g_x[28]
#                   OTHERWISE LET l_order[g_i]  = '-'
#                             LET g_orderA[g_i] = ' '          #清為空白
#              END CASE
#          END FOR
#          LET sr.order1 = l_order[1]
#          LET sr.order2 = l_order[2]
#          LET sr.order3 = l_order[3]
      SELECT ima906 INTO l_ima906 FROM ima_file                                                                                     
                         WHERE ima01=sr.rvb05                                                                                       
      LET l_str2 = ""                                                                                                               
      IF g_sma115 = "Y" THEN                                                                                                        
         CASE l_ima906                                                                                                              
            WHEN "2"                                                                                                                
                CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85                                                                     
                LET l_str2 = l_pmn85 , sr.pmn83 CLIPPED                                                                             
                IF cl_null(sr.pmn85) OR sr.pmn85 = 0 THEN                                                                           
                    CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82                                                                 
                    LET l_str2 = l_pmn82, sr.pmn80 CLIPPED                                                                          
                ELSE                                                                                                                
                   IF NOT cl_null(sr.pmn82) AND sr.pmn82 > 0 THEN                                                                   
                      CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82                                                               
                      LET l_str2 = l_str2 CLIPPED,',',l_pmn82, sr.pmn80 CLIPPED                                                     
                   END IF                                                                                                           
                END IF      
            WHEN "3"                                                                                                                
                IF NOT cl_null(sr.pmn85) AND sr.pmn85 > 0 THEN                                                                      
                    CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85                                                                 
                    LET l_str2 = l_pmn85 , sr.pmn83 CLIPPED                                                                         
                END IF                                                                                                              
         END CASE                                                                                                                   
      ELSE                                                                                                                          
      END IF                                                                                                                        
      #-----MOD-AA0005---------
      LET l_ima021 = NULL
      SELECT ima021 INTO l_ima021 FROM ima_file
       WHERe ima01= sr.rvb05
      #-----END MOD-AA0005-----
           EXECUTE insert_prep USING sr.rva01,sr.rva05,sr.rva06,sr.rvb02,sr.rvb03,                                                  
                                     sr.rvb04,sr.rvb05,sr.rvb07,sr.rvb08,sr.rvb19,                                                  
                                     sr.rvb22,sr.rvb29,sr.rvb30,sr.rvb31,sr.pmn07,                                                  
                                     sr.pmn041,sr.pmc03,l_ima021,l_str2 
#          OUTPUT TO REPORT r510_rep(sr.*)
#No.FUN-810087---End 
     END FOREACH
#No.FUN-810087---Begin
#     FINISH REPORT r510_rep
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'rva01,rva06,rva05,rvb05,rvb04')                                                                       
              RETURNING tm.wc                                                                                                       
      END IF                                                                                                                        
      LET g_str=tm.wc ,";",tm.s[1,1],";", tm.s[2,2],";",                                                                            
                      tm.s[3,3],";",tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",                                                      
                      tm.u[1,1],";",tm.u[2,2],";",tm.u[3,3]                                                                         
                                                                                                                                    
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                                               
   CALL cl_prt_cs3('apmr510',l_name,l_sql,g_str)  
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-810087---End  
END FUNCTION
#No.FUN-810087---Begin 
#REPORT r510_rep(sr)
#  DEFINE l_ima021     LIKE ima_file.ima021   #FUN-4C0095
#  DEFINE l_last_sw    LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(1)
#         sr               RECORD order1 LIKE aaf_file.aaf03,   #No.FUN-680136 VARCHAR(40)
#                                 order2 LIKE aaf_file.aaf03,   #No.FUN-680136 VARCHAR(40)
#                                 order3 LIKE aaf_file.aaf03,   #No.FUN-680136 VARCHAR(40)
#                                 rva01 LIKE rva_file.rva01,  #驗收單號
#                                 rva05 LIKE rva_file.rva05,  #廠商編號
#                                 rva06 LIKE rva_file.rva06,  #驗收日期
#                                 rvb02 LIKE rvb_file.rvb02,  #驗收單項次
#                                 rvb03 LIKE rvb_file.rvb03,  #採購單項次
#                                 rvb04 LIKE rvb_file.rvb04,  #採購單號
#                                 rvb05 LIKE rvb_file.rvb05,  #料號
#                                 rvb07 LIKE rvb_file.rvb07,  #實收量
#                                 rvb08 LIKE rvb_file.rvb08,  #收貨數量
#                                 rvb19 LIKE rvb_file.rvb19,  #收貨狀況
#                                 rvb22 LIKE rvb_file.rvb22,  #收貨狀況
#                                 rvb30 LIKE rvb_file.rvb30,  #巳入庫量
#                                 rvb29 LIKE rvb_file.rvb29,
#                                 rvb31 LIKE rvb_file.rvb31,
#                                 pmn041 LIKE pmn_file.pmn041,#品名
#                                 pmn07 LIKE pmn_file.pmn07,  #採購單位
#                                 rvb10 LIKE rvb_file.rvb10,  #收料單價
#                                 pmc03 LIKE pmc_file.pmc03,  #簡稱
#                                 mony  LIKE pmn_file.pmn31,  #金額
#                                 azi03 LIKE azi_file.azi03,
#                                 azi04 LIKE azi_file.azi04,
#                                 azi05 LIKE azi_file.azi05,
##No.FUN-580004 --start--
#                                 pmn80 LIKE pmn_file.pmn80,
#                                 pmn82 LIKE pmn_file.pmn82,
#                                 pmn83 LIKE pmn_file.pmn83,
#                                 pmn85 LIKE pmn_file.pmn85
#                       END RECORD
# DEFINE l_ima906       LIKE ima_file.ima906
##DEFINE l_str2         VARCHAR(100)   #TQC-630166 mark
# DEFINE l_str2         STRING      #TQC-630166
# DEFINE l_pmn85        STRING
# DEFINE l_pmn82        STRING
##No.FUN-580004 --end--
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.order1,sr.order2,sr.order3
# FORMAT
#  PAGE HEADER
 
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#     PRINT COLUMN 01,g_x[32] CLIPPED, g_orderA[1] CLIPPED,'-',g_orderA[2] CLIPPED,
#           '-',g_orderA[3] CLIPPED
#     PRINT g_dash
#No.FUN-580004 --start--
#     PRINTX name=H1 g_x[41],g_x[42],g_x[64],g_x[43],g_x[44],g_x[45],g_x[46],g_x[65],g_x[47],g_x[63],g_x[48],g_x[49],g_x[50],g_x[51],g_x[52]
#     PRINTX name=H2 g_x[53],g_x[54],g_x[66],g_x[55],g_x[56],g_x[57]
#     PRINTX name=H3 g_x[58],g_x[59],g_x[68],g_x[60],g_x[61],g_x[62]
#No.FUN-580004 --end--
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.order1
#     IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#        THEN SKIP TO TOP OF PAGE
#     END IF
 
#  BEFORE GROUP OF sr.order2
#     IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#        THEN SKIP TO TOP OF PAGE
#     END IF
 
#  BEFORE GROUP OF sr.order3
#     IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#        THEN SKIP TO TOP OF PAGE
#     END IF
 
#  ON EVERY ROW
#     SELECT ima021 INTO l_ima021 FROM ima_file
#      WHERe ima01= sr.rvb05
#No.FUN-580004 --start--
#     SELECT ima906 INTO l_ima906 FROM ima_file
#                        WHERE ima01=sr.rvb05
#     LET l_str2 = ""
#     IF g_sma115 = "Y" THEN
#        CASE l_ima906
#           WHEN "2"
#               CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85
#               LET l_str2 = l_pmn85 , sr.pmn83 CLIPPED
#               IF cl_null(sr.pmn85) OR sr.pmn85 = 0 THEN
#                   CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82
#                   LET l_str2 = l_pmn82, sr.pmn80 CLIPPED
#               ELSE
#                  IF NOT cl_null(sr.pmn82) AND sr.pmn82 > 0 THEN
#                     CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82
#                     LET l_str2 = l_str2 CLIPPED,',',l_pmn82, sr.pmn80 CLIPPED
#                  END IF
#               END IF
#           WHEN "3"
#               IF NOT cl_null(sr.pmn85) AND sr.pmn85 > 0 THEN
#                   CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85
#                   LET l_str2 = l_pmn85 , sr.pmn83 CLIPPED
#               END IF
#        END CASE
#     ELSE
#     END IF
#     IF sr.rvb19 = '2' THEN
#         PRINTX name=D1 COLUMN g_c[41],'*';  #No.TQC-6C0079
##         PRINTX name=D1 COLUMN g_x[41],'*';  #No.TQC-6C0079
#     ELSE
#         PRINTX name=D1 COLUMN g_c[41],' ';  #No.TQC-6C0079
##         PRINTX name=D1 COLUMN g_x[41],' ';  #No.TQC-6C0079
#     END IF
#     PRINTX name=D1 COLUMN g_c[42], sr.rva01,
#                    COLUMN g_c[64], sr.rvb02 USING '###&', #FUN-590118
#                    COLUMN g_c[43], sr.rva06,
#                    COLUMN g_c[44], sr.rva05,
#                    COLUMN g_c[45], sr.rvb05 CLIPPED, #FUN-5B0014 [1,20],  #No.FUN-580004
#                    COLUMN g_c[46], sr.rvb04,
#                    COLUMN g_c[65], sr.rvb03 USING '###&', #FUN-590118
#                    COLUMN g_c[47], cl_numfor(sr.rvb08,47,2),  #收貨數量
#                    COLUMN g_c[63], l_str2 CLIPPED,   #No.FUN-580004
#                    COLUMN g_c[48], sr.pmn07,
#                    COLUMN g_c[49], cl_numfor(sr.rvb07,49,3),
#                    COLUMN g_c[50], cl_numfor(sr.rvb30,50,2),
#                    COLUMN g_c[51], cl_numfor(sr.rvb29,51,2),
#                    COLUMN g_c[52], cl_numfor(sr.rvb31,52,2)
 
#     PRINTX name=D2 COLUMN g_c[53],' ',
#                    COLUMN g_c[54],sr.rvb22,
#                    COLUMN g_c[66],' ',  #No.TQC-6C0079
#                    COLUMN g_c[55],' ',
#                    COLUMN g_c[56],sr.pmc03,
#                    COLUMN g_c[57],sr.pmn041
#     PRINTX name=D3 COLUMN g_c[58],' ',
#                    COLUMN g_c[59],' ',
#                    COLUMN g_c[68],' ',  #No.TQC-6C0079
#                    COLUMN g_c[60],' ',
#                    COLUMN g_c[61],' ',
#                    COLUMN g_c[62],l_ima021
#No.FUN-580004   --end--
#  AFTER GROUP OF sr.order1
#     IF tm.u[1,1] = 'Y' THEN
#        PRINTX name=S1 COLUMN g_c[45], g_orderA[1] CLIPPED,
#                       COLUMN g_c[46], g_x[31] CLIPPED,
#                       COLUMN g_c[47], cl_numfor(GROUP SUM(sr.rvb08),47,2),
#                       COLUMN g_c[49], cl_numfor(GROUP SUM(sr.rvb07),49,2),
#                       COLUMN g_c[50], cl_numfor(GROUP SUM(sr.rvb30),50,2),
#                       COLUMN g_c[51], cl_numfor(GROUP SUM(sr.rvb29),51,2),
#                       COLUMN g_c[52], cl_numfor(GROUP SUM(sr.rvb31),52,2)
#        PRINT ''
#     END IF
 
#  AFTER GROUP OF sr.order2
#     IF tm.u[2,2] = 'Y' THEN
#        PRINTX name=S1 COLUMN g_c[45], g_orderA[2] CLIPPED,
#                       COLUMN g_c[46], g_x[30] CLIPPED,
#                       COLUMN g_c[47], cl_numfor(GROUP SUM(sr.rvb08),47,2),
#                       COLUMN g_c[49], cl_numfor(GROUP SUM(sr.rvb07),49,2),
#                       COLUMN g_c[50], cl_numfor(GROUP SUM(sr.rvb30),50,2),
#                       COLUMN g_c[51], cl_numfor(GROUP SUM(sr.rvb29),51,2),
#                       COLUMN g_c[52], cl_numfor(GROUP SUM(sr.rvb31),52,2)
#        PRINT ''
#     END IF
 
#  AFTER GROUP OF sr.order3
#     IF tm.u[3,3] = 'Y' THEN
#        PRINTX name=S1 COLUMN g_c[45], g_orderA[2] CLIPPED,
#                       COLUMN g_c[46], g_x[29] CLIPPED,
#                       COLUMN g_c[47], cl_numfor(GROUP SUM(sr.rvb08),47,2),
#                       COLUMN g_c[49], cl_numfor(GROUP SUM(sr.rvb07),49,2),
#                       COLUMN g_c[50], cl_numfor(GROUP SUM(sr.rvb30),50,2),
#                       COLUMN g_c[51], cl_numfor(GROUP SUM(sr.rvb29),51,2),
#                       COLUMN g_c[52], cl_numfor(GROUP SUM(sr.rvb31),52,2)
#        PRINT ''
#     END IF
 
#  ON LAST ROW
#        PRINTX name=S1 COLUMN g_c[46], g_x[33] CLIPPED,
#                       COLUMN g_c[47], cl_numfor( SUM(sr.rvb08),47,2),
#                       COLUMN g_c[49], cl_numfor( SUM(sr.rvb07),49,2),
#                       COLUMN g_c[50], cl_numfor( SUM(sr.rvb30),50,2),
#                       COLUMN g_c[51], cl_numfor( SUM(sr.rvb29),51,2),
#                       COLUMN g_c[52], cl_numfor( SUM(sr.rvb31),52,2)
#     IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#        CALL cl_wcchp(tm.wc,'rva01,rva06,rva05,rvb05,rvb04')
#             RETURNING tm.wc
#        #TQC-630166
#        #    IF tm.wc[001,120] > ' ' THEN            # for 132
#        #PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#        #    IF tm.wc[121,240] > ' ' THEN
#        #PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#        #    IF tm.wc[241,300] > ' ' THEN
#        #PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#        PRINT g_dash
#        CALL cl_prt_pos_wc(tm.wc)
#        #END TQC-630166
 
#     END IF
#     PRINT g_x[34] CLIPPED
#     PRINT g_dash
#     LET l_last_sw = 'y'
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_x[34] CLIPPED
#             PRINT g_dash
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE SKIP 3 LINE
#     END IF
#END REPORT
#No.FUN-810087---End 
