# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: afar920.4gl
# Descriptions...: 抵押資產明細表
# Date & Author..: 96/06/11 By STAR
# Modify.........: No.FUN-510035 05/01/24 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-550034 05/05/17 by day   單據編號加大
# Modify.........: No.MOD-610033 06/01/09 By Smapmin 增加營運中心開窗功能
# Modify.........: No.TQC-610055 06/06/27 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By Jackho  本（原）幣取位修改
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.MOD-740433 07/03/24 By rainy 會抓到非年月的資料
# Modify.........: No.CHI-890021 08/09/19 By Sarah 將畫面上年度(yy1)期別(m1)改為截止日期(date1)
# Modify.........: No.FUN-8A0059 08/10/24 By tsai_yen 轉CR報表，4fd排序由6組改成3組
# Modify.........: No.TQC-980049 09/08/06 By sherry 修正報表sql  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-BB0229 11/11/28 By Carrier 去掉"耐用年限" !=0的限制,因为类似"土地等是没有耐用年限的
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                                   # Print condition RECORD
              wc      LIKE type_file.chr1000,       # Where condition            #No.FUN-680070 VARCHAR(1000)
              more    LIKE type_file.chr1,          # Input more condition(Y/N)  #No.FUN-680070 VARCHAR(1)
             #yy1     LIKE type_file.num5,          #No.FUN-680070 SMALLINT
             #m1      LIKE type_file.num5,          #No.FUN-680070 SMALLINT
              date1   LIKE type_file.dat,           #CHI-890021 add
              s       LIKE type_file.chr8,          # Order by sequence          #No.FUN-680070 VARCHAR(7)
              t       LIKE type_file.chr6,          # Eject sw                   #No.FUN-680070 VARCHAR(6)
              v       LIKE type_file.chr6           #No.FUN-680070 VARCHAR(6)
           END RECORD,
       g_bdate        LIKE type_file.dat,           #No.FUN-680070 DATE
       g_edate        LIKE type_file.dat,           #No.FUN-680070 DATE
#      g_azi03        LIKE azi_file.azi03,          # 單價 成本小數位數
#      g_azi05        LIKE azi_file.azi05,          # 小計 總計小數位數
       m_codest       LIKE type_file.chr1000,       #No.FUN-680070 VARCHAR(34)
       g_i            LIKE type_file.num5,          #count/index for any purpose #No.FUN-680070 SMALLINT
       t4             LIKE type_file.num5           #No.FUN-680070 SMALLINT
