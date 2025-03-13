# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: anmg723.4gl
# Descriptions...: 中長期貸款憑證
# Date & Author..: 97/09/12 By Lynn
# Modify.........: 02/08/23 by evechu
#			IF 存入銀行=null ,THEN 實際入帳金額=0
#                       IF 存入銀行<>null ,依他保銀行決定實際入帳金額
# Modify.........: No.FUN-4C0098 05/03/03 By pengu 修改報表單價、金額欄位寬度
# Modify.........: NO.FUN-550057 05/05/27 By jackie 單據編號加大
# Modify.........: No.FUN-4C0098 05/03/03 By pengu 修改報表單價、金額欄位寬度
# Modify.........: No.FUN-550114 05/05/26 By echo 新增報表備註
# Modify.........: No.FUN-570177 05/07/19 By Trisy 項次位數加大
# Modify.........: No.MOD-590490 05/10/03 By Dido 報表調整
# Modify.........: No.FUN-5A0180 05/10/25 By Claire 報表調整可印Font 10
# Modify.........: NO.FUN-590118 06/01/19 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-710085 07/02/02 By Rayven 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.TQC-830031 08/03/27 By Carol l_cmd 型態改為type_file.chr1000
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modfiy.........: No.FUN-B50018 11/05/20 By xumm CR轉GRW
# Modify.........: No.FUN-B80067 11/08/05 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-B50018 11/08/11 By xumm 程式規範修改
# Modify.........: No.FUN-C20052 12/02/09 By chenying GR調整
# Modify.........: No.FUN-C40020 12/04/10 By qirl  GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C50007 12/05/04 By minpp GR程式優化 
# Modify.........: No.FUN-C30085 12/06/29 By lixiang 修改匯率顯示*的BUG 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                             # Print condition RECORD
              wc      LIKE type_file.chr1000,    #No.FUN-680107 VARCHAR(600) # Where condition
              n       LIKE type_file.chr1,       #No.FUN-680107 VARCHAR(1)   # 列印單價
              more    LIKE type_file.chr1        #No.FUN-680107 VARCHAR(1)   # Input more condition(Y/N)
              END RECORD
 
   DEFINE g_i         LIKE type_file.num5        #count/index for any purpose #No.FUN-680107 SMALLINT
   DEFINE l_table     STRING                     #No.FUN-710085                                                                     
   DEFINE l_table1    STRING                     #No.FUN-710085                                                                     
   DEFINE l_table2    STRING                     #No.FUN-710085                                                                     
   DEFINE g_sql       STRING                     #No.FUN-710085                                                                     
   DEFINE g_str       STRING                     #No.FUN-710085
###GENGRE###START
TYPE sr1_t RECORD
    nng01 LIKE nng_file.nng01,
    nng02 LIKE nng_file.nng02,
    nng03 LIKE nng_file.nng03,
    nng04 LIKE nng_file.nng04,
    nng05 LIKE nng_file.nng05,
    nng06 LIKE nng_file.nng06,
    nng07 LIKE nng_file.nng07,
    nng081 LIKE nng_file.nng081,
    nng082 LIKE nng_file.nng082,
    nng09 LIKE nng_file.nng09,
    nng101 LIKE nng_file.nng101,
    nng102 LIKE nng_file.nng102,
    nng11 LIKE nng_file.nng11,
    nng12 LIKE nng_file.nng12,
    nng13 LIKE nng_file.nng13,
    nng14 LIKE nng_file.nng14,
    nng15 LIKE nng_file.nng15,
    nng16 LIKE nng_file.nng16,
    nng17 LIKE nng_file.nng17,
    nng18 LIKE nng_file.nng18,
    nng19 LIKE nng_file.nng19,
    nngex2 LIKE nng_file.nngex2,
    nng20 LIKE nng_file.nng20,
    nng21 LIKE nng_file.nng21,
    nng22 LIKE nng_file.nng22,
    nng23 LIKE nng_file.nng23,
    nng52 LIKE nng_file.nng52,
    nng53 LIKE nng_file.nng53,
    nng54 LIKE nng_file.nng54,
    nng55 LIKE nng_file.nng55,
    nng56 LIKE nng_file.nng56,
    nng57 LIKE nng_file.nng57,
    nng58 LIKE nng_file.nng58,
    nng59 LIKE nng_file.nng59,
    nng60 LIKE nng_file.nng60,
    nng61 LIKE nng_file.nng61,
    nngglno LIKE nng_file.nngglno,
    alg02 LIKE alg_file.alg02,
    nma02 LIKE nma_file.nma02,
    nml02 LIKE nml_file.nml02,      #FUN-C50007 add
    azi04 LIKE azi_file.azi04,
    azi07 LIKE azi_file.azi07,
    sign_type LIKE type_file.chr1,   # No.FUN-C40020 add
    sign_img  LIKE type_file.blob,   # No.FUN-C40020 add
    sign_show LIKE type_file.chr1,   # No.FUN-C40020 add
    sign_str  LIKE type_file.chr1000 # No.FUN-C40020 add
END RECORD

TYPE sr2_t RECORD
    nnf01 LIKE nnf_file.nnf01,
    nnf02 LIKE nnf_file.nnf02,
    nnf03 LIKE nnf_file.nnf02,
    nnf04f LIKE nnf_file.nnf04f,
    nnf04 LIKE nnf_file.nnf04,
    nnf05 LIKE nnf_file.nnf05,
    nnf06 LIKE nnf_file.nnf06,
    nmd02_1 LIKE nmd_file.nmd02,
    nmd12_1 LIKE nmd_file.nmd12
END RECORD

TYPE sr3_t RECORD
    nnh01 LIKE nnh_file.nnh01,
    nnh02 LIKE nnh_file.nnh02,
    nnh03 LIKE nnh_file.nnh03,
    nnh04f LIKE nnh_file.nnh04f,
    nnh04 LIKE nnh_file.nnh04,
    nnh05 LIKE nnh_file.nnh05,
    nnh06 LIKE nnh_file.nnh06,
    nmd02_2 LIKE nmd_file.nmd02,
    nmd12_2 LIKE nmd_file.nmd12
