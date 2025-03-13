# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: anmr711.4gl
# Descriptions...:短期融資憑證列印
# Date & Author..: 97/09/12 By Lynn
# Modify.........: Joan 020627 IF 存入銀行=null ,THEN 實際入帳金額=0
#                              IF 存入銀行<>null ,依他保銀行決定實際入帳金額
# Modify.........: No.FUN-4C0098 05/03/03 By pengu 修改報表單價、金額欄位寬度
# Modify.........: No.FUN-550114 05/05/26 By echo 新增報表備註
# Modify.........: No.MOD-590489 05/10/03 By Dido 報表調整
# Modify.........: No.MOD-5B0232 05/11/22 By Smapmin 融資原幣,沒有做小數位數取位
# Modify.........: No.TQC-5C0051 05/12/09 By kevin 欄位沒對齊
# Modify.........: No.MOD-660021 06/06/08 by Smapmin 銀行帳號沒有列印出來
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-710085 07/02/01 By Rayven 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.MOD-740448 07/04/30 By Smapmin 增加交割金額
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80067 11/08/05 By fengrui  程式撰寫規範修正
# Modify.........: No.TQC-C10034 12/01/19 By yuhuabao GP 5.3 CR報表列印TIPTOP與EasyFlow簽核圖片
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                             # Print condition RECORD
              wc      LIKE type_file.chr1000,    #No.FUN-680107 VARCHAR(600) # Where condition
              n       LIKE type_file.chr1,       #No.FUN-680107 VARCHAR(1)   # 列印單價
              more    LIKE type_file.chr1        #No.FUN-680107 VARCHAR(1)   # Input more condition(Y/N)
              END RECORD
 
