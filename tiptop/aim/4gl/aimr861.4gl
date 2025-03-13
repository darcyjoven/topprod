# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: aimr861.4gl
# Descriptions...: 未盤標籤清冊－在製工單
# Input parameter: 
# Return code....: 
# Date & Author..: 93/05/19 By Apple
# Modify.........: No:9752 04/07/13 By Mandy 在case tm.a when '3'時,其l_sql中的pie30 is null or pie40 is null請加括號
# Modify.........: No.FUN-510017 05/01/12 By Mandy 報表轉XML
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-5C0005 06/01/11 By kevin 結束位置調整
# Modify.........: No.TQC-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
#
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/07 By baogui 無列印順序
# Modify.........: No.FUN-7B0139 07/12/05 By zhaijie 報表輸出改為Crystal Report 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60080 10/07/08 By destiny 报表显示增加制程段号字段
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                          # Print condition RECORD
           wc      STRING,                 # Where Condition  #TQC-630166
           a       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           s       LIKE type_file.chr3,    #No.FUN-690026 VARCHAR(03)
           t       LIKE type_file.chr3,    #No.FUN-690026 VARCHAR(03)
           more    LIKE type_file.chr1     # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
           END RECORD
#NO.FUN-7B0139-----------START----MARK------
#       l_orderA      ARRAY[3] OF LIKE imm_file.imm13,    #TQC-6A0088
#       g_str       LIKE zaa_file.zaa08     #No.FUN-690026 VARCHAR(20)
#DEFINE g_i         LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
#NO.FUN-7B0139---------END-----MARK--------
 
