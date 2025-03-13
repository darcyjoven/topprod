# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmr340.4gl
# Descriptions...: 估價/成交價差異表
# Date & Author..: 00/04/14 By Melody
# Modify.........: No.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680137 06/09/05 By bnlent 欄位型態定義，改為LIKE  
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-720004 07/02/08 by TSD.pinky 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/28 By Sarah CR報表串cs3()增加傳一個參數,增加數字取位的處理
# Modify.........: No.FUN-890011 08/10/14 By xiaofeizhu 原抓取occ_file部份也要加判斷抓取ofd_file
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-D40101 13/07/17 By lujh 客戶編號開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE l_table     STRING                        ### FUN-720004 add ###
DEFINE g_sql       STRING                        ### FUN-720004 add ###
DEFINE g_str       STRING
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      LIKE type_file.chr1000,#No.FUN-680137 VARCHAR(500)             # Where condition
              bdate   LIKE type_file.dat,    #No.FUN-680137 DATE
              edate   LIKE type_file.dat,    #No.FUN-680137 DATE
              more    LIKE type_file.chr1    # Prog. Version..: '5.30.06-13.03.12(01)               # Input more condition(Y/N)
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680137
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
 
   #str FUN-720004 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> FUN-720004 *** ##
   LET g_sql = "oqa06.oqa_file.oqa06,",
               "oqa01.oqa_file.oqa01,",
               "oqa03.oqa_file.oqa03,",
               "oqa031.oqa_file.oqa031,",
               "oqa032.oqa_file.oqa032,",
               "oqa17.oqa_file.oqa17,",
               "oqa08.oqa_file.oqa08,",
               "oea61.oea_file.oea61,",
               "occ02.occ_file.occ02,",
               "rate.oad_file.oad041,",
               "azi04.azi_file.azi04"
 
   LET l_table = cl_prt_temptable('axmr340',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF# Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
   #end FUN-720004 add
 
   INITIALIZE tm.* TO NULL            # Default condition
 #--------------No.TQC-610089 modify
  #LET tm.more = 'N'
  #LET g_pdate = g_today
  #LET g_rlang = g_lang
  #LET g_bgjob = 'N'
  #LET g_copies = '1'
  #LET tm.bdate=g_today
  #LET tm.edate=g_today
  #LET tm.wc = ARG_VAL(1)
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.bdate= ARG_VAL(8)
   LET tm.edate= ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 #--------------No.TQC-610089 end
   IF cl_null(tm.wc)
      THEN CALL axmr340_tm(0,0)             # Input print condition
      ELSE LET tm.wc="oqa01= '",tm.wc CLIPPED,"'"
           CALL axmr340()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmr340_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 7 LET p_col = 33
 
   OPEN WINDOW axmr340_w AT p_row,p_col WITH FORM "axm/42f/axmr340"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
 #--------------No.TQC-610089 modify
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.bdate=g_today
   LET tm.edate=g_today
 #--------------No.TQC-610089 end
 
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oqa06
      #No.FUN-580031 --start--
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
      #No.FUN-580031 ---end---
 
      ON ACTION locale
         LET g_action_choice = "locale"
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT CONSTRUCT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      #TQC-D40101--add--str--
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(oqa06)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_occ"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oqa06
              NEXT FIELD oqa06
         END CASE
      #TQC-D40101--add--end--
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr340_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
 
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
 
   DISPLAY BY NAME tm.bdate,tm.edate,tm.more
  #UI
   INPUT BY NAME tm.bdate,tm.edate,tm.more WITHOUT DEFAULTS
      #No.FUN-580031 --start--
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr340_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmr340'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmr340','9031',1)
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
                       #------------No.TQC-610089 modify
                         " '",tm.bdate CLIPPED,"'"  ,
                         " '",tm.edate CLIPPED,"'"  ,
                       #------------No.TQC-610089 end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axmr340',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmr340_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmr340()
   ERROR ""
END WHILE
   CLOSE WINDOW axmr340_w
END FUNCTION
 
