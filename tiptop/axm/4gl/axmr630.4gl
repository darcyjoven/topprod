# Prog. Version..: '5.30.06-13.03.20(00010)'     #
#
# Pattern name...: axmr630.4gl
# Descriptions...: 出貨未開發票明細表
# Input parameter:
# Return code....:
# Date & Author..: 95/02/11 By Nick
#			換貨出貨之出貨單不應列出, so 加 line 189
# 本程式與axmr620非常相似
#                  出貨時未隨貨附發票,事後作銷退且不需再換貨,此筆出貨單不需
#                  出現在"已出貨未開發票明細表"
#
# Modify.........: 01-04-06 BY ANN CHEN B313 不包含出貨通知單
# Modify.........: No.FUN-4B0043 04/11/16 By Nicola 加入開窗功能
# Modify.........: NO.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-550070  05/05/27 By yoyo單據編號格式放大
# Modify.........: No.FUN-580004 05/08/03 By wujie 雙單位報表格式修改
# Modify.........: NO.FUN-5B0015 05/11/02 by Yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.FUN-610020 06/01/17 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.MOD-690107 06/11/16 By Claire (ogb12-ogb60)->(ogb917-ogb60)計未稅金額
# Modify.........: No.TQC-6B0137 06/11/27 By jamie 當使用計價單位,但不使用多單位時,單位一是NULL,導致單位註解內容為空
# Modify.........: NO.FUN-710081 07/02/02 By yoyo crystal report 
# Modify.........: No.CHI-720007 07/02/26 By jamie unmark l_sql 條件 
# Modify.........: No.TQC-730113 07/04/05 By Nicole 增加CR參數
# Modify.........: No.FUN-790019 07/09/26 By jamie sql語法有誤
# Modify.........: No.MOD-890258 08/09/25 By chenl 增加判斷，若該出貨單的單別未勾選產生應收，則不打印該出貨單。
# Modify.........: No.MOD-890247 08/10/06 By liuxqa 報表增加原幣未稅金額和匯率兩個欄位
# Modify.........: No.MOD-8C0209 08/12/22 By Smapmin 修正MOD-890247,SELECT 少抓一個欄位
# Modify.........: No.MOD-910105 09/01/14 By chenyu 賬款編號應該去axrt300中抓取
# Modify.........: No.TQC-940009 09/04/08 By sabrina 報表增加幣別欄位 & oga10的title改為帳單編號
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A10020 10/01/08 By Smapmin 原/本幣未稅金額的計算,要考慮是否含稅
# Modify.........: No:MOD-A60015 10/06/08 By Smapmin 匯率取位
# Modify.........: No:MOD-B20072 11/02/17 By Summer 排除axrt300作廢的資料
# Modify.........: No:MOD-B30057 11/03/08 By Summer 已在axrs010設定為外銷則不開立發票，國外已簽收且已立應收不該出現在此報表
# Modify.........: No:TQC-B50070 11/05/16 By lixia 開窗全選報錯修改
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改
# Modify.........: No.MOD-C10175 12/01/21 By yinhy 尾差問題
# Modify.........: No:TQC-CC0098 12/12/18 By qirl 增加開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580004--begin
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
END GLOBALS
#No.FUN-580004--end
   DEFINE tm  RECORD                  # Print condition RECORD
              wc     STRING,         # Where condition
              s      LIKE type_file.chr3,       # No.FUN-680137 VARCHAR(3)       # Order by sequence
              t      LIKE type_file.chr3,       # No.FUN-680137 VARCHAR(3)       # Eject sw
              u      LIKE type_file.chr3,       # No.FUN-680137 VARCHAR(3)       # Group total sw
              more   LIKE type_file.chr1        # No.FUN-680137 VARCHAR(1)         # Input more condition(Y/N)
              END RECORD
