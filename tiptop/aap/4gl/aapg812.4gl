# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapg812.4gl
# Descriptions...: 到貨通知單
# Date & Author..: 98/09/01  By Gunter
# Modify.........: No.FUN-550030 05/05/18 By ice 單據編號欄位放大
# Modify.........: No.FUN-550099 05/05/25 By echo 新增報表備註
# Modify.........: No.FUN-580010 05/08/02 By yoyo 憑証類報表原則修改
# Modify.........: No.FUN-5B0007 05/11/24 By Smapmin 報表缺少規格欄位
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.TQC-610053 06/07/03 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/30 By hellen 本原幣取位修改
# Modify.........: No.TQC-6B0128 06/12/06 By xufeng 修改報表
# Modify.........: NO.FUN-710029 07/01/16 By Yiting 外購多單位
# Modify.........: No.FUN-710086 07/02/07 By Rayven 報表輸出至Crystal Reports功能
# Modidy.........: NO.TQC-730088 07/03/22 By Nicole 增加CR參數
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60056 10/06/22 By lutingting GP5.2財務串前段問題整批調整 
# Modify.........: No.FUN-B40087 11/05/04 By yangtt  憑證報表轉GRW
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.FUN-B90058 11/09/06 By yangtt 程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題
# Modify.........: No.FUN-C10036 12/01/11 By qirl MOD-B80108追單
# Modify.........: No.FUN-C10036 12/01/16 By xuxz 程序規範修改
# Modify.........: No.FUN-C40019 12/04/09 By yangtt GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C50003 12/05/02 By yangtt GR程式優化
# Modify.........: No.FUN-C30085 12/06/25 By nanbing 新增付款條件、價格條件欄位說明
# Modify.........: No.FUN-CB0058 12/11/28 By yangtt 【單位註釋】動態顯示  
# Modify.........: No.CHI-C80041 12/12/19 By bart 排除作廢
     
DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE g_dash3     LIKE type_file.chr1000     # No.FUN-690028 VARCHAR(400)          #No.FUN-580010
   DEFINE tm  RECORD                   # Print condition RECORD
              wc      LIKE type_file.chr1000,      # Where condition  #No.FUN-690028 VARCHAR(600)
              price   LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1),         #
              more    LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)          # Input more condition(Y/N)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(72)
DEFINE   g_sma116    LIKE sma_file.sma116      #FUN-710029
DEFINE   g_sma115    LIKE sma_file.sma115      #FUN-710029
DEFINE   l_table     STRING                    #No.FUN-710086
DEFINE   g_sql       STRING                    #No.FUN-710086
DEFINE   g_str       STRING                    #No.FUN-710086

