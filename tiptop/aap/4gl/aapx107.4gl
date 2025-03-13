# Prog. Version..: '5.30.07-13.05.30(00004)'     #
#
# Pattern name...: aapx107.4gl
# Descriptions...: 驗收與發票價差明細表列印
# Input parameter:
# Return code....:
# Date & Author..: 92/12/30 By yen
# Modify.........: No.FUN-4C0097 04/12/23 By Nicola 報表架構修改
#                                                   增加列印員工姓名gen02、部門名稱gem02、品名apb27、規格ima021
# Modify.........: No.FUN-550030 05/05/18 By ice 單據編號欄位放大
# Modify.........: No.FUN-560011 05/06/03 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.TQC-630235 06/03/24 By Smapmin 拿掉CONTROLP
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/30 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.TQC-6A0088 06/11/08 By baogui結束位置調整
# Modify.........: No.FUN-750129 07/05/29 By Carrier 報表轉Crystal Report格式
# Modify.........: No.TQC-760041 07/08/13 By Smapmin 增加開窗功能
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A10098 10/01/19 By chenls 修改跨DB寫法 
# Modify.........: No.FUN-A60056 10/06/22 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/15 By fengrui  調整時間函數問題
# Modify.........: No.FUN-CA0132 12/11/05 By minpp CR轉XtraGrid
# Modify.........: No.FUN-D30053 13/03/18 By yangtt XtraGrid修改                
# Modify.........: No.FUN-D30070 13/03/21 By yangtt 去除畫面檔上小計欄位，并去除4gl中grup_sum_field
# Modify.........: No.FUN-D40129 13/05/20 By yangtt apb21a、 apb06a的欄位長度改為varchar(31)
#                                                   添加小數取位欄位

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                   # Print condition RECORD
              #wc      LIKE type_file.chr1000,      # Where condition   #TQC-630166  #No.FUN-690028 VARCHAR(600)
              wc       STRING,       # Where condition   #TQC-630166
              s        LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(3),         # Order by sequence
              t        LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(3),        # Eject sw
             #u        LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(3),        # Group total sw  #FUN-D30070 mark
              more     LIKE type_file.chr1         # No.FUN-690028 VARCHAR(1)          # Input more condition(Y/N)
              END RECORD,
#         l_orderA      ARRAY[4] OF VARCHAR(08)  #排序名稱
          l_orderA      ARRAY[4] OF LIKE zaa_file.zaa08      # No.FUN-690028 VARCHAR(16)  #排序名稱
                                              #No.FUN-550030
#     DEFINEl_time LIKE type_file.chr8         #No.FUN-6A0055
 
DEFINE l_table   STRING  #No.FUN-750129
DEFINE g_str     STRING  #No.FUN-750129
DEFINE g_sql     STRING  #No.FUN-750129
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055  #FUN-BB0047  mark
   #No.FUN-750129  --Begin
   LET g_sql = " apa01.apa_file.apa01,",   #帳款編號
               " apa05.apa_file.apa05,",   #送貨廠商編號
               " apa13.apa_file.apa13,",   #幣別
               " apa02.apa_file.apa02,",   #帳款日期
               " apa06.apa_file.apa06,",   #付款廠商
               " apa21.apa_file.apa21,",   #帳款人員
               " apa22.apa_file.apa22,",   #帳款部門
               " apa36.apa_file.apa36,",   #帳款類別
               " apb03.apb_file.apb03,",   #收貨工廠
               " apb21.apb_file.apb21,",   #憑證單號(驗收單號)
               " apb22.apb_file.apb22,",   #憑證單項次
               " apb06.apb_file.apb06,",   #採購單號
               " apb07.apb_file.apb07,",   #採購單項次
               " apb23.apb_file.apb23,",   #未稅單價
               " apb09.apb_file.apb09,",   #數量
               " apb10.apb_file.apb10,",   #金額
               " gen02.gen_file.gen02,",   #員工姓名
               " gem02.gem_file.gem02,",   #部門簡稱
               " apb12.apb_file.apb12,",   #料號
               " pmn31.pmn_file.pmn31,",   #驗收單價
               " apa07.apa_file.apa07,",   #廠商簡稱
               " azi03.azi_file.azi03,",   #單位小數位數
               " azi04.azi_file.azi04,",   #金額小數位數
               " azi05.azi_file.azi05,",   #小計小數位數
               " price_diff.apb_file.apb23,",  #單價差異
               " amt_diff.apb_file.apb10,",    #金額差異
               " apb27.apb_file.apb27,",       #品名
               " ima021.ima_file.ima021,",     #規格
               " pmc03.pmc_file.pmc03,",       #送貨廠商簡稱
              #" apb21a.type_file.chr21,",   #FUN-D40129 mark
               " apb21a.type_file.chr30,",   #FUN-D40129 add
              #" apb06a.type_file.chr21 "    #FUN-D40129 mark
               " apb06a.type_file.chr30,",   #FUN-D40129 add  
               " l_n1.type_file.num5"        #FUN-D40129 
   LET l_table = cl_prt_temptable('aapx107',g_sql) CLIPPED
   IF l_table = -1 THEN 
      EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?)"   #FUN-D40129
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-750129  --End
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
  #LET tm.u  = ARG_VAL(10)  #FUN-D30070 mark
  #FUN-D30070---mod--str--
  ##No.FUN-570264 --start--
  #LET g_rep_user = ARG_VAL(11)
  #LET g_rep_clas = ARG_VAL(12)
  #LET g_template = ARG_VAL(13)
  #LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
  ##No.FUN-570264 ---end---
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
  #FUN-D30070---mod--end--
 
   #no.6133
   DROP TABLE curr_tmp
