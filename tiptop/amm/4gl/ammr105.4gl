# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: ammr105.4gl
# Desc/riptions..: 開發案成本估算表
# Date & Author..: 20010608 by Ken
# Modify.........: No.FUN-4C0099 05/01/14 By kim 報表轉XML功能
# Modify.........: No.FUN-680100 06/08/28 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.TQC-6B0011 06/12/04 By Sarah (接下頁)、(結束)沒有靠右
# Modify.........: No.FUN-750028 07/05/28 By TSD.Achick報表改寫由Crystal Report產出
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80065 11/08/05 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD			              # Print condition RECORD
       	    	wc     	LIKE type_file.chr1000,       #No.FUN-680100 VARCHAR(500)#Where condition
                more	LIKE type_file.chr1           #No.FUN-680100 VARCHAR(1)
              END RECORD,
          g_zo          RECORD LIKE zo_file.*
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680100 SMALLINT
DEFINE   l_table        STRING                        ### FUN-750028 add ###
DEFINE   g_sql          STRING                        ### FUN-750028 add ###
DEFINE   g_str          STRING                        ### FUN-750028 add ###
 
MAIN
   OPTIONS
          INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMM")) THEN
      EXIT PROGRAM
   END IF
 
   #str FUN-750028 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> FUN-750028 *** ##
   LET g_sql = "mma02.mma_file.mma02,", 
               "mma021.mma_file.mma021,", 
               "mma01.mma_file.mma01,", 
               "mmb02.mmb_file.mmb02,", 
               "mmb03.mmb_file.mmb03,",
               "mmb04.mmb_file.mmb04,", 
               "mmb05.mmb_file.mmb05,", 
               "mmb06.mmb_file.mmb06,", 
               "mmb07.mmb_file.mmb07,", 
               "mmb08.mmb_file.mmb08,", 
               "mmb09.mmb_file.mmb09,", 
               "mmb10.mmb_file.mmb10,", 
               "mmb11.mmb_file.mmb11,", 
               "mmb16.mmb_file.mmb16,", 
               "mmb17.mmb_file.mmb17,", 
               "mmb18.mmb_file.mmb18,", 
               "mmb19.mmb_file.mmb19,", 
               "JaGongFei.mmb_file.mmb10,", 
               "RenGongChengBen.mmb_file.mmb10,", 
               "IsDup.type_file.chr1,",      # 0 為主報表使用的資料 1為子報表使用的資料
               "mmn03.mmn_file.mmn03,",
               "mmn04.mmn_file.mmn04,",
               "mmn05.mmn_file.mmn05"
 
   LET l_table = cl_prt_temptable('ammr105',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?)"
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
 
   LET g_pdate = ARG_VAL(1)	             # Get arguments from command line
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80065--add--
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r105_tm(0,0)		# Input print condition
      ELSE CALL ammr105()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
END MAIN
 
