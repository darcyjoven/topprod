# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: anmg711.4gl
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
# Modify.........: No.FUN-B40087 11/05/23 By yangtt  憑證報表轉GRW
# Modify.........: No.FUN-C10036 12/01/18 By lujh MOD-B80232追單
# Modify.........: No.FUN-C40020 12/04/10 By qirl  GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C50007 12/05/04 By minpp GR程序優化 
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
 
###GENGRE###START
TYPE sr1_t RECORD
    nne01 LIKE nne_file.nne01,
    nne02 LIKE nne_file.nne02,
    nne03 LIKE nne_file.nne03,
    nne04 LIKE nne_file.nne04,
    nne05 LIKE nne_file.nne05,
    nne051 LIKE nne_file.nne051,
    nne06 LIKE nne_file.nne06,
    nne07 LIKE nne_file.nne07,
    nne08 LIKE nne_file.nne08,
    nne09 LIKE nne_file.nne09,
    nne10 LIKE nne_file.nne10,
    nne111 LIKE nne_file.nne111,
    nne112 LIKE nne_file.nne112,
    nne12 LIKE nne_file.nne12,
    nne13 LIKE nne_file.nne13,
    nne14 LIKE nne_file.nne14,
    nne15 LIKE nne_file.nne15,
    nne16 LIKE nne_file.nne16,
    nne17 LIKE nne_file.nne17,
    nneex2 LIKE nne_file.nneex2,
    nne18 LIKE nne_file.nne18,
    nne19 LIKE nne_file.nne19,
    nne20 LIKE nne_file.nne20,
    nne21 LIKE nne_file.nne21,
    nne22 LIKE nne_file.nne22,
    nne23 LIKE nne_file.nne23,
    nne24 LIKE nne_file.nne24,
    nne25 LIKE nne_file.nne25,
    nne26 LIKE nne_file.nne26,
    nne27 LIKE nne_file.nne27,
    nne28 LIKE nne_file.nne28,
    nne29 LIKE nne_file.nne29,
    nne34 LIKE nne_file.nne34,
    nne35 LIKE nne_file.nne35,
    nne36 LIKE nne_file.nne36,
    nne37 LIKE nne_file.nne37,
    nne45 LIKE nne_file.nne45,
    nne46 LIKE nne_file.nne46,
    nneglno LIKE nne_file.nneglno,
    alg02 LIKE alg_file.alg02,
    nma02 LIKE nma_file.nma02,
    nma04_1 LIKE nma_file.nma04,
    l_nne06 LIKE nne_file.nne06,     #FUN-C50007 ADD
    nml02  LIKE nml_file.nml02,      #FUN-C50007 ADD
    nmt02  LIKE nmt_file.nmt02,      #FUN-C50007 ADD
    azi04 LIKE azi_file.azi04,
    azi07 LIKE azi_file.azi07,
    azi04_1 LIKE azi_file.azi04,
    sign_type LIKE type_file.chr1,   # No.FUN-C40020 add
    sign_img  LIKE type_file.blob,   # No.FUN-C40020 add
    sign_show LIKE type_file.chr1,   # No.FUN-C40020 add
    sign_str  LIKE type_file.chr1000 # No.FUN-C40020 add
END RECORD

TYPE sr2_t RECORD
    nnf01 LIKE nnf_file.nnf01,
    nnf03 LIKE nnf_file.nnf03,
    nnf04f LIKE nnf_file.nnf04f,
    nnf04 LIKE nnf_file.nnf04,
    nnf05 LIKE nnf_file.nnf05,
    nma04_2 LIKE nnf_file.nnf04,
    nmd02 LIKE nmd_file.nmd02
END RECORD
###GENGRE###END

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
               "nma04_1.nma_file.nma04,l_nne06.nne_file.nne06,", #FUN-C50007 add nne06
               "nml02.nml_file.nml02,nmt02.nmt_file.nmt02,",  #FUN-C50007
               "azi04.azi_file.azi04,azi07.azi_file.azi07,",
               "azi04_1.azi_file.azi04,",
               "sign_type.type_file.chr1,sign_img.type_file.blob,",  # No.FUN-C40020 add
               "sign_show.type_file.chr1,sign_str.type_file.chr1000" # No.FUN-C40020 add
   LET l_table = cl_prt_temptable('anmg711',g_sql) CLIPPED
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time         #FUN-B40087
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)     #FUN-B40087
      EXIT PROGRAM 
   END IF
 
   LET g_sql = "nnf01.nnf_file.nnf01,nnf03.nnf_file.nnf03,nnf04f.nnf_file.nnf04f,",
               "nnf04.nnf_file.nnf04,nnf05.nnf_file.nnf05,nma04_2.nnf_file.nnf04,",
               "nmd02.nmd_file.nmd02"
   LET l_table1 = cl_prt_temptable('anmg7111',g_sql) CLIPPED
   IF l_table1 = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time         #FUN-B40087
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)     #FUN-B40087
      EXIT PROGRAM 
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
      CALL anmg711_tm(0,0)             # Input print condition
   ELSE 
      CALL anmg711()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
