# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglr810.4gl
# Descriptions...: 科目異動碼明細表(aglr810)
# Modify.........: No.MOD-4C0156 04/12/24 By Kitty 帳別無法開窗,per配合調整
# Modify.........: No.FUN-580010 05/08/15 By trisy 2.0憑証類報表修改,轉XML格式
# Modify.........: No.TQC-5A0135 05/11/21 By Nicola 科目條件調整
# Modify.........: No.FUN-5C0015 06/01/09 By kevin
#                  1.印aag15改印ahe02(ahe01=aag15)。
#                  2.序號31放寬至50，序號35放寬至60。
#                  3.l_no、l_str 新增異動碼組別5~10
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-670005 06/07/07 By Hellen 帳別權限修改
# Modify.........: No.FUN-680098 06/09/01 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6A0080 06/11/24 By xumin添加打印總頁數
# Modify.........: No.FUN-6C0012 06/12/28 By Judy 新增打印額外名稱功能
# Modify.........: No.FUN-740020 07/04/10 By bnlent 會計科目加帳套
# Modify.........: NO.FUN-7C0038 08/02/25 By zhaijie 報表輸出改為Crystal Report
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9A0192 09/10/29 By Sarah l_table請定義為STRING
# Modify.........: No:MOD-A30183 10/03/24 By Summer 異動碼條件調整
# Modify.........: No:CHI-A40035 10/04/29 By liuxqa 追单-TQC-960194
# Modify.........: No:MOD-B10106 11/01/14 By Dido 取消 UNIQUE 條件 
# Modify.........: No.FUN-B20054 11/02/23 By xianghui 先錄入帳套,科目根據帳套過濾;結構改為DIALOG 
# Modify.........: No.FUN-B40026 11/06/15 By zhangweib 取消abg31~abg36, abh31~abh36, aag31~aag36相關處理
# Modify.........: No.FUN-B80057 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: No:MOD-B80100 11/08/18 By johung r810_cr_cur排序條件加上balance
# Modify.........: No.MOD-BC0051 11/12/06 By Dido 語法調整 
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                             # Print condition RECORD
              wc      LIKE type_file.chr1000,    # Where condition  #No.FUN-680098  VARCHAR(300)
              edate   LIKE type_file.dat,        # 截止日期   #No.FUN-680098    date   
              b       LIKE aaa_file.aaa01,       # 帳別
              e       LIKE type_file.chr1,       #列印額外名稱 #FUN-6C0012
              more    LIKE type_file.chr1        # Input more condition(Y/N) #No.FUN-680098 VARCHAR(1)      
              END RECORD,
         g_bookno     LIKE aaa_file.aaa01,       # 帳別
         l_orderA     ARRAY[2] OF LIKE type_file.chr20      #No.FUN-680098     VARCHAR(20)   
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680098 SMALLINT
#No.FUN-7C0038-------------START-------------
DEFINE g_sql      STRING
DEFINE l_table    STRING                  #MOD-9A0192 mod chr20->STRING
DEFINE l_table1   STRING                  #MOD-9A0192 mod chr20->STRING
DEFINE g_str      STRING
#No.FUN-7C0038-------------END-------------
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                  # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114 #FUN-BB0047
 
 
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
#No.FUN-7C0038-------------start-------------
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
   LET l_table = cl_prt_temptable('aglr810',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
 
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
               "abc04.abc_file.abc04"
   LET l_table1 = cl_prt_temptable('aglr8101',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
#No.FUN-7C0038-------------end-------------
 
#   SELECT azi04,azi05 INTO g_azi04,g_azi05 FROM azi_file WHERE azi01=g_aza.aza17                 #No.CHI-6A0004 mark
   IF g_bookno IS  NULL OR g_bookno = ' ' THEN
      LET g_bookno = g_aaz.aaz64
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N'  THEN # If background job sw is off
      CALL aglr810_tm(0,0)                    # Input print condition
   ELSE
      CALL aglr810()                          # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION aglr810_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01           #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680098  SMALLINT
          l_cmd       LIKE type_file.chr1000        #No.FUN-680098  VARCHAR(400)
   DEFINE li_chk_bookno  LIKE type_file.num5        #No.FUN-670005  #No.FUN-680098  smallint     
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 11 END IF
   CALL s_dsmark(g_bookno)
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 24
   ELSE LET p_row = 4 LET p_col = 11
   END IF
   OPEN WINDOW aglr810_w AT p_row,p_col
        WITH FORM "agl/42f/aglr810"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   #No.FUN-740020  --Begin
   IF tm.b IS  NULL OR tm.b = ' ' THEN
      LET tm.b = g_aza.aza81
   END IF
   #No.FUN-740020  --End
   #LET tm.b    = g_bookno         #No.FUN-740020
   LET tm.b     = g_aza.aza81      #No.FNN-B20054
   LET tm.edate = g_today
   LET tm.e     = 'N'  #FUN-6C0012
   LET tm.more  = 'N'
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
WHILE TRUE

#No.FUN-B20054--add--start--
      DIALOG ATTRIBUTE(unbuffered)
         INPUT BY NAME tm.b ATTRIBUTE(WITHOUT DEFAULTS)
            AFTER FIELD b
              IF NOT cl_null(tm.b) THEN
                   CALL s_check_bookno(tm.b,g_user,g_plant)
                    RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                    NEXT FIELD b
                END IF
                SELECT aaa02 FROM aaa_file WHERE aaa01 = tm.b
                IF STATUS THEN
                   CALL cl_err3("sel","aaa_file",tm.b,"","agl-043","","",0)
                   NEXT FIELD  b
                END IF
             END IF
         END INPUT

#No.FUN-B20054--add-end--


   CONSTRUCT BY NAME tm.wc ON aag01
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
#No.FUN-B20054--mark--start-- 
#       ON ACTION locale
#           #CALL cl_dynamic_locale()
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         LET g_action_choice = "locale"
#         EXIT CONSTRUCT
# 
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE CONSTRUCT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
# 
# 
#           ON ACTION exit
#           LET INT_FLAG = 1
#           EXIT CONSTRUCT
#         #No.FUN-580031 --start--
#         ON ACTION qbe_select
#            CALL cl_qbe_select()
#         #No.FUN-580031 ---end---
# 
#No.FUN-B20054--mark--end--
  END CONSTRUCT
#No.FUN-B20054--mark--start--
#       IF g_action_choice = "locale" THEN
#          LET g_action_choice = ""
#          CALL cl_dynamic_locale()
#          CONTINUE WHILE
#       END IF
# 
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0 CLOSE WINDOW aglr810_w 
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#      EXIT PROGRAM
#         
#   END IF
#   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
# 
#   DISPLAY BY NAME tm.edate,tm.e,tm.more   #FUN-6C0012
# 
#   INPUT BY NAME tm.edate,tm.b,tm.e,tm.more WITHOUT DEFAULTS  #FUN-6C0012
#No.FUN-B20054--mark--end-- 
    INPUT BY NAME tm.edate,tm.e,tm.more  ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20054
        #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD edate
         IF  cl_null(tm.edate) THEN NEXT FIELD edate END IF
      #no.7277
#No.FUN-B20054--mark--start--
#      AFTER FIELD b
#         IF tm.b IS NULL THEN NEXT FIELD b END IF
#         #No.FUN-670005--begin
#             CALL s_check_bookno(tm.b,g_user,g_plant) 
#                  RETURNING li_chk_bookno
#             IF (NOT li_chk_bookno) THEN
#                  NEXT FIELD b 
#             END IF 
#         #No.FUN-670005--end  
#         SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
#         IF STATUS THEN 
##           CALL cl_err('sel aaa:',STATUS,0) # NO.FUN-660123
#            CALL cl_err3("sel","aaa_file",tm.b,"",STATUS,"","sel aaa:",0)  # NO.FUN-660123
#            NEXT FIELD b
#         END IF
#      #no.7277(end)
#No.FUN-B20054--mark-end--
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
#No.FUN-B20054--mark--start--
#   ON ACTION CONTROLR
#      CALL cl_show_req_fields()
# 
#      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
#      ON ACTION CONTROLP
#          #No.MOD-4C0156 add
#         IF  INFIELD(b) THEN
#            CALL cl_init_qry_var()
#            LET g_qryparam.form = 'q_aaa'
#            LET g_qryparam.default1 = tm.b
#            CALL cl_create_qry() RETURNING tm.b
#            DISPLAY BY NAME tm.b
#            NEXT FIELD b
#         END IF
#          #No.MOD-4C0156 end
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
# 
#          ON ACTION exit
#          LET INT_FLAG = 1
#          EXIT INPUT
#         #No.FUN-580031 --start--
#         ON ACTION qbe_save
#            CALL cl_qbe_save()
#         #No.FUN-580031 ---end---
#No.FUN-B20054--mark-end-- 
   END INPUT
#No.FUN-B20054--add-start--
      ON ACTION CONTROLP
         CASE
            WHEN  INFIELD(b)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aaa'
               LET g_qryparam.default1 = tm.b
               CALL cl_create_qry() RETURNING tm.b
               DISPLAY BY NAME tm.b
               NEXT FIELD b
             WHEN INFIELD(aag01)
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_aag02"
                LET g_qryparam.state    = "c"
                LET g_qryparam.where = " aag00 = '",tm.b CLIPPED,"'"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO aag01
                NEXT FIELD aag01
             OTHERWISE EXIT CASE
        END CASE
       ON ACTION locale
          CALL cl_show_fld_cont()
          LET g_action_choice = "locale"
          EXIT DIALOG

       ON ACTION CONTROLR
          CALL cl_show_req_fields()

       ON ACTION CONTROLG
          CALL cl_cmdask()

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DIALOG

       ON ACTION about
          CALL cl_about()

       ON ACTION help
          CALL cl_show_help()

       ON ACTION exit
          LET INT_FLAG = 1
          EXIT DIALOG

       ON ACTION qbe_save
          CALL cl_qbe_save()

       ON ACTION accept
          EXIT DIALOG

       ON ACTION cancel
          LET INT_FLAG=1
          EXIT DIALOG
    END DIALOG
    IF g_action_choice = "locale" THEN
       LET g_action_choice = ""
       CALL cl_dynamic_locale()
       CONTINUE WHILE
    END IF

#No.FUN-B20054-add-end--
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW aglr810_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF     #No.FUN-B20054
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aglr810'
      IF SQLCA.sqlcode OR cl_null(l_cmd) THEN
         CALL cl_err('aglr810','9031',1)   
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
         CALL cl_cmdat('aglr810',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW aglr810_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aglr810()
   ERROR ""
END WHILE
   CLOSE WINDOW aglr810_w
END FUNCTION
 
FUNCTION aglr810()
   DEFINE l_name    LIKE type_file.chr20,          # External(Disk) file name        #No.FUN-680098 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0073
          l_sql     LIKE type_file.chr1000,        # RDSQL STATEMENT                 #No.FUN-680098 VARCHAR(1000)
          l_za05    LIKE za_file.za05,             #No.FUN-680098 VARCHAR(40)
          l_order   ARRAY[2] OF LIKE abh_file.abh11,   #No.FUN-680098 VARCHAR(30)         
          l_yy,l_mm  LIKE type_file.num10,             #No.FUN-680098  intger     
          l_bdate    LIKE type_file.dat,               #No.FUN-680098 date      
          l_lastyy,l_lastmm    LIKE  type_file.num10,  #No.FUN-680098 integr      
          p_order    LIKE type_file.chr1              #No.FUN-680098 VARCHAR(1)      
#NO.FUN-7C0038--------------------START------
#          sr        RECORD
#                    type      LIKE type_file.chr1,        #No.FUN-680098  VARCHAR(1)
#                    abi01     LIKE  abi_file.abi01,  #傳票編號
#                    abi02     LIKE  abi_file.abi02,  #項次
#                    abi03     LIKE  abi_file.abi03,  #年度
#                    abi04     LIKE  abi_file.abi04,  #期別
#                    abi05     LIKE  abi_file.abi05,  #會計科目
#                    abi06     LIKE  abi_file.abi06,  #傳票日期
#                    abi07     LIKE  abi_file.abi07,  #部門
#                    abi08     LIKE  abi_file.abi08,  #金額
#                    abi10     LIKE  abi_file.abi10,  #摘要
#                    abi11     LIKE  abi_file.abi11,  #異動碼一
#                    abi12     LIKE  abi_file.abi12,  #異動碼二
#                    abi13     LIKE  abi_file.abi13,  #異動碼三
#                    abi14     LIKE  abi_file.abi14,  #異動碼四
#                    aag02     LIKE  aag_file.aag02,  #會計名稱
#                    aag13     LIKE  aag_file.aag13,  #額外名稱 #FUN-6C0012
#                    aag15     LIKE  aag_file.aag15,  #異動1-名稱
#                    aag16     LIKE  aag_file.aag16,  #異動2-名稱
#                    aag17     LIKE  aag_file.aag17,  #異動3-名稱
#                    aag18     LIKE  aag_file.aag18,  #異動4-名稱
#                    aag222    LIKE  aag_file.aag222,
#                    #  FUN-5C0015 add (s)
#                    aag31     LIKE  aag_file.aag31,  #異動5-名稱
#                    aag32     LIKE  aag_file.aag32,  #異動6-名稱
#                    aag33     LIKE  aag_file.aag33,  #異動7-名稱
#                    aag34     LIKE  aag_file.aag34,  #異動8-名稱
#                    aag35     LIKE  aag_file.aag35,  #異動9-名稱
#                    aag36     LIKE  aag_file.aag36,  #異動10-名稱
#                    ahe02     LIKE  ahe_file.ahe02,
#                    abi31     LIKE  abi_file.abi31,  #異動碼五
#                    abi32     LIKE  abi_file.abi32,  #異動碼六
#                    abi33     LIKE  abi_file.abi33,  #異動碼七
#                    abi34     LIKE  abi_file.abi34,  #異動碼八
#                    abi35     LIKE  abi_file.abi35,  #異動碼九
#                    abi36     LIKE  abi_file.abi36   #異動碼十
#                    #  FUN-5C0015 add (e)
#                    END RECORD
 
DEFINE l_no        LIKE type_file.num5
DEFINE l_abi05     LIKE abi_file.abi05
DEFINE l_abi11     LIKE abi_file.abi11
DEFINE l_chg_abi05 LIKE type_file.chr1
DEFINE l_chg_abi11 LIKE type_file.chr1
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
           abc04   LIKE type_file.chr1000
           END RECORD
DEFINE     l_gx  LIKE zaa_file.zaa08 
#NO.FUN-7C0038--------------END------------
 
#NO.FUN-7C0038--------------------START------
   CALL cl_del_data(l_table)                                #No.FUN-7C0038  
   CALL cl_del_data(l_table1)                               #No.FUN-7C0038  
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
       CALL cl_err('insert_prep:',status,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80057--add--
       EXIT PROGRAM
   END IF 
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?)"
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
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND aaguser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
     #     END IF
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
#NO.FUN-7C0038--------------------START------
#     LET l_sql = "SELECT '1',abi01, abi02, abi03, abi04, abi05, abi06, abi07,",
#                 " (abi08-abi09), abi10, abi11, abi12, abi13, abi14,",
#                 " aag02, aag13, aag15, aag16, aag17, aag18, aag222, ",  #FUN-6C0012
#                #  FUN-5C0015 (s)
#                 " aag31,aag32,aag33,aag34,aag35,aag36,'', ",
#                 " abi31,abi32,abi33,abi34,abi35,abi36 ",
#                #  FUN-5C0015 (e)
   LET l_sql = "SELECT aag02,aag13,abi05,'',abi11,abi06,abi01,'1',abi07,abi10,",
               "(abi08-abi09),aag222,aag15,aag16,aag17,aag18,aag31,aag32,",
               " aag33,aag34,aag35,aag36,abi12,abi13,abi14,abi31,abi32,",
               " abi33,abi34,abi35,abi36,abi02 ",
#NO.FUN-7C0038--------------------END------
                 " FROM abi_file , aag_file  " ,
                 " WHERE abi00 = '",tm.b,"'", #no.7277
                 "   AND abi00 = aag00",      #No.FUN-740020
                 "   AND ", tm.wc CLIPPED,   #No.TQC-5A0135
                 "   AND abi05=aag01 AND aag222 IN ('1','2') ",
                # "   AND (aag15 IS NOT NULL OR aag15 !=' ') " #NO.MOD-A30183 mark
               #NO.MOD-A30183---START-----------------------
                 "   AND ((aag15 IS NOT NULL OR aag15 !=' ') ",
                 "    OR  (aag16 IS NOT NULL OR aag16 !=' ') ",
                 "    OR  (aag17 IS NOT NULL OR aag17 !=' ') ",
                 "    OR  (aag18 IS NOT NULL OR aag18 !=' '))"  #FUN-B40026   Add )
               #,"    OR  (aag31 IS NOT NULL OR aag31 !=' ') ", #FUN-B40026   Mark
               # "    OR  (aag32 IS NOT NULL OR aag32 !=' ') ", #FUN-B40026   Mark
               # "    OR  (aag33 IS NOT NULL OR aag33 !=' ') ", #FUN-B40026   Mark
               # "    OR  (aag34 IS NOT NULL OR aag34 !=' ')) " #FUN-B40026   Mark
               #NO.MOD-A30183---END-----------------------

     PREPARE aglr810_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM 
        END IF
     DECLARE aglr810_curs1 CURSOR FOR aglr810_prepare1
 
     #---->取本月份立帳
#NO.FUN-7C0038--------------------START------
#     LET l_sql = "SELECT '2',abg01,abg02,'','',abg03,abg06,abg05,",
#                 " abg071,abg04,abg11,abg12,abg13,abg14,",
#                 " aag02, aag13, aag15, aag16, aag17, aag18, aag222, ",  #FUN-6C0012
#                #  FUN-5C0015 (s)
#                 " aag31,aag32,aag33,aag34,aag35,aag36,'', ",
#                 " abg31,abg32,abg33,abg34,abg35,abg36 ",
#                #  FUN-5C0015 (e)
   LET l_sql = "SELECT aag02,aag13,abg03,'',abg11,abg06,abg01,'2',abg05,abg04,",
               "abg071,aag222,aag15,aag16,aag17,aag18,aag31,aag32,aag33,aag34,",
               " aag35,aag36,abg12,abg13,abg14,abg31,abg32,abg33,abg34,abg35,",
               " abg36,abg02 ",
#NO.FUN-7C0038--------------------END------
                 "  FROM abg_file,aag_file ",
                 " WHERE (abg06 BETWEEN '",l_bdate,"' AND '",tm.edate,"')",
                 "   AND ", tm.wc CLIPPED,
                 "   AND abg00='",tm.b,"'", #no.7277
                 "   AND abg00 = aag00",      #No.FUN-740020
                 "   AND abg03=aag01 AND aag222 IN ('1','2') ",
                # "   AND (aag15 IS NOT NULL OR aag15 !=' ') " #NO.MOD-A30183 mark
               #NO.MOD-A30183---START-----------------------
                 "   AND ((aag15 IS NOT NULL OR aag15 !=' ') ",
                 "    OR  (aag16 IS NOT NULL OR aag16 !=' ') ",
                 "    OR  (aag17 IS NOT NULL OR aag17 !=' ') ",
                 "    OR  (aag18 IS NOT NULL OR aag18 !=' '))"  #FUN-B40026   Add )
               #,"    OR  (aag31 IS NOT NULL OR aag31 !=' ') ", #FUN-B40026   Mark
               # "    OR  (aag32 IS NOT NULL OR aag32 !=' ') ", #FUN-B40026   Mark
               # "    OR  (aag33 IS NOT NULL OR aag33 !=' ') ", #FUN-B40026   Mark
               # "    OR  (aag34 IS NOT NULL OR aag34 !=' ')) " #FUN-B40026   Mark
               #NO.MOD-A30183---END----------------------- 

     PREPARE r810_abg_pre FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('pre abg_pre:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM 
        END IF
     DECLARE r810_abg_cur CURSOR FOR r810_abg_pre
 
     #---->取本月份沖帳
#NO.FUN-7C0038--------------------START------
#     LET l_sql = "SELECT '3',abh01,abh02,'','',abh03,abh021,abh05,",
#                 " abh09,abh04,abh11,abh12,abh13,abh14,",
#                 " aag02, aag13, aag15, aag16, aag17, aag18, aag222, ",  #FUN-6C0012
#                #  FUN-5C0015 (s)
#                 " aag31,aag32,aag33,aag34,aag35,aag36,'', ",
#                 " abh31,abh32,abh33,abh34,abh35,abh36 ",
#                #  FUN-5C0015 (e)
   LET l_sql = "SELECT aag02,aag13,abh03,'',abh11,abh021,abh01,'3',abh05,",
               "abh04,abh09,aag222,aag15,aag16,aag17,aag18,aag31,aag32,aag33,",
               "aag34,aag35,aag36,abh12,abh13,abh14,abh31,abh32,abh33,",
               "abh34,abh35,abh36,abh02 ",
#NO.FUN-7C0038--------------------END------
                 "  FROM abh_file,aag_file ",
                 " WHERE abhconf = 'Y'",
                 "  AND abh00='",tm.b,"'", #no.7277
                 #"  AND abg00 = aag00",      #No.FUN-740020  #CHI-A40035 mark
                 "  AND abh00 = aag00",      #No.FUN-740020   #CHI-A40035 mod
                 "  AND (abh021 BETWEEN '",l_bdate,"' AND '",tm.edate,"')",
                 "  AND ", tm.wc CLIPPED,
                 "  AND abh03=aag01 AND aag222 IN ('1','2') ",
                # "  AND (aag15 IS NOT NULL OR aag15 !=' ') " #NO.MOD-A30183 mark
               #NO.MOD-A30183---START-----------------------
                 "   AND ((aag15 IS NOT NULL OR aag15 !=' ') ",
                 "    OR  (aag16 IS NOT NULL OR aag16 !=' ') ",
                 "    OR  (aag17 IS NOT NULL OR aag17 !=' ') ",
                 "    OR  (aag18 IS NOT NULL OR aag18 !=' ')) "  #FUN-B40026   Add ) #MOD-BC0051 add )
               #,"    OR  (aag31 IS NOT NULL OR aag31 !=' ') ", #FUN-B40026   Mark
               # "    OR  (aag32 IS NOT NULL OR aag32 !=' ') ", #FUN-B40026   Mark
               # "    OR  (aag33 IS NOT NULL OR aag33 !=' ') ", #FUN-B40026   Mark
               # "    OR  (aag34 IS NOT NULL OR aag34 !=' ')) " #FUN-B40026   Mark
               #NO.MOD-A30183---END-----------------------
 
     PREPARE r810_abh_pre FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('pre abh_pre:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM 
        END IF
     DECLARE r810_abh_cur CURSOR FOR r810_abh_pre
 
     LET l_sql = "SELECT sum(abi08-abi09)  FROM abi_file ",
                 " WHERE abi00 = '",tm.b,"'",   #no.7277
                 "   AND abi03 = '",l_lastyy,"'",
                 "   AND abi04 = '",l_lastmm,"'",
                 "   AND abi05=  ? ",
                 "   AND abi11=  ? "
 
     PREPARE r810_abhsum_pre FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('pre abhsum_pre:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM 
        END IF
     DECLARE r810_abhsum_cur CURSOR FOR r810_abhsum_pre
#NO.FUN-7C0038--------------------START------
#     CALL cl_outnam('aglr810') RETURNING l_name
#     START REPORT aglr810_rep TO l_name
#
#     LET g_pageno = 0
#NO.FUN-7C0038--------------------END------
     INITIALIZE sr.* TO NULL
     #--->期初資料(有可能科目只有期初但當月無立帳或沖帳)
     FOREACH aglr810_curs1 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach r810_curs1:',SQLCA.sqlcode,1)
          EXIT FOREACH
         END IF
         # FUN-5C0015 add(s)
         SELECT ahe02 INTO sr.ahe02 FROM ahe_file
          WHERE ahe01 = sr.aag15
         # FUN-5C0015 add(e)
#NO.FUN-7C0038--------------------START------
#         LET p_order = 1
#         OUTPUT TO REPORT aglr810_rep(sr.*,p_order)
      EXECUTE insert_prep USING sr.*
      IF STATUS THEN
         CALL cl_err("execute insert_prep:",STATUS,1)
         EXIT FOREACH
      END IF
#      OPEN r810_abhsum_cur USING sr.abi05,sr.abi11
#      FETCH r810_abhsum_cur INTO l_rem
#      IF cl_null(l_rem) THEN LET l_rem = 0 END IF
#      CLOSE r810_abhsum_cur
#NO.FUN-7C0038--------------------END------
 
     END FOREACH
     #--->當月立帳
     FOREACH r810_abg_cur INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach r810_curs1:',SQLCA.sqlcode,1)   
          EXIT FOREACH
         END IF
         # FUN-5C0015 add(s)
         SELECT ahe02 INTO sr.ahe02 FROM ahe_file
          WHERE ahe01 = sr.aag15
         # FUN-5C0015 add(s)
#NO.FUN-7C0038--------------------START------
#         LET p_order =  1
#         OUTPUT TO REPORT aglr810_rep(sr.*,p_order)
      EXECUTE insert_prep USING sr.*
      IF STATUS THEN
         CALL cl_err("execute insert_prep:",STATUS,1)
         EXIT FOREACH
      END IF
#NO.FUN-7C0038--------------------END------
     END FOREACH
     #--->當月沖帳
     FOREACH r810_abh_cur INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach r810_curs1:',SQLCA.sqlcode,1)   
          EXIT FOREACH
         END IF
         # FUN-5C0015 add(s)
         SELECT ahe02 INTO sr.ahe02 FROM ahe_file
          WHERE ahe01 = sr.aag15
         # FUN-5C0015 add(e)
#NO.FUN-7C0038--------------------START------
#         LET p_order =  2
#         OUTPUT TO REPORT aglr810_rep(sr.*,p_order)
      EXECUTE insert_prep USING sr.*
      IF STATUS THEN
         CALL cl_err("execute insert_prep:",STATUS,1)
         EXIT FOREACH
      END IF
#NO.FUN-7C0038--------------------END------
     END FOREACH
 
#NO.FUN-7C0038--------------------START------
#     FINISH REPORT aglr810_rep
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   #LET l_sql = "SELECT UNIQUE * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,  #MOD-B10106 mark
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,         #MOD-B10106
#               " ORDER BY abi05,abi11,abi06,type"           #MOD-B80100 mark
                " ORDER BY abi05,abi11,abi06,type,balance"   #MOD-B80100
    PREPARE r810_cr_pre FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('pre abhsum_pre:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
       EXIT PROGRAM 
    END IF
   DECLARE r810_cr_cur CURSOR FOR r810_cr_pre
   FOREACH r810_cr_cur INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach r810_curs1:',SQLCA.sqlcode,1)   
         EXIT FOREACH
      END IF
  
      LET sr1.aag02 = sr.aag02
      LET sr1.aag13 = sr.aag13
      LET sr1.abi05 = sr.abi05
      LET sr1.ahe02 = sr.ahe02
      LET sr1.abi11 = sr.abi11
      LET sr1.abi06 = sr.abi06
      LET sr1.abi01 = sr.abi01
      LET sr1.type  = sr.type
      LET sr1.abi07 = sr.abi07
      LET sr1.abi10 = sr.abi10
      LET sr1.balance = sr.balance
      LET sr1.aag222 = sr.aag222
      IF cl_null(sr.abi05) THEN
         LET sr.abi05 = ' '
      END IF
      IF cl_null(sr.abi11) THEN
         LET sr.abi11 = ' '
      END IF
 
      # 組切換標志
      IF cl_null(l_abi05) THEN
         LET l_abi05 = sr.abi05
         LET l_chg_abi05 = '1'
         LET l_chg_abi11 = '1'
      ELSE
      	 IF l_abi05 <> sr.abi05 THEN
            LET l_abi05 = sr.abi05
            LET l_chg_abi05 = '1'
            LET l_chg_abi11 = '1'
         END IF
      END IF
      IF cl_null(l_abi11) THEN
         LET l_abi11 = sr.abi11
         LET l_chg_abi11 = '1'
      ELSE
      	 IF l_abi11 <>sr.abi11 THEN
      	    LET l_abi11 = sr.abi11
      	    LET l_chg_abi11 = '1'
      	 END IF
      END IF
 
      #GROUP abi05對 l_no 賦值
      IF l_chg_abi05 = '1' THEN
         LET l_no = 0
         IF not cl_null(sr.aag15) THEN LET l_no = l_no + 1  END IF
         IF not cl_null(sr.aag16) THEN LET l_no = l_no + 1  END IF
         IF not cl_null(sr.aag17) THEN LET l_no = l_no + 1  END IF
         IF not cl_null(sr.aag18) THEN LET l_no = l_no + 1  END IF
        #IF not cl_null(sr.aag31) THEN LET l_no = l_no + 1  END IF   #FUN-B40026  Mark
        #IF not cl_null(sr.aag32) THEN LET l_no = l_no + 1  END IF   #FUN-B40026  Mark
        #IF not cl_null(sr.aag33) THEN LET l_no = l_no + 1  END IF   #FUN-B40026  Mark
        #IF not cl_null(sr.aag34) THEN LET l_no = l_no + 1  END IF   #FUN-B40026  Mark
        #IF not cl_null(sr.aag35) THEN LET l_no = l_no + 1  END IF   #FUN-B40026  Mark
        #IF not cl_null(sr.aag36) THEN LET l_no = l_no + 1  END IF   #FUN-B40026  Mark
         LET l_chg_abi05 = '0'
      END IF
 
      #GROUP abi11取前期余額
      IF l_chg_abi11 = '1' THEN
         OPEN r810_abhsum_cur USING sr.abi05,sr.abi11
         FETCH r810_abhsum_cur INTO sr1.l_rem
         IF cl_null(sr1.l_rem) THEN LET sr1.l_rem = 0 END IF
         CLOSE r810_abhsum_cur
         LET sr1.l_diff = sr1.l_rem
         LET l_chg_abi11 = '0'
      END IF
#----------FUN-7C0038-----------START------
      #利用p_ze 中的多語言維護，使用cl_getmsg()函數返回詳細資料字段
      CALL cl_getmsg('aglr810',g_lang) RETURNING l_gx
#----------FUN-7C0038-----------END--------
      
      #詳細資料字段賦值處理
      IF sr.type != '1' THEN
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
         CASE
            WHEN sr.type = '2'
               IF sr.aag222 = '1' THEN
                  LET sr1.l_diff = sr1.l_diff + sr.balance
               ELSE
                  LET sr1.l_diff = sr1.l_diff + sr.balance
               END IF
            WHEN sr.type = '3'
               IF sr.aag222 = '2' THEN
                  LET sr1.l_diff = sr1.l_diff - sr.balance
               ELSE
                  LET sr1.l_diff = sr1.l_diff - sr.balance
               END IF
            OTHERWISE
               EXIT CASE
         END CASE
      END IF
 
      #額外摘要
      LET l_abc04=''
      LET sr1.abc04=''
      FOREACH abc_cur USING sr.abi01,sr.abi02 INTO l_abc04
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach r810_curs1:',SQLCA.sqlcode,1)   
            EXIT FOREACH
         END IF
         LET sr1.abc04 = sr1.abc04 CLIPPED,l_abc04
      END FOREACH
 
      #以sr1向臨時表插值，字段順序以及字段類型與l_table1對應
      EXECUTE insert_prep1 USING sr1.*
      IF STATUS THEN
         CALL cl_err("execute insert_prep:",STATUS,1)
         EXIT FOREACH
      END IF
   END FOREACH
 
   #報表數據預處理完畢
   #下面向CR輸出經處理過的l_table1中的數據
 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   CALL cl_wcchp(tm.wc,'aag01') RETURNING tm.wc
   LET g_str = tm.wc,";",g_zz05,";",g_azi03,";",g_azi04,";",g_azi05,";",tm.e
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
   CALL cl_prt_cs3('aglr810','aglr810',g_sql,g_str)
#NO.FUN-7C0038--------------------END------
END FUNCTION
 
#NO.FUN-7C0038--------------------START------
#REPORT aglr810_rep(sr,p_order)
#   DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680098   VARCHAR(1)    
#          l_no,l_no2   LIKE type_file.num5,          #No.FUN-680098   SMALLINT 
#          l_sw,l_flag  LIKE type_file.chr1,          #No.FUN-680098   VARCHAR(1)
##          l_str        LIKE type_file.chr1000,       #  FUN-5C0015 mod c(50) --> c(60) #No.FUN-680098   
#          l_str        LIKE zaa_file.zaa08,          #No.TQC-6A0080     
#          p_order      LIKE type_file.chr1,          #No.FUN-680098   VARCHAR(1)
#          l_abc03      LIKE abc_file.abc03,
#          l_abc04      LIKE abc_file.abc04,
#          l_rem,l_dif  LIKE abg_file.abg071,
#          l_tot        LIKE abg_file.abg071,
#          sr        RECORD
#                    type       LIKE type_file.chr1,                #No.FUN-680098   VARCHAR(1)
#                    abi01     LIKE  abi_file.abi01,  #傳票編號
#                    abi02     LIKE  abi_file.abi02,  #項次
#                    abi03     LIKE  abi_file.abi03,  #年度
#                    abi04     LIKE  abi_file.abi04,  #期別
#                    abi05     LIKE  abi_file.abi05,  #會計科目
#                    abi06     LIKE  abi_file.abi06,  #傳票日期
#                    abi07     LIKE  abi_file.abi07,  #部門
#                    abi08     LIKE  abi_file.abi08,  #金額
#                    abi10     LIKE  abi_file.abi10,  #摘要
#                    abi11     LIKE  abi_file.abi11,  #異動碼一
#                    abi12     LIKE  abi_file.abi12,  #異動碼二
#                    abi13     LIKE  abi_file.abi13,  #異動碼三
#                    abi14     LIKE  abi_file.abi14,  #異動碼四
#                    aag02     LIKE  aag_file.aag02,  #會計名稱
#                    aag13     LIKE  aag_file.aag13,  #額外名稱 #FUN-6C0012
#                    aag15     LIKE  aag_file.aag15,  #異動1-名稱
#                    aag16     LIKE  aag_file.aag16,  #異動2-名稱
#                    aag17     LIKE  aag_file.aag17,  #異動3-名稱
#                    aag18     LIKE  aag_file.aag18,  #異動4-名稱
#                    aag222    LIKE  aag_file.aag222,
#                    #  FUN-5C0015 add (s)
#                    aag31     LIKE  aag_file.aag31,  #異動5-名稱
#                    aag32     LIKE  aag_file.aag32,  #異動6-名稱
#                    aag33     LIKE  aag_file.aag33,  #異動7-名稱
#                    aag34     LIKE  aag_file.aag34,  #異動8-名稱
#                    aag35     LIKE  aag_file.aag35,  #異動9-名稱
#                    aag36     LIKE  aag_file.aag36,  #異動10-名稱
#                    ahe02     LIKE  ahe_file.ahe02,
#                    abi31     LIKE  abi_file.abi31,  #異動碼五
#                    abi32     LIKE  abi_file.abi32,  #異動碼六
#                    abi33     LIKE  abi_file.abi33,  #異動碼七
#                    abi34     LIKE  abi_file.abi34,  #異動碼八
#                    abi35     LIKE  abi_file.abi35,  #異動碼九
#                    abi36     LIKE  abi_file.abi36   #異動碼十
#                    #  FUN-5C0015 add (e)
#                    END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#
#  ORDER BY sr.abi05,sr.abi11,sr.abi06,p_order
#  FORMAT
#   PAGE HEADER
##No.FUN-580010 --start--
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
##      PRINT COLUMN ((g_len-FGL_WIDTH(sr.aag02 CLIPPED)-12)/2)+1 ,sr.aag02 CLIPPED,  #No.TQC-6A0080
##             '(', sr.abi05 CLIPPED,')','  ',g_x[1] CLIPPED
#      #FUN-6C0012.....begin
#      IF tm.e = 'Y' THEN
#         LET l_str = sr.aag13 CLIPPED,'(', sr.abi05 CLIPPED,')','  ',g_x[1] CLIPPED
#      ELSE
#      #FUN_6C0012.....end
#         LET l_str = sr.aag02 CLIPPED,'(', sr.abi05 CLIPPED,')','  ',g_x[1] CLIPPED  # No.TQC-6A0080
#      END IF    #FUN-6C0012
#      PRINT COLUMN ((g_len-FGL_WIDTH(l_str CLIPPED))/2)+1 ,l_str CLIPPED   #TQC-6A0080
##No.FUN-580010 --end--
#      LET g_pageno = g_pageno + 1
#      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
##           COLUMN 61,g_x[11] CLIPPED,tm.edate,
#            COLUMN ((g_len-16)/2)+1 ,g_x[11] CLIPPED,tm.edate,   #No.FUN-580010
#            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<',"/pageno"   #TQC-6A0080
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'n'
 
##No.FUN-580010 --start--
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
#      PRINT g_dash1
##No.FUN-580010 --end--
 
#    BEFORE GROUP OF sr.abi05  #Account code
#      LET l_no = 0
#      LET l_tot= 0
#      IF not cl_null(sr.aag15) THEN LET l_no = l_no + 1  END IF
#      IF not cl_null(sr.aag16) THEN LET l_no = l_no + 1  END IF
#      IF not cl_null(sr.aag17) THEN LET l_no = l_no + 1  END IF
#      IF not cl_null(sr.aag18) THEN LET l_no = l_no + 1  END IF
#      #  FUN-5C0015 add (s)
#      IF not cl_null(sr.aag31) THEN LET l_no = l_no + 1  END IF
#      IF not cl_null(sr.aag32) THEN LET l_no = l_no + 1  END IF
#      IF not cl_null(sr.aag33) THEN LET l_no = l_no + 1  END IF
#      IF not cl_null(sr.aag34) THEN LET l_no = l_no + 1  END IF
#      IF not cl_null(sr.aag35) THEN LET l_no = l_no + 1  END IF
#      IF not cl_null(sr.aag36) THEN LET l_no = l_no + 1  END IF
#      #  FUN-5C0015 add (e)
#      SKIP TO TOP OF PAGE
 
 
#    BEFORE GROUP OF sr.abi11  #異動碼(一)
##     NEED 5 LINES
#      OPEN r810_abhsum_cur USING sr.abi05,sr.abi11
#      FETCH r810_abhsum_cur INTO l_rem
#      IF cl_null(l_rem) THEN LET l_rem = 0 END IF
#      CLOSE r810_abhsum_cur
#      LET l_dif = l_rem
##No.FUN-580010 --start--
##     PRINT sr.aag15 CLIPPED,':',sr.abi11 CLIPPED,' '
##     PRINT g_dash[1,g_len]
##     PRINT g_x[12] CLIPPED, 3 SPACES, g_x[13] CLIPPED, 5 SPACES,
##           g_x[14] CLIPPED,21 SPACES, g_x[15] CLIPPED,
##           column  86,g_x[16] CLIPPED, column 105,g_x[17] CLIPPED,
##           column 123,g_x[18] CLIPPED
##     PRINT '-------- ------------- ------ ',
##           '-------------------------------------------------- ',
##           '------------------ ------------------ ------------------'
##     PRINT g_x[19] CLIPPED , COLUMN 119, cl_numfor(l_rem,18,g_azi04)
      #  FUN-5C0015 mod (s)
      #PRINT COLUMN g_c[31],sr.aag15 CLIPPED,':',sr.abi11 CLIPPED,
#      PRINT COLUMN g_c[31],sr.ahe02 CLIPPED,':',sr.abi11 CLIPPED,
      #  FUN-5C0015 mod (e)
#            COLUMN g_c[32],g_x[19] CLIPPED ,
#            COLUMN g_c[38],cl_numfor(l_rem,18,g_azi04)
##No.FUN-580010 --end--
#    ON EVERY ROW
    #FUN-5C0015 add (s)--------------------
    #IF sr.type !=  '1' THEN
    #   CASE
    #     WHEN  l_no = 1
    #           LET l_str = g_x[21] CLIPPED,sr.abi11,' ',sr.abi10
    #     WHEN  l_no = 2
    #           LET l_str = g_x[21] CLIPPED,sr.abi11,' ',
    #                       g_x[22] CLIPPED,sr.abi12
    #     WHEN  l_no = 3
    #           LET l_str = g_x[21] CLIPPED,sr.abi11,' ',
    #                       g_x[22] CLIPPED,sr.abi12
    #     WHEN  l_no = 4
    #           LET l_str = g_x[21] CLIPPED,sr.abi11,' ',
    #                       g_x[22] CLIPPED,sr.abi12
    #     OTHERWISE LET l_str = sr.abi10
    #   END CASE
#     IF sr.type != '1' THEN
#        CASE
#          WHEN l_no = 1
#               LET l_str = g_x[21] CLIPPED,sr.abi11 CLIPPED,' '
#          WHEN l_no = 2
#               LET l_str = g_x[21] CLIPPED,sr.abi11 CLIPPED,' ',
#                           g_x[22] CLIPPED,sr.abi12 CLIPPED
#          WHEN l_no = 3
#               LET l_str = g_x[21] CLIPPED,sr.abi11 CLIPPED,' ',
#                           g_x[22] CLIPPED,sr.abi12 CLIPPED,' ',
#                           g_x[23] CLIPPED,sr.abi13 CLIPPED
#          WHEN l_no = 4
#               LET l_str = g_x[21] CLIPPED,sr.abi11 CLIPPED,' ',
#                           g_x[22] CLIPPED,sr.abi12 CLIPPED,' ',
#                           g_x[23] CLIPPED,sr.abi13 CLIPPED,' ',
#                           g_x[24] CLIPPED,sr.abi14 CLIPPED
#          WHEN l_no = 5
#               LET l_str = g_x[21] CLIPPED,sr.abi11 CLIPPED,' ',
#                           g_x[22] CLIPPED,sr.abi12 CLIPPED,' ',
#                           g_x[23] CLIPPED,sr.abi13 CLIPPED,' ',
#                           g_x[24] CLIPPED,sr.abi14 CLIPPED,' ',
#                           g_x[27] CLIPPED,sr.abi31 CLIPPED
#          WHEN l_no = 6
#               LET l_str = g_x[21] CLIPPED,sr.abi11 CLIPPED,' ',
#                           g_x[22] CLIPPED,sr.abi12 CLIPPED,' ',
#                           g_x[23] CLIPPED,sr.abi13 CLIPPED,' ',
#                           g_x[24] CLIPPED,sr.abi14 CLIPPED,' ',
#                           g_x[27] CLIPPED,sr.abi31 CLIPPED,' ',
#                           g_x[28] CLIPPED,sr.abi32 CLIPPED
#           WHEN l_no = 7
#                LET l_str = g_x[21] CLIPPED,sr.abi11 CLIPPED,' ',
#                            g_x[22] CLIPPED,sr.abi12 CLIPPED,' ',
#                            g_x[23] CLIPPED,sr.abi13 CLIPPED,' ',
#                            g_x[24] CLIPPED,sr.abi14 CLIPPED,' ',
#                            g_x[27] CLIPPED,sr.abi31 CLIPPED,' ',
#                            g_x[28] CLIPPED,sr.abi32 CLIPPED,' ',
#                            g_x[29] CLIPPED,sr.abi33 CLIPPED
#           WHEN l_no = 8
#                LET l_str = g_x[21] CLIPPED,sr.abi11 CLIPPED,' ',
#                            g_x[22] CLIPPED,sr.abi12 CLIPPED,' ',
#                            g_x[23] CLIPPED,sr.abi13 CLIPPED,' ',
#                            g_x[24] CLIPPED,sr.abi14 CLIPPED,' ',
#                            g_x[27] CLIPPED,sr.abi31 CLIPPED,' ',
#                            g_x[28] CLIPPED,sr.abi32 CLIPPED,' ',
#                            g_x[29] CLIPPED,sr.abi33 CLIPPED,' ',
#                            g_x[30] CLIPPED,sr.abi34 CLIPPED
#           WHEN l_no = 9
#                LET l_str = g_x[21] CLIPPED,sr.abi11 CLIPPED,' ',
#                            g_x[22] CLIPPED,sr.abi12 CLIPPED,' ',
#                            g_x[23] CLIPPED,sr.abi13 CLIPPED,' ',
#                            g_x[24] CLIPPED,sr.abi14 CLIPPED,' ',
#                            g_x[27] CLIPPED,sr.abi31 CLIPPED,' ',
#                            g_x[28] CLIPPED,sr.abi32 CLIPPED,' ',
#                            g_x[29] CLIPPED,sr.abi33 CLIPPED,' ',
#                            g_x[30] CLIPPED,sr.abi34 CLIPPED,' ',
#                            g_x[39] CLIPPED,sr.abi35 CLIPPED
#            WHEN l_no = 10
#                 LET l_str = g_x[21] CLIPPED,sr.abi11 CLIPPED,' ',
#                             g_x[22] CLIPPED,sr.abi12 CLIPPED,' ',
#                             g_x[23] CLIPPED,sr.abi13 CLIPPED,' ',
#                             g_x[24] CLIPPED,sr.abi14 CLIPPED,' ',
#                             g_x[27] CLIPPED,sr.abi31 CLIPPED,' ',
#                             g_x[28] CLIPPED,sr.abi32 CLIPPED,' ',
#                             g_x[29] CLIPPED,sr.abi33 CLIPPED,' ',
#                             g_x[30] CLIPPED,sr.abi34 CLIPPED,' ',
#                             g_x[39] CLIPPED,sr.abi35 CLIPPED,' ',
#                             g_x[40] CLIPPED,sr.abi36 CLIPPED
#        END CASE
    #FUN-5C0015 add (e)--------------------
#        IF sr.type ='2' THEN LET l_sw = '*' ELSE  LET l_sw = ' ' END IF
#No.FUN-580010 --start--
#       PRINT sr.abi06,' ',sr.abi01,l_sw,' ',
#             COLUMN 24,sr.abi07,COLUMN 31, l_str;
#        PRINT COLUMN g_c[32],sr.abi06,
#              COLUMN g_c[33],sr.abi01,l_sw,
#              COLUMN g_c[34],sr.abi07,
              # FUN-5C0015 mod (s)
              #COLUMN g_c[35],l_str;
#              COLUMN g_c[35],sr.abi10 CLIPPED;
              # FUN-5C0015 mod (e)
#No.FUN-580010 --end--
#        CASE
#          WHEN sr.type = '2'
#               IF sr.aag222 = '1' THEN
#                    LET l_dif = l_dif + sr.abi08
#No.FUN-580010 --start--
#                   PRINT COLUMN 81,cl_numfor(sr.abi08,18,g_azi04),
#                         COLUMN 119,cl_numfor(l_dif,18,g_azi04)
#                    PRINT COLUMN g_c[36],cl_numfor(sr.abi08,18,g_azi04),
#                          COLUMN g_c[38],cl_numfor(l_dif,18,g_azi04)
#No.FUN-580010 --end--
#               ELSE
#                    LET l_dif = l_dif + sr.abi08
#No.FUN-580010 --start--
#                   PRINT COLUMN 100,cl_numfor(sr.abi08,18,g_azi04),
#                         COLUMN 119,cl_numfor(l_dif,18,g_azi04)
#                    PRINT COLUMN g_c[37],cl_numfor(sr.abi08,18,g_azi04),
#                          COLUMN g_c[38],cl_numfor(l_dif,18,g_azi04)
#No.FUN-580010 --end--
#               END IF
#          WHEN sr.type = '3'
#               IF sr.aag222 = '2' THEN
#                    LET l_dif = l_dif - sr.abi08
#No.FUN-580010 --start--
#                   PRINT COLUMN 81,cl_numfor(sr.abi08,18,g_azi04),
#                         COLUMN 119,cl_numfor(l_dif,18,g_azi04)
#                    PRINT COLUMN g_c[36],cl_numfor(sr.abi08,18,g_azi04),
#                          COLUMN g_c[38],cl_numfor(l_dif,18,g_azi04)
#No.FUN-580010 --end--
#               ELSE
#                    LET l_dif = l_dif - sr.abi08
#No.FUN-580010 --start--
#                   PRINT COLUMN 100,cl_numfor(sr.abi08,18,g_azi04),
#                         COLUMN 119,cl_numfor(l_dif,18,g_azi04)
#                    PRINT COLUMN g_c[37],cl_numfor(sr.abi08,18,g_azi04),
#                          COLUMN g_c[38],cl_numfor(l_dif,18,g_azi04)
#No.FUN-580010 --end--
#               END IF
#          OTHERWISE PRINT ' ' EXIT CASE
#        END CASE
# FUN-5C0015 (s)
#        IF NOT cl_null(l_str) THEN
#           PRINT COLUMN g_c[35],l_str CLIPPED
#        END IF
#
#        CASE
#          WHEN l_no = 2
#           IF not cl_null(sr.abi10) THEN
##             PRINT column 31,sr.abi10
#              PRINT COLUMN g_c[35],sr.abi10   #No.FUN-580010
#           END IF
#          WHEN l_no = 3 OR l_no = 4
##No.FUN-580010 --start--
##          PRINT column 21,g_x[23] CLIPPED,sr.abi13,' ',
##                          g_x[24] CLIPPED,sr.abi14,sr.abi10
#           PRINT COLUMN g_c[33],g_x[23] CLIPPED,sr.abi13,' ',
#                 COLUMN g_c[34],g_x[24] CLIPPED,sr.abi14,sr.abi10
##No.FUN-580010 --end--
#          OTHERWISE EXIT CASE
#        END CASE
#
# FUN-5C0015 (e)
        #--->列印額外摘要
#        LET l_flag  = 'N'
#        LET l_no2 = 0
#        FOREACH abc_cur USING sr.abi01,sr.abi02 INTO l_abc03,l_abc04
#           LET l_no2 = l_no2 + 1
#           LET l_flag = 'Y'
#           CASE
##No.FUN-580010 --start--
##            WHEN l_no2 = 1  PRINT column 21,l_abc04;
##            WHEN l_no2 = 2  PRINT column 51,l_abc04
#             WHEN l_no2 = 1  PRINT COLUMN g_c[33],l_abc04;
#             WHEN l_no2 = 2  PRINT COLUMN g_c[34],l_abc04
#No.FUN-580010 --end--
#                             LET l_no2 = 0
#             OTHERWISE  EXIT CASE
#           END CASE
#        END FOREACH
#        IF l_no2 != 2 AND l_flag = 'Y' THEN PRINT END IF
#     END IF
 
#   AFTER GROUP OF sr.abi11
#      PRINT ' '
#      LET l_tot = l_tot + l_dif
#      PRINT g_dash1     #No.FUN-580010
#   AFTER GROUP OF sr.abi05  #Account code
##No.FUN-580010 --start--
#     PRINT g_dash1[1,g_len]
#     PRINT COLUMN 17,g_x[25] CLIPPED,
#           COLUMN 119,cl_numfor(l_tot,18,g_azi05)
#     PRINT g_dash[1,g_len]
#      PRINT COLUMN g_c[35],g_x[25] CLIPPED,
#            COLUMN g_c[38],cl_numfor(l_tot,18,g_azi05)
##No.FUN-580010 --end--
#   ON LAST ROW
#      LET l_last_sw = 'y'
 
#   PAGE TRAILER
#      PRINT g_dash[1,g_len]
#      IF l_last_sw = 'n'
#         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      END IF
#END REPORT
#Patch....NO.TQC-610035 <> #
#FUN-7C0038---------END-----MARK----