END RECORD
###GENGRE###END

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
   LET g_sql = "nng01.nng_file.nng01,nng02.nng_file.nng02,nng03.nng_file.nng03,",
               "nng04.nng_file.nng04,nng05.nng_file.nng05,nng06.nng_file.nng06,",
               "nng07.nng_file.nng07,nng081.nng_file.nng081,nng082.nng_file.nng082,",
               "nng09.nng_file.nng09,nng101.nng_file.nng101,nng102.nng_file.nng102,",
               "nng11.nng_file.nng11,nng12.nng_file.nng12,nng13.nng_file.nng13,",
               "nng14.nng_file.nng14,nng15.nng_file.nng15,nng16.nng_file.nng16,",
               "nng17.nng_file.nng17,nng18.nng_file.nng18,nng19.nng_file.nng19,",
               "nngex2.nng_file.nngex2,nng20.nng_file.nng20,nng21.nng_file.nng21,",
               "nng22.nng_file.nng22,nng23.nng_file.nng23,nng52.nng_file.nng52,",
               "nng53.nng_file.nng53,nng54.nng_file.nng54,nng55.nng_file.nng55,",
               "nng56.nng_file.nng56,nng57.nng_file.nng57,nng58.nng_file.nng58,",
               "nng59.nng_file.nng59,nng60.nng_file.nng60,nng61.nng_file.nng61,",
               "nngglno.nng_file.nngglno,alg02.alg_file.alg02,nma02.nma_file.nma02,",
               "nml02.nml_file.nml02,azi04.azi_file.azi04,azi07.azi_file.azi07,",  #FUN-C50007 ADD--nml02
               "sign_type.type_file.chr1,sign_img.type_file.blob,",  # No.FUN-C40020 add
               "sign_show.type_file.chr1,sign_str.type_file.chr1000" # No.FUN-C40020 add
   LET l_table = cl_prt_temptable('anmg723',g_sql) CLIPPED
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add 
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)  #FUN-B50018  add 
      EXIT PROGRAM
   END IF
 
   LET g_sql = "nnf01.nnf_file.nnf01,nnf02.nnf_file.nnf02,nnf03.nnf_file.nnf02,",
               "nnf04f.nnf_file.nnf04f,nnf04.nnf_file.nnf04,nnf05.nnf_file.nnf05,",
               "nnf06.nnf_file.nnf06,nmd02_1.nmd_file.nmd02,nmd12_1.nmd_file.nmd12"
   LET l_table1 = cl_prt_temptable('anmg7231',g_sql) CLIPPED
   IF l_table1 = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)  #FUN-B50018  add
      EXIT PROGRAM
   END IF
 
   LET g_sql = "nnh01.nnh_file.nnh01,nnh02.nnh_file.nnh02,nnh03.nnh_file.nnh03,",
               "nnh04f.nnh_file.nnh04f,nnh04.nnh_file.nnh04,nnh05.nnh_file.nnh05,",
               "nnh06.nnh_file.nnh06,nmd02_2.nmd_file.nmd02,nmd12_2.nmd_file.nmd12"
   LET l_table2 = cl_prt_temptable('anmg7232',g_sql) CLIPPED
   IF l_table2 = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)  #FUN-B50018  add
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
      CALL anmg723_tm(0,0)             # Input print condition
   ELSE
      CALL anmg723()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
END MAIN
 
FUNCTION anmg723_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-680107 SMALLINT
       l_cmd          LIKE type_file.chr1000  #TQC-830031-modify  #No.FUN-680107 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 16
   ELSE LET p_row = 5 LET p_col = 15
   END IF
   OPEN WINDOW anmg723_w AT p_row,p_col
        WITH FORM "anm/42f/anmg723"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.n ='3'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nng01,nng02,nng03
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
      LET INT_FLAG = 0 CLOSE WINDOW anmg723_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
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
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
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
      LET INT_FLAG = 0 CLOSE WINDOW anmg723_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='anmg723'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmg723','9031',1)
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
         CALL cl_cmdat('anmg723',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW anmg723_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmg723()
   ERROR ""
END WHILE
   CLOSE WINDOW anmg723_w
END FUNCTION
 
FUNCTION anmg723()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0082
          l_sql     LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(3000)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(40)
          sr        RECORD LIKE nng_file.*,
          sr1       RECORD LIKE nnh_file.*,
          sr2       RECORD LIKE nmd_file.*
   DEFINE l_nml02   LIKE nml_file.nml02          #FUN-C50007
   #No.FUN-710085 --start--
   DEFINE l_alg02   LIKE alg_file.alg02
   DEFINE l_nma02   LIKE nma_file.nma02
   DEFINE l_nnf     RECORD LIKE nnf_file.*
   DEFINE l_img_blob        LIKE type_file.blob  # No.FUN-C40020 add
  # LOCATE l_img_blob        IN MEMORY            # No.FUN-C40020 add
   DEFINE l_nnh     RECORD LIKE nnh_file.*
   DEFINE l_nmd02_1 LIKE nmd_file.nmd02
   DEFINE l_nmd02_2 LIKE nmd_file.nmd02
   DEFINE l_nmd12_1 LIKE nmd_file.nmd12
   DEFINE l_nmd12_2 LIKE nmd_file.nmd12
   LOCATE l_img_blob        IN MEMORY            # No.FUN-C40020 add 
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)
     CALL cl_del_data(l_table2)
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"  #FUN-C50007 ADD ?
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)  #FUN-B50018  add
        EXIT PROGRAM
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                 " VALUES(?,?,?,?,?, ?,?,?,?)"
     PREPARE insert_prep1 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep1:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)  #FUN-B50018  add
        EXIT PROGRAM
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                 " VALUES(?,?,?,?,?, ?,?,?,?)"
     PREPARE insert_prep2 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep2:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)  #FUN-B50018  add
        EXIT PROGRAM
     END IF
   #No.FUN-710085 --end--
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'anmg723'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#NO.CHI-6A0004--BEGIN
#     SELECT azi03,azi04,azi05
#       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file
#      WHERE azi01=g_aza.aza17
#NO.CHI-6A0004--END
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND nnguser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND nnggrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND nnggrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nnguser', 'nnggrup')
     #End:FUN-980030
 
     #-----------------------mod by evechu 020823----------------------
     
   # LET l_sql="SELECT * FROM nng_file, nnh_file, OUTER nmd_file",
   #           " WHERE nng01=nnh01 ",
   #           "   AND nnh06=nmd_file.nmd01 ",
   #           "   AND nngconf<>'X' AND ",tm.wc CLIPPED
   #
   #FUN-C50007--MOD--STR 
   #  LET l_sql="SELECT * FROM nng_file ",
   #            " WHERE ",tm.wc CLIPPED
     LET l_sql="SELECT nng_file.* , alg02,nma02,nml02 FROM nng_file LEFT OUTER JOIN alg_file ON nng04=alg01 ",
               "  LEFT OUTER JOIN nma_file ON nng05=nma01 LEFT OUTER JOIN nml_file ON nng17=nml01 ",
               " WHERE ",tm.wc CLIPPED 
   #FUN-C50007--MOD--END
     #-----------------------end evechu 020823 -------------------------
     IF tm.n='1' THEN
        LET l_sql=l_sql CLIPPED," AND nngconf='Y' "
     END IF
     IF tm.n='2' THEN
        LET l_sql=l_sql CLIPPED," AND nngconf='N' "
     END IF
     PREPARE anmg723_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
        EXIT PROGRAM 
     END IF
     DECLARE anmg723_curs1 CURSOR FOR anmg723_prepare1

     #FUN-C50007--ADD-STR
     LET l_sql=" SELECT nnf_file.*,nmd02,nmd12 FROM nnf_file LEFT OUTER JOIN nmd_file ON nnf06=nmd01 ",
               "  WHERE nnf01= ? " 
     PREPARE anmg723_prep1 FROM l_sql
     DECLARE t723_t_c CURSOR FOR anmg723_prep1

     
     LET l_sql=" SELECT nnh_file.*,nmd02,nmd12 FROM nnh_file LEFT OUTER JOIN nmd_file ON nnh06=nmd01 ",
               " WHERE nnh01=? "
     PREPARE anmg723_prep2 FROM l_sql
     DECLARE t723_t_c1 CURSOR FOR anmg723_prep2

     
     #FUN-C50007--ADD-END

 
