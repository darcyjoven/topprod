# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: abgr020.4gl
# Descriptions...: 用人計劃表
# Date & Author..: 02/11/19 By Letter
# Modify.........: No.FUN-510025 05/01/12 By Smapmin 報表轉XML格式
# Modify.........: No.TQC-610054 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680061 06/08/25 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-690106 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-770033 07/07/18 By destiny 報表改為使用crystal report
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-990065 09/12/17 By chenmoyan cqguser,cqggrup--->bgeuser,bgegrup
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           wc      LIKE type_file.chr1000,  #No.FUN-680061    VARCHAR(500),
           bge01   LIKE bge_file.bge01,     # 版本
           bge03   LIKE bge_file.bge03,     # 年度
           bgv03   LIKE bgv_file.bgv03,     # 開始月份   #No.FUN-680061  SMALLINT,
           bgv03a  LIKE bgv_file.bgv03,     # 結束月份   #No.FUN-680061  SMALLINT,
           more    LIKE type_file.chr1      # 輸入其它列印條件 Y/N  #No.FUN-680061  VARCHAR(01)
           END RECORD
DEFINE   g_i       LIKE type_file.num5      #No.FUN-680061  SMALLINT
DEFINE   g_sql      STRING                  #No.FUN-770033                                                                          
DEFINE   g_str      STRING                  #No.FUN-770033                                                                          
DEFINE   l_table    STRING                  #No.FUN-770033
 
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
    LET g_sql="bge02.bge_file.bge02,",                                                                                              
              "bge05.bge_file.bge05,",                                                                                              
              "bge06.bge_file.bge06,",                                                                                              
              "bge04.bge_file.bge04,",                                                                                              
              "bge07.bge_file.bge07,",                                                                                              
              "bge09.bge_file.bge09,",                                                                                              
              "bgv10a.bgv_file.bgv10,",                                                                                            
              "bgv10b.bgv_file.bgv10,",                                                                                              
              "l_gem02.gem_file.gem02"
 
     LET l_table = cl_prt_temptable('abgr020',g_sql) CLIPPED                                                                        
     IF l_table= -1 THEN EXIT PROGRAM END IF                                                                                      
     LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?,?,?,?,?)"                                                                                 
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
   #-----TQC-610054---------
   LET tm.bge01 = ARG_VAL(8)
   LET tm.bge03 = ARG_VAL(9)
   LET tm.bgv03 = ARG_VAL(10)
   LET tm.bgv03a = ARG_VAL(11)
   #-----END TQC-610054-----
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF NOT cl_null(tm.wc) THEN
       CALL r020()
   ELSE
       CALL r020_tm(0,0)
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
END MAIN
 
FUNCTION r020_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5     #No.FUN-680061   SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000  #No.FUN-680061   VARCHAR(1000)
 
  IF p_row = 0 THEN LET p_row = 6 LET p_col = 13 END IF
 
 
     LET p_row = 6 LET p_col = 13
 
  OPEN WINDOW r020_w AT p_row,p_col
       WITH FORM "abg/42f/abgr020"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
 
  INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   #LET tm.bdate= g_today
   #LET tm.edate= g_today
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
  WHILE TRUE
     LET tm.bge01= ' ' #MOD-550183
    CONSTRUCT BY NAME tm.wc ON bge02 HELP 1
 
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
       CLOSE WINDOW r020_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
       EXIT PROGRAM
    END IF
 
    IF tm.wc = ' 1=1' THEN
       CALL cl_err('','9046',0) CONTINUE WHILE
    END IF
 
    INPUT BY NAME tm.bge01,tm.bge03,tm.bgv03,tm.bgv03a,tm.more
             WITHOUT DEFAULTS HELP 1
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
       AFTER FIELD bge01
          IF cl_null(tm.bge01)  THEN
             LET tm.bge01=' '
          END IF
 
       AFTER FIELD bge03
          IF cl_null(tm.bge03) or tm.bge03<0 THEN
             NEXT FIELD bge03
          END IF
 
       AFTER FIELD bgv03
          IF tm.bgv03<=0 or tm.bgv03>12 THEN
             NEXT FIELD bgv03
          END IF
 
       AFTER FIELD bgv03a
          IF tm.bgv03a<=0 OR  tm.bgv03a>12 THEN
             NEXT FIELD bgv03a
          END IF
          IF tm.bgv03a<tm.bgv03 THEN
             NEXT FIELD bgv03a
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
       #ON ACTION CONTROLT LET g_trace = 'Y'
 
        AFTER INPUT
