# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: abgr060.4gl
# Descriptions...: 預計折舊明細表
# Date & Author..: 02/12/07 By Letter
# Modify.........: No.FUN-510025 05/01/12 By Smapmin 報表轉XML格式
# Modify.........: No.TQC-610054 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680061 06/08/25 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-690106 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-730033 07/03/20 By Carrier 會計科目加帳套
# Modify.........: No.FUN-740029 07/04/10 By johnray 會計科目加帳套
# Modify.........: No.FUN-770033 07/07/23 By destiny 報表改為使用crystal report
# Modify.........: No.MOD-840447 08/04/21 By kim 印不出資料
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9B0069 09/11/11 By Sarah 報表資料重複顯示
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           wc      LIKE type_file.chr1000,#No.FUN-680061  VARCHAR(500)
           bhd01   LIKE bhd_file.bhd01,   # 版本  
           bhd02   LIKE bhd_file.bhd02,   # 年度
           more    LIKE type_file.chr1    # 輸入其它列印條件 Y/N  #No.FUN-680061 VARCHAR(1)
           END RECORD
DEFINE g_bookno1        LIKE aza_file.aza81   #No.FUN-730033
DEFINE g_bookno2        LIKE aza_file.aza82   #No.FUN-730033
DEFINE g_flag           LIKE type_file.chr1   #No.FUN-730033
DEFINE g_i              LIKE type_file.num5   #count/index for any purpose    #No.FUN-680061 SMALLINT
DEFINE g_sql            STRING                #No.FUN-770033                                                                          
DEFINE g_str            STRING                #No.FUN-770033                                                                          
DEFINE l_table          STRING                #No.FUN-770033
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("ABG")) THEN
       EXIT PROGRAM
    END IF
#No.FUN-770033--start--                                                                                                             
    LET g_sql="bhd04.bhd_file.bhd04,bhd07.bhd_file.bhd07,",
              "aag02.aag_file.aag02,l_gem02.gem_file.gem02,",
              "bhd09_1.bhd_file.bhd09,bhd09_2.bhd_file.bhd09,",
              "bhd09_3.bhd_file.bhd09,bhd09_4.bhd_file.bhd09,",
              "bhd09_5.bhd_file.bhd09,bhd09_6.bhd_file.bhd09,",
              "bhd09_7.bhd_file.bhd09,bhd09_8.bhd_file.bhd09,",
              "bhd09_9.bhd_file.bhd09,bhd09_10.bhd_file.bhd09,",
              "bhd09_11.bhd_file.bhd09,bhd09_12.bhd_file.bhd09"
    LET l_table = cl_prt_temptable('abgr060',g_sql) CLIPPED                                                                        
    IF l_table= -1 THEN EXIT PROGRAM END IF                                                                                        
    LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"                                                                                         
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep',status,1) EXIT PROGRAM                                                                             
    END IF                                                                                                                          
#No.FUN-770033--end--
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690106
    LET g_trace  = 'N'
    LET g_pdate  = ARG_VAL(1)
    LET g_towhom = ARG_VAL(2)
    LET g_rlang  = ARG_VAL(3)
    LET g_bgjob  = ARG_VAL(4)
    LET g_prtway = ARG_VAL(5)
    LET g_copies = ARG_VAL(6)
    LET tm.wc    = ARG_VAL(7)
    LET tm.bhd01 = ARG_VAL(8)   #TQC-610054
    LET tm.bhd02 = ARG_VAL(9)   #TQC-610054
    #No.FUN-570264 --start--
    LET g_rep_user = ARG_VAL(10)
    LET g_rep_clas = ARG_VAL(11)
    LET g_template = ARG_VAL(12)
    LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
    #No.FUN-570264 ---end---
    IF NOT cl_null(tm.wc) THEN
        CALL r060()
    ELSE
        CALL r060_tm(0,0)
    END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
END MAIN
 
