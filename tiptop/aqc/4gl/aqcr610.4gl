# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: aqcr610.4gl
# Descriptions...: 柏拉圖
# Date & Author..: 00/09/28 By Melody
# Modify.........: No.FUN-570243 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.TQC-5B0034 05/11/08 By Rosayu 畫面欄位預設值修改,單頭品名規格調整
# Modify.........: No.FUN-5C0078 05/12/20 By day 抓取qcs_file的程序多加判斷qcs00
# Modify.........: No.TQC-610086 06/04/18 By Pengu Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680104 06/08/28 By Czl  類型轉換
# Modify.........: No.FUN-690121 06/10/16 By Jackho cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-750064 07/06/12 By pengu 拿掉單頭[檢驗量]欄位
# Modify.........: No.TQC-790062 07/09/10 By claire 1.調整上邊界及品名的位置, 影響柏拉圖的產生
#                                                   2.p_zaa序號[11]不可使用:改用[31] 才不會影響柏拉圖的產生
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-960309 09/09/21 By baofei 修改溢位問題
# Modify.........: No.FUN-A20051 10/03/05 By chenls 老报表转CR
# Modify.........: No.FUN-B80066 11/08/05 By xuxz  AQC模組程序撰寫規範修正

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-680104 VARCHAR(600)
              a       LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
              ch      LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
              more    LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
              END RECORD,
          l_tot,l_i   LIKE type_file.num10,        #No.FUN-680104 INTEGER
          l_wc        LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(600)
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680104 SMALLINT
#No.FUN-A20051 ---add begin
DEFINE   g_sql        STRING       #NO.FUN-910082
DEFINE   g_sql1       STRING       #NO.FUN-910082
DEFINE   g_str        LIKE type_file.chr1000
DEFINE   l_table      LIKE type_file.chr1000
DEFINE   l_table1     LIKE type_file.chr1000
#No.FUN-A20051 ---add end
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AQC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690121

#No.FUN-A20051 ---BEGIN
   LET g_sql="qcs01.qcs_file.qcs01,",
             "qcs02.qcs_file.qcs02,",
             "qcs05.qcs_file.qcs05,",
             "qcs021.qcs_file.qcs021,",
             "qcs06.qcs_file.qcs06,",
             "qcs03.qcs_file.qcs03,",
             "qcs04.qcs_file.qcs04,",
             "qcs041.qcs_file.qcs041,",
             "qcu04.qcu_file.qcu04,",
             "qcu05.qcu_file.qcu05,",
             "ima02.ima_file.ima02,",
             "pmc03.pmc_file.pmc03,",
             "qce03.qce_file.qce03,",
             "per.type_file.num15_3"

   LET l_table = cl_prt_temptable('aqcr610',g_sql)
   IF l_table = -1 THEN EXIT PROGRAM END IF
#No.FUN-A20051 ---END 
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
#--------No.TQC-610086 modify
   LET tm.a  = ARG_VAL(8)
   LET tm.ch = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
#--------No.TQC-610086 end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r610_tm(0,0)
      ELSE CALL r610()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
END MAIN
 
FUNCTION r610_tm(p_row,p_col)
DEFINE lc_qbe_sn       LIKE gbm_file.gbm01       #No.FUN-580031
   DEFINE p_row,p_col  LIKE type_file.num5,      #No.FUN-680104 SMALLINT
          l_cmd        LIKE type_file.chr1000    #No.FUN-680104 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 14
   END IF
 
   OPEN WINDOW r610_w AT p_row,p_col
        WITH FORM "aqc/42f/aqcr610"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.a    = '1'
   LET tm.ch   = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ' 1=1'
WHILE TRUE
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON qcs01,qcs021
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
 
#No.FUN-570243 --start
     ON ACTION CONTROLP
        IF INFIELD(qcs021) THEN
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_ima"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO qcs021
           NEXT FIELD qcs021
        END IF
#No.FUN-570243 --end
 
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
         CLOSE WINDOW r520_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
         EXIT PROGRAM
      END IF
      IF tm.wc != ' 1=1' THEN EXIT WHILE END IF
      CALL cl_err('',9046,0)
   END WHILE
   DISPLAY BY NAME tm.a,tm.ch,tm.more
   INPUT BY NAME tm.a,tm.ch,tm.more WITHOUT DEFAULTS #TQC-5B0034
      #No.FUN-580031 --start--
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
 
      AFTER FIELD ch
         IF tm.ch NOT MATCHES '[12]' THEN NEXT FIELD ch END IF
 
      AFTER FIELD a
         IF tm.a NOT MATCHES '[12345]' THEN NEXT FIELD a END IF  #No.FUN-5C0078
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
      ON ACTION CONTROLG CALL cl_cmdask()
 
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
      CLOSE WINDOW r610_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='aqcr610'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aqcr610','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.a  CLIPPED,"'",            #No.TQC-610086 add 
                         " '",tm.ch CLIPPED,"'",            #No.TQC-610086 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('aqcr610',g_time,l_cmd)
      END IF
      CLOSE WINDOW r610_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r610()
   ERROR ""
