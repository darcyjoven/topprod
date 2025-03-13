# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: amdg311.4gl
# Descriptions...: 電子計算機統一發票明細列印作業
# Date & Author..: 96/07/02 By Lynn
# Modify.........: No:7699 03/07/18 By Wiky add " AND oom04 <> 'X' "
# Modify.........: No:8277 03/11/04 Kitty g_i未歸0,x1,x2,x3在ORA版也要用char
# Modify.........: No.9024 04/01/09 Kammy line 345 改成
#                                          AND (amd171!='33' OR amd171 IS NULL)
# Modify.........: No.MOD-4B0115 04/11/17 By Nicola report段的合計變數需適時清為0
# Modify.........: No.FUN-550114 05/05/31 By echo 新增報表備註
# Modify.........: No.FUN-560198 05/06/22 By Trisy 發票欄位加大后截位修改
# Modify.........: No.MOD-580331 05/08/28 By ice 修改報表打印格式
# Modify.........: No.MOD-590097 05/09/09 By yoyo 報表修改
# Modify.........: No.MOD-590481 05/10/05 By Smapmin 報表列印位置調整
# Modify.........: NO.TQC-5B0201 05/12/13 BY yiting 年月輸入模式統一為：年/起始月份-截止月份
# Modify.........: NO.FUN-5C0042 05/12/27 By Sarah 本月總計顯示數字應為一整個月的總計,而非每一頁次的累計
# Modify.........: No.MOD-610086 06/01/16 By Smapmin 列印條件修正
# Modify.........: No.TQC-610057 06/01/20 By Kevin 修改外部參數接收
# Modify.........: No.MOD-640010 06/04/04 By Smapmin 序號有誤
# Modify.........: No.FUN-660093 06/06/15 By xumin  cl_err To cl_err3
# Modify.........: No.FUN-680074 06/08/24 By huchenghao 類型轉換
# Modify.........: No.FUN-690116 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-690077 06/10/13 By Sarah PRINT段遇到l時增加CLIPPED
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改.
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-690128 06/11/03 By Smapmin 稅籍部門增加開窗功能
# Modify.........: No.MOD-690154 06/11/03 By Smapmin 修改列印00~49或50~99的條件判斷
# Modify.........: No.MOD-740025 07/04/10 By Smapmin 加入申報部門條件
# Modify.........: No.CHI-750026 07/05/23 By Smapmin 處理資料重複列印問題
# Modify.........: No.MOD-820074 08/02/18 By Smapmin 頁次顯示有誤
# Modify.........: No.TQC-810004 08/01/27 BY destiny 報表輸出改為CR
# Modify.........: No.MOD-850084 08/05/19 By Sarah 撈資料的SQL原先過濾oom04<>'X'改為過濾oom04='3'
# Modify.........: No.FUN-860041 08/06/11 By Carol 民國年欄位放大為3位
# Modify.........: No.TQC-870017 08/07/15 By Sarah 執行後一直跑不出報表
# Modify.........: No.MOD-870303 08/07/29 By chenl 修正年度欄位
# Modify.........: No.MOD-890025 08/09/02 By Sarah 資料有多頁時會殘留前頁資料
# Modify.........: No.MOD-890057 08/09/11 By Sarah g_pageno計算第幾頁計算有誤
# Modify.........: No.MOD-8B0035 08/11/07 By Sarah 報表資料有誤
# Modify.........: No.MOD-8B0134 08/11/13 By Sarah SQL中的amd_file改為OUTER join
# Modify.........: No.MOD-980051 09/08/12 By mike l_sql里過濾月份時條件是AND oom02 =tm.bm AND oom021 =tm.em , 
#                                                 請改成 AND oom02>=tm.bm AND oom021<=tm.em
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-990024 09/12/17 By chenmoyan修改抓取oom_file的条件
# Modify.........: No.TQC-9C0179 09/12/29 By tsai_yen EXECUTE裡不可有擷取字串的中括號[]
# Modify.........: No.FUN-9C0073 10/01/14 By chenls 程序精簡
# Modify.........: No:FUN-A10039 10/01/20 By jan 程式段中用到amd172 = 'D'或amd172 <> 'D'皆改為amd172 = 'F'或amd172 <> 'F'
# Modify.........: No.TQC-A40101 10/04/21 By Carrier SQL条件错误
# Modify.........: No:MOD-A90099 10/09/15 By Dido 空白發票增加 amd172 = 'D' 判斷 
# Modify.........: No:MOD-B50086 11/05/11 By Dido 增加過濾申報部門 
# Modify.........: No.FUN-B50018 11/05/16 By xumm GR轉GRW
# Modify.........: No.FUN-B80050 11/08/03 By minpp 程序撰写规范修改
# Modify.........: No.MOD-BC0008 11/12/09 By yangtt GRW套表不對齊
# Modify.........: No:FUN-C10036 12/01/16 By lujh 程式規範修改
# Modify.........: No.FUN-C50008 12/05/12 By wangrr GR程式優化
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm       RECORD
                yy          LIKE type_file.num10,      #No.FUN-680074 INTEGER #年度
                bm          LIKE type_file.num10,      #No.FUN-680074 INTEGER #月份
                em          LIKE type_file.num10,      #No.FUN-680074 INTEGER #月份
                date        LIKE type_file.dat,        #No.FUN-680074 INTEGER #申請日期
                ama01       LIKE ama_file.ama01,
                more        LIKE type_file.chr1        #No.FUN-680074 VARCHAR(1)
                END RECORD,
        g_wc     STRING,  #No.FUN-580092 HCN        #No.FUN-680074
       l_totamt1,l_totamt2    LIKE type_file.num20_6,              #No:8277        #No.FUN-680074 DECIMAL(20,6)
       l_totamt3,l_tottax     LIKE type_file.num20_6,              #No.FUN-680074  DECIMAL(20,6)#No:8277
       l_total1,l_total2,l_total3    LIKE type_file.num10,         #No.FUN-680074  INTEGER
       l_total4,l_total5             LIKE type_file.num10,         #No.FUN-680074  INTEGER
       g_ama    RECORD LIKE ama_file.*
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680074 SMALLINT
DEFINE   g_format        LIKE oom_file.oom08     #No.FUN-680074 VARCHAR(16) #No.FUN-560198
DEFINE   g_sql           STRING                  #No.TQC-810004--add                                                                
DEFINE   l_table         STRING                  #No.TQC-810004--add                                                                
DEFINE   g_sql1          STRING                  #No.TQC-810004--add                                                                
DEFINE   l_table1        STRING                  #No.TQC-810004--add                                                                
DEFINE   g_str           STRING                  #No.TQC-810004--add
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
    l_tot1 LIKE type_file.num10,
    l_tot2 LIKE type_file.num10,
    l_tot3 LIKE type_file.num10,
    l_tot4 LIKE type_file.num10,
    l_tot5 LIKE type_file.num10,
    l_total1 LIKE type_file.num10,
    l_total2 LIKE type_file.num10,
    l_total3 LIKE type_file.num10,
    l_total4 LIKE type_file.num10,
    l_total5 LIKE type_file.num10,
    l_tax LIKE type_file.num20_6,
    l_amt1 LIKE type_file.num20_6,
    l_amt2 LIKE type_file.num20_6,
    l_amt3 LIKE type_file.num20_6,
    l_tottax LIKE type_file.num20_6,
    l_totamt1 LIKE type_file.num20_6,
    l_totamt2 LIKE type_file.num20_6,
    l_totamt3 LIKE type_file.num20_6,
    g_pageno LIKE type_file.num10,
    g_i LIKE type_file.num5