###GENGRE###START
TYPE sr1_t RECORD
    alk05 LIKE alk_file.alk05,
    ala03 LIKE ala_file.ala03,
    ala36 LIKE ala_file.ala36,
    ale05 LIKE ale_file.ale05,
    ale06 LIKE ale_file.ale06,
    ale07 LIKE ale_file.ale07,
    ale11 LIKE ale_file.ale11,
    ale14 LIKE ale_file.ale14,
    ale16 LIKE ale_file.ale16,
    alk01 LIKE alk_file.alk01,
    alk02 LIKE alk_file.alk02,
    alk12 LIKE alk_file.alk12,
    als03 LIKE als_file.als03,
    als04 LIKE als_file.als04,
    als06 LIKE als_file.als06,
   #als07 LIKE als_file.als07,  #FUN-C10036 MARK (MOD-B80108)
    alk46 LIKE alk_file.alk46,  #FUN-C10036 ADD (MOD-B80108)
    als08 LIKE als_file.als08,
    als09 LIKE als_file.als09,
    als10 LIKE als_file.als10,
    als11 LIKE als_file.als11,
    als14 LIKE als_file.als14,
    als21 LIKE als_file.als21,
    als31 LIKE als_file.als31,
    als32 LIKE als_file.als32,
    als33 LIKE als_file.als33,
    als34 LIKE als_file.als34,
    als35 LIKE als_file.als35,
    als36 LIKE als_file.als36,
    alt06 LIKE alt_file.alt06,
    aza17 LIKE aza_file.aza17,
    ima021 LIKE ima_file.ima021,
    pmc03_1 LIKE pmc_file.pmc03,
    pmc03_2 LIKE pmc_file.pmc03,
    pmn041 LIKE pmn_file.pmn041,
    ale86 LIKE ale_file.ale86,
    ale87 LIKE ale_file.ale87,
    str LIKE type_file.chr1000,
    azi03 LIKE azi_file.azi03,
    azi04 LIKE azi_file.azi04,
    azi05 LIKE azi_file.azi05,
    azi07 LIKE azi_file.azi07,
    azi04_1 LIKE azi_file.azi04,
    sign_type LIKE type_file.chr1,     #FUN-C40019 add
    sign_img LIKE type_file.blob,      #FUN-C40019 add
    sign_show LIKE type_file.chr1,     #FUN-C40019 add
    sign_str LIKE type_file.chr1000    #FUN-C40019 add
    ,l_als10 LIKE pma_file.pma02, #FUN-C30085 add
    l_ala36  LIKE pnz_file.pnz02  #FUN-C30085 add
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055  #FUN-BB0047 mark
 
   #No.FUN-710086 --start--
   LET g_sql = "alk05.alk_file.alk05,ala03.ala_file.ala03,ala36.ala_file.ala36,",
               "ale05.ale_file.ale05,ale06.ale_file.ale06,ale07.ale_file.ale07,",
               "ale11.ale_file.ale11,ale14.ale_file.ale14,ale16.ale_file.ale16,",
               "alk01.alk_file.alk01,alk02.alk_file.alk02,alk12.alk_file.alk12,",
               "als03.als_file.als03,als04.als_file.als04,als06.als_file.als06,",
              #"als07.als_file.als07,als08.als_file.als08,als09.als_file.als09,",   #No.FUN-C10036 mark
               "alk46.alk_file.alk46,als08.als_file.als08,als09.als_file.als09,",   #No.FUN-C10036 add
               "als10.als_file.als10,als11.als_file.als11,als14.als_file.als14,",
               "als21.als_file.als21,als31.als_file.als31,als32.als_file.als32,",
               "als33.als_file.als33,als34.als_file.als34,als35.als_file.als35,",
               "als36.als_file.als36,alt06.alt_file.alt06,aza17.aza_file.aza17,",
               "ima021.ima_file.ima021,pmc03_1.pmc_file.pmc03,pmc03_2.pmc_file.pmc03,",
               "pmn041.pmn_file.pmn041,ale86.ale_file.ale86,ale87.ale_file.ale87,",
               "str.type_file.chr1000,azi03.azi_file.azi03,azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,azi07.azi_file.azi07,azi04_1.azi_file.azi04,",
               "sign_type.type_file.chr1,   sign_img.type_file.blob,",   #簽核方式, 簽核圖檔  #FUN-C40019 add
               "sign_show.type_file.chr1,  sign_str.type_file.chr1000"                        #FUN-C40019 add 
               ,",l_als10.pma_file.pma02,l_ala36.pnz_file.pnz02"#FUN-C30085 add
   LET l_table = cl_prt_temptable('aapg812',g_sql) CLIPPED
   IF l_table = -1 THEN 
      #CALL  cl_used(g_prog,g_time,2) RETURNING g_time        #FUN-B80105  #FUN-BB0047 mark
      #CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087#FUN-C10036 mark
      EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ? ,?,?)"   #FUN-C40019 add 4? #FUN-C30085 add 2?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      #CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80105
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B40087  #FUN-BB0047 mark
      #CALL cl_gre_drop_temptable(l_table)                #FUN-B40087#FUN-C10036 mark
      EXIT PROGRAM
   END IF
   #No.FUN-710086 --end--
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   LET tm.price = 'Y'
   LET g_pdate = ARG_VAL(1)            # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.price = ARG_VAL(8)   #TQC-610053
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file #FUN-710029
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL g812_tm(0,0)        # Input print condition
      ELSE CALL g812()              # Read data and create out-file
   END IF
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time        #FUN-B80105
   CALL cl_gre_drop_temptable(l_table)          #FUN-B90058  add
END MAIN
 
