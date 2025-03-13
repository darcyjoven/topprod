# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: aglg003.4gl
# Descriptions...: T/B B/S I/S 
# Input parameter: 
# Return code....: 
# Date & Author..: 01/09/21 By Debbie Hsu
# Modify.........: No.MOD-4C0156 04/12/24 By Kitty 上層公司無法開窗 
# Modify.........: No.FUN-510007 05/02/17 By Nicola 報表架構修改
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-660060 06/06/28 By Rainy 表頭期間置於中間
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670005 06/07/07 By xumin  帳別權限修改 
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680098 06/08/30 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.MOD-6A0038 06/10/14 By Smapmin 資產負債表的起始月份應為0
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-690090 06/12/07 By Claire 語言鈕失效 
# Modify.........: No.FUN-6C0012 06/12/25 By Judy 打印額外名稱調整
# Modify.........: No.FUN-6C0068 07/01/16 By rainy 報表結構加判斷使用者及部門設限
# Modify.........: No.MOD-720040 07/02/05 by TSD.doris 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/31 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.TQC-720032 07/04/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740020 07/04/13 By arman 會計科目加帳套
# Modifyl........: NO.FUN-750076 07/05/18 BY yiting 加入版本條件抓取資料
# Modify.........: No.FUN-760044 07/06/15 By Sarah 隱藏畫面的版本欄位,列印也不印
# Modify.........: No.FUN-770069 07/08/10 By Sarah 合併報表都是抓年月區間,合計不需如總帳報表的相同控制
# Modify.........: No.TQC-780054 07/08/15 By xiaofeizhu 修改INSERT INTO temptable語法(不用ora轉換)
# Modify.........: No.TQC-830012 08/03/11 By Sarah CR Temptable增加maj11
# Modify.........: No.MOD-850168 08/05/16 By Smapmin 將邏輯改的跟aglr110一致.
# Modify.........: No.MOD-860109 08/06/13 By Sarah Temptable增加紀錄maj09,在rpt判斷當maj09='-'時,金額要*-1來呈現
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-920188 09/02/25 By ve007 依據上層公司所在庫抓取maj_file 
# Modify.........: No.MOD-940202 09/04/16 By Sarah 畫面上帳別開窗有問題,應開上層公司所在DB的合併報表帳別aaz641
# Modify.........: No.FUN-950048 09/05/23 By jan 拿掉 ‘版本’ 欄位
# Modify.........: NO.FUN-980084 09/08/21 BY yiting 修正FUN-950048問題
# Modify.........: No:FUN-930076 09/11/06 BY yiting 報表代號開窗資料需跨DB處理
# Modify.........: No.FUN-9C0072 10/01/18 By vealxu 精簡程式碼
# Modify.........: No.MOD-A40008 10/04/02 By Dido 1.資產類抓取當月;損益類抓取區間 2.mai_file 增加帳別
# Modify.........: No.MOD-A40009 10/04/02 By Dido 需判斷 axa09 = 'N' 時,抓取目前營運中心 
# Modify.........: NO.MOD-A40194 10/04/30 BY yiting 取到上層公司記帳幣後 應以記帳幣做金額及匯率的取位 
# Modify.........: No.MOD-A50167 10/05/27 By sabrina 百分比欄位沒有印出來
# Modify.........: No.FUN-A50102 10/06/07 By lutingtingGP5.3集團架構優化:跨庫統一改為使用cl_get_target_table()實现 
# Modify.........: No:MOD-A70189 10/07/27 By Dido RPT 已經取消抑制顯示,因此可將 MOD-A50167 取 Dido RPT 已經取消抑制顯示,因此可將 MOD-A50167 取消 
# Modify.........: No:CHI-A70046 10/08/11 By Summer 百分比需依金額單位顯示
# Modify.........: No.FUN-A50076 10/08/18 By vealxu 增加XBRL功能
# Modify.........: No.FUN-A60039 10/08/22 By vealxu 由p_ze取出EXCEL工作表的名稱
# Modify.........: No.FUN-A30122 10/08/24 By vealxu 合併帳別/合併資料庫的抓法改為CALL s_get_aaz641,s_aaz641_dbs
# Modify.........: No:CHI-A70061 10/08/25 By Summer 先列印空白再列印資料
# Modify.........: No:CHI-A70050 10/10/26 By sabrina 計算合計階段需增加maj09的控制 
# Modify.........: NO.MOD-A70192 11/01/07 by Yiting 依之前寫的xbrl程式架構會造成產出的科目設為合計但不產出時，金額沒有被計算
# Modify.........: No:FUN-A90032 11/01/24 By wangxin 屬於合併報表者，取消起始期別'輸入, 也就是若該合併主體採季報實施,則該報表無法以單月呈現
# Modify.........: NO:CHI-B10030 11/01/26 BY Summer 抓取aznn_file的SQL要改為跨DB的寫法,跨到這次合併的上層公司所在DB去抓取
# Modify.........: No.TQC-B30100 11/03/11 BY zhangweib 將程序中的MATCHES修改成ORACLE能識別的IN
# Modify.........: No:MOD-B40063 11/04/12 By Dido XBRL 金額應取整數位 
# Modify.........: No.FUN-B40029 11/04/13 By xianghui 修改substr
# Modify.........: NO:MOD-B30067 11/04/14 BY Dido 取消 q_mai01 傳遞參數 
# Modify.........: No.FUN-B50001 11/05/10 By lutingting agls101參數檔改為aaw_file
# Modify.........: No.FUN-B60077 11/07/18 By belle 原本是抓取maj21做為XBRL轉出科目，改用maj31
# Modify.........: No.FUN-B80057 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-B90028 11/09/20 By qirl 明細CR報表轉GR
# Modify.........: No.FUN-B90028 12/01/05 By qirl FUN-BB0047追單
# Modify.........: No.FUN-B90028 12/01/05 By yangtt FUN-B90140追單
# Modify.........: No.FUN-B90028 12/01/06 By qirl FUN-BA0012追單
# Modify.........: No.FUN-B90028 12/01/13 By xuxz FUN-BA0012(FUN-B50001)追單
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料
# Modify.........: No.FUN-C50007 12/05/14 By minpp GR程序优化
DATABASE ds
 
GLOBALS "../../config/top.global"
#FUN-B90028 
DEFINE tm  RECORD
              rtype   LIKE type_file.chr1,      #報表結構編號    #No.FUN-680098  VARCHAR(1) 
              axa01   LIKE axa_file.axa01,
              axa02   LIKE axa_file.axa02,
              axa03   LIKE axa_file.axa03,
              a       LIKE mai_file.mai01,        #報表結構編號   #No.FUN-680098  VARCHAR(6) 
              b       LIKE aaa_file.aaa01,        #帳別編號       #No.FUN-670039
              yy      LIKE type_file.num5,        #輸入年度       #No.FUN-680098 smallint
              axa06   LIKE axa_file.axa06,        #FUN-A90032
              bm      LIKE type_file.num5,        #Begin 期別     #No.FUN-680098 smallint 
              em      LIKE type_file.num5,        # End  期別     #No.FUN-680098 smallint
              q1      LIKE type_file.chr1,        #FUN-A90032
              h1      LIKE type_file.chr1,        #FUN-A90032
              c       LIKE type_file.chr1,        #異動額及餘額為0者是否列印  #No.FUN-680098  VARCHAR(1)  
              d       LIKE type_file.chr1,        #金額單位       #No.FUN-680098  VARCHAR(1) 
              e       LIKE type_file.num5,        #小數位數       #No.FUN-680098  smallint
              f       LIKE type_file.num5,        #列印最小階數   #No.FUN-680098  smallint
              h       LIKE type_file.chr4,        #額外說明類別   #No.FUN-680098  VARCHAR(4) 
              xbrl    LIKE type_file.chr1,        #是否產生XBRL卡    #FUN-A50076
              exp     LIKE type_file.chr1,        #產生XBRL格式      #FUN-A50076
              o       LIKE type_file.chr1,        #轉換幣別否     #No.FUN-680098  VARCHAR(1) 
              p       LIKE azi_file.azi01,        #幣別
              q       LIKE azj_file.azj03,  #匯率
              r       LIKE azi_file.azi01,  #幣別
              more    LIKE type_file.chr1,    #Input more condition(Y/N)     #No.FUN-680098  VARCHAR(1) 
              ver     LIKE axh_file.axh13,    #NO.FUN-750076   #FUN-950048 mark    #FUN-980084 取消mark
              acc_code LIKE type_file.chr1    #No.FUN-B90028  add 
           END RECORD,
       bdate,edate    LIKE type_file.dat,          #No.FUN-680098 date
       i,j,k,g_mm,p   LIKE type_file.num5,         #No.FUN-680098 smallint
       g_unit         LIKE type_file.num10,        #金額單位基數    #No.FUN-680098  integer
       g_bookno       LIKE axh_file.axh00,         #帳別
       g_mai02        LIKE mai_file.mai02,
       g_mai03        LIKE mai_file.mai03,
       g_tot1         ARRAY[100] OF LIKE type_file.num20_6,    #No.FUN-680098 decimal(20,6)
       g_basetot1     LIKE axh_file.axh08
DEFINE g_tot2         ARRAY[100] OF  LIKE type_file.num20_6      #MOD-A70192
DEFINE g_basetot2     LIKE axh_file.axh08                        #MOD-A70192
DEFINE g_aaa02        LIKE aaa_file.aaa02          #MOD-940202 add
DEFINE g_aaa03        LIKE aaa_file.aaa03   
DEFINE g_msg          LIKE type_file.chr1000       #No.FUN-680098  VARCHAR(72) 
DEFINE x_aaa03        LIKE aaa_file.aaa03          #幣別
DEFINE l_table        STRING                       #MOD-720040 TSD.doris
DEFINE g_sql          STRING                       #MOD-720040 TSD.doris
DEFINE g_str          STRING                       #MOD-720040 TSD.doris
DEFINE g_axz03        LIKE axz_file.axz03          #No.FUN-920188
DEFINE g_dbs_axz03    STRING                       #No.FUN-920188
DEFINE g_plant_axz03  LIKE azw_file.azw01          #FUN-A50076  add 
DEFINE g_aaz641       LIKE aaz_file.aaz641         #MOD-940202 add   #FUN-B50001#FUN-B90028(FUN-B50001 rollback)
#DEFINE g_aaw01        LIKE aaw_file.aaw01          #FUN-B50001#FUN-B90028(FUN-B50001 rollback)
DEFINE l_length       LIKE type_file.num5          #No.FUN-930076
DEFINE g_str1         LIKE type_file.chr20         #FUN-A50076
DEFINE g_yy           LIKE type_file.num5          #FUN-A50076
DEFINE g_ss           LIKE type_file.num5          #FUN-A50076
DEFINE g_name1        LIKE type_file.chr100        #FUN-A50076
DEFINE g_axz09        LIKE axz_file.axz09          #FUN-A50076
DEFINE g_cmd          LIKE type_file.chr100        #FUN-A50076
DEFINE sheet1         STRING                       #FUN-A50076
DEFINE sheet2         STRING                       #FUN-A50076
DEFINE g_r            LIKE type_file.num5          #FUN-A50076
DEFINE g_axa05        LIKE axa_file.axa05          #FUN-A90032
 
