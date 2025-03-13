# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: apmr710.4gl
# Descriptions...: 採購料件預計到庫狀況表
# Input parameter:
# Return code....:
# Date & Author..: 92/12/28 By Keith
# Modify.........: No.FUN-4C0095 05/01/05 By Mandy 報表轉XML
# Modify.........: No.FUN-570243 05/07/25 By vivien 料件編號欄位增加controlp
# Modify.........: No.TQC-610085 06/04/06 By Claire Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680136 06/09/05 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.TQC-6A0079 06/10/30 By king 改正被誤定義為apm08類型的
# Modify.........: No.TQC-6B0095 06/11/16 By Ray 報表寬度不符
# Modify.........: No.FUN-7A0036 07/11/08 By zhoufeng 報表打印改為Crystal Report
# Modify.........: No.TQC-940009 09/04/08 By sabrina 未交量 (pmn20 - (pmn50 - pmn55))<=0不印出
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-C80147 12/09/17 By jt_chen 未交量應包含退貨換貨量
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
             #wc      LIKE type_file.chr1000,   # 料件編號、採購單號、廠商編號範圍   #TQC-630166 mark 	#No.FUN-680136
              wc      STRING,                   # 料件編號、採購單號、廠商編號範圍   #TQC-630166
              vdate   LIKE type_file.dat,       #N o.FUN-680136 DATE    # 截止到庫日
              more    LIKE type_file.chr1       # 是否輸入其它特殊列印條件(Y|N)      #No.FUN-680136 VARCHAR(1)
              END RECORD,
              g_p              LIKE type_file.num5,     #No.FUN-680136 SMALLINT
              g_num            LIKE type_file.num5   	#No.FUN-680136 SMALLINT
 
   DEFINE     g_i              LIKE type_file.num5      #count/index for any purpose #No.FUN-680136 SMALLINT
   DEFINE     g_sql            STRING                   #No.FUN-7A0036
   DEFINE     g_str            STRING                   #No.FUN-7A0036
   DEFINE     l_table          STRING                   #No.FUN-7A0036
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
 
   #No.FUN-7A0036 --start--
   LET g_sql="pmn35.pmn_file.pmn35,pmn04.pmn_file.pmn04,",
             "pmn041.pmn_file.pmn041,ima021.ima_file.ima021,",
             "pmn01.pmn_file.pmn01,pmn02.pmn_file.pmn02,pmm09.pmm_file.pmm09,",
             "pmc03.pmc_file.pmc03,pmn20.pmn_file.pmn20,pmn50.pmn_file.pmn50"
   LET l_table = cl_prt_temptable('apmr710',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-7A0036 --end--
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.vdate = ARG_VAL(8)
#----------------No.TQC-610085 modify
  #LET tm.more  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#----------------No.TQC-610085 end
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL apmr710_tm(0,0)        # Input print condition
   ELSE
      CALL apmr710()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION apmr710_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01          #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 5 LET p_col = 12
 
   OPEN WINDOW apmr710_w AT p_row,p_col WITH FORM "apm/42f/apmr710"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more    = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pmn04,pmm01,pmm09
 
#No.FUN-570243 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP
            IF INFIELD(pmn04) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmn04
               NEXT FIELD pmn04
            END IF
#No.FUN-570243 --end
 
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
      CLOSE WINDOW apmr710_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.more      # Condition
   INPUT BY NAME tm.vdate, tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
            NEXT FIELD more
         END IF
         IF tm.more = "Y" THEN
             CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
          CALL cl_cmdask()           # COMMAND EXECUTION
 
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
      CLOSE WINDOW apmr710_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
                  WHERE zz01='apmr710'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr710','9031',1)
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
                         " '",tm.vdate CLIPPED,"'",
                        #" '",tm.more CLIPPED,"'",          #No.TQC-610085 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmr710',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW apmr710_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr710()
   ERROR ""
END WHILE
CLOSE WINDOW apmr710_w
END FUNCTION
 
FUNCTION apmr710()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name            #No.FUN-680136 VARCHAR(20)
          l_time    LIKE type_file.chr8,          # Used time for running the job       #No.FUN-680136 VARCHAR(8)
         #l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT   #TQC-630166 mark  #No.FUN-680136 VARCHAR(1000)
          l_sql     STRING,                       # RDSQL STATEMENT   #TQC-630166
          l_chr     LIKE type_file.chr1,          # No.FUN-680136 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       # No.FUN-680136 VARCHAR(40)
     #    l_order   ARRAY[5] OF LIKE apm_file.apm08, 	#No.FUN-680136 VARCHAR(10)#No.TQC-6A0079
          sr        RECORD
                       pmn35 LIKE pmn_file.pmn35,
                       pmn04 LIKE pmn_file.pmn04,
                       pmn041 LIKE pmn_file.pmn041,
                       pmn01 LIKE pmn_file.pmn01,
                       pmn02 LIKE pmn_file.pmn02,
                       pmm09 LIKE pmm_file.pmm09,
                       pmc03 LIKE pmc_file.pmc03,
                       pmn20 LIKE pmn_file.pmn20,
                       pmn50 LIKE pmn_file.pmn50
                    END RECORD
   DEFINE l_ima021  LIKE ima_file.ima021          #No.FUN-7A0036
 
   CALL cl_del_data(l_table)                      #No.FUN-7A0036
 
   SELECT zo02 INTO g_company FROM zo_file
                  WHERE zo01 = g_rlang
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND pmmuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND pmmgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND pmmgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
   #End:FUN-980030
 
   LET l_sql = "SELECT pmn35, pmn04, pmn041, pmn01, pmn02, pmm09, ",
             # "       pmc03, pmn20, pmn50 ",
               "       pmc03, pmn20, (pmn50-pmn55-pmn58) ",  #No.B553 010519 by linda   #MOD-C80147 add pmn58
               "  FROM pmn_file,pmm_file,OUTER pmc_file ",
               " WHERE pmn01 = pmm01",
               "  AND pmm_file.pmm09 = pmc_file.pmc01 ",
               "  AND (pmn20 - (pmn50 - pmn55 - pmn58)) > 0 ",     #TQC-940009 add      #MOD-C80147 add pmn58
               "  AND pmn16 not IN ('6','7','8','9') "
 
   IF tm.vdate = ' ' OR tm.vdate IS NULL THEN
      LET l_sql = l_sql CLIPPED,' AND ',tm.wc CLIPPED,' ORDER BY pmn35'
   ELSE
      LET l_sql = l_sql CLIPPED," AND pmn35 <= '",tm.vdate,"' AND ",
                  tm.wc CLIPPED," ORDER BY pmn35"
   END IF
   PREPARE apmr710_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
       EXIT PROGRAM
   END IF
   DECLARE apmr710_curs1 CURSOR FOR apmr710_prepare1
 
#   CALL cl_outnam('apmr710') RETURNING l_name        #No.FUN-7A0036
#   START REPORT apmr710_rep TO l_name                #No.FUN-7A0036
#
#   LET g_pageno = 0                                  #No.FUN-7A0036
#   CALL cl_prt_pos_len()                             #No.FUN-7A0036
   FOREACH apmr710_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0  THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      IF sr.pmn20 IS NULL THEN LET sr.pmn20 = 0  END IF
      IF sr.pmn50 IS NULL THEN LET sr.pmn50 = 0  END IF
#      OUTPUT TO REPORT apmr710_rep(sr.*)             #No.FUN-7A0036
      #No.FUN-7A0036 --start--
      SELECT ima021 INTO l_ima021 FROM ima_file WHERE ima01=sr.pmn04
      IF SQLCA.sqlcode THEN
         LET l_ima021 = NULL
      END IF
      EXECUTE insert_prep USING sr.pmn35,sr.pmn04,sr.pmn041,l_ima021,sr.pmn01,
                                sr.pmn02,sr.pmm09,sr.pmc03,sr.pmn20,sr.pmn50
      #No.FUN-7A0036 --end--
   END FOREACH
 
#   FINISH REPORT apmr710_rep                  #No.FUN-7A0036
#
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)#No.FUN-7A0036
   #No.FUN-7A0036 --start--
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'pmn04,pmm01,pmm09')
           RETURNING tm.wc
      LET g_str=tm.wc
   END IF
   LET g_str=g_str
   LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   CALL cl_prt_cs3('apmr710','apmr710',l_sql,g_str)
   #No.FUN-7A0036 --end--
