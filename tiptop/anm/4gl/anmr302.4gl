# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: anmr302.4gl
# Descriptions...: 銀行存款收支憑証列印
# Date & Author..: 97/09/08 By Lynn
# Modify.........: No.MOD-530676 05/03/29 By Smapmin 經由anmt302來CALL
# Modify.........: No.FUN-550114 05/05/26 By echo 新增報表備註
# Modify.........: No.FUN-570177 05/07/19 By Trisy 項次位數加大
# Modify.........: No.FUN-580010 05/08/02 By will 報表轉XML格式
# Modify.........: No.MOD-590487 05/10/03 By Dido 報表調整
# Modify.........: No.FUN-5A0180 05/10/25 By Claire 報表調整可印FONT 10
# Modify.........: NO.FUN-590118 06/01/19 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-6A0094 06/11/10 By johnray 報表修改
# Modify.........: No.FUN-710085 07/02/01 By Rayven 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.TQC-C10034 12/01/19 By yuhuabao GP 5.3 CR報表列印TIPTOP與EasyFlow簽核圖片
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(600) # Where condition
              n       LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)   # 列印單價
              more    LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)   # Input more condition(Y/N)
              END RECORD
 
DEFINE   g_i          LIKE type_file.num5    #count/index for any purpose  #No.FUN-680107 SMALLINT
#No.FUN-580010  -begin
#DEFINE   g_dash      VARCHAR(400)  #Dash line
#DEFINE   g_len       SMALLINT   #Report width(79/132/136)
#DEFINE   g_pageno    SMALLINT   #Report page no
#DEFINE   g_zz05      VARCHAR(1)    #Print tm.wc ?(Y/N)
#No.FUN-580010  -end
DEFINE    l_table     STRING     #No.FUN-710085
DEFINE    g_sql       STRING     #No.FUN-710085
DEFINE    g_str       STRING     #No.FUN-710085
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
   #No.FUN-710085 --start--
   LET g_sql = "nmg00.nmg_file.nmg00,nmg20.nmg_file.nmg20,nmg18.nmg_file.nmg18,",
               "nmg19.nmg_file.nmg19,nmg01.nmg_file.nmg01,nmg21.nmg_file.nmg21,",
               "nmg13.nmg_file.nmg13,nmg11.nmg_file.nmg11,gem02.gem_file.gem02,",
               "nmg23.nmg_file.nmg23,nmg14.nmg_file.nmg14,nmg17.nmg_file.nmg17,",
               "nml02.nml_file.nml02,nmg25.nmg_file.nmg25,nmg06.nmg_file.nmg06,",
               "nmg24.nmg_file.nmg24,nmg05.nmg_file.nmg05,npk01.npk_file.npk01,",
               "npk03.npk_file.npk03,npk02.npk_file.npk02,nmc02.nmc_file.nmc02,",
               "npk04.npk_file.npk04,npk05.npk_file.npk05,npk08.npk_file.npk08,",
               "npk07.npk_file.npk07,npk10.npk_file.npk10,npk06.npk_file.npk06,",
               "npk09.npk_file.npk09,azi04.azi_file.azi04,azi07.azi_file.azi07,",
               "azi04_1.azi_file.azi04,",  #No.TQC-C10034 add , ,
               "sign_type.type_file.chr1,",   #簽核方式                   #No.TQC-C10034 add
               "sign_img.type_file.blob,",    #簽核圖檔                   #No.TQC-C10034 add
               "sign_show.type_file.chr1,",   #是否顯示簽核資料(Y/N)      #No.TQC-C10034 add
               "sign_str.type_file.chr1000"   #簽核字串                   #No.TQC-C10034 add
 
   LET l_table = cl_prt_temptable('anmr302',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ? ,?,?,?,?)"  #No.TQC-C10034 add 4?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-710085 --end--
                        
 
 
   #-----TQC-610058---------
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc  = ARG_VAL(7)
   LET tm.n = ARG_VAL(8)
   #-----END TQC-610058-----
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(tm.wc) THEN
      CALL anmr302_tm(0,0)             # Input print condition
   ELSE
      CALL anmr302()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr302_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,  #No.FUN-680107 SMALLINT
       l_cmd          LIKE type_file.chr1000#No.FUN-680107 VARCHAR(400)
 
   LET p_row = 5 LET p_col = 15
   OPEN WINDOW anmr302_w AT p_row,p_col
        WITH FORM "anm/42f/anmr302"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.n ='3'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nmg00,nmg01,nmg11,npk05    
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr302_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.n,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD n
         IF cl_null(tm.n) OR tm.n NOT MATCHES '[123]' THEN
            NEXT FIELD n
         END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
    AFTER INPUT
        IF INT_FLAG THEN EXIT INPUT END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr302_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='anmr302'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr302','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.n CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('anmr302',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW anmr302_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr302()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr302_w
END FUNCTION
 
FUNCTION anmr302()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0082
          l_sql     LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(3000)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(40)
          sr        RECORD
                    nmg00     LIKE nmg_file.nmg00,
                    nmg01     LIKE nmg_file.nmg01,
                    nmg11     LIKE nmg_file.nmg11,
                    gem02     LIKE gem_file.gem02,
                    nmg17     LIKE nmg_file.nmg17,
                    nml02     LIKE nml_file.nml02,
                    nmg20     LIKE nmg_file.nmg20,
                    nmg18     LIKE nmg_file.nmg18,
                    nmg19     LIKE nmg_file.nmg19,
                    nmg21     LIKE nmg_file.nmg21,
                    nmg23     LIKE nmg_file.nmg23,
                    nmg25     LIKE nmg_file.nmg25,
                    nmg24     LIKE nmg_file.nmg24,
                    nmg13     LIKE nmg_file.nmg13,
                    nmg14     LIKE nmg_file.nmg14,
                    nmg06     LIKE nmg_file.nmg06,
                    nmg05     LIKE nmg_file.nmg05,
                    npk01     LIKE npk_file.npk01,
                    npk03     LIKE npk_file.npk03,
                    npk02     LIKE npk_file.npk02,
                    nmc02     LIKE nmc_file.nmc02,
                    npk04     LIKE npk_file.npk04,
                    npk05     LIKE npk_file.npk05,
                    npk06     LIKE npk_file.npk06,
                    npk07     LIKE npk_file.npk07,
                    npk08     LIKE npk_file.npk08,
                    npk09     LIKE npk_file.npk09,
                    npk10     LIKE npk_file.npk10,
                    azi04     LIKE azi_file.azi04
                    END RECORD
   DEFINE l_img_blob     LIKE type_file.blob                                         #No.TQC-C10034 add
   LOCATE l_img_blob IN MEMORY   #blob初始化   #Genero Version 2.21.02之後要先初始化 #No.TQC-C10034 add
 
     CALL cl_del_data(l_table)  #No.FUN-710085
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-580010  --begin
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'anmr302'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 87 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#    FOR g_i = 1 TO g_len LET g_dash1[g_i,g_i] = '-' END FOR
#No.FUN-580010  --end
#NO.CHI-6A0004--BEGIN
#     SELECT azi03,azi04,azi05
#       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file
#      WHERE azi01=g_aza.aza17
#NO.CHI-6A0004--END
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND nmguser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND nmggrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND nmggrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmguser', 'nmggrup')
     #End:FUN-980030
 
     LET l_sql="SELECT nmg00,nmg01,nmg11,gem02,nmg17,nml02,",
               "       nmg20,nmg18,nmg19,nmg21,nmg23,nmg25,",
               "       nmg24,nmg13,nmg14,nmg06,nmg05,",
               "       npk01,npk03,npk02,nmc02,npk04,npk05,npk06,",
               "       npk07,npk08,npk09,npk10,azi04",
               "  FROM nmg_file,npk_file,OUTER gem_file,OUTER nml_file, ",
               "  OUTER nmc_file,OUTER azi_file",
               " WHERE nmg00=npk00 ",
               "   AND nmg_file.nmg11=gem_file.gem01 ",
               "   AND nmg_file.nmg17=nml_file.nml01 ",
               "   AND npk_file.npk02=nmc_file.nmc01 ",
               "   AND npk_file.npk05=azi_file.azi01 ",
               "   AND nmgconf <> 'X' ",
               "   AND ",tm.wc CLIPPED
     IF tm.n='1' THEN
        LET l_sql=l_sql CLIPPED," AND nmgconf='Y' "
     END IF
     IF tm.n='2' THEN
        LET l_sql=l_sql CLIPPED," AND nmgconf='N' "
     END IF
     PREPARE anmr302_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM 
     END IF
     DECLARE anmr302_curs1 CURSOR FOR anmr302_prepare1
 
#    CALL cl_outnam('anmr302') RETURNING l_name  #No.FUN-710085 mark
#    START REPORT anmr302_rep TO l_name          #No.FUN-710085 mark
 
     LET g_pageno = 0
     FOREACH anmr302_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
       #No.FUN-710085 --start--
       SELECT azi07 INTO t_azi07 FROM azi_file WHERE azi01=sr.npk05
 
       EXECUTE insert_prep USING sr.nmg00,sr.nmg20,sr.nmg18,sr.nmg19,
                                 sr.nmg01,sr.nmg21,sr.nmg13,sr.nmg11,
                                 sr.gem02,sr.nmg23,sr.nmg14,sr.nmg17,
                                 sr.nml02,sr.nmg25,sr.nmg06,sr.nmg24,
                                 sr.nmg05,sr.npk01,sr.npk03,sr.npk02,
                                 sr.nmc02,sr.npk04,sr.npk05,sr.npk08,
                                 sr.npk07,sr.npk10,sr.npk06,sr.npk09,
                                 sr.azi04,t_azi07,g_azi04
                                 ,"",  l_img_blob,   "N",""      #No.TQC-C10034 add
       #No.FUN-710085 --end--
 
#      OUTPUT TO REPORT anmr302_rep(sr.*)        #No.FUN-710085 mark
     END FOREACH
 
#    FINISH REPORT anmr302_rep                   #No.FUN-710085 mark
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len) #No.FUN-710085 mark
 
     #No.FUN-710085 --start--
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'nmg00,nmg01,nmg11,npk05')
          RETURNING tm.wc
     LET g_str = tm.wc,";",g_zz05
   # LET l_sql = "SELECT * FROM ",l_table CLIPPED   #TQC-730088
   # CALL cl_prt_cs3('anmr302',l_sql,g_str)
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_cr_table = l_table                 #主報表的temp table名稱        #No.TQC-C10034 add
     LET g_cr_apr_key_f = "nmg00"             #報表主鍵欄位名稱，用"|"隔開   #No.TQC-C10034 add
     CALL cl_prt_cs3('anmr302','anmr302',l_sql,g_str)
     #No.FUN-710085 --end--
 