###GENGRE###START
TYPE sr1_t RECORD
    maj31 LIKE maj_file.maj31,
    maj20 LIKE maj_file.maj20,
    maj20e LIKE maj_file.maj20e,
    maj03 LIKE maj_file.maj03,
    maj04 LIKE maj_file.maj04,
    maj05 LIKE maj_file.maj05,
    maj02 LIKE maj_file.maj02,
    maj11 LIKE maj_file.maj11,
    line LIKE type_file.num5,
    bal1 LIKE axh_file.axh08,
    per1 LIKE fid_file.fid03,
    azi03 LIKE azi_file.azi03,
    azi04 LIKE azi_file.azi04,
    azi05 LIKE azi_file.azi05,
    maj09 LIKE maj_file.maj09
END RECORD
###GENGRE###END

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
    # CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114#FUN-B90028 
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
#  LET g_sql = "maj20.maj_file.maj20,maj20e.maj_file.maj20e,",                           #No.FUN-B90028 mark
   LET g_sql = "maj31.maj_file.maj31,maj20.maj_file.maj20,maj20e.maj_file.maj20e,",      #No.FUN-B90028 add
               "maj03.maj_file.maj03,maj04.maj_file.maj04,",
               "maj05.maj_file.maj05,maj02.maj_file.maj02,",
               "maj11.maj_file.maj11,line.type_file.num5,bal1.axh_file.axh08,",  #TQC-830012 add maj11 #CHI-A70061 add line
               "per1.fid_file.fid03, azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,azi05.azi_file.azi05,",
               "maj09.maj_file.maj09"   #MOD-860109 add
   
   LET l_table = cl_prt_temptable('aglg003',g_sql) CLIPPED # 產生TEMP TABLE
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,      # TQC-780054
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"   #TQC-830012 add ?   #MOD-860109 add ? #CHI-A70061 add ?  #No.FUN-B90028 add?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-B90028 
   LET g_bookno = ARG_VAL(1)
   LET g_pdate  = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.rtype = ARG_VAL(8)
   LET tm.axa01 = ARG_VAL(9)
   LET tm.axa02 = ARG_VAL(10)
   LET tm.axa03 = ARG_VAL(11)
   LET tm.a  = ARG_VAL(12)
   LET tm.b  = ARG_VAL(13)   #TQC-610056
   LET tm.yy = ARG_VAL(14)
#  LET tm.bm    = ARG_VAL(15)   #FUN-A90032
   LET tm.axa06 = ARG_VAL(15)   #FUN-A90032
   LET tm.em = ARG_VAL(16)
   LET tm.c  = ARG_VAL(17)
   LET tm.d  = ARG_VAL(18)
   LET tm.e  = ARG_VAL(19)
   LET tm.f  = ARG_VAL(20)
   LET tm.h  = ARG_VAL(21)
   LET tm.o  = ARG_VAL(22)
   LET tm.r  = ARG_VAL(23)   #TQC-610056
   LET tm.p  = ARG_VAL(24)
   LET tm.q  = ARG_VAL(25)
   LET g_rep_user = ARG_VAL(26)
   LET g_rep_clas = ARG_VAL(27)
   LET g_template = ARG_VAL(28)
   LET tm.ver = ARG_VAL(29)   #no.FUN-750076  #FUN-950048  ##FUN-980084 取消mark
 # LET g_rpt_name = ARG_VAL(29)  #No.FUN-7C0078            #FUN-A50076 mark
   LET g_rpt_name = ARG_VAL(30)                            #FUN-A50076 add  
   #FUN-A50076 -----------add start---------------------------------
   LET tm.xbrl  = ARG_VAL(31)
   LET tm.exp   = ARG_VAL(32)
   #FUN-A50076 ----------add end-----------------------------------
   #FUN-A90032 --Begin
   LET tm.q1  = ARG_VAL(33)
   LET tm.h1  = ARG_VAL(34)
   #FUN-A90032 --End
 
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
   IF cl_null(tm.ver) THEN LET tm.ver = '00' END IF   #FUN-760044 add #寫死抓版本00的資料 #FUN-950048 mark  ##FUN-980084 取消mark
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL g003_tm()                # Input print condition
   ELSE
      IF tm.xbrl = 'N' THEN   #FUN-A50076
         CALL g003()            # Read data and create out-file
      ELSE                    #FUN-A50076
         CALL g003_xbrl()     #FUN-A50076
      END IF                  #FUN-A50076
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
   CALL cl_gre_drop_temptable(l_table)   #FUN-B90028 add
END MAIN
 
FUNCTION g003_tm()
   DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680098     smalllint
   DEFINE l_sw           LIKE type_file.chr1          #重要欄位是否空白  #No.FUN-680098   VARCHAR(1) 
   DEFINE l_cnt          LIKE type_file.num5          #No.FUN-680098     smallint
   DEFINE l_cmd          LIKE type_file.chr1000       #No.FUN-680098     VARCHAR(400) 
   DEFINE li_chk_bookno  LIKE type_file.num5          #No.FUN-670005     #No.FUN-680098 smallint
   DEFINE li_result      LIKE type_file.num5          #No.FUN-6C0068
   DEFINE l_dbs          LIKE type_file.chr21         #FUN-930076 add
   DEFINE l_flag         LIKE type_file.num5          #MOD-940202 add
   DEFINE l_aaa05        LIKE aaa_file.aaa05          #FUN-950048
   DEFINE l_axa09        LIKE axa_file.axa09          #MOD-A40009
   DEFINE l_azp03        LIKE azp_file.azp03          #FUN-A30122 
   DEFINE l_aznn01       LIKE aznn_file.aznn01        #FUN-A90032
   DEFINE l_axz03        LIKE axz_file.axz03          #CHI-B10030 add
   
   CALL s_dsmark(g_bookno)
 
   LET p_row = 2 LET p_col = 20
 
   OPEN WINDOW g003_w AT p_row,p_col WITH FORM "agl/42f/aglg003" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0)   #No.FUN-660123
   END IF
   #使用預設帳別之幣別之小數位數
   SELECT azi05 INTO tm.e FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","sel azi:",0)   #No.FUN-660123
   END IF
   LET tm.b = g_bookno
   LET tm.bm = 0  #FUN-950048
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.f = 0
   LET tm.h = 'N'
   LET tm.o = 'N'
   LET tm.p = g_aaa03
   LET tm.q = 1
   LET tm.r = g_aaa03
   LET tm.more = 'N'
   LET tm.xbrl = 'N'    #FUN-A50076 add
   LET tm.exp  = ' '    #FUN-A50076 add
   LET tm.ver = '00'    #FUN-760044 add  #寫死抓版本00的資料 #FUN-950048 mark ##FUN-980084 取消mark
   LET tm.acc_code = 'N'  #No.FUN-B90028 add
   LET g_unit  = 1
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
    LET l_sw = 1
    CALL cl_set_comp_entry("exp",FALSE)                 #No.FUN-A50076
    LET tm.xbrl = 'N'                                   #No.FUN-A50076
    LET tm.exp  = ' '                                   #No.FUN-A50076
 
    INPUT BY NAME tm.rtype,tm.axa01,tm.axa02,tm.axa03,  #NO.FUN-750076   #FUN-950048
#                 tm.a,tm.b,tm.yy,tm.bm,tm.em,          #FUN-A90032
                  tm.a,tm.b,tm.yy,tm.em,tm.q1,tm.h1,    #FUN-A90032
                  tm.e,tm.f,tm.d,tm.acc_code,tm.c,tm.h,tm.xbrl,tm.exp,tm.o,tm.r,     #FUN-A50076 add tm.xbrl,tm.exp    #NO.FUN-90028 ADD tm.acc_code
                  tm.p,tm.q,tm.more WITHOUT DEFAULTS  
 
       BEFORE INPUT
          CALL cl_qbe_init()
       
       #FUN-A90032 --Begin
          CALL g003_set_entry()
          CALL g003_set_no_entry()
       #FUN-A90032 --End 
        
       ON ACTION locale
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          LET g_action_choice = "locale"
          EXIT INPUT  #TQC-690090 add
 
 
        BEFORE FIELD rtype
          CALL g003_set_entry() 
 
#FUN-A90032 --Begin 
#        AFTER FIELD rtype 
#           IF tm.rtype = '1' THEN
#              LET tm.bm=0
#              DISPLAY tm.bm TO bm 
#              CALL g003_set_no_entry()
#           END IF 
#FUN-A90032 --End           
 
       AFTER FIELD axa01
          IF cl_null(tm.axa01) THEN NEXT FIELD axa01 END IF
          SELECT COUNT(*) INTO l_cnt FROM axa_file 
           WHERE axa01=tm.axa01
          IF SQLCA.sqlcode THEN LET l_cnt = 0 END IF
#FUN-A30122 -------------------------mark start-----------------------
#         IF l_cnt <=0  THEN 
#            CALL cl_err(tm.axa01,'agl-223',0) NEXT FIELD axa01  
#            NEXT FIELD axa01 
#         ELSE
#            #抓取上層公司所屬合併帳別
#            CALL g003_get_bookno() RETURNING tm.b
#            DISPLAY BY NAME tm.b
#         END IF
#FUN-A30122 -----------------------mark end--------------------------
#FUN-A90032 --Begin
            LET tm.axa06 = '2'
            SELECT axa05,axa06 
             INTO g_axa05,tm.axa06
             FROM axa_file
            WHERE axa01 = tm.axa01     
              AND axa04 = 'Y'
            DISPLAY BY NAME tm.axa06                                                                                   
            CALL g003_set_entry()
            CALL g003_set_no_entry()
            IF tm.axa06 = '1' THEN
                LET tm.q1 = '' 
                LET tm.h1 = '' 
                LET l_aaa05 = 0
                SELECT aaa05 INTO l_aaa05 FROM aaa_file 
                 WHERE aaa01=tm.b 
#                  AND aaaacti MATCHES '[Yy]'     #No.TQC-B30100 Mark
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
 
       AFTER FIELD axa02
          IF cl_null(tm.axa02) THEN NEXT FIELD axa02 END IF
          SELECT COUNT(*) INTO l_cnt FROM axa_file
           WHERE axa01=tm.axa01 AND axa02=tm.axa02
          IF SQLCA.sqlcode THEN LET l_cnt = 0 END IF
          IF l_cnt <=0  THEN 
             CALL cl_err(tm.axa02,'agl-223',0) NEXT FIELD axa02
             NEXT FIELD axa02 
          ELSE 
             SELECT axa03 INTO tm.axa03 FROM axa_file
              WHERE axa01=tm.axa01 AND axa02=tm.axa02
             DISPLAY BY NAME tm.axa03
#FUN-A30122 ---------------------------mark start--------------------
#            #抓取上層公司所屬合併帳別
#            CALL g003_get_bookno() RETURNING tm.b
#            DISPLAY BY NAME tm.b
          END IF

