# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: acor102.4gl
# Descriptions...:
# Date & Author..: 00/09/05 By Apple
# Modify.........: NO.MOD-490398 04/11/22 BY Elva add HS Code,coc10,Customs No.
# Modify.........: NO.MOD-490398 05/02/24 BY Elva add print cod04,con04
# Modify.........: No.MOD-490398 05/03/01 By Carrier
# Modify.........: No.TQC-610082 06/04/07 By Claire Review 所有報表程式接收的外部參數是否完整
# MOdify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Jackho 本（原）幣取位修改
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-770006 07/07/09 By zhoufeng 報表輸出改為Crystal Reports
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(300)   # Where condition
               y      LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)     # NO.MOD-490398
              more    LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)        # Input more condition(Y/N)
              END RECORD,
          l_orderA ARRAY[2] OF LIKE qcs_file.qcs03,       #No.FUN-680069 VARCHAR(10)
          l_tot_credit    LIKE cod_file.cod05
DEFINE    g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE    g_sql           STRING                  #No.FUN-770006
DEFINE    g_str           STRING                  #No.FUN-770006
DEFINE    l_table         STRING                  #No.FUN-770006
DEFINE    l_table1        STRING                  #No.FUN-770006
 
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
   LET g_sql="coc01.coc_file.coc01,",
             "coc02.coc_file.coc02,cod03.cod_file.cod03,cob09.cob_file.cob09,",
             "cod041.cod_file.cod041,cod06.cod_file.cod06,",
             "cob02.cob_file.cob02,coc10.coc_file.coc10,cna02.cna_file.cna02,",
             "coc03.coc_file.coc03,cob021.cob_file.cob021,",
             "cod11.cod_file.cod11,geb02.geb_file.geb02,cod05.cod_file.cod05,",
             "cod10.cod_file.cod10,cod07.cod_file.cod07,cod08.cod_file.cod08,",
             "azi03.azi_file.azi03,azi04.azi_file.azi04"
 
   LET l_table = cl_prt_temptable('acor102',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql ="coc01.coc_file.coc01,",
              "con03.con_file.con03,cob02_1.cob_file.cob02,",  
              "cob021_1.cob_file.cob021,con04.con_file.con04,",
              "con05.con_file.con05,con06.con_file.con06"
 
   LET l_table1 = cl_prt_temptable('acor1021',g_sql) CLIPPED                      
   IF l_table1 = -1 THEN EXIT PROGRAM END IF    
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
#----------------No.TQC-610082 modify
   LET tm.y    = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#----------------No.TQC-610082 end
 
   IF cl_null(g_bgjob) or g_bgjob = 'N'
      THEN CALL acor102_tm(0,0)
      ELSE CALL acor102()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION acor102_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680069 SMALLINT
       l_cmd          LIKE type_file.chr1000        #No.FUN-680069 VARCHAR(400)
 
   LET p_row = 5 LET p_col = 20
 
   OPEN WINDOW acor102_w AT p_row,p_col WITH FORM "aco/42f/acor102"
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
    CONSTRUCT BY NAME tm.wc ON coc01,coc04,coc10,coc03  #NO.MOD-490398
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
      LET INT_FLAG = 0 CLOSE WINDOW acor102_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
    INPUT BY NAME tm.y,tm.more    #NO.MOD-490398
      WITHOUT DEFAULTS
 
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
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()     # Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW acor102_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='acor102'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('acor102','9031',1)
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
                         " '",tm.y CLIPPED,"'",             #No.TQC-610082 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
         CALL cl_cmdat('acor102',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW acor102_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL acor102()
   ERROR ""
END WHILE
   CLOSE WINDOW acor102_w
END FUNCTION
 
FUNCTION acor102()
   DEFINE l_name    LIKE type_file.chr20,        #No.FUN-680069 VARCHAR(20)   # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0063
          l_sql     LIKE type_file.chr1000,     #No.FUN-680069 VARCHAR(600)
          l_za05    LIKE za_file.za05,  # NO.MOD-490398
          l_order    ARRAY[5] OF LIKE qcs_file.qcs03,       #No.FUN-680069 VARCHAR(10)
          sr            RECORD
                        coc01  LIKE coc_file.coc01,   #申請編號
                        coc02  LIKE coc_file.coc02,   #幣別
                        coc03  LIKE coc_file.coc03,   #手冊編號
                        coc10  LIKE coc_file.coc10,   #海關代號
                        cod02  LIKE cod_file.cod02,   #項次
                        cod03  LIKE cod_file.cod03,   #料號
                        cod041 LIKE cod_file.cod041,
                        cod05  LIKE cod_file.cod05,   #數量
                        cod06  LIKE cod_file.cod06,   #單位
                        cod07  LIKE cod_file.cod07,   #單價
                        cod08  LIKE cod_file.cod08,   #金額
                        cod10  LIKE cod_file.cod10,   #加簽數量#NO.MOD-490398
                        cod11  LIKE cod_file.cod11,   #消費國
                        cob02  LIKE cob_file.cob02    #品名
                        END RECORD
 
#No.FUN-770006 --start--
   DEFINE l_cob02   LIKE cob_file.cob02,
          l_cob021  LIKE cob_file.cob021,
          l_cna02   LIKE cna_file.cna02,
          l_geb02   LIKE geb_file.geb02,
          l_con03   LIKE con_file.con03,
          t_con02   LIKE con_file.con02,
          t_con03   LIKE con_file.con03,
          t_cob02   LIKE cob_file.cob02,
          t_cob021  LIKE cob_file.cob021,
          t_con04   LIKE con_file.con04,
          t_con05   LIKE con_file.con05,
          t_con06   LIKE con_file.con06,
          l_cod03   LIKE cod_file.cod03
#No.FUN-770006 --end--
 
#No.FUN-770006 --start--
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                        
                 " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"                 
     PREPARE insert_prep FROM g_sql                                               
     IF STATUS THEN                                                               
        CALL cl_err('insert_prep',status,1)                                       
     END IF
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                        
                 " VALUES(?,?,?,?,?,?,?)"                 
     PREPARE insert_prep1 FROM g_sql                                               
     IF STATUS THEN                                                               
        CALL cl_err('insert_prep1',status,1)                                       
     END IF
#No.FUN-770006 --end--
     CALL cl_del_data(l_table)                         #No.FUN-770006
     CALL cl_del_data(l_table1)                        #No.FUN-770006
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
      LET l_sql = "SELECT con02,con03,con04,cob02,cob021,con05,con06 ", #No.MOD-490398
                 " FROM con_file,OUTER cob_file ",
                 " WHERE con01 = ? ",
                 "   AND con013 = ? ",
                  "   AND con08= ? ", #NO.MOD-490398
                 "   AND con_file.con03 = cob_file.cob01 ",
                 "  ORDER BY con02 "
     PREPARE r102_precon  FROM l_sql
     IF STATUS THEN CALL cl_err('precon:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE r102_cur_con CURSOR FOR r102_precon
 
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
 
 ##NO.MOD-490398--begin
     LET l_sql = "SELECT coc01, coc02, coc03, coc10,",
 
                 " cod02,cod03,cod041,cod05,cod06,cod07,cod08,cod10,cod11,cob02 ",
 
                 " FROM coc_file,cod_file,OUTER cob_file ",
                 " WHERE ",tm.wc CLIPPED,
                 " AND coc01=cod01 ",
                 " AND cocacti='Y' ",
                 " AND cod_file.cod03 = cob_file.cob01 ",
                 " ORDER BY coc03,cod03,cod041" #No.FUN-770006 add
 ##NO.MOD-490398--end
 
     PREPARE acor102_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE acor102_curs1 CURSOR FOR acor102_prepare1
 
#    CALL cl_outnam('acor102') RETURNING l_name        #No.FUN-770006
#    START REPORT acor102_rep TO l_name                #No.FUN-770006
#    LET g_pageno = 0                                  #No.FUN-770006
     FOREACH acor102_curs1 INTO sr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
       END IF
#       OUTPUT TO REPORT acor102_rep(sr.*,'')   #NO.MOD-490398#No.FUN-770006
#No.FUN-770006 --start--
       SELECT cna02 INTO l_cna02 FROM cna_file WHERE cna01=sr.coc10
       IF SQLCA.sqlcode THEN LET l_cna02 = ' ' END IF
       SELECT geb02 INTO l_geb02 FROM geb_file WHERE geb01 = sr.cod11
       IF SQLCA.sqlcode THEN LET l_geb02 = ' ' END IF
       SELECT cob021 INTO l_cob021 FROM cob_file WHERE cob01=sr.cod03
       SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05 FROM azi_file
              WHERE azi01=sr.coc02
 
       IF tm.y = 'N' THEN
          LET l_cod03 = sr.cod03
       ELSE 
          SELECT cob09 INTO l_cod03 FROM cob_file WHERE cob01=sr.cod03
       END IF
       EXECUTE insert_prep USING sr.coc01,sr.coc02,sr.cod03,l_cod03,sr.cod041,
                                 sr.cod06,l_cob02,sr.coc10,l_cna02,sr.coc03,
                                 l_cob021,sr.cod11,l_geb02,sr.cod05,
                                 sr.cod10,sr.cod07,sr.cod08,t_azi03,t_azi04
 
       FOREACH r102_cur_con USING sr.cod03,sr.cod041,sr.coc10
               INTO t_con02,t_con03,t_con04,t_cob02,t_cob021,t_con05,t_con06
          IF SQLCA.sqlcode THEN
             CALL cl_err('r102_cur_con',SQLCA.sqlcode,0)
             EXIT FOREACH
          END IF
          IF tm.y = 'N' THEN
             LET l_con03 = t_con03
          ELSE
             SELECT cob09 INTO l_con03 FROM cob_file WHERE cob01=t_con03
          END IF
          EXECUTE insert_prep1 USING sr.coc01,l_con03,t_cob02,t_cob021,t_con04,
                                     t_con05,t_con06
       END FOREACH 
#No.FUN-770006 --end--
     END FOREACH
 
#    FINISH REPORT acor102_rep                             #No.FUN-770006
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)           #No.FUN-770006
#No.FUN-770006 --start--
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'coc01,coc04,coc10,coc03')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str
     LET l_sql = "SELECT A.*,B.con03,B.cob02_1,B.cob021_1,B.con04,",
            "       B.con05,B.con06 ",
            " FROM ", g_cr_db_str CLIPPED ,l_table CLIPPED," A  ",
	    " LEFT OUTER JOIN ",g_cr_db_str CLIPPED,l_table1 CLIPPED," B ",
	    " ON A.coc01 = B.coc01 "
     CALL cl_prt_cs3('acor102','acor102',l_sql,g_str)
#No.FUN-770006 --end--
END FUNCTION
#No.FUN-770006 --start-- mark
{REPORT acor102_rep(sr)
   DEFINE l_last_sw  LIKE type_file.chr1,         #No.FUN-680069  VARCHAR(1)
          l_con02    LIKE con_file.con02,
          l_con03    LIKE con_file.con03,
          l_cob02    LIKE cob_file.cob02,
          l_con04    LIKE con_file.con04,         #NO.MOD-490398
          l_con05    LIKE con_file.con05,
          l_con06    LIKE con_file.con06,
          l_geb02    LIKE geb_file.geb02,
          l_cna02    LIKE cna_file.cna02,
          l_cob021   LIKE cob_file.cob021,
          t_cob021   LIKE cob_file.cob021,
          l_str      LIKE cob_file.cob01,         #No.FUN-680069 VARCHAR(40)    #NO.MOD-490398
          sr            RECORD
                        coc01  LIKE coc_file.coc01,   #申請編號
                        coc02  LIKE coc_file.coc02,   #幣別
                        coc03  LIKE coc_file.coc03,   #手冊編號
                        coc10  LIKE coc_file.coc10,   #海關代號
                        cod02  LIKE cod_file.cod02,   #項次
                        cod03  LIKE cod_file.cod03,   #料號
                        cod041 LIKE cod_file.cod041,
                        cod05  LIKE cod_file.cod05,   #數量
                        cod06  LIKE cod_file.cod06,   #單位
                        cod07  LIKE cod_file.cod07,   #單價
                        cod08  LIKE cod_file.cod08,   #金額
                        cod10  LIKE cod_file.cod10,   #加簽數量#NO.MOD-490398
                        cod11  LIKE cod_file.cod11,   #消費國
                        cob02  LIKE cob_file.cob02,   #品名
                        cob09  LIKE cob_file.cob09    #NO.MOD-490398
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
   ORDER BY sr.coc03,sr.cod03,sr.cod041 #No.MOD-490398
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      PRINT COLUMN (((g_len-FGL_WIDTH(g_x[1])))/2)+1 ,g_x[1]
      PRINT g_x[24] CLIPPED,sr.coc02 CLIPPED
      PRINT g_dash[1,g_len]
 
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[9]))/2)+1,g_x[9] CLIPPED
      PRINT ''
 
 #NO.MOD-490398--begin
      SELECT cna02 INTO l_cna02 FROM cna_file WHERE cna01=sr.coc10
      IF SQLCA.sqlcode THEN LET l_cna02 = ' ' END IF
      SELECT geb02 INTO l_geb02 FROM geb_file WHERE geb01 = sr.cod11
      IF SQLCA.sqlcode THEN LET l_geb02 = ' ' END IF
      SELECT cob021 INTO l_cob021 FROM cob_file WHERE cob01=sr.cod03
