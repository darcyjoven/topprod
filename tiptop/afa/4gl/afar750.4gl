# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Desc/riptions...: 投資抵減申請書套表
# Input parameter:
# Return code....:
# Date & Author..: 96/06/24 By Star
# Modify.........: No.FUN-550102 05/05/26 By echo 新增報表備註
# Modify.........: No.FUN-560060 05/06/15 By day   單據編號修改
# Modify.........: No.FUN-580144 05/08/29 By Dido 報表套印格式修改for經濟部工業局
# Modify.........: NO.FUN-590118 06/01/03 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-710083 07/01/30 By Ray Crystal Report修改
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-C10034 12/01/19 By yuhuabao GP 5.3 CR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.TQC-C20055 12/02/09 By zhuhao GP 5.3 CR報表列印TIPTOP與EasyFlow簽核圖片還原
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm   RECORD
              wc      LIKE type_file.chr1000, #No.FUN-680070 VARCHAR(1000)
              more    LIKE type_file.chr1     #No.FUN-680070 VARCHAR(1)
            END RECORD,
       g_zo RECORD    LIKE zo_file.*
DEFINE g_i            LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
#No.FUN-710083 --begin
DEFINE  g_sql      STRING
DEFINE  l_table    STRING
DEFINE  g_str      STRING
#No.FUN-710083 --end
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                            # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
 
 
   LET g_pdate = ARG_VAL(1)                   # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#No.FUN-710083 --begin
   LET g_sql ="fcc01.fcc_file.fcc01,",
              "fcc02.fcc_file.fcc02,",
              "fcb03.fcb_file.fcb03,",
              "fcb04.fcb_file.fcb04,",
              "fcc06.fcc_file.fcc06,",
              "fcc07.fcc_file.fcc07,",
              "fcc11.fcc_file.fcc11,",
              "fcc08.fcc_file.fcc08,",
              "fcc17.fcc_file.fcc17,",
              "fcc18.fcc_file.fcc18,",
              "fcc19.fcc_file.fcc19,",
              "fcc191.fcc_file.fcc191,",
              "faj21.faj_file.faj21,",
              "faj25.faj_file.faj25,",
              "faj49.faj_file.faj49,",
              "fcc09.fcc_file.fcc09,",
              "fcc14.fcc_file.fcc14,",
              "fcc15.fcc_file.fcc15,",
              "fcc12.fcc_file.fcc12,",
              "fcc05.fcc_file.fcc05,",
              "fcc10.fcc_file.fcc10,",
              "fcc13.fcc_file.fcc13,",
              "fcc26.fcc_file.fcc26"
             #TQC-C20055--mark--begin
             #"sign_type.type_file.chr1,",   #簽核方式                   #No.TQC-C10034 add
             #"sign_img.type_file.blob,",    #簽核圖檔                   #No.TQC-C10034 add
             #"sign_show.type_file.chr1,",   #是否顯示簽核資料(Y/N)      #No.TQC-C10034 add
             #"sign_str.type_file.chr1000"   #簽核字串                   #No.TQC-C10034 add
             #TQC-C20055--mark--end
   LET l_table = cl_prt_temptable('afar750',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?,",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?,",
               "        ?, ?, ?, ?, ?)"   #, ?, ?, ?, ?)"    #No.TQC-C10034 add 4?  #TQC-C20055--mark
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#No.FUN-710083 --end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'       # If background job sw is off
      THEN CALL r750_tm(0,0)                  # Input print condition
      ELSE CALL afar750()                     # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION r750_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-680070 SMALLINT
       l_cmd          LIKE type_file.chr1000  #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 5 LET p_col = 18
 
   OPEN WINDOW r750_w AT p_row,p_col WITH FORM "afa/42f/afar750"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                    # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON fcb01,fcb02
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
           #CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()             #No.FUN-550037 hmf
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
         LET INT_FLAG = 0 CLOSE WINDOW r750_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
            END IF
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
 
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
         LET INT_FLAG = 0 CLOSE WINDOW r750_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='afar750'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar750','9031',1)
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
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('afar750',g_time,l_cmd)
         END IF
         CLOSE WINDOW r750_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar750()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r750_w
END FUNCTION
 
FUNCTION afar750()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0069
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT       #No.FUN-680070 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(40)
          sr               RECORD
                           fcc01     LIKE fcc_file.fcc01,
                           fcc02     LIKE fcc_file.fcc02,
                           fcb03     LIKE fcb_file.fcb03, #申請日期
                           fcb04     LIKE fcb_file.fcb04, #申請編號
                           fcc06     LIKE fcc_file.fcc06,
                           fcc07     LIKE fcc_file.fcc07,
                           fcc11     LIKE fcc_file.fcc11,
                           fcc08     LIKE fcc_file.fcc08,
                           fcc17     LIKE fcc_file.fcc17,
                           fcc18     LIKE fcc_file.fcc18,
                           fcc19     LIKE fcc_file.fcc19,
                           fcc191    LIKE fcc_file.fcc191,
                           faj21     LIKE faj_file.faj21, #存放位置
                           faj25     LIKE faj_file.faj25, #取得日期
                           faj49     LIKE faj_file.faj49, #進口編號
                           fcc09     LIKE fcc_file.fcc09,
                           fcc14     LIKE fcc_file.fcc14,
                           fcc15     LIKE fcc_file.fcc15,
                           fcc12     LIKE fcc_file.fcc12,
                           fcc05     LIKE fcc_file.fcc05,
                           fcc10     LIKE fcc_file.fcc10,
                           fcc13     LIKE fcc_file.fcc13,
                           fcc26     LIKE fcc_file.fcc26  #FUN-580144 設備或技術來源
                        END RECORD

#TQC-C20055--mark--begin 
  #DEFINE l_img_blob     LIKE type_file.blob                                         #No.TQC-C10034 add
  #LOCATE l_img_blob IN MEMORY   #blob初始化   #Genero Version 2.21.02之後要先初始化 #No.TQC-C10034 add
#TQC-C20055--mark--end
     CALL cl_del_data(l_table)     #No.FUN-710083
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-710083 --begin
#    SELECT * INTO g_zo.* FROM zo_file WHERE zo01= g_rlang
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'afar750'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-710083 --end
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fcbuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND fcbgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND fcbgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fcbuser', 'fcbgrup')
     #End:FUN-980030
 
 
     LET l_sql = "SELECT fcc01,fcc02,fcb03,fcb04,fcc06,fcc07,fcc11,fcc08,fcc17,fcc18, ",
                 "       fcc19,fcc191, ",
                 "       faj21,faj25,faj49,fcc21,fcc14,fcc15,fcc12,fcc05,fcc10,fcc23 ,fcc26 ", #FUN-580144
                 "  FROM fcb_file,fcc_file,OUTER faj_file  ",
                 " WHERE fcb01 = fcc01 ",
                 "   AND fcbconf != 'X' ",   #010802增
                 "   AND fcc04 != '0' ",
               # "   AND fcc09 != 0 ",
                 "   AND fcc21 != 0 ",
                 "   AND faj_file.faj02=fcc_file.fcc03 ",
                 "   AND faj_file.faj022=fcc_file.fcc031 ",
                 "   AND ",tm.wc,
                 "   ORDER BY fcc02,faj25"
 
     PREPARE r750_prepare FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE r750_cs CURSOR FOR r750_prepare
 
#No.FUN-710083 --begin
#    CALL cl_outnam('afar750') RETURNING l_name
 
#    START REPORT r750_rep TO l_name
#    LET g_pageno=0
#No.FUN-710083 --end
 
     CALL r750_create_temp1()
     LET g_line = 0
     FOREACH r750_cs INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       LET g_line = g_line + 1
       IF cl_null(sr.fcc09) THEN LET sr.fcc09 = 0 END IF
       IF cl_null(sr.fcc15) THEN LET sr.fcc15 = 0 END IF
       IF cl_null(sr.fcc12) THEN LET sr.fcc12 = 0 END IF
       IF cl_null(sr.fcc10) THEN LET sr.fcc10 = 0 END IF
       IF cl_null(sr.fcc13) THEN LET sr.fcc13 = 0 END IF
       IF sr.fcc14 = 'YEN ' THEN LET sr.fcc14 = 'JYP ' END IF
#No.FUN-710083 --begin
       EXECUTE insert_prep USING sr.*
                                #,"",  l_img_blob,   "N",""      #No.TQC-C10034 add  #TQC-C20055--mark
#      OUTPUT TO REPORT r750_rep(sr.*)
#No.FUN-710083 --end
     END FOREACH
 
 
#No.FUN-710083 --begin
  #  LET l_sql = "SELECT * FROM ",l_table CLIPPED    #TQC-730088
  #  CALL cl_prt_cs3('afar750',l_sql,'')
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
#TQC-C20055--mark--begin
  #  LET g_cr_table = l_table                 #主報表的temp table名稱        #No.TQC-C10034 add
  #  LET g_cr_apr_key_f = "fcc01"             #報表主鍵欄位名稱，用"|"隔開   #No.TQC-C10034 add
#TQC-C20055--mark--end
     CALL cl_prt_cs3('afar750','afar750',l_sql,'')
#    FINISH REPORT r750_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-710083 --end
END FUNCTION
 
#No.FUN-710083 --begin
#REPORT r750_rep(sr)
#   DEFINE a LIKE type_file.chr5                         #No.FUN-680070 VARCHAR(5)
#   DEFINE x1,x2 ARRAY[10] OF LIKE type_file.chr20       #No.FUN-680070 VARCHAR(10)
#   DEFINE l_last_row       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
#          tot1             LIKE type_file.num20_6,      #No.FUN-680070 DEC(15,2)
#          l_v              LIKE type_file.chr2,         #No.FUN-680070 VARCHAR(2)
#          xr            RECORD
#                           fcc14 LIKE type_file.chr4,   #No.FUN-680070 VARCHAR(4)
#                           tot2  LIKE type_file.num20   #No.FUN-680070 dec(16,0)
#                        END RECORD,
#          sr            RECORD
#                           fcc01     LIKE fcc_file.fcc01,
#                           fcc02     LIKE fcc_file.fcc02,
#                           fcb03     LIKE fcb_file.fcb03, #申請日期
#                           fcb04     LIKE fcb_file.fcb04, #申請編號
#                           fcc06     LIKE fcc_file.fcc06,
#                           fcc07     LIKE fcc_file.fcc07,
#                           fcc11     LIKE fcc_file.fcc11,
#                           fcc08     LIKE fcc_file.fcc08,
#                           fcc17     LIKE fcc_file.fcc17,
#                           fcc18     LIKE fcc_file.fcc18,
#                           fcc19     LIKE fcc_file.fcc19,
#                           fcc191    LIKE fcc_file.fcc191,
#                           faj21     LIKE faj_file.faj21, #存放位置
#                           faj25     LIKE faj_file.faj25, #取得日期
#                           faj49     LIKE faj_file.faj49, #進口編號
#                           fcc09     LIKE fcc_file.fcc09,
#                           fcc14     LIKE fcc_file.fcc14,
#                           fcc15     LIKE fcc_file.fcc15,
#                           fcc12     LIKE fcc_file.fcc12,
#                           fcc05     LIKE fcc_file.fcc05,
#                           fcc10     LIKE fcc_file.fcc10,
#                           fcc13     LIKE fcc_file.fcc13,
#                           fcc26     LIKE fcc_file.fcc26  #FUN-580144 設備或技術來源
#                        END RECORD
#DEFINE    l_insum_p     LIKE type_file.num20_6   #國產設備小計       #No.FUN-680070 DEC(20,6)
#DEFINE    l_insum_t     LIKE type_file.num20_6   #國產設備總計       #No.FUN-680070 DEC(20,6)
#DEFINE    l_outsum_p    LIKE type_file.num20_6   #國外設備小計       #No.FUN-680070 DEC(20,6)
#DEFINE    l_outsum_t    LIKE type_file.num20_6   #國外設備總計       #No.FUN-680070 DEC(20,6)
#DEFINE    l_line        LIKE type_file.num5      #目前項次       #No.FUN-680070 DEC(5,2)
##FUN-580144
#DEFINE    l_n           LIKE type_file.num5       #跳頁檢核       #No.FUN-680070 SMALLINT
#    OUTPUT TOP MARGIN 0
#           LEFT MARGIN g_left_margin
#           BOTTOM MARGIN 0
#           PAGE LENGTH g_page_line
#    ORDER BY sr.fcc02,sr.faj25
#    FORMAT
#    PAGE HEADER
#       SKIP 9  LINES
#{10}   PRINT COLUMN 18,g_company
#       SKIP 10 LINES
#
##       SKIP 7 LINES
##{8 }   PRINT COLUMN 134,YEAR(sr.fcb03) USING "####",'    ',MONTH(sr.fcb03) USING "##",'   ',
##                          DAY(sr.fcb03) USING "##"
##{9 }   SKIP 1 LINES
##{10}   PRINT COLUMN 134,sr.fcb04
##       SKIP 2 LINES
##{13}   PRINT COLUMN 26,g_company ,COLUMN 90 ,g_zo.zo11
##       SKIP 2 LINES
##{16}   PRINT COLUMN 26,g_zo.zo02
##       SKIP 2 LINE
##{19}   PRINT COLUMN 26,g_zo.zo041
##       SKIP 4 LINES
##    IF g_line mod 7 = 0 THEN
##        LET g_line = g_line/7
##    ELSE
##        LET g_line = g_line/7 + 1
##    END IF
#
#    LET l_line = 0
#    LET l_insum_p = 0
#    LET l_outsum_p = 0
#    LET l_insum_t = 0
#    LET l_outsum_t = 0
#    LET l_last_row = 'N'
# 
#    ON EVERY ROW
#        LET l_line = l_line + 1
#
#{21}    PRINT COLUMN  8 ,sr.fcc02 USING '####',      #項次 #FUN-590118
#              COLUMN  12,sr.fcc06[1,15],            #英文名稱
#              COLUMN  36,sr.fcc11[1,10],            #用途
#              COLUMN  57,sr.fcc26,                  #設備或技術來源
#              COLUMN  73,sr.fcc17,                  #訂購日期
#              COLUMN  93,sr.fcc09 USING '#######&', #數量
#              COLUMN 103,sr.fcc12                   #備註
#      SKIP 1 LINES
#
#{23}    PRINT COLUMN  12,sr.fcc07[1,12],#型號或規格
#              COLUMN  57,sr.fcc08[1,08],#廠商名稱
#              COLUMN  73,sr.fcc19,                  #交貨日期
#              COLUMN  93,sr.fcc13 USING '#######&'  #原幣成本(單價)
#      SKIP 1 LINES
#
#{25}    PRINT COLUMN  73,sr.fcc191,                          #安裝日期
#              COLUMN  87,sr.fcc14[1,4],                      #幣別
#              COLUMN  93,sr.fcc09*sr.fcc13 USING '#######&'  #總價
#      SKIP 1 LINES
#
#      LET l_n = l_n + 1
#      IF l_n = 9 THEN
#         SKIP TO TOP OF PAGE
#      END IF
#
#
##{24}    PRINT COLUMN  10,sr.fcc02 USING '###', #項次
##            COLUMN  14,sr.fcc06[1,28],       #英文名稱
##            COLUMN  44,sr.fcc07[1,12],       #型號或規格
##            COLUMN  57,sr.fcc11[1,14];       #用途
##        IF cl_null(sr.faj49) THEN
##            PRINT COLUMN  72,g_x[29] CLIPPED;           #國內
##            LET l_insum_p = l_insum_p + (sr.fcc09 * sr.fcc13) #國產設備小計
##            LET l_insum_t = l_insum_t + (sr.fcc09 * sr.fcc13) #國產設備總計
##        ELSE
##            PRINT COLUMN  77,g_x[29] CLIPPED;           #國外
##            LET l_outsum_p = l_outsum_p + (sr.fcc09 * sr.fcc13 ) #國外設備小計
##            LET l_outsum_t = l_outsum_t + (sr.fcc09 * sr.fcc13 ) #國外設備總計
##        END IF
##        PRINT
##            COLUMN  80,sr.fcc08[1,08],                     #廠商名稱
##            COLUMN  90,sr.fcc17,                           #訂購日期
##            COLUMN  99,sr.fcc19,                           #交貨日期
##            COLUMN 108,sr.fcc191,                          #安裝日期
##            COLUMN 117,sr.fcc09 USING '######&',           #數量
##            COLUMN 125,sr.fcc13 USING '######&',           #原幣成本(單價)
##            COLUMN 133,sr.fcc09*sr.fcc13 USING '#######&', #總價
##            COLUMN 142,sr.fcc15 USING '##&',               #抵減率
##            COLUMN 148,sr.fcc12                            #備註
#
##{25}    PRINT COLUMN  14,sr.fcc05,            #中文名稱
##              COLUMN 120,sr.fcc10[1,4],       #單位
##              COLUMN 128,sr.fcc14[1,4],       #幣別
##              COLUMN 137,sr.fcc14[1,4]        #幣別
# 
##{26}    SKIP 1 LINE
##        IF l_line mod 7 = 0 THEN
##           SKIP TO TOP OF PAGE
##        END IF
#
#    ON LAST ROW
#        LET l_last_row = 'Y'
#
#    PAGE TRAILER
#        SKIP 1 LINES
#
##        IF l_last_row = 'Y' THEN
##            PRINT COLUMN 13,g_x[29] CLIPPED,COLUMN 57,l_insum_t USING "############",
##                  COLUMN 85,l_outsum_t USING "############"
##            IF l_insum_t != 0 THEN
##                PRINT COLUMN 65,sr.fcc14;
##            END IF
##            IF l_outsum_t != 0 THEN
##                PRINT COLUMN 93,sr.fcc14;
##            END IF
##            PRINT
##        ELSE
##            PRINT COLUMN 29,g_x[29] CLIPPED,COLUMN 57,l_insum_p USING "############",
##                  COLUMN 85,l_outsum_p USING "############"
##            IF l_insum_p != 0 THEN
##                PRINT COLUMN 57,sr.fcc14;
##            END IF
##            IF l_outsum_p != 0 THEN
##                PRINT COLUMN 85,sr.fcc14;
##            END IF
##            PRINT
##        END IF
##        SKIP 6 LINES
##        PRINT COLUMN 156,PAGENO USING "###"   #頁次
##        SKIP 7 LINES
##        PRINT COLUMN 156,g_line USING "###"   #總頁數
##        PRINT
##        PRINT COLUMN 34,sr.fcb03,COLUMN 82,sr.fcb03
##        PRINT
##        PRINT COLUMN 34,sr.fcb04,COLUMN 82,sr.fcb04
##        SKIP 4 LINES
##        LET l_insum_p = 0
##        LEt l_outsum_p = 0
### FUN-550102
##      PRINT ''
##      IF l_last_row = 'N' THEN
##         IF g_memo_pagetrailer THEN
##             PRINT g_x[30]
##             PRINT g_memo
##         ELSE
##             PRINT
##             PRINT
##         END IF
##      ELSE
##             PRINT g_x[30]
##             PRINT g_memo
##      END IF
### END FUN-550102
##  END FUN-580144
#END REPORT
#No.FUN-710083 --end
 
FUNCTION r750_create_temp1()
   DROP TABLE b1_temp
#No.FUN-680070  -- begin --
#   CREATE  TABLE b1_temp(
#     fcc01 VARCHAR(16),               #No.FUN-560060
#     fcc14 VARCHAR(4),
#     tot2  dec(16,0));
   CREATE TEMP TABLE b1_temp(
     fcc01 LIKE fcc_file.fcc01,
     fcc14 LIKE fcc_file.fcc14,
     tot2  LIKE type_file.num20);
#No.FUN-680070  -- end --
END FUNCTION
#Patch....NO.TQC-610035 <001> #
