# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: afar720.4gl
# Descriptions...: 投資抵減明細盤點清單
# Date & Author..: 96/05/14 By STAR
# Modify.........: No.FUN-510035 05/01/25 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By Jackho  本（原）幣取位修改
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6C0009 06/12/08 By Rayven 表頭制表日期等位置調整
# Modify.........: No.FUN-770052 07/08/06 By xiaofeizhu 制作水晶報表
# Modify.........: No.FUN-8A0055 09/01/04 By shiwuying 修改tm.wc
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80054 11/08/04 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,       # Where condition       #No.FUN-680070 VARCHAR(1000)
              more    LIKE type_file.chr1,          # Input more condition(Y/N)       #No.FUN-680070 VARCHAR(1)
              a       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
              b       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
              s       LIKE type_file.chr6,          # Order by sequence       #No.FUN-680070 VARCHAR(6)
              t       LIKE type_file.chr6,          # Eject sw       #No.FUN-680070 VARCHAR(6)
              v       LIKE type_file.chr6           # 小計       #No.FUN-680070 VARCHAR(6)
              END RECORD,
          m_codest  LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(34)
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
 
 
DEFINE   t4              LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE   l_table         STRING                      #No.FUN-770052                                                                     
DEFINE   g_sql           STRING                      #No.FUN-770052                                                                     
DEFINE   g_str           STRING                      #No.FUN-770052                                                                      
DEFINE   l_table1        STRING                      #No.FUN-770052  
 
 
 
 
 
 
 
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
### *** FUN-770052 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                     
    LET g_sql = "fcc01.fcc_file.fcc01,",                                                                                            
                "fcc02.fcc_file.fcc02,",                                                                                            
                "fcc03.fcc_file.fcc03,",                                                                                            
                "fcc031.fcc_file.fcc031,",                                                                                          
                "fcc06.fcc_file.fcc06,",                                                                                            
                "fcc05.fcc_file.fcc05,",                                                                                            
                "fcc08.fcc_file.fcc08,",                                                                                            
                "fcc07.fcc_file.fcc07,",                                                                                            
                "fcc19.fcc_file.fcc19,",                                                                                            
                "fcc21.fcc_file.fcc21,",                                                                                           
                "fcc14.fcc_file.fcc14,",                                                                                           
                "fcc23.fcc_file.fcc23,",                                                                                           
                "fcc24.fcc_file.fcc24,",                                                                                           
                "fcc15.fcc_file.fcc15,",                                                                                            
                "fcc24a.fcc_file.fcc24,",
                "faj20.faj_file.faj20,",  
                "gen02.gen_file.gen02,",  
                "fcb03.fcb_file.fcb03,", 
                "fcb04.fcb_file.fcb04,",
                "fcb05.fcb_file.fcb05,",
                "fcb06.fcb_file.fcb06,",
                "num5.type_file.num5,",
                "faj02.faj_file.faj02,",
                "faj08.faj_file.faj08,",
                "fcc16c.fcc_file.fcc16,",
                "fcc16d.fcc_file.fcc16,",
                "azi04.azi_file.azi04,",
                "azi05.azi_file.azi05"
    LET l_table = cl_prt_temptable('afar720',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生    
    
    LET g_sql = "fcc14a.fcc_file.fcc14,",
                "fcc16.fcc_file.fcc16,", 
                "fcc16a.fcc_file.fcc16,",
                "fcc15a.fcc_file.fcc15,",
                "fcc16b.fcc_file.fcc16,",
                "fcc01.fcc_file.fcc01,", 
                "fcc03.fcc_file.fcc03,",
                "fcc031.fcc_file.fcc031"
    LET l_table1 = cl_prt_temptable('afar7201',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table1 = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                  
#----------------------------------------------------------CR (1) ------------#  
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.v  = ARG_VAL(10)
   LET tm.a  = ARG_VAL(11)
   LET tm.b  = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   DROP TABLE r720_temp
#No.FUN-680070  -- begin --
#   CREATE TEMP TABLE r720_temp(
#     fcb04 VARCHAR(20),    #管理局核准文號
#     fcc15 smallint,    #扺減率
#     fcc14 VARCHAR(4),     #幣別
#     cost1 dec(20,6),   #原幣金額
#     cost2 dec(20,6),   #本幣金額
#     cost3 dec(20,6));  #扺減額
   CREATE TEMP TABLE r720_temp(
     fcb04 LIKE fcb_file.fcb04,
     fcc15 LIKE fcc_file.fcc15,
     fcc14 LIKE fcc_file.fcc14,
     cost1 LIKE type_file.num20_6,
     cost2 LIKE type_file.num20_6,
     cost3 LIKE type_file.num20_6);
#No.FUN-680070  -- end --
create  unique index r720_01 on r720_temp(fcb04,fcc15,fcc14);
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL afar720_tm(0,0)            # Input print condition
      ELSE CALL afar720()                   # Read data and create out-file
   END IF
   DROP TABLE r720_temp
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION afar720_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW afar720_w AT p_row,p_col WITH FORM "afa/42f/afar720"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a = 'N'
   LET tm.b = '2'
   LET tm.s  = '21   '
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.s4   = tm.s[4,4]
   LET tm2.s5   = tm.s[5,5]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.t4   = tm.t[4,4]
   LET tm2.t5   = tm.t[5,5]
   LET tm2.u1   = tm.v[1,1]
   LET tm2.u2   = tm.v[2,2]
   LET tm2.u3   = tm.v[3,3]
   LET tm2.u4   = tm.v[4,4]
   LET tm2.u5   = tm.v[5,5]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.s4) THEN LET tm2.s4 = ""  END IF
   IF cl_null(tm2.s5) THEN LET tm2.s5 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.t4) THEN LET tm2.t4 = "N" END IF
   IF cl_null(tm2.t5) THEN LET tm2.t5 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
   IF cl_null(tm2.u4) THEN LET tm2.u4 = "N" END IF
   IF cl_null(tm2.u5) THEN LET tm2.u5 = "N" END IF
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON fcb03,fcb04,faj20,faj02,faj08,fcc02
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
         LET INT_FLAG = 0 CLOSE WINDOW afar720_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
         INPUT BY NAME
            tm.a,tm.b,tm2.s1,tm2.s2,tm2.s3,tm2.s4,tm2.s5,
            tm2.t1,tm2.t2,tm2.t3,tm2.t4,tm2.t5,
            tm2.u1,tm2.u2,tm2.u3,tm2.u4,tm2.u5,tm.more
            WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
            AFTER FIELD more
               IF tm.more = 'Y' THEN
                  CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                 g_bgjob,g_time,g_prtway,g_copies)
                  RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
               END IF
            ON ACTION CONTROLR
               CALL cl_show_req_fields()
            ON ACTION CONTROLG
               CALL cl_cmdask()    # Command execution
            AFTER INPUT
               LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1],tm2.s4[1,1],tm2.s5[1,1]
               LET tm.t = tm2.t1,tm2.t2,tm2.t3,tm2.t4,tm2.t5
               LET tm.v = tm2.u1,tm2.u2,tm2.u3,tm2.u4,tm2.u5
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
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
         END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW afar720_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='afar720'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar720','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,      #(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.a  CLIPPED,"'",
                            " '",tm.b  CLIPPED,"'",
                            " '",tm.s  CLIPPED,"'",
                            " '",tm.t  CLIPPED,"'",
                            " '",tm.v  CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('afar720',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW afar720_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar720()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW afar720_w
END FUNCTION
 
FUNCTION afar720()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0069
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                #No.FUN-680070 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680070 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680070 VARCHAR(40)
          l_order   ARRAY[7] OF LIKE faj_file.faj08,     #No.FUN-680070 VARCHAR(10)
          l_count      LIKE type_file.num5,       #No.FUN-770052                                                       
          l_gen02      LIKE gen_file.gen02,       #No.FUN-770052                                                                                  
          l_fcc14      LIKE fcc_file.fcc14,       #No.FUN-770052                                                                                  
          l_fcc15      LIKE fcc_file.fcc15,       #No.FUN-770052                                                                                  
          l_cost3      LIKE fcc_file.fcc16,       #No.FUN-770052
          l_str        STRING,                    #No.FUN-770052
          l_sum1,l_sum2,l_sum3,l_amt,l_amt3 LIKE fcc_file.fcc16,                   #No.FUN-770052
          sr        RECORD
                       order1 LIKE faj_file.faj08,       #No.FUN-680070 VARCHAR(10)
                       order2 LIKE faj_file.faj08,       #No.FUN-680070 VARCHAR(10)
                       order3 LIKE faj_file.faj08,       #No.FUN-680070 VARCHAR(10)
                       order4 LIKE faj_file.faj08,       #No.FUN-680070 VARCHAR(10)
                       order5 LIKE faj_file.faj08,       #No.FUN-680070 VARCHAR(10)
                       fcc01  LIKE fcc_file.fcc01,       #單號
                       fcc02  LIKE fcc_file.fcc02,       #項次
                       fcc03  LIKE fcc_file.fcc03,       #財編
                       fcc031 LIKE fcc_file.fcc031,      #附號
                       fcc04  LIKE fcc_file.fcc04,       #合併碼
                       fcc05  LIKE fcc_file.fcc05,       #中文名稱
                       fcc06  LIKE fcc_file.fcc06,       #英文名稱
                       fcc08  LIKE fcc_file.fcc08,       #廠商名稱
                       fcc09  LIKE fcc_file.fcc09,       #數量
                       fcc21  LIKE fcc_file.fcc21,       #數量
                       fcc14  LIKE fcc_file.fcc14,       #幣別
                       fcc15  LIKE fcc_file.fcc15,       #抵減率
                       fcc13  LIKE fcc_file.fcc13,       #原幣成本
                       fcc16  LIKE fcc_file.fcc16,       #本幣成本
                       fcc23  LIKE fcc_file.fcc23,       #合併前原幣
                       fcc24  LIKE fcc_file.fcc24,       #本幣
                       fcb03  LIKE fcb_file.fcb03,       #管理局核准日
                       fcb04  LIKE fcb_file.fcb04,       #文號
                       fcb05  LIKE fcb_file.fcb05,       #國稅局核准日
                       fcb06  LIKE fcb_file.fcb06,       #文號
                       faj04  LIKE faj_file.faj04,       #主類別
                       faj43  LIKE faj_file.faj43,       #狀態
                       faj45  LIKE faj_file.faj45,       #帳款編號
                       faj47  LIKE faj_file.faj47,       #採購單號
                       faj49  LIKE faj_file.faj49,       #進口編號
                       faj51  LIKE faj_file.faj51,       #發票號碼
                       faj20  LIKE faj_file.faj20,
                       faj08  LIKE faj_file.faj08,
                       faj02  LIKE faj_file.faj02,
                       faj19  LIKE faj_file.faj19,
                       fcc07  LIKE fcc_file.fcc07,
                       fcc19  LIKE fcc_file.fcc19,
                       cost1  LIKE fcc_file.fcc23,
                       cost2  LIKE fcc_file.fcc24,
                       cost3  LIKE fcc_file.fcc24,
                       qty    LIKE fcc_file.fcc21
                    END RECORD
#No.FUN-770052--begin--
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                           
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,                                                                                   
                         ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"                                                                                      
   PREPARE insert_prep FROM g_sql                                                                                                   
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80054--add--
       EXIT PROGRAM                                                                            
    END IF
 
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                                           
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?)"                                                                                    
   PREPARE insert_prep1 FROM g_sql                                                                                                   
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80054--add--
       EXIT PROGRAM                                                                            
    END IF