END WHILE
   CLOSE WINDOW r610_w
END FUNCTION
 
FUNCTION r610()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680104 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0085
          l_sql     LIKE type_file.chr1000,       #RDSQL STATEMENT                  #No.FUN-680104 VARCHAR(1200)
          l_chr     LIKE type_file.chr1,          #No.FUN-680104 VARCHAR(1)
          l_za05    LIKE cob_file.cob01,          #No.FUN-680104 VARCHAR(40)
          l_sum     LIKE type_file.num15_3,       #No.FUN-A20051
          l_per_up  LIKE type_file.num15_3,       #No.FUN-A20051
          l_qcs_old LIKE qcs_file.qcs01,          #No.FUN-A20051
          sr        RECORD
                    qcs01      LIKE qcs_file.qcs01,
                    qcs02      LIKE qcs_file.qcs02,
                    qcs05      LIKE qcs_file.qcs05,
                    qcs021     LIKE qcs_file.qcs021,
                    qcs06      LIKE qcs_file.qcs06,
                    qcs03      LIKE qcs_file.qcs03,
                    qcs04      LIKE qcs_file.qcs04,
                    qcs041     LIKE qcs_file.qcs041,
                    qcu04      LIKE qcu_file.qcu04,
                    qcu05      LIKE qcu_file.qcu05,
#FUN-A20051 ---add begin
                    ima02      LIKE ima_file.ima02,
                    pmc03      LIKE pmc_file.pmc03,
                    qce03      LIKE qce_file.qce03,
                    per        LIKE qcu_file.qcu05      #每一筆所占比率
#FUN-A20051 ---add end
                    END RECORD
#FUN-A20051 ---add begin
     LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-B80066
        CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
     END IF
     CALL cl_del_data(l_table)
#FUN-A20051 ---add end
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aqcr610'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND qcsuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND qcsgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND qcsgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('qcsuser', 'qcsgrup')
     #End:FUN-980030
 
     CASE tm.a
          WHEN '1' LET l_sql = "SELECT qcs01,qcs02,qcs05,qcs021,",
#                               "       qcs06,qcs03,qcs04,qcs041,qcu04,qcu05 ",              #FUN-A20051 --mark
                               "       qcs06,qcs03,qcs04,qcs041,qcu04,qcu05,' ',' ',' ',' ' ",   #FUN-A20051 --add
                               "  FROM qcs_file, qcu_file ",
                               " WHERE qcs01=qcu01 AND qcs02=qcu02 ",
                               "   AND qcs05=qcu021 AND qcs14 <> 'X' ",
                               "   AND qcs00<'5'  ",  #No.FUN-5C0078
                               "   AND ", tm.wc CLIPPED,
                               " ORDER BY qcs01,qcu05 DESC "         #FUN-A20051 add qcs01
          WHEN '2' LET l_wc = tm.wc
#TQC-960309---begin                                                                                                                 
#                   FOR l_i = 1 TO length(l_wc)                                                                                     
#                       CASE l_wc[l_i,l_i+2]                                                                                        
#                            WHEN 'qcs' LET l_wc[l_i,l_i+2] = 'qcf'                                                                 
#                       END CASE                                                                                                    
#                   END FOR                                                                                                         
                   LET l_wc = cl_replace_str(l_wc,"qcs","qcf")                                                                      
#TQC-960309---end  
                   LET l_sql = "SELECT qcf01,0,0,qcf021,",
#                               "       qcf06,qcf03,qcf04,qcf041,qcu04,qcu05 ",              #FUN-A20051 --mark
                               "       qcf06,qcf03,qcf04,qcf041,qcu04,qcu05,' ',' ',' ',' ', ",   #FUN-A20051 --add
                               "  FROM qcf_file, qcu_file ",
                               " WHERE qcf01=qcu01 AND ",l_wc CLIPPED,
                               "   AND qcf14 <> 'X'  ",
                               " ORDER BY qcf01,qcu05 DESC "          #FUN-A20051 add qcf01
          WHEN '3' LET l_wc = tm.wc