# No.FUN-690028 --start--
   CREATE TEMP TABLE curr_tmp(
       curr    LIKE azi_file.azi01,
       amt     LIKE type_file.num20_6,
       order1  LIKE apa_file.apa01,
       order2  LIKE apa_file.apa01,
       order3  LIKE apa_file.apa01);
 
# No.FUN-690028 ---end---
   #no.6133(end)
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL aapx107_tm(0,0)
   ELSE
      CALL aapx107()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD 
END MAIN
 
FUNCTION aapx107_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   LET p_row = 3 LET p_col = 13
   OPEN WINDOW aapx107_w AT p_row,p_col
     WITH FORM "aap/42f/aapx107"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '123'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
  #LET tm2.u1   = tm.u[1,1]  #FUN-D30070 mark
  #LET tm2.u2   = tm.u[2,2]  #FUN-D30070 mark
  #LET tm2.u3   = tm.u[3,3]  #FUN-D30070 mark
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
  #IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF  #FUN-D30070 mark
  #IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF  #FUN-D30070 mark
  #IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF  #FUN-D30070 mark
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON apa01,apa02,apa05,apa06,apa21,apa22,apa36
 
         #-----TQC-760041---------
         ON ACTION CONTROLP
            CASE
            WHEN INFIELD(apa01) 
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_apa"
               LET g_qryparam.arg1 = '11'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apa01
               NEXT FIELD apa01
            WHEN INFIELD(apa05) 
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_pmc1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apa05
               NEXT FIELD apa05
            WHEN INFIELD(apa06) 
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_pmc12"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apa06
               NEXT FIELD apa06
            WHEN INFIELD(apa21) 
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gen"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apa21
               NEXT FIELD apa21
            WHEN INFIELD(apa22) 
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gem"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apa22
               NEXT FIELD apa22
            WHEN INFIELD(apa36) 
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_apr"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apa36
               NEXT FIELD apa36
            END CASE
         #-----END TQC-760041-----
 
         ON ACTION locale
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
 
      END CONSTRUCT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aapx107_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      DISPLAY BY NAME tm.more         # Condition
 
      INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,
                    # tm2.u1,tm2.u2,tm2.u3,tm.more #FUN-D30070 mark
                      tm.more  #FUN-D30070 add
                      WITHOUT DEFAULTS
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         #ON ACTION CONTROLP   #TQC-630234
         #   CALL aapx107_wc()   #TQC-630234
 
         AFTER INPUT
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
            LET tm.t = tm2.t1,tm2.t2,tm2.t3
           #LET tm.u = tm2.u1,tm2.u2,tm2.u3  #FUN-D30070 mark
 
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
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aapx107_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aapx107'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapx107','9031',1)
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
                        " '",tm.s CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",
                      # " '",tm.u CLIPPED,"'", #FUN-D30070 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aapx107',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW aapx107_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL aapx107()
      ERROR ""
 
   END WHILE
 
   CLOSE WINDOW aapx107_w
 
