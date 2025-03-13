# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: asfr616.4gl
# Descriptions...: 工單齊料套數明細表
# Date & Author..: 97/07/23  By  Sophia
# Modify.........: NO.FUN-510029 05/01/13 By Carol 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.FUN-680121 06/08/31 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: NO.FUN-7B0139 07/12/07 By zhaijie 報表輸出改為Crystal Report
# Modify.........: No.FUN-910053 09/02/12 By jan sma74-->ima153
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A60027 10/06/18 by sunchenxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No.TQC-C20238 12/02/16 By destiny sfb18 >sfb15 
# Modify.........: No:FUN-C70037 12/08/16 By lixh1 CALL s_minp增加傳入日期參數,報表類程式傳入空
# Modify.........: No.TQC-C90063 12/09/17 By chenjing 工單編號，部門編碼欄位增加開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
#             wc      VARCHAR(600),    #TQC-630166
              wc      STRING,       #TQC-630166
              s       LIKE type_file.chr3,          #No.FUN-680121 VARCHAR(3)
              t       LIKE type_file.chr3,          #No.FUN-680121 VARCHAR(3)
              u       LIKE type_file.chr3,          #No.FUN-680121 VARCHAR(3)
              more    LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)
              END RECORD,
          g_ordera  ARRAY[5] OF LIKE type_file.chr1000  #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE g_sql      STRING                                         #NO.FUN-7B0139
