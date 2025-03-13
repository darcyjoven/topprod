# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: aapr804.4gl
# Descriptions...: 提單收貨差異表
# Date & Author..: 96/01/05  By  Roger
# Modify.........: No.FUN-4C0097 05/01/28 By Nicola 報表架構修改
#                                                   增加列印部門名稱gem02
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.TQC-610053 06/07/03 By Smapmin 修改外部參數接收
 
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-750093 07/05/25 By ve 報表輸出轉為crystal report
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60056 10/06/22 By lutingting GP5.2財務串前段問題整批調整 
# Modify.........: No.FUN-A70139 10/07/29 By lutingting 修正FUN-A60056問題
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.CHI-C80041 12/12/19 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
              wc      LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(600)
              diff    LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1),
              more    LIKE type_file.chr1         # No.FUN-690028 VARCHAR(1)
           END RECORD
DEFINE g_i LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
#     DEFINEl_time LIKE type_file.chr8         #No.FUN-6A0055
DEFINE g_sql    STRING                         #No.FUN-750093
DEFINE g_str    STRING                         #No.FUN-750093
DEFINE l_table  STRING                         #No.FUN-750093
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
#No.FUN-750093 --start--
   LET g_sql="als04.als_file.als04,gem02.gem_file.gem02,als01.als_file.als01,",
             "als02.als_file.als02,alt14.alt_file.alt14,chr8.type_file.chr8,",
             "alt11.alt_file.alt11,alt06.alt_file.alt06,rvb01.rvb_file.rvb01,",
             "chr8_1.type_file.chr8,rvb05.rvb_file.rvb05,rvb07.rvb_file.rvb07"
   LET l_table = cl_prt_temptable('aapr804',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#No.FUN-750093 --end--
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055
   LET g_pdate = ARG_VAL(1)            # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.diff = ARG_VAL(8)   #TQC-610053
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r804_tm(0,0)
   ELSE
      CALL r804()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD 
END MAIN
 
FUNCTION r804_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_cmd          LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   LET p_row = 3 LET p_col = 16
   OPEN WINDOW r804_w AT p_row,p_col
     WITH FORM "aap/42f/aapr804"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.diff = 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
 
      CONSTRUCT BY NAME tm.wc ON als01,als02,als04
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
         CLOSE WINDOW r804_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      INPUT BY NAME tm.diff,tm.more WITHOUT DEFAULTS
 
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
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
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
         CLOSE WINDOW r804_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aapr804'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr804','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.diff CLIPPED,"'",   #TQC-610053
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aapr804',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW r804_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL r804()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r804_w
 
END FUNCTION
 
FUNCTION r804()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#         l_time    LIKE type_file.chr8,           # Used time for running the job  #No.FUN-690028 VARCHAR(8)
          l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT  #No.FUN-690028 VARCHAR(1200)
          l_order   ARRAY[5] OF LIKE faj_file.faj02,      # No.FUN-690028 VARCHAR(10),
          als       RECORD LIKE als_file.*,
          alt       RECORD LIKE alt_file.*,
          rvb       RECORD LIKE rvb_file.*,
          l_gem02   LIKE gem_file.gem02
DEFINE    l_alt15   LIKE type_file.chr8,             #No.FUN-750093
          l_rvb02   LIKE type_file.chr8              #No.FUN-750093
 
   CALL cl_del_data(l_table)                         #No.FUN-750093
#    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND alsuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND alsgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND alsgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('alsuser', 'alsgrup')
   #End:FUN-980030
 
  #FUN-A60056--mod--str-- 
  #LET l_sql = "SELECT als_file.*, alt_file.*, rvb_file.*",
  #            "  FROM als_file, alt_file, OUTER rvb_file",  
   LET l_sql = "SELECT als_file.*, alt_file.* ", 
               "  FROM als_file, alt_file ",                
  #FUN-A60056--mod--end
               " WHERE als01=alt01",
              #"   AND alt_file.alt01=rvb_file.rvb22 AND  alt_file.alt14=rvb_file.rvb04 AND alt_file.alt15=rvb_file.rvb03",   #FUN-A60056
               "   AND ", tm.wc CLIPPED,
               "   AND alsfirm <> 'X' "  #CHI-C80041
   PREPARE r804_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   DECLARE r804_curs1 CURSOR FOR r804_prepare1
 
#   CALL cl_outnam('aapr804') RETURNING l_name       #No.FUN-750093
#   START REPORT r804_rep TO l_name                  #No.FUN-750093
#
#   LET g_pageno = 0                                 #No.FUN-750093
 
  #FOREACH r804_curs1 INTO als.*, alt.*, rvb.*       #FUN-A60056
   FOREACH r804_curs1 INTO als.*, alt.*              #FUN-A60056
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #FUN-A60056--add--str--
      LET l_sql = "SELECT rvb.* FROM ",cl_get_target_table(als.als97,'rvb_file'),
                  " WHERE rvb22 = '",alt.alt01,"'",
                  "   AND rvb04 = '",alt.alt14,"'",
                  "   AND rvb03 = '",alt.alt15,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,als.als97) RETURNING l_sql
      PREPARE sel_rvb FROM l_sql
     #DECLARE sel_rvb_cs CURSOR FOR sel_rvb    #FUN-A70139
     #FOREACH sel_rvb_cs INTO rvb.*            #FUN-A70139
      EXECUTE sel_rvb INTO rvb.*
      #FUN-A60056--add--end
         IF tm.diff = 'Y' THEN
            IF alt.alt14 IS NULL THEN
               CONTINUE FOREACH
            END IF
            IF alt.alt11 = rvb.rvb05 AND alt.alt06 = rvb.rvb07 THEN
               CONTINUE FOREACH
            END IF
         END IF
 
         LET l_gem02 = ''
         SELECT gem02 INTO l_gem02 FROM gem_file
          WHERE gem01 = als.als04
 