END RECORD

TYPE sr2_t RECORD
    l_n1 LIKE type_file.num5,
    l_n2 LIKE type_file.num5,
    amd03 LIKE amd_file.amd03,
    amd03_1 LIKE amd_file.amd03,
    amd04 LIKE amd_file.amd04,
    amd04_1 LIKE amd_file.amd04,
    amd08 LIKE amd_file.amd08,
    amd08_1 LIKE amd_file.amd08,
    amd07 LIKE amd_file.amd07,
    amd07_1 LIKE amd_file.amd07,
    x1 LIKE type_file.chr1,
    x2 LIKE type_file.chr1,
    x3 LIKE type_file.chr1,
    y1 LIKE type_file.chr1,
    y2 LIKE type_file.chr1,
    y3 LIKE type_file.chr1,
    memo1 LIKE type_file.chr50,
    memo2 LIKE type_file.chr50,
    l_i LIKE type_file.num5,
    ama02 LIKE ama_file.ama02
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
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690116   #FUN-C10036   mark
   LET g_sql =" ama02.ama_file.ama02,",
              " ama03.ama_file.ama03,",                                                                                             
              " ama07.ama_file.ama07,",                                                                                             
              " oom07.oom_file.oom07,",                                                                                             
              " oom07_1.oom_file.oom07,",
              " oom08.oom_file.oom08,",                                                                                             
              " oom11.oom_file.oom11,",                                                                                             
              " oom12.oom_file.oom12,",
              " l_tot1.type_file.num10,",
              " l_tot2.type_file.num10,",
              " l_tot3.type_file.num10,",
              " l_tot4.type_file.num10,",
              " l_tot5.type_file.num10,",
              " l_total1.type_file.num10,",
              " l_total2.type_file.num10,",
              " l_total3.type_file.num10,",
              " l_total4.type_file.num10,",
              " l_total5.type_file.num10,",
              " l_tax.type_file.num20_6,",
              " l_amt1.type_file.num20_6,", 
              " l_amt2.type_file.num20_6,", 
              " l_amt3.type_file.num20_6,", 
              " l_tottax.type_file.num20_6,",
              " l_totamt1.type_file.num20_6,",
              " l_totamt2.type_file.num20_6,",
              " l_totamt3.type_file.num20_6,",
              " g_pageno.type_file.num10,",
              " g_i.type_file.num5"
   LET l_table = cl_prt_temptable('amdg311',g_sql) CLIPPED                                                                          
   IF l_table=-1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add       #FUN-C10036   mark
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1)    #FUN-B50018  add  #FUN-C10036   mark
      EXIT PROGRAM 
   END IF 
 
   LET g_sql1=" l_n1.type_file.num5,",                                                                                             
              " l_n2.type_file.num5,",                                                                                             
              " amd03.amd_file.amd03,",                                                                                             
              " amd03_1.amd_file.amd03,",    
              " amd04.amd_file.amd04,",
              " amd04_1.amd_file.amd04,",
              " amd08.amd_file.amd08,",
              " amd08_1.amd_file.amd08,",
              " amd07.amd_file.amd07,",
              " amd07_1.amd_file.amd07,",                                                                         
              " x1.type_file.chr1,",                                                                                                
              " x2.type_file.chr1,",                                                                                                
              " x3.type_file.chr1,",                                                                                                
              " y1.type_file.chr1,",                                                                                                
              " y2.type_file.chr1,",                                                                                                
              " y3.type_file.chr1,",                                                                                                
              " memo1.type_file.chr50,",                                                                                            
              " memo2.type_file.chr50,",                                                                                            
              " l_i.type_file.num5,",                                                                                                 
              " ama02.ama_file.ama02"    
                                                                                         
   LET l_table1 = cl_prt_temptable('amdg3111',g_sql1) CLIPPED                                                                       
   IF l_table1=-1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add      #FUN-C10036   mark
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1)    #FUN-B50018  add #FUN-C10036   mark 
      EXIT PROGRAM 
   END IF 

   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-C10036  add 

   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
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
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL g311_tm(0,0)
      ELSE CALL g311()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