#        #-MOD-A40009-add-
#         SELECT axa09 INTO l_axa09 
#           FROM axa_file
#          WHERE axa01 = tm.axa01 AND axa02 = tm.axa02 AND axa03 = tm.axa03 
#         IF l_axa09 = 'N' THEN
#            LET g_dbs_axz03 = s_dbstring(g_dbs CLIPPED)        
#            LET g_plant_axz03 =  g_plant                           #FUN-A50076 add 
#            LET g_plant_new = g_plant   #FUN-A50102
#         ELSE
#            SELECT axz03 INTO g_axz03 FROM axz_file WHERE axz01=tm.axa02
#            LET  g_plant_new = g_axz03
#            CALL s_getdbs()
#            LET g_dbs_axz03 = g_dbs_new        
#            LET g_plant_axz03 = g_axz03                            #FUN-A50076 add
#         END IF
#        #-MOD-A40009-end-
#         IF NOT cl_null(g_dbs_axz03) THEN 
#            LET l_length = LENGTH(g_dbs_axz03)                     #NO.FUN-930076
#              IF l_length >1 THEN                                    #NO.FUN-930076
#                 LET  l_dbs = g_dbs_axz03.subSTRING(1,l_length-1)    #NO.FUN-930076
#              END IF                                                 #NO.FUN-930076   
#         ELSE 
#            LET l_dbs = g_dbs   
#         END IF
#FUN-A30122 ------------------------mark end-----------------------------------------

#FUN-A30122 ------------------------add start-------------------------------------
          CALL  s_aaz641_dbs(tm.axa01,tm.axa02) RETURNING g_plant_axz03   
          CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaz641     #FUN-B50001        #FUN-B90028(FUN-B50001 rollback)
          #CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaw01#FUN-B90028(FUN-B50001 rollback)
          LET g_plant_new = g_plant_axz03 
          LET tm.b = g_aaz641  #合并帐别   #FUN-B50001   #FUN-B90028(FUN-B50001 rollback)                          
          #LET tm.b = g_aaw01  #合并帐别           #FUN-B90028(FUN-B50001 rollback)                     
          DISPLAY BY NAME tm.b        
          SELECT axz06 INTO x_aaa03 FROM axz_file where axz01 = tm.axa02        
          LET tm.r = x_aaa03                                                    
          LET tm.p = x_aaa03                                                    
          SELECT azi05 INTO tm.e FROM azi_file WHERE azi01 = x_aaa03            
          DISPLAY BY NAME tm.r                                                  
          DISPLAY BY NAME tm.p                                                  
          DISPLAY BY NAME tm.e                                                  
          SELECT azi03,azi04,azi05                                              
            INTO t_azi03,t_azi04,t_azi05                  #MOD-B40063 mod g_azi -> t_azi
            FROM azi_file WHERE azi01 = x_aaa03                                 
          IF cl_null(t_azi03) THEN LET t_azi03 = 0 END IF #MOD-B40063 mod g_azi -> t_azi
          IF cl_null(t_azi04) THEN LET t_azi05 = 0 END IF #MOD-B40063 mod g_azi -> t_azi
          IF cl_null(t_azi05) THEN LET t_azi05 = 0 END IF #MOD-B40063 mod g_azi -> t_azi
          SELECT azp03 INTO l_azp03 FROM azp_file
           WHERE azp01 = g_plant_axz03
          LET g_dbs_axz03 = l_azp03 
          IF NOT cl_null(g_dbs_axz03) THEN                                      
             LET l_length = LENGTH(g_dbs_axz03)                                 
             IF l_length > 1 THEN                                               
                LET l_dbs = g_dbs_axz03.subSTRING(1,l_length-1)                 
             END IF                                                             
          ELSE                                                                  
             LET l_dbs=g_dbs                                                    
          END IF
#FUN-A30122 -------------------------add end---------------------- 
 
       AFTER FIELD axa03
          IF cl_null(tm.axa03) THEN NEXT FIELD axa03 END IF
          SELECT COUNT(*) INTO l_cnt FROM axa_file
           WHERE axa01=tm.axa01 AND axa02=tm.axa02 AND axa03=tm.axa03
          IF SQLCA.sqlcode THEN LET l_cnt = 0 END IF
          IF l_cnt <=0  THEN 
             CALL cl_err(tm.axa03,'agl-223',0) NEXT FIELD axa03
             NEXT FIELD axa03 
          END IF

#FUN-A90032 --Begin mark 
#        BEFORE FIELD a
#          IF cl_null(tm.rtype) THEN
#             CALL g003_set_entry() 
#          END IF
#FUN-A90032 --End mark          
 
      #AFTER FIELD a              #FUN-A50076 mark
       ON CHANGE a                #FUN-A50076 add
          IF tm.a IS NULL THEN NEXT FIELD a END IF
          CALL s_chkmai(tm.a,'RGL') RETURNING li_result  #FUN-930076 mark
          IF NOT li_result THEN
            CALL cl_err(tm.a,g_errno,1)
            NEXT FIELD a
          END IF
         #LET g_sql = "SELECT mai02,mai03 FROM ",l_dbs_axz03,"mai_file",  #FUN-A50102
          LET g_sql = "SELECT mai02,mai03 FROM ",cl_get_target_table(g_plant_new,'mai_file'), #FUN-A50102
                      " WHERE mai01 = '",tm.a,"'",
                      "   ANd mai00 = '",tm.axa03,"'",     #MOD-A40008
                      "   AND maiacti IN ('Y','y')"
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
          CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
          PREPARE g003_pre FROM g_sql
          DECLARE g003_cur CURSOR FOR g003_pre
          OPEN g003_cur
          FETCH g003_cur INTO g_mai02,g_mai03
          IF STATUS THEN 
             CALL cl_err3("sel","mai_file",tm.a,"",STATUS,"","sel mai:",0)   #No.FUN-660123
             NEXT FIELD a
         #No.TQC-C50042   ---start---   Add
          ELSE
             IF g_mai03 = '5' OR g_mai03 = '6' THEN
                CALL cl_err('','agl-268',0)
                NEXT FIELD a
             END IF
         #No.TQC-C50042   ---end---     Add
          END IF
          #FUN-A90032 --Begin mark
          # IF cl_null(tm.rtype) THEN
          #    IF g_mai03 = '2' THEN 
          #       LET tm.bm = 0
          #       DISPLAY tm.bm TO bm 
          #       CALL cl_set_comp_entry("bm",FALSE) 
          #    END IF
          # END IF
          #FUN-A90032 --End mark
 
       AFTER FIELD b
          IF tm.b IS NULL THEN NEXT FIELD b END IF
#FUN-A30122 ----------------------mark start------------------------ 
#         LET g_errno = ''
#         CALL g003_chk_bookno()
#         IF NOT cl_null(g_errno) THEN
#            CALL cl_err('',g_errno,0)
#            NEXT FIELD b
#         END IF
#FUN-A30122 --------------------mark end-------------------------------
         LET l_aaa05 = 0
         SELECT aaa05 INTO l_aaa05 FROM aaa_file                                                                                    
          WHERE aaa01=tm.b                                                                                                          
            AND aaaacti IN ('Y','y')                                                                                              
         LET tm.em = l_aaa05                                                                                                        
         DISPLAY tm.em TO em
 
       AFTER FIELD c
          IF tm.c IS NULL OR tm.c NOT MATCHES "[YN]" THEN NEXT FIELD c END IF
 
       AFTER FIELD yy
          IF tm.yy IS NULL OR tm.yy = 0 THEN
             NEXT FIELD yy
          END IF

#FUN-A90032 --Begin 
#       AFTER FIELD bm
#          IF NOT cl_null(tm.bm) THEN
#             SELECT azm02 INTO g_azm.azm02 FROM azm_file
#               WHERE azm01 = tm.yy
#             IF g_azm.azm02 = 1 THEN
#                IF tm.bm > 12 OR tm.bm < 0 THEN   #FUN-770069 mod 1->0
#                   CALL cl_err('','agl-020',0)
#                   NEXT FIELD bm
#                END IF
#             ELSE
#                IF tm.bm > 13 OR tm.bm < 0 THEN   #FUN-770069 mod 1->0
#                   CALL cl_err('','agl-020',0)
#                   NEXT FIELD bm
#                END IF
#             END IF
#          END IF
#FUN-A90032 --End          
  
       AFTER FIELD em
          IF NOT cl_null(tm.em) THEN
             SELECT azm02 INTO g_azm.azm02 FROM azm_file
               WHERE azm01 = tm.yy
             IF g_azm.azm02 = 1 THEN
                IF tm.em > 12 OR tm.em < 0 THEN     #FUN-770069 需可包含期初   #tm.em<1-->0
                   CALL cl_err('','agl-020',0)
                   NEXT FIELD em
                END IF
             ELSE
                IF tm.em > 13 OR tm.em < 0 THEN     #FUN-770069 需可包含期初   #tm.em<1-->0
                   CALL cl_err('','agl-020',0)
                   NEXT FIELD em
                END IF
             END IF
          END IF
#          IF tm.bm > tm.em THEN CALL cl_err('','9011',0) NEXT FIELD bm END IF   #FUN-A90032 mark
 
       AFTER FIELD d
          IF tm.d IS NULL OR tm.d NOT MATCHES'[123]'  THEN
             NEXT FIELD d
          END IF
          CASE 
             WHEN tm.d = '1' 
                LET g_unit = 1
             WHEN tm.d = '2' 
                LET g_unit = 1000
             WHEN tm.d = '3' 
                LET g_unit = 1000000
          END CASE
 
       AFTER FIELD e
          IF tm.e < 0 THEN
             LET tm.e = 0
             DISPLAY BY NAME tm.e
          END IF
 
       AFTER FIELD f
          IF tm.f IS NULL OR tm.f < 0  THEN
             LET tm.f = 0
             DISPLAY BY NAME tm.f
             NEXT FIELD f
          END IF
 
       AFTER FIELD h
          IF tm.h NOT MATCHES "[YN]" THEN NEXT FIELD h END IF
 
       AFTER FIELD o
          IF tm.o IS NULL OR tm.o NOT MATCHES'[YN]' THEN NEXT FIELD o END IF
          IF tm.o = 'N' THEN 
            #LET tm.p = g_aaa03    #MOD-A40194 mark 
             LET tm.p = x_aaa03    #MOD-A40194
             LET tm.q = 1
             DISPLAY g_aaa03 TO p   
             DISPLAY BY NAME tm.q
          END IF
 
       BEFORE FIELD p
          IF tm.o = 'N' THEN NEXT FIELD more END IF
 
       AFTER FIELD p
          SELECT azi01 FROM azi_file WHERE azi01 = tm.p AND aziacti = 'Y'
          IF SQLCA.sqlcode THEN 
             CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","",0)   #No.FUN-660123
             NEXT FIELD p
          END IF
          #---MOD-A40194 start---
          IF tm.o = 'Y' THEN
              SELECT azi03,azi04,azi05 
                INTO t_azi03,t_azi04,t_azi05                  #MOD-B40063 mod g_azi -> t_azi
                FROM azi_file WHERE azi01 = tm.p
              IF cl_null(t_azi03) THEN LET t_azi03 = 0 END IF #MOD-B40063 mod g_azi -> t_azi
              IF cl_null(t_azi04) THEN LET t_azi05 = 0 END IF #MOD-B40063 mod g_azi -> t_azi
              IF cl_null(t_azi05) THEN LET t_azi05 = 0 END IF #MOD-B40063 mod g_azi -> t_azi
          END IF
          #---MOD-A40194 end -----
 
       BEFORE FIELD q
          IF tm.o = 'N' THEN NEXT FIELD o END IF
 
       AFTER FIELD more
          IF tm.more = 'Y'
             THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                 g_bgjob,g_time,g_prtway,g_copies)
                       RETURNING g_pdate,g_towhom,g_rlang,
                                 g_bgjob,g_time,g_prtway,g_copies
          END IF

       #FUN-A50076 -------------------add start--------------------------
       ON CHANGE xbrl
           IF tm.xbrl='N' THEN LET tm.exp='' END IF
           DISPLAY BY NAME tm.exp
           LET tm.d = '2'                  #XBRL限制以千為單位轉入 
           DISPLAY BY NAME tm.d
           CALL g003_set_entry_1()
           CALL g003_set_no_entry_1()          
       #FUN-A50076 -----------------add end------------------------------ 
 
       AFTER INPUT 
          IF INT_FLAG THEN EXIT INPUT END IF
          IF tm.yy IS NULL THEN 
             LET l_sw = 0 
             DISPLAY BY NAME tm.yy 
             CALL cl_err('',9033,0)
          END IF
