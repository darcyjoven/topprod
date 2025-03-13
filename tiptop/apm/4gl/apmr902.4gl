# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmr902.4gl
# Descriptions...: 採購單列印(套表)
# Input parameter:
# Return code....:
# Date & Author..: 92/07/30 By Yen
# Modify.........: No.MOD-530190 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式 or LIKE type_file.num20_6
# Modify.........: No.FUN-550060 05/05/30 By Will 單據編號放大
# Modify.........: No.FUN-550114 05/06/01 By echo 新增報表備註
# Modify.........: No.MOD-5A0121 05/10/14 By ice 料號/品名/規格欄位放大
# Modify.........: No.TQC-5B0037 05/10/07 By Rosayu 保稅否與前面資料連在一起
# Modify.........: No.TQC-650044 06/05/15 By Echo 憑證類的報表因報表寬度(p_zz)為0或NULL,導致報表當掉
# Modify.........: No.FUN-680136 06/09/05 By Jackho  欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改 
# Modify.........: No.TQC-6C0136 06/12/22 By rainy 使用計價單位時，金額錯誤修正
# Modify.........: No.FUN-710091 07/03/13 By xufeng 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.TQC-740276 07/04/20 By wujie 特別說明單身"在後"印出來的位置錯誤
# Modify.........: No.FUN-740223 07/05/07 By Sarah 特別說明列印功能有問題，已暫時關閉，per檔選擇功能也請先隱藏
# Modify.........: No.TQC-780049 07/08/15 By Sarah 修改INSERT INTO temptable語法
# Modify.........: No.CHI-7A0018 07/10/05 By jamie 改用新寫法調整子報表
# Modify.........: No.FUN-870151 08/08/18 By xiaofeizhu  匯率調整為用azi07取位
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9C0315 09/12/21 By sabrina 當採購單為內含稅時，若依未稅單價*未稅金額時，會與apmr900不一致 
# Modify.........: No:TQC-C10039 12/01/12 By minpp  CR报表列印TIPTOP与EasyFlow签核图片 
# Modify.........: No.TQC-C20067 12/02/09 By zhuhao CR报表列印TIPTOP与EasyFlow签核图片還原
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                            # Print condition RECORD
             #wc       LIKE type_file.chr1000,  # Where condition   #TQC-630166 mark 	#No.FUN-680136 VARCHAR(500)
              wc       STRING,                  # Where condition   #TQC-630166
             #a        LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)   #FUN-740223 mark
             #b        LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)   #FUN-740223 mark
              d        LIKE type_file.chr1,     # print gkf_file detail(Y/N) 	#No.FUN-680136 VARCHAR(1)
              e        LIKE type_file.chr1,     # print gkf_file detail(Y/N) 	#No.FUN-680136 VARCHAR(1)
              f        LIKE type_file.chr1,     # print gkf_file detail(Y/N) 	#No.FUN-680136 VARCHAR(1)
              more     LIKE type_file.chr1      # Input more condition(Y/N) 	#No.FUN-680136 VARCHAR(1)
              END RECORD,
          g_aza17        LIKE aza_file.aza17,   # 本國幣別
          g_dates       LIKE aab_file.aab02, 	#No.FUN-680136 VARCHAR(6)
          g_datee       LIKE aab_file.aab02, 	#No.FUN-680136 VARCHAR(6)
          pmm12_tm      LIKE pmm_file.pmm12,
          g_pmm01       LIKE pmm_file.pmm01,    #No.FUN-550060 	#No.FUN-680136 VARCHAR(16)
          g_total       LIKE pmn_file.pmn31,    #MOD-530190
          swth          LIKE type_file.chr1   	#No.FUN-680136 VARCHAR(1)
   DEFINE g_i           LIKE type_file.num5     #count/index for any purpose    #No.FUN-680136 SMALLINT
#No.FUN-710091  --begin
   DEFINE l_table       STRING
   DEFINE l_table1      STRING
   DEFINE l_table2      STRING
   DEFINE l_table3      STRING
   DEFINE l_table4      STRING
   DEFINE g_sql         STRING
   DEFINE g_str         STRING
