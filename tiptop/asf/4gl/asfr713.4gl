# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asfr713.4gl
# Descriptions...: 效率月統計表(人工)
# Date & Author..: 99/05/27 by patricia
# Modify.........: NO.FUN-510040 05/02/15 By Echo 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.MOD-580342 05/09/06 By Claire c02 Lengh 改為 VARCHAR(10)
# Modify.........: No.TQC-5C0026 05/12/06 By kevin 結束位置調整
#
# Modify.........: No.FUN-680121 06/08/31 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0090 06/10/31 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.TQC-770004 07/07/03 By mike 幫組按鈕灰色
# Modify.........: No.MOD-7C0220 08/01/03 By Pengu 1.算產出工時(B)時應在除於生產數量
#                                                  2.生產力應=產出量 sum(shb111+shb112) * 100/投入工時
#                                                  3.生產效率應=產出工時(B) * 100/投入工時
# Modify.........: NO.FUN-830054 08/07/28 By zhaijie 報表輸出改為CR
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No:MOD-A40149 10/04/23 by jan 程序不能r.c2
# Modify.........: No.TQC-A50156 10/05/28 By Carrier sum3写错成sum2
# Modify.........: No.FUN-A60027 10/06/22 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A70095 11/06/14 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
# Modify.........: No:CHI-B80086 11/10/06 By johung 修改轉嫁工時抓取方式，並改以"時"顯示
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              wc      LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(600)
              bdate   LIKE type_file.dat,           #No.FUN-680121 DATE
              edate   LIKE type_file.dat,           #No.FUN-680121 DATE
              yy      LIKE type_file.num5,          #No.FUN-680121 SMALLINT
              mm      LIKE type_file.num5           #No.FUN-680121 SMALLINT
              END RECORD,
          g_max       LIKE type_file.num5           #No.FUN-680121 SMALLINT
#          g_dash1  VARCHAR(140),
#          g_sql   LIKE type_file.chr1000            #No.FUN-680121 VARCHAR(300)#NO.FUN-830054--MARK-
 
DEFINE   g_cnt           LIKE type_file.num10       #No.FUN-680121 INTEGER
#DEFINE   g_dash          VARCHAR(400)   #Dash line
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
#DEFINE   g_len           SMALLINT   #Report width(79/132/136)
#DEFINE   g_zz05          VARCHAR(1)   #Print tm.wc ?(Y/N)
#NO.FUN-830054------START---
DEFINE   g_sql         STRING
DEFINE   g_str         STRING
DEFINE   l_table       STRING
#NO.FUN-830054------END----
 
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
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 #FUN-BB0047 mark
 
#NO.FUN-830054------START---
   LET g_sql = "shb08.shb_file.shb08,",
               "sum1.shb_file.shb032,",
#              "sum2.ima_file.ima26,",
#              "sum3.ima_file.ima26,",
               "sum2.type_file.num15_3,",   #NO.FUN-A20044
               "sum3.type_file.num15_3,",   #NO.FUN-A20044  #No.TQC-A50156
               "l_ecg02.ecg_file.ecg02,",
               "l_E.shb_file.shb111,",
               "sum_E.shb_file.shb111"
   LET l_table = cl_prt_temptable('asfr713',g_sql) CLIPPED
   IF  l_table =-1 THEN EXIT PROGRAM END IF
   LET g_sql ="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#NO.FUN-830054------END---
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET g_sql = ''
   IF cl_null(g_bgjob) OR g_bgjob ='N' THEN
      CALL r713_tm(0,0)
   ELSE
      CALL asfr713()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION r713_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_cmd        LIKE type_file.chr1000          #No.FUN-680121 CAHR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 10 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 10
   END IF
   OPEN WINDOW r713_w AT p_row,p_col
        WITH FORM "asf/42f/asfr713"
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
WHILE TRUE
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
     ON ACTION help                              #No.TQC-770004  
         LET g_action_choice="help"     #No.TQC-770004  
         CALL cl_show_help()                   #No.TQC-770004  
         CONTINUE CONSTRUCT                #No.TQC-770004
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
         CLOSE WINDOW r713_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
      END IF
   INPUT BY NAME tm.yy,tm.mm WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
       AFTER FIELD mm
         IF tm.mm < 1 OR tm.mm > 12 THEN
            LET tm.mm=MONTH(g_today)
            NEXT FIELD mm
         END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
          ON ACTION help                              #No.TQC-770004                                                                     
            LET g_action_choice="help"     #No.TQC-770004                                                                              
            CALL cl_show_help()                   #No.TQC-770004                                                                       
            CONTINUE INPUT                #No.TQC-770004           
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
      CLOSE WINDOW r713_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL asfr713()
   ERROR ""