FUNCTION r060_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5   #No.FUN-680061 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000#No.FUN-680061 VARCHAR(1000)
 
 
     LET p_row = 6 LET p_col = 13
 
  OPEN WINDOW r060_w AT p_row,p_col
       WITH FORM "abg/42f/abgr060"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
 
  INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
  WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON bhd04
              HELP 1
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
       LET INT_FLAG = 0
       CLOSE WINDOW r060_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
       EXIT PROGRAM
    END IF
 
    IF tm.wc = ' 1=1' THEN
       CALL cl_err('','9046',0) CONTINUE WHILE
    END IF
 
    INPUT BY NAME tm.bhd01,tm.bhd02,tm.more
             WITHOUT DEFAULTS HELP 1
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
       AFTER FIELD bhd01
          IF cl_null(tm.bhd01) THEN LET tm.bhd01 = ' ' END IF
 
       AFTER FIELD bhd02
          IF tm.bhd02<0 THEN
             NEXT FIELD bhd02
          END IF
 
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
      ON ACTION CONTROLT LET g_trace = 'Y'
   AFTER INPUT
#      LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
#      LET tm.t = tm2.t1,tm2.t2,tm2.t3
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
      LET INT_FLAG = 0
      CLOSE WINDOW r060_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='abgr060'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abgr060','9031',1)
      ELSE
         LET tm.wc=cl_wcsub(tm.wc)
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.bhd01 CLIPPED,"'",   #TQC-610054
                         " '",tm.bhd02 CLIPPED,"'",   #TQC-610054
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         IF g_trace = 'Y' THEN ERROR l_cmd END IF
 
         CALL cl_cmdat('abgr060',g_time,l_cmd)
      END IF
      CLOSE WINDOW r060_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
   END IF
 
   CALL cl_wait()
   CALL r060()
   ERROR ""
 
END WHILE
   CLOSE WINDOW r060_w
END FUNCTION
 
FUNCTION r060()
 DEFINE l_name    LIKE type_file.chr20   #No.FUN-680061 VARCHAR(20)