#No.FUN-710091  --end  
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                 # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
 
 
   LET g_pdate = ARG_VAL(1)                 # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
  #LET tm.a  = ARG_VAL(8)   #FUN-740223 mark
  #LET tm.b  = ARG_VAL(9)   #FUN-740223 mark
   LET tm.d  = ARG_VAL(8)
   LET tm.e  = ARG_VAL(9)
   LET tm.f  = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   #No.FUN-710091  --begin
   LET g_sql ="pmm01.pmm_file.pmm01,",
              "pmm02.pmm_file.pmm02,",
              "pmm03.pmm_file.pmm03,",
              "pmm04.pmm_file.pmm04,",
              "pmm09.pmm_file.pmm09,",
              "pmm12.pmm_file.pmm12,",
              "pmm13.pmm_file.pmm13,",
              "pmm14.pmm_file.pmm14,",
              "pmm15.pmm_file.pmm15,",
              "pmm16.pmm_file.pmm16,",
              "pmm17.pmm_file.pmm17,",
              "pmm18.pmm_file.pmm18,",
              "pmm20.pmm_file.pmm20,",
              "pmm22.pmm_file.pmm22,",
              "pmm42.pmm_file.pmm42,",
              "pmn02.pmn_file.pmn02,",
              "pmn04.pmn_file.pmn04,",
              "pmn041.pmn_file.pmn041,",
              "pmn07.pmn_file.pmn07,",
              "pmn15.pmn_file.pmn15,",
              "pmn20.pmn_file.pmn20,",
              "pmn64.pmn_file.pmn64,",
              "pmn31.pmn_file.pmn31,",
              "pmn33.pmn_file.pmn33,",
              "pmn41.pmn_file.pmn41,",
              "pmn87.pmn_file.pmn87,",
              "pmn88.pmn_file.pmn88,",       #MOD-9C0315 add
              "pmn80.pmn_file.pmn80,",
              "pmn82.pmn_file.pmn82,",
              "pmn83.pmn_file.pmn83,",
              "pmn85.pmn_file.pmn85,",
              "pmn86.pmn_file.pmn86,",
              "g_pmn.pmn_file.pmn31,",
              "pmm43.pmm_file.pmm43,",
              "pmmprno.pmm_file.pmmprno,",
              "l_n.type_file.num5,",
              "zo041.zo_file.zo041,",
              "zo042.zo_file.zo042,",
              "pmc081.pmc_file.pmc081,",
              "pmc082.pmc_file.pmc082,",
              "zo05.zo_file.zo05,",
              "zo09.zo_file.zo09,",
              "zo06.zo_file.zo06,", 
              "gem02.gem_file.gem02,",
              "pma02.pma_file.pma02,",
              "l_pmm13_gem02.type_file.chr50,",
              "l_pmm15_gen02.type_file.chr50,",
              "l_pmm12_gen02.type_file.chr50,",
              "t_azi03.azi_file.azi03,",
              "t_azi04.azi_file.azi04,",
              "t_azi05.azi_file.azi05,",
              "t_azi07.azi_file.azi07,",   #No.FUN-870151
              "pmc03.pmc_file.pmc03"
             #TQC-C20067--mark--begin
             #"sign_type.type_file.chr1,",      #簽核方式   #TQC-C10039
             #"sign_img.type_file.blob ,",      #簽核圖檔   #TQC-C10039
             #"sign_show.type_file.chr1,",      #是否顯示簽核資料(Y/N)  #TQC-C10039
             #"sign_str.type_file.chr1000"      #簽核字串 #TQC-C10039
             #TQC-C20067--mark--end
   LET l_table = cl_prt_temptable('apmr902',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql= "pmm01.pmm_file.pmm01,",
              "pmo06_1.pmo_file.pmo06"    #CHI-7A0018 mod
             #"l_i_1.type_file.num5"      #CHI-7A0018 mark
   LET l_table1 = cl_prt_temptable('apmr9021',g_sql) CLIPPED
   IF  l_table1 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql= "pmm01.pmm_file.pmm01,",
              "pmn02.pmn_file.pmn02,",   #CHI-7A0018 mod     #No.TQC-740276 
              "pmo06_2.pmo_file.pmo06"
             #"pmn02.pmn_file.pmn02"     #CHI-7A0018 mod     #No.TQC-740276 
             #"l_i_2.type_file.num5"     #CHI-7A0018 mark  
   LET l_table2 = cl_prt_temptable('apmr9022',g_sql) CLIPPED
   IF  l_table2 = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql= "pmm01.pmm_file.pmm01,",
              "pmn02.pmn_file.pmn02,",   #CHI-7A0018 mod     #No.TQC-740276 
              "pmo06_3.pmo_file.pmo06"
             #"pmn02.pmn_file.pmn02"     #CHI-7A0018 mod     #No.TQC-740276 
             #"l_i_3.type_file.num5"     #CHI-7A0018 mark
   LET l_table3 = cl_prt_temptable('apmr9023',g_sql) CLIPPED
   IF  l_table3 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql= "pmm01.pmm_file.pmm01,",
              "pmo06_4.pmo_file.pmo06"   #CHI-7A0018 mod
             #"l_i_4.type_file.num5"     #CHI-7A0018 mark
   LET l_table4 = cl_prt_temptable('apmr9024',g_sql) CLIPPED
   IF  l_table4 = -1 THEN EXIT PROGRAM END IF
   #No.FUN-710091  --end  
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
      THEN CALL r902_tm(0,0)        # Input print condition
      ELSE CALL apmr902()        # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r902_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01      #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,     #No.FUN-680136 SMALLINT
       l_cmd          LIKE type_file.chr1000   #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW r902_w AT p_row,p_col WITH FORM "apm/42f/apmr902"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
  #LET tm.a    = 'N'   #FUN-740223 mark
  #LET tm.b    = 'N'   #FUN-740223 mark
   LET tm.d    = 'N'
   LET tm.e    = 'N'
   LET tm.f    = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
  #DISPLAY BY NAME tm.a,tm.b,tm.d,tm.e,tm.f,tm.more    #FUN-740223 mark
   DISPLAY BY NAME tm.d,tm.e,tm.f,tm.more              #FUN-740223
           # Condition
   CONSTRUCT BY NAME tm.wc ON pmm01,pmm04,pmm09
      #No.FUN-580031 --start--
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 ---end---
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r902_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
 
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
 
  #DISPLAY BY NAME tm.a,tm.b,tm.d,tm.e,tm.f,tm.more    #FUN-740223 mark
   DISPLAY BY NAME tm.d,tm.e,tm.f,tm.more              #FUN-740223
           # Condition
  #INPUT BY NAME tm.a,tm.b,tm.d,tm.e,tm.f,tm.more      #FUN-740223 mark
   INPUT BY NAME tm.d,tm.e,tm.f,tm.more                #FUN-740223
           WITHOUT DEFAULTS
 
      #No.FUN-580031 --start--
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
 
     #str FUN-740223 mark
     #AFTER FIELD a
     #   IF tm.a NOT MATCHES '[YN]'  OR tm.a IS NULL
     #      THEN NEXT FIELD a
     #   END IF
     #AFTER FIELD b
     #   IF tm.b NOT MATCHES "[YN]" OR tm.b IS NULL
     #      THEN NEXT FIELD b
     #   END IF
     #end FUN-740223 mark
      AFTER FIELD d
         IF tm.d NOT MATCHES "[YN]" OR tm.d IS NULL
            THEN NEXT FIELD d
         END IF
      AFTER FIELD e
         IF tm.e NOT MATCHES "[YN]" OR tm.e IS NULL
            THEN NEXT FIELD e
         END IF
      AFTER FIELD f
         IF tm.f NOT MATCHES "[YN]" OR tm.f IS NULL
            THEN NEXT FIELD f
         END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES '[YN]'  OR tm.more IS NULL
            THEN NEXT FIELD more
         END IF
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
 
      #No.FUN-580031 --start--
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r902_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='apmr902'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr902','9031',1)
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
                        #" '",tm.a CLIPPED,"'",                 #FUN-740223 mark
                        #" '",tm.b CLIPPED,"'",                 #FUN-740223 mark
                         " '",tm.d CLIPPED,"'" ,
                         " '",tm.e CLIPPED,"'" ,
                         " '",tm.f CLIPPED,"'"  ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmr902',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r902_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr902()
   ERROR ""
END WHILE
   CLOSE WINDOW r902_w
END FUNCTION
 
FUNCTION apmr902()
  #DEFINE  l_img_blob     LIKE type_file.blob        #TQC-C10039  #TQC-C20067--mark
   DEFINE l_name    LIKE type_file.chr20,       # External(Disk) file name            #No.FUN-680136 VARCHAR(20)
          l_time    LIKE type_file.chr8,        # Used time for running the job       #No.FUN-680136 VARCHAR(8)
         #l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT   #TQC-630166 mark  #No.FUN-680136 VARCHAR(1000)
          l_sql     STRING,                     # RDSQL STATEMENT   #TQC-630166
          l_chr     LIKE type_file.chr1,        #No.FUN-680136 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,     #No.FUN-680136 VARCHAR(40)
          sr               RECORD
                                  pmm01 LIKE pmm_file.pmm01,    # 單號
                                  pmm02 LIKE pmm_file.pmm02,    # 單據類別
                                  pmm03 LIKE pmm_file.pmm03,    # 更動序號
                                  pmm04 LIKE pmm_file.pmm04,    # 單據日期
                                  pmm09 LIKE pmm_file.pmm09,    # 廠商編號
                                  pmm12 LIKE pmm_file.pmm12,    # 採購員
                                  pmm13 LIKE pmm_file.pmm13,    # 請購部門
                                  pmm14 LIKE pmm_file.pmm14,    # 收貨部門
                                  pmm15 LIKE pmm_file.pmm15,    # 確認人
                                  pmm16 LIKE pmm_file.pmm16,    # 運送方式
                                  pmm17 LIKE pmm_file.pmm17,    # 代理商
                                  pmm18 LIKE pmm_file.pmm18,    # FOB條件
                                  pmm20 LIKE pmm_file.pmm20,    # 付款方式
                                  pmm22 LIKE pmm_file.pmm22,    # 弊別
                                  pmm42 LIKE pmm_file.pmm42,    # 匯率
                                  pmn02 LIKE pmn_file.pmn02,    # 項次
                                  pmn04 LIKE pmn_file.pmn04,    # 料件編號
                                  pmn041 LIKE pmn_file.pmn041,  # 品名規格
                                  pmn07 LIKE pmn_file.pmn07,    # 單位
                                  pmn15 LIKE pmn_file.pmn15,    # 提前交貨
                                  pmn20 LIKE pmn_file.pmn20,    # 訂購量
                                  pmn64 LIKE pmn_file.pmn64,    # 保稅否
                                  pmn31 LIKE pmn_file.pmn31,    # 單價
                                  pmn33 LIKE pmn_file.pmn33,    # 原始交貨日期
                                  pmn41 LIKE pmn_file.pmn41,    # 原始交貨日期
                                  pmn87 LIKE pmn_file.pmn87,    # 計價數量 #TQC-6C0136
                                  pmn88 LIKE pmn_file.pmn88,    #MOD-9C0315 add
                                  pmn80 LIKE pmn_file.pmn80,    #TQC-6C0136
                                  pmn82 LIKE pmn_file.pmn82,    #TQC-6C0136
                                  pmn83 LIKE pmn_file.pmn83,    #TQC-6C0136
                                  pmn85 LIKE pmn_file.pmn85,    #TQC-6C0136
                                  pmn86 LIKE pmn_file.pmn86,    #TQC-6C0136
                             #    pmn44 LIKE pmn_file.pmn44,    # 本幣單價
                                   g_pmn LIKE pmn_file.pmn31,   #MOD-530190
                             #    pmm10 LIKE pmm_file.pmm10,    # 送貨地址
                                  pmm43 LIKE pmm_file.pmm43,    # 稅率 %
                             #    pmm11 LIKE pmm_file.pmm11,    # 帳單地址
                                  pmmprno LIKE pmm_file.pmmprno # 已列印否
                        END RECORD
          #No.FUN-710091  --begin
          DEFINE   l_n  LIKE type_file.num5  
          DEFINE   l_i  LIKE type_file.num5  
          DEFINE   l_zo041  LIKE  zo_file.zo041 
          DEFINE   l_zo042  LIKE  zo_file.zo042 
          DEFINE   l_zo05   LIKE  zo_file.zo05 
          DEFINE   l_zo06   LIKE  zo_file.zo06 
          DEFINE   l_zo09   LIKE  zo_file.zo09 
          DEFINE   l_pmc03  LIKE  pmc_file.pmc03 
          DEFINE   l_pmc081 LIKE  pmc_file.pmc081    
          DEFINE   l_pmc082 LIKE  pmc_file.pmc082 
#          DEFINE   l_sql1   LIKE  type_file.chr1000
#          DEFINE   l_sql2   LIKE  type_file.chr1000
#          DEFINE   l_sql3   LIKE  type_file.chr1000
#          DEFINE   l_sql4   LIKE  type_file.chr1000
#          DEFINE   l_sql5   LIKE  type_file.chr1000
#          DEFINE   l_sql6   LIKE  type_file.chr1000
          DEFINE   l_sql1,l_sql2,l_sql3,l_sql4,l_sql5,l_sql6        STRING       #NO.FUN-910082
          DEFINE   l_pmo06  LIKE  pmo_file.pmo06
          DEFINE   l_gem02  LIKE  gem_file.gem02 
          DEFINE   l_pmm20  LIKE  pma_file.pma02 
          DEFINE   l_pmm13_gem02 LIKE type_file.chr50  
          DEFINE   l_pmm12_gen02 LIKE type_file.chr50
          DEFINE   l_pmm15_gen02 LIKE type_file.chr50
          DEFINE   l_gen02       LIKE gen_file.gen02
          #No.FUN-710091  --end  
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'apmr902'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 105 END IF
     #TQC-650044
     #IF g_len = 0 OR g_len IS NULL THEN LET g_len = 142 END IF   #No.MOD-5A0121
     #FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     #END TQC-650044
#No.CHI-6A0004-----Begin---
#     SELECT azi03,azi04,azi05
#       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file
#      WHERE azi01=g_aza.aza17
#No.CHI-6A0004----End------
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pmmuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pmmgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pmmgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
     #End:FUN-980030
    #LOCATE l_img_blob IN MEMORY   #blob初始化   #TQC-C10039  #TQC-C20067--mark
     #No.FUN-710091   --begin
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)
     CALL cl_del_data(l_table2)
     CALL cl_del_data(l_table3)
     CALL cl_del_data(l_table4)
     LET g_sql ="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-780049
                " VALUES(?,?,?,?,?,",
                "?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
                "?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"  #,?,?, ?,?)"   #FUN-870151 Add "?"  #MOD-9C0315 add ? #TQC-C10039 ADD 4?	#TQC-C20067--mark
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert_prep:",STATUS,1)
     END IF
     LET g_sql ="INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,  #TQC-780049
                " VALUES(?,?)"     #CHI-7A0018 mod
               #" VALUES(?,?,?)"   #CHI-7A0018 mark
     PREPARE insert_prep1 FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert_prep1:",STATUS,1)
     END IF
     LET g_sql ="INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,  #TQC-780049
                " VALUES(?,?,?)"       #CHI-7A0018 mod  #No.TQC-740276
               #" VALUES(?,?,?,?)"     #CHI-7A0018 mark #No.TQC-740276
     PREPARE insert_prep2 FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert_prep2:",STATUS,1)
     END IF
     LET g_sql ="INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,  #TQC-780049
                " VALUES(?,?,?)"       #CHI-7A0018 mod  #No.TQC-740276
               #" VALUES(?,?,?,?)"     #CHI-7A0018 mark #No.TQC-740276
     PREPARE insert_prep3 FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert_prep3:",STATUS,1)
     END IF
     LET g_sql ="INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,  #TQC-780049
                " VALUES(?,?)"         #CHI-7A0018 mod
               #" VALUES(?,?,?)"       #CHI-7A0018 mark
     PREPARE insert_prep4 FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert_prep4:",STATUS,1)
     END IF
     
     #No.FUN-710091   --end   
 
     LET l_sql = "SELECT  ",
                 "   pmm01,  pmm02,  pmm03,  pmm04,  pmm09,  pmm12,  pmm13 ,",
                 "   pmm14,  pmm15,  pmm16,  pmm17,  pmm18,  pmm20 ,",
                 "   pmm22,  pmm42,  pmn02,  pmn04,  pmn041, pmn07 ,",
                 "   pmn15,  pmn20,  pmn64,  pmn31,  pmn33,pmn41,pmn87,pmn88,pmn80,pmn82,pmn83,pmn85,pmn86,' ',",   #TQC-6C0136 add pmn87/80/82/83/85/86 #MOD-9C0315 add pmn88
                 "   pmm43,  pmmprno ",
                 " FROM pmm_file,pmn_file",
                 " WHERE pmm01 = pmn01 AND pmm18 !='X' ",
                 " AND ",tm.wc
     LET l_sql = l_sql CLIPPED," ORDER BY pmm01,pmn02"
     INITIALIZE pmm12_tm TO NULL
     LET  g_total = 0
 
     PREPARE r902_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM 
     END IF
     DECLARE r902_cs1 CURSOR FOR r902_prepare1
     IF SQLCA.sqlcode THEN CALL cl_err('declare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM 
     END IF
 
    #CALL cl_outnam('apmr902') RETURNING l_name   #No.FUN-710091 
    #TQC-650044
    #IF g_len = 0 OR g_len IS NULL THEN LET g_len = 142 END IF   #No.MOD-5A0121 #No.FUN-710091
    #FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FORS  #No.FUN-710091
    #END TQC-650044
 
    #START REPORT r902_rep TO l_name  #No.FUN-710091 
 
     LET g_pageno = 0
     INITIALIZE g_pmm01 TO NULL  #No.FUN-710091
     FOREACH r902_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach1:',SQLCA.sqlcode,1) EXIT FOREACH END IF
     # INITIALIZE g_pmm01 TO NULL  #No.FUN-710091
       IF sr.pmn31 IS NULL THEN LET sr.pmn31=0  END IF
       IF sr.pmn20 IS NULL THEN LET sr.pmn20=0  END IF
     #TQC-6C0136 --begin
      #LET sr.g_pmn =  sr.pmn31 * sr.pmn20
     #MOD-9C0315---modify---start---
     #IF g_sma.sma116 MATCHES '[13]' THEN
     #   LET sr.g_pmn =  sr.pmn31 * sr.pmn87
     #ELSE
     #   LET sr.g_pmn =  sr.pmn31 * sr.pmn20
     #END IF
      LET sr.g_pmn = sr.pmn88
     #MOD-9C0315---modify---end---
     #TQC-6C0136 --end
#      OUTPUT TO REPORT r902_rep(sr.*)  #No.FUN-710091 
 
      #str FUN-740223 mark
      #LET l_sql1 =" SELECT pmo06  FROM pmo_file    WHERE",
      #        " pmo01='",sr.pmm01,"' AND     pmo02 = '1' "
      #LET l_sql6 = "SELECT imc04 FROM imc_file WHERE imc01='",sr.pmn04 CLIPPED,"'"
      ##向table1插入數據
      #IF tm.a='Y' THEN
      #    LET l_sql2 = l_sql1 CLIPPED," AND  pmo03 ='0'",
      #                 " AND pmo04 = '0'"
      #    PREPARE r901_prepare2 FROM l_sql2
      #    DECLARE r901_note_cur2  CURSOR FOR r901_prepare2
      #    LET l_i = 0
      #    FOREACH r901_note_cur2 INTO l_pmo06
      #        IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode !=100
      #            THEN CALL cl_err('foreach2:',SQLCA.sqlcode,1)
      #                 EXIT FOREACH
      #        END IF
      #        EXECUTE insert_prep1 USING sr.pmm01,l_pmo06,l_i
      #        LET l_i = l_i+1 
      #    END FOREACH
      #END IF
      #
      ##向table2插入數據
      #IF tm.b = 'Y' THEN
      #    LET l_sql3 = l_sql1 CLIPPED," AND  pmo03 ='1' AND pmo05 ='",sr.pmn02,     #No.TQC-740276
      #                 "'  AND pmo04 = '0'"
      #    PREPARE r901_prepare3 FROM l_sql3
      #    DECLARE r901_note_cur3 CURSOR FOR r901_prepare3
      #    LET l_i=0
      #    FOREACH r901_note_cur3 INTO l_pmo06
      #       IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode !=100
      #           THEN CALL cl_err('foreach3:',SQLCA.sqlcode,1)
      #                EXIT FOREACH
      #       END IF
      #       EXECUTE insert_prep2 USING sr.pmm01,l_pmo06,sr.pmn02,l_i    #No.TQC-740276
      #       LET l_i = l_i+1
      #    END FOREACH
      #END IF
      #
      ##向table3插入數據
      #IF tm.b = 'Y' THEN
      #    LET l_sql4 = l_sql1 CLIPPED," AND  pmo03 ='1' AND pmo05 ='",sr.pmn02,     #No.TQC-740276
      #                 "'  AND pmo04 = '1'"
      #    PREPARE r901_prepare4 FROM l_sql4
      #    DECLARE r901_note_cur4 CURSOR FOR r901_prepare4
      #    FOREACH r901_note_cur4 INTO l_pmo06
      #      IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode !=100
      #         THEN CALL cl_err('foreach4:',SQLCA.sqlcode,1) EXIT FOREACH
      #      END IF
      #      EXECUTE insert_prep3 USING sr.pmm01,l_pmo06,sr.pmn02,l_i      #No.TQC-740276
      #      LET l_i = l_i+1
      #    END FOREACH
      #END IF
      #
      ##向table4插入數據
      #IF tm.a='Y' THEN
      #    LET l_sql5 = l_sql1 CLIPPED," AND  pmo03 ='0'"," AND pmo04 = '1'"
      #    PREPARE r902_prepare5 FROM l_sql5
      #    DECLARE r902_note_cur5 CURSOR FOR r902_prepare5
      #    FOREACH r902_note_cur5 INTO l_pmo06
      #        IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode !=100
      #           THEN CALL cl_err('foreach5:',SQLCA.sqlcode,1) EXIT FOREACH
      #        END IF
      #        EXECUTE insert_prep4 USING sr.pmm01,l_pmo06,l_i
      #        LET l_i = l_i+1
      #    END FOREACH
      #END IF
      #end FUN-740223 mark
 
       #收貨部門
       SELECT gem02 INTO l_gem02 FROM gem_file WHERE sr.pmm14=gem01
       IF SQLCA.sqlcode THEN LET l_gem02 = NULL END IF 
 
       #付款方式
       SELECT pma02 INTO l_pmm20 FROM pma_file WHERE pma01 = sr.pmm20
       IF SQLCA.sqlcode THEN LET l_pmm20 = sr.pmm20 END IF 
       #請購部門
       SELECT gem02 INTO l_gem02 FROM gem_file WHERE sr.pmm13=gem01
       IF SQLCA.sqlcode THEN LET l_gem02 = NULL END IF 
       IF l_gem02 IS  NOT NULL THEN
           LET l_pmm13_gem02 = l_gem02
       ELSE
           LET l_pmm13_gem02 = sr.pmm13
       END IF
       #確認人
       SELECT gen02 INTO l_gen02 FROM gen_file WHERE sr.pmm15=gen01
       IF SQLCA.sqlcode THEN LET l_gen02 = NULL END IF 
       IF l_gen02 IS  NOT NULL THEN
           LET l_pmm15_gen02 = l_gen02
       ELSE
           LET l_pmm15_gen02 = sr.pmm15
       END IF
       #採購人
       SELECT gen02 INTO l_gen02 FROM gen_file WHERE sr.pmm12=gen01
       IF SQLCA.sqlcode THEN LET l_gen02 = NULL END IF 
       IF l_gen02 IS  NOT NULL THEN
           LET l_pmm12_gen02 = l_gen02
       ELSE
           LET l_pmm12_gen02 = sr.pmm12
       END IF
 
     #CHI-7A0018 add
      #額外備註-項次前備註 
      DECLARE pmo_cur2 CURSOR FOR
         SELECT pmo06 FROM pmo_file 
          WHERE pmo01=sr.pmm01 AND pmo03=sr.pmn02 AND pmo04='0'
          ORDER BY pmo05                                                      
      FOREACH pmo_cur2 INTO l_pmo06                                           
         EXECUTE insert_prep2 USING sr.pmm01,sr.pmn02,l_pmo06                                    
      END FOREACH
      
      #額外備註-項次後備註 
      DECLARE pmo_cur3 CURSOR FOR
       SELECT pmo06 FROM pmo_file    
        WHERE pmo01=sr.pmm01 AND pmo03=sr.pmn02 AND pmo04='1'
        ORDER BY pmo05                                                        
      FOREACH pmo_cur3 INTO l_pmo06                                           
         EXECUTE insert_prep3 USING sr.pmm01,sr.pmn02,l_pmo06                                    
      END FOREACH
     #CHI-7A0018 add
 
      #SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05    #No.CHI-6A0004  #No.FUN-870151 Mark
       SELECT azi03,azi04,azi05,azi07 INTO t_azi03,t_azi04,t_azi05,t_azi07      #No.FUN-870151       
         FROM azi_file WHERE azi01=sr.pmm22
 
    SELECT  zo041,zo042,zo09,zo05,zo06 INTO l_zo041,l_zo042,l_zo09,l_zo05
               ,l_zo06   FROM zo_file WHERE zo01 = g_rlang
       IF SQLCA.sqlcode THEN LET l_zo041 = NULL
          LET l_zo042 = NULL
          LET l_zo09 = NULL
          LET l_zo05 = NULL
          LET l_zo06 = NULL
       END IF
       LET l_pmc03  = NULL
       LET l_pmc081 = NULL
       LET l_pmc082 = NULL
       SELECT pmc03,pmc081,pmc082
          INTO l_pmc03,l_pmc081,l_pmc082
          FROM pmc_file WHERE sr.pmm09 = pmc01
 
       IF sr.pmm01 = g_pmm01 AND NOT cl_null(g_pmm01) THEN
          LET l_n = 1
       ELSE 
          LET l_n = 0
       END IF 
       LET g_pmm01 = sr.pmm01
       EXECUTE insert_prep USING sr.*,l_n,l_zo041,l_zo042,l_pmc081,l_pmc082,
                                 l_zo05,l_zo09,l_zo06,l_gem02,l_pmm20,l_pmm13_gem02,l_pmm15_gen02,l_pmm12_gen02,t_azi03,t_azi04,t_azi05,
                                 t_azi07,   #No.FUN-870151
                                 l_pmc03 #No.FUN-710091
                              #  "",l_img_blob, "N",""   #TQC-C10039 ADD "",l_img_blob, "N",""  #TQC-C20067--mark
     END FOREACH
 
 
  #str CHI-7A0018 add
   #處理單據前、後特別說明
   LET l_sql = "SELECT pmm01 FROM pmm_file ",
               " WHERE ",tm.wc CLIPPED,
               "   ORDER BY pmm01"
   PREPARE r902_prepare2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare2:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   DECLARE r902_cs2 CURSOR FOR r902_prepare2
 
   FOREACH r902_cs2 INTO sr.pmm01
      #額外備註-單據前備註 
      DECLARE pmo_cur CURSOR FOR
         SELECT pmo06 FROM pmo_file
          WHERE pmo01=sr.pmm01 AND pmo03=0 AND pmo04='0'
          ORDER BY pmo05 
      FOREACH pmo_cur INTO l_pmo06
         EXECUTE insert_prep1 USING sr.pmm01,l_pmo06 
      END FOREACH
     
      #額外備註-單據後備註 
      DECLARE pmo_cur4 CURSOR FOR
       SELECT pmo06 FROM pmo_file
        WHERE pmo01=sr.pmm01 AND pmo03=0 AND pmo04='1'
        ORDER BY pmo05 
      FOREACH pmo_cur4 INTO l_pmo06
         EXECUTE insert_prep4 USING sr.pmm01,l_pmo06 
      END FOREACH
   END FOREACH
  #end CHI-7A0018 add
 
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED
  #end CHI-7A0018 add
 
#    FINISH REPORT r902_rep #No.FUN-710091
#No.FUN-710091  --begin
  #str FUN-740223 modify 
  #  LET g_sql ="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #CHI-7A0018 mark
  #  LET g_sql ="SELECT A.*,B.pmo06_1,B.l_i_1,C.pmo06_2,C.l_i_2,D.pmo06_3,D.l_i_3,E.pmo06_4,E.l_i_4 FROM ",
  ##TQC-730088 #  l_table CLIPPED," A,",l_table1 CLIPPED," B,",
  #            #  l_table2 CLIPPED," C,",l_table3 CLIPPED," D,",
  #            #  l_table4 CLIPPED," E ",
  #               g_cr_db_str CLIPPED,l_table CLIPPED," A,",g_cr_db_str CLIPPED,l_table1 CLIPPED," B,",     #No.TQC-740276
  #               g_cr_db_str CLIPPED,l_table2 CLIPPED," C,",g_cr_db_str CLIPPED,l_table3 CLIPPED," D,",    #No.TQC-740276
  #               g_cr_db_str CLIPPED,l_table4 CLIPPED," E ",
  #             " WHERE A.pmm01=B.pmm01(+)",    #No.TQC-740276
  #             " AND A.pmm01 = C.pmm01(+)",    #No.TQC-740276
  #             " AND A.pmn02 = C.pmn02(+)",    #No.TQC-740276
  #             " AND A.pmm01 = D.pmm01(+)",    #No.TQC-740276
  #             " AND A.pmn02 = D.pmn02(+)",    #No.TQC-740276
  #             " AND A.pmm01 = E.pmm01(+)"     #No.TQC-740276
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'pmm01,pmm04,pmm09')
             RETURNING tm.wc
     ELSE
        LET tm.wc = ''
     END IF
    #LET g_str = tm.wc,";",tm.a,";",tm.b,";",tm.d,";",tm.e,";",tm.f
     LET g_str = tm.wc,";;;",tm.d,";",tm.e,";",tm.f
  #end FUN-740223 modify
   # CALL cl_prt_cs3("apmr902",g_sql,g_str)  #TQC-730088