END WHILE
   CLOSE WINDOW r713_w
END FUNCTION
 
FUNCTION asfr713()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680121 VARCHAR(1100)
          l_chr     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_sgf02   LIKE sgf_file.sgf02,
          l_za05    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          l_b00   LIKE type_file.num5,            #No.FUN-680121 SMALLINT
          l_b01   LIKE aab_file.aab02,            #No.FUN-680121 VARCHAR(06)
          l_b03   LIKE sta_file.sta04,            #No.FUN-680121 DEC(10,4)
          sr3    ARRAY[100] OF LIKE oea_file.oea01,        #No.FUN-680121 VARCHAR(12)
         sgb04,sgb04_old LIKE sgb_file.sgb04,
         l_count,l_i,l_max   LIKE type_file.num5,          #No.FUN-680121 SMALLINT
         l_cmd1,l_cmd2 ARRAY[15] OF LIKE type_file.chr6,   #No.FUN-680121 VARCHAR(6)	
         l_cmd11,l_cmd22 LIKE type_file.chr1000,           #No.FUN-680121 VARCHAR(300)
         l_cnt,l_cntt    LIKE type_file.num5,              #No.FUN-680121 SMALLINT
         l_shb08  LIKE shb_file.shb08,
         l_shb05  LIKE shb_File.shb05,            #CHI-B80086 add
           sr     RECORD
              shb05   LIKE shb_file.shb05,        #CHI-B80086 add
              shb08   LIKE shb_file.shb08,        #線/班次編號 
              sum1    LIKE shb_file.shb032,       #No.FUN-680121 DEC(6,2)#sum(shb032) /60
#             sum2    LIKE ima_file.ima26,        #No.FUN-680121 DEC(13,3)#sum(shb111+shb112)
#             sum3    LIKE ima_file.ima26         #No.FUN-680121 DEC(15,3)#sum(shb111+shb112)*ecm14
              sum2    LIKE type_file.num15_3,     ###GP5.2  #NO.FUN-A20044
              sum3    LIKE type_file.num15_3      ###GP5.2  #NO.FUN-A20044
                 END RECORD,
           sr2       RECORD
              shg021  LIKE shg_file.shg021,   #班別編號
              sgb04   LIKE sgb_file.sgb04,    #屬性
              shg09   LIKE shg_file.shg09     #核準工時
                 END RECORD
   DEFINE l_E,sum_E    LIKE shb_file.shb111   #NO.FUN-830054
   DEFINE l_ecg02      LIKE ecg_file.ecg02    #NO.FUN-830054
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #產生暫存檔
     CALL r713_create_tp1()
     CALL r713_create_tp2()  #核準工時
     CALL r713_create_tp3()
     LET g_max = ''
 
     CALL cl_del_data(l_table)                 #NO.FUN-830054
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='asfr713' #NO.FUN-830054
    #--------------
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
 
 
     LET tm.bdate=MDY(tm.mm,1,tm.yy)
     IF tm.mm=12 THEN
        LET tm.edate=MDY(1,1,tm.yy+1)-1
     ELSE
        LET tm.edate=MDY(tm.mm+1,1,tm.yy)-1
     END IF
      #-----------No.MOD-7C022 modify
      #LET l_sql=" SELECT shb08,SUM(shb032)/60,SUM(shb111+shb112),",
      #          " SUM(shb111+shb112) *(ecm14/3600) ",    
      #          " FROM shb_file,ecm_file ",
      #          "  WHERE shb03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
      #          "    AND shb05 = ecm01 AND shb06 = ecm03 ",
      #          "    AND ",tm.wc CLIPPED,
      #          " GROUP BY shb08,shb032,shb111,shb112,ecm14 "
      #LET l_sql=" SELECT shb08,SUM(shb032)/60,SUM(shb111+shb112),",         #CHI-B80086 mark
       LET l_sql=" SELECT shb05,shb08,SUM(shb032)/60,SUM(shb111+shb112),",   #CHI-B80086
                 " SUM(shb111+shb112) *(ecm14/(3600*sfb08)) ",    
                 " FROM shb_file,ecm_file,sfb_file ",
                 "  WHERE shb03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 "    AND shb05 = ecm01 AND shb06 = ecm03 ",
                 "    AND sfb01=shb05 ",
                 "    AND ecm012 = shb012 ",    #FUN-A60027 add 
                 "    AND shbconf = 'Y' ",      #FUN-A70095 add
                 "    AND ",tm.wc CLIPPED,
                #" GROUP BY shb08,shb032,shb111,shb112,ecm14,sfb08 "         #CHI-B80086 mark
                 " GROUP BY shb05,shb08,shb032,shb111,shb112,ecm14,sfb08 "   #CHI-B80086
      #-----------No.MOD-7C022 end
     PREPARE r713_pre1 FROM l_sql
     IF SQLCA.sqlcode THEN CALL cl_err('r713_pre1',STATUS,1) END IF
     DECLARE r713_curs1 CURSOR FOR r713_pre1
     IF SQLCA.sqlcode THEN CALL cl_err('r713_curs1',STATUS,1) END IF
