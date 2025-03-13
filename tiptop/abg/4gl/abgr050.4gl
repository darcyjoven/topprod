# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: abgr050.4gl
# Descriptions...: 預計聘用人員明細表
# Date & Author..: 02/11/12 By yiting
# Modify.........: No.FUN-510025 05/01/12 By Smapmin 報表轉XML格式
# Modify.........: No.TQC-610054 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680061 06/08/25 By cheunl 欄位型態定義,改為LIKE 
# Modify.........: No.FUN-690106 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-770033 07/07/04 By destiny 報表改為使用crystal report
# Modify.........: No.FUN-7C0048 07/12/19 By jamie 列印條件未轉欄位名稱
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           bge01   LIKE bge_file.bge01,
           bge03   LIKE bge_file.bge03,
           more    LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(1),
           a       LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(1),
           wc      STRING                 #No.TQC-630166
           END RECORD
DEFINE g_i         LIKE type_file.num5    #No.FUN-680061  SMALLINT
DEFINE g_sql       STRING                 #No.FUN-770033
DEFINE l_table     STRING                 #No.FUN-770033                                                                 
DEFINE g_str       STRING                 #No.FUN-770033
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690106
#No.FUN-770033--start--
   LET g_sql = "bge02.bge_file.bge02,",
               "l_gem02.gem_file.gem02,",
               "bge05.bge_file.bge05,",
               "bge06.bge_file.bge06,",
               "bge04.bge_file.bge04,",
               "bge07.bge_file.bge07,",
               "bge09.bge_file.bge09,",
               "m1.bge_file.bge07,",
               "m2.bge_file.bge07,",
               "m3.bge_file.bge07,",
               "m4.bge_file.bge07,",
               "m5.bge_file.bge07,",
               "m6.bge_file.bge07,",
               "m7.bge_file.bge07,",
               "m8.bge_file.bge07,",
               "m9.bge_file.bge07,",
               "m10.bge_file.bge07,",
               "m11.bge_file.bge07,",
               "m12.bge_file.bge07"
   LET l_table = cl_prt_temptable('abgr050',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?)"
   PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                   
#No.FUN-770033--end--
       LET g_trace  = 'N'
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.bge01 = ARG_VAL(8)   #TQC-610054
   LET tm.bge03 = ARG_VAL(9)   #TQC-610054
   LET tm.a = ARG_VAL(10)   #TQC-610054
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF NOT cl_null(tm.wc) THEN
       CALL r050()
   ELSE
       CALL r050_tm(0,0)
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
END MAIN
 
FUNCTION r050_tm(p_row,p_col)
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col LIKE type_file.num5   #No.FUN-680061   SMALLINT
DEFINE l_cmd       LIKE type_file.chr1000#No.FUN-680061   VARCHAR(1000)
 
IF p_row = 0 THEN LET p_row = 5 LET p_col = 13 END IF
 LET p_row = 5 LET p_col = 13
   OPEN WINDOW r050_w AT p_row,p_col
        WITH FORM "abg/42f/abgr050"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.a='3'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON bge02    HELP 1           #組QBE
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
      CLOSE WINDOW r050_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
 
INPUT BY NAME tm.bge01,tm.bge03,tm.a,tm.more
      WITHOUT DEFAULTS HELP 1
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      AFTER FIELD bge03                    #輸入年度，不可空白不可小於0
         IF tm.bge03<0 or cl_null(tm.bge03) THEN NEXT FIELD bge03 END IF
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
      CLOSE WINDOW r050_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='abgr050'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abgr050','9031',1)
      ELSE
         LET tm.wc=cl_wcsub(tm.wc)
         LET l_cmd=l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.bge01 CLIPPED,"'",   #TQC-610054
                         " '",tm.bge03 CLIPPED,"'",   #TQC-610054
                         " '",tm.a CLIPPED,"'",   #TQC-610054
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         IF g_trace = 'Y' THEN ERROR l_cmd END IF
         CALL cl_cmdat('abgr050',g_time,l_cmd)
      END IF
      CLOSE WINDOW r050_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r050()
   ERROR ""
END WHILE
   CLOSE WINDOW r050_w
END FUNCTION
 
