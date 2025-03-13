# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: acor100.4gl
# Descriptions...: 進口料件申請備案清單列印
# Date & Author..: 00/07/25 By Carol
# Modify.........: NO.MOD-490398 04/11/22 BY Elva add HS Code,coc10,Customs No.
# Modify.........: No.FUN-510042 05/01/20 By pengu 報表轉XML
# Modify.........: No.MOD-540035 05/04/05 By wujie  產地列印欄位放寬
# Modify.........: NO.FUN-590118 06/01/03 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610082 06/04/07 By Claire Review 所有報表程式接收的外部參數是否完整
# MOdify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Jackho 本（原）幣取位修改
 
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-770006 07/07/06 By zhoufeng 報表輸出改為Crystal Reports
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(300)     # Where condition
              y       LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)       # NO.MOD-490398
              more    LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)        # Input more condition(Y/N)
              END RECORD,
          l_orderA ARRAY[2] OF LIKE qcs_file.qcs03,       #No.FUN-680069 VARCHAR(10)
          l_tot_credit LIKE cod_file.cod05
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE   g_head1         STRING
DEFINE   g_sql           STRING                  #No.FUN-770006
DEFINE   g_str           STRING                  #No.FUN-770006
DEFINE   l_table         STRING                  #No.FUN-770006
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
#No.FUN-770006 --start--
   LET g_sql="coc10.coc_file.coc10,cna02.cna_file.cna02,coc03.coc_file.coc03,",
             "coe02.coe_file.coe02,coe03.coe_file.coe03,cob02.cob_file.cob02,",
             "cob021.cob_file.cob021,geb02.geb_file.geb02,",
             "coe05.coe_file.coe05,coe06.coe_file.coe06,coe07.coe_file.coe07,",
             "coe08.coe_file.coe08,cnc02.cnc_file.cnc02,coc01.coc_file.coc01,",
             "azi03.azi_file.azi03,azi04.azi_file.azi04"
   LET l_table = cl_prt_temptable('acor100',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#No.FUN-770006 --end--
 
   INITIALIZE tm.* TO NULL                # Default condition
   LET tm.y     = 'N'    #NO.MOD-490398
   LET tm.more  = 'N'
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
#------------No.TQC-610082 modify
   LET tm.y    = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#------------No.TQC-610082 end
  
 
   IF cl_null(g_bgjob) or g_bgjob = 'N'
      THEN CALL acor100_tm(0,0)
      ELSE CALL acor100()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION acor100_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01         #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,        #No.FUN-680069 SMALLINT
       l_cmd          LIKE type_file.chr1000      #No.FUN-680069 VARCHAR(400)
 
   LET p_row = 5 LET p_col = 20
 
   OPEN WINDOW acor100_w AT p_row,p_col WITH FORM "aco/42f/acor100"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.y   = 'N'    #NO.MOD-490398
   LET tm.more= 'N'
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'
 
 WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON coc01,coc04,coc10,coc03,cob01 #NO.MOD-490398
      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
      LET INT_FLAG = 0 CLOSE WINDOW acor100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
    INPUT BY NAME tm.y,tm.more  #NO.MOD-490398
      WITHOUT DEFAULTS
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()     # Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
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
      LET INT_FLAG = 0 CLOSE WINDOW acor100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='acor100'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('acor100','9031',1)
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
                         " '",tm.y CLIPPED,"'",              #No.TQC-610082 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
         CALL cl_cmdat('acor100',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW acor100_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL acor100()
   ERROR ""
END WHILE
   CLOSE WINDOW acor100_w
END FUNCTION
 
FUNCTION acor100()
   DEFINE l_name    LIKE type_file.chr20,        #No.FUN-680069 VARCHAR(20)    # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0063
          l_sql     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(600)
          l_za05    LIKE za_file.za05,  # NO.MOD-490398
          l_order   ARRAY[5] OF LIKE qcs_file.qcs03,       #No.FUN-680069 VARCHAR(10)
          sr            RECORD
                               coc01  LIKE coc_file.coc01,
                               coc02  LIKE coc_file.coc02,
                               coc10  LIKE coc_file.coc10,   #NO.MOD-490398
                               coc03  LIKE coc_file.coc03,
                               coe02  LIKE coe_file.coe02,
                               coe03  LIKE coe_file.coe03,
                               coe05  LIKE coe_file.coe05,
                               coe06  LIKE coe_file.coe06,
                               coe07  LIKE coe_file.coe07,
                               coe08  LIKE coe_file.coe08,
                               cob02  LIKE cob_file.cob02,
                               cob021 LIKE cob_file.cob021,
                               geb02  LIKE geb_file.geb02,
                               cnc02  LIKE cnc_file.cnc02
                        END RECORD
   DEFINE  l_cna02      LIKE cna_file.cna02                  #No.FUN-770006
 
     CALL cl_del_data(l_table)                               #No.FUN-770006
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND cocuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND cocgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND cocgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('cocuser', 'cocgrup')
     #End:FUN-980030
 
      LET l_sql = "SELECT coc01,coc02,coc10,coc03,coe02,coe03,coe05+coe10,coe06,", #NO.MOD-490398
                 "    coe07,coe08,cob02,cob021,geb02,cnc02  FROM coc_file,coe_file,",
                 "OUTER geb_file,OUTER cob_file,OUTER cnc_file ",
                 " WHERE ",tm.wc CLIPPED,
                  " AND coc01=coe01 AND coe_file.coe03=cob_file.cob01 ",
                 " AND cocacti = 'Y' ",
                  " AND coe_file.coe11=geb_file.geb01 AND coe_file.coe12=cnc_file.cnc01 " CLIPPED
 
     PREPARE acor100_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE acor100_curs1 CURSOR FOR acor100_prepare1
 
#    CALL cl_outnam('acor100') RETURNING l_name        #No.FUN-770006
#    START REPORT acor100_rep TO l_name                #No.FUN-770006
#    LET g_pageno = 0                                  #No.FUN-770006
     FOREACH acor100_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
#      OUTPUT TO REPORT acor100_rep(sr.*,'')   #NO.MOD-490398#No.FUN-770006
#No.FUN-770006 --start--
       SELECT cna02 INTO l_cna02 FROM cna_file                                   
              WHERE cna01=sr.coc10                                                      
       IF SQLCA.sqlcode THEN                                                     
          LET l_cna02 = ' '                                                      
       END IF          
       SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05 FROM azi_file      
              WHERE azi01=sr.coc02   
       IF tm.y='Y' THEN
          SELECT cob09 INTO sr.coe03 FROM cob_file
                 WHERE cob01=sr.coe03
       END IF
       EXECUTE insert_prep USING sr.coc10,l_cna02,sr.coc03,sr.coe02,sr.coe03,
                                 sr.cob02,sr.cob021,sr.geb02,sr.coe05,sr.coe06,
                                 sr.coe07,sr.coe08,sr.cnc02,sr.coc01,t_azi03,
                                 t_azi04
#No.FUN-770006 --end--
     END FOREACH
 
#    FINISH REPORT acor100_rep                    #No.FUN-770006
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #No.FUN-770006
#No.FUN-770006 --start--
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'coc01,coc04,coc10,coc03,cob01')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
     CALL cl_prt_cs3('acor100','acor100',l_sql,g_str)
#No.FUN-770006 --end--
END FUNCTION
#No.FUn-770006 --start-- mark
{REPORT acor100_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
          l_cna02      LIKE cna_file.cna02,
          sr           RECORD
                               coc01  LIKE coc_file.coc01,
                               coc02  LIKE coc_file.coc02,
                               coc10  LIKE coc_file.coc10,   #NO.MOD-490398
                               coc03  LIKE coc_file.coc03,
                               coe02  LIKE coe_file.coe02,
                               coe03  LIKE coe_file.coe03,
                               coe05  LIKE coe_file.coe05,
                               coe06  LIKE coe_file.coe06,
                               coe07  LIKE coe_file.coe07,
                               coe08  LIKE coe_file.coe08,
                               cob02  LIKE cob_file.cob02,
                               cob021 LIKE cob_file.cob021,
                               geb02  LIKE geb_file.geb02,
                               cnc02  LIKE cnc_file.cnc02,
                                cob09  LIKE cob_file.cob09    #NO.MOD-490398
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
  ORDER BY sr.coc03,sr.coc01,sr.coe02
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
 
 #NO.MOD-490398--begin
      SELECT cna02 INTO l_cna02 FROM cna_file
      WHERE cna01=sr.coc10
      IF SQLCA.sqlcode THEN
         LET l_cna02 = ' '
      END IF
      LET g_head1=g_x[10] CLIPPED,sr.coc10 CLIPPED,' ',l_cna02 CLIPPED,'     ',
                  g_x[9] CLIPPED,sr.coc03 CLIPPED
      PRINT g_head1
      PRINT g_dash[1,g_len]
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[40] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,g_x[39] CLIPPED
      PRINT g_dash1
      LET l_last_sw = 'n'
 
 #NO.MOD-490398--end
    BEFORE GROUP OF sr.coc03
       SKIP TO TOP OF PAGE
 
#No.CHI-6A0004--begin 
#       SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05 FROM azi_file
#        WHERE azi01=sr.coc02
       SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05 FROM azi_file
        WHERE azi01=sr.coc02
#No.CHI-6A0004--end 
 
    ON EVERY ROW
       PRINT COLUMN g_c[31],sr.coe02 USING '###&';
 #NO.MOD-490398--begin
       IF tm.y = 'N' THEN
          PRINT COLUMN g_c[32],sr.coe03;
       ELSE
          SELECT cob09 INTO sr.cob09 FROM cob_file WHERE cob01=sr.coe03
          PRINT COLUMN g_c[32],sr.cob09;
       END IF
       PRINT COLUMN g_c[33],sr.cob02 CLIPPED,
             COLUMN g_c[40],sr.cob021,
 #NO.MOD-540035--begin
#            COLUMN g_c[34],sr.geb02[1,10] CLIPPED,
             COLUMN g_c[34],sr.geb02 CLIPPED,
 #NO.MOD-540035-end
             COLUMN g_c[35],sr.coe05 USING '##########&.&&&',
             COLUMN g_c[36],sr.coe06,
             COLUMN g_c[37],cl_numfor(sr.coe07,37,t_azi03),                 #No.CHI-6A0004
             COLUMN g_c[38],cl_numfor(sr.coe08,38,t_azi04),                 #No.CHI-6A0004
             COLUMN g_c[39],sr.cnc02
 #NO.MOD-490398--end
 
   ON LAST ROW
       PRINT g_dash[1,g_len] CLIPPED
       LET l_last_sw = 'y'
       PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len] CLIPPED
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT}
#No.FUN-770006 --end--
