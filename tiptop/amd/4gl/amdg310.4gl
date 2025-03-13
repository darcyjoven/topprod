# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: amdg310.4gl
# Descriptions...: 電子計算機統一發票明細列印作業(二聯式)
# Date & Author..: 96/07/02 By Lynn
# Modify.........: No:7699 03/07/18 By Wiky add " AND oom04 <> 'X' "
# Modify.........: No:8277 03/11/04 Kitty g_i未歸0,x1,x2,x3在ORA版也要用char
# Modify.........: No:9024 04/01/09 Kammy line 345 改成
#                                          AND (amd171!='33' OR amd171 IS NULL)
# Modify.........: No.MOD-4B0115 04/11/17 By Nicola report段的合計變數需適時清為0
# Modify.........: No.FUN-550114 05/05/31 By echo 新增報表備註
# Modify.........: No.FUN-560198 05/06/22 By ice 發票欄位加大后截位修改
# Modify.........: No.MOD-580331 05/08/28 By ice 修改報表打印格式
# Modify.........: No.MOD-590097 05/09/09 By yoyo 報表修改
# Modify.........: No.MOD-590298 05/09/13 By wujie報表修改
# Modify.........: No.TQC-5B0201 05/12/13 BY yiting 年月輸入模式統一為：年/起始月份-截止月份
# Modify.........: No.FUN-5C0042 05/12/22 By Sarah 本月總計顯示數字應為一整個月的總計,而非每一頁次的累計
# Modify.........: No.MOD-610086 06/01/16 By Smapmin 列印條件修正
# Modify.........: No.TQC-610057 06/01/20 By Kevin 修改外部參數接收
# Modify.........: No.MOD-640010 06/04/04 By Smapmin 序號有誤
# Modify.........: No.TQC-690062 06/09/14 By Claire unicode格線無法印出
# Modify.........: No.FUN-690128 06/09/28 By Smapmin 稅籍部門增加開窗功能
# Modify.........: No.FUN-680074 06/08/24 By huchenghao 類型轉換
# Modify.........: No.MOD-690154 06/10/02 By Smapmin 修改列印00~49或50~99的條件判斷
# Modify.........: No.FUN-690077 06/10/11 By Sarah 複製amdr311改成amdg310,PRINT段遇到l時增加CLIPPED
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-6A0068 06/10/26 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.MOD-6A0175 06/11/10 By Smapmin 放大發票總金額,銷售額,稅額等欄位
# Modify.........: No.MOD-740025 07/04/10 By Smapmin 加入申報部門條件
# Modify.........: No.CHI-750026 07/05/23 By Smapmin 處理資料重複列印問題
# Modify.........: No.TQC-810004 08/01/07 BY ve 報表輸出改為CR 
# Modify.........: No.FUN-860041 08/06/11 By Carol 民國年欄位放大為3位
# Modify.........: No.MOD-870262 08/07/24 By Sarah CR Temptable裡的欄位與XML裡的欄位不一致,導致報表出時表有些欄位印不出來
# Modify.........: No.MOD-870303 08/07/29 By chenl 調整年度位數。
# Modify.........: No.MOD-890030 08/09/03 By Sarah 資料有多頁時會殘留前頁資料
# Modify.........: No.MOD-890057 08/09/11 By Sarah g_pageno計算第幾頁計算有誤
# Modify.........: No.MOD-8B0035 08/11/07 By Sarah 報表資料有誤
# Modify.........: No.MOD-8B0038 08/11/07 By Sarah 表尾發票總金額,銷售額,稅額應以SUM(amd06),SUM(amd08),SUM(amd07)來計算
# Modify.........: No.TQC-8B0014 08/11/07 By Sarah 第幾頁計算有誤
# Modify.........: No.MOD-920139 09/02/11 By Sarah 當amd172='1'時才要加總到l_amt4
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-990024 09/12/17 By chenmoyan 修改抓取oom_file时的条件
# Modify.........: No.TQC-9C0179 09/12/29 By tsai_yen EXECUTE裡不可有擷取字串的中括號[]
# Modify.........: No.FUN-9C0073 10/01/14 By chenls 程序精簡
# Modify.........: No:FUN-A10039 10/01/20 By jan 程式段中用到amd172 = 'D'或amd172 <> 'D'皆改為amd172 = 'F'或amd172 <> 'F'
# Modify.........: No.TQC-A40101 10/04/21 By Carrier SQL条件错误
# Modify.........: No:MOD-A90099 10/09/15 By Dido 空白發票增加 amd172 = 'D' 判斷 
# Modify.........: No:CHI-AA0014 10/11/04 By Summer 計算銷售額與稅額用倒推的方式算
# Modify.........: No:MOD-B50086 11/05/11 By Dido 增加過濾申報部門
# Modify.........: No.FUN-B40092 11/05/19 By xujing GR轉GRW 
# Modify.........: No.FUN-B80050 11/08/03 By minpp 程序撰写规范修改
# Modify.........: No.FUN-B40092 11/08/17 By xujing 程式規範修改
# Modify.........: No.MOD-BC0008 11/12/21 By yangtt 套表更新處理
# Modify.........: No.FUN-C10036 12/01/11 By lujh  FUN-B80050,FUN-BB0047 追單
# Modify.........: No.FUN-C50008 12/05/09 By wangrr GR程式優化
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm        RECORD
                  yy         LIKE type_file.num10,      #No.FUN-680074 INTEGER #年度
                  bm         LIKE type_file.num10,      #No.FUN-680074 INTEGER #月份
                  em         LIKE type_file.num10,      #No.FUN-680074 INTEGER #月份
                  date       LIKE type_file.dat,        #No.FUN-680074 DATE    #申請日期
                  ama01      LIKE ama_file.ama01,
                  more       LIKE type_file.chr1        #No.FUN-680074 VARCHAR(1)
                 END RECORD,
       g_wc                  STRING,                   #No.FUN-680074 #No.FUN-580092 HCN
       l_totamt1,l_totamt2   LIKE type_file.num20_6,   #No.FUN-680074 DECIMAL(20,6)  #No:8277
       l_totamt3,l_tottax    LIKE type_file.num20_6,   #No.FUN-680074 DECIMAL(20,6)  #No:8277
       l_totamt4             LIKE type_file.num20_6,   #No.FUN-680074 DECIMAL(20,6)  #FUN-690077 add
       l_total1,l_total2     LIKE type_file.num10,     #No.FUN-680074 INTEGER
       l_total3,l_total4     LIKE type_file.num10,     #No.FUN-680074 INTEGER
       l_total5              LIKE type_file.num10,     #No.FUN-680074 INTEGER
       g_ama     RECORD LIKE ama_file.*
DEFINE g_i                   LIKE type_file.num5       #No.FUN-680074 SMALLINT #count/index for any purpose
DEFINE g_format              LIKE oom_file.oom08       #No.FUN-680074 VARCHAR(16) #No.FUN-560198
DEFINE g_sql                 STRING                    #No.TQC-810004--add                                                          
DEFINE l_table               STRING                    #No.TQC-810004--add                                                          
DEFINE l_table1              STRING                    #No.TQC-810004--add                                                          
DEFINE g_str                 STRING                    #No.TQC-810004--add
 