FUNCTION r105_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,          #No.FUN-680100 SMALLINT
          l_cmd		LIKE type_file.chr1000        #No.FUN-680100 VARCHAR(400)
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row =  9 LET p_col = 18 
   ELSE LET p_row = 4 LET p_col = 15
   END IF
 
   OPEN WINDOW r105_w AT p_row,p_col
        WITH FORM "amm/42f/ammr105" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON mma02,mma01,mma021 
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
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('mmauser', 'mmagrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r105_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1 " THEN CALL cl_err(' ','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.more WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF cl_null(tm.more) THEN LET tm.more='N' END IF
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            THEN NEXT FIELD more
         END IF
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
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW r105_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='ammr105'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('ammr105','9031',1)
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
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('ammr105',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r105_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL ammr105()
   ERROR ""
END WHILE
   CLOSE WINDOW r105_w
END FUNCTION
 
FUNCTION ammr105()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name        #No.FUN-680100 VARCHAR(20)
          l_sql 	STRING,	                   	# RDSQL STATEMENT        #No.FUN-680100
          l_chr		LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
          l_za05	LIKE type_file.chr1000,       #No.FUN-680100 VARCHAR(40)
          l_mmn03       LIKE mmn_file.mmn03,
          l_mmn04       LIKE mmn_file.mmn04,
          l_mmn05       LIKE mmn_file.mmn05,
          sr   RECORD 
               mma RECORD LIKE mma_file.*,
               mmb RECORD LIKE mmb_file.*,
               JaGongFei LIKE mmb_file.mmb10,
               RenGongChengBen LIKE mmb_file.mmb10
               END RECORD
       #No.FUN-B80065--mark--Begin--- 
       #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
       #No.FUN-B80065--mark--End-----
   #str FUN-750028  add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-750028 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
   #end FUN-750028  add
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-750028 add ###
     LET l_sql = "SELECT mma_file.*, mmb_file.*, '', ''  ",
                 "  FROM mma_file , mmb_file ",
                 " WHERE mma01 = mmb01 ",
                 "   AND ",tm.wc CLIPPED
 
     PREPARE r105_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
        EXIT PROGRAM 
     END IF
     DECLARE r105_cs1 CURSOR FOR r105_prepare1
     SELECT * INTO g_zo.* FROM zo_file WHERE zo01=g_rlang
     
     FOREACH r105_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
       END IF
       LET sr.JaGongFei = sr.mmb.mmb09 * sr.mmb.mmb10
       IF cl_null(sr.JaGongFei) THEN LET sr.JaGongFei = 0 END IF
       LET sr.RenGongChengBen = sr.mmb.mmb11 * sr.mmb.mmb19
       IF cl_null(sr.RenGongChengBen) THEN LET sr.RenGongChengBen = 0 END IF
 
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-750028 *** ##
         EXECUTE insert_prep USING 
         sr.mma.mma02, sr.mma.mma021, sr.mma.mma01, sr.mmb.mmb02, sr.mmb.mmb03,
         sr.mmb.mmb04, sr.mmb.mmb05,  sr.mmb.mmb06, sr.mmb.mmb07, sr.mmb.mmb08, 
         sr.mmb.mmb09, sr.mmb.mmb10,  sr.mmb.mmb11, sr.mmb.mmb16, sr.mmb.mmb17,
         sr.mmb.mmb18, sr.mmb.mmb19,  sr.JaGongFei, sr.RenGongChengBen,'0',
         '0','','0'
       #------------------------------ CR (3) ------------------------------#
 
     END FOREACH
 
     LET l_chr = 'N'
     LET l_sql = "SELECT mma02,mma021 ",
                 "  FROM mma_file , mmb_file ",
                 " WHERE mma01 = mmb01 ",
                 "   AND ",tm.wc CLIPPED,
                 " GROUP BY mma02,mma021"
 
     PREPARE r105_prepare2 FROM l_sql
     DECLARE r105_cs2 CURSOR FOR r105_prepare2
 
     FOREACH r105_cs2 INTO sr.mma.mma02,sr.mma.mma021
       LET l_chr = 'N'
 
       DECLARE mmn_cur CURSOR FOR 
          SELECT mmn03,mmn04,mmn05 FROM mmn_file 
            WHERE mmn01=sr.mma.mma02 AND mmn02=sr.mma.mma021
       FOREACH mmn_cur INTO l_mmn03,l_mmn04,l_mmn05
          LET l_chr = 'Y'
          EXECUTE insert_prep USING 
          sr.mma.mma02, sr.mma.mma021, sr.mma.mma01, sr.mmb.mmb02, sr.mmb.mmb03,
          sr.mmb.mmb04, sr.mmb.mmb05,  sr.mmb.mmb06, sr.mmb.mmb07, sr.mmb.mmb08, 
          sr.mmb.mmb09, sr.mmb.mmb10,  sr.mmb.mmb11, sr.mmb.mmb16, sr.mmb.mmb17, 
          sr.mmb.mmb18, sr.mmb.mmb19,  sr.JaGongFei, sr.RenGongChengBen,'1',
          l_mmn03,l_mmn04,l_mmn05
       END FOREACH
  
       IF l_chr = 'N' THEN  #沒有其他費用則塞一筆金額為0的資料
          EXECUTE insert_prep USING 
          sr.mma.mma02, sr.mma.mma021, sr.mma.mma01, sr.mmb.mmb02, sr.mmb.mmb03,
          sr.mmb.mmb04, sr.mmb.mmb05,  sr.mmb.mmb06, sr.mmb.mmb07, sr.mmb.mmb08, 
          sr.mmb.mmb09, sr.mmb.mmb10,  sr.mmb.mmb11, sr.mmb.mmb16, sr.mmb.mmb17, 
          sr.mmb.mmb18, sr.mmb.mmb19,  sr.JaGongFei, sr.RenGongChengBen,'1',
          '1','Empty','0'
       END IF   
 
     END FOREACH
 
   #str FUN-750028 add 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-750028 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'mma02,mma01,mma021')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET g_str = g_str,";",g_azi03,";",g_azi04,";",g_azi05
   CALL cl_prt_cs3('ammr105','ammr105',l_sql,g_str)   
   #------------------------------ CR (4) ------------------------------#
 
   #No.FUN-B80067--mark--Begin---
   #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
   #No.FUN-B80067--mark--End-----
END FUNCTION
 