DEFINE    g_sql     STRING                  #NO.FUN-7B0139
DEFINE    g_str     STRING                  #NO.FUN-7B0139
DEFINE    l_table   STRING                  #NO.FUN-7B0139
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
#NO.FUN-7B0139----------start----------
   LET g_sql = "peo.type_file.chr1,",
               "pid01.pid_file.pid01,",
               "pid02.pid_file.pid02,",
               "pid03.pid_file.pid03,",
               "pie02.pie_file.pie02,",
               "pie03.pie_file.pie03,",
               "pie07.pie_file.pie07,",
               "sfb02.sfb_file.sfb02,",
               "sfb04.sfb_file.sfb04,",
               "sfb15.sfb_file.sfb15,",
               "l_ima02.ima_file.ima02,",
               "l_ima021.ima_file.ima021,",
               "l_ima02_r.ima_file.ima02,",
               "l_ima021_r.ima_file.ima021,",
               "pie012.pie_file.pie012,",  #NO.FUN-A60080
               "pie013.pie_file.pie013"  #NO.FUN-A60080
   LET l_table = cl_prt_temptable('aimr861',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = " INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?,?)" #NO.FUN-A60080 add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#NO.FUN-7B0139--------end--------
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
  #LET tm.s  = ARG_VAL(8)      #TQC-610072
   LET tm.a  = ARG_VAL(8)      #TQC-610072
   LET tm.s  = ARG_VAL(9)
   LET tm.t  = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL aimr861_tm(0,0)        # Input print condition
      ELSE CALL aimr861()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION aimr861_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_cmd          LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   LET p_row = 4 LET p_col = 12
 
   OPEN WINDOW aimr861_w AT p_row,p_col
        WITH FORM "aim/42f/aimr861" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a    = '3'
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
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pid01,pid02,pid03,sfb15,sfb04,sfb02 
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
 LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW aimr861_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
#UI
   INPUT BY NAME tm.a,
                 #UI
                 tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3,
                 tm.more WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a 
         IF tm.a IS NULL OR tm.a NOT MATCHES'[123]' 
         THEN NEXT FIELD a
         END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
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
      LET INT_FLAG = 0 CLOSE WINDOW aimr861_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aimr861'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr861','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr861',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW aimr861_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aimr861()
   ERROR ""
END WHILE
   CLOSE WINDOW aimr861_w
END FUNCTION
 
FUNCTION aimr861()
   DEFINE l_name    LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0074
          l_sql     STRING,                 # RDSQL STATEMENT     #TQC-630166
          l_chr     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_za05    LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE ima_file.ima01,      #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
          sr        RECORD order1 LIKE ima_file.ima01,    #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                           order2 LIKE ima_file.ima01,    #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                           order3 LIKE ima_file.ima01,    #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                           peo    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
                           pid01  LIKE pid_file.pid01,
                           pid02  LIKE pid_file.pid02,
                           pid03  LIKE pid_file.pid03,
                           pie02  LIKE pie_file.pie02,
                           pie03  LIKE pie_file.pie03,
                           pie07  LIKE pie_file.pie07,
                           pie30  LIKE pie_file.pie30,
                           pie40  LIKE pie_file.pie40,
                           sfb02  LIKE sfb_file.sfb02,
                           sfb04  LIKE sfb_file.sfb04,
                           sfb15  LIKE sfb_file.sfb15,
                           pie012 lIKE pie_file.pie012, #NO.FUN-A60080
                           pie013 lIKE pie_file.pie013  #NO.FUN-A60080
                    END RECORD
   DEFINE l_ima02       LIKE ima_file.ima02                #No.FUN-7B0139
   DEFINE l_ima021      LIKE ima_file.ima021               #No.FUN-7B0139
   DEFINE l_ima02_r     LIKE ima_file.ima02                #No.FUN-7B0139
   DEFINE l_ima021_r    LIKE ima_file.ima021               #No.FUN-7B0139
   DEFINE l_t           STRING                             #NO.FUN-A60080
     CALL cl_del_data(l_table)                             #NO.FUN-7B0139
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aimr861'    #NO.FUN-7B0139
     LET l_sql = "SELECT '','','','',",
                 "       pid01, pid02, pid03, ",
                 "       pie02, pie03, pie07, pie30, pie40,",
                 "       sfb02, sfb04, sfb15,pie012,pie013 ", #NO.FUN-A60080
                 "  FROM pid_file, pie_file,sfb_file",
                 " WHERE pid01 = pie01 AND pid02 = sfb01 ",
                 "   AND (pie02 is not null and pie02 !=' ')",
                 "   AND sfb87!='X' AND ",tm.wc
     CASE tm.a
       WHEN '1' LET l_sql = l_sql clipped,
                 "   AND pie30 is null "         ## or pie30 = ' ')"
       WHEN '2' LET l_sql = l_sql clipped,
                 "   AND pie40 is null "        ## or pie40 = ' ')"
       WHEN '3' LET l_sql = l_sql clipped,
                 "   AND (pie30 is null ",       ##  or pie30 = ' ' ", #No:9752
                 "    OR  pie40 is null )"       ##  or pie40 = ' ')"  #No:9752
       OTHERWISE EXIT CASE
     END CASE 
 
     PREPARE aimr861_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE aimr861_curs1 CURSOR FOR aimr861_prepare1
#NO.FUN-7B0139-------------------START-----MARK------
#     CALL cl_outnam('aimr861') RETURNING l_name
#     START REPORT aimr861_rep TO l_name
#     LET g_str = ' '
#     CASE tm.a
#       WHEN '1'  LET g_str = g_x[14] clipped
#       WHEN '2'  LET g_str = g_x[15] clipped
#       WHEN '3'  LET g_str = g_x[16] clipped
#       OTHERWISE EXIT CASE
#     END CASE
#     LET g_pageno = 0
#NO.FUN-7B0139----------END-------MARK-----------
     FOREACH aimr861_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1) 
          EXIT FOREACH 
       END IF
       IF tm.a = '3' THEN 
          IF sr.pie30 IS NULL       #OR sr.pie30 = ' ' )
              AND sr.pie40 IS NULL  # OR sr.pie40 = ' ')
          THEN LET sr.peo = '&'
          ELSE 
               IF sr.pie40 IS NULL  #OR sr.pie40 = ' '
               THEN LET sr.peo = '*'
               END IF
          END IF
       END IF