#FUN-8A0059 START #
DEFINE  g_sql         STRING
DEFINE  g_str         STRING
DEFINE  l_table       STRING    #暫存檔
#FUN-8A0059 END #
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                                  # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
 
 
   LET g_pdate  = ARG_VAL(1)                         # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.s     = ARG_VAL(8)
   LET tm.t     = ARG_VAL(9)
   LET tm.v     = ARG_VAL(10)   #TQC-610055
  #LET tm.yy1   = ARG_VAL(11)   #CHI-890021 mark
  #LET tm.m1    = ARG_VAL(12)   #CHI-890021 mark
   LET tm.date1 = ARG_VAL(11)   #CHI-890021
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   #No.FUN-570264 ---end---
   LET g_rpt_name = ARG_VAL(15) #報表樣版名稱  #FUN-8A0059
 
 
   #FUN-8A0059 START #
   #建立CR所需的暫存檔  => 欄位別名,表格名稱,欄位名稱
   LET g_sql="faj04.faj_file.faj04"             #排序：資產類別
                ,",fcd06.fcd_file.fcd06"        #抵押文號
                ,",fce02.fce_file.fce02"        #項次
                ,",fcd05.fcd_file.fcd05"        #抵押銀行
                ,",faj06.faj_file.faj06"        #財產中文名稱
                ,",faj07.faj_file.faj07"        #財產英文名稱
                ,",fce20.fce_file.fce20"        #數量
                ,",faj13.faj_file.faj13"        #單價
                ,",fce04.fce_file.fce04"        #帳面價值
                ,",fce05.fce_file.fce05"        #抵押金額
                ,",faj30.faj_file.faj30"        #未耐用年限(月數)
                ,",faj29.faj_file.faj29"        #耐用年限(月數)
                ,",faj30_29.type_file.num20_6"      #新舊程度 faj30/faj29
                ,",fce03.fce_file.fce03"        #財產編號faj02=fce03
                ,",fce031.fce_file.fce031"      #附號faj022=fce031
                ,",fce08.fce_file.fce08"        #銀行標籤
                ,",faj05.faj_file.faj05"        #排序：資產次類別
                ,",faj47.faj_file.faj47"        #排序：採購單號
                ,",fcd09.fcd_file.fcd09"        #排序：抵押日期
                ,",fab02.fab_file.fab02"        #資產類別名稱
                ,",faj02.faj_file.faj02"        #財產編號
                ,",faj20.faj_file.faj20"        #保管部門
                ,",faj22.faj_file.faj22"        #存放營運中心
                ,",faj14.faj_file.faj14"        #本幣成本
                ,",faj141.faj_file.faj141"      #調整成本
                ,",a.type_file.num20_6"         #成本
                ,",b.type_file.num20_6"         #累計折舊
 
 
   LET l_table = cl_prt_temptable('afar920',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED
                ," VALUES(?,?,?,?,?,?,?,?,?,? ,?,?,?,?,?,?,?,?,?,?"
                       ,",?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
        CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #FUN-8A0059 END #
 
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'             # If background job sw is off
      THEN CALL afar920_tm(0,0)                     # Input print condition
      ELSE CALL afar920()                           # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION afar920_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01           #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,      #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000    #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 15
 
   OPEN WINDOW afar920_w AT p_row,p_col WITH FORM "afa/42f/afar920"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)      #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                          # Default condition
  #LET tm.yy1  = g_faa.faa07   #CHI-890021 mark
  #LET tm.m1   = g_faa.faa08   #CHI-890021 mark
   LET tm.s    = '12    '
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   #FUN-8A0059 mark START #
   #LET tm2.s4   = tm.s[4,4]
   #LET tm2.s5   = tm.s[5,5]
   #LET tm2.s6   = tm.s[6,6]
   #FUN-8A0059 mark START #
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   #FUN-8A0059 mark START #
   #LET tm2.t4   = tm.t[4,4]
   #LET tm2.t5   = tm.t[5,5]
   #LET tm2.t6   = tm.t[6,6]
   #FUN-8A0059 mark START #
   LET tm2.u1   = tm.v[1,1]
   LET tm2.u2   = tm.v[2,2]
   LET tm2.u3   = tm.v[3,3]
   #FUN-8A0059 mark START #
   #LET tm2.u4   = tm.v[4,4]
   #LET tm2.u5   = tm.v[5,5]
   #LET tm2.u6   = tm.v[6,6]
   #FUN-8A0059 mark END #
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   #FUN-8A0059 mark START #
   #IF cl_null(tm2.s4) THEN LET tm2.s4 = ""  END IF
   #IF cl_null(tm2.s5) THEN LET tm2.s5 = ""  END IF
   #IF cl_null(tm2.s6) THEN LET tm2.s6 = ""  END IF
   #FUN-8A0059 mark END #
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   #FUN-8A0059 mark START #
   #IF cl_null(tm2.t4) THEN LET tm2.t4 = "N" END IF
   #IF cl_null(tm2.t5) THEN LET tm2.t5 = "N" END IF
   #IF cl_null(tm2.t6) THEN LET tm2.t6 = "N" END IF
   #FUN-8A0059 mark END #
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
   #FUN-8A0059 mark START #
   #IF cl_null(tm2.u4) THEN LET tm2.u4 = "N" END IF
   #IF cl_null(tm2.u5) THEN LET tm2.u5 = "N" END IF
   #IF cl_null(tm2.u6) THEN LET tm2.u6 = "N" END IF
   #FUN-8A0059 mark END #
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON faj04,faj05,fcd06,fcd05,faj47,fcd09, fce02,faj20,faj22
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
         
         #-----MOD-610033---------
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(faj22)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_azp"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO faj22
                    NEXT FIELD faj22
            END CASE
         #-----END MOD-610033-----
 
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
         LET INT_FLAG = 0 CLOSE WINDOW afar920_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
 
      IF tm.wc = '1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
 
      INPUT BY NAME
           #tm.yy1,tm.m1,   #CHI-890021 mark
            tm.date1,       #CHI-890021
            #FUN-8A0059 START #
            tm2.s1,tm2.s2,tm2.s3,
            tm2.t1,tm2.t2,tm2.t3,
            tm2.u1,tm2.u2,tm2.u3,tm.more
            #FUN-8A0059 END #
            #FUN-8A0059 mark START #
            #tm2.s1,tm2.s2,tm2.s3,tm2.s4,tm2.s5,tm2.s6,
            #tm2.t1,tm2.t2,tm2.t3,tm2.t4,tm2.t5,tm2.t6,
            #tm2.u1,tm2.u2,tm2.u3,tm2.u4,tm2.u5,tm2.u6,tm.more
            #FUN-8A0059 mark END #
            WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
        #str CHI-890021 mark
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
        #end CHI-890021 mark
 
        #str CHI-890021 add
         AFTER FIELD date1
            IF cl_null(tm.date1) THEN
               NEXT FIELD date1
            END IF
        #end CHI-890021 add
 
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
            #FUN-8A0059 mark START #
            #LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1],tm2.s4[1,1],tm2.s5[1,1],tm2.s6[1,1]
            #LET tm.t = tm2.t1,tm2.t2,tm2.t3,tm2.t4,tm2.t5,tm2.t6
            #LET tm.v = tm2.u1,tm2.u2,tm2.u3,tm2.u4,tm2.u5,tm2.u6
            #FUN-8A0059 mark END #
            #FUN-8A0059 START #
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
            LET tm.t = tm2.t1,tm2.t2,tm2.t3
            LET tm.v = tm2.u1,tm2.u2,tm2.u3
            #FUN-8A0059 END #
 
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
         LET INT_FLAG = 0 CLOSE WINDOW afar920_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='afar920'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar920','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,      #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'",        #FUN-8A0059 mark
                        " '",g_rlang CLIPPED,"'",        #FUN-8A0059
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.s  CLIPPED,"'",
                        " '",tm.t  CLIPPED,"'",
                        " '",tm.v  CLIPPED,"'",
                       #" '",tm.yy1 CLIPPED,"'",       #CHI-890021 mark
                       #" '",tm.m1 CLIPPED,"'",        #CHI-890021 mark
                        " '",tm.date1 CLIPPED,"'",     #CHI-890021
                        " '",g_rep_user CLIPPED,"'",   #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",   #No.FUN-570264
                        " '",g_template CLIPPED,"'",    #No.FUN-570264
                        " '",g_rpt_name CLIPPED,"'"    #FUN-8A0059
            CALL cl_cmdat('afar920',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW afar920_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar920()
   END WHILE
 
   CLOSE WINDOW afar920_w
END FUNCTION
 
FUNCTION afar920()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0069
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                #No.FUN-680070 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680070 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680070 VARCHAR(40)
          l_year    LIKE type_file.num5,          #CHI-890021 add
          l_mon     LIKE type_file.num5,          #CHI-890021 add
          l_order   ARRAY[7] OF LIKE fcd_file.fcd06,         #No.FUN-550034        #No.FUN-680070 VARCHAR(16)
#No.FUN-550034-bigin
          sr        RECORD 
                           #FUN-8A0059 mark START #
                           #order1 LIKE fcd_file.fcd06,       #No.FUN-680070 VARCHAR(16)
                           #order2 LIKE fcd_file.fcd06,       #No.FUN-680070 VARCHAR(16)
                           #order3 LIKE fcd_file.fcd06,       #No.FUN-680070 VARCHAR(16)
                           #order4 LIKE fcd_file.fcd06,       #No.FUN-680070 VARCHAR(16)
                           #order5 LIKE fcd_file.fcd06,       #No.FUN-680070 VARCHAR(16)
                           #order6 LIKE fcd_file.fcd06,       #No.FUN-680070 VARCHAR(16)
                           #order7 LIKE fcd_file.fcd06,       #No.FUN-680070 VARCHAR(16)
                           #FUN-8A0059 mark END #
                           faj04  LIKE faj_file.faj04,        #排序：資產類別
                           fcd06  LIKE fcd_file.fcd06,        #抵押文號
                           fce02  LIKE fce_file.fce02,        #項次
                           fcd05  LIKE fcd_file.fcd05,        #抵押銀行
                           faj06  LIKE faj_file.faj06,        #財產中文名稱
                           faj07  LIKE faj_file.faj07,        #財產英文名稱
                           fce20  LIKE fce_file.fce20,        #數量
                           faj13  LIKE faj_file.faj13,        #單價
                           fce04  LIKE fce_file.fce04,        #帳面價值
                           fce05  LIKE fce_file.fce05,        #抵押金額
                           faj30  LIKE faj_file.faj30,        #未耐用年限(月數)      
                           faj29  LIKE faj_file.faj29,        #耐用年限(月數)  
                           faj30_29  LIKE type_file.num20_6,     #新舊程度 faj30/faj29    #FUN-8A0059
                           fce03  LIKE fce_file.fce03,
                           fce031 LIKE fce_file.fce031,       #附號faj022=fce031
                           fce08  LIKE fce_file.fce08,        #銀行標籤
                           faj05  LIKE faj_file.faj05,        #排序：資產次類別
                           faj47  LIKE faj_file.faj47,        #排序：採購單號
                           fcd09  LIKE fcd_file.fcd09,        #排序：抵押日期
                           fab02  LIKE fab_file.fab02,        #資產類別名稱
                           faj02  LIKE faj_file.faj02,        #財產編號
                           #faj022 LIKE faj_file.faj022,       #附號faj022=fce031       #FUN-8A0059 mark 
                           faj20  LIKE faj_file.faj20,        #保管部門
                           faj22  LIKE faj_file.faj22,        #存放營運中心
                           faj14  LIKE faj_file.faj14,        #本幣成本
                           faj141 LIKE faj_file.faj141,       #調整成本 
                           a      LIKE type_file.num20_6,            #成本       #No.FUN-680070 DEC(20,6)
                           b      LIKE type_file.num20_6            #累折       #No.FUN-680070 DEC(20,6)
                           #FUN-8A0059 mark START #
                           #c      LIKE type_file.num20_6             #帳面價值       #No.FUN-680070 DEC(20,6)
                           #FUN-8A0059 mark END #
                    END RECORD,
          l_item    LIKE type_file.num5         #No.FUN-680070 smallint
#No.FUN-550034-end
   #清除站存檔資料
   CALL cl_del_data(l_table)    #FUN-8A0059
 
   #取公司名稱
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #是否列印選擇條件
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog    #FUN-8A0059 
   
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
 
  #str CHI-890021 mark
  #CALL s_azn01(tm.yy1,tm.m1) RETURNING g_bdate,g_edate
  #LET tm.date1 = g_edate
  #end CHI-890021 mark
 
   LET l_sql =
       #FUN-8A0059 mark START #
       #"SELECT '','','','','','','',faj04,fcd06,fce02,fcd05,faj06, ",
       #"  faj07,fce20,faj13,fce04,fce05,faj30,faj29, ",
       #"  fce03,fce031,fce08,faj05,faj47,fcd09,'',faj02,faj022,",
       #"  faj20,faj22,faj14,faj141,0,0,0 ",
       #FUN-8A0059 mark END #
       #FUN-8A0059 START #
       "SELECT faj04,fcd06,fce02,fcd05,faj06"       
       #     ,",faj07,fce20,faj13,fce04,fce05,faj30,faj29,faj30/faj29 AS faj30_29"    #No.TQC-BB0229
             ,",faj07,fce20,faj13,fce04,fce05,faj30,faj29,0"                          #No.TQC-BB0229
             ,",fce03,fce031,fce08,faj05,faj47,fcd09,'',faj02"  #fab02=''
             ,",faj20,faj22,faj14,faj141,0,0",
        #FUN-8A0059 END #  
       "  FROM faj_file,fcd_file,fce_file ",
       " WHERE faj02=fce03 ",
       "  AND faj022=fce031 ",
       "  AND fcd01=fce01 ",
       "  AND (faj88 is null OR faj88 <= '",tm.date1,"')",   #表已扺押
       "  AND (faj91 is null OR faj91 >= '",tm.date1,"') ",
       "  AND fcdconf='Y' ",
      #"  AND fcd02 >='",g_bdate,"' AND fcd02 <='", g_edate,"'",  #MOD-740433 add   #CHI-890021 mark
       "  AND fcd02 <='",tm.date1,"'",                                              #CHI-890021
#      "  AND faj29 <> 0 ",  #TQC-980049 add      #No.TQC-BB0229 mark
       "  AND ",tm.wc CLIPPED
#No.CHI-6A0004--begin
#  SELECT azi03,azi04,azi05
#    INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#    FROM azi_file
#   WHERE azi01=g_aza.aza17
#No.CHI-6A0004--end
 
   PREPARE r920_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
      EXIT PROGRAM
   END IF
   DECLARE r920_curs1 CURSOR FOR r920_prepare1
 
   # 取本期的成本以及累折
   LET l_sql = " SELECT fan14 FROM fan_file ",
               "  WHERE fan01 = ? ",
               "    AND fan02 = ? ",
               "    AND fan03 = ? ",
               "    AND fan04 = ? ",
               "    AND fan041 = '1'",
               "    AND fan05 IN ('1','2')"   ##Modify:2646
 
   PREPARE afar920_prepare2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
      EXIT PROGRAM
   END IF
 
   DECLARE afar920_curs2 SCROLL CURSOR FOR afar920_prepare2
   # 取本期的累折
   LET l_sql = " SELECT SUM(fan15) FROM fan_file ",
               "  WHERE fan01 = ? ",
               "    AND fan02 = ? ",
               "    AND fan03 = ? ",
               "    AND fan04 = ? ",
               "    AND fan05 IN ('1','2')"   ##Modify:2646
 
   PREPARE afar920_prepare3 FROM l_sql
   DECLARE afar920_curs3 SCROLL CURSOR FOR afar920_prepare3
 
   #CALL cl_outnam('afar920') RETURNING l_name   #FUN-8A0059 mark
   #START REPORT r920_rep TO l_name     #FUN-8A0059 mark
 
   LET g_pageno = 0
 
   LET l_year = YEAR(tm.date1)    #CHI-890021 add
   LET l_mon  = MONTH(tm.date1)   #CHI-890021 add
   FOREACH r920_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      # 若前面user 按下 control-t 則會顯示目前做到第 n 筆
      FOR g_i = 1 TO 7
         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.faj04
              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.faj05
              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.fcd06
              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.fcd05
              WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.faj47
              WHEN tm.s[g_i,g_i] = '6'
                     LET l_order[g_i] = sr.fcd09 USING 'yyyymmdd'
              WHEN tm.s[g_i,g_i] = '7'
                         #   LET l_order[g_i] = sr.fce02
                             let l_item = sr.fce02
              WHEN tm.s[g_i,g_i] = '8' LET l_order[g_i] = sr.faj20
              WHEN tm.s[g_i,g_i] = '9' LET l_order[g_i] = sr.faj22
              OTHERWISE LET l_order[g_i] = '-'
         END CASE
      END FOR
      #FUN-8A0059 mark START #
      #LET sr.order1 = l_order[1]
      #LET sr.order2 = l_order[2]
      #LET sr.order3 = l_order[3]
      #LET sr.order4 = l_order[4]
      #LET sr.order5 = l_order[5]
      #LET sr.order6 = l_order[6]
      #LET sr.order7 = l_order[7]
      #FUN-8A0059 mark END #
      IF cl_null(sr.fce02) THEN LET sr.fce02 = 0 END IF
      IF cl_null(sr.fce20) THEN LET sr.fce20 = 0 END IF
      IF cl_null(sr.faj13) THEN LET sr.faj13 = 0 END IF
      IF cl_null(sr.fce04) THEN LET sr.fce04 = 0 END IF
      IF cl_null(sr.fce05) THEN LET sr.fce05 = 0 END IF
      IF cl_null(sr.faj30) THEN LET sr.faj30 = 0 END IF
      IF cl_null(sr.faj29) THEN LET sr.faj29 = 0 END IF
      SELECT fab02 INTO sr.fab02 FROM fab_file WHERE fab01 = sr.faj04
      #No.TQC-BB0229  --Begin
      IF sr.faj29 = 0 THEN
         LET sr.faj30_29 = 0 USING '#.##'
      ELSE
         LET sr.faj30_29 = sr.faj30/sr.faj29 USING '#.##'           #FUN-8A0059
      END IF
      #No.TQC-BB0229  --End
 
     #OPEN afar920_curs2 USING sr.faj02,sr.faj022,tm.yy1,tm.m1   #CHI-890021 mark
     #OPEN afar920_curs2 USING sr.faj02,sr.faj022,l_year,l_mon   #CHI-890021            #FUN-8A0059 mark
      OPEN afar920_curs2 USING sr.faj02,sr.fce031,l_year,l_mon   #faj022=fce031         #FUN-8A0059
      FETCH FIRST afar920_curs2 INTO sr.a
      CLOSE afar920_curs2
     #OPEN afar920_curs3 USING sr.faj02,sr.faj022,tm.yy1,tm.m1   #CHI-890021 mark
     #OPEN afar920_curs3 USING sr.faj02,sr.faj022,l_year,l_mon   #CHI-890021            #FUN-8A0059 mark
      OPEN afar920_curs3 USING sr.faj02,sr.fce031,l_year,l_mon   #faj022=fce031         #FUN-8A0059 
      FETCH FIRST afar920_curs3 INTO sr.b
      CLOSE afar920_curs3
 
       # 還沒有折舊資料
       IF cl_null(sr.a) OR cl_null(sr.b) THEN
          IF cl_null(sr.faj14) THEN LET sr.faj14 = 0 END IF
          IF cl_null(sr.faj141) THEN LET sr.faj141 = 0 END IF
          LET sr.a = sr.faj14 + sr.faj141
          LET sr.b = 0
       END IF
 
      #OUTPUT TO REPORT r920_rep(sr.*,l_item)   #FUN-8A0059 mark
      #FUN-8A0059 START #
      #將報表所需要的資料寫到暫存檔    
      EXECUTE insert_prep USING
        sr.faj04,sr.fcd06,sr.fce02,sr.fcd05,sr.faj06       
        ,sr.faj07,sr.fce20,sr.faj13,sr.fce04,sr.fce05,sr.faj30,sr.faj29,sr.faj30_29
        ,sr.fce03,sr.fce031,sr.fce08,sr.faj05,sr.faj47,sr.fcd09,sr.fab02,sr.faj02
        ,sr.faj20,sr.faj22,sr.faj14,sr.faj141,sr.a,sr.b
      #FUN-8A0059 END #
      
     END FOREACH
 
     #FINISH REPORT r920_rep    #FUN-8A0059 mark
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)       #FUN-8A0059 mark
     
   #FUN-8A0059 START #
   #準備抓取暫存檔裡資料的SQL
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   
   #欲傳到CR做排序、跳頁、小計控制的參數
   #FUN-8A0059 mark START #
   #LET g_str = tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.s[4,4],";",tm.s[5,5],";",tm.s[6,6],";"   #排序
   #            ,tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",tm.t[4,4],";",tm.t[5,5],";",tm.t[6,6],";"   #跳頁
   #            ,tm.v[1,1],";",tm.v[2,2],";",tm.v[3,3],";",tm.v[4,4],";",tm.v[5,5],";",tm.v[6,6]   #小計
   #FUN-8A0059 mark END #
   LET g_str = tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3]       #排序
          ,";",tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3]       #跳頁
          ,";",tm.v[1,1],";",tm.v[2,2],";",tm.v[3,3]       #小計
          ,";",g_azi03,";",g_azi04,";",g_azi05             #金額取位
 
   
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'faj04,faj05,fcd06,fcd05,faj47,fcd09,fce02,faj20,faj22') RETURNING tm.wc      
   ELSE
      LET tm.wc = ''
   END IF
   LET g_str = tm.wc,";",g_str
   
   #與Crystal Reports 串接(程式代號，樣版代號，抓取資料SQL，參數)
   CALL cl_prt_cs3('afar920','afar920',g_sql,g_str)
   #FUN-8A0059 END #
   
   