#FUN-A90032 --Begin mark
#          IF tm.bm IS NULL THEN 
#             LET l_sw = 0 
#             DISPLAY BY NAME tm.bm 
#          END IF
#           IF tm.em IS NULL THEN 
#              LET l_sw = 0 
#              DISPLAY BY NAME tm.em 
#          END IF
#FUN-A90032 --End mark          
          IF l_sw = 0 THEN 
              LET l_sw = 1 
              NEXT FIELD a
              CALL cl_err('',9033,0)
          END IF
 
          CASE 
             WHEN tm.d = '1' 
                LET g_unit = 1
             WHEN tm.d = '2' 
                LET g_unit = 1000
             WHEN tm.d = '3' 
                LET g_unit = 1000000
          END CASE
          #--FUN-A90032 start--
          IF NOT cl_null(tm.axa06) THEN
              CASE
                  WHEN tm.axa06 = '1' 
                       LET tm.bm = 0
                 #CHI-B10030 add --start--
                  OTHERWISE      
                       CALL s_axz03_dbs(tm.axa02) RETURNING l_axz03 
                       CALL s_get_aznn01(l_axz03,tm.axa06,tm.axa03,tm.yy,tm.q1,tm.h1) RETURNING tm.em
                 #CHI-B10030 add --end--
              END CASE
          END IF
          #--FUN-A90032
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()    # Command execution
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(axa01) OR INFIELD(axa02)          #No.MOD-4C0156
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_axa'
                LET g_qryparam.default1 = tm.axa01
                LET g_qryparam.default2 = tm.axa02
                LET g_qryparam.default3 = tm.axa03
                CALL cl_create_qry() RETURNING tm.axa01,tm.axa02,tm.axa03
                DISPLAY BY NAME tm.axa01
                DISPLAY BY NAME tm.axa02
                DISPLAY BY NAME tm.axa03
                NEXT FIELD axa01
             WHEN INFIELD(a) 
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_mai01'          #FUN-930076 mod 
                LET g_qryparam.default1 = tm.a           #FUN-930076 mod
               #LET g_qryparam.arg1 = l_azp03            #FUN-930076 mod #MOD-B30067 mark
               #LET g_qryparam.where = "mai00 = '",tm.axa03,"'"      #MOD-A40008    #NO.TQC-C50042   Add
                LET g_qryparam.where = "mai00 = '",tm.axa03,"' AND mai03 NOT IN ('5','6')"  #No.TQC-C50042   Add
                CALL cl_create_qry() RETURNING tm.a
                DISPLAY BY NAME tm.a
                NEXT FIELD a
             WHEN INFIELD(b)                                                     
                 CALL cl_init_qry_var()                                          
                 LET g_qryparam.form = 'q_aaa'    
                 LET g_qryparam.default1 = tm.b
                 CALL cl_create_qry() RETURNING tm.b                             
                 DISPLAY BY NAME tm.b                                            
                 NEXT FIELD b                                                    
             WHEN INFIELD(p)
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_azi'
                LET g_qryparam.default1 = tm.p
                CALL cl_create_qry() RETURNING tm.p 
                DISPLAY BY NAME tm.p
                NEXT FIELD p
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
 
    IF g_action_choice = "locale" THEN
       LET g_action_choice = ""
       CALL cl_dynamic_locale()
       CONTINUE WHILE
    END IF
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0 CLOSE WINDOW g003_w 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
       CALL cl_gre_drop_temptable(l_table)   #FUN-B90028 add
       EXIT PROGRAM
    END IF
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
              WHERE zz01='aglg003'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('aglg003','9031',1)  
       ELSE
          LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                          " '",g_bookno CLIPPED,"'" ,
                          " '",g_pdate CLIPPED,"'",
                          " '",g_towhom CLIPPED,"'",
                          " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                          " '",g_bgjob CLIPPED,"'",
                          " '",g_prtway CLIPPED,"'",
                          " '",g_copies CLIPPED,"'",
                          " '",tm.rtype CLIPPED,"'",
                          " '",tm.axa01 CLIPPED,"'",
                          " '",tm.axa02 CLIPPED,"'",
                          " '",tm.axa03 CLIPPED,"'",
                          " '",tm.a CLIPPED,"'",
                          " '",tm.b CLIPPED,"'",   #TQC-610056
                          " '",tm.yy CLIPPED,"'",
#                         " '",tm.bm CLIPPED,"'",    #FUN-A90032 mark
                          " '",tm.axa06 CLIPPED,"'", #FUN-A90032
                          " '",tm.em CLIPPED,"'",
                          " '",tm.c CLIPPED,"'",
                          " '",tm.d CLIPPED,"'",
                          " '",tm.e CLIPPED,"'",
                          " '",tm.f CLIPPED,"'",
                          " '",tm.h CLIPPED,"'",
                          " '",tm.o CLIPPED,"'",
                          " '",tm.r CLIPPED,"'",   #TQC-610056
                          " '",tm.p CLIPPED,"'",
                          " '",tm.q CLIPPED,"'",
                          " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                          " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                          " '",g_template CLIPPED,"'",           #No.FUN-570264
                          " '",tm.ver CLIPPED,"'"                #NO.FUN-750076  #FUN-950048 mark  #FUN-980084 取消mark
                         ," '",tm.q1 CLIPPED,"'",                #NO.FUN-A90032
                          " '",tm.h1 CLIPPED,"'"                 #NO.FUN-A90032
 
          CALL cl_cmdat('aglg003',g_time,l_cmd)    # Execute cmd at later time
       END IF
       CLOSE WINDOW g003_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
       CALL cl_gre_drop_temptable(l_table)   #FUN-B90028 add
       EXIT PROGRAM
    END IF
    CALL cl_wait()
    IF tm.xbrl = 'N' THEN               #FUN-A50076 add 
       CALL g003()
    ELSE                                #FUN-A50076 
       CALL g003_xbrl()                 #FUN-A50076
    END IF                              #FUN-A50076  
    ERROR ""
END WHILE
CLOSE WINDOW g003_w
END FUNCTION
 
FUNCTION g003()
   DEFINE l_name    LIKE type_file.chr20      # External(Disk) file name        #No.FUN-680098 VARCHAR(20)
   DEFINE l_sql     LIKE type_file.chr1000    # RDSQL STATEMENT        #No.FUN-680098  VARCHAR(1000) 
   DEFINE l_chr     LIKE type_file.chr1       #No.FUN-680098  VARCHAR(1) 
   DEFINE amt1      LIKE axh_file.axh08
   DEFINE maj       RECORD LIKE maj_file.*
   DEFINE g_i       LIKE type_file.num5       #No.FUN-680098 smallint
   DEFINE sr        RECORD
                     bal1 LIKE axh_file.axh08
                    END RECORD
   DEFINE per1      LIKE fid_file.fid03       #MOD-720040 add  
   DEFINE l_temp    LIKE axh_file.axh08       #MOD-720040 add
   DEFINE l_str     STRING                    #FUN-770069 add 10/19
   DEFINE l_axz02   LIKE axz_file.axz02       #FUN-770069 add 10/19
   DEFINE l_bm      LIKE type_file.num5       #MOD-A40008
  #DEFINE l_maj11   LIKE maj_file.maj11       #MOD-A50167 add        #MOD-A70189 mark
  #DEFINE l_sql2    STRING                    #MOD-A50167 add        #MOD-A70189 mark
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   
   SELECT axz06 INTO x_aaa03 FROM axz_file where axz01 = tm.axa02     #MOD-66003
 
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = tm.b AND aaf02 = g_rlang
 
   CASE WHEN tm.rtype='0' LET g_msg=" 1=1"
        #WHEN tm.rtype='1' LET g_msg=" SUBSTRING(maj23,1,1)='1'" #CHI-A70046 mark
        #WHEN tm.rtype='2' LET g_msg=" SUBSTRING(maj23,1,1)='2'" #CHI-A70046 mark
        WHEN tm.rtype='1' LET g_msg=" maj23 like '1%'" #CHI-A70046
        WHEN tm.rtype='2' LET g_msg=" maj23 like '2%'" #CHI-A70046
        OTHERWISE LET g_msg = " 1=1" 
   END CASE
   #LET l_sql = "SELECT * FROM ",g_dbs_axz03 CLIPPED,"maj_file",    #No.FUN-920188   #FUN-A50102
   LET l_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'maj_file'),   #FUN-A50102
               " WHERE maj01 = '",tm.a,"'",
               "   AND ",g_msg CLIPPED,
               " ORDER BY maj02"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-A50102
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql   #FUN-A50102
   PREPARE g003_p FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)   #FUN-B90028 add
      EXIT PROGRAM 
   END IF
   DECLARE g003_c CURSOR FOR g003_p

   #FUN-C50007--ADD--STR
   LET l_sql = "SELECT SUM(axh08-axh09) ",
                    "  FROM axh_file,",cl_get_target_table(g_plant_new,'aag_file'),   
                    " WHERE axh00 = '",tm.b,"'",
                    "   AND axh01 = '",tm.axa01,"'",
                    "   AND axh02 = '",tm.axa02,"'",
                    "   AND axh03 = '",tm.axa03,"'",
                    "   AND axh05 BETWEEN ? AND ?",
                    "   AND axh00 = aag00",
                    "   AND aag00 = '",tm.b,"'",     
                    "   AND axh06 = ",tm.yy,
                    "   AND axh07 = ",tm.em, 
                    "   AND axh05 = aag01 AND aag07 IN ('2','3')",
                    "   AND axh13 = '",tm.ver,"'",   
                    "   AND axh12 = '",x_aaa03,"'"   
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql  
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql   
        PREPARE g003_sum_p FROM l_sql
        DECLARE g003_sum_c CURSOR FOR g003_sum_p
   #FUN-C50007--ADD--END
   FOR g_i = 1 TO 100 LET g_tot1[g_i] = 0 END FOR
 
   LET tm.bm = 0 #FUN-A90032
  #-MOD-A40008-add- 
   IF tm.rtype = '1' THEN  
      LET l_bm = tm.bm 
      LET tm.bm = tm.em 
   END IF
  #-MOD-A40008-end- 
   LET g_pageno = 0
  #-MOD-A70189-mark-
  #MOD-A50167---add---start---
  #LET l_sql2 = "SELECT COUNT(maj11) FROM ",g_dbs_axz03 CLIPPED,"maj_file",    #No.FUN-920188   #FUN-A50102
  #LET l_sql2 = "SELECT COUNT(maj11) FROM ",cl_get_target_table(g_plant_new,'maj_file'),   #FUN-A50102
  #           " WHERE maj01 = '",tm.a,"'",
  #           "   AND maj11 = 'Y' ",
  #           "   AND ",g_msg CLIPPED,
  #           " ORDER BY maj02"
  #CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2  #FUN-A50102
  #CALL cl_parse_qry_sql(l_sql2,g_plant_new) RETURNING l_sql2   #FUN-A50102
  #PREPARE g003_p1 FROM l_sql2
  #EXECUTE g003_p1 INTO l_maj11
  #MOD-A50167---add---end--- 
  #-MOD-A70189-end-
   FOREACH g003_c INTO maj.*
     IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
     LET amt1 = 0
    #MOD-A50167---add---start---
    #IF l_maj11 > 0 THEN            #MOD-A70189 mark
    #   LET maj.maj11 = 'Y'         #MOD-A70189 mark
    #END IF                         #MOD-A70189 mark
    #MOD-A50167---add---end---
     IF NOT cl_null(maj.maj21) THEN
        IF cl_null(maj.maj22) THEN LET maj.maj22 = maj.maj21 END IF
      #FUN-C50007--MARK--STR
       #LET l_sql = "SELECT SUM(axh08-axh09) ",
       #           #"  FROM axh_file,",g_dbs_axz03,"aag_file",  #FUN-A50102
       #            "  FROM axh_file,",cl_get_target_table(g_plant_new,'aag_file'),   #FUN-A50102
       #            " WHERE axh00 = '",tm.b,"'",
       #            "   AND axh01 = '",tm.axa01,"'",
       #            "   AND axh02 = '",tm.axa02,"'",
       #            "   AND axh03 = '",tm.axa03,"'",
       #            "   AND axh05 BETWEEN '",maj.maj21,"' AND '",maj.maj22,"'",
       #            "   AND axh00 = aag00", 
       #            "   AND aag00 = '",tm.b,"'",     #NO.FUN-740020
       #            "   AND axh06 = ",tm.yy,