#No.FUN-770052--end--
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-770052 *** ##
     CALL cl_del_data(l_table)                                                  
     CALL cl_del_data(l_table1)                                                 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-770052 a
     #------------------------------ CR (2) ------------------------------#  
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fcbuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND fcbgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND fcbgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fcbuser', 'fcbgrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT ' ',' ',' ',' ',' ', ",
                       " fcc01, fcc02, fcc03, fcc031, fcc04, fcc05, ",
                       " fcc06, fcc08, fcc09, fcc21,  fcc14, fcc15,",
                       " fcc13, fcc16, fcc23, fcc24, ",
                       " fcb03, fcb04, fcb05, fcb06, faj04, faj43, faj45,",
                       " faj47, faj49, faj51, faj20, faj08, faj02, faj19,",
                       " fcc07, fcc19, ",
                       " '','','','' ",
                 "  FROM fcb_file, fcc_file,faj_file",
                 " WHERE fcb01 = fcc01 ",
                 "   AND fcc03 = faj02 ",
                 "   AND fcbconf != 'X' ",      #010802 增
                 "   AND fcc031= faj022 ",
                 "   AND ",tm.wc CLIPPED
 
      IF tm.a = 'Y' THEN   # 國稅局處理否
         LET l_sql = l_sql CLIPPED," AND fcc20 = '5' "
      ELSE
         LET l_sql = l_sql CLIPPED," AND fcc20 = '3' "
      END IF
 
      #-->合併資料
      IF tm.b = '2' THEN
         LET l_sql = l_sql clipped," AND fcc04 IN ('1','2') "
      END IF
     PREPARE afar720_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE afar720_curs1 CURSOR FOR afar720_prepare1
 
     #--->附加費用(幣別/抵減率依申請項次)
     LET l_sql = "SELECT fcj_file.*,faj04,faj43,faj45,faj47,faj49,faj51",
                 " FROM fcj_file,faj_file ",
                 " WHERE fcj01 = ?  AND fcj02 = ? ",
                 "   AND fcj03 = faj02 ",
                 "   AND fcj031= faj022 "
 
     PREPARE afar720_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare2:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE afar720_curs2 CURSOR FOR afar720_prepare2
 
