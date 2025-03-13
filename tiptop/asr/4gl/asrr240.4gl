# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: asrr240.4gl
# Descriptions...: 不良原因統計表
# Date & Author..: 2006/03/06 By Joe
# Modify.........: No.TQC-630251 06/03/27 By Joe 超過10種以上的異常原因 要列印在第二頁以後
# Modify.........: No.FUN-680130 06/08/31 By zhuying 欄位形態定義為LIKE
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-6C0142 06/12/28 By ray 報表問題修改
# Modify.........: No.FUN-7C0034 07/12/20 By johnray 使用CR打印報表
# Modify.........: No.FUN-880057 08/09/23 By Cockroach 過單
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-8A0067 09/03/04 By destiny 修改37區打印時報-201的錯
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9A0192 09/10/29 By Sarah l_table請定義為STRING
# Modify.........: No.FUN-B80063 11/08/05 By fanbj  EXIT PROGRAM 前加cl_used(2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              wc      STRING,
              bdate   LIKE type_file.dat,           #No.FUN-680130 DATE
              edate   LIKE type_file.dat,           #No.FUN-680130 DATE
              more    LIKE type_file.chr1           #No.FUN-680130 VARCHAR(1)
              END RECORD,
     g_line_1 DYNAMIC ARRAY OF RECORD
              line    LIKE srf_file.srf03,
              qty     LIKE sri_file.sri05
              END RECORD,
        g_res DYNAMIC ARRAY OF RECORD
              res     LIKE sri_file.sri04,
              qty     LIKE sri_file.sri05
              END RECORD
   DEFINE     g_i       LIKE type_file.num5,        # count/index for any purpose        #No.FUN-680130 SMALLINT
              g_line_ac LIKE type_file.num10,       #No.FUN-680130 INTEGER
              g_res_ac  LIKE type_file.num10,       #No.FUN-680130 INTEGER
              g_tqty LIKE sri_file.sri05
#No.FUN-7C0034 -- begin --
   DEFINE g_sql      STRING
   DEFINE l_table    STRING   #MOD-9A0192 mod chr20->STRING
   DEFINE g_str      STRING