#DEFINE l_time    LIKE type_file.chr8    #No.FUN-6A0056
 DEFINE l_sql     LIKE type_file.chr1000 # RDSQL STATEMENT #No.FUN-680061 VARCHAR(300)
 DEFINE l_za05    LIKE type_file.chr1000 #No.FUN-680061 VARCHAR(40)
 DEFINE l_gem02   LIKE gem_file.gem02    #No.FUN-770033
 DEFINE sr        RECORD
                        bhd03    LIKE bhd_file.bhd03,      # 期別
                        bhd04    LIKE bhd_file.bhd04,      # 部門
                        bhd07    LIKE bhd_file.bhd07,      # 折舊科目
                        bhd09    LIKE bhd_file.bhd09,      # 分攤金額
                        aag02    LIKE aag_file.aag02,      # 科目名稱
                        bhd09_1  LIKE bhd_file.bhd09,      # 分攤金額(1月)
                        bhd09_2  LIKE bhd_file.bhd09,      # 分攤金額(2月)
                        bhd09_3  LIKE bhd_file.bhd09,      # 分攤金額(3月)
                        bhd09_4  LIKE bhd_file.bhd09,      # 分攤金額(4月)
                        bhd09_5  LIKE bhd_file.bhd09,      # 分攤金額(5月)
                        bhd09_6  LIKE bhd_file.bhd09,      # 分攤金額(6月)
                        bhd09_7  LIKE bhd_file.bhd09,      # 分攤金額(7月)
                        bhd09_8  LIKE bhd_file.bhd09,      # 分攤金額(8月)
                        bhd09_9  LIKE bhd_file.bhd09,      # 分攤金額(9月)
                        bhd09_10 LIKE bhd_file.bhd09,      # 分攤金額(10月)
                        bhd09_11 LIKE bhd_file.bhd09,      # 分攤金額(11月)
                        bhd09_12 LIKE bhd_file.bhd09      # 分攤金額(12月)
                 END RECORD

     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog       #No.FUN-770033
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

    #Begin:FUN-980030
    #IF g_priv2='4' THEN                   #只能使用自己的資料
    #    LET tm.wc = tm.wc clipped," AND cqguser = '",g_user,"'"
    #END IF
    #IF g_priv3='4' THEN                   #只能使用相同群的資料
    #    LET tm.wc = tm.wc clipped," AND cqggrup MATCHES '",g_grup CLIPPED,"*'"
    #END IF
    #IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #    LET tm.wc = tm.wc clipped," AND cqggrup IN ",cl_chk_tgrup_list()
    #END IF
    #LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('cqguser', 'cqggrup')   #MOD-9B0069 mark
    #End:FUN-980030
     CALL cl_del_data(l_table)    #No.FUN-770033
     #No.FUN-730033  --Begin
     CALL s_get_bookno(tm.bhd02) RETURNING g_flag,g_bookno1,g_bookno2
     IF g_flag =  '1' THEN  #抓不到帳別
        CALL cl_err(tm.bhd02,'aoo-081',1)
        RETURN
     END IF
     #No.FUN-730033  --End  
  LET l_sql = "SELECT bhd03,bhd04,bhd07,bhd09,aag02,0,0,0,0,0,0,0,0,0,0,0,0 ",  
                 " FROM bhd_file ",
                 " LEFT OUTER JOIN aag_file ",  #MOD-840447
                 " ON bhd07=aag01 AND aag00='",g_aza.aza81,"' ", #MOD-840447
                 " WHERE bhd01='",tm.bhd01,"' ", #MOD-840447
                 "   AND bhd02=",tm.bhd02,       #MOD-840447
                 "   AND bhd05='折舊' ", 
                #"   AND bhd07=aag01 ",
                #"   AND aag00='",g_bookno1,"'",   #No.FUN-730033
                #"   AND aag00='",g_aza.aza81,"'", #No.FUN-740029
                 "   AND ",tm.wc CLIPPED
 
     LET l_sql = l_sql CLIPPED," ORDER BY bhd04,bhd07,bhd03"  #MOD-9B0069 add bhd03
     IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
     PREPARE r060_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
         EXIT PROGRAM
     END IF
     DECLARE r060_curs1 CURSOR FOR r060_prepare1
#     CALL cl_outnam('abgr060') RETURNING l_name         #No.FUN-770033
#     START REPORT r060_rep TO l_name                    #No.FUN-770033
     LET g_pageno = 0
     FOREACH r060_curs1 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
       #str MOD-9B0069 add
       #先將變數歸零
        LET sr.bhd09_1 =0  LET sr.bhd09_2 =0  LET sr.bhd09_3 =0
        LET sr.bhd09_4 =0  LET sr.bhd09_5 =0  LET sr.bhd09_6 =0
        LET sr.bhd09_7 =0  LET sr.bhd09_8 =0  LET sr.bhd09_9 =0
        LET sr.bhd09_10=0  LET sr.bhd09_11=0  LET sr.bhd09_12=0
       #end MOD-9B0069 add
        SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.bhd04  #No.FUN-770033                                                                              
        IF cl_null(sr.bhd09) THEN LET sr.bhd09 = 0  END IF
        CASE
           WHEN sr.bhd03=1  LET sr.bhd09_1=sr.bhd09
           WHEN sr.bhd03=2  LET sr.bhd09_2=sr.bhd09
           WHEN sr.bhd03=3  LET sr.bhd09_3=sr.bhd09
           WHEN sr.bhd03=4  LET sr.bhd09_4=sr.bhd09
           WHEN sr.bhd03=5  LET sr.bhd09_5=sr.bhd09
           WHEN sr.bhd03=6  LET sr.bhd09_6=sr.bhd09
           WHEN sr.bhd03=7  LET sr.bhd09_7=sr.bhd09
           WHEN sr.bhd03=8  LET sr.bhd09_8=sr.bhd09
           WHEN sr.bhd03=9  LET sr.bhd09_9=sr.bhd09
           WHEN sr.bhd03=10 LET sr.bhd09_10=sr.bhd09
           WHEN sr.bhd03=11 LET sr.bhd09_11=sr.bhd09
           WHEN sr.bhd03=12 LET sr.bhd09_12=sr.bhd09
        END CASE
