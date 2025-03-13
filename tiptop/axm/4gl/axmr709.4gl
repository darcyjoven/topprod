# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmr709.4gl
# Descriptions...: 業務人員預計行程列印
# Date & Author..: 02/12/17 By Maggie
# Modify.........: NO.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-660167 06/06/23 By Douzh cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-850014 08/05/06 By xiaofeizhu 報表輸出改為CR
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-D50056 13/07/16 By yangtt 增加業務員編號、潛在客戶編號、部門編號開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      LIKE type_file.chr1000,     # No.FUN-680137 VARCHAR(500)    # Where condition
              b       LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(01)
              bdate   LIKE type_file.dat,         # No.FUN-680137 DATE
              edate   LIKE type_file.dat,         # No.FUN-680137 DATE
              more    LIKE type_file.chr1         # Prog. Version..: '5.30.06-13.03.12(01)    # Input more condition(Y/N)
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_head1         STRING
 
#No.FUN-850014 --Add--Begin--                                                                                                       
  DEFINE   l_table         STRING                                                                                                   
  DEFINE   g_str           STRING                                                                                                   
  DEFINE   g_sql           STRING                                                                                                   
#No.FUN-850014 --Add--End--
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
 
#No.FUN-850014 --Add--Begin--                                                                                                       
#--------------------------CR(1)--------------------------------#                                                                   
   LET g_sql = " gem01.gem_file.gem01,",
               " gem02.gem_file.gem02,",
               " ofd23.ofd_file.ofd23,",                                                                                            
               " gen02.gen_file.gen02,",
               " ofd26_1.type_file.dat,",                                                                                            
               " ofd01.ofd_file.ofd01,",                                                                                            
               " ofd02.ofd_file.ofd02,",                                                                                            
               " ofd10.ofd_file.ofd10,",                                                                                            
               " ofd26.ofd_file.ofd26,",                                                                                            
               " ofd27.ofd_file.ofd27,",                                                                                            
               " ofd31.ofd_file.ofd31,",                                                                                            
               " ofd33.ofd_file.ofd33"
                                                                                                                                    
    LET l_table = cl_prt_temptable('axmr709',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"                                                                          
   PREPARE insert_prep FROM g_sql                                                                                                   
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
                                                                                                                                    
#--------------------------CR(1)--------------------------------#
 
 #--------------No.TQC-610089 modify
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.b    = ARG_VAL(8)
   LET tm.bdate= ARG_VAL(9)
   LET tm.edate= ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No.FUN-570264 ---end---
 #--------------No.TQC-610089 end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL axmr709_tm(0,0)             # Input print condition
      ELSE CALL axmr709()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmr709_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_cmd          LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(1000)
          l_flag         LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
          l_string       LIKE type_file.chr20,       # No.FUN-680137 VARCHAR(20)
          l_string1      LIKE type_file.chr20,       # No.FUN-680137 VARCHAR(20)
          l_bm           LIKE type_file.num5,        # No.FUN-680137 SMALLINT
          l_em           LIKE type_file.num5,        # No.FUN-680137 SMALLINT
          l_tmp          LIKE type_file.dat,         # No.FUN-680137 DATE
          l_tmp1         LIKE type_file.dat,         # No.FUN-680137 DATE
          l_azn01        LIKE azn_file.azn01,
          l_azn02        LIKE azn_file.azn02,
          l_azn03        LIKE azn_file.azn03,
          l_azn04        LIKE azn_file.azn04,
          l_azn05        LIKE azn_file.azn05
 
   LET p_row = 5 LET p_col = 18
 
   OPEN WINDOW axmr709_w AT p_row,p_col WITH FORM "axm/42f/axmr709"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                # Default condition
   LET tm.b    = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ofd01,gem01,ofd23,ofd10
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---

   #TQC-D50056--add--start
      ON ACTION CONTROLP
         IF INFIELD (ofd23) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ofd23"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ofd23
            NEXT FIELD ofd23
         END IF
         IF INFIELD (gem01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gem01"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO gem01
            NEXT FIELD gem01
         END IF
         IF INFIELD (ofd01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ofd"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ofd01
            NEXT FIELD ofd01
         END IF
   #TQC-D50056--add--end
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr709_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN CALL cl_err(' ','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.b,tm.bdate,tm.edate,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD b
         IF tm.b NOT MATCHES '[1234]' THEN NEXT FIELD b END IF
         CALL s_gactpd(g_today) RETURNING l_flag,l_azn02,l_azn03,l_azn04,l_azn05
         IF l_flag != 0 THEN CALL cl_err('','mfg3078',0) END IF
         IF tm.b = '1' THEN                     #按周計算
            LET l_azn05 = l_azn05 +1
            IF l_azn05 > 53 THEN           #下一年
               LET l_azn05 = 1             #周
               LET l_azn02 = l_azn02 + 1   #年
            END IF
            DECLARE azn_cur CURSOR FOR
               SELECT azn01 FROM azn_file
                WHERE azn02 = l_azn02 AND azn05 = l_azn05
            FOREACH azn_cur INTO l_azn01
               IF SQLCA.sqlcode != 0 THEN
                  CALL cl_err('foreach:',SQLCA.sqlcode,1) 
                  EXIT FOREACH
               END IF
               IF WEEKDAY(l_azn01) = 0 THEN   #周日
                  LET tm.bdate = l_azn01
               END IF
               IF l_azn05 = 53 THEN           #一年最后一周
                  LET l_string = l_azn02,'/12/31'
                  LET tm.edate = DATE(l_string)
               END IF
               IF WEEKDAY(l_azn01) = 6 THEN    #周六
                  LET tm.edate = l_azn01
               END IF
            END FOREACH
         ELSE
            IF tm.b = '2' THEN                      #按月計算
               IF g_aza.aza02 = '1' AND l_azn04 = 12 THEN      #一年12期
                  LET l_azn02 = l_azn02 + 1
                  LET l_azn04 = 1
               ELSE
                  IF g_aza.aza02 = '2' AND l_azn04 = 13 THEN   #一年13期
                     LET l_azn02 = l_azn02 + 1
                     LET l_azn04 = 1
                  ELSE
                     LET l_azn02 = l_azn02
                     LET l_azn04 = l_azn04 + 1
                  END IF
               END IF
               CALL s_azn01(l_azn02,l_azn04) RETURNING tm.bdate,tm.edate
            ELSE
               IF tm.b = '3' THEN                      #按季計算
                  LET l_azn03 = l_azn03 + 1
                  IF l_azn03 > 4 THEN
                     LET l_azn03 = 1
                     LET l_azn02 = l_azn02+1
                  END IF
                  CALL s_period(l_azn03,l_azn02) RETURNING l_bm,l_em
                  CALL s_azn01(l_azn02,l_bm) RETURNING tm.bdate,l_tmp
                  CALL s_azn01(l_azn02,l_em) RETURNING l_tmp1,tm.edate
               ELSE
                  IF tm.b = '4' THEN                   #按年計算
                     LET l_azn02 = l_azn02 +1
                     LET l_string = l_azn02 ,'/01/01'
                     LET tm.bdate = DATE(l_string)
                     LET l_string1 = l_azn02,'/12/31'
                     LET tm.edate = DATE(l_string1)
                  END IF
               END IF
            END IF
         END IF
         DISPLAY tm.bdate,tm.edate TO FORMONLY.bdate,FORMONLY.edate
 
      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
      AFTER FIELD edate
         IF cl_null(tm.edate) OR tm.bdate > tm.edate THEN
            NEXT FIELD edate
         END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr709_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmr709'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axmr709','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang   CLIPPED,"'",
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'" ,
                         " '",tm.b     CLIPPED,"'" ,
                         " '",tm.bdate CLIPPED,"'" ,
                         " '",tm.edate CLIPPED,"'" ,
                        #" '",tm.more  CLIPPED,"'"  ,           #No.TQC-610089 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axmr709',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmr709_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmr709()
   ERROR ""
END WHILE
   CLOSE WINDOW axmr709_w
END FUNCTION
 
FUNCTION axmr709()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(600)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_temp    LIKE type_file.num5,         # No.FUN-680137 SMALLINT
          i         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          sr        RECORD
                    gem01     LIKE gem_file.gem01,
                    gem02     LIKE gem_file.gem02,
                    ofd23     LIKE ofd_file.ofd23,
                    gen02     LIKE gen_file.gen02,
                    ofd26_1   LIKE type_file.dat,         # No.FUN-680137 DATE
                    ofd01     LIKE ofd_file.ofd01,
                    ofd02     LIKE ofd_file.ofd02,
                    ofd10     LIKE ofd_file.ofd10,
                    ofd24     LIKE ofd_file.ofd24,
                    ofd26     LIKE ofd_file.ofd26,
                    ofd27     LIKE ofd_file.ofd27,
                    ofd31     LIKE ofd_file.ofd31,
                    ofd33     LIKE ofd_file.ofd33,
                    ofc04     LIKE ofc_file.ofc04,
                    ofc05     LIKE ofc_file.ofc05,
                    ofc06     LIKE ofc_file.ofc06
                    END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     IF SQLCA.sqlcode THEN 
#       CALL cl_err('',SQLCA.sqlcode,0)#No.FUN-660167
        CALL cl_err3("sel","zo_file",g_rlang,"",SQLCA.sqlcode,"","",0)  #No.FUN-660167 
        END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR             #No.FUN-850014            
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-850014 *** ##                                                    
     CALL cl_del_data(l_table)                                                                                                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-850014 add ###                                              
     #------------------------------ CR (2) ------------------------------#
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN
     #         LET tm.wc = tm.wc CLIPPED," AND ofduser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN
     #         LET tm.wc = tm.wc CLIPPED," AND ofdgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc CLIPPED," AND ofdgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ofduser', 'ofdgrup')
     #End:FUN-980030
 
     LET l_sql="SELECT gem01,gem02,ofd23,gen02,ofd26,ofd01,ofd02,ofd10,ofd24,",
               "       ofd26,ofd27,ofd31,ofd33,ofc04,ofc05,ofc06",
               "  FROM gem_file,gen_file,ofd_file,ofc_file",
               " WHERE ofd23 = gen01 ",
               "   AND gen03 = gem01 ",
               "   AND ofc01 = ofd10 ",
               "   AND ofc03 = 'Y'   ",              #定期拜訪
               "   AND ofd22 = '1'   ",              #指派
	       "   AND ofd10 IS NOT NULL ",
               "   AND ",tm.wc CLIPPED
 
     PREPARE axmr709_prepare FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
     END IF
     DECLARE axmr709_curs CURSOR FOR axmr709_prepare
 
#    CALL cl_outnam('axmr709') RETURNING l_name                                      #No.FUN-850014     
#    START REPORT axmr709_rep TO l_name                                              #No.FUN-850014
 
#    LET g_pageno = 0                                                                #No.FUN-850014
     FOREACH axmr709_curs INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET i = 0
       IF sr.ofc06 >0 THEN
          LET l_temp = (sr.ofc04*30+sr.ofc05)/sr.ofc06
       ELSE
          LET l_temp = 0
       END IF
       IF cl_null(sr.ofd26) THEN
          LET sr.ofd26 = sr.ofd24
       END IF
       WHILE TRUE
          LET i = i+1
          LET sr.ofd26_1 = sr.ofd26 + l_temp*i
          IF sr.ofd26_1 >= tm.bdate AND sr.ofd26_1 <= tm.edate THEN
#            OUTPUT TO REPORT axmr709_rep(sr.*)                                      #No.FUN-850014
 
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-850014 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
                   sr.gem01,sr.gem02,sr.ofd23,sr.gen02,sr.ofd26_1,sr.ofd01,                                                         
                   sr.ofd02,sr.ofd10,sr.ofd26,sr.ofd27,sr.ofd31,sr.ofd33                                                                  
          #------------------------------ CR (3) ------------------------------#
 
             EXIT WHILE
          ELSE
             IF sr.ofd26_1 > tm.edate OR
                (l_temp = 0 AND (sr.ofd26 < tm.bdate
                 OR sr.ofd26 > tm.edate)) THEN
                EXIT WHILE
             END IF
          END IF
       END WHILE
     END FOREACH
 
#    FINISH REPORT axmr709_rep                                                        #No.FUN-850014
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)                                      #No.FUN-850014
 
#No.FUN-850014--begin                                                                                                               
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'ofd01,gem01,ofd23,ofd10')                                                                 
              RETURNING tm.wc                                                                                                       
      END IF                                                                                                                        
#No.FUN-850014--end                                                                                                                 
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-850014 **** ##                                                        
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
    LET g_str = tm.wc,";",tm.bdate,";",tm.edate                                                                                                      
    CALL cl_prt_cs3('axmr709','axmr709',l_sql,g_str)                                                                                
    #------------------------------ CR (4) ------------------------------#
 
END FUNCTION
 
#No.FUN-850014--Mark--Begin--##
#REPORT axmr709_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)
#         l_str     LIKE aaf_file.aaf03,           # No.FUN-680137 VARCHAR(40)
#         sr        RECORD
#                   gem01     LIKE gem_file.gem01,
#                   gem02     LIKE gem_file.gem02,
#                   ofd23     LIKE ofd_file.ofd23,
#                   gen02     LIKE gen_file.gen02,
#                   ofd26_1   LIKE type_file.dat,         # No.FUN-680137 DATE
#                   ofd01     LIKE ofd_file.ofd01,
#                   ofd02     LIKE ofd_file.ofd02,
#                   ofd10     LIKE ofd_file.ofd10,
#                   ofd24     LIKE ofd_file.ofd24,
#                   ofd26     LIKE ofd_file.ofd26,
#                   ofd27     LIKE ofd_file.ofd27,
#                   ofd31     LIKE ofd_file.ofd31,
#                   ofd33     LIKE ofd_file.ofd33,
#                   ofc04     LIKE ofc_file.ofc04,
#                   ofc05     LIKE ofc_file.ofc05,
#                   ofc06     LIKE ofc_file.ofc06
#                   END RECORD
 
# OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
# ORDER BY sr.gem01,sr.ofd23,sr.ofd26_1
 
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<','/pageno'
#     PRINT g_head CLIPPED, pageno_total
 
#     LET l_str = g_x[10] CLIPPED,tm.bdate,'-',tm.edate
#     LET g_head1 = g_x[09] CLIPPED,sr.gem01 CLIPPED,' ',sr.gem02 CLIPPED
#     PRINT g_head1 CLIPPED,
#           COLUMN g_c[35],l_str CLIPPED
 
#     PRINT g_dash[1,g_len]
#     PRINT g_x[31],
#           g_x[32],
#           g_x[33],
#           g_x[34],
#           g_x[35],
#           g_x[36],
#           g_x[37],
#           g_x[38],
#           g_x[39],
#           g_x[40]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.gem01
#     SKIP TO TOP OF PAGE
 
#  BEFORE GROUP OF sr.ofd23
#     PRINT COLUMN g_c[31], sr.ofd23,
#           COLUMN g_c[32],sr.gen02;
#
#  BEFORE GROUP OF sr.ofd26_1
#     PRINT COLUMN g_c[33],sr.ofd26_1;
#
#  AFTER GROUP OF sr.ofd26_1
#     PRINT COLUMN g_c[34],sr.ofd01,
#           COLUMN g_c[35],sr.ofd02,
#           COLUMN g_c[36],sr.ofd10,
#           COLUMN g_c[37],sr.ofd26,
#           COLUMN g_c[38],sr.ofd27,
#           COLUMN g_c[39],sr.ofd31,
#           COLUMN g_c[40],sr.ofd33
 
#  ON LAST ROW
#     PRINT g_dash[1,g_len]
#     PRINT g_x[4] CLIPPED, COLUMN g_c[40], g_x[7] CLIPPED
#     LET l_last_sw = 'y'
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len]
#             PRINT g_x[4] CLIPPED, COLUMN g_c[40], g_x[6] CLIPPED
#     ELSE SKIP 2 LINE
#     END IF
#END REPORT
#No.FUN-850014--Mark--End--##
#No.FUN-870144
