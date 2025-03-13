# Prog. Version..: '5.30.06-13.03.22(00010)'     #
#
# Pattern name...: aglr007.4gl
# Descriptions...: 合併財務報表工作底稿列印
# DATE AND ARTHUR: NO.FUN-580072 05/09/02 by yiting
# Modify.........: NO.TQC-5B0064 05/11/08 By Niocla 報表修改
# Modify.........: No.MOD-660034 06/06/13 By Smapmin 修改抓取匯率方式
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-670005 06/07/07 By xumin  帳別權限修改 
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680098 06/08/30 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6A0093 06/11/08 By Carrier 調整報表格式
# Modify.........: No.FUN-6C0012 06/12/25 By Judy 新增欄位打印額外名稱
# Modify.........: No.FUN-6C0068 07/01/16 By rainy 報表結構加判斷使用者及部門設限
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.TQC-740015 07/04/04 By Judy 語言功能失效
# Modify.........: No.FUN-740020 07/04/13 By mike  會計科目加帳套
# Modify.........: No.TQC-740093 07/04/17 By mike  會計科目加帳套
# Modify.........: No.MOD-740257 07/04/26 By Sarah 抓取axe11,axe12時失敗,導致後面取換算匯率時也失敗
# Modify.........: NO.FUN-750076 07/05/18 BY yiting 增加版本條件
# Modify.........: No.FUN-760044 07/06/15 By Sarah 隱藏畫面的版本欄位,列印也不印
# Modify.........: No.FUN-760083 07/07/25 By mike  報表格式修改為crystal reports
# Modify.........: No.FUN-770069 07/08/03 By Sarah 要列印版本,增加傳tm.ver到CR
# Modify.........: No.FUN-870151 08/08/13 By sherry  匯率調整為用azi07取位
# Modify.........: No.FUN-910001 09/01/06 By Sarah 串axe_file時,增加串axe13(族群代號)=tm.axb01
# Modify.........: No.FUN-920199 09/05/20 By ve007 依據上層公司所在庫抓取maj_file
# Modify.........: No.FUN-930076 09/05/19 By ve007 報表代號開窗資料需跨DB處理
# Modify.........: NO.FUN-930117 09/05/20 BY ve007 pk值異動，相關程式修改
# Modify.........: No.MOD-940202 09/04/16 By Sarah 畫面上帳別開窗有問題,應開上層公司所在DB的合併報表帳別aaz641
# Modify.........: NO.FUN-950048 09/05/22 BY jan 拿掉'版本'欄位
# Modify.........: No.TQC-960293 09/06/23 By Sarah 組g_dbs_new時,語法有誤,增加用ora轉換
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-9A0027 09/10/15 By mike 年度期别之初值应调整为 CALL s_yp(g_today) RETURNING tm.yy,tm.em                   
# Modify.........: No.FUN-9C0072 10/01/18 By vealxu 精簡程式碼
# Modify.........: No.MOD-A40008 10/04/02 By Dido 1.資產類抓取當月;損益類抓取區間 2.mai_file 增加帳別
# Modify.........: No.MOD-A40009 10/04/02 By Dido 需判斷 axa09 = 'N' 時,抓取目前營運中心 
# Modify.........: No.MOD-A50018 10/05/05 By sabrina 抓取g_axz06
# Modify.........: No.TQC-A40133 10/05/07 By liuxqa modify sql
# Modify.........: No.TQC-A50028 10/05/12 By sabrina 執行報表後，記帳幣*再衡量匯率=功能幣，
#                                                    此時的再衡量匯率因為子公司記帳幣=功能幣，匯率應為1
# Modify.........: No.MOD-A50184 10/05/27 By sabrina (1)將匯率(sr.rate,sr.rate1)清空
#                                                    (2)l_axp05,l_axp06,l_axp07先預設值
# Modify.........: No.FUN-A50102 10/06/07 By lutingtingGP5.3集團架構優化:跨庫統一改為使用cl_get_target_table()實现
# Modify.........: No:MOD-A70181 10/07/23 By Dido 設定換算匯率預設值 
# Modify.........: No:CHI-A80019 10/08/13 By Summer sr.rate/sr.rate1改抓axg18/axg19來顯示
# Modify.........: No.FUN-A30122 10/08/24 By vealxu 合併帳別/合併資料庫的抓法改為CALL s_get_aaz641,s_aaz641_dbs
# Modify.........: No:CHI-A70061 10/08/25 By Summer 先列印空白再列印資料
# Modify.........: No:CHI-A70050 10/10/25 By sabrina 計算合計階段需增加maj09的控制 
# Modify.........: No:MOD-AB0200 10/11/23 By Dido 訊息 refresh 調整 
# Modify.........: No:FUN-A90032 11/01/24 By wangxin 屬於合併報表者，取消起始期別'輸入, 也就是若該合併主體採季報實施,則該報表無法以單月呈現
# Modify.........: NO:CHI-B10030 11/01/26 BY Summer 抓取aznn_file的SQL要改為跨DB的寫法,跨到這次合併的上層公司所在DB去抓取
# Modify.........: No.TQC-B30100 11/03/11 BY zhangweib 將程序中的MATCHES修改成ORACLE能識別的IN
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: NO:MOD-B30067 11/04/14 BY Dido 取消 q_mai01 傳遞參數
# Modify.........: NO:FUN-B70066 11/07/21 By belle 增加累換數科目,增加欄位:調整金額及合計欄位
# Modify.........: NO:MOD-B80279 11/08/24 By Sarah 餘額為0者不列印,應該要判斷全部金額都為0時才不列印
# Modify.........: NO.TQC-B90053 11/09/06 BY yiting aglr007程式中的mai00應該用合併帳別tm.b為條件 
# Modify.........: NO.MOD-B90062 11/09/06 BY Dido 累換數抓取 axi06 改抓上層,增加串連 axj05 為下層 
# Modify.........: NO.MOD-B90085 11/09/14 By Polly 累換數金額要抓取aglq001合併前金額+aglt001沖銷金額
# Modify.........: No.FUN-BA0012 11/10/05 by belle 將4/1版更後的GP5.25合併報表程式與目前己修改LOSE的FUN,TQC,MOD單追齊
# Modify.........: No.MOD-BB0128 11/11/14 By Polly 增加axg_file條件的抓取
# Modify.........: No.MOD-BB0244 11/11/24 By Polly FUNCTION r007() 中相關使用 l_axb02 改為 g_axb02
# Modify.........: No.MOD-BC0144 11/12/13 By Dido 抓取 g_amt4 應判斷借貸方 
# Modify.........: No.MOD-C40181 12/04/23 By Polly 重過程式碼至正式區
# Modify.........: NO:FUN-B80166 12/04/30 By belle aglr007 記帳幣調整欄位分為借貸二欄 
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料
# Modify.........: NO.CHI-C60024 12/07/04 BY bart 未將換匯差額分錄之本期損益BS金額納入，導致B/S、I/S之本期損益數不合。
#                                                   應將本期損益BS匯差納入，並將累積換算調整數淨額再回加或減本期損益BS金額
# Modify.........: NO.FUN-C50079 12/07/04 BY bart 增加可以取出中間層公司本身自己的合併前科餘處理
# Modify.........: No.MOD-C90087 12/09/11 By Polly 上層公司和下層公司相同時，才需取出中間層公司本身自己的合併前科餘處理
# Modify.........: No.MOD-D30208 13/03/22 By Belle 增加關係人代號

DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE tm  RECORD
           rtype   LIKE type_file.chr1,   #報表Type     #No.FUN-680098   VARCHAR(1)   
           a       LIKE mai_file.mai01,   #報表結構編號 #No.FUN-680098   VARCHAR(6)  
           b       LIKE aaa_file.aaa01,   #帳別編號     #No.FUN-670039
           axb01   LIKE axb_file.axb01,   #列印族群 
           axb04   LIKE axb_file.axb04,   #下層公司
           axb05   LIKE axb_file.axb05,   #帳號
           yy      LIKE type_file.num5,   #輸入年度     #No.FUN-680098   smallint
           axa06   LIKE axa_file.axa06,   #FUN-A90032
           bm      LIKE type_file.num5,   #Begin 期別   #No.FUN-680098   smallint
           em      LIKE type_file.num5,   # End  期別   #No.FUN-680098   smallint
           q1      LIKE type_file.chr1,   #FUN-A90032   
           h1      LIKE type_file.chr1,   #FUN-A90032
           c       LIKE type_file.chr1,   #異動額及餘額為0者是否列印 #No.FUN-680098  VARCHAR(1) 
           d       LIKE type_file.chr1,   #金額單位     #No.FUN-680098  VARCHAR(1) 
           e       LIKE type_file.chr1,   #列印額外名稱 #FUN-6C0012
           f       LIKE type_file.num5,   #列印最小階數 #No.FUN-680098 smallint
           more    LIKE type_file.chr1    #Input more condition(Y/N)  #No.FUN-680098  VARCHAR(1) 
          ,axb02   LIKE axb_file.axb02    #FUN-C50079
          ,axb03   LIKE axb_file.axb03    #FUN-C50079
           END RECORD,
       i,j,k,h,m,n,g_mm  LIKE type_file.num5,   #No.FUN-680098  smallint
       g_unit        LIKE type_file.num10,        #金額單位基數  #No.FUN-680098  integer
       g_buf         LIKE type_file.chr1000,      #No.FUN-680098   VARCHAR(600) 
       g_cn          LIKE type_file.num5,         #No.FUN-680098   smallint
       g_flag        LIKE type_file.chr1,         #No.FUN-680098    VARCHAR(1) 
       g_bookno      LIKE aah_file.aah00,         #帳別
       g_gem05       LIKE gem_file.gem05,
       g_mai02       LIKE mai_file.mai02,
       g_mai03       LIKE mai_file.mai03,
       g_abd01       LIKE abd_file.abd01,
       g_axb01       LIKE axb_file.axb01,
       g_no          LIKE type_file.num5,                    #No.FUN-680098 smallint
       g_tot1        ARRAY[100] OF  LIKE type_file.num20_6,   #No.FUN-680098 decimal(20,6)
       g_tot2        ARRAY[100] OF  LIKE type_file.num20_6,   #No.FUN-680098 decimal(20,6)
       g_tot3        ARRAY[100] OF  LIKE type_file.num20_6,   #No.FUN-680098 decimal(20,6)
       g_tot4        ARRAY[100] OF  LIKE type_file.num20_6,   #FUN-B70066 #No.FUN-680098 decimal(20,6) 
       g_tot5        ARRAY[100] OF  LIKE type_file.num20_6   #FUN-B70066 #No.FUN-680098 decimal(20,6)
       #g_tot6        ARRAY[100] OF  LIKE type_file.num20_6,   #FUN-B80166
       #g_tot7        ARRAY[100] OF  LIKE type_file.num20_6    #FUN-B80166