#      #            "   AND axh07 BETWEEN ",tm.bm," AND ",tm.em, #FUN-A90032 mark
       #            "   AND axh07 = ",tm.em, #FUN-A90032
       #            "   AND axh05 = aag01 AND aag07 IN ('2','3')",
       #            "   AND axh13 = '",tm.ver,"'",   #NO.FUN-750076  #FUN-950048 mark  ##FUN-980084 取消mark
       #            "   AND axh12 = '",x_aaa03,"'"   #NO.FUN-750076
       #CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-A50102
       #CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql   #FUN-A50102
       #PREPARE g003_sum_p FROM l_sql
       #DECLARE g003_sum_c CURSOR FOR g003_sum_p
       #OPEN g003_sum_c
       #FUN-C50007--MARK--END
        OPEN g003_sum_c USING maj.maj21,maj.maj22                                    #FUN-C50007  ADD
        FETCH g003_sum_c INTO amt1
        IF SQLCA.sqlcode THEN 
           CALL cl_err3("sel","axh_file,aag_file",tm.yy,"",STATUS,"","sel axh:",1)   #No.FUN-660123
           EXIT FOREACH 
        END IF
        IF amt1 IS NULL THEN LET amt1 = 0 END IF
     END IF
     #-->匯率的轉換
     IF tm.o = 'Y' THEN LET amt1 = amt1 * tm.q END IF 
     #-->合計階數處理
     IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0 THEN
        FOR i = 1 TO 100 
          #CHI-A70050---modify---start---
          #LET g_tot1[i]=g_tot1[i]+amt1 
           IF maj.maj09 = '-' THEN
              LET g_tot1[i] = g_tot1[i] - amt1
           ELSE
              LET g_tot1[i] = g_tot1[i] + amt1
           END IF
          #CHI-A70050---modify---end---
        END FOR
        LET k=maj.maj08  LET sr.bal1=g_tot1[k]
       #CHI-A70050---add---start---
        IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
           LET sr.bal1 = sr.bal1 *-1
        END IF
       #CHI-A70050---add---end---
        FOR i = 1 TO maj.maj08 LET g_tot1[i]=0 END FOR
     ELSE
        IF maj.maj03='5' THEN
           LET sr.bal1=amt1
        ELSE
           LET sr.bal1=NULL
        END IF
     END IF
     IF maj.maj07 = '2' THEN
        LET sr.bal1 = sr.bal1 * -1
     END IF
 
     #-->百分比基準科目
     IF maj.maj11 = 'Y' THEN                  
        LET g_basetot1=sr.bal1
        IF g_basetot1 = 0 THEN LET g_basetot1 = NULL END IF
        LET g_basetot1=g_basetot1/g_unit #CHI-A70046 add
     END IF
     IF maj.maj03='0' THEN CONTINUE FOREACH END IF #本行不印出
     #-->餘額為 0 者不列印
     IF (tm.c='N' OR maj.maj03='2') AND
        maj.maj03 MATCHES "[0125]" AND sr.bal1=0 THEN
        CONTINUE FOREACH                        
     END IF
     #-->最小階數起列印
     IF tm.f>0 AND maj.maj08 < tm.f THEN
        CONTINUE FOREACH                        
     END IF
 
     #MOD-720040 TSD.doris-------(S)-------------
     LET per1 = (sr.bal1 / g_basetot1) * 100     #百分比
 
     #-->列印額外名稱
     IF tm.h = 'Y' THEN
         LET maj.maj20 = maj.maj20e 
     END IF
     LET maj.maj20 = maj.maj05 SPACES,maj.maj20
     LET l_temp = (sr.bal1/g_unit)
     
     ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
     EXECUTE insert_prep USING maj.maj31,maj.maj20,maj.maj20e,maj.maj03,                #NO.FUN-B90028   Add maj.maj31
                               maj.maj04,maj.maj05,maj.maj02,maj.maj11,'2',   #TQC-830012 add maj11 #CHI-A70061 add '2'
                               l_temp,per1,t_azi03,t_azi04,t_azi05,maj.maj09   #MOD-860109 add maj09 #MOD-B40063 mod g_azi -> t_azi
     #CHI-A70061 add --start--
     IF maj.maj04 > 0 THEN
        #空行的部份,以寫入同樣的maj20資料列進Temptable,
        #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,
        #讓空行的這筆資料排在正常的資料前面印出
        FOR i = 1 TO maj.maj04
           EXECUTE insert_prep USING maj.maj31,maj.maj20,maj.maj20e,maj.maj03,         #NO.FUN-B90028   Add maj.maj31
                                     maj.maj04,maj.maj05,maj.maj02,maj.maj11,'1',
                                     l_temp,per1,t_azi03,t_azi04,t_azi05,maj.maj09 #MOD-B40063 mod g_azi -> t_azi
           IF STATUS THEN
              CALL cl_err("execute insert_prep:",STATUS,1)
              EXIT FOR
           END IF
        END FOR
     END IF
     #CHI-A70061 add --end--
   END FOREACH
 
  #-MOD-A40008-add- 
   IF tm.rtype = '1' THEN  
      LET tm.bm = l_bm 
      DISPLAY BY NAME tm.bm 
   END IF
  #-MOD-A40008-end- 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
###GENGRE###   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
  #列印公司編號,名稱
   SELECT axz02 INTO l_axz02 FROM axz_file WHERE axz01=tm.axa02
   LET l_str=tm.axa02 CLIPPED,'(',l_axz02 CLIPPED,')'
###GENGRE###   LET g_str = g_basetot1,";",tm.rtype,";",tm.axa01,";",l_str,";",tm.axa03,";", #FUN-770069      10/19  #FUN-770069 10/19
###GENGRE###               tm.a,";",tm.b,";",tm.yy,";",tm.bm,";",tm.em,";",
###GENGRE###               tm.e,";",tm.f,";",tm.d,";",tm.c,";",tm.h,";",
###GENGRE###               tm.o,";",tm.r,";",tm.p,";",tm.q  #,";",tm.ver  #NO.FUN-750076  #FUN-950048 拿掉tm.ver
###GENGRE###               ,";",tm.acc_code   #NO.FUN-B90028   Add
 
###GENGRE###   CALL cl_prt_cs3('aglg003','aglg003',l_sql,g_str)   #FUN-710080 modify
    CALL aglg003_grdata()    ###GENGRE###
   #------------------------------ CR (4) ------------------------------#
   
END FUNCTION
 
FUNCTION g003_set_entry()
  #IF INFIELD(rtype) THEN               #FUN-A90032 mark
  #   CALL cl_set_comp_entry("bm",TRUE) #FUN-A90032 mark
  #END IF                               #FUN-A90032 mark
  CALL cl_set_comp_entry("q1,em,h1",TRUE) #FUN-A90032
END FUNCTION
 
FUNCTION g003_set_no_entry()
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
 
#FUN-A50076 --------------------------add start---------------------------
FUNCTION g003_set_entry_1()
   CALL cl_set_comp_entry("exp,d",TRUE)
END FUNCTION

FUNCTION g003_set_no_entry_1()
   IF tm.xbrl = 'N' THEN
      CALL cl_set_comp_entry("exp",FALSE)
   ELSE
      CALL cl_set_comp_entry("d",FALSE)
   END IF
END FUNCTION
#FUN-A50076 ------------------------add end---------------------------------
 
#FUN-A30122 ------------------------mark start------------------------------
{
FUNCTION g003_get_bookno()
 
   #上層公司編號在agli009中所設定工廠/DB
   SELECT axz03 INTO g_axz03 FROM axz_file
    WHERE axz01 = tm.axa02
   LET g_plant_new = g_axz03      #營運中心
   CALL s_getdbs()
   IF cl_null(g_dbs_new) THEN
      LET g_dbs_new=s_dbstring(g_dbs CLIPPED)
   END IF
 
   #上層公司所屬合併帳別
  #LET g_sql = "SELECT aaz641 FROM ",g_dbs_new,"aaz_file",   #FUN-A50102
#FUN-B50001--mod--str--#FUN-B90028(FUN-B50001 rollback)
  LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_plant_new,'aaz_file'),  #FUN-A50102
              " WHERE aaz00 = '0'"
#   LET g_sql = "SELECT aaw01 FROM ",cl_get_target_table(g_plant_new,'aaw_file'), 
#               " WHERE aaw00 = '0'"
#FUN-B50001--mod--end#FUN-B90028(FUN-B50001 rollback)
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
   PREPARE g003_pre_01 FROM g_sql
   DECLARE g003_cur_01 CURSOR FOR g003_pre_01
   OPEN g003_cur_01
   FETCH g003_cur_01 INTO g_aaz641   #合併帳別   #FUN-B50001#FUN-B90028(FUN-B50001 rollback)
   #FETCH g003_cur_01 INTO g_aaw01   #合併帳別#FUN-B90028(FUN-B50001 rollback)
   CLOSE g003_cur_01
   RETURN g_aaz641    #FUN-B50001#FUN-B90028(FUN-B50001 rollback)
   #RETURN g_aaw01#FUN-B90028(FUN-B50001 rollback)
 
END FUNCTION
}
#FUN-A30122 -------------------------------mark end-----------------------------------------
 
