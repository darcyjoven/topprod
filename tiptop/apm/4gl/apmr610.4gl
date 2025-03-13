# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmr610.4gl
# Desc/riptions...: 簽核人員未簽採購單列印
# Input parameter:
# Return code....:
# Date & Author..: 91/10/22 By MAY
# Modify.........: No.FUN-4C0095 05/01/06 By Mandy 報表轉XML
# Modify.........: No.TQC-5B0015 05/11/29 By Nicola 語法修改
# Modify.........: No.TQC-610085 06/04/06 By Claire Review所有報表程式接收的外部參數是否完整
# Modify.........: No.MOD-660133 06/06/30 By Ray 增加新欄位pmm40t(含稅總金額)
# Modify.........: No.FUN-680136 06/09/04 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.TQC-750041 07/05/15 By sherry 簽核人員欄位開窗，test欄位未維護中文
# Modify.........: No.FUN-750093 07/06/26 By jan 報表改為使用crystal report
# Modify.........: No.FUN-760086 07/07/20 By jan 打印條件修改
 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80088 11/08/10 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
                #wc      VARCHAR(500),              #TQC-630166 mark
                 wc      STRING,                 #TQC-630166
                 azc03   LIKE azc_file.azc03,
                 more    LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)
              END RECORD,
          g_aza17        LIKE aza_file.aza17     # 本國幣別
   DEFINE g_cnt          LIKE type_file.num10    #No.FUN-680136 INTEGER
   DEFINE g_i            LIKE type_file.num5     #count/index for any purpose #No.FUN-680136 SMALLINT
   DEFINE g_str      STRING     #No.FUN-750093
   DEFINE g_sql      STRING     #No.FUN_750093
   DEFINE l_table    STRING     #No.FUN-750093
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                       # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
 
   LET g_pdate = ARG_VAL(1)                   # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.azc03= ARG_VAL(8)