DEFINE g_axz_u       RECORD LIKE axz_file.*       #上層公司
DEFINE g_axz_d       RECORD LIKE axz_file.*       #下層公司
DEFINE g_aaa03       LIKE aaa_file.aaa03   
DEFINE g_i           LIKE type_file.num5          #count/index for any purpose        #No.FUN-680098 smallint
DEFINE g_msg         LIKE type_file.chr1000       #No.FUN-680098 VARCHAR(72)
DEFINE maj           RECORD LIKE maj_file.*
DEFINE g_amt1        LIKE type_file.num20_6       #No.FUN-680098 decimal(20,6)
DEFINE g_amt2        LIKE type_file.num20_6       #No.FUN-680098 decimal(20,6)
DEFINE g_amt3        LIKE type_file.num20_6       #No.FUN-680098 decimal(20,6)
DEFINE g_amt4        LIKE type_file.num20_6       #FUN-B70066   #No.FUN-680098 decimal(20,6)
DEFINE g_amt41       LIKE type_file.num20_6       #MOD-BC0144
DEFINE g_amt42       LIKE type_file.num20_6       #MOD-BC0144
DEFINE g_amt5        LIKE type_file.num20_6       #FUN-B70066   #No.FUN-680098 decimal(20,6)
#DEFINE g_amt6        LIKE type_file.num20_6       #FUN-B80166
#DEFINE g_amt7        LIKE type_file.num20_6       #FUN-B80166
DEFINE g_azi02_1     LIKE azi_file.azi02
DEFINE g_azi02_2     LIKE azi_file.azi02
DEFINE g_azi02_3     LIKE azi_file.azi02
DEFINE g_sql         STRING                       #No.FUN-760083
DEFINE g_str         STRING                       #No.FUN-760083
DEFINE l_table       STRING                       #No.FUN-760083
DEFINE g_dbs_axz03   STRING                       #No.FUN-920199
DEFINE g_dbs_axz03_1 STRING                       #MOD-940202 add
DEFINE g_plant_axz03 LIKE type_file.chr21         #FUN-A30122 add
DEFINE g_axz06       LIKE axz_file.axz06          #FUN-930117
DEFINE g_axz03       LIKE axz_file.axz03          #MOD-940202 add
DEFINE g_aaz641      LIKE aaz_file.aaz641         #MOD-940202 add
DEFINE l_length      LIKE type_file.num5          #No.FUN-930076
DEFINE g_axa05       LIKE axa_file.axa05          #FUN-A90032
DEFINE g_axb02       LIKE axb_file.axb02          #MOD-BB0128 add
DEFINE g_axb03       LIKE axb_file.axb03          #MOD-BB0128 add
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                          #Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
   LET g_sql="maj02.maj_file.maj02,",
             "maj03.maj_file.maj03,",
             "maj04.maj_file.maj04,",
             "maj05.maj_file.maj05,",
             "maj07.maj_file.maj07,",
             "maj20.maj_file.maj20,",
             "maj20e.maj_file.maj20e,",
             "maj21.maj_file.maj21,",
             "maj22.maj_file.maj22,",
             "line.type_file.num5,", #CHI-A70061 add
             "bal1.type_file.num20_6,",
             "bal4.type_file.num20_6,",   #No:FUN-B70066 調整金額
             "bal5.type_file.num20_6,",   #No:FUN-B70066 合計金額
             #"bal6.type_file.num20_6,",   #FUN-B80166 借方
             #"bal7.type_file.num20_6,",   #FUN-B80166 貸方
             "axe11.axe_file.axe11,",
            #"rate.axp_file.axp06,",  #CHI-A80019 mark
             "rate.axg_file.axg18,",  #CHI-A80019
             "bal2.type_file.num20_6,",
             "axe12.axe_file.axe12,",
            #"rate1.axp_file.axp05,", #CHI-A80019 mark
             "rate1.axg_file.axg19,", #CHI-A80019
             "bal3.type_file.num20_6,",
             "azi07.azi_file.azi07,",    #No.FUN-870151
             "azi07_1.azi_file.azi07"    #No.FUN-870151
             
 
  LET l_table=cl_prt_temptable("aglr007",g_sql) CLIPPED 
  IF l_table=-1 THEN EXIT PROGRAM END IF
  #LET g_sql ="INSERT INTO ds_report.",l_table CLIPPED,  #TQC-A40133 mark
  LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,   #TQC-A40133 mod
             #" VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"  #FUN-B80166 #FUN-B70066 add ? #No:FUN-870151 #CHI-A70061 add ?
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)" 
  PREPARE insert_prep FROM g_sql
  IF STATUS THEN
      CALL cl_err("insert_prep:",status,1)
  END IF
 
 
   LET g_bookno= ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)                 #Get arguments from command line
   LET g_towhom= ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway= ARG_VAL(6)
   LET g_copies= ARG_VAL(7)
   LET tm.a    = ARG_VAL(8)
   LET tm.axb01= ARG_VAL(9)
   LET tm.yy   = ARG_VAL(10)
#  LET tm.bm   = ARG_VAL(11)  #FUN-A90032
   LET tm.axa06= ARG_VAL(11)  #FUN-A90032
   LET tm.em   = ARG_VAL(12)
   LET tm.c    = ARG_VAL(13)
   LET tm.d    = ARG_VAL(14)
   LET tm.f    = ARG_VAL(15)
   LET g_rep_user = ARG_VAL(16)
   LET g_rep_clas = ARG_VAL(17)
   LET g_template = ARG_VAL(18)
   LET tm.e       = ARG_VAL(19)   #FUN-6C0012
   LET g_rpt_name = ARG_VAL(20)  #No.FUN-7C0078
   LET tm.q1      = ARG_VAL(21)  #FUN-A90032
   LET tm.h1      = ARG_VAL(22)  #FUN-A90032
 
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL r007_tm()                           # Input print condition
   ELSE
      CALL r007()         
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION r007_tm()
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680098  smallint
          l_sw           LIKE type_file.chr1,          #重要欄位是否空白 #No.FUN-680098  VARCHAR(1) 
          l_cmd          LIKE type_file.chr1000,       #No.FUN-680098 VARCHAR(400)
          l_axb01        LIKE type_file.num5,          #No.FUN-680098 smallint
          l_axb04        LIKE type_file.num5,          #No.FUN-680098 smallint
          li_chk_bookno  LIKE type_file.num5,          #No.FUN-670005    #No.FUN-680098  smallint
          li_result      LIKE type_file.num5           #No.FUN-6C0068
   DEFINE l_dbs          LIKE type_file.chr21          #FUN-930076 add
   DEFINE l_dbs1         LIKE type_file.chr21          #MOD-940202 add
   DEFINE l_axa02        LIKE axa_file.axa02           #MOD-940202 add
   DEFINE l_aaa05        LIKE aaa_file.aaa05           #FUN-950048
   DEFINE l_axa09        LIKE axa_file.axa09          #MOD-A40009
   DEFINE l_azp03        LIKE azp_file.azp03          #FUN-A30122 
   DEFINE l_aznn01       LIKE aznn_file.aznn01         #FUN-A90032
   DEFINE l_axz03        LIKE axz_file.axz03          #CHI-B10030 add
   DEFINE l_cnt_axb02    LIKE type_file.num5           #FUN-C50079
   
   CALL s_dsmark(g_bookno)
 
   LET p_row = 2 LET p_col = 20
 
   OPEN WINDOW r007_w AT p_row,p_col WITH FORM "agl/42f/aglr007" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  #Default condition
   LET tm.bm= 0              #FUN-950048
   CALL s_yp(g_today) RETURNING tm.yy,tm.em #CHI-9A0027     
   LET tm.a = ' '
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.e = 'N'  #FUN-6C0012
   LET tm.f = 0
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
WHILE TRUE
    LET l_sw = 1
    #INPUT BY NAME tm.rtype,tm.axb01,tm.axb04,tm.axb05,tm.a,tm.b,  #FUN-930076 mod   #NO.FUN-750076 #FUN-950048 拿掉tm.ver #FUN-C50079
    INPUT BY NAME tm.rtype,tm.axb01,tm.axb02,tm.axb04,tm.axb05,tm.a,tm.b,  #FUN-C50079 add axb02
#                 tm.yy,tm.bm,tm.em,tm.f,tm.d,tm.c,tm.e,tm.more          #FUN-6C0012 #FUN-A90032 mark
                  tm.yy,tm.em,tm.q1,tm.h1,tm.f,tm.d,tm.c,tm.e,tm.more                #FUN-A90032 
                  WITHOUT DEFAULTS
       BEFORE INPUT
          CALL cl_qbe_init()
          CALL r007_set_entry()      #FUN-A90032
          CALL r007_set_no_entry()   #FUN-A90032
 
       ON ACTION locale
          CALL cl_dynamic_locale()   #TQC-740015
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          LET g_action_choice = "locale"
 
        BEFORE FIELD rtype 
          CALL r007_set_entry()
 
#FUN-A90032 --Begin 
#        AFTER FIELD rtype
#           IF tm.rtype = '1' THEN  
#              LET tm.bm=0
#              DISPLAY tm.bm TO bm 
#              CALL r007_set_no_entry()
#           END IF
#FUN-A90032 --End           
 
       AFTER FIELD axb01
          IF cl_null(tm.axb01) THEN NEXT FIELD axb01 END IF
          SELECT COUNT(*) INTO l_axb01 FROM axb_file WHERE axb01=tm.axb01
          IF l_axb01 = 0 THEN
             CALL cl_err('sel axb:',STATUS,0) 
             NEXT FIELD axb01
#FUN-A30122 ------------------------mark start-------------------------------
#         ELSE
#            #抓取上層公司所屬合併帳別
#            CALL r007_get_bookno() RETURNING tm.b
#            DISPLAY BY NAME tm.b
#FUN-A30122 ----------------------mark end-----------------------------------
          END IF
#FUN-A90032 --Begin
          LET tm.axa06 = '2'
          SELECT axa05,axa06 
            INTO g_axa05,tm.axa06
           FROM axa_file
          WHERE axa01 = tm.axb01
            AND axa04 = 'Y'
          DISPLAY BY NAME tm.axa06
          CALL r007_set_entry()
          CALL r007_set_no_entry()
          IF tm.axa06 = '1' THEN
              LET tm.q1 = '' 
              LET tm.h1 = '' 
              LET l_aaa05 = 0
              SELECT aaa05 INTO l_aaa05 FROM aaa_file 
               WHERE aaa01=tm.b 
