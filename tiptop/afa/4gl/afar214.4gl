# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: afar214.4gl
# Desc/riptions...: 固定資產外送明細表
# Date & Author..: 96/06/11 By WUPN
# Modify.........: No.FUN-510035 05/01/18 By Smapmin 報表轉XML格式
# Modify.........: No.TQC-610055 06/06/27 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-850005 08/05/07 By Sunyanchun  老報表轉CR
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-B70113 11/07/12 By Dido 排除狀態為'0','5','6','X'資產 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD                               # Print condition RECORD
             wc   STRING,                      # Where condition
             s    LIKE type_file.chr3,         # Order by sequence           #No.FUN-680070 VARCHAR(3)
             t    LIKE type_file.chr3,         # Eject sw                    #No.FUN-680070 VARCHAR(3)
             c    LIKE type_file.chr3,         # print gkf_file detail(Y/N)  #No.FUN-680070 VARCHAR(3)
             a    LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
             b    LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
             d    LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
             more LIKE type_file.chr1          # Input more condition(Y/N)   #No.FUN-680070 VARCHAR(1)
          END RECORD,
        g_aza17   LIKE aza_file.aza17,         # 本國幣別
        g_dates   LIKE type_file.chr6,         #No.FUN-680070 VARCHAR(6)
        g_datee   LIKE type_file.chr6,         #No.FUN-680070 VARCHAR(6)
        l_bdates  LIKE type_file.dat,          #No.FUN-680070 DATE
        l_bdatee  LIKE type_file.dat,          #No.FUN-680070 DATE
        g_fau01   LIKE fau_file.fau01,         #No.FUN-680070 VARCHAR(10)
        g_total   LIKE type_file.num20_6,      #No.FUN-680070 DECIMAL(13,3)
        swth      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        g_str1    LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(15)
        g_str2    LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(15)
        g_str3    LIKE type_file.chr20         #No.FUN-680070 VARCHAR(15)