#    CALL cl_outnam('anmg723') RETURNING l_name  #No.FUN-710085 mark
#    START REPORT anmg723_rep TO l_name          #No.FUN-710085 mark
 
     LET g_pageno = 0
     #------------------------mod by evechu 020823-----------------------
     {
     FOREACH anmg723_curs1 INTO sr.*,sr1.*,sr2.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       OUTPUT TO REPORT anmg723_rep(sr.*,sr1.*,sr2.*)
     END FOREACH
     }
    # FOREACH anmg723_curs1 INTO sr.*   #FUN-C50007 MRK
      FOREACH anmg723_curs1 INTO sr.* ,l_alg02,l_nma02,l_nml02    #FUN-C50007 add
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
       #No.FUN-710085 --start--
       IF cl_null(sr.nng55) THEN
          LET sr.nng55 = 0
       END IF
       SELECT azi07 INTO t_azi07
         FROM azi_file
        WHERE azi01=sr.nng18
      #SELECT alg02 INTO l_alg02 FROM alg_file WHERE alg01=sr.nng04  #FUN-C50007 mark
      #SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01=sr.nng05  #FUN-C50007 mark
       IF sr.nng55 > 0 THEN
          #FUN-C50007--MARK--STR
         #DECLARE t723_t_c CURSOR FOR
         # SELECT nnf_file.*,nmd02,nmd12 FROM nnf_file,OUTER nmd_file
         #  WHERE nnf01=sr.nng01
         #    AND nmd_file.nmd01 = nnf_file.nnf06
         # FOREACH t723_t_c INTO l_nnf.*,l_nmd02_1,l_nmd12_1
         #FUN-C50007--MARK--END
           FOREACH t723_t_c USING sr.nng01 INTO l_nnf.*,l_nmd02_1,l_nmd12_1  #FUN-C50007
             IF STATUS THEN EXIT FOREACH END IF
             EXECUTE insert_prep1 USING sr.nng01,l_nnf.nnf02,l_nnf.nnf03,
                                        l_nnf.nnf04f,l_nnf.nnf04,l_nnf.nnf05,
                                        l_nnf.nnf06,l_nmd02_1,l_nmd12_1
          END FOREACH
       ELSE
        ##FUN-C50007--MARK--STR
        # DECLARE t723_t_c1 CURSOR FOR
        #  SELECT nnh_file.*,nmd02,nmd12 FROM nnh_file,OUTER nmd_file
        #   WHERE nnh01=sr.nng01
        #     AND nmd_file.nmd01 = nnh_file.nnh06
        #  FOREACH t723_t_c1 INTO l_nnh.*,l_nmd02_2,l_nmd12_2
        ##FUN-C50007--MARK--end
           FOREACH t723_t_c1 USING sr.nng01 INTO l_nnh.*,l_nmd02_2,l_nmd12_2  
           IF STATUS THEN EXIT FOREACH END IF
             EXECUTE insert_prep2 USING sr.nng01,l_nnh.nnh02,l_nnh.nnh03,
                                        l_nnh.nnh04f,l_nnh.nnh04,l_nnh.nnh05,
                                        l_nnh.nnh06,l_nmd02_2,l_nmd12_2
          END FOREACH
       END IF
 
       EXECUTE insert_prep USING sr.nng01,sr.nng02,sr.nng03,sr.nng04,sr.nng05,
                                 sr.nng06,sr.nng07,sr.nng081,sr.nng082,sr.nng09,
                                 sr.nng101,sr.nng102,sr.nng11,sr.nng12,sr.nng13,
                                 sr.nng14,sr.nng15,sr.nng16,sr.nng17,sr.nng18,
                                 sr.nng19,sr.nngex2,sr.nng20,sr.nng21,sr.nng22,
                                 sr.nng23,sr.nng52,sr.nng53,sr.nng54,sr.nng55,
                                 sr.nng56,sr.nng57,sr.nng58,sr.nng59,sr.nng60,
                                 sr.nng61,sr.nngglno,l_alg02,l_nma02,l_nml02,g_azi04,t_azi07, #FUN-C50007 ADD--l_nml02
                                 "",  l_img_blob,"N",""  # No.FUN-C40020 add
       #No.FUN-710085 --end--
 
#      OUTPUT TO REPORT anmg723_rep(sr.*)        #No.FUN-710085 mark
     END FOREACH
     #-------------------------end evechu 20823---------------------------