#                AND aaaacti MATCHES '[Yy]'   #No.TQC-B30100 Mark
                 AND aaaacti IN ('Y','y')       #No.TQC-B30100 add
              LET tm.em = l_aaa05
          END IF
          IF tm.axa06 = '2' THEN
              LET tm.h1 = '' 
              LET tm.em = '' 
          END IF
          IF tm.axa06 = '3' THEN
              LET tm.em = '' 
              LET tm.q1 = ''
          END IF
          IF tm.axa06 = '4' THEN
              LET tm.em = '' 
              LET tm.q1 = ''
              let tm.h1 = ''
          END IF
          DISPLAY BY NAME tm.em
          DISPLAY BY NAME tm.q1
          DISPLAY BY NAME tm.h1

         AFTER FIELD q1
         IF cl_null(tm.q1) AND  tm.axa06 = '2' THEN
            NEXT FIELD q1
         END IF
         IF cl_null(tm.q1) OR tm.q1 NOT MATCHES '[1234]' THEN
            NEXT FIELD q1
         END IF

         AFTER FIELD h1
            IF (cl_null(tm.h1) OR tm.h1>2 OR tm.h1<0) AND tm.axa06='4' THEN
               NEXT FIELD h1
            END IF
#FUN-A90032 --End          
       #--FUN-C50079 start --- 
       AFTER FIELD axb02
          IF cl_null(tm.axb02) THEN NEXT FIELD axb02 END IF
              LET l_cnt_axb02 = 0             
              SELECT COUNT(*) INTO l_cnt_axb02
                FROM axb_file
               WHERE axb01 = tm.axb01
                 AND axb02 = tm.axb02
              IF cl_null(l_cnt_axb02) OR l_cnt_axb02 = 0 THEN 
                  CALL cl_err('','agl-223',0)
                  NEXT FIELD axb02
              ELSE
                  SELECT axb03 INTO tm.axb03
                    FROM axb_file
                   WHERE axb01 = tm.axb01
                     AND axb02 = tm.axb02
                  DISPLAY BY NAME tm.axb03
              END IF
              
       #--FUN-C50079 end----
       
       AFTER FIELD axb04
          IF cl_null(tm.axb04) THEN NEXT FIELD axb04 END IF
#FUN-A30122 --------------------------mark start----------------------------
#        #-MOD-A40009-add-
#         SELECT axa09 INTO l_axa09 
#           FROM axa_file
#          WHERE axa01 = tm.axb01 AND axa02 = tm.axb04 AND axa03 = tm.axb05 
#         IF l_axa09 = 'N' THEN
#            LET g_dbs_axz03 = s_dbstring(g_dbs CLIPPED)
#            LET g_plant_new = g_plant   #FUN-A50102
#           #MOD-A50018---mark---start---
#           #SELECT axz06 INTO g_axz06  
#           #  FROM axz_file
#           # WHERE axz01 = tm.axb04
#           #MOD-A50018---mark---end---
#         ELSE
#          #SELECT axz03,axz06 INTO g_plant_new,g_axz06  #FUN-930117 add axz06 #MOD-A50018 mark
#           SELECT axz03 INTO g_plant_new                #MOD-A50018 add
#             FROM axz_file
#            WHERE axz01 = tm.axb04
#           CALL s_getdbs()
#           LET g_dbs_axz03 = g_dbs_new  
#         END IF
#        #-MOD-A40009-end-
#         IF NOT cl_null(g_dbs_axz03) THEN 
#             LET l_length = LENGTH(g_dbs_axz03)                     #NO.FUN-930076
#              IF l_length >1 THEN                                    #NO.FUN-930076
#                 LET  l_dbs = g_dbs_axz03.subSTRING(1,l_length-1)    #NO.FUN-930076
#              END IF                                                 #NO.FUN-930076
#         ELSE 
#            LET l_dbs = g_dbs   
#         END IF
#FUN-A30122 -------------------------------mark end-------------------------------------------
#FUN-A30122 -------------------------------add start------------------------------------------
          CALL s_aaz641_dbs(tm.axb01,tm.axb04) RETURNING g_plant_axz03
          CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaz641
          LET g_plant_new = g_plant_axz03
          LET tm.b = g_aaz641
          DISPLAY BY NAME tm.b
          SELECT azp03 INTO l_azp03 FROM azp_file
           WHERE azp01 = g_plant_axz03
          LET g_dbs_axz03 = l_azp03 
          IF NOT cl_null(g_dbs_axz03) THEN 
             LET l_length = LENGTH(g_dbs_axz03) 
             IF l_length >1 THEN
                LET  l_dbs = g_dbs_axz03.subSTRING(1,l_length-1)   
             END IF 
          ELSE
             LET l_dbs = g_dbs
          END IF
#FUN-A30122 -------------------------------add end-------------------------------------------
         #--FUN-C50079 start--
          IF tm.axb04 = tm.axb02 THEN
              LET l_cnt_axb02 = 0             
              #先搜尋是否存在上層
              SELECT COUNT(*) INTO l_cnt_axb02
                FROM axa_file
               WHERE axa01 = tm.axb01
                 AND axa02 = tm.axb04
              IF cl_null(l_cnt_axb02) OR l_cnt_axb02 = 0 THEN 
                  CALL cl_err('','agl-223',0)
                  NEXT FIELD axb02
              ELSE
                  SELECT axa03 INTO tm.axb05 FROM axa_file
                   WHERE axa01=tm.axb01 AND axa02=tm.axb04
                  DISPLAY BY NAME tm.axb05
              END IF
          ELSE
              LET l_cnt_axb02 = 0             
              SELECT COUNT(*) INTO l_cnt_axb02
                FROM axb_file
               WHERE axb02 = tm.axb02
                 AND axb04 = tm.axb04
              IF l_cnt_axb02 = 0 THEN
                  CALL cl_err('','agl-221',0)
                  NEXT FIELD axb02
         #--FUN-C50079 end-----
#---FUN-C50079 mark---start--
#          SELECT COUNT(*) INTO l_axb04 FROM axb_file
#           WHERE axb01=tm.axb01 AND axb04=tm.axb04
#          IF l_axb04 = 0 THEN
#             CALL cl_err('sel axb:',STATUS,0)
#             NEXT FIELD axb04
#---FUN-C50079 mark---end--
              ELSE         
                 SELECT axb05 INTO tm.axb05 FROM axb_file
                  WHERE axb01=tm.axb01 AND axb04=tm.axb04
                 DISPLAY BY NAME tm.axb05
#FUN-A30122 ---------------------mark start-------------------------
#            #抓取上層公司所屬合併帳別
#            CALL r007_get_bookno() RETURNING tm.b
#            DISPLAY BY NAME tm.b
#FUN-A30122 --------------------mark end-------------------------------
              END IF
          END IF   #FUN-C50079   add
 
       AFTER FIELD axb05
          IF cl_null(tm.axb05) THEN NEXT FIELD axb05 END IF
          SELECT axb05 INTO tm.axb05 FROM axb_file
           WHERE axb01=tm.axb01 AND axb04=tm.axb04 AND axb05=tm.axb05
          IF STATUS THEN
             CALL cl_err3("sel","axb_file",tm.axb01,tm.axb04,STATUS,"","sel axb:",0)   # NO.FUN-660123
             NEXT FIELD axb05
          END IF
          DISPLAY BY NAME tm.axb05

#FUN-A90032 --Begin mark 
#        BEFORE FIELD a
#          IF cl_null(tm.rtype) THEN
#             CALL r007_set_entry() 
#          END IF 
#FUN-A90032 --End mark          
 
       AFTER FIELD a
          IF cl_null(tm.a) THEN NEXT FIELD a END IF
          CALL s_chkmai(tm.a,'RGL') RETURNING li_result                
          IF NOT li_result THEN
             CALL cl_err(tm.a,g_errno,1)
             NEXT FIELD a
          END IF
         #LET g_sql = "SELECT mai02,mai03 FROM ",g_dbs_axz03,"mai_file",  #FUN-A50102
          LET g_sql = "SELECT mai02,mai03 FROM ",cl_get_target_table(g_plant_new,'mai_file'), #FUN-A50102   
                      " WHERE mai01 = '",tm.a,"'",
                      #"   AND mai00 = '",tm.axb05,"'",     #MOD-A40008
                      "   AND mai00 = '",tm.b,"'",     #MOD-A40008    #TQC-B90053 mod
                      "   AND maiacti IN ('Y','y')"
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
          CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
          PREPARE r007_pre FROM g_sql
          DECLARE r007_cur CURSOR FOR r007_pre
          OPEN r007_cur
          FETCH r007_cur INTO g_mai02,g_mai03
          IF STATUS THEN
             CALL cl_err3("sel","mai_file",tm.a,"",STATUS,"","sel mai:",0)  # NO.FUN-660123
             NEXT FIELD a
         #No.TQC-C50042   ---start---   Add
          ELSE
             IF g_mai03 = '5' OR g_mai03 = '6' THEN
                CALL cl_err('','agl-268',0)
                NEXT FIELD a
             END IF
         #No.TQC-C50042   ---end---     Add
          END IF
           IF cl_null(tm.rtype) THEN
#FUN-A90032 --Begin           
#              IF g_mai03 = '2' THEN
#                 LET tm.bm = 0
#                 DISPLAY tm.bm TO bm 
#                 CALL cl_set_comp_entry("bm",FALSE)
#              END IF
#FUN-A90032 --End              
           END IF
 
       AFTER FIELD b
          IF cl_null(tm.b) THEN NEXT FIELD b END IF
#FUN-A30122 --------------------------mod start---------------------------------
          IF tm.b <> g_aaz641 THEN                                              
             CALL cl_err('','agl-965',0)                                        
             NEXT FIELD b
          END IF 
#         LET g_errno = ''
#         CALL r007_chk_bookno()
#         IF NOT cl_null(g_errno) THEN
#            CALL cl_err('',g_errno,0)
#            NEXT FIELD b
#         END IF
#        SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
#FUN-A30122 -------------------------mod end------------------------------------
         LET l_aaa05 = 0
         SELECT aaa05 INTO l_aaa05 FROM aaa_file 
          WHERE aaa01=tm.b
            AND aaaacti IN ('Y','y')
         LET tm.em = l_aaa05
         DISPLAY tm.em TO FORMONLY.em
 
       AFTER FIELD c
          IF cl_null(tm.c) OR tm.c NOT MATCHES "[YN]" THEN NEXT FIELD c END IF
 
       AFTER FIELD yy
          IF cl_null(tm.yy) OR tm.yy = 0 THEN NEXT FIELD yy END IF