FUNCTION g812_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   LET p_row = 2 LET p_col = 5
   OPEN WINDOW g812_w AT p_row,p_col
     WITH FORM "aap/42f/aapg812"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET tm.price = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc  ON alk01,alk02
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
      LET INT_FLAG = 0
      CLOSE WINDOW g812_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.price,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
 
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW g812_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aapg812'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aapg812','9031',1)
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
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.price CLIPPED,"'",   #TQC-610053
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
         CALL cl_cmdat('aapg812',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW g812_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL g812()
   ERROR ""
END WHILE
   CLOSE WINDOW g812_w
END FUNCTION
 
FUNCTION g812()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#         l_time    LIKE type_file.chr8,           # Used time for running the job  #No.FUN-690028 VARCHAR(8)
          l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT  #No.FUN-690028 VARCHAR(1200)
          l_za05    LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE faj_file.faj02,      # No.FUN-690028 VARCHAR(10),
          l_pma02  LIKE pma_file.pma02,         #FUN-C30085 mod pma02->l_pma02
          alk	RECORD LIKE alk_file.*,
          ale	RECORD LIKE ale_file.*,
          ala	RECORD LIKE ala_file.*,
          als	RECORD LIKE als_file.*,
          sr   RECORD
               pmc03 LIKE pmc_file.pmc03, # 廠商簡稱
               pmn041 LIKE pmn_file.pmn041,
               alt06 LIKE alt_file.alt06,
               alg02 LIKE alg_file.alg02,
               alh08 LIKE alh_file.alh08,
               pmn20 LIKE pmn_file.pmn20,  #FUN-710029
               pmn07 LIKE pmn_file.pmn07   #FUN-710029
              END RECORD
 
   #No.FUN-710086 --start--
   DEFINE l_pmc03      LIKE pmc_file.pmc03
   DEFINE l_ima021     LIKE ima_file.ima021
   DEFINE l_str2       LIKE type_file.chr1000
   DEFINE l_ima906     LIKE ima_file.ima906
   DEFINE l_ale85      LIKE ale_file.ale85
   DEFINE l_ale82      LIKE ale_file.ale82
   DEFINE l_pmn20      LIKE pmn_file.pmn20
   #No.FUN-710086 --end--
   DEFINE l_img_blob     LIKE type_file.blob     #FUN-C40019 add
   #FUN-C30085 --start--
   DEFINE l_als10 LIKE pma_file.pma02
   DEFINE l_ala36 LIKE pnz_file.pnz02
   #FUN-C30085 --end--
     CALL cl_del_data(l_table)  #No.FUN-710086
 
#      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-580010--start
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aapg812'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#    FOR g_i = 1 TO g_len LET g_dash1[g_i,g_i] = '-' END FOR
     FOR g_i = 1 TO g_len LET g_dash3[g_i,g_i] = '-' END FOR
#No.FUN-580010--end
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND alsuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND alsgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND alsgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('alsuser', 'alsgrup')
     #End:FUN-980030

     LOCATE l_img_blob    IN MEMORY                #FUN-C40019 add 

#    LET l_sql= "SELECT alk_file.*,ale_file.*,ala_file.*,",
     LET l_sql= "SELECT alk_file.*,ale_file.*,ala_file.*,als_file.*,",
               #"       pmc03,pmn041,0,alg02,alh08,pmn20,pmn07 ",  #FUN-710029 add pmn20/pmn07   #FUN-A60056
                "       pmc03,'',0,alg02,alh08,'','' ",  #FUN-A60056
                "       ,azi03,azi04,azi05,azi07 ",   #FUN-C50003 add
                 " FROM alk_file LEFT OUTER JOIN pmc_file ON alk05=pmc01 ",
                               " LEFT OUTER JOIN ala_file ON alk03=ala01 ",
                               " LEFT OUTER JOIN alg_file ON ala07=alg01 ",
                               " LEFT OUTER JOIN alh_file ON alk01=alh01 ,",
                     #" ale_file LEFT OUTER JOIN pmn_file ON ale14=pmn01 AND ale15=pmn02, ",   #FUN-A60056
                      " ale_file ,",    #FUN-A60056
                      " als_file ",   
                      "          LEFT OUTER JOIN azi_file ON azi01=als11 ",    #FUN-C50003 add
                " WHERE alk01=als01 AND alafirm<>'X' AND ",tm.wc CLIPPED,   
                "   AND alk01 = ale01 ",       #FUN-C50003 add
                "   AND alsfirm <> 'X' ", #CHI-C80041
                "   AND alkfirm <> 'X' "  #CHI-C80041
 
     PREPARE r812_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL  cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
        EXIT PROGRAM
     END IF
     DECLARE r812_curs1 CURSOR FOR r812_prepare1
 
#No.FUN-710086 --start-- mark
#    CALL cl_outnam('aapr812') RETURNING l_name
##FUN-710029 start------#zaa06隱藏否
#   IF g_sma116 MATCHES '[13]' THEN
#       LET g_zaa[46].zaa06 = "N" #計價單位
#       LET g_zaa[47].zaa06 = "N" #計價數量
#       LET g_zaa[41].zaa06 = 'Y' #進貨數量
#   ELSE
#       LET g_zaa[46].zaa06 = "Y" #計價單位
#       LET g_zaa[47].zaa06 = "Y" #計價數量
#       LET g_zaa[41].zaa06 = 'N' #進貨數量
#   END IF
#   IF g_sma115 = "Y" OR g_sma116 MATCHES '[13]' THEN
#       LET g_zaa[45].zaa06 = "N" #單位註解
#   ELSE
#       LET g_zaa[45].zaa06 = "Y" #單位註解
#   END IF
#   CALL cl_prt_pos_len()
##FUN-710029 end------------
#    START REPORT r812_rep TO l_name
#    LET g_pageno = 0
#No.FUN-710086 --end--
 
     FOREACH r812_curs1 INTO alk.*, ale.*, ala.*, als.*, sr.*, 
                             t_azi03, t_azi04, t_azi05, t_azi07   #FUN-C50003 add
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          #FUN-A60056--add--str--
          LET l_sql = "SELECT pmn041,pmn20,pmn07 ",
                      "  FROM ",cl_get_target_table(alk.alk97,'pmn_file'),
                      " WHERE  pmn01 = '",ale.ale14,"'",
                      "   AND  pmn02 = '",ale.ale15,"'"
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql
          CALL cl_parse_qry_sql(l_sql,alk.alk97) RETURNING l_sql
          PREPARE sel_pmn041 FROM l_sql
          EXECUTE sel_pmn041 INTO sr.pmn041,sr.pmn20,sr.pmn07
          #FUN-A60056--add--end
          IF tm.price='N' THEN LET ale.ale05=NULL LET ale.ale07=NULL END IF
          SELECT alt06 INTO sr.alt06
            FROM alt_file
#Wendy 990323 應以採購單及項次link到提單
      #     WHERE alt01 = ale.ale01 AND alt02 = ale.ale02
           WHERE alt01 = ale.ale01 AND
                 alt14 = ale.ale14 AND alt15 = ale.ale15
 
          #No.FUN-710086 --start--
          SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 = als.als06
          SELECT pma02 INTO l_pma02 FROM pma_file WHERE pma01 = als.als10   #FUN-C30085 mod pma02->l_pma02 
          SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file                                                                     
           WHERE ima01=ale.ale11
          LET l_str2 = ""
          IF g_sma115 = "Y" THEN
             CASE l_ima906
                WHEN "2"
                    CALL cl_remove_zero(ale.ale85) RETURNING l_ale85
                    LET l_str2 = l_ale85 , ale.ale83 CLIPPED
                    IF cl_null(ale.ale85) OR ale.ale85 = 0 THEN
                        CALL cl_remove_zero(ale.ale82) RETURNING l_ale82
                        LET l_str2 = l_ale82, ale.ale80 CLIPPED
                    ELSE
                       IF NOT cl_null(ale.ale82) AND ale.ale82 > 0 THEN
                          CALL cl_remove_zero(ale.ale82) RETURNING l_ale82
                          LET l_str2 = l_str2 CLIPPED,',',l_ale82, ale.ale80 CLIPPED
                       END IF
                    END IF
                WHEN "3"
                    IF NOT cl_null(ale.ale85) AND ale.ale85 > 0 THEN
                        CALL cl_remove_zero(ale.ale85) RETURNING l_ale85
                        LET l_str2 = l_ale85 , ale.ale83 CLIPPED
                    END IF
             END CASE
          END IF
          IF g_sma116 MATCHES '[13]' THEN 
                IF sr.pmn07 <> ale.ale86 THEN 
                   CALL cl_remove_zero(sr.pmn20) RETURNING l_pmn20
                   LET l_str2 = l_str2 CLIPPED,"(",l_pmn20,sr.pmn07 CLIPPED,")"
                END IF
          END IF
          IF als.als31 IS NULL THEN LET als.als31=0 END IF
          IF als.als32 IS NULL THEN LET als.als32=0 END IF
          IF als.als33 IS NULL THEN LET als.als33=0 END IF
          IF als.als34 IS NULL THEN LET als.als34=0 END IF
          IF als.als35 IS NULL THEN LET als.als35=0 END IF
          IF als.als36 IS NULL THEN LET als.als36=0 END IF
 
         #FUN-C50003-----mark----str----
         #SELECT azi03,azi04,azi05,azi07
         #  INTO t_azi03,t_azi04,t_azi05,t_azi07
         #  FROM azi_file
         # WHERE azi01=als.als11
         #FUN-C50003-----mark----end----
          #FUN-C30085 --start--
          LET l_als10 =''
          SELECT pma02 INTO l_als10 FROM pma_file
           WHERE pma01 = als.als10

          LET l_ala36 =''
          SELECT pnz02 INTO l_ala36 FROM pnz_file
           WHERE pnz01 = ala.ala36
          #FUN-C30085 --end-- 
          EXECUTE insert_prep USING alk.alk05,ala.ala03,ala.ala36,ale.ale05,
                                    ale.ale06,ale.ale07,ale.ale11,ale.ale14,
                                    ale.ale16,alk.alk01,alk.alk02,alk.alk12,
                                   #als.als03,als.als04,als.als06,als.als07,  #No.FUN-C10036 mark
                                    als.als03,als.als04,als.als06,alk.alk46,  #No.FUN-C10036 add
                                    als.als08,als.als09,als.als10,als.als11,
                                    als.als14,als.als21,als.als31,als.als32,
                                    als.als33,als.als34,als.als35,als.als36,
                                    sr.alt06,g_aza.aza17,l_ima021,sr.pmc03,
                                    l_pmc03,sr.pmn041,ale.ale86,ale.ale87,
                                    l_str2,t_azi03,t_azi04,t_azi05,t_azi07,g_azi04,
                                    "",        l_img_blob,    "N",           ""    #FUN-C40019 add
                                    ,l_als10,l_ala36 #FUN-C30085 add
          #No.FUN-710086 --end--
 
#         OUTPUT TO REPORT r812_rep(alk.*, ale.*, ala.*, als.*, sr.*)  #No.FUN-710086 mark
     END FOREACH
 
#    FINISH REPORT r812_rep                        #No.FUN-710086 mark
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)   #No.FUN-710086 mark
 
     #No.FUN-710086 --start--
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'alk01,alk02')
          RETURNING tm.wc

     LET g_cr_table = l_table                   #主報表的temp table名稱          #FUN-C40019 add
     LET g_cr_apr_key_f = "alk01"               #報表主鍵欄位名稱，用"|"隔開     #FUN-C40019 add

