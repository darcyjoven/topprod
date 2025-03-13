# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: asfr712.4gl
# Descriptions...: 直接人工工時移轉月報表
# Date & Author..: 99/06/01 By Iceman
# Modify.........: NO.FUN-510040 05/02/17 By Echo 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: No.FUN-550124 05/05/30 By echo 新增報表備註
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.MOD-640256 06/04/011 By pengu 責任部門,工時,合計工時沒有顯示出來
# Modify.........: No.FUN-680121 06/08/31 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0090 06/10/31 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A70095 11/06/14 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
#              wc      VARCHAR(600), #NO.TQC-6310166 MARK
              wc      STRING,
              yy      LIKE type_file.num5,          #No.FUN-680121 SMALLINT
              mm      LIKE type_file.num5,          #No.FUN-680121 SMALLINT
              bdate   LIKE type_file.dat,           #No.FUN-680121 DATE
              edate   LIKE type_file.dat            #No.FUN-680121 DATE
              END RECORD,
          g_shg RECORD LIKE shg_file.*,
          g_sfb RECORD LIKE sfb_file.*,
          g_no     LIKE type_file.num5,             #No.FUN-680121 SMALLINT
          g_sum    LIKE shb_file.shb09,
          g_x1     ARRAY[6] OF LIKE shg_file.shg05, #No.FUN-680121 VARCHAR(10)#合計使用
          l_x      LIKE type_file.num5,             #No.FUN-680121 SMALLINT
          last_y,last_m LIKE type_file.num5         #No.FUN-680121 SMALLINT
 
 
#DEFINE   g_dash          VARCHAR(400)   #Dash line
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
#DEFINE   g_len           SMALLINT   #Report width(79/132/136)
#DEFINE   g_pageno        SMALLINT   #Report page no
#DEFINE   g_zz05          VARCHAR(1)   #Print tm.wc ?(Y/N)
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123
 
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   CALL r712_tm(0,0)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION r712_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680121 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 14
   END IF
   OPEN WINDOW r712_w AT p_row,p_col
        WITH FORM "asf/42f/asfr712"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.yy=YEAR(g_today)
   LET tm.mm=MONTH(g_today)
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET g_no=1
 
WHILE TRUE
#  WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON shb05,shb10,shb08
#No.FUN-570240 --start--
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION controlp
            IF INFIELD(shb10) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO shb10
               NEXT FIELD shb10
            END IF
#No.FUN-570240 --end--
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
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
         CLOSE WINDOW r712_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
      END IF
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF
   INPUT BY NAME tm.yy,tm.mm WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
       AFTER FIELD mm
         IF tm.mm < 1 or tm.mm >12 THEN
            LET tm.mm=MONTH(g_today)
            NEXT FIELD mm
         END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
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
      CLOSE WINDOW r712_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r712()
   ERROR ""
END WHILE
   CLOSE WINDOW r712_w
END FUNCTION
 