#FUN-A90032 --Begin mark
#       AFTER FIELD bm
#          IF NOT cl_null(tm.bm) THEN
#             SELECT azm02 INTO g_azm.azm02 FROM azm_file
#               WHERE azm01 = tm.yy
#             IF g_azm.azm02 = 1 THEN
#                IF tm.bm > 12 OR tm.bm < 0 THEN #FUN-770069 需可包含期初
#                   CALL cl_err('','agl-020',0)
#                   NEXT FIELD bm
#                END IF
#             ELSE
#                IF tm.bm > 13 OR tm.bm < 0 THEN #FUN-770069 需可包含期初
#                   CALL cl_err('','agl-020',0)
#                   NEXT FIELD bm
#                END IF
#             END IF
#          END IF
#FUN-A90032 --End mark          
 
       AFTER FIELD em
          IF NOT cl_null(tm.em) THEN
             SELECT azm02 INTO g_azm.azm02 FROM azm_file
               WHERE azm01 = tm.yy
             IF g_azm.azm02 = 1 THEN
                IF tm.em > 12 OR tm.em < 0 THEN #FUN-770069 需可包含期初   #tm.em<1-->0
                   CALL cl_err('','agl-020',0)
                   NEXT FIELD em
                END IF
             ELSE
                IF tm.em > 13 OR tm.em < 0 THEN #FUN-770069 需可包含期初   #tm.em<1-->0
                   CALL cl_err('','agl-020',0)
                   NEXT FIELD em
                END IF
             END IF
          END IF
#          IF tm.bm > tm.em THEN CALL cl_err('','9011',0) NEXT FIELD bm END IF   #FUN-A90032 mark 
 
       AFTER FIELD d
          IF cl_null(tm.d) OR tm.d NOT MATCHES'[123]' THEN NEXT FIELD d END IF
 
       AFTER FIELD f
          IF cl_null(tm.f) OR tm.f < 0  THEN
             LET tm.f = 0 DISPLAY BY NAME tm.f NEXT FIELD f
          END IF
 
       AFTER FIELD more
          IF tm.more = 'Y' THEN
             CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies)
                  RETURNING g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies
          END IF
 
       AFTER INPUT 
          IF INT_FLAG THEN EXIT INPUT END IF
          IF cl_null(tm.yy) THEN
             LET l_sw = 0 
             DISPLAY BY NAME tm.yy 
             CALL cl_err('',9033,0)
          END IF
#FUN-A90032 --Begin          
#          IF cl_null(tm.bm) THEN
#             LET l_sw = 0 
#             DISPLAY BY NAME tm.bm 
#          END IF
#FUN-A90032 --End   
          #--FUN-A90032 start--
          IF NOT cl_null(tm.axa06) THEN
              CASE
                  WHEN tm.axa06 = '1'  #る 
                       LET tm.bm = 0
                 #CHI-B10030 add --start--
                  OTHERWISE      
                       CALL s_axz03_dbs(tm.axb04) RETURNING l_axz03 
                       CALL s_get_aznn01(l_axz03,tm.axa06,tm.axb05,tm.yy,tm.q1,tm.h1) RETURNING tm.em
                 #CHI-B10030 add --end--
              END CASE
          END IF
          #--FUN-A90032       
          IF cl_null(tm.em) THEN
             LET l_sw = 0 
             DISPLAY BY NAME tm.em 
          END IF
          IF tm.d = '1' THEN LET g_unit = 1       END IF
          IF tm.d = '2' THEN LET g_unit = 1000    END IF
          IF tm.d = '3' THEN LET g_unit = 1000000 END IF
          IF l_sw = 0 THEN 
             LET l_sw = 1 
             NEXT FIELD a
             CALL cl_err('',9033,0)
          END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()    # Command execution
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(a) 
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_mai01'          #FUN-930076 mod 
                LET g_qryparam.default1 = tm.a           #FUN-930076 mod
               #LET g_qryparam.arg1 = l_dbs              #FUN-930076 mod #MOD-B30067 mark
               #LET g_qryparam.where = "mai00 = '",tm.axb05,"'"      #MOD-A40008 
               #LET g_qryparam.where = "mai00 = '",tm.b,"'"           #TQC-B90053   #No.TQC-C50042   Mark
                LET g_qryparam.where = "mai00 = '",tm.b,"' AND mai03 NOT IN ('5','6')"  #No.TQC-C50042   Add
                CALL cl_create_qry() RETURNING tm.a 
                DISPLAY BY NAME tm.a
                NEXT FIELD a
             WHEN INFIELD(b) 
                SELECT axa02 INTO l_axa02 FROM axa_file,axb_file
                 WHERE axa01=axb01 AND axa02=axb02 AND axa03=axb03
                   AND axb01=tm.axb01 AND axb04=tm.axb04
                SELECT axz03 INTO g_plant_new FROM axz_file WHERE axz01=l_axa02
                CALL s_getdbs()
                LET g_dbs_axz03_1 = g_dbs_new
                IF NOT cl_null(g_dbs_axz03_1) THEN
                   LET l_length = LENGTH(g_dbs_axz03_1)                     #NO.FUN-930076
                         IF l_length >1 THEN                                    #NO.FUN-930076
                            LET  l_dbs1 = g_dbs_axz03_1.subSTRING(1,l_length-1)    #NO.FUN-930076
                         END IF                                                 #NO.FUN-930076
                ELSE
                   LET l_dbs1 = g_dbs
                END IF
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_aaa5'   #MOD-940202 mod q_aaa->q_aaa5
                LET g_qryparam.default1 = tm.b
                LET g_qryparam.arg1 = l_dbs1     #MOD-940202 add
                CALL cl_create_qry() RETURNING tm.b 
                DISPLAY BY NAME tm.b
                NEXT FIELD b
             WHEN INFIELD(axb01) 
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_axb1'
                LET g_qryparam.default1 = tm.axb01
                LET g_qryparam.default2 = tm.axb04
                LET g_qryparam.default3 = tm.axb05
                CALL cl_create_qry() RETURNING tm.axb01,tm.axb04,tm.axb05
                DISPLAY BY NAME tm.axb01,tm.axb04,tm.axb05
                NEXT FIELD axb01
          END CASE
 
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
    IF INT_FLAG THEN
       LET INT_FLAG = 0 CLOSE WINDOW r007_w 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
       EXIT PROGRAM
    END IF
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
              WHERE zz01='aglr007'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('aglr007','9031',1)   
       ELSE
          LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                          " '",g_bookno CLIPPED,"'" ,
                          " '",g_pdate CLIPPED,"'",
                          " '",g_towhom CLIPPED,"'",
                          " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                          " '",g_bgjob CLIPPED,"'",
                          " '",g_prtway CLIPPED,"'",
                          " '",g_copies CLIPPED,"'",
                          " '",tm.a CLIPPED,"'",
                          " '",tm.axb01 CLIPPED,"'",
                          " '",tm.yy CLIPPED,"'",
#                         " '",tm.bm CLIPPED,"'",    #FUN-A90032
                          " '",tm.axa06 CLIPPED,"'", #FUN-A90032
                          " '",tm.em CLIPPED,"'",
                          " '",tm.c CLIPPED,"'",
                          " '",tm.d CLIPPED,"'",
                          " '",tm.e CLIPPED,"'",                 #FUN-6C0012
                          " '",tm.f CLIPPED,"'" ,
                          " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                          " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                          " '",g_template CLIPPED,"'"            #No.FUN-570264
                         ," ,",tm.q1 CLIPPED,"'",                #FUN-A90032
                          " ,",tm.h1 CLIPPED,"'"                 #FUN-A90032
          CALL cl_cmdat('aglr007',g_time,l_cmd)    # Execute cmd at later time
       END IF
       CLOSE WINDOW r007_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
       EXIT PROGRAM
    END IF
    CALL cl_wait()
    CALL r007()
    ERROR ""
END WHILE
CLOSE WINDOW r007_w
END FUNCTION
 