END MAIN
 
FUNCTION g311_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680074 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680074 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 6 LET p_col = 25
   ELSE LET p_row = 4 LET p_col = 12
   END IF
 
   OPEN WINDOW g311_w AT p_row,p_col
        WITH FORM "amd/42f/amdg311"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET tm.yy   =  YEAR(g_today)
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
         BEFORE INPUT
             CALL cl_qbe_init()
 
      ON ACTION locale
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
         IF tm.em < tm.bm THEN NEXT FIELD em END IF
      AFTER FIELD date
         IF cl_null(tm.date) THEN NEXT FIELD date END IF
      AFTER FIELD ama01
         IF cl_null(tm.ama01) THEN NEXT FIELD ama01
         ELSE
           SELECT * INTO g_ama.* FROM ama_file WHERE ama01 = tm.ama01
                                                    AND amaacti = 'Y'
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","ama_file",tm.ama01,"","amd-002","","",0)    #No.FUN-660093
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
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
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
 
      ON ACTION CONTROLG CALL cl_cmdask()
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
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
 
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW g311_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='amdg311'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amdg311','9031',1)
      ELSE
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
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
         CALL cl_cmdat('amdg311',g_time,l_cmd)
      END IF
      CLOSE WINDOW g311_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL g311()
   ERROR ""
END WHILE
   CLOSE WINDOW g311_w
END FUNCTION
 
FUNCTION g311()
   DEFINE l_name    LIKE type_file.chr20,        #No.FUN-680074 VARCHAR(20) # External(Disk) file name
          l_sql     STRING,       # RDSQL STATEMENT        #No.FUN-680074 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,         #No.FUN-680074 VARCHAR(1)
          l_oom07   LIKE oom_file.oom07,         # Prog. Version..: '5.30.06-13.03.12(08) #modi by nick 960228
          m_oom07   LIKE oom_file.oom07,
          o_oom07   LIKE oom_file.oom07,   #CHI-750026
          k_oom07   LIKE type_file.num5,         #No.FUN-680074 SMALLINT
          j_oom07   LIKE oom_file.oom07,         # Prog. Version..: '5.30.06-13.03.12(08) #modi by nick 960228
          sr        RECORD
                    oom07     LIKE oom_file.oom07,         #起始發票號碼
                    oom08     LIKE oom_file.oom08,         #截止發票號碼
                    oom11     LIKE oom_file.oom11,         #起始流水位數
                    oom12     LIKE oom_file.oom12          #截止流水位數
                    END RECORD
   DEFINE l_i       LIKE type_file.num5                                 #No.FUN-560198        #No.FUN-680074 SMALLINT
   DEFINE l_amd     DYNAMIC ARRAY OF RECORD
                    amd03     LIKE amd_file.amd03,
                    amd04     LIKE amd_file.amd04,
                    amd08     LIKE amd_file.amd08,
                    amd172    LIKE amd_file.amd172,
                    amd07     LIKE amd_file.amd07,
                    x1        LIKE type_file.chr4,      
                    x2        LIKE type_file.chr4,       
                    x3        LIKE type_file.chr4        
                    END RECORD, 
          sr1     RECORD
                    l_n1         LIKE type_file.num5,
                    l_n2         LIKE type_file.num5,
                    amd03        LIKE amd_file.amd03,
                    amd03_1      LIKE amd_file.amd03,
                    amd04        LIKE amd_file.amd04,
                    amd04_1      LIKE amd_file.amd04,
                    amd08        LIKE amd_file.amd08,
                    amd08_1      LIKE amd_file.amd08,
                    amd07        LIKE amd_file.amd07,
                    amd07_1      LIKE amd_file.amd07,
                    x1           LIKE type_file.chr1,
                    x2           LIKE type_file.chr1,
                    x3           LIKE type_file.chr1,
                    y1           LIKE type_file.chr1,
                    y2           LIKE type_file.chr1,
                    y3           LIKE type_file.chr1,
                    memo1        LIKE type_file.chr50,
                    memo2        LIKE type_file.chr50
                    END RECORD
   DEFINE l_tot1,l_tot2,l_tot3   LIKE type_file.num10,
          l_tot4,l_tot5          LIKE type_file.num10,
          l_tax,l_amt1,l_amt2    LIKE type_file.num20_6,
          l_amt3                 LIKE type_file.num20_6,
          l_n                    LIKE type_file.num5,
          l_flag                 LIKE type_file.chr1,
          l_amd03                LIKE amd_file.amd03,
          m_oom08                LIKE oom_file.oom08
   DEFINE l_x1,l_x2,l_x3         STRING,
          l_x4,l_x5,l_x6         STRING
   DEFINE l_oom07_1 LIKE oom_file.oom07
   DEFINE l_oom07_m LIKE oom_file.oom07
 
   CALL cl_del_data(l_table)                                                                                                        
   CALL cl_del_data(l_table1)                                                                                                       
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED ,l_table CLIPPED,                                                                           
               "  VALUES(?,?,?,?,?,  ?,?,?,?,?,",                                                                                     
               "         ?,?,?,?,?,  ?,?,?,?,?,",                                                                                     
               "         ?,?,?,?,?,  ?,?,?)      "                                                                                      
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
     CALL cl_err('insert_prep:',status,1) 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80050    ADD
     CALL cl_gre_drop_temptable(l_table||"|"||l_table1)    #FUN-B50018  add
     EXIT PROGRAM                                                                              
   END IF                                                                                                                           
                                                                                                                                    
   LET g_sql1 = "INSERT INTO ",g_cr_db_str CLIPPED ,l_table1 CLIPPED,                                                                         
               "  VALUES(?,?,?,?,?,  ?,?,?,?,?,",                                                                                     
               "         ?,?,?,?,?,  ?,?,?,?,?)            "                                                                                      
   PREPARE insert_prep1 FROM g_sql1                                                                                                 
   IF STATUS THEN                                                                                                                   
     CALL cl_err('insert_prep1:',status,1)
     CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80050    ADD
     CALL cl_gre_drop_temptable(l_table||"|"||l_table1)    #FUN-B50018  add
     EXIT PROGRAM                                                                             
   END IF                                                                                                                           
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'amdg311'
   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
 
   LET g_wc = '1=1'
   #資料權限的檢查
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('oomuser', 'oomgrup')
 
   LET l_sql ="SELECT DISTINCT oom07,oom08,oom11,oom12 ",   #MOD-740025
            # "  FROM oom_file LEFT OUTER JOIN amd_file ON amd03 BETWEEN oom07 AND oom08 AND amd22 ='",tm.ama01,"' ",   #MOD-740025  #MOD-8B0134  #No.TQC-A40101
              "  FROM oom_file LEFT OUTER JOIN amd_file ON amd03 BETWEEN oom07 AND oom08 ",   #MOD-740025  #MOD-8B0134  #No.TQC-A40101
              " WHERE oom01 =",tm.yy,
              "   AND oom02 >=",tm.bm, #MOD-980051 add >
              "   AND oom021<=",tm.em, #MOD-980051 add <
              "   AND oom04 = '3' ", #No:7699   #MOD-850084 oom04<>'X'->oom04='3'
              "   AND ",g_wc CLIPPED 
   IF g_aza.aza94 = 'Y' THEN
      LET l_sql = l_sql CLIPPED,
                "   AND oom13 = '",g_ama.ama02,"' ",
                "  ORDER BY oom07 "
   ELSE
     #LET l_sql = l_sql CLIPPED, " ORDER BY oom07 "  #MOD-B50086 mark
     #-MOD-B50086-add-
      LET l_sql = l_sql CLIPPED,               
                  "   AND amd22 = '",tm.ama01,"' ",
                  "  ORDER BY oom07 "
     #-MOD-B50086-end-
   END IF
   PREPARE oom_pr FROM l_sql
   IF SQLCA.SQLCODE THEN CALL cl_err('oom_pr',STATUS,0) END IF
   DECLARE oom_curs CURSOR FOR oom_pr
   
