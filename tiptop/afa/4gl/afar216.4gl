# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: afar216.4gl
# Desc/riptions...: 固定資產移轉明細表
# Date & Author..: 96/06/11 By WUPN
# Modify.........: No.FUN-510035 05/01/19 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-5A0162 05/10/31 By Sarah 報表抬頭忘記印移轉前、移轉後
# Modify.........: No.TQC-610055 06/06/27 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6C0009 06/12/08 By Rayven 表頭制表日期等位置調整
# Modify.........: NO.FUN-7A0036 07/10/30 By zhaijie 報表改為Crystal Reports
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-AB0134 10/11/28 By suncx 列印時中文名稱(faj06)未帶出顯示
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD                                  # Print condition RECORD
             wc      STRING,                      # Where condition
             s       LIKE type_file.chr3,         # Order by sequence             #No.FUN-680070 VARCHAR(3)
             t       LIKE type_file.chr3,         # Eject sw                      #No.FUN-680070 VARCHAR(3)
             more    LIKE type_file.chr1          # Input more condition(Y/N)     #No.FUN-680070 VARCHAR(1)
          END RECORD,
       g_aza17       LIKE aza_file.aza17,         # 本國幣別
       g_dates       LIKE type_file.chr6,         #No.FUN-680070 VARCHAR(6)
       g_datee       LIKE type_file.chr6,         #No.FUN-680070 VARCHAR(6)
       l_bdates      LIKE type_file.dat,          #No.FUN-680070 DATE
       l_bdatee      LIKE type_file.dat,          #No.FUN-680070 DATE
       g_fas01       LIKE fas_file.fas01,         #No.FUN-680070 VARCHAR(10)
       g_total       LIKE type_file.num20_6,      #No.FUN-680070 DECIMAL(13,3)
       swth          LIKE type_file.chr1          #No.FUN-680070 VARCHAR(1)
DEFINE g_i           LIKE type_file.num5          #count/index for any purpose    #No.FUN-680070 SMALLINT
 
DEFINE l_table       STRING                       #NO.FUN-7A0036 暫存檔
DEFINE g_str         STRING                       #NO.FUN-7A0036 組參數
DEFINE g_sql         STRING                       #NO.FUN-7A0036 抓取暫存盤資料sql
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
#NO.FUN-7A0036  錄入CR所需的暫存檔--start---
 
   LET g_sql="faj04.faj_file.faj04,fas01.fas_file.fas01,fas02.fas_file.fas02,",
             "fas04.fas_file.fas04,fas03.fas_file.fas03,fas05.fas_file.fas05,",
             "fas06.fas_file.fas06,fat02.fat_file.fat02,fat03.fat_file.fat03,",
             "fat031.fat_file.fat031,faj06.faj_file.faj06,",
             "fap18.fap_file.fap18,fap17.fap_file.fap17,fap19.fap_file.fap19,",
             "fap12.fap_file.fap12,fap13.fap_file.fap13,fap15.fap_file.fap15,",
             "fap16.fap_file.fap16,fap14.fap_file.fap14,fat04.fat_file.fat04,",
             "fat05.fat_file.fat05,fat06.fat_file.fat06,fat07.fat_file.fat07,",
             "fat08.fat_file.fat08,fat09.fat_file.fat09,fat10.fat_file.fat10,",
             "fat11.fat_file.fat11"
   LET l_table = cl_prt_temptable('afar216',g_sql) CLIPPED
    IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,",
               "       ?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
     CALL cl_err('insert_pret:',status,1) EXIT PROGRAM
   END IF