#    FINISH REPORT anmg723_rep                   #No.FUN-710085 mark
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len) #No.FUN-710085 mark
 
     #No.FUN-710085 --start--
     CALL cl_wcchp(tm.wc,'nng01,nng02,nng03')
          RETURNING tm.wc
###GENGRE###     LET g_str = tm.wc,";",g_zz05 CLIPPED
###GENGRE###     LET l_sql = "SELECT A.*,B.nnf02,B.nnf03,B.nnf04f,B.nnf04,B.nnf05,B.nnf06,",
###GENGRE###                 "       B.nmd02_1,B.nmd12_1,C.nnh02,C.nnh03,C.nnh04f,C.nnh04,",
###GENGRE###                 "       C.nnh05,C.nnh06,C.nmd02_2,C.nmd12_2",
###GENGRE###   #TQC-730088 # "  FROM ",l_table CLIPPED," A,OUTER ",l_table1 CLIPPED," B,OUTER ",l_table2 CLIPPED," C",
###GENGRE###"  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A ",    
###GENGRE###"  LEFT OUTER JOIN ",g_cr_db_str CLIPPED,l_table1 CLIPPED," B ",    
###GENGRE###"  ON ((A.nng01 = B.nnf01))  ",    
###GENGRE###"  LEFT OUTER JOIN ",g_cr_db_str CLIPPED,l_table2 CLIPPED," C ", 
###GENGRE###"  ON ((A.nng01 = C.nnh01)) "
   # CALL cl_prt_cs3('anmg723',l_sql,g_str)     #TQC-730088
###GENGRE###     CALL cl_prt_cs3('anmg723','anmg723',l_sql,g_str)
    LET g_cr_table = l_table                    # No.FUN-C40020 add
    LET g_cr_apr_key_f = "nng01"                    # No.FUN-C40020 add
    CALL anmg723_grdata()    ###GENGRE###
     #No.FUN-710085 --end--
END FUNCTION
 
#mod by evechu 020823
#REPORT anmg723_rep(sr,sr1,sr2)
#No.FUN-710085 --start-- mark
{REPORT anmg723_rep(sr)
   DEFINE l_last_sw LIKE type_file.chr1,       #No.FUN-680107 VARCHAR(1)
          sr        RECORD LIKE nng_file.*,
          sr1       RECORD LIKE nnh_file.*,
          sr2       RECORD LIKE nmd_file.*,
          l_flag    LIKE type_file.chr1,       #No.FUN-680107 VARCHAR(1)
          t_azi03   LIKE azi_file.azi03,     #NO.CHI-6A0004
          t_azi04   LIKE azi_file.azi04,     #NO.CHI-6A0004
          t_azi05   LIKE azi_file.azi05      #NO.CHI-6A0004
   DEFINE l_alg02   LIKE alg_file.alg02
   DEFINE l_nma02   LIKE nma_file.nma02
   DEFINE l_nmd02   LIKE nmd_file.nmd02
   DEFINE l_nmd12   LIKE nmd_file.nmd12
   DEFINE l_nnh04f  LIKE nnh_file.nnh04f
   DEFINE l_nnh04   LIKE nnh_file.nnh04
   DEFINE l_nnf     RECORD LIKE nnf_file.*
 
  OUTPUT TOP MARGIN 0
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN 6
         PAGE LENGTH g_page_line
 #mod by evechu 020823
 #ORDER BY sr.nng01,sr1.nnh02
  ORDER BY sr.nng01
  FORMAT
   PAGE HEADER
      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
      IF g_towhom IS NULL OR g_towhom = ' '
         THEN PRINT '';
         ELSE PRINT 'TO:',g_towhom;
      END IF
      PRINT ' '
#MOD-590490
      PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1];
#     PRINT (g_len-FGL_WIDTH(g_company))/2 SPACES,g_x[1];
#MOD-590490 End
      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
      PRINT ' '
      LET g_pageno= g_pageno+1
      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
            COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.nng01
      SKIP TO TOP OF PAGE
 
      SELECT azi03,azi04,azi05,azi07
        INTO t_azi03,t_azi04,t_azi05,t_azi07  #NO.CHI-6A0004
        FROM azi_file
       WHERE azi01=sr.nng18
 
        LET l_flag = 'N'
        SELECT alg02 INTO l_alg02 FROM alg_file WHERE alg01=sr.nng04
        SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01=sr.nng05
        PRINT g_x[11] CLIPPED,sr.nng01,COLUMN 40,g_x[12] CLIPPED;
        CASE sr.nng15
            WHEN '1'
                 PRINT g_x[39] CLIPPED
            WHEN '2'
                 PRINT g_x[40] CLIPPED
            WHEN '3'
                 PRINT g_x[41] CLIPPED
        END CASE
        #--add by kitty
        PRINT COLUMN 60,g_x[49] CLIPPED,sr.nng52
        PRINT g_x[13] CLIPPED,sr.nng02,'  ',g_x[14] CLIPPED,sr.nng03,'   ',
              g_x[15] CLIPPED;
#--modi by kitty
#       PRINT g_x[13] CLIPPED,sr.nng02,
#             COLUMN 14,g_x[14] CLIPPED,sr.nng03,
#             COLUMN 40,g_x[15] CLIPPED;
#-- 
        CASE sr.nng12
            WHEN '1'
                 PRINT g_x[42] CLIPPED;
            WHEN '2'
                 PRINT g_x[43] CLIPPED;
        END CASE
        PRINT COLUMN 60,g_x[16] CLIPPED,sr.nng11 USING '<<<<'
        PRINT g_x[17] CLIPPED,sr.nng04,'  ',l_alg02,
              COLUMN 40,g_x[18] CLIPPED,sr.nng09,g_x[48] CLIPPED,
              COLUMN 60,g_x[19] CLIPPED,sr.nng13 USING '#&'
#---modi by kitty
#       PRINT COLUMN 67,g_x[16] CLIPPED,sr.nng11 USING '<<<<'
 