FUNCTION g003_chk_bookno()
   DEFINE li_chk_bookno  LIKE type_file.num5
   DEFINE l_cnt          LIKE type_file.num5
 
   #上層公司編號在agli009中所設定工廠/DB
   SELECT axz03 INTO g_axz03 FROM axz_file
    WHERE axz01 = tm.axa02
   CALL s_check_bookno(tm.b,g_user,g_axz03)
        RETURNING li_chk_bookno
   IF (NOT li_chk_bookno) THEN
      LET g_errno = 'agl-100'
      RETURN
   END IF
   
   LET g_plant_new = g_axz03      #營運中心
   CALL s_getdbs()
   IF cl_null(g_dbs_new) THEN
      LET g_dbs_new=s_dbstring(g_dbs CLIPPED)
   END IF
 
   #上層公司所屬合併帳別
  #LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_new,"aaz_file",   #FUN-A50102
#FUN-B5001--mod-str--#FUN-B90028(FUN-B50001 rollback)
  LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'aaz_file'),   #FUN-A50102
              " WHERE aaz641 = '",tm.b,"'"
#   LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'aaw_file'),
#               " WHERE aaw01 = '",tm.b,"'"
#FUN-B50001--mod--end#FUN-B90028(FUN-B50001 rollback)
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
   PREPARE g003_pre_02 FROM g_sql
   DECLARE g003_cur_02 CURSOR FOR g003_pre_02
   OPEN g003_cur_02
   FETCH g003_cur_02 INTO l_cnt
   IF cl_null(l_cnt) OR l_cnt=0 THEN
      LET g_errno = 'agl-965'
      RETURN
   END IF
 
   RETURN
END FUNCTION

#FUN-A50076 --------------------------------------add start-------------------------------
FUNCTION g003_xbrl()
   DEFINE sr         RECORD
                        bal1      LIKE aah_file.aah04,
                        bal2      LIKE aah_file.aah04
                     END RECORD
   DEFINE l_maj      RECORD LIKE maj_file.*
   DEFINE l_i        LIKE type_file.num5
   DEFINE l_dbs      LIKE azp_file.azp03
   DEFINE l_sql      LIKE type_file.chr1000
   DEFINE l_name     LIKE type_file.chr50
   DEFINE l_flag     LIKE type_file.chr1
   DEFINE l_bdate    LIKE type_file.dat
   DEFINE l_edate    LIKE type_file.dat
   DEFINE l_url      LIKE type_file.chr100
   DEFINE l_date     LIKE type_file.dat
   DEFINE l_azn02    LIKE azn_file.azn02
   DEFINE l_azn04    LIKE azn_file.azn04
   DEFINE l_azn05    LIKE azn_file.azn05
   DEFINE l_cmd      LIKE type_file.chr100
   DEFINE li_result  LIKE type_file.num5
   DEFINE l_unixpath LIKE type_file.chr100
   DEFINE l_winpath  LIKE type_file.chr100
   DEFINE l_time     LIKE type_file.chr20
   DEFINE l_date1    LIKE type_file.chr20
   DEFINE l_dt       LIKE type_file.chr20
   DEFINE l_code     LIKE type_file.num10
   DEFINE l_ze03     LIKE ze_file.ze03
   DEFINE l_ze03_s   STRING      
   DEFINE l_year     LIKE type_file.chr4
   DEFINE l_month    LIKE type_file.chr4
   DEFINE l_day      LIKE type_file.chr4

   DEFINE l_amt1    LIKE aah_file.aah04      
   DEFINE l_amt2    LIKE aah_file.aah04     
   DEFINE l_bal1    LIKE aah_file.aah04    
   DEFINE l_bal2    LIKE aah_file.aah04      
   DEFINE g_i       LIKE type_file.num5     
   DEFINE l_azi04_1 LIKE azi_file.azi04   
  
   SELECT axz06 INTO x_aaa03 FROM axz_file where axz01 = tm.axa02

   CALL cl_del_data(l_table)
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = tm.b
      AND aaf02 = g_rlang
   
   #---------取報表類別
   SELECT axz09 INTO g_axz09 FROM axz_file WHERE axz01=tm.axa02
   LET g_yy = tm.yy - 1911                         #轉民國年
   LET l_date = g003_lastday()
   CALL s_gactpd(l_date) RETURNING l_flag,l_azn02,g_ss,l_azn04,l_azn05
   LET l_date1 = g_today                           #取季別 
   LET l_time = TIME(CURRENT)
   LET l_year = tm.yy USING '&&&&'
   LET l_month = MONTH(l_date1) USING '&&'
   LET l_day = DAY(l_date1) USING  '&&'
   LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,
                l_time[1,2],l_time[4,5],l_time[7,8]
   IF tm.exp = '1' THEN
      IF g_mai03 <> '3' THEN
         LET g_str1 = 'A01'
      ELSE
         LET g_str1 = 'A02'
      END IF

      IF NOT cl_null(g_axz09) THEN
         LET g_str1[4,9] = g_axz09
      END IF
      IF NOT cl_null(g_yy) THEN
         LET g_str1[10,12] = g_yy USING '&&&'
      END IF
      IF NOT cl_null(g_ss) THEN
         LET g_str1[13,14] = g_ss USING '&&'
      END IF
      
      LET l_name = "aglg003",l_dt CLIPPED,".txt"
      LET g_name1 = FGL_GETENV("TEMPDIR") CLIPPED,'/',l_name
   ELSE
     SELECT ze03 INTO l_ze03 FROM ze_file WHERE ze01='agl-512' AND ze02=g_lang
      LET l_ze03_s = l_ze03          
      LET sheet1 = l_ze03_s.trim()  
      DISPLAY sheet1

      IF g_mai03 <> '3' THEN
         LET l_unixpath = "$TOP/tool/report/aglr110_1.xls"
         LET l_winpath  = "C:\\TIPTOP\\aglg0031",l_dt CLIPPED,".xls"
         SELECT ze03 INTO l_ze03 FROM ze_file WHERE ze01='agl-513' AND ze02=g_lang
      ELSE
         LET l_unixpath = "$TOP/tool/report/aglr110_2.xls"
         LET l_winpath  = "C:\\TIPTOP\\aglg0032",l_dt CLIPPED,".xls"
         SELECT ze03 INTO l_ze03 FROM ze_file WHERE ze01='agl-514' AND ze02=g_lang
      END IF
      LET l_ze03_s = l_ze03   #FUN-A60039
      LET sheet2 = l_ze03_s.trim()   #FUN-A60039
      LET li_result=cl_download_file(l_unixpath,l_winpath)
      IF STATUS THEN
         CALL cl_err('',"amd-021",1)
         DISPLAY "Download fail!!"
         LET g_success = 'N'
         RETURN
      END IF
      LET g_cmd = "EXCEL ",l_winpath
      CALL ui.Interface.frontCall("standard","shellexec",[g_cmd],[])
      SLEEP 10
      CALL ui.Interface.frontCall("WINDDE","DDEConnect",[g_cmd,sheet1],[li_result])
      CALL g003_checkError(li_result,"Connect DDE Sheet1")
      CALL g003_exceldata(1,' ',' ',' ',' ',' ')
      CALL ui.Interface.frontCall("WINDDE","DDEFinish",[l_cmd,sheet1],[li_result])
      CALL ui.Interface.frontCall("WINDDE","DDEConnect",[g_cmd,sheet2],[li_result])
      CALL g003_checkError(li_result,"Connect DDE Sheet2")
   END IF
   CASE WHEN tm.rtype='0' LET g_msg=" 1=1"
        WHEN tm.rtype='1' 
        #  LET g_msg=" substr(maj23,1,1)='1'"
           LET g_msg=" maj23[1,1]='1'"   #FUN-B40029
        WHEN tm.rtype='2'
        #  LET g_msg=" substr(maj23,1,1)='2'"
            LET g_msg=" maj23[1,1]='2'"   #FUN-B40029
        OTHERWISE LET g_msg = " 1=1"
   END CASE
   LET g_basetot1 = NULL

    # LET l_sql = "SELECT * FROM ",g_dbs_axz03 CLIPPED," maj_file",               #FUN-A50076 mark
      LET l_sql = "SELECT * FROM ",cl_get_target_table(g_plant_axz03,'maj_file'), #FUN-A50076 add
                  " WHERE maj01 = '",tm.a,"'",
                  "   AND ",g_msg CLIPPED,
                  " ORDER BY maj02"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
      CALL cl_parse_qry_sql(l_sql,g_plant_axz03) RETURNING l_sql                  #FUN-A50076 add 
      PREPARE g003_pre1 FROM l_sql
      IF STATUS THEN
         CALL cl_err('prepare:',STATUS,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)   #FUN-B90028 add
         EXIT PROGRAM
      END IF
      DECLARE g003_curs1 CURSOR FOR g003_pre1
      FOR l_i = 1 TO 100
        LET g_tot1[l_i] = 0
      END FOR
      
      FOR g_i = 1 TO 100
         LET g_tot2[g_i] = 0
      END FOR 
      #--MOD-A70192 start--
      FOR g_i = 1 TO 100
         LET g_tot2[g_i] = 0
      END FOR
      #--MOD-A70192 end--
     
      #增加抓取會計期間落在哪一季 
      LET g_r = 0
      FOREACH g003_curs1 INTO l_maj.*
         IF STATUS THEN
            CALL cl_err('foreach:',STATUS,1)
            EXIT FOREACH
         END IF
         
         LET l_amt1 = 0
         LET l_amt2 = 0
         #CALL g003_xbrl_bal(tm.yy,l_maj.*) RETURNING sr.bal1    #今年金額  #MOD-A70192 mark
         #CALL g003_xbrl_bal(tm.yy-1,l_maj.*) RETURNING sr.bal2  #去年金額  #MOD-A70192 mark

         #--MOD-A70192 start--
         LET l_amt1 = 0
         LET l_amt2 = 0
         CALL g003_xbrl_bal(tm.yy,l_maj.*) RETURNING l_amt1    #今年金額
         CALL g003_xbrl_bal(tm.yy-1,l_maj.*) RETURNING l_amt2  #去年金額
         #--MOD-A70192 end--

         #匯率的轉換
         IF tm.o = 'Y' THEN
            LET l_amt1 = l_amt1 * tm.q
            LET l_amt2 = l_amt2 * tm.q
         END IF

         #合計階數處理
         IF l_maj.maj03 MATCHES "[012]" AND l_maj.maj08 > 0 THEN
           FOR i = 1 TO 100
               IF l_maj.maj09 = '-' THEN
                  LET g_tot1[i] = g_tot1[i] - l_amt1
                  LET g_tot2[i] = g_tot2[i] - l_amt2
               ELSE
                 LET g_tot1[i] = g_tot1[i] + l_amt1
                 LET g_tot2[i] = g_tot2[i] + l_amt2
               END IF
            END FOR
            LET k = l_maj.maj08
            LET l_bal1= g_tot1[k]
            LET l_bal2= g_tot2[k]
            FOR i = 1 TO l_maj.maj08
               LET g_tot1[i] = 0
               LET g_tot2[i] = 0
            END FOR
         ELSE         
            IF l_maj.maj03 = '5' THEN
               LET l_bal1 = l_amt1
               LET l_bal2 = l_amt2
            ELSE
               LET l_bal1 = NULL
               LET l_bal2 = NULL
            END IF
         END IF
     
         #百分比基準科目
         IF l_maj.maj11 = 'Y' THEN
            LET g_basetot1 = l_bal1
            LET g_basetot2 = l_bal2
            LET g_basetot1 = g_basetot1/g_unit #CHI-A70046 add
            LET g_basetot2 = g_basetot2/g_unit #CHI-A70046 add
            IF g_basetot1 = 0 THEN
               LET g_basetot1 = NULL
            END IF
            IF g_basetot2 = 0 THEN
               LET g_basetot2 = NULL
            END IF
            IF l_maj.maj07='2' THEN
               LET g_basetot1 = g_basetot1 * -1
               LET g_basetot2 = g_basetot2 * -1
            END IF
         END IF
        
         IF l_maj.maj03 = '0' THEN
             CONTINUE FOREACH
         END IF 
     
         IF l_maj.maj07 = '2' THEN
            LET l_bal1 = l_bal1 * -1
            LET l_bal2 = l_bal2 * -1
         END IF

         IF tm.h = 'Y' THEN
            LET l_maj.maj20 = l_maj.maj20e
         END IF

         LET l_maj.maj20 = l_maj.maj05 SPACES,l_maj.maj20
         LET l_bal1=l_bal1/g_unit
         LET l_bal2=l_bal2/g_unit

         SELECT azi04 INTO l_azi04_1
           FROM azi_file
          WHERE azi01 = tm.p
            AND aziacti = 'Y'
         IF tm.o = 'Y' THEN
            SELECT azi04 INTO l_azi04_1
              FROM azi_file
             WHERE azi01 = tm.p
               AND aziacti = 'Y'
            LET l_bal1 = cl_digcut(l_bal1,l_azi04_1)
            LET l_bal2 = cl_digcut(l_bal2,l_azi04_1)
         ELSE                                        #MOD-B40063
            LET l_bal1 = cl_digcut(l_bal1,g_azi04)   #MOD-B40063
            LET l_bal2 = cl_digcut(l_bal2,g_azi04)   #MOD-B40063
         END IF

         #餘額為 0 者不列印 
         IF (tm.c='N' OR l_maj.maj03='2') AND
            l_maj.maj03 MATCHES "[0125]" THEN
            IF (l_bal1 = 0 AND l_bal2=0) THEN
               CONTINUE FOREACH
            END IF
         END IF
 
         LET g_r = g_r +1
        #CALL g003_tofile(g_r,l_name,l_maj.maj21,l_maj.maj20,l_bal1,l_bal2)   #FUN-B60077 mark
         CALL g003_tofile(g_r,l_name,l_maj.maj31,l_maj.maj20,l_bal1,l_bal2)   #FUN-B60077 add
      END FOREACH  

      IF tm.exp = '1' THEN
         LET l_url = FGL_GETENV("FGLASIP") CLIPPED,"/tiptop/out/",l_name
         CALL ui.Interface.frontCall("standard", "shellexec", ["EXPLORER \"" || l_url || "\""],[])
      ELSE
         CALL ui.Interface.frontCall("WINDDE","DDEFinishAll",[],[li_result])
      END IF

