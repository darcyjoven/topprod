# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglr811.4gl
# Descriptions...: 科目異動碼明細表(aglr811)
# Input parameter:
# Return code....:
# Modify.........: No.MOD-490260 04/09/14 By Nicola 加一選項條件,"餘額為0是否顯示"
# Modify.........: No.FUN-580010 05/08/15 By yoyo 憑証類報表原則修改
# Modify.........: No.TQC-5A0136 05/12/06 By Nicola 餘額判斷修改
# Modify.........: No.FUN-5C0015 06/01/06 By kevin
#                  1.原列印aag15~18，改抓ahe02 ( ahe01=aag15~18，aag31~37)
#                  2.增加列印abi31~37，(abi11~14，abi31~36依參數aaz88印出)
# Modify.........: No.TQC-620025 06/02/09 By Jana 解決動態表頭
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680098 06/09/01 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.MOD-680084 06/09/06 By Smapmin 不應只判斷異動碼第一碼有值才抓取資料
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6A0080 06/11/23 By xumin 頁次顯示錯誤
# Modify.........: No.FUN-6C0012 06/12/28 By Judy 新增打印額外名稱功能
# Modify.........: No.FUN-740020 07/04/10 By bnlent 會計科目加帳套
# Modify.........: No.TQC-760105 07/06/18 By hongmei 修改顯示重復
# Modify.........: No.FUN-750098 07/06/21 By hongmei 修改資料重復
# Modify.........: No.FUN-830104 08/04/28 By dxfwo 報表改由CR輸出
# Modify.........: No.MOD-950141 09/05/14 By lilingyu l_sql 去掉abc00 = aag00條件,EXECUTE參數調整
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A90053 10/09/07 By Dido 帳別應納入條件之一 
# Modify.........: No.FUN-B20054 11/02/23 By xianghui 先錄入帳套,科目根據帳套過濾;結構改為DIALOG
# Modify.........: No.FUN-B40026 11/06/20 By zhangweib 取消abg31~abg36, abi31~abi36, aag31~aag36相關處理
# Modify.........: No.FUN-B80057 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: No.MOD-B80029 11/08/04 By Polly 當月立帳資料沒有寫入CR Temptable
# Modify.........: No.MOD-BC0172 11/12/16 By Polly 將l_sql、wc型態改為STRING 
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                             # Print condition RECORD
             #wc      LIKE type_file.chr1000,    # Where condition   #No.FUN-680098    VARCHAR(300)  #MOD-BC0172 mark
              wc      STRING,                    #MOD-BC0172 add 
              edate   LIKE type_file.dat,        # 截止日期          #No.FUN-680098    DATE,
              bookno  LIKE aaa_file.aaa01,       #No.FUN-740020
              zero    LIKE type_file.chr1,        #No.FUN-680098  VARCHAR(1)   
              e       LIKE type_file.chr1,       #FUN-6C0012
              more    LIKE type_file.chr1         # Input more condition(Y/N)  #No.FUN-680098  VARCHAR(1)  
              END RECORD,
         #g_bookno     LIKE aaa_file.aaa01,       #帳別
         l_orderA     ARRAY[2] OF  LIKE type_file.chr20         #No.FUN-680098    VARCHAR(20)
#DEFINE   g_dash         VARCHAR(400)   #Dash line                 #No.FUN-580010 
DEFINE   g_i              LIKE type_file.num5     #count/index for any purpose    #No.FUN-680098 SMALLINT
#DEFINE   g_len          LIKE type_file.num5      #Report width(79/132/136)    #No.FUN-580010
#DEFINE   g_pageno        LIKE type_file.num5     #Report page no              #No.FUN-580010
#DEFINE   g_zz05          LIKE zz_file.zz05       #Print tm.wc ?(Y/N) #No.FUN-580010 #No.FUN-680098 VARCHAR(1)
#No.FUN-830104---Begin                                                                                                              
DEFINE    g_sql       STRING                                                                                                        
DEFINE    g_str       STRING                                                                                                        
DEFINE    l_table1    STRING                                                                                                        
DEFINE    l_table2    STRING                                                                                                        
#No.FUN-830104---End 
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
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114 #FUN-BB0047 mark
   
   #No.FUN-830104---Begin    
   LET g_sql = " abi11.abi_file.abi11,",
               " abi12.abi_file.abi12,",
               " abi13.abi_file.abi13,",
               " abi14.abi_file.abi14,",
              #" abi31.abi_file.abi31,",   #FUN-B40026   Mark
              #" abi32.abi_file.abi32,",   #FUN-B40026   Mark
              #" abi33.abi_file.abi33,",   #FUN-B40026   Mark
              #" abi34.abi_file.abi34,",   #FUN-B40026   Mark
              #" abi35.abi_file.abi35,",   #FUN-B40026   Mark
              #" abi36.abi_file.abi36,",   #FUN-B40026   Mark
               " abi10.abi_file.abi10,",
               " abi07.abi_file.abi07,",
               " abi01.abi_file.abi01,",
               " abi02.abi_file.abi02,",
               " abi06.abi_file.abi06,",
               " abi08.abi_file.abi08,",
               " abi05.abi_file.abi05,",
               " aag13.aag_file.aag13,",
               " aag02.aag_file.aag02 " 
   LET l_table1 = cl_prt_temptable('aglr8111',g_sql) CLIPPED                                                                  
   IF  l_table1 = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql = " abc01.abc_file.abc01,",
               " abc02.abc_file.abc02,",                                        
               " abc04.abc_file.abc04,",
               " l_chr.type_file.chr1000 " 
   LET l_table2 = cl_prt_temptable('aglr8112',g_sql) CLIPPED                    
   IF  l_table2 = -1 THEN EXIT PROGRAM END IF    
 #No.FUN-830104---End  
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET tm.bookno= ARG_VAL(1)        #No.FUN-740020
   LET g_pdate = ARG_VAL(2)         # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc    = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.zero = ARG_VAL(10)   #TQC-610056
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No.FUN-570264 ---end---
   LET tm.e     = ARG_VAL(14)   #FUN-6C0012
 