#          LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
#          LET tm.t = tm2.t1,tm2.t2,tm2.t3
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
      CLOSE WINDOW r020_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='abgr020'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abgr020','9031',1)
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
                         #-----TQC-610054---------
                         " '",tm.bge01 CLIPPED,"'",
                         " '",tm.bge03 CLIPPED,"'",
                         " '",tm.bgv03 CLIPPED,"'",
                         " '",tm.bgv03a CLIPPED,"'",
                         #-----END TQC-610054-----
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
         IF g_trace = 'Y' THEN ERROR l_cmd END IF
 
         CALL cl_cmdat('abgr020',g_time,l_cmd)
      END IF
      CLOSE WINDOW r020_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
   END IF
 
   CALL cl_wait()
   CALL r020()
   ERROR ""
 
END WHILE
   CLOSE WINDOW r020_w
END FUNCTION
 
FUNCTION r020()
DEFINE l_name    LIKE type_file.chr20     #No.FUN-680061   VARCHAR(20)
#     DEFINEl_time LIKE type_file.chr8        #No.FUN-6A0056
DEFINE l_sql     LIKE type_file.chr1000   #No.FUN-680061   VARCHAR(1300)
DEFINE l_za05    LIKE type_file.chr1000   #No.FUN-680061   VARCHAR(40)
DEFINE sr        RECORD
                        bge02  LIKE bge_file.bge02,      # 部門
                        bge04  LIKE bge_file.bge04,      # 月份
                        bge05  LIKE bge_file.bge05,      # 職等
                        bge06  LIKE bge_file.bge06,      # 職級
                        bge07  LIKE bge_file.bge07,      # 編製人力(直接)
                        bge09  LIKE bge_file.bge09,      # 編製人力(間接)
                        bgv10a LIKE bgv_file.bgv10,      # 費用項目(直接)
                        bgv10b LIKE bgv_file.bgv10       # 費用項目(間接)
                 END RECORD
DEFINE  l_gem02      LIKE gem_file.gem02    #No.FUN-770033 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog       #No.FUN-770033
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND cqguser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND cqggrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND cqggrup IN ",cl_chk_tgrup_list()
     #     END IF
#    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('cqguser', 'cqggrup') #FUN-990065 MARK
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bgeuser', 'bgegrup') #FUN-990065 MARK
     #End:FUN-980030
     CALL cl_del_data(l_table)    #No.FUN-770033
     DISPLAY "tm.bge01=",tm.bge01
     DISPLAY "tm.bge03=",tm.bge03
     DISPLAY "tm.bgv03=",tm.bgv03
     DISPLAY "tm.bgv03a=",tm.bgv03a
  LET l_sql = "SELECT bge02,bge04,bge05,bge06,SUM(bge07),SUM(bge09),0,0 ",
                 " FROM bge_file          ",
                 " WHERE bge01 ='",tm.bge01,"'",
                 "   AND bge03=",tm.bge03,
                 "   AND bge04 BETWEEN ",tm.bgv03," and ", tm.bgv03a,
                 "   AND ",tm.wc CLIPPED
     LET l_sql = l_sql CLIPPED," GROUP BY bge02,bge05,bge06,bge04 ",
                               " ORDER BY bge02,bge05,bge06,bge04 "
     IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
     PREPARE r020_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
         EXIT PROGRAM
     END IF
     DECLARE r020_curs1 CURSOR FOR r020_prepare1
#     CALL cl_outnam('abgr020') RETURNING l_name      #No.FUN-770033
#     START REPORT r020_rep TO l_name                 #No.FUN-770033
     LET g_pageno = 0
     FOREACH r020_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
     SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr.bge02          #No.FUN-770033                                                                        
          SELECT SUM(bgv10) INTO sr.bgv10a FROM bgv_file
                 WHERE bgv06='1'
                 and bgv01=tm.bge01
                 and bgv04=sr.bge02
                 and bgv02=tm.bge03
                 and bgv03=sr.bge04
                 and bgv07=sr.bge05
                 and bgv08=sr.bge06
                 and bgv00=='1'
          SELECT SUM(bgv10) INTO sr.bgv10b FROM bgv_file
                 WHERE bgv06='2'
                 and bgv01=tm.bge01
                 and bgv04=sr.bge02
                 and bgv02=tm.bge03
                 and bgv03=sr.bge04
                 and bgv07=sr.bge05
                 and bgv08=sr.bge06
                 and bgv00=='1'
          IF cl_null(sr.bgv10a) THEN LET sr.bgv10a = 0 END IF
          IF cl_null(sr.bgv10b) THEN LET sr.bgv10b = 0 END IF
#No.FUN-770033--start--  
          EXECUTE insert_prep USING                                                                                                    
                  sr.bge02,sr.bge05,sr.bge06,sr.bge04,sr.bge07,sr.bge09,sr.bgv10a,
                  sr.bgv10b,l_gem02 