END FUNCTION
 
#FUN-8A0059 mark START #
#REPORT r920_rep(sr,l_item)
#  DEFINE l_last_sw    LIKE type_file.chr1,                     #No.FUN-680070 VARCHAR(1)
#         l_fce04      LIKE fce_file.fce04,
#         l_fce05      LIKE fce_file.fce05,
##No.FUN-550034-begin
#         sr           RECORD order1 LIKE fcd_file.fcd06,       #No.FUN-680070 VARCHAR(16)
#                             order2 LIKE fcd_file.fcd06,       #No.FUN-680070 VARCHAR(16)
#                             order3 LIKE fcd_file.fcd06,       #No.FUN-680070 VARCHAR(16)
#                             order4 LIKE fcd_file.fcd06,       #No.FUN-680070 VARCHAR(16)
#                             order5 LIKE fcd_file.fcd06,       #No.FUN-680070 VARCHAR(16)
#                             order6 LIKE fcd_file.fcd06,       #No.FUN-680070 VARCHAR(16)
#                             order7 LIKE fcd_file.fcd06,       #No.FUN-680070 VARCHAR(16)
#                             faj04  LIKE faj_file.faj04,
#                             fcd06  LIKE fcd_file.fcd06,
#                             fce02  LIKE fce_file.fce02,
#                             fcd05  LIKE fcd_file.fcd05,
#                             faj06  LIKE faj_file.faj06,
#                             faj07  LIKE faj_file.faj07,
#                             fce20  LIKE fce_file.fce20,
#                             faj13  LIKE faj_file.faj13,
#                             fce04  LIKE fce_file.fce04,
#                             fce05  LIKE fce_file.fce05,
#                             faj30  LIKE faj_file.faj30,
#                             faj29  LIKE faj_file.faj29,
#                             fce03  LIKE fce_file.fce03,
#                             fce031 LIKE fce_file.fce031,
#                             fce08  LIKE fce_file.fce08,
#                             faj05  LIKE faj_file.faj05,
#                             faj47  LIKE faj_file.faj47,
#                             fcd09  LIKE fcd_file.fcd09,
#                             fab02  LIKE fab_file.fab02,
#                             faj02  LIKE faj_file.faj02,
#                             faj022 LIKE faj_file.faj022,
#                             faj20  LIKE faj_file.faj20,
#                             faj22  LIKE faj_file.faj22,
#                             faj14  LIKE faj_file.faj14,
#                             faj141 LIKE faj_file.faj141,
#                             a      LIKE type_file.num20_6,            #成本       #No.FUN-680070 DEC(20,6)
#                             b      LIKE type_file.num20_6,            #累折       #No.FUN-680070 DEC(20,6)
#                             c      LIKE type_file.num20_6             #帳面價值       #No.FUN-680070 DEC(20,6)
#                       END RECORD
# define l_item LIKE type_file.num5         #No.FUN-680070 smallint
##No.FUN-550034-end
 
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.order1,sr.order2,sr.order3,sr.order4,l_item
##          sr.order5,sr.order6,sr.order7,l_item
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED, pageno_total
#     PRINT g_dash[1,g_len]
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#           g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.order1
#    IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
#  BEFORE GROUP OF sr.order2
#    IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
#  BEFORE GROUP OF sr.order3
#    IF tm.t[3,3] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
#  BEFORE GROUP OF sr.order4
#    IF tm.t[4,4] = 'Y' THEN SKIP TO TOP OF PAGE END IF
#  ON EVERY ROW
#        PRINT COLUMN g_c[31],sr.fcd06,              # 抵押文號
#              COLUMN g_c[32],sr.fce02 USING '####',
#              COLUMN g_c[33],sr.fab02[1,08],        # 資產類別
#              COLUMN g_c[34],sr.fcd05,              # 抵押銀行
#              COLUMN g_c[35],sr.faj06,
#              COLUMN g_c[36],sr.faj07,
#              COLUMN g_c[37],cl_numfor(sr.fce20,37,0),
#              COLUMN g_c[38],cl_numfor(sr.faj13,38,g_azi03),  # 單價
#              COLUMN g_c[39],cl_numfor(sr.a,39,g_azi04),      # 成本
#              COLUMN g_c[40],cl_numfor(sr.b,40,g_azi04),      # 累計折舊
#              COLUMN g_c[41],cl_numfor(sr.fce04,41,g_azi04),  # 帳面價值
#              COLUMN g_c[42],cl_numfor(sr.fce05,42,g_azi04),  # 扺押金額
#              COLUMN g_c[43],sr.faj30/sr.faj29 USING '#.##',  # 新舊程度
#              COLUMN g_c[44],sr.fce03,
#              COLUMN g_c[45],sr.fce031,
#              COLUMN g_c[46],sr.fce08[1,8]
#  AFTER GROUP OF sr.order1
#    IF tm.v[1,1] = 'Y' THEN
#       LET l_fce04 = GROUP SUM(sr.fce04)
#       LET l_fce05 = GROUP SUM(sr.fce05)
#       PRINT COLUMN g_c[31] ,g_x[9] CLIPPED,
#             COLUMN g_c[39],cl_numfor(GROUP SUM(sr.a),39,g_azi05),
#             COLUMN g_c[40],cl_numfor(GROUP SUM(sr.b),40,g_azi05),      # 累計折舊
#             COLUMN g_c[41],cl_numfor(GROUP SUM(sr.fce04),41,g_azi05),  # 帳面價值
#             COLUMN g_c[42],cl_numfor(GROUP SUM(sr.fce05),42,g_azi05)   # 扺押金額
#       SKIP 1 LINE
#    END IF
 