#    CALL cl_outnam('afar720') RETURNING l_name                         #FUN-770052
 
#    START REPORT afar720_rep TO l_name                                 #FUN-770052
     LET g_pageno = 0
 
     DELETE FROM r720_temp
     FOREACH afar720_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
#No.FUN-770052--add--
         LET l_gen02 = ' '                                                                                                          
         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = sr.faj19                                                             
         IF cl_null(l_gen02) THEN LET l_gen02 = ' ' END IF                                                                          
         SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05 FROM azi_file                      
          WHERE azi01=sr.fcc14 
#No.FUN-770052--end--
       # 若前面user 按下 control-t 則會顯示目前做到第 n 筆
          IF tm.b = '1' THEN
           # LET sr.cost1 = sr.fcc23                    #原幣值
           # LET sr.cost2 = sr.fcc24                    #本幣值
           # LET sr.cost3 = sr.cost2 * (sr.fcc15/100)   #抵減額
           # LET sr.qty   = sr.fcc21                    #數量
             LET sr.cost1 = sr.fcc13                    #原幣值
             LET sr.cost2 = sr.fcc16                    #本幣值
             LET sr.cost3 = sr.cost2 * (sr.fcc15/100)   #抵減額
             LET sr.qty   = sr.fcc09                    #數量
          ELSE
           # LET sr.cost1 = sr.fcc13                    #原幣值
           # LET sr.cost2 = sr.fcc16                    #本幣值
           # LET sr.cost3 = sr.cost2 * (sr.fcc15/100)   #抵減額
           # LET sr.qty   = sr.fcc09                    #數量
             LET sr.cost1 = sr.fcc23                    #原幣值
             LET sr.cost2 = sr.fcc24                    #本幣值
             LET sr.cost3 = sr.cost2 * (sr.fcc15/100)   #抵減額
             LET sr.qty   = sr.fcc21                    #數量
          END IF
          #-->依申請號+抵減率+幣別
          INSERT INTO r720_temp
               VALUES(sr.fcb04,sr.fcc15,sr.fcc14,sr.cost1,sr.cost2,sr.cost3)
          IF SQLCA.sqlcode THEN
             UPDATE r720_temp SET cost1=cost1 + sr.cost1,
                                  cost2=cost2 + sr.cost2,
                                  cost3=cost3 + sr.cost3
                          WHERE fcb04 = sr.fcb04
                            AND fcc15 = sr.fcc15
                            AND fcc14 = sr.fcc14
          END IF