#       PRINT g_x[17] CLIPPED,sr.nng04,'  ',l_alg02,
#             COLUMN 40,g_x[18] CLIPPED,sr.nng09,g_x[48] CLIPPED,
#             COLUMN 56,g_x[19] CLIPPED,sr.nng13 USING '#&'
#--- 
      # Joan 020903 -------------------------------------------------------*
      # PRINT g_x[20] CLIPPED,sr.nng05[1,6],'  ',l_nma02,' ',sr.nng051,'   ',
      #       g_x[21] CLIPPED;
        PRINT g_x[20] CLIPPED,sr.nng05[1,10],COLUMN 20,l_nma02 CLIPPED,
              COLUMN 40,g_x[21] CLIPPED;
      # Joan 020903 end ---------------------------------------------------*
        CASE sr.nng14
            WHEN '1'
                 PRINT g_x[44] CLIPPED;
            WHEN '2'
                 PRINT g_x[45] CLIPPED;
        END CASE
        PRINT COLUMN 60,g_x[50] CLIPPED, sr.nng53 USING '###.###','%'
        PRINT g_x[22] CLIPPED,sr.nng06,COLUMN 40,g_x[23] CLIPPED;
        CASE sr.nng16
            WHEN '1'
                 PRINT g_x[46] CLIPPED;
            WHEN '2'
                 PRINT g_x[47] CLIPPED;
        END CASE
# evechu 020627先判斷IF 存入銀行=null ,THEN 實際入帳金額= 0 --------------------
#                    IF 存入銀行<>null ,依他保銀行決定實際入帳金額
        #PRINT COLUMN 60,g_x[51] CLIPPED
        IF NOT cl_null(sr.nng05) THEN
           IF NOT cl_null(sr.nng54) THEN
              PRINT COLUMN 60,g_x[51] CLIPPED,
	            COLUMN 73,cl_numfor(sr.nng22-sr.nng55-sr.nng59-sr.nng61,18,g_azi04)
           ELSE
              PRINT COLUMN 60,g_x[51] CLIPPED,
	    	    COLUMN 73,cl_numfor(sr.nng22-sr.nng55-sr.nng57-sr.nng59-sr.nng61,18,g_azi04)
           END IF
        ELSE
           PRINT COLUMN 60,g_x[51] CLIPPED,'    0'
        END IF
#end evechu 020823-------------------------------------------------------------
        PRINT g_x[24] CLIPPED,sr.nng081,' - ',sr.nng082,
              COLUMN 40,g_x[25] CLIPPED,sr.nng17,
              COLUMN 60,g_x[52] CLIPPED,sr.nng54
 
        PRINT g_x[26] CLIPPED,sr.nng101,' - ',sr.nng102,
              COLUMN 40,g_x[27] CLIPPED,sr.nng07
 
        PRINT g_x[28] CLIPPED,COLUMN 10,sr.nng18,COLUMN 20,cl_numfor(sr.nng19,10,t_azi07),
              COLUMN 40,g_x[29] CLIPPED,COLUMN 45,cl_numfor(sr.nngex2,10,t_azi07),
              COLUMN 60,g_x[30] CLIPPED,sr.nngglno
 
      # Joan 020903 -------------------------------------------------*
#        
#       PRINT g_x[31] CLIPPED,cl_numfor(sr.nng20,11,g_azi04),' ',
#             g_x[32] CLIPPED,cl_numfor(sr.nng22,11,g_azi04),' Dr:',
#             sr.nng_d1[1,10],'  Cr:',sr.nng_c1[1,10]
#       PRINT '    ',g_x[33] CLIPPED,cl_numfor(sr.nng21,11,g_azi04),5 SPACES,
#             g_x[33] CLIPPED,cl_numfor(sr.nng23,11,g_azi04),'    ',
#             sr.nng_d2[1,10],'     ',sr.nng_c2[1,10]
#        
        PRINT g_x[31] CLIPPED,COLUMN 10,cl_numfor(sr.nng20,18,g_azi04),
              COLUMN 40,g_x[32] CLIPPED,COLUMN 49,cl_numfor(sr.nng22,18,g_azi04)
        PRINT COLUMN 5,g_x[33] CLIPPED,COLUMN 10,cl_numfor(sr.nng21,18,g_azi04),
              COLUMN 40,g_x[33] CLIPPED,COLUMN 49,cl_numfor(sr.nng23,18,g_azi04)
      # Joan020903 end ----------------------------------------------*
         PRINT g_x[53] CLIPPED,COLUMN 10,cl_numfor(sr.nng55,18,g_azi04),
               COLUMN 40, g_x[54] CLIPPED,sr.nng56,'%',
               COLUMN 60, g_x[55] CLIPPED,COLUMN 69,cl_numfor(sr.nng57,18,g_azi04)
         PRINT COLUMN 40, g_x[56] CLIPPED,sr.nng58,'%',
               COLUMN 60, g_x[57] CLIPPED,COLUMN 69,cl_numfor(sr.nng59,18,g_azi04)
         PRINT COLUMN 40, g_x[58] CLIPPED,sr.nng60,'%',
               COLUMN 60, g_x[59] CLIPPED,COLUMN 69,cl_numfor(sr.nng61,18,g_azi04)
         PRINT g_x[34] ,g_x[35]
         #FUN-5A0180-begin
         #PRINT COLUMN 1,g_x[36] ,COLUMN 59,g_x[37]
         #PRINT '----',
         #      COLUMN 7,'--------',
         #      COLUMN 17,'-------------------',
         #      COLUMN 38,'-------------------',
         #      COLUMN 59,'--------',
         #      COLUMN 69,'----------------',   #No.FUN-550057加長6格
         #      COLUMN 87,'----------',
         #      COLUMN 98,'----'
          PRINT COLUMN  1, g_x[60],
                COLUMN  7, g_x[61],
                COLUMN 16, g_x[62],
                COLUMN 35, g_x[63],
                COLUMN 54, g_x[64],
                COLUMN 66, g_x[65],
                COLUMN 83, g_x[66],
                COLUMN 94, g_x[67]
         PRINT '----',
                COLUMN  7,'--------',
                COLUMN 16,'------------------',
                COLUMN 35,'------------------',
                COLUMN 54,'-----------',
                COLUMN 63,'----------------',   #No.FUN-550057加長6格
                COLUMN 83,'----------',
                COLUMN 94,'----'
         #FUN-5A0180-end
	 #i--------------------mod by evechu 020823---------------------
