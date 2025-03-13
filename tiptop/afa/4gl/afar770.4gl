# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: afar770.4gl
# Descriptions...: 尚未投資抵減清單
# Date & Author..: 96/05/15 By STAR
# Modify.........: No.FUN-510035 05/02/03 By Smapmin 報表轉XML格式
# Modify.........: No.TQC-5C0037 05/12/07 By kevin 欄位沒對齊
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6A0085 06/11/08 By ice 修正報表格式錯誤
# Modify.........: No.FUN-850092 08/05/16 By arman 修改為CR報表
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-AB0191 10/11/29 By suncx 將資料插入臨時表時變量順序錯誤
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                               # Print condition RECORD
              wc      LIKE type_file.chr1000,   # Where condition             #No.FUN-680070 VARCHAR(1000)
              yy      LIKE type_file.num5,      #No.FUN-680070 SMALLINT
              a       LIKE type_file.chr1,      #No.FUN-680070 VARCHAR(1)
              more    LIKE type_file.chr1       # Input more condition(Y/N)   #No.FUN-680070 VARCHAR(1)
           END RECORD,
       m_codest       LIKE type_file.chr1000    #No.FUN-680070 VARCHAR(34)
 
DEFINE g_i            LIKE type_file.num5       #count/index for any purpose  #No.FUN-680070 SMALLINT
# NO.FUN-850092 --begin                                                                                                             
DEFINE l_table        STRING,                                                                                                       
       g_str          STRING,                                                                                                       
       g_sql          STRING                                                                                                        
# No.FUN-850092 --end
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
 
#No.FUN-850092 ---begin
   LET g_sql = "fcc19.fcc_file.fcc19,",
               "fcc05.fcc_file.fcc05,",
               "fcc09.fcc_file.fcc09,",
               "fcc10.fcc_file.fcc10,",
               "fcb03.fcb_file.fcb03,",
               "fcb04.fcb_file.fcb04,",
               "fcb05.fcb_file.fcb05,",
               "fcb06.fcb_file.fcb06,",
               "code1.type_file.chr2,",
               "code2.type_file.chr2,",
               "total1.type_file.num20_6,",
               "total2.type_file.num20_6,",
               "fcc15.fcc_file.fcc15,",
               "fcm04.fcm_file.fcm04,",
               "total3.type_file.num20_6"
   LET l_table = cl_prt_temptable('afar710',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,? )"                                                                  
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF
 