DEFINE    g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
#FUN-580004--begin
DEFINE g_sma115         LIKE sma_file.sma115
DEFINE g_sma116         LIKE sma_file.sma116
#DEFINE l_sql            LIKE type_file.chr1000     #No.FUN-680137  VARCHAR(1000)  #NO.FUN-710081
DEFINE l_zaa02          LIKE zaa_file.zaa02
DEFINE i                LIKE type_file.num10       # No.FUN-680137 INTEGER
#FUN-580004--end
#No.FUN-710081--start
DEFINE   l_table       STRING
DEFINE   l_str         STRING
DEFINE   l_sql         STRING
DEFINE   g_sql         STRING
#No.FUN-710081--end
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway =ARG_VAL(5)
   LET g_copies =ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#NO.FUN-710081--start
      #       OUTPUT TO REPORT axmr630_rep(sr.*)
     LET g_sql ="oga01.oga_file.oga01,",
               " oga02.oga_file.oga02,",
               " oga03.oga_file.oga03,",
               " oga032.oga_file.oga032,",
               " oga04.oga_file.oga04,",
               " occ02.occ_file.occ02,",
               " oga14.oga_file.oga14,",
               " gen02.gen_file.gen02,",
               " oga15.oga_file.oga01,",
               " oga24.oga_file.oga24,",    #No.MOD-890247 add by liuxqa
               " gem02.gem_file.gem02,",
               " ogb03.ogb_file.ogb03,",
               " ogb31.ogb_file.ogb31,",
               " ogb04.ogb_file.ogb04,",
               " ogb06.ogb_file.ogb06,",
               " ima021.ima_file.ima021,",
               " str2.type_file.chr50,",
               " ogb916.ogb_file.ogb916,",
               " ogb917.ogb_file.ogb917,",
               " ogb05.ogb_file.ogb05,",
               " ogb13.ogb_file.ogb13,",
               " balance.ogb_file.ogb917,",
               " ogb14.ogb_file.ogb14,",
               " ogb141.ogb_file.ogb14,",   #No.MOD-890247 add by liuxqa
               " oga10.oga_file.oga10,",
               " azi03.azi_file.azi03,",
               " azi04.azi_file.azi04,",
               " azi05.azi_file.azi05,",
               " azi07.azi_file.azi07,",   #MOD-A60015
               " oga23.oga_file.oga23"     #TQC-940009 add
 
   LET l_table = cl_prt_temptable('axmr630',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF  
 #No.FUN-710081--end    
   SELECT * INTO g_ooz.* FROM ooz_file WHERE ooz00='0' #MOD-B30057 add
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL axmr630_tm(0,0)        # Input print condition
      ELSE CALL axmr630()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmr630_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 5 LET p_col = 17
 
   OPEN WINDOW axmr630_w AT p_row,p_col WITH FORM "axm/42f/axmr630"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm2.s1  = '1'
   LET tm2.s2  = '2'
   LET tm2.s3  = '3'
   LET tm2.u1  = 'N'
   LET tm2.u2  = 'N'
   LET tm2.u3  = 'N'
   LET tm2.t1  = 'N'
   LET tm2.t2  = 'N'
   LET tm2.t3  = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oga01,oga02,oga03,oga04,oga14,oga15
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON ACTION CONTROLP    #FUN-4B0043
#---TQC-CC0098--add--star--
           IF INFIELD(oga01) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_oga01_2"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oga01
              NEXT FIELD oga01
           END IF
#---TQC-CC0098--add--end--
           IF INFIELD(oga03) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_occ"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oga03
              NEXT FIELD oga03
           END IF
           IF INFIELD(oga04) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_occ"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oga04
              NEXT FIELD oga04
           END IF
           IF INFIELD(oga14) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oga14
              NEXT FIELD oga14
           END IF
           IF INFIELD(oga15) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gem"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oga15
              NEXT FIELD oga15
           END IF
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr630_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.more         # Condition
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
                 tm2.u1,tm2.u2,tm2.u3,
                 tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
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
#     ON ACTION CONTROLP CALL axmr630_wc()   # Input detail Where Condition
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr630_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmr630'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmr630','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
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
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axmr630',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmr630_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmr630()
   ERROR ""
END WHILE
   CLOSE WINDOW axmr630_w
END FUNCTION
 
FUNCTION axmr630()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
         #l_time    LIKE type_file.chr8        #No.FUN-6A0094
          #l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                 #No.FUN-680137 VARCHAR(1000)
          l_sql     STRING,                    #TQC-B50070
          l_chr     LIKE type_file.chr1,       #No.FUN-680137 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
         #l_order    ARRAY[5] OF VARCHAR(10),
          l_order    ARRAY[5] OF LIKE oea_file.oea01,              # No.FUN-680137 VARCHAR(16)        #No.FUN-550070
         #sr               RECORD order1 VARCHAR(10),
         #                        order2 VARCHAR(10),
         #                        order3 VARCHAR(10),
#No.FUN-550070  --start--
         sr               RECORD order1 LIKE oea_file.oea01,      # No.FUN-680137 VARCHAR(16)
                                 order2  LIKE oea_file.oea01,     # No.FUN-680137 VARCHAR(16)
                                 order3  LIKE oea_file.oea01,      # No.FUN-680137 VARCHAR(16)
#No.FUN-550070 --end--
                                  oga01 LIKE oga_file.oga01,    #
                                  oga02 LIKE oga_file.oga02,
                                  oga03 LIKE oga_file.oga03,
                                  oga032 LIKE oga_file.oga032,
                                  oga04 LIKE oga_file.oga04,
                                  occ02 LIKE occ_file.occ02,
                                  oga14 LIKE oga_file.oga14,
                                  oga15 LIKE oga_file.oga15,
                                  oga24 LIKE oga_file.oga24,
                                  oga213 LIKE oga_file.oga213,   #MOD-A10020
                                  oga211 LIKE oga_file.oga211,   #MOD-A10020
                                  ogb03 LIKE ogb_file.ogb03,   #單身項次
                                  ogb31 LIKE ogb_file.ogb31,
                                  ogb04 LIKE ogb_file.ogb04,
                                  ogb06 LIKE ogb_file.ogb06,
                                  ogb05 LIKE ogb_file.ogb05,
                                  ogb13 LIKE ogb_file.ogb13,
                                  balance LIKE ogb_file.ogb12,
                                  ogb14   LIKE ogb_file.ogb14,
                                  ogb141  LIKE ogb_file.ogb14,  #No.MOD-890247 add by liuxqa
                                  ogb910  LIKE ogb_file.ogb910,    #No.FUN-580004
                                  ogb912  LIKE ogb_file.ogb912,    #No.FUN-580004
                                  ogb913  LIKE ogb_file.ogb913,    #No.FUN-580004
                                  ogb915  LIKE ogb_file.ogb915,    #No.FUN-580004
                                  ogb916  LIKE ogb_file.ogb916,    #No.FUN-580004
                                  ogb917  LIKE ogb_file.ogb917,    #No.FUN-580004
                                  oga10   LIKE oga_file.oga10,
                                  azi03   LIKE azi_file.azi03,
                                  azi04   LIKE azi_file.azi04,
                                  azi05   LIKE azi_file.azi05,
                                  azi07   LIKE azi_file.azi07,   #MOD-A60015
                                  oga23   LIKE oga_file.oga23       #TQC-940009 add 
                        END RECORD
#No.FUN-710081--start                      
   DEFINE    l_gen02   LIKE gen_file.gen02,
             l_gem02   LIKE gem_file.gem02,
             l_ima021  LIKE ima_file.ima021,
             l_ima906  LIKE ima_file.ima906,
             l_str2    LIKE type_file.chr50,
             l_ogb915     STRING,
             l_ogb912     STRING,
             l_ogb12      STRING
#FUN-710081--end
DEFINE       l_oayslip LIKE oay_file.oayslip   #No.MOD-890258
DEFINE       l_oay11   LIKE oay_file.oay11     #No.MOD-890258
   DEFINE    l_oga08   LIKE oga_file.oga08     #MOD-B30057 add
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     
#NO.FUN-710081--start
#     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND ogauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND ogagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND ogagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT '','','',",
                 "       oga01,oga02,oga03,oga032,oga04,occ02,oga14, ",
## No:2606 modify 1998/10/23 --------------------------------------
#                "       oga15,ogb03,ogb31,ogb04,ogb06,ogb05, ",
                 "       oga15,oga24,oga213,oga211,ogb03,ogb31,ogb04,ogb06,ogb05, ",   #MOD-A10020 add oga213/oga211
                 #"       ogb13,ogb917-ogb60,0,ogb910,ogb912,ogb913,ogb915,ogb916,ogb917,oga10, ",        #No.FUN-580004  #MOD-690107 ogb12->ogb917   #MOD-8C0209
                 "       ogb13,ogb917-ogb60,0,0,ogb910,ogb912,ogb913,ogb915,ogb916,ogb917,oga10, ",        #No.FUN-580004  #MOD-690107 ogb12->ogb917   #MOD-8C0209
                #"		 azi03,azi04,azi05 ",   #FUN-790019 mark(有\t\t)
                 #"               azi03,azi04,azi05,oga23 ",   #FUN-790019 mod      #TQC-940009 add oga23   #MOD-A60015
                 "               azi03,azi04,azi05,azi07,oga23,oga08 ",   #MOD-A60015 #MOD-B30057 add oga08
                 "  FROM oga_file,OUTER occ_file,ogb_file,azi_file ",
                 " WHERE oga01 = ogb_file.ogb01 AND oga09 !='1' AND oga09!='5' ", #B313
                 "   AND oga09 !='7' AND oga09!='9' ", #No.FUN-610020
                 "  AND oga65='N' ",  #No.FUN-610020
                 "   AND oga_file.oga04 = occ_file.occ01 ",
                 "   AND oga53 > oga54 ",
                 "   AND oga23 = azi_file.azi01 ",
                 "   AND ogb12 > ogb60+ogb63+ogb64 ",  #CHI-720007 unmark # modify by WUPN
                 "   AND ogb_file.ogb60 =0      ",
                 "   AND (oga00 ='1'    ",  # 換貨出貨不應列出
                 "    OR oga00 ='4')   ",  #BugNo:6782
                 "   AND ogapost='Y'   ",
                 "   AND ",tm.wc
     PREPARE axmr630_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
           
     END IF
     DECLARE axmr630_curs1 CURSOR FOR axmr630_prepare1
 
#    LET l_name = 'axmr630.out'
 
#     CALL cl_outnam('axmr630') RETURNING l_name
#FUN-580004--begin
#     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file
#     IF g_sma.sma116 MATCHES '[23]' THEN    #No.FUN-610076
#            LET g_zaa[46].zaa06 = "Y"
#            LET g_zaa[48].zaa06 = "Y"
#            LET g_zaa[52].zaa06 = "N"
#            LET g_zaa[53].zaa06 = "N"
#     ELSE
#            LET g_zaa[46].zaa06 = "N"
#            LET g_zaa[48].zaa06 = "N"
#            LET g_zaa[52].zaa06 = "Y"
#            LET g_zaa[53].zaa06 = "Y"
#     END IF
#     IF g_sma115 = "Y" OR g_sma.sma116 MATCHES '[23]' THEN    #No.FUN-610076
#            LET g_zaa[51].zaa06 = "N"
#     ELSE
#            LET g_zaa[51].zaa06 = "Y"
#     END IF
#      CALL cl_prt_pos_len()
##No.FUN-580004--end
#
#     START REPORT axmr630_rep TO l_name
##    LET l_name = 'cat > axmr630.out'
##    START REPORT axmr630_rep TO PIPE l_name
 
#     LET g_pageno = 0
     CALL cl_del_data(l_table)
     LET g_sql=" INSERT INTO ",g_cr_db_str CLIPPED,l_table clipped,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, 
                        ?,?,?,?,?, ?,?,?,?,?)"  #No.MOD-890247 add 2 '?' by liuxqa  #TQC-940009 add ?   #MOD-A60015 add ?
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
        EXIT PROGRAM 
     END IF   