###GENGRE###START
TYPE sr1_t RECORD
    ama02 LIKE ama_file.ama02,
    ama03 LIKE ama_file.ama03,
    ama07 LIKE ama_file.ama07,
    oom07 LIKE oom_file.oom07,
    oom07_1 LIKE oom_file.oom07,
    oom08 LIKE oom_file.oom08,
    oom11 LIKE oom_file.oom11,
    oom12 LIKE oom_file.oom12,
    amt1 LIKE type_file.num20_6,
    amt2 LIKE type_file.num20_6,
    amt3 LIKE type_file.num20_6,
    amt4 LIKE type_file.num20_6,
    tax LIKE type_file.num20_6,
    g_i LIKE type_file.num5,
    azi04 LIKE azi_file.azi04,
    azi05 LIKE azi_file.azi05,
    tot1 LIKE type_file.num20_6,
    tot2 LIKE type_file.num20_6,
    tot3 LIKE type_file.num20_6,
    tot4 LIKE type_file.num20_6,
    tot5 LIKE type_file.num20_6,
    totamt1 LIKE type_file.num20_6,
    totamt2 LIKE type_file.num20_6,
    totamt3 LIKE type_file.num20_6,
    totamt4 LIKE type_file.num20_6,
    tottax LIKE type_file.num20_6,
    g_pageno LIKE type_file.num10,
    total1 LIKE type_file.num20_6,
    total2 LIKE type_file.num20_6,
    total3 LIKE type_file.num20_6,
    total4 LIKE type_file.num20_6,
    total5 LIKE type_file.num20_6
END RECORD

TYPE sr2_t RECORD
    l_n1 LIKE type_file.num5,
    l_n2 LIKE type_file.num5,
#   amd03 LIKE amd_file.amd03,          #MOD-BC0008 mark
#   amd03_1 LIKE amd_file.amd03,        #MOD-BC0008 mark
#   amd04 LIKE amd_file.amd04,          #MOD-BC0008 mark
#   amd04_1 LIKE amd_file.amd04,        #MOD-BC0008 mark
    amd06   LIKE amd_file.amd06,        #FUN-B40092  add
    amd06_1 LIKE amd_file.amd06,        #FUN-B40092  add
#   amd08 LIKE amd_file.amd08,          #MOD-BC0008 mark
#   amd08_1 LIKE amd_file.amd08,        #MOD-BC0008 mark
#   amd07 LIKE amd_file.amd07,          #MOD-BC0008 mark
#   amd07_1 LIKE amd_file.amd07,        #MOD-BC0008 mark
    memo1 LIKE type_file.chr50,
    memo2 LIKE type_file.chr50,
    x1 LIKE type_file.chr1,
    x2 LIKE type_file.chr1,
    x3 LIKE type_file.chr1,
    y1 LIKE type_file.chr1,
    y2 LIKE type_file.chr1,
    y3 LIKE type_file.chr1,
    ama02 LIKE ama_file.ama02,
    l_i LIKE type_file.num5
END RECORD
###GENGRE###END

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMD")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-B80050    ADD   #FUN-C10036  mark
 
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.yy    = ARG_VAL(7)
   LET tm.bm    = ARG_VAL(8)
   LET tm.em    = ARG_VAL(9)
   LET tm.date  = ARG_VAL(10)
   LET tm.ama01 = ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
 
   LET g_sql = "ama02.ama_file.ama02,     ama03.ama_file.ama03,",
      "ama07.ama_file.ama07,     oom07.oom_file.oom07,",
      "oom07_1.oom_file.oom07,   oom08.oom_file.oom08,",
      "oom11.oom_file.oom11,     oom12.oom_file.oom12,",
      "amt1.type_file.num20_6,   amt2.type_file.num20_6,",     #MOD-870262 mod
      "amt3.type_file.num20_6,   amt4.type_file.num20_6,",     #MOD-870262 mod
      "tax.type_file.num20_6,    g_i.type_file.num5,",         #MOD-870262 mod
      "azi04.azi_file.azi04,     azi05.azi_file.azi05,",
      "tot1.type_file.num20_6,   tot2.type_file.num20_6,",
      "tot3.type_file.num20_6,   tot4.type_file.num20_6,",
      "tot5.type_file.num20_6,",
      "totamt1.type_file.num20_6,totamt2.type_file.num20_6,",  #MOD-870262 add
      "totamt3.type_file.num20_6,totamt4.type_file.num20_6,",  #MOD-870262 add
      "tottax.type_file.num20_6, g_pageno.type_file.num10,",   #MOD-870262 mod
      "total1.type_file.num20_6, total2.type_file.num20_6,",
      "total3.type_file.num20_6, total4.type_file.num20_6,",
      "total5.type_file.num20_6"
   LET l_table = cl_prt_temptable('amdg310',g_sql) CLIPPED                                                                          
   IF l_table=-1 THEN 
      #CALL cl_used(g_prog, g_time,2) RETURNING g_time #FUN-B40092     #FUN-C10036  mark
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1) #FUN-B40092  #FUN-C10036  mark
      EXIT PROGRAM 
   END IF                                                                                           
                                                                                                                                    
   LET g_sql =
      "l_n1.type_file.num5,  l_n2.type_file.num5,",
      "amd06.amd_file.amd06, amd06_1.amd_file.amd06,",
      "memo1.type_file.chr50,memo2.type_file.chr50,",
      "x1.type_file.chr1,    x2.type_file.chr1,",
      "x3.type_file.chr1,    y1.type_file.chr1,",
      "y2.type_file.chr1,    y3.type_file.chr1,",
      "ama02.ama_file.ama02, l_i.type_file.num5"
   LET l_table1 = cl_prt_temptable('amdg3101',g_sql) CLIPPED 
   IF l_table1=-1 THEN 
      #CALL cl_used(g_prog, g_time,2) RETURNING g_time #FUN-B40092      #FUN-C10036  mark
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1) #FUN-B40092   #FUN-C10036  mark
      EXIT PROGRAM  
   END IF                                                                                          
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-C10036 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL g310_tm(0,0)
      ELSE CALL g310()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80050    ADD
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1) #FUN-B40092 
END MAIN
 