FUNCTION r007()
   DEFINE l_name    LIKE type_file.chr20          # External(Disk) file name        #No.FUN-680098  VARCHAR(20) 
   DEFINE l_name1   LIKE type_file.chr20          # External(Disk) file name        #No.FUN-680098  VARCHAR(20) 
   DEFINE l_sql     LIKE type_file.chr1000        # RDSQL STATEMENT        #No.FUN-680098  VARCHAR(1000) 
   DEFINE l_chr     LIKE type_file.chr1           #No.FUN-680098  VARCHAR(1) 
   DEFINE l_axb02   LIKE axb_file.axb02
   DEFINE l_azi01   LIKE azi_file.azi01
   DEFINE sr     RECORD
       maj02     LIKE maj_file.maj02,     #No.FUN-680098  dec(9,2)
       maj03     LIKE maj_file.maj03,     #No.FUN-680098  VARCHAR(1) 
       maj04     LIKE maj_file.maj04,     #No.FUN-680098  smallint
       maj05     LIKE maj_file.maj05,     #No.FUN-680098  smallint
       maj07     LIKE maj_file.maj07,     #No.FUN-680098  VARCHAR(1) 
       maj09     LIKE maj_file.maj09,     #No.FUN-770069  add 10/19
       maj20     LIKE maj_file.maj20,     #No.FUN-680098  VARCHAR(30) 
       maj20e    LIKE maj_file.maj20e,    #No.FUN-680098  VARCHAR(30) 
       maj21     LIKE maj_file.maj21,     #No.FUN-680098  VARCHAR(24) 
       maj22     LIKE maj_file.maj22,     #No.FUN-680098  VARCHAR(24) 
       bal1      LIKE type_file.num20_6,  #記帳貨幣金額    #No.FUN-680098 decimal(20,6)
       bal4      LIKE type_file.num20_6,  #記帳貨幣調整金額   #FUN-B70066
       bal5      LIKE type_file.num20_6,  #記帳貨幣合計金額   #FUN-B70066
       #bal6      LIKE type_file.num20_6,  #記帳貨幣--借方  #FUN-B80166
       #bal7      LIKE type_file.num20_6,  #記帳貨幣--貸方  #FUN-B80166
       axe11     LIKE axe_file.axe11,     #再衡量匯率別    #No.FUN-680098 VARCHAR(1) 
      #rate      LIKE axp_file.axp06,     #再衡量匯率      #No.FUN-680098 decimal(20,10) #CHI-A80019 mark
       rate      LIKE axg_file.axg18,     #再衡量匯率      #CHI-A80019
       bal2      LIKE type_file.num20_6,  #功能貨幣金額    #No.FUN-680098 decimal(20,6)
       axe12     LIKE axe_file.axe12,     #換算匯率別      #No.FUN-680098 VARCHAR(1)
      #rate1     LIKE axp_file.axp05,     #換算匯率        #No.FUN-680098 decimal(20,10) #CHI-A80019 mark
       rate1     LIKE axg_file.axg19,     #換算匯率        #CHI-A80019
       bal3      LIKE type_file.num20_6   #合併貨幣金額    #No.FUN-680098 decimal(20,6)       
       END RECORD
   DEFINE t_azi07_1 LIKE azi_file.azi07  #No.FUN-870151
   SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = tm.b
      AND aaf02 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aglr007'
 
  #CASE WHEN tm.rtype='1' LET g_msg=" SUBSTRING(maj23,1,1)='1'"  #NO.FUN-750076 此寫法ORACLE不接受 #CHI-A70061 mark
  #     WHEN tm.rtype='2' LET g_msg=" SUBSTRING(maj23,1,1)='2'"  #NO.FUN-750076                    #CHI-A70061 mark
   CASE WHEN tm.rtype='1' LET g_msg=" maj23 like '1%'"  #CHI-A70061
        WHEN tm.rtype='2' LET g_msg=" maj23 like '2%'"  #CHI-A70061
        OTHERWISE LET g_msg = " 1=1"
   END CASE
   DROP TABLE r007_file
   CREATE TEMP TABLE r007_file(
    maj02 LIKE maj_file.maj02,     
    maj03 LIKE maj_file.maj03,     
    maj04 LIKE maj_file.maj04,     
    maj05 LIKE maj_file.maj05,     
    maj07 LIKE maj_file.maj07,     
    maj09 LIKE maj_file.maj09,   #FUN-770069 add 10/19
    maj20 LIKE maj_file.maj20,     
    maj20e LIKE maj_file.maj20e,   
    maj21 LIKE maj_file.maj21,     
    maj22 LIKE maj_file.maj22,     
    bal1  LIKE type_file.num20_6,  
    bal4  LIKE type_file.num20_6,   #FUN-B70066
    bal5  LIKE type_file.num20_6,   #FUN-B70066
    axe11 LIKE type_file.chr1,     
    rate  LIKE axg_file.axg18, #CHI-A80019 mod rate  LIKE type_file.num20_6,->rate  LIKE axg_file.axg18, 
    bal2  LIKE type_file.num20_6,  
    axe12 LIKE axe_file.axe12,     
    rate1 LIKE axg_file.axg19, #CHI-A80019 mod rate1 LIKE axp_file.axp05,->rate1 LIKE axg_file.axg19,    
    bal3  LIKE type_file.num20_6)  
 
  #LET l_sql = "SELECT * FROM ",g_dbs_axz03 CLIPPED,"maj_file",   #No.FUN-920199  #FUN-A50102
   LET l_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'maj_file'),   #FUN-A50102
               " WHERE maj01 = '",tm.a,"'",  #報表編號
               "   AND ",g_msg CLIPPED,
               " ORDER BY maj02"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql  #FUN-A50102
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql   #FUN-A50102
   PREPARE r007_p FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM 
   END IF
   DECLARE r007_c CURSOR FOR r007_p
 
   LET g_i = 1 FOR g_i = 1 TO 100 LET g_tot1[g_i] = 0 END FOR
   LET g_i = 1 FOR g_i = 1 TO 100 LET g_tot2[g_i] = 0 END FOR
   LET g_i = 1 FOR g_i = 1 TO 100 LET g_tot3[g_i] = 0 END FOR
   LET g_i = 1 FOR g_i = 1 TO 100 LET g_tot4[g_i] = 0 END FOR   #FUN-B70066
   LET g_i = 1 FOR g_i = 1 TO 100 LET g_tot5[g_i] = 0 END FOR   #FUN-B70066
   #LET g_i = 1 FOR g_i = 1 TO 100 LET g_tot6[g_i] = 0 END FOR   #FUN-B80166
   #LET g_i = 1 FOR g_i = 1 TO 100 LET g_tot7[g_i] = 0 END FOR   #FUN-B80166
   LET g_mm = tm.em
 
   LET g_str=''                                     #No.FUN-760083
   CALL cl_del_data(l_table)                        #No.FUN-760083
   LET g_pageno = 0
 
   LET sr.bal1 = 0 
   LET sr.bal2 = 0
   LET sr.bal3 = 0
   LET sr.bal4 = 0  #FUN-B70066
   LET sr.bal5 = 0  #FUN-B70066
   #LET sr.bal6 = 0   #FUN-B80166
   #LET sr.bal7 = 0   #FUN-B80166
  #--FUN-C50079 start-- 如果找的是中間層母公司自己合併前的資料，那就要以tm.axb02為值
   IF tm.axb02 = tm.axb04 THEN
       LET g_axb02 = tm.axb02
       LET g_axb03 = tm.axb03
   ELSE
  #--FUN-C50079 end--
     #SELECT axb02 INTO l_axb02                 #MOD-BB0128 mark
      SELECT axb02,axb03 INTO g_axb02,g_axb03   #MOD-BB0128 add
        FROM axb_file
       WHERE axb01 = tm.axb01
         AND axb04 = tm.axb04
         AND axb05 = tm.axb05
   END IF   #FUN-C50079 add
  #SELECT * INTO g_axz_u.* FROM axz_file WHERE axz01= l_axb02   #上層公司  #MOD-BB0244 mark
   SELECT * INTO g_axz_u.* FROM axz_file WHERE axz01= g_axb02   #上層公司  #MOD-BB0244 add
   IF SQLCA.sqlcode THEN
     #CALL cl_err3("sel","axz_file",l_axb02,"",SQLCA.sqlcode,"","",0)   #No.FUN-660123 #MOD-BB0244 mark
      CALL cl_err3("sel","axz_file",g_axb02,"",SQLCA.sqlcode,"","",0)   #MOD-BB0244 add
      CALL ui.Interface.refresh()           #MOD-AB0200
   END IF
   
   SELECT * INTO g_axz_d.* FROM axz_file WHERE axz01= tm.axb04  #下層公司
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","axz_file",tm.axb04,"",SQLCA.sqlcode,"","",0)   #No.FUN-660123
      CALL ui.Interface.refresh()           #MOD-AB0200
   END IF
 
   #依族群及下層公司到agli009找出對應的記帳貨幣/功能貨幣/上層公司記帳貨幣
   SELECT axz06 INTO l_azi01 FROM axz_file WHERE axz01 = tm.axb04
   IF NOT cl_null(l_azi01) THEN
      SELECT azi02 INTO g_azi02_1 FROM azi_file WHERE azi01 = l_azi01
   END IF
   SELECT azi02 INTO g_azi02_2 FROM azi_file WHERE azi01 = g_axz_d.axz07
   SELECT azi02 INTO g_azi02_3 FROM azi_file WHERE azi01 = g_axz_u.axz06
   SELECT azi07 INTO t_azi07 FROM azi_file WHERE azi01= l_azi01
   SELECT azi07 INTO t_azi07_1 FROM azi_file WHERE azi01= g_axz_d.axz07
 
   CALL r007_process()
 
   DECLARE tmp_curs CURSOR FOR
      SELECT * FROM r007_file ORDER BY maj02
   IF STATUS THEN CALL cl_err('tmp_curs',STATUS,1) END IF
   FOREACH tmp_curs INTO sr.*
      IF STATUS THEN CALL cl_err('tmp_curs',STATUS,1) EXIT FOREACH END IF
 
      IF sr.maj07='2' OR (sr.maj07 = '1' AND sr.maj09 = '-') THEN  #FUN-760053   #FUN-770069      10/19
          LET sr.bal1=sr.bal1*-1 
          LET sr.bal2=sr.bal2*-1 
          LET sr.bal3=sr.bal3*-1 
          LET sr.bal4=sr.bal4*-1     #FUN-B70066
          LET sr.bal5=sr.bal5*-1     #FUN-B70066
          #LET sr.bal6=sr.bal6*-1     #FUN-B80166
          #LET sr.bal7=sr.bal7*-1     #FUN-B80166
      END IF
 
      IF tm.d MATCHES '[23]' THEN             #換算金額單位
         IF g_unit!=0 THEN
            LET sr.bal1 = sr.bal1 / g_unit    #實際
            LET sr.bal2 = sr.bal2 / g_unit    #實際
            LET sr.bal3 = sr.bal3 / g_unit    #實際
            LET sr.bal4 = sr.bal4 / g_unit    #FUN-B70066 #實際
            LET sr.bal5 = sr.bal5 / g_unit    #FUN-B70066 #實際
         ELSE
            LET sr.bal1 = 0
            LET sr.bal2 = 0
            LET sr.bal3 = 0
            LET sr.bal4 = 0  #FUN-B70066
            LET sr.baL5 = 0  #FUN-B70066
         END IF
      END IF
 
      EXECUTE insert_prep USING
         sr.maj02,sr.maj03,sr.maj04,sr.maj05,sr.maj07,sr.maj20,sr.maj20e,
        #sr.maj21,sr.maj22,'2',sr.bal1,sr.axe11,sr.rate,sr.bal2,sr.axe12,                 #FUN-B70066 mark   #CHI-A70061 add '2'
         sr.maj21,sr.maj22,'2',sr.bal1,sr.bal4,sr.bal5,sr.axe11,sr.rate,sr.bal2,sr.axe12, #FUN-B80166 mark   #FUN-B70066 
         #sr.maj21,sr.maj22,'2',sr.bal1,sr.bal4,sr.bal5,sr.bal6,sr.bal7,sr.axe11,sr.rate,sr.bal2,sr.axe12,    #FUN-B80166
         sr.rate1,sr.bal3
        ,t_azi07,t_azi07_1  #No.FUN-870151

     #CHI-A70061 add --start--
     IF sr.maj04 > 0 THEN
        #空行的部份,以寫入同樣的maj20資料列進Temptable,
        #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,
        #讓空行的這筆資料排在正常的資料前面印出
        FOR i = 1 TO sr.maj04
           EXECUTE insert_prep USING
                   sr.maj02,sr.maj03,sr.maj04,sr.maj05,sr.maj07,sr.maj20,sr.maj20e,
                  #sr.maj21,sr.maj22,'1',sr.bal1,sr.axe11,sr.rate,sr.bal2,sr.axe12,                  #MOD-B80279 mark
                   sr.maj21,sr.maj22,'1',sr.bal1,sr.bal4,sr.bal5,sr.axe11,sr.rate,sr.bal2,sr.axe12,  #FUN-B80166 mark #MOD-B80279
                   #sr.maj21,sr.maj22,'1',sr.bal1,sr.bal4,sr.bal5,sr.bal6,sr.bal7,                    #FUN-B80166
                   #sr.axe11,sr.rate,sr.bal2,sr.axe12,                                                #FUN-B80166
                   sr.rate1,sr.bal3,t_azi07,t_azi07_1
           IF STATUS THEN
              CALL cl_err("execute insert_prep:",STATUS,1)
              EXIT FOR
           END IF
        END FOR
     END IF
     #CHI-A70061 add --end--
 
      INITIALIZE sr.* TO NULL 
   END FOREACH
   IF tm.e='Y' THEN                               #No.FUN-760083
      LET l_name = 'aglr007_1'                      #No.FUN-760083
   ELSE                                           #No.FUN-760083
      LET l_name = 'aglr007'                    #No.FUN-760083
   END IF                                         #No.FUN-760083
 
   LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #No.FUN-760083
   LET g_str=tm.d,';',g_aaz.aaz77,';',g_mai02,';',tm.a,';',tm.yy,';',
             tm.bm,';',tm.em,';',g_azi02_1,';',g_azi02_2,';',g_azi02_3,';',
             tm.e,";",'',";",         #FUN-770069 add tm.ver #FUN-950048 
             tm.axb04,";",g_axz_d.axz02   #FUN-770069 add 10/19
   CALL cl_prt_cs3("aglr007",l_name,g_sql,g_str)      #No.FUN-760083
