# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: abgr090.4gl
# Descriptions...: 應徵人員明細表
# Date & Author..: 00/12/1 By Wiky
# Modify.........: No.FUN-510025 05/01/13 By Smapmin 報表轉XML格式
# Modify.........: No.TQC-610054 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680061 06/08/25 By cheunl 欄位型態定義,改為LIKE 
# Modify.........: No.FUN-690106 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-770033 07/07/24 By destiny 報表改為使用crystal report
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           ch      LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(1)
           more    LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(1)
           bgo01   LIKE bgo_file.bgo01,
           #bgo03  LIKE bgo_file.bgo03,
           bgo06   LIKE bgo_file.bgo06,
           wc      STRING                 #No.TQC-630166
           END RECORD
DEFINE   g_i       LIKE type_file.num5    #count/index for any purpose #No.FUN-680061 SMALLINT
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690106
#No.FUN-770033--start--                                                                                                             
    LET g_sql="bgo03.bgo_file.bgo03,",                                                                                              
              "bgo02.bgo_file.bgo02,",                                                                                              
              "bgo07.bgo_file.bgo07,",                                                                                              
              "m1.bgo_file.bgo10,",                                                                                            
              "m2.bgo_file.bgo10,",                                                                                            
              "m3.bgo_file.bgo10,",
              "m4.bgo_file.bgo10,",
              "m5.bgo_file.bgo10,",
              "m6.bgo_file.bgo10,",
              "m7.bgo_file.bgo10,",
              "m8.bgo_file.bgo10,",
              "m9.bgo_file.bgo10,",
              "m10.bgo_file.bgo10,",
              "m11.bgo_file.bgo10,",
              "m12.bgo_file.bgo10"
 
     LET l_table = cl_prt_temptable('abgr090',g_sql) CLIPPED                                                                        
     IF l_table= -1 THEN EXIT PROGRAM END IF                                                                                        
     LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"                                                                           
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN 
       CALL cl_err('insert_prep',status,1) EXIT PROGRAM                                                                             
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
   LET tm.bgo01 = ARG_VAL(8)   #TQC-610054
   LET tm.bgo06 = ARG_VAL(9)   #TQC-610054
   LET tm.ch = ARG_VAL(10)   #TQC-610054
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF NOT cl_null(tm.ch) THEN
       CALL r090()
   ELSE
       CALL r090_tm(0,0)
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
END MAIN
 
FUNCTION r090_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5   #No.FUN-680061 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000#No.FUN-680061 VARCHAR(1000)
 
IF p_row = 0 THEN LET p_row = 5 LET p_col = 13 END IF
   LET p_row = 5 LET p_col = 13
   OPEN WINDOW r090_w AT p_row,p_col
        WITH FORM "abg/42f/abgr090"
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
    LET tm.bgo01=' '  #MOD-550185
   CONSTRUCT BY NAME tm.wc ON bgo03             #組QBE
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
      CLOSE WINDOW r090_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
      LET tm.ch ='N'
      DISPLAY BY NAME tm.ch
 
INPUT BY NAME tm.bgo01,tm.bgo06,tm.ch,tm.more
      WITHOUT DEFAULTS HELP 1
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD bgo01
         IF cl_null(tm.bgo01) THEN LET tm.bgo01 = ' ' END IF
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      AFTER FIELD bgo06                    #輸入年度，不可空白不可小於0
         IF tm.bgo06<0 or cl_null(tm.bgo06) THEN NEXT FIELD bgo06 END IF
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
      CLOSE WINDOW r090_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='abgr090'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abgr090','9031',1)
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
                         " '",tm.bgo01 CLIPPED,"'",   #TQC-610054
                         " '",tm.bgo06 CLIPPED,"'",   #TQC-610054
                         " '",tm.ch CLIPPED,"'",   #TQC-610054
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         IF g_trace = 'Y' THEN ERROR l_cmd END IF
         CALL cl_cmdat('abgr090',g_time,l_cmd)
      END IF
      CLOSE WINDOW r090_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r090()
   ERROR ""
END WHILE
   CLOSE WINDOW r090_w
END FUNCTION
 