#NO.FUN-7B0139----------END-------MARK-----------
#       FOR g_i = 1 TO 3
#          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.pid01
#                                        LET l_orderA[g_i] = g_x[53]     #TQC-6A0088
#               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.pid02
#                                        LET l_orderA[g_i] = g_x[54]     #TQC-6A0088
#               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.pid03
#                                        LET l_orderA[g_i] = g_x[55]     #TQC-6A0088
#               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.sfb15 USING 'yyyymmdd'
#                                        LET l_orderA[g_i] = g_x[50]     #TQC-6A0088
#               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.sfb04 
#                                        LET l_orderA[g_i] = g_x[51]     #TQC-6A0088
#               WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.sfb02 
#                                        LET l_orderA[g_i] = g_x[52]     #TQC-6A0088
#               OTHERWISE LET l_order[g_i] = '-'
#                                        LET l_orderA[g_i] = ''     #TQC-6A0088
#          END CASE
#       END FOR
#       LET sr.order1 = l_order[1]
#       LET sr.order2 = l_order[2]
#       LET sr.order3 = l_order[3]
#       OUTPUT TO REPORT aimr861_rep(sr.*)
#NO.FUN-7B0139----------END-------MARK-----------
#NO.FUN-7B0139----------start--------------
      SELECT ima02,ima021 INTO l_ima02,l_ima021
        FROM ima_file
      WHERE ima01 = sr.pid03
      IF SQLCA.sqlcode THEN
          LET l_ima02  = NULL
          LET l_ima021 = NULL
      END IF
 
      SELECT ima02,ima021 INTO l_ima02_r,l_ima021_r
        FROM ima_file
       WHERE ima01 = sr.pie02
      IF SQLCA.sqlcode THEN
          LET l_ima02_r  = NULL
          LET l_ima021_r = NULL
      END IF
      EXECUTE insert_prep USING 
         sr.peo,sr.pid01,sr.pid02,sr.pid03,sr.pie02,sr.pie03,sr.pie07,
         sr.sfb02,sr.sfb04,sr.sfb15,l_ima02,l_ima021,l_ima02_r,l_ima021_r,
         sr.pie012,sr.pie013 #NO.FUN-A60080
    
#NO.FUN-7B0139---------end---------------
     END FOREACH
 
#     FINISH REPORT aimr861_rep                                 #NO.FUN-7B0139
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)               #NO.FUN-7B0139
#NO.FUN-7B0139---------start---------------
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'pid01,pid02,pid03,sfb15,sfb04,sfb02')
        RETURNING tm.wc
     END IF
     LET g_str = tm.wc,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
                 tm.a,";",tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3]
     #NO.FUN-A60080--begin
     IF g_sma.sma541='N' THEN 
        LET l_t='aimr861'
     ELSE 
        LET l_t='aimr861_1'  
     END IF 
     #CALL cl_prt_cs3('aimr861','aimr861',g_sql,g_str)
     CALL cl_prt_cs3('aimr861',l_t,g_sql,g_str)
     #NO.FUN-A60080--end
     
#NO.FUN-7B0139---------end---------------
END FUNCTION
 
