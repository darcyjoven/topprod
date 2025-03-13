# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmr760.4gl
# Descriptions...: 銀行別短期借款明細表(anmr760)
# Date & Author..: 99/02/04 By Billy
# Modify.........: No.FUN-4C0098 05/01/05 By pengu 報表轉XML
# Modify.........: No.FUN-550114 05/05/26 By echo 新增報表備註
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.MOD-5B0224 05/11/22 By Smapmin 借款金額前加上借款幣別
# Modify.........: No.TQC-5C0051 05/12/09 By kevin 欄位沒對齊
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: NO.FUN-7A0036 07/11/07 By zhaijie 改Crystal Report
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                          # Print condition RECORD
              wc      LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(600) #Where Condiction
              more    LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)   #
              END RECORD,
          g_day       LIKE type_file.num5     #No.FUN-680107 SMALLINT
 
   DEFINE g_i         LIKE type_file.num5     #count/index for any purpose #No.FUN-680107 SMALLINT
   DEFINE l_table     STRING             #NO.FUN-7A0036
   DEFINE g_str       STRING             #NO.FUN-7A0036
   DEFINE g_sql       STRING             #NO.FUN-7A0036
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
 
#NO.FUN-7A0036---------start---
   LET g_sql = "code.type_file.chr1,",
               "nne02.nne_file.nne02,",
               "nne04.nne_file.nne04,",
               "nne06.nne_file.nne06,",   
               "nne112.nne_file.nne112,",
               "nne14.nne_file.nne14,",
               "nne19.nne_file.nne19,",
               "alg01.alg_file.alg01,",
               "alg02.alg_file.alg02,",
               "nnn02.nnn_file.nnn02,",
               "nnn03.nnn_file.nnn03,",
               "nne16.nne_file.nne16,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05"
   LET l_table = cl_prt_temptable('anmr760',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql   = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?,?,?,?,?,?,?,?,?,?,",
                 "        ?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF 
#NO.FUN-7A0036--------end---
 
   LET g_pdate = ARG_VAL(1)             # Get arguments from command line
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
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'         # If background job sw is off
      THEN CALL anmr760_tm()                    # Input print condition
      ELSE CALL anmr760()                       # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr760_tm()
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01        #No.FUN-580031
DEFINE p_row,p_col   LIKE type_file.num5,       #No.FUN-680107 SMALLINT
       l_cmd         LIKE type_file.chr1000,    #No.FUN-680107 VARCHAR(400)
       l_jmp_flag    LIKE type_file.chr1        #No.FUN-680107 VARCHAR(1)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 16
   ELSE LET p_row = 4 LET p_col = 13
   END IF
   OPEN WINDOW anmr760_w AT p_row,p_col
        WITH FORM "anm/42f/anmr760"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON
         nne01, nne02, nne03, nne06
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr760_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]"
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()        # Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr760_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
             WHERE zz01='anmr760'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr760','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('anmr760',g_time,l_cmd)  # Execute cmd at later time
      END IF
      CLOSE WINDOW anmr760_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr760()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr760_w
END FUNCTION
 
FUNCTION anmr760()
   DEFINE l_name        LIKE type_file.chr20,             # External(Disk) file name       #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8            #No.FUN-6A0082
          l_sql         LIKE type_file.chr1000,           # RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200)
          l_za05        LIKE type_file.chr1000,           #標題內容 #No.FUN-680107 VARCHAR(40)
          l_day         LIKE type_file.num5,              #No.FUN-680107 SMALLINT  #計算每月日數
          sr            RECORD
                        code      LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
                        nne02     LIKE   nne_file.nne02 , #
                        nne04     LIKE   nne_file.nne04 ,
                        nne06     LIKE   nne_file.nne06 ,
                        nne112    LIKE   nne_file.nne112 ,
                        nne14     LIKE   nne_file.nne14 ,
                        nne19     LIKE   nne_file.nne19 ,
                        alg01     LIKE   alg_file.alg01,
                        alg02     LIKE   alg_file.alg02 ,
                        nnn02     LIKE   nnn_file.nnn02 ,
                        nnn03     LIKE   nnn_file.nnn03 ,
                        nne16     LIKE   nne_file.nne16
                        END RECORD