FUNCTION g310_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680074 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680074 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 6 LET p_col = 25
   ELSE
      LET p_row = 4 LET p_col = 12
   END IF
 
   OPEN WINDOW g310_w AT p_row,p_col WITH FORM "amd/42f/amdg310"
        ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET tm.yy   = YEAR(g_today)
   LET tm.bm   = MONTH(g_today)
   LET tm.em   = MONTH(g_today)
   LET tm.date = g_today
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= '1'
 
   WHILE TRUE
      INPUT BY NAME tm.date,
                    tm.ama01,tm.yy,tm.bm,tm.em,tm.more WITHOUT DEFAULTS
         ON ACTION locale
            LET g_action_choice = "locale"
            EXIT INPUT
 
         AFTER FIELD yy
            IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
 
         AFTER FIELD bm
            IF cl_null(tm.bm) THEN NEXT FIELD bm END IF
            IF tm.bm > 12 OR tm.bm < 1 THEN NEXT FIELD bm END IF
 
         AFTER FIELD em
            IF cl_null(tm.em) THEN NEXT FIELD em END IF
            IF tm.em > 12 OR tm.em < 1 THEN NEXT FIELD em END IF
 
         AFTER FIELD date
            IF cl_null(tm.date) THEN NEXT FIELD date END IF
 
         AFTER FIELD ama01
            IF cl_null(tm.ama01) THEN
               NEXT FIELD ama01
            ELSE
               SELECT * INTO g_ama.* FROM ama_file WHERE ama01 = tm.ama01
                                                     AND amaacti = 'Y'
               IF SQLCA.sqlcode THEN
                  CALL cl_err(tm.ama01,'amd-002',0)
                  NEXT FIELD ama01
               END IF
               LET tm.yy = g_ama.ama08
               LET tm.bm = g_ama.ama09 + 1
               IF tm.bm > 12 THEN
                   LET tm.yy = tm.yy + 1
                   LET tm.bm = tm.bm - 12
               END IF
               LET tm.em = tm.bm + g_ama.ama10 - 1
               DISPLAY tm.yy TO FORMONLY.yy
               DISPLAY tm.bm TO FORMONLY.bm
               DISPLAY tm.em TO FORMONLY.em
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
 
         ON ACTION CONTROLP
             CASE WHEN INFIELD(ama01)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_ama"
                       LET g_qryparam.default1 = tm.ama01
                       CALL cl_create_qry() RETURNING tm.ama01
                       DISPLAY tm.ama01 TO ama01
                  OTHERWISE
                       EXIT CASE
              END CASE
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
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
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW g310_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80050    ADD
         CALL cl_gre_drop_temptable(l_table||"|"||l_table1) #FUN-B40092 
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
                WHERE zz01='amdg310'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('amdg310','9031',1)
         ELSE
            LET l_cmd = l_cmd CLIPPED,
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_rlang CLIPPED,"'",              #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.yy CLIPPED,"'",
                        " '",tm.bm CLIPPED,"'",
                        " '",tm.em CLIPPED,"'",
                        " '",tm.date CLIPPED,"'" ,
                        " '",tm.ama01 CLIPPED,"'" ,            #No.TQC-610057 
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                        " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('amdg310',g_time,l_cmd)
         END IF
         CLOSE WINDOW g310_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80050    ADD
         CALL cl_gre_drop_temptable(l_table||"|"||l_table1) #FUN-B40092
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL g310()
      ERROR ""
   END WHILE
   CLOSE WINDOW g310_w
END FUNCTION
 
FUNCTION g310()
   DEFINE l_name    LIKE type_file.chr20,   #No.FUN-680074 VARCHAR(20)   # External(Disk) file name
          l_sql     STRING,                 #No.FUN-680074 VARCHAR(1000) # RDSQL STATEMENT
          l_chr     LIKE type_file.chr1,    #No.FUN-680074 VARCHAR(1)
          l_oom07   LIKE oom_file.oom07,    # Prog. Version..: '5.30.06-13.03.12(08)   #modi by nick 960228
          m_oom07   LIKE oom_file.oom07,
          o_oom07   LIKE oom_file.oom07,    #CHI-750026
          k_oom07   LIKE type_file.num5,    #No.FUN-680074 SMALLINT
          j_oom07   LIKE oom_file.oom07,    # Prog. Version..: '5.30.06-13.03.12(08)   #modi by nick 960228
          sr        RECORD
                     oom07     LIKE oom_file.oom07,         #起始發票號碼
                     oom08     LIKE oom_file.oom08,         #截止發票號碼
                     oom11     LIKE oom_file.oom11,         #起始流水位數
                     oom12     LIKE oom_file.oom12          #截止流水位數
                    END RECORD
   DEFINE l_i       LIKE type_file.num5          #No.FUN-680074 SMALLINT   #No.FUN-560198
   DEFINE  l_amd    DYNAMIC ARRAY OF RECORD                                                                                         
                     amd03     LIKE amd_file.amd03,                                                                                  
                     amd04     LIKE amd_file.amd04,                                                                                  
                     amd06     LIKE amd_file.amd06,                                                                                  
                     amd172    LIKE amd_file.amd172,                                                                                 
                     amd08     LIKE amd_file.amd08,   #MOD-8B0038 add
                     amd07     LIKE amd_file.amd07,   #MOD-8B0038 add
                     x1        LIKE type_file.chr4,                                                                                  
                     x2        LIKE type_file.chr4,                                                                                  
                     x3        LIKE type_file.chr4                                                                                   
                    END RECORD,                                                                                                     
            sr1     RECORD                                                                                                          
                     l_n1         LIKE type_file.num5,                                                                               
                     l_n2         LIKE type_file.num5,                                                                               
                     amd06        LIKE amd_file.amd06,                                                                               
                     amd06_1      LIKE amd_file.amd06,                                                                               
                     memo1        LIKE type_file.chr50,                                                                              
                     memo2        LIKE type_file.chr50,                                                                              
                     x1           LIKE type_file.chr1,                                                                               
                     x2           LIKE type_file.chr1,                                                                               
                     x3           LIKE type_file.chr1,                                                                               
                     y1           LIKE type_file.chr1,                                                                               
                     y2           LIKE type_file.chr1,                                                                               
                     y3           LIKE type_file.chr1                                                                                
                    END RECORD
   DEFINE l_tot1,l_tot2,l_tot3   LIKE type_file.num10,                                                                              
          l_tot4,l_tot5          LIKE type_file.num10,                                                                              
          l_amt1,l_amt2,l_amt3   LIKE type_file.num20_6,                                                                            
          l_amt4                 LIKE type_file.num20_6,                                                                            
          l_tax                  LIKE type_file.num20_6,                                                                            
          l_n                    LIKE type_file.num5,                                                                               
          l_flag                 LIKE type_file.chr1,                                                                               
          l_amd03                LIKE amd_file.amd03,                                                                               
          m_oom08                LIKE oom_file.oom08                                                                                
   DEFINE l_x1,l_x2,l_x3         STRING,                                                                                            
          l_x4,l_x5,l_x6         STRING                                                                                             
   DEFINE l_oom07_1 LIKE oom_file.oom07
   DEFINE l_oom07_m LIKE oom_file.oom07
 
#   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0068  #FUN-B40092 mark                                   
 
   CALL cl_del_data(l_table)                                                                                                        
   CALL cl_del_data(l_table1)                                                                                                       
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?)"   #MOD-870262 add 4?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
     CALL cl_err('insert_prep:',status,1) 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80050    ADD
     CALL cl_gre_drop_temptable(l_table||"|"||l_table1) #FUN-B40092
     EXIT PROGRAM
   END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
     CALL cl_err('insert_prep1:',status,1) 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80050    ADD
     CALL cl_gre_drop_temptable(l_table||"|"||l_table1) #FUN-B40092
     EXIT PROGRAM
   END IF
 
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'amdg310'
 
   LET g_wc = '1=1'
   #資料權限的檢查
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('oomuser', 'oomgrup')
 
   LET l_sql ="SELECT DISTINCT oom07,oom08,oom11,oom12 ",    #MOD-740025
              "  FROM oom_file LEFT OUTER JOIN amd_file ON amd03 BETWEEN oom07 AND oom08",   #MOD-740025   #MOD-890030 add OUTER
              " WHERE oom01 =",tm.yy,
            # "   AND oom02 >",tm.bm,  #FUN-990024 mark  #No.TQC-A40101
            # "   AND oom021<",tm.em,  #FUN-990024 mark  #No.TQC-A40101
              "   AND oom02 >=",tm.bm, #FUN-990024 mark  #No.TQC-A40101
              "   AND oom021<=",tm.em, #FUN-990024 mark  #No.TQC-A40101
              "   AND oom04 = '2' ",  #FUN-690077 modify   #二聯式
              "   AND ",g_wc CLIPPED 
   IF g_aza.aza94 = 'Y' THEN
      LET l_sql = l_sql CLIPPED,
                  "   AND oom13 = '",g_ama.ama02,"' ",
                  "  ORDER BY oom07,oom08 "
   ELSE
     #LET l_sql = l_sql CLIPPED, " ORDER BY oom07,oom08 "  #MOD-B50086 mark
     #-MOD-B50086-add-
      LET l_sql = l_sql CLIPPED,               
                  "   AND amd22 = '",tm.ama01,"' ",
                  "  ORDER BY oom07,oom08 "
     #-MOD-B50086-end-
   END IF
   PREPARE oom_pr FROM l_sql
   IF SQLCA.SQLCODE THEN CALL cl_err('oom_pr',STATUS,0) END IF
   DECLARE oom_curs CURSOR FOR oom_pr

