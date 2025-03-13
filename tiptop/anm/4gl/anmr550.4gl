# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: anmr550.4gl
# Descriptions...: 借款狀況明細表
# Date & Author..: 99/05/26 By Kammy
# Modify.........: No.7354 03/10/28 By Kitty 列印改為小數4位
# Modify.........: No.FUN-4C0098 05/01/03 By pengu 報表轉XML
# Modify.........: No.MOD-590002 05/09/05 By vivien 報表結構修改
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-C40191 12/04/23 By lujh 利率到小數點第6位
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                             # Print condition RECORD
              wc     LIKE type_file.chr1000      #No.FUN-680107 VARCHAR(600)
              END RECORD,
          l_dash    LIKE type_file.chr1000,      #No.FUN-680107 VARCHAR(100)
          bdate     LIKE type_file.dat,          #No.FUN-680107 DATE
          l_sw      LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE   g_head1         STRING
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                              # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
 
   LET g_pdate = ARG_VAL(1)             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)   #TQC-610058
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   #No.FUN-570264 ---end---
 
  IF cl_null(g_bgjob) OR g_bgjob = 'N'             # If background job sw is off
      THEN CALL anmr550_tm()                    # Input print condition
      ELSE CALL anmr550()                       # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr550_tm()
   DEFINE p_row,p_col   LIKE type_file.num5,         #No.FUN-680107 SMALLINT
          l_cmd         LIKE type_file.chr1000,      #No.FUN-680107 VARCHAR(400)
          l_flag        LIKE type_file.chr1,         #是否必要欄位有輸入 #No.FUN-680107 VARCHAR(1)
          l_jmp_flag    LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
   LET p_row = 6 LET p_col = 12
   OPEN WINDOW anmr550_w AT p_row,p_col
        WITH FORM "anm/42f/anmr550"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET bdate=g_today
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
WHILE TRUE
       CONSTRUCT BY NAME tm.wc ON nmm01,nmm02
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
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
 END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
       IF INT_FLAG THEN
          LET INT_FLAG = 0 CLOSE WINDOW anmr550_w 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
          EXIT PROGRAM
             
       END IF
       IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
 
    #  ON ACTION CONTROLG CALL cl_cmdask()        # Command execution
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
             WHERE zz01='anmr550'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr550','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('anmr550',g_time,l_cmd)  # Execute cmd at later time
      END IF
      CLOSE WINDOW anmr550_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr550()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr550_w
END FUNCTION
 
