# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: acor204.4gl
# Descriptions...: 年度手冊材料報關單明細表
# Date & Author..: 05/01/13 By Elva
# Modify.........: No.TQC-610082 06/04/07 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-770006 07/07/17 By zhoufeng 報表輸出改為Crystal Reports
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-C80041 12/12/21 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(300) # Where condition
              y1      LIKE type_file.dat,          #No.FUN-680069 DATE
              y2      LIKE type_file.dat,          #No.FUN-680069 DATE
              y       LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
              s       LIKE type_file.chr4,         #No.FUN-680069 VARCHAR(3) # Order by sequence
              more    LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1) # Input more condition(Y/N)
           END RECORD
DEFINE   g_i          LIKE type_file.num5,    #count/index for any purpose        #No.FUN-680069 SMALLINT
         g_head1      STRING
DEFINE    g_orderA ARRAY[3] OF LIKE qcs_file.qcs03 #No.FUN-680069 VARCHAR(10)
DEFINE   g_sql        STRING                       #No.FUN-770006
DEFINE   g_str        STRING                       #No.FUN-770006
DEFINE   l_table      STRING                       #No.FUN-770006
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET g_pdate = ARG_VAL(1)
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
#-----------------No.TQC-610082 modify
   LET tm.y1  = ARG_VAL(8)
   LET tm.y2  = ARG_VAL(9)
   LET tm.y   = ARG_VAL(10)
   LET tm.s   = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#-----------------No.TQC-610082 end
   LET g_trace = 'N'                       # default trace off
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
#No.FUN-770006 --start--
   LET g_sql="cnp03.cnp_file.cnp03,cob09.cob_file.cob09,cob02.cob_file.cob02,",
             "cob021.cob_file.cob021,cob04.cob_file.cob04,",
             "cno07.cno_file.cno07,chr20.type_file.chr20,",
             "cno06.cno_file.cno06,cno09.cno_file.cno09,cnp05.cnp_file.cnp05,",
             "cnp05_1.cnp_file.cnp05,cno10.cno_file.cno10,",
             "cno04.cno_file.cno04,cno08.cno_file.cno08"
   LET l_table = cl_prt_temptable('acor204',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#No.FUN-770006 --end--
 
 
   IF cl_null(g_bgjob) or g_bgjob = 'N' THEN
      CALL r204_tm(0,0)
   ELSE
      CALL r204()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION r204_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(1000)
 
   LET p_row = 5 LET p_col = 13
   OPEN WINDOW r204_w AT p_row,p_col
        WITH FORM "aco/42f/acor204"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.y1  = g_today
   LET tm.y2  = g_today
   LET tm.y   = 'N'
   LET tm2.s1 = '1'
   LET tm2.s2 = '2'
   LET tm2.s3 = '3'
   LET tm.more= 'N'
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON cnp15,cno10,cno06,cno01,
                              cno02,cnp03
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
      CLOSE WINDOW r204_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r204_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
   END IF
 
     INPUT BY NAME tm.y1,tm.y2,tm.y,tm2.s1,tm2.s2,tm2.s3,tm.more  WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIElD y1
            IF cl_null(tm.y1) THEN
                NEXT FIELD y1
            END IF
 
      AFTER FIELD y2
            IF cl_null(tm.y2) OR tm.y2 < tm.y1 THEN
                NEXT FIELD y2
            END IF
            IF YEAR(tm.y1)<>YEAR(tm.y2) THEN
               CALL cl_err('acor204','aco-203',1)
               NEXT FIELD y2
            END IF
 
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]"
            THEN NEXT FIELD FORMONLY.more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
     ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()
   AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
 
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
      CLOSE WINDOW r204_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='acor204'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('acor204','9031',1)
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
                         " '",tm.y1 CLIPPED,"'" ,            #No.TQC-610082 add
                         " '",tm.y2 CLIPPED,"'" ,            #No.TQC-610082 add
                         " '",tm.y  CLIPPED,"'" ,            #No.TQC-610082 add
                         " '",tm.s CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('acor204',g_time,l_cmd)
      END IF
      CLOSE WINDOW r204_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r204()
   ERROR ""
END WHILE
   CLOSE WINDOW r204_w
END FUNCTION
 
