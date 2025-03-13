# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aglg808.4gl
# Descriptions...: 科目異動碼明細表(aglg808)
#                : By TSD.Ken 080714
#                  copy from aglr810
#
#                  construct的欄位是abg，那抓取上期是(abi)
#                  所以都會用replace替換。
#                  抓取沖帳也是，沖帳是abh。也要替換掉
#
#                  報表多加newgrup群組->為了要依異動碼跳頁。
#                  科目+異動碼跳碼(tm.c打勾)
 
#                  Mark ..... STR 沒有了
#                  原餘額在rpt(l_diff)應該是有錯。原#tot，在rpt那邊修正。
#                  餘額改拿最後一筆的l_diff來show。
#                  Mark ..... END
 
#                  Mark ..... STR
#                  餘額為0不列印。->有上期的abi，但本期此科目+異動碼都沒有
#                  立、沖。
#                  則此筆不印。
#                  在cs3前處理，如果有type=1，且它的abi05，abi11
#                  在本期沒有的話，則此筆的abi05, abi11不取。
#                  Mark ..... END
#
#  TSD.Ken 080715 NOTE
#  現在整個程式的概念是，以傳票來看，此科目+異動碼一的傳票，
#  還有多少沒被沖掉的，show到報表。
#
#  TSD.Ken 080807 NOTE
#  因為要細到此張傳票，異動碼，摘要，立帳 ← 被沖多少
#  直接使用傳票+項次←←看有多少的沖帳是沖這筆的
 
# TSD.Ken 080815 NOTE
# 修改餘額為0不列印這段，現在不在程式裡面寫，改在rpt那邊做
# rpt就設定，如果餘額為0有打勾，且此筆餘額是0，就不show
 
# create      : #FUN-8A0105  08/10/30 by duke  
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-A10003 10/04/15 By Summer 將l_table的變數定義成STRING 
# Modify.........: No.FUN-B80057 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No.FUN-C40071 12/05/23 By zhangwei CR轉GR


DATABASE ds

#GLOBALS "../../../tiptop/config/top. global"   #FUN-8A0105  MARK  #No.FUN-B80057--加了空格----
GLOBALS "../../config/top.global"              #FUN-8A0105  ADD
 
 
DEFINE g_wc LIKE type_file.chr1000
DEFINE g_abi05 LIKE abi_file.abi05
DEFINE g_abi02 LIKE abi_file.abi02
DEFINE g_abi11 LIKE abi_file.abi11
DEFINE g_abi06 LIKE abi_file.abi06
DEFINE g_abi10 LIKE abi_file.abi10
DEFINE tm RECORD                             # Print condition RECORD
          wc      LIKE type_file.chr1000,    # Where condition  #No.FUN-680098  VARCHAR(300)
          edate   LIKE type_file.dat,        # 截止日期   #No.FUN-680098    date   
          b       LIKE aaa_file.aaa01,       # 帳別
          c       LIKE type_file.chr1,       # 依異動碼跳頁
          d       LIKE type_file.chr1,       # 餘額為0不列印
          e       LIKE type_file.chr1,       #列印額外名稱 #FUN-6C0012
          more    LIKE type_file.chr1        # Input more condition(Y/N) #No.FUN-680098 VARCHAR(1)      
          END RECORD,
       g_bookno   LIKE aaa_file.aaa01,       # 帳別
       l_orderA   ARRAY[2] OF LIKE type_file.chr20      #No.FUN-680098     VARCHAR(20)   
DEFINE g_i        LIKE type_file.num5     #count/index for any purpose  #No.FUN-680098 SMALLINT
#No.FUN-7C0038-------------START-------------
DEFINE g_sql      STRING
DEFINE l_table    STRING  #No.CHI-A10003 mod LIKE type_file.chr20-->STRING
DEFINE l_table1   STRING  #No.CHI-A10003 mod LIKE type_file.chr20-->STRING
DEFINE g_str      STRING
#No.FUN-7C0038-------------END-------------
DEFINE g_sss  STRING 
DEFINE g_cnt  INTEGER
 
DEFINE l_table3   STRING  #No.CHI-A10003 mod LIKE type_file.chr20-->STRING
 
###GENGRE###START
TYPE sr1_t RECORD
    aag02 LIKE aag_file.aag02,
    aag13 LIKE aag_file.aag13,
    abi05 LIKE abi_file.abi05,
    ahe02 LIKE ahe_file.ahe02,
    abi11 LIKE abi_file.abi11,
    abi06 LIKE abi_file.abi06,
    abi01 LIKE abi_file.abi01,
    type LIKE type_file.chr1,
    abi07 LIKE abi_file.abi07,
    abi10 LIKE abi_file.abi10,
    balance LIKE abi_file.abi08,
    aag222 LIKE aag_file.aag222,
    aag15 LIKE aag_file.aag15,
    aag16 LIKE aag_file.aag16,
    aag17 LIKE aag_file.aag17,
    aag18 LIKE aag_file.aag18,
    aag31 LIKE aag_file.aag31,
    aag32 LIKE aag_file.aag32,
    aag33 LIKE aag_file.aag33,
    aag34 LIKE aag_file.aag34,
    aag35 LIKE aag_file.aag35,
    aag36 LIKE aag_file.aag36,
    abi12 LIKE abi_file.abi12,
    abi13 LIKE abi_file.abi13,
    abi14 LIKE abi_file.abi14,
    abi31 LIKE abi_file.abi31,
    abi32 LIKE abi_file.abi32,
    abi33 LIKE abi_file.abi33,
    abi34 LIKE abi_file.abi34,
    abi35 LIKE abi_file.abi35,
    abi36 LIKE abi_file.abi36,
    abi02 LIKE abi_file.abi02
END RECORD