DEFINE   g_i          LIKE type_file.num5        #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE   l_table      STRING                     #No.FUN-710085                                                                       
DEFINE   l_table1     STRING                     #No.FUN-710085                                                                       
DEFINE   g_sql        STRING                     #No.FUN-710085                                                                       
DEFINE   g_str        STRING                     #No.FUN-710085
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                               # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
   #No.FUN-710085 --start--
   LET g_sql = "nne01.nne_file.nne01,nne02.nne_file.nne02,nne03.nne_file.nne03,",
               "nne04.nne_file.nne04,nne05.nne_file.nne05,nne051.nne_file.nne051,",
               "nne06.nne_file.nne06,nne07.nne_file.nne07,nne08.nne_file.nne08,",
               "nne09.nne_file.nne09,nne10.nne_file.nne10,nne111.nne_file.nne111,",
               "nne112.nne_file.nne112,nne12.nne_file.nne12,nne13.nne_file.nne13,",
               "nne14.nne_file.nne14,nne15.nne_file.nne15,nne16.nne_file.nne16,",
               "nne17.nne_file.nne17,nneex2.nne_file.nneex2,nne18.nne_file.nne18,",
               "nne19.nne_file.nne19,nne20.nne_file.nne20,nne21.nne_file.nne21,",
               "nne22.nne_file.nne22,nne23.nne_file.nne23,nne24.nne_file.nne24,",
               "nne25.nne_file.nne25,nne26.nne_file.nne26,nne27.nne_file.nne27,",
               "nne28.nne_file.nne28,nne29.nne_file.nne29,nne34.nne_file.nne34,",
               "nne35.nne_file.nne35,nne36.nne_file.nne36,nne37.nne_file.nne37,",
               "nne45.nne_file.nne45,nne46.nne_file.nne46,",    #MOD-740448
               "nneglno.nne_file.nneglno,alg02.alg_file.alg02,nma02.nma_file.nma02,",
               "nma04_1.nma_file.nma04,azi04.azi_file.azi04,azi07.azi_file.azi07,",
               "azi04_1.azi_file.azi04,", #No.TQC-C10034 add , ,
               "sign_type.type_file.chr1,",   #簽核方式                   #No.TQC-C10034 add
               "sign_img.type_file.blob,",    #簽核圖檔                   #No.TQC-C10034 add
               "sign_show.type_file.chr1,",   #是否顯示簽核資料(Y/N)      #No.TQC-C10034 add
               "sign_str.type_file.chr1000"   #簽核字串                   #No.TQC-C10034 add
   LET l_table = cl_prt_temptable('anmr711',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "nnf01.nnf_file.nnf01,nnf03.nnf_file.nnf03,nnf04f.nnf_file.nnf04f,",
               "nnf04.nnf_file.nnf04,nnf05.nnf_file.nnf05,nma04_2.nnf_file.nnf04,",
               "nmd02.nmd_file.nmd02"
   LET l_table1 = cl_prt_temptable('anmr7111',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
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
      CALL anmr711_tm(0,0)             # Input print condition
   ELSE 
      CALL anmr711()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr711_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01      #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,     #No.FUN-680107 SMALLINT
       l_cmd          LIKE type_file.chr1000   #No.FUN-680107 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 15
   OPEN WINDOW anmr711_w AT p_row,p_col
        WITH FORM "anm/42f/anmr711"
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
   CONSTRUCT BY NAME tm.wc ON nne01,nne02,nne03,nne06
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr711_w 
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr711_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='anmr711'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr711','9031',1)
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
         CALL cl_cmdat('anmr711',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW anmr711_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr711()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr711_w
END FUNCTION
 
FUNCTION anmr711()
   #No.FUN-710085 --start--
   DEFINE l_alg02   LIKE alg_file.alg02
   DEFINE l_nma02   LIKE nma_file.nma02
   DEFINE l_nma04_1 LIKE nma_file.nma04
   DEFINE l_nma04_2 LIKE nma_file.nma04  
   DEFINE l_nmd02   LIKE nmd_file.nmd02
   DEFINE l_nne06   LIKE nne_file.nne06
   DEFINE l_nnf     RECORD LIKE nnf_file.*
   #No.FUN-710085 --end--
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0082
          l_sql     LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(3000)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(40)
          sr        RECORD  LIKE nne_file.*
   DEFINE l_img_blob     LIKE type_file.blob                                         #No.TQC-C10034 add
   LOCATE l_img_blob IN MEMORY   #blob初始化   #Genero Version 2.21.02之後要先初始化 #No.TQC-C10034 add
 
     #No.FUN-710085 --start--
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                 #"        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"   #MOD-740448
                 "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,? ,?,?,?,?)"   #MOD-740448 #No.TQC-C10034 add 4?
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
        EXIT PROGRAM
     END IF
     
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                 " VALUES(?,?,?,?,?, ?,?)"
     PREPARE insert_prep1 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep1:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
        EXIT PROGRAM
     END IF
     #No.FUN-710085 --end--
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'anmr711'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#NO.CHI-6A0004
#     SELECT azi03,azi04,azi05
#       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file
#      WHERE azi01=g_aza.aza17
#NO.CHI-6A0004
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
 
     LET l_sql="SELECT * FROM nne_file WHERE nneconf <> 'X' AND ",tm.wc CLIPPED
     IF tm.n='1' THEN
        LET l_sql=l_sql CLIPPED," AND nneconf='Y' "
     END IF
     IF tm.n='2' THEN
        LET l_sql=l_sql CLIPPED," AND nneconf='N' "
     END IF
     PREPARE anmr711_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM 
     END IF
     DECLARE anmr711_curs1 CURSOR FOR anmr711_prepare1
 
#    CALL cl_outnam('anmr711') RETURNING l_name  #No.FUN-710085 mark
#    START REPORT anmr711_rep TO l_name          #No.FUN-710085 mark
 
     LET g_pageno = 0
     FOREACH anmr711_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
       #No.FUN-710085 --start--
       DECLARE r711_nnf_cur CURSOR FOR SELECT * from nnf_file
                                        WHERE nnf01 = sr.nne01
       SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=sr.nne16
       SELECT azi07 INTO t_azi07 FROM azi_file WHERE azi01=sr.nne16
       SELECT alg02 INTO l_alg02 FROM alg_file WHERE alg01=sr.nne04
       SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01=sr.nne05
       SELECT nma04 INTO l_nma04_1 FROM nma_file
        WHERE nma01=sr.nne05
       SELECT nnn02 INTO l_nne06 FROM nnn_file WHERE nnn01=sr.nne06
       FOREACH r711_nnf_cur INTO l_nnf.*
          LET l_nma04_2 = NULL
          LET l_nmd02 = NULL
          IF STATUS THEN EXIT FOREACH END IF
          SELECT nma04 INTO l_nma04_2 FROM nma_file
           WHERE nma01 = l_nnf.nnf05
          LET l_nma04_2 = l_nma04_2[1,15]
          SELECT nmd02 INTO l_nmd02 FROM nmd_file
           WHERE nmd01 = l_nnf.nnf06
          EXECUTE insert_prep1 USING sr.nne01,l_nnf.nnf03,l_nnf.nnf04f,
                                     l_nnf.nnf04,l_nnf.nnf05,l_nma04_2,l_nmd02
       END FOREACH
 
       EXECUTE insert_prep USING sr.nne01,sr.nne02,sr.nne03,sr.nne04,
                                 sr.nne05,sr.nne051,sr.nne06,sr.nne07,
                                 sr.nne08,sr.nne09,sr.nne10,sr.nne111,
                                 sr.nne112,sr.nne12,sr.nne13,sr.nne14,
                                 sr.nne15,sr.nne16,sr.nne17,sr.nneex2,
                                 sr.nne18,sr.nne19,sr.nne20,sr.nne21,
                                 sr.nne22,sr.nne23,sr.nne24,sr.nne25,
                                 sr.nne26,sr.nne27,sr.nne28,sr.nne29,
                                 sr.nne34,sr.nne35,sr.nne36,sr.nne37,
                                 sr.nne45,sr.nne46,   #MOD-740448
                                 sr.nneglno,l_alg02,l_nma02,l_nma04_1,
                                 t_azi04,t_azi07,g_azi04
                                 ,"",  l_img_blob,   "N",""      #No.TQC-C10034 add
       #No.FUN-710085 --end--
 
#      OUTPUT TO REPORT anmr711_rep(sr.*)        #No.FUN-710085 mark
     END FOREACH
 
#    FINISH REPORT anmr711_rep                   #No.FUN-710085 mark
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len) #No.FUN-710085 mark
 
     #No.FUN-710085 --start--
     CALL cl_wcchp(tm.wc,'nne01,nne02,nne03,nne06')
          RETURNING tm.wc
     LET g_str = tm.wc,";",g_zz05 CLIPPED
     LET l_sql = "SELECT A.*,B.nnf03,B.nnf04f,B.nnf04,B.nnf05,B.nma04_2,B.nmd02",
   #TQC-730088 # "  FROM ",l_table CLIPPED," A,OUTER ",l_table1 CLIPPED," B",
                 "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A LEFT OUTER JOIN  ",g_cr_db_str CLIPPED,l_table1 CLIPPED," B",
                 " ON A.nne01 = B.nnf01 "
   # CALL cl_prt_cs3('anmr711',l_sql,g_str)    #TQC-730088
     LET g_cr_table = l_table                 #主報表的temp table名稱        #No.TQC-C10034 add
     LET g_cr_apr_key_f = "nne01"             #報表主鍵欄位名稱，用"|"隔開   #No.TQC-C10034 add
     CALL cl_prt_cs3('anmr711','anmr711',l_sql,g_str)
     #No.FUN-710085 --end--
END FUNCTION
 
#No.FUN-710085 --start--
{REPORT anmr711_rep(sr)
 DEFINE l_last_sw LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
         sr       RECORD LIKE nne_file.*,
         t_azi04  LIKE azi_file.azi04,
         l_flag   LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
         l_azi03  LIKE azi_file.azi03,
         l_azi04  LIKE azi_file.azi04,
         l_azi05  LIKE azi_file.azi05
  DEFINE l_alg02  LIKE alg_file.alg02
  DEFINE l_nma02  LIKE nma_file.nma02
  DEFINE l_nma04  LIKE nma_file.nma04
  DEFINE l_nma10  LIKE nma_file.nma10
  DEFINE l_nnn06  LIKE nnn_file.nnn06
  DEFINE l_nne06  LIKE nne_file.nne06     #No.FUN-680107 VARCHAR(12)
  DEFINE l_nnf    RECORD LIKE nnf_file.*
  DEFINE l_nmd02  LIKE nmd_file.nmd02
 
  OUTPUT TOP MARGIN 0
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN 5
         PAGE LENGTH g_page_line
  ORDER BY sr.nne01,sr.nne02,sr.nne03
  FORMAT
   PAGE HEADER
      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
      IF g_towhom IS NULL OR g_towhom = ' '
         THEN PRINT '';
         ELSE PRINT 'TO:',g_towhom;
      END IF
      PRINT ' '
      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1];#No.TQC-5C0051
      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
      PRINT ' '
      LET g_pageno= g_pageno+1
      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.nne01
    # Jason 020124 融資開票明細
      DECLARE r711_nnf_cur CURSOR FOR SELECT * from nnf_file
       WHERE nnf01 = sr.nne01	
    #----------END
      SKIP TO TOP OF PAGE
 
   ON EVERY ROW
      SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=sr.nne16   #MOD-5B0232
      SELECT azi07 INTO t_azi07 FROM azi_file WHERE azi01=sr.nne16
      SELECT alg02 INTO l_alg02 FROM alg_file WHERE alg01=sr.nne04
      SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01=sr.nne05
      PRINT COLUMN 02,g_x[11] CLIPPED,sr.nne01,
#            COLUMN 36,g_x[12] CLIPPED,sr.nne111,'-',sr.nne112   #MOD-5B0232
            COLUMN 38,g_x[12] CLIPPED,sr.nne111,'-',sr.nne112   #MOD-5B0232
      PRINT COLUMN 02,g_x[13] CLIPPED,sr.nne02,
#MOD-590489
            COLUMN 38,g_x[14] CLIPPED,sr.nne16 CLIPPED,COLUMN 54,cl_numfor( sr.nne17,10,t_azi07),
#           COLUMN 38,g_x[14] CLIPPED,sr.nne16 CLIPPED,COLUMN 52,cl_numfor( sr.nne17,10,t_azi07),
#            COLUMN 66,g_x[15] CLIPPED,COLUMN 83,cl_numfor(sr.nneex2,10,t_azi07)    #MOD-5B0232
            COLUMN 67,g_x[15] CLIPPED,COLUMN 76,cl_numfor(sr.nneex2,10,t_azi07)    #MOD-5B0232
#           COLUMN 65,g_x[15] CLIPPED,COLUMN 74,cl_numfor(sr.nneex2,10,t_azi07)
#MOD-590489 End
      PRINT COLUMN 02,g_x[16] CLIPPED,sr.nne03,
            COLUMN 38,g_x[17] CLIPPED,
#            COLUMN 46,cl_numfor(sr.nne12,17,l_azi04),   #MOD-5B0232
            COLUMN 46,cl_numfor(sr.nne12,17,t_azi04),   #MOD-5B0232
#            COLUMN 66,g_x[18] CLIPPED,     #g_x[18]改為借款金額:   #MOD-5B0232
            COLUMN 67,g_x[18] CLIPPED,     #g_x[18]改為借款金額:   #MOD-5B0232
#MOD-590489
#            COLUMN 75,cl_numfor(sr.nne19,18,g_azi04)   #MOD-5B0232
            COLUMN 76,cl_numfor(sr.nne19,18,g_azi04)   #MOD-5B0232
#MOD-590489 End
      PRINT COLUMN 02,g_x[19] CLIPPED,sr.nne04,'  ',l_alg02,
            COLUMN 42,g_x[20] CLIPPED,
#            COLUMN 46,cl_numfor(sr.nne27,17,l_azi04),   #MOD-5B0232
            COLUMN 46,cl_numfor(sr.nne27,17,t_azi04),   #MOD-5B0232
#            COLUMN 66,g_x[20] CLIPPED,   #MOD-5B0232
#            COLUMN 75,cl_numfor(sr.nne20,18,g_azi04)   #MOD-5B0232
            COLUMN 67,g_x[20] CLIPPED,   #MOD-5B0232
            COLUMN 76,cl_numfor(sr.nne20,18,g_azi04)   #MOD-5B0232
      PRINT COLUMN 02,g_x[21] CLIPPED,sr.nne05[1,6],'  ',l_nma02[1,12],' ',
            sr.nne051,
            COLUMN 38,g_x[22] CLIPPED,sr.nne13,g_x[51] CLIPPED,
#MOD-590489
              #--g_x[23]改為總借款成本:
#            COLUMN 66,g_x[23] CLIPPED,'      ',sr.nne14,g_x[51] CLIPPED  #MOD-5B0232
            COLUMN 67,g_x[23] CLIPPED,'      ',sr.nne14,g_x[51] CLIPPED  #MOD-5B0232
#           COLUMN 65,g_x[23] CLIPPED,sr.nne14,g_x[51] CLIPPED
#MOD-590489 End
# Thomas 01/12/27
      SELECT nnn02,nnn06 INTO l_nne06,l_nnn06 FROM nnn_file WHERE nnn01=sr.nne06
      # IF l_nnn06 matches '[23]' THEN
# Thomas 020307 透過自保他保來判斷入帳金額
# Joan 020627 先判斷IF 存入銀行=null ,THEN 實際入帳金額= 0 --------------------
#                   IF 存入銀行<>null ,依他保銀行決定實際入帳金額
      #-----MOD-660021---------
      LET l_nma04=''
      SELECT nma04 INTO l_nma04 FROM nma_file
        WHERE nma01=sr.nne05
      #-----END MOD-660021-----
      IF NOT cl_null(sr.nne05) THEN
         IF NOT cl_null(sr.nne35) THEN
            PRINT COLUMN 02,g_x[59] CLIPPED,l_nma04,
                  COLUMN 38,g_x[60] CLIPPED,
                  COLUMN 51,cl_numfor(sr.nne19-sr.nne25-sr.nne24-sr.nne37,18,g_azi04)
         ELSE
            PRINT COLUMN 02,g_x[59] CLIPPED,l_nma04,
                  COLUMN 38,g_x[60] CLIPPED,
                  COLUMN 51,cl_numfor(sr.nne19-sr.nne25-sr.nne29-sr.nne24-sr.nne37,18,g_azi04)
         END IF
      ELSE
         PRINT COLUMN 02,g_x[59] CLIPPED,
               COLUMN 38,g_x[60] CLIPPED,'    0'
      END IF
# Joan 020627 end -------------------------------------------------------------
# End #
      PRINT COLUMN 02,g_x[24] CLIPPED;
      #----NO:0246
      SELECT nnn02 INTO l_nne06 FROM nnn_file WHERE nnn01=sr.nne06
      PRINT l_nne06 CLIPPED;
      #---
      PRINT COLUMN 38,g_x[25] CLIPPED,sr.nne21,
#            COLUMN 66,g_x[26] CLIPPED,sr.nne22 USING '#&'   #MOD-5B0232
            COLUMN 67,g_x[26] CLIPPED,sr.nne22 USING '#&'   #MOD-5B0232
      PRINT COLUMN 38,g_x[27] CLIPPED,sr.nne26
      PRINT COLUMN 38,g_x[28] CLIPPED,sr.nne18
      PRINT COLUMN 38,g_x[29] CLIPPED,sr.nneglno
      PRINT COLUMN 38,g_x[52] CLIPPED,sr.nne35
      PRINT COLUMN 2,g_x[30] CLIPPED,sr.nne28,
            COLUMN 38,g_x[31] CLIPPED,sr.nne15
 
      PRINT COLUMN 2,g_x[32] CLIPPED;
      CASE sr.nne07
          WHEN '1' PRINT g_x[45] CLIPPED;
          WHEN '2' PRINT g_x[46] CLIPPED;
      END CASE
      PRINT COLUMN 38,g_x[37] CLIPPED,
            COLUMN 47,cl_numfor(sr.nne25,18,g_azi04)
 
      PRINT COLUMN 2,g_x[34] CLIPPED;
      CASE sr.nne08
          WHEN '1' PRINT g_x[47] CLIPPED;
          WHEN '2' PRINT g_x[48] CLIPPED;
      END CASE
      PRINT COLUMN 38,g_x[53] CLIPPED,COLUMN 47,sr.nne34,g_x[51] CLIPPED,
#            COLUMN 65,g_x[54] CLIPPED,   #MOD-5B0232
#            COLUMN 74,cl_numfor(sr.nne29,18,g_azi04)   #MOD-5B0232
            COLUMN 67,g_x[54] CLIPPED,   #MOD-5B0232
            COLUMN 76,cl_numfor(sr.nne29,18,g_azi04)   #MOD-5B0232
 
      PRINT COLUMN 2,g_x[36] CLIPPED;
      CASE sr.nne09
          WHEN '1' PRINT g_x[49] CLIPPED;
          WHEN '2' PRINT g_x[50] CLIPPED;
      END CASE
 
      PRINT COLUMN 38,g_x[55] CLIPPED,COLUMN 47,sr.nne23,g_x[51] CLIPPED,
#            COLUMN 65,g_x[56] CLIPPED,   #MOD-5B0232
#            COLUMN 74,cl_numfor(sr.nne24,18,g_azi04)   #MOD-5B0232
            COLUMN 67,g_x[56] CLIPPED,   #MOD-5B0232
            COLUMN 76,cl_numfor(sr.nne24,18,g_azi04)   #MOD-5B0232
 
      PRINT COLUMN 2,g_x[38] CLIPPED,sr.nne10;
      PRINT COLUMN 38,g_x[57] CLIPPED,COLUMN 47,sr.nne36,g_x[51] CLIPPED,
#            COLUMN 65,g_x[58] CLIPPED,   #MOD-5B0232
#            COLUMN 74,cl_numfor(sr.nne37,18,g_azi04)   #MOD-5B0232
            COLUMN 67,g_x[58] CLIPPED,   #MOD-5B0232
            COLUMN 76,cl_numfor(sr.nne37,18,g_azi04)   #MOD-5B0232
    # Jason 020124 融資開票明細
      PRINT COLUMN 2,g_x[61],COLUMN 54,g_x[62] CLIPPED
      PRINT COLUMN 2,'--------',
            COLUMN 12,'-------------------',
            COLUMN 32,'-------------------',
            COLUMN 52,'-----------',
            COLUMN 64,'---------------',
            COLUMN 81,'------------'
      FOREACH r711_nnf_cur INTO l_nnf.*
        IF STATUS THEN EXIT FOREACH END IF
        LET l_nma04 = ''   #MOD-660021
        LET l_nma10 = ''   #MOD-660021
        LET l_nmd02 = ''   #MOD-660021
        SELECT nma04,nma10 INTO l_nma04,l_nma10 FROM nma_file
         WHERE nma01 = l_nnf.nnf05
        SELECT nmd02 INTO l_nmd02 FROM nmd_file
         WHERE nmd01 = l_nnf.nnf06
        SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=l_nma10
 
        PRINT COLUMN 2,l_nnf.nnf03,
              COLUMN 12,cl_numfor(l_nnf.nnf04f,18,t_azi04),
              COLUMN 32,cl_numfor(l_nnf.nnf04,18,g_azi04),
              COLUMN 52,l_nnf.nnf05,
              COLUMN 64,l_nma04[1,15],    #銀行帳號
              COLUMN 81,l_nmd02     #票據號碼
      END FOREACH
   #---------------END
      PRINT g_dash[1,g_len]
## FUN-550114
  #PAGE TRAILER   # mark By Jason 020118
  #   PRINT''
  #   PRINT''
  #       PRINT COLUMN 01,g_x[04] CLIPPED,COLUMN 41,g_x[05] CLIPPED
  # PAGE TRAILER
  #   PRINT''
ON LAST ROW
     LET l_last_sw = 'y'
 
PAGE TRAILER
     PRINT ''
     IF l_last_sw = 'n' THEN
        IF g_memo_pagetrailer THEN
            PRINT g_x[4]
            PRINT g_memo
        ELSE
            PRINT
            PRINT
        END IF
     ELSE
            PRINT g_x[4]
            PRINT g_memo
     END IF
## END FUN-550114
 
END REPORT}
#No.FUN-710085 --end--
#Patch....NO.TQC-610036 <001,002> #
