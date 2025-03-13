# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Desc/riptions...: 動產機械設備及工具鑑價套表
# Input parameter:
# Return code....:
# Date & Author..: 96/06/18 By Star
# Modify.........: No.MOD-530080 05/02/15 By cate 報表標題標準化
# Modify.........: No.MOD-530728 05/03/28 By Smapmin 多頁列印時第一行有空行
# Modify         : No.MOD-530844 05/03/30 by alexlin VARCHAR->CHAR
# Modify.........: No.FUN-550102 05/05/25 By echo 新增報表備註
# Modify.........: No.MOD-590097 05/09/08 By Tracy 報表畫線寫入zaa
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6A0085 06/11/08 By ice 修正報表格式錯誤
# Modify.........: No.MOD-730146 07/04/12 By claire zo12改zo02
# Modify.........: No.TQC-810004 08/01/04 By zhaijie報表輸出改為Crystal Report
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-C10034 12/01/19 By yuhuabao GP 5.3 CR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.TQC-C20055 12/02/09 By zhuhao GP 5.3 CR報表列印TIPTOP與EasyFlow簽核圖片還原 
# Modify.........: No.TQC-BC0033 12/03/02 By Elise 加入製造廠商欄位說明

DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD
                   wc      LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(1000)
                   more    LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
              END RECORD,
          g_zo   RECORD LIKE zo_file.*
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE   g_sql           STRING                            #TQC-810004
DEFINE   g_str           STRING                            #TQC-810004
DEFINE   l_table         STRING                            #TQC-810004
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                         # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
 
#NO.TQC-810004--------------start----------------
   LET g_sql = "fce02.fce_file.fce02,",
               "faj06.faj_file.faj06,",
               "faj07.faj_file.faj07,",
               "faj08.faj_file.faj08,",
               "faj12.faj_file.faj12,",
               "faj11.faj_file.faj11,",
               "fce21.fce_file.fce21,",
               "fce20.fce_file.fce20,",
               "fce04.fce_file.fce04,",
               "faj29.faj_file.faj29,",
               "fcd01.fcd_file.fcd01,",
               "l_faj11.pmc_file.pmc03"           #TQC-BC0033
              #TQC-C20055--mark--begin
              #"sign_type.type_file.chr1,",   #簽核方式                   #No.TQC-C10034 add
              #"sign_img.type_file.blob,",    #簽核圖檔                   #No.TQC-C10034 add
              #"sign_show.type_file.chr1,",   #是否顯示簽核資料(Y/N)      #No.TQC-C10034 add
              #"sign_str.type_file.chr1000"   #簽核字串                   #No.TQC-C10034 add
              #TQC-C20055--mark--end
   LET l_table = cl_prt_temptable('afar900',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,? )"  #,?,?,?,?)"     #No.TQC-C10034 add 4? #TQC-C20055--mark  #TQC-BC0033 add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#NO.TQC-810004--------------end----------------
 
   LET g_pdate = ARG_VAL(1)                 # Get arguments from command line
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
   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
      THEN CALL r900_tm(0,0)        # Input print condition
      ELSE CALL afar900()        # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION r900_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 5 LET p_col = 32
 
   OPEN WINDOW r900_w AT p_row,p_col WITH FORM "afa/42f/afar900"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON fcd01
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
         LET INT_FLAG = 0 CLOSE WINDOW r900_w 
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
         LET INT_FLAG = 0 CLOSE WINDOW r900_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='afar900'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar900','9031',1)
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
            CALL cl_cmdat('afar900',g_time,l_cmd)
         END IF
         CLOSE WINDOW r900_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar900()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r900_w
END FUNCTION
 