#         
#        IF sr.nng55 > 0 THEN
#           DECLARE t723_t_c CURSOR FOR
#            SELECT nnf.*,nmd02,nmd12 FROM nnf_file, nmd_file
#             WHERE nnf01=sr.nng01
#               AND nmd_file.nmd01 = nnf_file.nnf06
#           FOREACH t723_t_c INTO l_nnf.*
#             PRINT COLUMN 01,l_nnf.nnf02 USING '###&',    #No.FUN-570177
#                   COLUMN  7,l_nnf.nnf03,
#                   COLUMN 17,cl_numfor(l_nnf.nnf04f,18,g_azi04),
#                   COLUMN 38,cl_numfor(l_nnf.nnf04,18,g_azi04),
#                   COLUMN 59,l_nnf.nnf05[1,6],
#                   COLUMN 69,l_nnf.nnf06,
#                   COLUMN 81,l_nmd02,
#                   COLUMN 92,l_nmd12
#           END FOREACH
#        END IF
#         
         #------------------------end evecdhu 020823---------------------
 
   ON EVERY ROW
#         #---------------------mod by evechu 020823---------------------
#        IF sr.nng55 = 0 THEN
#           PRINT COLUMN 01,sr1.nnh02 USING '###&','  ',sr1.nnh03,' ',  #No.FUN-570177
#                 cl_numfor(sr1.nnh04f,12,g_azi04),' ',
#                 cl_numfor(sr1.nnh04,12,g_azi04),'  ',
#                 sr1.nnh05[1,6],'   ',sr1.nnh06,'  ',sr2.nmd02,'  ',
#                 sr2.nmd12
#        END IF
#         #------------------------end evechu 020823---------------------
         IF sr.nng55 > 0 THEN
            DECLARE t723_t_c CURSOR FOR
             SELECT nnf_file.*,nmd02,nmd12 FROM nnf_file,OUTER nmd_file
              WHERE nnf01=sr.nng01
                AND nmd_file.nmd01 = nnf_file.nnf06
# Thomas 020903
            FOREACH t723_t_c INTO l_nnf.*,l_nmd02,l_nmd12
            #FUN-5A0170-begin
              #PRINT COLUMN 01,l_nnf.nnf02 USING '###&',    #No.FUN-570177
              #      COLUMN 7,l_nnf.nnf03,
              #      COLUMN 17,cl_numfor(l_nnf.nnf04f,18,g_azi04),
                # Joan 020903 -------------------------------------------*
                # cl_numfor(l_nnf.nnf04,12,g_azi04),'  ',
                # l_nnf.nnf05[1,6],'   ',l_nnf.nnf06,'  ',l_nmd02,'  ',
              #    COLUMN 38,cl_numfor(l_nnf.nnf04,18,g_azi04),
              #    COLUMN 59,l_nnf.nnf05[1,10],
              #    COLUMN 69,l_nnf.nnf06,
#No.FUN-550057 --start--
              #    COLUMN 87,l_nmd02,
              #    COLUMN 98,l_nmd12
#No.FUN-550057 ---end--
              PRINT COLUMN 01,l_nnf.nnf02 USING '###&',
                    COLUMN  7,l_nnf.nnf03,
                    COLUMN 16,cl_numfor(l_nnf.nnf04f,17,g_azi04),
                    COLUMN 35,cl_numfor(l_nnf.nnf04,17,g_azi04),
                    COLUMN 54,l_nnf.nnf05,
                    COLUMN 66,l_nnf.nnf06,
                    COLUMN 83,l_nmd02,
                    COLUMN 94,l_nmd12
            #FUN-5A0170-end
                # Joan 020903 end ---------------------------------------*
            END FOREACH
	 ELSE
            DECLARE t723_t_c1 CURSOR FOR
             SELECT * FROM nnh_file, OUTER nmd_file
              WHERE nnh01=sr.nng01
                AND nmd_file.nmd01 = nnh_file.nnh06
            FOREACH t723_t_c1 INTO sr1.*,sr2.*
               #FUN-5A0180-begin
               #PRINT COLUMN 01,sr1.nnh02 USING '###&', #No.FUN-570177
               #      COLUMN  7,sr1.nnh03,
               #      COLUMN 17,cl_numfor(sr1.nnh04f,18,g_azi04),
               #      COLUMN 38,cl_numfor(sr1.nnh04,18,g_azi04),
               #      COLUMN 59,sr1.nnh05[1,6],
               #      COLUMN 69,sr1.nnh06,
#No.FUN-550057 --start--
               #      COLUMN 87,sr2.nmd02,
               #      COLUMN 98,sr2.nmd12
#No.FUN-550057 ---end--
               PRINT COLUMN 01,sr1.nnh02 USING '###&', #No.FUN-570177
                     COLUMN  7,sr1.nnh03,
                     COLUMN 16,cl_numfor(sr1.nnh04f,17,g_azi04),
                     COLUMN 35,cl_numfor(sr1.nnh04,17,g_azi04),
                     COLUMN 54,sr1.nnh05,
                     COLUMN 66,sr1.nnh06,
                     COLUMN 83,sr2.nmd02,
                     COLUMN 94,sr2.nmd12
               #FUN-5A0180-end
            END FOREACH
         END IF
 
   AFTER GROUP OF sr.nng01
      PRINT ''
#--modi by kitty
#     PRINT g_x[38] CLIPPED,6 SPACES,
#           cl_numfor(GROUP SUM(sr1.nnh04f),15,t_azi04),' ',  #NO.CHI-6A0004
#           cl_numfor(GROUP SUM(sr1.nnh04),15,g_azi04)
#--- 
      IF sr.nng55 > 0 THEN
         SELECT sum(nnf04f),sum(nnf04) INTO l_nnf.nnf04f,l_nnf.nnf04
           FROM nnf_file
          WHERE nnf01=sr.nng01
      PRINT g_x[38] CLIPPED,
            COLUMN 16,cl_numfor(l_nnf.nnf04f,17,g_azi04),
            COLUMN 35,cl_numfor(l_nnf.nnf04, 17,g_azi04)
      ELSE
         SELECT sum(nnh04f),sum(nnh04) INTO l_nnh04f,l_nnh04
           FROM nnh_file
          WHERE nnh01=sr.nng01
      PRINT g_x[38] CLIPPED,
            COLUMN 16,cl_numfor(l_nnh04f,17,g_azi04),
            COLUMN 35,cl_numfor(l_nnh04 ,17,g_azi04)
      END IF
      PRINT g_dash[1,g_len]
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
#Patch....NO.TQC-610036 <001,002,003> #