#  AFTER GROUP OF sr.order2
#    IF tm.v[2,2] = 'Y' THEN
#       LET l_fce04 = GROUP SUM(sr.fce04)
#       LET l_fce05 = GROUP SUM(sr.fce05)
#       PRINT COLUMN g_c[31] ,g_x[9] CLIPPED,
#             COLUMN g_c[39],cl_numfor(GROUP SUM(sr.a),39,g_azi05),
#             COLUMN g_c[40],cl_numfor(GROUP SUM(sr.b),40,g_azi05),      # 累計折舊
#             COLUMN g_c[41],cl_numfor(GROUP SUM(sr.fce04),41,g_azi05),  # 帳面價值
#             COLUMN g_c[42],cl_numfor(GROUP SUM(sr.fce05),42,g_azi05)   # 扺押金額
#       SKIP 1 LINE
#    END IF
 
#  AFTER GROUP OF sr.order3
#    IF tm.v[3,3] = 'Y' THEN
#       LET l_fce04 = GROUP SUM(sr.fce04)
#       LET l_fce05 = GROUP SUM(sr.fce05)
#       PRINT COLUMN g_c[31] ,g_x[9] CLIPPED,
#             COLUMN g_c[39],cl_numfor(GROUP SUM(sr.a),39,g_azi05),
#             COLUMN g_c[40],cl_numfor(GROUP SUM(sr.b),40,g_azi05),      # 累計折舊
#             COLUMN g_c[41],cl_numfor(GROUP SUM(sr.fce04),41,g_azi05),  # 帳面價值
#             COLUMN g_c[42],cl_numfor(GROUP SUM(sr.fce05),42,g_azi05)   # 扺押金額
#       SKIP 1 LINE
#    END IF
 