DEFINE  g_i       LIKE type_file.num5          #count/index for any purpose  #No.FUN-680070 SMALLINT
DEFINE  g_sql     STRING    #NO.FUN-850005
DEFINE  g_str     STRING    #NO.FUN-850005
DEFINE  l_table   STRING    #NO.FUN-850005
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                             # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
   #NO.FUN-850005---BEGIN----
   LET g_sql = "order1.fau_file.fau01,",    
              "order2.fau_file.fau01,",  
              "order3.fau_file.fau01,", 
              "fau01.fau_file.fau01,", 
              "fau02.fau_file.fau02,",
              "fau03.fau_file.fau03,",
              "fau04.fau_file.fau04,",
              "fau05.fau_file.fau05,",
              "fav02.fav_file.fav02,",
              "fav03.fav_file.fav03,",
              "fav031.fav_file.fav031,",
              "faj06.faj_file.faj06,",
              "fav04.fav_file.fav04,",
              "faj18.faj_file.faj18,",
              "fav06.fav_file.fav06,",
              "fav05.fav_file.fav05,",
              "fav07.fav_file.fav07"
   LET l_table = cl_prt_temptable('afar214',g_sql)
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"                                                                                             
   PREPARE insert_prep FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1)                                                                                        
      EXIT PROGRAM                                                                                                                 
   END IF
   #NO.FUN-850005---END------
 
   LET g_pdate = ARG_VAL(1)	               # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.c  = ARG_VAL(10)   #TQC-610055
   LET tm.a  = ARG_VAL(11)
   LET tm.b  = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r214_tm(0,0)		# Input print condition
      ELSE CALL afar214()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION r214_tm(p_row,p_col)
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01         #No.FUN-580031
DEFINE p_row,p_col   LIKE type_file.num5,        #No.FUN-680070 SMALLINT
       l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 17
 
   OPEN WINDOW r214_w AT p_row,p_col WITH FORM "afa/42f/afar214"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.s    = '3'
   LET tm.c    = 'Y  '
   LET tm.t    = 'Y  '
   LET tm.a    = '3'
   LET tm.b    = '3'
   LET tm.d    = 'N'
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
   LET tm2.u1   = tm.c[1,1]
   LET tm2.u2   = tm.c[2,2]
   LET tm2.u3   = tm.c[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
 
   WHILE TRUE
   #  DISPLAY BY NAME tm.s,tm.c,tm.t,tm.more,tm.a,tm.b,tm.d
                      # Condition
      CONSTRUCT BY NAME tm.wc ON faj04,fav03,fau01,fau02,fau04,fau03,fau05
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
         LET INT_FLAG = 0 CLOSE WINDOW r214_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF
   #  DISPLAY BY NAME tm.d,tm.a,tm.b,tm.s,tm.c,tm.t,tm.more
                      # Condition
         INPUT BY NAME
            tm.d,tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,
            tm2.u1,tm2.u2,tm2.u3,tm.a,tm.b,tm.more
            WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
            AFTER FIELD a
               IF tm.a NOT MATCHES "[123]" OR tm.a IS NULL THEN
                  NEXT FIELD a
               END IF
            AFTER FIELD b
               IF tm.b NOT MATCHES "[123]" OR tm.b IS NULL THEN
                  NEXT FIELD b
               END IF
            AFTER FIELD d
               IF tm.d NOT MATCHES "[YN]" OR tm.d IS NULL THEN
                  NEXT FIELD d
               END IF
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
                LET tm.c = tm2.u1,tm2.u2,tm2.u3
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
         LET INT_FLAG = 0 CLOSE WINDOW r214_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='afar214'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar214','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_lang CLIPPED,"'",
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.s CLIPPED,"'",
                            " '",tm.t CLIPPED,"'",
                            " '",tm.c CLIPPED,"'",
                            " '",tm.a CLIPPED,"'",
                            " '",tm.b CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('afar214',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW r214_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar214()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r214_w
END FUNCTION
 
FUNCTION afar214()
   DEFINE l_name	LIKE type_file.chr20,                   # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0069
          l_sql 	STRING,                     # RDSQL STATEMENT                #No.FUN-680070 CHAR(1000) #MOD-B70113 mod STRING
          l_chr		LIKE type_file.chr1,                    #No.FUN-680070 VARCHAR(1)
          l_za05	LIKE type_file.chr1000,                 #No.FUN-680070 VARCHAR(40)
          l_order	ARRAY[6] OF LIKE fau_file.fau01,        #No.FUN-680070 VARCHAR(10)
          sr            RECORD order1 LIKE fau_file.fau01,      #No.FUN-680070 VARCHAR(10)
                               order2 LIKE fau_file.fau01,      #No.FUN-680070 VARCHAR(10)
                               order3 LIKE fau_file.fau01,      #No.FUN-680070 VARCHAR(10)
                               faj04 LIKE faj_file.faj04,	#
                               fau01 LIKE fau_file.fau01,	#
                               fau02 LIKE fau_file.fau02,	#
                               fau04 LIKE fau_file.fau04,	#
                               fau03 LIKE fau_file.fau03,	#
                               fau05 LIKE fau_file.fau05,	#
                               fav02 LIKE fav_file.fav02,	#
                               fav03 LIKE fav_file.fav03,	#
                               fav031 LIKE fav_file.fav031,	#
                               faj06 LIKE faj_file.faj06,	#
                               fav04 LIKE fav_file.fav04,	#
                               faj18 LIKE faj_file.faj18,	#
                               fav06 LIKE fav_file.fav06,	#
                               fav05 LIKE fav_file.fav05,	#
                               fav07 LIKE fav_file.fav07, 	#
                               faj43 LIKE faj_file.faj43        #MOD-B70113
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fauuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND faugrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND faugrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fauuser', 'faugrup')
     #End:FUN-980030
 
 
     IF tm.a='1' THEN LET tm.wc=tm.wc CLIPPED," AND fauconf='Y' " END IF
     IF tm.a='2' THEN LET tm.wc=tm.wc CLIPPED," AND fauconf='N' " END IF
     IF tm.b='1' THEN LET tm.wc=tm.wc CLIPPED," AND faupost='Y' " END IF
     IF tm.b='2' THEN LET tm.wc=tm.wc CLIPPED," AND faupost='N' " END IF
     IF tm.d='Y' THEN LET tm.wc=tm.wc CLIPPED," AND fav04 > fav07 " END IF
 
     LET l_sql = "SELECT '','','',",
                 "   faj04, fau01, fau02, fau04, fau03, fau05, fav02, fav03,",
                 "   fav031,faj06, fav04, faj18, fav06, fav05, fav07, faj43 ", #MOD-B70113 add faj43
                 " FROM fau_file,fav_file,OUTER faj_file  ",
                 " WHERE fau01 = fav01 " ,
                 "   AND fauconf != 'X' " , #增010801
                 "   AND fav_file.fav03=faj_file.faj02 " ,
                 "   AND fav_file.fav031=faj_file.faj022 " ,
                 " AND ",tm.wc
     LET  g_total = 0
 
     PREPARE r214_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE r214_cs1 CURSOR FOR r214_prepare1
 #    CALL cl_outnam('afar214') RETURNING l_name    #NO.FUN-850005
 
#     START REPORT r214_rep TO l_name    #NO.FUN-850005
     LET g_pageno = 0
 
     IF NOT cl_null(tm.s[1,1]) THEN
        LET g_i=tm.s[1,1] LET g_str1=g_x[14+g_i]
     END IF
     IF NOT cl_null(tm.s[2,2]) THEN
        LET g_i=tm.s[2,2] LET g_str2=g_x[14+g_i]
     END IF
     IF NOT cl_null(tm.s[3,3]) THEN
        LET g_i=tm.s[3,3] LET g_str3=g_x[14+g_i]
     END IF
     CALL cl_del_data(l_table)   #NO.FUN-850005
     FOREACH r214_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
      #-MOD-B70113-add-
       IF sr.faj43 MATCHES '[056X]' THEN
          CONTINUE FOREACH 
       END IF    
      #-MOD-B70113-end-
       FOR g_i = 1 TO 3
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.faj04
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.fav03
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.fau01
               WHEN tm.s[g_i,g_i] = '4'
                    LET l_order[g_i] = sr.fau02 USING 'yyyymmdd'
               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.fau04
               WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.fau03
               WHEN tm.s[g_i,g_i] = '7'
                    LET l_order[g_i] = sr.fau05 USING 'yyyymmdd'
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
       INITIALIZE g_fau01 TO NULL
       IF cl_null(sr.fav07) THEN LET sr.fav07=0 END IF
       #NO.FUN-850005----BEGIN-----
       EXECUTE insert_prep USING sr.order1,sr.order2,sr.order3,sr.fau01,
                                 sr.fau02,sr.fau03,sr.fau04,sr.fau05,
                                 sr.fav02,sr.fav03,sr.fav031,sr.faj06,
                                 sr.fav04,sr.faj18,sr.fav06,sr.fav05,
                                 sr.fav07
       #OUTPUT TO REPORT r214_rep(sr.*)
       #NO.FUN-850005----END-----
     END FOREACH
     #NO.FUN-850005------BEGIN--------
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog            
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'faj04,fav03,fau01,fau02,fau04,fau03,fau05')
            RETURNING tm.wc
     ELSE
        LET tm.wc = ""
     END IF
     LET g_str = tm.wc,";",tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",
             tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.c[1,1],";",
             tm.c[2,2],";",tm.c[3,3]
     CALL cl_prt_cs3('afar214','afar214',g_sql,g_str)
     #FINISH REPORT r214_rep
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #NO.FUN-850005----END-----
END FUNCTION
#NO.FUN-850005-----BEGIN-------
#REPORT r214_rep(sr)
#  DEFINE l_last_sw	LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
#         l_str         LIKE type_file.chr50,        #列印排列順序說明         #No.FUN-680070 VARCHAR(50)
#         l_str1        LIKE type_file.chr20,        #列印合計的前置說明       #No.FUN-680070 VARCHAR(10)
#         l_str2        LIKE type_file.chr20,        #列印合計的前置說明       #No.FUN-680070 VARCHAR(10)
#         l_str3        LIKE type_file.chr20,        #列印合計的前置說明       #No.FUN-680070 VARCHAR(10)
#         l_total       LIKE type_file.num20_6,      #No.FUN-680070 DECIMAL(12,3)
#         sq1           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
#         sq2           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
#         sq3           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
#         l_ima08       LIKE ima_file.ima08,
#         l_ima37       LIKE ima_file.ima08,
#         sr               RECORD order1 LIKE fau_file.fau01,   #No.FUN-680070 VARCHAR(10)
#                                 order2 LIKE fau_file.fau01,   #No.FUN-680070 VARCHAR(10)
#                                 order3 LIKE fau_file.fau01,   #No.FUN-680070 VARCHAR(10)
#                                 faj04 LIKE faj_file.faj04,	#
#                                 fau01 LIKE fau_file.fau01,	#
#                                 fau02 LIKE fau_file.fau02,	#
#                                 fau04 LIKE fau_file.fau04,	#
#                                 fau03 LIKE fau_file.fau03,	#
#                                 fau05 LIKE fau_file.fau05,	#
#                                 fav02 LIKE fav_file.fav02,	#
#                                 fav03 LIKE fav_file.fav03,	#
#                                 fav031 LIKE fav_file.fav031,	#
#                                 faj06 LIKE faj_file.faj06,	#
#                                 fav04 LIKE fav_file.fav04,	#
#                                 faj18 LIKE faj_file.faj18,	#
#                                 fav06 LIKE fav_file.fav06,	#
#                                 fav05 LIKE fav_file.fav05,	#
#                                 fav07 LIKE fav_file.fav07 	#
#                       END RECORD
#
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.order1,sr.order2,sr.order3,sr.fau01,sr.fav02
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED, pageno_total
#     PRINT g_dash[1,g_len]
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#           g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
#
#  BEFORE GROUP OF sr.order1
#     IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#        THEN SKIP TO TOP OF PAGE
#     END IF
#  BEFORE GROUP OF sr.order2
#     IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#        THEN SKIP TO TOP OF PAGE
#     END IF
#  BEFORE GROUP OF sr.order3
#     IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#        THEN SKIP TO TOP OF PAGE
#     END IF
 
#
#    BEFORE GROUP OF sr.fau01
#     IF g_fau01 IS NULL OR  g_fau01!=sr.fau01 THEN
#         LET swth = 'Y'
#     ELSE LET swth='N'
#     END IF
 
#  ON EVERY ROW
#     IF swth='Y' THEN
#        PRINT COLUMN g_c[31],sr.fau01,
#              COLUMN g_c[32],sr.fau02,
#              COLUMN g_c[33],sr.fau04,
#              COLUMN g_c[34],sr.fau03,
#              COLUMN g_c[35],sr.fau05;
#        LET swth='N'
#     END IF
#        PRINT COLUMN g_c[36],sr.fav02 USING '###',
#              COLUMN g_c[37],sr.fav03,
#              COLUMN g_c[38],sr.fav031,
#              COLUMN g_c[39],sr.faj06,
#              COLUMN g_c[40],cl_numfor(sr.fav04,40,0),
#              COLUMN g_c[41],sr.faj18,
#              COLUMN g_c[42],sr.fav06,
#              COLUMN g_c[43],sr.fav05,
#              COLUMN g_c[44],cl_numfor(sr.fav07,44,0)
 
 
#  AFTER GROUP OF sr.order1
#     IF tm.c[1,1] = 'Y'  AND tm.c[1,1] = 'Y' THEN
#        PRINT
#        PRINT COLUMN g_c[31],g_str1 CLIPPED,
#              COLUMN g_c[44],cl_numfor(GROUP SUM(sr.fav07),44,0)
#        PRINT COLUMN g_c[44],g_dash2[1,g_w[44]]
#      END IF
 
#  AFTER GROUP OF sr.order2
#     IF tm.c[2,2] = 'Y'  AND tm.c[2,2] = 'Y' THEN
#        PRINT
#        PRINT COLUMN g_c[31],g_str2 CLIPPED,
#              COLUMN g_c[44],cl_numfor(GROUP SUM(sr.fav07),44,0)
#        PRINT COLUMN g_c[44],g_dash2[1,g_w[44]]
#     END IF
 
#  AFTER GROUP OF sr.order3
#     IF tm.c[3,3] = 'Y' AND tm.c[3,3] = 'Y' THEN
#        PRINT
#        PRINT COLUMN g_c[31],g_str3 CLIPPED,
#              COLUMN g_c[44],cl_numfor(GROUP SUM(sr.fav07),44,0)
#        PRINT COLUMN g_c[44],g_dash2[1,g_w[44]]
#     END IF
 
#N LAST ROW
#     IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
#        THEN
#             PRINT g_dash2
#           #-- TQC-630166 begin
#             IF tm.wc[001,070] > ' ' THEN			# for 80
#	         PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#             IF tm.wc[071,140] > ' ' THEN
# 	         PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#             IF tm.wc[141,210] > ' ' THEN
# 	         PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#             IF tm.wc[211,280] > ' ' THEN
# 	         PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#             #IF tm.wc[001,120] > ' ' THEN			# for 132
#	      #   PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#             #IF tm.wc[121,240] > ' ' THEN
#	      #   PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#             #IF tm.wc[241,300] > ' ' THEN
#	      #   PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#             CALL cl_prt_pos_wc(tm.wc)
#           #-- TQC-630166 end
#     END IF
#     PRINT g_dash[1,g_len]
#     LET l_last_sw = 'y'
#     PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#  PAGE TRAILER
#   IF l_last_sw = 'n'
#       THEN PRINT g_dash[1,g_len]
#            PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#       ELSE SKIP 2 LINES
#    END IF
#END REPORT
#NO.FUN-850005---END-----
#FUN-870144
