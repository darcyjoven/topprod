# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: ammr221.4gl
# Desc/riptions..: 零件需求總表列印
# Date & Author..: 01/02/13 By Chien
# Modify.........: No.FUN-4C0099 05/01/17 By kim 報表轉XML功能
# Modify.........: No.FUN-680100 06/08/28 By huchenghao 類型轉換
 
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.FUN-750028 07/07/09 By TSD.liquor 報表改成Crystal Report方式
# Modify.........: No.FUN-8B0002 09/02/05 By lilingyu mark cl_outnam()
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80065 11/08/05 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				      # Print condition RECORD
       	    	wc     	LIKE type_file.chr1000,       #No.FUN-680100 VARCHAR(600)# Where condition
                more	LIKE type_file.chr1           #No.FUN-680100 VARCHAR(1)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680100 SMALLINT
DEFINE   l_table        STRING, #FUN-750029###
         g_str          STRING, #FUN-750029### 
         g_sql          STRING  #FUN-750029### 
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
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "mma01.mma_file.mma01,",
               "mma03.mma_file.mma03,",
               "mma05.mma_file.mma05,",
               "mma051.mma_file.mma051,",
               "mma07.mma_file.mma07,",
               "mma08.mma_file.mma08,",
               "mma09.mma_file.mma09,",
               "mma14.mma_file.mma14,",
               "mma15.mma_file.mma15,",
               "mma16.mma_file.mma16,",
               "gem02.gem_file.gem02,",
               "mmi02.mmi_file.mmi02,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021"
 
   LET l_table = cl_prt_temptable('ammr221',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
   #end FUN-750028 add
 
 
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
      THEN CALL r221_tm(0,0)		# Input print condition
      ELSE CALL ammr221()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
END MAIN
 
FUNCTION r221_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,          #No.FUN-680100 SMALLINT
          l_cmd		LIKE type_file.chr1000        #No.FUN-680100 VARCHAR(400)
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 9 LET p_col = 15 
   ELSE LET p_row = 5 LET p_col = 15
   END IF
 
   OPEN WINDOW r221_w AT p_row,p_col
        WITH FORM "amm/42f/ammr221" 
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
   CONSTRUCT BY NAME tm.wc ON mma01,mma15,mma05,mma08 
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
      LET INT_FLAG = 0 CLOSE WINDOW r221_w
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
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
            NEXT FIELD more
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
      LET INT_FLAG = 0 CLOSE WINDOW r221_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='ammr221'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('ammr221','9031',1)
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
         CALL cl_cmdat('ammr221',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r221_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL ammr221()
   ERROR ""
END WHILE
   CLOSE WINDOW r221_w
END FUNCTION
 
FUNCTION ammr221()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name        #No.FUN-680100 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0076
          l_sql 	STRING,		# RDSQL STATEMENT        #No.FUN-680100
          l_chr		LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
          l_za05	LIKE type_file.chr1000,       #No.FUN-680100 VARCHAR(40)
          sr   RECORD 
               mma      RECORD LIKE mma_file.*,
               gem02           LIKE gem_file.gem02,    #部門
               mmi02           LIKE mmi_file.mmi02     #需求類別
               END RECORD
    DEFINE l_ima02      LIKE ima_file.ima02,   #FUN-750028 TSD.liquor add
           l_ima021     LIKE ima_file.ima021   #FUN-750028 TSD.liquor add
 
     #str FUN-750028 add
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
     #------------------------------ CR (2) ------------------------------#
       
       #No.FUN-B80065--mark--Begin--- 
       #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
       #No.FUN-B80065--mark--End-----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #FUN-750028 add
     LET l_sql = "SELECT mma_file.*,gem02,mmi02 ",
                 "  FROM mma_file LEFT OUTER JOIN gem_file ON (mma15 = gem01) LEFT OUTER JOIN mmi_file ON (mma14 = mmi01) AND mmi_file.mmi03 = '2' ",
                 
                 
                 "   WHERE mmaacti<> 'X' ",
                 "   AND ",tm.wc CLIPPED
     
     PREPARE r221_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
        EXIT PROGRAM 
     END IF
     DECLARE r221_cs1 CURSOR FOR r221_prepare1
#     CALL cl_outnam('ammr221') RETURNING l_name #FUN-8B0002
     LET g_pageno = 0
     FOREACH r221_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
       END IF
       #FUN-750028 TSD.liquor add start
       SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file 
          WHERE ima01=sr.mma.mma05
       IF SQLCA.sqlcode THEN 
          LET l_ima02 = NULL 
          LET l_ima021 = NULL 
       END IF
       #FUN-750028 add end
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-750028 *** ##
         EXECUTE insert_prep USING 
         sr.mma.mma01, sr.mma.mma03, sr.mma.mma05, sr.mma.mma051, sr.mma.mma07,
         sr.mma.mma08, sr.mma.mma09,  sr.mma.mma14, sr.mma.mma15, sr.mma.mma16,
         sr.gem02,sr.mmi02, l_ima02, l_ima021 
       #------------------------------ CR (3) ------------------------------#
     END FOREACH
 
   #str FUN-750028 add 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-750028 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'mma01,mma15,mma05,mma08')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET g_str = g_str
   CALL cl_prt_cs3('ammr221','ammr221',l_sql,g_str)   
   #------------------------------ CR (4) ------------------------------#
 
   #No.FUN-B80067--mark--Begin---
   #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
   #No.FUN-B80067--mark--End-----
END FUNCTION
