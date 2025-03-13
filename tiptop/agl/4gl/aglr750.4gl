# Prog. Version..: '5.30.06-13.04.16(00010)'     #
#
# Pattern name...: aglr750.4gl
# Descriptions...: 部門科目日記帳
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬aag02
# Modify.........: No.FUN-510007 05/02/18 By Smapmin 報表轉XML格式
# Modify.........: No.MOD-580211 05/09/07 By ice 小數位數根據azi檔的設置來取位
# Modify.........: No.FUN-5C0015 06/01/03 By miki
#                  將表頭說明組在單身，加上abb31~abb36(增加zaa18~23)，
#                  序號35放寬至60，報表寬度修改
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680098 06/09/01 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6C0012 06/12/27 By Judy 新增打印額外名稱功能
# Modify.........: No.FUN-740020 07/04/11 By Lynn 會計科目加帳套
# Modify.........: No.TQC-6C0098 07/04/22 By Sarah QBE加一選項"是否列印內部管理科目"(aag38)
# Modify.........: No.MOD-740244 07/04/22 By Sarah 重新過單
# Modify.........: No.TQC-810013 08/01/07 By Smapmin 增加zz05程式段
# Modify.........: NO.FUN-830094 08/03/25 By zhaijie 報表輸出改為CR
# Modify.........: NO.FUN-940013 09/04/21 By jan abb03 欄位增加開窗功能
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B20054 11/02/24 By lixiang 先錄入帳套,科目根據帳套過濾;結構改為DIALOG 
# Modify.........: No.FUN-B80057 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No.MOD-C40068 12/04/10 By Polly 取消 DISTINCT 語法
# Modify.........: No.MOD-C90163 12/09/21 By Polly 調整執行背景作業所傳遞的參數順序和個數
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                               # Print condition RECORD
              wc       LIKE type_file.chr1000,     #Where Condiction     #No.FUN-680098  VARCHAR(300)
              bookno   LIKE aag_file.aag00,        #No.FUN-740020
              b_date   LIKE type_file.dat,         #No.FUN-680098    date
              e_date   LIKE type_file.dat,         #No.FUN-680098    date
              a        LIKE type_file.chr1,        #FUN-6C0012
              aag38    LIKE aag_file.aag38,        #TQC-6C0098 add
              more     LIKE type_file.chr1         #是否輸入其它特殊列印條件   #No.FUN-680098  VARCHAR(1)
              END RECORD
#          g_bookno  LIKE aba_file.aba00             #帳別編號    #No.FUN-740020
 
DEFINE   g_aaa03         LIKE aaa_file.aaa03
DEFINE   g_cnt           LIKE type_file.num10       #No.FUN-680098 integer
DEFINE   g_i             LIKE type_file.num5        #count/index for any purpose   #No.FUN-680098 smallint
#NO.FUN-830094------START---
DEFINE   g_sql           STRING
DEFINE   g_str           STRING
DEFINE   l_table         STRING
DEFINE   l_table1        STRING   
#NO.FUN-830094-----END----
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                              # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114 #FUN-BB0047 mark
#NO.FUN-830094------START---
   LET g_sql = "abb05.abb_file.abb05,",
               "gem03.gem_file.gem03,",
               "aba00.aba_file.aba00,",
               "abb02.abb_file.abb02,",
               "abb03.abb_file.abb03,",
               "abb11.abb_file.abb11,",
               "abb12.abb_file.abb12,",
               "abb13.abb_file.abb13,",
               "abb14.abb_file.abb14,",
               "abb31.abb_file.abb31,",
               "abb32.abb_file.abb32,",
               "abb33.abb_file.abb33,",
               "abb34.abb_file.abb34,",
               "abb35.abb_file.abb35,",
               "abb36.abb_file.abb36,",
               "aag02.aag_file.aag02,",
               "aag13.aag_file.aag13,",
               "aba02.aba_file.aba02,",
               "aba01.aba_file.aba01,",
               "abb04.abb_file.abb04,",
               "abb06.abb_file.abb06,",
               "abb07.abb_file.abb07,",
               "l_n.type_file.num5,",
               "l_abc04.abc_file.abc04,",
               "t_azi04.azi_file.azi04"
   LET l_table = cl_prt_temptable('aglr750',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "aba00.aba_file.aba00,",
               "aba01.aba_file.aba01,",
               "abb02.abb_file.abb02,",
               "abb04.abb_file.abb04,",
               "abb06.abb_file.abb06,",
               "abb07.abb_file.abb07,",
               "abb14.abb_file.abb14,",
               "l_abc04.abc_file.abc04,",
               "l_no.type_file.num5,",
               "l_no2.type_file.num5,",
               "g_cnt.type_file.num10"
   LET l_table1 = cl_prt_temptable('aglr7501',g_sql) CLIPPED
   IF  l_table1 = -1 THEN EXIT PROGRAM END IF 
#NO.FUN-830094-----END----
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET tm.bookno =ARG_VAL(1)    #No.FUN-740020
   LET g_pdate  = ARG_VAL(2)             # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc    = ARG_VAL(8)
   LET tm.b_date = ARG_VAL(9)   #TQC-610056
   LET tm.e_date = ARG_VAL(10)  #TQC-610056
   LET tm.aag38 = ARG_VAL(11)   #MOD-C90163 add
   LET tm.a     = ARG_VAL(12)   #MOD-C90163 add
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13) #MOD-C90163 mod 13
   LET g_rep_clas = ARG_VAL(14) #MOD-C90163 mod 14
   LET g_template = ARG_VAL(15) #MOD-C90163 mod 15
   #No.FUN-570264 ---end---
  #LET tm.a     = ARG_VAL(14)    #FUN-6C0012 #MOD-C90163 mark
  #LET tm.aag38 = ARG_VAL(15)    #TQC-6C0098 add #MOD-C90163 mark
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
 
