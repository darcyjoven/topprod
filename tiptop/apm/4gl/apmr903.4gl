# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Desc/riptions...: 請購單列印
# Input parameter:
# Return code....:
# Date & Author..: 91/10/05 By MAY
# Modify.........: 93/12/03 By Apple
# Note...........: 考慮列印委外代買的資料
# Modify.........: 95/02/21 By Danny  (格式變更)
# modify.........: 97/04/16 By Davidjr(English Note Printing)
# Modify.........: No.MOD-4A0256 04/10/20 By Mandy 單身沒資料,列印時會出現錯誤錯誤視窗,造成程式當掉
# Modify.........: No.FUN-4B0043 04/11/15 By Nicola 加入開窗功能
# Modify.........: No.MOD-530089 05/03/14 By cate 報表標題標準化
# Modify.........: No.MOD-520129 05/02/25 By Mandy 將g_x[30][1,2]改成g_x[30].substring(1,2)
# Modify.........: No.FUN-550060 05/05/30 By Will 單據編號放大
# Modify.........: No.FUN-550114 05/05/27 By echo 新增報表備註
# Modify.........: NO.MOD-580126 05/08/12 By Rosayu 報表表格沒對齊
# Modify.........: No.MOD-580143 05/08/15 By kim 列印廠商時,應該要依排序順序列出,排序依序為:核准狀態,核准日期(由最近開始排序),單價
# Modify.........: No.TQC-5A0009 05/10/06 By kim 報表料號放大
# Modify.........: No.MOD-5A0121 05/10/14 By ice 料號/品名/規格欄位放大
# Modify.........: No.FUN-5A0139 05/10/24 By Pengu 調整報表的格式
# Modify.........: No.TQC-610127 06/02/14 By pengu 單位註解內容無show出
# Modify.........: No.TQC-610085 06/04/06 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.MOD-640056 06/04/08 By Echo 請購單無列印「規格 」欄位
# Modify.........: No.TQC-640132 06/04/18 By Nicola 日期調整
# Modify.........: No.FUN-680136 06/09/05 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/31 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改 
# Modify.........: No.TQC-6A0079 06/11/6 By king 改正被誤定義為apm08類型的
# Modify.........: No.TQC-6A0086 06/11/13 By baogui  報表問題修改
# Modify.........: No.TQC-6B0137 06/11/27 By jamie 當使用計價單位,但不使用多單位時,單位一是NULL,導致單位註解內容為空
# Modify.........: No.FUN-710082 07/03/09 By day 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.TQC-740151 07/04/20 By Rayven 打印不出資料
# Modify.........: No.FUN-740214 07/05/10 By Sarah 特別說明的內容沒有印出來
# Modify.........: No.CHI-7A0026 07/10/15 By jamie 特別說明改由新的子報表寫法
# Modify.........: No.MOD-860194 08/06/18 By Smapmin 列印廠商資料時會重複
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.FUN-910012 09/01/08 By tsai_yen 在CR報表列印簽核欄
# Moidfy.........: No.FUN-930113 09/03/30 By mike 將oah-->pnz
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No.TQC-9A0187 09/10/30 By xiaofeizhu 標準SQL修改
# Modify.........: No:FUN-9C0071 10/01/14 By huangrh 精簡程式
# Modify.........: No.FUN-A40073 10/05/05 By liuxqa modify sql
# Modify.........: No:TQC-A50009 10/05/10 By liuxqa modify sql
# Modify.........: No:FUN-A50041 10/05/10 by tsai_yen 報表簽核圖功能出現Error Messages -450,在fglrun Version 2.21.02中的blob必須先用LOCATE初始化
# Modify.........: No.FUN-B80088 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: No:CHI-B70039 11/08/18 By joHung 金額 = 計價數量 x 單價
# Modify.........: No:TQC-BA0075 11/10/14 By destiny 笔数可输入负数 
# Modify.........: No:TQC-BB0168 12/01/05 By destiny apmt420调用时会报错退出
# Modify.........: No:TQC-C10039 12/01/13 By minpp  CR报表列印TIPTOP与EasyFlow签核图片
# Modify.........: No:CHI-C50001 12/06/05 By Elise 請購單號(pmk01)增加開窗

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
                   wc      LIKE type_file.chr1000,	#No.FUN-680136 VARCHAR(500)
                   a       LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
                   b       LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
                   c       LIKE type_file.num5,         #No.FUN-680136 SMALLINT
                   more    LIKE type_file.chr1   	#No.FUN-680136 VARCHAR(1)
              END RECORD,
          g_zo   RECORD    LIKE zo_file.*
 
   DEFINE g_cnt            LIKE type_file.num10         #No.FUN-680136 INTEGER
   DEFINE i                LIKE type_file.num5          #No.FUN-710082
   DEFINE g_cnt1           LIKE type_file.num10         #No.FUN-710082 
   DEFINE g_i              LIKE type_file.num5          #count/index for any purpose  #No.FUN-680136 SMALLINT