#No.FUN-770052--add--
       LET l_count=0                                                                                                                
       DECLARE r720_tot2  CURSOR FOR                                                                                                
          SELECT fcc14,fcc15,SUM(cost1),SUM(cost2),SUM(cost3)                                                                       
            FROM r720_temp                                                                                                          
            GROUP BY fcc15,fcc14                                                                                                    
            ORDER BY fcc15,fcc14                                                                                                    
        LET l_amt = 0  LET l_amt3 = 0  
        FOREACH r720_tot2 INTO l_fcc14,l_fcc15,l_sum1,l_sum2,l_sum3                                                                 
           LET l_count=l_count+1 
           LET l_amt = l_amt + l_sum2                                                                                               
           LET l_amt3 = l_amt3 + l_sum3
           EXECUTE insert_prep1 USING
                      l_fcc14,l_sum1,l_sum2,l_fcc15,l_sum3,sr.fcc01,sr.fcc03,sr.fcc031
         END FOREACH                                                                                                                
         IF SQLCA.sqlcode != 0 THEN                                                                                                 
            CALL cl_err('r720_tot2:',SQLCA.sqlcode,1)                                                                               
         END IF                                                                                                                     
         IF l_count=0 THEN 
           EXECUTE insert_prep1 USING                                                                                                
                     ' ',' ',' ', ' ',' ',sr.fcc01,sr.fcc03,sr.fcc031
         END IF  