FUNCTION r204()
   DEFINE l_name    LIKE type_file.chr20,        #No.FUN-680069 VARCHAR(20) # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0063
          l_sql     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(600)
          l_za05    LIKE za_file.za05,
          l_order   ARRAY[5] OF LIKE cno_file.cno08,       #No.FUN-680069 VARCHAR(20)
          sr            RECORD
                               order1 LIKE cno_file.cno08,         #No.FUN-680069 VARCHAR(20)
                               order2 LIKE cno_file.cno08,         #No.FUN-680069 VARCHAR(20)
                               order3 LIKE cno_file.cno08,         #No.FUN-680069 VARCHAR(20)
                               cno01  LIKE cno_file.cno01,
                               cno07  LIKE cno_file.cno07,
                               cno031 LIKE cno_file.cno031,
                               cno04  LIKE cno_file.cno04,
                               cno06  LIKE cno_file.cno06,
                               cno08  LIKE cno_file.cno08,
                               cno10  LIKE cno_file.cno10,
                               cnp03  LIKE cnp_file.cnp03,
                               cnp04  LIKE cnp_file.cnp04,
                               cnp05  LIKE cnp_file.cnp05,
                               msg    LIKE zaa_file.zaa08,         #No.FUN-680069 VARCHAR(8)
                               cno09  LIKE cno_file.cno09
                        END RECORD
   DEFINE l_cnp05sum   LIKE cnp_file.cnp05,                        #No.FUN-770006
          l_cob02      LIKE cob_file.cob02,                        #No.FUN-770006
          l_cob021     LIKE cob_file.cob021,                       #No.FUN-770006
          l_cob04      LIKE cob_file.cob04,                        #No.FUN-770006
          l_cob09      LIKE cob_file.cob09,                        #No.FUN-770006
          l_cnt        LIKE type_file.num5,                        #No.FUN-770006
          l_cnp03      LIKE cnp_file.cnp03                         #No.FUN-770006
 
     CALL cl_del_data(l_table)                                     #No.FUN-770006
     LET l_cnp03 = NULL                                            #No.FUN-770006
     LET l_cnt = 1                                                 #No.FUN-770006
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #        LET tm.wc = tm.wc clipped," AND adduser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #        LET tm.wc = tm.wc clipped," AND addgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #        LET tm.wc = tm.wc clipped," AND addgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('adduser', 'addgrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT '','','',cno01,cno07,cno031,cno04,cno06,",
                 "      cno08,cno10,cnp03,cnp04,cnp05,'',cno09 ",
                 " FROM cno_file,cnp_file ",
                 "WHERE cno01 = cnp01 ",
                 "  AND cno03 = '2' AND ",tm.wc CLIPPED,
                 "  AND cno07 BETWEEN '",tm.y1,"' AND '",tm.y2,"' ",
                 "  AND cnoconf <> 'X' ",  #CHI-C80041
                 "ORDER BY cnp03,cno07 "
     PREPARE r204_prepare1 FROM l_sql
     IF SQLCA.sqlcode !=0 THEN
         CALL cl_err('prepare1:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
         EXIT PROGRAM
     END IF
     DECLARE r204_curs1 CURSOR FOR r204_prepare1
#    CALL cl_outnam('acor204') RETURNING l_name         #No.FUN-770006
#    START REPORT r204_rep TO l_name                    #No.FUN-770006
#    LET g_pageno = 0                                   #No.FUN-770006
     FOREACH r204_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       IF sr.cno031 = '2' AND sr.cno04 = '1' THEN
          CALL cl_getmsg('aco-191',g_lang) RETURNING sr.msg  # 直接進口
       END IF
       IF sr.cno031 = '2' AND sr.cno04 = '2' THEN
          CALL cl_getmsg('aco-192',g_lang) RETURNING sr.msg  # 轉廠進口
       END IF
       IF sr.cno031 = '2' AND sr.cno04 = '5' THEN
          CALL cl_getmsg('aco-193',g_lang) RETURNING sr.msg  # 核銷進口
       END IF
       IF sr.cno031 = '2' AND sr.cno04 = '6' THEN
          CALL cl_getmsg('aco-194',g_lang) RETURNING sr.msg  # 內購進口
       END IF
       IF sr.cno031 = '1' AND sr.cno04 = '1' THEN
          CALL cl_getmsg('aco-195',g_lang) RETURNING sr.msg  # 直接耗用出口
       END IF
       IF sr.cno031 = '1' AND sr.cno04 = '2' THEN
          CALL cl_getmsg('aco-196',g_lang) RETURNING sr.msg  # 轉廠耗用出口
       END IF
       IF sr.cno031 = '1' AND sr.cno04 = '3' THEN
          CALL cl_getmsg('aco-197',g_lang) RETURNING sr.msg  # 材料退港
       END IF
       IF sr.cno031 = '1' AND sr.cno04 = '4' THEN
          CALL cl_getmsg('aco-198',g_lang) RETURNING sr.msg  # 內銷耗用出口
       END IF
       IF sr.cno031 = '1' AND sr.cno04 = '5' THEN
          CALL cl_getmsg('aco-199',g_lang) RETURNING sr.msg  # 核銷出口
       END IF
       IF sr.cno031 = '1' AND sr.cno04 = '6' THEN
          CALL cl_getmsg('aco-200',g_lang) RETURNING sr.msg  # 內購出口
       END IF
       IF sr.cno031 = '1' AND sr.cno04 = '7' THEN
          CALL cl_getmsg('aco-201',g_lang) RETURNING sr.msg  # 轉廠退港
       END IF
       IF sr.cno031 = '3' THEN
          CALL cl_getmsg('aco-202',g_lang) RETURNING sr.msg  # 報廢
       END IF
#No.FUN-770006 --start-- mark
#      FOR g_i = 1 TO 3
#         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.cno07
#                                       LET g_orderA[g_i] = g_x[20]
#              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.cno04
#                                       LET g_orderA[g_i] = g_x[21]
#              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.cno08
#                                       LET g_orderA[g_i] = g_x[22]
#              OTHERWISE LET l_order[g_i] = '-'
#                        LET g_orderA[g_i] = ' '          #清為空白
#         END CASE
#      END FOR
#      LET sr.order1 = l_order[1]
#      LET sr.order2 = l_order[2]
#      LET sr.order3 = l_order[3]
#      OUTPUT TO REPORT r204_rep(sr.*)
#No.FUN-770006 --end--
#No.FUN-770006 --start--
       SELECT cob02,cob021,cob04,cob09
              INTO l_cob02,l_cob021,l_cob04,l_cob09 FROM cob_file
              WHERE cob01 = sr.cnp03
       IF tm.y = 'N' THEN
          LET l_cob09 = sr.cnp03
       END IF
       IF l_cnt = 1 THEN
          LET l_cnp05sum = 0
          IF sr.cno031 = '2' THEN
             LET l_cnp05sum = l_cnp05sum + sr.cnp05
          ELSE
             LET l_cnp05sum = l_cnp05sum - sr.cnp05
          END IF
          EXECUTE insert_prep USING sr.cnp03,l_cob09,l_cob02,l_cob021,l_cob04,
                                    sr.cno07,sr.msg,sr.cno06,sr.cno09,sr.cnp05,
                                    l_cnp05sum,sr.cno10,sr.cno04,sr.cno08
          LET l_cnt = l_cnt+1
          LET l_cnp03 = sr.cnp03
       ELSE
          IF l_cnp03 != sr.cnp03 THEN
             LET l_cnp05sum = 0
          END IF
          IF sr.cno031 = '2' THEN 
             LET l_cnp05sum = l_cnp05sum + sr.cnp05
          ELSE
             LET l_cnp05sum = l_cnp05sum - sr.cnp05
          END IF
          EXECUTE insert_prep USING sr.cnp03,l_cob09,l_cob02,l_cob021,l_cob04,
                                    sr.cno07,sr.msg,sr.cno06,sr.cno09,sr.cnp05,
                                    l_cnp05sum,sr.cno10,sr.cno04,sr.cno08
          LET l_cnt = l_cnt+1
          LET l_cnp03 = sr.cnp03
       END IF
#No.FUN-770006 --end--
     END FOREACH
#    FINISH REPORT r204_rep                      #No.FUN-770006
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len) #No.FUN-770006
#No.FUN-770006 --start--
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'cnp15,cno10,cno06,cno01,                          
                             cno02,cnp03')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = tm.y1,";",tm.y2,";",YEAR(tm.y1),";",
                 tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",g_str
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
     CALL cl_prt_cs3('acor204','acor204',l_sql,g_str)