DEFINE   g_sma115        LIKE sma_file.sma115
DEFINE   g_sma116        LIKE sma_file.sma116
DEFINE  g_sql      STRING                                                       
DEFINE  l_table    STRING                                                       
DEFINE  l_table1   STRING                                                       
DEFINE  l_table2   STRING    #FUN-740214 add                                                   
DEFINE  l_str      STRING   
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                         # Supress DEL key function
   #TQC-BB0168--begin
   LET g_pdate = ARG_VAL(1)                 # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   LET tm.c  = ARG_VAL(10)
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #TQC-BB0168--end
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
 
   #--->無使用請購功能
   IF g_sma.sma31 matches'[Nn]' THEN
      CALL cl_err(g_sma.sma31,'mfg0032',1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   #TQC-BB0168--begin 
#  LET g_pdate = ARG_VAL(1)                 # Get arguments from command line
#  LET g_towhom = ARG_VAL(2)
#  LET g_rlang = ARG_VAL(3)
#  LET g_bgjob = ARG_VAL(4)
#  LET g_prtway = ARG_VAL(5)
#  LET g_copies = ARG_VAL(6)
#  LET tm.wc = ARG_VAL(7)
#  LET tm.a  = ARG_VAL(8)
#  LET tm.b  = ARG_VAL(9)
#  LET tm.c  = ARG_VAL(10)   
#  LET g_rep_user = ARG_VAL(11)
#  LET g_rep_clas = ARG_VAL(12)
#  LET g_template = ARG_VAL(13)
#  LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #TQC-BB0168--end 
   IF cl_null(tm.a) THEN LET tm.a='N' END IF
   IF cl_null(tm.b) THEN LET tm.b='N' END IF
   IF cl_null(tm.c) THEN LET tm.c=0   END IF
 
   LET g_sql ="pmk01.pmk_file.pmk01,",
              "smydesc.smy_file.smydesc,",
              "pmk04.pmk_file.pmk04,",
              "pmk13.pmk_file.pmk13,",
              "gem02.gem_file.gem02,",
 
              "pmc081.pmc_file.pmc081,",
              "pmc091.pmc_file.pmc091,",
              "pma02.pma_file.pma02,",
              "pmk41.pmk_file.pmk41,",
              "oah02.oah_file.oah02,",
 
              "pme031.pme_file.pme031,",
              "pme032.pme_file.pme032,",
              "pmk11.pmk_file.pmk11,",
              "gec02.gec_file.gec02,",
              "pmk22.pmk_file.pmk22,",
 
              "pml02.pml_file.pml02,",
              "pml04.pml_file.pml04,",
              "pml07.pml_file.pml07,",
              "pml20.pml_file.pml20,",
              "pml18.pml_file.pml18,",
 
              "pml33.pml_file.pml33,",
              "pml34.pml_file.pml34,",
              "pml35.pml_file.pml35,",
              "pml15.pml_file.pml15,",
              "pml14.pml_file.pml14,",
 
              "pml041.pml_file.pml041,",
              "pml41.pml_file.pml41,",
              "pml80.pml_file.pml80,",
              "pml82.pml_file.pml82,",
              "pml83.pml_file.pml83,",
 
              "pml85.pml_file.pml85,",
              "pml86.pml_file.pml86,",
              "str2.type_file.chr1000,",
              "pmm04.pmm_file.pmm04,",
              "pmm01.pmm_file.pmm01,",
              "pmn02.pmn_file.pmn02,",   #No.TQC-740151
 
              "pmc03.pmc_file.pmc03,",
              "pmn20.pmn_file.pmn20,",
              "pmn07.pmn_file.pmn07,",
              "pmm22.pmm_file.pmm22,",
              "pmn31.pmn_file.pmn31,",
 
              "amt.pmm_file.pmm40,",
              "zo041.zo_file.zo041,",
              "zo042.zo_file.zo042,",
              "zo05.zo_file.zo05,",
              "zo09.zo_file.zo09,",
 
              "pmk21.pmk_file.pmk21,",
              "pme031a.pme_file.pme031,",
              "pme032a.pme_file.pme032,",
              "ima021.ima_file.ima021,",
              "azi03.azi_file.azi03,",
 
              "azi04.azi_file.azi04,",
              "sign_type.type_file.chr1, sign_img.type_file.blob,",    #簽核方式, 簽核圖檔     #FUN-910012
              "sign_show.type_file.chr1,",                               #是否顯示簽核資料(Y/N)  #FUN-910012
              "sign_str.type_file.chr1000"      #簽核字串 #TQC-C10039
 
   LET l_table = cl_prt_temptable('apmr903',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql ="pml02.pml_file.pml02,",   #MOD-860194
              "ima01.ima_file.ima01,",
              "x1_1.type_file.chr10,",
              "x1_2.type_file.chr10,",
              "x1_3.type_file.chr10,",
              "x1_4.type_file.chr10,",
              "x2_1.type_file.num20_6,",
              "x2_2.type_file.num20_6,",
              "x2_3.type_file.num20_6,",
              "x2_4.type_file.num20_6,",
              "x3_1.type_file.chr3,",
              "x3_2.type_file.chr3,",
              "x3_3.type_file.chr3,",
              "x3_4.type_file.chr3,",
              "azi03_1.azi_file.azi03,",
              "azi03_2.azi_file.azi03,",
              "azi03_3.azi_file.azi03,",
              "azi03_4.azi_file.azi03,",
              "i.type_file.num5"
 
   LET l_table1= cl_prt_temptable('apmr9031',g_sql) CLIPPED
   IF l_table1= -1 THEN EXIT PROGRAM END IF
 
   LET g_sql ="pmo01.pmo_file.pmo01,",
              "pmo03.pmo_file.pmo03,",
              "pmo04.pmo_file.pmo04,",
              "pmo05.pmo_file.pmo05,",    #CHI-7A0026 add
              "pmo06.pmo_file.pmo06"      #CHI-7A0026 add
 
   LET l_table2= cl_prt_temptable('apmr9032',g_sql) CLIPPED
   IF l_table2= -1 THEN EXIT PROGRAM END IF
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL r903_tm(0,0)        # Input print condition
   ELSE
      CALL apmr903()           # Read data and create out-file
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r903_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680136 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW r903_w AT p_row,p_col WITH FORM "apm/42f/apmr903"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a    = 'N'
   LET tm.b    = 'N'
   LET tm.c    = 0
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pmk01,pmk04,pmk12,pmk13
 
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
        ON ACTION CONTROLP    #FUN-4B0043
         #CHI-C50001---S---
           CASE
             WHEN INFIELD(pmk12)
          #IF INFIELD(pmk12) THEN
         #CHI-C50001---E---
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmk12
              NEXT FIELD pmk12
          #END IF   #CHI-C50001 mark

        #CHI-C50001---S---
           WHEN INFIELD(pmk01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_pmk3"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO pmk01
                NEXT FIELD pmk01

           OTHERWISE EXIT CASE
         END CASE
        #CHI-C50001---E---
 
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
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r903_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   INPUT BY NAME tm.a,tm.b,tm.c,tm.more WITHOUT DEFAULTS
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD a
         IF tm.a NOT MATCHES "[YN]" OR cl_null(tm.a) THEN
            NEXT FIELD a
         END IF
      AFTER FIELD b
      AFTER FIELD c
         #TQC-BA0075--being
         IF NOT cl_null(tm.c) THEN
            IF tm.c<0 THEN
               CALL cl_err('','aec-020',1)
               NEXT FIELD c
            END IF
         END IF
         #TQC-BA0075--being
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
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
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r903_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='apmr903'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr903','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.a CLIPPED,"'" ,
                         " '",tm.b CLIPPED,"'" ,
                         " '",tm.c CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmr903',g_time,l_cmd)
      END IF
      CLOSE WINDOW r903_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr903()
   ERROR ""
END WHILE
   CLOSE WINDOW r903_w
END FUNCTION
 
FUNCTION apmr903()
   DEFINE l_name    LIKE type_file.chr20,      # External(Disk) file name        #No.FUN-680136 VARCHAR(20)
          l_time    LIKE type_file.chr8,       # Used time for running the job   #No.FUN-680136 VARCHAR(8)
          l_sql     LIKE type_file.chr1000,    # RDSQL STATEMENT                 #No.FUN-680136 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,       #No.FUN-680136 VARCHAR(1)
          l_smyslip LIKE smy_file.smyslip,
          l_za05    LIKE type_file.chr1000,    #No.FUN-680136 VARCHAR(40)
          sr               RECORD
                           pmk01     LIKE pmk_file.pmk01,
                           smydesc   LIKE smy_file.smydesc,
                           pmk04     LIKE pmk_file.pmk04,
                           pmk13     LIKE pmk_file.pmk13,
                           gem02     LIKE gem_file.gem02,
                           pmc081    LIKE pmc_file.pmc081,
                           pmc091    LIKE pmc_file.pmc091,
                           pma02     LIKE pma_file.pma02,
                           pmk41     LIKE pmk_file.pmk41,
                           pnz02     LIKE pnz_file.pnz02, #FUN-930113
                           pme031    LIKE pme_file.pme031,
                           pme032    LIKE pme_file.pme032,
                           pmk11     LIKE pmk_file.pmk11,
                           gec02     LIKE gec_file.gec02,
                           pmk22     LIKE pmk_file.pmk22,
                           pml02     LIKE pml_file.pml02,
                           pml04     LIKE pml_file.pml04,
                           pml07     LIKE pml_file.pml07,
                           pml20     LIKE pml_file.pml20,
                           pml18     LIKE pml_file.pml18,
                           pml33     LIKE pml_file.pml33,
                           pml34     LIKE pml_file.pml34,
                           pml35     LIKE pml_file.pml35,  #No.TQC-6640132
                           pml15     LIKE pml_file.pml15,
                           pml14     LIKE pml_file.pml14,
                           pml041    LIKE pml_file.pml041,
                           pml41     LIKE pml_file.pml41,
                           pml80     LIKE pml_file.pml80,
                           pml82     LIKE pml_file.pml82,
                           pml83     LIKE pml_file.pml83,
                           pml85     LIKE pml_file.pml85,
                           pml86     LIKE pml_file.pml86
                        END RECORD
DEFINE  sr1          RECORD
                     pmm04     LIKE pmm_file.pmm04,
                     pmm01     LIKE pmm_file.pmm01,
                     pmn02     LIKE pmn_file.pmn02,             #No.TQC-740151
                     pmc03     LIKE pmc_file.pmc03,
                     pmn20     LIKE pmn_file.pmn20,
                     pmn07     LIKE pmn_file.pmn07,
                     pmm22     LIKE pmm_file.pmm22,
                     pmn31     LIKE pmn_file.pmn31,
                     amt       LIKE pmm_file.pmm40
                     END RECORD
   DEFINE a                LIKE aba_file.aba00          	#No.FUN-680136 VARCHAR(5)
   DEFINE x1         ARRAY[10] OF LIKE type_file.chr10   	#No.FUN-680136 VARCHAR(10)#No.TQC-6A0079
   DEFINE x2         ARRAY[10] OF LIKE type_file.num20_6        #No.FUN-680136 DECIMAL(20,6)
   DEFINE x3         ARRAY[10] OF LIKE type_file.chr3     	#No.FUN-680136 VARCHAR(3)
   DEFINE x4         ARRAY[10] OF LIKE type_file.num20_6        #No.FUN-680136 DECIMAL(20,6)
   DEFINE l_azi03    ARRAY[10] OF LIKE type_file.num5   	#No.FUN-680136 SMALLINT
   DEFINE l_str1           LIKE type_file.chr1000              #No.TQC-610127
   DEFINE l_str2           LIKE type_file.chr1000              #No.TQC-610127
   DEFINE l_ima906         LIKE ima_file.ima906                 #No.TQC-610127
   DEFINE l_ima021         LIKE ima_file.ima021                 #MOD-640056
DEFINE  l_pml20      LIKE pml_file.pml20,
        l_pml85      LIKE pml_file.pml85,
        l_pml82      LIKE pml_file.pml82,
        l_pmo06      LIKE pmo_file.pmo06,
        l_pme031     LIKE pme_file.pme031,
        l_pme032     LIKE pme_file.pme032,
        l_flag       LIKE type_file.chr1,       #No.FUN-680136 VARCHAR(1)
        l_totamt     LIKE tlf_file.tlf18 	#No.FUN-680136 DECIMAL(13,3)
DEFINE  l_pmk21      LIKE pmk_file.pmk21       
DEFINE  l_pmh01      LIKE pmh_file.pmh01       
DEFINE  l_pmo05      LIKE pmo_file.pmo05        #CHI-7A0026 add
DEFINE  l_pmk09      LIKE pmk_file.pmk09        #MOD-860194
DEFINE l_img_blob     LIKE type_file.blob
#TQC-C10039--mark--str--
#DEFINE l_ii           INTEGER
#DEFINE l_key          RECORD                  #主鍵
#          v1          LIKE pmk_file.pmk01
#          END RECORD
#TQC-C10039--mark--end--
   LOCATE l_img_blob IN MEMORY   #blob初始化   #TQC-C10039 
   CALL cl_del_data(l_table) 
   CALL cl_del_data(l_table1) 
   CALL cl_del_data(l_table2)   #FUN-740214 add 
   LOCATE l_img_blob IN MEMORY  #FUN-A50041
   
   #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-A50009 mod
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?) "  #No.TQC-740151 add ?  #FUN-910012 加3個 #TQC-C10039 ADD 1?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
      EXIT PROGRAM
   END IF
   #LET g_sql = "INSERT INTO ds_report.",l_table1 CLIPPED,
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,  #TQC-A50009 mod
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?)"   #MOD-860194
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep1:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
      EXIT PROGRAM
   END IF
   #LET g_sql = "INSERT INTO ds_report.",l_table2 CLIPPED,
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,  #TQC-A50009 mod
               " VALUES(?,?,?,?,?)"        #CHI-7A0026 mod
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep2:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
      EXIT PROGRAM
   END IF
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file   #No.TQC-610127 add
   SELECT * INTO g_zo.* FROM zo_file WHERE zo01= g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'apmr903'
 
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmkuser', 'pmkgrup')
 
   LET l_sql = "SELECT pmk01,'',pmk04,pmk13,gem02,pmc081,",
               "       pmc091,pma02,pmk41,pnz02,pme031,pme032,pmk11,gec02,", #FUN-930113
               "       pmk22,pml02,pml04,pml07,pml20,pml18,pml33,pml34,pml35,",  #No.TQC-640132
               "       pml15,pml14,pml041,pml41",   
               "       ,pml80,pml82,pml83,pml85,pml86,pmk21",    #No.TQC-610127 add  #No.FUN-710082
        " FROM pmk_file LEFT OUTER JOIN pml_file ON pmk01 = pml01 ",
	" LEFT OUTER JOIN pmc_file ON pmc01 = pmk09 ",
	" LEFT OUTER JOIN pme_file ON pme01 = pmk10 ",
	" LEFT OUTER JOIN pma_file ON pma01 = pmk20 ",
	" LEFT OUTER JOIN gec_file ON gec01 = pmk21 AND gec011='1' ",
	" LEFT OUTER JOIN gem_file ON gem01 = pmk13 ",
	" LEFT OUTER JOIN oah_file ON oah01 = pmk41 ",
        " LEFT OUTER JOIN pnz_file ON pnz01 = pmk41 ",                          #TQC-9A0187 Add
	" WHERE pmkacti='Y' AND ",tm.wc
   LET l_sql = l_sql CLIPPED," ORDER BY pmk01,pml02"   #No.FUN-710082  
   display "l_sql:",l_sql CLIPPED
 
   PREPARE r903_prepare FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) RETURN
   END IF
   DECLARE r903_cs CURSOR FOR r903_prepare
      