#  AFTER GROUP OF sr.order4
#    IF tm.v[4,4] = 'Y' THEN
#       LET l_fce04 = GROUP SUM(sr.fce04)
#       LET l_fce05 = GROUP SUM(sr.fce05)
#       PRINT COLUMN g_c[31] ,g_x[9] CLIPPED,
#             COLUMN g_c[39],cl_numfor(GROUP SUM(sr.a),39,g_azi05),
#             COLUMN g_c[40],cl_numfor(GROUP SUM(sr.b),40,g_azi05),      # 累計折舊
#             COLUMN g_c[41],cl_numfor(GROUP SUM(sr.fce04),41,g_azi05),  # 帳面價值
#             COLUMN g_c[42],cl_numfor(GROUP SUM(sr.fce05),42,g_azi05)   # 扺押金額
#       SKIP 1 LINE
#    END IF
 
#  #AFTER GROUP OF sr.order5
#  #  IF tm.v[5,5] = 'Y' THEN
#  #     LET l_fce04 = GROUP SUM(sr.fce04)
#  #     LET l_fce05 = GROUP SUM(sr.fce05)
#  #     PRINT COLUMN 13 ,g_x[16] CLIPPED,
#  #           COLUMN 119,cl_numfor(l_fce04,11,0),
#  #           COLUMN 129,cl_numfor(l_fce05,11,0)
#  #     SKIP 1 LINE
#  #  END IF
 