#NO.FUN-850092  --end
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.yy = ARG_VAL(8)
   LET tm.a  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL afar770_tm(0,0)        # Input print condition
      ELSE CALL afar770()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION afar770_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 7
 
   OPEN WINDOW afar770_w AT p_row,p_col WITH FORM "afa/42f/afar770"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.yy   = YEAR(g_today)
   LET tm.a    = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON fcb04,fcb06,fcc14,fcc15,fcb03,fcb05,fcb01
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
         LET INT_FLAG = 0 CLOSE WINDOW afar770_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.yy,tm.a,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD yy
            IF cl_null(tm.yy) THEN
               NEXT FIELD yy
            END IF
 
         AFTER FIELD more
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
         LET INT_FLAG = 0 CLOSE WINDOW afar770_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='afar770'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar770','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,      #(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_lang CLIPPED,"'",
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.yy CLIPPED,"'",
                            " '",tm.a  CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
 
            CALL cl_cmdat('afar770',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW afar770_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar770()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW afar770_w
END FUNCTION
 
FUNCTION afar770()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0069
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT       #No.FUN-680070 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(40)
          l_order   ARRAY[3] OF LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(10)
          l_fcj11   LIKE   fcj_file.fcj11,
          l_fcc24   LIKE   fcc_file.fcc24,
          l_fcm04   LIKE   fcm_file.fcm04,
          l_total1 LIKE type_file.num20_6,      #No.FUN-680070 DEC(20,6)
          l_total2 LIKE type_file.num20_6,      #No.FUN-680070 DEC(20,6)
          l_n      LIKE type_file.num5,         #No.FUN-680070 SMALLINT
          sr               RECORD fcc02  LIKE fcc_file.fcc02,
                                  fcc04  LIKE fcc_file.fcc04,
                                  fcc05  LIKE fcc_file.fcc05,
                                  fcc09  LIKE fcc_file.fcc09,
                                  fcc10  LIKE fcc_file.fcc10,
                                  fcc19  LIKE fcc_file.fcc19,
                                  fcc16  LIKE fcc_file.fcc16,
                                  fcb03  LIKE fcb_file.fcb03,
                                  fcb04  LIKE fcb_file.fcb04,
                                  fcb05  LIKE fcb_file.fcb05,
                                  fcb06  LIKE fcb_file.fcb06,
                                  code1  LIKE type_file.chr2,         #No.FUN-680070 VARCHAR(2)
                                  code2  LIKE type_file.chr2,         #No.FUN-680070 VARCHAR(2)
                                  total1 LIKE type_file.num20_6,      #No.FUN-680070 DEC(20,6)
                                  fcc15  LIKE fcc_file.fcc15,
                                  fcc14  LIKE fcc_file.fcc14,
                                  total2 LIKE type_file.num20_6,      #No.FUN-680070 DEC(20,6)
                                  fcc01  LIKE fcc_file.fcc01,
                                  fcm04  LIKE fcm_file.fcm04,
                                  total3 LIKE type_file.num20_6      #No.FUN-680070 DEC(20,6)
                        END RECORD
          CALL cl_del_data(l_table)     #TQC-AB0191 add 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
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
 
     LET l_sql = "SELECT fcc02,fcc04,fcc05,fcc21,fcc10,fcc19,fcc24,fcb03, ",
                 "       fcb04,fcb05,fcb06,'','',0,",
                 "       fcc15,fcc14,0,fcc01,0,0  ",
                 "  FROM fcb_file,fcc_file, faj_file  ",
                 " WHERE fcb01 = fcc01 ",
                 "   AND fcbconf != 'X' ",  #010802 增
                 "   AND fcc20 = '5' ",
                 "   AND fcc03 = faj02 ",
                 "   AND fcc031 = faj022 ",
                 "   AND fcc04 IN ('1','2') ",  # 合併後
                 "   AND ",tm.wc CLIPPED
 
      #-->處份是否包含
     #IF tm.d = 'N' THEN
     #   LET l_sql = l_sql clipped," AND faj43 not matches'[56]' "
     #END IF
 
#    SELECT azi03,azi04,azi05
#       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file
#     WHERE azi01=g_aza.aza17
 
     PREPARE afar770_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE afar770_curs1 CURSOR FOR afar770_prepare1
 
     #--->附加費用(幣別/抵減率依申請項次)
     LET l_sql = "SELECT fcj11 ",
                 " FROM fcj_file,faj_file ",
                 " WHERE fcj01 = ?  AND fcj02 = ? ",
                 "   AND fcj03 = faj02 ",
                 "   AND fcj031= faj022 "
    # IF tm.d = 'N' THEN
    #    LET l_sql = l_sql clipped," AND faj43 not matches'[56]' "
    # END IF
 
     PREPARE afar770_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare2:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE afar770_curs2 CURSOR FOR afar770_prepare2
 
#    CALL cl_outnam('afar770') RETURNING l_name             #No.FUN-850092
 
#    START REPORT afar770_rep TO l_name   #No.FUN-850092
     LET g_pageno = 0
 
     FOREACH afar770_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       # 若前面user 按下 control-t 則會顯示目前做到第 n 筆
       IF cl_null(sr.fcc02) THEN LET sr.fcc02=0 END IF
       IF cl_null(sr.fcc09) THEN LET sr.fcc09=0 END IF
       IF cl_null(sr.fcc15) THEN LET sr.fcc15=0 END IF
       IF cl_null(sr.fcc14) THEN LET sr.fcc14=0 END IF
       IF cl_null(sr.fcc16) THEN LET sr.fcc16=0 END IF
       IF cl_null(sr.total1) THEN LET sr.total1 = 0 END IF
       IF cl_null(sr.total2) THEN LET sr.total2 = 0 END IF
       IF sr.fcc15 = 20 AND sr.fcc14 = 'NTD' THEN
          #LET sr.code1 = 'ˇ' LET sr.code2 = '' #No.TQC-5C0037
          LET sr.code1 = 'v' LET sr.code2 = ''   #No.TQC-5C0037
       ELSE
          #LET sr.code1='' LET sr.code2 ='ˇ'    #No.TQC-5C0037
          LET sr.code1='' LET sr.code2 ='v'      #No.TQC-5C0037
       END IF
 
       LET sr.total1 = sr.fcc16                    # 申報實際成本 [主件]
 
       LET l_total1 = 0 LET l_total2 = 0
     #-->計算主件部份的扺減額  .. 為避免小數位四捨五入問題
       #-->扺減額獨立推算
       DECLARE afar770_cost3 CURSOR FOR
      # SELECT fcc24 FROM fcc_file WHERE fcc01=sr.fcc01 AND fcc02=sr.fcc02
        SELECT fcc16 FROM fcc_file WHERE fcc01=sr.fcc01 AND fcc02=sr.fcc02
       LET l_fcc24 = 0
       FOREACH afar770_cost3 INTO l_fcc24
           IF STATUS THEN EXIT FOREACH END IF
           LET l_total1 = l_total1 + (l_fcc24*(sr.fcc15/100))
       END FOREACH
       IF cl_null(l_total1) THEN
          LET l_total1 =(sr.fcc16 * (sr.fcc15/100))   # 主件申報可扺減稅額
       END IF
 
     #-->計算附加費用部份的扺減額 .. 為避免小數位四捨五入問題
       LET l_fcj11 = 0
       IF sr.fcc04 MATCHES '[12]' THEN   #若有附加費用
          FOREACH afar770_curs2
          USING sr.fcc01,sr.fcc02
          INTO l_fcj11
              IF STATUS THEN LET l_total2 = 0 EXIT FOREACH END IF
              IF cl_null(l_fcj11) THEN LET l_fcj11 = 0 END IF
              # 附件申報可扺減稅額
              LET l_total2 = l_total2 + (l_fcj11 * (sr.fcc15/100))
              LET sr.total1= sr.total1 + l_fcj11
          END FOREACH
          CLOSE afar770_curs2
       END IF
 
       LET sr.total2 =l_total1 + l_total2          # 申報可扺減稅額
 
     # 己扺減稅額
       SELECT SUM(fcm04) INTO sr.total3 FROM fcm_file
        WHERE fcm01 = sr.fcc01 AND fcm02 = sr.fcc02
          AND fcm05 <= tm.yy
          AND fcmconf = 'Y'
    {  IF sr.fcc01='OLD-000001' and sr.fcc02 = 47 THEN
          MESSAGE sr.fcc01,' ',sr.fcc02,' ',tm.yy ,' ',sr.total3
          sleep 10
       END IF  }
 
     #-->本期扺減稅額
        SELECT fcm04 INTO sr.fcm04 FROM fcm_file
         WHERE fcm01 = sr.fcc01 AND fcm02 = sr.fcc02
           AND fcm05 = tm.yy
           AND fcmconf = 'Y'
       IF cl_null(sr.fcm04) THEN LET sr.fcm04 = 0 END IF
 
     #-->之前無扺減, 還是要印出來
       LET l_n = 0
       SELECT COUNT(*) INTO l_n FROM fcm_file
        WHERE fcm01 = sr.fcc01 AND fcm02 = sr.fcc02
          AND fcmconf = 'Y'
 
     #-->若本期無資料, 表之前已扺減完畢
       IF sr.fcm04 = 0 AND l_n != 0 THEN CONTINUE FOREACH END IF
 
     #-->未扺減稅額
       LET sr.total3 = sr.total2 - sr.total3
       IF l_n = 0 THEN LET sr.total3 = sr.total2 END IF
#No.FUN-850092    ----begin
       LET l_name = 'afar770'    
#      OUTPUT TO REPORT afar770_rep(sr.*)        
       EXECUTE insert_prep USING sr.fcc19,sr.fcc05,sr.fcc09,sr.fcc10,sr.fcb03,
                                 sr.fcb04,sr.fcb05,sr.fcb06,sr.code1,sr.code2,
                                 #sr.total1,sr.fcc15,sr.total2,sr.fcm04,sr.total3    #TQC-AB0191 mark
                                 sr.total1,sr.total2,sr.fcc15,sr.fcm04,sr.total3     #TQC-AB0191
#No.FUN-850092  ----end
     END FOREACH
 
#No.FUN-850092 ----begin                                                                                                            
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                        
    IF g_zz05 = 'Y' THEN                                                                                                            
         CALL cl_wcchp(tm.wc,'fcb04,fcb06,fcc14,fcc15,fcb03,fcb05,fcb01')                                                                       
              RETURNING tm.wc                                                                                                       
    END IF                                                                                                                          
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                                             
     LET g_str = tm.wc,";",g_azi04,";",g_azi05,";",tm.yy                                                                                              
     CALL cl_prt_cs3('afar770',l_name,l_sql,g_str)                                                                                  
#    FINISH REPORT afar770_rep                    #No.FUN-850092
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #No.FUN-850092
#No.FUN-850092 ----end        
END FUNCTION
 
#EPORT afar770_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
#         l_n          LIKE type_file.num5,         #No.FUN-680070 SMALLINT
#         l_faj261     LIKE type_file.num5,         #No.FUN-680070 SMALLINT
#         l_faj262     LIKE type_file.num5,         #No.FUN-680070 SMALLINT
#         l_str        STRING,
#         sr               RECORD fcc02  LIKE fcc_file.fcc02,
#                                 fcc04  LIKE fcc_file.fcc04,
#                                 fcc05  LIKE fcc_file.fcc05,
#                                 fcc09  LIKE fcc_file.fcc09,
#                                 fcc10  LIKE fcc_file.fcc10,
#                                 fcc19  LIKE fcc_file.fcc19,
#                                 fcc16  LIKE fcc_file.fcc16,
#                                 fcb03  LIKE fcb_file.fcb03,
#                                 fcb04  LIKE fcb_file.fcb04,
#                                 fcb05  LIKE fcb_file.fcb05,
#                                 fcb06  LIKE fcb_file.fcb06,
#                                 code1  LIKE type_file.chr2,         #No.FUN-680070 VARCHAR(2)
#                                 code2  LIKE type_file.chr2,         #No.FUN-680070 VARCHAR(2)
#                                 total1 LIKE type_file.num20_6,      #No.FUN-680070 DEC(20,6)
#                                 fcc15  LIKE fcc_file.fcc15,
#                                 fcc14  LIKE fcc_file.fcc14,
#                                 total2 LIKE type_file.num20_6,      #No.FUN-680070 DEC(20,6)
#                                 fcc01  LIKE fcc_file.fcc01,
#                                 fcm04  LIKE fcm_file.fcm04,
#                                 total3 LIKE type_file.num20_6      #No.FUN-680070 DEC(20,6)
#                       END RECORD
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.fcb03,sr.fcb04,sr.fcc02
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     LET g_x[1] = tm.yy-1911 USING '###&',g_x[1]
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED    #No.TQC-6A0085
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED, pageno_total
#     PRINT g_dash[1,g_len]
#     PRINT COLUMN g_c[36],g_x[12],
#           COLUMN g_c[38],g_x[13],
#           COLUMN g_c[40],g_x[14],
#           COLUMN g_c[44],g_x[15],
#           COLUMN g_c[45],g_x[16],
#           COLUMN g_c[46],g_x[17]
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
#           g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],
#           g_x[45],g_x[46],g_x[47]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  ON EVERY ROW
#        LET l_faj261 = YEAR(sr.fcc19) -1911
#        LET l_faj262 = YEAR(sr.fcc19) + 4  -1911
#        IF cl_null(l_faj261) THEN LET l_faj261 = 0 END IF
#        IF cl_null(l_faj262) THEN LET l_faj262 = 0 END IF
#        LET l_n = l_n + 1
#        PRINT COLUMN g_c[31],l_n USING '###&',
#              COLUMN g_c[32],sr.fcc05,
#              COLUMN g_c[33],cl_numfor(sr.fcc09,33,0),
#              COLUMN g_c[34],sr.fcc10;
#        LET l_str = MONTH(sr.fcc19) USING '&&','/',
#                    DAY(sr.fcc19)   USING '&&','/',
#                    YEAR(sr.fcc19)  USING '&&&&'
#        PRINT COLUMN g_c[35],l_str;
#        LET l_str = MONTH(sr.fcb03) USING '&&','/',
#                    DAY(sr.fcb03)   USING '&&','/',
#                    YEAR(sr.fcb03)  USING '&&&&'
#        PRINT COLUMN g_c[36],l_str,
#              COLUMN g_c[37],sr.fcb04[1,20];
#        LET l_str = MONTH(sr.fcb05) USING '&&','/',
#                    DAY(sr.fcb05)   USING '&&','/',
#                    YEAR(sr.fcb05)  USING '&&&&'
#        PRINT COLUMN g_c[38],l_str,
#              COLUMN g_c[39],sr.fcb06[1,20],
#              COLUMN g_c[40], sr.code1,
#              COLUMN g_c[41], sr.code2,
#              COLUMN g_c[42], cl_numfor(sr.total1,42,g_azi04),
#              COLUMN g_c[43], sr.fcc15  USING '#####&',
#              COLUMN g_c[44],cl_numfor(sr.total2,44,g_azi04),
#              COLUMN g_c[45],cl_numfor(sr.fcm04,45,g_azi04),
#              COLUMN g_c[46],cl_numfor(sr.total3,46,g_azi04);
#        LET l_str = l_faj261 USING '#&',g_x[9],
#                    l_faj262 USING '#&',g_x[10]
#        PRINT COLUMN g_c[47],l_str
 
#  ON LAST ROW
#     PRINT COLUMN g_c[41],g_x[11] CLIPPED,
#           COLUMN g_c[42],cl_numfor(SUM(sr.total1),42,g_azi05),
#           COLUMN g_c[44],cl_numfor(SUM(sr.total2),44,g_azi05),
#           COLUMN g_c[45],cl_numfor(SUM(sr.fcm04),45,g_azi05),
#           COLUMN g_c[46],cl_numfor(SUM(sr.total3),46,g_azi05)
#     PRINT g_dash[1,g_len]
#     LET l_last_sw = 'y'
#     PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#   #  PRINT '~i;'
 
#  PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#          PRINT g_dash[1,g_len]
#          PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE
#          SKIP 2 LINE
#      END IF
 
#ND REPORT
#FUN-870144
 