FUNCTION r050()
DEFINE l_name    LIKE type_file.chr20  #No.FUN-680061 VARCHAR(20)
#     DEFINEl_time LIKE type_file.chr8        #No.FUN-6A0056
DEFINE l_sql     LIKE type_file.chr1000#No.FUN-680061 VARCHAR(300)
DEFINE l_za05    LIKE type_file.chr1000#NO.FUN-680061 VARCHAR(40)
DEFINE l_order   ARRAY[5] OF LIKE cre_file.cre08 #No.FUN-680061 ARRAY[5] OF VARCHAR(10)
DEFINE l_gem02   LIKE gem_file.gem02
DEFINE sr        RECORD
                     bge02     LIKE bge_file.bge02,    #部門
                     bge05     LIKE bge_file.bge05,    #職等
                     bge06     LIKE bge_file.bge06,    #職級
                     bge04     LIKE bge_file.bge04,    #月份
                     bge07     LIKE bge_file.bge07,    #直接人力
                     bge09     LIKE bge_file.bge09,    #間接人力
                     m1        LIKE bge_file.bge07,    #一月份
                     m2        LIKE bge_file.bge07,    #二月份
                     m3        LIKE bge_file.bge07,    #三月份
                     m4        LIKE bge_file.bge07,    #四月份
                     m5        LIKE bge_file.bge07,    #五月份
                     m6        LIKE bge_file.bge07,    #六月份
                     m7        LIKE bge_file.bge07,    #七月份
                     m8        LIKE bge_file.bge07,    #八月份
                     m9        LIKE bge_file.bge07,    #九月份
                     m10       LIKE bge_file.bge07,    #十月份
                     m11       LIKE bge_file.bge07,    #十一月份
                     m12       LIKE bge_file.bge07     #十二月份
                    END RECORD,
      l_month1_1     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month1_2     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month1_3     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month1_4     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month1_5     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month1_6     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month1_7     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month1_8     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month1_9     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month1_10    LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month1_11    LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month1_12    LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month2_1     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month2_2     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month2_3     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month2_4     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month2_5     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month2_6     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month2_7     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month2_8     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month2_9     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month2_10    LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month2_11    LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month2_12    LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month3_1     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month3_2     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month3_3     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month3_4     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month3_5     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month3_6     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month3_7     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month3_8     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month3_9     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month3_10    LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month3_11    LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month3_12    LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_rowno        LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_amt_1        LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_amt_2        LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_amt_3        LIKE type_file.num5    #No.FUN-680061 SMALLINT
#No.FUN-770033--start--
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01= g_prog
#No.FUN-770033--end--     
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND bgeuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND bgegrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND bgegrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bgeuser', 'bgegrup')
     #End:FUN-980030
 
 
     LET l_sql = " SELECT bge02,bge05,bge06,bge04,bge07,bge09,",
                 " '0','0','0','0','0','0','0','0','0','0','0','0'",
                 " FROM bge_file",
                 " WHERE ", tm.wc CLIPPED
 
    IF cl_null(tm.bge01) THEN
	LET l_sql = l_sql CLIPPED, " AND (bge01 IS NULL OR bge01 = ' ') "
    ELSE
	LET l_sql = l_sql CLIPPED, " AND bge01 ='", tm.bge01, "'"
    END IF
 
    IF NOT cl_null(tm.bge03) THEN
	LET l_sql = l_sql CLIPPED,  " AND bge03 =",tm.bge03
    END IF
 
     IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
     PREPARE r050_prepare1 FROM l_sql
     IF SQLCA.sqlcode !=0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
         EXIT PROGRAM
     END IF
     DECLARE r050_curs1 CURSOR FOR r050_prepare1
