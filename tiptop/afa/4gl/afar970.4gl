# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: afar970.4gl
# Descriptions...: 資產抵押工作底稿
# Date & Author..: 96/06/21 By Danny
# Modify.........: No.FUN-510035 05/01/24 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-850024 08/05/06 By Cockroach 報表轉CR
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80054 11/08/04 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,   # Where condition       #No.FUN-680070 VARCHAR(1000)
              a       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
              yy1     LIKE type_file.num5,         #No.FUN-680070 SMALLINT
              m1      LIKE type_file.num5,         #No.FUN-680070 SMALLINT
              more    LIKE type_file.chr1         # Input more condition(Y/N)       #No.FUN-680070 VARCHAR(1)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
#No.FUN-850024  --ADD START--
DEFINE   g_sql           STRING
DEFINE   g_str           STRING
DEFINE   l_table         STRING 
#No.FUN-850024  --ADD END--
 
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
 
#No.FUN-850024 --ADD START--  
 LET g_sql =        "fce01.fce_file.fce01,",
                    "fce02.fce_file.fce02,",
                    "faj02.faj_file.faj02,",
                    "faj022.faj_file.faj022,",
                    "faj06.faj_file.faj06,",
                    "fce11.fce_file.fce11,",
                    "fce12.fce_file.fce12,",
                    "faj14.faj_file.faj14,",
                    "faj141.faj_file.faj141,",
                    "a.faj_file.faj14,", 
                    "b.fce_file.fce09,", 
                    "fce10.fce_file.fce10,",
                    "fce20.fce_file.fce20,",
                    "fce21.fce_file.fce21,",
                    "fce04.fce_file.fce04,",
                    "fce05.fce_file.fce05,",
                    "fce06.fce_file.fce06,",
                    "fce07.fce_file.fce07,",
                    "faj47.faj_file.faj47,",
                    "faj21.faj_file.faj21,",             
                    "faj26.faj_file.faj26 " 
                       
   LET l_table = cl_prt_temptable('afar970',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF   
#No.FUN-850024 --ADD END--
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
 
 
   LET g_pdate  = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.a     = ARG_VAL(8)
   LET tm.yy1    = ARG_VAL(9)
   LET tm.m1     = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL afar970_tm(0,0)        # Input print condition
      ELSE CALL afar970()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION afar970_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 5 LET p_col = 16
 
   OPEN WINDOW afar970_w AT p_row,p_col WITH FORM "afa/42f/afar970"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a  = '1'
   LET tm.more = 'N'
   LET tm.yy1=g_faa.faa07
   LET tm.m1 = g_faa.faa08
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON fcd01,fcd02
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
         LET INT_FLAG = 0 CLOSE WINDOW afar970_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc = '1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.a,tm.yy1,tm.m1,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD yy1
            IF cl_null(tm.yy1) THEN
               NEXT FIELD yy1
            END IF
         AFTER FIELD m1
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy1
            IF g_azm.azm02 = 1 THEN
               IF tm.m1 > 12 OR tm.m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            ELSE
               IF tm.m1 > 13 OR tm.m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
            IF cl_null(tm.m1) THEN
               NEXT FIELD m1
            END IF
         AFTER FIELD a
            IF cl_null(tm.a) OR tm.a NOT MATCHES '[12]' THEN
               NEXT FIELD a
            END IF
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
         LET INT_FLAG = 0 CLOSE WINDOW afar970_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='afar970'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar970','9031',1)
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
                            " '",tm.a  CLIPPED,"'",
                            " '",tm.yy1 CLIPPED,"'",
                            " '",tm.m1  CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('afar970',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW afar970_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar970()
   END WHILE
 
   CLOSE WINDOW afar970_w
END FUNCTION
 
FUNCTION afar970()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0069
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT       #No.FUN-680070 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(40)
          g_bdate   LIKE type_file.dat,          #No.FUN-680070 DATE
          g_edate   LIKE type_file.dat,          #No.FUN-680070 DATE
          sr        RECORD
                    fce01   LIKE fce_file.fce01,
                    fce02   LIKE fce_file.fce02,
                    faj02   LIKE faj_file.faj02,
                    faj022  LIKE faj_file.faj022,
                    faj06   LIKE faj_file.faj06,
                    fce11   LIKE fce_file.fce11,
                    fce12   LIKE fce_file.fce12,
                    faj14   LIKE faj_file.faj14,
                    faj141  LIKE faj_file.faj141,
                    a       LIKE faj_file.faj14,  #成本
                    b       LIKE fce_file.fce09,  #累積折舊
                    fce10   LIKE fce_file.fce10,
                    fce20   LIKE fce_file.fce20,
                    fce21   LIKE fce_file.fce21,
                    fce04   LIKE fce_file.fce04,
                    fce05   LIKE fce_file.fce05,
                    fce06   LIKE fce_file.fce06,
                    fce07   LIKE fce_file.fce07,
                    faj47   LIKE faj_file.faj47,
                    faj21   LIKE faj_file.faj21
                    END RECORD
        define l_tot_amt,l_curr_d like faj_file.faj14
        define l_faj26 like faj_file.faj26
        define l_faj25 like faj_file.faj25
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     CALL s_azn01(tm.yy1,tm.m1) RETURNING g_bdate,g_edate
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #        LET tm.wc = tm.wc CLIPPED," AND fcduser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #        LET tm.wc = tm.wc CLIPPED," AND fcdgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #        LET tm.wc = tm.wc CLIPPED," AND fcdgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fcduser', 'fcdgrup')
     #End:FUN-980030
 
#No.FUN-850024  --ADD START--
     CALL cl_del_data(l_table)
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"                                                                                                         
     PREPARE insert_prep FROM g_sql                                                                                                  
     IF STATUS THEN                                                                                                                   
        CALL cl_err('insert_prep:',status,1)                                                                                        
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80054--add--
        EXIT PROGRAM                                                                                                                 
     END IF     
#No.FUN-850024  --ADD END--
 
 # 明細
  IF tm.a ='1' THEN
     LET l_sql = "SELECT fce01,fce02,faj02,faj022,faj06,fce11,fce12, ",
                 " faj14,faj141,0 ,0 ,fce10,fce20,fce21,fce04,fce05,fce06,",
                 " fce07,faj47,faj21,faj26 ",
                 "  FROM fcd_file,fce_file, faj_file ",
                 " WHERE fcd01 = fce01 ",
                 "   AND fce03 = faj02 AND fce031 = faj022 ",
                 "   AND ",tm.wc CLIPPED
 # 彙總
  ELSE
     LET l_sql = "SELECT fce01,fce02,faj02,faj022,faj06,fce11,fce12, ",
                 "  faj14,faj141,   0,",
             #----- 暫時為了聯貸案作的---#
                 "     0,fce10,fce20,fce21,fce04,fce05,fce06,fce07,",
                 " faj47,faj21,faj26 ",
                 "  FROM fcd_file,fce_file,faj_file ",
                 " WHERE fcd01 = fce01 ",
                 "   AND fce03 = faj02 AND fce031 = faj022 ",
                 "   AND ( fce06 = ' ' or fce06 is null) ",
                 "   AND ",tm.wc CLIPPED
  END IF
  # 表已扺押
              LET l_sql= l_sql clipped,
                 "   AND faj88 <= '",g_edate,"'",
                 "   AND ( faj91 is null OR faj91 >= '",g_edate,"') ",
                    " and fcdconf='Y' "
 
     PREPARE afar970_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE afar970_curs1 CURSOR FOR afar970_prepare1
 
     # 取本期的成本以及累折
     LET l_sql = " SELECT fan14 FROM fan_file ",
                 "  WHERE fan01 = ? ",
                 "    AND fan02 = ? ",
                 "    AND fan03 = ? ",
                 "    AND fan04 = ? ",
                 "    AND fan041 = '1'",
##Modify:2665
                 "    AND fan05 IN ('1','2')"
 
     PREPARE afar970_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE afar970_curs2 SCROLL CURSOR FOR afar970_prepare2
     # 取本期的成本以及累折
     LET l_sql = " SELECT SUM(fan15) FROM fan_file ",
                 "  WHERE fan01 = ? ",
                 "    AND fan02 = ? ",
                 "    AND fan03 = ? ",
                 "    AND fan04 = ? ",
##Modify:2665
                 "    AND fan05 IN ('1','2')"
 
     PREPARE afar970_prepare3 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE afar970_curs3 SCROLL CURSOR FOR afar970_prepare3
 
#     CALL cl_outnam('afar970') RETURNING l_name          #No.FUN-850024 --MARK--
#     START REPORT afar970_rep TO l_name                  #No.FUN-850024 --MARK--
     LET g_pageno = 0
 
     FOREACH afar970_curs1 INTO sr.*,l_faj26    #No.FUN-850024 --MARK-- ,l_faj25
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       # 若前面user 按下 control-t 則會顯示目前做到第 n 筆
 
       OPEN afar970_curs2 USING sr.faj02,sr.faj022,tm.yy1,tm.m1
       FETCH FIRST afar970_curs2 INTO sr.a
       CLOSE afar970_curs2
       OPEN afar970_curs3 USING sr.faj02,sr.faj022,tm.yy1,tm.m1
       FETCH FIRST afar970_curs3 INTO sr.b
       CLOSE afar970_curs3
 
       # 還沒有折舊資料
       IF cl_null(sr.a) OR cl_null(sr.b) THEN
          IF cl_null(sr.faj14) THEN LET sr.faj14 = 0 END IF
          IF cl_null(sr.faj141) THEN LET sr.faj141 = 0 END IF
          LET sr.a = sr.faj14 + sr.faj141
          LET sr.b = 0
       END IF
 
     { if l_faj26 >="96/10/01"
          then let l_faj26="96/09/30"
       end if }
#       OUTPUT TO REPORT afar970_rep(sr.*,l_faj26)   #No.FUN-850024 --MARK--
#No.FUN-850024 --ADD START--
      EXECUTE   insert_prep  USING
      sr.fce01,sr.fce02,sr.faj02,sr.faj022,sr.faj06,sr.fce11,sr.fce12,
      sr.faj14,sr.faj141,sr.a,sr.b,sr.fce10,sr.fce20,sr.fce21,sr.fce04,
      sr.fce05,sr.fce06,sr.fce07,sr.faj47,sr.faj21,l_faj26   
#No.FUN-850024  --ADD END--            
 
     END FOREACH
 
#     FINISH REPORT afar970_rep                      #No.FUN-850024 --MARK--   
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)    #No.FUN-850024 --MARK--   
#No.FUN-850024 --ADD START--
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ''
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
   IF g_zz05 = 'Y' THEN                                                                                                            
      CALL cl_wcchp(tm.wc,'fcd01,fcd02')                                                                                           
           RETURNING tm.wc                                                                                                         
      LET g_str = tm.wc                                                                                                            
   END IF
   LET g_str = g_str,";",tm.a,";",g_azi04,";",g_azi05,";",tm.yy1,";",tm.m1
   CALL cl_prt_cs3('afar970','afar970',l_sql,g_str)        
#No.FUN-850024  --ADD END--
END FUNCTION
 
#No.FUN-850024 --MARK START --   
#REPORT afar970_rep(sr,p_faj26)
#  DEFINE l_last_sw LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
#         l_tot1    LIKE fce_file.fce09,
#         l_tot2    LIKE fce_file.fce09,
#         l_tot3    LIKE faj_file.faj14,
#         l_tot4    LIKE faj_file.faj32,
#         str       STRING,
#         sr        RECORD
#                   fce01   LIKE fce_file.fce01,
#                   fce02   LIKE fce_file.fce02,
#                   faj02   LIKE faj_file.faj02,
#                   faj022  LIKE faj_file.faj022,
#                   faj06   LIKE faj_file.faj06,
#                   fce11   LIKE fce_file.fce11,
#                   fce12   LIKE fce_file.fce12,
#                   faj14   LIKE faj_file.faj14,
#                   faj141  LIKE faj_file.faj141,
#                   a       LIKE faj_file.faj14,  #成本
#                   b       LIKE fce_file.fce09,  #累積折舊
#                   fce10   LIKE fce_file.fce10,
#                   fce20   LIKE fce_file.fce20,
#                   fce21   LIKE fce_file.fce21,
#                   fce04   LIKE fce_file.fce04,
#                   fce05   LIKE fce_file.fce05,
#                   fce06   LIKE fce_file.fce06,
#                   fce07   LIKE fce_file.fce07,
#                   faj47   LIKE faj_file.faj47,
#                   faj21   LIKE faj_file.faj21
#                   END RECORD
# define p_faj26 like faj_file.faj26
# define l_fce07_type LIKE type_file.chr4         #No.FUN-680070 VARCHAR(4)
 
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
#  ORDER BY sr.fce01,sr.fce02
## ORDER BY sr.fce01,sr.faj02,sr.fce02
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     #---工作底稿 -----#
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED, pageno_total
#     #---製表日期 -----#
#     PRINT g_dash[1,g_len]
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#           g_x[39],g_x[40],g_x[41],g_x[42],g_x[43]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.fce01
#     PRINT COLUMN g_c[31],sr.fce01;
 
#  ON EVERY ROW
#     LET str = sr.faj02,' ',sr.faj022
#     PRINT COLUMN g_c[32],sr.fce02 USING '###&',
#           COLUMN g_c[33],str,
#           COLUMN g_c[34],p_faj26,
#           COLUMN g_c[35],sr.faj06;
#     IF tm.a = '1' THEN
#         PRINT COLUMN g_c[36],cl_numfor(sr.fce11,36,0),           # 數量
#               COLUMN g_c[37], sr.fce12,                        # 單位
#               COLUMN g_c[38], cl_numfor(sr.a,38,g_azi04),      # 成本
#               COLUMN g_c[39], cl_numfor(sr.b,39,g_azi04),      # 累積折舊
#               COLUMN g_c[40],cl_numfor(sr.fce04,40,g_azi04),  # 帳面價值
#               COLUMN g_c[41],cl_numfor(sr.fce05,41,g_azi04)   # 扺押金額
#     ELSE
#        PRINT COLUMN g_c[36],cl_numfor(sr.fce20,36,0),
#              COLUMN g_c[37],sr.fce21,
#              COLUMN g_c[38], cl_numfor(sr.a,38,g_azi04),       # 成本
#              COLUMN g_c[39], cl_numfor(sr.b,39,g_azi04),       # 累積折舊
#              COLUMN g_c[40],cl_numfor(sr.fce04,40,g_azi04),   # 帳面價值
#              COLUMN g_c[41],cl_numfor(sr.fce05,41,g_azi04)    # 扺押金額
#     END IF
#     call r970_getstatus(sr.fce07) returning l_fce07_type
#     PRINT COLUMN g_c[42],l_fce07_type,
#           COLUMN g_c[43],sr.faj47
 
#  AFTER GROUP OF sr.fce01
#        LET l_tot1 = GROUP SUM(sr.a)
#        LET l_tot2 = GROUP SUM(sr.b)
#        LET l_tot3 = GROUP SUM(sr.fce04)
#        LET l_tot4 = GROUP SUM(sr.fce05)
#     PRINT COLUMN g_c[38],g_dash2[1,g_w[38]],
#           COLUMN g_c[39],g_dash2[1,g_w[39]],
#           COLUMN g_c[40],g_dash2[1,g_w[40]],
#           COLUMN g_c[41],g_dash2[1,g_w[41]]
#     PRINT COLUMN g_c[36],g_x[12] CLIPPED,
#           COLUMN g_c[38],cl_numfor(l_tot1,38,g_azi05),
#           COLUMN g_c[39],cl_numfor(l_tot2,39,g_azi05),
#           COLUMN g_c[40],cl_numfor(l_tot3,40,g_azi05),
#           COLUMN g_c[41],cl_numfor(l_tot4,41,g_azi05)
#     PRINT COLUMN g_c[38],g_dash2[1,g_w[38]],
#           COLUMN g_c[39],g_dash2[1,g_w[39]],
#           COLUMN g_c[40],g_dash2[1,g_w[40]],
#           COLUMN g_c[41],g_dash2[1,g_w[41]]
#     SKIP 1 LINE
 
#  ON LAST ROW
#     LET l_tot1 = SUM(sr.a)
#     LET l_tot2 = SUM(sr.b)
#     LET l_tot3 = SUM(sr.fce04)
#     LET l_tot4 = SUM(sr.fce05)
#     PRINT COLUMN g_c[36],g_x[13] CLIPPED,
#           COLUMN g_c[38],cl_numfor(l_tot1,38,g_azi05),
#           COLUMN g_c[39],cl_numfor(l_tot2,39,g_azi05),
#           COLUMN g_c[40],cl_numfor(l_tot3,40,g_azi05),
#           COLUMN g_c[41],cl_numfor(l_tot4,41,g_azi05)
 
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
##----------------------------------#
#function r970_getstatus(A)
# define a char
# define l_fce07 LIKE fce_file.fce07       #No.FUN-680070 VARCHAR(6)
# case a
#      when "1" let l_fce07=g_x[18]
#      when "2" let l_fce07=g_x[19]
#      when "3" let l_fce07=g_x[20]
# end case
# return l_fce07
#end function
#No.FUN-850024 --MARK END--   
#FUN-870144
