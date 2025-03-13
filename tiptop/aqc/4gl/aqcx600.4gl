# Prog. Version..: '5.30.07-13.05.30(00001)'     #
#
# Pattern name...: aqcx600.4gl
# Descriptions...: 管制圖
# Date & Author..: 99/05/10 By Melody
# Modify.........: No.FUN-570243 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.TQC-5B0034 05/11/08 By Rosayu 畫面欄位預設值修改
# Modify.........: No.TQC-610086 06/04/18 By Pengu Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680104 06/08/28 By Czl  類型轉換
# Modify.........: No.FUN-690121 06/10/16 By Jackho cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-790026 07/09/04 By claire x-bar管制圖的上邊界要default 0
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20051 10/03/03 By chenls 老報表轉CR 
# Modify.........: No:MOD-A40001 10/04/06 By Sarah 報表增加抓取qdb011,qdb012,qdb013,排序跟跳頁改依qdb01+qdb011+qdb012+qdb01,
#                                                  並將qdb011,qdb012,qdb013此三個欄位呈現在qdb01後面
# Modify.........: No.FUN-D30044 13/03/15 By yangtt CR轉XGrid     
# Modify.........: No.FUN-D40129 13/05/15 By yangtt qdb01新增開窗；單頭添加料件規格ima021顯示

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-680104 VARCHAR(600)
              a       LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
              ch      LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
              more    LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
              END RECORD,
          g_dash_1    LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(200)
 
DEFINE    g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680104 SMALLINT
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
   LET g_sql="qdb01.qdb_file.qdb01,qdb011.qdb_file.qdb011,",    #MOD-A40001 add qdb011
             "qdb012.qdb_file.qdb012,qdb013.qdb_file.qdb013,",  #MOD-A40001 add
             "qdb02.qdb_file.qdb02,ima02.ima_file.ima02,",
             "qdb03.qdb_file.qdb03,qdb09.qdb_file.qdb09,",
             "azf03.azf_file.azf03,qdb07.qdb_file.qdb07,",
             "qdb071.qdb_file.qdb071,qdb072.qdb_file.qdb072,",
             "qdb05.qdb_file.qdb05,qdb08.qdb_file.qdb08,",
             "qdb081.qdb_file.qdb081,qdb082.qdb_file.qdb082,",
             "qdb06.qdb_file.qdb06,qdc02.qdc_file.qdc02,",
             "qdc03.qdc_file.qdc03,qdc04.qdc_file.qdc04,",
             "qdc07.qdc_file.qdc07,qdc08.qdc_file.qdc08,",
             "l_qdb02.type_file.chr1000,l_qdb09.type_file.chr1000,",    #FUN-D30044
             "l_num1.type_file.num5"    #FUN-D30044
   LET l_table = cl_prt_temptable('aqcx600',g_sql)
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"   #MOD-A40001 add 3?   #FUN-D30044 add 3?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
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
      THEN CALL x600_tm(0,0)
      ELSE CALL x600()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
END MAIN
 
FUNCTION x600_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680104 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 14
   END IF
 
   OPEN WINDOW x600_w AT p_row,p_col
        WITH FORM "aqc/42f/aqcx600"
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
      CONSTRUCT BY NAME tm.wc ON qdb01,qdb02
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
        IF INFIELD(qdb02) THEN
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_ima"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO qdb02
           NEXT FIELD qdb02
        END IF
        #FUN-D40129----add---str--
        IF INFIELD(qdb01) THEN
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_qdb01"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO qdb01
           NEXT FIELD qdb01
        END IF
        #FUN-D40129----add---end--
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
         IF tm.a NOT MATCHES '[123]' THEN NEXT FIELD a END IF
 
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
      CLOSE WINDOW x600_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='aqcx600'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aqcx600','9031',1)
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
         CALL cl_cmdat('aqcx600',g_time,l_cmd)
      END IF
      CLOSE WINDOW x600_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL x600()
   ERROR ""
END WHILE
   CLOSE WINDOW x600_w
END FUNCTION
 
FUNCTION x600()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name      #No.FUN-680104 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0085
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT               #No.FUN-680104 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680104 VARCHAR(1)
          l_za05    LIKE cob_file.cob01,          #No.FUN-680104 VARCHAR(40)
          sr        RECORD