FUNCTION r090()
DEFINE l_name    LIKE type_file.chr20    #No.FUN-680061 VARCHAR(20)
#     DEFINEl_time LIKE type_file.chr8        #No.FUN-6A0056
DEFINE l_sql     LIKE type_file.chr1000  # RDSQL STATEMENT #No.FUN-680061 VARCHAR(1000)
DEFINE l_za05    LIKE type_file.chr1000  #No.FUN-680061 VARCHAR(40)
DEFINE l_order   ARRAY[5] OF LIKE cre_file.cre08 #No.FUN-680061 VARCHAR(10)
DEFINE sr        RECORD
                     bgo03    LIKE bgo_file.bgo03,    #主類別編號
                     bgo02    LIKE bgo_file.bgo02,    #設備名稱
                     bgo07    LIKE bgo_file.bgo07,    #期別
                     money    LIKE bgo_file.bgo10,    #金額
                     m1       LIKE bgo_file.bgo10,    #一月份
                     m2       LIKE bgo_file.bgo10,    #二月份
                     m3       LIKE bgo_file.bgo10,    #三月份
                     m4       LIKE bgo_file.bgo10,    #四月份
                     m5       LIKE bgo_file.bgo10,    #五月份
                     m6       LIKE bgo_file.bgo10,    #六月份
                     m7       LIKE bgo_file.bgo10,    #七月份
                     m8       LIKE bgo_file.bgo10,    #八月份
                     m9       LIKE bgo_file.bgo10,    #九月份
                     m10      LIKE bgo_file.bgo10,    #十月份
                     m11      LIKE bgo_file.bgo10,    #十一月份
                     m12      LIKE bgo_file.bgo10     #十二月份
                 END RECORD,
      l_month1_1     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month1_2     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month1_3     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month1_4     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month1_5     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month1_6     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month1_7     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month1_8     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month1_9     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month1_10    LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month1_11    LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month1_12    LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month2_1     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month2_2     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month2_3     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month2_4     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month2_5     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month2_6     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month2_7     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month2_8     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month2_9     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month2_10    LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month2_11    LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month2_12    LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month3_1     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month3_2     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month3_3     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month3_4     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month3_5     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month3_6     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month3_7     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month3_8     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month3_9     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month3_10    LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month3_11    LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month3_12    LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
          l_rowno    LIKE type_file.num5,   #No.FUN-680061 SMALLINT
          l_amt_1    LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
          l_amt_2    LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
          l_amt_3    LIKE type_file.num20_6 #No.FUN-680061 DEC(20,6)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog       #No.FUN-770033
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND bgouser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND bgogrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND bgogrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bgouser', 'bgogrup')
     #End:FUN-980030
     CALL cl_del_data(l_table)           #No.FUN-770033
  LET l_sql = " SELECT bgo03,bgo02,bgo07,bgo10,",
                 " '0','0','0','0','0','0','0','0','0','0','0','0'",  
                 " FROM bgo_file",
                 " WHERE bgo01 =","'",tm.bgo01,"'",
                 "   AND bgo06 =",tm.bgo06,
                 "   AND ",tm.wc CLIPPED
     LET l_sql = l_sql CLIPPED," ORDER BY bgo03"
     IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
     PREPARE r090_prepare1 FROM l_sql
     IF SQLCA.sqlcode !=0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
         EXIT PROGRAM
     END IF
     DECLARE r090_curs1 CURSOR FOR r090_prepare1
#     CALL cl_outnam('abgr090') RETURNING l_name        #No.FUN-770033
#     START REPORT r090_rep TO l_name                   #No.FUN-770033
     LET g_pageno = 0
     FOREACH r090_curs1 INTO sr.*
 
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
 
     CASE
     WHEN sr.bgo07 ='1'
          LET sr.m1 = sr.money
     WHEN sr.bgo07 ='2'
          LET sr.m2 = sr.money
     WHEN sr.bgo07 ='3'
          LET sr.m3 = sr.money
     WHEN sr.bgo07 ='4'
          LET sr.m4 = sr.money
     WHEN sr.bgo07 ='5'
          LET sr.m5 = sr.money
     WHEN sr.bgo07 ='6'
          LET sr.m6 = sr.money
     WHEN sr.bgo07 ='7'
          LET sr.m7 = sr.money
     WHEN sr.bgo07 ='8'
          LET sr.m8 = sr.money
     WHEN sr.bgo07 ='9'
          LET sr.m9 = sr.money
     WHEN sr.bgo07 ='10'
         LET sr.m10 = sr.money
     WHEN sr.bgo07 ='11'
         LET sr.m11 = sr.money
     WHEN sr.bgo07 ='12'
         LET sr.m12 = sr.money
     END CASE
#No.FUN-770033--start--                                                                                                             
          EXECUTE insert_prep USING
                  sr.bgo03,sr.bgo02,sr.bgo07,sr.m1,sr.m2,sr.m3,sr.m4,
                  sr.m5,sr.m6,sr.m7,sr.m8,sr.m9,sr.m10,sr.m11,sr.m12