#TQC-960309---begin                                                                                                                 
#                   FOR l_i = 1 TO length(l_wc)                                                                                     
#                       CASE l_wc[l_i,l_i+2]                                                                                        
#                            WHEN 'qcs' LET l_wc[l_i,l_i+2] = 'qcm'                                                                 
#                       END CASE                                                                                                    
#                   END FOR                                                                                                         
                   LET l_wc = cl_replace_str(l_wc,"qcs","qcm")                                                                      
#TQC-960309---end 
                   LET l_sql = "SELECT qcm01,0,0,qcm021,",
#                               "       qcm06,qcm03,qcm04,qcm041,qcu04,qcu05 ",              #FUN-A20051 --mark
                               "       qcm06,qcm03,qcm04,qcm041,qcu04,qcu05,' ',' ',' ',' ' ",   #FUN-A20051 --add
                               "  FROM qcm_file, qcu_file ",
                               " WHERE qcm01=qcu01 AND qcm14 <> 'X' ",
                               "   AND ",l_wc CLIPPED,
                               " ORDER BY qcm01,qcu05 DESC "        #FUN-A20051 add qcm01
#No.FUN-5C0078-begin
          WHEN '4' LET l_sql = "SELECT qcs01,qcs02,qcs05,qcs021,",
#                               "       qcs06,qcs03,qcs04,qcs041,qcu04,qcu05 ",              #FUN-A20051 --mark
                               "       qcs06,qcs03,qcs04,qcs041,qcu04,qcu05,' ',' ',' ',' ' ",   #FUN-A20051 --add
                               "  FROM qcs_file, qcu_file ",
                               " WHERE qcs01=qcu01 AND qcs02=qcu02 ",
                               "   AND qcs05=qcu021 AND qcs14 <> 'X' ",
                               "   AND (qcs00='5' OR qcs00='6')  ",
                               "   AND ", tm.wc CLIPPED,
                               " ORDER BY qcs01,qcu05 DESC "        #FUN-A20051 add qcs01
          WHEN '5' LET l_sql = "SELECT qcs01,qcs02,qcs05,qcs021,",
#                               "       qcs06,qcs03,qcs04,qcs041,qcu04,qcu05 ",              #FUN-A20051 --mark
                               "       qcs06,qcs03,qcs04,qcs041,qcu04,qcu05,' ',' ',' ',' ' ",   #FUN-A20051 --add
                               "  FROM qcs_file, qcu_file ",
                               " WHERE qcs01=qcu01 AND qcs02=qcu02 ",
                               "   AND qcs05=qcu021 AND qcs14 <> 'X' ",
                               "   AND (qcs00='A' OR qcs00='B' OR qcs00='C' OR qcs00='D'  ",
                               "        OR qcs00='E' OR qcs00='F' OR qcs00='G' OR qcs00='Z')  ",
                               "   AND ", tm.wc CLIPPED,
                               " ORDER BY qcs01,qcu05 DESC "      #FUN-A20051 add qcs01
#No.FUN-5C0078-end
     END CASE
 
 
     PREPARE r610_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
        EXIT PROGRAM
     END IF
     DECLARE r610_curs1 CURSOR FOR r610_prepare1

#FUN-A20051 ---BEGIN
#     CALL cl_outnam('aqcr610') RETURNING l_name
#     IF tm.ch='1' THEN
#        START REPORT r610_rep1 TO l_name
#     ELSE
#        START REPORT r610_rep2 TO l_name
#     END IF
#     LET g_pageno = 0
#FUN-A20051 ---END

     LET l_per_up = 0

     FOREACH r610_curs1 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF

#FUN-A20051 ---BEGIN
         IF sr.qcs01 <> l_qcs_old THEN
            LET l_per_up = 0
         END IF
         LET l_qcs_old = sr.qcs01
         SELECT SUM(qcu05) INTO l_sum  FROM qcu_file WHERE qcu01=sr.qcs01
         LET sr.per = sr.qcu05 / l_sum * 100 + l_per_up
         LET l_per_up = sr.per

         SELECT ima02 INTO sr.ima02 FROM ima_file
          WHERE ima01 = sr.qcs021
         SELECT pmc03 INTO sr.pmc03 FROM pmc_file
          WHERE pmc01=sr.qcs03
         SELECT qce03 INTO sr.qce03 FROM qce_file WHERE qce01=sr.qcu04 

         EXECUTE insert_prep USING sr.qcs01,sr.qcs02,sr.qcs05,sr.qcs021,
                                   sr.qcs06,sr.qcs03,sr.qcs04,sr.qcs041,
                                   sr.qcu04,sr.qcu05,sr.ima02,sr.pmc03,sr.qce03,sr.per