#NO.FUN-7A0036 ---end----
 
   LET g_pdate = ARG_VAL(1)             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)   #TQC-610055
   LET tm.t  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r216_tm(0,0)		# Input print condition
      ELSE CALL afar216()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION r216_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 14
 
   OPEN WINDOW r216_w AT p_row,p_col WITH FORM "afa/42f/afar216"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Defaslt condition
   LET tm.s    = '3'
   LET tm.t    = 'Y  '
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
 
   WHILE TRUE
   #  DISPLAY BY NAME tm.s,tm.t,tm.more
                      # Condition
      CONSTRUCT BY NAME tm.wc ON faj04,fat03,fas01,fas02,fas04,fas03,fas05
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
         LET INT_FLAG = 0 CLOSE WINDOW r216_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF
    # DISPLAY BY NAME tm.s,tm.t,tm.more
                      # Condition
         INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3, tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
            AFTER FIELD more
               IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
                  NEXT FIELD more
               END IF
               IF tm.more = 'Y' THEN
                  CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies)
                  RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
               END IF
            ON ACTION CONTROLR
               CALL cl_show_req_fields()
            ON ACTION CONTROLG
               CALL cl_cmdask()	# Command execution
            AFTER INPUT
               LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
               LET tm.t = tm2.t1,tm2.t2,tm2.t3
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
         LET INT_FLAG = 0 CLOSE WINDOW r216_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='afar216'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar216','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.s CLIPPED,"'",
                            " '",tm.t CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('afar216',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW r216_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar216()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r216_w
END FUNCTION
 
FUNCTION afar216()
   DEFINE l_name	LIKE type_file.chr20,                   # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0069
          l_sql 	LIKE type_file.chr1000,                 # RDSQL STATEMENT                #No.FUN-680070 VARCHAR(1000)
          l_chr		LIKE type_file.chr1,                    #No.FUN-680070 VARCHAR(1)
          l_za05	LIKE type_file.chr1000,                 #No.FUN-680070 VARCHAR(40)
          l_order	ARRAY[6] OF LIKE fas_file.fas01,        #No.FUN-680070 VARCHAR(10)
          sr            RECORD order1 LIKE fas_file.fas01,      #No.FUN-680070 VARCHAR(10)
                               order2 LIKE fas_file.fas01,      #No.FUN-680070 VARCHAR(10)
                               order3 LIKE fas_file.fas01,      #No.FUN-680070 VARCHAR(10)
                               faj04 LIKE faj_file.faj04,	#
                               fas01 LIKE fas_file.fas01,	#
                               fas02 LIKE fas_file.fas02,	#
                               fas04 LIKE fas_file.fas04,	#
                               fas03 LIKE fas_file.fas03,	#
                               fas05 LIKE fas_file.fas05,	#
                               fas06 LIKE fas_file.fas06,	#
                               fat02 LIKE fat_file.fat02,	#
                               fat03 LIKE fat_file.fat03,	#
                               fat031 LIKE fat_file.fat031,	#
                               faj06 LIKE faj_file.faj06,	#
                               fap18 LIKE fap_file.fap18,	#
                               fap17 LIKE fap_file.fap17,	#
                               fap19 LIKE fap_file.fap19,	#
                               fap12 LIKE fap_file.fap12,	#
                               fap13 LIKE fap_file.fap13,	#
                               fap15 LIKE fap_file.fap15,	#
                               fap16 LIKE fap_file.fap16,	#
                               fap14 LIKE fap_file.fap14,	#
                               fat04 LIKE fat_file.fat04,	#
                               fat05 LIKE fat_file.fat05,	#
                               fat06 LIKE fat_file.fat06,	#
                               fat07 LIKE fat_file.fat07,	#
                               fat08 LIKE fat_file.fat08,	#
                               fat09 LIKE fat_file.fat09,	#
                               fat10 LIKE fat_file.fat10,	#
                               fat11 LIKE fat_file.fat11 	#
                        END RECORD
     CALL cl_del_data(l_table)                                  #NO.FUN-7A0036
    
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='afar216'  #NO.FUN-7A0036
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fasuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND fasgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND fasgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fasuser', 'fasgrup')
     #End:FUN-980030
 
 
     LET l_sql = "SELECT '','','',",
                 "   faj04, fas01,  fas02,  fas04,  fas03,  fas05, fas06,",
                 "  fat02,  fat03,",
                 "   fat031,  faj06,",
                 " fap18, fap17, fap19, fap12, fap13, fap15,fap16, fap14, ",
                 "  fat04, fat05, fat06, fat07, fat08, fat09, fat10,fat11",
                 " FROM fas_file,fat_file,fap_file,OUTER faj_file ",
                 " WHERE fas01 = fat01 " ,
                 "   AND fasconf != 'X' " ,  #增010801
                 "   AND fat_file.fat03=faj_file.faj02 " ,
                 #"   AND fat_file.fat031=faj_file.faj02 " ,    #TQC-AB0134 mark
                 "   AND fat_file.fat031=faj_file.faj022 " ,    #TQC-AB0134 add
                 "   AND fas01 = fap50 " ,
                 "   AND fat02 = fap501 " ,
                 "   AND fat03 = fap02 " ,
                 "   AND fat031 = fap021 " ,
                 "   AND fap03 = '3'" ,
                 "   AND fas02 = fap04 " ,
                 " AND ",tm.wc
 
     LET  g_total = 0
    
     PREPARE r216_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE r216_cs1 CURSOR FOR r216_prepare1
#     CALL cl_outnam('afar216') RETURNING l_name       #NO.FUN-7A0036
                 
#     START REPORT r216_rep TO l_name                  #NO.FUN-7A0036
#     LET g_pageno = 0                                 #NO.FUN-7A0036
 
     FOREACH r216_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
#NO.FUN-7A0036 ----start----remark-----
{       FOR g_i = 1 TO 3
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.faj04
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.fat03
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.fas01
               WHEN tm.s[g_i,g_i] = '4'
                     LET l_order[g_i] = sr.fas02 USING 'yyyymmdd'
               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.fas04
               WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.fas03
               WHEN tm.s[g_i,g_i] = '7'
                     LET l_order[g_i] = sr.fas05 USING 'yyyymmdd'
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
}
       INITIALIZE g_fas01 TO NULL
       IF cl_null(sr.fat07) THEN LET sr.fat07=0 END IF
 
#NO.FUN-7A0036--------end---
#NO.FUN-7A0036--------start--
 
     EXECUTE insert_prep USING 
       sr.faj04,sr.fas01,sr.fas02,sr.fas04,sr.fas03,sr.fas05,sr.fas06,
       sr.fat02,sr.fat03,sr.fat031,sr.faj06,sr.fap18,sr.fap17,sr.fap19,
       sr.fap12,sr.fap13,sr.fap15,sr.fap16,sr.fap14,sr.fat04,sr.fat05,
       sr.fat06,sr.fat07,sr.fat08,sr.fat09,
       sr.fat10,sr.fat11
 
#NO.FUN-7A0036--------end--
     END FOREACH
 
#     FINISH REPORT r216_rep                        #NO.FUN-7A0036
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)   #NO.FUN-7A0036
#NO.FUN-7A0036 ---------start---
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 
     IF g_zz05 ='Y' THEN 
      CALL cl_wcchp(tm.wc,'faj04,fat03,fas01,fas02,fas04,fas03,fas05')
            RETURNING tm.wc
     END IF
     LET g_str = tm.wc,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
                  tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3]
     CALL cl_prt_cs3('afar216','afar216',g_sql,g_str)
       
           