#No.FUN-770006 --end--
END FUNCTION
#No.FUN-770006 --start-- mark
{REPORT r204_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
          l_cnp05sum   LIKE cnp_file.cnp05,
          l_cob02      LIKE cob_file.cob02,
          l_cob021     LIKE cob_file.cob021,
          l_cob04      LIKE cob_file.cob04,
          l_cob09      LIKE cob_file.cob09,
          l_title      LIKE cob_file.cob08,         #No.FUN-680069 VARCHAR(30)
          sr            RECORD
                               order1 LIKE cno_file.cno08,       #No.FUN-680069 VARCHAR(20)
                               order2 LIKE cno_file.cno08,       #No.FUN-680069 VARCHAR(20)
                               order3 LIKE cno_file.cno08,       #No.FUN-680069 VARCHAR(20)
                               cno01  LIKE cno_file.cno01,
                               cno07  LIKE cno_file.cno07,
                               cno031 LIKE cno_file.cno031,
                               cno04  LIKE cno_file.cno04,
                               cno06  LIKE cno_file.cno06,
                               cno08  LIKE cno_file.cno08,
                               cno10  LIKE cno_file.cno10,
                               cnp03  LIKE cnp_file.cnp03,
                               cnp04  LIKE cnp_file.cnp04,
                               cnp05  LIKE cnp_file.cnp05,       #No.FUN-680069 DEC(13,2)
                               msg    LIKE ze_file.ze03,         #No.FUN-680069 VARCHAR(8)
                               cno09  LIKE cno_file.cno09
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.cnp03,sr.order1,sr.order2,sr.order3,sr.cno07
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<', "/pageno"
      PRINT g_head CLIPPED, pageno_total
      LET l_title = YEAR(tm.y1) CLIPPED,g_x[1]
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,l_title
      LET g_head1 = g_x[13] CLIPPED, g_orderA[1] CLIPPED, '-',
                    g_orderA[2] CLIPPED, '-', g_orderA[3]
      PRINT g_head1
      PRINT g_dash[1,g_len]
      SELECT cob02,cob021,cob04,cob09
        INTO l_cob02,l_cob021,l_cob04,l_cob09 FROM cob_file
       WHERE cob01 = sr.cnp03
      IF tm.y = 'N' THEN
          PRINT COLUMN 1,g_x[9] CLIPPED,sr.cnp03 CLIPPED
      ELSE
          PRINT COLUMN 1,g_x[9] CLIPPED,l_cob09 CLIPPED
      END IF
      PRINT COLUMN 1,g_x[10] CLIPPED,l_cob02 CLIPPED
      PRINT COLUMN 1,g_x[23] CLIPPED,l_cob021 CLIPPED,
            COLUMN (g_len-30)/2,g_x[11] CLIPPED,tm.y1,'--',tm.y2,
            COLUMN (g_len-14),g_x[12] CLIPPED,l_cob04
      PRINT g_x[5]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],
            g_x[35],g_x[36],g_x[37],g_x[38]
      PRINT g_dash1
      LET l_last_sw='n'
 
   BEFORE GROUP OF sr.cnp03
         LET l_cnp05sum = 0
         SKIP TO TOP OF PAGE
 
   ON EVERY ROW
       IF sr.cno031 = '2' THEN
          LET l_cnp05sum = l_cnp05sum + sr.cnp05
       ELSE
          LET l_cnp05sum = l_cnp05sum - sr.cnp05
       END IF
       PRINT COLUMN g_c[31],sr.cno07,
             COLUMN g_c[32],sr.msg,
             COLUMN g_c[33],sr.cno06,
             COLUMN g_c[34],sr.cno09,
             COLUMN g_c[35],sr.cnp05,
             COLUMN g_c[36],l_cnp05sum USING '##########&.&&&',
             COLUMN g_c[37],sr.cno10,
             COLUMN g_c[38],g_x[5]
 
   ON LAST ROW
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED,
            COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED,
              COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT}
#No.FUN-770006 --end--