#         IF tm.ch='1' THEN
#            OUTPUT TO REPORT r610_rep1(sr.*)
#         ELSE
#            OUTPUT TO REPORT r610_rep2(sr.*)
#         END IF
#FUN-A20051 ---END
     END FOREACH

#FUN-A20051 ---BEGIN
     LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05 = 'Y' THEN
         CALL cl_wcchp(tm.wc,'qcs01,qcs021')
                 RETURNING tm.wc
     ELSE
         LET tm.wc=""
     END IF
#     LET g_str = tm.wc,';',tm.bdate,';',tm.edate,';',tm.ans
     LET g_str = tm.wc
     IF tm.ch='1' THEN
        CALL cl_prt_cs3('aqcr610','aqcr610',g_sql,g_str)
     ELSE
        CALL cl_prt_cs3('aqcr610','aqcr610_1',g_sql,g_str)
     END IF
#FUN-A20051 ---END

#FUN-A20051 ---BEGIN 
#    IF tm.ch='1' THEN
#       FINISH REPORT r610_rep1
#    ELSE
#       FINISH REPORT r610_rep2
#    END IF
#
#    IF tm.ch='1' THEN
#       CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#    ELSE
#       LET l_sql = "p000 ",l_name CLIPPED," x"
#       RUN l_sql
#    END IF
#FUN-A20051 ---END
END FUNCTION

#FUN-A20051 --- mark begin 
#REPORT r610_rep2(sr)
#  DEFINE l_last_sw LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#         l_ima02   LIKE ima_file.ima02,
#         l_pmc03   LIKE pmc_file.pmc03,
#         l_qce03   LIKE qce_file.qce03,
#         l_qcu05   LIKE qcu_file.qcu05,
#         sr        RECORD
#                   qcs01      LIKE qcs_file.qcs01,
#                   qcs02      LIKE qcs_file.qcs02,
#                   qcs05      LIKE qcs_file.qcs05,
#                   qcs021     LIKE qcs_file.qcs021,
#                   qcs06      LIKE qcs_file.qcs06,
#                   qcs03      LIKE qcs_file.qcs03,
#                   qcs04      LIKE qcs_file.qcs04,
#                   qcs041     LIKE qcs_file.qcs041,
#                   qcu04      LIKE qcu_file.qcu04,
#                   qcu05      LIKE qcu_file.qcu05
#                   END RECORD
#
# OUTPUT TOP MARGIN 0    #TQC-790062 mark g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.qcs01,sr.qcs02,sr.qcs05
# FORMAT
#  BEFORE GROUP OF sr.qcs05
#     SKIP TO TOP OF PAGE
#     SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=sr.qcs021
#     SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=sr.qcs03
#     LET g_pageno = g_pageno + 1
#     IF g_pageno > 1 THEN PRINT '' PRINT '@' END IF
#     PRINT g_company CLIPPED,';'
#     PRINT g_x[1] CLIPPED
#     PRINT g_company CLIPPED
#     PRINT g_x[1] CLIPPED
#
#     PRINT g_x[31] CLIPPED,"(",sr.qcs01 CLIPPED,' ',sr.qcs02 USING '#&',' ',sr.qcs05 USING '#&',")"  #TQC-790062 modify
#     PRINT g_x[12] CLIPPED,sr.qcs021 CLIPPED #TQC-5B0034
#     ;PRINT COLUMN 45,l_ima02 CLIPPED #TQC-5B0034  TQC-790062 modify
#    #---------------No.TQC-750064 modify
#    #PRINT g_x[14] CLIPPED,sr.qcs06 CLIPPED,
#    #      COLUMN 35,g_x[15] CLIPPED,sr.qcs03 CLIPPED,' ',l_pmc03
#     PRINT g_x[15] CLIPPED,sr.qcs03 CLIPPED,' ',l_pmc03
#    #---------------No.TQC-750064 end
#     PRINT g_x[13] CLIPPED,sr.qcs04,
#           COLUMN 35,g_x[16] CLIPPED,sr.qcs041
#     PRINT g_x[17] CLIPPED
#     SELECT SUM(qcu05) INTO l_tot FROM qcu_file
#        WHERE qcu01=sr.qcs01 AND qcu02=sr.qcs02 AND qcu021=sr.qcs05
#     LET l_qcu05 = 0
#  ON EVERY ROW
#     LET l_qcu05 = l_qcu05+ sr.qcu05
#     SELECT qce03 INTO l_qce03 FROM qce_file WHERE qce01=sr.qcu04
#     PRINT sr.qcu04 CLIPPED,';',
#           l_qce03 CLIPPED,';',
#           sr.qcu05 CLIPPED USING '######&',';',
#           l_qcu05/l_tot*100 USING '##&.&&%'
#
#END REPORT
#FUN-A20051 ---mark end