#No.FUN-740020  --begin   
   IF tm.bookno = ' ' OR tm.bookno IS NULL THEN
      LET tm.bookno = g_aza.aza81         #帳別若為空白則使用預設帳別
   END IF
#No.FUN-740020  --end
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.bookno     #No.FUN-740020
   IF SQLCA.sqlcode THEN LET g_aaa03 = g_aza.aza17 END IF     #使用本國幣別
   SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file WHERE azi01 = g_aaa03          #No.CHI-6A0004 g_azi-->t_azi
   IF SQLCA.sqlcode THEN
#    CALL cl_err(g_aaa03,SQLCA.sqlcode,0)  # NO.FUN-660123
     CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","",0)  # NO.FUN-660123
    END IF
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
        CALL aglr750_tm()                # Input print condition
   ELSE
        CALL aglr750()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION aglr750_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680098 SMALLINT
          l_cmd       LIKE type_file.chr1000,       #No.FUN-680098 VARCHAR(400) 
          l_jmp_flag  LIKE type_file.chr1            #No.FUN-680098 VARCHAR(1)
DEFINE li_chk_bookno  LIKE type_file.num5            #FUN-B20054 
   CALL s_dsmark(tm.bookno)
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 16
   ELSE LET p_row = 4 LET p_col = 14
   END IF
   OPEN WINDOW aglr750_w AT p_row,p_col
        WITH FORM "agl/42f/aglr750"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL s_shwact(0,0,tm.bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL   # Default conditio
   LET tm.bookno = g_aza.aza81   #FUN-B20054 
   LET tm.a    = 'N'  #FUN-6C0012
   LET tm.aag38= 'N'   #TQC-6C0098 add
   LET tm.more = 'N'
   LET tm.b_date = g_today
   LET tm.e_date = g_today
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET l_jmp_flag = 'N'
WHILE TRUE
  #FUN-B20054--add--str--
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
                   NEXT FIELD bookno
                END IF
            END IF
       END INPUT
     #FUN-B20054--add--end

   CONSTRUCT BY NAME tm.wc ON abb05,abb03,aba01
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---

#FUN-B20054--mark--str--
#         #FUN-940013--begin--add
#         ON ACTION controlp
#           CASE
#              WHEN INFIELD(abb03)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state    = "c"
#                   LET g_qryparam.form = "q_aag"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO abb03
#                   NEXT FIELD abb03
#              OTHERWISE EXIT CASE
#           END CASE
#          #FUN-940013--end--add--
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
#FUN-B20054--mark--end
 
  END CONSTRUCT

#FUN-B20054--mark--str--
#       IF g_action_choice = "locale" THEN
#          LET g_action_choice = ""
#          CALL cl_dynamic_locale()
#          CONTINUE WHILE
#       END IF
# 
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0 CLOSE WINDOW aglr750_w 
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#      EXIT PROGRAM
#         
#   END IF
#  IF tm.wc = ' 1=1' THEN CALL cl_err('','9016',0) CONTINUE WHILE END IF
#FUN-B20054--mark--end

 #  INPUT BY NAME tm.bookno,tm.b_date,tm.e_date,tm.a,tm.aag38,tm.more    #FUN-6C0012   #No.FUN-740020   #TQC-6C0098 add tm.aag38
            #                 WITHOUT DEFAULTS   #FUN-B20054
    INPUT BY NAME tm.b_date,tm.e_date,tm.a,tm.aag38,tm.more
                 ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20054
            
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---

  #FUN-B20054--mark--str--
  #       #No.FUN-740020 --begin                                                                                                     
  #       AFTER FIELD bookno                                                                                                         
  #          IF cl_null(tm.bookno) THEN                                                                                              
  #             NEXT FIELD bookno                                                                                                    
  #          END IF                                                                                                                  
  #       #No.FUN-740020 --end
  #FUN-B20054--mark--end
  
 # AFTER FIELD b_date
 #    IF cl_null(tm.b_date) THEN NEXT FIELD b_date END IF
 # AFTER FIELD edate
 #    IF cl_null(tm.e_date) THEN NEXT FIELD e_date END IF
 #    IF tm.e_date < tm.b_date THEN NEXT FIELD b_date END IF
   #str TQC-6C0098 add
   AFTER FIELD aag38
      IF tm.aag38 NOT MATCHES "[YN]" THEN
         NEXT FIELD aag38
      END IF
   #end TQC-6C0098 add
   AFTER FIELD more
      IF tm.more NOT MATCHES "[YN]" THEN
         NEXT FIELD more
      END IF
      IF tm.more = 'Y' THEN
         CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies)
                  RETURNING g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies
      END IF
 #FUN-B20054--add--str--
   AFTER INPUT
      LET l_jmp_flag = 'N'
 #FUN-B20054--add--end