#     CALL cl_outnam('asfr713') RETURNING l_name          #NO.FUN-830054
#     START REPORT r713_rep TO l_name                     #NO.FUN-830054
     FOREACH r713_curs1 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
         #----------------INS TMP1--------------------
        #INSERT INTO tp1_file(a01,a02,a03,a04)               #CHI-B80086 mark
        #VALUES(sr.shb08,sr.sum1,sr.sum2,sr.sum3)            #CHI-B80086 mark
         INSERT INTO tp1_file(a05,a01,a02,a03,a04)           #CHI-B80086
         VALUES(sr.shb05,sr.shb08,sr.sum1,sr.sum2,sr.sum3)   #CHI-B80086
         IF SQLCA.sqlcode THEN CALL cl_err('ins tp1',STATUS,1) END IF
     END FOREACH
 
     DECLARE tp1_cur CURSOR FOR
       #SELECT UNIQUE(a01) FROM tp1_file       #CHI-B80086 mark
        SELECT UNIQUE(a01),a05 FROM tp1_file   #CHI-B80086
        ORDER BY a01
      IF SQLCA.sqlcode THEN CALL cl_err('tp1_cur',STATUS,1) END IF
    #FOREACH tp1_cur INTO l_shb08  #每一班別 #CHI-B80086 mark
     FOREACH tp1_cur INTO l_shb08,l_shb05    #CHI-B80086
      IF SQLCA.sqlcode THEN CALL cl_err('tp1_for',STATUS,1) EXIT FOREACH
      END IF
        #--------抓屬性-----------------
     #LET l_sql="SELECT shg021,sgb04,shg09 FROM shg_file, sgb_file ",      #CHI-B80086 mark
      LET l_sql="SELECT shg021,sgb04,shg09/60 FROM shg_file, sgb_file ",   #CHI-B80086
                " WHERE shg021 = '",l_shb08,"'",         #班別
                "  AND shg06 = '",l_shb05,"'",   #CHI-B80086 add
                "  AND shg01 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                "  AND shg04 = sgb01 ",
                " ORDER BY sgb04 " CLIPPED
        PREPARE shg_pre FROM l_sql
        DECLARE shg_cur CURSOR FOR shg_pre
        IF SQLCA.sqlcode THEN CALL cl_err('shg_cur',STATUS,1) END IF
 
        FOREACH shg_cur INTO sr2.*
         IF SQLCA.sqlcode THEN CALL cl_err('shg_for',STATUS,1)
            EXIT FOREACH END IF
         INSERT INTO tp3_file(c01,c02,c03) VALUES(sr2.shg021,sr2.sgb04,sr2.shg09)
         IF SQLCA.sqlcode THEN
          CALL cl_err('ins tp3',STATUS,1)
         END IF
        END FOREACH
     END FOREACH
     unload to "/u3/top40/tp3.txt" select * from tp3_file
 
 
        DECLARE tp3_cur CURSOR FOR
         SELECT c01,c02,c03 FROM tp3_file
         ORDER BY c02      #異常代號
        IF SQLCA.sqlcode THEN CALL cl_err('tp3_cur',STATUS,1) END IF
        LET sgb04_old = ' '
        LET sgb04 = ' '
        LET l_cnt = 0
        FOREACH tp3_cur INTO sr2.*
          LET sgb04 = sr2.sgb04
          IF sgb04 != sgb04_old THEN
              LET l_cnt = l_cnt + 1
          END IF
          SELECT sgf02 INTO l_sgf02 FROM sgf_file
          WHERE sgf01 = sr2.sgb04
          #-----------INS TMP2-----------
          INSERT INTO tp2_file(b00,b01,b02,b03)
               VALUES(l_cnt,sr2.shg021,l_sgf02,sr2.shg09)
          IF SQLCA.sqlcode THEN CALL cl_err('ins tp2',STATUS,1) END IF
          LET sgb04_old = sgb04
        END FOREACH
     unload to "/u3/top40/tp2.txt" select * from tp2_file
 
 
     DECLARE tp2_cur CURSOR FOR
       SELECT UNIQUE(b00) FROM tp2_file
       ORDER BY b00
     IF SQLCA.sqlcode THEN CALL cl_err('tp2_cur',STATUS,1) END IF
     LET l_i = 1
     FOREACH tp2_cur INTO l_cnt
      IF SQLCA.sqlcode THEN CALL cl_err('tp2_for',STATUS,1) EXIT FOREACH END IF
      SELECT UNIQUE(b02) INTO l_sgf02 FROM tp2_file
      WHERE b00 = l_cnt
      LET sr3[l_i] = l_sgf02
      LET l_i = l_i + 1
     END FOREACH
      LET l_i = l_i - 1
     for g_cnt = 1 to 15
      LET l_cmd1[g_cnt] = NULL
      LET l_cmd2[g_cnt] = NULL
     end for
     #-----------組表頭的字串------------
     FOR g_cnt = 1 TO l_i
           LET l_cmd1[g_cnt] =sr3[g_cnt][1,6]
           LET l_cmd2[g_cnt]= sr3[g_cnt][7,12]
     END FOR
     for g_cnt = 1 to l_i
       let l_count = (g_cnt-1)*12+8
       let l_cmd11[(g_cnt-1)*6+1,(g_cnt-1)*6+6] = l_cmd1[g_cnt] clipped
       let l_cmd22[(g_cnt-1)*6+1,(g_cnt-1)*6+6]= l_cmd2[g_cnt] clipped
     end for
     let l_cmd11 = l_cmd11 clipped
     let l_cmd22 = l_cmd22 clipped
     select count(distinct b02) into g_max from tp2_file
    #------------------------------
    #---------丟到報表----------
     DECLARE r713_cur CURSOR FOR
       SELECT * FROM tp1_file
       ORDER BY a01
     IF SQLCA.sqlcode THEN CALL cl_err('r713_cur',STATUS,1) END IF
     FOREACH r713_cur INTO sr.*
      IF SQLCA.sqlcode THEN CALL cl_err('r713_for',STATUS,1)
         EXIT FOREACH END IF