#  #AFTER GROUP OF sr.order6
#  #  IF tm.v[6,6] = 'Y' THEN
#  #     LET l_fce04 = GROUP SUM(sr.fce04)
#  #     LET l_fce05 = GROUP SUM(sr.fce05)
#  #     PRINT COLUMN 13 ,g_x[16] CLIPPED,
#  #           COLUMN 119,cl_numfor(l_fce04,11,0),
#  #           COLUMN 129,cl_numfor(l_fce05,11,0)
#  #     SKIP 1 LINE
#  #  END IF
 
#  ON LAST ROW
#     LET l_fce04 = SUM(sr.fce04)
#     LET l_fce05 = SUM(sr.fce05)
#     SKIP 1 LINE
#       PRINT COLUMN g_c[31] ,g_x[9] CLIPPED,
#             COLUMN g_c[39],cl_numfor( SUM(sr.a),39,g_azi05),
#             COLUMN g_c[40],cl_numfor( SUM(sr.b),40,g_azi05),      # 累計折舊
#             COLUMN g_c[41],cl_numfor( SUM(sr.fce04),41,g_azi05),  # 帳面價值
#             COLUMN g_c[42],cl_numfor( SUM(sr.fce05),42,g_azi05)   # 扺押金額
#     PRINT g_dash[1,g_len]
#     LET l_last_sw = 'y'
#     PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#  PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#          PRINT g_dash[1,g_len]
#          PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE
#          SKIP 2 LINE
#      END IF
 
#END REPORT
#FUN-8A0059 mark END #