#      OUTPUT TO REPORT r804_rep(als.*, alt.*, rvb.*,l_gem02) #No.FUN-750093
   #No.FUN-750093 --start--
         LET l_alt15 = '-',alt.alt15 USING '###&'
         LET l_rvb02 = '-',rvb.rvb02 USING '###&'
        EXECUTE insert_prep USING als.als04,l_gem02,als.als01,als.als02,alt.alt14,
                                  l_alt15,alt.alt11,alt.alt06,rvb.rvb01,
                                  l_rvb02,rvb.rvb05,rvb.rvb07
   #No.FUN-750093 --end--
      #END FOREACH   #FUN-A60056   #FUN-A70139
   END FOREACH
 
#   FINISH REPORT r804_rep                      #No.FUN-750093
#
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len) #No.FUN-750093
#No.FUN-750093 --start--
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    LET g_str = tm.wc
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
    CALL cl_prt_cs3('aapr804','aapr804',l_sql,g_str)
#No.FUN-750093 --end--
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055   #FUN-B80105 MARK
 
END FUNCTION
#No.FUN-750093 --start--mark
{REPORT r804_rep(als,alt,rvb,l_gem02)
   DEFINE l_last_sw LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          als       RECORD LIKE als_file.*,
          alt       RECORD LIKE alt_file.*,
          rvb       RECORD LIKE rvb_file.*,
          l_gem02   LIKE gem_file.gem02,
          l_alt15   LIKE type_file.chr8,        # No.FUN-690028 VARCHAR(6),
          l_rvb02   LIKE type_file.chr8         # No.FUN-690028 VARCHAR(6)
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY als.als01
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         PRINT
         PRINT g_dash[1,g_len]
         PRINTX name = H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
                          g_x[37],g_x[38]
         PRINTX name = H2 g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44]
         PRINT g_dash1
         LET l_last_sw = 'n'
 
      BEFORE GROUP OF als.als01
         PRINTX name = D1 COLUMN g_c[31],als.als04,
                          COLUMN g_c[32],l_gem02,
                          COLUMN g_c[33],als.als01,
                          COLUMN g_c[34],als.als02;
 
      ON EVERY ROW
         LET l_alt15 = '-',alt.alt15 USING '###&' #FUN-590118
         LET l_rvb02 = '-',rvb.rvb02 USING '###&' #FUN-590118
         IF rvb.rvb07 IS NULL THEN
            LET rvb.rvb07 = 0
         END IF
         PRINTX name = D1 COLUMN g_c[35],alt.alt14,
                          COLUMN g_c[36],l_alt15 CLIPPED,
                          COLUMN g_c[37],alt.alt11,
                          COLUMN g_c[38],alt.alt06 USING '###########&.&&'
         PRINTX name = D2 COLUMN g_c[40],rvb.rvb01,
                          COLUMN g_c[41],l_rvb02 CLIPPED,
                          COLUMN g_c[42],rvb.rvb05,
                          COLUMN g_c[43],rvb.rvb07 USING '###########&.&&',
                          COLUMN g_c[44],rvb.rvb07-alt.alt06 USING '###########&.&&'
         PRINT
 
      ON LAST ROW
         PRINT g_dash[1,g_len]
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
         PRINT
         PRINT g_x[9] CLIPPED,COLUMN 25,g_x[10] CLIPPED,COLUMN 50,g_x[11] CLIPPED
         LET l_last_sw = 'y'
 
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
            PRINT
            PRINT g_x[9] CLIPPED,COLUMN 25,g_x[10] CLIPPED,COLUMN 50,g_x[11] CLIPPED
         ELSE
            SKIP 4 LINE
         END IF
 
END REPORT}
#No.FUN-750093 --end-