END FUNCTION
#FUN-A50076 -----------------------------------------add end------------------------------------

#FUN-A50076 -----------------------------------------add start----------------------------------
FUNCTION g003_xbrl_bal(p_yy,l_maj)
DEFINE p_yy      LIKE type_file.chr4
DEFINE l_amt1    LIKE aah_file.aah04
DEFINE g_bal     LIKE aah_file.aah04
DEFINE l_tmp     LIKE aah_file.aah04
DEFINE l_endy1   LIKE abb_file.abb07
DEFINE l_endy2   LIKE abb_file.abb07
DEFINE l_sql     LIKE type_file.chr1000
DEFINE l_maj RECORD LIKE maj_file.*
DEFINE maj       RECORD LIKE maj_file.*
DEFINE g_i       LIKE type_file.num5       
DEFINE l_azi04_1 LIKE azi_file.azi04

   LET l_amt1 = 0
   IF NOT cl_null(l_maj.maj21) THEN
      IF cl_null(l_maj.maj22) THEN
         LET l_maj.maj22 = l_maj.maj21
      END IF
      LET l_sql = "SELECT SUM(axh08-axh09) ",
                # "  FROM axh_file,",g_dbs_axz03,"aag_file",                         #FUN-A50076 mark 
                  "  FROM axh_file,",cl_get_target_table(g_plant_axz03,'aag_file'),  #FUN-A50076 add
                  " WHERE axh00 = '",tm.b,"'",
                  "   AND axh01 = '",tm.axa01,"'",
                  "   AND axh02 = '",tm.axa02,"'",
                  "   AND axh03 = '",tm.axa03,"'",
                  "   AND axh05 BETWEEN '",l_maj.maj21,"' AND '",l_maj.maj22,"'",
                  "   AND axh00 = aag00",
                  "   AND aag00 = '",tm.b,"'",
                  "   AND axh06 = ",p_yy,
#                 "   AND axh07 BETWEEN ",tm.bm," AND ",tm.em, #FUN-A90032 mark
                  "   AND axh07 = ",tm.em, #FUN-A90032
#                 "   AND axh05 = aag01 AND aag07 MATCHES '[23]'",       #No.TQC-B30100 Mark
                  "   AND axh05 = aag01 AND aag07 IN ('2','3')",        #No.TQC-B30100 add
                  "   AND axh13 = '",tm.ver,"'",
                  "   AND axh12 = '",x_aaa03,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,g_plant_axz03) RETURNING l_sql              #FUN-A50076 add
      PREPARE g003_sum_p1 FROM l_sql
      DECLARE g003_sum_c1 CURSOR FOR g003_sum_p1
      OPEN g003_sum_c1
      FETCH g003_sum_c1 INTO l_amt1
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","axh_file,aag_file",tm.yy,"",STATUS,"","sel axh:",1)  
         RETURN 0
      END IF               
      IF l_amt1 IS NULL THEN LET l_amt1 = 0 END IF
   END IF
   RETURN l_amt1

END FUNCTION 
#FUN-A50076 -------------------------add end---------------------------------------
   
#FUN-A50076 -------------------------add start-------------------------------------
#FUNCTION g003_tofile(p_r,p_name,p_maj21,p_maj20,p_bal1,p_bal2)  #FUN-B60077 mark
FUNCTION g003_tofile(p_r,p_name,p_maj31,p_maj20,p_bal1,p_bal2)   #FUN-B60077 modify 
DEFINE p_r          LIKE type_file.num5
DEFINE p_name       LIKE type_file.chr20
#DEFINE p_maj21      LIKE maj_file.maj21   #FUN-B60077 mark
DEFINE p_maj31      LIKE maj_file.maj31    #FUN-B60077 add 
DEFINE p_maj20      LIKE maj_file.maj20
DEFINE p_bal1       LIKE aah_file.aah04
DEFINE p_bal2       LIKE aah_file.aah04
DEFINE l_date       LIKE type_file.dat
DEFINE l_flag       LIKE type_file.chr1
DEFINE l_azn02      LIKE azn_file.azn02
DEFINE l_azn04      LIKE azn_file.azn04
DEFINE l_azn05      LIKE azn_file.azn05

   IF tm.exp = '1' THEN           #TXT
     #CALL g003_totxt(p_maj21,p_maj20,p_bal1,p_bal2)   #FUN-B60077 mark
      CALL g003_totxt(p_maj31,p_maj20,p_bal1,p_bal2)   #FUN-B60077 add 
   ELSE
     #CALL g003_exceldata('2',p_r,p_maj21,p_maj20,p_bal1,p_bal2)  #FUN-B60077 mark
      CALL g003_exceldata('2',p_r,p_maj31,p_maj20,p_bal1,p_bal2)  #FUN-B60077 add
   END IF
END FUNCTION
#FUN-A50076 -------------------------add end-------------------------------

#FUN-A50076 -------------------------add start-----------------------------
#FUNCTION g003_totxt(p_maj21,p_maj20,p_bal1,p_bal2)  #FUN-B60077 mark
#DEFINE p_maj21    LIKE maj_file.maj21               #FUN-B60077 mark
FUNCTION g003_totxt(p_maj31,p_maj20,p_bal1,p_bal2)   #FUN-B60077 add 
DEFINE p_maj31    LIKE maj_file.maj31                #FUN-B60077 add
DEFINE p_maj20    LIKE maj_file.maj20
DEFINE p_bal1     LIKE aah_file.aah04
DEFINE p_bal2     LIKE aah_file.aah04
DEFINE l_str      LIKE type_file.chr100
DEFINE l_channel1 base.Channel
DEFINE l_cmd      LIKE type_file.chr100
DEFINE l_i        LIKE type_file.num5

   LET l_channel1 = base.Channel.create()
   CALL l_channel1.openFile(g_name1,"a")
   LET l_str=g_str1

  #IF NOT cl_null(p_maj21) THEN            #FUN-B60077 mark
  #   LET l_str[15,20] = p_maj21 CLIPPED   #FUN-B60077 mark
   IF NOT cl_null(p_maj31) THEN            #FUN-B60077 add
      LET l_str[15,20] = p_maj31 CLIPPED   #FUN-B60077 add
   END IF

   IF p_bal1>=0 THEN
      LET l_str[21,21] = '+'
   ELSE
      LET l_str[21,21] = '-'
      LET p_bal1 = p_bal1 * -1
   END IF
   LET l_str[22,36] = p_bal1 USING '&&&&&&&&&&&&&&&'

   IF p_bal2>=0 THEN
      LET l_str[37,37] = '+'
   ELSE
      LET l_str[37,37] = '-'
      LET p_bal2 = p_bal2 * -1
   END IF
   LET l_str[38,52] = p_bal2 USING '&&&&&&&&&&&&&&&'
   FOR l_i = 21 TO 52
     IF cl_null(l_str[l_i,l_i]) THEN
        LET l_str[l_i,l_i] = '0'
     END IF
   END FOR
   
  #IF NOT cl_null(p_maj21) THEN     #FUN-B60077 mark
   IF NOT cl_null(p_maj31) THEN     #FUN-B60077 add
      CALL l_channel1.write(l_str)
   END IF

END FUNCTION

FUNCTION g003_lastday()
DEFINE l_yy   LIKE type_file.num5
DEFINE l_mm   LIKE type_file.num5
   IF tm.em=12 THEN
      LET l_yy = tm.yy + 1
      LET l_mm = 1
   ELSE
      LET l_yy = tm.yy
      LET l_mm = tm.em + 1
   END IF
   RETURN MDY(l_mm,1,l_yy)-1
END FUNCTION

#FUNCTION g003_exceldata(p_s,p_r,p_maj21,p_maj20,p_bal1,p_bal2)  #FUN-B60077 mark
FUNCTION g003_exceldata(p_s,p_r,p_maj31,p_maj20,p_bal1,p_bal2)   #FUN-B60077
DEFINE p_s     LIKE type_file.chr10
DEFINE p_r     LIKE type_file.num5
#DEFINE p_maj21 LIKE maj_file.maj21  #FUN-B60077 mark
DEFINE p_maj31 LIKE maj_file.maj31   #FUN-B60077
DEFINE p_maj20 LIKE maj_file.maj20
DEFINE p_bal1  LIKE aah_file.aah04
DEFINE p_bal2  LIKE aah_file.aah04
DEFINE l_c     LIKE type_file.num5
DEFINE l_ze03  LIKE ze_file.ze03
DEFINE l_ze03_s STRING  
DEFINE l_str   STRING
DEFINE ls_cell STRING
DEFINE li_result LIKE type_file.num5
DEFINE l_cmd   LIKE type_file.chr100
DEFINE l_err   STRING

   IF p_s = "1" THEN