FUNCTION anmr550()
   DEFINE l_name        LIKE type_file.chr20,              # External(Disk) file name       #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8            #No.FUN-6A0082
          l_sql         LIKE type_file.chr1000,            # RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200)
          l_za05        LIKE type_file.chr1000,            #標題內容 #No.FUN-680107 VARCHAR(40)
          l_order       ARRAY[2] OF LIKE cre_file.cre08,   #No.FUN-680107 ARRAY[2] OF VARCHAR(10) #排列順序
          sr            RECORD
                         nmm01    LIKE nmm_file.nmm01,
                         nmm02    LIKE nmm_file.nmm02,
                         nmn04    LIKE nmn_file.nmn04,
                         nmn06    LIKE nmn_file.nmn06,
                         nmn05    LIKE nmn_file.nmn05,
                         nmn07    LIKE nmn_file.nmn07,
                         nmn08    LIKE nmn_file.nmn08,
                         nmm04    LIKE nmm_file.nmm04,
                         nmm03    LIKE nmm_file.nmm03
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND nmmuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND nmmgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND nmmgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmmuser', 'nmmgrup')
     #End:FUN-980030
 
   CALL cl_outnam('anmr550') RETURNING l_name
   START REPORT anmr550_rep TO l_name
   LET g_pageno = 0
       LET l_sql = "SELECT nmm01,nmm02,nmn04,nmn06,nmn05,nmn07,nmn08,nmm04,",
                   " nmm03",
                   " FROM nmn_file,nmm_file",
                  #" WHERE nmn01 = ",tm.nmm01,
                  #" AND nmn02 = ",tm.nmm02,
                   " WHERE ",tm.wc CLIPPED,
                   " AND nmm01 = nmn01",
                   " AND nmm02 = nmn02"
     PREPARE anmr550_prepare0 FROM l_sql
     DECLARE anmr550_curs0 CURSOR FOR anmr550_prepare0
     FOREACH anmr550_curs0 INTO sr.*
       IF STATUS THEN CALL cl_err('p00:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
          EXIT PROGRAM 
       END IF
     OUTPUT TO REPORT anmr550_rep(sr.*)
     END FOREACH
     FINISH REPORT anmr550_rep
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT anmr550_rep(sr)
   DEFINE         l_sw1,l_last_sw LIKE type_file.chr1,       #No.FUN-680107 VARCHAR(1)
                  l_alg02         LIKE alg_file.alg02,       #No.FUN-680107 VARCHAR(16)
                  ret             LIKE csd_file.csd04,       #No.FUN-680107 DEC(7,4)
        sr   RECORD
                  nmm01    LIKE nmm_file.nmm01,
                  nmm02    LIKE nmm_file.nmm02,
                  nmn04    LIKE nmn_file.nmn04,
                  nmn06    LIKE nmn_file.nmn06,
                  nmn05    LIKE nmn_file.nmn05,
                  nmn07    LIKE nmn_file.nmn07,
                  nmn08    LIKE nmn_file.nmn08,
                  nmm04    LIKE nmm_file.nmm04,
                  nmm03    LIKE nmm_file.nmm03
               END RECORD
OUTPUT TOP MARGIN g_top_margin
   LEFT MARGIN g_left_margin
   BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line   #No.MOD-580242
   ORDER BY sr.nmn04
FORMAT
PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      LET g_head1=sr.nmm01 CLIPPED,g_x[9] CLIPPED,sr.nmm02 CLIPPED,g_x[10] CLIPPED
      PRINT g_head1
      PRINT g_dash[1,g_len]
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED
      PRINT g_dash1
 
ON EVERY ROW
       PRINT COLUMN g_c[31],sr.nmn04 CLIPPED,
             COLUMN g_c[32],cl_numfor(sr.nmn06,32,g_azi04),
             COLUMN g_c[33],cl_numfor(sr.nmn05,33,g_azi04),
             COLUMN g_c[34],cl_numfor(sr.nmn07,34,g_azi04),
             COLUMN g_c[35],sr.nmn08 USING '####&',
             COLUMN g_c[36],cl_numfor(sr.nmn07*sr.nmn08,36,g_azi05)
ON LAST ROW
      #PRINT l_dash[1,g_len]
      PRINT g_dash2
      PRINT COLUMN g_c[31],g_x[11] CLIPPED,
            COLUMN g_c[32],cl_numfor(SUM(sr.nmn06),32,g_azi05),
            COLUMN g_c[33],cl_numfor(SUM(sr.nmn05),33,g_azi05),
            COLUMN g_c[34],cl_numfor(SUM(sr.nmn07),34,g_azi05),
            COLUMN g_c[35],SUM(sr.nmn08) USING "####&",
            COLUMN g_c[36],cl_numfor(SUM(sr.nmn07*sr.nmn08),36,g_azi05)
      PRINT ''
      PRINT COLUMN g_c[31],g_x[12] CLIPPED,
            COLUMN g_c[32],cl_numfor(sr.nmm04,32,g_azi05),
            COLUMN g_c[33],g_x[13] CLIPPED,
            COLUMN g_c[34],sr.nmm03 CLIPPED USING "##&.######%",   #No:7354   #TQC-C40191  mod  ####%--->######%
            COLUMN g_c[35],g_x[14] CLIPPED,
            COLUMN g_c[36],sr.nmm03/SUM(sr.nmn08) USING "##&.######%"    #No:7354     #TQC-C40191  mod  ####%--->######%
 
      PRINT
      #IF l_last_sw = 'y'
      PRINT g_dash[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED  #MOD-590002
PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,
              COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