#No.FUN-770052--end--
#No.FUN-770052--mark--
 {     FOR g_i = 1 TO 6                   
          CASE WHEN tm.s[g_i,g_i] = '1'
                     LET l_order[g_i] = sr.fcb03 USING 'yyyymmdd'
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.fcb04
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.faj20
               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.faj02
               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.faj08
               WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.fcc02
                                            USING '&&&&&&&&&&'
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
       LET sr.order4 = l_order[4]
       LET sr.order5 = l_order[5]
#      OUTPUT TO REPORT afar720_rep(sr.*) }
#No.FUN-770052--end--
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-770052 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
                   sr.fcc01,sr.fcc02,sr.fcc03,sr.fcc031,sr.fcc06,sr.fcc05,sr.fcc08,sr.fcc07,
                   sr.fcc19,sr.qty,sr.fcc14,sr.cost1,sr.cost2,sr.fcc15,sr.cost3,sr.faj20,l_gen02 , 
                   sr.fcb03,sr.fcb04,sr.fcb05,sr.fcb06,'',sr.faj02,sr.faj08,l_amt,l_amt3,t_azi04,t_azi05                                            
          #------------------------------ CR (3) ------------------------------#   
     END FOREACH
 
#    FINISH REPORT afar720_rep                                            #FUN-770052
#FUN-8A0055---START--
     IF g_zz05 = 'Y' THEN                                    
        CALL cl_wcchp(tm.wc,'fcb03,fcb04,faj20,faj02,faj08,fcc02')                          
           RETURNING tm.wc                                                                
     END IF   
#FUN-8A0055----END---
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)                          #FUN-770052
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-770052 **** ##                                                        
    LET l_sql = "SELECT B.fcc14a,B.fcc16,B.fcc16a,B.fcc15a,B.fcc16b,A.*",
                " FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A LEFT OUTER JOIN ",
                "   ",g_cr_db_str CLIPPED,l_table1 CLIPPED," B ON",
                "  A.fcc01=B.fcc01 AND A.fcc03=B.fcc03 AND A.fcc031=B.fcc031"                                                  
    LET g_str = ''                                                                                                                  
    LET g_str = g_azi04,";",g_azi05,";",tm.wc,";",'',";",tm.s[1,1],";",                                                          
                tm.s[2,2],";",tm.s[3,3],";",tm.s[4,4],";",tm.s[5,5],";",tm.s[6,6],";",                                                                                        
                tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",tm.t[4,4],";",tm.t[5,5],";",
                tm.v[1,1],";",tm.v[2,2],";",tm.v[3,3],";",tm.v[4,4],";",tm.v[5,5]                                     
    CALL cl_prt_cs3('afar720','afar720',l_sql,g_str)                                                                                  
    #------------------------------ CR (4) ------------------------------# 