###GENGRE###     LET g_str = tm.price,";",tm.wc,";",g_zz05,";",g_sma116,";",g_sma115
   # LET l_sql = "SELECT * FROM ",l_table CLIPPED     #TQC-730088
###GENGRE###     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
   # CALL cl_prt_cs3('aapr812',l_sql,g_str)           #TQC-730088
###GENGRE###     CALL cl_prt_cs3('aapr812','aapr812',l_sql,g_str)
    CALL aapg812_grdata()    ###GENGRE###
     #No.FUN-710086 --end--
 
       #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055    #FUN-B80105  MARK
#      CALL cl_gre_drop_temptable(l_table)       #FUN-B90058 mark
END FUNCTION
 
#No.FUN-710086 --start-- mark
{REPORT r812_rep(alk, ale, ala, als, sr)
   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_ale07_sum  LIKE ale_file.ale07,
          l_ale07_sum2 LIKE ale_file.ale07,
          alk	RECORD LIKE alk_file.*,
          ale	RECORD LIKE ale_file.*,
          als	RECORD LIKE als_file.*,
          ala	RECORD LIKE ala_file.*,
          sr   RECORD
               pmc03 LIKE pmc_file.pmc03, # 廠商簡稱
               pmn041 LIKE pmn_file.pmn041,
               alt06 LIKE alt_file.alt06,
               alg02 LIKE alg_file.alg02,
               alh08 LIKE alh_file.alh08,
               pmn20 LIKE pmn_file.pmn20,  #FUN-710029
               pmn07 LIKE pmn_file.pmn07   #FUN-710029
               END RECORD,
         l_pmc03     LIKE pmc_file.pmc03, # No.FUN-690028  VARCHAR(12)
         pma02  LIKE pma_file.pma02,
#        l_azi03 LIKE azi_file.azi03,     #NO.CHI-6A0004
#        l_azi04 LIKE azi_file.azi04,     #NO.CHI-6A0004
#        l_azi05 LIKE azi_file.azi05,     #NO.CHI-6A0004
#        l_azi07 LIKE azi_file.azi07,     #NO.CHI-6A0004
         l_chr       LIKE type_file.chr1  #No.FUN-690028 VARCHAR(1)
   DEFINE l_gen02  LIKE gen_file.gen02
   DEFINE l_ima021 LIKE ima_file.ima021   #FUN-5B0007
   DEFINE l_str2       LIKE type_file.chr1000, #FUN-710029
          l_ima906     LIKE ima_file.ima906,   #FUN-710029
          l_ale85      LIKE ale_file.ale85,    #FUN-710029
          l_ale82      LIKE ale_file.ale82,    #FUN-710029
          l_pmn20      LIKE pmn_file.pmn20     #FUN-710029
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT   MARGIN 0
         BOTTOM MARGIN g_bottom_margin
         PAGE   LENGTH g_page_line
  ORDER BY alk.alk01, ale.ale02
  FORMAT
   PAGE HEADER
#No.FUN-580010--start
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT ' '   #No.TQC-6B0128
#No.TQC-6B0128    -begin
      LET g_pageno=g_pageno+1
      LET pageno_total = PAGENO USING '<<<',"/pageno" 
      PRINT g_head CLIPPED,pageno_total
#No.TQC-6B0128    --end
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED
      PRINT ' '
#No.FUN-580010--end
 
      LET g_msg = NULL
      SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 = als.als06
      SELECT pma02 INTO pma02 FROM pma_file WHERE pma01 = als.als10
 
      PRINT g_x[11] CLIPPED,alk.alk05,' ',sr.pmc03,
            COLUMN 50,g_x[12] CLIPPED,alk.alk01
      PRINT COLUMN 10,als.als06,' ',l_pmc03 CLIPPED,                #No.FUN-580010
            COLUMN 50,g_x[14] CLIPPED,alk.alk02
      PRINT COLUMN 10,als.als04                             #No.FUN-580010
      PRINT g_x[20] CLIPPED,ala.ala03,
            COLUMN 50,g_x[18] CLIPPED,als.als03
      PRINT COLUMN 10,als.als21 CLIPPED,                            #No.FUN-580010
            COLUMN 50,g_x[19] CLIPPED,als.als07
      PRINT g_x[15] CLIPPED,ala.ala36 CLIPPED,
            COLUMN 59,als.als11                             #No.FUN-580010
      PRINT g_x[17] CLIPPED,als.als08,als.als09
          # COLUMN 50,g_x[42] CLIPPED,als.als55
      PRINT g_x[13] CLIPPED,als.als10,' ',pma02  # '  ',als.als14 CLIPPED
      PRINT g_dash[1,g_len]
#No.FUN-580010--start
      PRINTX name=H1
             g_x[38],g_x[40],g_x[41],
             g_x[46],g_x[47],  #FUN-710029
             g_x[42],g_x[43],
             g_x[45]           #FUN-710029
#      PRINTX name=H2 g_x[39]   #FUN-5B0007
      PRINTX name=H2 g_x[39],g_x[44]   #FUN-5B0007
      PRINT g_dash1
#No.FUN-580010--end
 
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF alk.alk01
      SKIP TO TOP OF PAGE
   ON EVERY ROW
#NO.FUN-710029 start----
      SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file
                         WHERE ima01=ale.ale11
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(ale.ale85) RETURNING l_ale85
                LET l_str2 = l_ale85 , ale.ale83 CLIPPED
                IF cl_null(ale.ale85) OR ale.ale85 = 0 THEN
                    CALL cl_remove_zero(ale.ale82) RETURNING l_ale82
                    LET l_str2 = l_ale82, ale.ale80 CLIPPED
                ELSE
                   IF NOT cl_null(ale.ale82) AND ale.ale82 > 0 THEN
                      CALL cl_remove_zero(ale.ale82) RETURNING l_ale82
                      LET l_str2 = l_str2 CLIPPED,',',l_ale82, ale.ale80 CLIPPED
                   END IF
                END IF
            WHEN "3"
                IF NOT cl_null(ale.ale85) AND ale.ale85 > 0 THEN
                    CALL cl_remove_zero(ale.ale85) RETURNING l_ale85
                    LET l_str2 = l_ale85 , ale.ale83 CLIPPED
                END IF
         END CASE
      ELSE
      END IF
      IF g_sma116 MATCHES '[13]' THEN 
            IF sr.pmn07 <> ale.ale86 THEN 
               CALL cl_remove_zero(sr.pmn20) RETURNING l_pmn20
               LET l_str2 = l_str2 CLIPPED,"(",l_pmn20,sr.pmn07 CLIPPED,")"
            END IF
      END IF
#NO.FUN-710029 end--------------
#No.FUN-580010--start
      SELECT azi03,azi04,azi05,azi07
#       INTO l_azi03,l_azi04,l_azi05,l_azi07   #NO.CHI-6A0004
        INTO t_azi03,t_azi04,t_azi05,t_azi07   #NO.CHI-6A0004
        FROM azi_file
       WHERE azi01=als.als11
 
      PRINTX name=D1
             COLUMN g_c[38],ale.ale11 CLIPPED,
             COLUMN g_c[40],sr.alt06 USING '###########&.&&',
             COLUMN g_c[41],ale.ale06 USING '###########&.&&',
             COLUMN g_c[46],ale.ale86,                         #FUN-710029
             COLUMN g_c[47],cl_numfor(ale.ale87,47,t_azi03),   #FUN-710029
#            COLUMN g_c[42],cl_numfor(ale.ale05,42,l_azi03),   #NO.CHI-6A0004
             COLUMN g_c[42],cl_numfor(ale.ale05,42,t_azi03),   #NO.CHI-6A0004
#            COLUMN g_c[43],cl_numfor(ale.ale07,43,l_azi04)    #NO.CHI-6A0004
             COLUMN g_c[43],cl_numfor(ale.ale07,43,t_azi04),   #NO.CHI-6A0004
             COLUMN g_c[45],l_str2 CLIPPED                     #FUN-710029
#FUN-5B0007
      SELECT ima021 INTO l_ima021 FROM ima_file
         WHERE ima01=ale.ale11
#END FUN-5B0007
      PRINTX name=D2
             COLUMN g_c[39],sr.pmn041,
             COLUMN g_c[44],l_ima021      #FUN-5B0007
      PRINT 'P/O:',ale.ale14
      PRINT 'Stk-in:',ale.ale16
#No.FUN-580010--end
   AFTER GROUP OF alk.alk01
      LET l_ale07_sum = GROUP SUM(ale.ale07)
      LET l_ale07_sum2 = l_ale07_sum * alk.alk12
      PRINT g_dash3[1,g_len]                           #No.FUN-580010
      PRINT g_x[24] CLIPPED,
#           COLUMN g_c[43],cl_numfor(l_ale07_sum,43,l_azi05)  #No.FUN-580010 #NO.CHI-6A0004
            COLUMN g_c[43],cl_numfor(l_ale07_sum,43,t_azi05)  #No.FUN-580010 #NO.CHI-6A0004
      PRINT g_dash3[1,g_len]                            #No.FUN-580010
      PRINT (g_len-FGL_WIDTH(g_x[25]))/2 SPACES,g_x[25]
      #No.FUN-550030 start
      PRINT COLUMN 16,g_dash3[1,g_len-16]                  #No.FUN-580010
      PRINT COLUMN 16,g_x[27] CLIPPED,als.als11,
#NO.CHI-6A0004 --START
#           COLUMN 29,cl_numfor(l_ale07_sum,18,l_azi05),'x RATE',
#           COLUMN 54,cl_numfor(alk.alk12,10,l_azi07),'=',g_aza.aza17,
#           COLUMN 70,cl_numfor(l_ale07_sum2,18,l_azi05)
            COLUMN 29,cl_numfor(l_ale07_sum,18,t_azi05),'x RATE',
            COLUMN 54,cl_numfor(alk.alk12,10,t_azi07),'=',g_aza.aza17,
            COLUMN 70,cl_numfor(l_ale07_sum2,18,t_azi05)
#NO.CHI-6A0004 --END
      #No.FUN-550030 end
      IF tm.price='Y' THEN
         IF als.als31 IS NULL THEN LET als.als31=0 END IF
         IF als.als32 IS NULL THEN LET als.als32=0 END IF
         IF als.als33 IS NULL THEN LET als.als33=0 END IF
         IF als.als34 IS NULL THEN LET als.als34=0 END IF
         IF als.als35 IS NULL THEN LET als.als35=0 END IF
         IF als.als36 IS NULL THEN LET als.als36=0 END IF
         PRINT
         #No.FUN-550030 start
         PRINT COLUMN 16,g_x[28] CLIPPED,cl_numfor(als.als31,18,g_azi04),
               COLUMN 49,g_x[29] CLIPPED,cl_numfor(als.als32,18,g_azi04)
         PRINT COLUMN 16,g_x[30] CLIPPED,cl_numfor(als.als33,18,g_azi04),
               COLUMN 49,g_x[31] CLIPPED,cl_numfor(als.als34,18,g_azi04)
         PRINT COLUMN 16,g_x[32] CLIPPED,cl_numfor(als.als35,18,g_azi04),
               COLUMN 49,g_x[33] CLIPPED,cl_numfor(als.als36,18,g_azi04)
         #No.FUN-550030 end
      END IF
 
## FUN-550099
ON LAST ROW
      LET l_last_sw = 'y'
 
PAGE TRAILER
      PRINT g_dash[1,g_len]
#      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_user
#      PRINT g_x[34] CLIPPED,COLUMN 25,g_x[35] CLIPPED,COLUMN 50,g_x[36] CLIPPED
#            ,l_gen02
      IF l_last_sw = 'n' THEN
         IF g_memo_pagetrailer THEN
             PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[6]  #No.TQC-6B0128
             PRINT g_x[34]
             PRINT g_memo
         ELSE
             PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[6]  #No.TQC-6B0128
             PRINT
             PRINT
         END IF
      ELSE
             PRINT COLUMN 1,g_x[4],COLUMN g_len-9,g_x[7]   #No.TQC-6B0128
             PRINT g_x[34] 
             PRINT g_memo
      END IF
## END FUN-550099
 
END REPORT}
#No.FUN-710086 --end--
#Patch....NO.TQC-610035 <> #