#NO.FUN-710081--end
     FOREACH axmr630_curs1 INTO sr.*,l_oga08 #MOD-B30057 add l_oga08
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF g_ooz.ooz64 = 'N' AND l_oga08 = '2' AND g_aza.aza26 = '0' THEN CONTINUE FOREACH END IF #MOD-B30057 add
      #No.MOD-890258--begin--
       LET l_oayslip = s_get_doc_no(sr.oga01)
       SELECT oay11 INTO l_oay11 FROM oay_file WHERE oayslip = l_oayslip
       IF l_oay11 != 'Y' THEN 
          CONTINUE FOREACH
       END IF 
      #No.MOD-890258---end---
       FOR g_i = 1 TO 3
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.oga01
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.oga02 USING 'yyyymmdd'
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.oga03
               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.oga04
               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.oga14
               WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.oga15
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
## No:2606 modify 1998/10/23 --------------------------------------
#          LET sr.ogb14	 = sr.balance*sr.ogb13
           #-----MOD-A10020---------
	   #LET sr.ogb14  = sr.balance*sr.ogb13*sr.oga24
           #LET sr.ogb141 = sr.balance*sr.ogb13   #No.MOD-890247 add by liuxqa
           IF sr.oga213 = 'N' THEN
              LET sr.ogb141 = (sr.balance*sr.ogb13)  #原幣未稅金額
              LET sr.ogb14 = sr.ogb141 * sr.oga24  #本幣未稅金額
           ELSE
              LET sr.ogb141 = (sr.balance*sr.ogb13)/(1+sr.oga211/100)  #原幣未稅金額
              LET sr.ogb14 = sr.ogb141 * sr.oga24  #本幣未稅金額
           END IF   
           LET sr.ogb141 = cl_digcut(sr.ogb141,t_azi04)   #MOD-C10175
           LET sr.ogb14 = cl_digcut(sr.ogb14,g_azi04)     #MOD-C10175
           #-----END MOD-A10020-----