END FUNCTION
 
{REPORT afar720_rep(sr)                                                   #FUN-770052
   DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          recno        LIKE type_file.num5,         #No.FUN-680070 SMALLINT
          rectot       LIKE type_file.num5,         #No.FUN-680070 SMALLINT
          l_count      LIKE type_file.num5,         #No.FUN-680070 SMALLINT
          l_gen02      LIKE gen_file.gen02,
          l_fcc14      LIKE fcc_file.fcc14,
          l_fcc15      LIKE fcc_file.fcc15,
          l_cost3      LIKE fcc_file.fcc16,
#          l_azi03      LIKE azi_file.azi03,        #No.CHI-6A0004 mark
#          l_azi04      LIKE azi_file.azi04,        #No.CHI-6A0004 mark
#          l_azi05      LIKE azi_file.azi05,        #No.CHI-6A0004 mark 
          l_sum1,l_sum2,l_sum3,l_amt,l_amt3 LIKE fcc_file.fcc16,
          l_str        STRING,
          sr           RECORD
                          order1 LIKE faj_file.faj08,         #No.FUN-680070 VARCHAR(10)
                          order2 LIKE faj_file.faj08,         #No.FUN-680070 VARCHAR(10)
                          order3 LIKE faj_file.faj08,         #No.FUN-680070 VARCHAR(10)
                          order4 LIKE faj_file.faj08,         #No.FUN-680070 VARCHAR(10)
                          order5 LIKE faj_file.faj08,         #No.FUN-680070 VARCHAR(10)
                          fcc01  LIKE fcc_file.fcc01,         #單號
                          fcc02  LIKE fcc_file.fcc02,         #項次
                          fcc03  LIKE fcc_file.fcc03,         #財編
                          fcc031 LIKE fcc_file.fcc031,        #附號
                          fcc04  LIKE fcc_file.fcc04,         #合併碼
                          fcc05  LIKE fcc_file.fcc05,         #中文名稱
                          fcc06  LIKE fcc_file.fcc06,         #英文名稱
                          fcc08  LIKE fcc_file.fcc08,         #廠商名稱
                          fcc09  LIKE fcc_file.fcc09,         #數量
                          fcc21  LIKE fcc_file.fcc21,         #數量
                          fcc14  LIKE fcc_file.fcc14,         #幣別
                          fcc15  LIKE fcc_file.fcc15,         #抵減率
                          fcc13  LIKE fcc_file.fcc13,         #原幣成本
                          fcc16  LIKE fcc_file.fcc16,         #本幣成本
                          fcc23  LIKE fcc_file.fcc23,         #合併前原幣
                          fcc24  LIKE fcc_file.fcc24,         #      本幣
                          fcb03  LIKE fcb_file.fcb03,         #管理局核准日
                          fcb04  LIKE fcb_file.fcb04,         #    文號
                          fcb05  LIKE fcb_file.fcb05,         #國稅局核准日
                          fcb06  LIKE fcb_file.fcb06,         #    文號
                          faj04  LIKE faj_file.faj04,         #主類別
                          faj43  LIKE faj_file.faj43,         #狀態
                          faj45  LIKE faj_file.faj45,         #帳款編號
                          faj47  LIKE faj_file.faj47,         #採購單號
                          faj49  LIKE faj_file.faj49,         #進口編號
                          faj51  LIKE faj_file.faj51,         #發票號碼
                          faj20  LIKE faj_file.faj20,
                          faj08  LIKE faj_file.faj08,
                          faj02  LIKE faj_file.faj02,
                          faj19  LIKE faj_file.faj19,
                          fcc07  LIKE fcc_file.fcc07,
                          fcc19  LIKE fcc_file.fcc19,
                          cost1  LIKE fcc_file.fcc23,
                          cost2  LIKE fcc_file.fcc24,
                          cost3  LIKE fcc_file.fcc24,
                          qty    LIKE fcc_file.fcc21
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3,sr.order4,sr.order5
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]  #No.TQC-6C0009 mark
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]  #No.TQC-6C0009
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
            g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],
            g_x[47],g_x[48],g_x[49],g_x[50]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
     IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.order2
     IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.order3
     IF tm.t[3,3] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.order4
     IF tm.t[4,4] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.order5
     IF tm.t[5,5] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   ON EVERY ROW
         LET l_gen02 = ' '
         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = sr.faj19
         IF cl_null(l_gen02) THEN LET l_gen02 = ' ' END IF
         SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05 FROM azi_file    #No.CHI-6A0004 l_azi-->t_azi
          WHERE azi01=sr.fcc14
 
         IF cl_null(recno) THEN LET recno = 1 ELSE LET recno=recno+1 END IF
         LET l_str = sr.fcc15 USING '##&','%'
         PRINT COLUMN g_c[31],sr.fcc02 USING '###&',
               COLUMN g_c[32],sr.fcc03,
               COLUMN g_c[33],sr.fcc031,
               COLUMN g_c[34],sr.fcc06,
               COLUMN g_c[35],sr.fcc05,
               COLUMN g_c[36],sr.fcc08,
               COLUMN g_c[37],sr.fcc07[1,20],
               COLUMN g_c[38],sr.fcc19,
               COLUMN g_c[39],cl_numfor(sr.qty,39,0),
               COLUMN g_c[40],sr.fcc14,
               COLUMN g_c[41],cl_numfor(sr.cost1,41,t_azi04),                   #No.CHI-6A0004 l_azi-->t_azi                   
               COLUMN g_c[42],cl_numfor(sr.cost2,42,g_azi04),
               COLUMN g_c[43],l_str,
               COLUMN g_c[44],cl_numfor(sr.cost3,44,g_azi04),
               COLUMN g_c[45],sr.faj20,
               COLUMN g_c[46],l_gen02 ,
               COLUMN g_c[47],sr.fcb03,
               COLUMN g_c[48],sr.fcb04,
               COLUMN g_c[49],sr.fcb05,
               COLUMN g_c[50],sr.fcb06
 
   AFTER GROUP OF sr.order1
     IF tm.v[1,1] = 'Y' THEN
        LET l_str = recno USING '###&',' ', g_x[11] CLIPPED
        PRINT COLUMN g_c[31],g_x[9] CLIPPED ,
              COLUMN g_c[32],l_str,
              COLUMN g_c[42],cl_numfor(GROUP SUM(sr.cost2),42,g_azi05),
              COLUMN g_c[44],cl_numfor(GROUP SUM(sr.cost3),44,g_azi05)
         IF cl_null(rectot) THEN LET rectot = 0 END IF
         LET rectot = rectot + recno
         LET recno = 0
     END IF
 
   AFTER GROUP OF sr.order2
     IF tm.v[2,2] = 'Y' THEN
        LET l_str = recno USING '###&',' ', g_x[11] CLIPPED
        PRINT COLUMN g_c[31],g_x[9] CLIPPED ,
              COLUMN g_c[32],l_str,
              COLUMN g_c[42],cl_numfor(GROUP SUM(sr.cost2),42,g_azi05),
              COLUMN g_c[44],cl_numfor(GROUP SUM(sr.cost3),44,g_azi05)
         IF cl_null(rectot) THEN LET rectot = 0 END IF
         LET rectot = rectot + recno
         LET recno = 0
     END IF
 
 
   AFTER GROUP OF sr.order3
     IF tm.v[3,3] = 'Y' THEN
        LET l_str = recno USING '###&',' ', g_x[11] CLIPPED
        PRINT COLUMN g_c[31],g_x[9] CLIPPED ,
              COLUMN g_c[32],l_str,
              COLUMN g_c[42],cl_numfor(GROUP SUM(sr.cost2),42,g_azi05),
              COLUMN g_c[44],cl_numfor(GROUP SUM(sr.cost3),44,g_azi05)
         IF cl_null(rectot) THEN LET rectot = 0 END IF
         LET rectot = rectot + recno
         LET recno = 0
     END IF
 
   AFTER GROUP OF sr.order4
     IF tm.v[4,4] = 'Y' THEN
        LET l_str = recno USING '###&',' ', g_x[11] CLIPPED
        PRINT COLUMN g_c[31],g_x[9] CLIPPED ,
              COLUMN g_c[32],l_str,
              COLUMN g_c[42],cl_numfor(GROUP SUM(sr.cost2),42,g_azi05),
              COLUMN g_c[44],cl_numfor(GROUP SUM(sr.cost3),44,g_azi05)
         IF cl_null(rectot) THEN LET rectot = 0 END IF
         LET rectot = rectot + recno
         LET recno = 0
     END IF
 
   AFTER GROUP OF sr.order5
     IF tm.v[5,5] = 'Y' THEN
        LET l_str = recno USING '###&',' ', g_x[11] CLIPPED
        PRINT COLUMN g_c[31],g_x[9] CLIPPED ,
              COLUMN g_c[32],l_str,
              COLUMN g_c[42],cl_numfor(GROUP SUM(sr.cost2),42,g_azi05),
              COLUMN g_c[44],cl_numfor(GROUP SUM(sr.cost3),44,g_azi05)
         IF cl_null(rectot) THEN LET rectot = 0 END IF
         LET rectot = rectot + recno
         LET recno = 0
     END IF
 
   ON LAST ROW
       PRINT g_dash2[1,g_len]
       PRINT COLUMN g_c[31],g_x[12] CLIPPED;
       LET l_count=0
       DECLARE r720_tot2  CURSOR FOR
          SELECT fcc14,fcc15,SUM(cost1),SUM(cost2),SUM(cost3)
            FROM r720_temp
            GROUP BY fcc15,fcc14
            ORDER BY fcc15,fcc14
        LET l_amt = 0  LET l_amt3 = 0
        FOREACH r720_tot2 INTO l_fcc14,l_fcc15,l_sum1,l_sum2,l_sum3
           LET l_count=l_count+1
           LET l_str = l_fcc15 USING '##&','%'
           PRINT COLUMN g_c[40],l_fcc14[1,4],
                 COLUMN g_c[41],cl_numfor(l_sum1,41,t_azi05),  #原幣值     #No.CHI-6A0004 l_azi-->t_azi
                 COLUMN g_c[42],cl_numfor(l_sum2,42,g_azi05),  #本幣值
                 COLUMN g_c[43],l_str,
                 COLUMN g_c[44],cl_numfor(l_sum3,44,g_azi05)  #抵減額
           #-->總計(依本幣)
           LET l_amt = l_amt + l_sum2
           LET l_amt3 = l_amt3 + l_sum3
         END FOREACH
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('r720_tot2:',SQLCA.sqlcode,1)
         END IF
         IF l_count=0 THEN PRINT ' ' END IF
         #--->列印總計
         PRINT g_dash[1,g_len]
         PRINT COLUMN g_c[31],g_x[10] CLIPPED,
               COLUMN g_c[42],cl_numfor(l_amt,42,g_azi05) CLIPPED,
               COLUMN g_c[44],cl_numfor(l_amt3,44,g_azi05) CLIPPED             #抵減額
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
       IF l_last_sw = 'n' THEN
           PRINT g_dash[1,g_len]
           PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
       ELSE
           SKIP 2 LINE
       END IF
 
END REPORT}                                                               #FUN-770052