#FUN-A20051 ---BEGIN
#                    qdb    RECORD LIKE qdb_file.*,
#                    qdc    RECORD LIKE qdc_file.*
                     qdb01  LIKE qdb_file.qdb01,
                     qdb011 LIKE qdb_file.qdb011,   #MOD-A40001 add
                     qdb012 LIKE qdb_file.qdb012,   #MOD-A40001 add
                     qdb013 LIKE qdb_file.qdb013,   #MOD-A40001 add
                     qdb02  LIKE qdb_file.qdb02,
                     ima02  LIKE ima_file.ima02,
                     qdb03  LIKE qdb_file.qdb03,
                     qdb09  LIKE qdb_file.qdb09,
                     azf03  LIKE azf_file.azf03,
                     qdb07  LIKE qdb_file.qdb07,
                     qdb071 LIKE qdb_file.qdb071,
                     qdb072 LIKE qdb_file.qdb072,
                     qdb05  LIKE qdb_file.qdb05,
                     qdb08  LIKE qdb_file.qdb08,
                     qdb081 LIKE qdb_file.qdb081,
                     qdb082 LIKE qdb_file.qdb082,
                     qdb06  LIKE qdb_file.qdb06,
                     qdc02  LIKE qdc_file.qdc02,
                     qdc03  LIKE qdc_file.qdc03,
                     qdc04  LIKE qdc_file.qdc04,
                     qdc07  LIKE qdc_file.qdc07,
                     qdc08  LIKE qdc_file.qdc08
                    END RECORD
   DEFINE l_qdb02   LIKE type_file.chr1000  #FUN-D30044
   DEFINE l_qdb09   LIKE type_file.chr1000  #FUN-D30044
   DEFINE l_num1    LIKE type_file.num5     #FUN-D30044
   DEFINE l_ima021  LIKE ima_file.ima021    #FUN-D40129

   CALL cl_del_data(l_table)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='aqcx600'
#FUN-A20051 ---END 
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aqcx600'
   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
   FOR g_i = 1 TO g_len LET g_dash_1[g_i,g_i] = '-' END FOR
   #Begin:FUN-980030
   #IF g_priv2='4' THEN                           #只能使用自己的資料
   #   LET tm.wc = tm.wc clipped," AND qdbuser = '",g_user,"'"
   #END IF
   #IF g_priv3='4' THEN                           #只能使用相同群的資料
   #   LET tm.wc = tm.wc clipped," AND qdbgrup MATCHES '",g_grup CLIPPED,"*'"
   #END IF
   #IF g_priv3 MATCHES "[5678]" THEN              #TQC-5C0134群組權限
   #   LET tm.wc = tm.wc clipped," AND qdbgrup IN ",cl_chk_tgrup_list()
   #END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('qdbuser', 'qdbgrup')
   #End:FUN-980030

#FUN-A20051 ---BEGIN 
#  LET l_sql = "SELECT * FROM qdb_file, qdc_file ",
   LET l_sql = "SELECT qdb01,qdb011,qdb012,qdb013,",   #MOD-A40001 add qdb011,qdb012,qdb013
               "       qdb02,' ',qdb03,qdb09,' ',qdb07,qdb071,qdb072,",
               "       qdb05,qdb08,qdb081,qdb082,qdb06,qdc02,qdc03,qdc04,qdc07,qdc08",
               "  FROM qdb_file, qdc_file ",
#FUN-A20051 ---END
               " WHERE qdb01=qdc01 ",
               "   AND qdb011=qdc011 ",
               "   AND qdb012=qdc012 ",
               "   AND qdb013=qdc013 ",
               "   AND qdbconf='Y' ",
               "   AND qdb00='",tm.a,"' ",
               "   AND ", tm.wc CLIPPED
   PREPARE x600_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      EXIT PROGRAM
   END IF
   DECLARE x600_curs1 CURSOR FOR x600_prepare1
#FUN-A20051 ---BEGIN
#  CALL cl_outnam('aqcx600') RETURNING l_name
#  IF tm.ch='1' THEN
#     START REPORT x600_rep1 TO l_name
#  ELSE
#     START REPORT x600_rep2 TO l_name
#  END IF
#  LET g_pageno = 0
#FUN-A20051 ---END

   FOREACH x600_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