END MAIN
 
FUNCTION anmg711_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01      #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,     #No.FUN-680107 SMALLINT
       l_cmd          LIKE type_file.chr1000   #No.FUN-680107 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 15
   OPEN WINDOW anmg711_w AT p_row,p_col
        WITH FORM "anm/42f/anmg711"
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
      LET INT_FLAG = 0 CLOSE WINDOW anmg711_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
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
      LET INT_FLAG = 0 CLOSE WINDOW anmg711_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='anmg711'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmg711','9031',1)
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
         CALL cl_cmdat('anmg711',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW anmg711_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmg711()
   ERROR ""
END WHILE
   CLOSE WINDOW anmg711_w
END FUNCTION
 
FUNCTION anmg711()
   #No.FUN-710085 --start--
   DEFINE l_img_blob        LIKE type_file.blob  # No.FUN-C40020 add
  # LOCATE l_img_blob        IN MEMORY            # No.FUN-C40020 add
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
   #FUN-C50007--ADD-STR
   DEFINE l_nml02  LIKE nml_file.nml02
   DEFINE l_nmt02  LIKE nmt_file.nmt02
   #FUN-C50007--ADD--END 
     #No.FUN-710085 --start--
   LOCATE l_img_blob        IN MEMORY            # No.FUN-C40020 add
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)   
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                 #"        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"   #MOD-740448
                 "?,?,?,?,        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"   #MOD-740448 #FUN-C50007 ADD 3?
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1)     #FUN-B40087
        EXIT PROGRAM
     END IF
     
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                 " VALUES(?,?,?,?,?, ?,?)"
     PREPARE insert_prep1 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep1:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1)     #FUN-B40087
        EXIT PROGRAM
     END IF
     #No.FUN-710085 --end--
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'anmg711'
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
     
     #LET l_sql="SELECT * FROM nne_file WHERE nneconf <> 'X' AND ",tm.wc CLIPPED  #FUN-C50007  mark 
     #FUN-C50007--add--STR
      LET l_sql="SELECT nne_file.*,alg02,nma02,nma04,nnn02,nml02,nmt02",
               "  FROM nne_file LEFT OUTER JOIN alg_file ON nne04=alg01 ",
               "  LEFT OUTER JOIN nma_file ON nne05=nma01  LEFT OUTER JOIN nnn_file ON nne06=nnn01 ",
               "  LEFT OUTER JOIN nml_file ON nne18=nml01  LEFT OUTER JOIN nmt_file ON nne35=nmt01",
               "  WHERE nneconf <> 'X' AND ",tm.wc CLIPPED 
     #FUN-C50007--add--END
     IF tm.n='1' THEN
        LET l_sql=l_sql CLIPPED," AND nneconf='Y' "
     END IF
     IF tm.n='2' THEN
        LET l_sql=l_sql CLIPPED," AND nneconf='N' "
     END IF
     PREPARE anmg711_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
        EXIT PROGRAM 
     END IF
     DECLARE anmg711_curs1 CURSOR FOR anmg711_prepare1
 