FUNCTION afar900()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0069
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT       #No.FUN-680070 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(40)
          sr               RECORD
                           fce02     LIKE fce_file.fce02,
                           faj06     LIKE faj_file.faj06,
                           faj07     LIKE faj_file.faj07,
                           faj08     LIKE faj_file.faj08,
                           faj12     LIKE faj_file.faj12,
                           faj11     LIKE faj_file.faj11,
                           fce21     LIKE fce_file.fce21,
                           fce20     LIKE fce_file.fce20,
                           fce04     LIKE fce_file.fce04,
                           faj29     LIKE faj_file.faj29,
                           fcd01     LIKE fcd_file.fcd01
                        END RECORD
     DEFINE l_faj11 LIKE pmc_file.pmc03     #TQC-BC0033 add
    #TQC-C20055--mark--begin
    #DEFINE l_img_blob     LIKE type_file.blob                                         #No.TQC-C10034 add
    #LOCATE l_img_blob IN MEMORY   #blob初始化   #Genero Version 2.21.02之後要先初始化 #No.TQC-C10034 add
    #TQC-C20055--mark--end
     CALL cl_del_data(l_table)                             #NO.TQC-810004
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT * INTO g_zo.* FROM zo_file WHERE zo01= g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'afar900'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 211 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fajuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND fajgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND fajgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT fce02,faj06,faj07,faj08,faj12,faj11,fce21,fce20,",
                 "       fce04,faj29,fcd01 ",
                 "  FROM faj_file,fce_file,fcd_file ",
                 " WHERE faj02 = fce03 ",
                 "   AND faj022= fce031",
                 "   AND fajconf='Y' ",
                 "   AND fcd01 = fce01 ",
                 "   AND fcdconf != 'X' ",   #010803增
                 "   AND ",tm.wc
#測試報表時可用的SQL
#     LET l_sql = "SELECT 1    ,faj06,faj07,faj08,faj12,faj11,'PCS',100,",
#                 "       10000,faj29,'ABC-123456' ",
#                 "  FROM faj_file ",
#                 " WHERE fajconf='Y' "
 
     PREPARE r900_prepare FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE r900_cs CURSOR FOR r900_prepare
 
#     CALL cl_outnam('afar900') RETURNING l_name       #NO.TQC-810004
 
#     START REPORT r900_rep TO l_name                  #NO.TQC-810004
#     LET g_pageno=0                                   #NO.TQC-810004
 
     FOREACH r900_cs INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       IF cl_null(sr.fce20) THEN LET sr.fce20 = 0 END IF
       IF cl_null(sr.fce04) THEN LET sr.fce04 = 0 END IF
 
#       OUTPUT TO REPORT r900_rep(sr.*)                 #NO.TQC-810004
#NO.TQC-810004--------------------start--------------
    #TQC-BC0033---add---str----
     LET l_faj11 =''                             
     SELECT pmc03 INTO l_faj11 FROM pmc_file       
      WHERE pmc01 = sr.faj11   
    #TQC-BC0033---add---end----               
     EXECUTE insert_prep USING
        sr.fce02,sr.faj06,sr.faj07,sr.faj08,sr.faj12,sr.faj11,sr.fce21,
        sr.fce20,sr.fce04,sr.faj29,sr.fcd01,l_faj11          #TQC-BC0033 add l_faj11 
       #,"",  l_img_blob,   "N",""      #No.TQC-C10034 add   #TQC-C20055--mark
#NO.TQC-810004--------------------end--------------
     END FOREACH
 
#     FINISH REPORT r900_rep                            #NO.TQC-810004
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)       #NO.TQC-810004
#NO.TQC-810004-------------------start--------------
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
#TQC-C20055--mark--begin
#  LET g_cr_table = l_table                 #主報表的temp table名稱        #No.TQC-C10034 add
#  LET g_cr_apr_key_f = "fce02"                  #報表主鍵欄位名稱，用"|"隔開   #No.TQC-C10034 add
#TQC-C20055--mark--end
    IF g_zz05 = 'Y' THEN 
       CALL cl_wcchp(tm.wc,'fcd01')  RETURNING tm.wc
    END IF
    LET g_str = tm.wc,";",g_zo.zo02,";",g_zo.zo041,";",g_azi04,";",g_azi05
    CALL cl_prt_cs3('afar900','afar900',g_sql,g_str)
#NO.TQC-810004--------------------end--------------
END FUNCTION
 