#FUN-B20054--mark--str-- 
#    ################################################################################
#    # START genero shell script ADD
#       ON ACTION CONTROLR
#          CALL cl_show_req_fields()
#    # END genero shell script ADD
#    ################################################################################
#       ON ACTION CONTROLG CALL cl_cmdask()   # Command execution
#     #  ON ACTION CONTROLP CALL aglr750_wc    # Input detail where condiction
# 
#   AFTER INPUT
#      LET l_jmp_flag = 'N'
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
# 
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
#FUN-B20054--mark--end
 
   END INPUT

   #FUN-B20054--add--str--
     #FUN-940013--begin--add
         ON ACTION controlp
           CASE
              WHEN INFIELD(bookno)                                                                                                    
                 CALL cl_init_qry_var()                                                                                                
                 LET g_qryparam.form = 'q_aaa'                                                                                         
                 LET g_qryparam.default1 = tm.bookno                                                                                      
                 CALL cl_create_qry() RETURNING tm.bookno                                                                                 
                 DISPLAY BY NAME tm.bookno                                                                                                
                 NEXT FIELD bookno
              WHEN INFIELD(abb03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state    = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = " aag00 = '",tm.bookno CLIPPED,"'"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO abb03
                 NEXT FIELD abb03
              OTHERWISE EXIT CASE
           END CASE
          #FUN-940013--end--add--
      ON ACTION locale
        #CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT DIALOG
         
      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      #No.FUN-580031 ---end---

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
    IF INT_FLAG THEN
       LET INT_FLAG = 0 CLOSE WINDOW aglr750_w 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
       EXIT PROGRAM       
    END IF

   IF tm.wc = ' 1=1' THEN CALL cl_err('','9016',0) CONTINUE WHILE END IF  #FUN-B20054
 #FUN-B20054--add--end
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
             WHERE zz01='aglr750'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aglr750','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
                         " '",tm.bookno CLIPPED,"'" ,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.b_date CLIPPED,"'",   #TQC-610056
                         " '",tm.e_date CLIPPED,"'",   #TQC-610056
                         " '",tm.aag38 CLIPPED,"'",             #TQC-6C0098 add
                         " '",tm.a CLIPPED,"'",                 #MOD-C90163 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aglr750',g_time,l_cmd)  # Execute cmd at later time
      END IF
      CLOSE WINDOW aglr750_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aglr750()
   ERROR ""
END WHILE
   CLOSE WINDOW aglr750_w
END FUNCTION
 
FUNCTION aglr750()
   DEFINE l_name        LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680098 VARCHAR(20)
#       l_time          LIKE type_file.chr8            #No.FUN-6A0073
          l_sql         LIKE type_file.chr1000,       # RDSQL STATEMENT                 #No.FUN-680098 VARCHAR(1000)
          l_chr         LIKE type_file.chr1,          #No.FUN-680098   VARCHAR(1)
          l_za05        LIKE za_file.za05,            #標題內容        #No.FUN-680098   VARCHAR(40)
          l_order       ARRAY[5] OF LIKE cre_file.cre08,   #排列順序   #No.FUN-680098   VARCHAR(10)
          l_i           LIKE type_file.num5,              #No.FUN-680098   smallint   #MOD-740244
          sr               RECORD
                           abb05     LIKE abb_file.abb05,#部門         #No.FUN-680098  VARCHAR(6)
                           gem03     LIKE gem_file.gem03,#部門名稱
                           aba00     LIKE aba_file.aba00,#帳別
                           abb02     LIKE abb_file.abb02,#項次
                           abb03     LIKE abb_file.abb03,#科目
                           abb11     LIKE abb_file.abb11,#異動碼1
                           abb12     LIKE abb_file.abb12,#異動碼2
                           abb13     LIKE abb_file.abb13,#異動碼3
                           abb14     LIKE abb_file.abb14,#異動碼4
                           abb31     LIKE abb_file.abb31,#異動5 #FUN-5C0015-(S)
                           abb32     LIKE abb_file.abb32,#異動6
                           abb33     LIKE abb_file.abb33,#異動7
                           abb34     LIKE abb_file.abb34,#異動8
                           abb35     LIKE abb_file.abb35,#異動9
                           abb36     LIKE abb_file.abb36,#異動10#FUN-5C0015-(E)
                           aag02     LIKE aag_file.aag02,#科目名稱
                           aag13     LIKE aag_file.aag13,#額外名稱 #FUN-6C0012
                           aba02     LIKE aba_file.aba02,#傳票日期
                           aba01     LIKE aba_file.aba01,#傳票編號
                           abb04     LIKE abb_file.abb04,#摘要
                           abb06     LIKE abb_file.abb06,#借貸別
                           abb07     LIKE abb_file.abb07 #異動金額
                        END RECORD
#NO.FUN-830094------START---
DEFINE        l_no         LIKE type_file.num5
DEFINE        l_no2        LIKE type_file.num5
DEFINE        l_abc04      LIKE abc_file.abc04
DEFINE        l_str        LIKE type_file.chr1000
 
   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?)"                                                                                  
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80057--add--
      EXIT PROGRAM                                                                             
   END IF 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80057--add-- 
      EXIT PROGRAM
   END IF
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aglr750'
#NO.FUN-830094------END-----
    #SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
         SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = tm.bookno      #No.FUN-740020
                        AND aaf02 = g_rlang
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND abauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND abagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND abagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('abauser', 'abagrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT abb05,gem03, abb00,abb02,abb03,abb11,abb12,abb13,",
                #->FUN-5C0015-----------------------------------------------(S)
                #"       abb14,aag02, aba02,aba01,abb04, abb06, abb07",
                 "       abb14,abb31,abb32,abb33,abb34,abb35,abb36,",
                 "       aag02, aag13,aba02,aba01,abb04, abb06, abb07",   #FUN-6C0012
                #->FUN-5C0015-----------------------------------------------(E)
                 " FROM aba_file, abb_file LEFT OUTER JOIN aag_file ON abb03 = aag_file.aag01 AND aag_file.aag03='2' LEFT OUTER JOIN gem_file ON abb05 = gem_file.gem01",
                 " WHERE aba00 = '",tm.bookno,"'", #若為空白使用預設帳別   #No.FUN-740020
                 "   AND ",tm.wc clipped,
                 "   AND aba00 = abb00",
                 "   AND aba00 = aag00",
                 "   AND aba01 = abb01",
 
 
                 "   AND abapost = 'Y'",
                 "   AND abaacti = 'Y'",
                 "   AND aba02 BETWEEN '",tm.b_date,"' AND '",tm.e_date,"'"
     LET l_sql = l_sql CLIPPED," AND aag_file.aag38 = '",tm.aag38,"'"   #TQC-6C0098 add
 
     PREPARE aglr750_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM END IF
     DECLARE aglr750_curs1 CURSOR FOR aglr750_prepare1
 
     LET l_sql="SELECT abc04 FROM abc_file ",
               " WHERE abc00=? AND abc01=? AND abc02=? "
 
     PREPARE aglr750_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare2:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM END IF
     DECLARE aglr750_curs2 CURSOR FOR aglr750_prepare2
 
#     CALL cl_outnam('aglr750') RETURNING l_name        #NO.FUN-830094
#NO.FUN-830094----START-----
     #FUN-6C0012.....begin
     IF tm.a = 'N' THEN
      #  LET g_zaa[34].zaa06 = 'N'                                               
      #  LET g_zaa[40].zaa06 = 'Y'                                               
        LET l_name = 'aglr750_1' 
      ELSE                                                                       
      #  LET g_zaa[34].zaa06 = 'Y'                                               
      #  LET g_zaa[40].zaa06 = 'N'                                               
        LET l_name = 'aglr750' 
     END IF 
#NO.FUN-830094----END-----
#     CALL cl_prt_pos_len()                      #NO.FUN-830094
    #No.FUN-6C0012  --end                                                      
                          
#     START REPORT aglr750_rep TO l_name         #NO.FUN-830094
 
#     LET g_pageno = 0                           #NO.FUN-830094
     LET g_cnt    = 1
     FOREACH aglr750_curs1 INTO sr.*
       IF STATUS != 0 THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       IF sr.abb05 IS NULL THEN LET sr.abb05=' ' END IF
#       OUTPUT TO REPORT aglr750_rep(sr.*)       #NO.FUN-830094
#NO.FUN-830094-----START---
      LET l_no=0
      IF NOT cl_null(sr.abb11) THEN LET l_no=l_no+1 END IF
      IF NOT cl_null(sr.abb12) THEN LET l_no=l_no+1 END IF
      IF NOT cl_null(sr.abb13) THEN LET l_no=l_no+1 END IF
      IF NOT cl_null(sr.abb14) THEN LET l_no=l_no+1 END IF
      IF NOT cl_null(sr.abb31) THEN LET l_no=l_no+1 END IF
      IF NOT cl_null(sr.abb32) THEN LET l_no=l_no+1 END IF
      IF NOT cl_null(sr.abb33) THEN LET l_no=l_no+1 END IF
      IF NOT cl_null(sr.abb34) THEN LET l_no=l_no+1 END IF
      IF NOT cl_null(sr.abb35) THEN LET l_no=l_no+1 END IF
      IF NOT cl_null(sr.abb36) THEN LET l_no=l_no+1 END IF
      LET l_no2 = 0  LET g_cnt=0
      FOREACH aglr750_curs2 USING sr.aba00,sr.aba01,sr.abb02 INTO l_abc04
         IF g_cnt=0 THEN
            CASE
                 WHEN l_no=0
                      IF cl_null(sr.abb04) THEN  LET l_str=l_abc04 END IF
                 WHEN l_no=1
                      IF NOT cl_null(sr.abb04) THEN LET l_no2=1 END IF
                 WHEN l_no=2 OR l_no=3 
                      IF cl_null(sr.abb04) THEN LET l_no2=1 END IF
                 WHEN l_no=4
                      IF NOT cl_null(sr.abb04) THEN LET l_no2=1 END IF
                OTHERWISE EXIT CASE
            END CASE
            LET g_cnt=g_cnt+1
            CONTINUE FOREACH
         END IF
         IF g_cnt=1 AND l_no=0 AND cl_null(sr.abb04) THEN
            LET g_cnt=g_cnt+1
            CONTINUE FOREACH
         END IF
         LET l_no2 = l_no2 + 1
 
         EXECUTE insert_prep1 USING
             sr.aba00,sr.aba01,sr.abb02,sr.abb04,sr.abb06,sr.abb07,sr.abb14,
             l_abc04,l_no,l_no2,g_cnt
               
         IF l_no2 = 2 THEN LET l_no2 = 0 END IF 
         LET g_cnt=g_cnt+1
     END FOREACH
     
     EXECUTE insert_prep USING
        sr.abb05,sr.gem03,sr.aba00,sr.abb02,sr.abb03,sr.abb11,sr.abb12,
        sr.abb13,sr.abb14,sr.abb31,sr.abb32,sr.abb33,sr.abb34,sr.abb35,
        sr.abb36,sr.aag02,sr.aag13,sr.aba02,sr.aba01,sr.abb04,sr.abb06,
        sr.abb07,l_no,l_abc04,t_azi04 
#NO.FUN-830094-----END---   
     END FOREACH
 
#     FINISH REPORT aglr750_rep                   #NO.FUN-830094
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len) #NO.FUN-830094
#NO.FUN-830094----------START----------------------------------
    #LET g_sql = " SELECT DISTINCT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",      #MOD-C40068 mark
    #            " SELECT DISTINCT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED          #MOD-C40068 mark
     LET g_sql = " SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",               #MOD-C40068 add
                 " SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED                   #MOD-C40068 add
     IF g_zz05='Y' THEN
         CALL cl_wcchp(tm.wc,'abb05,abb03,aba01') RETURNING tm.wc
     ELSE 
         LET tm.wc = ""
     END IF
       
     LET g_str =tm.wc,";",tm.b_date,";",tm.e_date,";",tm.a
     CALL cl_prt_cs3('aglr750',l_name,g_sql,g_str)