#No.FUN-770033--start--                                                                                                             
        EXECUTE insert_prep USING
           sr.bhd04,sr.bhd07,sr.aag02,l_gem02,
           sr.bhd09_1,sr.bhd09_2,sr.bhd09_3,sr.bhd09_4,sr.bhd09_5,
           sr.bhd09_6,sr.bhd09_7,sr.bhd09_8,sr.bhd09_9,sr.bhd09_10,
           sr.bhd09_11,sr.bhd09_12
#       OUTPUT TO REPORT r060_rep(sr.*)
     END FOREACH
 
     IF g_zz05 = 'Y' THEN                                                                                                           
        CALL cl_wcchp(tm.wc,'bhd04')                                                                                                
             RETURNING tm.wc                                                                                                        
        LET g_str = tm.wc                                                                                                           
     END IF                                                                                                                         
    #str MOD-9B0069 mod
    #LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET l_sql="SELECT bhd04,bhd07,aag02,l_gem02,",
               "       SUM(bhd09_1) bhd09_1,SUM(bhd09_2) bhd09_2,",
               "       SUM(bhd09_3) bhd09_3,SUM(bhd09_4) bhd09_4,",
               "       SUM(bhd09_5) bhd09_5,SUM(bhd09_6) bhd09_6,",
               "       SUM(bhd09_7) bhd09_7,SUM(bhd09_8) bhd09_8,",
               "       SUM(bhd09_9) bhd09_9,SUM(bhd09_10) bhd09_10,",
               "       SUM(bhd09_11) bhd09_11,SUM(bhd09_12) bhd09_12",
               "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " GROUP BY bhd04,bhd07,aag02,l_gem02"
    #end MOD-9B0069 mod
     LET g_str=g_str,";",g_azi04,";",g_azi05