DEFINE g_str      STRING                                         #NO.FUN-7B0139
DEFINE l_table    STRING                                         #NO.FUN-7B0139
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 #FUN-BB0047 mark
#NO.FUN-7B0139------------start---------------
   LET g_sql = "sfb01.sfb_file.sfb01,",
               "sfb18.sfb_file.sfb18,",
               "sfb05.sfb_file.sfb05,",
               "sfb82.sfb_file.sfb82,",
               "sfb08.sfb_file.sfb08,",
               "sfb081.sfb_file.sfb081,",
               "min_set.sfb_file.sfb09,",
               "sfb09.sfb_file.sfb09,",
               "l_ima02.ima_file.ima02,",
               "l_ima021.ima_file.ima021"
   LET l_table = cl_prt_temptable('asfr616',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?)" 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#NO.FUN-7B0139------------end-----------
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r616_tm(0,0)
      ELSE CALL r616()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION r616_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680121 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 12
   END IF
 
   OPEN WINDOW r616_w AT p_row,p_col
        WITH FORM "asf/42f/asfr616"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
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
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.u3   = tm.u[3,3]
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
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON sfb01,sfb82,sfb05,sfb18
#No.FUN-570240 --start--
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION controlp
        #TQC-C90063--add--start--
            IF INFIELD(sfb01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_sfb_3"
               LET g_qryparam.state = "c"
               CAlL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO sfb01
               NEXT FIELD sfb01
            END IF
            IF INFIELD(sfb82) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_sfb82"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO sfb82
               NEXT FIELD sfb82
            END IF  
        #TQC-C90063--add--end--
            IF INFIELD(sfb05) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO sfb05
               NEXT FIELD sfb05
            END IF
#No.FUN-570240 --end--
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
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
         CLOSE WINDOW r520_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
      END IF
      IF tm.wc != ' 1=1' THEN EXIT WHILE END IF
      CALL cl_err('',9046,0)
   END WHILE
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                   tm2.t1,tm2.t2,tm2.t3,
                   tm2.u1,tm2.u2,tm2.u3,
                   tm.more  WITHOUT DEFAULTS
 
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
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
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
      CLOSE WINDOW r616_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='asfr616'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asfr616','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
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
                         " '",tm.u CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('asfr616',g_time,l_cmd)
      END IF
      CLOSE WINDOW r616_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r616()
   ERROR ""
END WHILE
   CLOSE WINDOW r616_w
END FUNCTION
 
FUNCTION r616()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
#         l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT   #TQC-630166        #No.FUN-680121 VARCHAR(1000)
          l_sql     STRING,          # RDSQL STATEMENT   #TQC-630166
          l_chr     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_cnt     LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_za05    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          l_order   ARRAY[4] OF LIKE sfb_file.sfb05,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
          sr        RECORD
                    order1   LIKE sfb_file.sfb05,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                    order2   LIKE sfb_file.sfb05,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                    order3   LIKE sfb_file.sfb05,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                    sfb01    LIKE sfb_file.sfb01,
                   #sfb18    LIKE sfb_file.sfb18,        #TQC-C20238
                    sfb15    LIKE sfb_file.sfb15,        #TQC-C20238
                    sfb05    LIKE sfb_file.sfb05,
                    sfb82    LIKE sfb_file.sfb82,
                    sfb08    LIKE sfb_file.sfb08,
                    sfb081   LIKE sfb_file.sfb081,
                    min_set  LIKE sfb_file.sfb09,          #No.FUN-680121 DEC(12,3)
                    sfb09    LIKE sfb_file.sfb09
                    END RECORD
   DEFINE l_ima02      LIKE ima_file.ima02                  #FUN-7B0139
   DEFINE l_ima021     LIKE ima_file.ima021                 #FUN-7B0139
   DEFINE l_ima153     LIKE ima_file.ima153   #FUN-910053 
 
     CALL cl_del_data(l_table)                              #FUN-7B0139
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aimr997'      #FUN-7B0139
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND sfbuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
     #End:FUN-980030
     LET tm.wc=cl_replace_str(tm.wc, 'sfb18', 'sfb15') #TQC-C20238 
     
     LET l_sql = "SELECT '','','',",
                #"sfb01,sfb18,sfb05,sfb82,sfb08,sfb081,0,sfb09", #TQC-C20238
                 "sfb01,sfb15,sfb05,sfb82,sfb08,sfb081,0,sfb09", #TQC-C20238
                 " FROM sfb_file",
                 " WHERE ", tm.wc CLIPPED ,
                 "   AND sfb04 <> '8' AND sfb87!='X' " #No.B333 add 010510 by linda
 
     PREPARE r616_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
     END IF
     DECLARE r616_curs1 CURSOR FOR r616_prepare1
#     CALL cl_outnam('asfr616') RETURNING l_name           #NO.FUN-7B0139
#     START REPORT r616_rep TO l_name                      #NO.FUN-7B0139
#     LET g_pageno = 0                                     #NO.FUN_7B0139 
#     FOR g_i = 1 TO 5                                     #NO.FUN-7B0139
#         LET g_ordera[g_i]= NULL                          #NO.FUN-7B0139
#     END FOR                                              #NO.FUN-7B0139
     FOREACH r616_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          CALL s_get_ima153(sr.sfb05) RETURNING l_ima153  #FUN-910053  
         #CALL s_minp(sr.sfb01,g_sma.sma73,g_sma.sma74,'')
         #CALL s_minp(sr.sfb01,g_sma.sma73,l_ima153,'','','')  #FUN-A60027   #FUN-C70037 mark
          CALL s_minp(sr.sfb01,g_sma.sma73,l_ima153,'','','','')  #FUN-C70037 
               RETURNING l_cnt,sr.min_set
          IF l_cnt != 0 THEN LET sr.min_set = 0 END IF
#NO.FUN-7B0139------------start----mark-------
#          FOR g_i = 1 TO 3
#              CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.sfb01
#                                            LET g_ordera[g_i]= g_x[09]
#                   WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.sfb82
#                                            LET g_ordera[g_i]= g_x[10]
#                   WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.sfb05
#                                            LET g_ordera[g_i]= g_x[11]
#                   WHEN tm.s[g_i,g_i] = '4'
#                        LET l_order[g_i] = sr.sfb18 USING 'YYYYMMDD'
#                        LET g_ordera[g_i]= g_x[12]
#                   OTHERWISE LET l_order[g_i]  = '-'
#                             LET g_ordera[g_i] = ' '          #清為空白
#              END CASE
#          END FOR
#          LET sr.order1 = l_order[1]
#          LET sr.order2 = l_order[2]
#          LET sr.order3 = l_order[3]
#         OUTPUT TO REPORT r616_rep(sr.*)
#NO.FUN-7B0139------------end----mark-------
#NO.FUN-7B0139------------start-----------
      LET l_ima02 = ''
      LET l_ima021= ''
      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
       WHERE ima01 = sr.sfb05
       
      EXECUTE insert_prep USING 
         sr.sfb01,sr.sfb15,sr.sfb05,sr.sfb82,sr.sfb08,sr.sfb081,sr.min_set,
         sr.sfb09,l_ima02,l_ima021
#NO.FUN-7B0139------------end-----------
     END FOREACH
 
#     FINISH REPORT r616_rep                               #NO.FUN-7B0139
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)          #NO.FUN-7B0139
#NO.FUN-7B0139--------start------------
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'sfb01,sfb82,sfb05,sfb18')
           RETURNING tm.wc
     END IF
     LET g_str = tm.wc,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
                 tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",
                 tm.u[1,1],";",tm.u[2,2],";",tm.u[3,3]                 
     CALL cl_prt_cs3('asfr616','asfr616',g_sql,g_str)                      
#NO.FUN-7B0139--------end------------
END FUNCTION
 
#NO.FUN-7B0139--------MARK------START---------
#REPORT r616_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
#          l_ima02      LIKE ima_file.ima02,
#          l_ima021     LIKE ima_file.ima021,
#          l_str        LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(80)
#          sr        RECORD
#                    order1   LIKE sfb_file.sfb05,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
#                    order2   LIKE sfb_file.sfb05,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
#                    order3   LIKE sfb_file.sfb05,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
#                    sfb01    LIKE sfb_file.sfb01,
#                    sfb18    LIKE sfb_file.sfb18,
#                    sfb05    LIKE sfb_file.sfb05,
#                    sfb82    LIKE sfb_file.sfb82,
#                    sfb08    LIKE sfb_file.sfb08,
#                    sfb081   LIKE sfb_file.sfb081,
#                    min_set  LIKE sfb_file.sfb09,          #No.FUN-680121 DEC(12,3)
#                    sfb09    LIKE sfb_file.sfb09
#                    END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
 