TYPE sr2_t RECORD
    aag02 LIKE aag_file.aag02,
    aag13 LIKE aag_file.aag13,
    abi05 LIKE abi_file.abi05,
    ahe02 LIKE ahe_file.ahe02,
    abi11 LIKE abi_file.abi11,
    abi06 LIKE abi_file.abi06,
    abi01 LIKE abi_file.abi01,
    type LIKE type_file.chr1,
    abi07 LIKE abi_file.abi07,
    abi10 LIKE abi_file.abi10,
    balance LIKE abi_file.abi08,
    l_rem LIKE abi_file.abi08,
    l_diff LIKE abi_file.abi08,
    aag222 LIKE aag_file.aag222,
    l_str LIKE type_file.chr1000,
    abc03 LIKE abc_file.abc03,
    abc04 LIKE abc_file.abc04,
    newgrup LIKE type_file.chr1000
END RECORD

TYPE sr3_t RECORD
    abi050 LIKE abi_file.abi05,
    abi110 LIKE abi_file.abi11
END RECORD
###GENGRE###END

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                  # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CGL")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114 #FUN-BB0047 mark
 
   LET g_bookno= ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)         # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc    = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.b     = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No.FUN-570264 ---end---
   LET tm.e   = ARG_VAL(14)   #FUN-6C0012
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
#No.FUN-7C0038-------------START-------------
#   l_table用于匯集存儲初始數據,與RECORD sr對應
   LET g_sql = "aag02.aag_file.aag02,",
               "aag13.aag_file.aag13,",
               "abi05.abi_file.abi05,",
               "ahe02.ahe_file.ahe02,",
               "abi11.abi_file.abi11,",
               "abi06.abi_file.abi06,",
               "abi01.abi_file.abi01,",
               "type.type_file.chr1,",
               "abi07.abi_file.abi07,",
               "abi10.abi_file.abi10,",
               "balance.abi_file.abi08,",
               "aag222.aag_file.aag222,",
               "aag15.aag_file.aag15,",
               "aag16.aag_file.aag16,",
               "aag17.aag_file.aag17,",
               "aag18.aag_file.aag18,",
               "aag31.aag_file.aag31,",
               "aag32.aag_file.aag32,",
               "aag33.aag_file.aag33,",
               "aag34.aag_file.aag34,",
               "aag35.aag_file.aag35,",
               "aag36.aag_file.aag36,",
               "abi12.abi_file.abi12,",
               "abi13.abi_file.abi13,",
               "abi14.abi_file.abi14,",
               "abi31.abi_file.abi31,",
               "abi32.abi_file.abi32,",
               "abi33.abi_file.abi33,",
               "abi34.abi_file.abi34,",
               "abi35.abi_file.abi35,",
               "abi36.abi_file.abi36,",
               "abi02.abi_file.abi02"
   LET l_table = cl_prt_temptable('aglg808',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
#  臨時表字段的順序依據原報表的畫面欄位呈現順序
   LET g_sql = "aag02.aag_file.aag02,",
               "aag13.aag_file.aag13,",
               "abi05.abi_file.abi05,",
               "ahe02.ahe_file.ahe02,",
               "abi11.abi_file.abi11,",
               "abi06.abi_file.abi06,",
               "abi01.abi_file.abi01,",
               "type.type_file.chr1,",
               "abi07.abi_file.abi07,",
               "abi10.abi_file.abi10,",
               "balance.abi_file.abi08,",
               "l_rem.abi_file.abi08,",
               "l_diff.abi_file.abi08,",
               "aag222.aag_file.aag222,",
               "l_str.type_file.chr1000,",
               "abc03.abc_file.abc03,",
               "abc04.abc_file.abc04,",
               "newgrup.type_file.chr1000" #Ken 080714
      
   LET l_table1 = cl_prt_temptable('aglg8081',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
#No.FUN-7C0038-------------END-------------
 
   LET g_sql = "abi050.abi_file.abi05,", #會科
               "abi110.abi_file.abi11"   
 
   LET l_table3 = cl_prt_temptable('aglg8081xxx',g_sql) CLIPPED
   IF l_table3 = -1 THEN EXIT PROGRAM END IF
 
 
#   SELECT azi04,azi05 INTO g_azi04,g_azi05 FROM azi_file WHERE azi01=g_aza.aza17                 #No.CHI-6A0004 mark
 
   IF g_bookno IS  NULL OR g_bookno = ' ' THEN
      LET g_bookno = g_aaz.aaz64
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N'  THEN # If background job sw is off
      CALL aglg808_tm(0,0)                    # Input print condition
   ELSE
      CALL aglg808()                          # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION aglg808_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01           #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680098  SMALLINT
       l_cmd          LIKE type_file.chr1000        #No.FUN-680098  VARCHAR(400)
DEFINE li_chk_bookno  LIKE type_file.num5        #No.FUN-670005  #No.FUN-680098  smallint     
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 11 END IF
   CALL s_dsmark(g_bookno)
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 24
   ELSE LET p_row = 4 LET p_col = 11
   END IF
   OPEN WINDOW aglg808_w AT p_row,p_col WITH FORM "agl/42f/aglg808"  #FUN-8A0105
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   IF tm.b IS  NULL OR tm.b = ' ' THEN
      LET tm.b = g_aza.aza81
   END IF
   LET tm.edate = g_today
   LET tm.e     = 'N'  #FUN-6C0012
   LET tm.c     = 'Y'
   LET tm.d     = 'Y'
   LET tm.more  = 'N'
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON aag01, abg11, abg12, abg13, abg14
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
         LET INT_FLAG = 0 CLOSE WINDOW aglg808_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
      IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
 
      DISPLAY BY NAME tm.edate,tm.e,tm.more   #FUN-6C0012
 
      INPUT BY NAME tm.edate,tm.b,
                    tm.c, tm.d,   #by TSD.Ken 
                    tm.e,tm.more 
      WITHOUT DEFAULTS
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
         AFTER FIELD edate
            IF  cl_null(tm.edate) THEN NEXT FIELD edate END IF
 
         AFTER FIELD b
            IF tm.b IS NULL THEN NEXT FIELD b END IF
            CALL s_check_bookno(tm.b,g_user,g_plant) RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
               NEXT FIELD b 
            END IF 
            SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
            IF STATUS THEN 
               CALL cl_err3("sel","aaa_file",tm.b,"",STATUS,"","sel aaa:",0)  # NO.FUN-660123
               NEXT FIELD b
            END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies)
                  RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG 
            CALL cl_cmdask()    # Command execution
         ON ACTION CONTROLP
            IF INFIELD(b) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aaa'
               LET g_qryparam.default1 = tm.b
               CALL cl_create_qry() RETURNING tm.b
               DISPLAY BY NAME tm.b
               NEXT FIELD b
            END IF
 
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
         LET INT_FLAG = 0 CLOSE WINDOW aglg808_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM   
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aglg808'
         IF SQLCA.sqlcode OR cl_null(l_cmd) THEN
            CALL cl_err('aglg808','9031',1)   
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_bookno CLIPPED,"' ",
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.edate CLIPPED,"'",
                        " '",tm.b CLIPPED,"'",
                        " '",tm.e CLIPPED,"'",    #FUN-6C0012
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aglg808',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW aglg808_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL aglg808()
      ERROR ""
   END WHILE
   CLOSE WINDOW aglg808_w
END FUNCTION
 
FUNCTION aglg808()
DEFINE l_name     LIKE type_file.chr20,            # External(Disk) file name        #No.FUN-680098 VARCHAR(20)
#      l_time     LIKE type_file.chr8              #No.FUN-6A0073
       l_sql      LIKE type_file.chr1000,          # RDSQL STATEMENT                 #No.FUN-680098 VARCHAR(1000)
       l_abh09    LIKE abh_file.abh09,
       l_za05     LIKE za_file.za05,               #No.FUN-680098 VARCHAR(40)
       l_order    ARRAY[2] OF LIKE abh_file.abh11, #No.FUN-680098 VARCHAR(30)         
       l_yy,l_mm  LIKE type_file.num10,            #No.FUN-680098  intger     
       l_bdate    LIKE type_file.dat,              #No.FUN-680098 date      
       l_lastyy   LIKE type_file.num10,            #No.FUN-680098 integr      
       l_lastmm   LIKE type_file.num10,            #No.FUN-680098 integr      
       p_order    LIKE type_file.chr1              #No.FUN-680098 VARCHAR(1)      
#NO.FUN-7C0038--------------------START------
#      sr        RECORD
#                type      LIKE type_file.chr1,   #No.FUN-680098  VARCHAR(1)
#                abi01     LIKE  abi_file.abi01,  #傳票編號
#                abi02     LIKE  abi_file.abi02,  #項次
#                abi03     LIKE  abi_file.abi03,  #年度   
#                abi04     LIKE  abi_file.abi04,  #期別   
#                abi05     LIKE  abi_file.abi05,  #會計科目
#                abi06     LIKE  abi_file.abi06,  #傳票日期
#                abi07     LIKE  abi_file.abi07,  #部門
#                abi08     LIKE  abi_file.abi08,  #金額
#                abi10     LIKE  abi_file.abi10,  #摘要
#                abi11     LIKE  abi_file.abi11,  #異動碼一
#                abi12     LIKE  abi_file.abi12,  #異動碼二
#                abi13     LIKE  abi_file.abi13,  #異動碼三
#                abi14     LIKE  abi_file.abi14,  #異動碼四
#                aag02     LIKE  aag_file.aag02,  #會計名稱
#                aag13     LIKE  aag_file.aag13,  #額外名稱 #FUN-6C0012
#                aag15     LIKE  aag_file.aag15,  #異動1-名稱
#                aag16     LIKE  aag_file.aag16,  #異動2-名稱
#                aag17     LIKE  aag_file.aag17,  #異動3-名稱
#                aag18     LIKE  aag_file.aag18,  #異動4-名稱
#                aag222    LIKE  aag_file.aag222,
#                #  FUN-5C0015 add (s)
#                aag31     LIKE  aag_file.aag31,  #異動5-名稱
#                aag32     LIKE  aag_file.aag32,  #異動6-名稱
#                aag33     LIKE  aag_file.aag33,  #異動7-名稱
#                aag34     LIKE  aag_file.aag34,  #異動8-名稱
#                aag35     LIKE  aag_file.aag35,  #異動9-名稱
#                aag36     LIKE  aag_file.aag36,  #異動10-名稱
#                ahe02     LIKE  ahe_file.ahe02,
#                abi31     LIKE  abi_file.abi31,  #異動碼五
#                abi32     LIKE  abi_file.abi32,  #異動碼六
#                abi33     LIKE  abi_file.abi33,  #異動碼七
#                abi34     LIKE  abi_file.abi34,  #異動碼八
#                abi35     LIKE  abi_file.abi35,  #異動碼九
#                abi36     LIKE  abi_file.abi36   #異動碼十
#                #  FUN-5C0015 add (e)
#                END RECORD
DEFINE l_no        LIKE type_file.num5
DEFINE l_abi05     LIKE abi_file.abi05            #
DEFINE l_abi11     LIKE abi_file.abi11            #  分組數據處理
DEFINE l_chg_abi05 LIKE type_file.chr1            #
DEFINE l_chg_abi11 LIKE type_file.chr1            #
DEFINE l_abc04     LIKE abc_file.abc04
DEFINE sr RECORD
          aag02    LIKE aag_file.aag02,
          aag13    LIKE aag_file.aag13,
          abi05    LIKE abi_file.abi05,
          ahe02    LIKE ahe_file.ahe02,
          abi11    LIKE abi_file.abi11,
          abi06    LIKE abi_file.abi06,
          abi01    LIKE abi_file.abi01,
          type     LIKE type_file.chr1,
          abi07    LIKE abi_file.abi07,
          abi10    LIKE abi_file.abi10,
          balance  LIKE abi_file.abi08,
          aag222   LIKE aag_file.aag222,
          aag15    LIKE aag_file.aag15,
          aag16    LIKE aag_file.aag16,
          aag17    LIKE aag_file.aag17,
          aag18    LIKE aag_file.aag18,
          aag31    LIKE aag_file.aag31,
          aag32    LIKE aag_file.aag32,
          aag33    LIKE aag_file.aag33,
          aag34    LIKE aag_file.aag34,
          aag35    LIKE aag_file.aag35,
          aag36    LIKE aag_file.aag36,
          abi12    LIKE abi_file.abi12,
          abi13    LIKE abi_file.abi13,
          abi14    LIKE abi_file.abi14,
          abi31    LIKE abi_file.abi31,
          abi32    LIKE abi_file.abi32,
          abi33    LIKE abi_file.abi33,
          abi34    LIKE abi_file.abi34,
          abi35    LIKE abi_file.abi35,
          abi36    LIKE abi_file.abi36,
          abi02    LIKE abi_file.abi02
          END RECORD
DEFINE sr1 RECORD
           aag02   LIKE aag_file.aag02,
           aag13   LIKE aag_file.aag13,
           abi05   LIKE abi_file.abi05,
           ahe02   LIKE ahe_file.ahe02,
           abi11   LIKE abi_file.abi11,
           abi06   LIKE abi_file.abi06,
           abi01   LIKE abi_file.abi01,
           type    LIKE type_file.chr1,
           abi07   LIKE abi_file.abi07,
           abi10   LIKE abi_file.abi10,
           balance LIKE abi_file.abi08,
           l_rem   LIKE abi_file.abi08,
           l_diff  LIKE abi_file.abi08,
           aag222  LIKE aag_file.aag222,
           l_str   LIKE type_file.chr1000,
           abc03   LIKE abc_file.abc03,
           abc04   LIKE type_file.chr1000,
           newgrup LIKE type_file.chr1000 #Ken 080714
           END RECORD
DEFINE     l_gx  LIKE zaa_file.zaa08
#NO.FUN-7C0038--------------------END------
 
#NO.FUN-7C0038--------------------START------
   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)
   CALL cl_del_data(l_table3)
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80057--add--
      EXIT PROGRAM
   END IF 
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)" #Ken add one ?
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80057--add--
      EXIT PROGRAM
   END IF 