#FUN-A20051 ---BEGIN
      SELECT ima02 INTO sr.ima02 FROM ima_file
       WHERE ima01 = sr.qdb02
      SELECT azf03 INTO sr.azf03 FROM azf_file
       WHERE azf01 = sr.qdb09 AND azf02='6'
      
      SELECT ima021 INTO l_ima021 FROM ima_file   #FUN-D40129
       WHERE ima01 = sr.qdb02    #FUN-D40129

      LET l_qdb02 = sr.qdb02,"     ",sr.ima02,"    ",l_ima021   #FUN-D30044   #FUN-D40129 add l_ima021
      LET l_qdb09 = sr.qdb09,"     ",sr.azf03   #FUN-D30044
      LET l_num1  = 2   #FUN-D30044

      EXECUTE insert_prep USING
         sr.qdb01, sr.qdb011,sr.qdb012,sr.qdb013,sr.qdb02,   #MOD-A40001 add qdb011,qdb012,qdb013
         sr.ima02, sr.qdb03, sr.qdb09, sr.azf03, sr.qdb07,
         sr.qdb071,sr.qdb072,sr.qdb05, sr.qdb08, sr.qdb081,
         sr.qdb082,sr.qdb06, sr.qdc02, sr.qdc03, sr.qdc04,
         sr.qdc07, sr.qdc08,
         l_qdb02,  l_qdb09,  l_num1    #FUN-D30044
#     IF tm.ch='1' THEN
#        OUTPUT TO REPORT x600_rep1(sr.*)
#     ELSE
#        OUTPUT TO REPORT x600_rep2(sr.*)
#     END IF
#FUN-A20051 ---END
   END FOREACH

#FUN-A20051 ---BEGIN
###XtraGrid###   LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'qdb01,qdb02') RETURNING tm.wc
   ELSE
      LET tm.wc=""
   END IF
#  LET g_str = tm.wc,';',tm.bdate,';',tm.edate,';',tm.ans
###XtraGrid###   LET g_str = tm.wc
   IF tm.ch='1' THEN
###XtraGrid###      CALL cl_prt_cs3('aqcx600','aqcx600',g_sql,g_str)
    LET g_xgrid.table = l_table    ###XtraGrid###
    LET g_xgrid.template = 'aqcx600'    #FUN-D30044
    LET g_xgrid.order_field = 'qdc02'  #FUN-D30044
    LET g_xgrid.grup_field = "qdb01,qdb011,qdb012,qdb012"  #FUN-D30044
    LET g_xgrid.skippage_field = 'qdb01'   #FUN-D30044
    CALL cl_xg_view()    ###XtraGrid###
   ELSE
###XtraGrid###      CALL cl_prt_cs3('aqcx600','aqcx600_1',g_sql,g_str)
    LET g_xgrid.table = l_table    ###XtraGrid###
    LET g_xgrid.template = 'aqcx600_1'    #FUN-D30044
    LET g_xgrid.order_field = 'qdc02'  #FUN-D30044
    LET g_xgrid.grup_field = "qdb01,qdb011,qdb012,qdb012"  #FUN-D30044
    LET g_xgrid.skippage_field = 'qdb01'   #FUN-D30044
    CALL cl_xg_view()    ###XtraGrid###
   END IF
#FUN-A20051 ---END

#FUN-A20051 ---BEGIN 
#     IF tm.ch='1' THEN
#        FINISH REPORT x600_rep1
#     ELSE
#        FINISH REPORT x600_rep2
#     END IF
# 
#     IF tm.ch='1' THEN
#        CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#     ELSE
#        LET l_sql = "p000 ",l_name CLIPPED," x"
#        RUN l_sql
#     END IF
#FUN-A20051 ---END
END FUNCTION