#FUN-C50008--add--str
   LET l_sql="SELECT amd03,amd04,amd08,amd172,amd07,",
             "       '','','' ",
             "  FROM amd_file ",
             " WHERE amd03=?  ",
             "   AND amd22='",tm.ama01,"'",   
             "   AND (amd171!='33' OR amd171 IS NULL)",
             "   AND (amd171!='34' OR amd171 IS NULL)" 
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
   LET l_tottax =0      #No:8277
   LET l_total1 =0      #No:8277
   LET l_total2 =0      #No:8277
   LET l_total3 =0      #No:8277
   LET l_total4 =0      #No:8277
   LET l_total5 =0      #No:8277
 
   CALL g311_cal_tot()   #FUN-5C0042
   FOREACH oom_curs INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
         CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
         EXIT PROGRAM
      END IF
      #為了與舊寫法兼容，default初值
      IF cl_null(sr.oom11) THEN LET sr.oom11 = 3 END IF
      IF cl_null(sr.oom12) THEN LET sr.oom12 = 10 END IF
      LET l_oom07=sr.oom07[sr.oom11,sr.oom12]
      LET m_oom07=sr.oom07
      IF sr.oom07[1,8] = o_oom07[1,8] AND 
         ((sr.oom07[9,10]-49<=0 AND o_oom07[9,10]-49<=0) OR
          (sr.oom07[9,10]-49>0 AND o_oom07[9,10]-49>0)) THEN
         CONTINUE FOREACH
      END IF
      WHILE TRUE
         LET k_oom07=m_oom07[sr.oom12-1,sr.oom12]
         IF k_oom07>=0  AND k_oom07<=49 THEN   #MOD-610086
            CALL g311_oom11(sr.oom11,sr.oom12)       #MOD-610086
            LET j_oom07=m_oom07[sr.oom11,sr.oom12]
            LET j_oom07=(j_oom07 - k_oom07) USING g_format #MOD-570042   #MOD-640010
            IF sr.oom11 > 1 THEN
               LET m_oom07=m_oom07[1,sr.oom11-1],j_oom07
            ELSE
               LET m_oom07=j_oom07
            END IF
         END IF
         IF k_oom07>=50 AND k_oom07<=99 THEN   #MOD-610086
            CALL g311_oom11(sr.oom11,sr.oom12)       #MOD-610086
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
         LET l_amt1=0  LET l_amt2=0  LET l_amt3=0  LET l_tax=0
         LET l_i=1
         LET l_amd03=m_oom07[sr.oom11,sr.oom12]    #MOD-8B0035
         CALL g311_oom11(sr.oom11,sr.oom12)
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
         IF cl_null(l_tax) THEN LET l_tax=0 END IF
         IF cl_null(l_total1) THEN LET l_total1=0 END IF
         IF cl_null(l_total2) THEN LET l_total2=0 END IF
         IF cl_null(l_total3) THEN LET l_total3=0 END IF
         IF cl_null(l_total4) THEN LET l_total4=0 END IF
         IF cl_null(l_total5) THEN LET l_total5=0 END IF
         IF cl_null(l_totamt1) THEN LET l_totamt1=0 END IF
         IF cl_null(l_totamt2) THEN LET l_totamt2=0 END IF
         IF cl_null(l_totamt3) THEN LET l_totamt3=0 END IF
         IF cl_null(l_tottax) THEN LET l_tottax=0 END IF
 
         WHILE TRUE
         #FUN-C50008--mark--str
         #  LET l_sql="SELECT amd03,amd04,amd08,amd172,amd07,",
         #            "       '','','' ",
         #            "  FROM amd_file ",
         #            " WHERE amd03='",m_oom07,"'",
         #            "   AND amd22='",tm.ama01,"'",   #MOD-740025
         #            "   AND (amd171!='33' OR amd171 IS NULL)", #No.9024
         #            "   AND (amd171!='34' OR amd171 IS NULL)"  #No.9024
         #  PREPARE amd_pr FROM l_sql
         #  DECLARE amd_curs CURSOR FOR amd_pr
         #  IF SQLCA.SQLCODE THEN CALL cl_err('amd_pr',STATUS,0) END IF
         #  OPEN amd_curs
         #FUN-C50008--mark--end
           OPEN amd_curs USING m_oom07 #FUN-C50008 add
           INITIALIZE l_amd[l_i].* TO NULL   #MOD-890025 add
           FETCH amd_curs INTO l_amd[l_i].*
           IF cl_null(l_amd[l_i].amd08) THEN LET l_amd[l_i].amd08=0 END IF
           IF cl_null(l_amd[l_i].amd07) THEN LET l_amd[l_i].amd07=0 END IF
           IF l_amd[l_i].amd172='F' THEN      #作廢合計,總計 #FUN-A10039
              LET l_tot4=l_tot4+1
           END IF
          #IF cl_null(l_amd[l_i].amd03) THEN   #空白合計,總計                            #MOD-A90099 mark 
           IF cl_null(l_amd[l_i].amd03) OR l_amd[l_i].amd172 = 'D' THEN   #空白合計,總計 #MOD-A90099 
              LET l_tot5=l_tot5+1
           END IF
           CASE WHEN l_amd[l_i].amd172='1'    #應稅合計,總計
                  LET l_amd[l_i].x1='Y'      LET l_tot1=l_tot1+1
                  LET l_amt1=l_amt1+l_amd[l_i].amd08
                  LET l_tax=l_tax+l_amd[l_i].amd07
                WHEN l_amd[l_i].amd172='2'    #零稅率合計,總計
                  LET l_amd[l_i].x2='Y'      LET l_tot2=l_tot2+1
                  LET l_amt2=l_amt2+l_amd[l_i].amd08
                WHEN l_amd[l_i].amd172='3'    #免稅合計,總計
                  LET l_amd[l_i].x3='Y'      LET l_tot3=l_tot3+1
                  LET l_amt3=l_amt3+l_amd[l_i].amd08
           END CASE
           IF l_amd[l_i].amd08=0 THEN LET l_amd[l_i].amd08=NULL END IF
           IF l_amd[l_i].amd07=0 THEN LET l_amd[l_i].amd07=NULL END IF
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
            INITIALIZE sr1.* TO NULL   #MOD-890025 add
 
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
            LET sr1.amd03=l_amd[l_n].amd03
            LET sr1.amd04=l_amd[l_n].amd04
            LET sr1.amd08=l_amd[l_n].amd08
            LET sr1.amd07=l_amd[l_n].amd07
            LET sr1.x1 = l_amd[l_n].x1
            LET sr1.x2 = l_amd[l_n].x2
            LET sr1.x3 = l_amd[l_n].x3
            IF l_flag = '1' THEN
               LET sr1.l_n2=l_n+24 USING '&&'
            ELSE
               LET sr1.l_n2=l_n+74 USING '&&'
            END IF
            IF l_amd[l_n+25].amd172 = 'F' THEN #FUN-A10039
               LET sr1.memo2 = 'void'
            ELSE 
               LET sr1.memo2 = ''
            END If
           #IF cl_null(l_amd[l_n+25].amd03) THEN                                #MOD-A90099 mark 
            IF cl_null(l_amd[l_n+25].amd03) OR l_amd[l_n+25].amd172 = 'D' THEN  #MOD-A90099 
               LET sr1.memo2 = 'space'
            END IF 
            LET sr1.amd03_1=l_amd[l_n+25].amd03
            LET sr1.amd04_1=l_amd[l_n+25].amd04
            LET sr1.amd08_1=l_amd[l_n+25].amd08
            LET sr1.amd07_1=l_amd[l_n+25].amd07
            LET sr1.y1 = l_amd[l_n+25].x1
            LET sr1.y2 = l_amd[l_n+25].x2
            LET sr1.y3 = l_amd[l_n+25].x3
            EXECUTE insert_prep1 USING sr1.*,g_i,g_ama.ama02
         END FOR
         LET g_pageno=g_pageno+1   #MOD-820074
         IF sr.oom11 > 1 THEN
            LET m_oom07=sr.oom07[1,sr.oom11-1],l_oom07
         ELSE
            LET m_oom07=l_oom07
         END IF
         IF m_oom07 >= sr.oom08 THEN EXIT WHILE END IF   #TQC-870017
 
          LET l_oom07_1 = sr.oom07[1,sr.oom11-1]
          LET l_oom07_m = m_oom07[sr.oom11,sr.oom12-2]
         EXECUTE insert_prep USING
            g_ama.ama02,g_ama.ama03,g_ama.ama07,
            l_oom07_1,l_oom07_m,                                  #TQC-9C0179
            sr.oom08,sr.oom11,sr.oom12,l_tot1,l_tot2,l_tot3,l_tot4,l_tot5,
            l_total1,l_total2,l_total3,l_total4,l_total5,l_tax,l_amt1,l_amt2,
            l_amt3,l_tottax,l_totamt1,l_totamt2,l_totamt3,g_pageno,g_i
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
   LET l_x1=tm.yy-1911 USING '&&&' #No.MOD-870303
   LET l_x2=tm.bm
   LET l_x3=tm.em
   LET l_x4=YEAR(tm.date)-1911 USING '&&&' #No.MOD-870303
   LET l_x5=MONTH(tm.date)
   LET l_x6=DAY(tm.date) 