#No.CHI-6A0004--begin 
#     SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05 FROM azi_file
#       WHERE azi01=sr.coc02
     SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05 FROM azi_file
       WHERE azi01=sr.coc02
#No.CHI-6A0004--end 
 
      PRINT COLUMN 01,g_x[10] CLIPPED;
      IF tm.y = 'N' THEN
         PRINT sr.cod03;
      ELSE
         SELECT cob09 INTO sr.cob09 FROM cob_file WHERE cob01=sr.cod03
         PRINT sr.cob09;
      END IF
      PRINT COLUMN 78,g_x[13] CLIPPED,sr.cod041,
            COLUMN 138,g_x[17] CLIPPED,sr.cod06
 
      PRINT COLUMN 01,g_x[11] CLIPPED,l_cob02 CLIPPED,
            COLUMN 78,g_x[14] CLIPPED,sr.coc10,' ',l_cna02 CLIPPED,
            COLUMN 138,g_x[16] CLIPPED,sr.coc03
 
      PRINT COLUMN 01,g_x[12] CLIPPED,l_cob021 CLIPPED,
            COLUMN 78,g_x[21] CLIPPED,sr.cod11,' ',l_geb02 CLIPPED
 
      PRINT COLUMN 01,g_x[18] CLIPPED,sr.cod05+sr.cod10 using '#######&.&&&',
            COLUMN 78,g_x[19] CLIPPED,cl_numfor(sr.cod07,12,t_azi03),            #No.CHI-6A0004
            COLUMN 138,g_x[20] CLIPPED,cl_numfor(sr.cod08,12,t_azi04)            #No.CHI-6A0004
 #NO.MOD-490398--end
 
      PRINT ''
      PRINT COLUMN r102_getStartPos(31,37,g_x[23]),g_x[23]
      PRINT COLUMN g_c[31],g_dash2[1,g_w[31]+g_w[32]+g_w[33]+g_w[34]+g_w[35]
                                   +g_w[36]+g_w[37]+6]
 #NO.MOD-490398--begin
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],
            g_x[35],g_x[36],g_x[37]
      PRINT g_dash1
 #NO.MOD-490398--end
      LET l_last_sw = 'n'
 
    BEFORE GROUP OF sr.cod041
      LET g_pageno = 0
      SKIP TO TOP OF PAGE
 
    ON EVERY ROW
 
        FOREACH r102_cur_con USING sr.cod03,sr.cod041,sr.coc10 #NO.MOD-490398
                       INTO l_con02,l_con03,l_con04,l_cob02,t_cob021,l_con05,l_con06
           IF SQLCA.sqlcode THEN
              CALL cl_err('r102_cur_con',SQLCA.sqlcode,0)
              EXIT FOREACH
           END IF
           IF tm.y = 'N' THEN
              PRINT COLUMN g_c[31],l_con03;
           ELSE
              SELECT cob09 INTO sr.cob09 FROM cob_file WHERE cob01=l_con03
              PRINT COLUMN g_c[31],sr.cob09;
           END IF
           PRINT COLUMN g_c[32],l_cob02,
                 COLUMN g_c[33],t_cob021,
                 COLUMN g_c[34],l_con04,
                 COLUMN g_c[35],l_con05 USING '###&.&&&&&',
                 COLUMN g_c[36],l_con06 USING '##&.&&&&&'
       END FOREACH
 
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
END REPORT
FUNCTION r102_getStartPos(l_sta,l_end,l_str)
DEFINE l_sta,l_end,l_length,l_pos,l_w_tot,l_i LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINE l_str     STRING       #No.FUN-680069
   LET l_str=l_str.trim()
   LET l_length=l_str.getLength()
   LET l_w_tot=0
   FOR l_i=l_sta to l_end
      LET l_w_tot=l_w_tot+g_w[l_i]
   END FOR
   LET l_pos=(l_w_tot/2)-(l_length/2)
   IF l_pos<0 THEN LET l_pos=0 END IF
   LET l_pos=l_pos+g_c[l_sta]+(l_end-l_sta)
   RETURN l_pos
END FUNCTION}
#No.FUN-770006 --end--