#NO.FUN-7A0036 ---------end---
 
END FUNCTION
#NO.FUN-7A0036 ------start----mark----
{REPORT r216_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_str         LIKE type_file.chr50,        #列印排列順序說明         #No.FUN-680070 VARCHAR(50)
          l_str1        LIKE type_file.chr20,        #列印合計的前置說明       #No.FUN-680070 VARCHAR(10)
          l_str2        LIKE type_file.chr20,        #列印合計的前置說明       #No.FUN-680070 VARCHAR(10)
          l_str3        LIKE type_file.chr20,        #列印合計的前置說明       #No.FUN-680070 VARCHAR(10)
          l_total       LIKE type_file.num20_6,      #No.FUN-680070 DECIMAL(12,3)
          sq1           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          sq2           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          sq3           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_ima08       LIKE ima_file.ima08,
          l_ima37       LIKE ima_file.ima08,
          sr               RECORD order1 LIKE fas_file.fas01,   #No.FUN-680070 VARCHAR(10)
                                  order2 LIKE fas_file.fas01,   #No.FUN-680070 VARCHAR(10)
                                  order3 LIKE fas_file.fas01,   #No.FUN-680070 VARCHAR(10)
                                  faj04 LIKE faj_file.faj04,	#
                                  fas01 LIKE fas_file.fas01,	#
                                  fas02 LIKE fas_file.fas02,	#
                                  fas04 LIKE fas_file.fas04,	#
                                  fas03 LIKE fas_file.fas03,	#
                                  fas05 LIKE fas_file.fas05,	#
                                  fas06 LIKE fas_file.fas06,	#
                                  fat02 LIKE fat_file.fat02,	#
                                  fat03 LIKE fat_file.fat03,	#
                                  fat031 LIKE fat_file.fat031,	#
                                  faj06 LIKE faj_file.faj06,	#
                                  fap18 LIKE fap_file.fap18,	#
                                  fap17 LIKE fap_file.fap17,	#
                                  fap19 LIKE fap_file.fap19,	#
                                  fap12 LIKE fap_file.fap12,	#
                                  fap13 LIKE fap_file.fap13,	#
                                  fap15 LIKE fap_file.fap15,	#
                                  fap16 LIKE fap_file.fap16,	#
                                  fap14 LIKE fap_file.fap14,	#
                                  fat04 LIKE fat_file.fat04,	#
                                  fat05 LIKE fat_file.fat05,	#
                                  fat06 LIKE fat_file.fat06,	#
                                  fat07 LIKE fat_file.fat07,	#
                                  fat08 LIKE fat_file.fat08,	#
                                  fat09 LIKE fat_file.fat09,	#
                                  fat10 LIKE fat_file.fat10,	#
                                  fat11 LIKE fat_file.fat11 	#
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3,sr.fas01,sr.fat02
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]  #No.TQC-6C0009 mark
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]  #No.TQC-6C0009
      PRINT g_dash[1,g_len]
     #start FUN-5A0162
      PRINT COLUMN g_c[41],'--------------------------------------------',
            COLUMN g_c[44],g_x[9] CLIPPED,
            COLUMN g_c[45],'----------------------------------------',
            COLUMN g_c[49],'--------------------------------------------',
            COLUMN g_c[52],g_x[10] CLIPPED,
            COLUMN g_c[53],'----------------------------------------'
     #end FUN-5A0162
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
            g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],
            g_x[47],g_x[48],g_x[49],g_x[50],g_x[51],g_x[52],g_x[53],g_x[54],
            g_x[55],g_x[56]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 6)
         THEN SKIP TO TOP OF PAGE
      END IF
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 6)
         THEN SKIP TO TOP OF PAGE
      END IF
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 6)
         THEN SKIP TO TOP OF PAGE
      END IF
 
 
     BEFORE GROUP OF sr.fas01
      IF g_fas01 IS NULL OR  g_fas01!=sr.fas01 THEN
          LET swth = 'Y'
      ELSE LET swth='N'
      END IF
 
   ON EVERY ROW
      IF swth='Y' THEN
         PRINT COLUMN g_c[31],sr.fas01,
               COLUMN g_c[32],sr.fas02,
               COLUMN g_c[33],sr.fas04,
               COLUMN g_c[34],sr.fas03,
               COLUMN g_c[35],sr.fas05,
               COLUMN g_c[36],sr.fas06;
         LET swth='N'
      ELSE
         PRINT ;
      END IF
         PRINT COLUMN g_c[37],sr.fat02 USING '####',
               COLUMN g_c[38],sr.fat03,
               COLUMN g_c[39],sr.fat031,
               COLUMN g_c[40],sr.faj06,
               COLUMN g_c[41],sr.fap18,
               COLUMN g_c[42],sr.fap17,
               COLUMN g_c[43],sr.fap19,
               COLUMN g_c[44],sr.fap12[1,10],
               COLUMN g_c[45],sr.fap13[1,10],
               COLUMN g_c[46],sr.fap15,
               COLUMN g_c[47],sr.fap16,
               COLUMN g_c[48],sr.fap14[1,10],
               COLUMN g_c[49],sr.fat04,
               COLUMN g_c[50],sr.fat05,
               COLUMN g_c[51],sr.fat06,
               COLUMN g_c[52],sr.fat07[1,10],
               COLUMN g_c[53],sr.fat08[1,10],
               COLUMN g_c[54],sr.fat09,
               COLUMN g_c[55],sr.fat10,
               COLUMN g_c[56],sr.fat11[1,10]
 
ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN
              PRINT g_dash[1,g_len]
            #-- TQC-630166 begin
#             IF tm.wc[001,070] > ' ' THEN			# for 80
#	         PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#             IF tm.wc[071,140] > ' ' THEN
# 	         PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#             IF tm.wc[141,210] > ' ' THEN
# 	         PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#             IF tm.wc[211,280] > ' ' THEN
# 	         PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
              #IF tm.wc[001,120] > ' ' THEN			# for 132
 	      #   PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
              #IF tm.wc[121,240] > ' ' THEN
 	      #   PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
              #IF tm.wc[241,300] > ' ' THEN
 	      #   PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
              CALL cl_prt_pos_wc(tm.wc)
            #-- TQC-630166 end
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
    IF l_last_sw = 'n'
        THEN PRINT g_dash[1,g_len]
             PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
        ELSE SKIP 2 LINES
     END IF
END REPORT}
#NO.FUN-7A0036 ----------end---------