#FUN-C50008--add--str
  LET l_sql="SELECT amd03,amd04,amd06,amd172,amd08,amd07,", 
            "       '','','' ",
            "  FROM amd_file ",
            " WHERE amd03=?",
            "   AND amd22='",tm.ama01,"'",   #MOD-740025
            "   AND (amd171 ='31' OR amd171 ='32' OR amd171 ='35')"
   PREPARE amd_pr FROM l_sql
   DECLARE amd_curs CURSOR FOR amd_pr
   IF SQLCA.SQLCODE THEN CALL cl_err('amd_pr',STATUS,0) END IF 
#FUN-C50008--add--end 
   LET g_pageno = 0
   LET g_i=0            #No:8277
   LET l_oom07=''       #No:8277
   LET m_oom07=''       #No:8277
   LET j_oom07=''       #No:8277
   LET l_totamt1=0      #No:8277
   LET l_totamt2=0      #No:8277
   LET l_totamt3=0      #No:8277
   LET l_totamt4=0      #FUN-690077 add
   LET l_tottax =0      #No:8277
   LET l_total1 =0      #No:8277
   LET l_total2 =0      #No:8277
   LET l_total3 =0      #No:8277
   LET l_total4 =0      #No:8277
   LET l_total5 =0      #No:8277
 
   CALL g310_cal_tot()   #FUN-5C0042
   FOREACH oom_curs INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
         CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
         EXIT PROGRAM
      END IF
      #為了與舊寫法兼容，default初值
      IF cl_null(sr.oom11) THEN LET sr.oom11 = 3  END IF
      IF cl_null(sr.oom12) THEN LET sr.oom12 = 10 END IF
      LET l_oom07=sr.oom07[sr.oom11,sr.oom12]
      LET m_oom07=sr.oom07
      IF sr.oom07[1,8] = o_oom07[1,8] AND
         ((sr.oom07[9,10]-49<=0 AND o_oom07[9,10]-49<=0) OR
          (sr.oom07[9,10]-49>0 AND o_oom07[9,10]-49>0)) THEN
         CONTINUE FOREACH
      END IF
      WHILE TRUE
         LET k_oom07=m_oom07[sr.oom12-1,sr.oom12]    #No.FUN-560198
         IF k_oom07>=0  AND k_oom07<=49 THEN   #MOD-610086   
            CALL g310_oom11(sr.oom11,sr.oom12)
            LET j_oom07=m_oom07[sr.oom11,sr.oom12]
            LET j_oom07=(j_oom07 -k_oom07) USING g_format  #MOD-570042    #MOD-640010
            IF sr.oom11 > 1 THEN
               LET m_oom07=m_oom07[1,sr.oom11-1],j_oom07
            ELSE
               LET m_oom07=j_oom07
            END IF
         END IF
         IF k_oom07>=50 AND k_oom07<=99 THEN   #MOD-610086   
            CALL g310_oom11(sr.oom11,sr.oom12)   #MOD-610086
            LET j_oom07=m_oom07[sr.oom11,sr.oom12]
            LET j_oom07=j_oom07 + (50 -k_oom07) USING g_format #MOD-570042    
            IF sr.oom11 > 1 THEN
               LET m_oom07=m_oom07[1,sr.oom11-1],j_oom07
            ELSE
               LET m_oom07=j_oom07
            END IF
         END IF
         LET g_i=g_i+1   #CHI-750026
         LET o_oom07 = m_oom07   #CHI-750026
         IF m_oom07[sr.oom12-1,sr.oom12] <= 49 THEN    #MOD-8B0035
            LET l_flag = '1'                                                                                                        
         ELSE                                                                                                                       
            LET l_flag = '0'                                                                                                        
         END IF                                                                                                                     
                                                                                                                                    
         LET l_tot1=0  LET l_tot2=0  LET l_tot3=0  LET l_tot4=0  LET l_tot5=0                                                       
         LET l_amt1=0  LET l_amt2=0  LET l_amt3=0  LET l_amt4=0  LET l_tax=0                                                        
         LET l_i=1                                                                                                                  
         LET l_amd03=m_oom07[sr.oom11,sr.oom12]    #MOD-8B0035
         CALL g310_oom11(sr.oom11,sr.oom12)                                                                                         
         LET m_oom08=l_amd03+49 USING g_format                                                                                      
         IF sr.oom11 > 1 THEN                                                                                                        
            LET m_oom08=sr.oom07[1,sr.oom11-1],m_oom08                                                                               
         END IF                                                                                                                      
         IF cl_null(l_tot1) THEN LET l_tot1=0 END IF                                                                                 
         IF cl_null(l_tot2) THEN LET l_tot2=0 END IF                                                                                 
         IF cl_null(l_tot3) THEN LET l_tot3=0 END IF                                                                                 
         IF cl_null(l_tot4) THEN LET l_tot4=0 END IF 
         IF cl_null(l_tot5) THEN LET l_tot5=0 END IF                                                                                 
         IF cl_null(l_amt1) THEN LET l_amt1=0 END IF                                                                                 
         IF cl_null(l_amt2) THEN LET l_amt2=0 END IF                                                                                 
         IF cl_null(l_amt3) THEN LET l_amt3=0 END IF                                                                                 
         IF cl_null(l_amt4) THEN LET l_amt4=0 END IF   #FUN-690077 add                                                               
         IF cl_null(l_tax)  THEN LET l_tax=0  END IF                                                                                 
         IF cl_null(l_total1)  THEN LET l_total1=0  END IF                                                                           
         IF cl_null(l_total2)  THEN LET l_total2=0  END IF                                                                           
         IF cl_null(l_total3)  THEN LET l_total3=0  END IF                                                                           
         IF cl_null(l_total4)  THEN LET l_total4=0  END IF                                                                           
         IF cl_null(l_total5)  THEN LET l_total5=0  END IF                                                                           
         IF cl_null(l_totamt1) THEN LET l_totamt1=0 END IF                                                                           
         IF cl_null(l_totamt2) THEN LET l_totamt2=0 END IF                                                                           
         IF cl_null(l_totamt3) THEN LET l_totamt3=0 END IF                                                                           
         IF cl_null(l_totamt4) THEN LET l_totamt4=0 END IF   #FUN-690077 add                                                         
         IF cl_null(l_tottax)  THEN LET l_tottax=0  END IF                                                                           
         WHILE TRUE
         #FUN-C50008--mark--str                                                                                                                 
         #   LET l_sql="SELECT amd03,amd04,amd06,amd172,amd08,amd07,",   #MOD-8B0038 add amd08,amd07                                                                           
         #             "       '','','' ",                                                                                            
         #             "  FROM amd_file ",                                                                                            
         #             " WHERE amd03='",m_oom07,"'",                                                                                  
         #             "   AND amd22='",tm.ama01,"'",   #MOD-740025                                                                   
         #             "   AND (amd171 ='31' OR amd171 ='32' OR amd171 ='35')"                                                        
         #   PREPARE amd_pr FROM l_sql
         #   DECLARE amd_curs CURSOR FOR amd_pr                                                                                       
         #   IF SQLCA.SQLCODE THEN CALL cl_err('amd_pr',STATUS,0) END IF 
         #   OPEN amd_curs    
         #FUN-C50008--mark--end
            OPEN amd_curs USING m_oom07    #FUN-C50008 add                                                                                                       
            INITIALIZE l_amd[l_i].* TO NULL   #MOD-890030 add
            FETCH amd_curs INTO l_amd[l_i].*                                                                                         
            IF cl_null(l_amd[l_i].amd06) THEN LET l_amd[l_i].amd06=0 END IF                                                          
            IF l_amd[l_i].amd172='F' THEN      #作廢合計,總計 #FUN-A10039                                                                     
               LET l_tot4=l_tot4+1                                                                                                 
            END IF                                                                                                                 
           #IF cl_null(l_amd[l_i].amd03) THEN   #空白合計,總計                            #MOD-A90099 mark 
            IF cl_null(l_amd[l_i].amd03) OR l_amd[l_i].amd172 = 'D' THEN   #空白合計,總計 #MOD-A90099 
               LET l_tot5=l_tot5+1                                                                                                  
            END IF                                                                                                                 
            CASE                                                                                                                  
               WHEN l_amd[l_i].amd172='1'      #應稅合計,總計                                                                       
                  LET l_amd[l_i].x1='Y'      LET l_tot1=l_tot1+1                                                                     
                  LET l_amt1=l_amt1+l_amd[l_i].amd06                                                                                 
                 #LET l_amt4=l_amt4+l_amd[l_i].amd08  #MOD-8B0038 add #CHI-AA0014 mark
                 #LET l_tax=l_tax+l_amd[l_i].amd07    #MOD-8B0038 add #CHI-AA0014 mark
               WHEN l_amd[l_i].amd172='2'      #零稅率合計,總計                                                                     
                  LET l_amd[l_i].x2='Y'      LET l_tot2=l_tot2+1                                                                     
                  LET l_amt2=l_amt2+l_amd[l_i].amd06                                                                                 
               WHEN l_amd[l_i].amd172='3'      #免稅合計,總計                                                                       
                  LET l_amd[l_i].x3='Y'      LET l_tot3=l_tot3+1                                                                     
                  LET l_amt3=l_amt3+l_amd[l_i].amd06                                                                                 
            END CASE                                                                                                              
            IF l_amd[l_i].amd06=0 THEN LET l_amd[l_i].amd06=NULL END IF                                                           
            IF l_amd[l_i].amd07=0 THEN LET l_amd[l_i].amd07=NULL END IF   #MOD-8B0038 add
            IF l_amd[l_i].amd08=0 THEN LET l_amd[l_i].amd08=NULL END IF   #MOD-8B0038 add
            LET l_i=l_i+1 
            LET l_amd03=m_oom07[sr.oom11,sr.oom12]                                                                                
            LET l_amd03 = l_amd03 + 1 USING g_format                                                                              
            IF sr.oom11 > 1 THEN                                                                                                  
               LET m_oom07=sr.oom07[1,sr.oom11-1],l_amd03                                                                         
            ELSE                                                                                                                  
               LET m_oom07=l_amd03                                                                                                 
            END IF                                                                                                                
            IF m_oom07 > m_oom08 THEN EXIT WHILE END IF                                                                           
         END WHILE                                                                                                                  
         FOR l_n=1 TO 25                                                                                                       
            INITIALIZE sr1.* TO NULL                                                                                            
            IF l_flag = '1' THEN                                                                                             
               LET sr1.l_n1=l_n-1 USING '&&'                                                                                  
            ELSE                                                                                                             
               LET sr1.l_n1=l_n+49 USING '&&'                                                                                 
            END IF                                                                                                           
            IF l_amd[l_n].amd172 = 'F' THEN  #FUN-A10039                                                                                   
               LET sr1.memo1 = 'void'                                                                                           
            ELSE                                                                                                                
               LET sr1.memo1 = ''                                                                                         
            END IF     
           #IF cl_null(l_amd[l_n].amd03) THEN                             #MOD-A90099 mark 
            IF cl_null(l_amd[l_n].amd03) OR l_amd[l_n].amd172 = 'D' THEN  #MOD-A90099 
               LET sr1.memo1 = 'space'                                                                                          
            END IF                                                                                                              
            LET sr1.amd06 = l_amd[l_n].amd06                                                                                    
            LET sr1.x1 = l_amd[l_n].x1                                                                                          
            LET sr1.x2 = l_amd[l_n].x2                                                                                          
            LET sr1.x3 = l_amd[l_n].x3                                                                                          
            IF l_flag = '1' THEN                                                                                             
               LET sr1.l_n2=l_n+24 USING '&&'                                                                                
            ELSE                                                                                                             
               LET sr1.l_n2=l_n+74 USING '&&'                                                                                
            END IF                                                                                                           
            IF l_amd[l_n+25].amd172 = 'F' THEN  #FUN-A10039                                                                                  
               LET sr1.memo2 = 'void'                                                                                             
            ELSE                                                                                                                  
               LET sr1.memo2 = ''                                                                                                 
            END IF                                                                                                                
           #IF cl_null(l_amd[l_n+25].amd03) THEN                                #MOD-A90099 mark 
            IF cl_null(l_amd[l_n+25].amd03) OR l_amd[l_n+25].amd172 = 'D' THEN  #MOD-A90099 
               LET sr1.memo2 = 'space'                                                                                           
            END IF                                                                                                                
            LET sr1.amd06_1 = l_amd[l_n+25].amd06                                                                                 
            LET sr1.y1 = l_amd[l_n+25].x1 
            LET sr1.y2 = l_amd[l_n+25].x2                                                                                         
            LET sr1.y3 = l_amd[l_n+25].x3                                                                                         
            EXECUTE insert_prep1 USING sr1.*,g_ama.ama02,g_i                                                                      
         END FOR                                                                                                               
                                                                                                                                    
         IF sr.oom11 > 1 THEN
            LET m_oom07=sr.oom07[1,sr.oom11-1],l_oom07
         ELSE
            LET m_oom07=l_oom07
         END IF
         IF m_oom07 >= sr.oom08 THEN EXIT WHILE END IF
 
        #CHI-AA0014 add --start--
        LET l_amt4 = cl_digcut(l_amt1 * 100 / 105,0)
        LET l_tax = l_amt1 - l_amt4
        LET l_totamt4 = cl_digcut(l_totamt1 * 100 / 105,0)
        LET l_tottax  = l_totamt1 - l_totamt4
        #CHI-AA0014 add --end--
 
         LET g_pageno=g_pageno+1   #TQC-8B0014 add
         LET l_oom07_1 = sr.oom07[1,sr.oom11-1] 
         LET l_oom07_m = m_oom07[sr.oom11,sr.oom12-2] 
         EXECUTE insert_prep USING
            g_ama.ama02,g_ama.ama03,g_ama.ama07,
            l_oom07_1,l_oom07_m,                                     #TQC-9C0179
            sr.oom08,sr.oom11,sr.oom12,
            l_amt1,l_amt2,l_amt3,l_amt4,l_tax,g_i,g_azi04,g_azi05,
            l_tot1,l_tot2,l_tot3,l_tot4,l_tot5,
            l_totamt1,l_totamt2,l_totamt3,l_totamt4,l_tottax,g_pageno,
            l_total1,l_total2,l_total3,l_total4,l_total5
         LET l_oom07=l_oom07 + 50 USING g_format
         IF sr.oom11 > 1 THEN
            LET m_oom07=sr.oom07[1,sr.oom11-1],l_oom07
         ELSE
            LET m_oom07=l_oom07
         END IF
         IF m_oom07 >= sr.oom08 THEN EXIT WHILE END IF
      END WHILE
   END FOREACH
 
 