#TQC-810004---------------START----mark----------
#REPORT r900_rep(sr)
#   DEFINE a LIKE type_file.chr5         #No.FUN-680070 VARCHAR(5)
#   DEFINE x1,x2 ARRAY[10] OF LIKE type_file.chr20        #No.FUN-680070 VARCHAR(10)
#   DEFINE l_flag LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
#   DEFINE l_last_sw        LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
#          sr               RECORD
#                           fce02     LIKE fce_file.fce02,
#                           faj06     LIKE faj_file.faj06,
#                           faj07     LIKE faj_file.faj07,
#                           faj08     LIKE faj_file.faj08,
#                           faj12     LIKE faj_file.faj12,
#                           faj11     LIKE faj_file.faj11,
#                           fce21     LIKE fce_file.fce21,
#                           fce20     LIKE fce_file.fce20,
#                           fce04     LIKE fce_file.fce04,
#                           faj29     LIKE faj_file.faj29,
#                           fcd01     LIKE fcd_file.fcd01
#                        END RECORD,
#
#        l_fce04      LIKE fce_file.fce04,
#        l_str        LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(40)
# 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.fcd01,sr.fce02
#  FORMAT
#   PAGE HEADER
#      LET l_flag ='N'
#      LET l_str = g_x[1] CLIPPED
#      PRINT (211-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED  #No.TQC-6A0085
#      SKIP 1 LINES   #No.TQC-6A0085
#      PRINT ((211-FGL_WIDTH(l_str CLIPPED))/2) SPACES,g_x[1] CLIPPED    #No.TQC-6A0085
#      SKIP 1 LINES   #No.TQC-6A0085
#      PRINT g_x[11] CLIPPED,g_zo.zo02   #MOD-730146
#      PRINT g_x[12] CLIPPED,g_zo.zo02   #MOD-730146
#      PRINT g_x[13] CLIPPED,g_zo.zo041
#      SKIP 1 LINE
#      LET g_pageno = g_pageno + 1
#      PRINT COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
#      PRINT g_x[51],g_x[52],g_x[53],g_x[54],g_x[55],g_x[56],g_x[57],
#            g_x[58],g_x[59],g_x[60],g_x[61]   #No.MOD-590097
#
#      PRINT COLUMN   1,g_x[36] CLIPPED,g_x[14] CLIPPED,
#            COLUMN   7,g_x[36] CLIPPED,g_x[15] CLIPPED,
#            COLUMN  35,g_x[36] CLIPPED,g_x[16] CLIPPED,
#            COLUMN  57,g_x[36] CLIPPED,g_x[17] CLIPPED,
#            COLUMN  67,g_x[36] CLIPPED,g_x[18] CLIPPED,
#            COLUMN  77,g_x[36] CLIPPED,g_x[19] CLIPPED,
#            COLUMN  83,g_x[36] CLIPPED,g_x[20] CLIPPED,
#            COLUMN 101,g_x[36] CLIPPED,g_x[21] CLIPPED,
#            COLUMN 157,g_x[36] CLIPPED,g_x[23] CLIPPED,
#            COLUMN 179,g_x[36] CLIPPED,g_x[25] CLIPPED,
#            COLUMN 201,g_x[36] CLIPPED,g_x[27] CLIPPED,
#            COLUMN 211,g_x[36] CLIPPED
#
#      PRINT COLUMN   1,g_x[36] CLIPPED,
#            COLUMN   7,g_x[36] CLIPPED,
#            COLUMN  35,g_x[36] CLIPPED,
#            COLUMN  57,g_x[36] CLIPPED,
#            COLUMN  67,g_x[36] CLIPPED,
#            COLUMN  77,g_x[36] CLIPPED,
#            COLUMN  83,g_x[36] CLIPPED,
#            COLUMN 101,g_x[36] CLIPPED,g_x[22] CLIPPED,COLUMN 121,g_x[49] CLIPPED,
#            COLUMN 157,g_x[36] CLIPPED,g_x[24] CLIPPED,
#            COLUMN 179,g_x[36] CLIPPED,g_x[24] CLIPPED,
#            COLUMN 201,g_x[36] CLIPPED,
#            COLUMN 211,g_x[36] CLIPPED
#      PRINT g_x[62],g_x[63],g_x[64],g_x[65],g_x[66],g_x[67],g_x[68],
#            g_x[69],g_x[70],g_x[71],g_x[72] #No.MOD-590097
#      LET l_last_sw = 'n' #FUN-550102
#
# 
#   BEFORE GROUP OF sr.fcd01
#      SKIP TO TOP OF PAGE
###Modify:2644
#ON EVERY ROW
#      PRINT COLUMN   1,g_x[36] CLIPPED,sr.fce02 USING '####',
#            COLUMN   7,g_x[36] CLIPPED,sr.faj06 CLIPPED,  #No.TQC-6A0085
#            COLUMN  35,g_x[36] CLIPPED,sr.faj08[1,20],
#            COLUMN  57,g_x[36] CLIPPED,sr.faj12[1,8],
#            COLUMN  67,g_x[36] CLIPPED,
#            COLUMN  77,g_x[36] CLIPPED,sr.fce21,
#            COLUMN  83,g_x[36] CLIPPED,COLUMN  85,cl_numfor(sr.fce20,15,0),
#            COLUMN 101,g_x[36] CLIPPED,COLUMN 103,cl_numfor(sr.fce04,19,g_azi04),
#            COLUMN 123,g_x[36] CLIPPED,
#            COLUMN 145,g_x[36] CLIPPED,sr.faj29 USING '####',
#            COLUMN 151,g_x[36] CLIPPED,g_x[29] CLIPPED,
#            COLUMN 157,g_x[36] CLIPPED,
#            COLUMN 179,g_x[36] CLIPPED,
#            COLUMN 201,g_x[36] CLIPPED,
#            COLUMN 211,g_x[36] CLIPPED
#
#      PRINT COLUMN   1,g_x[36] CLIPPED,
#            COLUMN   7,g_x[36] CLIPPED,sr.faj07[1,25],
#            COLUMN  35,g_x[36] CLIPPED,
#            COLUMN  57,g_x[36] CLIPPED,sr.faj11[1,8],
#            COLUMN  67,g_x[36] CLIPPED,
#            COLUMN  77,g_x[36] CLIPPED,
#            COLUMN  83,g_x[36] CLIPPED,
#            COLUMN 101,g_x[36] CLIPPED,
#            COLUMN 123,g_x[36] CLIPPED,
#            COLUMN 145,g_x[36] CLIPPED,
#            COLUMN 151,g_x[36] CLIPPED,
#            COLUMN 157,g_x[36] CLIPPED,
#            COLUMN 179,g_x[36] CLIPPED,
#            COLUMN 201,g_x[36] CLIPPED,
#            COLUMN 211,g_x[36] CLIPPED
#     DISPLAY "LINENO=",LINENO
# #MOD-530728
#     IF LINENO > 1  THEN
#        PRINT g_x[62],g_x[63],g_x[64],g_x[65],g_x[66],g_x[67],g_x[84],
#              g_x[85],g_x[70],g_x[71],g_x[72] #No.MOD-590097
#     ELSE
# 
#     END IF
# #MOD-530728
#   AFTER GROUP OF sr.fcd01
#      LET l_flag ='Y'
#      LET l_fce04 = SUM(sr.fce04)
#      PRINT COLUMN   1,g_x[36] CLIPPED,
#            COLUMN   7,g_x[36] CLIPPED,g_x[28] CLIPPED,
#            COLUMN  35,g_x[36] CLIPPED,
#            COLUMN  57,g_x[36] CLIPPED,
#            COLUMN  67,g_x[36] CLIPPED,
#            COLUMN  77,g_x[36] CLIPPED,
#            COLUMN  83,g_x[36] CLIPPED,
#            COLUMN 101,g_x[36] CLIPPED,COLUMN 103,cl_numfor(l_fce04,19,g_azi05),
#            COLUMN 123,g_x[36] CLIPPED,
#            COLUMN 145,g_x[36] CLIPPED,
#            COLUMN 151,g_x[36] CLIPPED,
#            COLUMN 157,g_x[36] CLIPPED,
#            COLUMN 179,g_x[36] CLIPPED,
#            COLUMN 201,g_x[36] CLIPPED,
#            COLUMN 211,g_x[36] CLIPPED
#      PRINT g_x[73],g_x[74],g_x[75],g_x[76],g_x[77],g_x[78],g_x[79],
#            g_x[80],g_x[81],g_x[82],g_x[83]  #No.MOD-590097
# 
### FUN-550102
#   ON LAST ROW
#      LET l_last_sw = 'y'
# 
#   PAGE TRAILER
#     IF l_flag ='N' THEN
#        PRINT g_x[73],g_x[74],g_x[75],g_x[76],g_x[77],g_x[78],g_x[79],
#              g_x[80],g_x[81],g_x[82],g_x[83]  #No.MOD-590097
#     ELSE
#        SKIP 1 LINES
#     END IF
#      PRINT ' '
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[50]
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT g_x[50]
#             PRINT g_memo
#      END IF
### END FUN-550102
#
#END REPORT
#Patch....NO.TQC-610035 <001> #
#NO.TQC-81004-----------end------------