## --
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
#NO.FUN-710081--start   
#       OUTPUT TO REPORT axmr630_rep(sr.*)
     SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oga14           
     SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.oga15  
      IF sr.ogb04[1,4] !='MISC' THEN
         SELECT ima021 INTO l_ima021 FROM ima_file
          WHERE ima01 = sr.ogb04
      ELSE        
         LET l_ima021 = ''
      END IF
 
#FUN-580004--begin
 
      SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file
       WHERE ima01=sr.ogb04
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
                LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
                IF cl_null(sr.ogb915) OR sr.ogb915 = 0 THEN
                    CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
                    LET l_str2 = l_ogb912, sr.ogb910 CLIPPED
                ELSE
                   IF NOT cl_null(sr.ogb912) AND sr.ogb912 > 0 THEN
                      CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
                      LET l_str2 = l_str2 CLIPPED,',',l_ogb912, sr.ogb910 CLIPPED
                   END IF
                END IF
            WHEN "3"
                IF NOT cl_null(sr.ogb915) AND sr.ogb915 > 0 THEN
                    CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
                    LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
                END IF
         END CASE
      ELSE
      END IF
      IF g_sma.sma116 MATCHES '[23]' THEN    #No.FUN-610076
           #IF sr.ogb910 <> sr.ogb916 THEN   #No.TQC-6B0137 mark
            IF sr.ogb05  <> sr.ogb916 THEN   #No.TQC-6B0137 mod
               CALL cl_remove_zero(sr.balance) RETURNING l_ogb12
               LET l_str2 = l_str2 CLIPPED,"(",l_ogb12,sr.ogb05 CLIPPED,")"
            END IF
      END IF 
      #No.MOD-910105 add --begin
      LET sr.oga10 = NULL
      SELECT oma01 INTO sr.oga10 FROM oma_file,omb_file
       WHERE oma01 = omb01 AND omb31 = sr.oga01 AND omb32 = sr.ogb03
         AND omavoid <> 'Y' #MOD-B20072 add
         AND oma02 = (SELECT MAX(oma02) FROM oma_file,omb_file
                       WHERE oma01 = omb01 
                         AND omavoid <> 'Y' #MOD-B20072 add
                         AND omb31 = sr.oga01 AND omb32 = sr.ogb03)
      #No.MOD-910105 add --end
      EXECUTE insert_prep USING sr.oga01,sr.oga02,
                                sr.oga03,sr.oga032,sr.oga04,sr.occ02,sr.oga14,
                                l_gen02, sr.oga15,sr.oga24, l_gem02, sr.ogb03,sr.ogb31,  #No.MOD-890247 add by liuxqa
                                sr.ogb04,sr.ogb06, l_ima021,l_str2,  sr.ogb916,
                                sr.ogb917,sr.ogb05,sr.ogb13,sr.balance,sr.ogb14,sr.ogb141,   #No.MOD-890247 add by liuxqa
                                #sr.oga10,sr.azi03, sr.azi04,sr.azi05,sr.oga23    #FUN-790019 add azi03 azi04 azi05    #TQC-940009 oga23   #MOD-A60015
                                sr.oga10,sr.azi03, sr.azi04,sr.azi05,sr.azi07,sr.oga23    #MOD-A60015
     END FOREACH
     
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axmr630'
     IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'oga01,oga02,oga03,oga04,oga14,oga15')
              RETURNING tm.wc
     END IF     
  ## LET l_sql=" SELECT * FROM ",l_table clipped  #TQC-730113
     LET l_sql=" SELECT * FROM ",g_cr_db_str CLIPPED,l_table clipped
     PREPARE axmr630_preparet FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    
        EXIT PROGRAM
     END IF
     LET l_str = tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",
                 tm.u[1,1],";",tm.u[2,2],";",tm.u[3,3],";",
                 tm.wc CLIPPED,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3]
     IF g_sma.sma116 MATCHES '[23]' THEN  
      # CALL cl_prt_cs3('axmr630',l_sql,l_str)     #TQC-730113 
        CALL cl_prt_cs3('axmr630','axmr630',l_sql,l_str) 
     ELSE
        IF g_sma115= 'Y' THEN
      ##   CALL cl_prt_cs3('axmr6301',l_sql,l_str) #TQC-730113  
           CALL cl_prt_cs3('axmr630','axmr630_1',l_sql,l_str)  
        ELSE
      ##   CALL cl_prt_cs3('axmr6302',l_sql,l_str) #TQC-730113
           CALL cl_prt_cs3('axmr630','axmr630_2',l_sql,l_str) 
        END IF
     END IF 