FUNCTION r712()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680121 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_last    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
#         l_wo      LIKE apm_file.apm08,          #No.FUN-680121 VARCHAR(10)
          l_begin   LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_end     LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_za05    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          l_azf04   LIKE azf_file.azf04,
          l_shb03   LIKE shb_file.shb03,
          l_shb05   LIKE shb_file.shb05,
          sr        RECORD shb08  LIKE shb_file.shb08,   #線/班
                           shb02  LIKE shb_file.shb02,   #日期
                           shb05  LIKE shb_file.shb05,   #工單編號
                           shb06  LIKE shb_file.shb06,   #製程
                           shb04  LIKE shb_file.shb04,   #員工班號
                           shb032 LIKE shb_file.shb032,  #投入工時
                           shb07  LIKE shb_file.shb07    #工作中心
                    END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            # 只能使用自己的資料
    #        LET tm.wc= tm.wc clipped," AND shbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            # 只能使用相同群的資料
    #        LET tm.wc= tm.wc clipped," AND shbgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET tm.wc= tm.wc clipped," AND shbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('shbuser', 'shbgrup')
    #End:FUN-980030
 
 
     FOR l_x =1 TO 5 LET g_x1[l_x] = 0 END FOR
     LET tm.bdate=MDY(tm.mm,1,tm.yy)
     IF tm.mm=12 THEN
        LET tm.edate=MDY(1,1,tm.yy+1)-1
     ELSE
        LET tm.edate=MDY(tm.mm+1,1,tm.yy)-1
     END IF
     LET g_sum=0
     DROP TABLE x
     DROP TABLE x1
     LET l_sql = "SELECT shb08,shb02,shb05,shb06,shb04,shb032,shb07",
                 " FROM shb_file ",
                 " WHERE shb03 >='",tm.bdate,"'",
                 "   AND shb03 <='",tm.edate,"'",
                 "   AND shbconf = 'Y' ",    #FUN-A70095
                 "   AND ", tm.wc CLIPPED
 
     PREPARE r712_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
     END IF
     DECLARE r712_curs1 CURSOR FOR r712_prepare1
     CALL cl_outnam('asfr712') RETURNING l_name
     START REPORT r712_rep TO l_name
     LET g_pageno = 0
     FOREACH r712_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          OUTPUT TO REPORT r712_rep(sr.*)
     END FOREACH
     FINISH REPORT r712_rep
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r712_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_chr        LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_before LIKE ste_file.ste06,              #No.FUN-680121 DEC(10,2)
          l_end    LIKE ste_file.ste06,              #No.FUN-680121 DEC(10,2)
          l_gem02  LIKE gem_file.gem02,
          l_gen02  LIKE gen_file.gen02,
          l_ima02  LIKE ima_file.ima02,
          l_ecg02  LIKE ecg_file.ecg02,
          l_tot    LIKE shb_file.shb09,
          l_sum    LIKE shb_file.shb09,
          h_sum    LIKE shb_file.shb09,
          l_cnt    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_i      LIKE type_file.num5,          #No.FUN-680121 SMALLINT
           g_sql    string,  #No.FUN-580092 HCN
          l_i1     LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          j        LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          sr        RECORD shb08  LIKE shb_file.shb08,   #線/班
                           shb02  LIKE shb_file.shb02,   #日期
                           shb05  LIKE shb_file.shb05,   #工單編號
                           shb06  LIKE shb_file.shb06,   #製程
                           shb04  LIKE shb_file.shb04,   #員工班號
                           shb032 LIKE shb_file.shb032,  #投入工時
                           shb07  LIKE shb_file.shb07    #工作中心
                    END RECORD,
          sr1      RECORD
                           l_i      LIKE type_file.num5,          #No.FUN-680121 SMALLINT
                           shg10  LIKE shg_file.shg10,
                           shg05  LIKE shg_file.shg05
          END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line   #No.MOD-580242
 
  ORDER BY sr.shb08,sr.shb02
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT ' '
      LET l_ecg02=' '
      SELECT ecg02 INTO l_ecg02 FROM ecg_file WHERE ecg01=sr.shb08
      display length(g_x[12])
      PRINT g_x[11] CLIPPED,sr.shb08 CLIPPED,' ',l_ecg02,
            COLUMN ((g_len-FGL_WIDTH(g_x[12])-19)/2)+1,g_x[12] CLIPPED,tm.bdate,' - ',tm.edate
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
            g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],
            g_x[45],g_x[46],g_x[47]
      PRINT g_dash1
      LET l_last_sw = 'n'
      LET g_no=1
 
   BEFORE GROUP OF sr.shb08
      DELETE FROM x1
      INITIALIZE sr1.* TO NULL
      LET l_i  = 0
      LET l_sum=0
      SKIP TO TOP OF PAGE
 
   BEFORE GROUP OF sr.shb02
      INITIALIZE sr1.* TO NULL
      DELETE FROM x
      PRINT COLUMN g_c[31],sr.shb02;
      LET l_tot = 0
      LET l_i  = 0
 
   ON EVERY ROW
      SELECT gen02 INTO l_gen02 FROM gen_file where gen01=sr.shb04
 
      PRINT COLUMN g_c[32],sr.shb05,
            COLUMN g_c[33],sr.shb06,
            COLUMN g_c[34],sr.shb04,
            COLUMN g_c[35],l_gen02,
            COLUMN g_c[36],sr.shb032 USING '##,##&.&';
      PRINT ' '
#-----------責任單位/工時
   AFTER GROUP OF sr.shb02
       DROP TABLE x       #No.MOD-640256 add
       SELECT shg10,SUM(shg05) as x2  FROM shg_file
        WHERE shg021 = sr.shb08
          AND shg02 = sr.shb04
          AND shg06 = sr.shb05
          AND shg11 = 'Y'
         AND YEAR(shg01) = tm.yy
         AND MONTH(shg01) = tm.mm
          GROUP BY shg10
       #ORDER BY x2 DESC    #No.MOD-640256 mark
       INTO TEMP x
 
     DECLARE r712_curs2 CURSOR FOR
           SELECT '',shg10,x2 FROM x
              ORDER BY x2 DESC    #No.MOD-640256 add
     LET sr1.l_i = 1
     LET j = 37
     FOREACH r712_curs2 INTO sr1.*
     LET l_i = l_i + 1
        IF l_i > 5 THEN EXIT FOREACH END IF
        PRINT COLUMN g_c[j],sr1.shg10,COLUMN g_c[j+1],sr1.shg05 USING'####&';
     LET l_tot = l_tot + sr1.shg05
     LET j = j + 2
     LET g_x1[l_i] = g_x1[l_i] + sr1.shg05
     END FOREACH               #日期,班別,員工編號,工單,製程代號
     PRINT COLUMN g_c[47],l_tot USING '###,##&.&&'    #合計
     PRINT ' '
 