#      OUTPUT TO REPORT r713_rep(sr.*,l_cmd11,l_cmd22,g_max) #NO.FUN-830054
#NO.FUN-830054-------START-----
      SELECT ecg02 INTO l_ecg02 FROM ecg_file WHERE ecg01 = sr.shb08
      IF l_ecg02 IS NULL THEN LET l_ecg02 = '-' END IF
      let l_sql = " select sum(b03) from tp2_file",
                  " where b01 ='",sr.shb08,"' ",
                  " and b00 = ? " clipped
      let g_sql = l_sql
      prepare b000_pre from l_sql
      if sqlca.sqlcode then call cl_err('b000_pre',STATUS,1) end if
      declare b000_cur cursor for b000_pre
      if sqlca.sqlcode then call cl_err('b000_cur',STATUS,1) end if
      for g_cnt = 1 to g_max
         let l_b03 = ''
         open b000_cur using g_cnt
         fetch b000_cur into l_b03
#         print column (42+(g_cnt-1)*7),l_b03 using '####&.#&';
      end for
 
      SELECT SUM(b03) INTO l_E FROM tp2_file
        WHERE b01 = sr.shb08
      IF l_E IS NULL THEN LET l_E = 0 END IF
 
 
       let l_sql = " select sum(b03) from tp2_file",
                   " where b00 = ? " clipped
           prepare b0001_pre from l_sql
       if sqlca.sqlcode then call cl_err('b0001_pre',STATUS,1) end if
       declare b0001_cur cursor for b0001_pre
       if sqlca.sqlcode then call cl_err('b0001_cur',STATUS,1) end if
       for g_cnt = 1 to g_max
         let l_b03 =''
         open b0001_cur using g_cnt
         fetch b0001_cur into l_b03
        if cl_null(l_b03) then let l_b03 = '@@@@' end if
