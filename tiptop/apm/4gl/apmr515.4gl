# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmr515.4gl
# Descriptions...: 廠商進料入庫明細表作業
# Date & Author..: 93/05/17  By  Apple
# Modify         : 95/06/26 by nick 加入退貨的考慮
# Modify.........: NO.MOD-490032 04/09/02 by Smapmin 修正排序順序
# Modify.........: No.FUN-4B0022 04/11/04 By Yuna 新增料號,廠商,採購單號開窗
# Modify.........: No.FUN-4C0095 04/12/27 By Mandy 報表轉XML
# Modify.........: No.FUN-550067  05/06/03 By yoyo單據編號格式放大
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.MOD-610006 06/12/03 By Nicola 收料單價(rvb10)應抓sr.azi03
# Modify.........: No.MOD-630054 06/03/14 By Mandy 報表列印的收貨量應該列印 rvb07(實收數量) 而非 rvb08
# Modify.........: No.FUN-680136 06/09/04 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.TQC-6B0095 06/11/15 By Ray 調整“接下頁”和“結束”的位置
# Modify.........: No.MOD-6C0109 06/12/19 By Sarah 金額應抓取單價*計價數量(rvb87)
# Modify.........: No.TQC-6C0124 06/12/22 By jamie 依sam116判斷是否列印"入庫單位"""計價單位""計價數量"
# Modify.........: No.FUN-7C0034 07/12/26 By sherry 報表改由CR輸出  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80145 11/09/07 By Sakura 加入取apmt111無採購單號資料
# Modify.........: No.FUN-C30285 12/03/27 By bart 增加批號作業編號for ICD
# Modify.........: No:TQC-D10042 13/01/08 By xuxz 添加收貨單號開窗q_rvaaqc_cs
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
             #wc      VARCHAR(500),   #TQC-630166 mark
              wc      STRING,      #TQC-630166
              s       LIKE type_file.chr3,     #No.FUN-680136 VARCHAR(3)
              sub     LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(1)
              b       LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(1)
              more    LIKE type_file.chr1      #No.FUN-680136 VARCHAR(1)
              END RECORD
 
   DEFINE g_i         LIKE type_file.num5     #count/index for any purpose  #No.FUN-680136 SMALLINT
   #No.FUN-7C0034---Begin                                                          
   DEFINE g_sql     STRING                                                         
   DEFINE g_str     STRING                                                         
   DEFINE l_table   STRING                                                         
   #No.FUN-7C0034---End  
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
   #FUN-C30285---begin
   IF s_industry("icd") THEN
      LET g_sql = "rva05.rva_file.rva05,",
                  "pmc03.pmc_file.pmc03,",
                  "rvb19.rvb_file.rvb19,",
                  "rva01.rva_file.rva01,",
                  "rvb02.rvb_file.rvb02,",
                  "rvb22.rvb_file.rvb22,",
                  "rvb34.rvb_file.rvb34,",
                  "rva06.rva_file.rva06,",
                  "rvb05.rvb_file.rvb05,",
                  "pmn041.pmn_file.pmn041,",
                  "ima021.ima_file.ima021,",
                  "rvb04.rvb_file.rvb04,",
                  "rvb03.rvb_file.rvb03,",
                  "pmm22.pmm_file.pmm22,",
                  "rvb07.rvb_file.rvb07,",
                  "rvv35.rvv_file.rvv35,",
                  "rvb30.rvb_file.rvb30,",
                  "rvb10.rvb_file.rvb10,",
                  "rvb86.rvb_file.rvb86,",
                  "rvb87.rvb_file.rvb87,",
                  "rvb08.rvb_file.rvb08,",
                  "pmm42.pmm_file.pmm42,",
                  "azi03.azi_file.azi03,",
                  "azi04.azi_file.azi04,",
                  "rvb38.rvb_file.rvb38,",         #FUN-C30285
                  "rvbiicd03.rvbi_file.rvbiicd03"  #FUN-C30285
   ELSE 
   #FUN-C30285---end
   #No.FUN-7C0034---Begin
      LET g_sql = "rva05.rva_file.rva05,",
                  "pmc03.pmc_file.pmc03,",
                  "rvb19.rvb_file.rvb19,",
                  "rva01.rva_file.rva01,",
                  "rvb02.rvb_file.rvb02,",
                  "rvb22.rvb_file.rvb22,",
                  "rvb34.rvb_file.rvb34,",
                  "rva06.rva_file.rva06,",
                  "rvb05.rvb_file.rvb05,",
                  "pmn041.pmn_file.pmn041,",
                  "ima021.ima_file.ima021,",
                  "rvb04.rvb_file.rvb04,",
                  "rvb03.rvb_file.rvb03,",
                  "pmm22.pmm_file.pmm22,",
                  "rvb07.rvb_file.rvb07,",
                  "rvv35.rvv_file.rvv35,",
                  "rvb30.rvb_file.rvb30,",
                  "rvb10.rvb_file.rvb10,",
                  "rvb86.rvb_file.rvb86,",
                  "rvb87.rvb_file.rvb87,",
                  "rvb08.rvb_file.rvb08,",
                  "pmm42.pmm_file.pmm42,",
                  "azi03.azi_file.azi03,",
                  "azi04.azi_file.azi04 "
   END IF        #FUN-C30285
   LET l_table = cl_prt_temptable('apmr512',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF  
   #FUN-C30285---begin
   IF s_industry("icd") THEN  
      LET g_sql = "INSERT INTO ", g_cr_db_str CLIPPED,l_table CLIPPED,             
                  " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
                  "        ?,?,?,?,?, ?,?,?,?,?, ?) "   #FUN-C30285
   ELSE 
   #FUN-C30285---end
      LET g_sql = "INSERT INTO ", g_cr_db_str CLIPPED,l_table CLIPPED,             
                  " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
                  "        ?,?,?,?,?, ?,?,?,?) "
   END IF #FUN-C30285     
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF                                
   #No.FUN-7C0034---End
 
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.s     = ARG_VAL(8)
   LET tm.sub   = ARG_VAL(9)
   LET tm.b     = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r515_tm(0,0)
      ELSE CALL r515()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r515_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 12
 
   OPEN WINDOW r515_w AT p_row,p_col WITH FORM "apm/42f/apmr515"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.s      = '345'
   LET tm.sub    = '3'
   LET tm.b      = '3'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
 
WHILE TRUE
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON rva01,rva05,rva06,rvb04,rvb05
   #--No.FUN-4B0022-------
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
   ON ACTION CONTROLP
     CASE WHEN INFIELD(rva05)      #廠商編號
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
               LET g_qryparam.form = "q_pmc"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rva05
               NEXT FIELD rva05
          WHEN INFIELD(rvb04)      #採購單號
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
               LET g_qryparam.form = "q_pmm602"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rvb04
               NEXT FIELD rvb04
          WHEN INFIELD(rvb05)      #料件編號
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
               LET g_qryparam.form = "q_ima1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rvb05
               NEXT FIELD rvb05
         #TQC-D10042-add--str--收貨單號開窗
          WHEN INFIELD(rva01)      #
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
               LET g_qryparam.form = "q_rvaaqc_cs"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rva01
               NEXT FIELD rva01
         #TQC-D10042 --add--end
     OTHERWISE EXIT CASE
     END CASE
   #--END---------------
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
         CLOSE WINDOW r515_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
         EXIT PROGRAM
      END IF
      IF tm.wc != ' 1=1' THEN EXIT WHILE END IF
      CALL cl_err('',9046,0)
   END WHILE
#UI
   INPUT BY NAME tm.sub,tm.b,tm2.s1,tm2.s2,tm2.s3,tm.more
            WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD sub
         IF tm.sub NOT MATCHES '[123]' THEN NEXT FIELD sub END IF
      AFTER FIELD b
         IF tm.b NOT MATCHES '[123]' OR cl_null(tm.b) THEN
            NEXT FIELD b
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
      ON ACTION CONTROLG CALL cl_cmdask()
      #UI
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
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
      CLOSE WINDOW r515_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='apmr515'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr515','9031',1)
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
                         " '",tm.s     CLIPPED,"'",
                         " '",tm.sub    CLIPPED,"'",
                         " '",tm.b    CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmr515',g_time,l_cmd)
      END IF
      CLOSE WINDOW r515_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r515()
   ERROR ""
END WHILE
   CLOSE WINDOW r515_w
END FUNCTION
 
FUNCTION r515()
   DEFINE l_name    LIKE type_file.chr20,       # External(Disk) file name        #No.FUN-680136 VARCHAR(20)
          l_time    LIKE type_file.chr8,        # Used time for running the job   #No.FUN-680136 VARCHAR(8)
         #l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT   #TQC-630166 mark  #No.FUN-680136 VARCHAR(1000)
          l_sql     STRING,                     # RDSQL STATEMENT   #TQC-630166
          l_chr     LIKE type_file.chr1,        #No.FUN-680136 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,     #No.FUN-680136 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE aaf_file.aaf03,              #No.FUN-680136 VARCHAR(40)
          sr               RECORD order1 LIKE aaf_file.aaf03,     #No.FUN-680136 VARCHAR(40)
                                  order2 LIKE aaf_file.aaf03,     #No.FUN-680136 VARCHAR(40)
                                  order3 LIKE aaf_file.aaf03,     #No.FUN-680136 VARCHAR(40)
                                 rva01 LIKE rva_file.rva01,  #驗收單號
                                 rva05 LIKE rva_file.rva05,  #廠商編號
                                 rva06 LIKE rva_file.rva06,  #驗收日期
                                 rvb02 LIKE rvb_file.rvb02,  #驗收單項次
                                 rvb03 LIKE rvb_file.rvb03,  #採購單項次
                                 rvb04 LIKE rvb_file.rvb04,  #採購單號
                                 rvb05 LIKE rvb_file.rvb05,  #料號
                                 rvb07 LIKE rvb_file.rvb07,  #實收量
                                 rvb08 LIKE rvb_file.rvb08,  #收貨數量
                                 rvb19 LIKE rvb_file.rvb19,  #
                                 rvb22 LIKE rvb_file.rvb22,  #發票號碼
                                 rvb30 LIKE rvb_file.rvb30,  #巳入庫量
                                 rvb87 LIKE rvb_file.rvb87,  #計價數量   #MOD-6C0109
                                 rvb29 LIKE rvb_file.rvb29,  #退貨量
                                 rvb31 LIKE rvb_file.rvb31,  #可入庫量
                                 pmn041 LIKE pmn_file.pmn041,#品名
                                 rvb34 LIKE rvb_file.rvb34,  #工單
                                 pmn07 LIKE pmn_file.pmn07,  #採購單位
                                 rvb10 LIKE rvb_file.rvb10,  #收料單價
                                 pmc03 LIKE pmc_file.pmc03,  #簡稱
                                 pmm22 LIKE pmm_file.pmm22,  #幣別
                                 pmm42 LIKE pmm_file.pmm42,
                                 azi03 LIKE azi_file.azi03,
                                 azi04 LIKE azi_file.azi04,
                                 azi05 LIKE azi_file.azi05,
                                 rvb86 LIKE rvb_file.rvb86,  #計價單位   #TQC-6C0124 add
                                 rvv35 LIKE rvv_file.rvv35   #入庫單位   #TQC-6C0124 add
 
                        END RECORD
     DEFINE l_ima021     LIKE ima_file.ima021    #No.FUN-7C0034
     DEFINE l_rvb38      LIKE rvb_file.rvb38      #FUN-C30285
     DEFINE l_rvbiicd03  LIKE rvbi_file.rvbiicd03 #FUN-C30285
     CALL cl_del_data(l_table)                   #No.FUN-7C0034
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog  #No.FUN-7C0034
#No.CHI-6A0004--------------------------------------Begin---------------
#     SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
#                              FROM azi_file
#                             WHERE azi01 = g_aza.aza17
#No.CHI-6A0004--------------------------------------End---------------
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
     #            " rvb07, rvb08, rvb19, rvb22, rvb30, rvb87, rvb29, rvb31, ",   #MOD-6C0109 add rvb87
     #            " pmn041,rvb34, pmn07, rvb10, pmc03,",
     #            " pmm22,pmm42,azi03,azi04,azi05,rvb86 ",#TQC-6C0124 add rvb86
     #            " FROM rva_file, rvb_file, pmm_file, pmn_file,",
     #            " OUTER pmc_file,OUTER azi_file ",
     #            " WHERE rva01 = rvb01 ",
     #            " AND rvb04 = pmm01 ",
     #            " AND pmn01 = pmm01 ",
     #            " AND pmn02 = rvb03 ",
     #            " AND pmc_file.pmc01 = rva_file.rva05 ",
     #            " AND pmm_file.pmm22 = azi_file.azi01 ",
     #            " AND pmm18 !='X' ",
     #            " AND rvaconf !='X' ",
     #            " AND ", tm.wc CLIPPED
     #No.FUN-B80145---End---mark

     #FUN-C30285----begin
     IF s_industry("icd") THEN
        LET l_sql = "SELECT '','','',",
                    " rva01, rva05, rva06, rvb02, rvb03, rvb04, rvb05, ",
                    " rvb07, rvb08, rvb19, rvb22, rvb30, rvb87, rvb29, rvb31, ",
                    " pmn041,rvb34, pmn07, rvb10, pmc03,",
                    " pmm22,pmm42,azi03,azi04,azi05,rvb86,'',rvb38,rvbiicd03 ",  #FUN-C30285
                    " FROM rva_file ", 
                    " INNER JOIN rvb_file ON rva_file.rva01 = rvb_file.rvb01 ",
                    " INNER JOIN rvbi_file ON (rvb_file.rvb01 = rvbi_file.rvbi01 AND rvb_file.rvb02 = rvbi_file.rvbi02)",  #FUN-C30285
                    " INNER JOIN pmm_file ON rvb_file.rvb04 = pmm_file.pmm01 ", 
                    " INNER JOIN pmn_file ON pmn_file.pmn01 = pmm_file.pmm01 ", 
                    " AND pmn_file.pmn02 = rvb_file.rvb03 ",
                    " LEFT OUTER JOIN pmc_file ON pmc_file.pmc01 = rva_file.rva05 ",
                    " LEFT OUTER JOIN azi_file ON pmm_file.pmm22 = azi_file.azi01 ",
                    " WHERE pmm18 !='X' ",
                    " AND rvaconf !='X' ",
                    " AND rva00 ='1' ",
                    " AND ", tm.wc CLIPPED

     LET l_sql = l_sql,
                 " UNION ALL ", 
                 " SELECT '','','',",
                 " rva01, rva05, rva06, rvb02, rvb03, rvb04, rvb05, ",
                 " rvb07, rvb08, rvb19, rvb22, rvb30, rvb87, rvb29, rvb31, ",  
                 " ima02,rvb34, rvb90, rvb10, pmc03,",
                 " rva113,rva114,azi03,azi04,azi05,rvb86,'',rvb38,rvbiicd03  ",  #FUN-C30285
                 " FROM rva_file",
                 " INNER JOIN rvb_file ON rva_file.rva01 = rvb_file.rvb01 ",
                 " INNER JOIN rvbi_file ON (rvb_file.rvb01 = rvbi_file.rvbi01 AND rvb_file.rvb02 = rvbi_file.rvbi02)",  #FUN-C30285
                 " LEFT OUTER JOIN ima_file ON ima_file.ima01  = rvb_file.rvb05 ",
                 " LEFT OUTER JOIN pmc_file ON pmc_file.pmc01  = rva_file.rva05 ",
                 " LEFT OUTER JOIN azi_file ON rva_file.rva113 = azi_file.azi01 ",
                 " WHERE rvaconf !='X' ",
                 " AND rva00 ='2' ",
                 " AND ", tm.wc CLIPPED
     ELSE 
     #FUN-C30285----end
     #No.FUN-B80145---Begin---add
        LET l_sql = "SELECT '','','',",
                    " rva01, rva05, rva06, rvb02, rvb03, rvb04, rvb05, ",
                    " rvb07, rvb08, rvb19, rvb22, rvb30, rvb87, rvb29, rvb31, ",
                    " pmn041,rvb34, pmn07, rvb10, pmc03,",
                    " pmm22,pmm42,azi03,azi04,azi05,rvb86,'','','' ",  #FUN-C30285
                    " FROM rva_file ", 
                    " INNER JOIN rvb_file ON rva_file.rva01 = rvb_file.rvb01 ", 
                    " INNER JOIN pmm_file ON rvb_file.rvb04 = pmm_file.pmm01 ", 
                    " INNER JOIN pmn_file ON pmn_file.pmn01 = pmm_file.pmm01 ", 
                    " AND pmn_file.pmn02 = rvb_file.rvb03 ",
                    " LEFT OUTER JOIN pmc_file ON pmc_file.pmc01 = rva_file.rva05 ",
                    " LEFT OUTER JOIN azi_file ON pmm_file.pmm22 = azi_file.azi01 ",
                    " WHERE pmm18 !='X' ",
                    " AND rvaconf !='X' ",
                    " AND rva00 ='1' ",
                    " AND ", tm.wc CLIPPED

        LET l_sql = l_sql,
                    " UNION ALL ", 
                    " SELECT '','','',",
                    " rva01, rva05, rva06, rvb02, rvb03, rvb04, rvb05, ",
                    " rvb07, rvb08, rvb19, rvb22, rvb30, rvb87, rvb29, rvb31, ",  
                    " ima02,rvb34, rvb90, rvb10, pmc03,",
                    " rva113,rva114,azi03,azi04,azi05,rvb86,'','','' ",   #FUN-C30285
                    " FROM rva_file",
                    " INNER JOIN rvb_file ON rva_file.rva01 = rvb_file.rvb01 ",
                    " LEFT OUTER JOIN ima_file ON ima_file.ima01  = rvb_file.rvb05 ",
                    " LEFT OUTER JOIN pmc_file ON pmc_file.pmc01  = rva_file.rva05 ",
                    " LEFT OUTER JOIN azi_file ON rva_file.rva113 = azi_file.azi01 ",
                    " WHERE rvaconf !='X' ",
                    " AND rva00 ='2' ",
                    " AND ", tm.wc CLIPPED
     #No.FUN-B80145---End---add      
     END IF   #FUN-C30285
     IF tm.b='1' THEN
        LET l_sql = l_sql CLIPPED," AND rvaconf='Y' "
     END IF
     IF tm.b='2' THEN
        LET l_sql = l_sql CLIPPED," AND rvaconf='N' "
     END IF
     PREPARE r515_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
     END IF
     DECLARE r515_curs1 CURSOR FOR r515_prepare1
     #No.FUN-7C0034---Begin
     #CALL cl_outnam('apmr515') RETURNING l_name
     #FUN-C30285---begin
     IF s_industry("icd") THEN 
        IF g_sma.sma116 MATCHES '[13]' THEN
            LET l_name = 'apmr515_2'
        ELSE
            LET l_name = 'apmr515_3'
        END IF
     ELSE 
     #FUN-C30285---end
      ##TQC-6C0124---add---str---
      ##zaa06隱藏否
        IF g_sma.sma116 MATCHES '[13]' THEN
      #     LET g_zaa[46].zaa06 = "N" #入庫單位
      #     LET g_zaa[49].zaa06 = "N" #計價單位
      #     LET g_zaa[50].zaa06 = "N" #計價數量
            LET l_name = 'apmr515'
        ELSE
      #     LET g_zaa[46].zaa06 = "Y" #入庫單位
      #     LET g_zaa[49].zaa06 = "Y" #計價單位
      #     LET g_zaa[50].zaa06 = "Y" #計價數量
            LET l_name = 'apmr515_1'
        END IF
      ##TQC-6C0124---add---end---
     END IF   #FUN-C30285
     #CALL cl_prt_pos_len()    #TQC-6C0124  add
 
     #START REPORT r515_rep TO l_name
     #No.FUN-7C0034---End
     FOREACH r515_curs1 INTO sr.*,l_rvb38,l_rvbiicd03   #FUN-C30285
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
 
         #TQC-6C0124---add---str---
         SELECT rvv35 INTO sr.rvv35
           FROM rvv_file
          WHERE rvv04 = sr.rva01
         #TQC-6C0124---add---end---
 
          IF tm.sub = '1' THEN
             IF sr.rvb19 ='2' THEN CONTINUE FOREACH END IF
          END IF
          IF tm.sub = '2' THEN
             IF sr.rvb19 ='1' THEN CONTINUE FOREACH END IF
          END IF
#         IF NOT cl_prichk('$') THEN LET sr.rvb10 = NULL END IF
          #No.FUN-7C0034---Begin
          #FOR g_i = 1 TO 3
          #     #MOD-490032修正排序順序
          #    CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.rva05
          #         WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.rva06 USING 'YYYYMMDD'
          #         WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.rva01
          #         WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.rvb04
          #         WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.rvb05
          #         OTHERWISE LET l_order[g_i]  = '-'
          #    END CASE
          #     #MOD-490032
          #END FOR
          #LET sr.order1 = l_order[1]
          #LET sr.order2 = l_order[2]
          #LET sr.order3 = l_order[3]
          SELECT ima021
            INTO l_ima021
            FROM ima_file
           WHERE ima01=sr.rvb05
          IF SQLCA.sqlcode THEN
             LET l_ima021 = NULL
          END IF
          #FUN-C30285---begin
          IF s_industry("icd") THEN
             EXECUTE insert_prep USING sr.rva05,sr.pmc03,sr.rvb19,sr.rva01,
                                       sr.rvb02,sr.rvb22,sr.rvb34,sr.rva06,
                                       sr.rvb05,sr.pmn041,l_ima021,sr.rvb04,
                                       sr.rvb03,sr.pmm22,sr.rvb07,sr.rvv35,
                                       sr.rvb30,sr.rvb10,sr.rvb86,sr.rvb87,
                                       sr.rvb08,sr.pmm42,sr.azi03,sr.azi04,
                                       l_rvb38,l_rvbiicd03
          ELSE 
          #FUN-C30285---end
             EXECUTE insert_prep USING sr.rva05,sr.pmc03,sr.rvb19,sr.rva01,
                                       sr.rvb02,sr.rvb22,sr.rvb34,sr.rva06,
                                       sr.rvb05,sr.pmn041,l_ima021,sr.rvb04,
                                       sr.rvb03,sr.pmm22,sr.rvb07,sr.rvv35,
                                       sr.rvb30,sr.rvb10,sr.rvb86,sr.rvb87,
                                       sr.rvb08,sr.pmm42,sr.azi03,sr.azi04
          END IF   #FUN-C30285 
          #OUTPUT TO REPORT r515_rep(sr.*)
          #No.FUN-7C0034---End
     END FOREACH
     #No.FUN-7C0034---Begin
     #FINISH REPORT r515_rep
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     IF g_zz05 = 'Y' THEN                                                       
        CALL cl_wcchp(tm.wc,'rva01,rva05,rva06,rvb04,rvb05')                    
        RETURNING g_str                                                         
     END IF                                                                     
     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",           
                 g_sma.sma116,";",g_aza.aza17,";",g_azi05,";",tm.sub,";",tm.b          
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED         
     CALL cl_prt_cs3('apmr515',l_name,l_sql,g_str) 
     #No.FUN-7C0034---End
END FUNCTION
 
#No.FUN-7C0034---Begin
#REPORT r515_rep(sr)
#  DEFINE l_ima021     LIKE ima_file.ima021     #FUN-4C0095
#  DEFINE l_print      LIKE type_file.chr1      #No.FUN-680136 VARCHAR(1)
#  DEFINE l_last_sw    LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(1)
#         sr           RECORD    order1 LIKE aaf_file.aaf03, #No.FUN-680136 VARCHAR(40)
#                                order2 LIKE aaf_file.aaf03, #No.FUN-680136 VARCHAR(40)
#                                order3 LIKE aaf_file.aaf03, #No.FUN-680136 VARCHAR(40)
#                                rva01 LIKE rva_file.rva01,  #驗收單號
#                                rva05 LIKE rva_file.rva05,  #廠商編號
#                                rva06 LIKE rva_file.rva06,  #驗收日期
#                                rvb02 LIKE rvb_file.rvb02,  #驗收單項次
#                                rvb03 LIKE rvb_file.rvb03,  #採購單項次
#                                rvb04 LIKE rvb_file.rvb04,  #採購單號
#                                rvb05 LIKE rvb_file.rvb05,  #料號
#                                rvb07 LIKE rvb_file.rvb07,  #實收量
#                                rvb08 LIKE rvb_file.rvb08,  #收貨數量
#                                rvb19 LIKE rvb_file.rvb19,  #
#                                rvb22 LIKE rvb_file.rvb22,  #發票號碼
#                                rvb30 LIKE rvb_file.rvb30,  #巳入庫量
#                                rvb87 LIKE rvb_file.rvb87,  #計價數量   #MOD-6C0109
#                                rvb29 LIKE rvb_file.rvb29,  #退貨量
#                                rvb31 LIKE rvb_file.rvb31,  #可入庫量
#                                pmn041 LIKE pmn_file.pmn041,#品名
#                                rvb34 LIKE rvb_file.rvb34,  #工單
#                                pmn07 LIKE pmn_file.pmn07,  #採購單位
#                                rvb10 LIKE rvb_file.rvb10,  #收料單價
#                                pmc03 LIKE pmc_file.pmc03,  #簡稱
#                                pmm22 LIKE pmm_file.pmm22,  #幣別
#                                pmm42 LIKE pmm_file.pmm42,
#                                azi03 LIKE azi_file.azi03,
#                                azi04 LIKE azi_file.azi04,
#                                azi05 LIKE azi_file.azi05,
#                                rvb86 LIKE rvb_file.rvb86,  #計價單位   #TQC-6C0124 
#                                rvv35 LIKE rvv_file.rvv35   #入庫單位   #TQC-6C0124
 
#                       END RECORD
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.rva05,sr.order1,sr.order2,sr.order3
 
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
#     PRINT
#     PRINT g_dash  #FUN-4C0095
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38], #FUN-4C0095 印表頭
#           g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48], #FUN-4C0095 印表頭
#           g_x[49],g_x[50],g_x[51] #TQC-6C0124 印表頭
#     PRINT g_dash1 #FUN-4C0095
#     #FUN-4C0095(end)
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.rva05
#     SKIP TO TOP OF PAGE
#     PRINT COLUMN g_c[31],sr.rva05,
#           COLUMN g_c[32],sr.pmc03;
 