#No.FUN-7C0034 -- end --
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASR")) THEN
      EXIT PROGRAM
   END IF
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
#No.FUN-7C0034 -- begin --
   LET g_sql = "srf03.srf_file.srf03,",
               "eci06.eci_file.eci06,",
               "sri04.sri_file.sri04,",
               "azf03.azf_file.azf03,",
               "sri05.sri_file.sri05,",
               "bad_rate.type_file.num20_6"
   LET l_table = cl_prt_temptable('asrr240',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
#No.FUN-7C0034 -- end --
#   CALL r240_cre_tmp()
   CREATE TEMP TABLE r240_tmp(
      srf03 LIKE srf_file.srf03,
      sri04 LIKE sri_file.sri04,
      sri05 LIKE sri_file.sri05)

   CALL cl_used(g_prog,g_time,1) RETURNING g_time      # FUN-B80063--add--
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r240_tm(0,0)
   ELSE
      CALL r240()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
END MAIN
 
FUNCTION r240_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680130 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680130 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 6 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 14
   END IF
   OPEN WINDOW r240_w AT p_row,p_col
        WITH FORM "asr/42f/asrr240"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.bdate= g_today
   LET tm.edate= g_today
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ' 1=1'
 
   WHILE TRUE
      WHILE TRUE
         CONSTRUCT BY NAME tm.wc ON srf03
            BEFORE CONSTRUCT
                CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE WHEN INFIELD(srf03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_eci"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO srf03
                 NEXT FIELD srf03
            END CASE
 
         ON ACTION locale
            CALL cl_show_fld_cont()
            LET g_action_choice = "locale"
            EXIT CONSTRUCT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         END CONSTRUCT
 
         IF g_action_choice = "locale" THEN
            LET g_action_choice = ""
            CALL cl_dynamic_locale()
            CONTINUE WHILE
         END IF
 
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            CLOSE WINDOW r240_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
            EXIT PROGRAM
         END IF
         IF tm.wc != ' 1=1' THEN EXIT WHILE END IF
         CALL cl_err('',9046,0)
      END WHILE
      INPUT BY NAME tm.bdate,tm.edate,tm.more WITHOUT DEFAULTS
 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
         AFTER FIELD bdate
             IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
 
         AFTER FIELD edate
             IF cl_null(tm.edate) THEN NEXT FIELD edate END IF
             IF tm.edate < tm.bdate THEN NEXT FIELD edate END IF
 
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
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r240_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
                WHERE zz01='asrr240'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('asrr240','9031',1)
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
                            " '",tm.bdate CLIPPED,"'",
                            " '",tm.edate CLIPPED,"'",
                            " '",g_rep_user CLIPPED,"'",
                            " '",g_rep_clas CLIPPED,"'",
                            " '",g_template CLIPPED,"'"
            CALL cl_cmdat('asrr240',g_time,l_cmd)
         END IF
         CLOSE WINDOW r240_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r240()
      ERROR ""
   END WHILE
   CLOSE WINDOW r240_w
END FUNCTION
 
#No.FUN-7C0034 -- start mark --
#FUNCTION r240()
#   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680130 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6B0014
#          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                 #No.FUN-680130 VARCHAR(1000)
#          l_chr     LIKE type_file.chr1,          #No.FUN-680130 VARCHAR(1)
#          l_za05    LIKE za_file.za05,            #No.FUN-680130 VARCHAR(40)
#          l_i       LIKE type_file.num10,         #No.FUN-680130 INTEGER
#          l_srf     RECORD LIKE srf_file.*,
#          l_srg     RECORD LIKE srg_file.*,
#          l_sri     RECORD LIKE sri_file.*,
#          l_line    LIKE srf_file.srf03,
#          l_res     LIKE sri_file.sri04,
#          l_qty     LIKE sri_file.sri05,
#          sr        RECORD
#                    page    LIKE type_file.num10,     ## 頁面頁次         #No.FUN-680130 INTEGER
#                    line    LIKE srf_file.srf03,      ## 機台編號
#                    resno   LIKE type_file.num10,     ## 不良原因頁面編號(1-10)  #No.FUN-680130 INTEGER
#                    qty     LIKE sri_file.sri05       ## 不良數量
#                    END RECORD
#
#     CALL g_zaa_dyn.clear()
#
#     CALL  cl_used(g_prog,g_time,1) RETURNING g_time   #No.FUN-6B0014
#     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#
#     IF g_priv2='4' THEN                           #只能使用自己的資料
#         LET tm.wc = tm.wc clipped," AND qcsuser = '",g_user,"'"
#     END IF
#     IF g_priv3='4' THEN                           #只能使用相同群的資料
#         LET tm.wc = tm.wc clipped," AND qcsgrup MATCHES '",g_grup CLIPPED,"*'"
#     END IF
#     IF g_priv3 MATCHES "[5678]" THEN              #TQC-5C0134群組權限
#         LET tm.wc = tm.wc clipped," AND qcsgrup IN ",cl_chk_tgrup_list()
#     END IF
#
#     LET l_sql = "SELECT * FROM srf_file,srg_file,sri_file ",
#                 " WHERE srf01=srg01 ",
#                 "   AND sri01=srg01 ",
#                 "   AND sri03=srg02 ",
#                 "   AND srfconf = 'Y'",
#                 "   AND srf02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
#                 "   AND ", tm.wc CLIPPED
#
#     PREPARE r240_prepare1 FROM l_sql
#     IF SQLCA.sqlcode != 0 THEN
#        CALL cl_err('prepare:',SQLCA.sqlcode,1)
#        EXIT PROGRAM
#     END IF
#     DECLARE r240_curs1 CURSOR FOR r240_prepare1
#     CALL cl_outnam('asrr240') RETURNING l_name
#     START REPORT r240_rep TO l_name
#
#     LET g_pageno = 0
#     LET g_line_ac = 0
#     LET g_res_ac = 0
#     ## 清除動態陣列----------------------------
#     CALL g_line_1.clear()
#     CALL g_res.clear()
#
#     DELETE FROM asrr240_tmp
#
#     FOREACH r240_curs1 INTO l_srf.*,l_srg.*,l_sri.*
#        IF SQLCA.sqlcode != 0 THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#        END IF
#        INSERT INTO asrr240_tmp VALUES (l_srf.srf03,l_sri.sri04,l_sri.sri05)
#     END FOREACH
#
#     #---計算選擇範圍內不良總數(g_tqty)------------
#     SELECT SUM(sri05) INTO g_tqty FROM asrr240_tmp
#
#     #---計算選擇範圍內機台(生產線)項次數(g_line_ac)並逐一填入陣列(g_line)---
#     SELECT COUNT(DISTINCT srf03) INTO g_line_ac FROM asrr240_tmp
#     LET l_i = 1
#     DECLARE r240_l CURSOR FOR
#      SELECT srf03,SUM(sri05) FROM asrr240_tmp
#      GROUP BY srf03
#     FOREACH r240_l INTO g_line_1[l_i].*
#        IF STATUS THEN
#           CALL cl_err('foreach line',STATUS,0)
#           EXIT FOREACH
#        END IF
#        IF l_i >= g_line_ac THEN
#           EXIT FOREACH
#        END IF
#        LET l_i = l_i + 1
#     END FOREACH
#
#     #--計算選擇範圍內不良原因項次數(g_res_ac)並逐一填入陣列(g_res)--
#     SELECT COUNT(DISTINCT sri04) INTO g_res_ac FROM asrr240_tmp
#     LET l_i = 1
#     DECLARE r240_res CURSOR FOR
#      SELECT sri04,SUM(sri05) FROM asrr240_tmp
#      GROUP BY sri04
#     FOREACH r240_res INTO g_res[l_i].*
#        IF STATUS THEN
#           CALL cl_err('foreach res',STATUS,0)
#           EXIT FOREACH
#        END IF
#        IF l_i >= g_res_ac THEN
#           EXIT FOREACH
#        END IF
#        LET l_i = l_i + 1
#     END FOREACH
#
#     ------單身資料-----------------
#     DECLARE r240_body CURSOR FOR
#      SELECT srf03,sri04,SUM(sri05) FROM asrr240_tmp
#      GROUP BY srf03,sri04
#     FOREACH r240_body INTO l_line,l_res,l_qty
#       IF STATUS THEN
#          CALL cl_err('foreach body',STATUS,0)
#          EXIT FOREACH
#       END IF
#       LET l_i = 1
#       WHILE g_res_ac >= l_i
#          IF g_res[l_i].res = l_res THEN
#             EXIT WHILE
#          END IF
#          LET l_i = l_i + 1
#       END WHILE
#       IF (l_i MOD 10) = 0 THEN
#          LET sr.page = l_i/10
#       ELSE
#          LET sr.page = (l_i/10) + 1
#       END IF
#       LET sr.line = l_line
#       LET sr.resno = (l_i MOD 10)
#       IF (l_i MOD 10) = 0 THEN
#          LET sr.resno = l_i
#       ELSE
#          LET sr.resno = (l_i MOD 10)
#       END IF
#       LET sr.qty = l_qty
#
#       OUTPUT TO REPORT r240_rep(sr.*)
#
#     END FOREACH
#
#     FINISH REPORT r240_rep
#
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#     CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-6B0014
#END FUNCTION
#
#REPORT r240_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680130 VARCHAR(1)
#          l_eci06      LIKE eci_file.eci06,
#          l_line_o     LIKE srf_file.srf03,
#          l_line_cnt   LIKE type_file.num10,         #No.FUN-680130 INTEGER
#          l_i          LIKE type_file.num10,         #No.FUN-680130 INTEGER
#          l_n          LIKE type_file.num10,         #No.FUN-680130 INTEGER
#          l_p          LIKE type_file.num10,         #No.FUN-680130 INTEGER
#          l_ac         LIKE type_file.num10,         #No.FUN-680130 INTEGER
#          sr    RECORD
#                page   LIKE type_file.num10,         ## 頁面頁次    #No.FUN-680130 INTEGER
#                line   LIKE srf_file.srf03,          ## 機台編號
#                resno  LIKE type_file.num10,         ## 不良原因頁面編號(1-10)   #No.FUN-680130 INTEGER
#                qty    LIKE sri_file.sri05  ## 不良數量
#                END RECORD,
#          l_qty ARRAY[10] OF RECORD
#                qty     LIKE sri_file.sri05
#                END RECORD,
#          l_str ARRAY[10] OF LIKE azf_file.azf03   #No.FUN-680130 ARRAY[10] OF VARCHAR(40)
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.page,sr.line,sr.resno
#
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT g_head CLIPPED,pageno_total     #No.TQC-6C0142
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      PRINT COLUMN 95,g_x[15] CLIPPED,tm.bdate,' - ',tm.edate
##     PRINT g_head CLIPPED,pageno_total     #No.TQC-6C0142
#      PRINT g_dash
#
#      LET l_ac = (g_res_ac/10) + 1
#      LET l_line_o = NULL
#      LET l_line_cnt = 0
#
#      FOR l_p = 1 to 10
#         LET g_zaa[34+l_p].zaa08 = g_res[(sr.page-1)*10+l_p].res
#      END FOR
#
#      CALL cl_prt_pos_dyn()
#
#      PRINTX name=H1 g_x[31],g_x[32],g_x[35],g_x[36],g_x[37],g_x[38],
#                     g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.page
#      IF sr.page <> 1 THEN
#         SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.line
#      IF l_line_cnt  = 15 THEN
#         SKIP TO TOP OF PAGE
#      END IF
#
#   ON EVERY ROW
#      LET l_qty[sr.resno].qty = sr.qty
#      SELECT eci06 INTO l_eci06 FROM eci_file WHERE eci01 = sr.line
#      IF (sr.line <> l_line_o) OR cl_null(l_line_o) THEN
#         PRINTX name=D1 COLUMN g_c[31],sr.line CLIPPED,
#                        COLUMN g_c[32],l_eci06 CLIPPED;
#         LET l_line_o = sr.line
#      END IF
#      PRINTX name=D1 COLUMN g_c[34+sr.resno],r240_chk_print(sr.qty,1,3);
#      IF l_ac = sr.page THEN
#         LET l_i = 1
#         WHILE g_line_ac >= l_i
#            IF sr.line = g_line_1[l_i].line THEN
#               EXIT WHILE
#            END IF
#            LET l_i = l_i + 1
#         END WHILE
#         PRINTX name=D1 COLUMN g_c[45],r240_chk_print(g_line_1[l_i].qty,1,3);
#      END IF
#
#   AFTER GROUP OF sr.line   #機台(生產線)
#      PRINTX name=D1 ''
#      LET l_n = 1
#      WHILE g_line_ac >= l_n
#         IF sr.line = g_line_1[l_n].line THEN
#            EXIT WHILE
#         END IF
#         LET l_n = l_n + 1
#      END WHILE
#      FOR l_i = 1 TO 10
#         IF NOT cl_null(l_qty[l_i].qty) THEN
#            PRINTX name=D1 COLUMN g_c[34+l_i],r240_chk_print((l_qty[l_i].qty/g_line_1[l_n].qty)*100,2,2);
#         END IF
#      END FOR
#      IF l_ac = sr.page THEN
#         PRINTX name=D1 COLUMN g_c[45],r240_chk_print(100,2,2);
#      END IF
#      FOR l_i = 1 TO 10
#         INITIALIZE l_qty[l_i].* TO NULL
#      END FOR
#      PRINTX name=D1 ''
#      PRINT g_dash1
#      LET l_line_cnt = l_line_cnt + 1
#
#   AFTER GROUP OF sr.page   # 頁面
#      PRINTX name=D1 COLUMN g_c[31],g_x[16] CLIPPED;
#      FOR l_i = 1 to 10
#         PRINTX name=D1 COLUMN g_c[34+l_i],r240_chk_print(g_res[(sr.page-1)*10+l_i].qty,1,3);
#      END FOR
#      IF l_ac = sr.page THEN
#         PRINTX name=D1 COLUMN g_c[45],r240_chk_print(g_tqty,1,3)
#      ELSE
#         PRINTX name=D1 ''
#      END IF
#      FOR l_i = 1 to 10
#         PRINTX name=D1 COLUMN g_c[34+l_i],r240_chk_print((g_res[(sr.page-1)*10+l_i].qty/g_tqty)*100,2,2);
#      END FOR
#      IF l_ac = sr.page THEN
#         PRINTX name=D1 COLUMN g_c[45],r240_chk_print(100,2,2)
#      ELSE
#         PRINTX name=D1 ''
#      END IF
#      PRINT
#      PRINT
#      FOR l_i = 1 to 10
#         CALL r240_azf(g_res[(sr.page-1)*10+l_i].res) RETURNING l_str[l_i]
#      END FOR
#      PRINT COLUMN g_c[31],g_res[(sr.page-1)*10+1].res,' ',l_str[1],
#            COLUMN g_c[35],g_res[(sr.page-1)*10+2].res,' ',l_str[2],
#            COLUMN g_c[38],g_res[(sr.page-1)*10+3].res,' ',l_str[3],
#            COLUMN g_c[41],g_res[(sr.page-1)*10+4].res,' ',l_str[4]
#      PRINT COLUMN g_c[31],g_res[(sr.page-1)*10+5].res,' ',l_str[5],
#            COLUMN g_c[35],g_res[(sr.page-1)*10+6].res,' ',l_str[6],
#            COLUMN g_c[38],g_res[(sr.page-1)*10+7].res,' ',l_str[7],
#            COLUMN g_c[41],g_res[(sr.page-1)*10+8].res,' ',l_str[8]
#      PRINT COLUMN g_c[31],g_res[(sr.page-1)*10+9].res,' ',l_str[9],
#            COLUMN g_c[35],g_res[(sr.page-1)*10+10].res,' ',l_str[10]
#
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         PRINT g_dash
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE
#         SKIP 2 LINE
#      END IF
#
#   ON LAST ROW
#
#END REPORT
#
#FUNCTION r240_azf(p_sri04)
#   DEFINE p_sri04   LIKE sri_file.sri04,
#          l_str     LIKE azf_file.azf03      #No.FUN-680130 VARCHAR(40)
#
#   SELECT azf03 INTO l_str
#     FROM azf_file
#    WHERE azf01 = p_sri04
#      AND azf02 = '6'
#
#   RETURN l_str
#END FUNCTION
#
#FUNCTION r240_cre_tmp()
#  CREATE TEMP TABLE asrr240_tmp
#   (srf03 LIKE srf_file.srf03,
#    sri04 LIKE sri_file.sri04,
#    sri05 LIKE sri_file.sri05)
#END FUNCTION
#
#FUNCTION r240_chk_print(p_value,p_form,p_n)
#   DEFINE p_value   LIKE sri_file.sri05,       # 傳入判斷數 #No.FUN-680130 DEC(15,3)
#          p_form    LIKE type_file.num5,       # 顯示格式 qty-->15  %-->14+%    #No.FUN-680130 SMALLINT
#          p_n       LIKE type_file.num5,       # 顯示小數位數         #No.FUN-680130 SMALLINT
#          p_str     LIKE type_file.chr20       #No.FUN-680130 VARCHAR(15)
#
#   IF (NOT cl_null(p_value)) AND (p_value <> 0) THEN
#      IF p_form = 2 THEN          # %型式
#         LET p_str = cl_numfor(p_value,14,p_n) CLIPPED,'%'
#      ELSE
#         LET p_str = cl_numfor(p_value,15,p_n)
#      END IF
#   ELSE
#      LET p_str = ''
#   END IF
#   RETURN p_str
#END FUNCTION
#No.FUN-7C0034 -- end mark --
 
#No.FUN-7C0034 -- start add --
#使用CR打印報表,將原報表拆分為兩個部分:基于單一生產線的不良原因統計和
#                                      基于所有生產線的不良原因統計
FUNCTION r240()
   DEFINE #l_sql           LIKE type_file.chr1000
          l_sql           STRING       #NO.FUN-910082  
   DEFINE l_za04          LIKE za_file.za05
   DEFINE l_srf03         LIKE srf_file.srf03
   DEFINE l_sri04         LIKE sri_file.sri04
   DEFINE l_sri05         LIKE sri_file.sri05
   DEFINE l_sum_sri05     LIKE sri_file.sri05
   DEFINE l_tot_sri05     LIKE type_file.num20_6
   DEFINE sr RECORD
                srf03     LIKE srf_file.srf03,
                eci06     LIKE eci_file.eci06,
                sri04     LIKE sri_file.sri04,
                azf03     LIKE azf_file.azf03,
                sri05     LIKE sri_file.sri05,
                bad_rate  LIKE type_file.num20_6
             END RECORD

   # No.FUN-B80063----start mark------------------------------------
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time
   # No.FUN-B80063----end mark--------------------------------------

   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   CALL cl_del_data(l_table)
   DELETE FROM r240_tmp
  #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,               #No.FUN-8A0067
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,     #No.FUN-8A0067
               " VALUES(?,?,?,?,?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add-- 
      EXIT PROGRAM
   END IF
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN
   #      LET tm.wc = tm.wc clipped," AND srfuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN
   #      LET tm.wc = tm.wc clipped," AND srfgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN
   #      LET tm.wc = tm.wc clipped," AND srfgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('srfuser', 'srfgrup')
   #End:FUN-980030
 
   #1.將各生產線的不良數按不良代碼存儲到臨時表中
   LET l_sql = "SELECT srf03,sri04,SUM(sri05) ",
               "  FROM srf_file,srg_file,sri_file ",
               " WHERE srf01 = srg01 AND sri01 = srg01 AND sri03 = srg02 ",
               "   AND srfconf = 'Y' ",
               "   AND srf02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
               "   AND ",tm.wc CLIPPED,
               " GROUP BY srf03,sri04"
   PREPARE r240_prepare1 FROM l_sql
   IF SQLCA.sqlcode !=0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
      EXIT PROGRAM
   END IF
   DECLARE r240_curs1 CURSOR FOR r240_prepare1
   FOREACH r240_curs1 INTO l_srf03,l_sri04,l_sri05
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      INSERT INTO r240_tmp VALUES(l_srf03,l_sri04,l_sri05)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","r240_tmp",l_srf03,l_sri04,SQLCA.sqlcode,"","insert r240_tmp",1)
         EXIT FOREACH
      END IF
   END FOREACH
 
   #2.從臨時表中讀數據,抓說明欄位,送到CR數據集
   LET l_sql = "SELECT srf03,'',sri04,'',sri05,0 ",
               " FROM r240_tmp "
   PREPARE r240_prepare2 FROM l_sql
   IF SQLCA.sqlcode !=0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
      EXIT PROGRAM
   END IF
   DECLARE r240_curs2 CURSOR FOR r240_prepare2
   FOREACH r240_curs2 INTO sr.*
      IF SQLCA.sqlcode !=0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT eci06 INTO sr.eci06 FROM eci_file WHERE eci01 = sr.srf03
      IF SQLCA.sqlcode = 100 THEN
         LET sr.eci06 = ' '
      END IF
      SELECT azf03 INTO sr.azf03 FROM azf_file WHERE azf01 = sr.sri04
      IF SQLCA.sqlcode = 100 THEN
         LET sr.azf03 = ' '
      END IF
      SELECT SUM(sri05) INTO l_sum_sri05 FROM r240_tmp
       WHERE srf03 = sr.srf03
      IF SQLCA.sqlcode THEN
         LET sr.bad_rate = 0
      ELSE
         LET sr.bad_rate = sr.sri05/l_sum_sri05*100
      END IF
      EXECUTE insert_prep USING sr.*
      IF STATUS THEN
         CALL cl_err("execute insert_prep:",STATUS,1)
         EXIT FOREACH
      END IF
   END FOREACH
   SELECT SUM(sri05) into l_tot_sri05 FROM r240_tmp   #以參數方式向CR傳遞不良總數,作為統計不良率之用
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   CALL cl_wcchp(tm.wc,'aaa00,aaa01') RETURNING tm.wc
   LET g_str = tm.wc,";",g_zz05,";",l_tot_sri05
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   CALL cl_prt_cs3('asrr240','asrr240',g_sql,g_str)
END FUNCTION
#No.FUN-7C0034 -- end add --
#No.FUN-880057 