#------部門投入工時 ------------------
   AFTER GROUP OF sr.shb08
      PRINT g_dash2
      PRINT COLUMN g_c[31],g_x[13] CLIPPED ;
      LET h_sum = 0
       DROP TABLE x1       #No.MOD-640256 add
      SELECT shg10,SUM(shg05) as x2 FROM shg_file
       WHERE shg021 = sr.shb08
         AND shg11 = 'Y'
         AND YEAR(shg01) = tm.yy
         AND MONTH(shg01) = tm.mm
         GROUP BY shg10
        #ORDER BY x2 DESC     #No.MOD-640256 mark
      INTO TEMP x1
 
      DECLARE r712_curs3 CURSOR FOR
           SELECT '',shg10,x2 FROM x1
              ORDER BY x2 DESC     #No.MOD-640256 add
 
     LET l_i = 1
     FOREACH r712_curs3 INTO sr1.*
       IF l_i=1 OR l_i=2 OR l_i=3 OR l_i=4 THEN
             PRINT COLUMN g_c[37],sr1.shg10,COLUMN g_c[38],sr1.shg05 USING'####&';
       END IF
       IF l_i = 5 THEN
             PRINT COLUMN g_c[37],sr1.shg10,COLUMN g_c[38],sr1.shg05 USING'####&';
             PRINT ''
       END IF
       IF l_i=6 OR l_i=7 OR l_i=8 OR l_i=9 THEN
             PRINT COLUMN g_c[37],sr1.shg10,g_c[38],sr1.shg05 USING'####&';
       END IF
       IF l_i = 10 THEN
             PRINT COLUMN g_c[37],sr1.shg10,g_c[38],sr1.shg05 USING'####&';
             PRINT ''
       END IF
       IF l_i=11 OR l_i=12 OR l_i=13 OR l_i=15 THEN
             PRINT COLUMN g_c[37],sr1.shg10,g_c[38],sr1.shg05 USING'####&';
       END IF
     LET l_i = l_i + 1
     LET h_sum = h_sum + sr1.shg05
     END FOREACH               #日期,班別,員工編號,工單,製程代號
       LET l_sum=GROUP SUM(sr.shb032)
       PRINT COLUMN g_c[47],h_sum USING '###,##&.&&' ;   #部門合計
       LET g_sum = g_sum + l_sum                    #合計工時
       PRINT ''
#-----------合計投入工時
   ON LAST ROW
      LET l_last_sw = 'y'
      PRINT g_dash2
      LET g_x1[6] = g_x1[1]+g_x1[2]+g_x1[3]+g_x1[4]+g_x1[5]
      PRINT COLUMN g_c[31],g_x[14] CLIPPED,
            COLUMN g_c[36],g_sum USING '##,##&.&&',
            COLUMN g_c[38],g_x1[1] USING'########&.#',
            COLUMN g_c[40],g_x1[2] USING'########&.#',
            COLUMN g_c[42],g_x1[3] USING'########&.#',
            COLUMN g_c[44],g_x1[4] USING'########&.#',
            COLUMN g_c[46],g_x1[5] USING'########&.#',
            COLUMN g_c[47],g_x1[6] USING'###,##&.&&'
      PRINT g_dash
## FUN-550124
        # SKIP 2 LINE
        # PRINT g_x[15] CLIPPED, g_x[16]
   PAGE TRAILER
     #IF l_last_sw = 'y' THEN
     #   SKIP 3 LINE
     #ELSE SKIP 3 LINE
     #END IF
      PRINT
      IF l_last_sw = 'n' THEN
         IF g_memo_pagetrailer THEN
             PRINT g_x[15]
             PRINT g_memo
         ELSE
             PRINT
             PRINT
         END IF
      ELSE
             PRINT g_x[15]
             PRINT g_memo
      END IF
## END FUN-550124
 
END REPORT
 