END FUNCTION
 
#No.FUN-710085 --start-- mark
{REPORT anmr302_rep(sr)
   DEFINE l_last_sw LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
          sr        RECORD
                    nmg00     LIKE nmg_file.nmg00,
                    nmg01     LIKE nmg_file.nmg01,
                    nmg11     LIKE nmg_file.nmg11,
                    gem02     LIKE gem_file.gem02,
                    nmg17     LIKE nmg_file.nmg17,
                    nml02     LIKE nml_file.nml02,
                    nmg20     LIKE nmg_file.nmg20,
                    nmg18     LIKE nmg_file.nmg18,
                    nmg19     LIKE nmg_file.nmg19,
                    nmg21     LIKE nmg_file.nmg21,
                    nmg23     LIKE nmg_file.nmg23,
                    nmg25     LIKE nmg_file.nmg25,
                    nmg24     LIKE nmg_file.nmg24,
                    nmg13     LIKE nmg_file.nmg13,
                    nmg14     LIKE nmg_file.nmg14,
                    nmg06     LIKE nmg_file.nmg06,
                    nmg05     LIKE nmg_file.nmg05,
                    npk01     LIKE npk_file.npk01,
                    npk03     LIKE npk_file.npk03,
                    npk02     LIKE npk_file.npk02,
                    nmc02     LIKE nmc_file.nmc02,
                    npk04     LIKE npk_file.npk04,
                    npk05     LIKE npk_file.npk05,
                    npk06     LIKE npk_file.npk06,
                    npk07     LIKE npk_file.npk07,
                    npk08     LIKE npk_file.npk08,
                    npk09     LIKE npk_file.npk09,
                    npk10     LIKE npk_file.npk10,
                    azi04     LIKE azi_file.azi04
                    END RECORD,
         l_t1       LIKE type_file.chr3,    #No.FUN-680107 VARCHAR(3)
         l_nmydesc  LIKE nmy_file.nmydesc,
         l_flag     LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
 
  OUTPUT TOP MARGIN 0
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN 5
         PAGE LENGTH g_page_line
  ORDER BY sr.nmg00,sr.npk01
  FORMAT
   PAGE HEADER
#No.FUN-580010  -begin
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1, g_company CLIPPED
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<'
#MOD-590487
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT g_head CLIPPED,pageno_total
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#MOD-590487 End
      PRINT g_dash
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT ' '
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1];
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     PRINT ' '
#     LET g_pageno= g_pageno+1
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#           COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
      PRINT g_x[11] CLIPPED,sr.nmg00,
              COLUMN 31,g_x[12] CLIPPED,sr.nmg20,
              COLUMN 59,g_x[13] CLIPPED,
              COLUMN 69,sr.nmg18,' ',sr.nmg19
      PRINT g_x[14] CLIPPED,sr.nmg01,
              COLUMN 31,g_x[15] CLIPPED,sr.nmg21,
              column 59,g_x[16] CLIPPED,sr.nmg13
      PRINT g_x[17] CLIPPED,sr.nmg11,' ',sr.gem02  CLIPPED,
              COLUMN 31,g_x[18] CLIPPED,
              COLUMN 40,cl_numfor(sr.nmg23,18,sr.azi04),
              COLUMN 59,g_x[19] CLIPPED,
              COLUMN 68,sr.nmg14
      PRINT g_x[20] CLIPPED,sr.nmg17,' ',sr.nml02
      PRINT COLUMN 31,g_x[21] CLIPPED,COLUMN 40,cl_numfor(sr.nmg25,18,g_azi04),
              COLUMN 59,g_x[22] CLIPPED,COLUMN 68,cl_numfor(sr.nmg06,18,g_azi04)
      PRINT COLUMN 31,g_x[23] CLIPPED,COLUMN 40,cl_numfor(sr.nmg24,18,g_azi04),
              COLUMN 59,g_x[26] CLIPPED,COLUMN 68,cl_numfor(sr.nmg05,18,sr.azi04)
      PRINT g_dash
      #FUN-5A0180-begin
      #PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
      #      g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[37],g_x[39]
      PRINTX name=H2 g_x[40],g_x[36],g_x[38]
      #FUN-5A0180-end
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.nmg00
      SKIP TO TOP OF PAGE
        LET l_flag = 'N'