#  ORDER BY sr.order1,sr.order2,sr.order3
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED, pageno_total
#      PRINT ''
 
#      PRINT g_dash
#      PRINT g_x[31],
#            g_x[32],
#            g_x[33],
#            g_x[34],
#            g_x[35],
#            g_x[36],
#            g_x[37],
#            g_x[38],
#            g_x[39]
#      PRINT g_dash1
 
 
#   BEFORE GROUP OF sr.order1
#      IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#         THEN SKIP TO TOP OF PAGE
#      END IF
 
#   BEFORE GROUP OF sr.order2
#      IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#         THEN SKIP TO TOP OF PAGE
#      END IF
 
#   BEFORE GROUP OF sr.order3
#      IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#         THEN SKIP TO TOP OF PAGE
#      END IF
 
#   ON EVERY ROW
#      LET l_ima02 = ''
#      LET l_ima021= ''
#      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
#       WHERE ima01 = sr.sfb05
#      PRINT COLUMN g_c[31],sr.sfb01,
#            COLUMN g_c[32],sr.sfb18,
#            COLUMN g_c[33],sr.sfb05,
#            COLUMN g_c[34],l_ima02,
#            COLUMN g_c[35],l_ima021,
#            COLUMN g_c[36],sr.sfb08   USING '--------------&',
#            COLUMN g_c[37],sr.sfb081  USING '--------------&',
#            COLUMN g_c[38],sr.min_set USING '--------------&',
#            COLUMN g_c[39],sr.sfb09   USING '--------------&'
 
#   AFTER GROUP OF sr.order1
#      IF tm.u[1,1] = 'Y' THEN
#         LET l_str = g_ordera[1] CLIPPED,g_x[15] CLIPPED
#         PRINT COLUMN g_c[35],l_str CLIPPED,
#               COLUMN g_c[36],GROUP SUM(sr.sfb08)   USING '--------------&',
#               COLUMN g_c[37],GROUP SUM(sr.sfb081)  USING '--------------&',
#               COLUMN g_c[38],GROUP SUM(sr.min_set) USING '--------------&',
#               COLUMN g_c[39],GROUP SUM(sr.sfb09)   USING '--------------&'
#         PRINT ''
#      END IF
 
#   AFTER GROUP OF sr.order2
#      IF tm.u[2,2] = 'Y' THEN
#         LET l_str = g_ordera[2] CLIPPED,g_x[14] CLIPPED
#         PRINT COLUMN g_c[35],l_str CLIPPED,
#               COLUMN g_c[36],GROUP SUM(sr.sfb08)   USING '--------------&',
#               COLUMN g_c[37],GROUP SUM(sr.sfb081)  USING '--------------&',
#               COLUMN g_c[38],GROUP SUM(sr.min_set) USING '--------------&',
#               COLUMN g_c[39],GROUP SUM(sr.sfb09)   USING '--------------&'
#         PRINT ''
#      END IF
 
#   AFTER GROUP OF sr.order3
#      IF tm.u[3,3] = 'Y' THEN
#         LET l_str = g_ordera[3] CLIPPED,g_x[13] CLIPPED
#         PRINT COLUMN g_c[35],l_str CLIPPED,
#               COLUMN g_c[36],GROUP SUM(sr.sfb08)   USING '--------------&',
#               COLUMN g_c[37],GROUP SUM(sr.sfb081)  USING '--------------&',
#               COLUMN g_c[38],GROUP SUM(sr.min_set) USING '--------------&',
#               COLUMN g_c[39],GROUP SUM(sr.sfb09)   USING '--------------&'
#         PRINT ''
#      END IF
 
  
#   ON LAST ROW
#      NEED 5 LINES
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#         CALL cl_wcchp(tm.wc,'sfb01,sfb82,sfb05,sfb18')  #TQC-630166
#              RETURNING tm.wc
 
 #TQC-630166-start
#         CALL cl_prt_pos_wc(tm.wc) 
#             IF tm.wc[001,070] > ' ' THEN            # for 80
#        PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#             IF tm.wc[071,140] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#             IF tm.wc[141,210] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#             IF tm.wc[211,280] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#TQC-630166-end
#      END IF
#      PRINT g_dash     
#      PRINT g_x[4] CLIPPED, COLUMN g_c[39], g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#              PRINT g_x[4] CLIPPED, COLUMN g_c[39], g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#NO.FUN-7B0139----------MARK------END--------