END FUNCTION
 
FUNCTION aapx107_wc()
   #DEFINE l_wc LIKE type_file.chr1000  #TQC-630166  #No.FUN-690028 VARCHAR(300)
   DEFINE l_wc  STRING   #TQC-630166
 
   OPEN WINDOW aapx107_w2 AT 2,2
     WITH FORM "aap/42f/aapt110"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("aapt110")
   CALL cl_opmsg('q')
 
   CONSTRUCT BY NAME l_wc ON apa01,apa02,apa05,apa06,apa18,apa08,apa09,
                             apa11,apa12,apa13,apa14,apa15,apa16,apa55,
                             apa41,apa19,apa20,apa171,apa17,apa172,apa173,
                             apa174,apa21,apa22,apa24,apa25,apa44,apamksg,
                             apa36,apa31,apa51,apa32,apa52,apa34,apa54,
                             apa35,apa33,apa53,apainpd,apauser,apagrup,
                             apamodu,apadate,apaacti
 
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
 
   END CONSTRUCT
 
   CLOSE WINDOW aapx107_w2
 
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW aapx107_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
 
END FUNCTION
 
FUNCTION aapx107()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#         l_time    LIKE type_file.chr8,           # Used time for running the job  #No.FUN-690028 VARCHAR(8)
          #l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT   #TQC-630166  #No.FUN-690028 VARCHAR(1200)
          l_sql      STRING,      # RDSQL STATEMENT   #TQC-630166
          l_str     STRING,       #FUN-CA0132
          l_cnt     LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          i         LIKE type_file.num5,    #No.FUN-690028 SMALLINT
#         l_order    ARRAY[5] OF VARCHAR(10),
#         l_order    ARRAY[5] OF VARCHAR(16),   #No.FUN-550030
          l_order    ARRAY[5] OF LIKE apa_file.apa01,      # No.FUN-690028 VARCHAR(100),   #No.FUN-560011
          sr               RECORD order1   LIKE  apa_file.apa01,    # No.FUN-690028 VARCHAR(100),             #FUN-560011
                                  order2   LIKE  apa_file.apa01,      # No.FUN-690028 VARCHAR(100),             #FUN-560011
                                  order3   LIKE  apa_file.apa01,      # No.FUN-690028 VARCHAR(100),             #FUN-560011
                                  apa01      LIKE apa_file.apa01,   #帳款編號
                                  apa05      LIKE apa_file.apa05,   #送貨廠商編號
                                  apa13      LIKE apa_file.apa13,   #幣別
                                  apa02      LIKE apa_file.apa02,   #帳款日期
                                  apa06      LIKE apa_file.apa06,   #付款廠商
                                  apa21      LIKE apa_file.apa21,   #帳款人員
                                  apa22      LIKE apa_file.apa22,   #帳款部門
                                  apa36      LIKE apa_file.apa36,   #帳款類別
                                  apb03      LIKE apb_file.apb03,   #收貨工廠
                                  apb21      LIKE apb_file.apb21,   #憑證單號(驗收單號)
                                  apb22      LIKE apb_file.apb22,   #憑證單項次
                                  apb06      LIKE apb_file.apb06,   #採購單號
                                  apb07      LIKE apb_file.apb07,   #採購單項次
                                  apb23      LIKE apb_file.apb23,   #未稅單價
                                  apb09      LIKE apb_file.apb09,   #數量
                                  apb10      LIKE apb_file.apb10,   #金額
                                  gen02      LIKE gen_file.gen02,   #員工姓名
                                  gem02      LIKE gem_file.gem02,   #部門簡稱
                                  apb12      LIKE apb_file.apb12,   #料號
                                  pmn31      LIKE pmn_file.pmn31,   #驗收單價
                                  apa07      LIKE apa_file.apa07,   #廠商簡稱
                                  azi03      LIKE azi_file.azi03,   #單位小數位數
                                  azi04      LIKE azi_file.azi04,   #金額小數位數
                                  azi05      LIKE azi_file.azi05,   #小計小數位數
                                  price_diff LIKE apb_file.apb23,   #單價差異
                                  amt_diff   LIKE apb_file.apb10,   #金額差異
                                  apb27      LIKE apb_file.apb27,   #品名
                                  ima021     LIKE ima_file.ima021,  #規格
                                  pmc03      LIKE pmc_file.pmc03,   #送貨廠商簡稱
