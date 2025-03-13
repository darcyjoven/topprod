# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmr115.4gl
# Descriptions...: 應付票據日計表列表作業
# Input parameter:
# Return code....:
# Modify.........: 95/09/27 By Roger
# Modify.........: No.FUN-4C0098 05/01/05 By pengu 報表轉XML
# Modify.........: NO.FUN-550057 05/05/23 By jackie 單據編號加大
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-660060 06/06/26 By Rainy 期間置於中間
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-720013 07/03/01 By TSD.Ken 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/31 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.TQC-830031 08/04/03 By Carol lc_cmd 型態改為type_file.chr1000
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD	
		  wc  	   LIKE type_file.chr1000,  #No.FUN-680107 VARCHAR(600)
   		s        LIKE type_file.chr2,     #No.FUN-680107 VARCHAR(2)
   		bdate    LIKE type_file.dat,      #No.FUN-680107 DATE
   		edate    LIKE type_file.dat,      #No.FUN-680107 DATE
		  more     LIKE type_file.chr1      #No.FUN-680107 VARCHAR(1)
              END RECORD,
          l_dash	LIKE type_file.chr1000#No.FUN-680107 VARCHAR(132)
 
DEFINE   g_i          LIKE type_file.num5   #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE   g_head1      STRING
DEFINE l_table        STRING,                   ### CR11 ###
       g_str          STRING,                   ### CR11 ###
       g_sql          STRING                    ### CR11 ###
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
   #FUN-720013 - START
   ## *** CR11 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>
   LET g_sql = " order1.nmd_file.nmd03, ",
               " sr00.nmd_file.nmd04, ",	    # 前日結餘
               " sr01.nmd_file.nmd04, ",	    # 本日開票
               " sr02.nmd_file.nmd04, ",	    # 本日兌現
               " sr03.nmd_file.nmd04, ",	    # 本日作廢
               " sr04.nmd_file.nmd04, ",	    # 本日撤票
               " sr05.nmd_file.nmd04, ",     # 本日退票
               " azi03.azi_file.azi03,",
               " azi04.azi_file.azi04,",
              " azi05.azi_file.azi05"
 
   LET l_table = cl_prt_temptable('anmr115',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?,  ",
               "        ?, ?, ?, ?, ?, ? ) "
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #----------------------------------------------------------CR (1) ------------#
   #FUN-720013 - END
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.bdate = ARG_VAL(9)   #TQC-610058
   LET tm.edate = ARG_VAL(10)   #TQC-610058
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r115_tm(0,0)		# Input print condition
      ELSE CALL r115()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION r115_tm(p_row,p_col)
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col   LIKE type_file.num5,    #No.FUN-680107 SMALLINT
       l_cmd         LIKE type_file.chr1000, #TQC-830031-modify #No.FUN-680107 VARCHAR(500) #No.FUN-570127
       l_jmp_flag    LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
   LET p_row = 5 LET p_col = 14
   OPEN WINDOW r115_w AT p_row,p_col
        WITH FORM "anm/42f/anmr115"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.s    = '1'
   LET tm.bdate= g_today-1
   LET tm.edate= g_today-1
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET l_jmp_flag = 'N'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nmd08,nmd06,nmd20,nmd03,nmd01,nmd31 #No.5058
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
      LET INT_FLAG = 0 CLOSE WINDOW r115_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
#  IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.bdate,tm.edate,tm.s,tm.more
                 WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD bdate
         IF NOT cl_null(tm.edate) THEN
         IF tm.edate < tm.bdate THEN
            NEXT FIELD bdate
         END IF
         END IF
      AFTER FIELD edate
         IF tm.edate < tm.bdate THEN
            NEXT FIELD bdate
         END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
#     ON ACTION CONTROLP CALL r115_wc()   # Input detail Where Condition
   AFTER INPUT
      LET l_jmp_flag = 'N'
      IF INT_FLAG THEN EXIT INPUT END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW r115_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='anmr115'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr115','9031',1)
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
                         " '",tm.bdate CLIPPED,"'",   #TQC-610058
                         " '",tm.edate CLIPPED,"'",   #TQC-610058
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('anmr115',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r115_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r115()
   ERROR ""
END WHILE
   CLOSE WINDOW r115_w
END FUNCTION
 
FUNCTION r115()
   DEFINE l_name	LIKE type_file.chr20, 		    # External(Disk) file name  #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0082
          l_sql 	LIKE type_file.chr1000,		    # RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200)
          l_chr		LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          l_za05	LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(40)
          nmd       RECORD LIKE nmd_file.*,
          sr               RECORD order1 LIKE nmd_file.nmd03,   #No.FUN-680107 VARCHAR(10)
                                  sr00 LIKE nmd_file.nmd04,	    # 前日結餘
                                  sr01 LIKE nmd_file.nmd04,	    # 本日開票
                                  sr02 LIKE nmd_file.nmd04,	    # 本日兌現
                                  sr03 LIKE nmd_file.nmd04,	    # 本日作廢
                                  sr04 LIKE nmd_file.nmd04,	    # 本日撤票
                                  sr05 LIKE nmd_file.nmd04,     # 本日退票
                                  sr21 LIKE nmd_file.nmd21,
                                  azi03 LIKE azi_file.azi03,
                                  azi04 LIKE azi_file.azi04,
                                  azi05 LIKE azi_file.azi05
                        END RECORD
 
     #FUN-720013 - START
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
     #FUN-720013 - END
  
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #FUN-720013 add
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND nmduser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND nmdgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND nmdgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmduser', 'nmdgrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT *",
                 "  FROM nmd_file",
                 " WHERE nmd30 <> 'X' AND ",tm.wc CLIPPED,
                 "   AND nmd07 <= '",tm.edate,"'"
     PREPARE r115_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM 
     END IF
     DECLARE r115_curs1 CURSOR FOR r115_prepare1
 
     LET g_pageno = 0
     FOREACH r115_curs1 INTO nmd.*
       LET sr.sr21=nmd.nmd21
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET sr.sr00=0
       LET sr.sr01=0 LET sr.sr02=0 LET sr.sr03=0 LET sr.sr04=0 LET sr.sr05=0
       IF nmd.nmd07<tm.bdate AND nmd.nmd29<tm.bdate THEN CONTINUE FOREACH END IF
       IF nmd.nmd07<tm.bdate AND (nmd.nmd29>=tm.bdate OR nmd.nmd29 IS NULL) THEN
          LET sr.sr00=nmd.nmd04
       END IF
       IF nmd.nmd07>=tm.bdate AND nmd.nmd07<=tm.edate THEN
          LET sr.sr01=nmd.nmd04
       END IF
       IF nmd.nmd29>=tm.bdate AND nmd.nmd29<=tm.edate THEN
	      CASE WHEN nmd.nmd12 = '8' LET sr.sr02=nmd.nmd04
	           WHEN nmd.nmd12 = '9' LET sr.sr03=nmd.nmd04
	           WHEN nmd.nmd12 = '7' LET sr.sr05=nmd.nmd04
	           OTHERWISE            LET sr.sr04=nmd.nmd04
	      END CASE
       END IF
       CASE WHEN tm.s='1' LET sr.order1=nmd.nmd08
            WHEN tm.s='2' LET sr.order1=nmd.nmd06
            WHEN tm.s='3' LET sr.order1=nmd.nmd20
            WHEN tm.s='4' LET sr.order1=nmd.nmd03
#            WHEN tm.s='5' LET sr.order1=nmd.nmd01[1,3]
            WHEN tm.s='5' LET sr.order1=s_get_doc_no(nmd.nmd01)   #No.FUN-550057
            OTHERWISE     LET sr.order1=' '
       END CASE
      SELECT azi03,azi04,azi05
        INTO sr.azi03,sr.azi04,sr.azi05    #NO.CHI-6A0004    
        FROM azi_file
       WHERE azi01=sr.sr21
 
       #FUN-720013 - START
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
       EXECUTE insert_prep USING sr.order1,sr.sr00,sr.sr01,sr.sr02,
                                           sr.sr03,sr.sr04,sr.sr05,
                                           sr.azi03,sr.azi04,sr.azi05
       #------------------------------ CR (3) ------------------------------#
       #FUN-720013 - END
     END FOREACH
 
    #FUN-720013 - START
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
    LET g_str = ''
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'nmd08,nmd06,nmd20,nmd03,nmd01,nmd31')
            RETURNING tm.wc
       LET g_str = tm.wc
    END IF
    LET g_str = g_str,";",tm.bdate,";",tm.edate
    CALL cl_prt_cs3('anmr115','anmr115',l_sql,g_str)   #FUN-71080 modify
    #------------------------------ CR (4) ------------------------------#
    #FUN-720013 - END
 
END FUNCTION
 
{
REPORT r115_rep(sr)
   DEFINE l_last_sw	       LIKE type_file.chr1,              #No.FUN-680107 VARCHAR(1) 
          sr               RECORD order1 LIKE nmd_file.nmd03,#No.FUN-680107 VARCHAR(10)
                                  sr00 LIKE nmd_file.nmd04,	 # 前日結餘
                                  sr01 LIKE nmd_file.nmd04,  # 本日開票
                                  sr02 LIKE nmd_file.nmd04,	 # 本日兌現
                                  sr03 LIKE nmd_file.nmd04,	 # 本日作廢
                                  sr04 LIKE nmd_file.nmd04,	 # 本日撤票
                                  sr05 LIKE nmd_file.nmd04,	 # 本日退票
                                  sr21 LIKE nmd_file.nmd21
                        END RECORD,
          l_chr		      LIKE type_file.chr1                  #No.FUN-680107 VARCHAR(1)
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line   #No.MOD-580242
  ORDER BY sr.order1
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      LET g_head1=g_x[9] CLIPPED,tm.bdate,'-',tm.edate
      #PRINT g_head1                        #FUN-660060 remark
      PRINT COLUMN (g_len-25)/2+1, g_head1  #FUN-660060
      PRINT g_dash[1,g_len]
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   AFTER GROUP OF sr.order1
      SELECT azi03,azi04,azi05
        INTO t_azi03,t_azi04,t_azi05    #NO.CHI-6A0004    
        FROM azi_file
       WHERE azi01=sr.sr21
 
      PRINT COLUMN g_c[31],sr.order1,
            COLUMN g_c[32],cl_numfor(GROUP SUM(sr.sr00),32,t_azi04),  #NO.CHI-6A0004  
            COLUMN g_c[33],cl_numfor(GROUP SUM(sr.sr01),33,t_azi04),  #NO.CHI-6A0004  
            COLUMN g_c[34],cl_numfor(GROUP SUM(sr.sr02),34,t_azi04),  #NO.CHI-6A0004  
            COLUMN g_c[35],cl_numfor(GROUP SUM(sr.sr03),35,t_azi04),  #NO.CHI-6A0004  
            COLUMN g_c[36],cl_numfor(GROUP SUM(sr.sr04),36,t_azi04),  #NO.CHI-6A0004  
            COLUMN g_c[37],cl_numfor(GROUP SUM(sr.sr05),37,t_azi04),  #NO.CHI-6A0004  
            COLUMN g_c[38],
                          cl_numfor(GROUP SUM(sr.sr00+sr.sr01-sr.sr02-sr.sr03-sr.sr04-sr.sr05),38,t_azi04)   #NO.CHI-6A0004  
   ON LAST ROW
      PRINT
      PRINT g_x[10] CLIPPED,
            COLUMN g_c[32],cl_numfor( SUM(sr.sr00),32,t_azi04),    #NO.CHI-6A0004  
            COLUMN g_c[33],cl_numfor( SUM(sr.sr01),33,t_azi04),    #NO.CHI-6A0004  
            COLUMN g_c[34],cl_numfor( SUM(sr.sr02),34,t_azi04),    #NO.CHI-6A0004  
            COLUMN g_c[35],cl_numfor( SUM(sr.sr03),35,t_azi04),    #NO.CHI-6A0004  
            COLUMN g_c[36],cl_numfor( SUM(sr.sr04),36,t_azi04),    #NO.CHI-6A0004  
            COLUMN g_c[37],cl_numfor( SUM(sr.sr05),37,t_azi04),    #NO.CHI-6A0004  
            COLUMN g_c[38],
            cl_numfor(SUM(sr.sr00+sr.sr01-sr.sr02-sr.sr03-sr.sr04-sr.sr05),38,t_azi04)  #NO.CHI-6A0004  
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
}