#    CALL cl_outnam('anmg711') RETURNING l_name  #No.FUN-710085 mark
#    START REPORT anmg711_rep TO l_name          #No.FUN-710085 mark

     #FUN-C50007--ADD--STR
     DECLARE g711_nnf_cur CURSOR FOR SELECT nnf_file.*,nma02,nmd02 
     FROM nnf_file LEFT OUTER JOIN nma_file ON nnf05=nma01	
                   LEFT OUTER JOIN nmd_file ON nnf06=nmd01
                                            WHERE nnf01 = ? 
     #FUN-C50007--ADD--END 

     LET g_pageno = 0
  #  FOREACH anmg711_curs1 INTO sr.*   #FUN-C50007 MARK
     FOREACH anmg711_curs1 INTO sr.*,l_alg02,l_nma02,l_nma04_1,l_nne06,l_nml02,l_nmt02   #FUN-C50007
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
       #No.FUN-710085 --start--
     # DECLARE g711_nnf_cur CURSOR FOR SELECT * from nnf_file        #FUN-C50007 MARK       
     #                                  WHERE nnf01 = sr.nne01       #FUN-C50007 MARK       
       SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=sr.nne16
       SELECT azi07 INTO t_azi07 FROM azi_file WHERE azi01=sr.nne16
     # SELECT alg02 INTO l_alg02 FROM alg_file WHERE alg01=sr.nne04  #FUN-C50007 MARK
     # SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01=sr.nne05  #FUN-C50007 MARK
     # SELECT nma04 INTO l_nma04_1 FROM nma_file                     #FUN-C50007 MARK
     #  WHERE nma01=sr.nne05                                         #FUN-C50007 MARK
     # SELECT nnn02 INTO l_nne06 FROM nnn_file WHERE nnn01=sr.nne06   #FUN-C50007 MARK
     # FOREACH g711_nnf_cur INTO l_nnf.*                              #FUN-C50007 MARK
       FOREACH g711_nnf_cur USING sr.nne01  INTO l_nnf.*,l_nma04_2,l_nmd02    #FUN-C50007
          LET l_nma04_2 = NULL
          LET l_nmd02 = NULL
          IF STATUS THEN EXIT FOREACH END IF
         ##FUN-C50007--MARK--STR
         #SELECT nma04 INTO l_nma04_2 FROM nma_file
         # WHERE nma01 = l_nnf.nnf05
         LET l_nma04_2 = l_nma04_2[1,15]
         #SELECT nmd02 INTO l_nmd02 FROM nmd_file
         # WHERE nmd01 = l_nnf.nnf06
         ##FUN-C50007--MARK--END
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
                                 l_nne06,l_nml02,l_nmt02,                        #FUN-C50007 ADD
                                 t_azi04,t_azi07,g_azi04,"",  l_img_blob,"N",""  # No.FUN-C40020 add
       #No.FUN-710085 --end--
 
#      OUTPUT TO REPORT anmg711_rep(sr.*)        #No.FUN-710085 mark
     END FOREACH
    
 
#    FINISH REPORT anmg711_rep                   #No.FUN-710085 mark
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len) #No.FUN-710085 mark
 
     #No.FUN-710085 --start--
     CALL cl_wcchp(tm.wc,'nne01,nne02,nne03,nne06')
          RETURNING tm.wc
###GENGRE###     LET g_str = tm.wc,";",g_zz05 CLIPPED
###GENGRE###     LET l_sql = "SELECT A.*,B.nnf03,B.nnf04f,B.nnf04,B.nnf05,B.nma04_2,B.nmd02",
###GENGRE###   #TQC-730088 # "  FROM ",l_table CLIPPED," A,OUTER ",l_table1 CLIPPED," B",
###GENGRE###                 "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A LEFT OUTER JOIN  ",g_cr_db_str CLIPPED,l_table1 CLIPPED," B",
###GENGRE###                 " ON A.nne01 = B.nnf01 "
   # CALL cl_prt_cs3('anmg711',l_sql,g_str)    #TQC-730088
###GENGRE###     CALL cl_prt_cs3('anmg711','anmg711',l_sql,g_str)
    LET g_cr_table = l_table                    # No.FUN-C40020 add
    LET g_cr_apr_key_f = "nne01"                    # No.FUN-C40020 add
    CALL anmg711_grdata()    ###GENGRE###
     #No.FUN-710085 --end--
END FUNCTION
 