###GENGRE###   LET g_str = l_x1,";",l_x2,";",l_x3,";",g_azi05,";",l_x4,";",l_x5,";",l_x6,";",g_azi04
###GENGRE###   CALL cl_prt_cs3('amdg311','amdg311',l_sql,g_str) 
    CALL amdg311_grdata()    ###GENGRE###
END FUNCTION
 
FUNCTION g311_oom11(p_first,p_last)
   DEFINE p_first  LIKE type_file.num5,         #No.FUN-680074 SMALLINT
          p_last   LIKE type_file.num5          #No.FUN-680074 SMALLINT
   DEFINE l_i      LIKE type_file.num5          #No.FUN-680074 SMALLINT
   LET g_format = NULL
   FOR l_i = p_first TO p_last
      LET g_format = '&',g_format CLIPPED
   END FOR
END FUNCTION
 
FUNCTION g311_cal_tot()
DEFINE  l_sql     STRING,         # RDSQL STATEMENT        #No.FUN-680074
        l_chr     LIKE type_file.chr1,           #No.FUN-680074 VARCHAR(1)
        l_oom07   LIKE oom_file.oom07,           #No.FUN-680074 VARCHAR(8) #modi by nick 960228
        m_oom07   LIKE oom_file.oom07,
        k_oom07   LIKE type_file.num5,           #No.FUN-680074 SMALLINT
        j_oom07   LIKE oom_file.oom07,           # Prog. Version..: '5.30.06-13.03.12(08),                      #modi by nick 960228
        sr        RECORD
                  oom07     LIKE oom_file.oom07,         #起始發票號碼
                  oom08     LIKE oom_file.oom08,         #截止發票號碼
                  oom11     LIKE oom_file.oom11,
                  oom12     LIKE oom_file.oom12          #截止流水位數
                  END RECORD
      LET l_oom07=''       #No:8277
      LET m_oom07=''       #No:8277
      LET j_oom07=''       #No:8277
      LET l_totamt1=0      #No:8277
      LET l_totamt2=0      #No:8277
      LET l_totamt3=0      #No:8277
      LET l_tottax =0      #No:8277
      LET l_total1 =0#No:8277
      LET l_total2 =0#No:8277
      LET l_total3 =0#No:8277
      LET l_total4 =0#No:8277
      LET l_total5 =0      #No:8277
 
      FOREACH oom_curs INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
           CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
           EXIT PROGRAM
        END IF
 
        #為了與舊寫法兼容，default初值
        IF cl_null(sr.oom11) THEN LET sr.oom11 = 3 END IF
        IF cl_null(sr.oom12) THEN LET sr.oom12 = 10 END IF
        CALL g311_oom11(sr.oom11,sr.oom12)
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
           CALL g311_cal_tot2(m_oom07,sr.oom11,sr.oom12)
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
 
