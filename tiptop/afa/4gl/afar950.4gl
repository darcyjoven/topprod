# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: afar950.4gl
# Descriptions...: 資產抵押明細彙總表
# Date & Author..: 96/06/21 By STAR
# Modify.........: tm.b 取消不用 BugNo:8850
# Modify.........: No.FUN-510035 05/01/24 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-550034 05/05/17 by day   單據編號加大
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-850010 08/05/05 By ve007 報表輸出方式 改為CR
# Modify.........: No.MOD-870236 08/07/21 By Sarah SQL需增加過濾日期的條件
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.CHI-890010 08/09/19 By Sarah 將畫面上年度(yy1)期別(m1)改為截止日期(date1)
# Modify.........: No.MOD-890233 08/09/24 By Sarah CR Temptable裡的a,b,c三個欄位改定義為type_file.num20_6
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                                  # Print condition RECORD
              wc      LIKE type_file.chr1000,      # Where condition             #No.FUN-680070 VARCHAR(1000)
              s       LIKE type_file.chr3,         #No.FUN-680070 VARCHAR(3)
              t       LIKE type_file.chr3,         #No.FUN-680070 VARCHAR(3)
              v       LIKE type_file.chr3,         #No.FUN-680070 VARCHAR(3)
             #yy1     LIKE type_file.num5,         #No.FUN-680070 SMALLINT   #CHI-890010 mark
             #m1      LIKE type_file.num5,         #No.FUN-680070 SMALLINT   #CHI-890010 mark
              date1   LIKE type_file.dat,          #CHI-890010 add
              a       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
         #    b       LIKE type_file.chr1,         #No:8850                      #No.FUN-680070 VARCHAR(1)
              more    LIKE type_file.chr1          # Input more condition(Y/N)   #No.FUN-680070 VARCHAR(1)
           END RECORD,
       g_fap660       LIKE fap_file.fap66,
       g_fap662       LIKE fap_file.fap66,
       g_fap67        LIKE fap_file.fap67,
       g_fap670       LIKE fap_file.fap67,
       g_fap54        LIKE fap_file.fap54,
       g_fap56        LIKE fap_file.fap56,
       g_fap57        LIKE fap_file.fap57,
       g_fap661       LIKE fap_file.fap661,
       g_fap570       LIKE fap_file.fap57,
       g_bdate        LIKE type_file.dat,          #No.FUN-680070 DATE
       g_edate        LIKE type_file.dat          #No.FUN-680070 DATE
 
DEFINE g_i            LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE l_table        STRING,                           #No.FUN-850010
       g_sql          STRING,                           #No.FUN-850010
       g_str          STRING                            #No.FUN-850010
 
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
   #No.FUN-850010--begin--
   LET g_sql = "faj02.faj_file.faj02,  faj022.faj_file.faj022,",
               "faj04.faj_file.faj04,  faj14.faj_file.faj14,",
               "faj141.faj_file.faj141,faj32.faj_file.faj32,",
               "faj59.faj_file.faj59,  faj60.faj_file.faj60,",
               "faj88.faj_file.faj88,  faj89.faj_file.faj89,",
               "faj90.faj_file.faj90,  faj91.faj_file.faj91,",
               "faj47.faj_file.faj47,  fab02.fab_file.fab02,",
              #str MOD-890233 mod
              #"a.fan_file.fan14,      b.fan_file.fan15,",
              #"c.type_file.num5,      fce05.fce_file.fce05,",
               "a.type_file.num20_6,   b.type_file.num20_6,",
               "c.type_file.num20_6,   fce05.fce_file.fce05,",
              #end MOD-890233 mod
               "fcd06.fcd_file.fcd06,  fcd05.fcd_file.fcd05"
   LET l_table = cl_prt_temptable('afar950',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?) "                                                                               
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                        
   #No.FUN-850010--end--
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s      = ARG_VAL(8)
   LET tm.t      = ARG_VAL(9)
   LET tm.v      = ARG_VAL(10)
  #LET tm.yy1    = ARG_VAL(11)   #CHI-890010 mark
  #LET tm.m1     = ARG_VAL(12)   #CHI-890010 mark
   LET tm.date1  = ARG_VAL(11)   #CHI-890010
   LET tm.a      = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   #No.FUN-570264 ---end---
  #LET tm.b      = ARG_VAL(13)  #No:8850
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL afar950_tm(0,0)        # Input print condition
      ELSE CALL afar950()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
   