##TQC-C10039--mark--str--      
#  #單據key值
#  LET l_sql = "SELECT pmk01",
#       " FROM pmk_file LEFT OUTER JOIN pml_file ON pmk01 = pml01 ",
#       " LEFT OUTER JOIN pmc_file ON pmc01 = pmk09 ",
#       " LEFT OUTER JOIN pme_file ON pme01 = pmk10 ",
#       " LEFT OUTER JOIN pma_file ON pma01 = pmk20 ",
#       " LEFT OUTER JOIN gec_file ON gec01 = pmk21 AND gec011='1' ",
#       " LEFT OUTER JOIN gem_file ON gem01 = pmk13 ",
#       " LEFT OUTER JOIN oah_file ON oah01 = pmk41 ",
#       " LEFT OUTER JOIN pnz_file ON pnz01 = pmk41 ",                          #TQC-9A0187 Add
#       " WHERE pmkacti='Y' AND ",tm.wc
#  LET l_sql = l_sql CLIPPED," GROUP BY pmk01"
#
#  PREPARE r903_pr3 FROM l_sql
#  IF SQLCA.sqlcode THEN
#     CALL cl_err('prepare r903_pr3:',SQLCA.sqlcode,0)
#     CALL cl_used(g_prog,g_time,2) RETURNING g_time
#     EXIT PROGRAM
#  END IF
#  DECLARE r903_cs3 CURSOR FOR r903_pr3
 ##TQC-C10039--mark--end
   FOREACH r903_cs INTO sr.*,l_pmk21
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
 
      LET l_smyslip = s_get_doc_no(sr.pmk01)     #No.FUN-550060
      SELECT smydesc INTO sr.smydesc FROM smy_file
       WHERE smyslip=l_smyslip
 
      SELECT pme031,pme032 INTO l_pme031,l_pme032 FROM pme_file
                                                 WHERE pme01=sr.pmk11
      IF SQLCA.SQLCODE THEN LET l_pme031='' LET l_pme032='' END IF
 
     #特別說明維護(項次前)
      LET l_pmo05=''
      LET l_pmo06=''
      DECLARE pmo_cur2 CURSOR FOR
         SELECT pmo05,pmo06 FROM pmo_file
          WHERE pmo01=sr.pmk01 AND pmo03=sr.pml02 AND pmo04='0'
          ORDER BY pmo05
      FOREACH pmo_cur2 INTO l_pmo05,l_pmo06
         EXECUTE insert_prep2 USING sr.pmk01,sr.pml02,'0',l_pmo05,l_pmo06
      END FOREACH
 
     #特別說明維護(項次後)
      LET l_pmo05=''
      LET l_pmo06=''
      DECLARE pmo_cur3 CURSOR FOR
       SELECT pmo05,pmo06 FROM pmo_file
        WHERE pmo01=sr.pmk01 AND pmo03=sr.pml02 AND pmo04='1'
        ORDER BY pmo05
      FOREACH pmo_cur3 INTO l_pmo05,l_pmo06
         EXECUTE insert_prep2 USING sr.pmk01,sr.pml02,'1',l_pmo05,l_pmo06
      END FOREACH
 
      SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=sr.pml04
      LET l_str2 = ""
      LET l_str1 = ""
 
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
               CALL cl_remove_zero(sr.pml85) RETURNING l_pml85
               LET l_str1 = l_pml85
               LET l_str2 = l_str1 CLIPPED,sr.pml83 CLIPPED
               IF cl_null(sr.pml85) OR sr.pml85 = 0 THEN
                  CALL cl_remove_zero(sr.pml82) RETURNING l_pml82
                  LET l_str1 = l_pml82
                  LET l_str2 = l_str1 CLIPPED, sr.pml80 CLIPPED
               ELSE
                  IF NOT cl_null(sr.pml82) AND sr.pml82 > 0 THEN
                     CALL cl_remove_zero(sr.pml82) RETURNING l_pml82
                     LET l_str1 = l_pml82
                     LET l_str2 = l_str2 CLIPPED,',',l_str1 CLIPPED,
                                  sr.pml80 CLIPPED
                  END IF
               END IF
            WHEN "3"
               IF NOT cl_null(sr.pml85) AND sr.pml85 > 0 THEN
                  CALL cl_remove_zero(sr.pml85) RETURNING l_pml85
                  LET l_str1 = l_pml85
                  LET l_str2 = l_str1 CLIPPED,sr.pml83 CLIPPED
               END IF
         END CASE
      END IF
      IF g_sma.sma116 MATCHES '[13]' THEN  #TQC-6B0137 mod
         IF sr.pml07 <> sr.pml86 THEN      #TQC-6B0137 mod
            CALL cl_remove_zero(sr.pml20) RETURNING l_pml20
            LET l_str1 = l_pml20
            LET l_str2 = l_str2 CLIPPED,"(",l_str1 CLIPPED,
                         sr.pml07 CLIPPED,")"
         END IF
      END IF
 
      LET l_ima021 = ""                                              #MOD-640056
      SELECT ima021 INTO l_ima021 FROM ima_file where ima01=sr.pml04 #MOD-640056 
 
      LET l_pmk09 = ''    #MOD-860194
      SELECT pmk09 INTO l_pmk09 FROM pmk_file WHERE pmk01 = sr.pmk01   #MOD-860194
 
      DECLARE pmh_cur CURSOR FOR
         #SELECT pmh01,pmc03,pmh12,pmh13,pmh12*pmh14 as aaa FROM pmh_file, pmc_file #MOD-580143 add pmh12*pmh14 as aaa     #FUN-A40073 mark
         SELECT pmh01,pmc03,pmh12,pmh13,pmh12*pmh14 as aaa FROM pmh_file LEFT OUTER JOIN pmc_file ON pmh02=pmc_file.pmc01  #FUN-A40073 mod 
          WHERE pmh01 = sr.pml04     # AND pmh02=pmc_file.pmc01  #FUN-A40073 mark
            AND pmh02 = l_pmk09   #MOD-860194
            AND pmh21 = " "                                             #CHI-860042                                                 
            AND pmh22 = '1'                                             #CHI-860042
            AND pmh23 = ' '                                             #No.CHI-960033
            AND pmhacti = 'Y'                                           #CHI-910021
          ORDER BY pmh05 ASC,pmh06 DESC,aaa ASC #MOD-580143
      FOR g_cnt=1 TO 10
         LET x1[g_cnt]='' 
         LET x2[g_cnt]='' 
         LET x3[g_cnt]=''
         LET x4[g_cnt]=NULL #MOD-580143
      END FOR
      LET g_cnt=1
      LET i=1
      FOREACH pmh_cur INTO l_pmh01,x1[g_cnt],x2[g_cnt],x3[g_cnt],x4[g_cnt] #MOD-580143 add x4[g_cnt]
         IF STATUS THEN EXIT FOREACH END IF
         SELECT azi03 INTO l_azi03[1]
           FROM azi_file WHERE azi01=x3[1]
         SELECT azi03 INTO l_azi03[2]
           FROM azi_file WHERE azi01=x3[2]
         SELECT azi03 INTO l_azi03[3]
           FROM azi_file WHERE azi01=x3[3]
         SELECT azi03 INTO l_azi03[4]
           FROM azi_file WHERE azi01=x3[4]
         EXECUTE insert_prep1 USING 
            sr.pml02,l_pmh01,   #MOD-860194
            x1[1],x1[2],x1[3],x1[4],
            x2[1],x2[2],x2[3],x2[4],
            x3[1],x3[2],x3[3],x3[4],
            l_azi03[1],l_azi03[2],l_azi03[3],l_azi03[4],
            i
         LET g_cnt=g_cnt+1 IF g_cnt > 4 THEN EXIT FOREACH END IF
         LET i=i+1
         LET l_pmh01=''
      END FOREACH
 
      DECLARE pmn_cur CURSOR FOR