FUNCTION g311_cal_tot2(sr)
DEFINE l_last_sw  LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
     sr           RECORD
                  oom07     LIKE oom_file.oom07,         #起始發票號碼
                  oom11     LIKE oom_file.oom11,         #起始流水位數
 
                  oom12     LIKE oom_file.oom12          #截止流水位數
 
                  END RECORD,
     l,x          LIKE type_file.chr4,     #No.FUN-680074 VARCHAR(04)
     l_x          LIKE zaa_file.zaa08,     #No.FUN-680074 VARCHAR(35) 
     l_i,l_j      LIKE type_file.num10,    #No.FUN-680074 INTEGER #FUN-5C0042
     l_k,l_n      LIKE type_file.num5,     #No.FUN-680074 SMALLINT
     l_sql        STRING,   #No.FUN-680074
     l_amd03      LIKE oom_file.oom07,     #No.FUN-680074 VARCHAR(8)
     m_oom07      LIKE oom_file.oom07,
     m_oom08      LIKE oom_file.oom08,
     l_tot1,l_tot2,l_tot3   LIKE type_file.num10,      #No.FUN-680074 INTEGER
     l_tot4,l_tot5,l_total3 LIKE type_file.num10,      #No.FUN-680074 INTEGER
     l_amt1,l_amt2,l_amt3   LIKE type_file.num20_6,    #No.FUN-680074 DECIMAL(20,6)
     l_tax                  LIKE type_file.num20_6,    #No.FUN-680074 DECIMAL(20,6)
     l_amd        DYNAMIC ARRAY OF RECORD
                  amd03     LIKE amd_file.amd03,
                  amd04     LIKE amd_file.amd04,
                  amd08     LIKE amd_file.amd08,
                  amd172    LIKE amd_file.amd172,
                  amd07     LIKE amd_file.amd07,
                  x1        LIKE type_file.chr4,       # Prog. Version..: '5.30.06-13.03.12(02) #No:8277 ORA版也用char
                  x2        LIKE type_file.chr4,       # Prog. Version..: '5.30.06-13.03.12(02) #No:8277 ORA版也用char
                  x3        LIKE type_file.chr4        # Prog. Version..: '5.30.06-13.03.12(02) #No:8277 ORA版也用char
                  END RECORD
  DEFINE l1_oom07           LIKE oom_file.oom07        #No.FUN-680074 VARCHAR(12) #No.MOD-580331
  DEFINE l_flag             LIKE type_file.chr1        #No.MOD-580331 0:與前一頁相同>        #No.FUN-680074 VARCHAR(1)
 
   FOR l_k=1 TO 50
       INITIALIZE l_amd[l_k].* TO NULL
   END FOR
   LET l_tot1=0  LET l_tot2=0  LET l_tot3=0  LET l_tot4=0  LET l_tot5=0
   LET l_amt1=0  LET l_amt2=0  LET l_amt3=0  LET l_tax=0
   LET l_i=1
 
   LET l_amd03=sr.oom07[3,10]
   LET l_amd03=sr.oom07[sr.oom11,sr.oom12]
 
   LET m_oom07=sr.oom07
      CALL g311_oom11(sr.oom11,sr.oom12)
 
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
   IF cl_null(l_tax) THEN LET l_tax=0 END IF
   IF cl_null(l_total1) THEN LET l_total1=0 END IF
   IF cl_null(l_total2) THEN LET l_total2=0 END IF
   IF cl_null(l_total3) THEN LET l_total3=0 END IF
   IF cl_null(l_total4) THEN LET l_total4=0 END IF
   IF cl_null(l_total5) THEN LET l_total5=0 END IF
   IF cl_null(l_totamt1) THEN LET l_totamt1=0 END IF
   IF cl_null(l_totamt2) THEN LET l_totamt2=0 END IF
   IF cl_null(l_totamt3) THEN LET l_totamt3=0 END IF
   IF cl_null(l_tottax) THEN LET l_tottax=0 END IF