#          OUTPUT TO REPORT r090_rep(sr.*)
 
     END FOREACH
     IF g_zz05 = 'Y' THEN                                                                                                           
        CALL cl_wcchp(tm.wc,'bgo03')                                                                                                
             RETURNING tm.wc                                                                                                        
        LET g_str = tm.wc                                                                                                           
     END IF                                                                                                                         
     LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str=tm.bgo01,";",tm.bgo06,";",g_str,";",g_azi04,";",g_azi05
#     FINISH REPORT r090_rep
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     CALL cl_prt_cs3('abgr090','abgr090',l_sql,g_str)
#No.FUN-770033--end-- 
END FUNCTION
#No.FUN-770033-start--
{REPORT r090_rep(sr)
DEFINE l_last_sw    LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(1)
       g_head1      STRING
DEFINE sr           RECORD
                     bgo03    LIKE bgo_file.bgo03,    #主類別編號
                     bgo02    LIKE bgo_file.bgo02,    #設備名稱
                     bgo07    LIKE bgo_file.bgo07,    #期別
                     money    LIKE bgo_file.bgo10,    #金額
                     m1       LIKE bgo_file.bgo10,    #一月份
                     m2       LIKE bgo_file.bgo10,    #二月份
                     m3       LIKE bgo_file.bgo10,    #三月份
                     m4       LIKE bgo_file.bgo10,    #四月份
                     m5       LIKE bgo_file.bgo10,    #五月份
                     m6       LIKE bgo_file.bgo10,    #六月份
                     m7       LIKE bgo_file.bgo10,    #七月份
                     m8       LIKE bgo_file.bgo10,    #八月份
                     m9       LIKE bgo_file.bgo10,    #九月份
                     m10      LIKE bgo_file.bgo10,    #十月份
                     m11      LIKE bgo_file.bgo10,    #十一月份
                     m12      LIKE bgo_file.bgo10     #十二月份
                    END RECORD,
 
      l_month1_1     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
      l_month1_2     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_month1_3     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_month1_4     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_month1_5     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_month1_6     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_month1_7     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_month1_8     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_month1_9     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_month1_10    LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_month1_11    LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_month1_12    LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_month2_1     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_month2_2     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_month2_3     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_month2_4     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_month2_5     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_month2_6     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_month2_7     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_month2_8     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_month2_9     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_month2_10    LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_month2_11    LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_month2_12    LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_month3_1     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_month3_2     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_month3_3     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_month3_4     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_month3_5     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_month3_6     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_month3_7     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_month3_8     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_month3_9     LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_month3_10    LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_month3_11    LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_month3_12    LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_rowno        LIKE type_file.num5,   #No.FUN-680061 SMALLINT
      l_amt_1        LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_amt_2        LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6) 
      l_amt_3        LIKE type_file.num20_6 #No.FUN-680061 DEC(20,6) 
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.bgo03,sr.bgo02
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      LET g_head1 = g_x[11] CLIPPED,tm.bgo01,' ',
                    g_x[12] CLIPPED,tm.bgo06
      PRINT g_head1
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
            g_x[39]   
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.bgo03
      PRINT COLUMN g_c[31],sr.bgo03 CLIPPED;
 
   BEFORE GROUP OF sr.bgo02
     IF sr.bgo02 = 'Y'
        THEN SKIP TO TOP OF PAGE
        PRINT COLUMN g_c[32],sr.bgo02 CLIPPED;
     ELSE
        PRINT COLUMN g_c[32],sr.bgo02 CLIPPED;
     END IF
 
   AFTER GROUP OF sr.bgo02       #年度合計
      LET l_month1_1 = GROUP SUM(sr.m1)
      LET l_month1_2 = GROUP SUM(sr.m2)
      LET l_month1_3 = GROUP SUM(sr.m3)
      LET l_month1_4 = GROUP SUM(sr.m4)
      LET l_month1_5 = GROUP SUM(sr.m5)
      LET l_month1_6 = GROUP SUM(sr.m6)
      LET l_month1_7 = GROUP SUM(sr.m7)
      LET l_month1_8 = GROUP SUM(sr.m8)
      LET l_month1_9 = GROUP SUM(sr.m9)
      LET l_month1_10= GROUP SUM(sr.m10)
      LET l_month1_11= GROUP SUM(sr.m11)
      LET l_month1_12= GROUP SUM(sr.m12)
      LET l_amt_1 = (l_month1_1+l_month1_2+l_month1_3+l_month1_4+l_month1_5+l_month1_6+
                     l_month1_7+l_month1_8+l_month1_9+l_month1_10+l_month1_11+l_month1_12)
      PRINT COLUMN g_c[33],cl_numfor(l_month1_1,33,g_azi04),
            COLUMN g_c[34],cl_numfor(l_month1_2,34,g_azi04),
            COLUMN g_c[35],cl_numfor(l_month1_3,35,g_azi04),
            COLUMN g_c[36],cl_numfor(l_month1_4,36,g_azi04),
            COLUMN g_c[37],cl_numfor(l_month1_5,37,g_azi04),
            COLUMN g_c[38],cl_numfor(l_month1_6,38,g_azi04)
      PRINT COLUMN g_c[33],cl_numfor(l_month1_7,33,g_azi04),
            COLUMN g_c[34],cl_numfor(l_month1_8,34,g_azi04),
            COLUMN g_c[35],cl_numfor(l_month1_9,35,g_azi04),
            COLUMN g_c[36],cl_numfor(l_month1_10,36,g_azi04),
            COLUMN g_c[37],cl_numfor(l_month1_11,37,g_azi04),
            COLUMN g_c[38],cl_numfor(l_month1_12,38,g_azi04),
            COLUMN g_c[39],cl_numfor(l_amt_1,39,g_azi05)
 
 
   AFTER GROUP OF sr.bgo03        #各月份的合計
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
      PRINT COLUMN g_c[32],g_x[10] CLIPPED,
            COLUMN g_c[33],cl_numfor(l_month2_1,33,g_azi04),
            COLUMN g_c[34],cl_numfor(l_month2_2,34,g_azi04),
            COLUMN g_c[35],cl_numfor(l_month2_3,35,g_azi04),
            COLUMN g_c[36],cl_numfor(l_month2_4,36,g_azi04),
            COLUMN g_c[37],cl_numfor(l_month2_5,37,g_azi04),
            COLUMN g_c[38],cl_numfor(l_month2_6,38,g_azi04)
      PRINT COLUMN g_c[33],cl_numfor(l_month2_7,33,g_azi04),
            COLUMN g_c[34],cl_numfor(l_month2_8,34,g_azi04),
            COLUMN g_c[35],cl_numfor(l_month2_9,35,g_azi04),
            COLUMN g_c[36],cl_numfor(l_month2_10,36,g_azi04),
            COLUMN g_c[37],cl_numfor(l_month2_11,37,g_azi04),
            COLUMN g_c[38],cl_numfor(l_month2_12,38,g_azi04)
 
   ON LAST ROW
      PRINT g_dash[1,g_len]      #各月份的總計
      LET l_last_sw = 'y'
      LET l_month3_1 = SUM(sr.m1)
      LET l_month3_2 = SUM(sr.m2)
      LET l_month3_3 = SUM(sr.m3)
      LET l_month3_4 = SUM(sr.m4)
      LET l_month3_5 = SUM(sr.m5)
      LET l_month3_6 = SUM(sr.m6)
      LET l_month3_7 = SUM(sr.m7)
      LET l_month3_8 = SUM(sr.m8)
      LET l_month3_9 = SUM(sr.m9)
      LET l_month3_10 = SUM(sr.m10)
      LET l_month3_11 = SUM(sr.m11)
      LET l_month3_12 = SUM(sr.m12)
      PRINT COLUMN g_c[32],g_x[13] CLIPPED,
            COLUMN g_c[33],cl_numfor(l_month3_1,33,g_azi04),
            COLUMN g_c[34],cl_numfor(l_month3_2,34,g_azi04),
            COLUMN g_c[35],cl_numfor(l_month3_3,35,g_azi04),
            COLUMN g_c[36],cl_numfor(l_month3_4,36,g_azi04),
            COLUMN g_c[37],cl_numfor(l_month3_5,37,g_azi04),
            COLUMN g_c[38],cl_numfor(l_month3_6,38,g_azi04)
      PRINT COLUMN g_c[33],cl_numfor(l_month3_7,33,g_azi04),
            COLUMN g_c[34],cl_numfor(l_month3_8,34,g_azi04),
            COLUMN g_c[35],cl_numfor(l_month3_9,35,g_azi04),
            COLUMN g_c[36],cl_numfor(l_month3_10,36,g_azi04),
            COLUMN g_c[37],cl_numfor(l_month3_11,37,g_azi04),
            COLUMN g_c[38],cl_numfor(l_month3_12,38,g_azi04)
 
      IF g_zz05 = 'Y' THEN
         CALL cl_wcchp(tm.wc,'bgo03')
              RETURNING tm.wc
         PRINT g_dash[1,g_len]
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
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,
              COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT}
#No.FUN-770033--end--
#Patch....NO.TQC-610035 <001> #