#NO.FUN-830094----------END------------------------------- 
END FUNCTION
 
#NO.FUN-830094---------start------mark--- 
#REPORT aglr750_rep(sr)
#   DEFINE l_last_sw     LIKE type_file.chr1,      #No.FUN-680098  VARCHAR(1)
#          amt1,amt2     LIKE abb_file.abb07,
#          l_prt,l_no,l_no2       LIKE type_file.num5,       #No.FUN-680098  SMALLINT
#          l_str         LIKE type_file.chr1000,             #No.FUN-680098  VARCHAR(60)
#          l_abc04       LIKE abc_file.abc04,
#          l_gem03       LIKE gem_file.gem03,
#          g_head1       STRING,
#          l_str2        STRING,
#          sr               RECORD
#                           abb05     LIKE abb_file.abb05, #部門      #No.FUN-680098  VARCHAR(6)
#                           gem03     LIKE gem_file.gem03,#部門名稱
#                           aba00     LIKE aba_file.aba00,#帳別
#                           abb02     LIKE abb_file.abb02,#項次
#                           abb03     LIKE abb_file.abb03,#科目
#                           abb11     LIKE abb_file.abb11,#異動碼1
#                           abb12     LIKE abb_file.abb12,#異動碼2
#                           abb13     LIKE abb_file.abb13,#異動碼3
#                           abb14     LIKE abb_file.abb14,#異動碼4
#                           abb31     LIKE abb_file.abb31,#異動5 #FUN-5C0015-(S)
#                           abb32     LIKE abb_file.abb32,#異動6
#                           abb33     LIKE abb_file.abb33,#異動7
#                           abb34     LIKE abb_file.abb34,#異動8
#                           abb35     LIKE abb_file.abb35,#異動9
#                           abb36     LIKE abb_file.abb36,#異動10#FUN-5C0015-(E)
#                           aag02     LIKE aag_file.aag02,#科目名稱
#                           aag13     LIKE aag_file.aag13,#FUN-6C0012
#                           aba02     LIKE aba_file.aba02,#傳票日期
#                           aba01     LIKE aba_file.aba01,#傳票編號
#                           abb04     LIKE abb_file.abb04,#摘要
#                           abb06     LIKE abb_file.abb06,#借貸別
#                           abb07     LIKE abb_file.abb07 #異動金額
#                        END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
 