FUNCTION axmr340()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(3000)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          sr        RECORD
                    oqa06    LIKE oqa_file.oqa06,
                    oqa01    LIKE oqa_file.oqa01,
                    oqa03    LIKE oqa_file.oqa03,
                    oqa031   LIKE oqa_file.oqa031,
                    oqa032   LIKE oqa_file.oqa032,
                    oqa17    LIKE oqa_file.oqa17,
                    oqa08    LIKE oqa_file.oqa08,
                    oea61    LIKE oea_file.oea61,
                    occ02    LIKE occ_file.occ02,
                    rate     LIKE oad_file.oad041,
                    azi04    LIKE azi_file.azi04   #FUN-710080 add
                    END RECORD
   DEFINE l_cnt     LIKE type_file.num5           #No.FUN-890011
 
  #str FUN-720004 add
  ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-720004 *** ##
  CALL cl_del_data(l_table)
  #------------------------------ CR (2) ------------------------------#
  #end FUN-720004 add
 
  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
  SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-720004 add ###
 
  FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
  #Begin:FUN-980030
  #  IF g_priv2='4' THEN                   #只能使用自己的資料
  #      LET tm.wc = tm.wc clipped," AND oqauser = '",g_user,"'"
  #  END IF
  #  IF g_priv3='4' THEN                   #只能使用相同群的資料
  #      LET tm.wc = tm.wc clipped," AND oqagrup MATCHES '",g_grup CLIPPED,"*'"
  #  END IF
  #  IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
  #      LET tm.wc = tm.wc clipped," AND oqagrup IN ",cl_chk_tgrup_list()
  #  END IF
  LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oqauser', 'oqagrup')
  #End:FUN-980030
 
  LET l_sql="SELECT oqa06,oqa01,oqa03,oqa031,oqa032,",
        #   "       oqa17,oqa08,oea61,occ02,'',azi04 ",   #FUN-710080 add azi04    #FUN-890011 Mark
            "       oqa17,oqa08,oea61,'','',azi04 ",                               #FUN-890011 Add            
        #   "  FROM oqa_file,oea_file,OUTER occ_file,",                            #FUN-890011 Mark
" FROM oqa_file LEFT OUTER JOIN azi_file ON oqa_file.oqa08 = azi_file.azi01,oea_file",
            " WHERE oqa01=oea12 ",
        #   "   AND oqa06=occ_file.occ01(+) ",                                                 #FUN-890011 Mark 
            "   AND oqa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
            "   AND ",tm.wc CLIPPED,
            "   AND oqaconf = 'Y' ",#估價單為已確認的資料01/08/04mandy
            "   AND oeaconf = 'Y' ",#訂單  為已確認的資料01/08/04mandy
            " ORDER BY oqa06 "
  PREPARE axmr340_prepare1 FROM l_sql
  IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
     EXIT PROGRAM 
  END IF
  DECLARE axmr340_curs1 CURSOR FOR axmr340_prepare1
 
  LET g_pageno = 0
  FOREACH axmr340_curs1 INTO sr.*
     IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
     IF sr.oea61 IS NULL OR sr.oea61=0 THEN
        LET sr.rate=0
     ELSE
        LET sr.rate=(sr.oea61-sr.oqa17)/sr.oea61*100
     END IF
    #NO.FUN-890011--Add--Begin--# 
     SELECT COUNT(*) INTO l_cnt FROM occ_file WHERE occ01=sr.oqa06              
     IF l_cnt <> 0 THEN
       SELECT occ02 INTO sr.occ02 FROM occ_file WHERE occ01=sr.oqa06
     ELSE
       SELECT ofd02 INTO sr.occ02 FROM ofd_file WHERE ofd01=sr.oqa06
     END IF
    #NO.FUN-890011--Add--End--#     
 
     #str FUN-720004 add
     ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-720004 *** ##
     EXECUTE insert_prep USING sr.*
     #------------------------------ CR (3) ------------------------------#
     #end FUN-720004 add
  END FOREACH
 
  #str FUN-720004 add
  ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720004 **** ##
  LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
  #是否列印選擇條件
  IF g_zz05 = 'Y' THEN
     CALL cl_wcchp(tm.wc,'oqa06')
          RETURNING tm.wc
     LET g_str = tm.wc
  END IF
  LET g_str = g_str CLIPPED,";",tm.bdate,";",tm.edate
  CALL cl_prt_cs3('axmr340','axmr340',l_sql,g_str)   #FUN-710080 modify
  #------------------------------ CR (4) ------------------------------#
  #end FUN-720004 add
 
END FUNCTION