#     FINISH REPORT r060_rep
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     CALL cl_prt_cs3('abgr060','abgr060',l_sql,g_str)
#No.FUN-770033--end--
END FUNCTION
#No.FUN-770033-start--
{REPORT r060_rep(sr)
 DEFINE l_last_sw    LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(1)
        g_head1      STRING,
        l_gem02      LIKE gem_file.gem02
 DEFINE l_sum1,l_sum2,l_sum3,l_sum4,l_sum5,l_sum6,l_sum7,
        l_sum8,l_sum9,l_sum10,l_sum11,l_sum12,l_tot LIKE bhd_file.bhd09   
 DEFINE l_s1,l_s2,l_s3,l_s4,l_s5,l_s6,l_s7,
        l_s8,l_s9,l_s10,l_s11,l_s12 LIKE bhd_file.bhd09   
 DEFINE sr        RECORD
                        bhd03    LIKE bhd_file.bhd03,      # 期別
                        bhd04    LIKE bhd_file.bhd04,      # 部門
                        bhd07    LIKE bhd_file.bhd07,      # 折舊科目
                        bhd09    LIKE bhd_file.bhd09,      # 分攤金額
                        aag02    LIKE aag_file.aag02,      # 科目名稱
                        bhd09_1  LIKE bhd_file.bhd09,      # 分攤金額(1月)
                        bhd09_2  LIKE bhd_file.bhd09,      # 分攤金額(2月)
                        bhd09_3  LIKE bhd_file.bhd09,      # 分攤金額(3月)
                        bhd09_4  LIKE bhd_file.bhd09,      # 分攤金額(4月)
                        bhd09_5  LIKE bhd_file.bhd09,      # 分攤金額(5月)
                        bhd09_6  LIKE bhd_file.bhd09,      # 分攤金額(6月)
                        bhd09_7  LIKE bhd_file.bhd09,      # 分攤金額(7月)
                        bhd09_8  LIKE bhd_file.bhd09,      # 分攤金額(8月)
                        bhd09_9  LIKE bhd_file.bhd09,      # 分攤金額(9月)
                        bhd09_10 LIKE bhd_file.bhd09,      # 分攤金額(10月)
                        bhd09_11 LIKE bhd_file.bhd09,      # 分攤金額(11月)
                        bhd09_12 LIKE bhd_file.bhd09       # 分攤金額(12月)
                 END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.bhd04,sr.bhd07
  FORMAT
 
   PAGE HEADER
 
      LET l_sum1=0
      LET l_sum2=0
      LET l_sum3=0
      LET l_sum4=0
      LET l_sum5=0
      LET l_sum6=0
      LET l_sum7=0
      LET l_sum8=0
      LET l_sum9=0
      LET l_sum10=0
      LET l_sum11=0
      LET l_sum12=0
 
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      LET g_head1 = g_x[4] CLIPPED,tm.bhd01 CLIPPED,' ',
                    g_x[5] CLIPPED,tm.bhd02 USING "<<<<<" CLIPPED
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
            g_x[39],g_x[40]   
      PRINT g_dash1
      LET l_last_sw = 'n'
      SELECT gem02 INTO l_gem02 FROM gem_file
         WHERE gem01 = sr.bhd04
   BEFORE GROUP OF sr.bhd04
          PRINT COLUMN g_c[31],sr.bhd04  CLIPPED,
                COLUMN g_C[32],l_gem02;
   BEFORE GROUP OF sr.bhd07
          PRINT COLUMN g_c[33]  ,sr.bhd07 CLIPPED;
          PRINT COLUMN g_c[34]  ,sr.aag02 CLIPPED;
   AFTER GROUP OF sr.bhd07
          PRINT COLUMN  g_c[35],cl_numfor(GROUP SUM(sr.bhd09_1),35,g_azi04),
                COLUMN  g_c[36] ,cl_numfor(GROUP SUM(sr.bhd09_2),36,g_azi04),
                COLUMN  g_c[37] ,cl_numfor(GROUP SUM(sr.bhd09_3),37,g_azi04),
                COLUMN  g_c[38] ,cl_numfor(GROUP SUM(sr.bhd09_4),38,g_azi04),
                COLUMN  g_c[39] ,cl_numfor(GROUP SUM(sr.bhd09_5),39,g_azi04),
                COLUMN  g_c[40] ,cl_numfor(GROUP SUM(sr.bhd09_6),40,g_azi04)
          PRINT COLUMN  g_c[35] ,cl_numfor(GROUP SUM(sr.bhd09_7),35,g_azi04),
                COLUMN  g_c[36] ,cl_numfor(GROUP SUM(sr.bhd09_8),36,g_azi04),
                COLUMN  g_c[37] ,cl_numfor(GROUP SUM(sr.bhd09_9),37,g_azi04),
                COLUMN  g_c[38] ,cl_numfor(GROUP SUM(sr.bhd09_10),38,g_azi04),
                COLUMN  g_c[39] ,cl_numfor(GROUP SUM(sr.bhd09_11),39,g_azi04),
                COLUMN  g_c[40] ,cl_numfor(GROUP SUM(sr.bhd09_12),40,g_azi04)
      LET l_tot=(GROUP SUM(sr.bhd09_1)+GROUP SUM(sr.bhd09_2)+GROUP SUM(sr.bhd09_3)+GROUP SUM(sr.bhd09_4)+
                 GROUP SUM(sr.bhd09_5)+GROUP SUM(sr.bhd09_6)+GROUP SUM(sr.bhd09_7)+GROUP SUM(sr.bhd09_8)+
                 GROUP SUM(sr.bhd09_9)+GROUP SUM(sr.bhd09_10)+GROUP SUM(sr.bhd09_11)+GROUP SUM(sr.bhd09_12))   
 
      PRINT COLUMN g_c[31],g_x[10];
 
   AFTER GROUP OF sr.bhd04
      LET l_sum1=GROUP SUM(sr.bhd09_1);
      LET l_sum2=GROUP SUM(sr.bhd09_2);
      LET l_sum3=GROUP SUM(sr.bhd09_3);
      LET l_sum4=GROUP SUM(sr.bhd09_4);
      LET l_sum5=GROUP SUM(sr.bhd09_5);
      LET l_sum6=GROUP SUM(sr.bhd09_6);
      LET l_sum7=GROUP SUM(sr.bhd09_7);
      LET l_sum8=GROUP SUM(sr.bhd09_8);
      LET l_sum9=GROUP SUM(sr.bhd09_9);
      LET l_sum10=GROUP SUM(sr.bhd09_10);
      LET l_sum11=GROUP SUM(sr.bhd09_11);
      LET l_sum12=GROUP SUM(sr.bhd09_12);
 
      PRINT g_dash2
      PRINT COLUMN  g_c[31] ,g_x[11] CLIPPED,
            COLUMN  g_c[35],cl_numfor(l_sum1 ,35,g_azi05),
            COLUMN  g_c[36],cl_numfor(l_sum2 ,36,g_azi05),
            COLUMN  g_c[37],cl_numfor(l_sum3 ,37,g_azi05),
            COLUMN  g_c[38],cl_numfor(l_sum4 ,38,g_azi05),
            COLUMN  g_c[39],cl_numfor(l_sum5 ,39,g_azi05),
            COLUMN  g_c[40],cl_numfor(l_sum6 ,40,g_azi05)
      PRINT COLUMN  g_c[35],cl_numfor(l_sum7 ,35,g_azi05),
            COLUMN  g_c[36],cl_numfor(l_sum8 ,36,g_azi05),
            COLUMN  g_c[37],cl_numfor(l_sum9 ,37,g_azi05),
            COLUMN  g_c[38],cl_numfor(l_sum10,38,g_azi05),
            COLUMN  g_c[39],cl_numfor(l_sum11,39,g_azi05),
            COLUMN  g_c[40],cl_numfor(l_sum12,40,g_azi05)
      PRINT
 
   ON LAST ROW
      LET l_last_sw = 'y'
 
      PRINT COLUMN  g_c[31] ,g_x[12] CLIPPED,
            COLUMN  g_c[35],cl_numfor(GROUP SUM(sr.bhd09_1) ,35,g_azi05),
            COLUMN  g_c[36],cl_numfor(GROUP SUM(sr.bhd09_2) ,36,g_azi05),
            COLUMN  g_c[37],cl_numfor(GROUP SUM(sr.bhd09_3) ,37,g_azi05),
            COLUMN  g_c[38],cl_numfor(GROUP SUM(sr.bhd09_4) ,38,g_azi05),
            COLUMN  g_c[39],cl_numfor(GROUP SUM(sr.bhd09_5) ,39,g_azi05),
            COLUMN  g_c[40],cl_numfor(GROUP SUM(sr.bhd09_6) ,40,g_azi05)
      PRINT COLUMN  g_c[35],cl_numfor(GROUP SUM(sr.bhd09_7) ,35,g_azi05),
            COLUMN  g_c[36],cl_numfor(GROUP SUM(sr.bhd09_8) ,36,g_azi05),
            COLUMN  g_c[37],cl_numfor(GROUP SUM(sr.bhd09_9) ,37,g_azi05),
            COLUMN  g_c[38],cl_numfor(GROUP SUM(sr.bhd09_10),38,g_azi05),
            COLUMN  g_c[39],cl_numfor(GROUP SUM(sr.bhd09_11),39,g_azi05),
            COLUMN  g_c[40],cl_numfor(GROUP SUM(sr.bhd09_12),40,g_azi05)
 
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
          PRINT g_dash[1,g_len]
          PRINT g_x[9] CLIPPED,
                COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE
          PRINT g_dash[1,g_len]
          PRINT g_x[9] CLIPPED,
                COLUMN (g_len-9), g_x[7] CLIPPED
      END IF
END REPORT}
#No.FUN-770033-end--
#Patch....NO.TQC-610035 <001> #