#        print column (42+(g_cnt-1)*7),l_b03 using '####&.#&';
      end for
 
      select sum(b03) into sum_E from tp2_file
      IF sum_E IS NULL THEN LET sum_E = 0 END IF
     
      EXECUTE insert_prep USING
             sr.shb08,sr.sum1,sr.sum2,sr.sum3,l_ecg02,l_E,sum_E
#NO.FUN-830054-------END------
     END FOREACH
 
#      FINISH REPORT r713_rep                              #NO.FUN-830054
      delete from tp1_file where 1=1
      delete from tp2_file where 1=1
      delete from tp3_file where 1=1
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)          #NO.FUN-830054
#NO.FUN-830054-------start------
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 
     IF g_zz05 ='Y' THEN 
       CALL cl_wcchp(tm.wc,'shb05,shb10,shb08')
            RETURNING tm.wc
     END IF 
     LET  g_str=tm.wc,";",tm.bdate,";",tm.edate
     CALL cl_prt_cs3('asfr713','asfr713',g_sql,g_str)
#NO.FUN-830054-------end------
END FUNCTION
 
#NO.FUN-830054----START---MARK----
{REPORT r713_rep(sr,p_cmd1,p_cmd2,p_max)
  DEFINE l_last_sw     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
         p_cmd1,p_cmd2 LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(300)
         p_max        LIKE type_file.num5,           #No.FUN-680121 SMALLINT
         l_ecg02      LIKE ecg_file.ecg02,
         l_b03        LIKE sta_file.sta04,           #No.FUN-680121 DEC(10,4)
         l_A,sum_A    LIKE shb_file.shb111,          #No.FUN-680121 DEC(12,3)
         l_B,sum_B    LIKE shb_file.shb111,          #No.FUN-680121 DEC(12,3)
         l_E,sum_E    LIKE shb_file.shb111,          #No.FUN-680121 DEC(12,3)
         l_F,sum_F    LIKE shb_file.shb111,          #No.FUN-680121 DEC(12,3)
         l_G,sum_G    LIKE shb_file.shb111,          #No.FUN-680121 DEC(12,3)
         l_H,sum_H    LIKE shb_file.shb111,          #No.FUN-680121 DEC(12,3)
         l_I,sum_I    LIKE shb_file.shb111,          #No.FUN-680121 DEC(12,3)
         l_cnt        LIKE type_file.num5,           #No.FUN-680121 SMALLINT
         l_sql        LIKE type_file.chr1000,        #No.FUN-680121 VARCHAR(1100)
         sr     RECORD
              shb08   LIKE shb_file.shb08,  #線/班次編號
              sum1    LIKE shb_file.shb032,          #No.FUN-680121 DEC(6,2)#sum(shb032) /60
              sum2    LIKE ima_file.ima26,           #No.FUN-680121 DEC(13,3)#sum(shb111+shb112)
              sum3    LIKE ima_file.ima26            #No.FUN-680121 DEC(15,3)#sum(shb111+shb112)*ecm14
                END RECORD
 
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line   #No.MOD-580242
  ORDER BY sr.shb08   #班/線別
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT ' '
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT ' '
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
            COLUMN ((g_len-FGL_WIDTH(g_x[9]))/2)+1,g_x[9] CLIPPED,tm.bdate,'-',tm.edate,
            COLUMN g_len-7,g_x[3] CLIPPED,pageno_total
      PRINT g_dash[1,g_len]
 
#     PRINT g_x[10] CLIPPED;
#           for g_i = 1 to p_max
#             print COLUMN 44+(g_i-1)*6,p_cmd1[(g_i-1)*6+1,(g_i-1)*6+6],'  ';
#           end for
#       print COLUMN (42+(p_max)*7+11),g_x[11] CLIPPED,
#           COLUMN (42+(p_max)*7+19),g_x[11] CLIPPED,
#           COLUMN (42+(p_max)*7+29),g_x[12] CLIPPED,
#           COLUMN (42+(p_max)*7+39),g_x[13] CLIPPED
#     PRINT g_x[14] CLIPPED;
#           for g_i = 1 to p_max
#             print COLUMN 44+(g_i-1)*6,p_cmd2[(g_i-1)*6+1,(g_i-1)*6+6],'  ';
#           end for
#
#     PRINT COLUMN (42+(p_max)*7+11),g_x[16] CLIPPED,
#           COLUMN (42+(p_max)*7+20),g_x[17] CLIPPED,
#           COLUMN (42+(p_max)*7+39),g_x[18] CLIPPED
 
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
      AFTER GROUP OF sr.shb08   #線/班別編號
        SELECT ecg02 INTO l_ecg02 FROM ecg_file WHERE ecg01 = sr.shb08
        IF l_ecg02 IS NULL THEN LET l_ecg02 = '-' END IF
        PRINT COLUMN g_c[31],l_ecg02 CLIPPED,
              COLUMN g_c[32],GROUP SUM(sr.sum1) USING '------&.-&',
              COLUMN g_c[33],GROUP SUM(sr.sum3) USING '--------&.-&';
        let l_sql = " select sum(b03) from tp2_file",
                    " where b01 ='",sr.shb08,"' ",
                    " and b00 = ? " clipped
        let g_sql = l_sql
        prepare b000_pre from l_sql
        if sqlca.sqlcode then call cl_err('b000_pre',STATUS,1) end if
        declare b000_cur cursor for b000_pre
        if sqlca.sqlcode then call cl_err('b000_cur',STATUS,1) end if
       for g_cnt = 1 to p_max
           let l_b03 = ''
           open b000_cur using g_cnt
           fetch b000_cur into l_b03
#           print column (42+(g_cnt-1)*7),l_b03 using '####&.#&';
       end for
 
      #----------------- l_E ------------	
       SELECT SUM(b03) INTO l_E FROM tp2_file
       WHERE b01 = sr.shb08
       IF l_E IS NULL THEN LET l_E = 0 END IF
       LET l_A = GROUP SUM(sr.sum1)
       IF l_A IS NULL THEN LET l_A = 0 END IF
       LET l_B = GROUP SUM(sr.sum3)
       IF l_B IS NULL THEN LET l_B = 0 END IF
       LET l_I = GROUP SUM(sr.sum2)
       IF l_I IS NULL THEN LET l_I = 0 END IF
       LET l_F = (l_E/l_A)*100
      #-----------------No.MOD-7C0220 modify
      #LET l_G = (l_A/l_I)*100
      #LET l_H = (l_A/l_B)*100  #生產效率
       LET l_G = (l_I/l_A)*100
       LET l_H = (l_B/l_A)*100  #生產效率
      #-----------------No.MOD-7C0220 end
       PRINT COLUMN g_c[34],l_E USING '------&.-&',
             COLUMN g_c[35],l_F USING '------&.-&',
             COLUMN g_c[36],l_G USING '------&.-&',
             COLUMN g_c[37],l_H USING '------&.-&'
 
   ON LAST ROW
       PRINT ' '
       LET sum_A = SUM(sr.sum1)
       LET sum_I = SUM(sr.sum2)
       LET sum_B = SUM(sr.sum3)
       IF sum_A IS NULL THEN LET sum_A = 0 END IF
       IF sum_I IS NULL THEN LET sum_I = 0 END IF
       IF sum_B IS NULL THEN LET sum_B = 0 END IF
       PRINT COLUMN g_c[31],g_x[10] CLIPPED,
             COLUMN g_c[32],sum_A USING '------&.-&',
             COLUMN g_c[33],sum_B USING '--------&.-&';
       let l_sql = " select sum(b03) from tp2_file",
                   " where b00 = ? " clipped
           prepare b0001_pre from l_sql
       if sqlca.sqlcode then call cl_err('b0001_pre',STATUS,1) end if
       declare b0001_cur cursor for b0001_pre
       if sqlca.sqlcode then call cl_err('b0001_cur',STATUS,1) end if
       for g_cnt = 1 to p_max
         let l_b03 =''
         open b0001_cur using g_cnt
         fetch b0001_cur into l_b03
        if cl_null(l_b03) then let l_b03 = '@@@@' end if
        print column (42+(g_cnt-1)*7),l_b03 using '####&.#&';
      end for
 
      #
       #----------------- sum_E ------------
       select sum(b03) into sum_E from tp2_file
       IF sum_E IS NULL THEN LET sum_E = 0 END IF
       LET sum_F = (sum_E/sum_A)*100
      #---------------No.MOD-7C0220 modify
      #LET sum_G = (sum_A/sum_I)*100
      #LET sum_H = (sum_A/sum_B)*100
       LET sum_G = (sum_I/sum_A)*100
       LET sum_H = (sum_B/sum_A)*100
      #---------------No.MOD-7C0220 end
        PRINT COLUMN g_c[34],sum_E USING '------&.-&',
              COLUMN g_c[35],sum_F USING '------&.-&',
              COLUMN g_c[36],sum_G USING '------&.-&',
              COLUMN g_c[37],sum_H USING '------&.-&'
       PRINT g_dash[1,g_len] #No.TQC-5C0026
       PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #No.TQC-5C0026
       LET l_last_sw= 'Y' #No.TQC-5C0026
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
 
END REPORT
}
#NO.FUN-830054----END---MARK-----
 