#No.FUN-550030--begin
                                 #apb21a     LIKE type_file.chr21,       # No.FUN-690028 VARCHAR(21)  #驗收單號+項次   #FUN-D40129 mark
                                  apb21a     LIKE type_file.chr30,       # No.FUN-D40129 add                      #驗收單號+項次
                                 #apb06a     LIKE type_file.chr21,       # No.FUN-690028 VARCHAR(21)  #採購單號+項次   #FUN-D40129 mark
                                  apb06a     LIKE type_file.chr30,       # No.FUN-D40129 add
                                  apb37      LIKE apb_file.apb37         #FUN-A60056 add apb37
#No.FUN-550030--end
                        END RECORD
   DEFINE l_n1  LIKE type_file.num5   #FUN-D40129
 
#    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
   #No.FUN-750129  --Begin
   CALL cl_del_data(l_table)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   #No.FUN-750129  --End
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND apauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND apagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND apagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apauser', 'apagrup')
   #End:FUN-980030
 
 
   #No.FUN-750129  --Begin
   ##no.6133   (針對幣別加總)
   #DELETE FROM curr_tmp;
 
   #LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 1 小計
   #          "  WHERE order1=? ",
   #          "  GROUP BY curr"
   #PREPARE tmp1_pre FROM l_sql
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err('pre_1:',SQLCA.sqlcode,1)
   #   RETURN
   #END IF
   #DECLARE tmp1_cs CURSOR FOR tmp1_pre
 
   #LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 2 小計
   #          "  WHERE order1=? ",
   #          "    AND order2=? ",
   #          "  GROUP BY curr  "
   #PREPARE tmp2_pre FROM l_sql
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err('pre_2:',SQLCA.sqlcode,1)
   #   RETURN
   #END IF
   #DECLARE tmp2_cs CURSOR FOR tmp2_pre
 
   #LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 3 小計
   #          "  WHERE order1=? ",
   #          "    AND order2=? ",
   #          "    AND order3=? ",
   #          "  GROUP BY curr  "
   #PREPARE tmp3_pre FROM l_sql
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err('pre_3:',SQLCA.sqlcode,1)
   #   RETURN
   #END IF
   #DECLARE tmp3_cs CURSOR FOR tmp3_pre
   #No.FUN-750129  --End  
 
   #no.6133(end)
   LET l_sql = "SELECT '','','',apa01,apa05,apa13,apa02,apa06,apa21,apa22,",
               "       apa36,apb03,apb21,apb22,apb06,apb07,apb23,apb09,",
              #"       apb10,gen02,gem02,apb12,pmn31,apa07,azi03,azi04,",  #FUN-A60056
               "       apb10,gen02,gem02,apb12,'',apa07,azi03,azi04,",  #FUN-A60056
               "       azi05,0,0,apb27,'','','','',apb37",   #FUN-A60056 add apb37
              #"  FROM apa_file,apb_file,OUTER pmn_file,",   #FUN-A60056
               "  FROM apa_file,apb_file,",   #FUN-A60056
               "       OUTER gen_file,OUTER gem_file,",
               "       OUTER azi_file",
               " WHERE apa00 = '11'",
               "   AND apa01 = apb01",
              #"   AND apb_file.apb06 = pmn_file.pmn01",  #No.FUN-750129   #FUN-A60056
              #"   AND apb_file.apb07 = pmn_file.pmn02",  #No.FUN-750129   #FUN-A60056
               "   AND gen_file.gen01 = apa_file.apa21",  #No.FUN-750129
               "   AND gem_file.gem01 = apa_file.apa22",  #No.FUN-750129
               "   AND azi_file.azi01 = apa_file.apa13",   #No.FUN-750129
               "   AND apaacti = 'Y' AND apa41='Y' AND apa42='N' ",
               "   AND ",tm.wc
   LET l_sql = l_sql CLIPPED," ORDER BY apa01,apb03"
   PREPARE aapx107_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   DECLARE aapx107_curs1 CURSOR FOR aapx107_prepare1
 
   #No.FUN-750129  --Begin