#FUN-C50008--add--str
   LET l_sql="SELECT amd03,amd04,amd08,amd172,amd07,",
             "       '','','' ",
             "  FROM amd_file ",
             " WHERE amd03=?  ",
             "   AND amd22='",tm.ama01,"'",
             "   AND (amd171!='33' OR amd171 IS NULL)",
             "   AND (amd171!='34' OR amd171 IS NULL)"
   PREPARE amd2_pr FROM l_sql
   DECLARE amd2_curs CURSOR FOR amd2_pr
   IF SQLCA.SQLCODE THEN CALL cl_err('amd2_pr',STATUS,0) END IF
#FUN-C50008--add--end

   WHILE TRUE
   #FUN-C50008--mark--str
   #    LET l_sql="SELECT amd03,amd04,amd08,amd172,amd07,",
   #              "       '','','' ",
   #              "  FROM amd_file ",
   #              " WHERE amd03='",m_oom07,"'",
   #              "   AND amd22='",tm.ama01,"'",   #MOD-740025
   #              "   AND (amd171!='33' OR amd171 IS NULL)", #No.9024
   #              "   AND (amd171!='34' OR amd171 IS NULL)"  #No.9024
   #    PREPARE amd2_pr FROM l_sql
   #    DECLARE amd2_curs CURSOR FOR amd2_pr
   #    IF SQLCA.SQLCODE THEN CALL cl_err('amd2_pr',STATUS,0) END IF
   #    OPEN amd2_curs
   #FUN-C50008--mark--end
       OPEN amd2_curs USING m_oom07   #FUN-C50008 add
       FETCH amd2_curs INTO l_amd[l_i].*
       IF cl_null(l_amd[l_i].amd08) THEN LET l_amd[l_i].amd08=0 END IF
       IF cl_null(l_amd[l_i].amd07) THEN LET l_amd[l_i].amd07=0 END IF
       IF l_amd[l_i].amd172='F' THEN      #作廢合計,總計 #FUN-A10039
          LET l_tot4=l_tot4+1 LET l_total4=l_total4+1
       END IF
      #IF cl_null(l_amd[l_i].amd03) THEN   #空白合計,總計                            #MOD-A90099 mark 
       IF cl_null(l_amd[l_i].amd03) OR l_amd[l_i].amd172 = 'D' THEN   #空白合計,總計 #MOD-A90099 
          LET l_tot5=l_tot5+1 LET l_total5=l_total5+1
       END IF
       CASE WHEN l_amd[l_i].amd172='1'      #應稅合計,總計
                 LET l_total1=l_total1+1
                 LET l_totamt1=l_totamt1+l_amd[l_i].amd08
                 LET l_tottax=l_tottax+l_amd[l_i].amd07
            WHEN l_amd[l_i].amd172='2'      #零稅率合計,總計
                 LET l_total2=l_total2+1
                 LET l_totamt2=l_totamt2+l_amd[l_i].amd08
            WHEN l_amd[l_i].amd172='3'      #免稅合計,總計
                 LET l_total3=l_total3+1
                 LET l_totamt3=l_totamt3+l_amd[l_i].amd08
       END CASE
       IF l_amd[l_i].amd08=0 THEN LET l_amd[l_i].amd08=NULL END IF
       IF l_amd[l_i].amd07=0 THEN LET l_amd[l_i].amd07=NULL END IF
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
FUNCTION amdg311_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("amdg311")
        IF handler IS NOT NULL THEN
            START REPORT amdg311_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
          
            DECLARE amdg311_datacur1 CURSOR FROM l_sql
            FOREACH amdg311_datacur1 INTO sr1.*
                OUTPUT TO REPORT amdg311_rep(sr1.*)
            END FOREACH
            FINISH REPORT amdg311_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT amdg311_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_sql    STRING                    #FUN-B50018
    DEFINE l_p1     STRING                    #FUN-B50018
    DEFINE l_p2     STRING                    #FUN-B50018
    DEFINE l_p3     STRING                    #FUN-B50018
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
    DEFINE l_p5      STRING                    #MOD-BC0008 add
    DEFINE l_p6      STRING                    #MOD-BC0008 add
    DEFINE l_p7      STRING                    #MOD-BC0008 add
    DEFINE l_fmt     STRING                    #MOD-BC0008 add
    DEFINE l_cnt    LIKE type_file.num10       #MOD-BC0008 add 

    ORDER EXTERNAL BY sr1.oom07
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.oom07
            LET l_lineno = 0

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_cnt = cl_gre_rowcnt(l_table) #MOD-BC0008 add
            PRINTX l_cnt                       #MOD-BC0008 add
            LET l_p5=tm.yy-1911 USING '&&&'  #MOD-BC0008 add
            LET l_p6=tm.bm                   #MOD-BC0008 add
            LET l_p7=tm.em                   #MOD-BC0008 add
            PRINTX l_p5                      #MOD-BC0008 add
            PRINTX l_p6                      #MOD-BC0008 add
            PRINTX l_p7                      #MOD-BC0008 add
            #FUN-B50018----add-----str-----------------
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        # " WHERE amd04 = '",sr1.ama02 CLIPPED,"'"    #MOD-BC0008
                        " WHERE ama02 = '",sr1.ama02 CLIPPED,"' AND l_i = ",sr1.g_i    #MOD-BC0008 
            DECLARE amdg311_repcur1 CURSOR FROM l_sql
            FOREACH amdg311_repcur1 INTO sr2.*

       #    LET  l_l_n1 = sr2.l_n1,'00'             #MOD-BC0008 mark
            LET  l_l_n1 = sr2.l_n1 USING '&&'       #MOD-BC0008 add
            PRINTX l_l_n1

            LET l_fmt = cl_gr_numfmt("amd_file","amd08",g_azi04)    #MOD-BC0008 add
            PRINTX l_fmt                                            #MOD-BC0008 add

      #     LET  l_l_n2 = sr2.l_n2,'00'              #MOD-BC0008 mark
            LET  l_l_n2 = sr2.l_n2 USING '&&'        #MOD-BC0008 add
            PRINTX l_l_n2

            IF sr2.memo1 = 'void' THEN
               LET  l_memo1 = '作 廢'
            ELSE
               IF sr2.memo1 = 'space' THEN
                  LET  l_memo1 = '空 白'
               ELSE
                  IF  sr2.memo1 = 'voidspace'THEN
                      LET  l_memo1 ='作廢 空白'
                  ELSE                          #MOD-BC0008 add
                     LET l_memo1 = NULL         #MOD-BC0008 add
                  END IF
               END IF
            END IF
            PRINTX l_memo1

            IF sr2.memo2 = 'void' THEN
               LET  l_memo2 = '作 廢'
            ELSE
               IF sr2.memo2 = 'space' THEN
                  LET  l_memo2 = '空 白'
               ELSE
                  IF  sr2.memo2 = 'voidspace'THEN
                      LET  l_memo2 ='作廢 空白'
                  ELSE                          #MOD-BC0008 add
                     LET l_memo2 = NULL         #MOD-BC0008 add
                  END IF
               END IF
            END IF
            PRINTX l_memo2

            IF sr2.x1 = 'Y' THEN
               LET l_x1 = 'ˇ'
            ELSE                   #MOD-BC0008 ADD
               LET l_x1 = NULL     #MOD-BC0008 ADD
            END IF
            PRINTX l_x1

            IF sr2.x2 = 'Y' THEN
               LET l_x2 = 'ˇ'
            ELSE                   #MOD-BC0008 ADD
               LET l_x2 = NULL     #MOD-BC0008 ADD
            END IF
            PRINTX l_x2

            IF sr2.x3 = 'Y' THEN
               LET l_x3 = 'ˇ'
            ELSE                   #MOD-BC0008 ADD
               LET l_x3 = NULL     #MOD-BC0008 ADD
            END IF
            PRINTX l_x3

            IF sr2.y1 = 'Y' THEN
               LET l_y1 = 'ˇ'
            ELSE                   #MOD-BC0008 ADD
               LET l_y1 = NULL     #MOD-BC0008 ADD
            END IF
            PRINTX l_y1

            IF sr2.y2 = 'Y' THEN
               LET l_y2 = 'ˇ'
            ELSE                   #MOD-BC0008 ADD
               LET l_y2 = NULL     #MOD-BC0008 ADD
            END IF
            PRINTX l_y2

            IF sr2.y3 = 'Y' THEN
               LET l_y3 = 'ˇ'
            ELSE                   #MOD-BC0008 ADD
               LET l_y3 = NULL     #MOD-BC0008 ADD
            END IF
            PRINTX l_y3
            PRINTX sr2.*      
            END FOREACH

#           LET l_p1 = tm.yy-1991 USING '&&&'    #MOD-BC0008 MARK
#           LET l_p2 = tm.bm                     #MOD-BC0008 MARK
#           LET l_p3 = tm.em                     #MOD-BC0008 MARK
            LET l_p1 = YEAR(tm.date) - 1911 USING '&&&'    #MOD-BC0008 add
            LET l_p2 = MONTH(tm.date)                      #MOD-BC0008 add
            LET l_p3 = DAY(tm.date)                        #MOD-BC0008 add
            PRINTX l_p1
            PRINTX l_p2
            PRINTX l_p3
            #FUN-B50018----add-----end-----------------

            PRINTX sr1.*

        
        ON LAST ROW

END REPORT


###GENGRE###END