#NO.FUN-7A0036 ------start----
     DEFINE t_azi03     LIKE azi_file.azi03
     DEFINE t_azi04     LIKE azi_file.azi04
     DEFINE t_azi05     LIKE azi_file.azi05
 
     CALL cl_del_data(l_table)      
#NO.FUN-7A0036-------end
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 ='anmr760'   #NO.FUN-7A0036
#NO.CHI-6A0004--BEGIN
#     SELECT azi04 , azi05 INTO g_azi04, g_azi05 FROM azi_file
#      WHERE  azi01=g_aza.aza17
#NO.CHI-6A0004--END
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND nneuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND nnegrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND nnegrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nneuser', 'nnegrup')
     #End:FUN-980030
 
     LET l_sql = " SELECT ''," ,
#                 " nne02, nne04, nne06, nne112, nne14, nne19,'','',nnn03  ",   #MOD-5B0224
                 " nne02, nne04, nne06, nne112, nne14, nne19,'','','',nnn03  ",   #MOD-5B0224
                 " ,nne16 ",
                 " FROM nne_file,OUTER nnn_file " ,
                 " WHERE nnn_file.nnn01=nne_file.nne06 AND nneconf <> 'X'",
                 "   AND ", tm.wc CLIPPED
 
     PREPARE anmr760_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM 
     END IF
     DECLARE anmr760_curs1 CURSOR FOR anmr760_prepare1
 
#     CALL cl_outnam('anmr760') RETURNING l_name         #NO.FUN-7A0036
 
#     START REPORT anmr760_rep TO l_name                 #NO.FUN-7A0036
#     LET g_pageno = 0
 
     FOREACH anmr760_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
       SELECT alg01,alg02 INTO sr.alg01,sr.alg02 FROM alg_file 
              WHERE alg01 = sr.nne04
       SELECT nnn02 INTO sr.nnn02 FROM nnn_file 
              WHERE nnn01 = sr.nne06
       IF sr.nnn03='2' THEN LET sr.code='2' ELSE LET sr.code='1' END IF
#       OUTPUT TO REPORT anmr760_rep(sr.*)               #NO.FUN-7A0036
#NO.FUN-7A0036 ----------start-------
      SELECT azi03,azi04,azi05
        INTO t_azi03,t_azi04,t_azi05  #NO.CHI-6A0004
        FROM azi_file
       WHERE azi01=sr.nne16
      EXECUTE insert_prep USING
        sr.code,sr.nne02,sr.nne04,sr.nne06,sr.nne112,sr.nne14,sr.nne19,
        sr.alg01,sr.alg02,sr.nnn02,sr.nnn03,sr.nne16,t_azi04,t_azi05
 
#NO.FUN-7A0036 --------end--------
      END FOREACH
#NO.FUN-7A0036 --------start----
      LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
      IF  g_zz05= 'Y' THEN
          CALL cl_wcchp(tm.wc,'nne01,nne02,nne03,nne06')
              RETURNING tm.wc
      END IF
      LET g_str = tm.wc
      CALL cl_prt_cs3('anmr760','anmr760',g_sql,g_str) 
#NO.FUN-7A0036 --------end--------
 