#No.FUN-710085 --start--
{REPORT anmg711_rep(sr)
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
      DECLARE g711_nnf_cur CURSOR FOR SELECT * from nnf_file
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
      FOREACH g711_nnf_cur INTO l_nnf.*
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

###GENGRE###START
FUNCTION anmg711_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE sr2      sr2_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    LOCATE sr1.sign_img IN MEMORY      # No.FUN-C40020 add
    CALL cl_gre_init_apr()             # No.FUN-C40020 add
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("anmg711")
        IF handler IS NOT NULL THEN
            START REPORT anmg711_rep TO XML HANDLER handler
          
            LET l_sql = "SELECT A.*,B.*",
                        "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A LEFT OUTER JOIN  ",g_cr_db_str CLIPPED,l_table1 CLIPPED," B",
                        " ON A.nne01 = B.nnf01 ORDER BY A.nne01"

            DECLARE anmg711_datacur1 CURSOR FROM l_sql
            FOREACH anmg711_datacur1 INTO sr1.*,sr2.*
                OUTPUT TO REPORT anmg711_rep(sr1.*,sr2.*)
            END FOREACH
            FINISH REPORT anmg711_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT anmg711_rep(sr1,sr2)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE l_lineno           LIKE type_file.num5
    #FUN-B40087---------add-----str----
    DEFINE sr1_o              sr1_t
    DEFINE l_nne04_alg02      STRING
    DEFINE l_nne05_nne051     STRING
    DEFINE l_nne111_nne112    STRING
    DEFINE l_nne19_nne37      LIKE nne_file.nne19
    DEFINE l_nne19_nne37_2    LIKE nne_file.nne19
    DEFINE l_nne07            STRING
    DEFINE l_nne08            STRING 
    DEFINE l_nne09            STRING
    DEFINE l_nne111           STRING
    DEFINE l_nne112           STRING
    DEFINE l_display          STRING
    DEFINE l_display1         STRING
    DEFINE l_display2         STRING
    DEFINE l_display3         STRING
    DEFINE l_nne17_fmt        STRING
    DEFINE l_nneex2_fmt       STRING
    DEFINE l_nne12_fmt        STRING
    DEFINE l_nne19_fmt        STRING
    DEFINE l_nne27_fmt        STRING
    DEFINE l_nne20_fmt        STRING
    DEFINE l_nne19_nne37_fmt  STRING
    DEFINE l_nne19_nne37_2_fmt STRING
    DEFINE l_nne25_fmt        STRING
    DEFINE l_nne29_fmt        STRING
    DEFINE l_nne24_fmt        STRING
    DEFINE l_nne37_fmt        STRING
    DEFINE l_nne46_fmt        STRING
    DEFINE l_nnf04f_fmt       STRING
    DEFINE l_nnf04_fmt        STRING
    #FUN-B40087---------add-----end----
    #FUN-C50007--ADD--STR
    DEFINE l_nne06_nne06     STRING
    DEFINE l_nne18_nml02     STRING
    DEFINE l_nne35_nmt02     STRING
    #FUN-C50007--ADD--END
    
    ORDER EXTERNAL BY sr1.nne01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
            PRINTX g_lang      #FUN-B40087
            LET sr1_o.nne01 = NULL
  
        BEFORE GROUP OF sr1.nne01
            LET l_lineno = 0

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            #FUN-B40087---------add-----str----
            LET l_nne17_fmt = cl_gr_numfmt('nne_file','nne17',sr1.azi07)
            PRINTX l_nne17_fmt
            LET l_nneex2_fmt = cl_gr_numfmt('nne_file','nneex2',sr1.azi07)
            PRINTX l_nneex2_fmt
            LET l_nne12_fmt = cl_gr_numfmt('nne_file','nne12',sr1.azi04)
            PRINTX l_nne12_fmt
            LET l_nne19_fmt = cl_gr_numfmt('nne_file','nne19',g_azi04)
            PRINTX l_nne19_fmt
            LET l_nne27_fmt = cl_gr_numfmt('nne_file','nne27',sr1.azi04)
            PRINTX l_nne27_fmt
            LET l_nne20_fmt = cl_gr_numfmt('nne_file','nne20',g_azi04)
            PRINTX l_nne20_fmt
            LET l_nne19_nne37_fmt = cl_gr_numfmt('nne_file','nne19',sr1.azi04)
            PRINTX l_nne19_nne37_fmt
            LET l_nne19_nne37_2_fmt = cl_gr_numfmt('nne_file','nne19',sr1.azi04_1)
            PRINTX l_nne19_nne37_2_fmt
            LET l_nne25_fmt = cl_gr_numfmt('nne_file','nne25',g_azi04)
            PRINTX l_nne25_fmt
            LET l_nne29_fmt = cl_gr_numfmt('nne_file','nne29',g_azi04)
            PRINTX l_nne29_fmt
            LET l_nne24_fmt = cl_gr_numfmt('nne_file','nne24',g_azi04)
            PRINTX l_nne24_fmt
            LET l_nne37_fmt = cl_gr_numfmt('nne_file','nne37',g_azi04)
            PRINTX l_nne37_fmt
            LET l_nne46_fmt = cl_gr_numfmt('nne_file','nne46',g_azi04)
            PRINTX l_nne46_fmt
            LET l_nnf04f_fmt = cl_gr_numfmt('nnf_file','nnf04f',sr1.azi04)
            PRINTX l_nnf04f_fmt
            LET l_nnf04_fmt = cl_gr_numfmt('nnf_file','nnf04',sr1.azi04_1)
            PRINTX l_nnf04_fmt
           

            LET l_nne04_alg02 = sr1.nne04,' ',sr1.alg02
            PRINTX l_nne04_alg02
            LET l_nne05_nne051 = sr1.nne05,' ',sr1.nma02,' ',sr1.nne051
            PRINTX l_nne05_nne051
            LET l_nne111 = sr1.nne111 USING "yyyy/mm/dd"
            LET l_nne112 = sr1.nne112 USING "yyyy/mm/dd"
            LET l_nne111_nne112 = l_nne111,'-',l_nne112
            PRINTX l_nne111_nne112
            LET l_nne19_nne37 = sr1.nne19-sr1.nne25-sr1.nne24-sr1.nne37
            PRINTX l_nne19_nne37
            LET l_nne19_nne37_2 = sr1.nne19-sr1.nne25-sr1.nne29-sr1.nne24-sr1.nne37
            PRINTX l_nne19_nne37_2
            LET l_nne09 = cl_gr_getmsg("gre-044",g_lang,sr1.nne09)
            LET l_nne08 = cl_gr_getmsg("gre-041",g_lang,sr1.nne08)
            PRINTX l_nne08
            PRINTX l_nne09
            LET l_nne07 = cl_gr_getmsg("gre-056",g_lang,sr1.nne07)
            PRINTX l_nne07
          
            IF NOT cl_null(sr1_o.nne01) THEN
               IF sr1_o.nne01 !=  sr1.nne01 THEN
                  LET l_display = "Y"
               ELSE
                  LET l_display = "N"
               END IF
            ELSE                       #FUN-C10036 add
               LET l_display = "Y"     #FUN-C10036 add
            END IF
            PRINTX l_display

            #IF (sr1_o.nne01 != sr1.nne01 OR cl_null(sr1_o.nne01)) AND NOT cl_null(sr1.nne05) AND NOT cl_null(sr1.nne35) THEN  #FUN-C10036  mark
            IF (sr1_o.nne01 != sr1.nne01 OR cl_null(sr1_o.nne01)) AND NOT cl_null(sr1.nne05) THEN  #FUN-C10036  add
               LET l_display1 = 'Y'
            ELSE
               LET l_display1 = 'N'
            END IF
            PRINTX l_display1

            #IF (sr1_o.nne01 != sr1.nne01 OR cl_null(sr1_o.nne01)) AND NOT cl_null(sr1.nne05) AND cl_null(sr1.nne35) THEN  #FUN-C10036  mark
            IF (sr1_o.nne01 != sr1.nne01 OR cl_null(sr1_o.nne01)) AND NOT cl_null(sr1.nne05) THEN  #FUN-C10036  add
               LET l_display2 = 'Y'
            ELSE
               LET l_display2 = 'N'
            END IF
            PRINTX l_display2

            IF (sr1_o.nne01 != sr1.nne01 OR cl_null(sr1_o.nne01)) AND cl_null(sr1.nne05) THEN
               LET l_display3 = 'Y'
            ELSE
               LET l_display3 = 'N'
            END IF
            PRINTX l_display3
            #FUN-B40087---------add-----end----
            #FUN-C50007--ADD--STR
            LET l_nne06_nne06=sr1.nne06,' ',sr1.l_nne06
            PRINTX  l_nne06_nne06
            LET l_nne18_nml02 = sr1.nne18,' ',sr1.nml02
            PRINTX l_nne18_nml02
            LET l_nne35_nmt02 = sr1.nne35,' ',sr1.nmt02
            PRINTX l_nne35_nmt02
            #FUN-C50007--ADD---END 
            PRINTX sr1.*
            PRINTX sr2.*
            LET sr1_o.* = sr1.*

        AFTER GROUP OF sr1.nne01

        
        ON LAST ROW

END REPORT
###GENGRE###END