#  ORDER BY sr.abb05, sr.abb03, sr.aba02,sr.aba01,sr.abb02
#
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] CLIPPED
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED, pageno_total
#      LET g_head1 = g_x[9] CLIPPED,tm.b_date,'-',tm.e_date
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_head1))/2)+1,g_head1
#      PRINT g_dash[1,g_len]
#      PRINT g_x[17],':',sr.abb05, ' ', sr.gem03
#      PRINT
##     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39]          #FUN-6C0012
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[40],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39]  #FUN-6C0012
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.abb05
#    { let l_no=0
#      IF NOT cl_null(sr.abb11) THEN LET l_no=l_no+1 END IF
#      IF NOT cl_null(sr.abb12) THEN LET l_no=l_no+1 END IF
#      IF NOT cl_null(sr.abb13) THEN LET l_no=l_no+1 END IF
#      IF NOT cl_null(sr.abb14) THEN LET l_no=l_no+1 END IF }
#      SKIP TO TOP OF PAGE
#
#   ON EVERY ROW
#      let l_no=0
#      IF NOT cl_null(sr.abb11) THEN LET l_no=l_no+1 END IF
#      IF NOT cl_null(sr.abb12) THEN LET l_no=l_no+1 END IF
#      IF NOT cl_null(sr.abb13) THEN LET l_no=l_no+1 END IF
#      IF NOT cl_null(sr.abb14) THEN LET l_no=l_no+1 END IF
#     #->FUN-5C0015-----------------------------------------------(S)
#      IF NOT cl_null(sr.abb31) THEN LET l_no=l_no+1 END IF
#      IF NOT cl_null(sr.abb32) THEN LET l_no=l_no+1 END IF
#      IF NOT cl_null(sr.abb33) THEN LET l_no=l_no+1 END IF
#      IF NOT cl_null(sr.abb34) THEN LET l_no=l_no+1 END IF
#      IF NOT cl_null(sr.abb35) THEN LET l_no=l_no+1 END IF
#      IF NOT cl_null(sr.abb36) THEN LET l_no=l_no+1 END IF
#     #->FUN-5C0015-----------------------------------------------(E)
#      CASE
#          WHEN  l_no = 1    #1:異動1+abb04
#                LET l_str = g_x[13] CLIPPED,sr.abb11,' ',sr.abb04
#          WHEN  l_no = 2    #2:異動1+異動2
#                LET l_str = g_x[13] CLIPPED,sr.abb11,' ',
#                            g_x[14] CLIPPED,sr.abb12
#          WHEN  l_no = 3    #3:異動1+異動2+異動3
#                LET l_str = g_x[13] CLIPPED,sr.abb11,' ',
#                            g_x[14] CLIPPED,sr.abb12,' ',
#                            g_x[15] CLIPPED,sr.abb13
#          WHEN  l_no = 4    #4:異動1+異動2+異動3
#                LET l_str = g_x[13] CLIPPED,sr.abb11,' ',
#                            g_x[14] CLIPPED,sr.abb12,' ',
#                            g_x[15] CLIPPED,sr.abb13,' ',
#                            g_x[16] CLIPPED,sr.abb14     #FUN-5C0015
# 
#         #->FUN-5C0015-----------------------------------------------(S)
#          WHEN  l_no = 5    #5:異動1+異動2+異動3+異動4+異動5
#                LET l_str = g_x[13] CLIPPED,sr.abb11,' ',
#                            g_x[14] CLIPPED,sr.abb12,' ',
#                            g_x[15] CLIPPED,sr.abb13,' ',
#                            g_x[16] CLIPPED,sr.abb14,' ',
#                            g_x[18] CLIPPED,sr.abb31
#          WHEN  l_no = 6    #6:異動1+異動2+異動3+異動4+異動5+異動6
#                LET l_str = g_x[13] CLIPPED,sr.abb11,' ',
#                            g_x[14] CLIPPED,sr.abb12,' ',
#                            g_x[15] CLIPPED,sr.abb13,' ',
#                            g_x[16] CLIPPED,sr.abb14,' ',
#                            g_x[18] CLIPPED,sr.abb31,' ',
#                            g_x[19] CLIPPED,sr.abb32
#          WHEN  l_no = 7    #7:異動1+異動2+異動3+異動4+異動5+異動6+異動7
#                LET l_str = g_x[13] CLIPPED,sr.abb11,' ',
#                            g_x[14] CLIPPED,sr.abb12,' ',
#                            g_x[15] CLIPPED,sr.abb13,' ',
#                            g_x[16] CLIPPED,sr.abb14,' ',
#                            g_x[18] CLIPPED,sr.abb31,' ',
#                            g_x[19] CLIPPED,sr.abb32,' ',
#                            g_x[20] CLIPPED,sr.abb33
#          WHEN  l_no = 8    #8:異動1+異動2+異動3+異動4+異動5+異動6+異動7+異動8
#                LET l_str = g_x[13] CLIPPED,sr.abb11,' ',
#                            g_x[14] CLIPPED,sr.abb12,' ',
#                            g_x[15] CLIPPED,sr.abb13,' ',
#                            g_x[16] CLIPPED,sr.abb14,' ',
#                            g_x[18] CLIPPED,sr.abb31,' ',
#                            g_x[19] CLIPPED,sr.abb32,' ',
#                            g_x[20] CLIPPED,sr.abb33,' ',
#                            g_x[21] CLIPPED,sr.abb34
#          WHEN  l_no = 9    #9:異動1+異動2+異動3+異動4+異動5+異動6+異動7+異動8+異動9
#                LET l_str = g_x[13] CLIPPED,sr.abb11,' ',
#                            g_x[14] CLIPPED,sr.abb12,' ',
#                            g_x[15] CLIPPED,sr.abb13,' ',
#                            g_x[16] CLIPPED,sr.abb14,' ',
#                            g_x[18] CLIPPED,sr.abb31,' ',
#                            g_x[19] CLIPPED,sr.abb32,' ',
#                            g_x[20] CLIPPED,sr.abb33,' ',
#                            g_x[21] CLIPPED,sr.abb34,' ',
#                            g_x[22] CLIPPED,sr.abb35
#          WHEN  l_no = 10   #10:異動1+異動2+異動3+異動4+異動5+異動6+異動7+異動8+異動9+異動10
#                LET l_str = g_x[13] CLIPPED,sr.abb11,' ',
#                            g_x[14] CLIPPED,sr.abb12,' ',
#                            g_x[15] CLIPPED,sr.abb13,' ',
#                            g_x[16] CLIPPED,sr.abb14,' ',
#                            g_x[18] CLIPPED,sr.abb31,' ',
#                            g_x[19] CLIPPED,sr.abb32,' ',
#                            g_x[20] CLIPPED,sr.abb33,' ',
#                            g_x[21] CLIPPED,sr.abb34,' ',
#                            g_x[22] CLIPPED,sr.abb35,' ',
#                            g_x[23] CLIPPED,sr.abb36
#         #->FUN-5C0015-----------------------------------------------(E)
#          OTHERWISE LET l_str = sr.abb04  #0:abb04
#       END CASE
#      LET l_prt=0
#      PRINT COLUMN g_c[31],sr.aba01,COLUMN g_c[32],sr.aba02,
#             COLUMN g_c[33],sr.abb03[1,6],COLUMN g_c[34],sr.aag02 CLIPPED; #MOD-4A0238
#      PRINT COLUMN g_c[40],sr.aag13;   #FUN-6C0012
#      IF (l_no=1 AND NOT cl_null(sr.abb04)) OR   #1:異動1+abb04
#          l_no=2 OR                              #2:異動1+異動2
#          l_no=3 OR                              #3:異動1+異動2+異動3
#         #->FUN-5C0015-----------------------------------------------(S)
#         #l_no=4 THEN                            #4:異動1+異動2+異動3
#          l_no=4 OR                              #4:異動1+異動2+異動3
#          l_no=5 OR    #5:異動1+異動2+異動3+異動4+異動5
#          l_no=6 OR    #6:異動1+異動2+異動3+異動4+異動5+異動6
#          l_no=7 OR    #7:異動1+異動2+異動3+異動4+異動5+異動6+異動7
#          l_no=8 OR    #8:異動1+異動2+異動3+異動4+異動5+異動6+異動7+異動8
#          l_no=9 OR    #9:異動1+異動2+異動3+異動4+異動5+異動6+異動7+異動8+異動9
#          l_no=10 THEN #10:異動1+異動2+異動3+異動4+異動5+異動6+異動7+異動8+異動9+異動10
#         #->FUN-5C0015-----------------------------------------------(E)
#          PRINT COLUMN g_c[35],l_str,
#                COLUMN g_c[38],cl_numfor(sr.abb07,18,t_azi04);   #TQC-5B0045  #No.CHI-6A0004 g_azi-->t_azi 
#                COLUMN g_c[38],cl_numfor(sr.abb07,23,t_azi04);   #TQC-5B0045    #No.CHI-6A0004 g_azi-->t_azi 
#          IF sr.abb06='1' THEN
#             PRINT COLUMN g_c[39],'DB'
#          ELSE
#             PRINT COLUMN g_c[39],'CR'
#          END IF
#      END IF
#     #--->列印額外摘要
#      LET l_no2 = 0  LET g_cnt=0
#      FOREACH aglr750_curs2 USING sr.aba00,sr.aba01,sr.abb02 INTO l_abc04
#         IF g_cnt=0 THEN        #處理摘要,金額的情形
#            CASE
#                 WHEN l_no=0
#                      IF cl_null(sr.abb04) THEN  LET l_str=l_abc04
#                      ELSE
#                         PRINT COLUMN g_c[35],l_str CLIPPED,COLUMN g_c[36],l_abc04,
#                               COLUMN g_c[38],cl_numfor(sr.abb07,18,t_azi04);   #TQC-5B0045  #No.CHI-6A0004 g_azi-->t_azi 
#                               COLUMN g_c[38],cl_numfor(sr.abb07,23,t_azi04);   #TQC-5B0045  #No.CHI-6A0004 g_azi-->t_azi 
#                         IF sr.abb06='1' THEN
#                            PRINT COLUMN g_c[39],'DB'
#                         ELSE
#                            PRINT COLUMN g_c[39],'CR'
#                         END IF
#                      END IF
#                 WHEN l_no=1
#                      IF cl_null(sr.abb04) THEN
#                         PRINT COLUMN g_c[35],l_str CLIPPED,COLUMN g_c[36],l_abc04,
#                               COLUMN g_c[38],cl_numfor(sr.abb07,18,t_azi04);   #TQC-5B0045  #No.CHI-6A0004 g_azi-->t_azi 
#                               COLUMN g_c[38],cl_numfor(sr.abb07,23,t_azi04);   #TQC-5B0045 #No.CHI-6A0004 g_azi-->t_azi 
#                         IF sr.abb06='1' THEN
#                            PRINT COLUMN g_c[39],'DB'
#                         ELSE
#                            PRINT COLUMN g_c[39],'CR'
#                         END IF
#                      ELSE
#                         PRINT COLUMN g_c[35],l_abc04;
#                         LET l_no2=1
#                      END IF
#                 WHEN l_no=2 OR l_no=3
#                      IF NOT cl_null(sr.abb04) THEN
#                         PRINT COLUMN g_c[35],sr.abb04,COLUMN g_c[36],l_abc04
#                      ELSE
#                         PRINT COLUMN g_c[35],l_abc04;
#                         LET l_no2=1
#                      END IF
#                 WHEN l_no=4
#                      PRINT COLUMN 52,sr.abb14;
#                      IF NOT cl_null(sr.abb04) THEN
#                         PRINT COLUMN g_c[36],sr.abb04
#                         PRINT COLUMN g_c[35],l_abc04;
#                         LET l_no2=1
#                      ELSE
#                         PRINT COLUMN g_c[36],l_abc04
#                      END IF
#                OTHERWISE EXIT CASE
#            END CASE
#            LET g_cnt=g_cnt+1
#            CONTINUE FOREACH
#         END IF
#         IF g_cnt=1 AND l_no=0 AND cl_null(sr.abb04) THEN
#            PRINT COLUMN g_c[35],l_str CLIPPED,COLUMN g_c[36],l_abc04,
#            COLUMN g_c[38],cl_numfor(sr.abb07,18,t_azi04),' ';   #TQC-5B0045   #No.CHI-6A0004 g_azi-->t_azi 
#            COLUMN g_c[38],cl_numfor(sr.abb07,23,t_azi04),' ';   #TQC-5B0045   #No.CHI-6A0004 g_azi-->t_azi 
#            IF sr.abb06='1' THEN
#               PRINT COLUMN g_c[39],'DB'
#            ELSE
#               PRINT COLUMN g_c[39],'CR'
#            END IF
#            LET g_cnt=g_cnt+1
#            CONTINUE FOREACH
#         END IF
#         LET l_no2 = l_no2 + 1
#         CASE
#             WHEN l_no2 = 1  PRINT column g_c[35],l_abc04;
#             WHEN l_no2 = 2  PRINT column g_c[36],l_abc04
#                             LET l_no2 = 0
#             OTHERWISE  EXIT CASE
#         END CASE
#         LET g_cnt=g_cnt+1
#     END FOREACH
#     IF g_cnt=0 THEN    #無額外摘要abc04時
#         CASE
#           WHEN l_no=0  #
#                PRINT COLUMN g_c[35],l_str CLIPPED,
#                      COLUMN g_c[38],cl_numfor(sr.abb07,18,t_azi04),' ';   #TQC-5B0045  #No.CHI-6A0004 g_azi-->t_azi 
#                      COLUMN g_c[38],cl_numfor(sr.abb07,23,t_azi04),' ';   #TQC-5B0045   #No.CHI-6A0004 g_azi-->t_azi 
#                IF sr.abb06='1' THEN
#                   PRINT COLUMN g_c[39],'DB'
#                ELSE
#                   PRINT COLUMN g_c[39],'CR'
#                END IF
#                LET l_no2=2
#           WHEN l_no=1
#                IF cl_null(sr.abb04) THEN
#                   PRINT COLUMN g_c[35],l_str CLIPPED,
#                         COLUMN g_c[38],cl_numfor(sr.abb07,18,t_azi04),' ';   #TQC-5B0045   #No.CHI-6A0004 g_azi-->t_azi 
#                         COLUMN g_c[38],cl_numfor(sr.abb07,23,t_azi04),' ';   #TQC-5B0045  #No.CHI-6A0004 g_azi-->t_azi 
#                   IF sr.abb06='1' THEN
#                      PRINT COLUMN g_c[39],'DB'
#                   ELSE
#                      PRINT COLUMN g_c[39],'CR'
#                   END IF
#                   LET l_no2=2
#                END IF
#           WHEN l_no=2 OR l_no=3
#                IF NOT cl_null(sr.abb04) THEN
#                   PRINT COLUMN g_c[35],sr.abb04
#                   LET l_no2=2
#                END IF
#           WHEN l_no=4
#                PRINT COLUMN g_c[35],g_x[21] CLIPPED,
#                      #MOD-580211 --start--
#                      COLUMN g_c[36],cl_numfor(sr.abb14,18,t_azi04),          #No.CHI-6A0004 g_azi-->t_azi 
#                      COLUMN g_c[37],sr.abb04
#                      #MOD-580211 --end--
#                LET l_no2=2
#           OTHERWISE EXIT CASE
#         END CASE
#     END IF
#     IF l_no2!=2 AND g_cnt>1 THEN PRINT END IF
#
#   AFTER GROUP OF sr.abb03
#      LET amt1=GROUP SUM(sr.abb07) WHERE sr.abb06='1'
#      LET amt2=GROUP SUM(sr.abb07) WHERE sr.abb06='2'
#      IF amt1 IS NULL THEN LET amt1=0 END IF
#      IF amt2 IS NULL THEN LET amt2=0 END IF
#      PRINT COLUMN g_c[36],g_dash2[1,g_w[36]],
#            COLUMN g_c[37],g_dash2[1,g_w[37]],
#            COLUMN g_c[38],g_dash2[1,g_w[38]],
#            COLUMN g_c[39],g_dash2[1,g_w[39]]
#      LET l_str2 = 'DB','       ',cl_numfor(amt1,18,t_azi04)       #No.CHI-6A0004 g_azi-->t_azi 
#      PRINT COLUMN g_c[36],l_str2;
#      LET l_str2 = 'CR','       ',cl_numfor(amt2,18,t_azi04)   #No.CHI-6A0004 g_azi-->t_azi 
#      PRINT COLUMN g_c[37],l_str2;
#      LET l_str2 = 'BAL=',' ',cl_numfor((amt1-amt2),18,t_azi04)  #No.CHI-6A0004 g_azi-->t_azi 
#      PRINT COLUMN g_c[38],l_str2
#      PRINT
#
#   AFTER GROUP OF sr.abb05
#      PRINT g_dash[1,g_len]
#      LET amt1=GROUP SUM(sr.abb07) WHERE sr.abb06='1'
#      LET amt2=GROUP SUM(sr.abb07) WHERE sr.abb06='2'
#      IF amt1 IS NULL THEN LET amt1=0 END IF
#      IF amt2 IS NULL THEN LET amt2=0 END IF
#      LET l_str2 = g_x[11],cl_numfor(amt1,18,t_azi04)   #No.CHI-6A0004 g_azi-->t_azi 
#      PRINT COLUMN g_c[36],l_str2;
#      LET l_str2 = g_x[12],cl_numfor(amt2,18,t_azi04)    #No.CHI-6A0004 g_azi-->t_azi 
#      PRINT COLUMN g_c[37],l_str2;
#      LET l_str2 = g_x[10],cl_numfor((amt1-amt2),18,t_azi04)   #No.CHI-6A0004 g_azi-->t_azi 
#      PRINT COLUMN g_c[38],l_str2
#
#   ON LAST ROW
#      #-----TQC-810013---------
#      IF g_zz05='Y' THEN 
#         CALL cl_wcchp(tm.wc,'abb05,abb03,aba01')                                                             
#              RETURNING tm.wc                                                                                                        
#         PRINT  g_dash[1,g_len]                                                                                                 
#         CALL cl_prt_pos_wc(tm.wc)                                                                                               
#      END IF                                                                                                                  
#      PRINT  g_dash[1,g_len]                                                      #NO.FUN-6C0028 
#      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED       #NO.FUN-6C0028   
      #-----END TQC-810013-----
#      LET l_last_sw = 'y'
 
#   PAGE TRAILER
      #-----TQC-810013---------
      #PRINT g_dash[1,g_len]
      #IF l_last_sw = 'n'
      #   THEN PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      #   ELSE PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      #END IF
#      IF l_last_sw = 'n' THEN
#         PRINT  g_dash[1,g_len]                                                   #NO.FUN-6C0028
#         PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE
#         SKIP 2 LINE                                                              #NO.FUN-6C0028     
#      END IF
      #-----END TQC-810013-----
#END REPORT
#NO.FUN-830094-----END----MARK----
#Patch....NO.TQC-610035 <001> #