##FUN-4C0095----
#  ON EVERY ROW
#     SELECT ima021
#       INTO l_ima021
#       FROM ima_file
#      WHERE ima01=sr.rvb05
#     IF SQLCA.sqlcode THEN
#         LET l_ima021 = NULL
#     END IF
#     IF sr.rvb19 = '2' THEN
#         LET l_print='*'
#     ELSE
#         LET l_print=' '
#     END IF
 
#     PRINT COLUMN g_c[33],l_print,
#           COLUMN g_c[34],sr.rva01,
#           COLUMN g_c[35],sr.rvb02 USING '####',
#           COLUMN g_c[36],sr.rvb22,
#           COLUMN g_c[37],sr.rvb34,
#           COLUMN g_c[38],sr.rva06,
#           COLUMN g_c[39],sr.rvb05,
#           COLUMN g_c[40],sr.pmn041,
#           COLUMN g_c[41],l_ima021,
#           COLUMN g_c[42],sr.rvb04,
#           COLUMN g_c[43],sr.rvb03,
#           COLUMN g_c[44],sr.pmm22,
#          #COLUMN g_c[45],cl_numfor(sr.rvb08,45,2), #MOD-630054 mark
#           COLUMN g_c[45],cl_numfor(sr.rvb07,45,2), #MOD-630054 add
#          #COLUMN g_c[46],cl_numfor(sr.rvb30,46,2), #TQC-6C0124 mark
#           COLUMN g_c[46],sr.rvv35,  #TQC-6C0124 add
#           COLUMN g_c[47],cl_numfor(sr.rvb30,47,2),
#          #COLUMN g_c[47],cl_numfor(sr.rvb10,47,sr.azi03),   #No.MOD-610006 #TQC-6C0124 mark
#           COLUMN g_c[48],cl_numfor(sr.rvb10,48,sr.azi03),   #No.MOD-610006
#           COLUMN g_c[49],sr.rvb86,                 #TQC-6C0124 add
#           COLUMN g_c[50],cl_numfor(sr.rvb87,50,2), #TQC-6C0124 add
#          #COLUMN g_c[48],cl_numfor(sr.rvb30*sr.rvb10,48,sr.azi04)   #MOD-6C0109 mark
#          #COLUMN g_c[48],cl_numfor(sr.rvb87*sr.rvb10,48,sr.azi04)   #MOD-6C0109  #TQC-6C0124 mod
#           COLUMN g_c[51],cl_numfor(sr.rvb87*sr.rvb10,51,sr.azi04)   #MOD-6C0109  #TQC-6C0124 mod
 
