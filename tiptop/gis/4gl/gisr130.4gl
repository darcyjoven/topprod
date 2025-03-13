# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: gisr130.4gl
# Descriptions...: 銷項發票底稿差異清單
# Date & Author..: 02/04/16 By Danny
# Modify.........: No.FUN-510024 05/01/28 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-690009 06/09/04 By Dxfwo  欄位類型定義
 
# Modify.........: No.FUN-6A0098 06/10/26 By atsea l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80047 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-BB0047 12/01/06 By fengrui  調整時間函數問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                           # Print condition RECORD
              wc      LIKE type_file.chr1000,  #NO FUN-690009 VARCHAR(1000)  # Where condition
              more    LIKE type_file.chr1      #NO FUN-690009 VARCHAR(1)     # Input more condition(Y/N)
              END RECORD
 
DEFINE   g_i          LIKE type_file.num5      #NO FUN-690009 SMALLINT    #count/index for any purpose
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GIS")) THEN
      EXIT PROGRAM
   END IF
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   #No.FUN-570264 ---end---
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80047--add--
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL gisr130_tm(0,0)        # Input print condition
      ELSE CALL gisr130()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80047--add--
END MAIN
 
FUNCTION gisr130_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01      #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,     #NO FUN-690009 SMALLINT
          l_cmd          LIKE type_file.chr1000   #NO FUN-690009 VARCHAR(400)
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 14
   END IF
   OPEN WINDOW gisr130_w AT p_row,p_col
        WITH FORM "gis/42f/gisr130"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON isa01,isa03,isa04,isa05
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
      LET INT_FLAG = 0 CLOSE WINDOW gisr130_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80047--add--
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW gisr130_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80047--add--
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='gisr130'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('gisr130','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('gisr130',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW gisr130_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80047--add--
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL gisr130()
   ERROR ""
END WHILE
   CLOSE WINDOW gisr130_w
END FUNCTION
 
FUNCTION gisr130()
   DEFINE l_name    LIKE type_file.chr20,    #NO FUN-690009 VARCHAR(20)   # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0098
          l_sql     LIKE type_file.chr1000,  #NO FUN-690009 VARCHAR(1000) # RDSQL STATEMENT
          l_za05    LIKE type_file.chr50,    #NO FUN-690009 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE type_file.chr20,   #NO FUN-690009 VARCHAR(20)
          sr        RECORD
                    isa    RECORD LIKE isa_file.*,
                    isc05  LIKE isc_file.isc05
                    END RECORD
        #No.FUN-B80047--mark--Begin---
        #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0098
        #No.FUN-B80047--mark--End-----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND isauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND isagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND isagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('isauser', 'isagrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT isa_file.*,isc05 ",
                 "  FROM isa_file,isc_file ",
                 " WHERE isa01 = isc01 AND isa04 = isc04 ",
                 "   AND ",tm.wc CLIPPED
     PREPARE gisr130_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80047--add--
        EXIT PROGRAM
     END IF
     DECLARE gisr130_curs1 CURSOR FOR gisr130_prepare1
 
     CALL cl_outnam('gisr130') RETURNING l_name
     START REPORT gisr130_rep TO l_name
 
     LET g_pageno = 0
     FOREACH gisr130_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF sr.isa.isa08 != sr.isc05 AND sr.isa.isa08t != sr.isc05 THEN
          OUTPUT TO REPORT gisr130_rep(sr.*)
       END IF
     END FOREACH
 
     FINISH REPORT gisr130_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #No.FUN-BB0047--mark--Begin---
     #  CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0098
     #No.FUN-BB0047--mark--End-----
END FUNCTION
 
REPORT gisr130_rep(sr)
  DEFINE  l_last_sw LIKE type_file.chr1,         #NO FUN-690009 VARCHAR(1)
          sr        RECORD
                    isa    RECORD LIKE isa_file.*,
                    isc05  LIKE isc_file.isc05
                    END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.isa.isa01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      PRINT COLUMN g_c[31],sr.isa.isa01,
            COLUMN g_c[32],sr.isa.isa03,
            COLUMN g_c[33],sr.isa.isa02,
            COLUMN g_c[34],sr.isa.isa04,
            COLUMN g_c[35],cl_numfor(sr.isa.isa08,35,g_azi04),
            COLUMN g_c[36],cl_numfor(sr.isa.isa08t,36,g_azi04),
            COLUMN g_c[37],cl_numfor(sr.isc05,37,g_azi04)
 
   ON LAST ROW
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