###GENGRE###   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," | ",                                                          
###GENGRE###               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED                                                                
 
   LET l_x1=tm.yy-1911 USING '&&&' #No.MOD-870303 add USING '&&&'
   LET l_x2=tm.bm
   LET l_x3=tm.em
   LET l_x4=YEAR(tm.date)-1911 USING '&&&' #No.MOD-870303 add USING '&&&'
   LET l_x5=MONTH(tm.date)
   LET l_x6=DAY(tm.date)
###GENGRE###   LET g_str = l_x1,";",l_x2,";",l_x3,";",g_azi05,";",l_x4,";",
###GENGRE###               l_x5,";",l_x6,";",g_azi04                                            
###GENGRE###   CALL cl_prt_cs3('amdg310','amdg310',l_sql,g_str)
    CALL amdg310_grdata()    ###GENGRE###
#   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0068 #FUN-B40092 mark
END FUNCTION
 
FUNCTION g310_oom11(p_first,p_last)
   DEFINE p_first  LIKE type_file.num5,         #No.FUN-680074 SMALLINT
          p_last   LIKE type_file.num5,         #No.FUN-680074 SMALLINT
          l_i      LIKE type_file.num5          #No.FUN-680074 SMALLINT
 
   LET g_format = NULL
   FOR l_i = p_first TO p_last
      LET g_format = '&',g_format CLIPPED
   END FOR