#NO.FUN-7C0038----------------END-----------
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = tm.b AND aaf02 = g_rlang    #No.FUN-740020
 
   #====>資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND aaguser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
   #End:FUN-980030
 
   #---->取額外摘要
   LET l_sql = " SELECT abc03,abc04 FROM abc_file ",
               "  WHERE abc00 = '",tm.b,"'", #no.7277
               "  AND abc01 = ? ",
               "  AND abc02 = ? ",
               "  ORDER BY 1   "
   PREPARE abc_pre FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('pre abc_pre:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM 
   END IF
   DECLARE abc_cur CURSOR FOR abc_pre
 
   LET l_yy  = YEAR(tm.edate) USING '&&&&'
   LET l_mm  = MONTH(tm.edate)
   LET l_bdate = MDY(l_mm,1,l_yy)
   IF l_mm = 1 THEN
      LET l_lastyy = l_yy - 1
      LET l_lastmm = 12
   ELSE
      LET l_lastyy = l_yy
      LET l_lastmm = l_mm - 1
   END IF
 
   #---->取上月份立帳餘額之後要減沖帳金額
   LET g_wc=''
   LET g_wc=cl_replace_str(tm.wc, "abg","abi")
 
   LET l_sql = "SELECT aag02,aag13,abi05,'',abi11,abi06,abi01,'1',abi07,abi10,",
               "(abi08-abi09),aag222,aag15,aag16,aag17,aag18,aag31,aag32,",
               " aag33,aag34,aag35,aag36,abi12,abi13,abi14,abi31,abi32,",
               " abi33,abi34,abi35,abi36,abi02 ",
               "  FROM abi_file , aag_file  " ,
               " WHERE abi00 = '",tm.b,"'", #no.7277
               "   AND abi00 = aag00",      #No.FUN-740020
               "   AND ", g_wc CLIPPED,   
               "   AND abi05=aag01 AND aag222 IN ('1','2') ",
               "   AND (aag15 IS NOT NULL OR aag15 !=' ') ",
               "   AND abi04 = '",l_lastmm,"'" #Ken 080716
 
   PREPARE aglg808_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM 
   END IF
   DECLARE aglg808_curs1 CURSOR FOR aglg808_prepare1
 
   #---->取本月份立帳  
   LET l_sql = "SELECT aag02,aag13,abg03,'',abg11,abg06,abg01,'2',abg05,abg04,",
               "abg071,aag222,aag15,aag16,aag17,aag18,aag31,aag32,aag33,aag34,",
               " aag35,aag36,abg12,abg13,abg14,abg31,abg32,abg33,abg34,abg35,",
               " abg36,abg02 ",
               "  FROM abg_file,aag_file ",
               " WHERE (abg06 BETWEEN '",l_bdate,"' AND '",tm.edate,"')",
               "   AND ", tm.wc CLIPPED,
               "   AND abg00='",tm.b,"'", #no.7277
               "   AND abg00 = aag00",      #No.FUN-740020
               "   AND abg03=aag01 AND aag222 IN ('1','2') ",
               "   AND (aag15 IS NOT NULL OR aag15 !=' ') "
   PREPARE r810_abg_pre FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('pre abg_pre:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM 
   END IF
   DECLARE r810_abg_cur CURSOR FOR r810_abg_pre
 
   #---->取本月份沖帳
# {#TSD.Ken 080807 Mark 沖帳不用
#  LET g_wc=''
#  LET g_wc=cl_replace_str(tm.wc, "abg","abh")
#  LET l_sql = "SELECT aag02,aag13,abh03,'',abh11,abh021,abh01,'3',abh05,",
#              "abh04,abh09,aag222,aag15,aag16,aag17,aag18,aag31,aag32,aag33,",
#              "aag34,aag35,aag36,abh12,abh13,abh14,abh31,abh32,abh33,",
#              "abh34,abh35,abh36,abh02,abh07,abh08 ",
#              "  FROM abh_file,aag_file ",
#              " WHERE abhconf = 'Y'",
#              "  AND abh00='",tm.b,"'", 
#              "  AND abh00 = aag00",   
#              "  AND (abh021 BETWEEN '",l_bdate,"' AND '",tm.edate,"')",
#              "  AND ", g_wc CLIPPED,
#              "  AND abh03=aag01 AND aag222 IN ('1','2') ",
#              "  AND (aag15 IS NOT NULL OR aag15 !=' ') "
#  PREPARE r810_abh_pre FROM l_sql
#  IF SQLCA.sqlcode != 0 THEN
#     CALL cl_err('pre abh_pre:',SQLCA.sqlcode,1) 
#     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#     EXIT PROGRAM 
#  END IF
#  DECLARE r810_abh_cur CURSOR FOR r810_abh_pre
# }
 
#  取期初余額的CURSOR NO.FUN-7C0038 by johnray
   LET l_sql = "SELECT sum(abi08-abi09)  FROM abi_file ",
               " WHERE abi00 = '",tm.b,"'", 
               "   AND abi03 = '",l_lastyy,"'",
               "   AND abi04 = '",l_lastmm,"'",
               "   AND abi01 = ? ",
               "   AND abi02 = ? ",
               "   AND abi05=  ? ", #會科
               "   AND abi11=  ? "  #異動碼一
   PREPARE r810_abhsum_pre FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('pre abhsum_pre:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM 
   END IF
   DECLARE r810_abhsum_cur CURSOR FOR r810_abhsum_pre
 
   INITIALIZE sr.* TO NULL
   #--->期初資料(有可能科目只有期初但當月無立帳或沖帳)
   FOREACH aglg808_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach r810_curs1:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT ahe02 INTO sr.ahe02 FROM ahe_file
         WHERE ahe01 = sr.aag15
      EXECUTE insert_prep USING sr.*
      IF STATUS THEN
         CALL cl_err("execute insert_prep:",STATUS,1)
         EXIT FOREACH
      END IF
   END FOREACH
 
   #--->當月立帳
   FOREACH r810_abg_cur INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach r810_curs1:',SQLCA.sqlcode,1)   
         EXIT FOREACH
      END IF
      SELECT ahe02 INTO sr.ahe02 FROM ahe_file
       WHERE ahe01 = sr.aag15
      EXECUTE insert_prep USING sr.*
      IF STATUS THEN
         CALL cl_err("execute insert_prep:",STATUS,1)
         EXIT FOREACH
      END IF
   END FOREACH
 
#  {#TSD.Ken 080807 Mark 沖帳不用ins
#  #--->當月沖帳
#  FOREACH r810_abh_cur INTO sr.*
#     IF SQLCA.sqlcode != 0 THEN
#        CALL cl_err('foreach r810_curs1:',SQLCA.sqlcode,1)   
#        EXIT FOREACH
#     END IF
#     SELECT ahe02 INTO sr.ahe02 FROM ahe_file
#      WHERE ahe01 = sr.aag15
#     EXECUTE insert_prep USING sr.*
#     IF STATUS THEN
#        CALL cl_err("execute insert_prep:",STATUS,1)
#        EXIT FOREACH
#     END IF
#  END FOREACH
#  }
 
#NO.FUN-7C0038--------------------START------
# 以上對來自數據表的源數據進行匯總,
# 以下對源數據進行處理,以適應報表的呈現要求
 
   #還是抓不同的會科+異動碼一
   LET l_sql = "SELECT DISTINCT abi05, abi11 FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " ORDER BY abi05,abi11"  
 
 {#Mark By TSD.Ken
   LET l_sql = "SELECT DISTINCT abi05, abi11,abi10 FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
,
              " ORDER BY abi05,abi11,abi10"    #TPS080806 up
 }
 
   PREPARE r001_ppp FROM l_sql
   DECLARE r001_cs CURSOR FOR r001_ppp
   #抓不同的會科+異動碼一
   #FOREACH r001_cs INTO g_abi05, g_abi11, g_abi10 #TPS080806 up add g_abi10
   FOREACH r001_cs INTO g_abi05, g_abi11
         LET sr1.abi05 = g_abi05
         LET sr1.abi11 = g_abi11
         #LET sr1.abi10 = g_abi10  #TPS080806 up
 
         SELECT aag15,aag16,aag17,aag18,
                aag31,aag32,aag33,aag34,
                aag35,aag36
           INTO sr.aag15,sr.aag16,sr.aag17,sr.aag18,
                sr.aag31,sr.aag32,sr.aag33,sr.aag34,
                sr.aag35,sr.aag36
           FROM aag_file 
          WHERE aag01 = g_abi05 AND aag00 = tm.b                 
         
         LET l_no = 0
         IF not cl_null(sr.aag15) THEN LET l_no = l_no + 1  END IF
         IF not cl_null(sr.aag16) THEN LET l_no = l_no + 1  END IF
         IF not cl_null(sr.aag17) THEN LET l_no = l_no + 1  END IF
         IF not cl_null(sr.aag18) THEN LET l_no = l_no + 1  END IF
         IF not cl_null(sr.aag31) THEN LET l_no = l_no + 1  END IF
         IF not cl_null(sr.aag32) THEN LET l_no = l_no + 1  END IF
         IF not cl_null(sr.aag33) THEN LET l_no = l_no + 1  END IF
         IF not cl_null(sr.aag34) THEN LET l_no = l_no + 1  END IF
         IF not cl_null(sr.aag35) THEN LET l_no = l_no + 1  END IF
         IF not cl_null(sr.aag36) THEN LET l_no = l_no + 1  END IF
 
         #此會科+碼動碼一的期初
         #Ken 080815 NOTE
         #現在已經不是這個會科+異動碼的期初了
         #這個ins只是單純的要show在報表上的群組欄位名稱而已
         #所以在rpt那邊，有關這個type = 1的，只會印它的會科+異動碼
         #名稱而已，沒有其它用途。
         #LET sr1.l_rem = ''
         #OPEN r810_abhsum_cur USING g_abi05,g_abi11,g_abi10 #TPS080806 add abi10
        # OPEN r810_abhsum_cur USING g_abi05,g_abi11
        # FETCH r810_abhsum_cur INTO sr1.l_rem
        # IF cl_null(sr1.l_rem) THEN LET sr1.l_rem = 0 END IF
        # CLOSE r810_abhsum_cur
         LET sr1.l_rem = 0 
         LET sr1.type = '1' 
         LET sr1.l_diff = 0
         #依會科+異動碼一跳頁用的群組
         LET sr1.newgrup = g_abi05,g_abi11         #TPS080806 up mark
         LET sr1.aag02 = ''
         LET sr1.aag13 = ''
         SELECT aag02, aag13,ahe02 
           INTO sr1.aag02, sr1.aag13 , sr1.ahe02
           FROM aag_file,ahe_file 
          WHERE aag01 = g_abi05 
            AND aag00 = tm.b
            AND aag15 = ahe01
         EXECUTE insert_prep1 USING sr1.*
         IF STATUS THEN
            CALL cl_err("execute insert_prep:",STATUS,1)
            EXIT FOREACH
         END IF
 
         #會科+異動碼一 => 對應到不同的傳票編號
         #而傳票編號依立帳的時間的話，會分
         #1、不在本期立帳(存在abi,不存在abg) 
         #2、在本期立帳(存在abg，不存在abi)
 
         #用傳票編號+項次來foreach #TSD.Ken 080807 MOD
         LET l_sql = "SELECT DISTINCT abi01,abi02 FROM ",
                      g_cr_db_str CLIPPED, 
                      l_table CLIPPED,
                     #傳票編號為本期立，或上期
                     " WHERE (type = '1' OR type = '2')",
                     "   AND abi05 = '",g_abi05,"'",
                     "   AND abi11 = '",g_abi11,"'"
 
         DECLARE get_dis_abi01 CURSOR FROM l_sql
         FOREACH get_dis_abi01 INTO sr1.abi01,g_abi02
              #抓出此傳票編號+異動碼一+此科目的第一筆
              #Ken NOTE 080815
              #抓出此傳票項次立帳的資料 
              LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,
                            l_table CLIPPED,
                          " WHERE abi01 = '",sr1.abi01,"'",
                          "   AND abi05 = '",g_abi05,"'",
                          "   AND abi02 = '",g_abi02,"'",
                          "   AND abi11 = '",g_abi11,"'"
              DECLARE get_abi_to CURSOR FROM l_sql
              FOREACH get_abi_to INTO sr.*
                 EXIT FOREACH
              END FOREACH                
              #來組此傳票編號的摘要 STR
              CASE
                 WHEN l_no = 1
                    LET sr1.l_str = l_gx CLIPPED,'1:',sr.abi11 CLIPPED,' '
                 WHEN l_no = 2
                    LET sr1.l_str = l_gx CLIPPED,'1:',sr.abi11 CLIPPED,' ',
                                    l_gx CLIPPED,'2:',sr.abi12 CLIPPED
                 WHEN l_no = 3
                    LET sr1.l_str = l_gx CLIPPED,'1:',sr.abi11 CLIPPED,' ',
                                    l_gx CLIPPED,'2:',sr.abi12 CLIPPED,' ',
                               l_gx CLIPPED,'3:',sr.abi13 CLIPPED
                 WHEN l_no = 4
                    LET sr1.l_str = l_gx CLIPPED,'1:',sr.abi11 CLIPPED,' ',
                                    l_gx CLIPPED,'2:',sr.abi12 CLIPPED,' ',
                                    l_gx CLIPPED,'3:',sr.abi13 CLIPPED,' ',
                                    l_gx CLIPPED,'4:',sr.abi14 CLIPPED
                 WHEN l_no = 5
                    LET sr1.l_str = l_gx CLIPPED,'1:',sr.abi11 CLIPPED,' ',
                                    l_gx CLIPPED,'2:',sr.abi12 CLIPPED,' ',
                                    l_gx CLIPPED,'3:',sr.abi13 CLIPPED,' ',
                                    l_gx CLIPPED,'4:',sr.abi14 CLIPPED,' ',
                                    l_gx CLIPPED,'5:',sr.abi31 CLIPPED
                 WHEN l_no = 6
                    LET sr1.l_str = l_gx CLIPPED,'1:',sr.abi11 CLIPPED,' ',
                                    l_gx CLIPPED,'2:',sr.abi12 CLIPPED,' ',
                                    l_gx CLIPPED,'3:',sr.abi13 CLIPPED,' ',
                                    l_gx CLIPPED,'4:',sr.abi14 CLIPPED,' ',
                                    l_gx CLIPPED,'5:',sr.abi31 CLIPPED,' ',
                                    l_gx CLIPPED,'6:',sr.abi32 CLIPPED
                 WHEN l_no = 7
                    LET sr1.l_str = l_gx CLIPPED,'1:',sr.abi11 CLIPPED,' ',
                                    l_gx CLIPPED,'2:',sr.abi12 CLIPPED,' ',
                                    l_gx CLIPPED,'3:',sr.abi13 CLIPPED,' ',
                                    l_gx CLIPPED,'4:',sr.abi14 CLIPPED,' ',
                                    l_gx CLIPPED,'5:',sr.abi31 CLIPPED,' ',
                                    l_gx CLIPPED,'6:',sr.abi32 CLIPPED,' ',
                                    l_gx CLIPPED,'7:',sr.abi33 CLIPPED
                 WHEN l_no = 8
                    LET sr1.l_str = l_gx CLIPPED,'1:',sr.abi11 CLIPPED,' ',
                                    l_gx CLIPPED,'2:',sr.abi12 CLIPPED,' ',
                                    l_gx CLIPPED,'3:',sr.abi13 CLIPPED,' ',
                                    l_gx CLIPPED,'4:',sr.abi14 CLIPPED,' ',
                                    l_gx CLIPPED,'5:',sr.abi31 CLIPPED,' ',
                                    l_gx CLIPPED,'6:',sr.abi32 CLIPPED,' ',
                                    l_gx CLIPPED,'7:',sr.abi33 CLIPPED,' ',
                                    l_gx CLIPPED,'8:',sr.abi34 CLIPPED
                 WHEN l_no = 9
                    LET sr1.l_str = l_gx CLIPPED,'1:',sr.abi11 CLIPPED,' ',
                                    l_gx CLIPPED,'2:',sr.abi12 CLIPPED,' ',
                                    l_gx CLIPPED,'3:',sr.abi13 CLIPPED,' ',
                                    l_gx CLIPPED,'4:',sr.abi14 CLIPPED,' ',
                                    l_gx CLIPPED,'5:',sr.abi31 CLIPPED,' ',
                                    l_gx CLIPPED,'6:',sr.abi32 CLIPPED,' ',
                                    l_gx CLIPPED,'7:',sr.abi33 CLIPPED,' ',
                                    l_gx CLIPPED,'8:',sr.abi34 CLIPPED,' ',
                                    l_gx CLIPPED,'9:',sr.abi35 CLIPPED
                 WHEN l_no = 10
                    LET sr1.l_str = l_gx CLIPPED,'1:',sr.abi11 CLIPPED,' ',
                                    l_gx CLIPPED,'2:',sr.abi12 CLIPPED,' ',
                                    l_gx CLIPPED,'3:',sr.abi13 CLIPPED,' ',
                                    l_gx CLIPPED,'4:',sr.abi14 CLIPPED,' ',
                                    l_gx CLIPPED,'5:',sr.abi31 CLIPPED,' ',
                                    l_gx CLIPPED,'6:',sr.abi32 CLIPPED,' ',
                                    l_gx CLIPPED,'7:',sr.abi33 CLIPPED,' ',
                                    l_gx CLIPPED,'8:',sr.abi34 CLIPPED,' ',
                                    l_gx CLIPPED,'9:',sr.abi35 CLIPPED,' ',
                                    l_gx CLIPPED,'10:',sr.abi36 CLIPPED
              END CASE
              #來組此傳票編號的摘要 END
 
              #取此傳票當初被立帳的金額
              LET l_sql = "SELECT SUM(abg071) FROM abg_file",
                          " WHERE abg00 = '",tm.b,"'",
                          "   AND abg01 = '",sr1.abi01,"'",
                          "   AND abg02 = '",g_abi02,"'",
                          "   AND abg03 = '",g_abi05,"'",
                          "   AND abg11 = '",g_abi11,"'"
              DECLARE get_ini_abg071 CURSOR FROM l_sql
              LET sr1.balance = 0
              FOREACH get_ini_abg071 INTO sr1.balance
                 EXIT FOREACH
              END FOREACH
              IF sr1.balance IS NULL THEN LET sr1.balance = 0 END IF
            
              LET sr1.aag02 = sr.aag02
              LET sr1.aag13 = sr.aag13
              LET sr1.abi05 = sr.abi05
              LET sr1.ahe02 = sr.ahe02
              LET sr1.abi11 = sr.abi11
              LET sr1.abi06 = sr.abi06
              LET sr1.abi01 = sr.abi01
              LET sr1.type  = '2'
              LET sr1.abi07 = sr.abi07
              LET sr1.abi10 = sr.abi10
              LET sr1.aag222 = sr.aag222
              LET sr1.newgrup = g_abi05,g_abi11         #TPS080806 up mark
 
              #取此傳票+異動碼+科目被沖掉的金額
              #TSD.Ken 080815
              #此傳票+項次被沖掉的金額
              LET l_sql = "SELECT SUM(abh09) FROM abh_file",
                          " WHERE abh00='",tm.b,"'",
                          "   AND (abh021 <='",tm.edate,"')",
                          "   AND abh03 = '",g_abi05,"'", #科目
                          "   AND abh11 = '",g_abi11,"'", #異動碼一
                          "   AND abh07 = '",sr1.abi01,"'",
                          "   AND abh08 = '",g_abi02,"'"
              DECLARE get_abh09 CURSOR FROM l_sql
              LET l_abh09 = 0
              FOREACH get_abh09 INTO l_abh09
                 EXIT FOREACH
              END FOREACH
              IF l_abh09 IS NULL THEN LET l_abh09 = 0 END IF
 
              #立帳餘額 = 立帳金額 - 沖帳金額 
              LET sr1.l_diff = sr1.balance - l_abh09
 
              #TSD.Ken 080721 STR
              #餘額為0不印
              #IF tm.d = 'Y' THEN
              #   IF sr1.l_diff = 0 THEN CONTINUE FOREACH END IF
              #END IF
              #TSD.Ken 080721 END
 
              EXECUTE insert_prep1 USING sr1.*
              IF STATUS THEN
                 CALL cl_err("execute insert_prep:",STATUS,1)
                 EXIT FOREACH
              END IF
         END FOREACH
   END FOREACH   
   # 報表數據預處理完畢,
   # 下面向CR輸出經處理過的l_table1中的數據
 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   CALL cl_wcchp(tm.wc,'aag01') RETURNING tm.wc
###GENGRE###   LET g_str = tm.wc,";",g_zz05,";",g_azi03,";",
###GENGRE###               g_azi04,";",g_azi05,";",tm.e,";",tm.c,";",tm.d,";",
###GENGRE###               tm.edate
              
   #餘額為0不印
  
   CALL cl_del_data(l_table3) 
#{#TSD.Ken 080815 Mark
#  IF tm.d = 'Y' THEN
#     LET g_sss = ''
#     LET g_sql = "SELECT DISTINCT abi05, abi11 FROM ",g_cr_db_str CLIPPED, 
# #    LET g_sql = "SELECT DISTINCT abi05, abi11,abi10 FROM ",g_cr_db_str CLIPPED,
#                 l_table1 CLIPPED,
#                 " WHERE type = '1'"
#     DECLARE get_abi05_11 CURSOR FROM g_sql
#     FOREACH get_abi05_11 INTO  sr.abi05, sr.abi11  #TPS080806 up mark
#   #  FOREACH get_abi05_11 INTO  sr.abi05, sr.abi11,sr.abi10  #TPS080806 up
#
#         #有上期，且本期此傳票被沖完(=0)。
#         LET g_sql = "SELECT count(*) FROM ",
#                     g_cr_db_str CLIPPED,l_table1 CLIPPED
#                    ," WHERE abi05 = '",sr.abi05,"'",
#                     "   AND abi11 = '",sr.abi11,"'",
#                     "   AND abi10 = '",sr.abi10,"'",  #TPS080806 up
#                     "   AND type  = '2'"
#         DECLARE get_0_l_rem CURSOR FROM g_sql
#         FOREACH get_0_l_rem INTO g_cnt
#             IF cl_null(g_cnt) THEN LET g_cnt = 0 END IF
#             IF g_cnt = 0 THEN
#                LET g_sql = "INSERT INTO ", g_cr_db_str CLIPPED,
#                             l_table3 CLIPPED,
#                            " VALUES ('",sr.abi05,"','",sr.abi11,"')" #TPS080806 mark
#                 # " VALUES ('",sr.abi05,"','",sr.abi11,"','",sr.abi10,"')" #TPS080806
#                PREPARE xxx_ins FROM g_sql
#                EXECUTE xxx_ins         
#             END IF 
#         END FOREACH
#     END FOREACH
#
#     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
#                 " WHERE (abi05,abi11) ",  # TPS080806 up mark
#                # " WHERE (abi05,abi11,abi10) ",  # TPS080806 up
#                 "   NOT IN ",
#                 "       (SELECT DISTINCT * FROM ",g_cr_db_str CLIPPED,
#                          l_table3 CLIPPED,")"
#  ELSE
#    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
#  END IF
#}
 
###GENGRE###   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
  
###GENGRE###   CALL cl_prt_cs3('aglg808','aglg808',g_sql,g_str)
    CALL aglg808_grdata()    ###GENGRE###
END FUNCTION


###GENGRE###START
FUNCTION aglg808_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr2_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg808")
        IF handler IS NOT NULL THEN
            START REPORT aglg808_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
          
            DECLARE aglg808_datacur1 CURSOR FROM l_sql
            FOREACH aglg808_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg808_rep(sr1.*,l_cnt)    #FUN-C40071 add l_cnt
            END FOREACH
            FINISH REPORT aglg808_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg808_rep(sr1,l_cnt)           #FUN-C40071 add l_cnt
    DEFINE sr1 sr2_t
    DEFINE sr2 sr2_t
    DEFINE sr3 sr3_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_diff1  LIKE abi_file.abi08
    DEFINE l_diff2  LIKE abi_file.abi08
    DEFINE l_str    STRING
    DEFINE l_aag13  STRING
    DEFINE l_cnt    LIKE type_file.num10    #FUN-C40071 add 
    DEFINE l_cnt1   LIKE type_file.num10    #FUN-C40071 add 
    DEFINE l_skip   LIKE type_file.chr1     #FUN-C40071 add 
    
    ORDER EXTERNAL BY sr1.abi05,sr1.abi11
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.abi05
            LET l_lineno = 0
            IF tm.e = 'Y' THEN
               LET l_aag13 = sr1.aag13,"(",sr1.abi05,")"
            ELSE
               LET l_aag13 = sr1.aag02,"(",sr1.abi05,")"
            END IF
            PRINTX l_aag13
        BEFORE GROUP OF sr1.abi11
            LET l_str = sr1.ahe02,":",sr1.abi11
            PRINTX l_str
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            IF sr1.type = 2 THEN
               LET sr1.abi01 = sr1.abi01,"*"
            END IF

            PRINTX sr1.*

        AFTER GROUP OF sr1.abi05
           LET l_diff1 = GROUP SUM(sr1.l_diff)
           PRINTX l_diff1
 
        AFTER GROUP OF sr1.abi11
           LET l_diff2 = GROUP SUM(sr1.l_diff)
           PRINTX l_diff2
           #FUN-C40071-----add---str---
           LET l_cnt1 = l_cnt1 + 1
           IF l_cnt1 = l_cnt THEN
              LET l_skip = 'Y'    
              LET l_cnt1 = 0 
           ELSE
              LET l_skip = 'N'
           END IF
           PRINTX l_skip 
           #FUN-C40071-----add---end---

        
        ON LAST ROW

END REPORT
###GENGRE###END