#NO.FUN-7B0139---------start-----mark--------
#REPORT aimr861_rep(sr)
#   DEFINE l_ima02      LIKE ima_file.ima02     #FUN-510017
#   DEFINE l_ima021     LIKE ima_file.ima021    #FUN-510017
#   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#          sr           RECORD order1 LIKE ima_file.ima01,    #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#                              order2 LIKE ima_file.ima01,    #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#                              order3 LIKE ima_file.ima01,    #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#                              peo    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#                              pid01  LIKE pid_file.pid01,
#                              pid02  LIKE pid_file.pid02,
#                              pid03  LIKE pid_file.pid03,
#                              pie02  LIKE pie_file.pie02,
#                              pie03  LIKE pie_file.pie03,
#                              pie07  LIKE pie_file.pie07,
#                              pie30  LIKE pie_file.pie30,
#                              pie40  LIKE pie_file.pie40,
#                              sfb02  LIKE sfb_file.sfb02,
#                              sfb04  LIKE sfb_file.sfb04,
#                              sfb15  LIKE sfb_file.sfb15
#                       END RECORD
 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.order1,sr.order2,sr.order3,sr.pid01,sr.pid02,sr.pie07
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno" 
#      PRINT g_head CLIPPED,pageno_total     
#      PRINT g_str
#      PRINT g_x[9] CLIPPED,l_orderA[1] CLIPPED,                # TQC-6A0088                                                         
#                       '-',l_orderA[2] CLIPPED,'-',l_orderA[3] CLIPPED  # TQC-6A0088
#      PRINT g_dash
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40], 
#            g_x[41]
#      PRINT g_dash1 
#      LET l_last_sw = 'n'
 
#   BEFORE GROUP OF sr.order1
#      IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.order2
#      IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#         THEN SKIP TO TOP OF PAGE
#      END IF
 
#   BEFORE GROUP OF sr.order3
#      IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#         THEN SKIP TO TOP OF PAGE
#      END IF
 
#   BEFORE GROUP OF sr.pid02
#      SELECT ima02,ima021 INTO l_ima02,l_ima021
#        FROM ima_file
#       WHERE ima01 = sr.pid03
#      IF SQLCA.sqlcode THEN
#          LET l_ima02  = NULL
#          LET l_ima021 = NULL
#      END IF
#      PRINT COLUMN g_c[31],sr.pid01,
#            COLUMN g_c[32],sr.pid02,
#            COLUMN g_c[33],sr.pid03,
#            COLUMN g_c[34],l_ima02,
#            COLUMN g_c[35],l_ima021;
 
#   ON EVERY ROW 
#      SELECT ima02,ima021 INTO l_ima02,l_ima021
#        FROM ima_file
#       WHERE ima01 = sr.pie02
#      IF SQLCA.sqlcode THEN
#          LET l_ima02  = NULL
#          LET l_ima021 = NULL
#      END IF
#      PRINT COLUMN g_c[36],sr.peo,
#            COLUMN g_c[37],sr.pie07 USING '###&',
#            COLUMN g_c[38],sr.pie02,
#            COLUMN g_c[39],l_ima02,
#            COLUMN g_c[40],l_ima021,
#            COLUMN g_c[41],sr.pie03 
#
#   AFTER GROUP OF sr.pid02
#      PRINT ' '
 
#   ON LAST ROW
#      IF tm.a = '3' THEN 
#         PRINT g_x[17] CLIPPED,' ',
#               g_x[18] CLIPPED,' ',
#               g_x[19] CLIPPED
#      END IF
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#         CALL cl_wcchp(tm.wc,'pid01,pid02,pid03,sfb15,sfb04,sfb02')
#              RETURNING tm.wc
#         PRINT g_dash
##TQC-630166
#             IF tm.wc[001,070] > ' ' THEN            # for 80
#        PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#             IF tm.wc[071,140] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
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
#         CALL cl_prt_pos_wc(tm.wc)
#      END IF
#      PRINT g_dash #No.TQC-5C0005
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN IF tm.a = '3' THEN 
#                   PRINT ''
#                   PRINT g_x[17] CLIPPED,' ',
#                         g_x[18] CLIPPED,' ',
#                         g_x[19] CLIPPED
#              ELSE SKIP 2 LINE
#              END IF
#              PRINT g_dash #No.TQC-5C0005
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 4 LINE
#      END IF
#END REPORT
#NO.FUN-7B0139---------------end--------mark-------