#TQC-C20067--mark--begin
#    LET g_cr_table = l_table                 #主報表的temp table名稱  #TQC-C10039
#    LET g_cr_apr_key_f = "pmm01"       #報表主鍵欄位名稱  #TQC-C10039
#TQC-C20067--mark--end
     CALL cl_prt_cs3('apmr902','apmr902',g_sql,g_str)
#No.FUN-710091  --end  
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len) #No.FUN-710091
END FUNCTION
#No.FUN-710091  --begin
#REPORT r902_rep(sr)
#   DEFINE l_last_sw     LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
#          l_sw          LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
#          l_pmm22       LIKE pmm_file.pmm22,
#          l_pmm42       LIKE pmm_file.pmm42,
#          l_pmm43       LIKE pmm_file.pmm43,
#          l_pmm20       LIKE pma_file.pma02,
#          l_pmm16       LIKE pmm_file.pmm16,
#          l_pmm17       LIKE pmm_file.pmm17,
#          l_pmm18       LIKE type_file.chr1000, # RDSQL STATEMENT #No.FUN-680136 VARCHAR(100)
#          l_pmm14_gem02 LIKE type_file.chr8,   	#No.FUN-680136 VARCHAR(8)
#          l_pmm13_gem02 LIKE type_file.chr8,   	#No.FUN-680136 VARCHAR(8) 
#          l_pmm12_gen02 LIKE type_file.chr8,   	#No.FUN-680136 VARCHAR(8) 
#          l_pmm15_gen02 LIKE type_file.chr8,   	#No.FUN-680136 VARCHAR(8) 
#          l_ima08       LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1) 
#          l_ima37       LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
#          l_dash        LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
#          l_str         LIKE type_file.chr1000,	#No.FUN-680136 VARCHAR(50)
#          l_sql1        LIKE type_file.chr1000, # RDSQL STATEMENT #No.FUN-680136 VARCHAR(1000)
#          l_sql2        LIKE type_file.chr1000, # RDSQL STATEMENT #No.FUN-680136 VARCHAR(1000)
#          l_sql3        LIKE type_file.chr1000, # RDSQL STATEMENT #No.FUN-680136 VARCHAR(1000)
#          l_sql4        LIKE type_file.chr1000, # RDSQL STATEMENT #No.FUN-680136 VARCHAR(1000)
#          l_sql5        LIKE type_file.chr1000, # RDSQL STATEMENT #No.FUN-680136 VARCHAR(1000)
#          l_sql6        LIKE type_file.chr1000, # RDSQL STATEMENT #No.FUN-680136 VARCHAR(1000)
#          l_sql7        LIKE type_file.chr1000, # RDSQL STATEMENT #No.FUN-680136 VARCHAR(1000)
#          l_sql8        LIKE type_file.chr1000, # RDSQL STATEMENT #No.FUN-680136 VARCHAR(1000)
#          l_sql9        LIKE type_file.chr1000, # RDSQL STATEMENT #No.FUN-680136 VARCHAR(1000)
#          l_pmn20       LIKE pmn_file.pmn20,    #MOD-530190
#          l_gem02  LIKE gem_file.gem02,
#          l_zo02   LIKE  zo_file.zo02,          #公司基本資料
#          l_zo041  LIKE  zo_file.zo041,
#          l_zo042  LIKE  zo_file.zo042,
#          l_zo0412 LIKE  zo_file.zo042,
#          l_zo05   LIKE  zo_file.zo05,
#          l_zo06   LIKE  zo_file.zo06,
#          l_zo09   LIKE  zo_file.zo09,
#          l_pmc03 LIKE pmc_file.pmc03,
#          l_pmc081 LIKE pmc_file.pmc081,        # 公司全名
#          l_pmc082 LIKE pmc_file.pmc082,
#          l_pmo06  LIKE pmo_file.pmo06,
#          l_gen02  LIKE gen_file.gen02,
#          l_pmc02       LIKE pmc_file.pmc02, 	#No.FUN-680136 VARCHAR(4)
#          l_imc04       LIKE imc_file.imc04,
#          l_pmn121      LIKE pmn_file.pmn121,
#          l_pmn122      LIKE pmn_file.pmn122,
#          l_pmn123      LIKE pmn_file.pmn123,
#          l_count       LIKE type_file.num5,    #No.FUN-680136 SMALLINT
#          l_rec         LIKE type_file.num5,   	#No.FUN-680136 SMALLINT
#          l_item        LIKE type_file.num5,   	#No.FUN-680136 SMALLINT
#          l1_ima02      LIKE ima_file.ima02,
#          l_n           LIKE type_file.num5,    #No.FUN-680136 SMALLINT
#          l_pageno      LIKE type_file.num5,   	#No.FUN-680136 SMALLINT
#          l_sub         LIKE pmn_file.pmn31,    #MOD-530190
#          sr               RECORD
#                                  pmm01 LIKE pmm_file.pmm01,    # 單號
#                                  pmm02 LIKE pmm_file.pmm02,    # 單據類別
#                                  pmm03 LIKE pmm_file.pmm03,     # 更動序號
#                                  pmm04 LIKE pmm_file.pmm04,     # 單據日期
#                                  pmm09 LIKE pmm_file.pmm09,    # 廠商編號
#                                  pmm12 LIKE pmm_file.pmm12,    # 採購員
#                                  pmm13 LIKE pmm_file.pmm13,    # 請購部門
#                                  pmm14 LIKE pmm_file.pmm14,    # 收貨部門
#                                  pmm15 LIKE pmm_file.pmm15,    # 確認人
#                                  pmm16 LIKE pmm_file.pmm16,    # 運送方式
#                                  pmm17 LIKE pmm_file.pmm17,    # 代理商
#                                  pmm18 LIKE pmm_file.pmm18,    # FOB條件
#                                  pmm20 LIKE pmm_file.pmm20,    # 付款方式
#                                  pmm22 LIKE pmm_file.pmm22,    # 弊別
#                                  pmm42 LIKE pmm_file.pmm42,    # 匯率
#                                  pmn02 LIKE pmn_file.pmn02,    # 項次
#                                  pmn04 LIKE pmn_file.pmn04,    # 料件編號
#                                  pmn041 LIKE pmn_file.pmn041,  # 料件編號
#                                  pmn07 LIKE pmn_file.pmn07,    # 單位
#                                  pmn15 LIKE pmn_file.pmn15,    # 提前交貨
#                                  pmn20 LIKE pmn_file.pmn20,    # 訂購量
#                                  pmn64 LIKE pmn_file.pmn64,    # 課稅否
#                                  pmn31 LIKE pmn_file.pmn31,    # 單價
#                                  pmn33 LIKE pmn_file.pmn33,    # 原始交貨日期
#                                  pmn41 LIKE pmn_file.pmn41,    # 原始交貨日期
#                                  pmn87 LIKE pmn_file.pmn87,    # 計價數量 #TQC-6C0136
#                                  pmn80 LIKE pmn_file.pmn80,    #TQC-6C0136
#                                  pmn82 LIKE pmn_file.pmn82,    #TQC-6C0136
#                                  pmn83 LIKE pmn_file.pmn83,    #TQC-6C0136
#                                  pmn85 LIKE pmn_file.pmn85,    #TQC-6C0136
#                                  pmn86 LIKE pmn_file.pmn86,    #TQC-6C0136
#                           #      pmn44 LIKE pmn_file.pmn44,    # 本幣單價
#                                   g_pmn LIKE pmn_file.pmn31,    #MOD-530190
#                           #      pmm10 LIKE pmm_file.pmm10,    # 送貨地址
#                                  pmm43 LIKE pmm_file.pmm43,    # 稅率%
#                           #      pmm11 LIKE pmm_file.pmm11,    # 帳單地址
#                                  pmmprno LIKE pmm_file.pmmprno    # 已列印否
#                        END RECORD
#DEFINE  l_pmn82         LIKE pmn_file.pmn82,   #TQC-6C0136
#        l_pmn85         LIKE pmn_file.pmn85,   #TQC-6C0136
#        l_ima906        LIKE ima_file.ima906   #TQC-6C0136
#
# 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin         #FUN-550114
#         PAGE LENGTH g_page_line
#  ORDER BY sr.pmm01
#  FORMAT
#   PAGE HEADER
#      SELECT  zo041,zo042,zo09,zo05,zo06 INTO l_zo041,l_zo042,l_zo09,l_zo05
#              ,l_zo06   FROM zo_file WHERE zo01 = g_rlang
#      IF SQLCA.sqlcode THEN LET l_zo041 = NULL
#         LET l_zo042 = NULL
#         LET l_zo09 = NULL
#         LET l_zo05 = NULL
#         LET l_zo06 = NULL
#      END IF
#      LET g_pageno = g_pageno + 1
#      SELECT pmc03,pmc081,pmc082
#         INTO l_pmc03,l_pmc081,l_pmc082
#         FROM pmc_file WHERE sr.pmm09 = pmc01
#      PRINT ' '
#      PRINT g_x[40] CLIPPED,
#            COLUMN 41,g_x[41] CLIPPED,
#            COLUMN 81,g_x[41] CLIPPED,
#            COLUMN 121,g_x[62] CLIPPED,     #No.MOD-5A0121
#            COLUMN 135,g_x[42] CLIPPED      #No.MOD-5A0121
#      PRINT g_x[47] CLIPPED,
#            (g_len-FGL_WIDTH(g_x[01]))/2 SPACES,g_x[01],
##           COLUMN 127,g_x[47] CLIPPED
#            COLUMN 141,g_x[47] CLIPPED      #No.MOD-5A0121
#      PRINT g_x[11] CLIPPED,' ',sr.pmm01 CLIPPED,'-',sr.pmm03 CLIPPED,
##           COLUMN 40,g_company CLIPPED,COLUMN 127,g_x[47] CLIPPED
#            COLUMN 47,g_company CLIPPED,COLUMN 141,g_x[47] CLIPPED   #No.MOD-5A0121
#      PRINT g_x[12] CLIPPED,' ',sr.pmm04 CLIPPED;
## 列印次數,若已列印過則印出'已列印過'的字樣
#      IF sr.pmmprno>0 THEN
#        PRINT COLUMN  26,g_x[13] CLIPPED;
#      ELSE PRINT ' ';
#      END IF
##No.MOD-5A0121 --start--
##     PRINT COLUMN 76,l_zo041 CLIPPED,COLUMN 127,g_x[47] CLIPPED
##     PRINT g_x[14] CLIPPED,' ',sr.pmm09 CLIPPED,05 SPACES,l_pmc03 CLIPPED,
##           COLUMN 76,l_zo042 CLIPPED,COLUMN 127,g_x[47] CLIPPED
##     PRINT g_x[47] CLIPPED,COLUMN 12,l_pmc081 CLIPPED,COLUMN 76,
##           g_x[15] CLIPPED,l_zo05 CLIPPED,'   ',
##           g_x[16] CLIPPED,l_zo09 CLIPPED,COLUMN 127,g_x[47] CLIPPED
##     PRINT g_x[47] CLIPPED,COLUMN 12,l_pmc082 CLIPPED,COLUMN 76, g_x[17] CLIPPED,
##           l_zo06 CLIPPED,COLUMN 127,g_x[47] CLIPPED
#      PRINT COLUMN 83,l_zo041 CLIPPED,COLUMN 141,g_x[47] CLIPPED
#      PRINT g_x[14] CLIPPED,' ',sr.pmm09 CLIPPED,05 SPACES,l_pmc03 CLIPPED,
#            COLUMN 83,l_zo042 CLIPPED,COLUMN 141,g_x[47] CLIPPED
#      PRINT g_x[47] CLIPPED,COLUMN 12,l_pmc081 CLIPPED,COLUMN 83,
#            g_x[15] CLIPPED,l_zo05 CLIPPED,'   ',
#            g_x[16] CLIPPED,l_zo09 CLIPPED,COLUMN 141,g_x[47] CLIPPED
#      PRINT g_x[47] CLIPPED,COLUMN 12,l_pmc082 CLIPPED,COLUMN 83, g_x[17] CLIPPED,
#            l_zo06 CLIPPED,COLUMN 141,g_x[47] CLIPPED
##No.MOD-5A0121 --end--
#      PRINT g_x[43] CLIPPED,
#            COLUMN 41,g_x[41] CLIPPED,
#            COLUMN 81,g_x[41] CLIPPED,
#            COLUMN 121,g_x[62] CLIPPED,     #No.MOD-5A0121
#            COLUMN 135,g_x[44] CLIPPED      #No.MOD-5A0121
#      PRINT g_x[18] CLIPPED,
##No.MOD-5A0121 --start--
##           COLUMN 41,g_x[19] CLIPPED,
##           COLUMN 70,g_x[20] CLIPPED,
##           COLUMn 117,g_x[21] CLIPPED
#            COLUMN 55,g_x[19] CLIPPED,
#            COLUMN 84,g_x[20] CLIPPED,
#            COLUMn 131,g_x[21] CLIPPED
##No.MOD-5A0121 --end--
#      PRINT g_x[43] CLIPPED,
#            COLUMN 41,g_x[41] CLIPPED,
#            COLUMN 81,g_x[41] CLIPPED,
#            COLUMN 121,g_x[62] CLIPPED,     #No.MOD-5A0121
#            COLUMN 135,g_x[44] CLIPPED      #No.MOD-5A0121
#      LET l_sql1 =" SELECT pmo06  FROM pmo_file    WHERE",
#              " pmo01='",sr.pmm01,"' AND     pmo02 = '1' "
#      LET l_sql6 = "SELECT imc04 FROM imc_file WHERE imc01='",sr.pmn04 CLIPPED,"'"
#      LET l_rec = 0
# 
#   BEFORE GROUP OF sr.pmm01
#      LET l_sub = 0
##公司基本資料，每張單號的第一頁才需要印
#      IF  PAGENO > 1 OR LINENO > 9
#              THEN SKIP TO TOP OF PAGE
#      END IF
#      LET l_last_sw = 'n'
#      IF tm.a='Y' THEN
#          LET l_sw = 'Y'
#          LET l_sql2 = l_sql1 CLIPPED," AND  pmo03 ='0'",
#                       " AND pmo04 = '0'"
#          PREPARE r901_prepare2 FROM l_sql2
#     IF SQLCA.sqlcode THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
#        EXIT PROGRAM 
#     END IF
#          DECLARE r901_note_cur2  CURSOR FOR r901_prepare2
#     IF SQLCA.sqlcode THEN CALL cl_err('declare:',SQLCA.sqlcode,1) 
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
#        EXIT PROGRAM 
#     END IF
#          LET l_count = 0
#          FOREACH r901_note_cur2 INTO l_pmo06
#              IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode !=100
#                  THEN CALL cl_err('foreach2:',SQLCA.sqlcode,1)
#                       EXIT FOREACH
#              END IF
#              IF l_sw = 'Y' THEN
##                 PRINT g_x[47] CLIPPED,g_x[30] CLIPPED,COLUMN 127,g_x[47] CLIPPED
#                  PRINT g_x[47] CLIPPED,g_x[30] CLIPPED,COLUMN 141,g_x[47] CLIPPED   #No.MOD-5A0121
#                  LET l_sw = 'N'
#              END IF
##             PRINT g_x[47] CLIPPED,l_pmo06 CLIPPED,COLUMN 127,g_x[47] CLIPPED
#              PRINT g_x[47] CLIPPED,l_pmo06 CLIPPED,COLUMN 141,g_x[47] CLIPPED       #No.MOD-5A0121
#          END FOREACH
##         PRINT g_x[47] CLIPPED,COLUMN 127,g_x[47] CLIPPED
#          PRINT g_x[47] CLIPPED,COLUMN 141,g_x[47] CLIPPED    #No.MOD-5A0121
#      END IF
#      LET l_rec = 0
#      LET l_item= 0
#
#   ON EVERY ROW
#      IF tm.b = 'Y' THEN
#          LET l_sql3 = l_sql1 CLIPPED," AND  pmo03 ='",sr.pmn02,
#                       "'  AND pmo04 = '0'"
#          PREPARE r901_prepare3 FROM l_sql3
#          DECLARE r901_note_cur3 CURSOR FOR r901_prepare3
#          LET l_rec   = l_rec+1
#          FOREACH r901_note_cur3 INTO l_pmo06
#             IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode !=100
#                 THEN CALL cl_err('foreach3:',SQLCA.sqlcode,1)
#                      EXIT FOREACH
#             END IF
##            PRINT g_x[47] CLIPPED,5 SPACES,l_pmo06 CLIPPED,COLUMN 127,g_x[47] CLIPPED
#             PRINT g_x[47] CLIPPED,5 SPACES,l_pmo06 CLIPPED,COLUMN 141,g_x[47] CLIPPED   #No.MOD-5A0121
#          END FOREACH
#      END IF
#      LET l_rec=l_rec+1
#      LET l_item  = l_item+1
#      SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05   #No.CHI-6A0004
#        FROM azi_file WHERE azi01=sr.pmm22
#      PRINT g_x[47] CLIPPED,
#            COLUMN 08,sr.pmn02 USING "####",
#            COLUMN 14,sr.pmn04 CLIPPED,
##No.MOD-5A0121 --start--
##           COLUMN 41,sr.pmn33 CLIPPED,
##           COLUMN 52,sr.pmn15 CLIPPED,
##           COLUMN 61,sr.pmn07 CLIPPED,
##           COLUMN 66,cl_numfor(sr.pmn31,15,g_azi03) CLIPPED,
##           COLUMN 83,sr.pmn20 USING "-------&.&&&",
##           COLUMN 96,cl_numfor(sr.g_pmn,18,g_azi04) CLIPPED ,
##           COLUMN 119,sr.pmn64 CLIPPED,
##           COLUMN 127,g_x[47] CLIPPED
#            COLUMN 55,sr.pmn33 CLIPPED,
#       #TQC-6C0136--begin
#           #COLUMN 66,sr.pmn15 CLIPPED,
#           #COLUMN 75,sr.pmn07 CLIPPED,
#           #COLUMN 80,cl_numfor(sr.pmn31,15,t_azi03) CLIPPED, #No.CHI-6A0004
#           #COLUMN 97,sr.pmn20 USING "-------&.&&&",
#           #COLUMN 110,cl_numfor(sr.g_pmn,18,t_azi04) CLIPPED ,  #No.CHI-6A0004
#           COLUMN 66,sr.pmn15 CLIPPED;
#           IF g_sma.sma116 MATCHES '[13]' THEN
#             PRINT COLUMN 75,sr.pmn86 CLIPPED,
#                   COLUMN 80,cl_numfor(sr.pmn31,15,t_azi03) CLIPPED,
#                   COLUMN 97,sr.pmn87 USING "-------&.&&&";
#           ELSE
#             PRINT COLUMN 75,sr.pmn07 CLIPPED,
#                   COLUMN 80,cl_numfor(sr.pmn31,15,t_azi03) CLIPPED,
#                   COLUMN 97,sr.pmn20 USING "-------&.&&&";
#           END IF
#           PRINT COLUMN 110,cl_numfor(sr.g_pmn,18,t_azi04) CLIPPED ,
#       #TQC-6C0136--end
#            COLUMN 132,sr.pmn64 CLIPPED, #TQC-5B0037 119->132
#            COLUMN 141,g_x[47] CLIPPED
##No.MOD-5A0121 --end--
#
#      IF l_count = 0  THEN
##         PRINT g_x[47] CLIPPED,5 SPACES,sr.pmn041 CLIPPED,COLUMN 127,g_x[47] CLIPPED
#          PRINT g_x[47] CLIPPED,11 SPACES,sr.pmn041 CLIPPED,COLUMN 141,g_x[47] CLIPPED    #No.MOD-5A0121
#       #TQC-6C0136 add--begin
#        #使用多單位或計價單位要列印單位註記
#         LET l_str = ""
#         IF g_sma.sma115 = "Y" THEN
#            SELECT ima906 INTO l_ima906 FROM ima_file
#                 WHERE ima01=sr.pmn04
#
#            CASE l_ima906
#               WHEN "2"
#                   CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85
#                   LET l_str = l_pmn85 , sr.pmn83 CLIPPED
#                   IF cl_null(sr.pmn85) OR sr.pmn85 = 0 THEN
#                       CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82
#
#                       LET l_str = l_pmn82, sr.pmn80 CLIPPED
#                   ELSE
#                      IF NOT cl_null(sr.pmn82) AND sr.pmn82 > 0 THEN
#                         CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82
#                         LET l_str = l_str CLIPPED,',',l_pmn82, sr.pmn80 CLIPPED
#                      END IF
#                   END IF
#               WHEN "3"
#                   IF NOT cl_null(sr.pmn85) AND sr.pmn85 > 0 THEN
#                       CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85
#                       LET l_str = l_pmn85 , sr.pmn83 CLIPPED
#                   END IF
#            END CASE
#         END IF
#         IF g_sma.sma116 MATCHES '[13]' THEN
#            IF sr.pmn07 <> sr.pmn86 THEN
#               CALL cl_remove_zero(sr.pmn20) RETURNING l_pmn20
#               LET l_str = l_str CLIPPED,"(",l_pmn20,sr.pmn07 CLIPPED,")"
#             END IF
#         END IF
#         IF g_sma.sma115 = "Y" OR g_sma.sma116 MATCHES '[13]' THEN
#            PRINT g_x[47] CLIPPED,11 SPACES,l_str CLIPPED,COLUMN 141,g_x[47] CLIPPED    #No.MOD-5A0121
#         END IF
#       #TQC-6C0136 --end
#
#         LET l_count = 0
#      ELSE  LET l_count = 0
#      END IF
#      IF tm.b = 'Y' THEN
#          LET l_sql4 = l_sql1 CLIPPED," AND  pmo03 ='",sr.pmn02,
#                       "'  AND pmo04 = '1'"
#          PREPARE r901_prepare4 FROM l_sql4
#          DECLARE r901_note_cur4 CURSOR FOR r901_prepare4
#          LET l_count = 0
#          FOREACH r901_note_cur4 INTO l_pmo06
#            IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode !=100
#               THEN CALL cl_err('foreach4:',SQLCA.sqlcode,1) EXIT FOREACH
#            END IF
##           PRINT g_x[47] CLIPPED,5 SPACES,l_pmo06,COLUMN 127,g_x[47] CLIPPED
#            PRINT g_x[47] CLIPPED,5 SPACES,l_pmo06,COLUMN 141,g_x[47] CLIPPED    #No.MOD-5A0121
#          END FOREACH
#      END IF
##     PRINT g_x[47] CLIPPED,COLUMN 127,g_x[47] CLIPPED
#      PRINT g_x[47] CLIPPED,COLUMN 141,g_x[47] CLIPPED    #No.MOD-5A0121
#
#   AFTER GROUP OF sr.pmm01
#       IF tm.a='Y' THEN
#           LET l_sw = 'Y'
#           LET l_sql5 = l_sql1 CLIPPED," AND  pmo03 ='0'"," AND pmo04 = '1'"
#           PREPARE r902_prepare5 FROM l_sql5
#           DECLARE r902_note_cur5 CURSOR FOR r902_prepare5
#           FOREACH r902_note_cur5 INTO l_pmo06
#               IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode !=100
#                  THEN CALL cl_err('foreach5:',SQLCA.sqlcode,1) EXIT FOREACH
#               END IF
#               IF l_sw = 'Y' THEN
##                  PRINT g_x[47] CLIPPED,g_x[30] CLIPPED,COLUMN 127,g_x[47] CLIPPED
#                   PRINT g_x[47] CLIPPED,g_x[30] CLIPPED,COLUMN 141,g_x[47] CLIPPED   #No.MOD-5A0121
#                   LET l_sw = 'N'
#               END IF
##              PRINT g_x[47] CLIPPED,l_pmo06 CLIPPED,COLUMN 127,g_x[47] CLIPPED
#               PRINT g_x[47] CLIPPED,l_pmo06 CLIPPED,COLUMN 127,g_x[47] CLIPPED       #No.MOD-5A0121
##              LET  l_count=l_count +1
#           END FOREACH
#       END IF
#
#     #TQC-6C0136--begin
#       #LET g_total = GROUP SUM(sr.pmn20 *sr.pmn31)
#       IF g_sma.sma116 MATCHES '[13]' THEN
#          LET  g_total =  GROUP SUM(sr.pmn31 * sr.pmn87)
#       ELSE
#          LET g_total = GROUP SUM(sr.pmn20 *sr.pmn31)
#       END IF
#     #TQC-6C0136--end
#
##      NEED 3 LINES
#       LET g_total = g_total + l_sub
##No.MOD-5A0121 --start--
##      PRINT g_x[47] CLIPPED,COLUMN 127,g_x[47] CLIPPED
##      PRINT g_x[47] CLIPPED,COLUMN 84,g_x[27] CLIPPED,g_pageno CLIPPED,
##            COLUMN 127,g_x[47] CLIPPED
##      PRINT g_x[47] CLIPPED,COLUMN 84,g_x[28] CLIPPED,l_item CLIPPED,
##            COLUMN 127,g_x[47] CLIPPED
##      PRINT g_x[47] CLIPPED,COLUMN 84,g_x[29] CLIPPED,
##            '(',sr.pmm22,')' CLIPPED,cl_numfor(g_total,18,g_azi05),
##            #USING "<<,<<<,<<<,<<&.&&&"  ,
##            COLUMN 127,g_x[47] CLIPPED
##      PRINT g_x[47] CLIPPED,COLUMN 104 ,"------------------",
##            COLUMN 127,g_x[47] CLIPPED
##      PRINT g_x[47] CLIPPED,COLUMN 47,g_x[32],COLUMN 127,g_x[47] CLIPPED
#       PRINT g_x[47] CLIPPED,COLUMN 141,g_x[47] CLIPPED
#       PRINT g_x[47] CLIPPED,COLUMN 98,g_x[27] CLIPPED,g_pageno CLIPPED,
#             COLUMN 141,g_x[47] CLIPPED
#       PRINT g_x[47] CLIPPED,COLUMN 98,g_x[28] CLIPPED,l_item CLIPPED,
#             COLUMN 141,g_x[47] CLIPPED
#       PRINT g_x[47] CLIPPED,COLUMN 98,g_x[29] CLIPPED,
#             '(',sr.pmm22,')' CLIPPED,cl_numfor(g_total,18,t_azi05),  #No.CHI-6A0004
#             #USING "<<,<<<,<<<,<<&.&&&"  ,
#             COLUMN 141,g_x[47] CLIPPED
#       PRINT g_x[47] CLIPPED,COLUMN 118 ,"------------------",
#             COLUMN 141,g_x[47] CLIPPED
#       PRINT g_x[47] CLIPPED,COLUMN 61,g_x[32],COLUMN 141,g_x[47] CLIPPED
##No.MOD-5A0121 --end--
#       LET l_count = 0
#       LET l_rec= 0
##      NEED 3 LINES
#       LET l_item= 0
#       LET l_last_sw='y'
#       FOR g_i = LINENO TO 39
##          PRINT g_x[47] CLIPPED,COLUMN 127,g_x[47] CLIPPED
#           PRINT g_x[47] CLIPPED,COLUMN 141,g_x[47] CLIPPED    #No.MOD-5A0121
#       END FOR
#
#       LET g_pageno = 0
#       UPDATE pmm_file SET pmmprno=pmmprno+1 WHERE pmm01 = sr.pmm01
#
#ON LAST ROW
#      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
#         THEN
#              PRINT g_dash[1,g_len]
##             IF tm.wc[001,070] > ' ' THEN            # for 80
##             PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
##             IF tm.wc[071,140] > ' ' THEN
##              PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
##             IF tm.wc[141,210] > ' ' THEN
##              PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
##             IF tm.wc[211,280] > ' ' THEN
##              PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#         #TQC-630166
#         #    IF tm.wc[001,120] > ' ' THEN            # for 132
#         #PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#         #    IF tm.wc[121,240] > ' ' THEN
#         #PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#         #    IF tm.wc[241,300] > ' ' THEN
#         #PRINT COLUMN 10,     
#         CALL cl_prt_pos_wc(tm.wc)
#         #END TQC-630166
#      END IF
#      LET l_last_sw = 'y'
#
#   PAGE TRAILER
#     IF l_last_sw = 'n'
##       THEN PRINT g_x[47] CLIPPED,COLUMN 47,g_x[31] CLIPPED,COLUMN 127,
##                  g_x[47] CLIPPED
#        THEN PRINT g_x[47] CLIPPED,COLUMN 61,g_x[31] CLIPPED,COLUMN 141,  #No.MOD-5A0121
#                   g_x[47] CLIPPED                                        #No.MOD-5A0121
#     ELSE
##       PRINT g_x[47],COLUMN 127,g_x[47] CLIPPED
#        PRINT g_x[47],COLUMN 141,g_x[47] CLIPPED   #No.MOD-5A0121
#     END IF
##    PRINT g_x[43],g_x[41],g_x[41],g_x[44] CLIPPED
##    PRINT g_x[47] CLIPPED,g_x[50],COLUMN 127,g_x[47] CLIPPED
#     PRINT g_x[43],g_x[41],g_x[41],g_x[62],g_x[44] CLIPPED     #No.MOD-5A0121
#     PRINT g_x[47] CLIPPED,g_x[50],COLUMN 141,g_x[47] CLIPPED  #No.MOD-5A0121
##付款資料是否列印
#     IF tm.d = 'Y' THEN
#         SELECT pma02 INTO l_pmm20 FROM pma_file WHERE pma01 = sr.pmm20
#         IF SQLCA.sqlcode THEN LET l_pmm20 = sr.pmm20 END IF #付款方式
#         IF sr.pmm18 = 0 THEN                #FOB條件
#             LET l_pmm18 = g_x[38] CLIPPED
#         ELSE
#             IF sr.pmm18 = 1 OR sr.pmm18 =2  OR sr.pmm18=3 THEN
#                 LET l_pmm18 = g_x[33] CLIPPED
#             END IF
#         END IF
#         #FOB 條件組合STRING
#     #   IF sr.pmm18 = 0 THEN
#     #       LET l_pmm18 ='     '
#     #   END IF
#         IF sr.pmm18 = 1  THEN
#             LET l_pmm18 = l_pmm18 CLIPPED,'/',g_x[34] CLIPPED,g_x[35] CLIPPED
#         END IF
#         IF sr.pmm18 = 2  THEN
#             LET l_pmm18 = l_pmm18 CLIPPED,'/',g_x[36] CLIPPED
#         END IF
#         IF sr.pmm18 = 3  THEN
#             LET l_pmm18 = l_pmm18 CLIPPED,'/',g_x[34] CLIPPED, g_x[37] CLIPPED
#         END IF
#         LET l_pmm22 = sr.pmm22
#         LET l_pmm42 = sr.pmm42
#         LET l_pmm43 = sr.pmm43
#     ELSE
#         INITIALIZE l_pmm22 TO NULL
#         INITIALIZE l_pmm42 TO NULL
#         INITIALIZE l_pmm43 TO NULL
#         INITIALIZE l_pmm20 TO NULL
#         INITIALIZE l_pmm18 TO NULL
#     END IF
##收貨資料是否列印
#     IF tm.e = 'Y' THEN
#         SELECT gem02 INTO l_gem02 FROM gem_file WHERE sr.pmm14=gem01
#         IF SQLCA.sqlcode THEN LET l_gem02 = NULL END IF #收貨部門
#         # 若員工代碼有相對的員工資料則列印員工姓名，否則就列印員工代碼即可
#         IF l_gem02 IS  NOT NULL THEN
#             LET l_pmm14_gem02 = l_gem02
#          ELSE
#             LET l_pmm14_gem02 = sr.pmm14
#          END IF
#         LET l_pmm16 = sr.pmm16
#     ELSE
#         INITIALIZE l_pmm14_gem02 TO NULL
#         INITIALIZE l_pmm16 TO NULL
#     END IF
##內部資料是否列印
#     IF tm.f = 'Y' THEN
#         SELECT gem02 INTO l_gem02 FROM gem_file WHERE sr.pmm13=gem01
#         IF SQLCA.sqlcode THEN LET l_gem02 = NULL END IF #請購部門
#         SELECT gen02 INTO l_gen02 FROM gen_file WHERE sr.pmm15=gen01
#         IF SQLCA.sqlcode THEN LET l_gen02 = NULL END IF #確認人
#         # 若員工代碼有相對的員工資料則列印員工姓名，否則就列印員工代碼即可
#         IF l_gem02 IS  NOT NULL THEN
#             LET l_pmm13_gem02 = l_gem02
#         ELSE
#             LET l_pmm13_gem02 = sr.pmm13
#         END IF
#         IF l_gen02 IS  NOT NULL THEN
#             LET l_pmm15_gen02 = l_gen02
#         ELSE
#             LET l_pmm15_gen02 = sr.pmm15
#         END IF
#         SELECT gen02 INTO l_gen02 FROM gen_file WHERE sr.pmm12=gen01
#         IF SQLCA.sqlcode THEN LET l_gen02 = NULL END IF #採購人
#         # 若員工代碼有相對的員工資料則列印員工姓名，否則就列印員工代碼即可
#         IF l_gen02 IS  NOT NULL THEN
#             LET l_pmm12_gen02 = l_gen02
#         ELSE
#             LET l_pmm12_gen02 = sr.pmm12
#         END IF
#         LET l_pmm17 = sr.pmm17
#     ELSE
#         INITIALIZE l_pmm13_gem02 TO NULL
#         INITIALIZE l_pmm12_gen02 TO NULL
#         INITIALIZE l_pmm15_gen02 TO NULL
#         INITIALIZE l_pmm17 TO NULL
#     END IF
##No.MOD-5A0121 --start--
##    PRINT g_x[47] CLIPPED,g_x[51] CLIPPED,' ',l_pmm22 CLIPPED,
##          COLUMN 17,g_x[55] CLIPPED,l_pmm42 CLIPPED,
##          COLUMN 44,g_x[56] CLIPPED,' ',l_pmm14_gem02 CLIPPED,
##          COLUMN 84,g_x[58] CLIPPED,' ',l_pmm13_gem02 CLIPPED,
##          COLUMN 127,g_x[47] CLIPPED
##    PRINT g_x[47] CLIPPED,g_x[52] CLIPPED,' ',l_pmm43 CLIPPED,'%',
##          COLUMN 44,g_x[57] CLIPPED,' ',l_pmm16 CLIPPED,
##          COLUMN 84,g_x[59] CLIPPED,' ',l_pmm12_gen02 CLIPPED,
##          COLUMN 127,g_x[47] CLIPPED
##    PRINT g_x[47] CLIPPED,g_x[53] CLIPPED,' ',l_pmm20 CLIPPED,
##          COLUMN 84,g_x[60] CLIPPED,' ',l_pmm17 CLIPPED,
##          COLUMN 127,g_x[47] CLIPPED
##    PRINT g_x[47] CLIPPED,g_x[54] CLIPPED,' ',l_pmm18 CLIPPED,
##          COLUMN 84,g_x[61] CLIPPED,' ',l_pmm15_gen02 CLIPPED,
##          COLUMN 127,g_x[47] CLIPPED
##    PRINT g_x[45],g_x[41],g_x[41],g_x[46] CLIPPED
#     PRINT g_x[47] CLIPPED,g_x[51] CLIPPED,' ',l_pmm22 CLIPPED,
#           COLUMN 22,g_x[55] CLIPPED,l_pmm42 CLIPPED,
#           COLUMN 54,g_x[56] CLIPPED,' ',l_pmm14_gem02 CLIPPED,
#           COLUMN 99,g_x[58] CLIPPED,' ',l_pmm13_gem02 CLIPPED,
#           COLUMN 141,g_x[47] CLIPPED
#     PRINT g_x[47] CLIPPED,g_x[52] CLIPPED,' ',l_pmm43 CLIPPED,'%',
#           COLUMN 54,g_x[57] CLIPPED,' ',l_pmm16 CLIPPED,
#           COLUMN 99,g_x[59] CLIPPED,' ',l_pmm12_gen02 CLIPPED,
#           COLUMN 141,g_x[47] CLIPPED
#     PRINT g_x[47] CLIPPED,g_x[53] CLIPPED,' ',l_pmm20 CLIPPED,
#           COLUMN 99,g_x[60] CLIPPED,' ',l_pmm17 CLIPPED,
#           COLUMN 141,g_x[47] CLIPPED
#     PRINT g_x[47] CLIPPED,g_x[54] CLIPPED,' ',l_pmm18 CLIPPED,
#           COLUMN 99,g_x[61] CLIPPED,' ',l_pmm15_gen02 CLIPPED,
#           COLUMN 141,g_x[47] CLIPPED
#     PRINT g_x[45],g_x[41],g_x[41],g_x[62],g_x[46] CLIPPED
##No.MOD-5A0121 --end--
### FUN-550114
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[9]
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#          PRINT g_x[9]
#          PRINT g_memo
#      END IF
### END FUN-550114
#
#END REPORT
#No.FUN-710091  --end
#Patch....NO.TQC-610036 <001,002> #