#No.FUN-580010  -begin
#        PRINT g_dash1[1,g_len]
#        PRINT COLUMN 01,g_x[24] CLIPPED,COLUMN 51,g_x[25] CLIPPED
#        PRINT '---  -  --------------  -----------   ----------   ------------------  ---------------'#No.FUN-570177
#No.FUN-580010  -end
 
   ON EVERY ROW
      SELECT azi07 INTO t_azi07 FROM azi_file WHERE azi01=sr.npk05
#No.FUN-580010  -begin
      #FUN-5A0180-begin
      #PRINT COLUMN g_c[31],sr.npk01 USING '##&',   #No.FUN-570177
      #      COLUMN g_c[32],sr.npk03,
      #      COLUMN g_c[33],sr.npk02,' ',sr.nmc02 CLIPPED,
      #      COLUMN g_c[34],sr.npk04 CLIPPED,
      #      COLUMN g_c[35],sr.npk05 CLIPPED,
      #      COLUMN g_c[36],cl_numfor(sr.npk06,36,t_azi07) CLIPPED,
      #      COLUMN g_c[37],cl_numfor(sr.npk08,37,sr.azi04) CLIPPED,
      #      COLUMN g_c[38],cl_numfor(sr.npk09,38,g_azi04),
      #      COLUMN g_c[39],sr.npk07,
      #      COLUMN g_c[40],sr.npk10 CLIPPED
      PRINTX name=D1
            COLUMN g_c[31],sr.npk01 USING '###&', #FUN-590118
            COLUMN g_c[32],sr.npk03,
            COLUMN g_c[33],sr.npk02,' ',sr.nmc02 CLIPPED,
            COLUMN g_c[34],sr.npk04 CLIPPED,
            COLUMN g_c[35],sr.npk05 CLIPPED,
            COLUMN g_c[37],cl_numfor(sr.npk08,37,sr.azi04) CLIPPED,
            COLUMN g_c[39],sr.npk07
      PRINTX name=D2
            COLUMN g_c[40],sr.npk10[1,36] CLIPPED,
            COLUMN g_c[36],cl_numfor(sr.npk06,36,t_azi07) CLIPPED,
            COLUMN g_c[38],cl_numfor(sr.npk09,38,g_azi04)
      #FUN-5A0180-end
