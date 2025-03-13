# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: afar218.4gl
# Desc/riptions...: 固定資產移轉明細表
# Date & Author..: 10/08/26 NO.FUN-9A0058 By vealxu 

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm RECORD                                  # Print condition RECORD
             wc      STRING,                      # Where condition
             s       LIKE type_file.chr3,         # Order by sequence             #No.FUN-680070 CHAR(3)
             t       LIKE type_file.chr3,         # Eject sw                      #No.FUN-680070 CHAR(3)
             more    LIKE type_file.chr1          # Input more condition(Y/N)     #No.FUN-680070 CHAR(1)
          END RECORD,
       g_aza17       LIKE aza_file.aza17,         # 本國幣別
       g_dates       LIKE type_file.chr6,         #No.FUN-680070 CHAR(6)
       g_datee       LIKE type_file.chr6,         #No.FUN-680070 CHAR(6)
       l_bdates      LIKE type_file.dat,          #No.FUN-680070 DATE
       l_bdatee      LIKE type_file.dat,          #No.FUN-680070 DATE
       g_fbl01       LIKE fbl_file.fbl01,         #No.FUN-680070 CHAR(10)
       g_total       LIKE type_file.num20_6,      #No.FUN-680070 DECIMAL(13,3)
       swth          LIKE type_file.chr1          #No.FUN-680070 CHAR(1)
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

   LET g_sql="faj04.faj_file.faj04,fbl01.fbl_file.fbl01,fbl02.fbl_file.fbl02,",
             "fbl04.fbl_file.fbl04,fbl03.fbl_file.fbl03,fbl05.fbl_file.fbl05,",
             "fbl06.fbl_file.fbl06,fbm02.fbm_file.fbm02,fbm03.fbm_file.fbm03,",
             "fbm031.fbm_file.fbm031,faj06.faj_file.faj06,",
             "fap18.fap_file.fap18,fap17.fap_file.fap17,fap19.fap_file.fap19,",
             "fap12.fap_file.fap12,fap13.fap_file.fap13,fap15.fap_file.fap15,",
             "fap16.fap_file.fap16,fap14.fap_file.fap14,fbm04.fbm_file.fbm04,",
             "fbm05.fbm_file.fbm05,fbm06.fbm_file.fbm06,fbm07.fbm_file.fbm06,",
             "fbm08.fbm_file.fbm06,fbm09.fbm_file.fbm06,fbm10.fbm_file.fbm06,",
             "fbm11.fbm_file.fbm06"
   LET l_table = cl_prt_temptable('afar218',g_sql) CLIPPED
    IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,",
               "       ?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
     CALL cl_err('insert_pret:',status,1) EXIT PROGRAM
   END IF

   LET g_pdate = ARG_VAL(1)             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)   #TQC-610055
   LET tm.t  = ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No:FUN-7C0078
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r218_tm(0,0)		# Input print condition
      ELSE CALL afar218()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN

FUNCTION r218_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No:FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 CHAR(1000)

   LET p_row = 4 LET p_col = 14

   OPEN WINDOW r218_w AT p_row,p_col WITH FORM "afa/42f/afar218"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()


   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Defbllt condition
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
      CONSTRUCT BY NAME tm.wc ON faj04,fbm03,fbl01,fbl02,fbl04,fbl03,fbl05
         BEFORE CONSTRUCT
             CALL cl_qbe_init()

      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT

    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()    
 
      ON ACTION help          
         CALL cl_show_help() 
 
      ON ACTION controlg   
         CALL cl_cmdask() 
 
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         ON ACTION qbe_select
            CALL cl_qbe_select()

 END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF

 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW r218_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF
         INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3, tm.more WITHOUT DEFAULTS
 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)

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

         ON ACTION qbe_save
            CALL cl_qbe_save()

         END INPUT

      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW r218_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='afar218'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar218','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_rlang CLIPPED,"'", 
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.s CLIPPED,"'",
                            " '",tm.t CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",       
                         " '",g_rep_clas CLIPPED,"'",     
                         " '",g_template CLIPPED,"'",    
                         " '",g_rpt_name CLIPPED,"'"    
            CALL cl_cmdat('afar218',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW r218_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar218()
      ERROR ""
   END WHILE

   CLOSE WINDOW r218_w
END FUNCTION
 
FUNCTION afar218()
   DEFINE l_name	LIKE type_file.chr20,                   # External(Disk) file name       #No.FUN-680070 CHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0069
          l_sql 	LIKE type_file.chr1000,                 # RDSQL STATEMENT                #No.FUN-680070 CHAR(1000)
          l_chr		LIKE type_file.chr1,                    #No.FUN-680070 CHAR(1)
          l_za05	LIKE type_file.chr1000,                 #No.FUN-680070 CHAR(40)
          l_order	ARRAY[6] OF LIKE fbl_file.fbl01,        #No.FUN-680070 CHAR(10)
          sr            RECORD order1 LIKE fbl_file.fbl01,      #No.FUN-680070 CHAR(10)
                               order2 LIKE fbl_file.fbl01,      #No.FUN-680070 CHAR(10)
                               order3 LIKE fbl_file.fbl01,      #No.FUN-680070 CHAR(10)
                               faj04 LIKE faj_file.faj04,	#
                               fbl01 LIKE fbl_file.fbl01,	#
                               fbl02 LIKE fbl_file.fbl02,	#
                               fbl04 LIKE fbl_file.fbl04,	#
                               fbl03 LIKE fbl_file.fbl03,	#
                               fbl05 LIKE fbl_file.fbl05,	#
                               fbl06 LIKE fbl_file.fbl06,	#
                               fbm02 LIKE fbm_file.fbm02,	#
                               fbm03 LIKE fbm_file.fbm03,	#
                               fbm031 LIKE fbm_file.fbm031,	#
                               faj06 LIKE faj_file.faj06,	#
                               fap18 LIKE fap_file.fap18,	#
                               fap17 LIKE fap_file.fap17,	#
                               fap19 LIKE fap_file.fap19,	#
                               fap12 LIKE fap_file.fap12,	#
                               fap13 LIKE fap_file.fap13,	#
                               fap15 LIKE fap_file.fap15,	#
                               fap16 LIKE fap_file.fap16,	#
                               fap14 LIKE fap_file.fap14,	#
                               fbm04 LIKE fbm_file.fbm04,	#
                               fbm05 LIKE fbm_file.fbm05,	#
                               fbm06 LIKE fbm_file.fbm06,	#
                               fbm07 LIKE fbm_file.fbm06,	#
                               fbm08 LIKE fbm_file.fbm06,	#
                               fbm09 LIKE fbm_file.fbm06,	#
                               fbm10 LIKE fbm_file.fbm06,	#
                               fbm11 LIKE fbm_file.fbm06 	#
                        END RECORD
     CALL cl_del_data(l_table)                                  #NO.FUN-7A0036
    
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='afar218'  #NO.FUN-7A0036

   # IF g_priv2='4' THEN                           #只能使用自己的資料
   #     LET tm.wc = tm.wc clipped," AND fbluser = '",g_user,"'"
   # END IF
   # IF g_priv3='4' THEN                           #只能使用相同群的資料
   #     LET tm.wc = tm.wc clipped," AND fblgrup MATCHES '",g_grup CLIPPED,"*'"
   # END IF

   # IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET tm.wc = tm.wc clipped," AND fblgrup IN ",cl_chk_tgrup_list()
   # END IF


     LET l_sql = " SELECT '','','',",
                 "   faj04, fbl01,  fbl02,  fbl04,  fbl03,  fbl05, fbl06,",
                 "   fbm02,  fbm03,",
                 "   fbm031,  faj06,",
                 "   '','','','','','','','',",
                 "   fbm04, fbm05, fbm06, '', '', '', '',''",
                 "  FROM fbl_file,fbm_file LEFT OUTER JOIN faj_file ",
                 "    ON fbm03 = faj02 AND fbm031 = faj022 ",  
                 " WHERE fbl01 = fbm01 " ,
                 "   AND fblconf != 'X' " ,
                 "   AND ",tm.wc

     LET  g_total = 0
    
     PREPARE r218_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE r218_cs1 CURSOR FOR r218_prepare1

     FOREACH r218_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF

      SELECT fap18,fap17,fap19,fap12,fap13,fap15,fap16,fap14
        INTO sr.fap18,sr.fap17,sr.fap19,sr.fap12,sr.fap13,sr.fap15,sr.fap16,sr.fap14
        FROM fap_file
       WHERE fap50 = sr.fbl01 
         AND fap501 = sr.fbm02 
         AND fap02 = sr.fbm03
         AND fap021 = sr.fbm031 
         AND fap03 = 'D'
         AND fap04 = sr.fbl02          

       INITIALIZE g_fbl01 TO NULL
       IF cl_null(sr.fbm07) THEN LET sr.fbm07=0 END IF

     EXECUTE insert_prep USING 
       sr.faj04,sr.fbl01,sr.fbl02,sr.fbl04,sr.fbl03,sr.fbl05,sr.fbl06,
       sr.fbm02,sr.fbm03,sr.fbm031,sr.faj06,sr.fap18,sr.fap17,sr.fap19,
       sr.fap12,sr.fap13,sr.fap15,sr.fap16,sr.fap14,sr.fbm04,sr.fbm05,
       sr.fbm06,sr.fbm07,sr.fbm08,sr.fbm09,
       sr.fbm10,sr.fbm11

     END FOREACH

     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED

     IF g_zz05 ='Y' THEN 
      CALL cl_wcchp(tm.wc,'faj04,fbm03,fbl01,fbl02,fbl04,fbl03,fbl05')
            RETURNING tm.wc
     END IF
     LET g_str = tm.wc,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
                  tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3]
     CALL cl_prt_cs3('afar218','afar218',g_sql,g_str)               

END FUNCTION
#NO.FUN-9A0058