#  CALL cl_outnam('aapx107') RETURNING l_name
#  START REPORT aapx107_rep TO l_name
   #No.FUN-750129  --End
 
   FOREACH aapx107_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
#FUN-A60056--mod--str--
#     IF sr.apb03 != g_plant THEN
#        LET g_plant_new = sr.apb03
##         CALL s_getdbs()                                                  #No.FUN-A10098 -----mark
##         LET l_sql = "SELECT apb12,pmn31 FROM ",g_dbs_new,"pmn_file",     #No.FUN-A10098 -----mark
#        LET l_sql = "SELECT pmn04,pmn31 FROM ",cl_get_target_table(g_plant_new,'pmn_file'),      #No.FUN-A10098 -----add
#                    " WHERE pmn01 = '",sr.apb06,"'",
#                    "   AND pmn02 = '",sr.apb07,"'"
#	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
#        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING  l_sql              #No.FUN-A10098 -----add
#        PREPARE x107_p2 FROM l_sql
#        OPEN x107_p2
#        FETCH x107_p2 INTO sr.apb12,sr.pmn31
#     END IF
      LET l_sql = "SELECT pmn31 FROM ",cl_get_target_table(sr.apb37,'pmn_file'),
                  " WHERE pmn01 = '",sr.apb06,"'",
                  "   AND pmn02 = '",sr.apb07,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,sr.apb37) RETURNING l_sql
      PREPARE sel_pmn31_cs FROM l_sql
      EXECUTE sel_pmn31_cs INTO sr.pmn31
#FUN-A60056--mod--end
      IF sr.pmn31 IS NULL THEN
         LET sr.pmn31 = 0
      END IF
      SELECT ima021 INTO sr.ima021 FROM ima_file
       WHERE ima01 = sr.apb12
      SELECT pmc03 INTO sr.pmc03 FROM pmc_file
       WHERE pmc01 = sr.apa05
      LET sr.apb21a = sr.apb21,"-",sr.apb22 USING '&&&&'
      LET sr.apb06a = sr.apb06,"-",sr.apb07 USING '&&&&'
      LET sr.price_diff = sr.apb23 - sr.pmn31
      IF sr.price_diff = 0 THEN
         CONTINUE FOREACH
      END IF
      LET sr.amt_diff = sr.price_diff * sr.apb09
      #No.FUN-750129  --Begin
      #FOR i = 1 TO 3
      #   CASE WHEN tm.s[i,i] = '1' LET l_order[i] = sr.apa01
      #                                 LET l_orderA[i] = g_x[12]
      #        WHEN tm.s[i,i] = '2' LET l_order[i] = sr.apa02 USING 'YYYYMMDD'
      #                                 LET l_orderA[i] = g_x[13]
      #        WHEN tm.s[i,i] = '3' LET l_order[i] = sr.apa05
      #                                 LET l_orderA[i] = g_x[14]
      #        WHEN tm.s[i,i] = '4' LET l_order[i] = sr.apa06
      #                                 LET l_orderA[i] = g_x[15]
      #        WHEN tm.s[i,i] = '5' LET l_order[i] = sr.apa21
      #                                 LET l_orderA[i] = g_x[16]
      #        WHEN tm.s[i,i] = '6' LET l_order[i] = sr.apa22
      #                                 LET l_orderA[i] = g_x[17]
      #        WHEN tm.s[i,i] = '7' LET l_order[i] = sr.apa36
      #                                 LET l_orderA[i] = g_x[18]
      #        OTHERWISE LET l_order[i] = '-'
      #                  LET l_orderA[i] = ' '
      #   END CASE
      #END FOR
      #LET sr.order1 = l_order[1]
      #LET sr.order2 = l_order[2]
      #LET sr.order3 = l_order[3]
      #IF sr.order1 IS NULL THEN
      #   LET sr.order1 = ' '
      #END IF
      #IF sr.order2 IS NULL THEN
      #   LET sr.order2 = ' '
      #END IF
      #IF sr.order3 IS NULL THEN
      #   LET sr.order3 = ' '
      #END IF
      #No.FUN-750129  --End  
      LET sr.amt_diff = sr.price_diff * sr.apb09
 
      #No.FUN-750129  --Begin