#公司代號
      SELECT ze03 INTO l_ze03
        FROM ze_file
       WHERE ze01 = 'agl-505'
         AND ze02 = g_lang
      LET l_str = l_ze03
      LET l_ze03_s = l_ze03       
      LET l_str = l_ze03_s.trim()   
      LET ls_cell = "R1C1"
      CALL ui.Interface.frontCall("WINDDE","DDEPoke",[g_cmd,sheet1,ls_cell,l_str],li_result)
      CALL g003_checkError(li_result,"DDEPoke Sheet1 R1C1")
      LET l_str = g_axz09
      LET ls_cell = "R1C2"
      CALL ui.Interface.frontCall("WINDDE","DDEPoke",[g_cmd,sheet1,ls_cell,l_str],[li_result])
      CALL g003_checkError(li_result,"DDEPoke Sheet1 R1C2")
#年度
     SELECT ze03 INTO l_ze03
        FROM ze_file
       WHERE ze01 = 'agl-506'
         AND ze02 = g_lang
      LET l_ze03_s = l_ze03     
      LET l_str = l_ze03_s.trim()  
      LET ls_cell = "R2C1"
      CALL ui.Interface.frontCall("WINDDE","DDEPoke",[g_cmd,sheet1,ls_cell,l_str],[li_result])
      CALL g003_checkError(li_result,"DDEPoke Sheet1 R2C1")
      LET l_str = g_yy
      LET ls_cell = "R2C2"
      CALL ui.Interface.frontCall("WINDDE","DDEPoke",[g_cmd,sheet1,ls_cell,l_str],[li_result])
      CALL g003_checkError(li_result,"DDEPoke Sheet1 R2C2")
#季别
     SELECT ze03 INTO l_ze03
        FROM ze_file
       WHERE ze01 = 'agl-507'
         AND ze02 = g_lang
      LET l_ze03_s = l_ze03     
      LET l_str = l_ze03_s.trim() 
      LET ls_cell = "R3C1"
      CALL ui.Interface.frontCall("WINDDE","DDEPoke",[g_cmd,sheet1,ls_cell,l_str],[li_result])
      CALL g003_checkError(li_result,"DDEPoke Sheet1 R3C1")
      LET l_str = g_ss
      LET ls_cell = "R3C2"
      CALL ui.Interface.frontCall("WINDDE","DDEPoke",[g_cmd,sheet1,ls_cell,l_str],[li_result])
      CALL g003_checkError(li_result,"DDEPoke Sheet1 R3C2")
   END IF
   IF p_r = 1 THEN
#科目代号
      SELECT ze03 INTO l_ze03
        FROM ze_file
       WHERE ze01 = 'agl-508'
         AND ze02 = g_lang
      LET l_ze03_s = l_ze03      
      LET l_str = l_ze03_s.trim() 
      CALL ui.Interface.frontCall("WINDDE","DDEPoke",[g_cmd,sheet2,"R1C1",l_str],[li_result])
      CALL g003_checkError(li_result,"DDEPoke Sheet2 R1C1")

#科目名称
      SELECT ze03 INTO l_ze03
        FROM ze_file
       WHERE ze01 = 'agl-509'
         AND ze02 = g_lang
      LET l_ze03_s = l_ze03     
      LET l_str = l_ze03_s.trim()  
      CALL ui.Interface.frontCall("WINDDE","DDEPoke",[g_cmd,sheet2,"R1C2",l_str],[li_result])   
      CALL g003_checkError(li_result,"DDEPoke Sheet2 R1C2")
#今年数值
     SELECT ze03 INTO l_ze03
       FROM ze_file
      WHERE ze01 = 'agl-510'
        AND ze02 = g_lang
     LET l_ze03_s = l_ze03      #FUN-A60039
     LET l_str = l_ze03_s.trim()  #FUN-A60039
     CALL ui.Interface.frontCall("WINDDE","DDEPoke",[g_cmd,sheet2,"R1C3",l_str],[li_result])
     CALL g003_checkError(li_result,"DDEPoke Sheet2 R1C3")   
#去年数值     
     SELECT ze03 INTO l_ze03
       FROM ze_file
      WHERE ze01 = 'agl-511'
        AND ze02 = g_lang
     LET l_ze03_s = l_ze03       #FUN-A60039
     LET l_str = l_ze03_s.trim()   #FUN-A60039
     CALL ui.Interface.frontCall("WINDDE","DDEPoke",[g_cmd,sheet2,"R1C4",l_str],[li_result])
     CALL g003_checkError(li_result,"DDEPoke Sheet2 R1C4")
     LET g_r = g_r + 1
     LET p_r = g_r
   END IF
    
   FOR l_c = 1 TO 4
          LET ls_cell = "R" || p_r || "C" || l_c
          CASE l_c
             WHEN 1
               #IF NOT cl_null(p_maj21) THEN   #FUN-B60077 mark
               #   LET l_str = p_maj21         #FUN-B60077 mark
                IF NOT cl_null(p_maj31) THEN   #FUN-B60077
                   LET l_str = p_maj31         #FUN-B60077
                   CALL ui.Interface.frontCall("WINDDE","DDEPoke",[g_cmd,sheet2,ls_cell,l_str],[li_result])
                   CALL g003_checkError(li_result,"DDEPoke Sheet2 ")
                END IF
             WHEN 2
                IF NOT cl_null(p_maj20) THEN
                   LET l_str = p_maj20
                   CALL ui.Interface.frontCall("WINDDE","DDEPoke",[g_cmd,sheet2,ls_cell,l_str],[li_result])
                   CALL g003_checkError(li_result,"DDEPoke Sheet2 ")
                END IF
             WHEN 3
               #IF NOT cl_null(p_bal1) AND NOT cl_null(p_maj21) THEN   #FUN-B60077 mark
                IF NOT cl_null(p_bal1) AND NOT cl_null(p_maj31) THEN   #FUN-B60077
                   LET l_str = p_bal1
                   CALL ui.Interface.frontCall("WINDDE","DDEPoke",[g_cmd,sheet2,ls_cell,l_str],[li_result])
                   CALL g003_checkError(li_result,"DDEPoke Sheet2 ")
                END IF
             WHEN 4
               #IF NOT cl_null(p_bal1) AND NOT cl_null(p_maj21) THEN   #FUN-B60077 mark
                IF NOT cl_null(p_bal1) AND NOT cl_null(p_maj31) THEN   #FUN-B60077
                   LET l_str = p_bal2
                   CALL ui.Interface.frontCall("WINDDE","DDEPoke",[g_cmd,sheet2,ls_cell,l_str],[li_result])
                   CALL g003_checkError(li_result,"DDEPoke Sheet2 ")
                END IF
          END CASE
       END FOR
END FUNCTION

FUNCTION g003_checkError(p_result,p_msg)
   DEFINE   p_result   SMALLINT
   DEFINE   p_msg      STRING
   DEFINE   ls_msg     STRING
   DEFINE   li_result  SMALLINT

   IF p_result THEN
      RETURN
   END IF
   DISPLAY p_msg," DDE ERROR:"
   CALL ui.Interface.frontCall("WINDDE","DDEError",[],[ls_msg])
   DISPLAY ls_msg
   CALL ui.Interface.frontCall("WINDDE","DDEFinishAll",[],[li_result])
   IF NOT li_result THEN
      DISPLAY "Exit with DDE Error."
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B90028--add--
   CALL cl_gre_drop_temptable(l_table)   #FUN-B90028 add
   EXIT PROGRAM
END FUNCTION
#FUN-A50076 --------------------------------------add end--------------------------------
#No.FUN-9C0072 精簡程式碼

###GENGRE###START
FUNCTION aglg003_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg003")
        IF handler IS NOT NULL THEN
            START REPORT aglg003_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
          
            DECLARE aglg003_datacur1 CURSOR FROM l_sql
            FOREACH aglg003_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg003_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg003_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg003_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
#FUN-B90028-------------STAR-------------
    DEFINE l_year        STRING
    DEFINE l_maj20       STRING
    DEFINE l_maj05       STRING          
    DEFINE l_maj20e      STRING    
    DEFINE l_str         STRING         
    DEFINE l_unit        STRING    
    DEFINE l_bal1        LIKE type_file.num5 
    DEFINE l_per         LIKE type_file.num5 
    DEFINE l_per1        STRING
    DEFINE l_tmyy        STRING
    DEFINE l_tmbm        STRING
    DEFINE l_tmem        STRING
    DEFINE l_fmt         STRING
    DEFINE l_str1        STRING
    DEFINE l_axz02       LIKE axz_file.axz02
    DEFINE l_x           LIKE type_file.num5 
#FUN-B90028------------END---------------    
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name    #FUN-B90028 add g_ptime,g_used_name
            PRINTX tm.*
#FUN-B90028-------------STAR---------
            LET l_tmyy = tm.yy
            LET l_tmbm = tm.bm
            LET l_tmem = tm.em
            LET l_year = l_tmyy.trim(),'/',l_tmbm.trim(),'-',l_tmem.trim()
            PRINTX l_year

            SELECT axz02 INTO l_axz02 FROM axz_file WHERE axz01=tm.axa02
            LET l_str1=tm.axa02 CLIPPED,'(',l_axz02 CLIPPED,')'
            PRINTX l_str1
#FUN-B90028--------------END---------              
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
#FUN-B90028--------------STAR-------------
            IF tm.acc_code = 'Y' THEN LET l_x = 14.9 ELSE LET l_x = 0 END IF
            PRINTX l_x  
            IF tm.h = 'Y' THEN
               LET l_maj05 = sr1.maj05
               LET l_maj05 = l_maj05 SPACES
               LET l_maj20e = sr1.maj20e
               LET l_maj20e = l_maj20e.trimright()
               LET l_str = l_maj05,l_maj20e
            ELSE
               LET l_maj05 = sr1.maj05
               LET l_maj05 = l_maj05 SPACES
               LET l_maj20 = sr1.maj20
               LET l_maj20 = l_maj20.trimright()
               LET l_str = l_maj05,l_maj20
            END IF
            PRINTX l_str

            IF sr1.maj09 = '-' THEN
               LET l_bal1 = sr1.bal1 * (-1)
            ELSE
               LET l_bal1 = sr1.bal1
            END IF
            PRINTX l_bal1
            LET l_fmt = cl_gr_numfmt("azi_file","azi05",tm.e)
            PRINTX l_fmt
 
            IF g_basetot1 = '' THEN
               LET l_per = 0
            ELSE
               LET l_per1 = g_basetot1
               IF l_per1 != 0 THEN
                  LET l_per = sr1.bal1 / l_per1 * 100
               ELSE 
                  LET l_per = 0
               END IF
            END IF
            PRINTX l_per

#FUN-B90028---------------END----------------
            PRINTX sr1.*

        
        ON LAST ROW
            LET l_unit = cl_gr_getmsg("gre-246",g_lang,tm.d)
            PRINTX l_unit

END REPORT
###GENGRE###END