END FUNCTION
 
FUNCTION r007_process()
   DEFINE l_sql         LIKE type_file.chr1000 #RDSQL STATEMENT        #No.FUN-680098  VARCHAR(1000) 
   DEFINE l_sql1        LIKE type_file.chr1000 #FUN-B70066 
   DEFINE l_axp05       LIKE axp_file.axp05    #FUN-770069 add
   DEFINE l_axp06       LIKE axp_file.axp06    #FUN-770069 add
   DEFINE l_axp07       LIKE axp_file.axp07    #FUN-770069 add
   DEFINE l_axp08       LIKE axp_file.axp08
   DEFINE l_axp09       LIKE axp_file.axp09
   DEFINE l_axg05       LIKE axg_file.axg05
   DEFINE l_axg06       LIKE axg_file.axg06
   DEFINE l_axg07       LIKE axg_file.axg07
   DEFINE l_amt1        LIKE type_file.num20_6  #FUN-B70066
   DEFINE l_amt2        LIKE type_file.num20_6  #FUN-B70066
   DEFINE sr  RECORD
               bal1     LIKE aah_file.aah04,   #記帳貨幣金額  #No.FUN-680098 decimal(20,6)
               bal4     LIKE aah_file.aah04,   #記帳貨幣調整金額  #FUN-B70066
               bal5     LIKE aah_file.aah04,   #記帳貨幣合計金額  #FUN-B70066
               #bal6     LIKE aah_file.aah04,   #記帳貨幣金額-借   #FUN-B80166
               #bal7     LIKE aah_file.aah04,   #記帳貨幣金額-貸   #FUN-B80166
               axe11    LIKE axe_file.axe11,   #再衡量匯率別  #No.FUN-680098   VARCHAR(1) 
              #rate     LIKE axp_file.axp06,   #再衡量匯率    #No.FUN-680098 decimal(20,10) #CHI-A80019 mark
               rate     LIKE axg_file.axg18,   #再衡量匯率    #CHI-A80019
               bal2     LIKE type_file.num20_6,#功能貨幣金額  #No.FUN-680098 decimal(20,6)
               axe12    LIKE axe_file.axe12,   #換算匯率別    #No.FUN-680098  VARCHAR(1) 
              #rate1    LIKE axp_file.axp05,   #換算匯率      #No.FUN-680098 decimal(20,10) #CHI-A80019 mark
               rate1    LIKE axg_file.axg19,   #換算匯率      #CHI-A80019
               bal3     LIKE type_file.num20_6 #合併貨幣金額  #No.FUN-680098  decimal(20,6)        
              END RECORD
   DEFINE l_bm          LIKE type_file.num5    #MOD-A40008
   DEFINE l_cnt         LIKE type_file.num5    #MOD-A50184 add
   DEFINE l_axj06       LIKE axj_file.axj06    #CHI-C60024
   DEFINE l_axj07       LIKE axj_file.axj07    #CHI-C60024
   #--FUN-C50079 start--
    IF tm.axb02 = tm.axb04 THEN
        SELECT axz06 INTO g_axz06
          FROM axz_file
         WHERE axz01 = tm.axb04
    ELSE
   #--FUN-C50079 end--
      #MOD-A50018---add---start---
       SELECT axz06 INTO g_axz06 FROM axz_file
        WHERE axz01 = ( SELECT axb02 FROM axb_file 
                         WHERE axb01 = tm.axb01 
                           AND axb05 = tm.axb05 AND axb04 = tm.axb04)
      #MOD-A50018---add---end---
   END IF    #FUN-C50079 add
    LET l_sql = "SELECT '',SUM(axg08-axg09),SUM(axg13-axg14),",
                "       SUM(axg15-axg16) ",  #NO.FUN-750076
                #"      ,SUM(axg08),SUM(axg09)",    #FUN-B80166
                "  FROM axg_file ",
                " WHERE axg00 = ? ",
                "   AND axg05 BETWEEN ? AND ? ",
                "   AND axg06 = ? ",
               #"   AND axg07 BETWEEN ? AND ? ",                  #FUN-A90032 mark
                "   AND axg07 = ? ", #FUN-A90032
                "   AND axg01 ='",tm.axb01,"' ",
                "   AND axg04 ='",tm.axb04,"' ",
                "   AND axg041='",tm.axb05,"' ",
                "   AND axg12 = '",g_axz06,"'",                   #FUN-930117
                "   AND axg02 = '",g_axb02,"'",                   #MOD-BB0128 add
                "   AND axg03 = '",g_axb03,"'"                    #MOD-BB0128 add 

    PREPARE r007_axg_p FROM l_sql
    DECLARE r007_axg_c CURSOR FOR r007_axg_p
    IF STATUS THEN CALL cl_err('axg prepare',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
       EXIT PROGRAM 
    END IF
   #FUN-B70066--begin--
    LET l_sql1= " SELECT SUM(axj07)",
                " FROM axi_file,axj_file,aag_file",
                " WHERE axi00 = axj00 ",
                "   AND axi01 = axj01 ",
                "   AND axi00 = ? ",
                "   AND axj03 BETWEEN ? AND ? ",
                "   AND axj06 = ? ",        #MOD-BC0144
                "   AND axi03 = '",tm.yy,"'",
                "   AND axi04 = '",tm.em,"'",
                "   AND axi08 = '1'",
                "   AND axi05 = '",tm.axb01,"'",
                "   AND axi06 = '",tm.axb04,"'",
                "   AND axi09 = 'N'",
                "   AND axiconf = 'Y'",
                "   AND aag00 = axj00 ",
                "   AND aag01 = axj03 "
    PREPARE r007_axg_p1 FROM l_sql1
   #DECLARE r007_axg_c1 CURSOR FOR r007_axg_p1           #MOD-BC0144 mark
    DECLARE r007_axg_c1 SCROLL CURSOR FOR r007_axg_p1    #MOD-BC0144
    IF STATUS THEN CALL cl_err('axg prepare',STATUS,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       EXIT PROGRAM
    END IF
   #FUN-B70066---end---
   #-MOD-A40008-add- 
    IF tm.rtype = '1' THEN  
       LET l_bm = tm.bm 
       LET tm.bm = tm.em 
    END IF
   #-MOD-A40008-end- 
    FOREACH r007_c INTO maj.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_amt1 = 0
       LET g_amt2 = 0
       LET g_amt3 = 0
       LET g_amt4 = 0  #FUN-B70066
       LET g_amt41 = 0 #MOD-BC0144 
       LET g_amt42 = 0 #MOD-BC0144
       LET g_amt5 = 0  #FUN-B70066
       #LET g_amt6 = 0   #FUN-B80166
       #LET g_amt7 = 0   #FUN-B80166
       IF NOT cl_null(maj.maj21) THEN
          LET g_amt1 = 0
          LET g_amt2 = 0 
          LET g_amt3 = 0
          LET g_amt4 = 0  #FUN-B70066
          LET g_amt41 = 0 #MOD-BC0144 
          LET g_amt42 = 0 #MOD-BC0144
          LET g_amt5 = 0  #FUN-B70066
          #LET g_amt6 = 0   #FUN-B80166
          #LET g_amt7 = 0   #FUN-B80166
#         OPEN r007_axg_c USING tm.b,maj.maj21,maj.maj22,tm.yy,tm.bm,tm.em #FUN-A90032 mark
          OPEN r007_axg_c USING tm.b,maj.maj21,maj.maj22,tm.yy,tm.em #FUN-A90032
         #FETCH r007_axg_c INTO l_axg05,g_amt3,g_amt1,g_amt2  #FUN-B70066
          FETCH r007_axg_c INTO l_axg05,g_amt3,g_amt5,g_amt2  #FUN-B80166    #FUN-B70066
          #FETCH r007_axg_c INTO l_axg05,g_amt3,g_amt5,g_amt2,g_amt6,g_amt7	 #FUN-B80166
          IF STATUS THEN
             LET l_axg05=''
             LET l_axg06=''
             LET l_axg07=''
             LET g_amt3=0
            #LET g_amt1=0  #FUN-B70066
             LET g_amt2=0
             LET g_amt5=0  #FUN-B70066
          ELSE
             LET l_axg05=maj.maj21   #FUN-770069
          END IF                     #FUN-770069
         #---------------MOD-C90087-------(S)
          LET l_cnt = 0
          SELECT COUNT(*) INTO l_cnt    #大於0表示為中間層公司
            FROM axb_file
          WHERE axb01 = tm.axb01
            AND axb02 = tm.axb04
          IF cl_null(l_cnt) THEN
             LET l_cnt = 0
          END IF
         #---------------MOD-C90087-------(E)
          IF tm.axb02 = tm.axb04 OR l_cnt = 0 THEN                            #MOD-C90087 add
            #FUN-B70066--begin--
             OPEN r007_axg_c1 USING tm.b,maj.maj21,maj.maj22,'1' #MOD-BC0144 add '1'
             FETCH r007_axg_c1 INTO g_amt41                      #MOD-BC0144 mod g_amt4 -> g_amt41             
            #-MOD-BC0144-add-
             CLOSE r007_axg_c1
             IF cl_null(g_amt41) THEN LET g_amt41 = 0 END IF 
             OPEN r007_axg_c1 USING tm.b,maj.maj21,maj.maj22,'2' 
             FETCH r007_axg_c1 INTO g_amt42                    
             CLOSE r007_axg_c1
             IF cl_null(g_amt42) THEN LET g_amt42 = 0 END IF 
             LET g_amt4 = g_amt41 - g_amt42              
            #-MOD-BC0144-end-
             IF STATUS THEN
                LET g_amt1=0
                LET g_amt4=0
             END IF
            #FUN-B70066---end---
          END IF                                                 #MOD-C90087 add
          IF cl_null(g_amt1) THEN LET g_amt1=0 END IF
          IF cl_null(g_amt2) THEN LET g_amt2=0 END IF
          IF cl_null(g_amt3) THEN LET g_amt3=0 END IF
          IF cl_null(g_amt4) THEN LET g_amt4=0 END IF  #FUN-B70066
          IF cl_null(g_amt5) THEN LET g_amt5=0 END IF  #FUN-B70066
          #IF cl_null(g_amt6) THEN LET g_amt6=0 END IF  #FUN-B80166
          #IF cl_null(g_amt7) THEN LET g_amt7=0 END IF  #FUN-B80166
          LET g_amt1 = g_amt5-g_amt4
         #DISPLAY l_axg05,' ',g_amt3,g_amt1,g_amt2
          DISPLAY l_axg05,' ',g_amt3,g_amt1,g_amt2,g_amt4,g_amt5  #FUN-B70066
       END IF
       #依子公司科目到agli001對照找出「再衡量匯率別」/「換算匯率類別」
       SELECT DISTINCT axe11,axe12 INTO sr.axe11,sr.axe12   #MOD-740257 add DISTINCT
         FROM axe_file
        WHERE axe01=tm.axb04        #公司名稱
          AND axe06=l_axg05         #科目名稱
          AND axe13=tm.axb01        #族群代號  #FUN-910001 add
       IF SQLCA.sqlcode THEN
          CALL cl_err3("sel","axe_file",tm.axb04,l_axg05,SQLCA.sqlcode,"","",0)   #No.FUN-660123
          LET sr.axe11 = ''   #MOD-660034
          LET sr.axe12 = ''   #MOD-660034
          CALL ui.Interface.refresh()           #MOD-AB0200
       END IF
       
     #CHI-A80019 mark --start--
     # #依agli008得到再衡量/換算匯率
     ##MOD-A50184---add---start---
     # LET l_cnt = 0 
     # SELECT count(*) INTO l_cnt         
     #   FROM axp_file
     #  WHERE axp01=tm.yy         AND axp02=tm.em
     #    AND axp03=g_axz_d.axz06 AND axp04=g_axz_d.axz07
     # IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
     # LET l_axp05=NULL     
     # LET l_axp06=NULL     
     # LET l_axp07=NULL     
     # IF l_cnt > 1 THEN   
     ##MOD-A50184---add---end---
     # ###再衡量匯率
     #    SELECT axp05,axp06,axp07 INTO l_axp05,l_axp06,l_axp07
     #      FROM axp_file
     #     WHERE axp01=tm.yy         AND axp02=tm.em
     #       AND axp03=g_axz_d.axz06 AND axp04=g_axz_d.axz07
     #    CASE
     #       WHEN sr.axe11='1'   #1.現時匯率
     #          LET sr.rate=l_axp05
     #       WHEN sr.axe11='2'   #2.歷史匯率
     #          LET sr.rate=l_axp06
     #       WHEN sr.axe11='3'   #3.平均匯率
     #          LET sr.rate=l_axp07
     #       OTHERWISE
     #          LET sr.rate=1
     #    END CASE
     # END IF    #MOD-A50184 add
     ##TQC-A50028---add---start---
     # IF g_axz_d.axz07 = g_axz_d.axz06 THEN
     #    LET sr.rate = 1
     # END IF
     ##TQC-A50028---add---end---
     # 
     ##-MOD-A70181-add-
     # LET l_cnt = 0 
     # SELECT count(*) INTO l_cnt         
     #   FROM axp_file
     #  WHERE axp01=tm.yy         AND axp02=tm.em
     #    AND axp03=g_axz_d.axz07 AND axp04=g_axz_u.axz06
     # IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
     # LET l_axp05=NULL     
     # LET l_axp06=NULL     
     # LET l_axp07=NULL     
     # IF l_cnt > 1 THEN   
     ##-MOD-A70181-end-
     #    ###換算匯率
     #    SELECT axp05,axp06,axp07 INTO l_axp05,l_axp06,l_axp07
     #      FROM axp_file
     #     WHERE axp01=tm.yy         AND axp02=tm.em
     #       AND axp03=g_axz_d.axz07 AND axp04=g_axz_u.axz06
     #    CASE
     #       WHEN sr.axe12='1'   #1.現時匯率
     #          LET sr.rate1=l_axp05
     #       WHEN sr.axe12='2'   #2.歷史匯率
     #          LET sr.rate1=l_axp06
     #       WHEN sr.axe12='3'   #3.平均匯率
     #          LET sr.rate1=l_axp07
     #       OTHERWISE
     #          LET sr.rate1=1
     #    END CASE
     # END IF                                    #MOD-A70181
     #CHI-A80019 mark --end--
     #CHI-A80019 add --start--
       SELECT axg18,axg19 INTO sr.rate,sr.rate1
         FROM axg_file 
        WHERE axg00 = tm.b 
          AND axg01 = tm.axb01
          AND axg04 = tm.axb04
          AND axg041= tm.axb05
          AND axg05 BETWEEN maj.maj21 AND maj.maj22 
          AND axg06 = tm.yy 
#         AND axg07 BETWEEN tm.bm AND tm.em #FUN-A90032
          AND axg07 = tm.em                 #FUN-A90032
          AND axg12 = g_axz06
          AND axg02 = g_axb02               #MOD-BB0128 add
          AND axg03 = g_axb03               #MOD-BB0128 add
     #CHI-A80019 add --end--
       IF cl_null(sr.rate)  THEN LET sr.rate = 1 END IF   
       IF cl_null(sr.rate1) THEN LET sr.rate1 = 1 END IF   
     #FUN-B70066--begin--
     #累積換算調整數(g_aaz.aaz87)要另外抓分錄(axj_file)裡的金額來show
       IF maj.maj21 = g_aaz.aaz87 OR maj.maj22 = g_aaz.aaz87 THEN
          SELECT SUM(axj07) INTO l_amt1 FROM axi_file,axj_file
          WHERE axi01=axj01 AND axi03=tm.yy
            AND axi04 = tm.em
            AND axj03 BETWEEN maj.maj21 AND maj.maj22 AND axj06='1'
           #AND axi05=tm.axb01 AND axi06=tm.axb04        #MOD-B90062 mark
            AND axi05=tm.axb01 AND axi06=g_axz_u.axz01   #MOD-B90062
            AND axj05=g_axz_d.axz08                      #MOD-B90062
            AND axi00=tm.b
            AND axi00=axj00
            AND axiconf ='Y'
            AND axi09 ='Y'
            AND axi08 ='2'
         IF cl_null(l_amt1) THEN LET l_amt1=0 END IF
 
         SELECT SUM(axj07) INTO l_amt2 FROM axi_file,axj_file
          WHERE axi01=axj01 AND axi03=tm.yy
            AND axi04 = tm.em
            AND axj03 BETWEEN maj.maj21 AND maj.maj22 AND axj06='2'
           #AND axi05=tm.axb01 AND axi06=tm.axb04        #MOD-B90062 mark
            AND axi05=tm.axb01 AND axi06=g_axz_u.axz01   #MOD-B90062
            AND axj05=g_axz_d.axz08                      #MOD-B90062
            AND axi00=tm.b
            AND axi00=axj00
            AND axiconf ='Y'
            AND axi09 ='Y'
            AND axi08 ='2'
         IF cl_null(l_amt2) THEN LET l_amt2=0 END IF
        #----------------------No.MOD-B90085----------start
        #LET g_amt3 = l_amt1-l_amt2
        #LET g_amt1 = 0
        #LET g_amt2 = 0
        #LET g_amt4 = 0
        #LET g_amt5 = 0
        #LET sr.rate  =" "
        #LET sr.rate1 =" "
        #LET sr.axe11 =" "
        #LET sr.axe12 =" "
         LET g_amt3 = g_amt3+(l_amt1-l_amt2)
        #----------------------No.MOD-B90085----------end
          #--CHI-C60024 start--
          #取出在換匯分錄中和本期損益相同金額的累換金額，如為貸方則扣除，借方則加回
          LET l_sql = "SELECT axj06,axj07 FROM axi_file,axj_file ",
                      " WHERE axi01=axj01 ",
                      "   AND axi03='",tm.yy,"'",
                      "   AND axi04='",tm.em,"'",  
                      "   AND axj03 BETWEEN '",maj.maj21,"' AND '",maj.maj22,"'",
                      "   AND axi06='",g_axz_u.axz01,"'",   
                      "   AND axi00='",tm.b,"'",
                      "   AND axi00=axj00",  
                      "   AND axiconf ='Y'",
                      "   AND axi09 ='Y'", 
                      "   AND axi08 ='2'" 
          PREPARE r007_axj_p1 FROM l_sql
          DECLARE r007_axj_c1 SCROLL CURSOR FOR r007_axj_p1 
          IF STATUS THEN CALL cl_err('axg prepare',STATUS,1) 
             CALL cl_used(g_prog,g_time,2) RETURNING g_time
             EXIT PROGRAM 
          END IF
          FOREACH r007_axj_c1 INTO l_axj06,l_axj07
             IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
             LET l_cnt = 0
             IF l_axj06 = '1' THEN 
                 SELECT COUNT(*) INTO l_cnt  
                   FROM axi_file,axj_file
                  WHERE axi01=axj01
                    AND axi03=tm.yy
                    AND axi04=tm.em
                    AND axj03=g_aaz.aaz114   #本期損益BS
                    AND axj05=g_axz_d.axz08  #MOD-D30208
                    AND axi06=g_axz_u.axz01
                    AND axi00=tm.b
                    AND axi00=axj00
                    AND axiconf='Y'
                    AND axi09 ='Y'
                    AND axi08 ='2'
                    AND axj06 ='2'
                    AND axj07 = l_axj07      #金額
                 IF l_cnt > 0 THEN
                     LET g_amt3 = g_amt3 + l_axj07
                 END IF 
             ELSE
                 SELECT COUNT(*) INTO l_cnt  
                   FROM axi_file,axj_file
                  WHERE axi01=axj01
                    AND axi03=tm.yy
                    AND axi04=tm.em
                    AND axj03=g_aaz.aaz114   #本期損益BS
                    AND axj05=g_axz_d.axz08  #MOD-D30208
                    AND axi06=g_axz_u.axz01
                    AND axi00=tm.b
                    AND axi00=axj00
                    AND axiconf='Y'
                    AND axi09 ='Y'
                    AND axi08 ='2'
                    AND axj06 ='1'
                    AND axj07 = l_axj07      #金額
                 IF l_cnt > 0 THEN
                     LET g_amt3 = g_amt3 - l_axj07
                 END IF 
             END IF
          END FOREACH
          #--CHI-C60024 end---
       END IF
       #FUN-B70066---end---
      #--CHI-C60024 start--
       IF maj.maj21 = g_aaz.aaz114 OR maj.maj22 = g_aaz.aaz114 THEN
          LET l_amt1 = 0
          SELECT SUM(axj07) INTO l_amt1 FROM axi_file,axj_file
           WHERE axi01=axj01 AND axi03=tm.yy
             AND axi04 = tm.em  
             AND axj03 BETWEEN maj.maj21 AND maj.maj22 AND axj06='1'
             AND axi05=tm.axb01 AND axi06=g_axz_u.axz01   
             AND axj05=g_axz_d.axz08                     
             AND axi00=tm.b
             AND axi00=axj00  
             AND axiconf ='Y'
             AND axi09 ='Y' 
             AND axi08 ='2'    
          IF cl_null(l_amt1) THEN LET l_amt1=0 END IF
             
          LET l_amt2 = 0
          SELECT SUM(axj07) INTO l_amt2 FROM axi_file,axj_file
           WHERE axi01=axj01 AND axi03=tm.yy
             AND axi04 = tm.em  
             AND axj03 BETWEEN maj.maj21 AND maj.maj22 AND axj06='2'
             AND axi05=tm.axb01 AND axi06=g_axz_u.axz01  
             AND axj05=g_axz_d.axz08                      
             AND axi00=tm.b
             AND axi00=axj00  
             AND axiconf ='Y'
             AND axi09 ='Y' 
             AND axi08 ='2'    
          IF cl_null(l_amt2) THEN LET l_amt2=0 END IF
          LET g_amt3 = g_amt3+(l_amt1-l_amt2)
       END IF
       #--CHI-C60024 end--------
       #-->合計階數處理
       IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0 THEN
          FOR i = 1 TO 100 
             #CHI-A70050---modify---start---
             #LET g_tot1[i]=g_tot1[i]+g_amt1
             #LET g_tot2[i]=g_tot2[i]+g_amt2 
             #LET g_tot3[i]=g_tot3[i]+g_amt3 
              IF maj.maj09 = '-' THEN
                 LET g_tot1[i] = g_tot1[i] - g_amt1
                 LET g_tot2[i] = g_tot2[i] - g_amt2 
                 LET g_tot3[i] = g_tot3[i] - g_amt3 
                 LET g_tot4[i] = g_tot4[i] - g_amt4   #FUN-B70066 
                 LET g_tot5[i] = g_tot5[i] - g_amt5   #FUN-B70066
                 #LET g_tot6[i] = g_tot6[i] - g_amt6   #FUN-B80166
                 #LET g_tot7[i] = g_tot7[i] - g_amt7   #FUN-B80166
              ELSE
                 LET g_tot1[i] = g_tot1[i] + g_amt1
                 LET g_tot2[i] = g_tot2[i] + g_amt2 
                 LET g_tot3[i] = g_tot3[i] + g_amt3 
                 LET g_tot4[i] = g_tot4[i] + g_amt4   #FUN-B70066
                 LET g_tot5[i] = g_tot5[i] + g_amt5   #FUN-B70066
                 #LET g_tot6[i] = g_tot6[i] + g_amt6   #FUN-B80166
                 #LET g_tot7[i] = g_tot7[i] + g_amt7   #FUN-B80166
              END IF
             #CHI-A70050---modify---end---
          END FOR
          LET k=maj.maj08  
          LET sr.bal1=g_tot1[k]
          LET sr.bal2=g_tot2[k]
          LET sr.bal3=g_tot3[k]
          LET sr.bal4=g_tot4[k]     #FUN-B70066
          LET sr.bal5=g_tot5[k]     #FUN-B70066
          #LET sr.bal6=g_tot6[k]     #FUN-B80166
          #LET sr.bal7=g_tot7[k]     #FUN-B80166
         #CHI-A70050---add---start---
          IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
             LET sr.bal1 = sr.bal1 *-1
             LET sr.bal2 = sr.bal2 *-1
             LET sr.bal3 = sr.bal3 *-1
             LET sr.bal4 = sr.bal4 *-1   #FUN-B70066
             LET sr.bal5 = sr.bal5 *-1   #FUN-B70066
             #LET sr.bal6 = sr.bal6 *-1   #FUN-B80166
             #LET sr.bal7 = sr.bal7 *-1   #FUN-B80166
          END IF
         #CHI-A70050---add---end---
          FOR i = 1 TO maj.maj08 
             LET g_tot1[i]=0 
             LET g_tot2[i]=0
             LET g_tot3[i]=0 
             LET g_tot4[i]=0   #FUN-B70066
             LET g_tot5[i]=0   #FUN-B70066
             #LET g_tot6[i]=0   #FUN-B80166
             #LET g_tot7[i]=0   #FUN-B80166
          END FOR
       ELSE
          IF maj.maj03='5' THEN
             LET sr.bal1=g_amt1
             LET sr.bal2=g_amt2
             LET sr.bal3=g_amt3
             LET sr.bal4=g_amt4   #FUN-B70066
             LET sr.bal5=g_amt5   #FUN-B70066
             #LET sr.bal6=g_amt6   #FUN-B80166
             #LET sr.bal7=g_amt7   #FUN-B80166
          ELSE 
             LET sr.bal1=NULL
             LET sr.bal2=NULL
             LET sr.bal3=NULL
             LET sr.bal4=NULL     #FUN-B70066
             LET sr.bal5=NULL     #FUN-B70066
             #LET sr.bal6=NULL     #FUN-B80166
             #LET sr.bal7=NULL     #FUN-B80166
             LET sr.rate=NULL     #MOD-A50184 add
             LET sr.rate1=NULL    #MOD-A50184 add
          END IF
       END IF
       IF maj.maj03='0' THEN CONTINUE FOREACH END IF #本行不印出
       #-->最小階數起列印
       IF tm.f>0 AND maj.maj08 < tm.f THEN CONTINUE FOREACH END IF
       #-->餘額為 0 者不列印
       IF (tm.c='N' OR maj.maj03='2') AND
          maj.maj03 MATCHES "[0125]" AND
      #   sr.bal1=0 THEN                                                           #MOD-B80279 mark
          sr.bal1=0 AND sr.bal2=0 AND sr.bal3=0 AND sr.bal4=0 AND sr.bal5=0 THEN   #MOD-B80279 mod
          CONTINUE FOREACH
       END IF
       INSERT INTO r007_file VALUES(maj.maj02,maj.maj03,maj.maj04,
                                    maj.maj05,maj.maj07,maj.maj09,   #FUN-770069 add maj.maj09 10/19
                                    maj.maj20,maj.maj20e,
                                    maj.maj21,maj.maj22,sr.*)
       IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err3("ins","r007_file",maj.maj02,maj.maj03,SQLCA.sqlcode,"","ins r007_file",1)   #No.FUN-660123
          CALL ui.Interface.refresh()           #MOD-AB0200
          EXIT FOREACH  
       END IF
    END FOREACH
   #-MOD-A40008-add- 
    IF tm.rtype = '1' THEN  
       LET tm.bm = l_bm 
       DISPLAY BY NAME tm.bm 
    END IF
   #-MOD-A40008-end- 
END FUNCTION         
 
#FUN-A30122 -------------------------mark start-------------------------------
{
FUNCTION r007_get_bookno()
   DEFINE l_axa02        LIKE axa_file.axa02
 
   #抓取上層公司編號
   SELECT axa02 INTO l_axa02 FROM axa_file,axb_file
    WHERE axa01=axb01 AND axa02=axb02 AND axa03=axb03
      AND axb01=tm.axb01 AND axb04=tm.axb04
 
   #上層公司編號在agli009中所設定工廠/DB
   SELECT axz03 INTO g_axz03 FROM axz_file
    WHERE axz01 = l_axa02
   LET g_plant_new = g_axz03      #營運中心
   CALL s_getdbs()
   IF cl_null(g_dbs_new) THEN
      LET g_dbs_new=g_dbs CLIPPED,'.'   #TQC-960293 mod
   END IF
 
   #上層公司所屬合併帳別
  #LET g_sql = "SELECT aaz641 FROM ",g_dbs_new,"aaz_file",  #FUN-A50102
   LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_plant_new,'aaz_file'),   #FUN-A50102 
               " WHERE aaz00 = '0'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
   PREPARE r007_pre_01 FROM g_sql
   DECLARE r007_cur_01 CURSOR FOR r007_pre_01
   OPEN r007_cur_01
   FETCH r007_cur_01 INTO g_aaz641   #合併帳別
   CLOSE r007_cur_01
   RETURN g_aaz641
 
END FUNCTION
 
FUNCTION r007_chk_bookno()
   DEFINE l_axa02        LIKE axa_file.axa02
   DEFINE li_chk_bookno  LIKE type_file.num5
   DEFINE l_cnt          LIKE type_file.num5
 
   #抓取上層公司編號
   SELECT axa02 INTO l_axa02 FROM axa_file,axb_file
    WHERE axa01=axb01 AND axa02=axb02 AND axa03=axb03
      AND axb01=tm.axb01 AND axb04=tm.axb04
 
   #上層公司編號在agli009中所設定工廠/DB
   SELECT axz03 INTO g_axz03 FROM axz_file
    WHERE axz01 = l_axa02
   CALL s_check_bookno(tm.b,g_user,g_axz03)
        RETURNING li_chk_bookno
   IF (NOT li_chk_bookno) THEN
      LET g_errno = 'agl-100'
      RETURN
   END IF
   
   LET g_plant_new = g_axz03      #營運中心
   CALL s_getdbs()
   IF cl_null(g_dbs_new) THEN
      LET g_dbs_new=g_dbs CLIPPED,'.'   #TQC-960293 mod
   END IF
 
   #上層公司所屬合併帳別
  #LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_new,"aaz_file",   #FUN-A50102
   LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'aaz_file'),   #FUN-A50102
               " WHERE aaz641 = '",tm.b,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
   PREPARE r007_pre_02 FROM g_sql
   DECLARE r007_cur_02 CURSOR FOR r007_pre_02
   OPEN r007_cur_02
   FETCH r007_cur_02 INTO l_cnt
   IF cl_null(l_cnt) OR l_cnt=0 THEN
      LET g_errno = 'agl-965'
      RETURN
   END IF
 
   RETURN
END FUNCTION
}
#FUN-A30122 -----------------------mark end-----------------------------------------
 
FUNCTION r007_set_entry()                                                                                                           
#  CALL cl_set_comp_entry("bm",TRUE)       #FUN-A90032
   CALL cl_set_comp_entry("q1,em,h1",TRUE) #FUN-A90032 add                                                                                           
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION r007_set_no_entry()                                                                                                        
#FUN-A90032 --Begin
#  IF INFIELD(rtype) AND tm.rtype = '1' THEN                                                                                        
#     CALL cl_set_comp_entry("bm",FALSE)                                                                                            
#  END IF                                                                                                                           
   IF tm.axa06 ="1" THEN
      CALL cl_set_comp_entry("q1,h1",FALSE)
   END IF
   IF tm.axa06 ="2" THEN
      CALL cl_set_comp_entry("em,h1",FALSE)
   END IF
   IF tm.axa06 ="3" THEN
      CALL cl_set_comp_entry("em,q1",FALSE)
   END IF
   IF tm.axa06 ="4" THEN
      CALL cl_set_comp_entry("q1,em,h1",FALSE)
   END IF
#FUN-A90032 --End                                                                                                                         
END FUNCTION
#No.FUN-9C0072精簡程式碼
#MOD-C40181 重過程式