#        SELECT pmm04,pmm01,pmn02,pmc03,pmn20,pmn07,pmm22,pmn31,pmn20*pmn31  #No.TQC-740151 add pmn02   #CHI-B70039 mark
         SELECT pmm04,pmm01,pmn02,pmc03,pmn20,pmn07,pmm22,pmn31,pmn87*pmn31  #CHI-B70039
           #FROM pmm_file, pmn_file, pmc_file
           FROM pmn_file, pmm_file LEFT OUTER JOIN pmc_file ON pmm09=pmc_file.pmc01   #FUN-A40073 mod 
          WHERE pmn04 = sr.pml04 AND pmn01=pmm01 #AND pmm09=pmc_file.pmc01   #FUN-A40073 mod 
                AND pmm18 <> 'X'
          ORDER BY pmm04 DESC
      LET g_cnt1=0
      LET l_flag=0
      LET sr1.pmm04 = ''   #No.TQC-740151
      SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05    #No.CHI-6A0004
        FROM azi_file WHERE azi01=sr1.pmm22
 
      FOREACH pmn_cur INTO sr1.*
         IF STATUS THEN CALL cl_err('pmn_cur',STATUS,1) EXIT FOREACH END IF
         LET g_cnt1=g_cnt1+1 IF g_cnt1 > tm.c THEN EXIT FOREACH END IF #No.TQC-740151
 
         EXECUTE insert_prep USING 
            sr.*,l_str2,sr1.*,
            g_zo.zo041,g_zo.zo042,g_zo.zo05,g_zo.zo09,
            l_pmk21,l_pme031,l_pme032,l_ima021,t_azi03,t_azi04,
            "",l_img_blob,"N",""      #FUN-910012 #TQC-c10039 add ""
            
         LET l_flag = 1            #No.TQC-740151
         LET sr1.pmm04=''
         LET sr1.pmm01=''
         LET sr1.pmn02=''          #No.TQC-740151
         LET sr1.pmc03=''
         LET sr1.pmn20=''
         LET sr1.pmn07=''
         LET sr1.pmn31=''
         LET sr1.amt=''         
      END FOREACH
      IF l_flag=0 THEN
         INITIALIZE sr1.* TO NULL
      END IF
      IF l_flag=0 AND cl_null(sr1.pmm04) THEN
         EXECUTE insert_prep USING sr.*,l_str2,sr1.*,
                                   g_zo.zo041,g_zo.zo042,g_zo.zo05,g_zo.zo09,
                                   l_pmk21,l_pme031,l_pme032,l_ima021,t_azi03,t_azi04,
                                   "",l_img_blob,"N",""      #FUN-910012   #TQC-c10039 add ""
         LET l_flag=1
      END IF
   END FOREACH
 
   #處理單據前、後特別說明
   LET l_sql = "SELECT pmk01 FROM pmk_file ",
               " WHERE ",tm.wc CLIPPED,
               "   ORDER BY pmk01"
   PREPARE r903_prepare2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare2:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   DECLARE r903_cs2 CURSOR FOR r903_prepare2
 
   FOREACH r903_cs2 INTO sr.pmk01
 
     #額外備註-單據前備註 
      DECLARE pmo_cur CURSOR FOR
         SELECT pmo05,pmo06 FROM pmo_file
          WHERE pmo01=sr.pmk01 AND pmo03=0 AND pmo04='0'
          ORDER BY pmo05
      FOREACH pmo_cur INTO l_pmo05,l_pmo06
         EXECUTE insert_prep2 USING sr.pmk01,'0','0',l_pmo05,l_pmo06
      END FOREACH
 
     #額外備註-單據後備註 
      DECLARE pmo_cur4 CURSOR FOR
       SELECT pmo05,pmo06 FROM pmo_file
        WHERE pmo01=sr.pmk01 AND pmo03=0 AND pmo04='1'
          ORDER BY pmo05
      FOREACH pmo_cur4 INTO l_pmo05,l_pmo06
         EXECUTE insert_prep2 USING sr.pmk01,'0','1',l_pmo05,l_pmo06
      END FOREACH
   END FOREACH
 
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED ,"|", 
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                 " WHERE pmo03=0 AND pmo04='0' ","|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                 " WHERE pmo03!=0 AND pmo04='0' ","|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                 " WHERE pmo03!=0 AND pmo04='1' ","|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                 " WHERE pmo03=0 AND pmo04='1' "
 
   IF g_zz05 = 'Y' THEN                                                         
      CALL cl_wcchp(tm.wc,'pmk01,pmk04,pmk12,pmk13')  
      RETURNING tm.wc                                                           
   ELSE
      LET tm.wc = ''
   END IF                      
   LET l_str = tm.wc CLIPPED,";",g_zz05 CLIPPED,";",tm.a CLIPPED,";",
               tm.b CLIPPED,";",tm.c CLIPPED
#TQC-C10039--mod--str-- 
   LET g_cr_table = l_table                 #主報表的temp table名稱
#  LET g_cr_gcx01 = "asmi300"               #單別維護程式
   LET g_cr_apr_key_f = "pmk01"       #報表主鍵欄位名稱，用"|"隔開 
#  LET l_ii = 1
   #報表主鍵值
#  CALL g_cr_apr_key.clear()                #清空
# FOREACH r903_cs3 INTO l_key.*            
#     LET g_cr_apr_key[l_ii].v1 = l_key.v1
#     LET l_ii = l_ii + 1
#   END FOREACH
#TQC-C10039--mod--end--
   CALL cl_prt_cs3('apmr903','apmr903',l_sql,l_str) 
END FUNCTION
#No:FUN-9C0071--------精簡程式-----