###GENGRE###START
FUNCTION anmg723_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE sr2      sr2_t
    DEFINE sr3      sr3_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    LOCATE sr1.sign_img IN MEMORY      # No.FUN-C40020 add
    CALL cl_gre_init_apr()             # No.FUN-C40020 add
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("anmg723")
        IF handler IS NOT NULL THEN
            START REPORT anmg723_rep TO XML HANDLER handler
           #LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  #FUN-B50018 mark
         
            #FUN-B50018------add------str-------
            LET l_sql = "SELECT A.*,B.*,C.* FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A LEFT OUTER JOIN ",
                         g_cr_db_str CLIPPED,l_table1 CLIPPED," B ON (B.nnf01 = A.nng01) LEFT OUTER JOIN ",
                         g_cr_db_str CLIPPED,l_table2 CLIPPED," C ON (C.nnh01 = A.nng01)",
                         " ORDER BY nng01,nnh02" 
            #FUN-B50018------end------str------- 
          
            DECLARE anmg723_datacur1 CURSOR FROM l_sql
            FOREACH anmg723_datacur1 INTO sr1.*,sr2.*,sr3.*
                OUTPUT TO REPORT anmg723_rep(sr1.*,sr2.*,sr3.*)
            END FOREACH
            FINISH REPORT anmg723_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT anmg723_rep(sr1,sr2,sr3)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE sr3 sr3_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B50018----add-----str-----------------
    DEFINE sr1_t sr1_t
    DEFINE l_nng04_alg02       STRING
    DEFINE l_nng05_nma02       STRING
    DEFINE l_nng081_nng082     STRING
    DEFINE l_nng101_nng102     STRING
    DEFINE l_nng101            STRING
    DEFINE l_nng102            STRING
    DEFINE l_nng12             STRING
    DEFINE l_nng14             STRING
    DEFINE l_nng15             STRING
    DEFINE l_nng16             STRING
    DEFINE l_nng18_nng19       STRING
    DEFINE l_nng19             STRING
    DEFINE l_nng081            STRING
    DEFINE l_nng082            STRING
    DEFINE l_nng22_nng61       LIKE  nng_file.nng22
    DEFINE l_nng22_nng61_2     LIKE  nng_file.nng22
    DEFINE l_display1          STRING
    DEFINE l_display2          STRING
    DEFINE l_display3          STRING
    DEFINE l_display4          STRING
    DEFINE l_sql               STRING
    DEFINE l_nnh04f_sum        LIKE  nnh_file.nnh04f
    DEFINE l_nnh04_sum         LIKE  nnh_file.nnh04
    DEFINE l_nnf04f_sum        LIKE  nnf_file.nnf04f
    DEFINE l_nnf04_sum         LIKE  nnf_file.nnf04
    DEFINE l_nng22_nng61_fmt   STRING
    DEFINE l_nng22_nng61_2_fmt STRING
    DEFINE l_nng19_fmt         STRING
    DEFINE l_nngex2_fmt        STRING
    DEFINE l_nng20_fmt         STRING
    DEFINE l_nng21_fmt         STRING
    DEFINE l_nng22_fmt         STRING
    DEFINE l_nng23_fmt         STRING
    DEFINE l_nng55_fmt         STRING
    DEFINE l_nng57_fmt         STRING
    DEFINE l_nng59_fmt         STRING
    DEFINE l_nng61_fmt         STRING
    DEFINE l_nnh04f_fmt        STRING
    DEFINE l_nnh04_fmt         STRING
    DEFINE l_nnh04f_sum_fmt    STRING
    DEFINE l_nnh04_sum_fmt     STRING
    DEFINE l_nnf04f_fmt        STRING
    DEFINE l_nnf04_fmt         STRING
    DEFINE l_nnf04f_sum_fmt    STRING
    DEFINE l_nnf04_sum_fmt     STRING
    #FUN-B50018----add-----end-----------------
    DEFINE l_nng17_nml02       STRING  #FUN-C50007 ADD
    
    ORDER EXTERNAL BY sr1.nng01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
            LET sr1_t.nng01 = NULL
  
        BEFORE GROUP OF sr1.nng01
            LET l_lineno = 0

            #FUN-B50018----add-----str-----------------
            LET l_nng22_nng61_fmt = cl_gr_numfmt('nng_file','nng22',g_azi04)
            PRINTX l_nng22_nng61_fmt
            LET l_nng22_nng61_2_fmt = cl_gr_numfmt('nng_file','nng22',g_azi04)
            PRINTX l_nng22_nng61_2_fmt
            LET l_nng19_fmt = cl_gr_numfmt('nng_file','nng19',sr1.azi07)
            PRINTX l_nng19_fmt
           #LET l_nngex2_fmt = cl_gr_numfmt('nng_file','ngex2',sr1.azi07)  #FUN-C30085 mark
            LET l_nngex2_fmt = cl_gr_numfmt('nng_file','nngex2',sr1.azi07) #FUN-C30085 add
            PRINTX l_nngex2_fmt
            LET l_nng20_fmt = cl_gr_numfmt('nng_file','nng20',g_azi04)
            PRINTX l_nng20_fmt
            LET l_nng55_fmt = cl_gr_numfmt('nng_file','nng55',g_azi04)
            PRINTX l_nng55_fmt
            LET l_nng21_fmt = cl_gr_numfmt('nng_file','nng21',g_azi04)
            PRINTX l_nng21_fmt
            LET l_nng22_fmt = cl_gr_numfmt('nng_file','nng22',g_azi04)
            PRINTX l_nng22_fmt
            LET l_nng23_fmt = cl_gr_numfmt('nng_file','nng23',g_azi04)
            PRINTX l_nng23_fmt
            LET l_nng57_fmt = cl_gr_numfmt('nng_file','nng57',g_azi04)
            PRINTX l_nng57_fmt
            LET l_nng59_fmt = cl_gr_numfmt('nng_file','nng59',g_azi04)
            PRINTX l_nng59_fmt
            LET l_nng61_fmt = cl_gr_numfmt('nng_file','nng61',g_azi04)
            PRINTX l_nng61_fmt
            LET l_nnh04f_fmt = cl_gr_numfmt('nnh_file','nnh04f',g_azi04)
            PRINTX l_nnh04f_fmt
            LET l_nnh04_fmt = cl_gr_numfmt('nnh_file','nnh04',g_azi04)
            PRINTX l_nnh04_fmt
            LET l_nnh04f_sum_fmt = cl_gr_numfmt('nnh_file','nnh04f',sr1.azi04)
            PRINTX l_nnh04f_sum_fmt
            LET l_nnh04_sum_fmt = cl_gr_numfmt('nnh_file','nnh04',sr1.azi04)
            PRINTX l_nnh04_sum_fmt
            LET l_nnf04f_fmt = cl_gr_numfmt('nnf_file','nnf04f',sr1.azi04)
            PRINTX l_nnf04f_fmt
            LET l_nnf04_fmt = cl_gr_numfmt('nnf_file','nnf04',sr1.azi04)
            PRINTX l_nnf04_fmt
            LET l_nnf04f_sum_fmt = cl_gr_numfmt('nnf_file','nnf04f',sr1.azi04)
            PRINTX l_nnf04f_sum_fmt
            LET l_nnf04_sum_fmt = cl_gr_numfmt('nnf_file','nnf04',sr1.azi04)
            PRINTX l_nnf04_sum_fmt

            LET l_nng04_alg02 = sr1.nng04,' ',sr1.alg02
            PRINTX  l_nng04_alg02



            LET l_nng05_nma02 = sr1.nng05,' ',sr1.nma02
            PRINTX  l_nng05_nma02
            LET l_nng04_alg02 = sr1.nng04,' ',sr1.alg02
            PRINTX  l_nng04_alg02


            LET l_nng05_nma02 = sr1.nng05,' ',sr1.nma02
            PRINTX  l_nng05_nma02


            LET l_nng081 = sr1.nng081
            LET l_nng082 = sr1.nng082
            IF NOT cl_null(l_nng081) AND NOT cl_null(l_nng082) THEN  #FUN-C20052
               LET l_nng081_nng082 = l_nng081,'-',l_nng082
            END IF  #FUN-C20052
            PRINTX  l_nng081_nng082

            LET l_nng101 = sr1.nng101
            LET l_nng102 = sr1.nng102
            IF NOT cl_null(l_nng101) AND NOT cl_null(l_nng102) THEN  #FUN-C20052
               LET l_nng101_nng102 = l_nng101,'-',l_nng102
            END IF   #FUN-C20052
            PRINTX  l_nng101_nng102

            LET   l_nng12 = cl_gr_getmsg("gre-043",g_lang,sr1.nng12)
            PRINTX l_nng12

            LET   l_nng14 = cl_gr_getmsg("gre-044",g_lang,sr1.nng14)
            PRINTX l_nng14


            LET   l_nng15 = cl_gr_getmsg("gre-045",g_lang,sr1.nng15)
            PRINTX l_nng15

            LET   l_nng16 = cl_gr_getmsg("gre-046",g_lang,sr1.nng16)
            PRINTX l_nng16

            LET l_nng17_nml02 = sr1.nng17,' ',sr1.nml02     #FUN-C50007 add
            PRINTX l_nng17_nml02                            #FUN-C50007 add
                                                               
            LET l_nng19 = sr1.nng19
            LET l_nng18_nng19 = sr1.nng18,' ',l_nng19
            PRINTX  l_nng18_nng19


            LET l_nng22_nng61 = sr1.nng22 - sr1.nng55 - sr1.nng59 - sr1.nng61
            PRINTX  l_nng22_nng61

            LET l_nng22_nng61_2 = sr1.nng22 - sr1.nng55 - sr1.nng57 - sr1.nng59 - sr1.nng61
            PRINTX  l_nng22_nng61_2

            IF NOT cl_null(sr1_t.nng01) THEN
               IF sr1_t.nng01 != sr1.nng01 THEN
                  LET l_display1 = 'Y'
               ELSE
                  LET l_display1 = 'N'
               END IF
            ELSE 
               LET l_display1 = 'Y'
            END IF 
            PRINTX l_display1

            
            IF (sr1_t.nng01 != sr1.nng01 OR cl_null(sr1_t.nng01)) AND NOT cl_null(sr1.nng05) AND NOT cl_null(sr1.nng54)  THEN
               LET l_display2 = 'Y'
            ELSE
               LET l_display2 = 'N'
            END IF
            PRINTX l_display2

            IF (sr1_t.nng01 != sr1.nng01 OR cl_null(sr1_t.nng01)) AND NOT cl_null(sr1.nng05) AND cl_null(sr1.nng54)  THEN
               LET l_display3 = 'Y'
            ELSE
               LET l_display3 = 'N'
            END IF
            PRINTX l_display3

            IF (sr1_t.nng01 != sr1.nng01 OR cl_null(sr1_t.nng01)) AND cl_null(sr1.nng05) THEN
               LET l_display4 = 'Y'
            ELSE
               LET l_display4 = 'N'
            END IF
            PRINTX l_display4
            LET sr1_t.* = sr1.*
            #FUN-B50018----add-----end-----------------
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            #FUN-B50018----add-----str-----------------
#           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
#                       " WHERE nnf01 = '",sr1.nng01 CLIPPED,"'"