END FUNCTION
 
FUNCTION g310_cal_tot()
DEFINE    l_sql     STRING,                        #No.FUN-680074 VARCHAR(1000) # RDSQL STATEMENT
          l_chr     LIKE type_file.chr1,           #No.FUN-680074 VARCHAR(1)
          l_oom07   LIKE oom_file.oom07,           #No.FUN-680074 VARCHAR(8)    #modi by nick 960228
          m_oom07   LIKE oom_file.oom07,
          k_oom07   LIKE type_file.num5,           #No.FUN-680074 SMALLINT
          j_oom07   LIKE oom_file.oom07,           # Prog. Version..: '5.30.06-13.03.12(08)   #modi by nick 960228
          sr        RECORD
                     oom07     LIKE oom_file.oom07,         #起始發票號碼
                     oom08     LIKE oom_file.oom08,         #截止發票號碼
                     oom11     LIKE oom_file.oom11,
                     oom12     LIKE oom_file.oom12          #截止流水位數
                    END RECORD
 
   LET l_oom07=''
   LET m_oom07=''
   LET j_oom07=''
   LET l_totamt1=0
   LET l_totamt2=0
   LET l_totamt3=0
   LET l_tottax =0
   LET l_total1 =0
   LET l_total2 =0
   LET l_total3 =0
   LET l_total4 =0
   LET l_total5 =0
   
   FOREACH oom_curs INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80050    ADD
         CALL cl_gre_drop_temptable(l_table||"|"||l_table1) #FUN-B40092
         EXIT PROGRAM
      END IF
 
      #為了與舊寫法兼容，default初值
      IF cl_null(sr.oom11) THEN LET sr.oom11 = 3 END IF
      IF cl_null(sr.oom12) THEN LET sr.oom12 = 10 END IF
      CALL g310_oom11(sr.oom11,sr.oom12)
      LET l_oom07=sr.oom07[sr.oom11,sr.oom12]
      LET m_oom07=sr.oom07
      WHILE TRUE
         LET k_oom07=m_oom07[sr.oom12-1,sr.oom12]
         IF k_oom07>0  AND k_oom07<49 THEN
            LET j_oom07=m_oom07[sr.oom11,sr.oom12]
 
 
            LET j_oom07=j_oom07 + (1  -k_oom07) USING g_format #MOD-570042
            IF sr.oom11 > 1 THEN
               LET m_oom07=m_oom07[1,sr.oom11-1],j_oom07
            ELSE
               LET m_oom07=j_oom07
            END IF
 
         END IF
         IF k_oom07>50 AND k_oom07<99 THEN
            LET j_oom07=m_oom07[sr.oom11,sr.oom12]
 
 
            LET j_oom07=j_oom07 + (50 -k_oom07) USING g_format #MOD-570042
            IF sr.oom11 > 1 THEN
               LET m_oom07=m_oom07[1,sr.oom11-1],j_oom07
            ELSE
               LET m_oom07=j_oom07
            END IF
 
         END IF
         CALL g310_cal_tot2(m_oom07,sr.oom11,sr.oom12)
         LET l_oom07=l_oom07 + 50 USING g_format
 
         IF sr.oom11 > 1 THEN
            LET m_oom07=sr.oom07[1,sr.oom11-1],l_oom07
         ELSE
            LET m_oom07=l_oom07
         END IF
 
         IF m_oom07 >= sr.oom08 THEN EXIT WHILE END IF
      END WHILE
   END FOREACH
 
END FUNCTION
 