#    FINISH REPORT axmr630_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-710081--end
END FUNCTION
 
#NO.FUN-710081--start
{
REPORT axmr630_rep(sr)
   DEFINE l_last_sw     LIKE type_file.chr1,        # No.FUN-680137  VARCHAR(1)
          sr               RECORD order1 LIKE faj_file.faj02,        # No.FUN-680137 VARCHAR(10)
                                  order2 LIKE faj_file.faj02,        # No.FUN-680137 VARCHAR(10)
                                  order3 LIKE faj_file.faj02,        # No.FUN-680137 VARCHAR(10)
                                  oga01 LIKE oga_file.oga01,    #
                                  oga02 LIKE oga_file.oga02,
                                  oga03 LIKE oga_file.oga03,
                                  oga032 LIKE oga_file.oga032,
                                  oga04 LIKE oga_file.oga04,
				  occ02 LIKE occ_file.occ02,
                                  oga14 LIKE oga_file.oga14,
                                  oga15 LIKE oga_file.oga15,
                                  oga24 LIKE oga_file.oga24,
                                  ogb03 LIKE ogb_file.ogb03,   #單身項次
                                  ogb31 LIKE ogb_file.ogb31,
                                  ogb04 LIKE ogb_file.ogb04,
                                  ogb06 LIKE ogb_file.ogb06,
                                  ogb05 LIKE ogb_file.ogb05,
                                  ogb13 LIKE ogb_file.ogb13,
                                  balance LIKE ogb_file.ogb12,
                                  ogb14 LIKE ogb_file.ogb14,
                                  ogb910  LIKE ogb_file.ogb910,    #No.FUN-580004
                                  ogb912  LIKE ogb_file.ogb912,    #No.FUN-580004
                                  ogb913  LIKE ogb_file.ogb913,    #No.FUN-580004
                                  ogb915  LIKE ogb_file.ogb915,    #No.FUN-580004
                                  ogb916  LIKE ogb_file.ogb916,    #No.FUN-580004
                                  ogb917  LIKE ogb_file.ogb917,    #No.FUN-580004
				  oga10	LIKE oga_file.oga10,
				  azi03	LIKE azi_file.azi03,
				  azi04	LIKE azi_file.azi04,
				  azi05	LIKE azi_file.azi05
                        END RECORD,
      l_amt     LIKE ogb_file.ogb14,
      l_ima021  LIKE ima_file.ima021,
      l_gen02   LIKE gen_file.gen02,
      l_gem02   LIKE gem_file.gem02,
      l_chr        LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
#No.FUN-580004--begin
   DEFINE  l_ogb915   STRING
   DEFINE  l_ogb912   STRING
   DEFINE  l_ogb12    STRING
   DEFINE  l_str2     STRING
   DEFINE  l_ima906    LIKE ima_file.ima906
#No.FUN-580004--end
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3,sr.oga01
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED, pageno_total
      PRINT ''
 
      PRINT g_dash[1,g_len]
      PRINT g_x[31],
            g_x[32],
            g_x[33],
            g_x[34],
            g_x[35],
            g_x[36],
            g_x[37],
            g_x[38],
            g_x[39],
            g_x[40],
            g_x[41],
            g_x[42],
            g_x[43],
            g_x[44],
            g_x[45],
            g_x[46],
            g_x[47],
            g_x[48],
            g_x[49],
            g_x[50],
            g_x[51],     #No.FUN-580004
            g_x[52],     #No.FUN-580004
            g_x[53]      #No.FUN-580004
 
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.oga01
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oga14
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.oga15
      PRINT COLUMN g_c[31], sr.oga01,
            COLUMN g_c[32],sr.oga02,
            COLUMN g_c[33],sr.oga03,
            COLUMN g_c[34],sr.oga032,
            COLUMN g_c[35],sr.oga04,
            COLUMN g_c[36],sr.occ02,
            COLUMN g_c[37],sr.oga14,
            COLUMN g_c[38],l_gen02,
            COLUMN g_c[39],sr.oga15,
            COLUMN g_c[40],l_gem02;
   ON EVERY ROW
      IF sr.ogb04[1,4] !='MISC' THEN
         SELECT ima021 INTO l_ima021 FROM ima_file
          WHERE ima01 = sr.ogb04
      ELSE
         LET l_ima021 = ''
      END IF
 
#FUN-580004--begin
 
      SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file
                         WHERE ima01=sr.ogb04
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
                LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
                IF cl_null(sr.ogb915) OR sr.ogb915 = 0 THEN
                    CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
                    LET l_str2 = l_ogb912, sr.ogb910 CLIPPED
                ELSE
                   IF NOT cl_null(sr.ogb912) AND sr.ogb912 > 0 THEN
                      CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
                      LET l_str2 = l_str2 CLIPPED,',',l_ogb912, sr.ogb910 CLIPPED
                   END IF
                END IF
            WHEN "3"
                IF NOT cl_null(sr.ogb915) AND sr.ogb915 > 0 THEN
                    CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
                    LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
                END IF
         END CASE
      ELSE
      END IF
      IF g_sma.sma116 MATCHES '[23]' THEN    #No.FUN-610076
           #IF sr.ogb910 <> sr.ogb916 THEN   #No.TQC-6B0137 mark
            IF sr.ogb05  <> sr.ogb916 THEN   #No.TQC-6B0137 mod
               CALL cl_remove_zero(sr.balance) RETURNING l_ogb12
               LET l_str2 = l_str2 CLIPPED,"(",l_ogb12,sr.ogb05 CLIPPED,")"
            END IF
      END IF
#FUN-580004--end
      PRINT COLUMN g_c[41],sr.ogb03 USING '###&',
            COLUMN g_c[42],sr.ogb31,
            #COLUMN g_c[43],sr.ogb04[1,20],  #No.FUN-580004
            COLUMN g_c[43],sr.ogb04 CLIPPED,  #No.FUN-580004  #NO.FUN-5B0015
            COLUMN g_c[44],sr.ogb06,
            COLUMN g_c[45],l_ima021,
            COLUMN g_c[51],l_str2 CLIPPED,    #No.FUN-580004
            COLUMN g_c[52],sr.ogb916,         #No.FUN-580004
            COLUMN g_c[53],sr.ogb917 USING '###########&.&&',         #No.FUN-580004
            COLUMN g_c[46],sr.ogb05,
            COLUMN g_c[47],cl_numfor(sr.ogb13,47,sr.azi03),
            COLUMN g_c[48],sr.balance USING '############&.&',
            COLUMN g_c[49],cl_numfor(sr.ogb14,49,sr.azi04) CLIPPED,
            COLUMN g_c[50],sr.oga10
 
   AFTER GROUP OF sr.oga01
#      LET g_pageno = 0
      LET l_amt = GROUP SUM(sr.ogb14)
      PRINT COLUMN g_c[48],g_x[09] CLIPPED,
            COLUMN g_c[49], cl_numfor(l_amt,49,sr.azi05) CLIPPED
      PRINT ''
      LET l_chr = 'Y'
 
   AFTER GROUP OF sr.order1
      IF tm.u[1,1] = 'Y' THEN
         LET l_amt = GROUP SUM(sr.ogb14)
         PRINT COLUMN g_c[48],g_x[09] CLIPPED,
               COLUMN g_c[49], cl_numfor(l_amt,49,sr.azi05) CLIPPED
         PRINT g_dash2[1,g_len]
         LET l_chr = 'N'
      END IF
 
   AFTER GROUP OF sr.order2
      IF tm.u[2,2] = 'Y' THEN
         LET l_amt = GROUP SUM(sr.ogb14)
         PRINT COLUMN g_c[48],g_x[09] CLIPPED,
               COLUMN g_c[49], cl_numfor(l_amt,49,sr.azi05) CLIPPED
         PRINT g_dash2[1,g_len]
         LET l_chr = 'N'
      END IF
 
   AFTER GROUP OF sr.order3
      IF tm.u[3,3] = 'Y' THEN
         LET l_amt = GROUP SUM(sr.ogb14)
         PRINT COLUMN g_c[48],g_x[09] CLIPPED,
               COLUMN g_c[49], cl_numfor(l_amt,49,sr.azi05) CLIPPED
         PRINT g_dash2[1,g_len]
         LET l_chr = 'N'
      END IF
 
   ON LAST ROW
      LET l_amt = SUM(sr.ogb14)
      IF l_chr = 'Y' THEN
         PRINT g_dash2[1,g_len]
      END IF
      PRINT COLUMN g_c[48],g_x[10] CLIPPED,
            COLUMN g_c[49], cl_numfor(l_amt,49,sr.azi05) CLIPPED
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'oga01,oga02,oga03,oga04,oga14,oga15')
              RETURNING tm.wc
         PRINT g_dash[1,g_len]
         #TQC-630166
         #     IF tm.wc[001,070] > ' ' THEN            # for 80
         #PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
         #     IF tm.wc[071,140] > ' ' THEN
         #PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
         #     IF tm.wc[141,210] > ' ' THEN
         #PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
         #     IF tm.wc[211,280] > ' ' THEN
         #PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
         CALL cl_prt_pos_wc(tm.wc)
         #END TQC-630166
 
      END IF
      LET l_last_sw = 'y'
      PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #No.FUN-580004
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #No.FUN-580004
         ELSE SKIP 2 LINE
      END IF
END REPORT
}
#No.FUN-710081--end