#     OUTPUT TO REPORT aapx107_rep(sr.*)
      LET l_n1 = 3   #FUN-D40129
      EXECUTE insert_prep USING
              sr.apa01, sr.apa05, sr.apa13, sr.apa02, sr.apa06,
              sr.apa21, sr.apa22, sr.apa36, sr.apb03, sr.apb21,
              sr.apb22, sr.apb06, sr.apb07, sr.apb23, sr.apb09,
              sr.apb10, sr.gen02, sr.gem02, sr.apb12, sr.pmn31,
              sr.apa07, sr.azi03, sr.azi04, sr.azi05, sr.price_diff,
              sr.amt_diff, sr.apb27, sr.ima021, sr.pmc03, sr.apb21a,
              sr.apb06a, l_n1   #FUN-D40129 add l_n1
      #No.FUN-750129  --End
 
   END FOREACH
 
   #No.FUN-750129  --Begin
   #FINISH REPORT aapx107_rep
 
   #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   #  CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
###XtraGrid###    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  #FUN-CA0132
    LET g_str = ''
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'apa01,apa02,apa05,apa06,apa21,apa22,apa36')
#      RETURNING g_str                                      #FUN-CA0132
       RETURNING tm.wc                                      #FUN-CA0132
    END IF
#FUN-CA0132---mod--str
#   LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";",tm.u   
#   CALL cl_prt_cs3('aapx107','aapx107',g_sql,g_str)                               
    LET g_xgrid.table = l_table  
    LET g_xgrid.order_field = cl_get_order_field(tm.s,"apa01,apa02,apa05,apa06,apa21,apa22,apa36")
   #LET g_xgrid.grup_field = cl_get_sum_field(tm.s,tm.u,"apa01,apa02,apa05,apa06,apa21,apa22,apa36") #FUN-D30053 mark
    LET g_xgrid.grup_field = cl_get_order_field(tm.s,"apa01,apa02,apa05,apa06,apa21,apa22,apa36")  #FUN-D30053
   #LET g_xgrid.grup_sum_field = cl_get_sum_field(tm.s,tm.u,"apa01,apa02,apa05,apa06,apa21,apa22,apa36")  #FUN-D30070 mark
    LET g_xgrid.skippage_field = cl_get_skip_field(tm.s,tm.t,"apa01,apa02,apa05,apa06,apa21,apa22,apa36")
   #LET l_str = cl_wcchp(g_xgrid.order_field,"apa01,apa02,apa05,apa06,apa21,apa22,apa36")  #FUN-D30070 mark
   #LET l_str = cl_replace_str(l_str,',',' ')  #FUN-D30070 mark
    LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc
   #LET g_xgrid.footerinfo1 = cl_getmsg("lib-626",g_lang),l_str   #FUN-D30070 mark
    CALL cl_xg_view()   
#FUN-CA0132---mark--end
   #No.FUN-750129  --End
 
END FUNCTION
 