END MAIN
 
FUNCTION afar950_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 15
 
   OPEN WINDOW afar950_w AT p_row,p_col WITH FORM "afa/42f/afar950"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= '1'
   LET tm.s    = '421'
  #LET tm.yy1  = g_faa.faa07    #CHI-890010 mark 
  #LET tm.m1   = g_faa.faa08    #CHI-890010 mark
   LET tm.a    = '1'
  #LET tm.b    = 'Y'   #No:8850
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.u1   = tm.v[1,1]
   LET tm2.u2   = tm.v[2,2]
   LET tm2.u3   = tm.v[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON faj04,fcd06,faj47,fcd05
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
         LET INT_FLAG = 0 CLOSE WINDOW afar950_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
 
      INPUT BY NAME
         tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,tm2.u1,tm2.u2,tm2.u3,
        #tm.yy1,tm.m1,tm.a,tm.more   #No:8850   #CHI-890010 mark
         tm.date1,tm.a,tm.more   #No:8850       #CHI-890010
         WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
        #str CHI-890010 mark
        #AFTER FIELD yy1
        #   IF cl_null(tm.yy1) THEN
        #      NEXT FIELD yy1
        #   END IF
        #
        #AFTER FIELD m1
        #  #No.TQC-720032 -- begin --
        #   IF NOT cl_null(tm.m1) THEN
        #      SELECT azm02 INTO g_azm.azm02 FROM azm_file
        #        WHERE azm01 = tm.yy1
        #      IF g_azm.azm02 = 1 THEN
        #         IF tm.m1 > 12 OR tm.m1 < 1 THEN
        #            CALL cl_err('','agl-020',0)
        #            NEXT FIELD m1
        #         END IF
        #      ELSE
        #         IF tm.m1 > 13 OR tm.m1 < 1 THEN
        #            CALL cl_err('','agl-020',0)
        #            NEXT FIELD m1
        #         END IF
        #      END IF
        #   END IF
        #  #No.TQC-720032 -- end --
        #   IF cl_null(tm.m1) THEN
        #      NEXT FIELD m1
        #   END IF
        #end CHI-890010 mark
 
        #str CHI-890010 add
         AFTER FIELD date1
            IF cl_null(tm.date1) THEN
               NEXT FIELD date1
            END IF
        #end CHI-890010 add
 
         AFTER FIELD a
            IF cl_null(tm.a) OR tm.a NOT MATCHES '[1-2]' THEN
               NEXT FIELD a
            END IF
 {--No:8850
         AFTER FIELD b
            IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN
               NEXT FIELD b
            END IF
---}
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
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
            LET tm.t = tm2.t1,tm2.t2,tm2.t3
            LET tm.v = tm2.u1,tm2.u2,tm2.u3
 
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
         LET INT_FLAG = 0 CLOSE WINDOW afar950_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='afar950'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar950','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,      #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_lang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.s  CLIPPED,"'",
                        " '",tm.t  CLIPPED,"'",
                        " '",tm.v  CLIPPED,"'",
                       #" '",tm.yy1 CLIPPED,"'",       #CHI-890010 mark
                       #" '",tm.m1  CLIPPED,"'",       #CHI-890010 mark
                        " '",tm.date1 CLIPPED,"'",     #CHI-890010
                        " '",tm.a   CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",   #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",   #No.FUN-570264
                        " '",g_template CLIPPED,"'"    #No.FUN-570264
            CALL cl_cmdat('afar950',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW afar950_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar950()
   END WHILE
 
   CLOSE WINDOW afar950_w
END FUNCTION
 
FUNCTION afar950()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name      #No.FUN-680070 VARCHAR(20)
#         l_time    LIKE type_file.chr8           #No.FUN-6A0069
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT               #No.FUN-680070 VARCHAR(1000)
          l_sql1    LIKE type_file.chr1000,       #No.FUN-680070 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680070 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680070 VARCHAR(40)
          l_order   ARRAY[3] OF LIKE fcd_file.fcd06, #No.FUN-550034           #No.FUN-680070 VARCHAR(16)
          l_year    LIKE type_file.num5,             #CHI-890010 add
          l_mon     LIKE type_file.num5,             #CHI-890010 add
          l_fan07   LIKE fan_file.fan07,
#No.FUN-550034-begin
          sr        RECORD order1 LIKE fcd_file.fcd06,   #No.FUN-680070 VARCHAR(16)
                           order2 LIKE fcd_file.fcd06,   #No.FUN-680070 VARCHAR(16)
                           order3 LIKE fcd_file.fcd06,   #No.FUN-680070 VARCHAR(16)
                           order4 LIKE fcd_file.fcd06,   #No.FUN-680070 VARCHAR(16)
                           faj02  LIKE faj_file.faj02,   #財編
                           faj022 LIKE faj_file.faj022,  #附號
                           faj04  LIKE faj_file.faj04,   #主類別
                           faj14  LIKE faj_file.faj14,   #成本
                           faj141 LIKE faj_file.faj141,  #調整成本
                           faj32  LIKE faj_file.faj32,   #累折
                           faj59  LIKE faj_file.faj59,   #銷帳成本
                           faj60  LIKE faj_file.faj60,   #銷帳累折
                           faj88  LIKE faj_file.faj88,   #抵押日期
                           faj89  LIKE faj_file.faj89,   #抵押文號
                           faj90  LIKE faj_file.faj90,   #抵押銀行
                           faj91  LIKE faj_file.faj91,   #解除日期
                           faj47  LIKE faj_file.faj47,   #採購單號
                           fab02  LIKE fab_file.fab02,   #名稱
                           a      LIKE type_file.num20_6,            #成本       #No.FUN-680070 DEC(20,6)
                           b      LIKE type_file.num20_6,            #累折       #No.FUN-680070 DEC(20,6)
                           c      LIKE type_file.num20_6,            #帳面價值       #No.FUN-680070 DEC(20,6)
                           fce05  LIKE fce_file.fce05    #扺押金額
                    END RECORD,
          l_fcd06   LIKE fcd_file.fcd06,
          l_fcd05   LIKE fcd_file.fcd05
#No.FUN-550034-end
     
   CALL cl_del_data(l_table)                         #No.FUN-850010
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog     #No.FUN-850010
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
  #str CHI-890010 mark
  #CALL s_azn01(tm.yy1,tm.m1) RETURNING g_bdate,g_edate
  #LET tm.date1 = g_edate
  #end CHI-890010 mark
 
   #====>資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND fajuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND fajgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN              #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND fajgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup')
   #End:FUN-980030
 
   LET l_sql = "SELECT '','','','',",
               " faj02, faj022, faj04, faj14, faj141, ",
               " faj32, faj59, faj60, faj88, faj89,",
               " faj90, faj91, faj47, fab02, 0,0,fce04,fce05, fcd06,fcd05 ",
               " FROM fcd_file,fce_file,faj_file,OUTER fab_file ",
               " WHERE fcd01 = fce01 ",
               "   AND fcdconf !='X' ",   #010803 增
              #"   AND fcd02 >='",g_bdate,"' AND fcd02 <='",g_edate,"'",   #MOD-870236 add   #CHI-890010 mark
               "   AND fcd02 <='",tm.date1,"'",                                              #CHI-890010
               "   AND fce03 = faj02 AND fce031 = faj022 ",
               "   AND faj_file.faj04=fab_file.fab01 AND fajconf = 'Y' ",
               "   AND ",tm.wc CLIPPED
   CASE
       WHEN tm.a = '1'     #  已抵押
            LET l_sql= l_sql clipped,
               "   AND faj88 <= '",tm.date1,"'",
               "   AND ( faj91 is null OR faj91 >= '",tm.date1,"') ",
                  " and fcdconf='Y' "
       WHEN tm.a = '2'     #  未抵押
            LET l_sql= l_sql clipped,
               "   AND NOT (faj88 <= '",tm.date1,"'",
               "   AND ( faj91 is null OR faj91 >= '",tm.date1,"')) "
       OTHERWISE EXIT CASE
   END CASE
 
   PREPARE afar950_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
      EXIT PROGRAM
   END IF
   DECLARE afar950_curs1 CURSOR FOR afar950_prepare1
 
   # 取本期的成本以及累折
   LET l_sql = " SELECT fan14 FROM fan_file ",
               "  WHERE fan01 = ? ",
               "    AND fan02 = ? ",
               "    AND fan03 = ? ",
               "    AND fan04 = ? ",
               "    AND fan041 = '1'"
 
   PREPARE afar950_prepare2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
      EXIT PROGRAM
   END IF
   DECLARE afar950_curs2 SCROLL CURSOR FOR afar950_prepare2
   # 取本期的成本以及累折
   LET l_sql = " SELECT SUM(fan15) FROM fan_file ",
               "  WHERE fan01 = ? ",
               "    AND fan02 = ? ",
               "    AND fan03 = ? ",
               "    AND fan04 = ? "
 
   PREPARE afar950_prepare3 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
      EXIT PROGRAM
   END IF
   DECLARE afar950_curs3 SCROLL CURSOR FOR afar950_prepare3
 
  #CALL cl_outnam('afar950') RETURNING l_name
 
  #START REPORT afar950_rep TO l_name            #No.FUN-850010--mark--
  #LET g_pageno = 0                              #No.FUN-850010--mark--
 
   LET l_year = YEAR(tm.date1)    #CHI-890010 add
   LET l_mon  = MONTH(tm.date1)   #CHI-890010 add
   FOREACH afar950_curs1 INTO sr.*,l_fcd06,l_fcd05
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      # 若前面user 按下 control-t 則會顯示目前做到第 n 筆
      FOR g_i = 1 TO 3
         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.faj04
              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = l_fcd06
              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = l_fcd05
              OTHERWISE LET l_order[g_i] = '-'
         END CASE
      END FOR
 
     #--No:8850
     #IF tm.b ="Y" THEN
     #   #---- jeffery add for special case on 86/04/08 ----#
     #   CASE
     #      WHEN sr.faj47[1,1] MATCHES "[WFwf]"
     #           LET sr.order4= "1","PHASE I"
     #      WHEN sr.faj47[1,1] MATCHES "[Pp]"
     #           LET sr.order4= "2","PHASE II"
     #      WHEN sr.faj47[1,1] MATCHES "[Gg]"
     #           LET sr.order4= "3","８ Inches"
     #      OTHERWISE
     #           LET sr.order4= "4","Normal "
     #   END CASE
     #ELSE
     #   LET sr.order4=' '
     #END IF
 
     #LET sr.order1 = l_order[1]
     #LET sr.order2 = l_order[2]
     #LET sr.order3 = l_order[3]   #No.FUN-850010 --mark--
 
     #OPEN afar950_curs2 USING sr.faj02,sr.faj022,tm.yy1,tm.m1   #CHI-890010 mark
      OPEN afar950_curs2 USING sr.faj02,sr.faj022,l_year,l_mon   #CHI-890010
      FETCH FIRST afar950_curs2 INTO sr.a
      CLOSE afar950_curs2
     #OPEN afar950_curs3 USING sr.faj02,sr.faj022,tm.yy1,tm.m1   #CHI-890010 mark
      OPEN afar950_curs3 USING sr.faj02,sr.faj022,l_year,l_mon   #CHI-890010
      FETCH FIRST afar950_curs3 INTO sr.b
      CLOSE afar950_curs3
 
      # 還沒有折舊資料
      IF cl_null(sr.a) OR cl_null(sr.b) THEN
         IF cl_null(sr.faj14) THEN LET sr.faj14 = 0 END IF
         IF cl_null(sr.faj141) THEN LET sr.faj141 = 0 END IF
         LET sr.a = sr.faj14 + sr.faj141
         LET sr.b = 0
      END IF
 
#     OUTPUT TO REPORT afar950_rep(sr.*,l_fcd06,l_fcd05)   #No.FUN-850010
      #No.FUN-850010 --BEGIN--
      EXECUTE insert_prep USING
         sr.faj02,sr.faj022,sr.faj04,sr.faj14,sr.faj141,
         sr.faj32,sr.faj59, sr.faj60,sr.faj88,sr.faj89,
         sr.faj90,sr.faj91, sr.faj47,sr.fab02,sr.a,
         sr.b,    sr.c,     sr.fce05,l_fcd06, l_fcd05
      #No.FUN-850010  -END-- 
   END FOREACH
   #No.FUn-850010 --begin--
   IF g_zz05 = 'Y' THEN                                                                                                          
       CALL cl_wcchp(tm.wc,'faj04,fcd06,faj47,fcd05')                                                                       
            RETURNING tm.wc    
   END IF
   LET g_str=tm.wc ,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t[1,1],";",
                        tm.t[2,2],";",tm.t[3,3],";",tm.v[1,1],";",tm.v[2,2],";",
                       #tm.v[3,3],";",tm.yy1,";",tm.m1,";",g_azi05   #CHI-890010 mark
                        tm.v[3,3],";",tm.date1,";;",g_azi05          #CHI-890010
                                   
                                                                  
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
                                                    
   CALL cl_prt_cs3('afar950','afar950',l_sql,g_str)
 # FINISH REPORT afar950_rep
 
 # CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 #No.FUN-850010 --end--
END FUNCTION
#No,FUN-580010--begin--
{
REPORT afar950_rep(sr,l_fcd06,l_fcd05)
   DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          a            LIKE type_file.num20_6,      #No.FUN-680070 DEC(20,6)
          b            LIKE type_file.num20_6,      #No.FUN-680070 DEC(20,6)
          c            LIKE type_file.num20_6,      #No.FUN-680070 DEC(20,6)
          d            LIKE type_file.num20_6,      #No.FUN-680070 DEC(20,6)
          e            LIKE type_file.num20_6,      #No.FUN-680070 DEC(20,6)
          l_str        STRING,
#No.FUN-550034-begin
          sr           RECORD order1 LIKE fcd_file.fcd06,   #No.FUN-680070 VARCHAR(16)
                              order2 LIKE fcd_file.fcd06,   #No.FUN-680070 VARCHAR(16)
                              order3 LIKE fcd_file.fcd06,   #No.FUN-680070 VARCHAR(16)
                              order4 LIKE fcd_file.fcd06,   #No.FUN-680070 VARCHAR(16)
                              faj02  LIKE faj_file.faj02,   #財編
                              faj022 LIKE faj_file.faj022,  #附號
                              faj04  LIKE faj_file.faj04,   #主類別
                              faj14  LIKE faj_file.faj14,   #成本
                              faj141 LIKE faj_file.faj141,  #調整成本
                              faj32  LIKE faj_file.faj32,   #累折
                              faj59  LIKE faj_file.faj59,   #銷帳成本
                              faj60  LIKE faj_file.faj60,   #銷帳累折
                              faj88  LIKE faj_file.faj88,   #抵押日期
                              faj89  LIKE faj_file.faj89,   #抵押文號
                              faj90  LIKE faj_file.faj90,   #抵押銀行
                              faj91  LIKE faj_file.faj91,   #解除日期
                              faj47  LIKE faj_file.faj47,   #採購單號
                              fab02  LIKE fab_file.fab02,   #名稱
                              a      LIKE type_file.num20_6,#成本           #No.FUN-680070 DEC(20,6)
                              b      LIKE type_file.num20_6,#累折           #No.FUN-680070 DEC(20,6)
                              c      LIKE type_file.num20_6,#帳面價值       #No.FUN-680070 DEC(20,6)
                              fce05  LIKE fce_file.fce05    #扺押金額
                        END RECORD
          define l_fcd06 LIKE type_file.chr20               #No.FUN-680070 VARCHAR(20)
          define l_fcd05 LIKE type_file.chr20               #No.FUN-680070 VARCHAR(10)
          define l_date  LIKE type_file.chr20               #No.FUN-680070 VARCHAR(20)
#No.FUN-550034-end
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3,sr.order4
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      LET l_date =tm.yy1,g_x[11],tm.m1 using "<<<<",g_x[12]
      PRINT l_date
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
     IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
   BEFORE GROUP OF sr.order2
     IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
   BEFORE GROUP OF sr.order3
     IF tm.t[3,3] = 'Y' THEN SKIP TO TOP OF PAGE END IF
   AFTER GROUP OF sr.order1
     IF tm.v[1,1] = 'Y' THEN
        LET a = GROUP SUM(sr.a)
        LET b = GROUP SUM(sr.b)
        LET c = GROUP SUM(sr.c)
        LET d = GROUP SUM(sr.fce05)
        PRINT COLUMN g_c[31],g_x[9] CLIPPED,
              COLUMN g_c[34],cl_numfor(a,34,g_azi05),            #成本
              COLUMN g_c[35],cl_numfor(b,35,g_azi05),            #累折
              COLUMN g_c[36],cl_numfor(c,36,g_azi05),            #帳面價值
              COLUMN g_c[37],cl_numfor(d,37,g_azi05)             #扺押價值
        SKIP 1 LINE
     END IF
 
   AFTER GROUP OF sr.order2
     IF tm.v[2,2] = 'Y' THEN
        LET a = GROUP SUM(sr.a)
        LET b = GROUP SUM(sr.b)
        LET c = GROUP SUM(sr.c)
        LET d = GROUP SUM(sr.fce05)
        PRINT COLUMN g_c[31],g_x[9] CLIPPED,
              COLUMN g_c[34],cl_numfor(a,34,g_azi05),            #成本
              COLUMN g_c[35],cl_numfor(b,35,g_azi05),            #累折
              COLUMN g_c[36],cl_numfor(c,36,g_azi05),            #帳面價值
              COLUMN g_c[37],cl_numfor(d,37,g_azi05)             #扺押價值
        SKIP 1 LINE
     END IF
 
   AFTER GROUP OF sr.order4
     LET a = GROUP SUM(sr.a)
     LET b = GROUP SUM(sr.b)
     LET c = GROUP SUM(sr.c)
     LET d = GROUP SUM(sr.fce05)
     LET l_str = sr.fab02[1,8],sr.order4[2,10]
     PRINT COLUMN g_c[31],l_fcd05[1,10] ,
           COLUMN g_c[32],l_fcd06,
           COLUMN g_c[33],l_str,
           COLUMN g_c[34],cl_numfor(a,34,g_azi05),         #成本
           COLUMN g_c[35],cl_numfor(b,35,g_azi05),         #累折
           COLUMN g_c[36],cl_numfor(c,36,g_azi05),         #帳面價值
           COLUMN g_c[37],cl_numfor(d,37,g_azi05)          #扺押價值
 
   ON LAST ROW
      LET a = SUM(sr.a)
      LET b = SUM(sr.b)
      LET c = SUM(sr.c)
      LET d = SUM(sr.fce05)
      PRINT COLUMN g_c[31],g_x[10] CLIPPED,
            COLUMN g_c[34],cl_numfor(a,34,g_azi05),         #成本
            COLUMN g_c[35],cl_numfor(b,35,g_azi05),         #累折
            COLUMN g_c[36],cl_numfor(c,36,g_azi05),         #帳面價值
            COLUMN g_c[37],cl_numfor(d,37,g_azi05)          #扺押價值
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
END REPORT
}
#No.FUN-580010--end--
 
#FUN-870144