#   SELECT azi04,azi05 INTO g_azi04,g_azi05 FROM azi_file WHERE azi01=g_aza.aza17          #No.CHI-6A0004 mark
   #No.FUN-740020  --Begin
   #IF g_bookno IS  NULL OR g_bookno = ' ' THEN
   #   LET g_bookno = g_aaz.aaz64
   #END IF
   #No.FUN-740020  --End
   IF cl_null(g_bgjob) OR g_bgjob = 'N'  THEN    # If background job sw is off
      CALL aglr811_tm(0,0)                    # Input print condition
   ELSE
      CALL aglr811()                          # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION aglr811_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01             #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,            #No.FUN-680098 SMALLINT
          l_cmd       LIKE type_file.chr1000          #No.FUN-680098 VARCHAR(400)
DEFINE li_chk_bookno  LIKE type_file.num5             #No.FUN-B20054
 
   CALL s_dsmark(tm.bookno)    #No.FUN-740020
 
   LET p_row = 4 LET p_col = 26
   OPEN WINDOW aglr811_w AT p_row,p_col
     WITH FORM "agl/42f/aglr811"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL s_shwact(0,0,tm.bookno)   #No.FUN-740020
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.edate = g_today
   LET tm.zero  = 'N'
   LET tm.e     = 'N'  #FUN-6C0012
   LET tm.more  = 'N'
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
   LET tm.bookno = g_aza.aza81   #No.FUN-740020

   DISPLAY BY NAME tm.bookno,tm.edate,tm.zero,tm.e,tm.more       #No.FUN-B20054
   WHILE TRUE
#No.FUN-B20054-add--start--
      DIALOG ATTRIBUTE(unbuffered)
         INPUT BY NAME tm.bookno ATTRIBUTE(WITHOUT DEFAULTS)
            AFTER FIELD bookno
              IF NOT cl_null(tm.bookno) THEN
                   CALL s_check_bookno(tm.bookno,g_user,g_plant)
                    RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                    NEXT FIELD bookno
                END IF
                SELECT aaa02 FROM aaa_file WHERE aaa01 = tm.bookno
                IF STATUS THEN
                   CALL cl_err3("sel","aaa_file",tm.bookno,"","agl-043","","",0)
                   NEXT FIELD  bookno
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
#         ON ACTION locale
#           LET g_action_choice = "locale"
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#           EXIT CONSTRUCT
# 
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE CONSTRUCT
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
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT CONSTRUCT
# 
#         #No.FUN-580031 --start--
#         ON ACTION qbe_select
#            CALL cl_qbe_select()
#         #No.FUN-580031 ---end---
#No.FUN-B20054-mark--end-- 
      END CONSTRUCT
#No.FUN-B20054--mark--end--
#      IF g_action_choice = "locale" THEN
#         LET g_action_choice = ""
#         CALL cl_dynamic_locale()
#         CONTINUE WHILE
#      END IF
# 
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0
#         CLOSE WINDOW aglr811_w
#         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#         EXIT PROGRAM
#      END IF
# 
#      IF tm.wc = ' 1=1' THEN
#         CALL cl_err('','9046',0)
#         CONTINUE WHILE
#      END IF
# 
#      DISPLAY BY NAME tm.bookno,tm.edate,tm.zero,tm.e,tm.more # Condition  #FUN-6C0012     #No.FUN-740020
# 
#      INPUT BY NAME tm.edate,tm.bookno,tm.zero,tm.e,tm.more WITHOUT DEFAULTS  #FUN-6C0012  #No.FUN-740020
#No.FUN-B20054--mark--end--
       INPUT BY NAME tm.edate,tm.zero,tm.e,tm.more    ATTRIBUTE(WITHOUT DEFAULTS)    #No.FUN-B20054
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD edate
            IF cl_null(tm.edate) THEN
               NEXT FIELD edate
            END IF
#No.FUN-B20054--mark--start-- 
#         #No.FUN-740020  --Begin
#         AFTER FIELD bookno 
#            IF cl_null(tm.bookno) THEN
#               NEXT FIELD tm.bookno
#            END IF
#         #No.FUN-740020  --End
#No.FUN-B20054--mark--end--
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies)
                       RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
            END IF
#No.FUN-B20054--mark--start-- 
#         #No.FUN-740020  --Begin
#         ON ACTION CONTROLP
#          CASE
#            WHEN INFIELD(bookno)                                                                                                       
#              CALL cl_init_qry_var()                                                                                                 
#              LET g_qryparam.form = 'q_aaa'                                                                                          
#              LET g_qryparam.default1 = tm.bookno                                                                                     
#              CALL cl_create_qry() RETURNING tm.bookno                                                                                
#              DISPLAY BY NAME tm.bookno                                                                                               
#              NEXT FIELD bookno 
#          END CASE
#         #No.FUN-740020  --End
# 
#         ON ACTION CONTROLR
#            CALL cl_show_req_fields()
# 
#         ON ACTION CONTROLG
#            CALL cl_cmdask()    # Command execution
# 
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE INPUT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
# 
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT INPUT
# 
#         #No.FUN-580031 --start--
#         ON ACTION qbe_save
#            CALL cl_qbe_save()
#         #No.FUN-580031 ---end---
#No.FUN-B20054--mark--end-- 
      END INPUT
#No.FUN-B20054--add-start--
        ON ACTION CONTROLP
         CASE
           WHEN INFIELD(bookno)
             CALL cl_init_qry_var()
             LET g_qryparam.form = 'q_aaa'
             LET g_qryparam.default1 = tm.bookno
             CALL cl_create_qry() RETURNING tm.bookno
             DISPLAY BY NAME tm.bookno
             NEXT FIELD bookno
           WHEN INFIELD(aag01)
             CALL cl_init_qry_var()
             LET g_qryparam.form     = "q_aag02"
             LET g_qryparam.state    = "c"
             LET g_qryparam.where = " aag00 = '",tm.bookno CLIPPED,"'"
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