END FUNCTION
#No.FUN-7A0036 --start-- mark
{REPORT apmr710_rep(sr)
   DEFINE l_ima021     LIKE ima_file.ima021     #FUN-4C0095
   DEFINE l_last_sw    LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
          l_pointer    LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
          l_pt         LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
          l_cnt,l_n    LIKE type_file.num5,     #No.FUN-680136 SMALLINT
          sr        RECORD
                       pmn35 LIKE pmn_file.pmn35,
                       pmn04 LIKE pmn_file.pmn04,
                       pmn041 LIKE pmn_file.pmn041,
                       pmn01 LIKE pmn_file.pmn01,
                       pmn02 LIKE pmn_file.pmn02,
                       pmm09 LIKE pmm_file.pmm09,
                       pmc03 LIKE pmc_file.pmc03,
                       pmn20 LIKE pmn_file.pmn20,
                       pmn50 LIKE pmn_file.pmn50
                       END RECORD
   OUTPUT   TOP MARGIN g_top_margin
           LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
           PAGE LENGTH g_page_line
   ORDER BY sr.pmn35,sr.pmn04
   FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
 
   BEFORE GROUP OF sr.pmn35
      PRINT COLUMN g_c[31],sr.pmn35;
 
   ON EVERY ROW
      SELECT ima021
        INTO l_ima021
        FROM ima_file
       WHERE ima01=sr.pmn04
      IF SQLCA.sqlcode THEN
          LET l_ima021 = NULL
      END IF
      PRINT COLUMN g_c[32],sr.pmn04,
            COLUMN g_c[33],sr.pmn041,
            COLUMN g_c[34],l_ima021,
            COLUMN g_c[35],sr.pmn01,
            COLUMN g_c[36],sr.pmn02 USING '########',
            COLUMN g_c[37],sr.pmm09,
            COLUMN g_c[38],sr.pmc03,
            COLUMN g_c[39],cl_numfor(sr.pmn20,39,3),
            COLUMN g_c[40],cl_numfor(sr.pmn20-sr.pmn50,40,3)
 
ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
          CALL cl_wcchp(tm.wc,'pmn04,pmm01,pmm09')
                  RETURNING tm.wc
          PRINT g_dash
         #TQC-630166
         #IF tm.wc[001,070] > ' ' THEN            # for 80
         #    PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
         #IF tm.wc[071,140] > ' ' THEN
         #    PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
         #IF tm.wc[141,210] > ' ' THEN
         #    PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
         #IF tm.wc[211,280] > ' ' THEN
         #    PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
         CALL cl_prt_pos_wc(tm.wc)
         #END TQC-630166
      END IF
      LET l_last_sw = 'y'
      PRINT g_dash
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[40], g_x[7] CLIPPED    #No.TQC-6B0095
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED    #No.TQC-6B0095
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
          PRINT g_dash
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[40], g_x[6] CLIPPED    #No.TQC-6B0095
          PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED    #No.TQC-6B0095
      ELSE
          SKIP 2 LINE
      END IF
END REPORT}
#No.FUN-7A0036 --end--