#     CALL cl_outnam('abgr050') RETURNING l_name      #No.FUN-770033
#     START REPORT r050_rep TO l_name                 #No.FUN-770033
#     LET g_pageno = 0                                #No.FUN-770033
     FOREACH r050_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
          SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr.bge02         #No.FUN-770033
          IF tm.a = '1' THEN
             CASE
                WHEN sr.bge04 ='1'  LET sr.m1 = sr.bge07
                WHEN sr.bge04 ='2'  LET sr.m2 = sr.bge07
                WHEN sr.bge04 ='3'  LET sr.m3 = sr.bge07
                WHEN sr.bge04 ='4'  LET sr.m4 = sr.bge07
                WHEN sr.bge04 ='5'  LET sr.m5 = sr.bge07
                WHEN sr.bge04 ='6'  LET sr.m6 = sr.bge07
                WHEN sr.bge04 ='7'  LET sr.m7 = sr.bge07
                WHEN sr.bge04 ='8'  LET sr.m8 = sr.bge07
                WHEN sr.bge04 ='9'  LET sr.m9 = sr.bge07
                WHEN sr.bge04 ='10' LET sr.m10 = sr.bge07
                WHEN sr.bge04 ='11' LET sr.m11 = sr.bge07
                WHEN sr.bge04 ='12' LET sr.m12 = sr.bge07
             END CASE
          END IF
          IF tm.a = '2' THEN
             CASE
                WHEN sr.bge04 ='1'  LET sr.m1 = sr.bge09
                WHEN sr.bge04 ='2'  LET sr.m2 = sr.bge09
                WHEN sr.bge04 ='3'  LET sr.m3 = sr.bge09
                WHEN sr.bge04 ='4'  LET sr.m4 = sr.bge09
                WHEN sr.bge04 ='5'  LET sr.m5 = sr.bge09
                WHEN sr.bge04 ='6'  LET sr.m6 = sr.bge09
                WHEN sr.bge04 ='7'  LET sr.m7 = sr.bge09
                WHEN sr.bge04 ='8'  LET sr.m8 = sr.bge09
                WHEN sr.bge04 ='9'  LET sr.m9 = sr.bge09
                WHEN sr.bge04 ='10' LET sr.m10 = sr.bge09
                WHEN sr.bge04 ='11' LET sr.m11 = sr.bge09
                WHEN sr.bge04 ='12' LET sr.m12 = sr.bge09
             END CASE
           END IF
           IF tm.a ='3' THEN
              CASE
                 WHEN sr.bge04 ='1'  LET sr.m1 = sr.bge07+sr.bge09
                 WHEN sr.bge04 ='2'  LET sr.m2 = sr.bge07+sr.bge09
                 WHEN sr.bge04 ='3'  LET sr.m3 = sr.bge07+sr.bge09
                 WHEN sr.bge04 ='4'  LET sr.m4 = sr.bge07+sr.bge09
                 WHEN sr.bge04 ='5'  LET sr.m5 = sr.bge07+sr.bge09
                 WHEN sr.bge04 ='6'  LET sr.m6 = sr.bge07+sr.bge09
                 WHEN sr.bge04 ='7'  LET sr.m7 = sr.bge07+sr.bge09
                 WHEN sr.bge04 ='8'  LET sr.m8 = sr.bge07+sr.bge09
                 WHEN sr.bge04 ='9'  LET sr.m9 = sr.bge07+sr.bge09
                 WHEN sr.bge04 ='10' LET sr.m10 = sr.bge07+sr.bge09
                 WHEN sr.bge04 ='11' LET sr.m11 = sr.bge07+sr.bge09
                 WHEN sr.bge04 ='12' LET sr.m12 = sr.bge07+sr.bge09
              END CASE
           END IF
           IF cl_null(sr.m1) THEN LET sr.m1 = 0 END IF
           IF cl_null(sr.m2) THEN LET sr.m1 = 0 END IF
           IF cl_null(sr.m3) THEN LET sr.m1 = 0 END IF
           IF cl_null(sr.m4) THEN LET sr.m1 = 0 END IF
           IF cl_null(sr.m5) THEN LET sr.m1 = 0 END IF
           IF cl_null(sr.m6) THEN LET sr.m1 = 0 END IF
           IF cl_null(sr.m7) THEN LET sr.m1 = 0 END IF
           IF cl_null(sr.m8) THEN LET sr.m1 = 0 END IF
           IF cl_null(sr.m9) THEN LET sr.m1 = 0 END IF
           IF cl_null(sr.m10) THEN LET sr.m1 = 0 END IF
           IF cl_null(sr.m11) THEN LET sr.m1 = 0 END IF
           IF cl_null(sr.m12) THEN LET sr.m1 = 0 END IF
#           OUTPUT TO REPORT r050_rep(sr.*)             #No.FUN-770033
           EXECUTE insert_prep USING                                  #No.FUN-770033
                   sr.bge02,l_gem02,sr.bge05,sr.bge06,sr.bge04,       #No.FUN-770033 
                   sr.bge07,sr.bge09,sr.m1,sr.m2,sr.m3,sr.m4,sr.m5,   #No.FUN-770033
                   sr.m6,sr.m7,sr.m8,sr.m9,sr.m10,sr.m11,sr.m12       #No.FUN-770033
           LET sr.bge04='0'  #No.8830
     END FOREACH