#     FINISH REPORT anmr760_rep                           #NO.FUN-7A0036
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)         #NO.FUN-7A0036
END FUNCTION
#NO.FUN-7A0036 -------start-----mark-----
{REPORT anmr760_rep(sr)
   DEFINE l_last_sw     LIKE type_file.chr1,              #No.FUN-680107 VARCHAR(1)
          t_azi04       LIKE     azi_file.azi04 ,
          t_azi05       LIKE     azi_file.azi05 ,
          l_amt01       LIKE nne_file.nne19,
          l_amt02       LIKE nne_file.nne19,
          l_amt03       LIKE nne_file.nne19,
          l_ret         LIKE type_file.num20_6,           #No.FUN-680107 DEC(20,6)
          sr            RECORD
                        code      LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1) #1.bank 2.nnn03='2'
                        nne02     LIKE   nne_file.nne02 , #
                        nne04     LIKE   nne_file.nne04 ,
                        nne06     LIKE   nne_file.nne06 ,
                        nne112    LIKE   nne_file.nne112 ,
                        nne14     LIKE   nne_file.nne14 ,
                        nne19     LIKE   nne_file.nne19 ,
                        alg01     LIKE   alg_file.alg01,
                        alg02     LIKE   alg_file.alg02 ,
                        nnn02     LIKE   nnn_file.nnn02 ,
                        nnn03     LIKE   nnn_file.nnn03 ,
                        nne16     LIKE   nne_file.nne16
                        END RECORD
 
  OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line   #No.MOD-580242
 
  ORDER BY  sr.nne04, sr.code,sr.nne06
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
 
      PRINT g_dash[1,g_len]
      PRINT g_x[31] CLIPPED ,g_x[32] CLIPPED ,g_x[33] CLIPPED ,g_x[34] CLIPPED ,
            g_x[35] CLIPPED ,g_x[36] CLIPPED ,g_x[37] CLIPPED ,g_x[38] CLIPPED ,
            g_x[39] CLIPPED   #MOD-5B0224
     PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
 
      SELECT azi03,azi04,azi05
        INTO t_azi03,t_azi04,t_azi05  #NO.CHI-6A0004
        FROM azi_file
       WHERE azi01=sr.nne16
 
     IF sr.code='1' THEN
        PRINT COLUMN g_c[31],sr.nne02 ,
              COLUMN g_c[32],sr.nne112,
              COLUMN g_c[33],sr.alg01,
              COLUMN g_c[34],sr.alg02,
              COLUMN g_c[39],sr.nne16,   #MOD-5B0224
              COLUMN g_c[35],cl_numfor(sr.nne19,35,t_azi04)  ,  #NO.CHI-6A0004
              #COLUMN g_c[37],sr.nne14 USING '##&.#&' CLIPPED , #No.TQC-5C0051
              COLUMN g_c[37],sr.nne14 USING '######&.#&' CLIPPED , #No.TQC-5C0051
              COLUMN g_c[38],sr.nnn02 CLIPPED
     END IF
 
   AFTER GROUP OF sr.nne06
      LET l_amt01 = 0
      IF sr.code='2' THEN     #code='1': other,'2':nnn03='2'
         LET l_amt01 = GROUP SUM(sr.nne19)
                       WHERE sr.nne04=sr.nne04
                         AND sr.nne06=sr.nne06
                         AND sr.code='2'
         PRINT COLUMN g_c[33],sr.alg01 CLIPPED,COLUMN g_c[34],sr.alg02,
               COLUMN g_c[36], cl_numfor(l_amt01,36,t_azi05) #NO.CHI-6A0004
      ELSE
         LET l_amt01 = GROUP SUM(sr.nne19)
                       WHERE sr.nne04=sr.nne04
                         AND sr.nne06=sr.nne06
                         AND sr.code='1'
         PRINT COLUMN g_c[36], cl_numfor(l_amt01,36,t_azi05)  #NO.CHI-6A0004
      END IF
 
   AFTER GROUP OF sr.nne04
      LET l_amt01 = 0
      LET l_amt01 = GROUP SUM(sr.nne19)
      PRINT COLUMN g_c[34], g_x[10] CLIPPED ,
            COLUMN g_c[36], cl_numfor(l_amt01,36,t_azi05)  #NO.CHI-6A0004
      PRINT g_dash2[1,g_len]
 
   ON LAST ROW
      LET l_last_sw='y'
      LET l_amt01 = 0
      LET l_amt01 =  SUM(sr.nne19)
      LET l_ret = 0
      PRINT g_dash[1,g_len] CLIPPED
      PRINT COLUMN g_c[34], g_x[11] CLIPPED ,
            COLUMN g_c[36], cl_numfor(l_amt01,36,t_azi05) #NO.CHI-6A0004
 
    PAGE TRAILER
      PRINT g_dash[1,g_len]
      SKIP 2 LINE
## FUN-550114
     # PRINT COLUMN 11, g_x[17] CLIPPED
         #  COLUMN 41, g_x[24] CLIPPED
         #  COLUMN 71, g_x[25] CLIPPED
     IF l_last_sw = 'n' THEN
        IF g_memo_pagetrailer THEN
            PRINT g_x[17]
            PRINT g_memo
        ELSE
            PRINT
            PRINT
        END IF
     ELSE
            PRINT g_x[17]
            PRINT g_memo
     END IF
## END FUN-550114
 
END REPORT}
#NO.FUN-7A0036 --------end--mark--