#           DECLARE anmg723_datacur2 CURSOR FROM l_sql
#           FOREACH anmg723_datacur2 INTO sr2.*
#           END FOREACH

#            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
#                        " WHERE nnh01 = '",sr1.nng01 CLIPPED,"'"

#           DECLARE anmg723_datacur3 CURSOR FROM l_sql
#           FOREACH anmg723_datacur3 INTO sr3.*
#           END FOREACH

            PRINTX sr2.*
            PRINTX sr3.*    
            #FUN-B50018----add-----end-----------------

            PRINTX sr1.*

        AFTER GROUP OF sr1.nng01
            #FUN-B50018----add-----str-----------------
            LET    l_nnh04_sum = GROUP SUM(sr3.nnh04)
            PRINTX l_nnh04_sum
            
            LET    l_nnh04f_sum = GROUP SUM(sr3.nnh04f)
            PRINTX l_nnh04f_sum

                       
            LET    l_nnf04_sum = GROUP SUM(sr2.nnf04)
            PRINTX l_nnf04_sum
 
            LET    l_nnf04f_sum = GROUP SUM(sr2.nnf04f)
            PRINTX l_nnf04f_sum
            #FUN-B50018----add-----end-----------------
     
        ON LAST ROW

END REPORT
###GENGRE###END