#  AFTER GROUP OF sr.rva05
#     PRINT COLUMN g_c[42],g_x[21] clipped,'(',g_aza.aza17 CLIPPED,')',   #No.FUN-550067
#          #COLUMN g_c[45],cl_numfor(GROUP SUM(sr.rvb08),45,2), #MOD-630054 mark
#           COLUMN g_c[45],cl_numfor(GROUP SUM(sr.rvb07),45,2), #MOD-630054 add
#          #COLUMN g_c[48],cl_numfor(GROUP SUM(sr.rvb30*sr.rvb10*sr.pmm42),48,g_azi05)   #MOD-6C0109 mark
#          #COLUMN g_c[48],cl_numfor(GROUP SUM(sr.rvb87*sr.rvb10*sr.pmm42),48,g_azi05)   #MOD-6C0109 #TQC-6C0124 mark
#           COLUMN g_c[51],cl_numfor(GROUP SUM(sr.rvb87*sr.rvb10*sr.pmm42),51,g_azi05)   #TQC-6C0124 mod
##FUN-4C0095(end)
 
#  ON LAST ROW
#     PRINT g_x[20] CLIPPED
#     IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#        CALL cl_wcchp(tm.wc,'rva05,rva06,rva01,rvb04,rvb05')
#             RETURNING tm.wc
#       #TQC-630166
#       #PRINT g_dash[1,g_len]
#       #     IF tm.wc[001,120] > ' ' THEN            # for 132
#       #PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#       #     IF tm.wc[121,240] > ' ' THEN
#       #PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#       #     IF tm.wc[241,300] > ' ' THEN
#       #PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#       PRINT g_dash
#       CALL cl_prt_pos_wc(tm.wc)
#       #END TQC-630166
#     END IF
#     PRINT g_dash #FUN-4C0095
#     LET l_last_sw = 'y'
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[48], g_x[7] CLIPPED #FUN-4C0095 #No.TQC-6B0095
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED #FUN-4C0095 #No.TQC-6B0095
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len]
#             PRINT g_x[20] CLIPPED
##            PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[48], g_x[6] CLIPPED #FUN-4C0095 #No.TQC-6B0095
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED #FUN-4C0095 #No.TQC-6B0095
#        ELSE SKIP 3 LINE
#     END IF
#END REPORT
#No.FUN-7C0034---End
#Patch....NO.TQC-610036 <001> #