#No.FUn-B20054--add-end-- 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aglr811_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
#No.FUN-B20054--add--start--
      IF tm.wc = ' 1=1' THEN       
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
#No.FUN-B20054--add-end-- 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aglr811'
         IF SQLCA.sqlcode OR cl_null(l_cmd) THEN
            CALL cl_err('aglr811','9031',1)   
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",tm.bookno CLIPPED,"' ",   #No.FUN-740020
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_lang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.edate CLIPPED,"'",
                        " '",tm.zero CLIPPED,"'",   #TQC-610056
                        " '",tm.e CLIPPED,"'",   #FUN-6C0012
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('aglr811',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW aglr811_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
 
      CALL aglr811()
 
      ERROR ""
 
   END WHILE
 
   CLOSE WINDOW aglr811_w
 
END FUNCTION
 
FUNCTION aglr811()
   DEFINE l_name    LIKE type_file.chr20,           # External(Disk) file name             #No.FUN-680098 VARCHAR(20)
          #l_time   LIKE type_file.chr8             #No.FUN-6A0073
         #l_sql     LIKE type_file.chr1000,         # RDSQL STATEMENT        #No.FUN-680098 VARCHAR(1000)  #MOD-BC0172 mark
          l_sql     STRING,                         #MOD-BC0172 add
          l_za05    LIKE za_file.za05,              #No.FUN-680098 VARCHAR(40)
          l_order   ARRAY[2] OF LIKE abh_file.abh11,      #No.FUN-680098   VARCHAR(30)
          l_yy,l_mm  LIKE type_file.num10,            #No.FUN-680098   INTEGER
          l_bdate    LIKE type_file.dat,              #No.FUN-680098    DATE
          l_lastyy,l_lastmm   LIKE type_file.num10,   #No.FUN-680098    INTEGER
          l_chr        LIKE type_file.chr1000,        #No.FUN-830104                                                                
          l_abc03      LIKE abc_file.abc03,           #No.FUN-830104                                                                
          l_abc04      LIKE abc_file.abc04,           #No.FUN-830104
          l_abh     RECORD LIKE abh_file.*,
          sr        RECORD
                    type       LIKE type_file.chr1,   #No.FUN-680098  VARCHAR(1)
                    abi01     LIKE  abi_file.abi01,  #傳票編號
                    abi02     LIKE  abi_file.abi02,  #項次
                    abi03     LIKE  abi_file.abi03,  #年度
                    abi04     LIKE  abi_file.abi04,  #期別
                    abi05     LIKE  abi_file.abi05,  #會計科目
                    abi06     LIKE  abi_file.abi06,  #傳票日期
                    abi07     LIKE  abi_file.abi07,  #部門
                    abi08     LIKE  abi_file.abi08,  #金額
                    abi10     LIKE  abi_file.abi10,  #摘要
                    abi11     LIKE  abi_file.abi11,  #異動碼一
                    abi12     LIKE  abi_file.abi12,  #異動碼二
                    abi13     LIKE  abi_file.abi13,  #異動碼三
                    abi14     LIKE  abi_file.abi14,  #異動碼四
                    # FUN-5C0015 add (s)
                   #abi31     LIKE  abi_file.abi31,  #異動碼五   #FUN-B40026   Mark
                   #abi32     LIKE  abi_file.abi32,  #異動碼六   #FUN-B40026   Mark
                   #abi33     LIKE  abi_file.abi33,  #異動碼七   #FUN-B40026   Mark
                   #abi34     LIKE  abi_file.abi34,  #異動碼八   #FUN-B40026   Mark
                   #abi35     LIKE  abi_file.abi35,  #異動碼九   #FUN-B40026   Mark
                   #abi36     LIKE  abi_file.abi36,  #異動碼十   #FUN-B40026   Mark
                    # FUN-5C0015 add (e)
                    aag02     LIKE  aag_file.aag02,  #會計名稱
                    aag13     LIKE  aag_file.aag13,  #額外名稱 #FUN-6C0012
                    aag15     LIKE  aag_file.aag15,  #異動1-名稱
                    aag16     LIKE  aag_file.aag16,  #異動2-名稱
                    aag17     LIKE  aag_file.aag17,  #異動3-名稱
                    aag18     LIKE  aag_file.aag18,  #異動4-名稱
                    #FUN-5C0015 add(s)
                   #aag31     LIKE  aag_file.aag31,  #異動5-代碼   #FUN-B40026   Mark
                   #aag32     LIKE  aag_file.aag32,  #異動6-代碼   #FUN-B40026   Mark
                   #aag33     LIKE  aag_file.aag33,  #異動7-代碼   #FUN-B40026   Mark
                   #aag34     LIKE  aag_file.aag34,  #異動8-代碼   #FUN-B40026   Mark
                   #aag35     LIKE  aag_file.aag35,  #異動9-代碼   #FUN-B40026   Mark
                   #aag36     LIKE  aag_file.aag36,  #異動10代碼   #FUN-B40026   Mark
                    abc01     LIKE  abc_file.abc01,                                                                                 
                    abc02     LIKE  abc_file.abc02,                                                                                 
                    abc04     LIKE  abc_file.abc04,
                    ahe02a    LIKE  ahe_file.ahe02,
                    ahe02b    LIKE  ahe_file.ahe02,
                    ahe02c    LIKE  ahe_file.ahe02,
                    ahe02d    LIKE  ahe_file.ahe02,
                    ahe02e    LIKE  ahe_file.ahe02,
                    ahe02f    LIKE  ahe_file.ahe02,
                    ahe02g    LIKE  ahe_file.ahe02,
                    ahe02h    LIKE  ahe_file.ahe02,
                    ahe02i    LIKE  ahe_file.ahe02,
                    ahe02j    LIKE  ahe_file.ahe02
                    # FUN-5C0015 add (e)
                    END RECORD
 
      CALL g_zaa_dyn.clear()       #TQC-620025
 
#No.FUN-830104---Begin                                                                                                              
     CALL cl_del_data(l_table1)                                                                                                     
     CALL cl_del_data(l_table2)                                                                                                     
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                               
               " VALUES(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?)"#,?,?,  ?,?,?,? )"    #FUN-B40026   Mark & Add ")                                           
     PREPARE insert_prep FROM g_sql                                                                                                 
     IF STATUS THEN                                                                                                                 
       CALL cl_err('insert_prep:',status,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80057--add--
       EXIT PROGRAM                                                                            
     END IF                                                                                                                         
                                                                                                                                    
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,                                                               
                 " VALUES(?,?,?,? )        "                                                                                        
     PREPARE insert_prep1 FROM g_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err('insert_prep1:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80057--add--
        EXIT PROGRAM                                                                          
     END IF                                                                                                                         
                                                                                                                                    
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                       
 #No.FUN-830104---End 
 
     SELECT aaf03 INTO g_company FROM aaf_file
      WHERE aaf01 = tm.bookno AND aaf02 = g_rlang    #No.FUN-740020
 
     DECLARE aglr811_za_cur CURSOR FOR
      SELECT za02,za05 FROM za_file WHERE za01 = "aglr811" AND za03 = g_rlang
 
     FOREACH aglr811_za_cur INTO g_i,l_za05
        LET g_x[g_i] = l_za05
     END FOREACH
 
#No.FUN-580010--start
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aglr811'
 
#    IF g_len = 0 OR cl_null(g_len) THEN
#       LET g_len = 137
#    END IF
 
#    FOR g_i = 1 TO g_len
#       LET g_dash[g_i,g_i] = '='
#    END FOR
 
#    FOR g_i = 1 TO g_len
#       LET g_dash1[g_i,g_i] = '-'
#    END FOR
#No.FUN-580010--end
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #        LET tm.wc = tm.wc clipped," AND aaguser = '",g_user,"'"
     #     END IF
 
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #        LET tm.wc = tm.wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #        LET tm.wc = tm.wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
     #End:FUN-980030
 
 
     #---->取額外摘要
     LET l_sql = " SELECT abc03,abc04 FROM abc_file ",
                 "  WHERE abc00 = '",tm.bookno,"'",      #No.FUN-740020
             #   "  AND abc00 = aag00",                  #No.TQC-760105  #MOD-950141 MARK
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
 
     #---->取本月份沖帳
     LET l_sql = "SELECT * FROM abh_file ",
                 " WHERE abh00 = '",tm.bookno,"'",   #No.FUN-740020
                 "   AND abhconf = 'Y' ",
                 "   AND abh07= ? AND abh08 = ? " ,
                 "   AND (abh021 BETWEEN '",l_bdate,"' AND '",tm.edate,"')"
 
     PREPARE r811_abh_pre FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('pre abh_pre:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM
     END IF
 
     DECLARE r811_abh_cur CURSOR FOR r811_abh_pre
 
     #---->取上月份立帳餘額之後要減沖帳金額
     LET l_sql = "SELECT '1',abi01, abi02, abi03, abi04, abi05, abi06, abi07,",
                 " (abi08-abi09), abi10, abi11, abi12, abi13, abi14,",
                #" abi31,abi32,abi33,abi34,abi35,abi36, ", # FUN-5C0015   #FUN-B40026   Mark
                 " aag02, aag13, aag15, aag16, aag17, aag18, ",  #FUN-6C0012
                #" aag31,aag32,aag33,aag34,aag35,aag36, ", # FUN-5C0015   #FUN-B40026   Mark
                 " '','','','','','','','','',''",         # FUN-5C0015
                 " FROM abi_file , aag_file  " ,
                 " WHERE abi00 = '",tm.bookno,"'",  #No.FUN-740020
                 "   AND abi00 = aag00 ",        #No.FUN-740020
                 "   AND ", tm.wc CLIPPED,
                 "   AND abi03 = '",l_lastyy,"'",
                 "   AND abi04 = '",l_lastmm,"'",
                 "   AND (abi08-abi09) > 0 ",
                 "   AND abi05=aag01 AND aag222 IN ('1','2') "
                 #"   AND (aag15 IS NOT NULL OR aag15 !=' ')  "   #MOD-680084
 
     PREPARE aglr811_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM
     END IF
 
     DECLARE aglr811_curs1 CURSOR FOR aglr811_prepare1
 
     #---->取本月份立帳
     #-----No.MOD-490260-----
     #-----No.TQC-5A0136 Mark-----
    #IF tm.zero ="Y" THEN
        LET l_sql = "SELECT '2',abg01,abg02,'','',abg03,abg06,abg05,",
                   #" (abg071-abg072),abg04,abg11,abg12,abg13,abg14,",
                    " abg071,abg04,abg11,abg12,abg13,abg14,",
                   #" abg31,abg32,abg33,abg34,abg35,abg36, ", # FUN-5C0015   #FUN-B40026   Mark
                    " aag02, aag13, aag15, aag16, aag17, aag18, ",  #FUN-6C0012
                   #" aag31,aag32,aag33,aag34,aag35,aag36, ", # FUN-5C0015   #FUN-B40026   Mark
                    " '','','','','','','','','',''",         # FUN-5C0015
                    "  FROM abg_file,aag_file ",
                   #" WHERE (abg071-abg072) > 0",
                    " WHERE (abg06 BETWEEN '",l_bdate,"' AND '",tm.edate,"')",
                 #   "  AND abg00 = aag00 ",         #No.FUN-740020
                    "  AND aag00 = '",tm.bookno,"'", #No.FUN-740020            #MOD-A90053 remark
                    "  AND ", tm.wc CLIPPED,
                    "  AND abg03=aag01 AND aag222 IN ('1','2') ",
                    #" AND (aag15 IS NOT NULL OR aag15 !=' ')  ",   #MOD-680084
                     " AND abg00 = aag00 "          # NNo.FUN-750098
    #ELSE
    #   LET l_sql = "SELECT '2',abg01,abg02,'','',abg03,abg06,abg05,",
    #              #" (abg071-abg072),abg04,abg11,abg12,abg13,abg14,",
    #               " abg071,abg04,abg11,abg12,abg13,abg14,",
    #               " aag02, aag15, aag16, aag17, aag18 ",
    #               "  FROM abg_file,aag_file ",
    #               " WHERE (abg071-abg072) > 0",
    #               "   AND (abg06 BETWEEN '",l_bdate,"' AND '",tm.edate,"')",
    #               "   AND ", tm.wc CLIPPED,
    #               "   AND abg03=aag01 AND aag222 IN ('1','2') ",
    #               "   AND (aag15 IS NOT NULL OR aag15 !=' ')  "
    #END IF
     #-----No.MOD-490260 END-----
     #-----No.TQC-5A0136 Mark END-----
 
     PREPARE r811_abg_pre FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('pre abg_pre:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM
     END IF
 
     DECLARE r811_abg_cur CURSOR FOR r811_abg_pre       #No.FUN-830104 
 
#    CALL cl_outnam('aglr811') RETURNING l_name         #No.FUN-830104 
 
     CALL r811_show_field()     # FUN-5C0015 add
     CALL cl_prt_pos_len()      # FUN-5C0015 重算g_len
 
#    START REPORT aglr811_rep TO l_name                 #No.FUN-830104 
 
     LET g_pageno = 0
     INITIALIZE sr.* TO NULL
 
     #--->期初立帳尚有餘額者
     FOREACH aglr811_curs1 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach r811_curs1:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
 
        #---->扣除當月沖帳
        FOREACH r811_abh_cur USING sr.abi01,sr.abi02 INTO l_abh.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach abh_cur:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           LET sr.abi08 = sr.abi08 - l_abh.abh09
        END FOREACH
 
        IF tm.zero = "N" THEN    #MOD-B80029 add
           IF sr.abi08 = 0 THEN
              CONTINUE FOREACH
           END IF
        END IF                   #MOD-B80029 add
 
       # FUN-5C0015 add(s)-------
        SELECT ahe02 INTO sr.ahe02a FROM ahe_file
          WHERE ahe01 = sr.aag15
        SELECT ahe02 INTO sr.ahe02b FROM ahe_file
          WHERE ahe01 = sr.aag16
        SELECT ahe02 INTO sr.ahe02c FROM ahe_file
          WHERE ahe01 = sr.aag17
        SELECT ahe02 INTO sr.ahe02d FROM ahe_file
          WHERE ahe01 = sr.aag18
#FUN-B40026   ---start   Mark
#       SELECT ahe02 INTO sr.ahe02e FROM ahe_file
#         WHERE ahe01 = sr.aag31
#       SELECT ahe02 INTO sr.ahe02f FROM ahe_file
#         WHERE ahe01 = sr.aag32
#       SELECT ahe02 INTO sr.ahe02g FROM ahe_file
#         WHERE ahe01 = sr.aag33
#       SELECT ahe02 INTO sr.ahe02h FROM ahe_file
#         WHERE ahe01 = sr.aag34
#       SELECT ahe02 INTO sr.ahe02i FROM ahe_file
#         WHERE ahe01 = sr.aag35
#       SELECT ahe02 INTO sr.ahe02j FROM ahe_file
#         WHERE ahe01 = sr.aag36
#FUN-B40026   ---end     Mark 
       # FUN-5C0015 add(e)-------
#No.FUN-830104 ----Begin---- 
#       OUTPUT TO REPORT aglr811_rep(sr.*)
        EXECUTE insert_prep USING  sr.abi11, sr.abi12, sr.abi13, sr.abi14, #sr.abi31, sr.abi32,           #FUN-B40026   Mark                        
                                  #sr.abi33, sr.abi34, sr.abi35, sr.abi36,    #FUN-B40026   Mark
                                   sr.abi10, sr.abi07,                                      
                                   sr.abi01, sr.abi02, sr.abi06, sr.abi08, sr.abi05, sr.aag13,                                      
                                   sr.aag02                                                                                         
                                                                                                                                    
       LET l_chr = ''                                                                                                               
       FOREACH abc_cur USING sr.abi01,sr.abi02 INTO l_abc03,l_abc04                                                                 
         LET l_chr = l_chr CLIPPED,l_abc04 CLIPPED                                                                                  
       # EXECUTE insert_prep1 USING sr.abc01, sr.abc02, sr.abc04, l_chr   #MOD-950141                                                           
         EXECUTE insert_prep1 USING sr.abi01, sr.abi02, sr.abc04, l_chr   #MOD-950141                                                           
       END FOREACH   
     END FOREACH
 
     #--->當月立帳
     FOREACH r811_abg_cur INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach r811_curs1:',SQLCA.sqlcode,1)   
           EXIT FOREACH
        END IF
 
        #---->扣除當月沖帳
        FOREACH r811_abh_cur USING sr.abi01,sr.abi02 INTO l_abh.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach abh_cur:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           LET sr.abi08 = sr.abi08 - l_abh.abh09
        END FOREACH
 
        #-----No.TQC-5A0136-----
        IF tm.zero = "N" THEN
           IF sr.abi08 = 0 THEN
              CONTINUE FOREACH
           END IF
        END IF
        #-----No.TQC-5A0136 END-----
 
        # FUN-5C0015 add(s)
        SELECT ahe02 INTO sr.ahe02a FROM ahe_file
          WHERE ahe01 = sr.aag15
        SELECT ahe02 INTO sr.ahe02b FROM ahe_file
          WHERE ahe01 = sr.aag16
        SELECT ahe02 INTO sr.ahe02c FROM ahe_file
          WHERE ahe01 = sr.aag17
        SELECT ahe02 INTO sr.ahe02d FROM ahe_file
          WHERE ahe01 = sr.aag18
#FUN-B40026   --start   Mark
#       SELECT ahe02 INTO sr.ahe02e FROM ahe_file
#         WHERE ahe01 = sr.aag31
#       SELECT ahe02 INTO sr.ahe02f FROM ahe_file
#         WHERE ahe01 = sr.aag32
#       SELECT ahe02 INTO sr.ahe02g FROM ahe_file
#         WHERE ahe01 = sr.aag33
#       SELECT ahe02 INTO sr.ahe02h FROM ahe_file
#         WHERE ahe01 = sr.aag34
#       SELECT ahe02 INTO sr.ahe02i FROM ahe_file
#         WHERE ahe01 = sr.aag35
#       SELECT ahe02 INTO sr.ahe02j FROM ahe_file
#         WHERE ahe01 = sr.aag36
#FUN-B40026   ---end     Mark
        # FUN-5C0015 add(e)
 
#      OUTPUT TO REPORT aglr811_rep(sr.*)
#------------------------MOD-B80029----------------------------------start
        EXECUTE insert_prep USING
           sr.abi11,sr.abi12,sr.abi13,sr.abi14,#sr.abi31,sr.abi32,
           sr.abi10,sr.abi07,
           sr.abi01,sr.abi02,sr.abi06,sr.abi08,sr.abi05,sr.aag13,
           sr.aag02
#------------------------MOD-B80029----------------------------------end
       LET l_chr = ''                                                                                                               
       FOREACH abc_cur USING sr.abi01,sr.abi02 INTO l_abc03,l_abc04                                                                 
         LET l_chr = l_chr CLIPPED,l_abc04 CLIPPED                                                                                  
  #      EXECUTE insert_prep1 USING sr.abc01, sr.abc02, sr.abc04, l_chr  #MOD-950141                                                           
         EXECUTE insert_prep1 USING sr.abi01, sr.abi02, sr.abc04, l_chr  #MOD-950141                                                           
       END FOREACH 
     END FOREACH
 
#    FINISH REPORT aglr811_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
        LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",                                                      
                    "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED                                                           
                                                                                                                                    
        LET g_str = ''                                                                                                              
        #是否列印選擇條件                                                                                                           
        IF g_zz05 = 'Y' THEN                                                                                                        
           CALL cl_wcchp(tm.wc,'aag01')                                                                                             
                RETURNING g_str                                                                                                     
        END IF                                                                                                                      
#                     p1       p2         p3         p4                                                                             
        LET g_str = g_str,";",tm.e,";",g_azi04,";",g_azi05                                                                          
        CALL cl_prt_cs3('aglr811','aglr811',g_sql,g_str)                                                                            
#No.FUN-830104 ----End----                    
END FUNCTION
#No.FUN-830104 ----Begin---- 
#REPORT aglr811_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
#         l_no,l_no2   LIKE type_file.num5,          #No.FUN-680098  SMALLINT
#         l_sw,l_flag  LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
#         l_str        LIKE type_file.chr1000,       #No.FUN-680098  VARCHAR(89)
#         l_sec1       LIKE type_file.chr1000,       #No.FUN-680098  VARCHAR(50)
#         l_abc03      LIKE abc_file.abc03,
#         l_abc04      LIKE abc_file.abc04,
#         sr        RECORD
#                   type      LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
#                   abi01     LIKE  abi_file.abi01,  #傳票編號
#                   abi02     LIKE  abi_file.abi02,  #項次
#                   abi03     LIKE  abi_file.abi03,  #年度
#                   abi04     LIKE  abi_file.abi04,  #期別
#                   abi05     LIKE  abi_file.abi05,  #會計科目
#                   abi06     LIKE  abi_file.abi06,  #傳票日期
#                   abi07     LIKE  abi_file.abi07,  #部門
#                   abi08     LIKE  abi_file.abi08,  #金額
#                   abi10     LIKE  abi_file.abi10,  #摘要
#                   abi11     LIKE  abi_file.abi11,  #異動碼一
#                   abi12     LIKE  abi_file.abi12,  #異動碼二
#                   abi13     LIKE  abi_file.abi13,  #異動碼三
#                   abi14     LIKE  abi_file.abi14,  #異動碼四
#                   # FUN-5C0015 add (s)
#                   abi31     LIKE  abi_file.abi31,  #異動碼五
#                   abi32     LIKE  abi_file.abi32,  #異動碼六
#                   abi33     LIKE  abi_file.abi33,  #異動碼七
#                   abi34     LIKE  abi_file.abi34,  #異動碼八
#                   abi35     LIKE  abi_file.abi35,  #異動碼九
#                   abi36     LIKE  abi_file.abi36,  #異動碼十
#                   # FUN-5C0015 add (e)
#                   aag02     LIKE  aag_file.aag02,  #會計名稱
#                   aag13     LIKE  aag_file.aag13,  #額外名稱 #FUN-6C0012
#                   aag15     LIKE  aag_file.aag15,  #異動1-名稱
#                   aag16     LIKE  aag_file.aag16,  #異動2-名稱
#                   aag17     LIKE  aag_file.aag17,  #異動3-名稱
#                   aag18     LIKE  aag_file.aag18,  #異動4-名稱
#                   # FUN-5C0015 add(s)
#                   aag31     LIKE  aag_file.aag31,  #異動5-代碼
#                   aag32     LIKE  aag_file.aag32,  #異動6-代碼
#                   aag33     LIKE  aag_file.aag33,  #異動7-代碼
#                   aag34     LIKE  aag_file.aag34,  #異動8-代碼
#                   aag35     LIKE  aag_file.aag35,  #異動9-代碼
#                   aag36     LIKE  aag_file.aag36,  #異動10代碼
#                   ahe02a    LIKE  ahe_file.ahe02,
#                   ahe02b    LIKE  ahe_file.ahe02,
#                   ahe02c    LIKE  ahe_file.ahe02,
#                   ahe02d    LIKE  ahe_file.ahe02,
#                   ahe02e    LIKE  ahe_file.ahe02,
#                   ahe02f    LIKE  ahe_file.ahe02,
#                   ahe02g    LIKE  ahe_file.ahe02,
#                   ahe02h    LIKE  ahe_file.ahe02,
#                   ahe02i    LIKE  ahe_file.ahe02,
#                   ahe02j    LIKE  ahe_file.ahe02
#                   # FUN-5C0015 add (e)
#                   END RECORD
# DEFINE l_chr      STRING   #MOD-680084
 
# OUTPUT TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
 
#  ORDER BY sr.abi05,sr.abi06,sr.abi11,sr.abi12,sr.abi13
# FORMAT
#  PAGE HEADER
#No.FUN-380010--start
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF cl_null(g_towhom) OR g_towhom = ' ' THEN
#        PRINT '';
#     ELSE
#        PRINT 'TO:',g_towhom;
#     END IF
#     PRINT ''
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     LET g_pageno=g_pageno+1
#     LET pageno_total=PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
#      LET g_pageno = g_pageno + 1  #TQC-6A0080
#     #FUN-6C0012.....begin
#     IF tm.e = 'Y' THEN
#        PRINT COLUMN ((g_len-FGL_WIDTH(sr.aag13 CLIPPED)-12)/2)+1, sr.aag13 CLIPPED,
#              '(',sr.abi05 CLIPPED,')','  ',g_x[9] CLIPPED
#     ELSE
#     #FUN-6C0012.....end
#        PRINT COLUMN ((g_len-FGL_WIDTH(sr.aag02 CLIPPED)-12)/2)+1, sr.aag02 CLIPPED,    #No.TQC-6A0080
#             '(', sr.abi05 CLIPPED,')','  ',g_x[9] CLIPPED
#     END IF   #FUN-6C0012
#     PRINT COLUMN 53, sr.aag02 CLIPPED,'  ',g_x[9] CLIPPED,'  (',
#           sr.abi05 CLIPPED,')'
#     PRINT ' '
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#           COLUMN 59,g_x[11] CLIPPED,tm.edate,
#           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#     PRINT COLUMN 59,g_x[11] CLIPPED,tm.edate
#     PRINT g_dash
#     PRINT COLUMN   6,sr.aag15,COLUMN  21,sr.aag16,
#           COLUMN  37,sr.aag17,COLUMN  52,sr.aag18,
#           COLUMN  75,g_x[12] CLIPPED,
#           COLUMN  90,g_x[13] CLIPPED, COLUMN 103,g_x[14] CLIPPED,
#           COLUMN 117,g_x[15] CLIPPED, COLUMN 130,g_x[16] CLIPPED
#   # FUN-5C0015 add (s)
#    #LET g_zaa[31].zaa08=sr.aag15
#    #LET g_zaa[32].zaa08=sr.aag16
#    #LET g_zaa[33].zaa08=sr.aag17
#    #LET g_zaa[34].zaa08=sr.aag18
#     LET g_zaa[31].zaa08=sr.ahe02a
#     LET g_zaa[32].zaa08=sr.ahe02b
#     LET g_zaa[33].zaa08=sr.ahe02c
#     LET g_zaa[34].zaa08=sr.ahe02d
#     LET g_zaa[41].zaa08=sr.ahe02e
#     LET g_zaa[42].zaa08=sr.ahe02f
#     LET g_zaa[43].zaa08=sr.ahe02g
#     LET g_zaa[44].zaa08=sr.ahe02h
#     LET g_zaa[45].zaa08=sr.ahe02i
#     LET g_zaa[46].zaa08=sr.ahe02j
#    # FUN-5C0015 add (e)
#     CALL cl_prt_pos_dyn()   #TQC-620025
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],
#           g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],   #FUN-5C0015
#           g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
#     PRINT g_dash1
#No.FUN-580010--end
#     #-----MOD-680084---------
#     #LET l_no = 0
#     #IF not cl_null(sr.aag15) THEN LET l_no = l_no + 1  END IF
#     #IF not cl_null(sr.aag16) THEN LET l_no = l_no + 1  END IF
#     #IF not cl_null(sr.aag17) THEN LET l_no = l_no + 1  END IF
#     #IF not cl_null(sr.aag18) THEN LET l_no = l_no + 1  END IF
#     #-----END MOD-680084-----
#     PRINT g_dash[1,g_len]
#     LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.abi05  #Account code
#     SKIP TO TOP OF PAGE
 
#   ON EVERY ROW
#NO.FUN-5C0015(S)-----Mark 改依參數azz88動態判斷異動碼應show的組數-------
#
#     CASE
#No.FUN-580010--start
#       WHEN  l_no = 1
#             LET l_sec1 = g_x[21] CLIPPED,sr.abi11,' ',sr.abi10
#             PRINT COLUMN g_c[31],g_x[21] CLIPPED,sr.abi11 CLIPPED,
#                   COLUMN g_c[35],sr.abi10 CLIPPED;
#             LET l_flag = 'N'
#             FOREACH abc_cur USING sr.abi01,sr.abi02 INTO l_abc03,l_abc04
#                 LET l_flag  = 'Y'
#                 LET l_str = l_sec1,' ',l_abc04
#                 PRINT COLUMN g_c[36],l_abc04 CLIPPED;
#                 EXIT FOREACH
#             END FOREACH
#             IF l_flag = 'N' THEN LET l_str = l_sec1 CLIPPED END IF
#       WHEN  l_no = 2
#             LET l_str = g_x[21] CLIPPED,sr.abi11,' ',
#                         g_x[22] CLIPPED,sr.abi12,' ',sr.abi10
#             PRINT COLUMN g_c[31],g_x[21] CLIPPED,sr.abi11 CLIPPED,
#                   COLUMN g_c[32],g_x[22] CLIPPED,sr.abi12 CLIPPED,
#                   COLUMN g_c[35],sr.abi10 CLIPPED;
#       WHEN  l_no = 3
#             LET l_str = g_x[21] CLIPPED,sr.abi11,' ',
#                         g_x[22] CLIPPED,sr.abi12,' ',
#                         g_x[23] CLIPPED,sr.abi13,sr.abi10
#             PRINT COLUMN g_c[31],g_x[21] CLIPPED,sr.abi11 CLIPPED,
#                   COLUMN g_c[32],g_x[22] CLIPPED,sr.abi12 CLIPPED,
#                   COLUMN g_c[33],g_x[23] CLIPPED,sr.abi13 CLIPPED,
#                   COLUMN g_c[35],sr.abi10 CLIPPED;
#       WHEN  l_no = 4
#             LET l_str = g_x[21] CLIPPED,sr.abi11,' ',
#                         g_x[22] CLIPPED,sr.abi12,' ',
#                         g_x[23] CLIPPED,sr.abi13,' ',
#                         g_x[24] CLIPPED,sr.abi14
#             PRINT COLUMN g_c[31],g_x[21] CLIPPED,sr.abi11 CLIPPED,
#                   COLUMN g_c[32],g_x[22] CLIPPED,sr.abi12 CLIPPED,
#                   COLUMN g_c[33],g_x[23] CLIPPED,sr.abi13 CLIPPED,
#                   COLUMN g_c[34],g_x[24] CLIPPED,sr.abi14 CLIPPED;
#       OTHERWISE LET l_str = sr.abi10
#       OTHERWISE PRINT COLUMN g_c[35],sr.abi10 CLIPPED;
#     END CASE
#
#NO.FUN-5C0015(E)-----Mark 改依參數azz88動態判斷異動碼應show的組數-------
#NO.FUN-5C0015(S)-----Add -----
#    IF NOT cl_null(sr.abi11) THEN
#       PRINT COLUMN g_c[31],g_x[21] CLIPPED,sr.abi11 CLIPPED;
#    END IF
#    IF NOT cl_null(sr.abi12) THEN
#       PRINT COLUMN g_c[32],g_x[22] CLIPPED,sr.abi12 CLIPPED;
#    END IF
#    IF NOT cl_null(sr.abi13) THEN
#       PRINT COLUMN g_c[33],g_x[23] CLIPPED,sr.abi13 CLIPPED;
#    END IF
#    IF NOT cl_null(sr.abi14) THEN
#       PRINT COLUMN g_c[34],g_x[24] CLIPPED,sr.abi14 CLIPPED;
#    END IF
#    IF NOT cl_null(sr.abi31) THEN
#       PRINT COLUMN g_c[41],g_x[25] CLIPPED,sr.abi31 CLIPPED;
#    END IF
#    IF NOT cl_null(sr.abi32) THEN
#       PRINT COLUMN g_c[42],g_x[26] CLIPPED,sr.abi32 CLIPPED;
#    END IF
#    IF NOT cl_null(sr.abi33) THEN
#       PRINT COLUMN g_c[43],g_x[27] CLIPPED,sr.abi33 CLIPPED;
#    END IF
#    IF NOT cl_null(sr.abi34) THEN
#       PRINT COLUMN g_c[44],g_x[28] CLIPPED,sr.abi34 CLIPPED;
#    END IF
#    IF NOT cl_null(sr.abi35) THEN
#       PRINT COLUMN g_c[45],g_x[29] CLIPPED,sr.abi35 CLIPPED;
#    END IF
#    IF NOT cl_null(sr.abi36) THEN
#       PRINT COLUMN g_c[46],g_x[30] CLIPPED,sr.abi36 CLIPPED;
#    END IF
#    PRINT COLUMN g_c[35],sr.abi10 CLIPPED;
#NO.FUN-5C0015(E)-----Add ------
#     PRINT l_str,
#          COLUMN  90,sr.abi07,
#          COLUMN  97,cl_numfor(sr.abi08,18,g_azi04),
#          COLUMN 117,sr.abi01,
#          COLUMN 130,sr.abi06
#     #-----MOD-680084---------
#     LET l_chr = ''
#     FOREACH abc_cur USING sr.abi01,sr.abi02 INTO l_abc03,l_abc04
#        LET l_chr = l_chr CLIPPED,l_abc04 CLIPPED
#     END FOREACH
#     PRINT COLUMN g_c[36],l_chr CLIPPED;
#     #-----END MOD-680084-----
#     PRINT
#          COLUMN g_c[37],sr.abi07 CLIPPED,
#          COLUMN g_c[38],cl_numfor(sr.abi08,38,g_azi04) CLIPPED,
#          COLUMN g_c[39],sr.abi01 CLIPPED,
#          COLUMN g_c[40],sr.abi06 CLIPPED
#No.FUN-580010--end
#     #-----MOD-680084---------
#     #--->列印額外摘要
#     #LET l_no2 = 0
#     #LET l_sw = 'N'
#     #FOREACH abc_cur USING sr.abi01,sr.abi02 INTO l_abc03,l_abc04
#     #   IF l_no = 1 AND l_sw ='N' THEN LET l_sw = 'Y' CONTINUE FOREACH END IF
#     #   LET l_no2 = l_no2 + 1
#     #   CASE
#No.FUN-580010--start
#     #    WHEN l_no2 = 1  PRINT column  1,l_abc04 CLIPPED;
#     #    WHEN l_no2 = 2  PRINT column 32,l_abc04 CLIPPED;
#     #    WHEN l_no2 = 3  PRINT column 63,l_abc04
#No.FUN-580010--end
#     #                     LET l_no2 = 0
#     #     OTHERWISE  EXIT CASE
#     #   END CASE
#     #END FOREACH
#     #IF l_no2 = 1 OR l_no2 = 2 THEN PRINT END IF
#     #-----END MOD-680084-----
 
#ruby
#  after group of sr.abi11
#No.FUN-580010--start
#     PRINT g_dash2[1,g_len]
#     PRINT COLUMN 17,g_x[17] CLIPPED,
#           COLUMN 97,cl_numfor(GROUP SUM(sr.abi08),18,g_azi05)
#     PRINTX name=S1
#           g_x[17] CLIPPED,
#           COLUMN g_c[38],cl_numfor(GROUP SUM(sr.abi08),38,g_azi05)
#     skip 1 line
#No.FUN-580010--end
 
#  AFTER GROUP OF sr.abi05
#No.FUN-580010--start
#     PRINT g_dash2[1,g_len]
#     PRINT COLUMN 17,g_x[17] CLIPPED,
#ruby
#     PRINT COLUMN 17,g_x[18] CLIPPED,
#           COLUMN 97,cl_numfor(GROUP SUM(sr.abi08),18,g_azi05)
#     PRINTX name=S1 g_x[18] CLIPPED,
#           COLUMN g_c[38],cl_numfor(GROUP SUM(sr.abi08),38,6)
#No.FUN-580010--end
#     PRINT g_dash[1,g_len]
#
#  ON LAST ROW
#     LET l_last_sw = 'y'
 
#  PAGE TRAILER
#     PRINT g_dash[1,g_len]
#     IF l_last_sw = 'n'
#        THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#     END IF
#END REPORT
#No.FUN-830104 ----End---- 
 
#FUN-5C0015 BY kevin (s)
FUNCTION  r811_show_field()
#依參數決定異動碼的多寡
 
  IF g_aaz.aaz88 < 10 THEN
     LET g_zaa[46].zaa06 = "Y"
  END IF
 
  IF g_aaz.aaz88 < 9 THEN
     LET g_zaa[45].zaa06 = "Y"
  END IF
 
  IF g_aaz.aaz88 < 8 THEN
     LET g_zaa[44].zaa06 = "Y"
  END IF
 
  IF g_aaz.aaz88 < 7 THEN
     LET g_zaa[43].zaa06 = "Y"
  END IF
 
  IF g_aaz.aaz88 < 6 THEN
     LET g_zaa[42].zaa06 = "Y"
  END IF
 
  IF g_aaz.aaz88 < 5 THEN
     LET g_zaa[41].zaa06 = "Y"
  END IF
 
  IF g_aaz.aaz88 < 4 THEN
     LET g_zaa[34].zaa06 = "Y"
  END IF
 
  IF g_aaz.aaz88 < 3 THEN
     LET g_zaa[33].zaa06 = "Y"
  END IF
 
  IF g_aaz.aaz88 < 2 THEN
     LET g_zaa[32].zaa06 = "Y"
  END IF
 
  IF g_aaz.aaz88 < 1 THEN
     LET g_zaa[31].zaa06 = "Y"
  END IF
 
 
END FUNCTION
 
#FUN-5C0015 BY kevin (e)
 
#Patch....NO.TQC-610035 <> #