FUNCTION g310_cal_tot2(sr)
   DEFINE l_last_sw      LIKE type_file.chr1,     #No.FUN-680074 VARCHAR(1)
          sr             RECORD
                          oom07     LIKE oom_file.oom07,         #起始發票號碼
                          oom11     LIKE oom_file.oom11,         #起始流水位數
                          oom12     LIKE oom_file.oom12          #截止流水位數
                         END RECORD,
          l,x            LIKE type_file.chr4,     #No.FUN-680074 VARCHAR(04)
          l_x            LIKE zaa_file.zaa08,     #No.FUN-680074 VARCHAR(35) 
          l_i,l_j        LIKE type_file.num10,    #No.FUN-680074 INTEGER  #FUN-5C0042
          l_k,l_n        LIKE type_file.num5,     #No.FUN-680074 SMALLINT
          l_sql          STRING,                  #No.FUN-680074
          l_amd03        LIKE oom_file.oom07,     #No.FUN-680074 VARCHAR(8)
          m_oom07        LIKE oom_file.oom07,
          m_oom08        LIKE oom_file.oom08,
          l_tot1,l_tot2  LIKE type_file.num10,    #No.FUN-680074 INTEGER
          l_tot3,l_tot4  LIKE type_file.num10,    #No.FUN-680074 INTEGER
          l_tot5         LIKE type_file.num10,    #No.FUN-680074 INTEGER
          l_amt1,l_amt2  LIKE type_file.num20_6,  #No.FUN-680074 DECIMAL(20,6)
          l_amt3         LIKE type_file.num20_6,  #No.FUN-680074 DECIMAL(20,6)
          l_tax          LIKE type_file.num20_6,  #No.FUN-680074 DECIMAL(20,6)
          l_amd          DYNAMIC ARRAY OF RECORD
                          amd03     LIKE amd_file.amd03,
                          amd04     LIKE amd_file.amd04,
                          amd06     LIKE amd_file.amd06,
                          amd172    LIKE amd_file.amd172,
                          amd08     LIKE amd_file.amd08,     #MOD-8B0038 add
                          amd07     LIKE amd_file.amd07,     #MOD-8B0038 add
                          x1        LIKE type_file.chr4,     # Prog. Version..: '5.30.06-13.03.12(02) #No:8277 ORA版也用char
                          x2        LIKE type_file.chr4,     # Prog. Version..: '5.30.06-13.03.12(02) #No:8277 ORA版也用char
                          x3        LIKE type_file.chr4      # Prog. Version..: '5.30.06-13.03.12(02) #No:8277 ORA版也用char
                         END RECORD
   DEFINE l1_oom07       LIKE oom_file.oom07      #No.FUN-680074 VARCHAR(12) #No.MOD-580331
   DEFINE l_flag         LIKE type_file.chr1      #No.FUN-680074 VARCHAR(1)  #No.MOD-580331 0:與前一頁相同，1:不同

   FOR l_k=1 TO 50
       INITIALIZE l_amd[l_k].* TO NULL
   END FOR
   LET l_tot1=0  LET l_tot2=0  LET l_tot3=0  LET l_tot4=0  LET l_tot5=0
   LET l_amt1=0  LET l_amt2=0  LET l_amt3=0  LET l_tax=0
   LET l_i=1
 
   LET l_amd03=sr.oom07[3,10]
   LET l_amd03=sr.oom07[sr.oom11,sr.oom12]
 
   LET m_oom07=sr.oom07
   CALL g310_oom11(sr.oom11,sr.oom12)
   
   LET m_oom08=l_amd03+49 USING g_format
   
   IF sr.oom11 > 1 THEN
      LET m_oom08=sr.oom07[1,sr.oom11-1],m_oom08
   END IF
 
   IF cl_null(l_tot1) THEN LET l_tot1=0 END IF
   IF cl_null(l_tot2) THEN LET l_tot2=0 END IF
   IF cl_null(l_tot3) THEN LET l_tot3=0 END IF
   IF cl_null(l_tot4) THEN LET l_tot4=0 END IF
   IF cl_null(l_tot5) THEN LET l_tot5=0 END IF
   IF cl_null(l_amt1) THEN LET l_amt1=0 END IF
   IF cl_null(l_amt2) THEN LET l_amt2=0 END IF
   IF cl_null(l_amt3) THEN LET l_amt3=0 END IF
   IF cl_null(l_tax)  THEN LET l_tax=0  END IF
   IF cl_null(l_total1)  THEN LET l_total1=0  END IF
   IF cl_null(l_total2)  THEN LET l_total2=0  END IF
   IF cl_null(l_total3)  THEN LET l_total3=0  END IF
   IF cl_null(l_total4)  THEN LET l_total4=0  END IF
   IF cl_null(l_total5)  THEN LET l_total5=0  END IF
   IF cl_null(l_totamt1) THEN LET l_totamt1=0 END IF
   IF cl_null(l_totamt2) THEN LET l_totamt2=0 END IF
   IF cl_null(l_totamt3) THEN LET l_totamt3=0 END IF
   IF cl_null(l_tottax)  THEN LET l_tottax=0  END IF
 
#FUN-C50008--add--str
   LET l_sql="SELECT amd03,amd04,amd06,amd172,amd08,amd07,",
             "       '','','' ",
             "  FROM amd_file ",
             " WHERE amd03=?",
             "   AND amd22='",tm.ama01,"'", 
             "   AND (amd171 ='31' OR amd171 ='32' OR amd171 ='35')"
   PREPARE amd2_pr FROM l_sql
   DECLARE amd2_curs CURSOR FOR amd2_pr
   IF SQLCA.SQLCODE THEN CALL cl_err('amd2_pr',STATUS,0) END IF
#FUN-C50008--add--end

   WHILE TRUE
   #FUN-C50008--mark--str
   #   LET l_sql="SELECT amd03,amd04,amd06,amd172,amd08,amd07,",   #MOD-8B0038 add amd08,amd07
   #             "       '','','' ",
   #             "  FROM amd_file ",
   #             " WHERE amd03='",m_oom07,"'",
   #             "   AND amd22='",tm.ama01,"'",   #MOD-740025
   #             "   AND (amd171 ='31' OR amd171 ='32' OR amd171 ='35')"
   #   PREPARE amd2_pr FROM l_sql
   #   DECLARE amd2_curs CURSOR FOR amd2_pr
   #   IF SQLCA.SQLCODE THEN CALL cl_err('amd2_pr',STATUS,0) END IF
   #   OPEN amd2_curs
   #FUN-C50008--mark--end
      OPEN amd2_curs USING m_oom07  #FUN-C50008 add
      FETCH amd2_curs INTO l_amd[l_i].*
      IF cl_null(l_amd[l_i].amd06) THEN LET l_amd[l_i].amd06=0 END IF
      IF l_amd[l_i].amd172='F' THEN      #作廢合計,總計 #FUN-A10039
         LET l_tot4=l_tot4+1 LET l_total4=l_total4+1
      END IF
     #IF cl_null(l_amd[l_i].amd03) THEN   #空白合計,總計                            #MOD-A90099 mark 
      IF cl_null(l_amd[l_i].amd03) OR l_amd[l_i].amd172 = 'D' THEN   #空白合計,總計 #MOD-A90099 
         LET l_tot5=l_tot5+1 LET l_total5=l_total5+1
      END IF
      CASE WHEN l_amd[l_i].amd172='1'      #應稅合計,總計
                LET l_total1=l_total1+1
                LET l_totamt1=l_totamt1+l_amd[l_i].amd06
                LET l_totamt4=l_totamt4+l_amd[l_i].amd08   #MOD-8B0038 add
                LET l_tottax =l_tottax +l_amd[l_i].amd07   #MOD-8B0038 add
           WHEN l_amd[l_i].amd172='2'      #零稅率合計,總計
                LET l_total2=l_total2+1
                LET l_totamt2=l_totamt2+l_amd[l_i].amd06
           WHEN l_amd[l_i].amd172='3'      #免稅合計,總計
                LET l_total3=l_total3+1
                LET l_totamt3=l_totamt3+l_amd[l_i].amd06
      END CASE
      IF l_amd[l_i].amd06=0 THEN LET l_amd[l_i].amd06=NULL END IF
      IF l_amd[l_i].amd07=0 THEN LET l_amd[l_i].amd07=NULL END IF   #MOD-8B0038 add
      IF l_amd[l_i].amd08=0 THEN LET l_amd[l_i].amd08=NULL END IF   #MOD-8B0038 add
      LET l_i=l_i+1
         LET l_amd03=m_oom07[sr.oom11,sr.oom12]
 
         LET l_amd03 = l_amd03 + 1 USING g_format
 
         IF sr.oom11 > 1 THEN
            LET m_oom07=sr.oom07[1,sr.oom11-1],l_amd03
         ELSE
            LET m_oom07=l_amd03
         END IF
 
      IF m_oom07 > m_oom08 THEN EXIT WHILE END IF
   END WHILE
 
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/14