###GENGRE###START
FUNCTION aapg812_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    
    LOCATE sr1.sign_img IN MEMORY   #FUN-C40019
    CALL cl_gre_init_apr()          #FUN-C40019

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aapg812")
        IF handler IS NOT NULL THEN
            START REPORT aapg812_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY alk01"
            DECLARE aapg812_datacur1 CURSOR FROM l_sql
            FOREACH aapg812_datacur1 INTO sr1.*
                OUTPUT TO REPORT aapg812_rep(sr1.*)
            END FOREACH
            FINISH REPORT aapg812_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aapg812_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno           LIKE type_file.num5
    #FUN-B40087-------add------str-----
    DEFINE l_alk05_pmc03_1    STRING       
    DEFINE l_als06_pmc03_2    STRING     
    DEFINE l_als08_als09      STRING    
    DEFINE l_sum              LIKE ale_file.ale07      
    DEFINE l_sum1             LIKE ale_file.ale07         
    DEFINE l_display1         LIKE sma_file.sma115
    DEFINE l_display2         LIKE sma_file.sma116
    DEFINE l_ale87_fmt        STRING
    DEFINE l_ale05_fmt        STRING
    DEFINE l_ale07_fmt        STRING   
    DEFINE l_sum_fmt          STRING
    DEFINE l_sum1_fmt         STRING
    DEFINE l_als31_fmt        STRING
    DEFINE l_als32_fmt        STRING
    DEFINE l_als33_fmt        STRING
    DEFINE l_als34_fmt        STRING
    DEFINE l_als35_fmt        STRING
    DEFINE l_als36_fmt        STRING
    DEFINE l_alk12_fmt        STRING
    #FUN-B40087-------add------end------
    DEFINE l_unit_memo        STRING     #FUN-CB0058

    ORDER EXTERNAL BY sr1.alk01
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.alk01
            LET l_lineno = 0
            #FUN-B40087-----add--------start--------------
            LET l_ale87_fmt = cl_gr_numfmt('ale_file','ale87',sr1.azi03)
            PRINTX l_ale87_fmt
            LET l_ale05_fmt = cl_gr_numfmt('ale_file','ale05',sr1.azi03)
            PRINTX l_ale05_fmt
            LET l_ale07_fmt = cl_gr_numfmt('ale_file','ale07',sr1.azi04)
            PRINTX l_ale07_fmt
            LET l_sum_fmt = cl_gr_numfmt('ale_file','ale07',sr1.azi05)
            PRINTX l_sum_fmt
            LET l_sum1_fmt = cl_gr_numfmt('ale_file','ale07',sr1.azi05)
            PRINTX l_sum1_fmt
            LET l_als31_fmt = cl_gr_numfmt('als_file','als31',g_azi04)
            PRINTX l_als31_fmt
            LET l_als32_fmt = cl_gr_numfmt('als_file','als32',g_azi04)
            PRINTX l_als32_fmt
            LET l_als33_fmt = cl_gr_numfmt('als_file','als33',g_azi04)
            PRINTX l_als33_fmt
            LET l_als34_fmt = cl_gr_numfmt('als_file','als34',g_azi04)
            PRINTX l_als34_fmt
            LET l_als35_fmt = cl_gr_numfmt('als_file','als35',g_azi04)
            PRINTX l_als35_fmt
            LET l_als36_fmt = cl_gr_numfmt('als_file','als36',g_azi04)
            PRINTX l_als36_fmt
            LET l_alk12_fmt = cl_gr_numfmt('alk_file','alk12',sr1.azi07)
            PRINTX l_alk12_fmt

            LET l_alk05_pmc03_1 = sr1.alk05,' ',sr1.pmc03_1
            LET l_als06_pmc03_2 = sr1.als06,' ',sr1.pmc03_2
            LET l_als08_als09 = sr1.als08,' ',sr1.als09
            PRINTX l_alk05_pmc03_1
            PRINTX l_als06_pmc03_2
            PRINTX l_als08_als09
            LET l_display1 = g_sma115
            PRINTX l_display1
            LET l_display2 = g_sma116
            PRINTX l_display2
            #FUN-B40087-----add--------end--------------
            #FUN-CB0058----add---str--
            IF g_sma115 = 'Y' THEN
               LET l_unit_memo = cl_gr_getmsg("gre-014",g_lang,1)
            ELSE 
               LET l_unit_memo = "   "  
            END IF
            PRINTX l_unit_memo
            #FUN-CB0058----add---end--
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.alk01
           #FUN-B40087-----add--------start--------------
           LET l_sum = GROUP SUM(sr1.ale07)
           LET l_sum1 = l_sum * sr1.alk12
           PRINTX l_sum
           PRINTX l_sum1
           #FUN-B40087-----add--------end--------------
        
        ON LAST ROW

END REPORT
###GENGRE###END