#No.FUN-750129  --Begin
{
REPORT aapx107_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          sr               RECORD order1   LIKE  apa_file.apa01,      # No.FUN-690028 VARCHAR(100),             #FUN-560011
                                  order2   LIKE  apa_file.apa01,      # No.FUN-690028 VARCHAR(100),             #FUN-560011
                                  order3   LIKE  apa_file.apa01,      # No.FUN-690028 VARCHAR(100),             #FUN-560011
                                  apa01      LIKE apa_file.apa01,   # 帳款編號
                                  apa05      LIKE apa_file.apa05,   #送貨廠商編號
                                  apa13      LIKE apa_file.apa13,   #幣別
                                  apa02      LIKE apa_file.apa02,   #帳款i 
                                  apa06      LIKE apa_file.apa06,   #付款廠商
                                  apa21      LIKE apa_file.apa21,   #帳款人員
                                  apa22      LIKE apa_file.apa22,   #帳款部門
                                  apa36      LIKE apa_file.apa36,   #帳款類別
                                  apb03      LIKE apb_file.apb03,   #收貨工廠
                                  apb21      LIKE apb_file.apb21,   #憑證單號(驗收單號)
                                  apb22      LIKE apb_file.apb22,   #憑證單項次
                                  apb06      LIKE apb_file.apb06,   #採購單號
                                  apb07      LIKE apb_file.apb07,   #採購單項次
                                  apb23      LIKE apb_file.apb23,   #未稅單價
                                  apb09      LIKE apb_file.apb09,   #數量
                                  apb10      LIKE apb_file.apb10,   #金額
                                  gen02      LIKE gen_file.gen02,   #員工姓名
                                  gem02      LIKE gem_file.gem02,   #部門簡稱
                                  apb12      LIKE apb_file.apb12,   #料號
                                  pmn31      LIKE pmn_file.pmn31,   #驗收單價
                                  apa07      LIKE apa_file.apa07,   #廠商簡稱
                                  azi03      LIKE azi_file.azi03,   #單位小數位數
                                  azi04      LIKE azi_file.azi04,   #金額小數位數
                                  azi05      LIKE azi_file.azi05,   #小計小數位數
                                  price_diff LIKE apb_file.apb23,   #單價差異
                                  amt_diff   LIKE apb_file.apb10,   #金額差異
                                  apb27      LIKE apb_file.apb27,   #品名
                                  ima021     LIKE ima_file.ima021,  #規格
                                  pmc03      LIKE pmc_file.pmc03,   #送貨廠商簡稱
#No.FUN-550030--begin
                                  apb21a     LIKE type_file.chr21,       # No.FUN-690028 VARCHAR(21),              #驗收單號+項次
                                  apb06a     LIKE type_file.chr21        # No.FUN-690028 VARCHAR(21)               #採購單號+項次
#No.FUN-550030--end
                        END RECORD,
          sr1           RECORD
                           curr      LIKE apa_file.apa13,
                           amt       LIKE apb_file.apb10
                        END RECORD
   DEFINE g_head1      STRING
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.order1,sr.order2,sr.order3
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         LET g_head1= g_x[20]CLIPPED,l_orderA[1] CLIPPED,
                      " - ",l_orderA[2] CLIPPED," - ",l_orderA[3] CLIPPED
         PRINT g_head1
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
               g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],
               g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50]
         PRINT g_dash1
         LET l_last_sw = 'n'
 
      BEFORE GROUP OF sr.order1
         IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9) THEN
            SKIP TO TOP OF PAGE
         END IF
 
      BEFORE GROUP OF sr.order2
         IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9) THEN
            SKIP TO TOP OF PAGE
         END IF
 
      BEFORE GROUP OF sr.order3
         IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 9) THEN
            SKIP TO TOP OF PAGE
         END IF
 
      BEFORE GROUP OF sr.apa01
         PRINT COLUMN g_c[31],sr.apa01,
               COLUMN g_c[32],sr.apa02,
               COLUMN g_c[33],sr.apa05,
               COLUMN g_c[34],sr.pmc03,
               COLUMN g_c[35],sr.apa21,
               COLUMN g_c[36],sr.gen02,
               COLUMN g_c[37],sr.apa22,
               COLUMN g_c[38],sr.gem02;
 
      ON EVERY ROW
         PRINT COLUMN g_c[39],sr.apb03,
               COLUMN g_c[40],sr.apb12,
               COLUMN g_c[41],sr.apb27,
               COLUMN g_c[42],sr.ima021,
               COLUMN g_c[43],sr.apb21a,
               COLUMN g_c[44],sr.apb06a,
               COLUMN g_c[45],sr.apa13,
               COLUMN g_c[46],cl_numfor(sr.apb23,46,sr.azi03),
               COLUMN g_c[47],cl_numfor(sr.pmn31,47,sr.azi03),
               COLUMN g_c[48],cl_numfor(sr.apb09,48,3),
               COLUMN g_c[49],cl_numfor(sr.price_diff,49,sr.azi03),
               COLUMN g_c[50],cl_numfor(sr.amt_diff,50,sr.azi04)
 
         #no.6133
         INSERT INTO curr_tmp VALUES(sr.apa13,sr.amt_diff,
                                     sr.order1,sr.order2,sr.order3)
         #no.6133(end)
 
      AFTER GROUP OF sr.order1
         #FUN-D30070---mark--str--
        #IF tm.u[1,1] = 'Y' THEN
      #NIC  PRINT COLUMN g_c[47],l_orderA[1] CLIPPED;
        #   PRINT COLUMN g_c[47],l_orderA[1] CLIPPED
        #   #no.6133
        #   FOREACH tmp1_cs USING sr.order1 INTO sr1.*
        #      SELECT azi05 INTO t_azi05 FROM azi_file   #No.CHI-6A0004
        #       WHERE azi01 = sr1.curr
        #      PRINT COLUMN g_c[48],sr1.curr CLIPPED,
        #            COLUMN g_c[49],g_x[9] CLIPPED,
        #            COLUMN g_c[50],cl_numfor(sr1.amt,50,t_azi05)   #No.CHI-6A0004
        #   END FOREACH
        #   #no.6133(end)
        #   SKIP 1 LINE
        #END IF
         #FUN-D30070---mark--str--
 
      AFTER GROUP OF sr.order2
        #FUN-D30070---mark--str--
        #IF tm.u[2,2] = 'Y' THEN
      #NIC  PRINT COLUMN g_c[47],l_orderA[2] CLIPPED;
        #   PRINT COLUMN g_c[47],l_orderA[2] CLIPPED
        #   #no.6133
        #   FOREACH tmp2_cs USING sr.order1,sr.order2 INTO sr1.*
        #      SELECT azi05 INTO t_azi05 FROM azi_file    #No.CHI-6A0004
        #       WHERE azi01 = sr1.curr
        #      PRINT COLUMN g_c[48],sr1.curr CLIPPED,
        #            COLUMN g_c[49],g_x[9] CLIPPED,
        #            COLUMN g_c[50],cl_numfor(sr1.amt,50,t_azi05)   #No.CHI-6A0004
        #   END FOREACH
        #   #no.6133(end)
        #   SKIP 1 LINE
        #END IF
        #FUN-D30070---mark--str-- 
 
      AFTER GROUP OF sr.order3
        #FUN-D30070---mark--str--
        #IF tm.u[3,3] = 'Y' THEN
      #NIC  PRINT COLUMN g_c[47],l_orderA[3] CLIPPED;
        #   PRINT COLUMN g_c[47],l_orderA[3] CLIPPED
        #   #no.6133
        #   FOREACH tmp3_cs USING sr.order1,sr.order2,sr.order3 INTO sr1.*
        #      SELECT azi05 INTO t_azi05 FROM azi_file   #No.CHI-6A0004
        #       WHERE azi01 = sr1.curr
        #      PRINT COLUMN g_c[48],sr1.curr CLIPPED,
        #            COLUMN g_c[49],g_x[9] CLIPPED,
        #            COLUMN g_c[50],cl_numfor(sr1.amt,50,t_azi05)   #No.CHI-6A0004
        #   END FOREACH
        #   #no.6133(end)
        #   SKIP 1 LINE
        #END IF
        #FUN-D30070---mark--str--
 
      ON LAST ROW
         IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
            CALL cl_wcchp(tm.wc,'apa01,apa02,apa05,apa06,apa21,apa22,apa36') RETURNING tm.wc
 
            #TQC-630166
            #IF tm.wc[001,070] > ' ' THEN            # for 80
            #   PRINT COLUMN g_c[31],g_x[8] CLIPPED,
            #         COLUMN g_c[32],tm.wc[001,070] CLIPPED
            #END IF
            #IF tm.wc[071,140] > ' ' THEN
            #   PRINT COLUMN g_c[32],tm.wc[071,140] CLIPPED
            #END IF
            #IF tm.wc[141,210] > ' ' THEN
            #   PRINT COLUMN g_c[32],tm.wc[141,210] CLIPPED
            #END IF
            #IF tm.wc[211,280] > ' ' THEN
            #   PRINT COLUMN g_c[32],tm.wc[211,280] CLIPPED
            #END IF
            PRINT g_dash[1,g_len]
            CALL cl_prt_pos_wc(tm.wc)
            #END TQC-630166
         END IF
         PRINT g_dash[1,g_len]
         LET l_last_sw = 'y'
     #   PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[50],g_x[7] CLIPPED   #TQC-6A0088
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[7] CLIPPED   #TQC-6A0088
 
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
    #       PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[50],g_x[6] CLIPPED   #TQC-6A0088
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[6] CLIPPED   #TQC-6A0088
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT
}
#No.FUN-750129  --End  


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