#No.FUN-580010  -end
 
   AFTER GROUP OF sr.nmg00
      PRINT g_dash
      LET g_pageno=0
      LET l_flag='Y'
 
## FUN-550114
ON LAST ROW
     LET l_last_sw = 'y'
 
PAGE TRAILER
     #IF l_flag ='Y' THEN
     #   PRINT COLUMN 01,g_x[04] CLIPPED,COLUMN 41,g_x[05] CLIPPED
     #ELSE
     #   PRINT g_dash[1,g_len]
     #END IF
#No.TQC-6A0094 -- begin --
#     IF l_last_sw = 'n' THEN
#        IF g_memo_pagetrailer THEN
#            PRINT g_x[4]
#            PRINT g_memo
#        ELSE
#            PRINT
#            PRINT
#        END IF
#     ELSE
#            PRINT g_x[4]
#            PRINT
#            PRINT g_memo
#     END IF
     PRINT g_dash[1,g_len]
     IF l_last_sw = 'n' THEN                                                    
        PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
     ELSE
        PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
     END IF
     PRINT
     IF l_last_sw = 'n' THEN
        IF g_memo_pagetrailer THEN                                              
            PRINT g_x[27] CLIPPED                                                
            PRINT g_memo                                                        
        ELSE                                                                    
            PRINT                                                               
            PRINT                                                               
        END IF                                                                  
     ELSE                                                                       
            PRINT g_x[27] CLIPPED                                                
            PRINT g_memo                                                        
     END IF
# END FUN-550114
 
END REPORT}
#No.FUN-710085 --end--
#Patch....NO.TQC-610036 <> #