#No.FUN-770033--end-- 
#          OUTPUT TO REPORT r020_rep(sr.*)      #No.FUN-770033
 
     END FOREACH
#No.FUN-770033--start--
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'bge02')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   
     LET g_str=tm.bge01,";",tm.bge03,";",g_azi04,";",g_str                      
#No.FUN-770033--end--
#     FINISH REPORT r020_rep                   #No.FUN-770033
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)   #No.FUN-770033
      CALL cl_prt_cs3('abgr020','abgr020',l_sql,g_str)  #No.FUN-770033
END FUNCTION
#No.FUN-770033-start--  
{REPORT r020_rep(sr)
DEFINE l_last_sw    LIKE type_file.chr1000,  #No.FUN-680061   VARCHAR(1),
       g_head1      STRING,                              
       l_gem02      LIKE gem_file.gem02
DEFINE sr           RECORD
                           bge02  LIKE bge_file.bge02,      # 部門
                           bge04  LIKE bge_file.bge04,      # 月份
                           bge05  LIKE bge_file.bge05,      # 職等
                           bge06  LIKE bge_file.bge06,      # 職級
                           bge07  LIKE bge_file.bge07,      # 編製人力(直接)
                           bge09  LIKE bge_file.bge09,      # 編製人力(間接)
                           bgv10a LIKE bgv_file.bgv10,      # 費用項目(直接)
                           bgv10b LIKE bgv_file.bgv10       # 費用項目(間接)
                    END RECORD,
        l_amt_1     LIKE bgv_file.bgv10,                    # 費用項目(直接)小計
        l_amt_2     LIKE bgv_file.bgv10,                    # 費用項目(間接)小計
        l_amt_3     LIKE bgv_file.bgv10,                    # 費用項目(直接)總計
        l_amt_4     LIKE bgv_file.bgv10                     # 費用項目(間接)總計
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.bge02,sr.bge05,sr.bge06,sr.bge04
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      LET g_head1 = g_x[4] CLIPPED,tm.bge01 CLIPPED,' ',
                    g_x[5] CLIPPED,tm.bge03 USING "<<<<<" CLIPPED
      PRINT g_head1
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
            g_x[39]
      PRINT g_dash1
      LET l_last_sw = 'n'
      SELECT gem02 INTO l_gem02 FROM gem_file
         WHERE gem01 = sr.bge02
 
   BEFORE GROUP OF sr.bge02
          PRINT COLUMN g_c[31],sr.bge02  CLIPPED,
                COLUMN g_c[32],l_gem02 CLIPPED;
   BEFORE GROUP OF sr.bge05
          PRINT COLUMN g_c[33] ,sr.bge05  ;
   BEFORE GROUP OF sr.bge06
          PRINT COLUMN g_c[34] ,sr.bge06  USING "####" CLIPPED;
 
   ON EVERY ROW
          PRINT COLUMN g_c[35] ,sr.bge04  USING "##" CLIPPED,
                COLUMN g_c[36] ,sr.bge07  USING "#######&" CLIPPED,
                COLUMN g_c[37] ,cl_numfor(sr.bgv10a,37,g_azi04),
                COLUMN g_c[38] ,sr.bge09  USING "#######&" CLIPPED,
                COLUMN g_c[39] ,cl_numfor(sr.bgv10b,39,g_azi04)
 
   AFTER GROUP OF sr.bge02
      LET l_amt_1 = GROUP SUM(sr.bgv10a)
      LET l_amt_2 = GROUP SUM(sr.bgv10b)
      PRINT COLUMN g_c[37],g_dash[1,g_w[37]],
            COLUMN g_c[39],g_dash[1,g_w[39]]
      PRINT COLUMN g_c[36],g_x[10] CLIPPED,
            COLUMN g_c[37],cl_numfor(l_amt_1,37,g_azi04),
            COLUMN g_c[38],g_x[10] CLIPPED,
            COLUMN g_c[39],cl_numfor(l_amt_2,39,g_azi04)
 
   ON LAST ROW
      LET l_last_sw = 'y'
      LET l_amt_3 =       SUM(sr.bgv10a)
      LET l_amt_4 =       SUM(sr.bgv10b)
 
      PRINT COLUMN g_c[37],g_dash[1,g_w[37]],
            COLUMN g_c[39],g_dash[1,g_w[39]]
      PRINT COLUMN g_c[36],g_x[11] CLIPPED,
            COLUMN g_c[37],cl_numfor(l_amt_3,37,g_azi04),
            COLUMN g_c[38],g_x[11] CLIPPED,
            COLUMN g_c[39],cl_numfor(l_amt_4,39,g_azi04)
 
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
#No.FUN-770033--end--
#Patch....NO.TQC-610035 <001> #