#FUN-A20051 --- mark begin 
#REPORT x600_rep2(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#         i            LIKE type_file.num5,         #No.FUN-680104 SMALLINT
#         bdate,edate  LIKE type_file.dat,          #No.FUN-680104 DATE
#         l_qdb011     LIKE qdb_file.qdb011,
#         l_qdb012     LIKE qdb_file.qdb012,
#         l_ima02      LIKE ima_file.ima02,
#         l_azf03      LIKE azf_file.azf03,
#         l_eca02      LIKE eca_file.eca02,
#         sr        RECORD
#                   qdb        RECORD LIKE qdb_file.*,
#                   qdc        RECORD LIKE qdc_file.*
#                   END RECORD
#
# OUTPUT TOP MARGIN 0                 #TQC-790026 modify g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.qdb.qdb01,sr.qdb.qdb011,sr.qdb.qdb012,sr.qdb.qdb013,sr.qdc.qdc02
# FORMAT
#  BEFORE GROUP OF sr.qdb.qdb013
#     SKIP TO TOP OF PAGE
#     SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=sr.qdb.qdb02
#     IF sr.qdb.qdb00='3' THEN
#        SELECT eca02 INTO l_eca02 FROM eca_file,ecm_file,qcm_file
#           WHERE qcm01=sr.qdb.qdb01 AND qcm02=ecm01 AND qcm05=ecm03
#             AND ecm06=eca01 AND qcm14 <> 'X'
#        IF STATUS THEN LET l_eca02='' END IF
#     END IF
#     SELECT MIN(qdc03),MAX(qdc03) INTO bdate,edate FROM qdc_file
#        WHERE qdc01=sr.qdc.qdc01
#          AND qdc011=sr.qdc.qdc011
#          AND qdc012=sr.qdc.qdc012
#          AND qdc013=sr.qdc.qdc013
#
#     IF sr.qdb.qdb011=0 THEN
#        LET l_qdb011='' LET l_qdb012=''
#     ELSE
#        LET l_qdb011=sr.qdb.qdb011 LET l_qdb012=sr.qdb.qdb012
#     END IF
#
#     #-------------------------------
#     LET g_pageno = g_pageno + 1
#     IF g_pageno > 1 THEN PRINT '' PRINT '@' END IF
#     PRINT sr.qdb.qdb07,';',sr.qdb.qdb071,';',sr.qdb.qdb072,';'
#     PRINT sr.qdb.qdb08,';',sr.qdb.qdb081,';',sr.qdb.qdb082,';'
#     PRINT g_company CLIPPED
#     PRINT g_x[1] CLIPPED
#     PRINT g_x[11] CLIPPED,'(',
#                           sr.qdb.qdb01 CLIPPED,' ',
#                           l_qdb011 USING '##',
#                                        ' ',l_qdb012 USING '##',
#                                        ' ',sr.qdb.qdb013 USING '##',')'
#     PRINT g_x[12] CLIPPED,sr.qdb.qdb02 CLIPPED,' ',l_ima02 CLIPPED,
#           COLUMN 53,g_x[14] CLIPPED,l_eca02 CLIPPED
#     PRINT COLUMN 01,g_x[13] CLIPPED,bdate,'-',edate,
#           COLUMN 53,g_x[16] CLIPPED,sr.qdb.qdb03 USING '######'
#     SELECT azf03 INTO l_azf03 FROM azf_file
#       WHERE azf01=sr.qdb.qdb09 AND azf02='6'
#     IF STATUS THEN LET l_azf03='' END IF
#     PRINT COLUMN 01,g_x[15] CLIPPED,l_azf03 CLIPPED
#     PRINT g_x[25] CLIPPED
#
#  ON EVERY ROW
#     PRINT sr.qdc.qdc02 CLIPPED,';',
#           sr.qdc.qdc03 CLIPPED,';',
#           sr.qdc.qdc04 CLIPPED,';',
#           sr.qdc.qdc07 USING '####&.&&&',';',
#           sr.qdc.qdc08 USING '####&.&&&'
#
#END REPORT
#FUN-A20051 ---mark end