#------------No.TQC-610085 modify
  #LET tm.more= ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#------------No.TQC-610085 end
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r610_tm(0,0)
   ELSE
      CALL apmr610()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r610_tm(p_row,p_col)
   DEFINE lc_qbe_sn        LIKE gbm_file.gbm01        #No.FUN-580031
   DEFINE p_row,p_col      LIKE type_file.num5,       #No.FUN-680136 SMALLINT
          l_cmd            LIKE type_file.chr1000     #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW r610_w AT p_row,p_col WITH FORM "apm/42f/apmr610"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      DISPLAY BY NAME tm.more  # Condition
 
      CONSTRUCT BY NAME tm.wc ON pmm01,pmm07,pmmsign
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
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
         CLOSE WINDOW r610_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
         EXIT PROGRAM
      END IF
 
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF
 
      DISPLAY BY NAME tm.more  # Condition
 
      INPUT BY NAME tm.azc03,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD azc03
            IF cl_null(tm.azc03) THEN
               CALL cl_err('','mfg2726',0)
               NEXT FIELD azc03
            ELSE
               SELECT COUNT(*) INTO g_cnt FROM azb_file
                WHERE azb01=tm.azc03
               IF g_cnt = 0 THEN
                 CALL cl_err('','mfg0017',0)
                 NEXT FIELD azc03
               END IF
            END IF
 
         AFTER FIELD more
            IF cl_null(tm.more) OR tm.more NOT MATCHES '[YN]' THEN
               NEXT FIELD more
            END IF
 
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
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(azc03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_azb1'     #No.TQC-750041
                  LET g_qryparam.default1 = tm.azc03
                  CALL cl_create_qry() RETURNING tm.azc03
                  DISPLAY BY NAME tm.azc03
                  NEXT FIELD azc03
            END CASE
 
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
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file      #get exec cmd (fglgo xxxx)
          WHERE zz01='apmr610'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('apmr610','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,            #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.azc03 CLIPPED,"'",
                        #" '",tm.more CLIPPED,"'"  ,         #No.TQC-610085 mark
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('apmr610',g_time,l_cmd)      # Execute cmd at later time
         END IF
 
         CLOSE WINDOW r610_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
 
      CALL apmr610()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r610_w
 
END FUNCTION
 
FUNCTION apmr610()
   DEFINE l_name      LIKE type_file.chr20,              #No.FUN-680136 VARCHAR(20)
          l_time      LIKE type_file.chr8,               #No.FUN-680136 VARCHAR(8)
         #l_sql       LIKE type_file.chr1000,            #TQC-630166 mark #No.FUN-680136 VARCHAR(1000)
          l_sql       STRING,                            #TQC-630166
          l_za05      LIKE type_file.chr1000,            #No.FUN-680136 VARCHAR(40)
          l_gen02     LIKE gen_file.gen02,               #No.FUN-750093
          sr          RECORD
                         pmm01   LIKE pmm_file.pmm01,    # 單號
                         pmm02   LIKE pmm_file.pmm02,    # 採購單性質
                         pmm04   LIKE pmm_file.pmm04,    # 採購日期
                         pmm09   LIKE pmm_file.pmm09,    # 供應廠商 #FUN-4C0095
                         pmc03   LIKE pmc_file.pmc03,    # 供應廠商
                         pmmsseq LIKE pmm_file.pmmsseq,  # 已簽核順序
                         pmmsmax LIKE pmm_file.pmmsmax,  # 應簽核順序
                         pmm22   LIKE pmm_file.pmm22,    # 幣別
                         pmm40   LIKE pmm_file.pmm40,    # 總金額
                         pmm40t  LIKE pmm_file.pmm40t,   # 含稅總金額   #MOD-660133
                         pmmprit LIKE pmm_file.pmmprit,  #優先等級
                         days    LIKE type_file.num5,    #No.FUN-680136 SMALLINT
                         pmmdays LIKE pmm_file.pmmdays   #No.TQC-5B0015
                      END RECORD
#No.FUN-750093--Begin
   LET g_sql = " pmm01.pmm_file.pmm01,",
               " pmm02.pmm_file.pmm02,",
               " pmm04.pmm_file.pmm04,",
               " pmm09.pmm_file.pmm09,",
               " pmc03.pmc_file.pmc03,",
               " pmmsseq.pmm_file.pmmsseq,",
               " pmmsmax.pmm_file.pmmsmax,",
               " pmm22.pmm_file.pmm22,",
               " pmm40.pmm_file.pmm40,",
               " pmm40t.pmm_file.pmm40t,",
               " pmmprit.pmm_file.pmmprit,",
               " days.type_file.num5,",
               " l_gen02.gen_file.gen02,",
               " azi04.azi_file.azi04"
 
   LET l_table = cl_prt_temptable('apmr610',g_sql) CLIPPED
   IF l_table = -1 THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
      EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
      EXIT PROGRAM
   END IF
   CALL cl_del_data(l_table)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#No.FUN-750093--End
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   SELECT azi03,azi04,azi05
     INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
     FROM azi_file
    WHERE azi01=g_aza.aza17
 
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
 
 
   LET l_sql = "SELECT pmm01,pmm02,pmm04,pmm09,pmc03,pmmsseq,pmmsmax,",
             # " pmm22,pmm40,pmmprit,(pmm04+pmmdays)-to_date(?)",
               " pmm22,pmm40,pmm40t,pmmprit,0,pmmdays ",   #No.TQC-5B0015       #MOD-660133
               " FROM pmm_file,pmc_file ",
               " WHERE pmmsign IS NOT NULL AND pmmsign !=' ' AND ",
               " pmmmksg='Y' AND",
               " pmm25='0' AND pmmacti='Y'",
               " AND pmm09 = pmc_file.pmc01 ",
               " AND ",tm.wc CLIPPED,
               #-[這一句話很重要]-----------------------------------------------
               #去選擇單據時, 加這一句條件, 可以得到該使用者該簽核而未簽核的單據
               " AND pmmsseq=(SELECT (azc02 - 1)",
               " FROM azc_file WHERE azc01=pmmsign AND azc03='",tm.azc03,"')"
 
   LET l_sql = l_sql CLIPPED ," ORDER BY pmm01"
 
   PREPARE r610_prepare1 FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      RETURN
   END IF
 
   DECLARE r610_cs1 CURSOR FOR r610_prepare1
 
#  CALL cl_outnam('apmr610') RETURNING l_name      #No.FUN-750093
#  START REPORT r610_rep TO l_name                 #No.FUN-750093
 
  #FOREACH r610_cs1 USING g_today INTO sr.*
   FOREACH r610_cs1 INTO sr.*  #No.TQC-5B0015
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
#No.FUN-750093--Begin
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = tm.azc03
 
      SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05                  
           FROM azi_file WHERE azi01=sr.pmm22
#No.FUN-750093--End
      LET sr.days = (sr.pmm04 + sr.pmmdays) - g_today  #No.TQC-5B0015
 
      IF sr.pmm01 IS NULL THEN
         LET sr.pmm01 = ' '
      END IF
 
#No.FUN-750093--Begin
#     OUTPUT TO REPORT r610_rep(sr.*)
      EXECUTE insert_prep USING
              sr.pmm01,sr.pmm02,sr.pmm04,sr.pmm09,sr.pmc03,sr.pmmsseq,sr.pmmsmax,
              sr.pmm22,sr.pmm40,sr.pmm40t,sr.pmmprit,sr.days,l_gen02,g_azi04
   END FOREACH
 
#  FINISH REPORT r610_rep
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ''
#No.FUN-760086--Begin 
   IF g_zz05 = 'Y' THEN                                                       
        CALL cl_wcchp(tm.wc,'pmm01,pmm07,pmmsign')                    
              RETURNING g_str
   END IF
   LET g_str = g_str,";",g_azi04,";",tm.azc03
#No.FUN_760086--End
   CALL cl_prt_cs3('apmr610','apmr610',l_sql,g_str)
 
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-750093--End
END FUNCTION
 
#No.FUN-750093--Begin
{
REPORT r610_rep(sr)
   DEFINE l_last_sw   LIKE type_file.chr1,               #No.FUN-680136 VARCHAR(1)
          l_pmc03     LIKE pmc_file.pmc03,
          l_gen02     LIKE gen_file.gen02,
          sr          RECORD
                         pmm01   LIKE pmm_file.pmm01,    # 單號
                         pmm02   LIKE pmm_file.pmm02,    # 採購單性質
                         pmm04   LIKE pmm_file.pmm04,    # 採購日期
                         pmm09   LIKE pmm_file.pmm09,    # 供應廠商     #FUN-4C0095
                         pmc03   LIKE pmc_file.pmc03,    # 供應廠商
                         pmmsseq LIKE pmm_file.pmmsseq,  # 已簽核順序
                         pmmsmax LIKE pmm_file.pmmsmax,  # 應簽核順序
                         pmm22   LIKE pmm_file.pmm22,    # 幣別
                         pmm40   LIKE pmm_file.pmm40,    # 總金額
                         pmm40t  LIKE pmm_file.pmm40t,   # 含稅總金額   #MOD-660133
                         pmmprit LIKE pmm_file.pmmprit,  #優先等級
                         days    LIKE type_file.num5,    #No.FUN-680136 SMALLINT
                         pmmdays LIKE pmm_file.pmmdays   #No.TQC-5B0015
                      END RECORD
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.pmm01
 
   FORMAT
      PAGE HEADER
         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = tm.azc03
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         PRINT
         PRINT g_dash
         PRINT ' ',g_x[11] CLIPPED,tm.azc03 CLIPPED,'     ',g_x[12] CLIPPED,l_gen02
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[42],g_x[40],     #MOD-660133
               g_x[41]
         PRINT g_dash1
         LET l_last_sw = 'n'
 
      ON EVERY ROW
         SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
           FROM azi_file WHERE azi01=sr.pmm22
         PRINT COLUMN g_c[31],sr.pmm01 CLIPPED,
               COLUMN g_c[32],sr.pmm02 CLIPPED,
               COLUMN g_c[33],sr.pmm04 CLIPPED,
               COLUMN g_c[34],sr.pmm09 CLIPPED,
               COLUMN g_c[35],sr.pmc03 CLIPPED,
               COLUMN g_c[36],sr.pmmsseq USING '&',
               COLUMN g_c[37],sr.pmmsmax USING '#',
               COLUMN g_c[38],sr.pmm22 CLIPPED,
               COLUMN g_c[39],cl_numfor(sr.pmm40,39,g_azi04),
               COLUMN g_c[42],cl_numfor(sr.pmm40t,42,g_azi04),       #MOD-660133
               COLUMN g_c[40],sr.pmmprit,
               COLUMN g_c[41],sr.days
         LET sr.pmm40 = 0
         LET l_last_sw = 'n'
 
      ON LAST ROW
         IF g_zz05 = 'Y' THEN
            PRINT g_dash
           #TQC-630166
           #IF tm.wc[001,070] > ' ' THEN                  # for 80
           #  PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
           #IF tm.wc[071,140] > ' ' THEN
           #   PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
           #IF tm.wc[141,210] > ' ' THEN
           #   PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
           #IF tm.wc[211,280] > ' ' THEN
           #   PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
           CALL cl_prt_pos_wc(tm.wc)
           #END TQC-630166
#           IF tm.wc[001,120] > ' ' THEN                  # for 132
#           PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#           IF tm.wc[121,240] > ' ' THEN
#           PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#           IF tm.wc[241,300] > ' ' THEN
#           PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
         END IF
         PRINT g_dash[1,g_len]
         LET l_last_sw = 'y'
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE
            SKIP 2 LINES
         END IF
 
END REPORT}
#No.FUN-750093--End
#Patch....NO.TQC-610036 <001> #