#FUN-A20051 ---mark begin 
#REPORT r610_rep1(sr)
#  DEFINE l_last_sw LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#         l_ima02   LIKE ima_file.ima02,
#         l_pmc03   LIKE pmc_file.pmc03,
#         l_qce03   LIKE qce_file.qce03,
#         l_qcu05   LIKE qcu_file.qcu05,
#         sr        RECORD
#                   qcs01      LIKE qcs_file.qcs01,
#                   qcs02      LIKE qcs_file.qcs02,
#                   qcs05      LIKE qcs_file.qcs05,
#                   qcs021     LIKE qcs_file.qcs021,
#                   qcs06      LIKE qcs_file.qcs06,
#                   qcs03      LIKE qcs_file.qcs03,
#                   qcs04      LIKE qcs_file.qcs04,
#                   qcs041     LIKE qcs_file.qcs041,
#                   qcu04      LIKE qcu_file.qcu04,
#                   qcu05      LIKE qcu_file.qcu05
#                   END RECORD
#
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.qcs01,sr.qcs02,sr.qcs05
# FORMAT
#  PAGE HEADER
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     PRINT ' '
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#     LET g_pageno = g_pageno + 1
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#     PRINT g_dash[1,g_len]
#     LET l_last_sw = 'n'
#
#  BEFORE GROUP OF sr.qcs05
#     SKIP TO TOP OF PAGE
#     SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=sr.qcs021
#     SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=sr.qcs03
#     PRINT COLUMN 01,g_x[11] CLIPPED,sr.qcs01,' ',sr.qcs02 USING '##',
#                                              ' ',sr.qcs05 USING '##'
#     PRINT g_x[12] CLIPPED,sr.qcs021 CLIPPED #TQC-5B0034
#     PRINT COLUMN 10,l_ima02 CLIPPED #TQC-5B0034
#    #---------------No.TQC-750064 modify
#    #PRINT g_x[14] CLIPPED,sr.qcs06 CLIPPED,
#    #      COLUMN 35,g_x[15] CLIPPED,sr.qcs03 CLIPPED,' ',l_pmc03
#     PRINT g_x[15] CLIPPED,sr.qcs03 CLIPPED,' ',l_pmc03
#    #---------------No.TQC-750064 end
#     PRINT g_x[13] CLIPPED,sr.qcs04,
#           COLUMN 35,g_x[16] CLIPPED,sr.qcs041
#     PRINT g_dash[1,g_len]
#     PRINT g_x[21] CLIPPED,COLUMN 43,g_x[22] CLIPPED
#     PRINT g_x[23] CLIPPED,g_x[24] CLIPPED
#     SELECT SUM(qcu05) INTO l_tot FROM qcu_file
#        WHERE qcu01=sr.qcs01 AND qcu02=sr.qcs02 AND qcu021=sr.qcs05
#     LET l_qcu05 = 0
#
#  ON EVERY ROW
#     LET l_qcu05 = l_qcu05 + sr.qcu05
#     SELECT qce03 INTO l_qce03 FROM qce_file WHERE qce01=sr.qcu04
#     PRINT COLUMN 05,sr.qcu04 CLIPPED,
#           COLUMN 13,l_qce03 CLIPPED,
#           COLUMN 44,sr.qcu05 USING '######&',
#           COLUMN 55,l_qcu05/l_tot*100 USING '##&.&&%'
#
#  AFTER GROUP OF sr.qcs05
#     PRINT g_dash[1,g_len]
#     PRINT COLUMN 30,g_x[18] CLIPPED,COLUMN 44,l_tot USING '######&',
#           COLUMN 55,'100.00%'
#
#  ON LAST ROW
#     PRINT g_dash[1,g_len]
#     LET l_last_sw = 'y'
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len]
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#FUN-A20051 ---mark end
#Patch....NO.TQC-610036 <001,002> #