FUNCTION r713_create_tp1()
  #No.FUN-680121-BEGIN
  CREATE TEMP TABLE tp1_file(
     a05   LIKE shb_file.shb05,  #CHI-B80086 add
     a01   LIKE aab_file.aab02,
#    a02   LIKE ima_file.ima26,
#    a03   LIKE ima_file.ima26,
#    a04   LIKE ima_file.ima26,  #MOD-A40149
     a02   LIKE type_file.num15_3,      
     a03   LIKE type_file.num15_3,
     a04   LIKE type_file.num15_3);  #NO.FUN-A20044
  #No.FUN-680121-END
END FUNCTION
 
	
FUNCTION r713_create_tp2()
 #No.FUN-680121-BEGIN
 CREATE TEMP TABLE tp2_file(
     b00   LIKE type_file.num5,  
     b01   LIKE aab_file.aab02,
     b02   LIKE oea_file.oea01,
     b03   LIKE sta_file.sta04);
  #No.FUN-680121-END
END FUNCTION
 
FUNCTION r713_create_tp3()
 #No.FUN-680121-BEGIN
  CREATE TEMP TABLE tp3_file(
     c01   LIKE aab_file.aab02,
     c02   LIKE sgb_file.sgb04,
     c03   LIKE sta_file.sta04);
  #No.FUN-680121-END
END FUNCTION