#No.FUN-770033--start--
     LET l_sql= "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str= ''
     IF g_zz05 = 'Y' THEN                                                                                                          
      #CALL cl_wcchp(tm.wc,'bge03')   #FUN-7C0048 mark                                                                                             
       CALL cl_wcchp(tm.wc,'bge02')   #FUN-7C0048 mod                                                                                               
            RETURNING tm.wc 
       LET g_str = tm.wc
     END IF
     LET g_str = g_str,";",tm.bge01,";",tm.bge03
     CALL cl_prt_cs3('abgr050','abgr050',l_sql,g_str)
#No.FUN770033--end-- 
#     FINISH REPORT r050_rep                            #No.FUN-770033
     
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)       #No.FUN-770033
END FUNCTION
#No.FUN-770033--start--
{REPORT r050_rep(sr)
DEFINE l_last_sw LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(1),
       g_head1   STRING,
       l_gem02   LIKE gem_file.gem02
DEFINE sr        RECORD
                     bge02     LIKE bge_file.bge02,    #部門
                     bge05     LIKE bge_file.bge05,    #職等
                     bge06     LIKE bge_file.bge06,    #職級
                     bge04     LIKE bge_file.bge04,    #月份
                     bge07     LIKE bge_file.bge07,    #直接人力
                     bge09     LIKE bge_file.bge09,    #間接人力
                     m1        LIKE bge_file.bge07,    #一月份
                     m2        LIKE bge_file.bge07,    #二月份
                     m3        LIKE bge_file.bge07,    #三月份
                     m4        LIKE bge_file.bge07,    #四月份
                     m5        LIKE bge_file.bge07,    #五月份
                     m6        LIKE bge_file.bge07,    #六月份
                     m7        LIKE bge_file.bge07,    #七月份
                     m8        LIKE bge_file.bge07,    #八月份
                     m9        LIKE bge_file.bge07,    #九月份
                     m10       LIKE bge_file.bge07,    #十月份
                     m11       LIKE bge_file.bge07,    #十一月份
                     m12       LIKE bge_file.bge07     #十二月份
                    END RECORD,
 
      l_month1_1     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month1_2     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month1_3     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month1_4     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month1_5     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month1_6     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month1_7     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month1_8     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month1_9     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month1_10    LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month1_11    LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month1_12    LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month2_1     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month2_2     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month2_3     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month2_4     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month2_5     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month2_6     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month2_7     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month2_8     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month2_9     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month2_10    LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month2_11    LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month2_12    LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month3_1     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month3_2     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month3_3     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month3_4     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month3_5     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month3_6     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month3_7     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month3_8     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month3_9     LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month3_10    LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month3_11    LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_month3_12    LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_rowno        LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_amt_1        LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_amt_2        LIKE type_file.num5,   #No.FUN-680061 SMALLINT,
      l_amt_3        LIKE type_file.num5    #No.FUN-680061 SMALLINT,
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.bge02,sr.bge05,sr.bge06
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      LET g_head1 = g_x[10] CLIPPED,tm.bge01,' ',
                    g_x[11] CLIPPED,tm.bge03
      PRINT g_head1
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
            g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],
            g_x[47]
      PRINT g_dash1
      LET l_last_sw = 'n'
      SELECT gem02 INTO l_gem02 FROM gem_file
         WHERE gem01 = sr.bge02
 
   BEFORE GROUP OF sr.bge02
      PRINT COLUMN g_c[31],sr.bge02 CLIPPED,
            COLUMN g_c[32],l_gem02;
 
   AFTER  GROUP OF sr.bge06
      LET  l_month1_1=GROUP SUM(sr.m1)
      LET  l_month1_2=GROUP SUM(sr.m2)
      LET  l_month1_3=GROUP SUM(sr.m3)
      LET  l_month1_4=GROUP SUM(sr.m4)
      LET  l_month1_5=GROUP SUM(sr.m5)
      LET  l_month1_6=GROUP SUM(sr.m6)
      LET  l_month1_7=GROUP SUM(sr.m7)
      LET  l_month1_8=GROUP SUM(sr.m8)
      LET  l_month1_9=GROUP SUM(sr.m9)
      LET  l_month1_10=GROUP SUM(sr.m10)
      LET  l_month1_11=GROUP SUM(sr.m11)
      LET  l_month1_12=GROUP SUM(sr.m12)
      #年度合計
      LET  l_amt_1 = (l_month1_1+l_month1_2+l_month1_3+l_month1_4+
                      l_month1_5+l_month1_6+l_month1_7+l_month1_8+
                      l_month1_9+l_month1_10+l_month1_11+l_month1_12)
      PRINT COLUMN g_c[33], sr.bge05 CLIPPED,
            COLUMN g_c[34], sr.bge06 USING '####',
            COLUMN g_c[35],l_month1_1 USING '##,##&',
            COLUMN g_c[36],l_month1_2 USING '##,##&',
            COLUMN g_c[37],l_month1_3 USING '##,##&',
            COLUMN g_c[38],l_month1_4 USING '##,##&',
            COLUMN g_c[39],l_month1_5 USING '##,##&',
            COLUMN g_c[40],l_month1_6 USING '##,##&',
            COLUMN g_c[41],l_month1_7 USING '##,##&',
            COLUMN g_c[42],l_month1_8 USING '##,##&',
            COLUMN g_c[43],l_month1_9 USING '##,##&',
            COLUMN g_c[44],l_month1_10 USING '##,##&',
            COLUMN g_c[45],l_month1_11 USING '##,##&',
            COLUMN g_c[46],l_month1_12 USING '##,##&',
            COLUMN g_c[47],l_amt_1 USING '###,##&'
 
   AFTER GROUP OF sr.bge02        #各部門的小計
      PRINT g_dash2
      LET l_month2_1 = GROUP SUM(sr.m1)
      LET l_month2_2 = GROUP SUM(sr.m2)
      LET l_month2_3 = GROUP SUM(sr.m3)
      LET l_month2_4 = GROUP SUM(sr.m4)
      LET l_month2_5 = GROUP SUM(sr.m5)
      LET l_month2_6 = GROUP SUM(sr.m6)
      LET l_month2_7 = GROUP SUM(sr.m7)
      LET l_month2_8 = GROUP SUM(sr.m8)
      LET l_month2_9 = GROUP SUM(sr.m9)
      LET l_month2_10 = GROUP SUM(sr.m10)
      LET l_month2_11 = GROUP SUM(sr.m11)
      LET l_month2_12 = GROUP SUM(sr.m12)
      IF  cl_null(l_month2_1) THEN LET l_month2_1=0 END IF
      IF  cl_null(l_month2_2) THEN LET l_month2_2=0 END IF
      IF  cl_null(l_month2_3) THEN LET l_month2_3=0 END IF
      IF  cl_null(l_month2_4) THEN LET l_month2_4=0 END IF
      IF  cl_null(l_month2_5) THEN LET l_month2_5=0 END IF
      IF  cl_null(l_month2_6) THEN LET l_month2_6=0 END IF
      IF  cl_null(l_month2_7) THEN LET l_month2_7=0 END IF
      IF  cl_null(l_month2_8) THEN LET l_month2_8=0 END IF
      IF  cl_null(l_month2_9) THEN LET l_month2_9=0 END IF
      IF  cl_null(l_month2_10) THEN LET l_month2_10=0 END IF
      IF  cl_null(l_month2_11) THEN LET l_month2_11=0 END IF
      IF  cl_null(l_month2_12) THEN LET l_month2_12=0 END IF
 
      LET l_amt_2 = (l_month2_1+l_month2_2+l_month2_3+l_month2_4+
                     l_month2_5+l_month2_6+l_month2_7+l_month2_8+
                     l_month2_9+l_month2_10+l_month2_11+l_month2_12)
      PRINT
      PRINT COLUMN g_c[33],g_x[12] CLIPPED,
            COLUMN g_c[35],l_month2_1 USING '##,##&',
            COLUMN g_c[36],l_month2_2 USING '##,##&',
            COLUMN g_c[37],l_month2_3 USING '##,##&',
            COLUMN g_c[38],l_month2_4 USING '##,##&',
            COLUMN g_c[39],l_month2_5 USING '##,##&',
            COLUMN g_c[40],l_month2_6 USING '##,##&',
            COLUMN g_c[41],l_month2_7 USING '##,##&',
            COLUMN g_c[42],l_month2_8 USING '##,##&',
            COLUMN g_c[43],l_month2_9 USING '##,##&',
            COLUMN g_c[44],l_month2_10 USING '##,##&',
            COLUMN g_c[45],l_month2_11 USING '##,##&',
            COLUMN g_c[46],l_month2_12 USING '##,##&',
            COLUMN g_c[47],l_amt_2 USING '###,##&'
 
 
   ON LAST ROW
      PRINT g_dash2    #各月份的總計
      PRINT
      LET l_last_sw = 'y'
      LET l_month3_1 = SUM(sr.m1)
      LET l_month3_2 = SUM(sr.m2)
      LET l_month3_3 = SUM(sr.m3)
      LET l_month3_4 = SUM(sr.m4)
      LET l_month3_5 = SUM(sr.m5)
      LET l_month3_6 = SUM(sr.m6)
      LET l_month3_8 = SUM(sr.m7)
      LET l_month3_8 = SUM(sr.m8)
      LET l_month3_9 = SUM(sr.m9)
      LET l_month3_10 = SUM(sr.m10)
      LET l_month3_11 = SUM(sr.m11)
      LET l_month3_12 = SUM(sr.m12)
      IF  cl_null(l_month3_1) THEN LET l_month3_1=0 END IF
      IF  cl_null(l_month3_2) THEN LET l_month3_2=0 END IF
      IF  cl_null(l_month3_3) THEN LET l_month3_3=0 END IF
      IF  cl_null(l_month3_4) THEN LET l_month3_4=0 END IF
      IF  cl_null(l_month3_5) THEN LET l_month3_5=0 END IF
      IF  cl_null(l_month3_6) THEN LET l_month3_6=0 END IF
      IF  cl_null(l_month3_7) THEN LET l_month3_7=0 END IF
      IF  cl_null(l_month3_8) THEN LET l_month3_8=0 END IF
      IF  cl_null(l_month3_9) THEN LET l_month3_9=0 END IF
      IF  cl_null(l_month3_10) THEN LET l_month3_10=0 END IF
      IF  cl_null(l_month3_11) THEN LET l_month3_11=0 END IF
      IF  cl_null(l_month3_12) THEN LET l_month3_12=0 END IF
      LET l_amt_3 = (l_month3_1+l_month3_2+l_month3_3+l_month3_4+
                     l_month3_5+l_month3_6+l_month3_7+l_month3_8+
                     l_month3_9+l_month3_10+l_month3_11+l_month3_12)
 
      PRINT COLUMN g_c[33],g_x[13] CLIPPED,
            COLUMN g_c[35], l_month3_1 USING '##,##&',
            COLUMN g_c[36], l_month3_2 USING '##,##&',
            COLUMN g_c[37], l_month3_3 USING '##,##&',
            COLUMN g_c[38], l_month3_4 USING '##,##&',
            COLUMN g_c[39], l_month3_5 USING '##,##&',
            COLUMN g_c[40], l_month3_6 USING '##,##&',
            COLUMN g_c[41], l_month3_7 USING '##,##&',
            COLUMN g_c[42], l_month3_8 USING '##,##&',
            COLUMN g_c[43], l_month3_9 USING '##,##&',
            COLUMN g_c[44], l_month3_10 USING '##,##&',
            COLUMN g_c[45], l_month3_11 USING '##,##&',
            COLUMN g_c[46], l_month3_12  USING '##,##&',
            COLUMN g_c[47], l_amt_3 USING '###,##&'
 
      IF g_zz05 = 'Y' THEN
         CALL cl_wcchp(tm.wc,'bge03')
              RETURNING tm.wc
         PRINT g_dash
         #No.TQC-630166 --start--
#             IF tm.wc[001,070] > ' ' THEN            # for 80
#        PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#             IF tm.wc[071,140] > ' ' THEN
#        PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#             IF tm.wc[141,210] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#             IF tm.wc[211,280] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#             IF tm.wc[001,120] > ' ' THEN            # for 132
#         PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#             IF tm.wc[121,240] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#             IF tm.wc[241,300] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
          CALL cl_prt_pos_wc(tm.wc)
          #No.TQC-630166 ---end---
      END IF
      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,
            COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,
              COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT}
#No.FUN-770033--end--
#Patch....NO.TQC-610035 <001> #