#FUN-A20051 ---mark begin 
#REPORT x600_rep1(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-680104 CAHR(1)
#         i            LIKE type_file.num5,         #No.FUN-680104 SMALLINT
#         bdate,edate  LIKE type_file.dat,          #No.FUN-680104 DATE
#         l_qdb011     LIKE qdb_file.qdb011,
#         l_qdb012     LIKE qdb_file.qdb012,
#         l_ima02      LIKE ima_file.ima02,
#         l_azf03      LIKE azf_file.azf03,
#         l_eca02      LIKE eca_file.eca02,
#         sr        RECORD
#                   qdb        RECORD LIKE qdb_file.*,
#                   qdc        RECORD LIKE qdc_file.*
#                   END RECORD
#
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.qdb.qdb01,sr.qdb.qdb011,sr.qdb.qdb012,sr.qdb.qdb013,sr.qdc.qdc02
# FORMAT
#  PAGE HEADER
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#     PRINT ' '
#     LET g_pageno = g_pageno + 1
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#     PRINT g_dash[1,g_len]
#     LET l_last_sw = 'n'
#
#  BEFORE GROUP OF sr.qdb.qdb013
#     SKIP TO TOP OF PAGE
#     SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=sr.qdb.qdb02
#     IF sr.qdb.qdb00='3' THEN
#        SELECT eca02 INTO l_eca02 FROM eca_file,ecm_file,qcm_file
#           WHERE qcm01=sr.qdb.qdb01 AND qcm02=ecm01 AND qcm05=ecm03
#             AND ecm06=eca01 AND qcm14 <> 'X'
#        IF STATUS THEN LET l_eca02='' END IF
#     END IF
#     SELECT MIN(qdc03),MAX(qdc03) INTO bdate,edate FROM qdc_file
#        WHERE qdc01=sr.qdc.qdc01
#          AND qdc011=sr.qdc.qdc011
#          AND qdc012=sr.qdc.qdc012
#          AND qdc013=sr.qdc.qdc013
#
#     IF sr.qdb.qdb011=0 THEN
#        LET l_qdb011='' LET l_qdb012=''
#     ELSE
#        LET l_qdb011=sr.qdb.qdb011 LET l_qdb012=sr.qdb.qdb012
#     END IF
#     PRINT COLUMN 01,g_x[11] CLIPPED,sr.qdb.qdb01,' ',l_qdb011 USING '##',
#                                                  ' ',l_qdb012 USING '##',
#                                                  ' ',sr.qdb.qdb013 USING '##'
#     PRINT COLUMN 01,g_x[12] CLIPPED,sr.qdb.qdb02 CLIPPED,' ',l_ima02 CLIPPED,
#           COLUMN 53,g_x[14] CLIPPED,l_eca02 CLIPPED
#     PRINT COLUMN 01,g_x[13] CLIPPED,bdate,'-',edate,
#           COLUMN 53,g_x[16] CLIPPED,sr.qdb.qdb03 USING '######'
#     SELECT azf03 INTO l_azf03 FROM azf_file
#       WHERE azf01=sr.qdb.qdb09 AND azf02='6'
#     IF STATUS THEN LET l_azf03='' END IF
#     PRINT COLUMN 01,g_x[15] CLIPPED,l_azf03 CLIPPED
#
#     PRINT COLUMN 01,g_x[17] CLIPPED,sr.qdb.qdb07,
#           COLUMN 33,g_x[19] CLIPPED,sr.qdb.qdb071,
#           COLUMN 53,g_x[20] CLIPPED,sr.qdb.qdb072
#     PRINT COLUMN 01,g_x[18] CLIPPED,sr.qdb.qdb08,
#           COLUMN 33,g_x[19] CLIPPED,sr.qdb.qdb081,
#           COLUMN 53,g_x[20] CLIPPED,sr.qdb.qdb082
#     PRINT g_dash_1[1,g_len]
#     PRINT COLUMN 18,g_x[21] CLIPPED,g_x[22] CLIPPED
#     PRINT COLUMN 18,g_x[23] CLIPPED,g_x[24] CLIPPED
#
#  ON EVERY ROW
#     PRINT COLUMN 16,sr.qdc.qdc02,
#           COLUMN 25,sr.qdc.qdc03,
#           COLUMN 34,sr.qdc.qdc04,
#           COLUMN 43,sr.qdc.qdc07 USING '####&.&&&',
#           COLUMN 54,sr.qdc.qdc08 USING '####&.&&&'
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
#Patch....NO.TQC-610036 <001,002,003> #


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