###GENGRE###START
FUNCTION amdg310_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("amdg310")
        IF handler IS NOT NULL THEN
            START REPORT amdg310_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
          
            DECLARE amdg310_datacur1 CURSOR FROM l_sql
            FOREACH amdg310_datacur1 INTO sr1.*
                OUTPUT TO REPORT amdg310_rep(sr1.*,l_cnt)
            END FOREACH
            FINISH REPORT amdg310_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT amdg310_rep(sr1,l_cnt)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_x4     STRING
    DEFINE l_x5     STRING
    DEFINE l_x6     STRING
    DEFINE l_sql    STRING                    #FUN-B40092
    DEFINE l_p1     STRING                    #FUN-B40092
    DEFINE l_p2     STRING                    #FUN-B40092
    DEFINE l_p3     STRING                    #FUN-B40092
    DEFINE l_cnt    LIKE type_file.num10
    #MOD-BC0008----add----str--------
    DEFINE l_l_n1    STRING
    DEFINE l_l_n2    STRING
    DEFINE l_memo1   STRING
    DEFINE l_memo2   STRING
    DEFINE l_x1      STRING
    DEFINE l_x2      STRING
    DEFINE l_x3      STRING
    DEFINE l_y1      STRING
    DEFINE l_y2      STRING
    DEFINE l_y3      STRING
    DEFINE l_fmt     STRING
    DEFINE l_fmt1    STRING
    #MOD-BC0008----add----end-------
    
    
    ORDER EXTERNAL BY sr1.oom07,sr1.oom08
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
            PRINTX l_cnt 
              
        BEFORE GROUP OF sr1.oom07
            LET l_lineno = 0

        
        ON EVERY ROW
            LET l_fmt = cl_gr_numfmt("type_file","num20_6",g_azi05)       #MOD-BC0008 add
            PRINTX l_fmt                                                  #MOD-BC0008 add
            LET l_fmt1 = cl_gr_numfmt("type_file","num20_6",g_azi04)       #MOD-BC0008 add
            PRINTX l_fmt1                                                  #MOD-BC0008 add
            #FUN-B40092------add------str
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                       #" WHERE oao01 = '",sr2.amd04 CLIPPED,"'" #MOD-BC0008
                        " WHERE ama02 = '",sr1.ama02 CLIPPED,"' AND l_i = ",sr1.g_i  #MOD-BC0008
            DECLARE amdg310_repcur1 CURSOR FROM l_sql
            FOREACH amdg310_repcur1 INTO sr2.*
            #  CALL amdg310_sr2(sr2.*)              #MOD-BC0008 mark
               #MOD-BC0008---add----str----------
               LET  l_l_n1 = sr2.l_n1 USING '&&'
               PRINTX l_l_n1

               LET  l_l_n2 = sr2.l_n2 USING '&&'
               PRINTX l_l_n2

               IF sr2.memo1 = "void" THEN
                  LET  l_memo1 = cl_gr_getmsg("gre-033",g_lang,0)
               ELSE
                  IF sr2.memo1 = "space" THEN
                     LET  l_memo1 = cl_gr_getmsg("gre-033",g_lang,1)
                  ELSE
                     IF sr2.memo1 = "voidspace" THEN
                        LET  l_memo1 = cl_gr_getmsg("gre-033",g_lang,2)
                     END IF
                  END IF
               END IF
               PRINTX l_memo1

               IF sr2.memo2 = "void" THEN
                  LET  l_memo2 = cl_gr_getmsg("gre-033",g_lang,0)
               ELSE
                  IF sr2.memo2 = "space" THEN
                     LET  l_memo2 = cl_gr_getmsg("gre-033",g_lang,1)
                  ELSE
                     IF sr2.memo2 = "voidspace" THEN
                        LET l_memo2 = cl_gr_getmsg("gre-033",g_lang,2)
                     END IF
                  END IF
               END IF
               PRINTX l_memo2

               IF sr2.x1 = 'Y' THEN
                  LET l_x1 = 'ˇ'
               ELSE
                  LET l_x1 = NULL
               END IF
               PRINTX l_x1

               IF sr2.x2 = 'Y' THEN
                  LET l_x2 = 'ˇ'
               ELSE
                  LET l_x2 = NULL
               END IF
               PRINTX l_x2

               IF sr2.x3 = 'Y' THEN
                  LET l_x3 = 'ˇ'
               ELSE
                  LET l_x3 = NULL
               END IF
               PRINTX l_x3

               IF sr2.y1 = 'Y' THEN
                  LET l_y1 = 'ˇ'
               ELSE
                  LET l_y1 = NULL
               END IF
               PRINTX l_y1

               IF sr2.y2 = 'Y' THEN
                  LET l_y2 = 'ˇ'
               ELSE
                  LET l_y2 = NULL
               END IF
               PRINTX l_y2

               IF sr2.y3 = 'Y' THEN
                  LET l_y3 = 'ˇ'
               ELSE
                  LET l_y3 = NULL
               END IF
               PRINTX l_y3
            #MOD-BC0008---add-----end-----------        
               PRINTX sr2.*
            END FOREACH
            LET l_x4 = YEAR(tm.date)-1911 USING '&&&'
            LET l_x5 = MONTH(tm.date)
            LET l_x6 = DAY(tm.date)

            PRINTX l_x4
            PRINTX l_x5
            PRINTX l_x6 
            LET l_p1 = tm.yy-1991 USING '&&&'
            LET l_p2 = tm.bm
            LET l_p3 = tm.em
            PRINTX l_p1
            PRINTX l_p2
            PRINTX l_p3
            #FUN-B40092------add------end

            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*


        
        ON LAST ROW

END REPORT

#MOD-BC0008----mark----str-----
#FUNCTION amdg310_sr2(sr2)
#DEFINE sr2   sr2_t
#DEFINE l_l_n1    STRING
#DEFINE l_l_n2    STRING
#DEFINE l_memo1   STRING
#DEFINE l_memo2   STRING
#DEFINE l_x1      STRING
#DEFINE l_x2      STRING
#DEFINE l_x3      STRING
#DEFINE l_y1      STRING
#DEFINE l_y2      STRING
#DEFINE l_y3      STRING

#           LET  l_l_n1 = sr2.l_n1,'00'
#           PRINTX l_l_n1

#           LET  l_l_n2 = sr2.l_n2,'00'
#           PRINTX l_l_n2

#           IF sr2.memo1 = 'void' THEN
#              LET  l_memo1 = cl_gr_getmsg("gre-033",g_lang,0)
#           ELSE
#              IF sr2.memo1 = 'space' THEN
#                 LET  l_memo1 = cl_gr_getmsg("gre-033",g_lang,1)
#              ELSE
#                 IF  sr2.memo1 = 'voidspace'THEN
#                     LET  l_memo1 = cl_gr_getmsg("gre-033",g_lang,2)
#                 END IF
#              END IF
#           END IF
#           PRINTX l_memo1

#           IF sr2.memo2 = 'void' THEN
#              LET  l_memo2 = cl_gr_getmsg("gre-033",g_lang,0)
#           ELSE
#              IF sr2.memo2 = 'space' THEN
#                 LET  l_memo2 = cl_gr_getmsg("gre-033",g_lang,1)
#              ELSE
#                 IF  sr2.memo2 = 'voidspace'THEN
#                     LET  l_memo2 = cl_gr_getmsg("gre-033",g_lang,2)
#                 END IF
#              END IF
#           END IF
#           PRINTX l_memo2
#           IF sr2.x1 = 'Y' THEN
#              LET l_x1 = 'ˇ'
#           END IF
#           PRINTX l_x1

#           IF sr2.x2 = 'Y' THEN
#              LET l_x2 = 'ˇ'
#           END IF
#           PRINTX l_x2

#           IF sr2.x3 = 'Y' THEN
#              LET l_x3 = 'ˇ'
#           END IF
#           PRINTX l_x3

#           IF sr2.y1 = 'Y' THEN
#              LET l_y1 = 'ˇ'
#           END IF
#           PRINTX l_y1

#           IF sr2.y2 = 'Y' THEN
#              LET l_y2 = 'ˇ'
#           END IF
#           PRINTX l_y2

#           IF sr2.y3 = 'Y' THEN
#              LET l_y3 = 'ˇ'
#           END IF
#           PRINTX l_y3 
#           

#END FUNCTION
#MOD-BC0008----mark----end-----
